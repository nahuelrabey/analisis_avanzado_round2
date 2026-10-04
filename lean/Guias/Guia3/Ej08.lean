/-
Análisis Avanzado (FCEN-UBA) · Práctica 3 · Ejercicio 8
Resolución en `apuntes-typst/guias-agente/guia_3_resuelta_agente.typ` (Ejercicio 8).

Se pide hallar la frontera y los puntos de acumulación (conjunto derivado) de los mismos ocho
subconjuntos de `ℝ` del Ejercicio 3:
  (a) `[0,1]`   (b) `(0,1)`   (c) `ℚ`   (d) `ℚ ∩ [0,1]`
  (e) `ℤ`       (f) `[0,1) ∪ {2}`   (g) `{1/n : n ∈ ℕ}`   (h) `{1/n : n ∈ ℕ} ∪ {0}`.

Fidelidad. `acumulacion`/`derivadoCurso` (Def. 4.33) y `fronteraCurso` (Def. 4.38) se definen
con bolas, tal cual el curso, y los veredictos son `x_derivado` y `x_frontera` para cada
conjunto. Como en el `.typ`, la frontera se obtiene de las clausuras e interiores del
Ejercicio 3: este archivo importa `Guias.Guia3.Ej03` (definiciones `interiorCurso`,
`clausuraCurso`, los conjuntos `Ca`, …, `Ch`, los Lemas 1-4 y los veredictos `x_interior`,
`x_clausura`) en lugar de volver a probarlos. Se prueba `∂S = S̄ ∖ S°` directamente de las
definiciones y se calcula `S'` y `∂S`. `frontier_eq_fronteraCurso` conecta con `frontier` de
Mathlib (`x_frontier_mathlib`).

Convención: en el curso `ℕ = {1, 2, 3, …}`; acá se escribe `1 ≤ n` explícitamente.
-/
import Mathlib
import Guias.Guia3.Ej03

open Guias.Guia3.Ej03

namespace Guias.Guia3.Ej08
/-! ## Ejercicio 8: acumulación y frontera

Se usan las definiciones del curso con bolas (Def. 4.33 y Def. 4.38). -/

/-- Definición 4.33: `x` es *punto de acumulación* de `S` si para todo `r > 0` existe
`y ∈ B(x, r) ∩ S` con `y ≠ x`. -/
def acumulacion (S : Set ℝ) (x : ℝ) : Prop :=
  ∀ r > 0, ∃ y ∈ Metric.ball x r ∩ S, y ≠ x

/-- Definición 4.33: el *conjunto derivado* `S'` es el de los puntos de acumulación. -/
def derivadoCurso (S : Set ℝ) : Set ℝ := {x | acumulacion S x}

/-- Definición 4.38: `x` es *punto de frontera* de `S` si todo `B(x, r)` interseca a `S` y a
`Sᶜ`. La *frontera* `∂S` es el conjunto de ellos. -/
def fronteraCurso (S : Set ℝ) : Set ℝ :=
  {x | ∀ r > 0, (Metric.ball x r ∩ S).Nonempty ∧ (Metric.ball x r ∩ Sᶜ).Nonempty}

/-- Reescritura del conjunto derivado con intervalos. -/
theorem mem_derivadoCurso {S : Set ℝ} {x : ℝ} :
    x ∈ derivadoCurso S ↔ ∀ r > 0, ∃ y ∈ S, y ≠ x ∧ x - r < y ∧ y < x + r := by
  constructor
  · intro h r hr
    obtain ⟨y, ⟨hyb, hyS⟩, hyx⟩ := h r hr
    exact ⟨y, hyS, hyx, mem_ball_iff.1 hyb⟩
  · intro h r hr
    obtain ⟨y, hyS, hyx, hy⟩ := h r hr
    exact ⟨y, ⟨mem_ball_iff.2 hy, hyS⟩, hyx⟩

/-- `S' ⊆ S̄`: un punto de acumulación es de adherencia. -/
theorem derivadoCurso_sub_clausura (S : Set ℝ) : derivadoCurso S ⊆ clausuraCurso S := by
  intro x hx r hr
  obtain ⟨y, hy, _⟩ := hx r hr
  exact ⟨y, hy⟩

/-- Si `S ⊆ T` entonces `S' ⊆ T'`. -/
theorem derivadoCurso_mono {S T : Set ℝ} (h : S ⊆ T) : derivadoCurso S ⊆ derivadoCurso T := by
  intro x hx r hr
  obtain ⟨y, ⟨hy1, hy2⟩, hyx⟩ := hx r hr
  exact ⟨y, ⟨hy1, h hy2⟩, hyx⟩

/-- `∂S = S̄ ∖ S°` (se deduce directo de las definiciones 4.38, 4.22 y 4.11): que ninguna bola
centrada en `x` esté contenida en `S` equivale a que todas intersequen a `Sᶜ`. -/
theorem fronteraCurso_eq (S : Set ℝ) : fronteraCurso S = clausuraCurso S \ interiorCurso S := by
  ext x
  constructor
  · intro h
    refine ⟨fun r hr => (h r hr).1, ?_⟩
    rintro ⟨_, r, hr, hsub⟩
    obtain ⟨y, hyb, hyc⟩ := (h r hr).2
    exact hyc (hsub hyb)
  · rintro ⟨hc, hi⟩ r hr
    refine ⟨hc r hr, ?_⟩
    by_contra hemp
    have hsub : Metric.ball x r ⊆ S := by
      intro y hy
      by_contra hyS
      exact hemp ⟨y, hy, hyS⟩
    exact hi ⟨hsub (Metric.mem_ball_self hr), r, hr, hsub⟩

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

/-! ### (a) `[0, 1]` -/

theorem a_derivado : derivadoCurso Ca = Set.Icc 0 1 := by
  apply Set.Subset.antisymm
  · exact (derivadoCurso_sub_clausura Ca).trans a_clausura.le
  · intro x hx
    rw [mem_derivadoCurso]
    intro r hr
    obtain ⟨y, hy1, hy2, hyx, hy3, hy4⟩ := exists_pto zero_lt_one hx hr
    exact ⟨y, ⟨hy1.le, hy2.le⟩, hyx, hy3, hy4⟩

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

/-! ### (b) `(0, 1)` -/

theorem b_derivado : derivadoCurso Cb = Set.Icc 0 1 := by
  apply Set.Subset.antisymm
  · exact (derivadoCurso_sub_clausura Cb).trans b_clausura.le
  · intro x hx
    rw [mem_derivadoCurso]
    intro r hr
    obtain ⟨y, hy1, hy2, hyx, hy3, hy4⟩ := exists_pto zero_lt_one hx hr
    exact ⟨y, ⟨hy1, hy2⟩, hyx, hy3, hy4⟩

theorem a_frontera : fronteraCurso Ca = {0, 1} := by
  rw [fronteraCurso_eq, a_clausura, a_interior]
  exact Icc_diff_Ioo_01

theorem b_frontera : fronteraCurso Cb = {0, 1} := by
  rw [fronteraCurso_eq, b_clausura, b_interior]
  exact Icc_diff_Ioo_01

/-! ### (c) `ℚ` -/

theorem c_derivado : derivadoCurso Cc = Set.univ := by
  apply Set.eq_univ_of_forall
  intro x
  rw [mem_derivadoCurso]
  intro r hr
  obtain ⟨q, hq1, hq2⟩ := exists_rat_btwn (show x < x + r by linarith)
  exact ⟨q, ⟨q, rfl⟩, by linarith, by linarith, hq2⟩

theorem c_frontera : fronteraCurso Cc = Set.univ := by
  rw [fronteraCurso_eq, c_clausura, c_interior, Set.sdiff_empty]

/-! ### (d) `ℚ ∩ [0, 1]` -/

theorem d_derivado : derivadoCurso Cd = Set.Icc 0 1 := by
  apply Set.Subset.antisymm
  · exact (derivadoCurso_sub_clausura Cd).trans d_clausura.le
  · intro x hx
    rw [mem_derivadoCurso]
    intro r hr
    obtain ⟨q, hq1, hq2, hqx, hq3, hq4⟩ := exists_rat_pto zero_lt_one hx hr
    exact ⟨q, ⟨⟨q, rfl⟩, hq1.le, hq2.le⟩, hqx, hq3, hq4⟩

theorem d_frontera : fronteraCurso Cd = Set.Icc 0 1 := by
  rw [fronteraCurso_eq, d_clausura, d_interior, Set.sdiff_empty]

/-! ### (e) `ℤ`

Un `x` de acumulación está en `ℤ̄ = ℤ`, digamos `x = n`; pero el único entero a distancia
menor que `1/2` de `n` es `n` mismo. -/

theorem e_derivado : derivadoCurso Ce = ∅ := by
  ext x
  simp only [Set.mem_empty_iff_false, iff_false]
  intro hx
  have hxe : x ∈ Ce := e_clausura.le (derivadoCurso_sub_clausura Ce hx)
  obtain ⟨n, rfl⟩ := hxe
  rw [mem_derivadoCurso] at hx
  obtain ⟨_, ⟨m, rfl⟩, hmx, hm1, hm2⟩ := hx (1 / 2) (by norm_num)
  have h1 : (n : ℝ) - 1 < m := by linarith
  have h2 : (m : ℝ) < n + 1 := by linarith
  have h1' : n - 1 < m := by exact_mod_cast h1
  have h2' : m < n + 1 := by exact_mod_cast h2
  have : m = n := by omega
  exact hmx (by rw [this])

theorem e_frontera : fronteraCurso Ce = Ce := by
  rw [fronteraCurso_eq, e_clausura, e_interior, Set.sdiff_empty]

/-! ### (f) `[0, 1) ∪ {2}` -/

theorem f_derivado : derivadoCurso Cf = Set.Icc 0 1 := by
  apply Set.Subset.antisymm
  · intro x hx
    rcases f_clausura.le (derivadoCurso_sub_clausura Cf hx) with h | h
    · exact h
    · -- `x = 2` no es de acumulación: en `B(2, 1/2)` el único punto de `S` es `2`.
      exfalso
      have hx2 : x = 2 := h
      rw [mem_derivadoCurso] at hx
      obtain ⟨y, hyS, hyx, hy1, _⟩ := hx (1 / 2) (by norm_num)
      rcases hyS with hy | hy
      · linarith [hy.2]
      · have hy2 : y = 2 := hy
        exact hyx (hy2.trans hx2.symm)
  · intro x hx
    rw [mem_derivadoCurso]
    intro r hr
    obtain ⟨y, hy1, hy2, hyx, hy3, hy4⟩ := exists_pto zero_lt_one hx hr
    exact ⟨y, Or.inl ⟨hy1.le, hy2⟩, hyx, hy3, hy4⟩

theorem f_frontera : fronteraCurso Cf = {0, 1, 2} := by
  rw [fronteraCurso_eq, f_clausura, f_interior]
  ext x
  simp only [Set.mem_sdiff, Set.mem_union, Set.mem_Icc, Set.mem_Ioo, Set.mem_insert_iff,
    Set.mem_singleton_iff]
  constructor
  · rintro ⟨(⟨h0, h1⟩ | h2), hn⟩
    · rcases eq_or_lt_of_le h0 with h | h
      · exact Or.inl h.symm
      · rcases eq_or_lt_of_le h1 with h' | h'
        · exact Or.inr (Or.inl h')
        · exact absurd ⟨h, h'⟩ hn
    · exact Or.inr (Or.inr h2)
  · rintro (h | h | h)
    · subst h
      exact ⟨Or.inl ⟨le_rfl, zero_le_one⟩, fun h => lt_irrefl _ h.1⟩
    · subst h
      exact ⟨Or.inl ⟨zero_le_one, le_rfl⟩, fun h => lt_irrefl _ h.2⟩
    · subst h
      exact ⟨Or.inr rfl, fun h => by linarith [h.2]⟩

/-! ### (g) y (h): `{1/n}` y `{1/n} ∪ {0}`

Ningún `1/n` es de acumulación (Arquímedes aparece sólo para `0`): la bola de radio
`1/(n(n+1)) = 1/n - 1/(n+1)` alrededor de `1/n` no contiene otros `1/m`, ni a `0`. -/

theorem h_derivado_sub : derivadoCurso Ch ⊆ {0} := by
  intro x hx
  rcases h_clausura.le (derivadoCurso_sub_clausura Ch hx) with ⟨n, hn, rfl⟩ | h
  · exfalso
    have hn' : (1 : ℝ) ≤ n := by exact_mod_cast hn
    have hn0 : (0 : ℝ) < n := by linarith
    have hr : (0 : ℝ) < 1 / ((n : ℝ) * (n + 1)) := by positivity
    rw [mem_derivadoCurso] at hx
    obtain ⟨y, hyS, hyx, hy1, hy2⟩ := hx _ hr
    rcases hyS with ⟨m, hm, rfl⟩ | hy
    · have hmn : m ≠ n := fun h => hyx (by rw [h])
      have h1 := aislado hn hm hmn
      have h2 : |1 / (m : ℝ) - 1 / n| < 1 / ((n : ℝ) * (n + 1)) := abs_lt.2 ⟨by linarith, by linarith⟩
      linarith
    · have hy0 : y = 0 := hy
      have hle : 1 / ((n : ℝ) * (n + 1)) ≤ 1 / n :=
        one_div_le_one_div_of_le hn0 (by nlinarith)
      rw [hy0] at hy1
      linarith
  · exact h

theorem zero_mem_derivado_Cg : (0 : ℝ) ∈ derivadoCurso Cg := by
  rw [mem_derivadoCurso]
  intro r hr
  obtain ⟨n, hn, hnr⟩ := exists_inv_lt hr
  have hn' : (1 : ℝ) ≤ n := by exact_mod_cast hn
  have : (0 : ℝ) < 1 / n := one_div_pos.2 (by linarith)
  exact ⟨1 / n, ⟨n, hn, rfl⟩, this.ne', by linarith, by linarith⟩

theorem g_derivado : derivadoCurso Cg = {0} := by
  apply Set.Subset.antisymm
  · exact (derivadoCurso_mono Cg_sub_Ch).trans h_derivado_sub
  · intro x hx
    have : x = 0 := hx
    rw [this]
    exact zero_mem_derivado_Cg

theorem g_frontera : fronteraCurso Cg = Ch := by
  rw [fronteraCurso_eq, g_clausura, g_interior, Set.sdiff_empty]

theorem h_derivado : derivadoCurso Ch = {0} := by
  apply Set.Subset.antisymm h_derivado_sub
  intro x hx
  have : x = 0 := hx
  rw [this]
  exact derivadoCurso_mono Cg_sub_Ch zero_mem_derivado_Cg

theorem h_frontera : fronteraCurso Ch = Ch := by
  rw [fronteraCurso_eq, h_clausura, h_interior, Set.sdiff_empty]

/-! ### Puente con la frontera de Mathlib -/

theorem frontier_eq_fronteraCurso (S : Set ℝ) : frontier S = fronteraCurso S := by
  rw [fronteraCurso_eq, ← interior_eq_interiorCurso, ← closure_eq_clausuraCurso]
  rfl

/-! ## Los veredictos de frontera con `frontier` de Mathlib -/

theorem a_frontier_mathlib : frontier Ca = {0, 1} := by
  rw [frontier_eq_fronteraCurso]; exact a_frontera

theorem b_frontier_mathlib : frontier Cb = {0, 1} := by
  rw [frontier_eq_fronteraCurso]; exact b_frontera

theorem c_frontier_mathlib : frontier Cc = Set.univ := by
  rw [frontier_eq_fronteraCurso]; exact c_frontera

theorem d_frontier_mathlib : frontier Cd = Set.Icc 0 1 := by
  rw [frontier_eq_fronteraCurso]; exact d_frontera

theorem e_frontier_mathlib : frontier Ce = Ce := by
  rw [frontier_eq_fronteraCurso]; exact e_frontera

theorem f_frontier_mathlib : frontier Cf = {0, 1, 2} := by
  rw [frontier_eq_fronteraCurso]; exact f_frontera

theorem g_frontier_mathlib : frontier Cg = Ch := by
  rw [frontier_eq_fronteraCurso]; exact g_frontera

theorem h_frontier_mathlib : frontier Ch = Ch := by
  rw [frontier_eq_fronteraCurso]; exact h_frontera

end Guias.Guia3.Ej08
