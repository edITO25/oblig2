variable "kortnavn" {
  description = "Kortnavnet ditt. Settes i config/felles.tfvars."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{2,10}$", var.kortnavn))
    error_message = "kortnavn må være 2–10 små bokstaver eller tall. Sett det i config/felles.tfvars."
  }
}

variable "location" {
  description = "Azure-regionen. Settes i config/felles.tfvars."
  type        = string
}

variable "miljo" {
  description = "Miljøet. Settes av scripts/kjor.sh (TF_VAR_miljo), ikke i en .tfvars-fil."
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.miljo)
    error_message = "miljo må være dev eller prod."
  }
}

variable "tjeneste" {
  description = "Tjenesten denne state-instansen eier."
  type        = string
}

variable "prefix" {
  description = "Adresseområdet til tjenestens subnett."
  type        = string
}

variable "runtime" {
  description = "Kjøremiljøet: vm eller webapp."
  type        = string

  validation {
    condition     = contains(["vm", "webapp"], var.runtime)
    error_message = "Kjøremiljøet må være vm eller webapp."
  }
}

variable "allow_http_from" {
  description = "Hvem som får nå tjenestene på port 80."
  type        = string
  default     = "Internet"
}
