# Patron Builder

Permite construir configuraciones complejas paso a paso para facilitar reproductibilidad  de recursos grandes

## Variables

```json
variable "env_name" {
  type        = string
  default     = "Ubuntu VM"
  description = "Nombre del entorno."
}
```

```json
variable "env_type" {
  type        = string
  default     = "Ubuntu"
  description = "Tipo del entorno."
}
```

```json
variable "env_count" {
  type        = number
  default     = 5
  description = "Cantidad de entornos a crear."
}
```

