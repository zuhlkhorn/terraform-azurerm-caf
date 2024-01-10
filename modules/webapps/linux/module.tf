
resource "azurecaf_name" "app_service_linux" {
  name          = var.name
  resource_type = "azurerm_app_service"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_linux_web_app" "app_service_linux" {
  name                = azurecaf_name.app_service_linux.result
  location            = local.location
  resource_group_name = local.resource_group_name
  service_plan_id     = var.service_plan_id
  tags                = merge(local.tags, try(var.settings.tags, {}))

  client_affinity_enabled                        = lookup(var.settings, "client_affinity_enabled", null)
  client_certificate_enabled                     = lookup(var.settings, "client_certificate_enabled", null)
  client_certificate_mode                        = lookup(var.settings, "client_certificate_mode", null)
  client_certificate_exclusion_paths             = lookup(var.settings, "client_certificate_exclusion_paths", null)
  enabled                                        = lookup(var.settings, "enabled", null)
  https_only                                     = lookup(var.settings, "https_only", null)
  virtual_network_subnet_id                      = lookup(var.settings, "virtual_network_subnet_id", null)
  zip_deploy_file                                = lookup(var.settings, "zip_deploy_file", null)
  # Add when updating to azurerm version 3.85
  # ftp_publish_basic_authentication_enabled       = lookup(var.settings, "ftp_publish_basic_authentication_enabled", null)
  # public_network_access_enabled                  = lookup(var.settings, "public_network_access_enabled", null)
  # webdeploy_publish_basic_authentication_enabled = lookup(var.settings, "webdeploy_publish_basic_authentication_enabled", null)

  key_vault_reference_identity_id = can(var.settings.key_vault_reference_identity.key) ? var.combined_objects.managed_identities[try(var.settings.identity.lz_key, var.client_config.landingzone_key)][var.settings.key_vault_reference_identity.key].id : try(var.settings.key_vault_reference_identity.id, null)

  dynamic "identity" {
    for_each = try(var.identity, null) == null ? [] : [1]

    content {
      type         = var.identity.type
      identity_ids = lower(var.identity.type) == "userassigned" ? local.managed_identities : null
    }
  }

  dynamic "site_config" {
    for_each = try(var.settings.site_config, {})

    content {
      always_on                                     = lookup(var.settings.site_config, "always_on", false)
      api_definition_url                            = lookup(var.settings.site_config, "api_definition_url", false)
      api_management_api_id                         = lookup(var.settings.site_config, "api_management_api_id", false)
      app_command_line                              = lookup(var.settings.site_config, "app_command_line", null)
      auto_heal_enabled                             = lookup(var.settings.site_config, "auto_heal_enabled", null)
      container_registry_managed_identity_client_id = lookup(var.settings.site_config, "container_registry_managed_identity_client_id", null)
      container_registry_use_managed_identity       = lookup(var.settings.site_config, "container_registry_use_managed_identity", null)
      default_documents                             = lookup(var.settings.site_config, "default_documents", null)
      ftps_state                                    = lookup(var.settings.site_config, "ftps_state", "Disabled")
      health_check_path                             = lookup(var.settings.site_config, "health_check_path", null)
      health_check_eviction_time_in_min             = lookup(var.settings.site_config, "health_check_eviction_time_in_min", null)
      http2_enabled                                 = lookup(var.settings.site_config, "http2_enabled", null)
      load_balancing_mode                           = lookup(var.settings.site_config, "load_balancing_mode", null)
      local_mysql_enabled                           = lookup(var.settings.site_config, "local_mysql_enabled", null)
      managed_pipeline_mode                         = lookup(var.settings.site_config, "managed_pipeline_mode", null)
      minimum_tls_version                           = lookup(var.settings.site_config, "minimum_tls_version", "1.2")
      remote_debugging_enabled                      = lookup(var.settings.site_config, "remote_debugging_enabled", null)
      remote_debugging_version                      = lookup(var.settings.site_config, "remote_debugging_version", null)
      scm_minimum_tls_version                       = lookup(var.settings.site_config, "scm_minimum_tls_version", null)
      scm_use_main_ip_restriction                   = lookup(var.settings.site_config, "scm_use_main_ip_restriction", null)
      use_32_bit_worker                             = lookup(var.settings.site_config, "use_32_bit_worker", false)
      vnet_route_all_enabled                        = lookup(var.settings.site_config, "vnet_route_all_enabled", null)
      websockets_enabled                            = lookup(var.settings.site_config, "websockets_enabled", false)
      worker_count                                  = lookup(var.settings.site_config, "worker_count", null)

      dynamic "application_stack" {
        for_each = lookup(var.settings.site_config, "application_stack", {}) != {} ? [1] : []

        content {
          docker_image        = lookup(var.settings.site_config.application_stack, "docker_image", null)
          docker_image_tag    = lookup(var.settings.site_config.application_stack, "docker_image_tag", null)
          dotnet_version      = lookup(var.settings.site_config.application_stack, "dotnet_version", null)
          go_version          = lookup(var.settings.site_config.application_stack, "go_version", null)
          java_server         = lookup(var.settings.site_config.application_stack, "java_server", null)
          java_server_version = lookup(var.settings.site_config.application_stack, "java_server_version", null)
          node_version        = lookup(var.settings.site_config.application_stack, "node_version", null)
          php_version         = lookup(var.settings.site_config.application_stack, "php_version", null)
          python_version      = lookup(var.settings.site_config.application_stack, "python_version", null)
          ruby_version        = lookup(var.settings.site_config.application_stack, "ruby_version", null)
        }
      }
    
      dynamic "auto_heal_setting" {
        for_each = lookup(var.settings.site_config, "auto_heal_setting", {}) != {} ? [1] : []

        content {
          dynamic "action" {
            for_each = lookup(var.settings.site_config.auto_heal_setting, "action", {}) != {} ? [1] : []

            content {
              action_type = lookup(var.settings.site_config.auto_heal_setting.action, "action_type", null)
              minimum_process_execution_time = lookup(var.settings.site_config.auto_heal_setting.action, "minimum_process_execution_time", null)
            }
          }
          dynamic "trigger" {
            for_each = lookup(var.settings.site_config.auto_heal_setting, "trigger", {}) != {} ? [1] : []

            content {
              dynamic "requests" {
                for_each = lookup(var.settings.site_config.auto_heal_setting.trigger, "requests", {}) != {} ? [1] : []
                
                content {
                  count    = lookup(var.settings.site_config.auto_heal_setting.trigger.requests, "count", null)
                  interval = lookup(var.settings.site_config.auto_heal_setting.trigger.requests, "interval", null)
                }
              }

              dynamic "slow_request" {
                for_each = try(var.settings.site_config.auto_heal_setting.trigger.slow_request, {})
                
                content {
                  count      = lookup(slow_request, "count", null)
                  interval   = lookup(slow_request, "interval", null)
                  time_taken = lookup(slow_request, "time_taken", null)
                  path       = lookup(slow_request, "path", null)
                }
              }

              dynamic "status_code" {
                for_each = try(var.settings.site_config.auto_heal_setting.trigger.status_code, {})
                
                content {
                  count             = lookup(status_code, "count", null)
                  interval          = lookup(status_code, "interval", null)
                  status_code_range = lookup(status_code, "status_code_range", null)
                  path              = lookup(status_code, "path", null)
                  sub_status        = lookup(status_code, "sub_status", null)
                  win32_status      = lookup(status_code, "win32_status", null)
                }
              }
            }
          }
        }
      }

      dynamic "cors" {
        for_each = lookup(var.settings.site_config, "cors", {}) != {} ? [1] : []

        content {
          allowed_origins     = lookup(var.settings.site_config.cors, "allowed_origins", null)
          support_credentials = lookup(var.settings.site_config.cors, "support_credentials", null)
        }
      }

      dynamic "scm_ip_restriction" {
        for_each = try(var.settings.site_config.scm_ip_restriction, {})

        content {
          action                    = lookup(scm_ip_restriction.value, "action", null)
          ip_address                = lookup(scm_ip_restriction.value, "ip_address", null)
          name                      = lookup(scm_ip_restriction.value, "name", null)
          priority                  = lookup(scm_ip_restriction.value, "priority", null)
          service_tag               = lookup(scm_ip_restriction.value, "service_tag", null)
          virtual_network_subnet_id = can(scm_ip_restriction.value.virtual_network_subnet_id) || can(scm_ip_restriction.value.virtual_network_subnet.id) || can(scm_ip_restriction.value.virtual_network_subnet.subnet_key) == false ? try(scm_ip_restriction.value.virtual_network_subnet_id, scm_ip_restriction.value.virtual_network_subnet.id, null) : var.combined_objects.networking[try(scm_ip_restriction.value.virtual_network_subnet.lz_key, var.client_config.landingzone_key)][scm_ip_restriction.value.virtual_network_subnet.vnet_key].subnets[scm_ip_restriction.value.virtual_network_subnet.subnet_key].id
          dynamic "headers" {
            for_each = try(scm_ip_restriction.headers, {})

            content {
              x_azure_fdid      = lookup(headers.value, "x_azure_fdid", null)
              x_fd_health_probe = lookup(headers.value, "x_fd_health_probe", null)
              x_forwarded_for   = lookup(headers.value, "x_forwarded_for", null)
              x_forwarded_host  = lookup(headers.value, "x_forwarded_host", null)
            }
          }
        }
      }

      dynamic "ip_restriction" {
        for_each = try(var.settings.site_config.ip_restriction, {})

        content {
          action                    = lookup(ip_restriction.value, "action", null)
          ip_address                = lookup(ip_restriction.value, "ip_address", null)
          name                      = lookup(ip_restriction.value, "name", null)
          priority                  = lookup(ip_restriction.value, "priority", null)
          service_tag               = lookup(ip_restriction.value, "service_tag", null)
          virtual_network_subnet_id = can(ip_restriction.value.virtual_network_subnet_id) || can(ip_restriction.value.virtual_network_subnet.id) || can(ip_restriction.value.virtual_network_subnet.subnet_key) == false ? try(ip_restriction.value.virtual_network_subnet_id, ip_restriction.value.virtual_network_subnet.id, null) : var.combined_objects.networking[try(ip_restriction.value.virtual_network_subnet.lz_key, var.client_config.landingzone_key)][ip_restriction.value.virtual_network_subnet.vnet_key].subnets[ip_restriction.value.virtual_network_subnet.subnet_key].id
          dynamic "headers" {
            for_each = try(ip_restriction.headers, {})

            content {
              x_azure_fdid      = lookup(headers.value, "x_azure_fdid", null)
              x_fd_health_probe = lookup(headers.value, "x_fd_health_probe", null)
              x_forwarded_for   = lookup(headers.value, "x_forwarded_for", null)
              x_forwarded_host  = lookup(headers.value, "x_forwarded_host", null)
            }
          }
        }
      }
    }
  }

  app_settings = local.app_settings

  dynamic "connection_string" {
    for_each = try(var.settings.connection_strings, {})

    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  dynamic "sticky_settings" {
    for_each = lookup(var.settings, "sticky_settings", {}) != {} ? [1] : []

    content {
      app_setting_names       = lookup(var.settings.sticky_settings, "app_setting_names", false)
      connection_string_names = lookup(var.settings.sticky_settings, "connection_string_names", null)
    }
  }

  dynamic "auth_settings" {
    for_each = lookup(var.settings, "auth_settings", {}) != {} ? [1] : []

    content {
      enabled                        = lookup(var.settings.auth_settings, "enabled", false)
      allowed_external_redirect_urls = lookup(var.settings.auth_settings, "allowed_external_redirect_urls", null)
      default_provider               = lookup(var.settings.auth_settings, "default_provider", null)
      issuer                         = lookup(var.settings.auth_settings, "issuer", null)
      runtime_version                = lookup(var.settings.auth_settings, "runtime_version", null)
      token_refresh_extension_hours  = lookup(var.settings.auth_settings, "token_refresh_extension_hours", null)
      token_store_enabled            = lookup(var.settings.auth_settings, "token_store_enabled", null)
      unauthenticated_client_action  = lookup(var.settings.auth_settings, "unauthenticated_client_action", null)

      dynamic "active_directory" {
        for_each = lookup(var.settings.auth_settings, "active_directory", {}) != {} ? [1] : []

        content {
          client_id         = can(var.settings.auth_settings.active_directory.client_id_key) ? var.azuread_applications[try(var.settings.auth_settings.active_directory.client_id_lz_key, var.client_config.landingzone_key)][var.settings.auth_settings.active_directory.client_id_key].client_id : var.settings.auth_settings.active_directory.client_id
          client_secret     = can(var.settings.auth_settings.active_directory.client_secret_key) ? var.azuread_service_principal_passwords[try(var.settings.auth_settings.active_directory.client_secret_lz_key, var.client_config.landingzone_key)][var.settings.auth_settings.active_directory.client_secret_key].service_principal_password : try(var.settings.auth_settings.active_directory.client_secret, null)
          allowed_audiences = lookup(var.settings.auth_settings.active_directory, "allowed_audiences", null)
        }
      }

      dynamic "facebook" {
        for_each = lookup(var.settings.auth_settings, "facebook", {}) != {} ? [1] : []

        content {
          app_id       = var.settings.auth_settings.facebook.app_id
          app_secret   = var.settings.auth_settings.facebook.app_secret
          oauth_scopes = lookup(var.settings.auth_settings.facebook, "oauth_scopes", null)
        }
      }

      dynamic "google" {
        for_each = lookup(var.settings.auth_settings, "google", {}) != {} ? [1] : []

        content {
          client_id     = var.settings.auth_settings.google.client_id
          client_secret = var.settings.auth_settings.google.client_secret
          oauth_scopes  = lookup(var.settings.auth_settings.google, "oauth_scopes", null)
        }
      }

      dynamic "microsoft" {
        for_each = lookup(var.settings.auth_settings, "microsoft", {}) != {} ? [1] : []

        content {
          client_id     = var.settings.auth_settings.microsoft.client_id
          client_secret = var.settings.auth_settings.microsoft.client_secret
          oauth_scopes  = lookup(var.settings.auth_settings.microsoft, "oauth_scopes", null)
        }
      }

      dynamic "twitter" {
        for_each = lookup(var.settings.auth_settings, "twitter", {}) != {} ? [1] : []

        content {
          consumer_key    = var.settings.auth_settings.twitter.consumer_key
          consumer_secret = var.settings.auth_settings.twitter.consumer_secret
        }
      }
    }
  }

  dynamic "auth_settings_v2" {
    for_each = lookup(var.settings, "auth_settings_v2", {}) != {} ? [1] : []

    content {
      config_file_path                        = lookup(var.settings.auth_settings_v2, "config_file_path", null)
      default_provider                        = lookup(var.settings.auth_settings_v2, "default_provider", null)
      runtime_version                         = lookup(var.settings.auth_settings_v2, "runtime_version", null)
      require_authentication                  = lookup(var.settings.auth_settings_v2, "require_authentication", null)
      unauthenticated_action                  = lookup(var.settings.auth_settings_v2, "unauthenticated_action", null)
      excluded_paths                          = lookup(var.settings.auth_settings_v2, "excluded_paths", null)
      require_https                           = lookup(var.settings.auth_settings_v2, "require_https", null)
      http_route_api_prefix                   = lookup(var.settings.auth_settings_v2, "http_route_api_prefix", null)
      forward_proxy_convention                = lookup(var.settings.auth_settings_v2, "forward_proxy_convention", null)
      forward_proxy_custom_host_header_name   = lookup(var.settings.auth_settings_v2, "forward_proxy_custom_host_header_name", null)
      forward_proxy_custom_scheme_header_name = lookup(var.settings.auth_settings_v2, "forward_proxy_custom_scheme_header_name", null)

      dynamic "login" {
        for_each = lookup(var.settings.auth_settings_v2, "login", {}) != {} ? [1] : []

        content {
          logout_endpoint = lookup(var.settings.auth_settings_v2.login, "logout_endpoint", null)
          token_store_enabled = lookup(var.settings.auth_settings_v2.login, "token_store_enabled", null)
          token_refresh_extension_time = lookup(var.settings.auth_settings_v2.login, "token_refresh_extension_time", null)
          token_store_path = lookup(var.settings.auth_settings_v2.login, "token_store_path", null)
          token_store_sas_setting_name = lookup(var.settings.auth_settings_v2.login, "token_store_sas_setting_name", null)
          preserve_url_fragments_for_logins = lookup(var.settings.auth_settings_v2.login, "preserve_url_fragments_for_logins", null)
          allowed_external_redirect_urls = lookup(var.settings.auth_settings_v2.login, "allowed_external_redirect_urls", null)
          cookie_expiration_convention = lookup(var.settings.auth_settings_v2.login, "cookie_expiration_convention", null)
          cookie_expiration_time = lookup(var.settings.auth_settings_v2.login, "cookie_expiration_time", null)
          validate_nonce = lookup(var.settings.auth_settings_v2.login, "validate_nonce", null)
          nonce_expiration_time = lookup(var.settings.auth_settings_v2.login, "nonce_expiration_time", null)
        }
      } 
      # Implement the following login methods when needed
      # apple_v2
      # active_directory_v2
      # azure_static_web_app_v2
      # custom_oidc_v2
      # facebook_v2
      # github_v2
      # google_v2
      # microsoft_v2
      # twitter_v2
    }
  }

  dynamic "storage_account" {
    for_each = lookup(var.settings, "storage_account", [])
    content {
      name         = storage_account.value.name
      type         = storage_account.value.type
      account_name = can(storage_account.value.account_key) ? var.storage_accounts[try(storage_account.value.lz_key, var.client_config.landingzone_key)][storage_account.value.account_key].name : try(storage_account.value.account_name, null)
      share_name   = storage_account.value.share_name
      access_key   = can(storage_account.value.account_key) ? var.storage_accounts[try(storage_account.value.lz_key, var.client_config.landingzone_key)][storage_account.value.account_key].primary_access_key : try(storage_account.value.access_key, null)
      mount_path   = lookup(storage_account.value, "mount_path", null)
    }
  }

  dynamic "backup" {
    for_each = lookup(var.settings, "backup", {}) != {} ? [1] : []

    content {
      name                = var.settings.backup.name
      enabled             = var.settings.backup.enabled
      storage_account_url = try(var.settings.backup.storage_account_url, local.backup_sas_url)

      dynamic "schedule" {
        for_each = lookup(var.settings.backup, "schedule", {}) != {} ? [1] : []

        content {
          frequency_interval       = var.settings.backup.schedule.frequency_interval
          frequency_unit           = lookup(var.settings.backup.schedule, "frequency_unit", null)
          keep_at_least_one_backup = lookup(var.settings.backup.schedule, "keep_at_least_one_backup", null)
          start_time               = lookup(var.settings.backup.schedule, "start_time", null)
        }
      }
    }
  }

  dynamic "logs" {
    for_each = lookup(var.settings, "logs", {}) != {} ? [1] : []

    content {
      detailed_error_messages = try(var.settings.logs.detailed_error_messages, null)
      failed_request_tracing = try(var.settings.logs.failed_request_tracing, null)

      dynamic "application_logs" {
        for_each = lookup(var.settings.logs, "application_logs", {}) != {} ? [1] : []

        content {
          file_system_level = try(var.settings.logs.application_logs.file_system_level, null)

          dynamic "azure_blob_storage" {
            for_each = lookup(var.settings.logs.application_logs, "azure_blob_storage", {}) != {} ? [1] : []

            content {
              level             = var.settings.logs.application_logs.azure_blob_storage.level
              sas_url           = try(var.settings.logs.application_logs.azure_blob_storage.sas_url, local.logs_sas_url)
              retention_in_days = var.settings.logs.application_logs.azure_blob_storage.retention_in_days
            }
          }
        }
      }

      dynamic "http_logs" {
        for_each = lookup(var.settings.logs, "http_logs", {}) != {} ? [1] : []

        content {
          dynamic "azure_blob_storage" {
            for_each = lookup(var.settings.logs.http_logs, "azure_blob_storage", {}) != {} ? [1] : []

            content {
              sas_url           = try(var.settings.logs.http_logs.azure_blob_storage.sas_url, local.http_logs_sas_url)
              retention_in_days = var.settings.logs.http_logs.azure_blob_storage.retention_in_days
            }
          }
          dynamic "file_system" {
            for_each = lookup(var.settings.logs.http_logs, "file_system", {}) != {} ? [1] : []

            content {
              retention_in_days = var.settings.logs.http_logs.file_system.retention_in_days
              retention_in_mb   = var.settings.logs.http_logs.file_system.retention_in_mb
            }
          }
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"]
    ]
  }
}
