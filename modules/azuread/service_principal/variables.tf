variable "global_settings" {
  default = {}
}
variable "settings" {
  default = {}
}
variable "client_config" {
  description = "Client configuration object (see module README.md)."
}
variable "client_id" {
  description = "Client ID of the service principal to create."
}
variable "azuread_api_permissions" {
  default = {}
}
variable "user_type" {}
