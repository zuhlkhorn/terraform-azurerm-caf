data "azurerm_management_group" "mg" {
  name = var.settings.management_group_id
}

resource "azurerm_management_group_subscription_association" "mg-association" {
  management_group_id = data.azurerm_management_group.mg.id
  subscription_id     = "/subscriptions/${try(azurerm_subscription.sub.0.subscription_id, var.settings.subscription_id)}"
}