
module "service_plans" {
  source = "./modules/webapps/service_plan"

  for_each = local.webapp.service_plans

  base_tags           = local.global_settings.inherit_tags
  resource_group      = local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)]
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : null
  location            = try(local.global_settings.regions[each.value.region], null)

  settings        = each.value
  global_settings = local.global_settings
}

output "service_plans" {
  value = module.service_plans
}
