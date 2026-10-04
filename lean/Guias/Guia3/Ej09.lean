/-
Análisis Avanzado (FCEN-UBA) · Práctica 3 · Ejercicio 9 (frontera).
Enunciado en `apuntes-typst/guias/p3.typ`; resolución en `apuntes-typst/guias-agente/guia_3_resuelta_agente.typ` (Ejercicio 9).

Sea `E` un espacio métrico y `A ⊆ E`.
(a) `∂A = cl A ∖ A°`, y `∂A` es cerrado.
(b) `∂A = cl A ∩ cl (E ∖ A)`, y por lo tanto `∂A = ∂(E ∖ A)`.

La frontera es la de la Definición 4.38 de `apuntes.typ` (`fronteraCurso`), definida por bolas.
`interior` y `closure` son los de Mathlib, pero se manejan siempre a través de su
caracterización por bolas (Definiciones 4.11 y 4.22). Los Ejercicios 5 (a) y 5 (b) del Typst
(`E ∖ A° = cl (E ∖ A)`, `E ∖ cl A = (E ∖ A)°`) se reprueban acá como `compl_interior_eq` y
`compl_closure_eq`, y con ellos "`A°` es abierto" y "`cl A` es cerrado" (Paso 3 del texto), sin
usar `isOpen_interior`/`isClosed_closure` de Mathlib.
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

/-- Paso 3 del texto: `A°` es abierto. Si `B(x, r) ⊆ A` e `y ∈ B(x, r)`, la bola
`B(y, r - d(y, x))` queda dentro de `B(x, r) ⊆ A` (triangular), así que `y ∈ A°`. -/
theorem isOpen_interior_bolas (A : Set E) : IsOpen (interior A) := by
  rw [Metric.isOpen_iff]
  intro x hx
  obtain ⟨r, hr, hsub⟩ := mem_interior_bolas.1 hx
  refine ⟨r, hr, fun y hy => ?_⟩
  rw [Metric.mem_ball] at hy
  refine mem_interior_bolas.2 ⟨r - dist y x, by linarith, fun z hz => hsub ?_⟩
  rw [Metric.mem_ball] at hz ⊢
  calc dist z x ≤ dist z y + dist y x := dist_triangle _ _ _
    _ < r := by linarith

/-- **Ejercicio 5 (b)**, reprobado localmente: `E ∖ cl A = (E ∖ A)°` (es el (a) aplicado a `E ∖ A`). -/
theorem compl_closure_eq (A : Set E) : (closure A)ᶜ = interior Aᶜ := by
  rw [← compl_compl (interior Aᶜ), compl_interior_eq, compl_compl]

/-- Paso 3 del texto: `cl A` es cerrado, porque su complemento `(E ∖ A)°` es abierto
(Ej. 5 (b) y Teorema 4.29, que acá es `isOpen_compl_iff`). -/
theorem isClosed_closure_bolas (A : Set E) : IsClosed (closure A) := by
  rw [← isOpen_compl_iff, compl_closure_eq]
  exact isOpen_interior_bolas Aᶜ

/-- **Ejercicio 9 (a), cerrado.** `∂A = cl A ∩ (E ∖ A°)` es intersección de dos cerrados
(Teorema 4.31 (a)): `cl A` por `isClosed_closure_bolas` y `E ∖ A°` por el Teorema 4.29
(`isClosed_compl_iff`) con `isOpen_interior_bolas`. -/
theorem frontera_isClosed (A : Set E) : IsClosed (fronteraCurso A) := by
  rw [frontera_eq_sdiff, Set.sdiff_eq]
  exact (isClosed_closure_bolas A).inter (isClosed_compl_iff.2 (isOpen_interior_bolas A))

/-- Lo mismo en la forma de la Definición 4.27: `cl (∂A) = ∂A`. -/
theorem closure_frontera_eq (A : Set E) : closure (fronteraCurso A) = fronteraCurso A :=
  (frontera_isClosed A).closure_eq

/-- **Ejercicio 9 (b), igualdad.** `∂A = cl A ∩ cl (E ∖ A)`. -/
theorem frontera_eq_inter_closure_compl (A : Set E) :
    fronteraCurso A = closure A ∩ closure Aᶜ := frontera_eq_inter A

/-- **Ejercicio 9 (b), conclusión.** `∂A = ∂(E ∖ A)`: como `E ∖ (E ∖ A) = A`, la fórmula
anterior aplicada a `E ∖ A` da `cl (E ∖ A) ∩ cl A`, que es lo mismo por conmutatividad. -/
theorem frontera_compl (A : Set E) : fronteraCurso A = fronteraCurso Aᶜ := by
  rw [frontera_eq_inter A, frontera_eq_inter Aᶜ, compl_compl, Set.inter_comm]

end Guias.Guia3.Ej09
