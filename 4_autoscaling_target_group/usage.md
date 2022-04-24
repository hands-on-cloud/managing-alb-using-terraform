# AWS Application Load Balancer (ALB) - Auto Scaled ALB Target Group

This is a demo repository for the [Managing AWS Application Load Balancer (ALB) Using Terraform](https://hands-on.cloud/managing-aws-application-load-balancer-alb-using-terraform/) article.

This module sets up the following AWS services:

* ALB Listener
* ALB Target Group
* ALB Security Group rule
* EC2 Security Group
* Auto Scaling Group for EC2 instances with Nginx 

![AWS Application Load Balancer (ALB) - Auto Scaled ALB Target Group](https://hands-on.cloud/wp-content/uploads/2022/04/Managing-AWS-Application-Load-Balancer-ALB-Using-Terraform-Auto-Scaling-2048x1670.png)

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
