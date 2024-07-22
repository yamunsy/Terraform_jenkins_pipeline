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

  ami           = "ami-0ec0e125bb6c6e8ec"  # Example AMI, replace with a valid one
  instance_type = "t2.micro"

  tags = {
    Name = "Mumbai"
  }
}

# Create EC2 instances in ap-southeast-1
resource "aws_instance" "Singapore" {
  provider = aws.southeast-1

  ami           = "ami-0e97ea97a2f374e3d"  # Example AMI, replace with a valid one
  instance_type = "t2.micro"

  tags = {
    Name = "singapore"
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
