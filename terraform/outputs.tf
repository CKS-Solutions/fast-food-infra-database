output "db_endpoint" {
  description = "Endpoint do RDS"
  value       = aws_db_instance.postgres.address
}

output "db_port" {
  description = "Porta do RDS"
  value       = aws_db_instance.postgres.port
}

output "db_name" {
  description = "Database name"
  value       = var.db_name
}

output "rds_security_group_id" {
  description = "SG do RDS (para referência cruzada)"
  value       = aws_security_group.rds.id
}
