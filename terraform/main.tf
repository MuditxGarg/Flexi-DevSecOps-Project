provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "jenkins_instance" {
  ami           = "ami-0dee22c13ea7a9a67"
  instance_type = "t2.micro"

  tags = {
    Name = "Jenkins-Docker-SonarQube"
  }

  key_name = "admin-flexi-key"
  
  # Allow access to SSH
  security_groups = [aws_security_group.jenkins_sg.name]

  # Modify connection to use the private key passed from Jenkins
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = var.private_key_content  # Use variable for the private key content
    host        = self.public_ip
  }

  # Removed provisioner block as no additional software is being installed
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Allow SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define the variable for the private key content
variable "private_key_content" {
  description = "The private key content for SSH access"
  type        = string
}
