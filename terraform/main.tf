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

resource "aws_instance" "linux" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.small"
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.djt.key_name

  vpc_security_group_ids = [
    aws_security_group.linux.id
  ]

  tags = {
    Name        = "network-lab-linux"
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

resource "aws_vpc_security_group_ingress_rule" "linux_ssh" {
  security_group_id = aws_security_group.linux.id
  description       = "Allow SSH from DJT public IP"

  cidr_ipv4   = "96.236.133.102/32"
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
