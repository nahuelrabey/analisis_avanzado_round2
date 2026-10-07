/-
Análisis Avanzado (FCEN-UBA) · Práctica 3 · Ejercicio 8
Resolución en `apuntes-typst/guias-agente/guia_3_resuelta_agente.typ` (Ejercicio 8).

Se pide hallar la frontera y los puntos de acumulación (conjunto derivado) de los mismos ocho
subconjuntos de `ℝ` del Ejercicio 3:
  (a) `[0,1]`   (b) `(0,1)`   (c) `ℚ`   (d) `ℚ ∩ [0,1]`
  (e) `ℤ`       (f) `[0,1) ∪ {2}`   (g) `{1/n : n ∈ ℕ}`   (h) `{1/n : n ∈ ℕ} ∪ {0}`.

Fidelidad. `acumulacion`/`derivadoCurso` (Def. 4.33) y `fronteraCurso` (Def. 4.38) están
definidas con bolas, tal cual el curso, en `Comun.Topologia.Curso` y `Comun.Topologia`, y los
veredictos son `x_derivado` y `x_frontera` para cada conjunto. Como en el `.typ`, la frontera se
obtiene de las clausuras e interiores del Ejercicio 3 vía `∂S = S̄ ∖ S°`
(`Comun.fronteraCurso_eq`): este archivo importa `Guias.Guia3.Ej03` (los conjuntos `Ca`, …, `Ch`,
los lemas `Cg_sub_Ch`, `exists_inv_lt`, … y los veredictos `x_interior`, `x_clausura`) en lugar
de volver a probarlos. `Comun.frontier_eq_fronteraCurso` conecta con `frontier` de Mathlib
(`x_frontier_mathlib`).

Qué importa de `Comun`: las definiciones, `fronteraCurso_eq`, `derivadoCurso_sub_clausura`,
`derivadoCurso_mono`, `mem_derivadoCurso_real` y el puente (`Comun.Topologia.Curso`), y los
lemas de `ℝ` `aislado`, `Icc_diff_Ioo_01`, `exists_pto`, `exists_rat_pto`
(`Comun.Topologia.Real`). Quedan locales los veredictos.

Convención: en el curso `ℕ = {1, 2, 3, …}`; acá se escribe `1 ≤ n` explícitamente.
-/
import Mathlib
import Comun.Topologia.Real
import Comun.Topologia.Curso
import Guias.Guia3.Ej03

open Comun Guias.Guia3.Ej03

namespace Guias.Guia3.Ej08

/-! ### (a) `[0, 1]` -/

theorem a_derivado : derivadoCurso Ca = Set.Icc 0 1 := by
  apply Set.Subset.antisymm
  · exact (derivadoCurso_sub_clausura Ca).trans a_clausura.le
  · intro x hx
    rw [mem_derivadoCurso_real]
    intro r hr
    obtain ⟨y, hy1, hy2, hyx, hy3, hy4⟩ := exists_pto zero_lt_one hx hr
    exact ⟨y, ⟨hy1.le, hy2.le⟩, hyx, hy3, hy4⟩

/-! ### (b) `(0, 1)` -/

theorem b_derivado : derivadoCurso Cb = Set.Icc 0 1 := by
  apply Set.Subset.antisymm
  · exact (derivadoCurso_sub_clausura Cb).trans b_clausura.le
  · intro x hx
    rw [mem_derivadoCurso_real]
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
  rw [mem_derivadoCurso_real]
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
    rw [mem_derivadoCurso_real]
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
  rw [mem_derivadoCurso_real] at hx
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
      rw [mem_derivadoCurso_real] at hx
      obtain ⟨y, hyS, hyx, hy1, _⟩ := hx (1 / 2) (by norm_num)
      rcases hyS with hy | hy
      · linarith [hy.2]
      · have hy2 : y = 2 := hy
        exact hyx (hy2.trans hx2.symm)
  · intro x hx
    rw [mem_derivadoCurso_real]
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
    rw [mem_derivadoCurso_real] at hx
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
  rw [mem_derivadoCurso_real]
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
