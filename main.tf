provider "aws" {
  region = var.region
}

# Create Route53 Hosted Zone
resource "aws_route53_zone" "main" {
  name          = var.domain_name
  comment       = var.comment
  force_destroy = true
}

# Create ACM Certificate (root + wildcard)
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain_name}"
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# Deduplicate domain validation options
locals {
  cert_validation_options = {
    for dvo in aws_acm_certificate.cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }
}

# Create Route53 validation records
resource "aws_route53_record" "cert_validation" {
  for_each = local.cert_validation_options

  zone_id = aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

# Validate certificate
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
