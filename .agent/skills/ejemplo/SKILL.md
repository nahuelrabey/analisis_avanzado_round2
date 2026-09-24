---
name: ejemplo
description: Transcribe ejemplos y ejercicios resueltos expuestos en imágenes o descripciones al archivo Typst de la guía que abordan (`apuntes-typst/ejemplos/p{N}.typ`) utilizando la librería `frame-it`. Se activa mediante el comando `/ejemplo` o cuando el usuario comparte una foto de un ejemplo matemático.
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
- Los ejemplos se guardan **un archivo por guía**: `apuntes-typst/ejemplos/p{N}.typ` contiene los ejemplos que preparan para `apuntes-typst/guias/p{N}.typ`. Elegir `N` según la guía cuyos ejercicios usa la técnica del ejemplo (no según la fecha de la clase ni el capítulo de `notas_materia.pdf`).
- Si `ejemplos/p{N}.typ` no existe, crearlo copiando el preámbulo y el encabezado de un archivo hermano (p. ej. `ejemplos/p1.typ`): mismos imports (`#import "../utils.typ": *`), reglas `#show`, título "Ejemplos resueltos --- Práctica N", el párrafo de tags de pestaña y una tabla-mapa vacía de bloques. Las reglas `#show` no se heredan por `#import`, así que tienen que estar copiadas en cada archivo:
  ```typst
  #import "@preview/frame-it:2.0.0": *
  #import "../utils.typ": *

  #show figure.where(kind: "frame"): set figure(numbering: none)
  #show figure.where(kind: "frame"): set block(breakable: true)
  #show: frame-style(styles.boxy)

  #show grid.cell: it => {
    if it.fill != none {
      set text(fill: white, weight: "bold", style: "italic")
      it
    } else {
      it
    }
  }
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

Cada `ejemplos/p{N}.typ` **no es una lista cronológica**: está organizado en bloques temáticos (`== Bloque K · Título`), numerados desde 1 en cada archivo, ordenados como escalera de preparación para la guía `p{N}`. Cada bloque abre con un `#sublema(titulo: "Qué desbloquea")[...]` que explica qué ejercicios de la guía habilita.

Por lo tanto, al incorporar un ejemplo nuevo:

1. **Identificar la técnica** del ejemplo (acotar por definición, caracterización $\varepsilon$, densidad, límite por definición, negación de convergencia, monotonía/subsucesiones, ...).
2. **Insertarlo al final del bloque temático que corresponda**, *no* al final del archivo. Si el ejemplo no encaja en ningún bloque existente, crear un bloque nuevo con su encabezado `==` y su `#sublema(titulo: "Qué desbloquea")[...]`, ubicándolo en el punto de la escalera donde la técnica se necesita por primera vez.
3. **Actualizar la tabla-mapa del encabezado** de ese archivo si se creó un bloque nuevo o si el ejemplo cambia qué ejercicios de la guía quedan cubiertos.
4. **Revisar la nota final "Huecos frente a la Práctica N"** del archivo, si la tiene: si el ejemplo recién cargado tapa uno de los huecos listados, borrar ese ítem.
5. **Actualizar la tabla "Qué leer antes de empezar"** de la guía correspondiente (`guias/p{N}.typ`), que referencia los ejemplos por su tag.

Preservar siempre todo el contenido existente.

### 5.1 Tags: la pestaña dice de dónde viene el ejemplo

- **Número solo** (`8`): ejemplo de `notas_materia.pdf`, con el contador secuencial del apunte. El título lleva además su numeración por capítulo entre paréntesis: `(Ejemplo 2.4)`.
- **`C{clase}-{ejemplo}`** (`C1-1.2`, `C2-2`): ejercicio resuelto en clase, transcrito en `clases_2023/apuntes_{clase}.typ`. El título termina en `(Clase 1 · Ejemplo 1.2)`.

Los ejemplos de clase **sí se copian** a `ejemplos/p{N}.typ` --- el tag y el título mantienen la trazabilidad al archivo de origen, que no se borra. Cuando se transcriba una clase nueva con contenido resuelto, volcar sus ejemplos en el archivo de la guía que corresponda y ubicarlos en su bloque. Si la guía todavía no tiene archivo de ejemplos, se crea (ver sec. 1).

Los tags de pestaña son **globales**: no se reinician por archivo, y las guías citan los ejemplos por tag.
