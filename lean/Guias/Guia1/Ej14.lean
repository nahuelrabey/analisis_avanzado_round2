/-
Práctica 1, Ejercicio 14: toda sucesión no acotada superiormente tiene una subsucesión que
diverge a `+∞`. Nociones del curso: `AcotadoSup` (Definición 1), subsucesión (`x ∘ φ` con
`StrictMono φ`) y `DivergeMasInf` (Definición 8), de `Comun`.
Resolución "a mano" en `apuntes-typst/guias-agente/guia_1_resuelta_agente.typ` (Ejercicio 14).

La prueba sigue el texto: (1) si `{x_n}` no está acotado superiormente, para todo `K` y todo `N`
hay `n > N` con `x_n > K` (si no, `máx {x_0, …, x_N, K}` sería cota superior: el máximo de
finitos números se obtiene por inducción en `N`); (2) con eso se elige recursivamente
`n_0 < n_1 < …` con `x_(n_k) > k`; (3) dado `M > 0`, el Principio de Arquímedes da `k₀ ≥ M` y
para `k ≥ k₀` resulta `x_(n_k) > k ≥ k₀ ≥ M`. No se usa `Tendsto` ni `Filter.extraction_of_*`.
-/
import Mathlib
import Comun.Reales
import Comun.Supremos
import Comun.Sucesiones

namespace Guias.Guia1.Ej14

open Comun

/-- Hecho de base: finitos números tienen un máximo. Por inducción en `N`, hay `c` con
`x_n ≤ c` para todo `n ≤ N` (`c = máx {x_0, …, x_N}`). -/
theorem exists_bound_finite (x : ℕ → ℝ) (N : ℕ) : ∃ c : ℝ, ∀ n ≤ N, x n ≤ c := by
  induction N with
  | zero => exact ⟨x 0, fun n hn => by rw [Nat.le_zero.1 hn]⟩
  | succ N ih =>
    obtain ⟨c, hc⟩ := ih
    refine ⟨max c (x (N + 1)), fun n hn => ?_⟩
    rcases Nat.lt_or_ge n (N + 1) with h | h
    · exact (hc n (Nat.lt_succ_iff.1 h)).trans (le_max_left _ _)
    · rw [le_antisymm hn h]; exact le_max_right _ _

/-- Paso (1): si `{x_n}` no está acotado superiormente, para todo `K ∈ ℝ` y todo `N ∈ ℕ` hay
`n > N` con `x_n > K`. Si no, `máx {x_0, …, x_N, K}` sería cota superior de `{x_n}`. -/
theorem exists_gt_of_not_acotadoSup {x : ℕ → ℝ} (h : ¬ AcotadoSup (Set.range x)) (K : ℝ)
    (N : ℕ) : ∃ n > N, K < x n := by
  by_contra hcon
  push Not at hcon
  obtain ⟨c, hc⟩ := exists_bound_finite x N
  apply h
  refine ⟨max c K, ?_⟩
  rintro _ ⟨n, rfl⟩
  rcases Nat.lt_or_ge N n with hn | hn
  · exact (hcon n hn).trans (le_max_right _ _)
  · exact (hc n hn).trans (le_max_left _ _)

/-- Construcción recursiva de índices: si para cada `k` y cada `N` hay `n > N` con `P k n`,
entonces hay `φ` estrictamente creciente con `P k (φ k)` para todo `k`. Se elige `φ 0` con
`P 0 (φ 0)` y, dado `φ k`, se elige `φ (k + 1) > φ k` con `P (k + 1) (φ (k + 1))`. -/
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

/-- **Ej. 14.** Si `(x_n)` no está acotada superiormente, hay una subsucesión `(x_(φ k))` que
diverge a `+∞`: se eligen `φ 0 < φ 1 < …` con `x_(φ k) > k` y, dado `M > 0`, el Principio de
Arquímedes (`arquimedes`) da `k₀` con `M ≤ k₀`; para `k ≥ k₀`, `M ≤ k₀ ≤ k < x_(φ k)`. -/
theorem ej14 {x : ℕ → ℝ} (h : ¬ AcotadoSup (Set.range x)) :
    ∃ φ : ℕ → ℕ, StrictMono φ ∧ DivergeMasInf (x ∘ φ) := by
  obtain ⟨φ, hφ, hgt⟩ := exists_strictMono_of_step
    (P := fun k n => (k : ℝ) < x n) (fun k N => exists_gt_of_not_acotadoSup h k N)
  refine ⟨φ, hφ, fun M _ => ?_⟩
  obtain ⟨k₀, hk₀⟩ := arquimedes M
  refine ⟨k₀, fun k hk => ?_⟩
  have hk' : (k₀ : ℝ) ≤ k := by exact_mod_cast hk
  have := hgt k
  simp only [Function.comp_apply]
  linarith

end Guias.Guia1.Ej14
