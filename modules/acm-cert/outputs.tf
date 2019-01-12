output "arn" {
  value = "${element(concat(aws_acm_certificate.acm_cert.*.arn, aws_acm_certificate.env_acm_cert.*.arn), 0)}"
}

output "id" {
  value = "${element(concat(aws_acm_certificate.acm_cert.*.id, aws_acm_certificate.env_acm_cert.*.id), 0)}"
}

output "domain_name" {
  value = "${element(concat(aws_acm_certificate.acm_cert.*.domain_name, aws_acm_certificate.env_acm_cert.*.domain_name), 0)}"
}