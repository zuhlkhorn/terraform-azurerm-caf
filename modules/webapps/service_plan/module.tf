
resource "azurecaf_name" "service_plan" {
  name          = var.settings.name
  resource_type = "azurerm_app_service_plan"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}


resource "azurerm_service_plan" "service_plan" {
  name                         = azurecaf_name.service_plan.result
  location                     = local.location
  resource_group_name          = local.resource_group_name
  os_type                      = var.settings.os_type
  sku_name                     = var.settings.sku_name
  app_service_environment_id   = lookup(var.settings, "app_service_environment_id", null)
  maximum_elastic_worker_count = lookup(var.settings, "maximum_elastic_worker_count", null)
  worker_count                 = lookup(var.settings, "worker_count", null)
  per_site_scaling_enabled     = lookup(var.settings, "per_site_scaling_enabled", false)
  zone_balancing_enabled       = lookup(var.settings, "zone_balancing_enabled", null)
  tags                         = merge(local.tags, try(var.settings.tags, {}))

  timeouts {
    create = "1h"
    update = "1h"
  }
}


