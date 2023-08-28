
output "id" {
  value       = azurerm_virtual_network.vnet.id
  description = "Virtual Network id"
}

output "name" {
  value       = azurerm_virtual_network.vnet.name
  description = "Virtual Network name"
}

output "address_space" {
  value       = azurerm_virtual_network.vnet.address_space
  description = "Virtual Network address_space"
}

output "dns_servers" {
  value       = azurerm_virtual_network.vnet.dns_servers
  description = "Virtual Network dns_servers"
}

output "resource_group_name" {
  value       = azurerm_virtual_network.vnet.resource_group_name
  description = "Virtual Network resource_group_name"

}

output "location" {
  value       = local.location
  description = "Azure region of the virtual network"
}

output "subnets" {
  description = "Returns all the subnets objects in the Virtual Network. As a map of keys, ID"
  value       = merge(module.special_subnets, module.subnets)

}