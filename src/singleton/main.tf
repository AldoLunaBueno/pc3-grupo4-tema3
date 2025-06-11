resource "null_resource" "Instance_object" {

  triggers = {
    instance_name = var.instance_name
  }
}