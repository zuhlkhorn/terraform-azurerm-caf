locals {
  backend_pools_app_services_linux = {
    for agw_config_key, value in var.application_gateway_applications : agw_config_key => flatten(
      [
        for app_service_key, app_service in try(value.backend_pool.app_services_linux, {}) : [
          try(var.app_services_linux[app_service.lz_key][app_service.key].default_hostname, var.app_services_linux[var.client_config.landingzone_key][app_service.key].default_hostname)
        ]
      ]
    ) if lookup(value, "backend_pool", false) != false
  }

  # Left for a future implementation, when needed
  # backend_pools_app_services_windows = {
  #   for agw_config_key, value in var.application_gateway_applications : agw_config_key => flatten(
  #     [
  #       for app_service_key, app_service in try(value.backend_pool.app_services_windows, {}) : [
  #         try(var.app_services_windows[app_service.lz_key][app_service.key].default_hostname, var.app_services_windows[var.client_config.landingzone_key][app_service.key].default_hostname)
  #       ]
  #     ]
  #   ) if lookup(value, "backend_pool", false) != false
  # }

  backend_pools_fqdn = {
    for key, value in var.application_gateway_applications : key => flatten(
      [
        try(value.backend_pool.fqdns, [])
      ]
    ) if lookup(value, "backend_pool", false) != false
  }

  # backend_pools_vmss = {
  #   for key, value in var.application_gateway_applications : key = > flatten(
  #     [
  #       try(value.backend_pool.vmss,)
  #     ]
  #   )
  # }

  backend_pools = {
    for key, value in var.application_gateway_applications : key => {
      name = try(value.backend_pool.name, value.name)
      fqdns = try(flatten(
        [
          local.backend_pools_app_services_linux[key],
          # local.backend_pools_app_services_windows[key],
          local.backend_pools_fqdn[key]
        ]
      ), null)
      ip_addresses = try(value.backend_pool.ip_addresses, null)
    } if try(value.type, null) != "redirect"
  }
}
