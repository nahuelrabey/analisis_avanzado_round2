# Propuesta: Diccionario Completo con Todos los Títulos en `apuntes.typ`

## Contexto y Objetivo
El usuario solicitó que **todos los conceptos y teoremas** estén explícitamente listados en el diccionario `#let contadores-repaso = (...)` (incluyendo aquellos con valor `0`), para poder cambiarlos fácilmente de `0` a `1`, `2`, etc., a medida que los vaya estudiando y completando sin mirar.

---

## Solución Propuesta

Incluir las 19 cajitas existentes del documento de forma explícita en el diccionario al comienzo de [`apuntes-typst/apuntes.typ`](file:///home/nahuel/study/analisis-avanzado/apuntes-typst/apuntes.typ):

```typst
// --- Diccionario Completo de Contadores Individuales por Cajita ---
#let contadores-repaso = (
  "Conjunto Acotado Superiormente": 1,
  "Supremo": 1,
  "Completitud": 1,
  "Principio de Arquímedes": 1,
  "Principio de Arquímedes 2": 1,
  "Densidad de ℚ": 1,
  "Equivalencia de supremo": 0,
  "Máximo": 0,
  "Caracterización de Supremo y Máximo": 0,
  "Conjunto Acotado Inferiormente": 0,
  "Ínfimo": 0,
  "Completitud en términos de ínfimos": 0,
  "Equivalencia de Ínfimo": 0,
  "Mínimo": 0,
  "Caracterización de Ínfimo y Mínimo": 0,
  "Sucesiones": 0,
  "Convergencia de Sucesiones": 0,
  "Divergencia de Sucesiones": 0,
  "Unicidad del límite": 0,
)
```

De esta manera, el usuario solo necesita abrir `apuntes.typ` y cambiar el número `0` por `1` (o el número deseado) en la línea correspondiente a la cajita recién repasada.

---

## Confirmación Requerida

En cumplimiento de la **Regla Global de Edición de Código bajo Demanda**, los archivos del repositorio (como `apuntes.typ`) requieren confirmación explícita para ser modificados.

Para proceder a incluir la lista completa de las 19 cajitas en el diccionario de `apuntes-typst/apuntes.typ`, por favor respondé con la palabra clave:
- **"implementá"** (o **"diseñá"** / **"planificá"**).
