# Paso 1: Inicializar el entorno
resource "null_resource" "step1_initialize_env" {
  # count = 1 si var.step1_initialize_env_enabled es true, 0 si es false
  count = var.step1_initialize_env_enabled ? 1 : 0

  triggers = {
    action      = "Initialize Environment"         // Acción que realiza el paso
    name        = var.step1_config.name            // Nombre del entorno desde la variable de configuración
    type        = var.step1_config.type            // Tipo de entorno desde la variable de configuración
    timestamp   = timestamp()                      // Marca de tiempo para forzar la re-ejecución si es necesario
  }
}

# Paso 2: Configurar la red
resource "null_resource" "step2_configure_network" {
  count = var.step2_configure_network_enabled ? 1 : 0

  triggers = {
    action       = "Configure Network"
    cidr_block   = var.step2_config.cidr_block
    subnet_count = var.step2_config.subnet_count
    timestamp    = timestamp()
  }

  # Este paso depende de que el paso 1 se haya completado (o intentado, si estaba habilitado)
  depends_on = [
    null_resource.step1_initialize_env
  ]
}

# Paso 3: Desplegar la aplicación
resource "null_resource" "step3_deploy_app" {
  count = var.step3_deploy_app_enabled ? 1 : 0

  triggers = {
    action      = "Deploy Application"
    app_name    = var.step3_config.app_name
    app_version = var.step3_config.app_version
    timestamp   = timestamp()
  }

  # depende del paso 2
  depends_on = [
    null_resource.step2_configure_network
  ]
}