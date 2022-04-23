locals {
  domain_name = "*.thaunghtikeoo.info"
  alt_name    = ["thaunghtikeoo.info"]
}

resource "aws_acm_certificate" "cert" {
  domain_name               = local.domain_name
  subject_alternative_names = local.alt_name
  validation_method         = "DNS"

  tags = {
    Environment = "test"
  }

  lifecycle {
    create_before_destroy = true
  }
}