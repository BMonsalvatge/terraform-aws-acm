terraform {
  backend "s3" {
    bucket = "bmonsalvatge-os-tf-state"
    key    = "aws-acm"
    region = "us-east-1"
  }
}
