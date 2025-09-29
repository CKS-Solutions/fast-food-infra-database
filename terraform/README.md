# db-infra (Terraform • RDS Postgres)

Provisiona um RDS Postgres 15 **privado**, acessível **apenas** por SGs autorizados (ex.: SG do cluster Kubernetes/EKS).

## Pré-requisitos
- Backend remoto configurado (S3 + DynamoDB)
- Já existir uma VPC e subnets privadas (virão do repositório k8s-infra no futuro)

## Variables obrigatórias
- `vpc_id`
- `private_subnet_ids`
- `db_username`
- `db_password`

## Acesso temporário (opcional)
- `temporary_allowed_cidr="SEU.IP.AQUI/32"` para acesso até o cluster existir.
- Depois, remova e use `allowed_security_group_ids=["sg-do-cluster"]`.

## Comandos

```bash
terraform init
terraform plan \
  -var vpc_id=vpc-123 \
  -var 'private_subnet_ids=["subnet-a","subnet-b"]' \
  -var db_username=admin \
  -var db_password='SENHA_FORTE' \
  -var temporary_allowed_cidr='203.0.113.10/32'

terraform apply -auto-approve ...
