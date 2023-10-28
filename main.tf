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

module "main_vpc" {

  source = "./custom_vpc"
  env    = terraform.workspace

}

resource "aws_s3_bucket" "tf_backend" {
  count = terraform.workspace == "default" ? 1 : 0
  bucket = "tf-backend-sanghoon"
  tags = {
    Name = "tf_backend"
  }
}

resource "aws_s3_bucket_acl" "tf_backend_acl" {
  count = terraform.workspace == "default" ? 1 : 0
  bucket     = aws_s3_bucket.tf_backend[0].id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  count = terraform.workspace == "default" ? 1 : 0
  bucket = aws_s3_bucket.tf_backend[0].id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_versioning" "tf_backend_versioning" {
  count = terraform.workspace == "default" ? 1 : 0
  bucket = aws_s3_bucket.tf_backend[0].id
  versioning_configuration {
    status = "Enabled"
  }
}
