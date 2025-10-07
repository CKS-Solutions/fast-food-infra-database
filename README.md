# db-infra (Terraform • RDS Postgres)

Provisiona um RDS Postgres 15 **privado**, acessível **apenas** por SGs autorizados (ex.: SG do cluster Kubernetes/EKS).

## Pré-requisitos
- Backend remoto configurado (S3 + DynamoDB)
- Já existir uma VPC e subnets privadas

## Variables obrigatórias
- `db_username`
- `db_password`

## Variáveis disponíveis

- `aws_region` (default: `us-east-1`)
- `vpc_name` (default: `myproj-vpc`)
- `subnet_name` (default: `myproj-private-subnet`)
- `db_name` (default: `fast-food`)
- `db_port` (default: `5432`)
- `db_instance_class` (default: `db.t3.medium`)
- `allocated_storage` (default: `20`)
- `max_allocated_storage` (default: `100`)
- `multi_az` (default: `false`)
- `backup_retention_period` (default: `0`)
- `delete_protection` (default: `false`)
- `skip_final_snapshot` (default: `true`)
- `enable_performance_insights` (default: `false`)

## Comandos

Devem ser executados dentro do diretório `infra-db/terraform/`.

```bash
terraform init
terraform plan \
  -var db_username=admin \
  -var db_password='SENHA_FORTE'

terraform apply -auto-approve ...
```