Este carpeta contiene mis apuntes para la materia de Análisis Avanzado, cursada en FCEN-UBA para Ciencia de Datos.

Los apuntes serán escritos en typst, y contendrán resúmenes de libros, clases, guías y examenes. Además, contendrá una carpeta llamada "apuntes-agente" dónde redactarás en markdown apuntes que yo te pida. También habrá una carpeta "scripts" dónde se harán pruebas con métodos numéricos en python.

Estructura de archivos:
- `apuntes-humano`: texto escrito por un ser humano.
    - `libros`
    - `clases`
    - `guias`
    - `examenes`
    - `slides`: resúmenes temáticos
- `apuntes-agente`
    - `notas`: texto en markdown, con un archivo `index.md`
    - `scripts`: pruebas usando métodos numéricos
    - `slides`: diapositivas que expliquen un tema en específico
    - `animaciones`: animaciones que expliquen un tema en específico
    - `cuestionarios`: multiple-choice teóricos

_reglas_:

1. Todo lo que está dentro de `apuntes-humano` sólo puede ser modificado con la autorización expresa del usuario del apunte.
2. El agente es libre de ordenar `apuntes-agente` cómo mejor lo considere.
3. El código en `apuntes-humano` debe ser escrito en Typst
4. El código en `apuntes-agente`debe ser markdown o python
5. Las animaciones se harán usando `manim` y las `apuntes-humano/slides` usando `manim-slides`
6. Los multiple-choices s harán en HTML plano y CSS simple (se verán sólo en PC). Tendrán una función en javascript para que las preguntas se presenten de forma aleatoria.
