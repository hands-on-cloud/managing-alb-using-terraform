<!-- BEGIN_TF_DOCS -->

# AWS Application Load Balancer (ALB) - IP-based Target Group

This is a demo repository for the [Managing AWS Application Load Balancer (ALB) Using Terraform](https://hands-on.cloud/managing-aws-application-load-balancer-alb-using-terraform/) article.

This module sets up the following AWS services:

* ALB Listener
* ALB Target Group
* ALB Security Group rule
* EC2 Security Group
* EC2 instances with Nginx

![Shared public AWS Application Load Balancer (ALB)](https://hands-on.cloud/wp-content/uploads/2022/04/Managing-AWS-Application-Load-Balancer-ALB-Using-Terraform-IP-Target-Group-2048x1670.png)

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
| <a name="module_instance_sg"></a> [instance\_sg](#module\_instance\_sg) | terraform-aws-modules/security-group/aws | n/a |
| <a name="module_web_http_sg"></a> [web\_http\_sg](#module\_web\_http\_sg) | terraform-aws-modules/security-group/aws | n/a |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | n/a |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.9.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.9 |
## Resources

| Name | Type |
|------|------|
| [aws_instance.nginx](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_lb_listener.web_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [terraform_remote_state.alb](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infrastructure](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

<!-- END_TF_DOCS -->