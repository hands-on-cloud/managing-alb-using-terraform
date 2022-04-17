# Set up Terraform provider version (if required)
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Defining AWS provider
provider "aws" {
  region = var.aws_region
}
