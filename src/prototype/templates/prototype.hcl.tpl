resource "null_resource" "${name}"{
    triggers = {
        env   = "${env}"
    }
}