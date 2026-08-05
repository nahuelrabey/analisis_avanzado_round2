#!/usr/bin/env bash

# Script para monitorear y compilar automáticamente los tres documentos Typst:
# - apuntes-typst/apuntes.typ -> apuntes-typst/apuntes.pdf
# - apuntes-typst/ejemplos.typ -> apuntes-typst/ejemplos.pdf
# - apuntes-typst/desafios.typ -> apuntes-typst/desafios.pdf

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$DIR/apuntes-typst"

echo "====================================================="
echo " Observando y compilando documentos Typst en vivo..."
echo " - $TARGET_DIR/apuntes.typ"
echo " - $TARGET_DIR/ejemplos.typ"
echo " - $TARGET_DIR/desafios.typ"
echo " Presiona Ctrl+C para detener."
echo "====================================================="

trap 'kill $(jobs -p) 2>/dev/null' EXIT INT TERM

typst watch "$TARGET_DIR/apuntes.typ" "$TARGET_DIR/apuntes.pdf" &
typst watch "$TARGET_DIR/ejemplos.typ" "$TARGET_DIR/ejemplos.pdf" &
typst watch "$TARGET_DIR/desafios.typ" "$TARGET_DIR/desafios.pdf" &

wait
