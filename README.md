# db-infra (Terraform • RDS Postgres)

Provisiona um RDS Postgres 15 **privado**, acessível **apenas** por SGs autorizados (ex.: SG do cluster Kubernetes/EKS e lambdas).

## Pré-requisitos
- Backend remoto configurado (S3 + DynamoDB)
- Já existir uma VPC e subnets privadas com as tags corretas
- Security Group do EKS (opcional): se `eks_security_group_name` for fornecido, o Security Group deve existir

## Variables obrigatórias
- `db_username`
- `db_password`

## Variáveis disponíveis

- `aws_region` (default: `us-east-1`)
- `vpc_name` (default: `fast-food-vpc`)
- `subnet_name` (default: `fast-food-private-subnet`)
- `db_name` (default: `appdb`)
- `db_port` (default: `5432`)
- `db_instance_class` (default: `db.t3.micro`)
- `allocated_storage` (default: `20`)
- `max_allocated_storage` (default: `100`)
- `multi_az` (default: `false`)
- `backup_retention_period` (default: `0`)
- `deletion_protection` (default: `false`)
- `skip_final_snapshot` (default: `true`)
- `enable_performance_insights` (default: `false`)
- `lambda_security_group_name` (default: `null`) - Nome do Security Group das lambdas. Se não fornecido, será criado um novo com o nome `fast-food-lambda-sg`
- `eks_security_group_name` (default: `null`) - Nome do Security Group do EKS. Se não fornecido, a regra de acesso do EKS não será criada

## Comandos

Devem ser executados dentro do diretório `terraform/`.

```bash
terraform init
terraform plan \
  -var db_username=admin \
  -var db_password='SENHA_FORTE'

terraform apply -auto-approve ...
```

## Configuração de Lambdas (Serverless Framework)

Para permitir que lambdas se conectem ao RDS, você precisa:

### 1. Obter os outputs do Terraform

Após aplicar o Terraform, obtenha os valores necessários:

```bash
terraform output lambda_security_group_id
terraform output vpc_id
terraform output private_subnet_ids
```

### 2. Configurar o serverless.yml

No repositório das lambdas, adicione a configuração de VPC no `serverless.yml`:

```yaml
provider:
  vpc:
    securityGroupIds:
      - ${env:LAMBDA_SECURITY_GROUP_ID}  # ou valor direto do output
    subnetIds:
      - ${env:PRIVATE_SUBNET_ID_1}  # primeira subnet privada
      - ${env:PRIVATE_SUBNET_ID_2}  # segunda subnet privada (se houver)
```

**Alternativa**: Usar valores diretos:

```yaml
provider:
  vpc:
    securityGroupIds:
      - sg-xxxxxxxxxxxxx  # ID do Security Group das lambdas
    subnetIds:
      - subnet-xxxxxxxxxxxxx  # IDs das subnets privadas
```

### 3. Configurar variáveis de ambiente (recomendado)

Para maior flexibilidade, use variáveis de ambiente ou SSM Parameters:

```yaml
provider:
  environment:
    LAMBDA_SECURITY_GROUP_ID: ${ssm:/fast-food/lambda-security-group-id}
    VPC_ID: ${ssm:/fast-food/vpc-id}
    DB_ENDPOINT: ${ssm:/fast-food/db-endpoint}
    DB_NAME: ${ssm:/fast-food/db-name}
  vpc:
    securityGroupIds:
      - ${self:provider.environment.LAMBDA_SECURITY_GROUP_ID}
    subnetIds:
      - ${self:provider.environment.PRIVATE_SUBNET_ID_1}
      - ${self:provider.environment.PRIVATE_SUBNET_ID_2}
```

### 4. Importante sobre performance de Lambda

Lambdas em VPC têm cold start mais lento. Considere:

- Aumentar o timeout das funções
- Usar provisioned concurrency se necessário
- Configurar conexões de banco com pool de conexões

## Outputs disponíveis

- `db_endpoint`: Endpoint do RDS
- `db_port`: Porta do RDS
- `db_name`: Nome do database
- `lambda_security_group_id`: ID do Security Group das lambdas
- `vpc_id`: ID da VPC
- `private_subnet_ids`: IDs das subnets privadas