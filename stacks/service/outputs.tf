#fra network
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
  value       = { for navn, s in module.subnet : navn => s.subnet_id }
}
#fra data
output "storage_account_names" {
  description = "Storage account per tjeneste."
  value       = { for navn, s in module.storage : navn => s.name }
}

output "key_vault_names" {
  description = "Key Vault per tjeneste."
  value       = { for navn, k in module.keyvault : navn => k.name }
}
