resource "null_resource" "env_builder" {
  triggers = {
    env_name = var.env_name
    env_type   = var.env_type
    env_count       = var.env_count
    total          = "Crear ${env_count} ${env_name}-${env_type}"
  }
}