locals {
  lambda_security_group_id = var.lambda_security_group_name != null ? data.aws_security_group.lambda[0].id : aws_security_group.lambda[0].id
}

