module "application_gateways" {
  depends_on = [module.keyvault_certificates, module.keyvault_certificate_requests, module.application_gateway_waf_policies]
  source     = "./modules/networking/application_gateway"
  for_each   = local.networking.application_gateways

  app_services_linux               = local.combined_objects_app_services_linux
  # app_services_windows             = local.combined_objects_app_services_windows
  application_gateway_waf_policies = local.combined_objects_application_gateway_waf_policies
  client_config                    = local.client_config
  diagnostics                      = local.combined_diagnostics
  dns_zones                        = local.combined_objects_dns_zones
  global_settings                  = local.global_settings
  keyvault_certificate_requests    = module.keyvault_certificate_requests
  keyvault_certificates            = module.keyvault_certificates
  keyvaults                        = local.combined_objects_keyvaults
  managed_identities               = local.combined_objects_managed_identities
  private_dns                      = lookup(each.value, "private_dns_records", null) == null ? {} : local.combined_objects_private_dns
  public_ip_addresses              = local.combined_objects_public_ip_addresses
  settings                         = each.value
  sku_name                         = each.value.sku_name
  sku_tier                         = each.value.sku_tier
  vnets                            = local.combined_objects_networking

  application_gateway_applications = {
    for key, value in local.networking.application_gateway_applications : key => value
    if value.application_gateway_key == each.key
  }

  base_tags           = local.global_settings.inherit_tags
  resource_group      = local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group_key, each.value.resource_group.key)]
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : null
  location            = try(local.global_settings.regions[each.value.region], null)
}

output "application_gateways" {
  value = module.application_gateways

}

output "application_gateway_applications" {
  value = local.networking.application_gateway_applications

}
