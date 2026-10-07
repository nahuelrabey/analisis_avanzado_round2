/-
Análisis Avanzado (FCEN-UBA) · Práctica 1 · Ejercicio 10
Enunciado en `apuntes-typst/guias/p1.typ`; resolución en
`apuntes-typst/guias-agente/guia_1_resuelta_agente.typ` (Ejercicio 10).

Si `x_n → ℓ₁`, `y_n → ℓ₂` y `x_n ≤ y_n` para todo `n`, entonces `ℓ₁ ≤ ℓ₂`. Por el absurdo: si
`ℓ₂ < ℓ₁`, con `ε = (ℓ₁ - ℓ₂)/2` y `n = máx(n₁, n₂)` queda `x_n > ℓ₁ - ε = ℓ₂ + ε > y_n`.
Es el ítem e de la Proposición 6 (Álgebra de límites): no se usa `algebra_limites_le` ni
`le_of_tendsto_of_tendsto`; sólo la Definición 7.
-/
import Mathlib
import Comun.Reales
import Comun.Supremos
import Comun.Sucesiones

namespace Guias.Guia1.Ej10

open Comun

/-- **Ej. 10.** Si `x_n → ℓ₁`, `y_n → ℓ₂` y `x_n ≤ y_n` para todo `n`, entonces `ℓ₁ ≤ ℓ₂`.
Por el absurdo con `ε = (ℓ₁ - ℓ₂)/2` y `n₀ = máx(n₁, n₂)`. -/
theorem ej10 {x y : ℕ → ℝ} {l₁ l₂ : ℝ} (hx : Converge x l₁) (hy : Converge y l₂)
    (hxy : ∀ n, x n ≤ y n) : l₁ ≤ l₂ := by
  by_contra hcon
  push Not at hcon
  -- `ε = (ℓ₁ - ℓ₂)/2 > 0`
  have hε : 0 < (l₁ - l₂) / 2 := by linarith
  obtain ⟨n₁, hn₁⟩ := hx _ hε
  obtain ⟨n₂, hn₂⟩ := hy _ hε
  -- en `n₀ = máx(n₁, n₂)` valen las dos cotas a la vez
  have h₁ := abs_sub_lt_iff.1 (hn₁ (max n₁ n₂) (le_max_left _ _))
  have h₂ := abs_sub_lt_iff.1 (hn₂ (max n₁ n₂) (le_max_right _ _))
  have h₃ := hxy (max n₁ n₂)
  -- `x_n > ℓ₁ - ε = ℓ₂ + ε > y_n`, contradicción con `x_n ≤ y_n`
  linarith [h₁.2, h₂.1]

end Guias.Guia1.Ej10
