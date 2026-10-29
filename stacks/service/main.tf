data "azurerm_client_config" "current" {}

locals {
  tags = {
    eier  = var.kortnavn
    miljo = var.miljo
    kurs  = "dcst3005-oblig2"
    keep  = "true"
  }

  subscription_scope  = join("/", ["", "subscriptions", data.azurerm_client_config.current.subscription_id])
  resource_group_name = "rg-${var.kortnavn}-oblig2-${var.miljo}"
  vnet_name           = "vnet-${var.kortnavn}-${var.miljo}"
  resource_group_id   = format("%s/resourceGroups/%s", local.subscription_scope, local.resource_group_name)
  vnet_id             = format("%s/providers/Microsoft.Network/virtualNetworks/%s", local.resource_group_id, local.vnet_name)

  subnet_name = "snet-${var.tjeneste}"
  subnet_id   = format("%s/subnets/%s", local.vnet_id, local.subnet_name)
}

module "subnet" {
  source = "../../modules/subnet"
  for_each = {
    (var.tjeneste) = {
      prefix  = var.prefix
      runtime = var.runtime
    }
  }

  service             = each.key
  resource_group_name = local.resource_group_name
  location            = var.location
  vnet_name           = local.vnet_name
  prefix              = each.value.prefix
  delegate_web        = each.value.runtime == "webapp"
  allow_http_from     = var.allow_http_from
  tags                = local.tags
}

module "storage" {
  source = "../../modules/storage"
  for_each = {
    (var.tjeneste) = var.tjeneste
  }

  service             = each.key
  kortnavn            = var.kortnavn
  miljo               = var.miljo
  resource_group_name = local.resource_group_name
  location            = var.location
  tags                = local.tags
}

module "keyvault" {
  source = "../../modules/keyvault"
  for_each = {
    (var.tjeneste) = var.tjeneste
  }

  service             = each.key
  kortnavn            = var.kortnavn
  miljo               = var.miljo
  resource_group_name = local.resource_group_name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = local.tags
}

#fra app
module "vm" {
  source   = "../../modules/vm"
  for_each = var.runtime == "vm" ? { (var.tjeneste) = var.runtime } : {}

  service             = each.key
  resource_group_name = local.resource_group_name
  location            = var.location
  subnet_id           = local.subnet_id
  size                = var.vm_size
  ssh_public_key      = var.ssh_public_key
  tags                = local.tags
}

module "webapp" {
  source   = "../../modules/webapp"
  for_each = var.runtime == "webapp" ? { (var.tjeneste) = var.runtime } : {}

  service             = each.key
  kortnavn            = var.kortnavn
  miljo               = var.miljo
  resource_group_name = local.resource_group_name
  location            = var.location
  subnet_id           = local.subnet_id
  sku                 = var.webapp_sku
  tags                = local.tags
}
