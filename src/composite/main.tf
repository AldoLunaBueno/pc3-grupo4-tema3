resource "null_resource" "parent_resource" {
  triggers = {
    parent_name = var.parent_name
  }
}

resource "null_resource" "childs_resources" {
  count = var.child_count

  triggers = {
    id    = count.index
    parent = var.parent_name
  }
}