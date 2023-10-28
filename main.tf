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
      name = "tf-test"
    }
  }
  /* backend "s3" {
    bucket = "tf-backend-sanghoon"
    key    = "terraform.tfstate"
    region = "ap-northeast-2"
    workspace_key_prefix = "test"
  } */
}
provider "aws" {
  region = "ap-northeast-2"
}
/* module "default_custom_vpc" {
  source = "./custom_vpc"
  env    = "dev"
}
module "prd_custom_vpc" {
  source = "./custom_vpc"
  env    = "prd"
} */
/* variable "envs" {
  type    = list(string)
  default = ["dev", "prd", ""]
} */
module "main_vpc" {
  /* for_each = toset([for env in var.envs : env if env != ""]) */
  source = "./custom_vpc"
  env    = terraform.workspace
  /* env      = each.key */
}
/* variable "names" {
  type    = list(string)
  default = ["sanghoon", "lee"]
}
module "personal_custom_vpc" {
  for_each = toset([for name in var.env : "${name}_human"])
  source   = "./custom_vpc"
  env      = "personal_${each.key}"
} */
resource "aws_s3_bucket" "tf_backend" {
  count  = terraform.workspace == "default" ? 1 : 0
  bucket = "tf-backend-sanghoon"
  tags = {
    Name = "tf_backend"
  }
}
resource "aws_s3_bucket_acl" "tf_backend_acl" {
  count      = terraform.workspace == "default" ? 1 : 0
  bucket     = aws_s3_bucket.tf_backend[0].id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  count  = terraform.workspace == "default" ? 1 : 0
  bucket = aws_s3_bucket.tf_backend[0].id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_versioning" "tf_backend_versioning" {
  count  = terraform.workspace == "default" ? 1 : 0
  bucket = aws_s3_bucket.tf_backend[0].id
  versioning_configuration {
    status = "Enabled"
  }
}
/* 43.202.127.94 */
/* 3.39.38.78 */
/* 43.200.40.236 */
/* resource "aws_eip" "tf_eip" {
  provisioner "local-exec" {
    command = "echo ${self.public_ip}"
  }
  tags = {
    Name = "tf_eip"
  }
} */