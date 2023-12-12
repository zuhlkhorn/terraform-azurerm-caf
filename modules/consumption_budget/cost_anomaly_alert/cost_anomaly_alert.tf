resource "azurecaf_name" "this_name" {
  name          = var.settings.name
  prefixes      = var.global_settings.prefixes
  resource_type = "azurerm_cost_anomaly_alert"
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_cost_anomaly_alert" "this" {
  name            = azurecaf_name.this_name.result
  display_name    = var.settings.display_name
  email_subject   = var.settings.email_subject
  email_addresses = var.settings.email_addresses
  message         = var.settings.message
}
