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
resource "aws_s3_bucket" "website_bucket" {
  #bucket = random_string.bucket_name.result
  bucket = var.bucket_name
  tags = {
    UserUuid        = var.UserUuid
  }
}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "index.html"  # Change to your desired index file
  source       = var.index_html_filepath  # Local path to your index.html file
  content_type = "text/html"
  etag = filemd5(var.index_html_filepath)
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "error.html"  # Change to your desired error file
  source       = var.error_html_filepath  # Local path to your error.html file
  content_type = "text/html"
  etag = filemd5(var.error_html_filepath)
}
