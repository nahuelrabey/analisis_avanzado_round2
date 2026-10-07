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
| 1 (ℝ, supremos, sucesiones) | `guias-agente/guia_1_resuelta_agente.typ` | `Guias/Guia1/Ej01.lean` ... `Ej16.lean`, `Guias/Guia1/Anexo.lean` |
| 2 (cardinales) | `guias-agente/guia_2_resuelta_agente.typ` | `Guias/Guia2/Ej01.lean` ... `Ej17.lean` |
| 3 (espacios métricos y topología) | `guias-agente/guia_3_resuelta_agente.typ` | `Guias/Guia3/Ej01.lean` ... `Ej16.lean` |

Cada ejercicio tiene su archivo con el mismo nombre de teorema que cita la caja *Observación* del
`.typ` (`ej3a`, `ej12b`, ...). Un ejercicio puede importar módulos de `Comun` (abajo) y ejercicios
anteriores de su misma práctica (`Guia3/Ej08` importa `Ej03`), nunca uno posterior ni uno de otra
práctica. Cuando un lema de `Comun` *es* un ejercicio, la demostración vive en `Comun` (con
docstring "Práctica K, Ej. N") y el `EjNN.lean` lo re-enuncia en una línea.

## La librería `Comun`

`Comun/` (lib `Comun`, umbrella `Comun.lean`, namespace `Comun`) reúne las definiciones del curso,
los resultados de `apuntes.typ` que las prácticas toman como verdaderos (deducidos de Mathlib) y los
lemas genéricos que antes estaban repetidos entre ejercicios y parciales. El diseño está en
`apuntes-agente/lean-lemas-compartidos-y-organizacion.md`.

| Módulo | Qué contiene |
|---|---|
| `Comun/Reales.lean` | Arquímedes (Teorema 1, Proposición 1), densidad de ℚ, `n ≤ 2^n`, `1/(n+1)` decreciente, `√2 ∉ ℚ`, irracional + racional |
| `Comun/Supremos.lean` | `CotaSup`, `CotaInf`, `AcotadoSup/Inf`, `Acotado`, `EsSup`, `EsInf`, `EsMax`, `EsMin` (Def. 1 a 6) con puentes a `IsLUB`/`sSup`; Axioma de Completitud, Prop. 3 a 6, Teorema 2; monotonía de cotas, `-A`, `c·A`, conjunto suma `A + B` |
| `Comun/Sucesiones.lean` | `Converge` (ε-n₀), `DivergeMasInf`, `DivergeMenosInf`, `Acotada`, `Creciente`, `Decreciente` (Def. 7 a 10) con puentes a `Tendsto`; unicidad, álgebra de límites, convergente ⇒ acotada, monótona acotada, Equivalencia del supremo 2, subsucesiones; recursión de subsucesiones (`exists_strictMono_of_step`), subsucesiones aritméticas, divergencias básicas |
| `Comun/Cardinales.lean` | `Coordinables`, `CardLe`, `Finito`, `Numerable`, `Contable`, `CardC` (Def. 3.1, 3.5, 3.6, 3.8) con puentes a `Countable`/`Cardinal.mk`; Prop. 3.2, 3.9, 3.13, 3.14, Teoremas 3.11 (CSB) y 3.19, Obs. 3.21; corolarios de una línea |
| `Comun/Cardinales/Numerables.lean` | `ℤ ≃ ℕ`, `ℕ × ℕ ↪ ℕ` (`2^n 3^m` y `2^k(2m+1)`), `ℕ ⊕ ℕ ↪ ℕ`, unión de dos contables (P2 Ej. 2), diferencia (Ej. 3), unión numerable con índice mínimo (Ej. 6 a), codificación en Σ-tipos, partes finitas de un numerable (Ej. 11) |
| `Comun/Cardinales/Continuo.lean` | `𝒫(X) ≃ (X → Bool)` (Ej. 8 a), cortes `ℝ ↪ 𝒫(ℚ)`, la serie `Σ aₙ/3ⁿ⁺¹`, `#𝒫(ℕ) = c` (Ej. 10 b), `ℝ × ℝ`, `ℝ^k` (Ej. 14), uniones de cardinal `c` (Ej. 7), polinomios ↦ coeficientes |
| `Comun/Metricas.lean` | `EsMetrica` (Def. 4.1), `bola`, `bolaCerrada`, `Con X d` + `EsMetrica.toMetricSpace` (instancia sobre un sinónimo de tipo), `EsMetrica.max`/`const_mul`, métricas equivalentes por bolas, `EsCauchy`, `ConvergeMet`, `EsCompleto` (Def. 4.42, 4.51, 4.55) con puentes, transferencia de completitud |
| `Comun/Metricas/Rn.lean` | `d1`, `d2`, `dinf` en `Fin n → ℝ`: son métricas (P3 Ej. 1 b-d), bolas, `d_∞ ≤ d₂ ≤ d₁ ≤ n·d_∞` (Ej. 12), completitud (Ej. 14), puentes con `dist` y `EuclideanSpace` |
| `Comun/Metricas/Discreta.lean` | `δ` (P3 Ej. 1 f), `Disc X` con su instancia, `B(x,1) = {x}`, `B̄(x,1) = X` |
| `Comun/Metricas/C01.lean` | `C01 = C([0,1])`, `dC` = `d_∞` (P3 Ej. 1 e) con `dC_eq_dist`; `C01.d1` (integral), `C01.d1_le_dist`, evaluación |
| `Comun/Topologia.lean` | interior/clausura por bolas (Def. 4.11, 4.22) para un `MetricSpace`; bolas abiertas/cerradas, `{x}`, `cl B(x,r') ⊆ B(x,r)` (P3 Ej. 4), complementos (Ej. 5), unión e intersección (Ej. 6), frontera (Ej. 9), conjuntos uniformemente discretos |
| `Comun/Topologia/Real.lean` | la bola de ℝ como intervalo, puntos cercanos racionales/irracionales, `Q = ℚ ⊆ ℝ` con su clausura e interior |
| `Comun/Topologia/Curso.lean` | `interiorCurso`, `clausuraCurso`, `AbiertoCurso`, `CerradoCurso`, `derivadoCurso`, `fronteraCurso` en cualquier espacio métrico, con los puentes a `interior`/`closure`/`IsOpen`/`IsClosed`/`frontier` y la sección de intervalos en ℝ |
| `Comun/Topologia/DistConjuntos.lean` | `AcotadoMet`, diámetro (P3 Ej. 7), `d(x, A)` (Ej. 10), `d̂(A, B)` (Ej. 11) |

Reglas: los módulos de `Comun` importan `Mathlib` y otros módulos de `Comun`, nunca `Guias/`,
`Parciales/` ni `Ejemplos/`. Los lemas que son literalmente un ejercicio no se prueban con el
lema de Mathlib que es ese resultado (p. ej. `union_contable` no usa `Set.Countable.union`;
`Converge` se trabaja con ε-n₀, no con `Filter.Tendsto`); los puentes `_iff_` sí usan Mathlib.
Conviven dos dialectos: el del curso (guías) y el de Mathlib (parciales), unidos por los puentes.

Para comprobar todo:

```sh
cd lean && lake build             # Comun, Parciales, Ejemplos y Guias; sin errores ni warnings
```

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
