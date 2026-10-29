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

#fra app
output "vm_public_ips" {
  description = "Offentlig IP per VM-tjeneste. Åpne http://<ip> for å se boot-id-en."
  value       = { for navn, v in module.vm : navn => v.public_ip }
}

output "webapp_hostnames" {
  description = "Adresse per web app-tjeneste."
  value       = { for navn, w in module.webapp : navn => w.hostname }
}
