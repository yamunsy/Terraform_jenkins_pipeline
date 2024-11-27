# Mention the Cloud Provider Name
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS Provider Region
provider "aws" {
  region = "ap-south-1"
}

# VPC Creation
# Resource1
resource "aws_vpc" "renuvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  
  tags = {
    Name = "renuvpc"
  }
}
# Public Subnet Creation
# Resource2
resource "aws_subnet" "publicsub" {
  vpc_id     = aws_vpc.renuvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "publicsub"
  }
}
# Private Subnet Creation
# Resource3
resource "aws_subnet" "privatesub" {
  vpc_id     = aws_vpc.renuvpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "privatesub"
  }
}
# Internet Gateway Creation
# Resource4
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.renuvpc.id

  tags = {
    Name = "IGW"
  }
}

# Public Routing Table Creation
resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.renuvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "publicRT"
  }
}

# Private Routing Table Creation
resource "aws_route_table" "privateRT" {
  vpc_id = aws_vpc.renuvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NATGW.id
  }

  tags = {
    Name = "privateRT"
  }
}

# Public Subnet Association
# Resource7
resource "aws_route_table_association" "publicassociate" {
  subnet_id      = aws_subnet.publicsub.id
  route_table_id = aws_route_table.publicRT.id
}
# Private Subnet Association
# Resource8
resource "aws_route_table_association" "privateassociate" {
  subnet_id      = aws_subnet.privatesub.id
  route_table_id = aws_route_table.privateRT.id
}

# Public Security Group
# Resource9
resource "aws_security_group" "publicSG" {
  name        = "publicSG"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.renuvpc.id

  ingress = [
    {
      description      = "TLS from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self = false
      }
  ]
 egress = [
    {
      description      = "TLS from VPC"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self = false
      
    }
  ]

  tags = {
    Name = "publicSG"
  }
}
# Resource10
# Private Security Group
resource "aws_security_group" "privateSG" {
  name        = "privateSG"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.renuvpc.id

  ingress = [
    {
      description      = "TLS from VPC"
      from_port        = 0
      to_port          = 0
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self = false
      security_groups  = [aws_security_group.publicSG.id]
      }
  ]

 egress = [
    {
      description      = "TLS from VPC"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self = false
      
    }
  ]

  tags = {
    Name = "privateSG"
  }
}
# Resource11
# Elastic IP Creation
resource "aws_eip" "myeip" {
  domain= "vpc"
}

# NATGW Creation
# Resource12
resource "aws_nat_gateway" "NATGW" {
  allocation_id = aws_eip.myeip.id
  subnet_id     = aws_subnet.publicsub.id
  
  tags = {
    Name = "NATGW"
  }
 
 # To ensure proper ordering, it is recommended to add an explicit dependency
 # on the Internet Gateway for the VPC.
 depends_on = [aws_internet_gateway.IGW]
}
#Resource for ec2 creation with public subnet
resource "aws_instance" "publicserver" {
  ami           = "ami-0ad21ae1d0696ad58"
  instance_type = "t2.micro"
  key_name      = "jenkins integration"
  vpc_security_group_ids = [aws_security_group.publicSG.id]
  subnet_id = aws_subnet.publicsub.id
  associate_public_ip_address = true

  tags = {
    Name = "publicserver"
  }
}
#Resource for ec2 creation with private subnet 
resource "aws_instance" "privateserver" {
  ami           = "ami-0ad21ae1d0696ad58"
  instance_type = "t2.micro"
  key_name      = "jenkins integration"
  vpc_security_group_ids = [aws_security_group.privateSG.id]
  subnet_id = aws_subnet.privatesub.id
  associate_public_ip_address = false

  tags = {
    Name = "privateserver"
  }
} 
