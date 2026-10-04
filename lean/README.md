# Verificación en Lean de los parciales

Proyecto Lean 4 + Mathlib con una formalización de cada ejercicio de los parciales
transcriptos en `apuntes-typst/parciales/`:

| Examen | Transcripción y resolución | Archivo Lean |
|---|---|---|
| Primer parcial 1C 2024 (soluciones oficiales) | `apuntes-typst/parciales/2024_1c_parcial_1.typ` | `Parciales/Parcial1_1C2024.lean` |
| Primer parcial 2C 2024 (19/10/2024, resolución oficial) | `apuntes-typst/parciales/2024_2c_parcial_1.typ` | `Parciales/Parcial1_2C2024.lean` |
| Primer parcial 1C 2025 (08/05/2025) | `apuntes-typst/parciales/2025_1c_parcial_1.typ` | `Parciales/Parcial1_1C2025.lean` |
| Primer recuperatorio 1C 2025 (08/07/2025) | `apuntes-typst/parciales/2025_1c_recuperatorio_1.typ` | `Parciales/Recu1_1C2025.lean` |
| Primer parcial 2C 2025 (16/10/2025) | `apuntes-typst/parciales/2025_2c_parcial_1.typ` | `Parciales/Parcial1_2C2025.lean` |
| Recuperatorio del primer parcial 2C 2025 (04/12/2025) | `apuntes-typst/parciales/2025_2c_recuperatorio_1.typ` | `Parciales/Recu1_2C2025.lean` |

Para los exámenes que traen resolución oficial (2024), el archivo Lean formaliza esa resolución
y el `.typ` termina con una sección *Verificación en Lean* que anota las diferencias. Para los
demás, el `.typ` tiene resoluciones propuestas y cada una termina con una caja *Observación*
que indica qué teorema del archivo Lean la certifica y en qué difiere la formalización de la
escritura a mano.

Además, `Ejemplos/` formaliza ejemplos de `apuntes-typst/ejemplos/`:

| Ejemplo | Archivo Lean |
|---|---|
| C3-6, la métrica del peine en `ℝ²` (`ejemplos/p3.typ`) | `Ejemplos/Peine.lean` |

`Guias/` formaliza las resoluciones de las prácticas escritas por el agente en
`apuntes-typst/guias-agente/` (separadas de las resoluciones del autor de los apuntes, que
viven en `apuntes-typst/guias/`):

| Práctica | Resolución | Archivos Lean |
|---|---|---|
| 3 (espacios métricos y topología) | `guias-agente/guia_3_resuelta_agente.typ` | `Guias/Guia3/Ej01.lean` ... `Ej16.lean` |

`Guias/Common.lean` define `EsMetrica` (Definición 4.1 de `apuntes.typ`), `bola` y `bolaCerrada`.
Cada ejercicio tiene un archivo independiente (no se importan entre sí); el `.typ` termina cada
ejercicio con una caja *Observación* que indica qué teoremas certifican qué ítems y los desvíos de
la formalización. Para comprobar todos los teoremas de la Práctica 3:

```sh
cd lean && lake build Guias        # compila sin errores ni warnings
```

Fuera de alcance: `apuntes-typst/parciales/2024_2c_parcial_2.typ` (segundo parcial: punto fijo,
series, medida de Lebesgue), cuyos temas no están cubiertos por `apuntes.typ`.

## Compilar

```sh
# una sola vez: instalar elan (gestor de toolchains de Lean)
curl -sSf https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh | sh -s -- -y

cd lean
lake exe cache get   # baja los .olean de Mathlib (varios GB); evita compilarla
lake build           # compila Parciales/*.lean; termina sin errores ni warnings
```

Para comprobar que ninguna demostración usa `sorry` ni axiomas no estándar:

```lean
import Parciales
#print axioms Parcial1_1C2025.ej1   -- [propext, Classical.choice, Quot.sound]
```

## Convenciones

- Las sucesiones del curso empiezan en `n = 1`; en Lean los índices empiezan en `0`
  (`a_n` del curso es `a (n-1)` en Lean). Ningún argumento depende de esto.
- `ℝⁿ` es `Fin n → ℝ`, que en Mathlib trae la métrica `d_∞`; `d_2` se transporta desde
  `EuclideanSpace ℝ (Fin n)`.
- El espacio `X` de sucesiones eventualmente nulas (parcial 1C 2025, ej. 4) se modela como
  subconjunto de `ℕ →ᵇ ℝ` (funciones acotadas, con la métrica del supremo).
- `C([0, 1])` es `C(unitInterval, ℝ)`, que trae la métrica `d_∞`; la distancia `d_1` se define
  a mano como `∫₀¹ |f - g|` y las afirmaciones de continuidad respecto de `d_1` se escriben con
  `ε`-`δ` (no se construye un espacio métrico `(C[0,1], d_1)`).
- Métricas "raras" del enunciado (`|x| + |y|`, la discreta, `máx{4/3 d_∞, d_2}`) se ponen sobre
  un sinónimo de tipo (`def Rd : Type := ℝ`, etc.) con su propia instancia `MetricSpace`.
