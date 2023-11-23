resource "terraform_data" "update_log_analytics_workspace_tables" {
  for_each = var.tables

  triggers_replace = [
    table_name = each.value.name,
    retention_in_days = each.value.retention_in_days,
    total_retention_in_days = each.value.total_retention_in_days
  ]

  provisioner "local-exec" {
    command = "az monitor log-analytics workspace table update --resource-group ${local.resource_group_name} --workspace-name ${azurerm_log_analytics_workspace.law.name} --name ${each.value.name} --retention-time ${each.value.retention_in_days} --total-retention-time ${each-value.total_retention_in_days}"
  }
}