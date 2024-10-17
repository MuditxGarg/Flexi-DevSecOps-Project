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
  
  # Allow access to Jenkins, Docker, SonarQube, and SSH
  security_groups = [aws_security_group.jenkins_sg.name]

  connection {
    type        = "ssh"
    user        = "ubuntu" 
    private_key = file("${path.module}/admin-flexi-key.pem")
    host        = self.public_ip  
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install docker -y",
      "sudo systemctl start docker",
      "sudo usermod -aG docker ec2-user",
      "sudo curl -L https://github.com/docker/compose/releases/download/v2.10.2/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "sudo yum install java-1.8.0-openjdk -y",  # For Jenkins
      "sudo yum install -y git",
      "sudo systemctl start jenkins"
    ]
  }
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Allow SSH, Jenkins, SonarQube, and Docker"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Jenkins Port
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # SonarQube Port
  }

  ingress {
    from_port   = 2375
    to_port     = 2375
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Docker Port
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
