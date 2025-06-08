variable "resource_type" {
  type        = string
  description = "Tipo de recurso a crear ('local', 'web', 'VM')."
  default     = "local"
}

variable "product_count" {
  type        = number
  description = "Cantidad de recursos a crear."
  default     = 1
}