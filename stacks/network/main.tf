# Nettverkslaget for ALLE tjenestene: ressursgruppa, VNet-et, og ett subnett
# med NSG per tjeneste.

data "azurerm_client_config" "current" {}

locals {
  resource_group_name = "rg-${var.kortnavn}-oblig2-${var.miljo}"
  vnet_name           = "vnet-${var.kortnavn}-${var.miljo}"
  subscription_scope  = join("/", ["", "subscriptions", data.azurerm_client_config.current.subscription_id])
}

removed {
  from = azurerm_resource_group.this

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.vnet.azurerm_virtual_network.this

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.subnet

  lifecycle {
    destroy = false
  }
}
