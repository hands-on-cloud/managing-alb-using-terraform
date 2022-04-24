# AWS Application Load Balancer (ALB) - Blue-Green deployment

This is a demo repository for the [Managing AWS Application Load Balancer (ALB) Using Terraform](https://hands-on.cloud/managing-aws-application-load-balancer-alb-using-terraform/) article.

This module sets up the following AWS services:

* ALB Listener with forward rules configuration
* Two ALB Target Groups
* ALB Security Group rule
* EC2 Security Group
* Tow Auto Scaling Group for EC2 instances with Nginx (blue and green environment) 

![AWS Application Load Balancer (ALB) - Blue-Green deployment](https://hands-on.cloud/wp-content/uploads/2022/04/Managing-AWS-Application-Load-Balancer-ALB-Using-Terraform-Blue-Green-deployment-2048x1670.png)

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
