resource "aws_acm_certificate" "acm_cert" {
  count             = "${var.environment == "production" ? 1 : 0}"
  domain_name       = "*.${var.domain}"
  validation_method = "DNS"

  tags {
    Environment  = "${var.environment}"
    Terraservice = "${var.terraservice}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "env_acm_cert" {
  count             = "${var.environment == "production" ? 0 : 1}"
  domain_name       = "*.${var.environment}.${var.domain}"
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
  provider     = "aws.dns"
  name         = "${var.domain}."
  private_zone = false
}

resource "aws_route53_record" "cert_validation" {
  count    = "${var.environment == "production" ? 1 : 0}"
  provider = "aws.dns"
  name     = "${aws_acm_certificate.acm_cert.domain_validation_options.0.resource_record_name}"
  type     = "${aws_acm_certificate.acm_cert.domain_validation_options.0.resource_record_type}"
  zone_id  = "${data.aws_route53_zone.zone.id}"
  records  = ["${aws_acm_certificate.acm_cert.domain_validation_options.0.resource_record_value}"]
  ttl      = 60
}

resource "aws_route53_record" "env_cert_validation" {
  count    = "${var.environment == "production" ? 0 : 1}"
  provider = "aws.dns"
  name     = "${aws_acm_certificate.env_acm_cert.domain_validation_options.0.resource_record_name}"
  type     = "${aws_acm_certificate.env_acm_cert.domain_validation_options.0.resource_record_type}"
  zone_id  = "${data.aws_route53_zone.zone.id}"
  records  = ["${aws_acm_certificate.env_acm_cert.domain_validation_options.0.resource_record_value}"]
  ttl      = 60
}

resource "aws_acm_certificate_validation" "cert" {
  count                   = "${var.environment == "production" ? 1 : 0}"
  certificate_arn         = "${aws_acm_certificate.acm_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}

resource "aws_acm_certificate_validation" "env_cert" {
  count                   = "${var.environment == "production" ? 0 : 1}"
  certificate_arn         = "${aws_acm_certificate.env_acm_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.env_cert_validation.fqdn}"]
}
