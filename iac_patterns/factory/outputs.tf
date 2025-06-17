output "product_details" {
  description = "Detalles del recurso creado por la fábrica."
  value = {
    type_created = var.factory_type
    #  si el recurso no fue creado usamos try 
    id = try(
      one(
        concat(
          local_file.product_file.*.id,
          random_id.product_id.*.id
        )
      ), 
      "N/A (recurso no creado para este tipo)"
    )
    details = try(
      one(
        concat(
          [for f in local_file.product_file : "Archivo creado en: ${f.filename}"],
          [for r in random_id.product_id : "ID aleatorio (hex): ${r.hex}"]
        )
      ),
      "N/A (recurso no creado para este tipo)"
    )
  }
}
