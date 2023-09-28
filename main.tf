terraform {
  cloud {
    organization = "ACG-Terraform-Demos-Orgs"
    workspaces {
      name = "terra-house-workspace1"
    }
  }
}
module "terrahouse_aws" {
  source              = "./modules/terrahouse_aws"
  UserUuid            = var.UserUuid
  bucket_name         = var.bucket_name
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  content_version     = var.content_version
  assets_filepath     = var.assets_filepath
}