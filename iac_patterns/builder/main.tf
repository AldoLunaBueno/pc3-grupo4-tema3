#Inicialización del entorno
resource "null_resource" "step1_initialize_env" {
  count = var.step1_initialize_env_enabled ? 1 : 0
  triggers = {
    action    = "Initialize Environment"
    name      = var.step1_config.name
    type      = var.step1_config.type
    timestamp = timestamp()
  }
}

#Configuración de red
resource "null_resource" "step2_configure_network" {
  count = var.step2_configure_network_enabled ? 1 : 0
  triggers = {
    action       = "Configure Network"
    cidr_block   = var.step2_config.cidr_block
    subnet_count = var.step2_config.subnet_count
    timestamp    = timestamp()
  }
  depends_on = [null_resource.step1_initialize_env]
}

#Despliegue de la aplicación
resource "null_resource" "step3_deploy_app" {
  count = var.step3_deploy_app_enabled ? 1 : 0
  triggers = {
    action      = "Deploy Application"
    app_name    = var.step3_config.app_name
    app_version = var.step3_config.app_version
    timestamp   = timestamp()
  }
  depends_on = [null_resource.step2_configure_network]
}