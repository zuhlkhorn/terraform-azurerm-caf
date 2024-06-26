
resource "azurecaf_name" "custom_role" {
  name          = var.custom_role.name
  resource_type = "azurerm_role_definition"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_role_definition" "custom_role" {
  name = azurecaf_name.custom_role.result

  # TODO: refactor scope to include other scopes like RG, resources.
  scope       = lookup(var.custom_role, "scope", var.subscription_primary)
  description = var.custom_role.description

  permissions {
    actions          = lookup(var.custom_role.permissions, "actions", [])
    not_actions      = lookup(var.custom_role.permissions, "not_actions", [])
    data_actions     = lookup(var.custom_role.permissions, "data_actions", [])
    not_data_actions = lookup(var.custom_role.permissions, "not_data_actions", [])
  }

  # As recommended by the provider, we're assigning the `scope` object_id as the first
  # entry for `assignable_scopes`
  # Also, the distinct function will avoid duplicating entries
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition#scope
  assignable_scopes = distinct(concat([lookup(var.custom_role, "scope", var.subscription_primary)], var.assignable_scopes))

}