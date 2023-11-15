resource "azurerm_monitor_private_link_scope" "mpls" {
  name                = var.settings.name
  resource_group_name = var.resource_group_name
  tags                = local.tags
}

# Link the MPLS to the Resource ID (log Analytics Workspace or something else)
resource "azurerm_monitor_private_link_scoped_service" "log_analytics_workspace" {
  name                = var.settings.log_analytics.linked_resource_name
  resource_group_name = var.resource_group_name
  scope_name          = azurerm_monitor_private_link_scope.mpls.name
  linked_resource_id  = var.linked_log_analytics_id
  depends_on          = [module.private_endpoint]
}

# Link the MPLS to the Resource ID (here Data Collection Endpoint)
resource "azurerm_monitor_private_link_scoped_service" "data_collection_endpoint" {
  name                = var.settings.data_collection_endpoint.linked_resource_name
  resource_group_name = var.resource_group_name
  scope_name          = azurerm_monitor_private_link_scope.mpls.name
  linked_resource_id  = var.linked_data_collection_endpoint_id
  depends_on          = [module.private_endpoint]
} 