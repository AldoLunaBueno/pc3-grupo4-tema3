resource "null_resource" "Instance_object" {

  validator = var.count ? 0 : 1

  triggers = {
    instance_name = var.instance_name
  }
}