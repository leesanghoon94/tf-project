resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "default_tf_vpc_${var.env}"
  }
}
resource "aws_subnet" "public_subnet" {
  count = var.env == "prod" ? 0 : 1
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

/* resource "aws_nat_gateway" "tf_nat_gw" {
  connectivity_type = "private"
  subnet_id = aws_subnet.private_subnet.id
  tags = {
    Name = "tf_nat_gw_${var.env}"
  }
}


resource "aws_internet_gateway" "tf_igw" {
    vpc_id = aws_vpc.default.id
    tags = {
      Name = "tf_igw_${var.env}"
    }
} */