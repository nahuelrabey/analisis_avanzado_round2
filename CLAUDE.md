
REGLA: Siempre que se utilice un comando definido dentre de las skills del proyecto, podes implementar directamente sin requerir input del usuario

Este carpeta contiene mis apuntes para la materia de Análisis Avanzado, cursada en FCEN-UBA para Ciencia de Datos.
Los apuntes serán escritos en typst, y contendrán resúmenes de libros, clases, guías y examenes. Además, contendrá una carpeta llamada "apuntes-agente" dónde redactarás en markdown apuntes que yo te pida. También habrá una carpeta "scripts" dónde podrás generar visualizaciones con Python

## Estructura de Archivos

- `apuntes-typst`
    - `libros`
    - `clases`
    - `guias`
    - `examenes`
    - `slides`: resúmenes temáticos
- `apuntes-docentes`: archivos sueltos con notas escritas por docentes
- `apuntes-agente`: notas generadas por el agente, a pedido del usuario
- `scripts`
    - `animaciones`
    - `slides`
- `cuestionarios`

_reglas_:

1. Todo lo que está dentro de `apuntes-typst` sólo puede ser modificado con la autorización expresa del usuario del apunte.
2. El código en `apuntes-typst` debe ser escrito en Typst
3. Las `scripts/animaciones/` se harán usando `manim` y las `scripts/slides` usando `manim-slides`
4. Los multiple-choices s harán en HTML plano y CSS simple (se verán sólo en PC). Tendrán una función en javascript para que las preguntas se presenten de forma aleatoria.

## Modificacion de apuntes

Siempre que se pida una modificación a los apuntes, escribir un archivo dentro de la carpeta `proposals`. En particular, evaluar si la modificación que se pide afecta a cómo se comportan las SKILLS.

Paso por paso:
1. Evaluar si la modificación afecta a una SKILL.
2. Escribir la propuesta
3. Una vez implementada, eliminar la propuesta
