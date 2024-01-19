module "cost_anomaly_alerts" {
  source = "./modules/consumption_budget/cost_anomaly_alert"
  for_each = try(local.shared_services.cost_anomaly_alerts, {})

  client_config   = local.client_config
  global_settings = local.global_settings
  settings        = each.value
}

output "cost_anomaly_alerts" {
  value = module.cost_anomaly_alerts
}