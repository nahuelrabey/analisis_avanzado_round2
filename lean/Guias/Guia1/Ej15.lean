/-
Práctica 1, Ejercicio 15: si toda subsucesión de `(x_n)` tiene una sub-subsucesión que converge
a `ℓ`, entonces `x_n → ℓ`. Nociones del curso: `Converge` (Definición 7) y subsucesión (`x ∘ φ`
con `StrictMono φ`), de `Comun`.
Resolución "a mano" en `apuntes-typst/guias-agente/guia_1_resuelta_agente.typ` (Ejercicio 15).

La prueba sigue el texto: por el absurdo, la Definición 9 (negación de la convergencia) da
`ε₀ > 0` tal que para todo `N` hay `n ≥ N` con `|x_n - ℓ| ≥ ε₀`; con eso se construye
recursivamente una subsucesión "mala" `n_0 < n_1 < …` con `|x_(n_k) - ℓ| ≥ ε₀` para todo `k`.
Por hipótesis tiene una sub-subsucesión que converge a `ℓ`, pero sus términos distan `≥ ε₀` de
`ℓ`: con `ε = ε₀` en la Definición 7 se llega a `ε₀ ≤ |x_(n_(k_j)) - ℓ| < ε₀`. No se usa
`tendsto_of_subseq_tendsto` ni `Tendsto`.
La subsucesión "mala" es el lema `exists_subseq_far_of_not_converge` de `Comun.Sucesiones`
(que usa la construcción recursiva `exists_strictMono_of_step`, compartida con el Ej. 14); de
ahí se importa también la Definición 7. El cierre por el absurdo, que es el ejercicio, queda local.
-/
import Mathlib
import Comun.Sucesiones

namespace Guias.Guia1.Ej15

open Comun

/-- **Ej. 15.** Si toda subsucesión `(x_(φ k))` tiene una sub-subsucesión `(x_(φ (ψ j)))` que
converge a `ℓ`, entonces `x_n → ℓ`. Por el absurdo: la subsucesión "mala" de
`Comun.exists_subseq_far_of_not_converge` tendría una sub-subsucesión convergente a `ℓ`, y en el
índice `j₀` que da la Definición 7 con `ε = ε₀` resultaría `ε₀ ≤ |x_(φ (ψ j₀)) - ℓ| < ε₀`. -/
theorem ej15 {x : ℕ → ℝ} {l : ℝ}
    (h : ∀ φ : ℕ → ℕ, StrictMono φ → ∃ ψ : ℕ → ℕ, StrictMono ψ ∧ Converge (x ∘ φ ∘ ψ) l) :
    Converge x l := by
  by_contra hnc
  obtain ⟨ε₀, hε₀, φ, hφ, hfar⟩ := exists_subseq_far_of_not_converge hnc
  obtain ⟨ψ, _, hconv⟩ := h φ hφ
  obtain ⟨j₀, hj₀⟩ := hconv ε₀ hε₀
  have hlt : |x (φ (ψ j₀)) - l| < ε₀ := hj₀ j₀ le_rfl
  exact absurd (hfar (ψ j₀)) (not_le.2 hlt)

end Guias.Guia1.Ej15
