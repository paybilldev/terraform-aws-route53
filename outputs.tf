output "zone_id" {
  description = "The ID of the Route 53 hosted zone"
  value       = aws_route53_zone.main.zone_id
}

output "name_servers" {
  description = "Name servers for the hosted zone"
  value       = aws_route53_zone.main.name_servers
}

output "certificate_arn" {
  description = "ARN of the issued ACM certificate"
  value       = aws_acm_certificate.cert.arn
}
