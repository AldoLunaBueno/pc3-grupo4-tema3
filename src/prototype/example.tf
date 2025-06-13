resource "null_resource" "mi_clon"{
    triggers = {
        env   = "entorno_basico"
    }
}