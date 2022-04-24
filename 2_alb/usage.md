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
