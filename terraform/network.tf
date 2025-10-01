resource "aws_db_subnet_group" "this" {
  name       = "fast-food-rds-private-subnets"
  subnet_ids = data.aws_subnets.fast-food-private-subnet.ids
  tags = {
    Name = "fast-food-rds-private-subnets"
  }
}

resource "aws_security_group" "rds" {
  name        = "fast-food-rds-postgres"
  description = "Acesso ao RDS Postgres (5432) somente de SGs autorizados"
  vpc_id      = data.aws_vpc.fast-food-vpc.id

  egress {
    description = "Saida irrestrita"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "fast-food-rds-postgres"
  }
}

resource "aws_security_group_rule" "inbound_from_sg" {
  for_each                 = toset(var.allowed_security_group_ids)
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds.id
  source_security_group_id = each.value
  description              = "Acesso Postgres 5432 do SG ${each.value}"
}

resource "aws_security_group_rule" "inbound_temp_cidr" {
  count             = length(var.temporary_allowed_cidr) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  security_group_id = aws_security_group.rds.id
  cidr_blocks       = [var.temporary_allowed_cidr]
  description       = "Acesso temporario por CIDR"
}
