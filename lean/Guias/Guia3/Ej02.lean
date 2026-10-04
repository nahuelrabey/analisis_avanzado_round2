/-
Análisis Avanzado (FCEN-UBA) · Práctica 3 · Ejercicio 2
Enunciado en `apuntes-typst/guias/p3.typ`; resolución en `apuntes-typst/guias-agente/_partes/ej02.typ`.

Se decide cuáles de las funciones `d : ℝ × ℝ → ℝ` son métricas en `ℝ` (Definición 4.1):
  (a) `(x - y)²`      NO es métrica: falla la desigualdad triangular (`0, 1, 2`).
  (b) `√|x - y|`      SÍ es métrica.
  (c) `|x² - y²|`     NO es métrica: falla la separación (`1` y `-1`).
-/
import Mathlib
import Guias.Common

namespace Guias.Guia3.Ej02

open Guias

/-- (a) `d(x, y) = (x - y)²`. -/
def dA (x y : ℝ) : ℝ := (x - y) ^ 2

/-- (b) `d(x, y) = √|x - y|`. -/
noncomputable def dB (x y : ℝ) : ℝ := Real.sqrt |x - y|

/-- (c) `d(x, y) = |x² - y²|`. -/
def dC (x y : ℝ) : ℝ := |x ^ 2 - y ^ 2|

/-! ## (a) `(x - y)²` no es métrica -/

/-- Contraejemplo a la desigualdad triangular: `d(0, 2) = 4 > 2 = d(0, 1) + d(1, 2)`. -/
theorem dA_contraejemplo : ¬ (dA 0 2 ≤ dA 0 1 + dA 1 2) := by
  unfold dA
  norm_num

/-- **Ej. 2 (a).** `(x - y)²` no es una métrica en `ℝ`. -/
theorem ej2a : ¬ EsMetrica dA := fun h => dA_contraejemplo (h.triangle 0 1 2)

/-! ## (c) `|x² - y²|` no es métrica -/

/-- Contraejemplo a la separación: `d(1, -1) = 0` pero `1 ≠ -1`. -/
theorem dC_contraejemplo : dC 1 (-1) = 0 ∧ (1 : ℝ) ≠ -1 := by
  refine ⟨?_, by norm_num⟩
  unfold dC
  norm_num

/-- **Ej. 2 (c).** `|x² - y²|` no es una métrica en `ℝ`. -/
theorem ej2c : ¬ EsMetrica dC := fun h =>
  dC_contraejemplo.2 ((h.eq_zero_iff 1 (-1)).1 dC_contraejemplo.1)

/-! ## (b) `√|x - y|` es métrica -/

/-- Paso clave: `√(a + b) ≤ √a + √b` para `a, b ≥ 0` (se eleva al cuadrado). -/
theorem sqrt_add_le (a b : ℝ) (ha : 0 ≤ a) (hb : 0 ≤ b) :
    Real.sqrt (a + b) ≤ Real.sqrt a + Real.sqrt b := by
  rw [Real.sqrt_le_iff]
  refine ⟨by positivity, ?_⟩
  have h1 := Real.sq_sqrt ha
  have h2 := Real.sq_sqrt hb
  nlinarith [mul_nonneg (Real.sqrt_nonneg a) (Real.sqrt_nonneg b)]

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
