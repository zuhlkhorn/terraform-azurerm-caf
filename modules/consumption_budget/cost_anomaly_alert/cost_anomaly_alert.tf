resource "azurerm_cost_anomaly_alert" "this" {
  name            = var.settings.name
  display_name    = var.settings.display_name
  email_subject   = var.settings.email_subject
  email_addresses = var.settings.email_addresses
  message         = try(var.settings.message, null)
}
