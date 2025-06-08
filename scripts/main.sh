#!/usr/bin/env bash
# main.sh 

# parsear parametros
mostrar_ayuda() {
  echo "Uso: $0 -p <patrón>"
  echo "Opciones:"
  echo "  -p  patrón a ejecutar (singleton, factory, etc.)"
  echo "  -h  muestra esta ayuda"
}

PATRON=""

while getopts "p:h" opcion; do
  case $opcion in
    p) PATRON="$OPTARG" ;;
    h) mostrar_ayuda; exit 0 ;;
    *) mostrar_ayuda; exit 1 ;;
  esac
done

if [[ -z "$PATRON" ]]; then
  echo "Error: falta el parámetro -p con el nombre del patrón"
  mostrar_ayuda
  exit 1
fi

# invocar modulo
MODULO="./$PATRON/run.sh"

if [[ -x "$MODULO" ]]; then
  "$MODULO"
else
  echo "No se encontró el módulo '$PATRON'"
  exit 1
fi
