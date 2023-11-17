resource "azurerm_monitor_data_collection_endpoint" "dce" {
  name                          = var.settings.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  public_network_access_enabled = var.settings.public_network_access_enabled
  tags                          = local.tags
}