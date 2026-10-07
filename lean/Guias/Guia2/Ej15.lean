/-
Análisis Avanzado (FCEN-UBA) · Práctica 2 · Ejercicio 15
Enunciado en `apuntes-typst/guias/p2.typ`; resolución en
`apuntes-typst/guias-agente/guia_2_resuelta_agente.typ` (Ejercicio 15).

  `#ℝ[X] = c`.
  `≥`: los polinomios constantes, `ℝ ↪ ℝ[X]`.
  `≤`: `p ↦ (gr p, (coeficientes 0..gr p))` es `ℝ[X] ↪ ⋃ₙ ℝ^(n+1)` (en Lean, `Σ n, (Fin (n+1) → ℝ)`);
       cada `ℝ^(n+1)` tiene cardinal `c` (Ej. 14 (c)) y la unión numerable de conjuntos de cardinal
       `c` tiene cardinal `c` (Ej. 7 (b)). Ambos se reprueban acá: `ℝ^(n+1) ∼ ℝ` por inducción con
       `ℝ × ℝ ∼ ℝ`, y `ℕ × ℝ ↪ ℝ` vía `ℝ ∼ [0,1)` y `(n, x) ↦ n + x`.
  Se cierra con Cantor–Schröder–Bernstein.

Los auxiliares viven en `Comun.Cardinales.Continuo`: `ℝ^(n+1) ∼ ℝ` es `cardC_pi` (Ej. 14 (c)),
`ℕ × ℝ ↪ ℝ` es `cardLe_nat_prod_real` (con `sumaEmb`), y `p ↦ (gr p, coeficientes)` es
`coefsEmb` (sobre cualquier semianillo). Quedan locales `sigmaEmb`, `cardLe_poly_real` y
`cardLe_real_poly`.
-/
import Mathlib
import Comun.Cardinales
import Comun.Cardinales.Continuo

open Comun

namespace Guias.Guia2.Ej15

/-! ### `ℝ[X] ↪ ⋃ₙ ℝ^(n+1) ↪ ℕ × ℝ ↪ ℝ` -/

/-- `Σ n, ℝ^(n+1) ↪ Σ n, ℝ ∼ ℕ × ℝ`: en cada `n` se usa la biyección `ℝ^(n+1) ∼ ℝ` del Ej. 14 (c). -/
noncomputable def sigmaEmb : (Σ n : ℕ, (Fin (n + 1) → ℝ)) ↪ ℕ × ℝ :=
  (Function.Embedding.sigmaMap (Function.Embedding.refl ℕ)
    (fun n => (Classical.choice (cardC_pi n)).toEmbedding)).trans
    (Equiv.sigmaEquivProd ℕ ℝ).toEmbedding

/-- `#ℝ[X] ≤ #ℝ`: `ℝ[X] ↪ Σ n, ℝ^(n+1)` (`Comun.coefsEmb`), `↪ ℕ × ℝ` y `↪ ℝ`
(`Comun.cardLe_nat_prod_real`). -/
theorem cardLe_poly_real : CardLe (Polynomial ℝ) ℝ := by
  obtain ⟨f⟩ := cardLe_nat_prod_real
  exact ⟨coefsEmb.trans (sigmaEmb.trans f)⟩

/-- `#ℝ ≤ #ℝ[X]`: los polinomios constantes. -/
theorem cardLe_real_poly : CardLe ℝ (Polynomial ℝ) := ⟨⟨Polynomial.C, Polynomial.C_injective⟩⟩

/-- **Ej. 15.** `#ℝ[X] = c` (Cantor–Schröder–Bernstein). -/
theorem ej15 : CardC (Polynomial ℝ) := teorema_CSB cardLe_poly_real cardLe_real_poly

end Guias.Guia2.Ej15
