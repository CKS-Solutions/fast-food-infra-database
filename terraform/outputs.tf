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

output "lambda_security_group_id" {
  description = "ID do Security Group das lambdas"
  value       = local.lambda_security_group_id
}

output "vpc_id" {
  description = "ID da VPC"
  value       = data.aws_vpc.fast-food-vpc.id
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas"
  value       = data.aws_subnets.fast-food-public-subnet.ids
}
