terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
  # cloud {
  #   organization = "ACG-Terraform-Demos-Orgs"
  #   workspaces {
  #     name = "terra-house-workspace1"
  #   }
  # }
}
provider "terratowns" {
  #endpoint = "http://localhost:4567"
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}
module "terrahouse_aws" {
  source              = "./modules/terrahouse_aws"
  teacherseat_user_uuid            = var.teacherseat_user_uuid
  bucket_name         = var.bucket_name
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  content_version     = var.content_version
  assets_filepath     = var.assets_filepath
}

resource "terratowns_home" "home" {
  name = "How to play Arcanum in 2023!"
  description = <<DESC
Arcanum is a game from 2001 that shipped with a lot of bugs.
Moddlers have removed all the originals making this game really fun to play
(despite the old looking graphics). This is my guide that will show you
how to play arcanum without spoiling the plot
DESC
  town = "missingo"
  domain_name = module.terrahouse_aws.cloudfront_distribution_domain_name
  #domain_name = "abcde.cloudfront.net"
  content_version = 1
}