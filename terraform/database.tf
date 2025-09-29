resource "aws_db_parameter_group" "pg15" {
  name        = "pg15-params"
  family      = "postgres15"
}

resource "aws_db_instance" "postgres" {
  identifier                 = "app-postgres"
  engine                     = "postgres"
  engine_version             = "15.3"
  instance_class             = var.db_instance_class

  db_name                    = var.db_name
  username                   = var.db_username
  password                   = var.db_password

  allocated_storage          = var.allocated_storage
  max_allocated_storage      = var.max_allocated_storage
  storage_encrypted          = true

  multi_az                   = var.multi_az
  publicly_accessible        = false
  port                       = 5432

  db_subnet_group_name       = aws_db_subnet_group.this.name
  vpc_security_group_ids     = [aws_security_group.rds.id]
  parameter_group_name       = aws_db_parameter_group.pg15.name

  backup_retention_period    = var.backup_retention_period
  deletion_protection        = var.deletion_protection
  skip_final_snapshot        = var.skip_final_snapshot

  auto_minor_version_upgrade = true
  performance_insights_enabled = var.enable_performance_insights

  tags = {
    Name = "app-postgres"
  }
}
