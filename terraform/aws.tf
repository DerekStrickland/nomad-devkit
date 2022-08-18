terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-2"
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}


resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-065deacbcaac64cf2"
  instance_type = "c5.xlarge"

  security_groups = ["allow_ssh"]
  key_name        = "var.key_name"
  user_data       = <<EOF
#!/bin/bash -xe
sudo apt update
sudo apt upgrade -y
sudo apt install -y golang docker.io podman make git vim
git clone https://github.com/hashicorp/nomad.git /home/ubuntu/nomad
chown -R ubuntu:ubuntu /home/ubuntu
usermod -a -G docker ubuntu
cat >> /home/ubuntu/.profile <<EOD
export PATH=~/go/bin:$PATH
EOD
EOF
  root_block_device {
    volume_size = 20
  }

  tags = {
    Name = "nomad-test"
  }
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}
