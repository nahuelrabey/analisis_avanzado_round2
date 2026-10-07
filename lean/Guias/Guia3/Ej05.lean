/-
Práctica 3, Ejercicio 5 (interior y clausura de un complemento).
Resolución "a mano" en `apuntes-typst/guias-agente/guia_3_resuelta_agente.typ` (Ejercicio 5).

Se prueban (a) `E ∖ A° = cl (E ∖ A)` y (b) `E ∖ cl A = (E ∖ A)°`, y se responde la pregunta final:
`cl A = cl (A°)` y `A° = (cl A)°` son falsas en general (contraejemplo `A = ℚ` en `ℝ`), aunque valen
las inclusiones `cl (A°) ⊆ cl A` y `A° ⊆ (cl A)°`.

Todo pasa por las definiciones por bolas (4.11, 4.22), vía `Comun.mem_interior_iff_ball` y
`Comun.mem_closure_iff_ball`.

Qué importa de `Comun`: (a) y (b) son `Comun.compl_interior_eq` y `Comun.compl_closure_eq`
(`Comun.Topologia`), con las inclusiones `closure_interior_subset` e
`interior_subset_interior_closure`; `Q`, `closure_Q` e `interior_Q` están en
`Comun.Topologia.Real`. Queda local la pregunta final (el contraejemplo `A = ℚ`).
-/
import Mathlib
import Comun.Topologia
import Comun.Topologia.Real

open Metric Set Comun

namespace Guias.Guia3.Ej05

variable {E : Type*} [MetricSpace E]

/-! ## (a) `E ∖ A° = cl (E ∖ A)` -/

/-- **Ej. 5 (a).** `x ∉ A°` ⟺ ninguna bola `B(x, r)` está contenida en `A` ⟺ toda bola `B(x, r)`
corta a `E ∖ A` ⟺ `x ∈ cl (E ∖ A)` (`Comun.compl_interior_eq`). -/
theorem ej5a (A : Set E) : (interior A)ᶜ = closure Aᶜ := compl_interior_eq A

/-! ## (b) `E ∖ cl A = (E ∖ A)°` -/

/-- **Ej. 5 (b).** `x ∉ cl A` ⟺ existe `r > 0` con `B(x, r) ∩ A = ∅` ⟺ existe `r > 0` con
`B(x, r) ⊆ E ∖ A` ⟺ `x ∈ (E ∖ A)°` (`Comun.compl_closure_eq`). -/
theorem ej5b (A : Set E) : (closure A)ᶜ = interior Aᶜ := compl_closure_eq A

/-! ## Las inclusiones que sí valen

`cl (A°) ⊆ cl A` e `A° ⊆ (cl A)°` son `Comun.closure_interior_subset` y
`Comun.interior_subset_interior_closure`. -/

/-! ## La pregunta final: contraejemplo `A = ℚ` en `ℝ` -/

/-- `ℚ ⊆ ℝ` es `Comun.Q`, con `cl ℚ = ℝ` (`Comun.closure_Q`) y `ℚ° = ∅` (`Comun.interior_Q`). -/
theorem closure_Q_interior_Q : closure Q = univ ∧ interior Q = ∅ := ⟨closure_Q, interior_Q⟩

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
