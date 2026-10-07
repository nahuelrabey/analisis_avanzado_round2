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
Los pasos (1) y (2) son los lemas `exists_bound_finite`, `exists_gt_of_not_acotadoSup` y
`exists_strictMono_of_step` de `Comun.Sucesiones`; de `Comun.Reales` se importa `arquimedes` y
de `Comun.Supremos` la Definición 1. El paso (3), que es el ejercicio, queda local.
-/
import Mathlib
import Comun.Reales
import Comun.Supremos
import Comun.Sucesiones

namespace Guias.Guia1.Ej14

open Comun

/-- **Ej. 14.** Si `(x_n)` no está acotada superiormente, hay una subsucesión `(x_(φ k))` que
diverge a `+∞`: se eligen `φ 0 < φ 1 < …` con `x_(φ k) > k` (`exists_strictMono_of_step` sobre
`exists_gt_of_not_acotadoSup`) y, dado `M > 0`, el Principio de Arquímedes (`arquimedes`) da
`k₀` con `M ≤ k₀`; para `k ≥ k₀`, `M ≤ k₀ ≤ k < x_(φ k)`. -/
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
