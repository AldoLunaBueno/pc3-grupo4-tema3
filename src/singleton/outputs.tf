output "create_instance" {
  value       = var.counter ? "Instancia ${var.instance_name} creada con exito." : "Instancia ya creada."
  description = "Estado de creación de la istancia global."
}