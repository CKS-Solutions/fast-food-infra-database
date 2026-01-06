resource "aws_db_subnet_group" "this" {
  name       = "fast-food-rds-subnets"
  subnet_ids = data.aws_subnets.fast-food-public-subnet.ids
  tags = {
    Name = "fast-food-rds-subnets"
  }
}

resource "aws_security_group" "lambda" {
  count       = var.lambda_security_group_name == null ? 1 : 0
  name        = "fast-food-lambda-sg"
  description = "Security Group para lambdas acessarem RDS"
  vpc_id      = data.aws_vpc.fast-food-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "fast-food-lambda-sg"
  }
}

resource "aws_security_group_rule" "inbound_public" {
  type                     = "ingress"
  from_port                = var.db_port
  to_port                  = var.db_port
  protocol                 = "tcp"
  security_group_id        = data.aws_security_group.rds.id
  cidr_blocks              = ["0.0.0.0/0"]
  description              = "Acesso Postgres ${var.db_port} do SG"
}

resource "aws_security_group_rule" "inbound_lambda" {
  type                     = "ingress"
  from_port                = var.db_port
  to_port                  = var.db_port
  protocol                 = "tcp"
  security_group_id        = data.aws_security_group.rds.id
  source_security_group_id = local.lambda_security_group_id
  description              = "Acesso Postgres ${var.db_port} do Security Group das lambdas"
}
