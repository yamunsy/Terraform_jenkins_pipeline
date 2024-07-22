# Terraform Block
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.50.0"
    }
  }
}

# Provider-1 for ap-south-1 (Default Provider)
provider "aws" {
  region = "ap-south-1"
  alias = "south-1"
  profile = "default"
}

# Provider-2 for eu-north-1
provider "aws" {
  region = "eu-north-1"
  alias = "north-1"
  profile = "default"
}

# Provider-3 for us-east-1
provider "aws" {
  region = "us-east-1"
  alias = "east-1"
  profile = "default"
}

# Create EC2 instances in ap-south-1
resource "aws_instance" "Mumbai" {
  provider = aws.south-1

  ami           = "ami-0ec0e125bb6c6e8ec"  # Example AMI, replace with a valid one
  instance_type = "t2.micro"

  tags = {
    Name = "Mumbai"
  }
}

# Create EC2 instances in eu-north-1
resource "aws_instance" "stockholm" {
  provider = aws.north-1

  ami           = "ami-0249211c9916306f8"  # Example AMI, replace with a valid one
  instance_type = "t3.micro"

  tags = {
    Name = "stockholm"
  }
}

# Create EC2 instances in us-east-1
resource "aws_instance" "Nvirginia" {
  provider = aws.east-1

  ami           = "ami-0b72821e2f351e396"  # Example AMI, replace with a valid one
  instance_type = "t2.micro"

  tags = {
    Name = "Nvirginia"
  }  
}

resource "aws_s3_bucket" "thunithovaikarabucket" {
  bucket = "thunithovaikarabucket"
  acl    = "private"

  tags = {
    Name        = "thunithovaikarabucket"
  }
}
