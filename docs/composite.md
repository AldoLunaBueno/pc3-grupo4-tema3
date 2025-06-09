# Patron Composite

Trata de forma jerarquica multiples recursos como una unica unidad logica

## Variables

```json
variable "parent_name" {
  type        = string
  description = "Nombre del recurso padre"
  default     = "Padre"
}
```

```json
variable "child_count" {
  type        = number
  description = "Cantidad de recursos hijo a crear."
  default     = 5
}
```

