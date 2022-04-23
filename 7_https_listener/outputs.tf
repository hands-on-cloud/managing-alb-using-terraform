output "cert_arn" {
  value       = aws_acm_certificate.cert.arn
  description = "the ARN of the certificate"

}