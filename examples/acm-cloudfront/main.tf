module "acm" {
  source = "../../modules/acm-cert"
  
  domain = "bmonsalvatge.com"

  wildcard = "true"
}
