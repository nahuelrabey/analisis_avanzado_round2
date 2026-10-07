/-
Librería común `Comun`: definiciones del curso y resultados de `apuntes.typ` compartidos por las
guías (`Guias/`), los parciales (`Parciales/`) y los ejemplos (`Ejemplos/`). Ver
`apuntes-agente/lean-lemas-compartidos-y-organizacion.md` para el diseño.

`Comun.Metricas.EvNulas`: el espacio `X` de las sucesiones reales eventualmente nulas con la
distancia del supremo `d_∞(a, b) = sup |a_n - b_n|`, modelado como el subconjunto `EvNulas` de
`ℕ →ᵇ ℝ` (funciones acotadas `ℕ → ℝ`, que en Mathlib llevan exactamente `d_∞`) con la métrica
inducida. Es el contraejemplo canónico de espacio métrico no completo (**1er parcial 1C 2025,
Ej. 4 (b)**): la sucesión de truncadas `aN N = (1, 1/2, …, 1/N, 0, 0, …)` es de Cauchy
(`aN_cauchySeq`, pues `d_∞(aN n, aN m) ≤ 1/(N+1)` para `n, m ≥ N`) pero no converge en `EvNulas`
(`not_completeSpace_evNulas`): su único límite posible es `(1/(n+1))ₙ`, que no es eventualmente
nula. `continuous_eval_evNulas` dice que evaluar una coordenada es continuo en `EvNulas`
(sirve para pasar a coordenadas y para ver que los conjuntos definidos por "`a_n = 0`" son
cerrados). Las sucesiones empiezan en `0` (en el curso, en `1`).
-/
import Mathlib
import Comun.Reales

open Filter Topology BoundedContinuousFunction

namespace Comun

/-- El espacio `X` de las sucesiones eventualmente nulas, dentro de `(ℕ →ᵇ ℝ, d_∞)`. -/
def EvNulas : Set (ℕ →ᵇ ℝ) := {f | ∃ n₀, ∀ n ≥ n₀, f n = 0}

/-- Evaluar en una coordenada es continuo en `EvNulas` (la evaluación es `1`-Lipschitz para
`d_∞`, y la métrica de `EvNulas` es la inducida). -/
theorem continuous_eval_evNulas (n : ℕ) : Continuous fun a : EvNulas => (a : ℕ →ᵇ ℝ) n :=
  (continuous_eval_const n).comp continuous_subtype_val

/-- La sucesión de la sugerencia del parcial, truncada: `a⁽ᴺ⁾ = (1, 1/2, ..., 1/N, 0, 0, ...)`.
Con índices desde `0`: `a⁽ᴺ⁾ n = 1/(n+1)` si `n < N`, y `0` si no. -/
noncomputable def aN (N : ℕ) : EvNulas :=
  ⟨BoundedContinuousFunction.ofNormedAddCommGroupDiscrete
      (fun n => if n < N then 1 / ((n : ℝ) + 1) else 0) 1 (fun n => by
        split_ifs
        · rw [Real.norm_eq_abs, abs_of_pos (by positivity)]
          rw [div_le_one (by positivity)]; linarith [(Nat.cast_nonneg n : (0:ℝ) ≤ n)]
        · simp),
    N, fun n hn => by simp [not_lt.2 hn]⟩

@[simp] theorem aN_apply (N n : ℕ) :
    (aN N : ℕ →ᵇ ℝ) n = if n < N then 1 / ((n : ℝ) + 1) else 0 := rfl

/-- `(a⁽ᴺ⁾)_N` es de Cauchy en `EvNulas`: para `n, m ≥ N`, `d_∞(a⁽ⁿ⁾, a⁽ᵐ⁾) ≤ 1/(N+1)`
(las dos truncadas coinciden hasta el índice `N` y después cada coordenada vale `0` o
`1/(k+1) ≤ 1/(N+1)`), y `1/(N+1) → 0`. -/
theorem aN_cauchySeq : CauchySeq aN := by
  refine cauchySeq_of_le_tendsto_0 (fun N : ℕ => 1 / ((N : ℝ) + 1)) ?_
    tendsto_one_div_add_atTop_nhds_zero_nat
  intro n m N hn hm
  rw [Subtype.dist_eq, BoundedContinuousFunction.dist_le (by positivity)]
  intro k
  simp only [aN_apply, Real.dist_eq]
  split_ifs with h1 h2 h2
  · rw [sub_self, abs_zero]; positivity
  · rw [sub_zero, abs_of_pos (by positivity)]; exact one_div_succ_antitone (by omega)
  · rw [zero_sub, abs_neg, abs_of_pos (by positivity)]; exact one_div_succ_antitone (by omega)
  · rw [sub_self, abs_zero]; positivity

/-- **1er parcial 1C 2025, Ej. 4 (b).** `(X, d_∞)` no es completo: la sucesión de Cauchy
`(a⁽ᴺ⁾)_N` no converge en `EvNulas`. Si convergiera a `b`, que es nula desde algún `n₀`, la
coordenada `n₀` (continua) tendería a `b n₀ = 0`; pero vale `1/(n₀+1)` para todo `N > n₀`. -/
theorem not_completeSpace_evNulas : ¬ CompleteSpace EvNulas := by
  intro hc
  obtain ⟨b, hb⟩ := cauchySeq_tendsto_of_complete aN_cauchySeq
  obtain ⟨n₀, hn₀⟩ := b.2
  -- la coordenada `n₀` converge a `b n₀ = 0` ...
  have hcoord : Tendsto (fun N => (aN N : ℕ →ᵇ ℝ) n₀) atTop (𝓝 ((b : ℕ →ᵇ ℝ) n₀)) :=
    ((continuous_eval_evNulas n₀).tendsto b).comp hb
  -- ... pero esa coordenada vale `1/(n₀+1)` para todo `N > n₀`.
  have hconst : Tendsto (fun N => (aN N : ℕ →ᵇ ℝ) n₀) atTop (𝓝 (1 / ((n₀ : ℝ) + 1))) := by
    refine tendsto_const_nhds.congr' ?_
    filter_upwards [eventually_gt_atTop n₀] with N hN
    simp [hN]
  have := tendsto_nhds_unique hcoord hconst
  rw [hn₀ n₀ le_rfl] at this
  have : (0 : ℝ) < 1 / ((n₀ : ℝ) + 1) := by positivity
  linarith

end Comun
