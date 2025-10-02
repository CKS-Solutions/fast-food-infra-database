data "aws_subnets" "fast-food-private-subnet" {
  filter {
    name   = "tag:Name"
    values = [var.subnet_name]
  }
}

data "aws_vpc" "fast-food-vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}