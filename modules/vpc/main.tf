# Create VPC
# terraform aws create vpc
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc-cidr
  # instance_tenancy        = "us-east-2"
  enable_dns_hostnames   = true
  
  tags = {
    Name = "Infog-prod VPC"
  }
}
# Create Public Subnet 1
# terraform aws create subnet
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public-subnet-1-cidr
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet 1"
  }
}

# Create Public Subnet 2
# terraform aws create subnet
resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public-subnet-2-cidr
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet 2"
  }
}

# Create Private Subnet 1
# terraform aws create subnet
resource "aws_subnet" "private-subnet-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private-subnet-1-cidr
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet 1 | App Tier"
  }
}

# Create Private Subnet 2
# terraform aws create subnet
resource "aws_subnet" "private-subnet-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private-subnet-2-cidr
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet 2 | App Tier"
  }
}


# create VPC Network access control list
resource "aws_network_acl" "Infoj_prod_VPC_Security_ACL" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = [aws_subnet.public-subnet-1.id]
  # allow ingress port 80 
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.public-subnet-1-cidr
    from_port  = 80
    to_port    = 80
  }
  # allow egress port 80 
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.public-subnet-1-cidr
    from_port  = 80
    to_port    = 80
  }
  tags = {
    Name = "Infoj Prod ACL"
  }
}
resource "aws_network_acl" "Infoj_prod_VPC_Security_ACL_2" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = [aws_subnet.public-subnet-2.id]
  # allow ingress port 80 
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.public-subnet-2-cidr
    from_port  = 80
    to_port    = 80
  }
  # allow egress port 80 
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.public-subnet-2-cidr
    from_port  = 80
    to_port    = 80
  }
  tags = {
    Name = "Infoj Prod ACL2"
  }
}