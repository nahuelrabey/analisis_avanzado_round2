/-
Análisis Avanzado (FCEN-UBA) · Práctica 3 · Ejercicio 8
Resolución en `apuntes-typst/guias-agente/guia_3_resuelta_agente.typ` (Ejercicio 8).

Se pide hallar la frontera y los puntos de acumulación (conjunto derivado) de los mismos ocho
subconjuntos de `ℝ` del Ejercicio 3:
  (a) `[0,1]`   (b) `(0,1)`   (c) `ℚ`   (d) `ℚ ∩ [0,1]`
  (e) `ℤ`       (f) `[0,1) ∪ {2}`   (g) `{1/n : n ∈ ℕ}`   (h) `{1/n : n ∈ ℕ} ∪ {0}`.

Fidelidad. `acumulacion`/`derivadoCurso` (Def. 4.33) y `fronteraCurso` (Def. 4.38) se definen
con bolas, tal cual el curso, y los veredictos son `x_derivado` y `x_frontera` para cada
conjunto. En el `.typ` la frontera se obtiene de las clausuras e interiores del Ejercicio 3;
como los archivos de Lean son independientes, la primera mitad de este archivo
(hasta "Puente con Mathlib") REPRUEBA localmente el Ejercicio 3 (interior y clausura de los
ocho conjuntos, con bolas y sin lemas de Mathlib que calculen interiores o clausuras). Después
se prueba `∂S = S̄ ∖ S°` directamente de las definiciones y se calcula `S'` y `∂S`.
`frontier_eq_fronteraCurso` conecta con `frontier` de Mathlib (`x_frontier_mathlib`).

Convención: en el curso `ℕ = {1, 2, 3, …}`; acá se escribe `1 ≤ n` explícitamente.
-/
import Mathlib

open Set

namespace Guias.Guia3.Ej08
/-! ## Nociones del curso, definidas con bolas

Se usan exactamente las definiciones de `apuntes.typ`, con `B(x, r) = Metric.ball x r` en `ℝ`
con la distancia usual `d(x, y) = |x - y|`. -/

/-- Definición 4.11: `x` es *punto interior* de `S` si `x ∈ S` y existe `r > 0` con
`B(x, r) ⊆ S`. El *interior* es el conjunto de todos ellos. -/
def interiorCurso (S : Set ℝ) : Set ℝ := {x | x ∈ S ∧ ∃ r > 0, Metric.ball x r ⊆ S}

/-- Definición 4.22: `x` es *punto de adherencia* de `S` si para todo `r > 0` se tiene
`B(x, r) ∩ S ≠ ∅`. La *clausura* es el conjunto de todos ellos. -/
def clausuraCurso (S : Set ℝ) : Set ℝ := {x | ∀ r > 0, (Metric.ball x r ∩ S).Nonempty}

/-- Definición 4.14: `S` es *abierto* si `S = S°`. -/
def AbiertoCurso (S : Set ℝ) : Prop := interiorCurso S = S

/-- Definición 4.27: `S` es *cerrado* si `S̄ = S`. -/
def CerradoCurso (S : Set ℝ) : Prop := clausuraCurso S = S

/-! ### Los ocho conjuntos del ejercicio -/

/-- (a) `[0, 1]`. -/
def Ca : Set ℝ := Set.Icc 0 1
/-- (b) `(0, 1)`. -/
def Cb : Set ℝ := Set.Ioo 0 1
/-- (c) `ℚ`, como imagen de `ℚ → ℝ`. -/
def Cc : Set ℝ := Set.range ((↑) : ℚ → ℝ)
/-- (d) `ℚ ∩ [0, 1]`. -/
def Cd : Set ℝ := Cc ∩ Set.Icc 0 1
/-- (e) `ℤ`, como imagen de `ℤ → ℝ`. -/
def Ce : Set ℝ := Set.range ((↑) : ℤ → ℝ)
/-- (f) `[0, 1) ∪ {2}`. -/
def Cf : Set ℝ := Set.Ico 0 1 ∪ {2}
/-- (g) `{1/n : n ∈ ℕ}`, con `ℕ = {1, 2, 3, …}` como en el curso (`1 ≤ n`). -/
def Cg : Set ℝ := {x | ∃ n : ℕ, 1 ≤ n ∧ x = 1 / (n : ℝ)}
/-- (h) `{1/n : n ∈ ℕ} ∪ {0}`. -/
def Ch : Set ℝ := Cg ∪ {0}

/-! ### Lemas generales -/

/-- `B(x, r) = (x - r, x + r)` en `ℝ`. -/
theorem mem_ball_iff {x y r : ℝ} : y ∈ Metric.ball x r ↔ x - r < y ∧ y < x + r := by
  rw [Real.ball_eq_Ioo]; exact Set.mem_Ioo

/-- Reescritura de la clausura con intervalos. -/
theorem mem_clausuraCurso {S : Set ℝ} {x : ℝ} :
    x ∈ clausuraCurso S ↔ ∀ r > 0, ∃ y ∈ S, x - r < y ∧ y < x + r := by
  constructor
  · intro h r hr
    obtain ⟨y, hyb, hyS⟩ := h r hr
    exact ⟨y, hyS, mem_ball_iff.1 hyb⟩
  · intro h r hr
    obtain ⟨y, hyS, hy⟩ := h r hr
    exact ⟨y, mem_ball_iff.2 hy, hyS⟩

/-- Reescritura del interior con intervalos. -/
theorem mem_interiorCurso {S : Set ℝ} {x : ℝ} :
    x ∈ interiorCurso S ↔ x ∈ S ∧ ∃ r > 0, ∀ y, x - r < y → y < x + r → y ∈ S := by
  constructor
  · rintro ⟨hx, r, hr, h⟩
    exact ⟨hx, r, hr, fun y h1 h2 => h (mem_ball_iff.2 ⟨h1, h2⟩)⟩
  · rintro ⟨hx, r, hr, h⟩
    exact ⟨hx, r, hr, fun y hy => h y (mem_ball_iff.1 hy).1 (mem_ball_iff.1 hy).2⟩

/-- Observación 4.12: `S° ⊆ S`. -/
theorem interiorCurso_subset (S : Set ℝ) : interiorCurso S ⊆ S := fun _ h => h.1

/-- Observación 4.23 (a): `S ⊆ S̄`. -/
theorem subset_clausuraCurso (S : Set ℝ) : S ⊆ clausuraCurso S := by
  intro x hx r hr
  exact ⟨x, Metric.mem_ball_self hr, hx⟩

/-- Si `S ⊆ T` entonces `S̄ ⊆ T̄`. -/
theorem clausuraCurso_mono {S T : Set ℝ} (h : S ⊆ T) : clausuraCurso S ⊆ clausuraCurso T := by
  intro x hx r hr
  obtain ⟨y, hy1, hy2⟩ := hx r hr
  exact ⟨y, hy1, h hy2⟩

/-- Un conjunto contenido en `[a, b]` tiene la clausura contenida en `[a, b]`. -/
theorem clausuraCurso_sub_Icc {S : Set ℝ} {a b : ℝ} (h : S ⊆ Set.Icc a b) :
    clausuraCurso S ⊆ Set.Icc a b := by
  intro x hx
  rw [mem_clausuraCurso] at hx
  constructor
  · by_contra hxa
    have hxa' : x < a := not_le.1 hxa
    obtain ⟨y, hyS, _, hy2⟩ := hx (a - x) (by linarith)
    have := (h hyS).1
    linarith
  · by_contra hxb
    have hxb' : b < x := not_le.1 hxb
    obtain ⟨y, hyS, hy1, _⟩ := hx (x - b) (by linarith)
    have := (h hyS).2
    linarith

/-- Un conjunto contenido en `[a, b]` tiene el interior contenido en `(a, b)`: si
`B(x, r) ⊆ S ⊆ [a, b]`, los puntos `x ± r/2` están en `[a, b]`. -/
theorem interiorCurso_sub_Ioo {S : Set ℝ} {a b : ℝ} (h : S ⊆ Set.Icc a b) :
    interiorCurso S ⊆ Set.Ioo a b := by
  intro x hx
  rw [mem_interiorCurso] at hx
  obtain ⟨_, r, hr, hball⟩ := hx
  have h1 := (h (hball (x - r / 2) (by linarith) (by linarith))).1
  have h2 := (h (hball (x + r / 2) (by linarith) (by linarith))).2
  exact ⟨by linarith, by linarith⟩

/-- Un intervalo abierto contenido en `S` está contenido en `S°`: para `x ∈ (a, b)` sirve
`r = mín{x - a, b - x}`. -/
theorem Ioo_sub_interiorCurso {S : Set ℝ} {a b : ℝ} (h : Set.Ioo a b ⊆ S) :
    Set.Ioo a b ⊆ interiorCurso S := by
  intro x hx
  rw [mem_interiorCurso]
  refine ⟨h hx, min (x - a) (b - x), lt_min (by linarith [hx.1]) (by linarith [hx.2]), ?_⟩
  intro y hy1 hy2
  have h1 := min_le_left (x - a) (b - x)
  have h2 := min_le_right (x - a) (b - x)
  exact h ⟨by linarith, by linarith⟩

/-- Un conjunto formado sólo por racionales tiene interior vacío,
porque toda bola `(x - r, x + r)` contiene un irracional (Práctica 1, Ej. 2 (d)). -/
theorem interiorCurso_vacio_of_racional {S : Set ℝ} (hS : S ⊆ Cc) : interiorCurso S = ∅ := by
  ext x
  simp only [Set.mem_empty_iff_false, iff_false]
  intro hx
  rw [mem_interiorCurso] at hx
  obtain ⟨_, r, hr, h⟩ := hx
  obtain ⟨z, hz, hz1, hz2⟩ := exists_irrational_btwn (show x - r < x + r by linarith)
  exact hz (hS (h z hz1 hz2))

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

/-- Para refutar "abierto": basta un punto de `S` que no es interior. -/
theorem not_abierto_of {S : Set ℝ} {x : ℝ} (hx : x ∈ S) (hn : x ∉ interiorCurso S) :
    ¬ AbiertoCurso S := by
  intro h
  apply hn
  unfold AbiertoCurso at h
  rw [h]
  exact hx

/-- Para refutar "cerrado": basta un punto de adherencia que no está en `S`. -/
theorem not_cerrado_of {S : Set ℝ} {x : ℝ} (hx : x ∈ clausuraCurso S) (hn : x ∉ S) :
    ¬ CerradoCurso S := by
  intro h
  apply hn
  unfold CerradoCurso at h
  rw [← h]
  exact hx

/-! ### (a) `[0, 1]` -/

theorem a_interior : interiorCurso Ca = Set.Ioo 0 1 :=
  Set.Subset.antisymm (interiorCurso_sub_Ioo (S := Ca) fun _ h => h)
    (Ioo_sub_interiorCurso Set.Ioo_subset_Icc_self)

theorem a_clausura : clausuraCurso Ca = Set.Icc 0 1 :=
  Set.Subset.antisymm (clausuraCurso_sub_Icc (S := Ca) fun _ h => h) (subset_clausuraCurso Ca)

theorem a_no_abierto : ¬ AbiertoCurso Ca := by
  refine not_abierto_of (x := 0) ⟨le_rfl, zero_le_one⟩ ?_
  rw [a_interior]
  exact fun h => lt_irrefl _ h.1

theorem a_cerrado : CerradoCurso Ca := a_clausura

/-! ### (b) `(0, 1)` -/

theorem b_interior : interiorCurso Cb = Set.Ioo 0 1 :=
  Set.Subset.antisymm (interiorCurso_subset Cb) (Ioo_sub_interiorCurso fun _ h => h)

theorem b_clausura : clausuraCurso Cb = Set.Icc 0 1 := by
  apply Set.Subset.antisymm
  · exact clausuraCurso_sub_Icc (S := Cb) Set.Ioo_subset_Icc_self
  · intro x hx
    rw [mem_clausuraCurso]
    intro r hr
    obtain ⟨y, hy1, hy2, _, hy3, hy4⟩ := exists_pto zero_lt_one hx hr
    exact ⟨y, ⟨hy1, hy2⟩, hy3, hy4⟩

theorem b_abierto : AbiertoCurso Cb := b_interior

theorem b_no_cerrado : ¬ CerradoCurso Cb := by
  refine not_cerrado_of (x := 0) ?_ (fun h => lt_irrefl _ h.1)
  rw [b_clausura]
  exact ⟨le_rfl, zero_le_one⟩

/-! ### (c) `ℚ` -/

theorem c_interior : interiorCurso Cc = ∅ := interiorCurso_vacio_of_racional subset_rfl

theorem c_clausura : clausuraCurso Cc = Set.univ := by
  apply Set.eq_univ_of_forall
  intro x
  rw [mem_clausuraCurso]
  intro r hr
  obtain ⟨q, hq1, hq2⟩ := exists_rat_btwn (show x - r < x + r by linarith)
  exact ⟨q, ⟨q, rfl⟩, hq1, hq2⟩

theorem c_no_abierto : ¬ AbiertoCurso Cc := by
  refine not_abierto_of (x := 0) ⟨0, by simp⟩ ?_
  rw [c_interior]
  exact Set.notMem_empty _

theorem c_no_cerrado : ¬ CerradoCurso Cc := by
  obtain ⟨z, hz, _, _⟩ := exists_irrational_btwn (show (0 : ℝ) < 1 by norm_num)
  refine not_cerrado_of (x := z) ?_ hz
  rw [c_clausura]
  exact Set.mem_univ _

/-! ### (d) `ℚ ∩ [0, 1]` -/

theorem d_interior : interiorCurso Cd = ∅ :=
  interiorCurso_vacio_of_racional Set.inter_subset_left

theorem d_clausura : clausuraCurso Cd = Set.Icc 0 1 := by
  apply Set.Subset.antisymm
  · exact clausuraCurso_sub_Icc (S := Cd) Set.inter_subset_right
  · intro x hx
    rw [mem_clausuraCurso]
    intro r hr
    obtain ⟨q, hq1, hq2, _, hq3, hq4⟩ := exists_rat_pto zero_lt_one hx hr
    exact ⟨q, ⟨⟨q, rfl⟩, hq1.le, hq2.le⟩, hq3, hq4⟩

theorem d_no_abierto : ¬ AbiertoCurso Cd := by
  refine not_abierto_of (x := 0) ⟨⟨0, by simp⟩, le_rfl, zero_le_one⟩ ?_
  rw [d_interior]
  exact Set.notMem_empty _

theorem d_no_cerrado : ¬ CerradoCurso Cd := by
  obtain ⟨z, hz, hz1, hz2⟩ := exists_irrational_btwn (show (0 : ℝ) < 1 by norm_num)
  refine not_cerrado_of (x := z) ?_ (fun h => hz h.1)
  rw [d_clausura]
  exact ⟨hz1.le, hz2.le⟩

/-! ### (e) `ℤ`

Un `x ∉ ℤ` cae estrictamente entre `n = ⌊x⌋` y `n + 1`; la bola de radio
`mín{x - n, n + 1 - x}` no contiene enteros. -/

theorem e_interior : interiorCurso Ce = ∅ := by
  refine interiorCurso_vacio_of_racional ?_
  rintro _ ⟨n, rfl⟩
  exact ⟨n, by simp⟩

theorem e_clausura : clausuraCurso Ce = Ce := by
  apply Set.Subset.antisymm _ (subset_clausuraCurso Ce)
  intro x hx
  by_contra hxe
  rw [mem_clausuraCurso] at hx
  have h1 : ((⌊x⌋ : ℤ) : ℝ) ≤ x := Int.floor_le x
  have h2 : x < ((⌊x⌋ : ℤ) : ℝ) + 1 := Int.lt_floor_add_one x
  have h3 : ((⌊x⌋ : ℤ) : ℝ) ≠ x := fun h => hxe ⟨⌊x⌋, h⟩
  have h4 : ((⌊x⌋ : ℤ) : ℝ) < x := lt_of_le_of_ne h1 h3
  obtain ⟨_, ⟨m, rfl⟩, hm1, hm2⟩ := hx (min (x - ⌊x⌋) (⌊x⌋ + 1 - x))
    (lt_min (by linarith) (by linarith))
  have h5 := min_le_left (x - ⌊x⌋) (⌊x⌋ + 1 - x)
  have h6 := min_le_right (x - ⌊x⌋) (⌊x⌋ + 1 - x)
  have h7 : ((⌊x⌋ : ℤ) : ℝ) < (m : ℝ) := by linarith
  have h8 : (m : ℝ) < ((⌊x⌋ : ℤ) : ℝ) + 1 := by linarith
  have h9 : ⌊x⌋ < m := Int.cast_lt.1 h7
  have h10 : m < ⌊x⌋ + 1 := by exact_mod_cast h8
  omega

theorem e_no_abierto : ¬ AbiertoCurso Ce := by
  refine not_abierto_of (x := 0) ⟨0, by simp⟩ ?_
  rw [e_interior]
  exact Set.notMem_empty _

theorem e_cerrado : CerradoCurso Ce := e_clausura

/-! ### (f) `[0, 1) ∪ {2}` -/

theorem f_interior : interiorCurso Cf = Set.Ioo 0 1 := by
  apply Set.Subset.antisymm
  · intro x hx
    rw [mem_interiorCurso] at hx
    obtain ⟨hxS, r, hr, hball⟩ := hx
    rcases hxS with hx | hx
    · -- `x ∈ [0, 1)`: el punto `x - r/2` está en `S`, luego `x - r/2 ≥ 0`.
      refine ⟨?_, hx.2⟩
      rcases hball (x - r / 2) (by linarith) (by linarith) with h | h
      · linarith [h.1]
      · have : x - r / 2 = 2 := h
        linarith [hx.2]
    · -- `x = 2`: el punto `x + r/2` no está en `S`.
      exfalso
      have hx2 : x = 2 := hx
      rcases hball (x + r / 2) (by linarith) (by linarith) with h | h
      · linarith [h.2]
      · have : x + r / 2 = 2 := h
        linarith
  · exact Ioo_sub_interiorCurso (fun _ h => Or.inl ⟨h.1.le, h.2⟩)

theorem f_clausura : clausuraCurso Cf = Set.Icc 0 1 ∪ {2} := by
  apply Set.Subset.antisymm
  · intro x hx
    by_contra hxn
    have hxn1 : ¬ (0 ≤ x ∧ x ≤ 1) := fun h => hxn (Or.inl h)
    have hxn2 : x ≠ 2 := fun h => hxn (Or.inr h)
    rw [mem_clausuraCurso] at hx
    rcases lt_or_ge x 0 with h0 | h0
    · obtain ⟨y, hyS, _, hy2⟩ := hx (-x) (by linarith)
      rcases hyS with hy | hy
      · linarith [hy.1]
      · have : y = 2 := hy
        linarith
    · have h1 : 1 < x := by
        by_contra h
        exact hxn1 ⟨h0, not_lt.1 h⟩
      rcases lt_trichotomy x 2 with h2 | h2 | h2
      · obtain ⟨y, hyS, hy1, hy2⟩ := hx (min (x - 1) (2 - x)) (lt_min (by linarith) (by linarith))
        have m1 := min_le_left (x - 1) (2 - x)
        have m2 := min_le_right (x - 1) (2 - x)
        rcases hyS with hy | hy
        · linarith [hy.2]
        · have : y = 2 := hy
          linarith
      · exact hxn2 h2
      · obtain ⟨y, hyS, hy1, _⟩ := hx (x - 2) (by linarith)
        rcases hyS with hy | hy
        · linarith [hy.2]
        · have : y = 2 := hy
          linarith
  · rintro x (hx | hx)
    · rw [mem_clausuraCurso]
      intro r hr
      obtain ⟨y, hy1, hy2, _, hy3, hy4⟩ := exists_pto zero_lt_one hx hr
      exact ⟨y, Or.inl ⟨hy1.le, hy2⟩, hy3, hy4⟩
    · exact subset_clausuraCurso Cf (Or.inr hx)

theorem f_no_abierto : ¬ AbiertoCurso Cf := by
  refine not_abierto_of (x := 0) (Or.inl ⟨le_rfl, zero_lt_one⟩) ?_
  rw [f_interior]
  exact fun h => lt_irrefl _ h.1

theorem f_no_cerrado : ¬ CerradoCurso Cf := by
  refine not_cerrado_of (x := 1) ?_ ?_
  · rw [f_clausura]
    exact Or.inl ⟨zero_le_one, le_rfl⟩
  · rintro (h | h)
    · exact lt_irrefl _ h.2
    · have : (1 : ℝ) = 2 := h
      norm_num at this

/-! ### (g) y (h): `{1/n}` y `{1/n} ∪ {0}`

El ingrediente es que `x ∉ {1/n} ∪ {0}` está a distancia positiva de todo el conjunto: si
`x ∈ (0, 1]`, queda entre `1/(n+1)` y `1/n` con `n = ⌊1/x⌋`. -/

/-- Arquímedes: para todo `r > 0` hay `n ≥ 1` con `1/n < r`. -/
theorem exists_inv_lt {r : ℝ} (hr : 0 < r) : ∃ n : ℕ, 1 ≤ n ∧ 1 / (n : ℝ) < r := by
  obtain ⟨N, hN⟩ := exists_nat_gt (1 / r)
  have hNpos : (0 : ℝ) < N := lt_trans (one_div_pos.2 hr) hN
  have h0 : 0 < N := Nat.cast_pos.1 hNpos
  exact ⟨N, h0, (one_div_lt hNpos hr).2 hN⟩

theorem Cg_sub_Ch : Cg ⊆ Ch := Set.subset_union_left

theorem Cg_sub_Cc : Cg ⊆ Cc := by
  rintro _ ⟨n, _, rfl⟩
  exact ⟨1 / (n : ℚ), by push_cast; rfl⟩

theorem Ch_sub_Cc : Ch ⊆ Cc := by
  rintro x (hx | hx)
  · exact Cg_sub_Cc hx
  · have : x = 0 := hx
    exact ⟨0, by simp [this]⟩

theorem zero_mem_Ch : (0 : ℝ) ∈ Ch := Or.inr rfl

theorem Ch_cota {y : ℝ} (hy : y ∈ Ch) : 0 ≤ y ∧ y ≤ 1 := by
  rcases hy with ⟨m, hm, rfl⟩ | h
  · have hm' : (1 : ℝ) ≤ m := by exact_mod_cast hm
    have hm0 : (0 : ℝ) < m := by linarith
    exact ⟨(one_div_pos.2 hm0).le, (div_le_one hm0).2 hm'⟩
  · have : y = 0 := h
    rw [this]
    exact ⟨le_rfl, zero_le_one⟩

theorem lejos_Ch {x : ℝ} (hx : x ∉ Ch) :
    ∃ r > 0, ∀ y ∈ Ch, ¬ (x - r < y ∧ y < x + r) := by
  have hx0 : x ≠ 0 := fun h => hx (Or.inr h)
  have hxg : ∀ n : ℕ, 1 ≤ n → x ≠ 1 / (n : ℝ) := fun n hn h => hx (Or.inl ⟨n, hn, h⟩)
  rcases lt_or_gt_of_ne hx0 with hneg | hpos
  · refine ⟨-x, by linarith, fun y hy ⟨h1, h2⟩ => ?_⟩
    have := (Ch_cota hy).1
    linarith
  · rcases le_or_gt x 1 with hle | hgt
    · -- `0 < x ≤ 1`, `x` no es de la forma `1/n`.
      have h1x : 1 ≤ 1 / x := (one_le_div hpos).2 hle
      set n : ℕ := ⌊1 / x⌋₊ with hn
      have hn1 : 1 ≤ n := Nat.le_floor (by exact_mod_cast h1x)
      have hnle : (n : ℝ) ≤ 1 / x := Nat.floor_le (by positivity)
      have hlt : 1 / x < (n : ℝ) + 1 := Nat.lt_floor_add_one _
      have hn' : (1 : ℝ) ≤ n := by exact_mod_cast hn1
      have hnpos : (0 : ℝ) < n := by linarith
      have hne : (n : ℝ) ≠ 1 / x := fun h => hxg n hn1 (by rw [h, one_div_one_div])
      have hnlt : (n : ℝ) < 1 / x := lt_of_le_of_ne hnle hne
      have hA : 1 / ((n : ℝ) + 1) < x := (one_div_lt (by linarith) hpos).2 hlt
      have hB : x < 1 / (n : ℝ) := (lt_one_div hpos hnpos).2 hnlt
      have hC : (0 : ℝ) < 1 / ((n : ℝ) + 1) := one_div_pos.2 (by linarith)
      refine ⟨min (1 / (n : ℝ) - x) (x - 1 / ((n : ℝ) + 1)),
        lt_min (by linarith) (by linarith), ?_⟩
      have m1 := min_le_left (1 / (n : ℝ) - x) (x - 1 / ((n : ℝ) + 1))
      have m2 := min_le_right (1 / (n : ℝ) - x) (x - 1 / ((n : ℝ) + 1))
      intro y hy ⟨h1, h2⟩
      rcases hy with ⟨m, hm, rfl⟩ | h
      · have hm' : (1 : ℝ) ≤ m := by exact_mod_cast hm
        have hmpos : (0 : ℝ) < m := by linarith
        have k1 : 1 / ((n : ℝ) + 1) < 1 / (m : ℝ) := by linarith
        have k2 : 1 / (m : ℝ) < 1 / (n : ℝ) := by linarith
        have k1' : (m : ℝ) < n + 1 := (one_div_lt_one_div (by linarith) hmpos).1 k1
        have k2' : (n : ℝ) < m := (one_div_lt_one_div hmpos hnpos).1 k2
        have k1'' : m < n + 1 := by exact_mod_cast k1'
        have k2'' : n < m := by exact_mod_cast k2'
        omega
      · have : y = 0 := h
        rw [this] at h1
        linarith
    · refine ⟨x - 1, by linarith, fun y hy ⟨h1, _⟩ => ?_⟩
      have := (Ch_cota hy).2
      linarith

/-- `{1/n} ∪ {0}` contiene a su clausura. -/
theorem clausura_Ch_sub : clausuraCurso Ch ⊆ Ch := by
  intro x hx
  by_contra hxn
  obtain ⟨r, hr, hlej⟩ := lejos_Ch hxn
  rw [mem_clausuraCurso] at hx
  obtain ⟨y, hy, hy1, hy2⟩ := hx r hr
  exact hlej y hy ⟨hy1, hy2⟩

theorem g_interior : interiorCurso Cg = ∅ := interiorCurso_vacio_of_racional Cg_sub_Cc

theorem g_clausura : clausuraCurso Cg = Ch := by
  apply Set.Subset.antisymm
  · exact (clausuraCurso_mono Cg_sub_Ch).trans clausura_Ch_sub
  · rintro x (hx | hx)
    · exact subset_clausuraCurso Cg hx
    · have hx0 : x = 0 := hx
      rw [hx0, mem_clausuraCurso]
      intro r hr
      obtain ⟨n, hn, hnr⟩ := exists_inv_lt hr
      have hn' : (1 : ℝ) ≤ n := by exact_mod_cast hn
      have : (0 : ℝ) < 1 / n := one_div_pos.2 (by linarith)
      exact ⟨1 / n, ⟨n, hn, rfl⟩, by linarith, by linarith⟩

theorem g_no_abierto : ¬ AbiertoCurso Cg := by
  refine not_abierto_of (x := 1) ⟨1, le_rfl, by norm_num⟩ ?_
  rw [g_interior]
  exact Set.notMem_empty _

theorem g_no_cerrado : ¬ CerradoCurso Cg := by
  refine not_cerrado_of (x := 0) ?_ ?_
  · rw [g_clausura]
    exact zero_mem_Ch
  · rintro ⟨n, hn, h⟩
    have hn' : (1 : ℝ) ≤ n := by exact_mod_cast hn
    have : (0 : ℝ) < 1 / n := one_div_pos.2 (by linarith)
    linarith

theorem h_interior : interiorCurso Ch = ∅ := interiorCurso_vacio_of_racional Ch_sub_Cc

theorem h_clausura : clausuraCurso Ch = Ch :=
  Set.Subset.antisymm clausura_Ch_sub (subset_clausuraCurso Ch)

theorem h_no_abierto : ¬ AbiertoCurso Ch := by
  refine not_abierto_of (x := 0) zero_mem_Ch ?_
  rw [h_interior]
  exact Set.notMem_empty _

theorem h_cerrado : CerradoCurso Ch := h_clausura

/-! ### Puente con Mathlib

Las nociones del curso coinciden con `interior`, `closure`, `IsOpen` e `IsClosed` de Mathlib.
Se prueban con las caracterizaciones por bolas (`Metric.mem_nhds_iff`, `Metric.mem_closure_iff`),
no con los cálculos concretos del ejercicio. -/

theorem interior_eq_interiorCurso (S : Set ℝ) : interior S = interiorCurso S := by
  ext x
  rw [mem_interior_iff_mem_nhds, Metric.mem_nhds_iff]
  constructor
  · rintro ⟨r, hr, h⟩
    exact ⟨h (Metric.mem_ball_self hr), r, hr, h⟩
  · rintro ⟨_, r, hr, h⟩
    exact ⟨r, hr, h⟩

theorem closure_eq_clausuraCurso (S : Set ℝ) : closure S = clausuraCurso S := by
  ext x
  rw [Metric.mem_closure_iff]
  constructor
  · intro h r hr
    obtain ⟨y, hyS, hd⟩ := h r hr
    exact ⟨y, Metric.mem_ball'.2 hd, hyS⟩
  · intro h r hr
    obtain ⟨y, hyb, hyS⟩ := h r hr
    exact ⟨y, hyS, Metric.mem_ball'.1 hyb⟩

theorem isOpen_iff_abiertoCurso (S : Set ℝ) : IsOpen S ↔ AbiertoCurso S := by
  unfold AbiertoCurso
  rw [← interior_eq_interiorCurso, interior_eq_iff_isOpen]

theorem isClosed_iff_cerradoCurso (S : Set ℝ) : IsClosed S ↔ CerradoCurso S := by
  unfold CerradoCurso
  rw [← closure_eq_clausuraCurso, closure_eq_iff_isClosed]

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
