output "builder_summary" {
  description = "Resumen del proceso de construcción y los pasos ejecutados."
  value = {
    step1_initialize_env = var.step1_initialize_env_enabled ? {
      status  = "Ejecutado"
      details = length(null_resource.step1_initialize_env) > 0 ? null_resource.step1_initialize_env[0].triggers : null
    } : {
      status  = "Omitido"
      details = null
    }
    step2_configure_network = var.step2_configure_network_enabled ? {
      status  = "Ejecutado"
      details = length(null_resource.step2_configure_network) > 0 ? null_resource.step2_configure_network[0].triggers : null
    } : {
      status  = "Omitido"
      details = null
    }
    step3_deploy_app = var.step3_deploy_app_enabled ? {
      status  = "Ejecutado"
      details = length(null_resource.step3_deploy_app) > 0 ? null_resource.step3_deploy_app[0].triggers : null
    } : {
      status  = "Omitido"
      details = null
    }
  }
}

output "final_message" {
  description = "Un mensaje indicando el estado general."
  value = join(" -> ", compact(concat(
    var.step1_initialize_env_enabled ? ["Entorno Inicializado"] : [],
    var.step2_configure_network_enabled ? ["Red Configurada"] : [],
    var.step3_deploy_app_enabled ? ["App Desplegada"] : []
  )))
}

output "builder_deployment_info" {
  description = "Information about the builder deployment context."
  value = {
    project_id = var.project_identifier
    region     = var.deployment_region
  }
}