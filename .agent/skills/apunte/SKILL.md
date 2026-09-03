---
name: apunte
description: Transcribe apuntes expuestos en imágenes o fotos (teoremas, proposiciones, definiciones, lemas, corolarios, axiomas y ejemplos) al archivo Typst (`apuntes-typst/apuntes.typ`) utilizando la librería `frame-it`. Se activa mediante el comando `/apunte` o cuando el usuario comparte la foto de un concepto matemático para apuntar.
---

# Skill: Apunte (`/apunte`)

Esta skill instruye al agente sobre cómo procesar imágenes de contenido matemático (teoremas, proposiciones, definiciones, lemas, corolarios, axiomas, ejemplos) y transcribirlos en sintaxis Typst utilizando el paquete `@preview/frame-it:2.0.0`.

## Documentación y Referencias de `frame-it`
- **Repositorio oficial de `frame-it`:** https://github.com/marc-thieme/frame-it
- `frame-it` provee bloques y marcos preconfigurados o personalizables para diferentes tipos de entornos (teorema, proposición, definición, lema, corolario, axioma, ejemplo, demostración/prueba).
- Al consultar estilos o variantes de marcos, revisar la documentación oficial o consultar la URL mediante `read_url_content`.

---

## Procedimiento de Transcripción

### 1. Preparación del Archivo Destino
- El archivo donde se guardan los apuntes acumulados es [`apuntes-typst/apuntes.typ`](file:///home/nahuel/study/analisis-avanzado/apuntes-typst/apuntes.typ).
- Si el archivo no existe, crearlo incorporando los imports y entornos iniciales:
  ```typst
  #import "@preview/frame-it:2.0.0": *
  #import "utils.typ": *

  #let (definicion, teorema, proposicion, lema, corolario, ejemplo, axioma, demostracion) = frames(
    definicion: ("Definición", blue),
    teorema: ("Teorema", purple),
    proposicion: ("Proposición", rgb("#8b5cf6")),
    lema: ("Lema", teal),
    corolario: ("Corolario", orange),
    ejemplo: ("Ejemplo", green),
    axioma: ("Axioma", red),
    demostracion: ("Demostración", gray),
  )

  #show: frame-style(styles.boxy)
  ```

### 2. Procesamiento de la Imagen e Identificación del Tipo
- Inspeccionar la foto o imagen provista por el usuario.
- Clasificar el tipo de concepto:
  - **Teorema** (`#teorema[...]`)
  - **Proposición** (`#proposicion[...]`)
  - **Definición** (`#definicion[...]`)
  - **Lema** (`#lema[...]`)
  - **Corolario** (`#corolario[...]`)
  - **Axioma** (`#axioma[...]`)
  - **Ejemplo** (`#ejemplo[...]`)
- Identificar título o nombre (si aplica), hipótesis, tesis y notación matemática.

### 3. Manejo Riguroso de Demostraciones y Explicaciones
- **Si la imagen INCLUYE demostración o resolución:**
  - Transcribirla fielmente dentro del bloque correspondiente de demostración/prueba de `frame-it` (`#demostracion[...]`) o inmediatamente a continuación.
- **Si la imagen NO INCLUYE demostración/resolución:**
  - **REGLA ESTRICTA:** **NO INVENTAR NI GENERAR DEMOSTRACIONES O RESOLUCIONES COMPLEMENTARIAS**.
  - Transcribir únicamente el concepto expuesto en la imagen y esperar a que el usuario agregue más detalles si lo desea.

### 4. Estructura y Formateo Typst con `frame-it`
- Encapsular cada concepto en su marco adecuado de `frame-it` (`definicion`, `teorema`, `proposicion`, `lema`, `corolario`, `axioma`, `ejemplo`).
- Asegurar que la notación matemática, símbolos, subíndices, integrales, límites y funciones estén correctamente adaptados a la sintaxis nativa de Typst (`$ ... $`).

### 5. Actualización del Archivo

El destino es siempre [`apuntes-typst/apuntes.typ`](file:///home/nahuel/study/analisis-avanzado/apuntes-typst/apuntes.typ), preservando **todo** el contenido existente y separando el bloque nuevo con una línea en blanco.

`apuntes.typ` **no es un log cronológico**: es el apunte de la materia leído de principio a fin. Por eso el apunte nuevo va **en el lugar que le corresponde temáticamente**, no automáticamente al final. Criterio en cascada:

1. **Si el concepto trae número de la fuente** (`3.9`, `2.4`, ...): insertarlo en su lugar dentro de la secuencia numérica del archivo, aunque ya haya contenido posterior cargado. **Nunca renumerar** lo que ya está.
2. **Si no trae número**: ubicarlo junto al concepto del que depende --- una proposición inmediatamente después de la definición que caracteriza, un corolario después de su teorema, un ejemplo después del resultado que ilustra.
3. **Al final del archivo** sólo si el concepto continúa el último tema cargado, o si no hay ningún lugar natural donde ubicarlo.

Además:

- Los bloques `#estrategia` y `#demostracion` viajan **pegados** a su enunciado: nunca se separan del `#proposicion` / `#teorema` / `#lema` al que pertenecen.
- Si el slot que corresponde ya está ocupado (choque de numeración), ubicar el bloque lo más cerca posible del lugar correcto, **no** tocar lo existente y **avisarle al usuario** del choque.
- Después de insertar, verificar que el archivo siga compilando:
  ```bash
  typst compile apuntes-typst/apuntes.typ
  ```
