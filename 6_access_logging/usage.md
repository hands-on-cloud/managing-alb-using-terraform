# AWS Application Load Balancer (ALB) - Sending Access logs to S3 bucket 

This is a demo repository for the [Managing AWS Application Load Balancer (ALB) Using Terraform](https://hands-on.cloud/managing-aws-application-load-balancer-alb-using-terraform/) article.

This module sets up the following AWS services:

* Application Load Balancer
* S3 Bucket for storing ALB Access Logs

![AWS Application Load Balancer (ALB) - Sending Access logs to S3 bucket](https://hands-on.cloud/wp-content/uploads/2022/04/Managing-AWS-Application-Load-Balancer-ALB-Using-Terraform-Sending-Access-Logs-to-S3-2048x1670.png)

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
