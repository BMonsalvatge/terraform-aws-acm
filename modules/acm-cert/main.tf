locals {
  combined_domain = "${var.environment}.${var.domain}"

  wildcard = "${var.wildcard == "true" ? "*.${var.domain}" : var.domain}"
  wildcard_env = "${var.wildcard == "true" ? "*.${local.combined_domain}" : local.combined_domain}"
}


resource "aws_acm_certificate" "acm_cert" {
  count             = "${var.environment == "default" ? 1 : 0}"
  domain_name       = "${local.wildcard}"
  validation_method = "${var.validation_method}"

  tags {
    Environment  = "${var.environment}"
    Terraservice = "${var.terraservice}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "env_acm_cert" {
  count             = "${var.environment == "default" ? 0 : 1}"
  domain_name       = "${local.wildcard_env}"
  validation_method = "${var.validation_method}"

  tags {
    Environment  = "${var.environment}"
    Terraservice = "${var.terraservice}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "zone" {
  name         = "${var.domain}."
  private_zone = false
}

resource "aws_route53_record" "cert_validation" {
  count    = "${var.environment == "default" ? 1 : 0}"
  name     = "${aws_acm_certificate.acm_cert.domain_validation_options.0.resource_record_name}"
  type     = "${aws_acm_certificate.acm_cert.domain_validation_options.0.resource_record_type}"
  zone_id  = "${data.aws_route53_zone.zone.id}"
  records  = ["${aws_acm_certificate.acm_cert.domain_validation_options.0.resource_record_value}"]
  ttl      = 60
}

resource "aws_route53_record" "env_cert_validation" {
  count    = "${var.environment == "default" ? 0 : 1}"
  name     = "${aws_acm_certificate.env_acm_cert.domain_validation_options.0.resource_record_name}"
  type     = "${aws_acm_certificate.env_acm_cert.domain_validation_options.0.resource_record_type}"
  zone_id  = "${data.aws_route53_zone.zone.id}"
  records  = ["${aws_acm_certificate.env_acm_cert.domain_validation_options.0.resource_record_value}"]
  ttl      = 60
}

resource "aws_acm_certificate_validation" "cert" {
  count                   = "${var.environment == "default" ? 1 : 0}"
  certificate_arn         = "${aws_acm_certificate.acm_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}

resource "aws_acm_certificate_validation" "env_cert" {
  count                   = "${var.environment == "default" ? 0 : 1}"
  certificate_arn         = "${aws_acm_certificate.env_acm_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.env_cert_validation.fqdn}"]
}
