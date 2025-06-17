variable "step1_initialize_env_enabled" {
  type        = bool
  description = "Habilitar paso 1: Inicializar entorno base."
  default     = true // Por defecto, este paso está habilitado
}

variable "step1_config" {
  type        = map(string)
  description = "Configuración para el paso 1."
  default     = {
    name = "BaseEnvironment" // Nombre del entorno base
    type = "Development"     // Tipo de entorno
  }
}

variable "step2_configure_network_enabled" {
  type        = bool
  description = "Habilitar paso 2: Configurar la red."
  default     = true // Por defecto, este paso está habilitado
}

variable "step2_config" {
  type        = map(string)
  description = "Configuración para el paso 2."
  default     = {
    cidr_block   = "10.0.0.0/16" // Bloque CIDR para la red
    subnet_count = "2"           // Cantidad de subredes (como string para el mapa, Terraform lo convierte si es necesario)
  }
}

variable "step3_deploy_app_enabled" {
  type        = bool
  description = "Habilitar paso 3: Desplegar la aplicación."
  default     = false // Por defecto, este paso está deshabilitado para el ejemplo
}

variable "step3_config" {
  type        = map(string)
  description = "Configuración para el paso 3."
  default     = {
    app_name    = "MyWebApp"    // Nombre de la aplicación
    app_version = "v1.0.2"      // Versión de la aplicación
  }
}