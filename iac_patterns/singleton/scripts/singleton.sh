#!/bin/bash

# === Setup ===
LOCK_FILE="instance.lock"
# archivo temporal para guardar el PID
PID_FILE="/tmp/singleton_instance.pid"
# =============

# === Execute ===
# Verifica que exista un proceso
if [ -f "$PID_FILE" ]; then
    echo "Ya existe una instancia ejecutándose."
    exit 1
fi

# Guardar el PID actual en el archivo PID
echo $$ > "$PID_FILE"

# Sino existe la instancia, la crea. Si existe, ya no se crea. (Singleton)
if [ ! -f "$LOCK_FILE" ]; then
    touch "$LOCK_FILE"
    echo "Instancia creada: $LOCK_FILE"
else
    echo "La instancia ya existe: $LOCK_FILE"
fi
# ===============

# === Teardown ===
# Elimina el archivo PID
rm -f "$PID_FILE"
# ===============
