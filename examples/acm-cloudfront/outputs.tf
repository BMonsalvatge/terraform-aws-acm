output "cert_id" {
  value = "${module.acm.id}"
}

output "cert_arn" {
  value = "${module.acm.arn}"
}

output "cert_domain" {
  value = "${module.acm.domain_name}"
}

