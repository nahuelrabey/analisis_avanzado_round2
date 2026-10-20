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
- **`C{clase}-{ejemplo}`** (`C1-1.2`, `C2-2`): ejercicio resuelto en clase, transcrito en `apuntes-typst/clases/` (notas docentes 2025). Los archivos se nombran **por tema**, no por número de clase; el número `{clase}` del tag es el orden de transcripción y cada archivo lo declara en su primera línea de comentario. Tabla actual:

  | tag | archivo en `clases/` | contenido |
  |---|---|---|
  | `C1-*` | `sucesiones_supremos.typ` | límites por definición, supremo e ínfimo |
  | `C2-*` | `sucesiones_cardinales.typ` | sucesiones recursivas, subsucesiones, primeros cardinales |
  | `C3-*` | `cardinales_metricas.typ` | cardinales de `ℕ^ℕ` y familias, primeras métricas |
  | `C4-*` | `espacios_metricos.typ` | interior/clausura/frontera, `A+B`, caracterizaciones de abierto (clase del 23/09/2025) |
  | `C5-*` | `completitud.typ` | espacios completos, `d = |x|+|y|`, encaje de cerrados (clase del 01/10/2025) |
  | `C6-*` | `continuidad.typ` | continuidad en productos `X × Y` con `d_∞`, proyecciones, continuidad coordenada a coordenada, continuidad uniforme (clase del 23/10/2025) |
  | `C7-*` | `compactos.typ` | compacidad por sucesiones: productos finitos, `{x_n} ∪ {x}`, cerrado ⟺ `K ∩ F` compacto (notas tipeadas "Clase AA — Compactos", octubre de 2025) |
  | `C8-*` | `punto_fijo.typ` | punto fijo en un compacto, encajes de compactos, `C(ℝ,[0,1])` sin denso numerable, Banach vía la esfera unitaria, operadores lineales y sucesiones nulas (clase del 11/11/2025; los Ej. 4 y 5 van a `ejemplos/p6.typ`) |

  Al transcribir una clase nueva: crear `clases/{tema}.typ` con el comentario de cabecera que fija su número de clase, y agregar la fila acá. El título del ejemplo termina en `(Clase 1 · Ejemplo 1.2)`.

- **`O{fuente}-{k}`** (`O1-3`, `O14-2`): ejemplo o ejercicio resuelto tomado de un apunte universitario de *acceso abierto* ajeno a la materia, transcripto en `apuntes-typst/ejemplos/p{N}_fuentes_abiertas.typ` (un archivo por guía, hermano de `ejemplos/p{N}.typ`, con la misma estructura de bloques). El número `{fuente}` es fijo por documento; la tabla fuente $arrow$ documento (autor, institución, URL, licencia o declaración de acceso) está en el encabezado de ese archivo, y la referencia precisa (sección, ejercicio, página del PDF) va al pie de cada ejemplo. Regla de fidelidad: se transcribe la resolución *de la fuente* (traducida y con la notación del curso); si la fuente sólo da el enunciado o una pista, no se inventa resolución. Numeración vigente:

  | `O` | fuente |
  |---|---|
  | `O1` | J. A. Guccione y J. J. Guccione, _Espacios Métricos_ (Cálculo Avanzado, FCEN-UBA, 2014) |
  | `O2` | _Espacios Métricos_, apunte de Cálculo Avanzado (FCEN-UBA, 2017) |
  | `O3` | A. Daniilidis, _Espacios Métricos_ (MA3801, DIM, U. de Chile) |
  | `O4` | P. Gajardo, _Análisis I_ (UTFSM, 2021) |
  | `O5` | E. Maximenko, _Funciones uniformemente continuas_ (ESFM-IPN) |
  | `O6` | J. Lebl, _Basic Analysis I_ (CC BY-NC-SA) |
  | `O7` | J. Tyson, _MATH 424 lecture notes: functions_ (UIUC, 2026) |
  | `O8` | P. Dote, _18.S097 Introduction to Metric Spaces_, Lecture 5 (MIT, 2022) |
  | `O9` | MIT OCW 18.100C _Real Analysis_ (2012), soluciones de problem sets (CC BY-NC-SA) |
  | `O10` | P. Karageorgis, _MA2223 Metric spaces_ (TCD) |
  | `O11` | D. Herrera Carrasco y F. Macías Romero, _La magia de los espacios métricos_ (BUAP) |
  | `O12` | R. G. Wilson, _Notas de Análisis_ (UAM-Iztapalapa) |
  | `O13` | Clase 21 de Análisis I (CIMAT, 2020) |
  | `O14` | R. Payá, _Análisis Matemático I_ (U. de Granada, 2024-25) |
  | `O15` | T. W. Körner, _Metric and Topological Spaces_ (Cambridge, 2021) |
  | `O16` | S. Chavan, _MTH304 Topology: notes and problems_ (IIT Kanpur) |
  | `O17` | N. Addington, _A Course in Metric Spaces and Point-Set Topology_ (U. of Oregon) |

  Al usar una fuente nueva se le asigna el siguiente número libre y se agrega acá y en el encabezado del archivo.

Los ejemplos de clase **sí se copian** a `ejemplos/p{N}.typ` --- el tag y el título mantienen la trazabilidad al archivo de origen, que no se borra. Cuando se transcriba una clase nueva con contenido resuelto, volcar sus ejemplos en el archivo de la guía que corresponda y ubicarlos en su bloque. Si la guía todavía no tiene archivo de ejemplos, se crea (ver sec. 1).

Los tags de pestaña son **globales**: no se reinician por archivo, y las guías citan los ejemplos por tag.
