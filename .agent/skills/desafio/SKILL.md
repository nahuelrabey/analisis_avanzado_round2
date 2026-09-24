---
name: desafio
description: Transcribe ejercicios o problemas matemáticos expuestos en imágenes marcados con el mote "desafio" al archivo Typst de la guía que abordan (`apuntes-typst/desafios/p{N}.typ`) utilizando la librería `frame-it`. Se activa mediante el comando `/desafio` o cuando el usuario sube una imagen con la etiqueta o palabra "desafio".
---

# Skill: Desafío (`/desafio`)

Esta skill instruye al agente sobre cómo procesar imágenes de ejercicios y problemas matemáticos del tipo "desafío" y transcribirlos en sintaxis Typst utilizando el paquete `@preview/frame-it:2.0.0`.

## Documentación y Referencias de `frame-it`
- **Repositorio oficial de `frame-it`:** https://github.com/marc-thieme/frame-it
- Al consultar estilos o configuraciones de marcos, revisar la documentación oficial o usar `read_url_content`.

---

## Procedimiento de Transcripción

### 1. Preparación del Archivo Destino
- Los desafíos se guardan **un archivo por guía**: `apuntes-typst/desafios/p{N}.typ` contiene los desafíos que alimentan a `apuntes-typst/guias/p{N}.typ`. Elegir `N` según la guía a la que sirve el desafío (normalmente, la del capítulo de `notas_materia.pdf` de donde sale).
- Si `desafios/p{N}.typ` no existe, crearlo copiando el preámbulo y el encabezado de un archivo hermano (p. ej. `desafios/p1.typ`): imports con `#import "../utils.typ": *`, reglas `#show` (no se heredan por `#import`), título "Desafíos --- Práctica N" y la tabla de bloques (*Bloque* / *Tema* / *Alimenta*).

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
- Cada `desafios/p{N}.typ` está organizado en bloques (`== Bloque K · Título`), numerados desde 1 en cada archivo y ordenados por dependencia: cada bloque supone resueltos los anteriores. Cada bloque abre con un `#sublema(titulo: "Qué desbloquea")[...]`.
- Añadir la transcripción **al final del bloque que corresponda** de `desafios/p{N}.typ`, no al final del archivo, preservando el contenido previo. Si no encaja en ningún bloque, crear uno nuevo con su `#sublema` y agregar su fila a la tabla del encabezado.
