variable "factory_type" {
  type        = string
  description = "El tipo de producto a crear. Valores válidos: 'local_file' o 'random_id'."
  validation {
    condition     = contains(["local_file", "random_id"], var.factory_type)
    error_message = "El valor de factory_type debe ser 'local_file' o 'random_id'."
  }
}

variable "file_name" {
  type        = string
  description = "Nombre del archivo a crear si factory_type es 'local_file'."
  default     = "default.txt"
}

variable "file_content" {
  type        = string
  description = "Contenido del archivo a crear."
  default     = "Archivo por defecto."
}

variable "random_byte_length" {
  type        = number
  description = "Longitud en bytes para el ID aleatorio si factory_type es 'random_id'."
  default     = 8
}