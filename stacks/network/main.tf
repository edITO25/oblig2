# Nettverkslaget for ALLE tjenestene: ressursgruppa, VNet-et, og ett subnett
# med NSG per tjeneste.

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
