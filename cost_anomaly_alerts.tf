module "cost_anomaly_alerts" {
  source = "./modules/consumption_budget/cost_anomaly_alert"
  depends_on = [ module.subscriptions, module.consumption_budgets_subscriptions, module.consumption_budgets_resource_groups ]
  for_each = try(local.shared_services.cost_anomaly_alerts, {})

  client_config   = local.client_config
  global_settings = local.global_settings
  settings        = each.value
}

output "cost_anomaly_alerts" {
  value = module.cost_anomaly_alerts
}