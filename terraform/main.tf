data "aws_caller_identity" "current" {

}
data "aws_region" "current" {

}

resource "aws_vpc" "lab" {
  cidr_block           = "10.224.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "network-lab"
    Project     = "network-automation-lab"
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.lab.id
  cidr_block        = "10.224.1.0/24"
  availability_zone = "us-east-1d"

  tags = {
    Name        = "network-lab-public-subnet"
    Project     = "network-automation-lab"
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.lab.id

  tags = {
    Name        = "network-lab-public-igw"
    Project     = "network-automation-lab"
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.lab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public.id
  }
  tags = {
    Name        = "network-lab-public-rt"
    Project     = "network-automation-lab"
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# resource "aws_instance" "linux" {
#   ami                         = data.aws_ami.amazon_linux.id
#   instance_type               = "t3.small"
#   subnet_id                   = aws_subnet.public.id
#   associate_public_ip_address = true
#   key_name                    = aws_key_pair.djt.key_name
# 
#   vpc_security_group_ids = [
#     aws_security_group.linux.id
#   ]
# 
#   tags = {
#     Name        = "network-lab-linux"
#     Project     = "network-automation-lab"
#     Environment = "lab"
#     ManagedBy   = "Terraform"
#   }
# }

resource "aws_instance" "cml_controller" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "m8i.2xlarge"
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true

  key_name             = aws_key_pair.djt.key_name
  iam_instance_profile = "cml_controller"
  ebs_optimized        = true

  vpc_security_group_ids = [
    aws_security_group.linux.id
  ]

  cpu_options {
    nested_virtualization = "enabled"
  }

  root_block_device {
    volume_size = 100
    volume_type = "gp3"
    encrypted   = true
  }

  user_data                   = file("${path.module}/scripts/install-cml.sh")
  user_data_replace_on_change = true

  tags = {
    Name        = "network-lab-cml-controller"
    Project     = "network-automation-lab"
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}

resource "aws_security_group" "linux" {
  name        = "network-lab-linux"
  description = "Security group for the network lab Linux instance"
  vpc_id      = aws_vpc.lab.id

  tags = {
    Name        = "network-lab-linux-sg"
    Project     = "network-automation-lab"
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}

resource "aws_vpc_security_group_ingress_rule" "cml_controller_https_home" {
  security_group_id = aws_security_group.linux.id
  description       = "Allow HTTPS from home"

  cidr_ipv4   = "96.236.133.102/32"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "cml_controller_https_camp" {
  security_group_id = aws_security_group.linux.id
  description       = "Allow HTTPS from camp"

  cidr_ipv4   = "172.59.26.145/32"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "linux_ssh_home" {
  security_group_id = aws_security_group.linux.id
  description       = "Allow SSH from home"

  cidr_ipv4   = "96.236.133.102/32"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "linux_ssh_camp" {
  security_group_id = aws_security_group.linux.id
  description       = "Allow SSH from camp"

  cidr_ipv4   = "172.59.26.145/32"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_ipv4" {
  security_group_id = aws_security_group.linux.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  description = "Allow all outbound IPv4 traffic"
}

resource "aws_key_pair" "djt" {
  key_name   = "network-lab-djt"
  public_key = file(pathexpand("~/.ssh/id_ed25519.pub"))

  tags = {
    Name        = "network-lab-djt-key"
    Project     = "network-automation-lab"
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket" "network_lab_artifacts" {
  bucket = "network-lab-artifacts-058264426456"

  tags = {
    Name        = "network-lab-artifacts"
    Project     = "network-automation-lab"
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "network_lab_artifacts" {
  bucket = aws_s3_bucket.network_lab_artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "network_lab_artifacts" {
  bucket = aws_s3_bucket.network_lab_artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "network_lab_artifacts" {
  bucket = aws_s3_bucket.network_lab_artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
