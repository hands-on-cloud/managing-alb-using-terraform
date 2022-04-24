<!-- BEGIN_TF_DOCS -->

# Shared public AWS Application Load Balancer (ALB)

This is a demo repository for the [Managing AWS Application Load Balancer (ALB) Using Terraform](https://hands-on.cloud/managing-aws-application-load-balancer-alb-using-terraform/) article.

This module sets up the following AWS services:

* Shared public AWS Application Load Balancer (ALB)
* Empty ALB Security Group

![Shared public AWS Application Load Balancer (ALB)](https://hands-on.cloud/wp-content/uploads/2022/04/Managing-AWS-Application-Load-Balancer-ALB-Using-Terraform-ALB-2048x1670.png)

## Deployment

```sh
terraform init
terraform plan
terraform apply -auto-approve
```

## Tier down

```sh
terraform destroy -auto-approve
```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region to deploy VPC | `string` | `"us-east-1"` | no |
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb_sg"></a> [alb\_sg](#module\_alb\_sg) | terraform-aws-modules/security-group/aws | n/a |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | n/a |
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | n/a |
| <a name="output_alb_dns_zone_id"></a> [alb\_dns\_zone\_id](#output\_alb\_dns\_zone\_id) | n/a |
| <a name="output_alb_security_group_id"></a> [alb\_security\_group\_id](#output\_alb\_security\_group\_id) | n/a |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.11.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.9 |
## Resources

| Name | Type |
|------|------|
| [aws_lb.web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [terraform_remote_state.infrastructure](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

<!-- END_TF_DOCS -->