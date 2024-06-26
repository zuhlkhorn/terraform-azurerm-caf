output "id" {
  value = azurerm_role_definition.custom_role.id

}

output "role_definition_resource_id" {
  value = azurerm_role_definition.custom_role.role_definition_resource_id

}

output "role_definition_name" {
  value = azurecaf_name.custom_role.result

}