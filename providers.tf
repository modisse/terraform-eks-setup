terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

variable "cluster_name" {
  default = "finance-cluster"
}

variable "cluster_version" {
  default = "1.27"
}