provider "aws" {
  region = "us-east-1"  # Change this to your preferred AWS region
}

resource "aws_instance" "example" {
  ami           = "ami-00a929b66ed6e0de6"  # Replace with a valid AMI ID
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform-Instance"
  }
}

output "instance_ip" {
  value = aws_instance.example.public_ip
}
