variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Nome da VPC"
  type        = string
  default     = "fast-food-vpc"
}

variable "subnet_name" {
  description = "Nome da subnet privada"
  type        = string
  default     = "fast-food-private-subnet"
}

variable "db_name" {
  description = "Nome do database inicial"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Usuário administrador do banco"
  type        = string
}

variable "db_password" {
  description = "Senha do usuário administrador"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "Classe da instância RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Tamanho inicial do storage (GB)"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Autoscaling de storage (GB)"
  type        = number
  default     = 100
}

variable "multi_az" {
  description = "Ativar Multi-AZ (produção)"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Dias de retenção de backup"
  type        = number
  default     = 0
}

variable "deletion_protection" {
  description = "Proteção contra deleção (recomendado true em produção)"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Pular snapshot final ao destruir (false em prod)"
  type        = bool
  default     = true
}

variable "enable_performance_insights" {
  description = "Habilitar Performance Insights"
  type        = bool
  default     = false
}

variable "db_port" {
  description = "Porta de acesso ao banco"
  type        = number
  default     = 5432
}