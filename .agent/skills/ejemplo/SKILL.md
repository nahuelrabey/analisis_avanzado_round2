---
name: ejemplo
description: Transcribe ejemplos y ejercicios resueltos expuestos en imágenes o descripciones al archivo Typst (`apuntes-typst/ejemplos.typ`) utilizando la librería `frame-it`. Se activa mediante el comando `/ejemplo` o cuando el usuario comparte una foto de un ejemplo matemático.
---

# Skill: Ejemplo (`/ejemplo`)

Esta skill instruye al agente sobre cómo procesar imágenes de ejemplos o ejercicios matemáticos resueltos y transcribirlos en sintaxis Typst utilizando el paquete `@preview/frame-it:1.0.0`.

## Documentación y Referencias de `frame-it`
- **Repositorio oficial de `frame-it`:** https://github.com/marc-thieme/frame-it
- `frame-it` provee bloques y marcos preconfigurados o personalizables para diferentes tipos de entornos.
- Al consultar estilos o variantes de marcos, revisar la documentación oficial o consultar la URL mediante `read_url_content`.

---

## Procedimiento de Transcripción

### 1. Preparación del Archivo Destino
- El archivo donde se guardan los ejemplos acumulados es [`apuntes-typst/ejemplos.typ`](file:///home/nahuel/study/analisis-avanzado/apuntes-typst/ejemplos.typ).
- Si el archivo no existe, crearlo incorporando las importaciones y la configuración inicial de marcos:
  ```typst
  #import "@preview/frame-it:1.0.0": *
  #import "utils.typ": *

  #let (ejemplo, solucion) = frames(
    ejemplo: ("Ejemplo", green),
    solucion: ("Solución", gray),
  )

  #show: frame-style(styles.boxy)

  // --- Archivo Acumulativo de Ejemplos ---
  ```

### 2. Procesamiento de la Imagen
- Inspeccionar la foto o imagen provista por el usuario.
- Identificar el título/nombre del ejemplo, conjunto o función analizada, hipótesis y notación matemática.

### 3. Manejo Riguroso de Resoluciones y Explicaciones
- **Si la imagen INCLUYE resolución o desarrollo:**
  - Transcribirla fielmente dentro del cuerpo del ejemplo o usando la estructura de lista/marco correspondiente.
- **Si la imagen NO INCLUYE resolución:**
  - **REGLA ESTRICTA:** **NO INVENTAR NI GENERAR DEMOSTRACIONES O RESOLUCIONES COMPLEMENTARIAS**.
  - Transcribir únicamente el enunciado del ejemplo expuesto en la imagen.

### 4. Estructura y Formateo Typst con `frame-it`
- Encapsular cada ejemplo en `#ejemplo[Título/Nombre][#ejemplo-body]`.
- Asegurar que la notación matemática, símbolos, subíndices, integrales, límites y funciones estén correctamente adaptados a la sintaxis nativa de Typst (`$ ... $`).

### 5. Actualización del Archivo
- Añadir el nuevo ejemplo al final de [`apuntes-typst/ejemplos.typ`](file:///home/nahuel/study/analisis-avanzado/apuntes-typst/ejemplos.typ), preservando todo el contenido existente.
