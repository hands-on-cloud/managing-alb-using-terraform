terraform {
  backend "s3" {
    bucket  = "hands-on-cloud-terraform-remote-state-s3"
    key     = "managing-alb-using-terraform-alb-ip-target-group.tfstate"
    region  = "us-west-2"
    encrypt = "true"
    dynamodb_table = "hands-on-cloud-terraform-remote-state-dynamodb"
  }
}
