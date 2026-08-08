---
name: ejemplo
description: Transcribe ejemplos y ejercicios resueltos expuestos en imágenes o descripciones al archivo Typst (`apuntes-typst/ejemplos.typ`) utilizando la librería `frame-it`. Se activa mediante el comando `/ejemplo` o cuando el usuario comparte una foto de un ejemplo matemático.
---

# Skill: Ejemplo (`/ejemplo`)

Esta skill instruye al agente sobre cómo procesar imágenes de ejemplos o ejercicios matemáticos resueltos y transcribirlos en sintaxis Typst utilizando el paquete `@preview/frame-it:2.0.0`.

## Documentación y Referencias de `frame-it`
- **Repositorio oficial de `frame-it`:** https://github.com/marc-thieme/frame-it
- `frame-it` provee bloques y marcos preconfigurados o personalizables para diferentes tipos de entornos.
- Al consultar estilos o variantes de marcos, revisar la documentación oficial o consultar la URL mediante `read_url_content`.

---

## Procedimiento de Transcripción

### 1. Preparación del Archivo Destino
- El archivo donde se guardan los ejemplos acumulados es [`apuntes-typst/ejemplos.typ`](file:///home/nahuel/study/analisis-avanzado/apuntes-typst/ejemplos.typ).
- Si el archivo no existe, crearlo incorporando las importaciones y la configuración inicial de marcos independientes:
  ```typst
  #import "@preview/frame-it:2.0.0": *
  #import "utils.typ": *

  #let (ejemplo, estrategia, resolucion) = frames(
    ejemplo: ("Ejemplo", rgb("#059669")),
    estrategia: ("Estrategia", rgb("#d97706")),
    resolucion: ("Resolución", rgb("#475569")),
  )

  #show figure.where(kind: "frame"): set figure(numbering: none)

  #show grid.cell: it => {
    if it.fill != none {
      set text(fill: white, weight: "bold")
      it
    } else {
      it
    }
  }

  #show: frame-style(styles.boxy)

  // --- Archivo Acumulativo de Ejemplos ---
  ```

### 2. Procesamiento de la Imagen
- Inspeccionar la foto o imagen provista por el usuario.
- Separar claramente el contenido en 3 componentes independientes al mismo nivel (sin marcos anidados):
  1. **`#ejemplo[Título][...]`**: (Obligatorio) Enunciado o planteo del problema.
  2. **`#estrategia[...]`**: (Opcional) Intuiciones, resúmenes de enfoque o notas orientativas.
  3. **`#resolucion[...]`**: (Opcional) Desarrollo, demostración o resolución paso a paso.

### 3. Manejo Riguroso de Resoluciones y Explicaciones
- **Si la imagen INCLUYE resolución o desarrollo:**
  - Transcribirla fielmente dentro del bloque `#resolucion[...]`.
- **Si la imagen NO INCLUYE resolución:**
  - **REGLA ESTRICTA:** **NO INVENTAR NI GENERAR DEMOSTRACIONES O RESOLUCIONES COMPLEMENTARIAS**.
  - Omitir el bloque `#resolucion[...]` y transcribir únicamente el enunciado en `#ejemplo[...]` (y `#estrategia[...]` si se incluyó alguna pista).

### 4. Estructura y Formateo Typst con `frame-it`
- Escribir las cajas consecutivamente (como bloques hermanos):
  ```typst
  #ejemplo[Título][Enunciado...]

  #estrategia[Notas de enfoque...] // Opcional

  #resolucion[Demostración...]     // Opcional
  ```
- Asegurar que la notación matemática, símbolos, subíndices, integrales, límites y funciones estén correctamente adaptados a la sintaxis nativa de Typst (`$ ... $`).

### 5. Actualización del Archivo
- Añadir los nuevos bloques al final de [`apuntes-typst/ejemplos.typ`](file:///home/nahuel/study/analisis-avanzado/apuntes-typst/ejemplos.typ), preservando todo el contenido existente.
