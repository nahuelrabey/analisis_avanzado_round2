/-
Análisis Avanzado (FCEN-UBA) · Práctica 3 · Ejercicio 7 (diámetro).
Enunciado en `apuntes-typst/guias/p3.typ`; resolución en `apuntes-typst/guias-agente/guia_3_resuelta_agente.typ` (Ejercicio 7).

Sea `E` un espacio métrico y `A, B ⊆ E` acotados.
(a) Si `A ⊆ B` entonces `diam A ≤ diam B`.
(b) `diam A = diam (cl A)`.

El diámetro se define como en la Definición 4.9 de `apuntes.typ`:
`diam A = sup {d(x, y) : x, y ∈ A}`, con `sSup` del conjunto de distancias. Como la definición
del curso sólo tiene sentido para `A ≠ ∅` (el supremo de un conjunto vacío no está definido),
se pide `A.Nonempty`. `closure` es la clausura de Mathlib, pero las pruebas pasan por su
caracterización por bolas (`Metric.mem_closure_iff`, Definición 4.22).

Qué importa de `Comun`: todo (`Comun.Topologia.DistConjuntos`: `AcotadoMet` (Def. 4.8, antes
`Acotado`), `distsDiam`, `diam`, `dist_le_diam`, `diam_le_of_forall`,
`dist_le_diam_of_mem_closure`, y los dos ítems `diam_mono`, `diam_closure`). Este archivo sólo
re-enuncia los ítems.
-/
import Mathlib
import Comun.Topologia.DistConjuntos

open Comun

namespace Guias.Guia3.Ej07

variable {E : Type*} [MetricSpace E]

/-- **Ejercicio 7 (a).** Si `A ⊆ B` son acotados (`A ≠ ∅`), entonces `diam A ≤ diam B`
(`Comun.diam_mono`). -/
theorem diam_mono {A B : Set E} (hA : A.Nonempty) (hB : AcotadoMet B) (hAB : A ⊆ B) :
    diam A ≤ diam B :=
  Comun.diam_mono hA hB hAB

/-- **Ejercicio 7 (b).** Si `A ≠ ∅` es acotado, `cl A` es acotado y `diam A = diam (cl A)`
(`Comun.diam_closure`). -/
theorem diam_closure {A : Set E} (hne : A.Nonempty) (hA : AcotadoMet A) :
    AcotadoMet (closure A) ∧ diam A = diam (closure A) :=
  Comun.diam_closure hne hA

end Guias.Guia3.Ej07
