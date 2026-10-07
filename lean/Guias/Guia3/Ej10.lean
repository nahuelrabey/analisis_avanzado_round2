/-
Análisis Avanzado (FCEN-UBA) · Práctica 3 · Ejercicio 10 (distancia de un punto a un conjunto).
Enunciado en `apuntes-typst/guias/p3.typ`; resolución en `apuntes-typst/guias-agente/guia_3_resuelta_agente.typ` (Ejercicio 10).

Sea `A ⊆ E` no vacío y `d(x, A) = ínf {d(x, a) : a ∈ A}` (`distA`, con `sInf`). Se prueba, para
todos `x, y ∈ E` y `r`:
(a) `|d(x, A) - d(y, A)| ≤ d(x, y)`;
(b) `x ∈ A → d(x, A) = 0`;
(c) `d(x, A) = 0 ↔ x ∈ cl A`;
(d) `B_A(r) = {x : d(x, A) < r}` es abierto;
(e) `B̄_A(r) = {x : d(x, A) ≤ r}` es cerrado.

El ínfimo existe porque el conjunto de distancias es no vacío y está acotado inferiormente por
`0` (Teorema 2, completitud en términos de ínfimos); en Lean, `sInf` está siempre definido y
las propiedades útiles (`csInf_le`, `le_csInf`) piden esas dos hipótesis.

Qué importa de `Comun`: todo (`Comun.Topologia.DistConjuntos`: `distsPunto`, `distA`, `distA_le`,
`le_distA`, `distA_nonneg`, `distA_le_add` y los cinco ítems). Este archivo sólo re-enuncia los
ítems.
-/
import Mathlib
import Comun.Topologia.DistConjuntos

open Comun

namespace Guias.Guia3.Ej10

variable {E : Type*} [MetricSpace E]

/-- **Ejercicio 10 (a).** `|d(x, A) - d(y, A)| ≤ d(x, y)` (`Comun.abs_distA_sub_le`). -/
theorem abs_distA_sub_le {A : Set E} (hA : A.Nonempty) (x y : E) :
    |distA x A - distA y A| ≤ dist x y :=
  Comun.abs_distA_sub_le hA x y

/-- **Ejercicio 10 (b).** `x ∈ A → d(x, A) = 0`: `0` es cota inferior y `0 = d(x, x)`
es un elemento del conjunto (Proposición 6) (`Comun.distA_eq_zero_of_mem`). -/
theorem distA_eq_zero_of_mem {A : Set E} (hA : A.Nonempty) {x : E} (hx : x ∈ A) :
    distA x A = 0 :=
  Comun.distA_eq_zero_of_mem hA hx

/-- **Ejercicio 10 (c).** `d(x, A) = 0 ↔ x ∈ cl A`. Se usa la caracterización por bolas
de la clausura (`Metric.mem_closure_iff`: para todo `ε > 0` hay `a ∈ A` con `d(x, a) < ε`)
y la Proposición 5 (equivalencia de ínfimo) en el sentido que corresponda
(`Comun.distA_eq_zero_iff`). -/
theorem distA_eq_zero_iff {A : Set E} (hA : A.Nonempty) (x : E) :
    distA x A = 0 ↔ x ∈ closure A :=
  Comun.distA_eq_zero_iff hA x

/-- **Ejercicio 10 (d).** `B_A(r) = {x : d(x, A) < r}` es abierto.
Si `d(x, A) < r`, con `ρ = r - d(x, A)` vale `B(x, ρ) ⊆ B_A(r)` por (a) (`Comun.isOpen_bolaA`). -/
theorem isOpen_bolaA {A : Set E} (hA : A.Nonempty) (r : ℝ) :
    IsOpen {x : E | distA x A < r} :=
  Comun.isOpen_bolaA hA r

/-- **Ejercicio 10 (e).** `B̄_A(r) = {x : d(x, A) ≤ r}` es cerrado: su complemento
`{x : d(x, A) > r}` es abierto. Si `d(x, A) > r`, con `ρ = d(x, A) - r` vale
`B(x, ρ) ⊆ {d(·, A) > r}` por (a) (`Comun.isClosed_bolaCerradaA`). -/
theorem isClosed_bolaCerradaA {A : Set E} (hA : A.Nonempty) (r : ℝ) :
    IsClosed {x : E | distA x A ≤ r} :=
  Comun.isClosed_bolaCerradaA hA r

end Guias.Guia3.Ej10
