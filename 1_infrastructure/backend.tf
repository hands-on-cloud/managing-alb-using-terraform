terraform {
  backend "s3" {
    bucket  = "hands-on-cloud-terraform-remote-state-s3"
    key     = "managing-alb-using-terraform-infrastructure.tfstate"
    region  = "us-west-2"
    encrypt = "true"
    dynamodb_table = "hands-on-cloud-terraform-remote-state-dynamodb"
  }
}
