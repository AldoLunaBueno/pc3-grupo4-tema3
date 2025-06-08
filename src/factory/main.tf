resource "null_resource" "product" {
  triggers = {
    type     = var.resource_type
    count = var.product_count
  }
}