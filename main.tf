provider "aws" {
  region = "us-east-1" # Change as needed
}

# ---------------- S3 Bucket ----------------
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-terraform-bucket-12345"
  acl    = "private"
}

# ---------------- VPC ----------------
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rt.id
}

# ---------------- EC2 Instance ----------------
resource "aws_instance" "my_instance" {
  ami           = "ami-00a929b66ed6e0de6" # Change to your region's AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  associate_public_ip_address = true

  tags = {
    Name = "Terraform-EC2"
  }
}

# ---------------- Load Balancer ----------------
resource "aws_lb" "my_lb" {
  name               = "my-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = []
  subnets           = [aws_subnet.public_subnet.id]
}

resource "aws_lb_target_group" "tg" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

output "instance_public_ip" {
  value = aws_instance.my_instance.public_ip
}
