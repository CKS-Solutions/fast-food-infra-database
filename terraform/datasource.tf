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

data "aws_security_group" "eks_nodes" {
  filter {
    name   = "tag:Name"
    values = ["fast-food-eks-nodes"]
  }
}

data "aws_security_group" "rds" {
  filter {
    name   = "tag:Name"
    values = ["fast-food-rds-postgres"]
  }
}

data "aws_security_group" "lambda" {
  count = var.lambda_security_group_name != null ? 1 : 0
  filter {
    name   = "tag:Name"
    values = [var.lambda_security_group_name]
  }
}