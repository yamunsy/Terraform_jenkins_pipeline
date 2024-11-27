resource "aws_instance" "rokesh" {
  ami           = "ami-0dee22c13ea7a9a67" # Amazon Linux 2 AMI ID for us-west-2, change it to your region's AMI ID
  instance_type = "t2.micro"

  tags = {
    Name = "rokesh"
  }
}
