variable "global_settings" {
  description = "Global settings object (see module README.md)"
}
variable "client_config" {
  description = "Client configuration object (see module README.md)."
}
variable "settings" {
  description = "(Required) Used to handle passthrough parameters."
}
variable "base_tags" {
  description = "Base tags for the resource to be inherited from the resource group."
  type        = map(any)
  default     = {}
}
variable "resource_group_name" {
  description = " The name of the resource group in which to create the private link scoped service instance."
}
variable "linked_log_analytics_id" {
  description = "(Required) The ID of the linked resource. It must be the Log Analytics workspace. Changing this forces a new resource to be created."
}
variable "linked_data_collection_endpoint_id" {
  description = "(Required) The ID of the linked resource. It must be the Data Collection endpoint. Changing this forces a new resource to be created."
}
variable "vnets" {}
variable "virtual_subnets" {}
variable "private_endpoints" {
  description = "The private endpoints settings. Usually a single one per region for a centralise monitoring solution."
}
variable "resource_groups" {}
variable "private_dns" {
  default = {}
}