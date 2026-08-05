---
name: desafio
description: Transcribe ejercicios o problemas matemáticos expuestos en imágenes marcados con el mote "desafio" al archivo Typst (`apuntes-typst/desafios.typ`) utilizando la librería `frame-it`. Se activa mediante el comando `/desafio` o cuando el usuario sube una imagen con la etiqueta o palabra "desafio".
---

# Skill: Desafío (`/desafio`)

Esta skill instruye al agente sobre cómo procesar imágenes de ejercicios y problemas matemáticos del tipo "desafío" y transcribirlos en sintaxis Typst utilizando el paquete `@preview/frame-it:2.0.0`.

## Documentación y Referencias de `frame-it`
- **Repositorio oficial de `frame-it`:** https://github.com/marc-thieme/frame-it
- Al consultar estilos o configuraciones de marcos, revisar la documentación oficial o usar `read_url_content`.

---

## Procedimiento de Transcripción

### 1. Preparación del Archivo Destino
- El archivo donde se guardan los desafíos es [`apuntes-typst/desafios.typ`](file:///home/nahuel/study/analisis-avanzado/apuntes-typst/desafios.typ).
- Si el archivo no existe, crearlo incorporando las importaciones y la configuración inicial de marcos:
  ```typst
  #import "@preview/frame-it:2.0.0": *
  #import "utils.typ": *

  #let (desafio, solucion) = frames(
    desafio: ("Desafío", orange),
    solucion: ("Solución", gray),
  )

  #show: frame-style(styles.boxy)

  // Archivo acumulativo de Desafíos
  ```

### 2. Procesamiento de la Imagen
- Inspeccionar la foto o imagen del desafío.
- Identificar el enunciado del ejercicio/problema, número o nombre de desafío (si lo posee), restricciones y notación matemática.

### 3. Manejo Riguroso de Resoluciones/Soluciones
- **Si la imagen INCLUYE resolución o solución:**
  - Transcribirla dentro del marco `#solucion[...]`.
- **Si la imagen NO INCLUYE resolución:**
  - **REGLA ESTRICTA:** **NO INVENTAR NI GENERAR LA SOLUCIÓN**.
  - Transcribir únicamente el problema dentro del marco `#desafio[...]`.

### 4. Estructura y Formateo Typst
- Encapsular cada problema en `#desafio[Título/Número][#desafio-body]`.
- Convertir la notación matemática a la sintaxis nativa de Typst (`$ ... $`).

### 5. Actualización del Archivo
- Añadir la transcripción al final de [`apuntes-typst/desafios.typ`](file:///home/nahuel/study/analisis-avanzado/apuntes-typst/desafios.typ), preservando el contenido previo.
