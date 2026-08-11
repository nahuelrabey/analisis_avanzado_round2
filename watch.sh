#!/usr/bin/env bash

# Script para monitorear y compilar automáticamente todos los documentos Typst en apuntes-typst/

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$DIR/apuntes-typst"
OUT_DIR="$DIR/pdf"

mkdir -p "$OUT_DIR"

echo "====================================================="
echo " Observando y compilando documentos Typst en vivo..."
echo "====================================================="

trap 'kill $(jobs -p) 2>/dev/null' EXIT INT TERM

# Buscar todos los archivos .typ en apuntes-typst/ excluyendo utilidades (utils.typ)
find "$TARGET_DIR" -type f -name "*.typ" ! -name "utils.typ" | sort | while read -r file; do
    rel_path="${file#$TARGET_DIR/}"
    pdf_out="$OUT_DIR/${rel_path%.typ}.pdf"
    mkdir -p "$(dirname "$pdf_out")"
    echo " - $rel_path -> pdf/${rel_path%.typ}.pdf"
    typst watch --root "$TARGET_DIR" "$file" "$pdf_out" &
done

echo "====================================================="
echo " Presiona Ctrl+C para detener."
echo "====================================================="

wait
