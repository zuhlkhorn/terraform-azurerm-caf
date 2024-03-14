terraform {
  required_providers {
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.58.0"
      configuration_aliases = [
        azurerm.launchpad
      ]
    }
  }

}

locals {
  tags = var.base_tags ? merge(
    var.global_settings.tags,
    try(var.resource_group.tags, null),
    try(var.storage_account.tags, null)
  ) : try(var.storage_account.tags, null)

  location            = coalesce(var.location, var.resource_group.location)
  resource_group_name = coalesce(var.resource_group_name, var.resource_group.name)
}
