resource "aws_db_subnet_group" "this" {
  name       = "fast-food-rds-private-subnets"
  subnet_ids = data.aws_subnets.fast-food-private-subnet.ids
  tags = {
    Name = "fast-food-rds-private-subnets"
  }
}

resource "aws_security_group_rule" "inbound_eks_nodes" {
  type                     = "ingress"
  from_port                = var.db_port
  to_port                  = var.db_port
  protocol                 = "tcp"
  security_group_id        = data.aws_security_group.rds.id
  source_security_group_id = data.aws_security_group.eks_nodes.id
  description              = "Acesso Postgres ${var.db_port} do SG ${data.aws_security_group.eks_nodes.name}"
}
