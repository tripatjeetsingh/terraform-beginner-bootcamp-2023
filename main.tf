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
  endpoint = "http://localhost:4567"
  user_uuid="e328f4ab-b99f-421c-84c9-4ccea042c7d1" 
  token="9b49b3fb-b8e9-483c-b703-97ba88eef8e0"
}
# module "terrahouse_aws" {
#   source              = "./modules/terrahouse_aws"
#   UserUuid            = var.UserUuid
#   bucket_name         = var.bucket_name
#   index_html_filepath = var.index_html_filepath
#   error_html_filepath = var.error_html_filepath
#   content_version     = var.content_version
#   assets_filepath     = var.assets_filepath
# }

resource "terratown_home" "home" {
  name = "How to play Arcanum"
  description = <<DESC
Arcanum is a game from 2001 that shipped with a lot of bugs.
Moddlers have removed all the originals making this game really fun
to play (despite the old looking graphics). This is my guide that will
show you how to play arcanum without spoiling the plot.
DESC
  town = "gamers-grotto"
  domain_name = "abcde.cloudfront.net"
  content_version = 1
}