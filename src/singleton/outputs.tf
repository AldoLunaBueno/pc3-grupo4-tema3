output "create_instance" {
  value       = val.cantidad ? "Instancia ${var.nombre} creada con exito." : "Instancia ya creada."
  description = "Estado de creación de la istancia global."
}