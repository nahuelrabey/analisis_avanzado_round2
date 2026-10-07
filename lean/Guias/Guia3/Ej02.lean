/-
Análisis Avanzado (FCEN-UBA) · Práctica 3 · Ejercicio 2
Enunciado en `apuntes-typst/guias/p3.typ`; resolución en `apuntes-typst/guias-agente/guia_3_resuelta_agente.typ` (Ejercicio 2).

Se decide cuáles de las funciones `d : ℝ × ℝ → ℝ` son métricas en `ℝ` (Definición 4.1):
  (a) `(x - y)²`      NO es métrica: falla la desigualdad triangular (`3, 2, 0`).
  (b) `√|x - y|`      SÍ es métrica.
  (c) `|x² - y²|`     NO es métrica: falla la separación (`1` y `-1`).

Qué importa de `Comun`: `EsMetrica` (`Comun.Metricas`) y el paso clave `√(a + b) ≤ √a + √b`
(`Comun.sqrt_add_le`, en `Comun.Topologia.Real`). Las tres funciones se llaman `dA2`, `dB`, `dC2`
(no `dA`/`dC`, que son las del Ej. 1 y de `C([0,1])`).
-/
import Mathlib
import Comun.Metricas
import Comun.Topologia.Real

namespace Guias.Guia3.Ej02

open Comun

/-- (a) `d(x, y) = (x - y)²`. -/
def dA2 (x y : ℝ) : ℝ := (x - y) ^ 2

/-- (b) `d(x, y) = √|x - y|`. -/
noncomputable def dB (x y : ℝ) : ℝ := Real.sqrt |x - y|

/-- (c) `d(x, y) = |x² - y²|`. -/
def dC2 (x y : ℝ) : ℝ := |x ^ 2 - y ^ 2|

/-! ## (a) `(x - y)²` no es métrica -/

/-- Contraejemplo a la desigualdad triangular: `d(3, 0) = 9 > 5 = d(3, 2) + d(2, 0)`. -/
theorem dA2_contraejemplo : ¬ (dA2 3 0 ≤ dA2 3 2 + dA2 2 0) := by
  unfold dA2
  norm_num

/-- **Ej. 2 (a).** `(x - y)²` no es una métrica en `ℝ`. -/
theorem ej2a : ¬ EsMetrica dA2 := fun h => dA2_contraejemplo (h.triangle 3 2 0)

/-! ## (c) `|x² - y²|` no es métrica -/

/-- Contraejemplo a la separación: `d(1, -1) = 0` pero `1 ≠ -1`. -/
theorem dC2_contraejemplo : dC2 1 (-1) = 0 ∧ (1 : ℝ) ≠ -1 := by
  refine ⟨?_, by norm_num⟩
  unfold dC2
  norm_num

/-- **Ej. 2 (c).** `|x² - y²|` no es una métrica en `ℝ`. -/
theorem ej2c : ¬ EsMetrica dC2 := fun h =>
  dC2_contraejemplo.2 ((h.eq_zero_iff 1 (-1)).1 dC2_contraejemplo.1)

/-! ## (b) `√|x - y|` es métrica -/

/-- **Ej. 2 (b).** `√|x - y|` es una métrica en `ℝ`. -/
theorem ej2b : EsMetrica dB where
  nonneg x y := Real.sqrt_nonneg _
  eq_zero_iff x y := by
    unfold dB
    rw [Real.sqrt_eq_zero (abs_nonneg _), abs_eq_zero, sub_eq_zero]
  symm x y := by
    unfold dB
    rw [abs_sub_comm]
  triangle x y z := by
    unfold dB
    calc Real.sqrt |x - z|
        ≤ Real.sqrt (|x - y| + |y - z|) := by
          apply Real.sqrt_le_sqrt
          calc |x - z| = |(x - y) + (y - z)| := by ring_nf
            _ ≤ |x - y| + |y - z| := abs_add_le _ _
      _ ≤ Real.sqrt |x - y| + Real.sqrt |y - z| :=
          sqrt_add_le _ _ (abs_nonneg _) (abs_nonneg _)

end Guias.Guia3.Ej02
