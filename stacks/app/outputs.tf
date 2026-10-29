output "webapp_hostnames" {
  description = "Adresse per web app-tjeneste."
  value       = { for navn, w in module.webapp : navn => w.hostname }
}
