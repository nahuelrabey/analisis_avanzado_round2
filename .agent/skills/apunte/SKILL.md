---
name: apunte
description: Transcribe apuntes expuestos en imágenes o fotos (teoremas, definiciones, lemas, corolarios, axiomas y ejemplos) al archivo Typst (`apuntes-typst/apuntes.typ`) utilizando la librería `frame-it`. Se activa mediante el comando `/apunte` o cuando el usuario comparte la foto de un concepto matemático para apuntar.
---

# Skill: Apunte (`/apunte`)

Esta skill instruye al agente sobre cómo procesar imágenes de contenido matemático (teoremas, definiciones, lemas, corolarios, axiomas, ejemplos) y transcribirlos en sintaxis Typst utilizando el paquete `@preview/frame-it:1.0.0`.

## Documentación y Referencias de `frame-it`
- **Repositorio oficial de `frame-it`:** https://github.com/marc-thieme/frame-it
- `frame-it` provee bloques y marcos preconfigurados o personalizables para diferentes tipos de entornos (teorema, definición, lema, corolario, axioma, ejemplo, demostración/prueba).
- Al consultar estilos o variantes de marcos, revisar la documentación oficial o consultar la URL mediante `read_url_content`.

---

## Procedimiento de Transcripción

### 1. Preparación del Archivo Destino
- El archivo donde se guardan los apuntes acumulados es [`apuntes-typst/apuntes.typ`](file:///home/nahuel/study/analisis-avanzado/apuntes-typst/apuntes.typ).
- Si el archivo no existe, crearlo incorporando los imports y entornos iniciales:
  ```typst
  #import "@preview/frame-it:1.0.0": *
  #import "utils.typ": *

  #let (definicion, teorema, lema, corolario, ejemplo, axioma, demostracion) = frames(
    definicion: ("Definición", blue),
    teorema: ("Teorema", purple),
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
- Encapsular cada concepto en su marco adecuado de `frame-it` (`definicion`, `teorema`, `lema`, `corolario`, `axioma`, `ejemplo`).
- Asegurar que la notación matemática, símbolos, subíndices, integrales, límites y funciones estén correctamente adaptados a la sintaxis nativa de Typst (`$ ... $`).

### 5. Actualización del Archivo
- Añadir el nuevo apunte al final de [`apuntes-typst/apuntes.typ`](file:///home/nahuel/study/analisis-avanzado/apuntes-typst/apuntes.typ), preservando todo el contenido existente y con una separación clara respecto a las entradas anteriores.
