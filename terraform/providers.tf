terraform {
  required_version = ">= 1.9.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.74"
    }
  }
  cloud {

    organization = "ra-devops-org"

    workspaces {
      name = "cloud-resume-api"
    }
  }
}

provider "azurerm" {
  features {

  }
}

