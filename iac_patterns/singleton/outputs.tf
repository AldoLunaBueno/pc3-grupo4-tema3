output "create_instance" {
  # 1: true , 0: false
  value       = var.instance_enabled ? "Recurso ${var.instance_name} creada con exito." : "Instancia deshabilitada."
  description = "Estado de creación."
}

output "singleton_status" {
  value = {
    enabled = var.instance_enabled
    name    = var.instance_name
    type    = var.instance_type
  }
  description = "Estado actual del modulo singleton."
}