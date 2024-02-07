# Terraform

This will build all resources needed for a fresh AWS account

## Providers

 [hashicorp/aws](https://registry.terraform.io/providers/hashicorp/aws/latest)

## Prerequisites

- setup github connection in codepipeline
- setup slack connection in chatbot
- link slack chatbot to codepipeline-notifications

## Usage

```terraform
#initialize terraform modules/providers
terraform init

#shows planned changes to environment/application
terraform plan

#builds environment/application from plan
terraform apply
```
