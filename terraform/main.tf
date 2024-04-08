# Create a security group to allow web traffic
resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow web inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Be cautious with allowing SSH access publicly
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web_sg"
  }
}

# Launch an EC2 instance
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0" # Ensure this AMI is valid in your chosen region
  instance_type = "t2.micro" # This is suitable for small applications

  # Associate the security group with this instance
  vpc_security_group_ids = [aws_security_group.allow_web.id]

  # Optionally, define a key pair for SSH access
  key_name               = "my-key-name" # Replace this with your key name if needed

  tags = {
    Name = "HelloWorldPythonApp"
  }
}

# Output the public IP of the instance
output "public_ip" {
  value = aws_instance.web.public_ip
}
