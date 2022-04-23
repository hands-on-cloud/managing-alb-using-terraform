## Requirements

| Name | Version |
|------|---------|
| aws | ~> 3.0 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_region | AWS Region to deploy VPC | `string` | `"us-east-1"` | no |
| prefix | Common prefix for AWS resources names | `string` | `"managing-alb-using-terraform"` | no |

## Outputs

| Name | Description |
|------|-------------|
| common\_tags | Exported common resources tags |
| prefix | Exported common resources prefix |
| private\_subnets | VPC private subnets' IDs list |
| public\_subnets | VPC public subnets' IDs list |
| vpc\_id | VPC ID |

