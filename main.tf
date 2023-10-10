terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
  cloud {
    organization = "ACG-Terraform-Demos-Orgs"
    workspaces {
      name = "terra-house-workspace1"
    }
  }
}
provider "terratowns" {
  #endpoint = "http://localhost:4567"
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}
module "home_mario" {
  source                = "./modules/terrahome_aws"
  UserUuid              = var.teacherseat_user_uuid
  bucket_name           = var.bucket_name
  public_path           = var.mario.public_path
  content_version       = var.mario.content_version
}

resource "terratowns_home" "home" {
  name = "The Mario Bros."
  description = <<DESC
In the Mushroom Kingdom, a tribe of turtle-like creatures known as the Koopa Troopas
invade the kingdom and uses the magic of its king, Bowser, to turn its inhabitants, 
known as the Mushroom People, into inanimate objects such as bricks, stones and horsehair plants. 
Bowser and his army also kidnap Princess Toadstool, the princess of the Mushroom Kingdom and 
the only one with the ability to reverse Bowser's spell. After hearing the news, the mario brothers
set out to save the princess and free the kingdom from Bowser.
DESC
  town = "missingo"
  domain_name = module.home_mario.cloudfront_distribution_domain_name
  content_version = var.mario.content_version
}

# module "home_recipe" {
#   source                = "./modules/terrahome_aws"
#   UserUuid              = var.teacherseat_user_uuid
#   bucket_name           = var.bucket_name
#   public_path           = var.mushroom_pasta.public_path
#   content_version       = var.mushroom_pasta.content_version
# }

# resource "terratowns_home" "recipe" {
#   name = "Making Mushroom pasta for Mario"
#   description = <<DESC
# Today we’re jumping into a warp pipe and heading out on an adventure into the world of Mario and Luigi. 
# Get ready to savor a taste of the Mushroom Kingdom with this delightful Mushroom Pasta recipe inspired 
# by the Mario Brothers Movie. With its creamy sauce, savory mushrooms, and flavorful ingredients, 
# this dish brings the magic of the Mario franchise to your dinner table. 
# DESC
#   town = "cooker-cove"
#   domain_name = module.home_recipe.cloudfront_distribution_domain_name
#   content_version = var.mushroom_pasta.content_version
# }

