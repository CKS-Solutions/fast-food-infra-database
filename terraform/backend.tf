terraform {
  backend "s3" {
    bucket         = "meu-tf-state"
    key            = "db-infra/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}