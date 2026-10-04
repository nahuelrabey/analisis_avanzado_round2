/-
Práctica 3, Ejercicio 5 (interior y clausura de un complemento).
Resolución "a mano" en `apuntes-typst/guias-agente/_partes/ej05.typ`.

Se prueban (a) `E ∖ A° = cl (E ∖ A)` y (b) `E ∖ cl A = (E ∖ A)°`, y se responde la pregunta final:
`cl A = cl (A°)` y `A° = (cl A)°` son falsas en general (contraejemplo `A = ℚ` en `ℝ`), aunque valen
las inclusiones `cl (A°) ⊆ cl A` y `A° ⊆ (cl A)°`.

Todo pasa por las definiciones por bolas (4.11, 4.22), vía `Metric.mem_closure_iff` y
`Metric.mem_nhds_iff`.
-/
import Mathlib

open Metric Set

namespace Guias.Guia3.Ej05

variable {E : Type*} [MetricSpace E]

/-! ## Herramientas del curso, por bolas -/

/-- Definición 4.11: `x` es interior de `A` si hay una bola abierta `B(x, r) ⊆ A`. -/
theorem mem_interior_iff_ball {A : Set E} {x : E} :
    x ∈ interior A ↔ ∃ r > 0, ball x r ⊆ A := by
  rw [mem_interior_iff_mem_nhds, Metric.mem_nhds_iff]

/-- Definición 4.22: `x` es de adherencia de `A` si toda bola `B(x, r)` corta a `A`. -/
theorem mem_closure_iff_ball {A : Set E} {x : E} :
    x ∈ closure A ↔ ∀ r > 0, (ball x r ∩ A).Nonempty := by
  rw [Metric.mem_closure_iff]
  constructor
  · intro h r hr
    obtain ⟨b, hb, hd⟩ := h r hr
    exact ⟨b, mem_ball.2 (by rwa [dist_comm]), hb⟩
  · intro h r hr
    obtain ⟨b, hb, hbA⟩ := h r hr
    exact ⟨b, hbA, by rw [dist_comm]; exact mem_ball.1 hb⟩

/-- Observación 4.23 (a): `A ⊆ cl A`. -/
theorem subset_closure_ball (A : Set E) : A ⊆ closure A := by
  intro x hx
  rw [mem_closure_iff_ball]
  exact fun r hr => ⟨x, mem_ball_self hr, hx⟩

/-- La clausura es monótona (inmediato de la Definición 4.22). -/
theorem closure_mono_ball {A B : Set E} (h : A ⊆ B) : closure A ⊆ closure B := by
  intro x hx
  rw [mem_closure_iff_ball] at hx ⊢
  intro r hr
  obtain ⟨z, hz1, hz2⟩ := hx r hr
  exact ⟨z, hz1, h hz2⟩

/-! ## (a) `E ∖ A° = cl (E ∖ A)` -/

/-- **Ej. 5 (a).** `x ∉ A°` ⟺ ninguna bola `B(x, r)` está contenida en `A` ⟺ toda bola `B(x, r)`
corta a `E ∖ A` ⟺ `x ∈ cl (E ∖ A)`. -/
theorem ej5a (A : Set E) : (interior A)ᶜ = closure Aᶜ := by
  ext x
  rw [mem_compl_iff, mem_interior_iff_ball, mem_closure_iff_ball]
  constructor
  · intro h r hr
    by_contra hne
    apply h
    refine ⟨r, hr, fun z hz => ?_⟩
    by_contra hzA
    exact hne ⟨z, hz, hzA⟩
  · rintro h ⟨r, hr, hsub⟩
    obtain ⟨z, hz1, hz2⟩ := h r hr
    exact hz2 (hsub hz1)

/-! ## (b) `E ∖ cl A = (E ∖ A)°` -/

/-- **Ej. 5 (b).** `x ∉ cl A` ⟺ existe `r > 0` con `B(x, r) ∩ A = ∅` ⟺ existe `r > 0` con
`B(x, r) ⊆ E ∖ A` ⟺ `x ∈ (E ∖ A)°`. -/
theorem ej5b (A : Set E) : (closure A)ᶜ = interior Aᶜ := by
  ext x
  rw [mem_compl_iff, mem_closure_iff_ball, mem_interior_iff_ball]
  constructor
  · intro h
    by_contra hne
    apply h
    intro r hr
    by_contra hemp
    apply hne
    refine ⟨r, hr, fun z hz hzA => hemp ⟨z, hz, hzA⟩⟩
  · rintro ⟨r, hr, hsub⟩ h
    obtain ⟨z, hz1, hz2⟩ := h r hr
    exact hsub hz1 hz2

/-! ## Las inclusiones que sí valen -/

/-- `cl (A°) ⊆ cl A`, pues `A° ⊆ A` (Observación 4.12) y la clausura es monótona. -/
theorem closure_interior_subset (A : Set E) : closure (interior A) ⊆ closure A := by
  apply closure_mono_ball
  intro x hx
  obtain ⟨r, hr, hsub⟩ := mem_interior_iff_ball.1 hx
  exact hsub (mem_ball_self hr)

/-- `A° ⊆ (cl A)°`, pues `A ⊆ cl A` (Observación 4.23 (a)): la misma bola sirve. -/
theorem interior_subset_interior_closure (A : Set E) : interior A ⊆ interior (closure A) := by
  intro x hx
  obtain ⟨r, hr, hsub⟩ := mem_interior_iff_ball.1 hx
  exact mem_interior_iff_ball.2 ⟨r, hr, hsub.trans (subset_closure_ball A)⟩

/-! ## La pregunta final: contraejemplo `A = ℚ` en `ℝ` -/

/-- Los racionales como subconjunto de `ℝ`. -/
def Q : Set ℝ := range ((↑) : ℚ → ℝ)

/-- `cl ℚ = ℝ`: todo intervalo `(x - r, x + r)` contiene un racional (Densidad de `ℚ`). -/
theorem closure_Q : closure Q = univ := by
  ext x
  simp only [mem_univ, iff_true]
  rw [mem_closure_iff_ball]
  intro r hr
  obtain ⟨q, hq1, hq2⟩ := exists_rat_btwn (show x - r < x + r by linarith)
  refine ⟨q, mem_ball.2 ?_, q, rfl⟩
  rw [Real.dist_eq, abs_lt]
  constructor <;> linarith

/-- `ℚ° = ∅`: todo intervalo `(x, x + r)` contiene un irracional. -/
theorem interior_Q : interior Q = ∅ := by
  refine eq_empty_of_forall_notMem fun x hx => ?_
  obtain ⟨r, hr, hsub⟩ := mem_interior_iff_ball.1 hx
  obtain ⟨y, hy, hy1, hy2⟩ := exists_irrational_btwn (show x < x + r by linarith)
  have hmem : y ∈ ball x r := by
    rw [mem_ball, Real.dist_eq, abs_lt]
    constructor <;> linarith
  exact hy (hsub hmem)

/-- `cl ∅ = ∅`: ninguna bola corta al vacío. -/
theorem closure_empty_ball : closure (∅ : Set ℝ) = ∅ := by
  refine eq_empty_of_forall_notMem fun x hx => ?_
  obtain ⟨z, _, hz⟩ := mem_closure_iff_ball.1 hx 1 one_pos
  exact hz

/-- `ℝ° = ℝ`: toda bola está contenida en `ℝ`. -/
theorem interior_univ_ball : interior (univ : Set ℝ) = univ := by
  ext x
  simp only [mem_univ, iff_true]
  exact mem_interior_iff_ball.2 ⟨1, one_pos, subset_univ _⟩

/-- **Ej. 5, pregunta final (primera igualdad).** `cl ℚ = ℝ ≠ ∅ = cl (ℚ°)`: la igualdad
`cl A = cl (A°)` es falsa en general. -/
theorem closure_ne_closure_interior : closure Q ≠ closure (interior Q) := by
  rw [closure_Q, interior_Q, closure_empty_ball]
  exact univ_nonempty.ne_empty

/-- **Ej. 5, pregunta final (segunda igualdad).** `ℚ° = ∅ ≠ ℝ = (cl ℚ)°`: la igualdad
`A° = (cl A)°` es falsa en general. -/
theorem interior_ne_interior_closure : interior Q ≠ interior (closure Q) := by
  rw [closure_Q, interior_Q, interior_univ_ball]
  exact (univ_nonempty (α := ℝ)).ne_empty.symm

/-- **Ej. 5, pregunta final.** Ninguna de las dos igualdades vale para todo `A` (ni siquiera en `ℝ`). -/
theorem ej5_final :
    ¬ (∀ A : Set ℝ, closure A = closure (interior A)) ∧
    ¬ (∀ A : Set ℝ, interior A = interior (closure A)) :=
  ⟨fun h => closure_ne_closure_interior (h Q), fun h => interior_ne_interior_closure (h Q)⟩

end Guias.Guia3.Ej05
