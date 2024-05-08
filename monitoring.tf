module "data_collection_endpoint" {
  source = "./modules/monitoring/data_collection_endpoint"
  for_each = local.shared_services.data_collection_endpoints

  global_settings     = local.global_settings
  settings            = each.value
  base_tags           = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}
  location            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name
}

output "data_collection_endpoint" {
  value = module.data_collection_endpoint
}

# TODO need to be implemented
# module "data_collection_rule" {
#   source = "./modules/monitoring/data_collection_rule"
#   for_each = local.shared_services.data_collection_rules

#   global_settings     = local.global_settings
#   settings            = each.value
#   location            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].location
#   resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name
# }

module "service_health_alerts" {
  source              = "./modules/monitoring/service_health_alerts"
  for_each            = local.shared_services.monitoring
  global_settings     = local.global_settings
  settings            = each.value
  location            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].location
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name
}

module "monitor_metric_alert" {
  source   = "./modules/monitoring/monitor_metric_alert"
  for_each = local.shared_services.monitor_metric_alert

  global_settings = local.global_settings
  client_config   = local.client_config
  settings        = each.value

  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name

  remote_objects = local.remote_objects
}
output "monitor_metric_alert" {
  value = module.monitor_metric_alert
}

module "monitor_activity_log_alert" {
  source   = "./modules/monitoring/monitor_activity_log_alert"
  for_each = local.shared_services.monitor_activity_log_alert

  global_settings     = local.global_settings
  client_config       = local.client_config
  settings            = each.value
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name

  remote_objects = local.remote_objects
}
output "monitor_activity_log_alert" {
  value = module.monitor_activity_log_alert
}

module "monitor_private_link_scope" {
  source   = "./modules/monitoring/monitor_private_link_scope"
  for_each = local.shared_services.monitor_private_link_scopes

  global_settings                    = local.global_settings
  client_config                      = local.client_config
  settings                           = each.value
  base_tags                          = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}
  resource_group_name                = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name
  linked_log_analytics_id            = try(each.value.log_analytics_id, local.combined_diagnostics.log_analytics[try(each.value.log_analytics_key, each.value.log_analytics.key)].id)
  linked_data_collection_endpoint_id = try(each.value.data_collection_endpoint_id, local.combined_objects_data_collection_endpoints[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.data_collection_endpoint_key, each.value.data_collection_endpoint.key)].id)
  vnets                              = local.combined_objects_networking
  virtual_subnets                    = local.combined_objects_virtual_subnets
  private_endpoints                  = try(each.value.private_endpoints, {})
  resource_groups                    = local.combined_objects_resource_groups
  private_dns                        = local.combined_objects_private_dns
}
output "monitor_private_link_scope" {
  value = module.monitor_private_link_scope
}

module "monitor_scheduled_query_rules_alert_v2" {
  source   = "./modules/monitoring/monitor_scheduled_query_rules_alert_v2"
  for_each = local.shared_services.monitor_scheduled_query_rules_alerts_v2

  global_settings     = local.global_settings
  client_config       = local.client_config
  settings            = each.value
  base_tags           = try(local.global_settings.inherit_tags, false) ? try(local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].tags, {}) : {}
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)].name
  location            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].location
}
output "monitor_scheduled_query_rules_alert_v2" {
  value = module.monitor_scheduled_query_rules_alert_v2
}