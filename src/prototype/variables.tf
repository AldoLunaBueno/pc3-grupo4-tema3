variable "clon_config" {
  type        = string
  description = "Prototipo general de cada clon"
  default     = "clon-v1"
}

variable "counter" {
  type        = number
  description = "Número de clones a crear."
  default     = 2
}