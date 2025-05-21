variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "public_key" {
  description = "SSH public key for EC2"
  type        = string
default = "server"
}
