resource "null_resource" "instance" {

  triggers = {
    instance_name = var.instance_name
    instance_type = var.instance_type
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    # script que no permite la creación de multiples instancias
    command = "./scripts/singleton.sh"
  }

}