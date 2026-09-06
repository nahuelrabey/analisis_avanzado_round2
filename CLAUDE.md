REGLA: Siempre que se utilice un comando definido dentre de las skills del proyecto, podes implementar directamente sin requerir input del usuario

REGLA: Antes de leer un PDF, buscá si no existe un archivo .typ que lo genere. Allí deberías tener en texto estructurado el contenido necesario

Este carpeta contiene mis apuntes para la materia de Análisis Avanzado, cursada en FCEN-UBA para Ciencia de Datos.
Los apuntes serán escritos en typst, y contendrán resúmenes de libros, clases, guías y examenes. Además, contendrá una carpeta llamada "apuntes-agente" dónde redactarás en markdown apuntes que yo te pida. También habrá una carpeta "scripts" dónde podrás generar visualizaciones con Python

## Estructura de Archivos

- `apuntes-typst`
    - `galerazos.typ`: técnicas y truquitos reutilizables (skill `/galerazo`)
    - `libros`
    - `clases`
    - `guias`
    - `examenes`
    - `slides`: resúmenes temáticos
- `apuntes-docentes`: archivos sueltos con notas escritas por docentes
- `apuntes-agente`: notas generadas por el agente, a pedido del usuario
- `libros-procesados`: texto plano de los libros en `apuntes-docentes/bibliografia`.
- `scripts`
    - `animaciones`
    - `slides`
- `cuestionarios`

_reglas_:

- No se puede usar `libros-procesados` cómo fuente, sólo cómo referencia. Las ecuaciones que están en esos archivos están probablemente mal procesadas. Siempre referirse a la fuente oficial, el PDF en `apuntes-docentes/bibliografia` para corroborar vía imagen u OCR que la ecuación es correcta. Podes usar razonamiento para deducirla PERO siempre aclarándolo.
- Todo lo que está dentro de `apuntes-typst` sólo puede ser modificado con la autorización expresa del usuario del apunte.
- El código en `apuntes-typst` debe ser escrito en Typst
- Las `scripts/animaciones/` se harán usando `manim` y las `scripts/slides` usando `manim-slides`
- Los multiple-choices s harán en HTML plano y CSS simple (se verán sólo en PC). Tendrán una función en javascript para que las preguntas se presenten de forma aleatoria.
- Siempre que se escriban expresiones con valor absoluto en Typst, usar obligatoriamente la función `abs(...)` en lugar de barras verticales aisladas `|...|` (por ejemplo, `abs(a_n)` o `abs(a)`).
- Para divisibilidad en Typst usar `divides` (∣) y `divides.not` (∤). Nunca `mid` ni `nmid` (no existen en Typst: se renderizan como texto monoespaciado literal) ni parches como `cancel("|")`.
- Las composiciones se escriben con `compose` ($g compose f$), no como aplicación anidada ($g(f(x))$). Si hace falta evaluar en un punto, primero se nombra la composición y después se la evalúa: `$ g = phi compose f, quad g(x) = ... $`.
- Las ecuaciones display no deben desbordar el margen: Typst no las parte solo, así que partirlas explícitamente con `\` y alinear la continuación.

## Modificacion de apuntes

Siempre que se pida una modificación a los apuntes, escribir un archivo dentro de la carpeta `proposals`. En particular, evaluar si la modificación que se pide afecta a cómo se comportan las SKILLS.

Paso por paso:
1. Evaluar si la modificación afecta a una SKILL.
2. Escribir la propuesta
3. Una vez implementada, eliminar la propuesta
