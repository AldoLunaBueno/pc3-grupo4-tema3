resource "local_file" "prototype_generator" {
  content  = data.template_file.prototype.rendered
  filename = "${path.module}/example.tf"
}

data "template_file" "prototype_template" {
  template = file("${path.module}/templates/prototype.hcl.tpl")
  vars = {
    name = var.name
    env  = var.env
  }
}