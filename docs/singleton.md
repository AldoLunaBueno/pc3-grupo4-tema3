# Patron Singleton

Permite que un modulo o recurso solo se instancie una unica vez, y se tenga control a nivel global.

## Variables

```json
variable "instance_name" {
  type        = string
  description = "Nombre de la instancia."
  default     = ""
}
```

```json
variable "count" {
  type        = bool
  description = "Permite crear la instancia."
  default     = false # no existe la instancia, por lo que se crea
}
```

