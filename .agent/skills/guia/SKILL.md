---
name: guia
description: Transcribe ejercicios de guías de trabajos prácticos expuestos en imágenes o descripciones, junto con propuestas de resolución y consultas para docentes, al archivo de la guía correspondiente (`apuntes-typst/guias/p{N}.typ`) utilizando la librería `frame-it`. Se activa mediante el comando `/guia` o cuando el usuario comparte la foto o resolución de un ejercicio de la guía.
---

# Skill: Guía (`/guia`)

Esta skill instruye al agente sobre cómo procesar imágenes o textos de ejercicios de guías de trabajos prácticos, transcribir el enunciado, incorporar una o varias propuestas de resolución y agregar preguntas/dudas para los docentes en el archivo correspondiente dentro de `apuntes-typst/guias/`.

## Documentación y Referencias de `frame-it`
- `frame-it` se encuentra configurado globalmente en [`apuntes-typst/utils.typ`](file:///home/nahuel/study/analisis-avanzado/apuntes-typst/utils.typ), proveyendo tres tipos de marcos:
  - `#enunciado[Título/Número][Contenido]`: Marco azul para el planteo del ejercicio.
  - `#solucion[Propuesta K][Contenido]`: Marco verde para propuestas de solución.
  - `#duda[Título][Contenido]`: Marco rojo/naranja para consultas a presentar a los docentes.

---

## Procedimiento de Transcripción

### 1. Identificación de la Guía y Archivo Destino
- Determinar el número de práctica/guía $N$ (por ejemplo, Guía 1 $\rightarrow$ `p1.typ`, Guía 2 $\rightarrow$ `p2.typ`, etc.).
- El archivo destino es [`apuntes-typst/guias/p{N}.typ`](file:///home/nahuel/study/analisis-avanzado/apuntes-typst/guias/).
- Asegurar que el archivo contenga la cabecera `#import "../utils.typ": *`.

### 2. Procesamiento del Input del Usuario
Inspeccionar la imagen o texto enviado y extraer:
1. **Número o Título del Ejercicio** (ej. "Ejercicio 3 (b)").
2. **Enunciado**: Transcribir fielmente a notación Typst (`$ ... $`).
3. **Propuestas de Solución**: Transcribir los intentos o desarrollos brindados por el usuario. Se puede incluir más de una propuesta de solución para un mismo ejercicio si el usuario provee enfoques alternativos.
4. **Dudas / Preguntas para Docentes**: Transcribir cualquier duda o inquietud planteada sobre pasos o conceptos específicos.

### 3. Manejo Riguroso de Resoluciones y Explicaciones
- **Si el usuario INCLUYE propuesta(s) de solución:**
  - Transcribirla(s) dentro de su(s) correspondiente(s) bloque(s) `#solucion[Propuesta 1][...]`, `#solucion[Propuesta 2][...]`, etc.
- **Si la imagen/input NO INCLUYE propuesta de solución:**
  - **REGLA ESTRICTA:** **NO INVENTAR NI GENERAR SOLUCIONES COMPLEMENTARIAS**.
  - Omitir el bloque `#solucion[...]` y colocar únicamente el `#enunciado[...]` (y `#duda[...]` si el usuario incluyó una consulta).

### 4. Estructura y Formateo Typst con `frame-it`
- Escribir las cajas consecutivamente al mismo nivel:
  ```typst
  #enunciado[Ejercicio 4 (a)][
    Pruebe que si $x < y + epsilon$ para todo $epsilon > 0$, entonces $x <= y$.
  ]

  #solucion[Propuesta 1][
    Supongamos por el absurdo que $x > y$. Sea $epsilon_0 = (x - y) / 2 > 0$...
  ]

  #solucion[Propuesta 2][
    Demostración directa utilizando la propiedad del ínfimo...
  ]

  #duda[Consulta para clase][
    ¿Es válido asumir $x > y$ directamente o conviene probar el lema por contrarecíproca?
  ]
  ```
- Adaptar toda la notación matemática a la sintaxis nativa de Typst (`$ ... $`).

### 5. Actualización del Archivo
- Añadir la transcripción al final del archivo correspondiente [`apuntes-typst/guias/p{N}.typ`](file:///home/nahuel/study/analisis-avanzado/apuntes-typst/guias/), preservando todo el contenido previo.
