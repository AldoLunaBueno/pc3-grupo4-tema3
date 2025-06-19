# Recurso que genera un nombre aleatorio
resource "random_pet" "mi_clon" {
  length = 2
  separator = "-"
}

# Recurso general nulo
resource "null_resource" "mi_clon" {
  triggers = {
    env = "entorno_basico"
    pet_id = random_pet.mi_clon.id
  }

  provisioner "local-exec" {
    command = "echo 'Creando un clon con nombre mi_clon'"
  }
}

output "mi_clon_info"{
    value = {
        env = "entorno_basico"
        pet_name = random_pet.mi_clon.id
    }
}