/-
Análisis Avanzado (FCEN-UBA) · Práctica 2 · Ejercicio 14
Enunciado en `apuntes-typst/guias/p2.typ`; resolución en
`apuntes-typst/guias-agente/guia_2_resuelta_agente.typ` (Ejercicio 14).

  (a) `#(𝒫(ℕ) × 𝒫(ℕ)) = c`: `𝒫(ℕ) × 𝒫(ℕ) ∼ {0,1}^ℕ × {0,1}^ℕ ∼ {0,1}^ℕ ∼ 𝒫(ℕ)` (intercalando
      pares e impares) y `#𝒫(ℕ) = c` (Ej. 10 (b), reprobado acá).
  (b) `#([0,1) × [0,1)) = c`: `[0,1) ∼ ℝ` (Obs. 3.21) y `ℝ × ℝ ∼ ℝ`, con
      `ℝ × ℝ ↪ 𝒫(ℚ) × 𝒫(ℚ) ∼ 𝒫(ℕ) × 𝒫(ℕ) ∼ 𝒫(ℕ) ↪ ℝ` para `≤`.
  (c) `#ℝ^k = c` para `k ≥ 1`, por inducción con `ℝ^(k+1) ∼ ℝ × ℝ^k`.

`𝒫(A)` es `Set A`, `{0,1}` es `Bool`, `ℝ^k` es `Fin k → ℝ`. Todo vive en
`Comun.Cardinales.Continuo` (`setProdEquiv`, `cardC_set_nat`, `cardC_set_nat_prod`,
`cardC_real_prod`, `cardC_pi`, con `intercalar`, cortes y serie); acá sólo se re-enuncian los
tres ítems.
-/
import Mathlib
import Comun.Cardinales
import Comun.Cardinales.Continuo

open Comun

namespace Guias.Guia2.Ej14

/-! ### Los tres ítems -/

/-- **Ej. 14 (a).** `#(𝒫(ℕ) × 𝒫(ℕ)) = c`: `𝒫(ℕ) × 𝒫(ℕ) ∼ 𝒫(ℕ)` intercalando pares e impares y
`#𝒫(ℕ) = c` (`Comun.cardC_set_nat_prod`). -/
theorem ej14a : CardC (Set ℕ × Set ℕ) := cardC_set_nat_prod

/-- **Ej. 14 (b).** `#([0,1) × [0,1)) = c`: `[0,1) ∼ ℝ` (Obs. 3.21) y `ℝ × ℝ ∼ ℝ`
(`Comun.cardC_real_prod`). -/
theorem ej14b : CardC (Set.Ico (0 : ℝ) 1 × Set.Ico (0 : ℝ) 1) := by
  obtain ⟨e⟩ := cardC_Ico (zero_lt_one' ℝ)
  exact coordinables_trans ⟨e.prodCongr e⟩ cardC_real_prod

/-- **Ej. 14 (c).** `#ℝ^k = c` para todo `k ≥ 1` (`Comun.cardC_pi`). -/
theorem ej14c (k : ℕ) (hk : 1 ≤ k) : CardC (Fin k → ℝ) := by
  obtain ⟨j, rfl⟩ := Nat.exists_eq_add_of_le' hk
  exact cardC_pi j

end Guias.Guia2.Ej14
