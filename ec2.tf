resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("/home/ec2-user/.ssh/authorized_keys")
}

resource "aws_instance" "web" {
  ami           = "ami-0953476d60561c955"  # Amazon Linux 2 AMI (update as needed)
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id
  key_name      = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<html><h1>Login Page</h1><form><input type='text' placeholder='Username'><br><input type='password' placeholder='Password'></form></html>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "LoginPageServer"
  }
}
