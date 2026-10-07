/-
Análisis Avanzado (FCEN-UBA) · Práctica 1 · Ejercicio 8
Enunciado en `apuntes-typst/guias/p1.typ`; resolución en
`apuntes-typst/guias-agente/guia_1_resuelta_agente.typ` (Ejercicio 8).

Si `|x_n - ℓ| ≤ a_n` para todo `n` y `a_n → 0`, entonces `x_n → ℓ`. Directo desde la
Definición 7: dado `ε > 0`, el `n₀` de `a_n → 0` sirve para `x_n`, porque
`|x_n - ℓ| ≤ a_n ≤ |a_n| = |a_n - 0| < ε`. No se usa `squeeze_zero` ni `Tendsto`.
-/
import Mathlib
import Comun.Reales
import Comun.Supremos
import Comun.Sucesiones

namespace Guias.Guia1.Ej08

open Comun

/-- **Ej. 8.** Dado `ε > 0`, se toma el `n₀` de `a_n → 0` (Definición 7) y para `n ≥ n₀`:
`|x_n - ℓ| ≤ a_n ≤ |a_n| = |a_n - 0| < ε`. -/
theorem ej8 {x a : ℕ → ℝ} {l : ℝ} (h : ∀ n, |x n - l| ≤ a n) (ha : Converge a 0) :
    Converge x l := by
  intro ε hε
  obtain ⟨n₀, hn₀⟩ := ha ε hε
  refine ⟨n₀, fun n hn => ?_⟩
  have h1 : |a n - 0| < ε := hn₀ n hn
  rw [sub_zero] at h1
  calc |x n - l| ≤ a n := h n
    _ ≤ |a n| := le_abs_self _
    _ < ε := h1

end Guias.Guia1.Ej08
