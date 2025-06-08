variable "env_name" {
  type        = string
  default     = "Ubuntu VM"
  description = "Nombre del entorno."
}

variable "env_type" {
  type        = string
  default     = "Ubuntu"
  description = "Tipo del entorno."
}

variable "env_count" {
  type        = number
  default     = 5
  description = "Cantidad de entornos a crear."
}