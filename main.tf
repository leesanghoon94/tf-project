terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.48.0"
    }
  }
  cloud {
    hostname     = "app.terraform.io"
    organization = "tf-sanghoon"
    workspaces {
      name = "test-prod"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

locals {
  default_vpc_id = "vpc-0bd752928d316c1e4"
  key_pair_name  = "lsh"
  myip           = "122.37.29.17"
}

resource "aws_instance" "tf-ansible" {
  ami                    = "ami-035233c9da2fabf52"
  instance_type          = "t2.micro"
  key_name               = local.key_pair_name
  subnet_id              = "subnet-02683abfcb7729c5e"
  vpc_security_group_ids = [aws_security_group.ansible_test_sg.id]

  tags = {
    Name = "ansible-test"
  }
}

resource "aws_security_group" "ansible_test_sg" {
  name        = "ansible_test_sg"
  description = "ansible_test_sg"
  vpc_id      = local.default_vpc_id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${local.myip}/32"]
  }
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${local.myip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
