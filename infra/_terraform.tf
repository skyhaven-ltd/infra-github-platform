terraform {
  required_version = ">= 1.7"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.6"
    }
  }

  # Remote state in Azure Storage. Settings are supplied at init time via
  # -backend-config (locally for the one-off migration, by the workflow in CI):
  #   resource_group_name  = rg-tfs-platform-prd-uks-01
  #   storage_account_name = sttfsplatformprduks01
  #   container_name       = infra-github-platform
  #   key                  = terraform.tfstate
  #   subscription_id      = <platform subscription>
  backend "azurerm" {}
}
