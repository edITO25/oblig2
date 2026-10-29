output "resource_group_name" {
  description = "Ressursgruppa alle stackene bruker."
  value       = local.resource_group_name
}

output "location" {
  description = "Regionen alt står i."
  value       = var.location
}

output "vnet_name" {
  description = "Navnet på VNet-et."
  value       = local.vnet_name
}

output "subnet_ids" {
  description = "Subnett-ID per tjeneste."
  value = {
    for navn, tjeneste in var.tjenester :
    navn => format(
      "%s/resourceGroups/%s/providers/Microsoft.Network/virtualNetworks/%s/subnets/snet-%s",
      local.subscription_scope,
      local.resource_group_name,
      local.vnet_name,
      navn
    )
  }
}
