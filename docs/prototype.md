# Patron Prototype

Crea modulos o recursos predefinidos a partir de una plantilla, y replica esto para diferentes clones.

## Variables

```json
variable "clon_config" {
  type        = string
  description = "Prototipo general de cada clon"
  default     = "clon-v1"
}
```

```json
variable "counter" {
  type        = number
  description = "Número de clones a crear."
  default     = 2
}
```

