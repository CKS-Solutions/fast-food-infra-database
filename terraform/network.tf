resource "aws_db_subnet_group" "this" {
  name       = "fast-food-rds-private-subnets"
  subnet_ids = data.aws_subnets.fast-food-private-subnet.ids
  tags = {
    Name = "fast-food-rds-private-subnets"
  }
}

resource "aws_security_group" "rds" {
  name        = "fast-food-rds-postgres"
  description = "Security Group para RDS PostgreSQL"
  vpc_id      = data.aws_vpc.fast-food-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "fast-food-rds-postgres"
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

resource "aws_security_group_rule" "inbound_eks_nodes" {
  count                    = var.eks_security_group_name != null ? 1 : 0
  type                     = "ingress"
  from_port                = var.db_port
  to_port                  = var.db_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds.id
  source_security_group_id = data.aws_security_group.eks_nodes[0].id
  description              = "Acesso Postgres ${var.db_port} do SG ${data.aws_security_group.eks_nodes[0].name}"
}

resource "aws_security_group_rule" "inbound_lambda" {
  type                     = "ingress"
  from_port                = var.db_port
  to_port                  = var.db_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds.id
  source_security_group_id = local.lambda_security_group_id
  description              = "Acesso Postgres ${var.db_port} do Security Group das lambdas"
}
