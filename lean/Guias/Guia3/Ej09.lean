/-
Análisis Avanzado (FCEN-UBA) · Práctica 3 · Ejercicio 9 (frontera).
Enunciado en `apuntes-typst/guias/p3.typ`; resolución en `apuntes-typst/guias-agente/_partes/ej09.typ`.

Sea `E` un espacio métrico y `A ⊆ E`.
(a) `∂A = cl A ∖ A°`, y `∂A` es cerrado.
(b) `∂A = cl A ∩ cl (E ∖ A)`, y por lo tanto `∂A = ∂(E ∖ A)`.

La frontera es la de la Definición 4.38 de `apuntes.typ` (`fronteraCurso`), definida por bolas.
`interior` y `closure` son los de Mathlib, pero se manejan siempre a través de su
caracterización por bolas (Definiciones 4.11 y 4.22). El Ejercicio 5 (a) del Typst
(`E ∖ A° = cl (E ∖ A)`) se reprueba acá como `compl_interior_eq` (los archivos Lean son
independientes entre sí).
-/
import Mathlib

namespace Guias.Guia3.Ej09

variable {E : Type*} [MetricSpace E]

/-- Definición 4.38: `x ∈ ∂A` si toda bola `B(x, r)` corta a `A` y a `E ∖ A`. -/
def fronteraCurso (A : Set E) : Set E :=
  {x | ∀ r > 0, (Metric.ball x r ∩ A).Nonempty ∧ (Metric.ball x r ∩ Aᶜ).Nonempty}

/-- Definición 4.22: `x ∈ cl A` ⇔ toda bola `B(x, r)` corta a `A`. -/
theorem mem_closure_bolas {A : Set E} {x : E} :
    x ∈ closure A ↔ ∀ r > 0, (Metric.ball x r ∩ A).Nonempty := by
  rw [Metric.mem_closure_iff]
  constructor
  · intro h r hr
    obtain ⟨b, hb, hxb⟩ := h r hr
    exact ⟨b, Metric.mem_ball'.2 hxb, hb⟩
  · intro h r hr
    obtain ⟨b, hb, hbA⟩ := h r hr
    exact ⟨b, hbA, Metric.mem_ball'.1 hb⟩

/-- Definición 4.11: `x ∈ A°` ⇔ existe una bola `B(x, r) ⊆ A`. -/
theorem mem_interior_bolas {A : Set E} {x : E} :
    x ∈ interior A ↔ ∃ r > 0, Metric.ball x r ⊆ A := by
  rw [mem_interior_iff_mem_nhds, Metric.mem_nhds_iff]

/-- **Ejercicio 5 (a)**, reprobado localmente: `E ∖ A° = cl (E ∖ A)`.
Negar "existe una bola dentro de `A`" es "toda bola corta a `E ∖ A`". -/
theorem compl_interior_eq (A : Set E) : (interior A)ᶜ = closure Aᶜ := by
  ext x
  rw [Set.mem_compl_iff, mem_interior_bolas, mem_closure_bolas]
  push Not
  refine forall₂_congr fun r _ => ?_
  rw [Set.not_subset]
  constructor
  · rintro ⟨y, hy, hyA⟩
    exact ⟨y, hy, hyA⟩
  · rintro ⟨y, hy, hyA⟩
    exact ⟨y, hy, hyA⟩

/-- Reescritura por definición: `∂A = cl A ∩ cl (E ∖ A)` (ambas se leen por bolas). -/
theorem frontera_eq_inter (A : Set E) : fronteraCurso A = closure A ∩ closure Aᶜ := by
  ext x
  rw [Set.mem_inter_iff, mem_closure_bolas, mem_closure_bolas]
  constructor
  · intro h
    exact ⟨fun r hr => (h r hr).1, fun r hr => (h r hr).2⟩
  · rintro ⟨h1, h2⟩ r hr
    exact ⟨h1 r hr, h2 r hr⟩

/-- **Ejercicio 9 (a), igualdad.** `∂A = cl A ∖ A°`.
Se usa `∂A = cl A ∩ cl (E ∖ A)` y el Ejercicio 5 (a): `cl (E ∖ A) = E ∖ A°`. -/
theorem frontera_eq_sdiff (A : Set E) : fronteraCurso A = closure A \ interior A := by
  rw [frontera_eq_inter, ← compl_interior_eq]
  rfl

/-- **Ejercicio 9 (a), cerrado.** `∂A` es cerrado: es `cl A ∖ A°`, la clausura (cerrada)
menos un abierto (el interior). -/
theorem frontera_isClosed (A : Set E) : IsClosed (fronteraCurso A) := by
  rw [frontera_eq_sdiff]
  exact isClosed_closure.sdiff isOpen_interior

/-- **Ejercicio 9 (b), igualdad.** `∂A = cl A ∩ cl (E ∖ A)`. -/
theorem frontera_eq_inter_closure_compl (A : Set E) :
    fronteraCurso A = closure A ∩ closure Aᶜ := frontera_eq_inter A

/-- **Ejercicio 9 (b), conclusión.** `∂A = ∂(E ∖ A)`: como `E ∖ (E ∖ A) = A`, la fórmula
anterior aplicada a `E ∖ A` da `cl (E ∖ A) ∩ cl A`, que es lo mismo por conmutatividad. -/
theorem frontera_compl (A : Set E) : fronteraCurso A = fronteraCurso Aᶜ := by
  rw [frontera_eq_inter A, frontera_eq_inter Aᶜ, compl_compl, Set.inter_comm]

end Guias.Guia3.Ej09
