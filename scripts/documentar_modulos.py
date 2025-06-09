import os
import re

"""
Generador de documentación para los patrones de diseño en IaC
y listado de variables básicas que utilizarán.
	1. Builder
	2. Composite
	3. Factory
	4. Prototype
	5. Singleton
"""
# verifica si la carpeta docs
if not os.path.exists("../docs"):
	os.makedirs("docs")

# dirección donde buscara archivos
path = "../src"

# enlista todos los nombres de los archivos dentro de path
dir_list = os.listdir(path)

# descripción breve de cada patrón
descripciones = {
	"builder": "Permite construir configuraciones complejas paso a paso para facilitar reproductibilidad  de recursos grandes",

	"composite": "Trata de forma jerarquica multiples recursos como una unica unidad logica",

	"factory": "Encapsula la logica de creacion de modulos, centraliza su instanciacion a base de los parametros que requiera el recurso",

	"prototype": "Crea modulos o recursos predefinidos a partir de una plantilla, y replica esto para diferentes clones.",

	"singleton": "Permite que un modulo o recurso solo se instancie una unica vez, y se tenga control a nivel global."

}

for carpeta in dir_list:
	# actualizar ruta = ../src/<patron>
	carpeta_path = os.path.join(path, carpeta)
	# ruta de variables = ruta_anterior/variables.tf para cada patron
	vars_path = os.path.join(carpeta_path, "variables.tf")

	if os.path.exists(vars_path):
		with open(vars_path, "r") as vars:
			content = vars.read()

			variables = re.findall(r'(variable\s+"[\w_]+"\s*{[^}]*})', content)
			"""
			Patron de busqueda:
			variable "<nombre>" {
			<cualquier-texto>
			}
			"""

	with open(f"../docs/{carpeta}.md", "w") as doc:

		doc.write(f"# Patron {carpeta.capitalize()}\n\n")
		doc.write(f"{descripciones.get(carpeta)}\n\n")
		doc.write("## Variables\n\n")
		
		for variable in variables:
			doc.write("```json\n")
			doc.write(f"{variable}\n")
			doc.write("```\n\n")