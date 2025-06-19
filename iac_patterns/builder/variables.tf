variable "step1_initialize_env_enabled" {
  type    = bool
  default = true
}

variable "step1_config" {
  type    = map(string)
  default = {
    name = "BaseEnvironment"
    type = "Development"
  }
}

variable "step2_configure_network_enabled" {
  type    = bool
  default = true
}

variable "step2_config" {
  type    = map(string)
  default = {
    cidr_block   = "10.0.0.0/16"
    subnet_count = "2"
  }
}

variable "step3_deploy_app_enabled" {
  type    = bool
  default = false
}

variable "step3_config" {
  type    = map(string)
  default = {
    app_name    = "MyWebApp"
    app_version = "v1.0.2"
  }
}

variable "project_identifier" {
  type        = string
  description = "A unique identifier for the project."
  default     = "alpha-project"
}

variable "deployment_region" {
  type        = string
  description = "The target region for this builder deployment."
  default     = "us-east-1"
}