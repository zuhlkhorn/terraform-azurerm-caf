output "id" {
  value       = azurerm_monitor_scheduled_query_rules_alert_v2.alert_v2.id
  description = "The ID of the Monitor Scheduled Query Rule."
}

output "created_with_api_version" {
  value       = azurerm_monitor_scheduled_query_rules_alert_v2.alert_v2.created_with_api_version
  description = "The api-version used when creating this alert rule."
}

output "is_a_legacy_log_analytics_rule" {
  value       = azurerm_monitor_scheduled_query_rules_alert_v2.alert_v2.is_a_legacy_log_analytics_rule
  description = "True if this alert rule is a legacy Log Analytic Rule."
}

output "is_workspace_alerts_storage_configured" {
  value       = azurerm_monitor_scheduled_query_rules_alert_v2.alert_v2.is_workspace_alerts_storage_configured
  description = "The flag indicates whether this Scheduled Query Rule has been configured to be stored in the customer's storage."
}