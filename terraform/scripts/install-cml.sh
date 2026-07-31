#!/bin/bash

set -e

#################################################
# Setup Environment
#################################################

echo "Updating Ubuntu package information..."

apt-get update

echo "Installing prerequisite packages..."

apt-get install -y \
    curl \
    unzip \
    python3-yaml

echo "Installing the AWS CLI..."

export AWS_DEFAULT_REGION=us-east-1

curl \
    "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
    -o "/tmp/awscliv2.zip"

cd /tmp
unzip -q awscliv2.zip
./aws/install

rm -f /tmp/awscliv2.zip
rm -rf /tmp/aws/

echo "Verifying AWS CLI installation..."

aws --version

echo "Creating /provision staging directory..."

mkdir -p /provision

#################################################
# Download CML Installation Package
#################################################

echo "Downloading CML installation package from S3..."

aws s3 cp \
    s3://network-lab-artifacts-058264426456/cml/software/2.9.0/cml2_2.9.0-3.pkg \
    /provision/cml2_2.9.0-3.pkg

#################################################
# Install Cisco Modeling Labs
#################################################

echo "Extracting Cisco Modeling Labs packages."

tar xvf /provision/cml2_2.9.0-3.pkg \
    --wildcards \
    -C /tmp \
    'cml2*_amd64.deb' \
    'patty*_amd64.deb' \
    'iol-tools*_amd64.deb' \
    'cml-docker-shim*_amd64.deb'

echo "Enabling 32-bit package support."

dpkg --add-architecture i386

echo "Adding the Docker package repository."

apt-get install -y ca-certificates curl

install -m 0755 -d /etc/apt/keyrings

curl -fsSL \
    https://download.docker.com/linux/ubuntu/gpg \
    -o /etc/apt/keyrings/docker.asc

chmod a+r /etc/apt/keyrings/docker.asc

echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
    > /etc/apt/sources.list.d/docker.list

echo "Refreshing package information with the Docker repository."

apt-get update

echo "Installing Cisco Modeling Labs packages."

DEBIAN_FRONTEND=noninteractive \
apt-get install -y \
    network-manager \
    /tmp/*.deb

echo "Cisco Modeling Labs packages have been installed."

#################################################
# Create CML Initial Configuration
#################################################

echo "Generating CML administrator credentials..."

CML_ADMIN_PASSWORD=$(openssl rand -hex 16)
CML_SYSTEM_PASSWORD=$(openssl rand -hex 16)
CML_CLUSTER_SECRET=$(openssl rand -hex 16)

cat > /root/cml-credentials.txt <<EOF
CML Web Administrator
Username: admin
Password: ${CML_ADMIN_PASSWORD}

CML System Administrator
Username: sysadmin
Password: ${CML_SYSTEM_PASSWORD}
EOF

chmod 600 /root/cml-credentials.txt

echo "Creating CML initial configuration..."

cat > /etc/virl2-base-config.yml <<EOF
admins:
  controller:
    password: "${CML_ADMIN_PASSWORD}"
    username: admin
  system:
    password: "${CML_SYSTEM_PASSWORD}"
    username: sysadmin

cluster_interface: ""
compute_secret: "${CML_CLUSTER_SECRET}"
controller_name: cml-controller
copy_iso_to_disk: false
hostname: cml-controller
interactive: false
is_cluster: false
is_compute: true
is_configured: false
is_controller: true
primary_interface: ""
ssh_server: true
use_ipv4_dhcp: true
skip_primary_bridge: true
EOF

chmod 600 /etc/virl2-base-config.yml

echo "CML initial configuration completed."

#################################################
# Configure CML Networking
#################################################

echo "Updating Ubuntu and CML network configuration..."

python3 /provision/interface_fix.py

systemctl restart NetworkManager
netplan apply

echo "Waiting for NetworkManager..."

attempts=12

while [ $attempts -gt 0 ]; do
    if systemctl is-active --quiet NetworkManager; then
        echo "NetworkManager is active."
        break
    fi

    sleep 5
    attempts=$((attempts - 1))
done

if [ $attempts -eq 0 ]; then
    echo "NetworkManager did not become active."
    exit 1
fi

#################################################
# Run CML Initial Setup
#################################################

echo "Preparing CML initial setup..."

# The AWS instance has no interactive TTY, so disable the
# terminal-related systemd settings used by an interactive install.
sed -i \
    '/^Standard/ s/^/#/' \
    /lib/systemd/system/virl2-initial-setup.service

# This marker tells CML that initial configuration is still required.
touch /etc/.virl2_unconfigured

# Stop the local console service because this is a headless cloud server.
systemctl stop getty@tty1.service || true

echo "Starting CML initial setup..."

systemctl enable --now virl2-initial-setup.service

#################################################
# Wait for CML Initial Setup
#################################################

echo "Waiting for CML initial setup to complete..."

attempts=24

while [ $attempts -gt 0 ]; do
    if [ ! -f /etc/.virl2_unconfigured ]; then
        echo "CML initial setup completed."
        break
    fi

    echo "CML initial setup is still running..."
    sleep 5
    attempts=$((attempts - 1))
done

if [ $attempts -eq 0 ]; then
    echo "CML initial setup did not complete in time."
    systemctl status virl2-initial-setup.service --no-pager || true
    exit 1
fi

#################################################
# Finish Installation
#################################################

echo "Enabling SSH..."

systemctl enable --now ssh.service

echo "Removing temporary installation files..."

rm -f /provision/*.pkg
rm -f /provision/*.deb
rm -f /tmp/*.deb

echo "Cisco Modeling Labs initial setup is complete."