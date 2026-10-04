/-
Práctica 3 · Ejercicio 13 (`apuntes-typst/guias/p3.typ`).

Sea `(E, d)` un espacio métrico y `(xₙ)`, `(yₙ)` sucesiones en `E`.

(a) Si `xₙ → x` e `yₙ → y`, entonces `d(xₙ, yₙ) → d(x, y)`.
(b) Si `(xₙ)` e `(yₙ)` son de Cauchy, entonces `(d(xₙ, yₙ))` converge (en `ℝ`).

Convención: las sucesiones empiezan en `n = 0` (en el curso, en `n = 1`); ningún argumento
depende de esto.

La convergencia y el carácter de Cauchy se usan en su forma `ε`-`N` (Definiciones 4.42 y 4.51
de `apuntes.typ`) a través de `Metric.tendsto_atTop` y `Metric.cauchySeq_iff`. No se usa
`Filter.Tendsto.dist`, que es el enunciado (a).
-/
import Mathlib

open Filter Topology

namespace Guias.Guia3.Ej13

variable {E : Type*} [MetricSpace E]

/-- Desigualdad clave: `|d(xₙ, yₙ) − d(x, y)| ≤ d(xₙ, x) + d(yₙ, y)`.
(Se deduce de la desigualdad triangular aplicada dos veces, en cada sentido.) -/
theorem abs_dist_sub_dist_le (a b a' b' : E) :
    |dist a b - dist a' b'| ≤ dist a a' + dist b b' := by
  rw [abs_le]
  constructor
  · -- `d(a',b') ≤ d(a',a) + d(a,b) + d(b,b')`
    have h1 := dist_triangle a' a b
    have h2 := dist_triangle a' b b'
    have h3 := dist_comm a a'
    have h4 := dist_comm b b'
    linarith
  · -- `d(a,b) ≤ d(a,a') + d(a',b') + d(b',b)`
    have h1 := dist_triangle a a' b
    have h2 := dist_triangle a' b' b
    have h3 := dist_comm b b'
    linarith

/-- **Ejercicio 13 (a).** Si `xₙ → x` e `yₙ → y`, entonces `d(xₙ, yₙ) → d(x, y)`. -/
theorem ej13a (x y : ℕ → E) (a b : E)
    (hx : Tendsto x atTop (𝓝 a)) (hy : Tendsto y atTop (𝓝 b)) :
    Tendsto (fun n => dist (x n) (y n)) atTop (𝓝 (dist a b)) := by
  rw [Metric.tendsto_atTop] at hx hy ⊢
  intro ε hε
  -- argumento `ε / 2`
  obtain ⟨N₁, hN₁⟩ := hx (ε / 2) (by linarith)
  obtain ⟨N₂, hN₂⟩ := hy (ε / 2) (by linarith)
  refine ⟨max N₁ N₂, fun n hn => ?_⟩
  have h1 := hN₁ n (le_trans (le_max_left _ _) hn)
  have h2 := hN₂ n (le_trans (le_max_right _ _) hn)
  rw [Real.dist_eq]
  calc |dist (x n) (y n) - dist a b| ≤ dist (x n) a + dist (y n) b := abs_dist_sub_dist_le _ _ _ _
    _ < ε / 2 + ε / 2 := add_lt_add h1 h2
    _ = ε := by ring

/-- **Ejercicio 13 (b).** Si `(xₙ)` e `(yₙ)` son de Cauchy, la sucesión de reales `d(xₙ, yₙ)`
es de Cauchy y, por la completitud de `ℝ` (Teorema 4.57), converge. -/
theorem ej13b (x y : ℕ → E) (hx : CauchySeq x) (hy : CauchySeq y) :
    ∃ L : ℝ, Tendsto (fun n => dist (x n) (y n)) atTop (𝓝 L) := by
  -- primero: la sucesión de reales `d(xₙ, yₙ)` es de Cauchy
  have hc : CauchySeq (fun n => dist (x n) (y n)) := by
    rw [Metric.cauchySeq_iff] at hx hy ⊢
    intro ε hε
    obtain ⟨N₁, hN₁⟩ := hx (ε / 2) (by linarith)
    obtain ⟨N₂, hN₂⟩ := hy (ε / 2) (by linarith)
    refine ⟨max N₁ N₂, fun m hm n hn => ?_⟩
    have h1 := hN₁ m (le_trans (le_max_left _ _) hm) n (le_trans (le_max_left _ _) hn)
    have h2 := hN₂ m (le_trans (le_max_right _ _) hm) n (le_trans (le_max_right _ _) hn)
    rw [Real.dist_eq]
    calc |dist (x m) (y m) - dist (x n) (y n)| ≤ dist (x m) (x n) + dist (y m) (y n) :=
          abs_dist_sub_dist_le _ _ _ _
      _ < ε / 2 + ε / 2 := add_lt_add h1 h2
      _ = ε := by ring
  -- segundo: `ℝ` es completo (Teorema 4.57)
  exact cauchySeq_tendsto_of_complete hc

end Guias.Guia3.Ej13
