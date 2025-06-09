# Patron Factory

Encapsula la logica de creacion de modulos, centraliza su instanciacion a base de los parametros que requiera el recurso

## Variables

```json
variable "resource_type" {
  type        = string
  description = "Tipo de recurso a crear ('local', 'web', 'VM')."
  default     = "local"
}
```

```json
variable "product_count" {
  type        = number
  description = "Cantidad de recursos a crear."
  default     = 1
}
```

