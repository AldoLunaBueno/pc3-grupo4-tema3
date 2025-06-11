resource "null_resource" "clone_generator" {
  triggers = {
    config   = var.clon_config
  }
}