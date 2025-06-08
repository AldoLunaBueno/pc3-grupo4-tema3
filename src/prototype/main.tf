resource "null_resource" "clone_generator" {
  clone_count = var.count

  triggers = {
    config   = var.clon_config
    clone_id = count.index
  }
}