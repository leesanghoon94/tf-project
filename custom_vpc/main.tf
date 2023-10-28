resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "default_tf_vpc_${var.env}"
  }
}

resource "aws_subnet" "public_subnet" {
  count = var.env == "tf-test-prod" ? 0 : 1
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.0.0/24"

  availability_zone = local.availability_zone

  tags = {
    Name = "default_tf_public_subnet_${var.env}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.10.0/24"

  availability_zone = local.availability_zone

  tags = {
    Name = "default_tf_private_subnet_${var.env}"
  }
}
