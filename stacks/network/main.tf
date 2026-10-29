# Nettverkslaget for ALLE tjenestene: ressursgruppa, VNet-et, og ett subnett
# med NSG per tjeneste.

locals {
  tags = {
    eier  = var.kortnavn
    miljo = var.miljo
    kurs  = "dcst3005-oblig2"
  }

  resource_group_name = "rg-${var.kortnavn}-oblig2-${var.miljo}"
  vnet_name           = "vnet-${var.kortnavn}-${var.miljo}"
}

module "subnet" {
  source   = "../../modules/subnet"
  for_each = var.tjenester

  service             = each.key
  resource_group_name = local.resource_group_name
  location            = var.location
  vnet_name           = local.vnet_name
  prefix              = each.value.prefix
  delegate_web        = each.value.runtime == "webapp"
  allow_http_from     = var.allow_http_from
  tags                = local.tags
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
