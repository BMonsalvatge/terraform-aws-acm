# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_DEFAULT_REGION

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "domain" {
  description = "The base of the domain you will using for the cert 'mywebsite.tld'"
}


# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "wildcard" {
  description = "If not specified, or set to STRING of true then a wildcard is use for your base domain and environment if enabled.  Set to anything else to disable."
  default = "true"
}


variable "environment" {
  description = "Specify the environment the certificate is for.  Also goes before domain in the URL.  Ex: default.domain.com"
  default = "default"
}

variable "terraservice" {
  description = "Used for AWS tags."
  default = "default"
}

variable "validation_method" {
  description = "Method to be used for validating the ACM Cert"
  default = "DNS"
}



