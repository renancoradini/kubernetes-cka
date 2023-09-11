######
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }

  }
}


provider "aws" {
  region = var.regionset
  #profile = "renandeploy"
  access_key = var.accessKey
  secret_key = var.secretKey
}

#   provider "aws" {
#    alias   = "acm_provider"
#    region  = "us-east-1"
#   access_key = var.accessKey
#   secret_key = var.secretKey
#  }
