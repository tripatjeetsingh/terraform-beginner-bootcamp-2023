terraform {
  cloud {
    organization = "ACG-Terraform-Demos-Orgs"
    workspaces {
      name = "terra-house-workspace1"
    }
  }
}
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  UserUuid = var.UserUuid
  bucket_name = var.bucket_name
}