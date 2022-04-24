locals {
  alb_arn                   = data.terraform_remote_state.alb.outputs.alb_arn
}

module "label" {
  source = "cloudposse/label/null"

  namespace = "eg"
  stage     = "prod"
  name      = "waf"
  delimiter = "-"

  tags = {
    "BusinessUnit" = "XYZ",
  }
}

module "waf" {
  source = "cloudposse/waf/aws"

  geo_match_statement_rules = [
    {
      name     = "rule-11"
      action   = "allow"
      priority = 11

      statement = {
        country_codes = ["US"]
      }

      visibility_config = {
        cloudwatch_metrics_enabled = true
        sampled_requests_enabled   = false
        metric_name                = "rule-11-metric"
      }
    }
  ]

  managed_rule_group_statement_rules = [
    {
      name            = "rule-20"
      override_action = "count"
      priority        = 20

      statement = {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        excluded_rule = [
          "SizeRestrictions_QUERYSTRING",
          "NoUserAgent_HEADER"
        ]
      }

      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
        metric_name                = "rule-20-metric"
      }
    }
  ]

  xss_match_statement_rules = [
    {
      name     = "rule-60"
      action   = "block"
      priority = 60

      statement = {
        field_to_match = {
          uri_path = {}
        }

        text_transformation = [
          {
            type     = "URL_DECODE"
            priority = 1
          },
          {
            type     = "HTML_ENTITY_DECODE"
            priority = 2
          }
        ]

      }

      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
        metric_name                = "rule-60-metric"
      }
    }
  ]

  context = module.label.context
}

resource "aws_wafv2_web_acl_association" "example" {
  resource_arn = local.alb_arn
  web_acl_arn  = module.waf.arn
}
