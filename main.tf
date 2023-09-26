terraform {
  cloud {
    organization = "ACG-Terraform-Demos-Orgs"
    workspaces {
      name = "terra-house-workspace1"
    }
  }
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}
provider "aws" {
  # Configuration options
}
provider "random" {
  # Configuration options
}
resource "random_string" "bucket_name" {
  length           = 32
  special          = false
  lower = true
  upper = false
}
resource "aws_s3_bucket" "my_bucket" {
  bucket = random_string.bucket_name.result
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
output "random_bucket_name" {
  value = random_string.bucket_name.result
}