/-
Práctica 3 · Ejercicio 16 (`apuntes-typst/guias/p3.typ`): teorema de la intersección de Cantor.

Sea `E` un espacio métrico completo y `(Aₙ)` una sucesión de subconjuntos cerrados, acotados y
no vacíos de `E` con `Aₙ₊₁ ⊆ Aₙ` y `diam(Aₙ) → 0`. Entonces existe un único `x ∈ ⋂ₙ Aₙ`.

Convención: la sucesión empieza en `n = 0` (en el curso, en `n = 1`).
`Metric.diam` es el diámetro de la Definición 4.9 (`sup {d(x, y)}`) para conjuntos acotados.

Pasos (los mismos del texto Typst):
1. elegir `xₙ ∈ Aₙ`;
2. `(xₙ)` es de Cauchy: para `m, n ≥ N`, `xₘ, xₙ ∈ A_N`, luego `d(xₘ, xₙ) ≤ diam(A_N) < ε`;
3. converge a un `x` por completitud;
4. `x ∈ Aₙ` para todo `n`: la cola `(xₘ)_{m ≥ n}` está en `Aₙ`, que es cerrado (Corolario 4.47);
5. unicidad: si `y, z ∈ ⋂ Aₙ`, entonces `d(y, z) ≤ diam(Aₙ) → 0`.
-/
import Mathlib

open Filter Topology

namespace Guias.Guia3.Ej16

variable {E : Type*} [MetricSpace E]

/-- Los `Aₙ` son decrecientes: `Aₘ ⊆ Aₙ` si `n ≤ m`. -/
theorem sub_of_le {X : Type*} (A : ℕ → Set X) (hdec : ∀ n, A (n + 1) ⊆ A n) {n m : ℕ} (h : n ≤ m) :
    A m ⊆ A n := by
  induction h with
  | refl => exact subset_rfl
  | step _ ih => exact (hdec _).trans ih

/-- **Ejercicio 16 (Cantor).** Existe un único `x ∈ ⋂ₙ Aₙ`. -/
theorem ej16 [CompleteSpace E] (A : ℕ → Set E)
    (hcerr : ∀ n, IsClosed (A n)) (hacot : ∀ n, Bornology.IsBounded (A n))
    (hne : ∀ n, (A n).Nonempty) (hdec : ∀ n, A (n + 1) ⊆ A n)
    (hdiam : Tendsto (fun n => Metric.diam (A n)) atTop (𝓝 0)) :
    ∃! x, x ∈ ⋂ n, A n := by
  -- 1. elegimos `xₙ ∈ Aₙ`
  choose x hx using hne
  -- 2. `(xₙ)` es de Cauchy
  have hcauchy : CauchySeq x := by
    rw [Metric.cauchySeq_iff]
    intro ε hε
    obtain ⟨N, hN⟩ := (Metric.tendsto_atTop.1 hdiam) ε hε
    refine ⟨N, fun m hm n hn => ?_⟩
    have hmN : x m ∈ A N := sub_of_le A hdec hm (hx m)
    have hnN : x n ∈ A N := sub_of_le A hdec hn (hx n)
    have h1 : dist (x m) (x n) ≤ Metric.diam (A N) :=
      Metric.dist_le_diam_of_mem (hacot N) hmN hnN
    have h2 : Metric.diam (A N) < ε := by
      have := hN N le_rfl
      rw [Real.dist_eq, sub_zero] at this
      exact lt_of_le_of_lt (le_abs_self _) this
    exact lt_of_le_of_lt h1 h2
  -- 3. converge (completitud)
  obtain ⟨l, hl⟩ := cauchySeq_tendsto_of_complete hcauchy
  -- 4. `l ∈ Aₙ` para todo `n`
  have hlmem : l ∈ ⋂ n, A n := by
    rw [Set.mem_iInter]
    intro n
    apply (hcerr n).mem_of_tendsto hl
    rw [eventually_atTop]
    exact ⟨n, fun m hm => sub_of_le A hdec hm (hx m)⟩
  refine ⟨l, hlmem, fun y hy => ?_⟩
  -- 5. unicidad: `d(y, l) ≤ diam(Aₙ) → 0`
  have hle : dist y l ≤ 0 := by
    apply ge_of_tendsto' hdiam
    intro n
    exact Metric.dist_le_diam_of_mem (hacot n) (Set.mem_iInter.1 hy n) (Set.mem_iInter.1 hlmem n)
  exact dist_le_zero.1 hle

end Guias.Guia3.Ej16
