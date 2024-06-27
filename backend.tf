terraform {
  required_version = ">=0.12.0"
  backend "s3" {
    key            = "infra/terraformstatefile"
    bucket         = "djtech-f8a889da47d6b432"
    region         = "eu-west-2"
    dynamodb_table = "finance-state-locking"
  }
}