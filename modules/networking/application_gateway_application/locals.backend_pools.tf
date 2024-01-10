locals {
  backend_pools_app_services_linux = {
    for key, value in try(var.settings.backend_pools, {}) : key => flatten(
      [
        for app_service_key, app_service in try(value.app_services_linux, {}) : [
          try(var.app_services_linux[app_service.lz_key][app_service.key].default_hostname, var.app_services_linux[var.client_config.landingzone_key][app_service.key].default_hostname)
        ]
      ]
    ) if lookup(value, "app_services_linux", false) != false
  }

  # Left for a future implementation, when needed
  # backend_pools_app_services_windows = {
  #   for key, value in try(var.settings.backend_pools, {}) : key => flatten(
  #     [
  #       for app_service_key, app_service in try(value.app_services_windows, {}) : [
  #         try(var.app_services_windows[app_service.lz_key][app_service.key].default_hostname, var.app_services_windows[var.client_config.landingzone_key][app_service.key].default_hostname)
  #       ]
  #     ]
  #   ) if lookup(value, "app_services_windows", false) != false
  # }

  # backend_pools_fqdn = {
  #   for key, value in var.settings.backend_pools : key => flatten(
  #     [
  #       try(value.fqdns, [])
  #     ]
  #   ) if lookup(value, "fqdns", false) != false
  # }

  # backend_pools_vmss = {
  #   for key, value in var.settings : key = > flatten(
  #     [
  #       try(value.backend_pool.vmss,)
  #     ]
  #   )
  # }

  backend_pools = {
    for key, value in try(var.settings.backend_pools, {}) : key => {
      address_pools = join(" ", try(flatten(
        [
          try(local.backend_pools_app_services_linux[key], []),
          # try(local.backend_pools_app_services_windows[key], []),
          try(value.fqdns, []),
          try(value.ip_addresses, [])
        ]
      ), null))
    }
  }
}
