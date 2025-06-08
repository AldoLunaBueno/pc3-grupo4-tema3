variable "instance_name" {
  type        = string
  description = "Nombre de la instancia."
  default     = ""
}

variable "count" {
  type        = bool
  description = "Permite crear la instancia."
  default     = false # no existe la instancia, por lo que se crea
}