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

# Provider-2 for ap-southeast-1
provider "aws" {
  region = "ap-southeast-1"
  alias = "southeast-1"
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

  ami           = "ami-01376101673c89611"  # Example AMI, replace with a valid one
  instance_type = "t2.micro"

  tags = {
    Name = "Mumbai"
  }
}

# Create EC2 instances in ap-southeast-1
resource "aws_instance" "Singapore" {
  provider = aws.southeast-1

  ami           = "ami-060e277c0d4cce553"  # Example AMI, replace with a valid one
  instance_type = "t2.micro"

  tags = {
    Name = "singapore"
  }
}

# Create EC2 instances in us-east-1
resource "aws_instance" "Nvirginia" {
  provider = aws.east-1

  ami           = "ami-04a81a99f5ec58529"  # Example AMI, replace with a valid one
  instance_type = "t2.micro"

  tags = {
    Name = "Nvirginia"
  }  
}
