terraform {
  required_version = ">=0.12.0"
  backend "s3" {
    key            = "infra/terraformstatefile"
    bucket         = "djtech-9ba2c0ecf6639220"
    region         = "eu-west-2"
    dynamodb_table = "finance-state-locking"
  }
}