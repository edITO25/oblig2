data "azurerm_client_config" "current" {}

locals {
  tags = {
    eier  = var.kortnavn
    miljo = var.miljo
    kurs  = "dcst3005-oblig2"
  }

#Azure ID-er
  subscription_scope  = join("/", ["", "subscriptions", data.azurerm_client_config.current.subscription_id])
  resource_group_name = "rg-${var.kortnavn}-oblig2-${var.miljo}"
  vnet_name           = "vnet-${var.kortnavn}-${var.miljo}"

  resource_group_id = format("%s/resourceGroups/%s", local.subscription_scope, local.resource_group_name)
  vnet_id           = format("%s/providers/Microsoft.Network/virtualNetworks/%s", local.resource_group_id, local.vnet_name)
}

resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.tags
}

module "vnet" {
  source              = "../../modules/vnet"
  name                = local.vnet_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = var.address_space
  tags                = local.tags
}

import {
  to = azurerm_resource_group.this
  id = local.resource_group_id
}

import {
  to = module.vnet.azurerm_virtual_network.this
  id = local.vnet_id
}