terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.48.0"
    }
  }
  cloud {
  
    organization = "tf-sanghoon"
    
    workspaces {
      name = "test-prod" 
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

module "tf_vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = "tf-vpc_${terraform.workspace}"
  cidr = "10.0.0.0/16"

  azs             = ["ap-northeast-2a", "ap-northeast-2c"]
  private_subnets = ["10.0.0.0/24", "10.0.1.0/24"]
  public_subnets  = ["10.0.100.0/24", "10.0.101.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true
  /* enable_vpn_gateway = true */

  manage_default_security_group = true

  tags = {
    Terraform = "true"
    Environment = terraform.workspace
  }
}
resource "aws_instance" "web_instance" {
  count = 2
  ami = "ami-035233c9da2fabf52"
  instance_type = "t2.micro"
  subnet_id = module.tf_vpc.public_subnets[count.index]
  tags = {
    Name = "tf-ec2${count.index}"
  }
}
