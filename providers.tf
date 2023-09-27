terraform {
  cloud {
    organization = "ACG-Terraform-Demos-Orgs"
    workspaces {
      name = "terra-house-workspace1"
    }
  }
  required_providers {
    # random = {
    #   source = "hashicorp/random"
    #   version = "3.5.1"
    # }
    aws = {
      source = "hashicorp/aws"
      version = "5.16.2"
    }
  }
}

provider "aws" {
  
}

provider "random" {
  # Configuration options
}