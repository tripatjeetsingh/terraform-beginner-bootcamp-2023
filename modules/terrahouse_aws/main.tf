terraform {
#   cloud {
#     organization = "ACG-Terraform-Demos-Orgs"
#     workspaces {
#       name = "terra-house-workspace1"
#     }
#   }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.16.2"
    }
  }
}
# provider "aws" {
#     # Configuration options
# }
resource "aws_s3_bucket" "my_bucket" {
  #bucket = random_string.bucket_name.result
  bucket = var.bucket_name
  tags = {
    UserUuid        = var.UserUuid
  }
}