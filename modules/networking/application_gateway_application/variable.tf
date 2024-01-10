variable "settings" {}
variable "global_settings" {
  description = "Global settings object (see module README.md)"
}
variable "client_config" {
  description = "Client configuration object (see module README.md)."
}
variable "application_gateway" {}
variable "app_services_linux" {
  default = {}
}
# Left for a future implementation, when needed
# variable "app_services_windows" {
#   default = {}
# }
variable "keyvaults" {
  default = {}
}
variable "keyvault_certificates" {
  default = {}
}
variable "keyvault_certificate_requests" {
  default = {}
}
variable "application_gateway_waf_policies" {
  default = {}
}
