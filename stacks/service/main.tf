data "azurerm_client_config" "current" {}

locals {
  tags = {
    eier  = var.kortnavn
    miljo = var.miljo
    kurs  = "dcst3005-oblig2"
  }

  subscription_scope  = join("/", ["", "subscriptions", data.azurerm_client_config.current.subscription_id])
  resource_group_name = "rg-${var.kortnavn}-oblig2-${var.miljo}"
  vnet_name           = "vnet-${var.kortnavn}-${var.miljo}"
  resource_group_id   = format("%s/resourceGroups/%s", local.subscription_scope, local.resource_group_name)
  vnet_id             = format("%s/providers/Microsoft.Network/virtualNetworks/%s", local.resource_group_id, local.vnet_name)

  subnet_name = "snet-${var.tjeneste}"
  nsg_name    = "nsg-${var.tjeneste}"
  subnet_id   = format("%s/subnets/%s", local.vnet_id, local.subnet_name)
  nsg_id      = format("%s/providers/Microsoft.Network/networkSecurityGroups/%s", local.resource_group_id, local.nsg_name)
  rule_id     = format("%s/securityRules/allow-http", local.nsg_id)

  storage_name  = "st${var.kortnavn}${var.tjeneste}${var.miljo}"
  storage_id    = format("%s/providers/Microsoft.Storage/storageAccounts/%s", local.resource_group_id, local.storage_name)
  keyvault_name = "kv-${var.kortnavn}-${var.tjeneste}-${var.miljo}"
  keyvault_id   = format("%s/providers/Microsoft.KeyVault/vaults/%s", local.resource_group_id, local.keyvault_name)
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

import {
  for_each = toset([var.tjeneste])
  to       = module.subnet[each.key].azurerm_subnet.this
  id       = local.subnet_id
}

import {
  for_each = toset([var.tjeneste])
  to       = module.subnet[each.key].azurerm_network_security_group.this
  id       = local.nsg_id
}

import {
  for_each = toset([var.tjeneste])
  to       = module.subnet[each.key].azurerm_network_security_rule.http
  id       = local.rule_id
}

import {
  for_each = toset([var.tjeneste])
  to       = module.subnet[each.key].azurerm_subnet_network_security_group_association.this
  id       = local.subnet_id
}

import {
  for_each = toset([var.tjeneste])
  to       = module.storage[each.key].azurerm_storage_account.this
  id       = local.storage_id
}

import {
  for_each = toset([var.tjeneste])
  to       = module.keyvault[each.key].azurerm_key_vault.this
  id       = local.keyvault_id
}
