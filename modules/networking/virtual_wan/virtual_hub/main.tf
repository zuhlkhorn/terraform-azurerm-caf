data "azurerm_subscription" "current" {
}

locals {
  tags = merge(var.tags, try(var.virtual_hub_config.tags, null))
}

terraform {
  required_providers {
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }

}

