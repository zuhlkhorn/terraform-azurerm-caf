module "private_endpoint" {
  source   = "../networking/private_endpoint"
  for_each = { for key, val in var.private_endpoints : key => val if !contains(["launchpad", "asvm"], try(val.lz_key, "")) }

  resource_id         = azurerm_storage_account.stg.id
  name                = each.value.name
  location            = local.location
  resource_group_name = local.resource_group_name
  subnet_id           = can(each.value.subnet_id) || can(each.value.virtual_subnet_key) ? try(each.value.subnet_id, var.virtual_subnets[try(each.value.lz_key, var.client_config.landingzone_key)][each.value.virtual_subnet_key].id) : var.vnets[try(each.value.lz_key, var.client_config.landingzone_key)][each.value.vnet_key].subnets[each.value.subnet_key].id
  settings            = each.value
  global_settings     = var.global_settings
  tags                = local.tags
  base_tags           = var.base_tags
  private_dns         = var.private_dns
  client_config       = var.client_config
}

module "private_endpoint_in_launchpad" {
  source   = "../networking/private_endpoint"
  for_each = { for key, val in var.private_endpoints : key => val if contains(["launchpad", "asvm"], try(val.lz_key, "")) }

  providers = {
    azurerm = azurerm.launchpad
  }

  resource_id         = azurerm_storage_account.stg.id
  name                = each.value.name
  location            = local.location
  resource_group_name = var.resource_groups[each.value.lz_key][each.value.resource_group_key].name
  subnet_id           = can(each.value.subnet_id) || can(each.value.virtual_subnet_key) ? try(each.value.subnet_id, var.virtual_subnets[try(each.value.lz_key, var.client_config.landingzone_key)][each.value.virtual_subnet_key].id) : var.vnets[try(each.value.lz_key, var.client_config.landingzone_key)][each.value.vnet_key].subnets[each.value.subnet_key].id
  settings            = each.value
  global_settings     = var.global_settings
  tags                = local.tags
  base_tags           = var.base_tags
  private_dns         = var.private_dns
  client_config       = var.client_config
}

