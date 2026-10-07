/-
Análisis Avanzado (FCEN-UBA) · `ejemplos/p3.typ`, Ejemplo C3-6 (Clase 3, Ejercicio 6):
la métrica del peine en `ℝ²`,
  `d((x, y), (x', y')) = |y - y'|` si `x = x'`, y `|x - x'| + |y| + |y'|` si `x ≠ x'`.

Este archivo verifica la resolución escrita en el `.typ`: la simetría, el ítem (a) y los cinco
casos de la desigualdad triangular, en el mismo orden y con las mismas cotas.

Qué usa de `Comun`: la Definición 4.1 `EsMetrica` y el constructor `EsMetrica.toMetricSpace`
(`Comun.Metricas`) para armar la instancia `MetricSpace Plano` a partir de los cuatro axiomas,
que son el ejemplo y quedan locales (`d_nonneg`, `d_eq_zero_iff`, `d_comm`, `d_triangle`).
-/
import Mathlib
import Comun.Metricas

open scoped Classical
open Comun

namespace Peine

/-- La distancia del peine. -/
noncomputable def d (p q : ℝ × ℝ) : ℝ :=
  if p.1 = q.1 then |p.2 - q.2| else |p.1 - q.1| + |p.2| + |q.2|

theorem d_eq_of_eq {x y x' y' : ℝ} (h : x = x') : d (x, y) (x', y') = |y - y'| := by
  simp [d, h]

theorem d_eq_of_ne {x y x' y' : ℝ} (h : x ≠ x') :
    d (x, y) (x', y') = |x - x'| + |y| + |y'| := by
  simp [d, h]

/-- Simetría: los dos casos son simétricos en las dos entradas. -/
theorem d_comm (x y x' y' : ℝ) : d (x, y) (x', y') = d (x', y') (x, y) := by
  by_cases h : x = x'
  · rw [d_eq_of_eq h, d_eq_of_eq h.symm, abs_sub_comm]
  · rw [d_eq_of_ne h, d_eq_of_ne (Ne.symm h), abs_sub_comm]; ring

/-- `d ≥ 0`. -/
theorem d_nonneg (x y x' y' : ℝ) : 0 ≤ d (x, y) (x', y') := by
  by_cases h : x = x'
  · rw [d_eq_of_eq h]; exact abs_nonneg _
  · rw [d_eq_of_ne h]; positivity

/-- **(a)** `d((x, y), (x', y')) = 0 ↔ (x, y) = (x', y')`. -/
theorem d_eq_zero_iff (x y x' y' : ℝ) : d (x, y) (x', y') = 0 ↔ (x, y) = (x', y') := by
  constructor
  · intro h
    by_cases hx : x = x'
    · -- primer caso: `|y - y'| = 0`, de donde `y = y'`
      rw [d_eq_of_eq hx, abs_eq_zero, sub_eq_zero] at h
      rw [hx, h]
    · -- segundo caso: `d ≥ |x - x'| > 0`, absurdo
      exfalso
      rw [d_eq_of_ne hx] at h
      have h1 : 0 < |x - x'| := abs_pos.2 (sub_ne_zero.2 hx)
      linarith [abs_nonneg y, abs_nonneg y']
  · rintro h
    simp only [Prod.mk.injEq] at h
    rw [d_eq_of_eq h.1, h.2, sub_self, abs_zero]

/-- **(b) Desigualdad triangular**, en los cinco casos de la resolución. -/
theorem d_triangle (x y x' y' x'' y'' : ℝ) :
    d (x, y) (x', y') ≤ d (x, y) (x'', y'') + d (x'', y'') (x', y') := by
  by_cases h1 : x = x'
  · by_cases h2 : x = x''
    · -- Caso `x = x' = x''`: desigualdad triangular en `ℝ`.
      have h3 : x'' = x' := h2.symm.trans h1
      rw [d_eq_of_eq h1, d_eq_of_eq h2, d_eq_of_eq h3]
      exact abs_sub_le y y'' y'
    · -- Caso `x = x' ≠ x''`: `|y - y'| ≤ |y| + |y'|` y todo lo demás es `≥ 0`.
      have h3 : x'' ≠ x' := fun h => h2 (h1.trans h.symm)
      rw [d_eq_of_eq h1, d_eq_of_ne h2, d_eq_of_ne h3]
      linarith [abs_sub y y', abs_nonneg (x - x''), abs_nonneg (x'' - x'), abs_nonneg y'']
  · by_cases h2 : x'' = x
    · -- Caso `x'' = x ≠ x'`: `|y| ≤ |y - y''| + |y''|`.
      have h3 : x'' ≠ x' := h2 ▸ h1
      rw [d_eq_of_ne h1, d_eq_of_eq h2.symm, d_eq_of_ne h3, h2]
      have hy : |y| ≤ |y - y''| + |y''| := by
        have := abs_sub_le y y'' 0
        simpa using this
      linarith
    · by_cases h3 : x'' = x'
      · -- Caso `x'' = x' ≠ x`: `|y'| ≤ |y''| + |y'' - y'|`.
        have h4 : x ≠ x'' := fun h => h1 (h.trans h3)
        rw [d_eq_of_ne h1, d_eq_of_ne h4, d_eq_of_eq h3, h3]
        have hy : |y'| ≤ |y''| + |y'' - y'| := by
          have := abs_sub_le 0 y'' y'
          simpa using this
        linarith
      · -- Caso `x'' ≠ x` y `x'' ≠ x'`: `|x - x'| ≤ |x - x''| + |x'' - x'|` y `2|y''| ≥ 0`.
        have h4 : x ≠ x'' := Ne.symm h2
        rw [d_eq_of_ne h1, d_eq_of_ne h4, d_eq_of_ne h3]
        linarith [abs_sub_le x x'' x', abs_nonneg y'']

/-- Conclusión del ejemplo: `d` es una métrica en `ℝ²` (Definición 4.1), con los cuatro axiomas
de arriba. -/
theorem esMetrica_d : EsMetrica d where
  nonneg p q := d_nonneg p.1 p.2 q.1 q.2
  eq_zero_iff p q := d_eq_zero_iff p.1 p.2 q.1 q.2
  symm p q := d_comm p.1 p.2 q.1 q.2
  triangle p q r := d_triangle p.1 p.2 r.1 r.2 q.1 q.2

/-- `ℝ²` con la métrica del peine. -/
def Plano : Type := ℝ × ℝ

/-- `(ℝ², d)` como `MetricSpace` de Mathlib (`Comun.EsMetrica.toMetricSpace`). -/
noncomputable instance : MetricSpace Plano :=
  show MetricSpace (Con (ℝ × ℝ) d) from esMetrica_d.toMetricSpace

theorem Plano.dist_eq (p q : Plano) : dist p q = d p q := rfl

end Peine
