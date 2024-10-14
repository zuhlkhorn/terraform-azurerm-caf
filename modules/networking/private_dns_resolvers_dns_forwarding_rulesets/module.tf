data "azurecaf_name" "pvtdnsrfrs" {
  name          = var.settings.name
  resource_type = "azurerm_private_dns_resolver_dns_forwarding_ruleset"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug

}

data "azurerm_resource_group" "parent" {
  name = local.resource_group_name
}

resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "pvt_dns_resolver_forwarding_ruleset" {
  name                                       = data.azurecaf_name.pvtdnsrfrs.result
  resource_group_name                        = local.resource_group_name
  location                                   = local.location
  tags                                       = var.inherit_tags ? merge(try(var.settings.tags, {}), local.tags, data.azurerm_resource_group.parent.tags) : try(var.settings.tags, {})
  private_dns_resolver_outbound_endpoint_ids = toset(var.outbound_endpoint_ids)

  lifecycle {
    ignore_changes = [name]
  }

}

