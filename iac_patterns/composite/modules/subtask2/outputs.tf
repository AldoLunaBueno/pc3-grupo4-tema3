output "task_name" {
  value = local.name
}

# Exportar cuántas instancias se crearon
output "subtask_count" {
  value = length(null_resource.subtask2)
}