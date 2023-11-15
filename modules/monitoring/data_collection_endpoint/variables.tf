variable "global_settings" {
  description = "Global settings object (see module README.md)"
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
  description = "The name of the resource group in which to create the data collection endpoint."
}
variable "location" {
  description = "The location in which to create the data collection endpoint."

}

