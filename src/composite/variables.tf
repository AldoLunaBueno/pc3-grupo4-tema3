variable "parent_name" {
  type        = string
  description = "Nombre del recurso padre"
  default     = "Padre"
}

variable "child_count" {
  type        = number
  description = "Cantidad de recursos hijo a crear."
  default     = 5
}