/-
Análisis Avanzado (FCEN-UBA) · Práctica 1 · Ejercicio 11
Enunciado en `apuntes-typst/guias/p1.typ`; resolución en
`apuntes-typst/guias-agente/guia_1_resuelta_agente.typ` (Ejercicio 11).

Si `x_n → 0` e `(y_n)` está acotada, entonces `x_n y_n → 0`. Con `|y_n| ≤ M` (`M > 0`,
Definición 9) y `|x_n| < ε/M` desde `n₀`, queda `|x_n y_n| = |x_n| |y_n| ≤ M |x_n| < ε`.
Sólo la Definición 7 y la Definición 9 (de `Comun.Sucesiones`): no se usa la Proposición 7 ni
`Filter.Tendsto`.
-/
import Mathlib
import Comun.Sucesiones

namespace Guias.Guia1.Ej11

open Comun

/-- **Ej. 11.** Si `x_n → 0` e `(y_n)` está acotada, entonces `x_n y_n → 0`. Dado `ε > 0`, con
`|y_n| ≤ M` para todo `n` se toma `n₀` tal que `|x_n| < ε/M` para `n ≥ n₀`. -/
theorem ej11 {x y : ℕ → ℝ} (hx : Converge x 0) (hy : Acotada y) :
    Converge (fun n => x n * y n) 0 := by
  obtain ⟨M, hM, hMy⟩ := hy
  intro ε hε
  -- `ε/M > 0`: la Definición 7 para `(x_n)` con ese `ε`
  obtain ⟨n₀, hn₀⟩ := hx (ε / M) (div_pos hε hM)
  refine ⟨n₀, fun n hn => ?_⟩
  have h₁ : |x n| < ε / M := by simpa using hn₀ n hn
  -- la cuenta: `|x_n y_n| = |x_n| |y_n| ≤ |x_n| M < ε`
  rw [sub_zero, abs_mul]
  calc |x n| * |y n| ≤ |x n| * M := mul_le_mul_of_nonneg_left (hMy n) (abs_nonneg _)
    _ < ε := (lt_div_iff₀ hM).1 h₁

end Guias.Guia1.Ej11
