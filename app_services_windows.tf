# Left for a future implementation

# module "app_services_windows" {
#   source     = "./modules/webapps/windows"
#   depends_on = [module.networking]
#   for_each   = local.webapp.app_services_windows

#   name                                = each.value.name
#   client_config                       = local.client_config
#   app_service_plan_id                 = can(each.value.app_service_plan_id) ? each.value.app_service_plan_id : local.combined_objects_app_service_plans[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.app_service_plan_key].id
#   settings                            = each.value.settings
#   identity                            = try(each.value.identity, null)
#   connection_strings                  = try(each.value.connection_strings, {})
#   app_settings                        = try(each.value.app_settings, null)
#   slots                               = try(each.value.slots, {})
#   global_settings                     = local.global_settings
#   dynamic_app_settings                = try(each.value.dynamic_app_settings, {})
#   combined_objects                    = local.dynamic_app_settings_combined_objects
#   application_insight                 = try(each.value.application_insight_key, null) == null ? null : module.azurerm_application_insights[each.value.application_insight_key]
#   diagnostic_profiles                 = try(each.value.diagnostic_profiles, null)
#   diagnostics                         = local.combined_diagnostics
#   storage_accounts                    = local.combined_objects_storage_accounts
#   private_endpoints                   = try(each.value.private_endpoints, {})
#   vnets                               = local.combined_objects_networking
#   subnet_id                           = can(each.value.subnet_id) || can(each.value.vnet_key) == false ? try(each.value.subnet_id, null) : local.combined_objects_networking[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.vnet_key].subnets[each.value.subnet_key].id
#   private_dns                         = local.combined_objects_private_dns
#   azuread_applications                = local.combined_objects_azuread_applications
#   azuread_service_principal_passwords = local.combined_objects_azuread_service_principal_passwords

#   base_tags           = local.global_settings.inherit_tags
#   resource_group      = local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)]
#   resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : null
#   location            = try(local.global_settings.regions[each.value.region], null)
# }

# output "app_services_windows" {
#   value = module.app_services_windows
# }
