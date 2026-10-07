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
-/
import Mathlib
import Comun.Reales
import Comun.Supremos
import Comun.Sucesiones

namespace Guias.Guia1.Ej15

open Comun

/-- Construcción recursiva de índices (la misma que en `Ej14.lean`): si para cada `k` y cada
`N` hay `n > N` con `P k n`, hay `φ` estrictamente creciente con `P k (φ k)` para todo `k`. -/
theorem exists_strictMono_of_step {P : ℕ → ℕ → Prop} (h : ∀ k N, ∃ n > N, P k n) :
    ∃ φ : ℕ → ℕ, StrictMono φ ∧ ∀ k, P k (φ k) := by
  choose f hf using h
  let φ : ℕ → ℕ := fun k => Nat.rec (f 0 0) (fun k ih => f (k + 1) ih) k
  have hφ0 : P 0 (φ 0) := (hf 0 0).2
  have hφs : ∀ k, φ k < φ (k + 1) ∧ P (k + 1) (φ (k + 1)) := fun k =>
    ⟨(hf (k + 1) (φ k)).1, (hf (k + 1) (φ k)).2⟩
  refine ⟨φ, strictMono_nat_of_lt_succ fun k => (hφs k).1, fun k => ?_⟩
  cases k with
  | zero => exact hφ0
  | succ k => exact (hφs k).2

/-- Definición 9 (negación de la convergencia) más la "subsucesión mala": si `x_n` no converge
a `ℓ`, hay `ε₀ > 0` y una subsucesión `(x_(φ k))` con `|x_(φ k) - ℓ| ≥ ε₀` para todo `k`. -/
theorem exists_subseq_far_of_not_converge {x : ℕ → ℝ} {l : ℝ} (h : ¬ Converge x l) :
    ∃ ε₀ > 0, ∃ φ : ℕ → ℕ, StrictMono φ ∧ ∀ k, ε₀ ≤ |x (φ k) - l| := by
  unfold Converge at h
  push Not at h
  obtain ⟨ε₀, hε₀, hbad⟩ := h
  refine ⟨ε₀, hε₀, ?_⟩
  have hstep : ∀ (k : ℕ) (N : ℕ), ∃ n > N, ε₀ ≤ |x n - l| := fun _ N => by
    obtain ⟨n, hn, hfar⟩ := hbad (N + 1)
    exact ⟨n, by omega, hfar⟩
  obtain ⟨φ, hφ, hfar⟩ := exists_strictMono_of_step hstep
  exact ⟨φ, hφ, hfar⟩

/-- **Ej. 15.** Si toda subsucesión `(x_(φ k))` tiene una sub-subsucesión `(x_(φ (ψ j)))` que
converge a `ℓ`, entonces `x_n → ℓ`. Por el absurdo: la subsucesión "mala" de
`exists_subseq_far_of_not_converge` tendría una sub-subsucesión convergente a `ℓ`, y en el
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
