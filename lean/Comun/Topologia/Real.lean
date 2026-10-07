/-
Librería común `Comun`: definiciones del curso y resultados de `apuntes.typ` compartidos por las
guías (`Guias/`), los parciales (`Parciales/`) y los ejemplos (`Ejemplos/`). Ver
`apuntes-agente/lean-lemas-compartidos-y-organizacion.md` para el diseño.

`Comun.Topologia.Real`: hechos sobre `ℝ` con la distancia usual que las prácticas usaban como
sublemas locales (sobre todo la Práctica 3, Ej. 2, 3, 5, 6, 8 y 11):
* la bola de `ℝ` es un intervalo (`mem_ball_iff`: `y ∈ B(x, r) ↔ x - r < y < x + r`), que
  reemplaza a `rw [mem_ball, Real.dist_eq, abs_lt]`;
* puntos de `(a, b)` distintos de `x` y arbitrariamente cerca de `x ∈ [a, b]` (`exists_pto`), y
  racionales (`exists_rat_pto`, densidad de `ℚ`);
* `ℚ` como subconjunto de `ℝ` (`Q`) con `closure_Q` (densidad de `ℚ`) e `interior_Q`
  (densidad de los irracionales, Práctica 1, Ej. 2 (d));
* `[0, 1] ∖ (0, 1) = {0, 1}` (`Icc_diff_Ioo_01`), la separación entre los puntos `1/n`
  (`aislado`) y `√(a + b) ≤ √a + √b` (`sqrt_add_le`, paso clave del Ej. 2 (b)).
No se usa ningún lema de Mathlib que calcule interior o clausura de `ℚ` (`Rat.denseRange_cast`,
…): sólo la densidad de `ℚ` (`exists_rat_btwn`) y de los irracionales (`exists_irrational_btwn`).
-/
import Mathlib
import Comun.Topologia

open Metric Set

namespace Comun

/-! ## La bola de `ℝ` es un intervalo -/

/-- `B(x, r) = (x - r, x + r)` en `ℝ`. -/
theorem mem_ball_iff {x y r : ℝ} : y ∈ Metric.ball x r ↔ x - r < y ∧ y < x + r := by
  rw [Real.ball_eq_Ioo]; exact Set.mem_Ioo

/-! ## Puntos cercanos en un intervalo -/

/-- Sobre un intervalo `[a, b]` con `a < b`, todo punto `x` tiene puntos de `(a, b)` distintos
de `x` y arbitrariamente cerca: se corre `x` hacia el centro del intervalo en
`t = mín{r, b - a} / 4`. -/
theorem exists_pto {a b x r : ℝ} (hab : a < b) (hx : a ≤ x ∧ x ≤ b) (hr : 0 < r) :
    ∃ y, a < y ∧ y < b ∧ y ≠ x ∧ x - r < y ∧ y < x + r := by
  have hm : 0 < min r (b - a) := lt_min hr (by linarith)
  have hmr := min_le_left r (b - a)
  have hmb := min_le_right r (b - a)
  by_cases h : x ≤ (a + b) / 2
  · refine ⟨x + min r (b - a) / 4, by linarith [hx.1], by linarith, by linarith, by linarith,
      by linarith⟩
  · refine ⟨x - min r (b - a) / 4, by linarith, by linarith [hx.2], by linarith, by linarith,
      by linarith⟩

/-- Igual que `exists_pto`, pero con el punto racional (densidad de `ℚ`). -/
theorem exists_rat_pto {a b x r : ℝ} (hab : a < b) (hx : a ≤ x ∧ x ≤ b) (hr : 0 < r) :
    ∃ q : ℚ, a < q ∧ (q : ℝ) < b ∧ (q : ℝ) ≠ x ∧ x - r < q ∧ (q : ℝ) < x + r := by
  obtain ⟨y, hy1, hy2, hyx, hy3, hy4⟩ := exists_pto hab hx hr
  rcases lt_or_gt_of_ne hyx with hlt | hgt
  · obtain ⟨q, hq1, hq2⟩ := exists_rat_btwn hlt
    exact ⟨q, by linarith, by linarith [hx.2], by linarith, by linarith, by linarith⟩
  · obtain ⟨q, hq1, hq2⟩ := exists_rat_btwn hgt
    exact ⟨q, by linarith [hx.1], by linarith, by linarith, by linarith, by linarith⟩

/-! ## `ℚ` dentro de `ℝ` -/

/-- Los racionales como subconjunto de `ℝ`. -/
def Q : Set ℝ := range ((↑) : ℚ → ℝ)

/-- `cl ℚ = ℝ`: todo intervalo `(x - r, x + r)` contiene un racional (Densidad de `ℚ`). -/
theorem closure_Q : closure Q = univ := by
  ext x
  simp only [mem_univ, iff_true]
  rw [mem_closure_iff_ball]
  intro r hr
  obtain ⟨q, hq1, hq2⟩ := exists_rat_btwn (show x - r < x + r by linarith)
  exact ⟨q, mem_ball_iff.2 ⟨hq1, hq2⟩, q, rfl⟩

/-- `ℚ° = ∅`: todo intervalo `(x, x + r)` contiene un irracional. -/
theorem interior_Q : interior Q = ∅ := by
  refine eq_empty_of_forall_notMem fun x hx => ?_
  obtain ⟨r, hr, hsub⟩ := mem_interior_iff_ball.1 hx
  obtain ⟨y, hy, hy1, hy2⟩ := exists_irrational_btwn (show x < x + r by linarith)
  exact hy (hsub (mem_ball_iff.2 ⟨by linarith, hy2⟩))

/-! ## Cuentas en `ℝ` -/

/-- `[0, 1] ∖ (0, 1) = {0, 1}`. -/
theorem Icc_diff_Ioo_01 : Set.Icc (0 : ℝ) 1 \ Set.Ioo 0 1 = {0, 1} := by
  ext x
  simp only [Set.mem_sdiff, Set.mem_Icc, Set.mem_Ioo, Set.mem_insert_iff, Set.mem_singleton_iff]
  constructor
  · rintro ⟨⟨h0, h1⟩, hn⟩
    rcases eq_or_lt_of_le h0 with h | h
    · exact Or.inl h.symm
    · rcases eq_or_lt_of_le h1 with h' | h'
      · exact Or.inr h'
      · exact absurd ⟨h, h'⟩ hn
  · rintro (h | h)
    · subst h
      exact ⟨⟨le_rfl, zero_le_one⟩, fun h => lt_irrefl _ h.1⟩
    · subst h
      exact ⟨⟨zero_le_one, le_rfl⟩, fun h => lt_irrefl _ h.2⟩

/-- Los puntos `1/n` están a distancia al menos `1/(n(n+1)) = 1/n - 1/(n+1)` de los demás
`1/m`. -/
theorem aislado {n m : ℕ} (hn : 1 ≤ n) (hm : 1 ≤ m) (hne : m ≠ n) :
    1 / ((n : ℝ) * (n + 1)) ≤ |1 / (m : ℝ) - 1 / n| := by
  have hn' : (1 : ℝ) ≤ n := by exact_mod_cast hn
  have hm' : (1 : ℝ) ≤ m := by exact_mod_cast hm
  have hn0 : (0 : ℝ) < n := by linarith
  have hm0 : (0 : ℝ) < m := by linarith
  rcases lt_or_gt_of_ne hne with hlt | hgt
  · -- `m < n`: `1/m - 1/n = (n - m)/(m n) ≥ 1/(n (n+1))`.
    have hmn : (m : ℝ) + 1 ≤ n := by exact_mod_cast hlt
    have hle : 1 / (n : ℝ) ≤ 1 / m := one_div_le_one_div_of_le hm0 (by linarith)
    rw [abs_of_nonneg (sub_nonneg.2 hle), div_sub_div _ _ hm0.ne' hn0.ne',
      div_le_div_iff₀ (by positivity) (by positivity)]
    nlinarith [mul_pos hm0 hn0, mul_nonneg hn0.le (sub_nonneg.2 hmn)]
  · -- `m > n`: `1/m - 1/n` es negativo y `1/n - 1/m = (m - n)/(m n) ≥ 1/(n (n+1))`.
    have hmn : (n : ℝ) + 1 ≤ m := by exact_mod_cast hgt
    have hle : 1 / (m : ℝ) ≤ 1 / n := one_div_le_one_div_of_le hn0 (by linarith)
    rw [abs_of_nonpos (sub_nonpos.2 hle), neg_sub, div_sub_div _ _ hn0.ne' hm0.ne',
      div_le_div_iff₀ (by positivity) (by positivity)]
    nlinarith [mul_pos hm0 hn0, mul_nonneg hn0.le (sub_nonneg.2 hmn)]

/-- `√(a + b) ≤ √a + √b` para `a, b ≥ 0` (se eleva al cuadrado). Paso clave del Ej. 2 (b) de
la Práctica 3. -/
theorem sqrt_add_le (a b : ℝ) (ha : 0 ≤ a) (hb : 0 ≤ b) :
    Real.sqrt (a + b) ≤ Real.sqrt a + Real.sqrt b := by
  rw [Real.sqrt_le_iff]
  refine ⟨by positivity, ?_⟩
  have h1 := Real.sq_sqrt ha
  have h2 := Real.sq_sqrt hb
  nlinarith [mul_nonneg (Real.sqrt_nonneg a) (Real.sqrt_nonneg b)]

end Comun
