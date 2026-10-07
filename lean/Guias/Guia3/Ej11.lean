/-
Análisis Avanzado (FCEN-UBA) · Práctica 3 · Ejercicio 11 (la "distancia" `d̂` entre conjuntos).
Enunciado en `apuntes-typst/guias/p3.typ`; resolución en `apuntes-typst/guias-agente/guia_3_resuelta_agente.typ` (Ejercicio 11).

`d̂(A, B) = ínf {d(a, b) : a ∈ A, b ∈ B}` (`dhat`, con `sInf`) para `A, B` no vacíos. Veredictos:
(a) `d̂(A, B) = d̂(cl A, B)`: VERDADERA, para todo espacio métrico `E` (`dhat_closure_left`).
(b) `d̂(A, B) = 0 ↔ A ∩ B ≠ ∅`: la ida `⇐` es cierta en todo `E` (`dhat_eq_zero_of_inter`);
    la vuelta `⇒` es FALSA: `(0, 1)` y `(1, 2)` en `ℝ` (`ej11b_contraejemplo`).
(c) `d̂(A, B) = 0 ↔ cl A ∩ cl B ≠ ∅`: la ida `⇐` es cierta en todo `E`
    (`dhat_eq_zero_of_closure_inter`); la vuelta `⇒` es FALSA: `A = {n : n ≥ 2}` y
    `B = {n + 1/n : n ≥ 2}` en `ℝ`, ambos cerrados y disjuntos, con `d̂(A, B) = 0`
    (`ej11c_contraejemplo`).
(d) `d̂(A, B) ≤ d̂(A, C) + d̂(C, B)`: FALSA: `A = {0}`, `B = {2}`, `C = {0, 2}` en `ℝ`
    (`ej11d_contraejemplo`).
Conclusión: `d̂` no es una distancia en `𝒳 = {A ⊆ ℝ : A ≠ ∅}` (falla la separación y la
triangular; `no_es_metrica`).
Los contraejemplos (b)-(d) se hacen en `ℝ`. Para la conclusión, `no_es_metrica` es el caso
`E = ℝ`, y `no_es_metrica_general` la versión para cualquier `E` con al menos dos puntos
(`[Nontrivial E]`): la separación falla con `A = {p}`, `C = {p, q}`. Para `E` de un solo punto
`𝒳` tiene un solo elemento y `d̂` sí es una métrica, así que esa hipótesis es necesaria.
-/
import Mathlib
import Comun.Metricas
import Comun.Topologia

open Comun

namespace Guias.Guia3.Ej11

variable {E : Type*} [MetricSpace E]

/-- El conjunto `{d(a, b) : a ∈ A, b ∈ B}`. -/
def distancias (A B : Set E) : Set ℝ := {r | ∃ a ∈ A, ∃ b ∈ B, r = dist a b}

/-- Ejercicio 11: `d̂(A, B) = ínf {d(a, b) : a ∈ A, b ∈ B}`. -/
noncomputable def dhat (A B : Set E) : ℝ := sInf (distancias A B)

theorem distancias_nonempty {A B : Set E} (hA : A.Nonempty) (hB : B.Nonempty) :
    (distancias A B).Nonempty := by
  obtain ⟨a, ha⟩ := hA
  obtain ⟨b, hb⟩ := hB
  exact ⟨dist a b, a, ha, b, hb, rfl⟩

/-- El conjunto de distancias está acotado inferiormente por `0`. -/
theorem distancias_bddBelow (A B : Set E) : BddBelow (distancias A B) := by
  refine ⟨0, ?_⟩
  rintro r ⟨a, -, b, -, rfl⟩
  exact dist_nonneg

/-- `d̂(A, B) ≤ d(a, b)` para `a ∈ A`, `b ∈ B` (el ínfimo es cota inferior). -/
theorem dhat_le {A B : Set E} {a b : E} (ha : a ∈ A) (hb : b ∈ B) : dhat A B ≤ dist a b :=
  csInf_le (distancias_bddBelow A B) ⟨a, ha, b, hb, rfl⟩

/-- El ínfimo es la mayor cota inferior. -/
theorem le_dhat {A B : Set E} (hA : A.Nonempty) (hB : B.Nonempty) {c : ℝ}
    (h : ∀ a ∈ A, ∀ b ∈ B, c ≤ dist a b) : c ≤ dhat A B := by
  apply le_csInf (distancias_nonempty hA hB)
  rintro r ⟨a, ha, b, hb, rfl⟩
  exact h a ha b hb

theorem dhat_nonneg {A B : Set E} (hA : A.Nonempty) (hB : B.Nonempty) : 0 ≤ dhat A B :=
  le_dhat hA hB fun _ _ _ _ => dist_nonneg

/-- `d̂` es simétrica: la propiedad (iii) de la Definición 4.1 sí vale (no hace falta en
`no_es_metrica`, que usa la triangular). -/
theorem dhat_comm (A B : Set E) : dhat A B = dhat B A := by
  have : distancias A B = distancias B A := by
    ext r
    constructor
    · rintro ⟨a, ha, b, hb, rfl⟩
      exact ⟨b, hb, a, ha, dist_comm a b⟩
    · rintro ⟨b, hb, a, ha, rfl⟩
      exact ⟨a, ha, b, hb, dist_comm b a⟩
  unfold dhat
  rw [this]

/-! ## (a) `d̂(A, B) = d̂(cl A, B)` -/

/-- **Ejercicio 11 (a).** VERDADERA: `d̂(A, B) = d̂(cl A, B)` para `A, B ≠ ∅` en todo espacio métrico.

`(≥)`: `A ⊆ cl A` y el ínfimo sobre un conjunto mayor es menor. `(≤)`: si `x ∈ cl A`, `b ∈ B`,
para `ε > 0` hay `a ∈ A` con `d(x, a) < ε`, y `d̂(A, B) ≤ d(a, b) ≤ d(a, x) + d(x, b) < ε + d(x, b)`;
luego `d̂(A, B) ≤ d(x, b)` y `d̂(A, B)` es cota inferior de las distancias de `(cl A, B)`. -/
theorem dhat_closure_left {A B : Set E} (hA : A.Nonempty) (hB : B.Nonempty) :
    dhat A B = dhat (closure A) B := by
  apply le_antisymm
  · apply le_dhat hA.closure hB
    intro x hx b hb
    apply le_of_forall_pos_le_add
    intro ε hε
    obtain ⟨a, ha, hxa⟩ := Metric.mem_closure_iff.1 hx ε hε
    have h1 : dhat A B ≤ dist a b := dhat_le ha hb
    have h2 : dist a b ≤ dist a x + dist x b := dist_triangle _ _ _
    rw [dist_comm a x] at h2
    linarith
  · -- `d̂(cl A, B) ≤ d̂(A, B)`: `d̂(cl A, B)` es cota inferior de las distancias de `(A, B)`.
    exact le_dhat hA hB fun a ha b hb => dhat_le (subset_closure ha) hb

/-! ## (b) `d̂(A, B) = 0 ↔ A ∩ B ≠ ∅` -/

/-- **Ejercicio 11 (b), ida `⇐` (cierta en todo `E`).** Si `A ∩ B ≠ ∅` entonces `d̂(A, B) = 0`:
si `x ∈ A ∩ B`, `0 ≤ d̂(A, B) ≤ d(x, x) = 0`. -/
theorem dhat_eq_zero_of_inter {A B : Set E} (hA : A.Nonempty) (hB : B.Nonempty)
    (h : (A ∩ B).Nonempty) : dhat A B = 0 := by
  obtain ⟨x, hxA, hxB⟩ := h
  apply le_antisymm _ (dhat_nonneg hA hB)
  have := dhat_le hxA hxB
  rwa [dist_self] at this

/-- Si para todo `ε > 0` hay `a ∈ A`, `b ∈ B` con `d(a, b) < ε`, entonces `d̂(A, B) = 0`. -/
theorem dhat_eq_zero_of_approx {A B : Set E} (hA : A.Nonempty) (hB : B.Nonempty)
    (h : ∀ ε > 0, ∃ a ∈ A, ∃ b ∈ B, dist a b < ε) : dhat A B = 0 := by
  apply le_antisymm _ (dhat_nonneg hA hB)
  apply le_of_forall_pos_le_add
  intro ε hε
  obtain ⟨a, ha, b, hb, hab⟩ := h ε hε
  have := dhat_le ha hb
  linarith

/-- Los intervalos `(0, 1)` y `(1, 2)` de `ℝ`: disjuntos y a distancia `0`. -/
theorem ej11b_conjuntos :
    dhat (Set.Ioo (0 : ℝ) 1) (Set.Ioo 1 2) = 0 ∧ Set.Ioo (0 : ℝ) 1 ∩ Set.Ioo 1 2 = ∅ := by
  constructor
  · apply dhat_eq_zero_of_approx ⟨1 / 2, by norm_num⟩ ⟨3 / 2, by norm_num⟩
    intro ε hε
    -- `t = mín(ε/4, 1/2)`: `1 - t ∈ (0, 1)`, `1 + t ∈ (1, 2)`, `d = 2t ≤ ε/2 < ε`.
    set t : ℝ := min (ε / 4) (1 / 2) with ht
    have ht1 : 0 < t := lt_min (by positivity) (by norm_num)
    have ht2 : t ≤ ε / 4 := min_le_left _ _
    have ht3 : t ≤ 1 / 2 := min_le_right _ _
    refine ⟨1 - t, ⟨by linarith, by linarith⟩, 1 + t, ⟨by linarith, by linarith⟩, ?_⟩
    rw [Real.dist_eq, show (1 - t) - (1 + t) = -(2 * t) by ring, abs_neg,
      abs_of_pos (by linarith)]
    linarith
  · ext x
    simp only [Set.mem_inter_iff, Set.mem_Ioo, Set.mem_empty_iff_false, iff_false]
    rintro ⟨⟨_, h1⟩, ⟨h2, _⟩⟩
    linarith

/-- **Ejercicio 11 (b), vuelta `⇒` FALSA.** No vale `d̂(A, B) = 0 → A ∩ B ≠ ∅`. -/
theorem ej11b_contraejemplo :
    ¬ (∀ A B : Set ℝ, A.Nonempty → B.Nonempty → dhat A B = 0 → (A ∩ B).Nonempty) := by
  intro h
  obtain ⟨h0, hdisj⟩ := ej11b_conjuntos
  obtain ⟨x, hx⟩ := h _ _ ⟨1 / 2, by norm_num⟩ ⟨3 / 2, by norm_num⟩ h0
  rw [hdisj] at hx
  exact hx

/-! ## (c) `d̂(A, B) = 0 ↔ cl A ∩ cl B ≠ ∅` -/

/-- **Ejercicio 11 (c), ida `⇐` (cierta en todo `E`).** Si `x ∈ cl A ∩ cl B` entonces
`d̂(A, B) = 0`: para `ε > 0` hay `a ∈ A`, `b ∈ B` con `d(x, a), d(x, b) < ε/2`, así que
`d(a, b) < ε`. -/
theorem dhat_eq_zero_of_closure_inter {A B : Set E} (hA : A.Nonempty) (hB : B.Nonempty)
    (h : (closure A ∩ closure B).Nonempty) : dhat A B = 0 := by
  obtain ⟨x, hxA, hxB⟩ := h
  apply dhat_eq_zero_of_approx hA hB
  intro ε hε
  obtain ⟨a, ha, hxa⟩ := Metric.mem_closure_iff.1 hxA (ε / 2) (by positivity)
  obtain ⟨b, hb, hxb⟩ := Metric.mem_closure_iff.1 hxB (ε / 2) (by positivity)
  refine ⟨a, ha, b, hb, ?_⟩
  have h2 : dist a b ≤ dist a x + dist x b := dist_triangle _ _ _
  rw [dist_comm a x] at h2
  linarith

/-- Un conjunto `S` con puntos distintos a distancia `≥ 1/2` es cerrado:
`cl S ⊆ S`. Si `x ∈ cl S`, hay `a ∈ S` con `d(x, a) < 1/4`; si fuera `x ≠ a`, tomando
`ε = mín(d(x, a), 1/4)` hay `a' ∈ S` con `d(x, a') < ε`, y entonces `d(a, a') < 1/2`, luego
`a' = a`, pero `d(x, a') < d(x, a) = d(x, a')`. -/
theorem closure_subset_of_sep {S : Set E} (hS : ∀ a ∈ S, ∀ a' ∈ S, a ≠ a' → 1 / 2 ≤ dist a a') :
    closure S ⊆ S := by
  intro x hx
  obtain ⟨a, ha, hxa⟩ := Metric.mem_closure_iff.1 hx (1 / 4) (by norm_num)
  by_cases hxeq : x = a
  · rw [hxeq]; exact ha
  · exfalso
    have hpos : 0 < dist x a := dist_pos.2 hxeq
    obtain ⟨a', ha', hxa'⟩ := Metric.mem_closure_iff.1 hx (min (dist x a) (1 / 4))
      (lt_min hpos (by norm_num))
    have h1 : dist x a' < dist x a := lt_of_lt_of_le hxa' (min_le_left _ _)
    have h2 : dist x a' < 1 / 4 := lt_of_lt_of_le hxa' (min_le_right _ _)
    have h3 : dist a a' ≤ dist a x + dist x a' := dist_triangle _ _ _
    rw [dist_comm a x] at h3
    by_cases haa : a = a'
    · rw [haa] at h1
      exact lt_irrefl _ h1
    · have := hS a ha a' ha' haa
      linarith

/-- `A = {n : n ≥ 2}` (naturales `≥ 2` vistos en `ℝ`). -/
def A11 : Set ℝ := {x | ∃ n : ℕ, 2 ≤ n ∧ x = n}

/-- `B = {n + 1/n : n ≥ 2}`. -/
def B11 : Set ℝ := {x | ∃ n : ℕ, 2 ≤ n ∧ x = n + 1 / n}

theorem A11_nonempty : A11.Nonempty := ⟨2, 2, le_refl _, by norm_num⟩

theorem B11_nonempty : B11.Nonempty := ⟨2 + 1 / 2, 2, le_refl _, by norm_num⟩

/-- Los puntos distintos de `A` están a distancia `≥ 1/2` (de hecho `≥ 1`). -/
theorem A11_sep : ∀ a ∈ A11, ∀ a' ∈ A11, a ≠ a' → 1 / 2 ≤ dist a a' := by
  rintro _ ⟨m, -, rfl⟩ _ ⟨n, -, rfl⟩ hne
  have hmn : m ≠ n := fun h => hne (by rw [h])
  rw [Real.dist_eq]
  rcases lt_or_gt_of_ne hmn with h | h
  · have : (m : ℝ) + 1 ≤ n := by exact_mod_cast h
    rw [abs_of_neg (by linarith)]
    linarith
  · have : (n : ℝ) + 1 ≤ m := by exact_mod_cast h
    rw [abs_of_pos (by linarith)]
    linarith

/-- Los puntos distintos de `B` están a distancia `≥ 1/2`: si `m < n`,
`(n + 1/n) - (m + 1/m) = (n - m) + (1/n - 1/m) ≥ 1 - 1/2 + 1/n > 1/2`. -/
theorem B11_sep : ∀ a ∈ B11, ∀ a' ∈ B11, a ≠ a' → 1 / 2 ≤ dist a a' := by
  have key : ∀ m n : ℕ, 2 ≤ m → m < n →
      1 / 2 ≤ ((n : ℝ) + 1 / n) - ((m : ℝ) + 1 / m) := by
    intro m n hm hmn
    have h1 : (m : ℝ) + 1 ≤ n := by exact_mod_cast hmn
    have h2 : (2 : ℝ) ≤ m := by exact_mod_cast hm
    have h3 : 1 / (m : ℝ) ≤ 1 / 2 := one_div_le_one_div_of_le (by norm_num) h2
    have h4 : 0 < 1 / (n : ℝ) := by
      apply one_div_pos.2
      linarith
    linarith
  rintro _ ⟨m, hm, rfl⟩ _ ⟨n, hn, rfl⟩ hne
  have hmn : m ≠ n := fun h => hne (by rw [h])
  rw [Real.dist_eq]
  rcases lt_or_gt_of_ne hmn with h | h
  · have := key m n hm h
    rw [abs_of_neg (by linarith)]
    linarith
  · have := key n m hn h
    rw [abs_of_pos (by linarith)]
    linarith

/-- `A` es cerrado: `cl A = A`. -/
theorem A11_closure : closure A11 = A11 :=
  Set.Subset.antisymm (closure_subset_of_sep A11_sep) subset_closure

/-- `B` es cerrado: `cl B = B`. -/
theorem B11_closure : closure B11 = B11 :=
  Set.Subset.antisymm (closure_subset_of_sep B11_sep) subset_closure

/-- `A` y `B` son disjuntos: `n = m + 1/m` con `0 < 1/m < 1` no puede ser entero. -/
theorem A11_inter_B11 : A11 ∩ B11 = ∅ := by
  ext x
  simp only [Set.mem_inter_iff, Set.mem_empty_iff_false, iff_false]
  rintro ⟨⟨n, -, rfl⟩, ⟨m, hm, hnm⟩⟩
  have h2 : (2 : ℝ) ≤ m := by exact_mod_cast hm
  have h3 : 1 / (m : ℝ) ≤ 1 / 2 := one_div_le_one_div_of_le (by norm_num) h2
  have h4 : 0 < 1 / (m : ℝ) := one_div_pos.2 (by linarith)
  rcases le_or_gt n m with h | h
  · have : (n : ℝ) ≤ m := by exact_mod_cast h
    linarith
  · have : (m : ℝ) + 1 ≤ n := by exact_mod_cast h
    linarith

/-- `d̂(A, B) = 0`: los puntos `n` y `n + 1/n` están a distancia `1/n → 0`. -/
theorem A11_B11_dhat : dhat A11 B11 = 0 := by
  apply dhat_eq_zero_of_approx A11_nonempty B11_nonempty
  intro ε hε
  obtain ⟨N, hN⟩ := exists_nat_gt (1 / ε)
  have hN2 : (1 / ε : ℝ) < ((max N 2 : ℕ) : ℝ) := lt_of_lt_of_le hN (by exact_mod_cast le_max_left N 2)
  set n : ℕ := max N 2 with hn
  have hn2 : 2 ≤ n := le_max_right _ _
  have hnpos : (0 : ℝ) < n := lt_of_le_of_lt (by positivity) hN2
  refine ⟨n, ⟨n, hn2, rfl⟩, n + 1 / n, ⟨n, hn2, rfl⟩, ?_⟩
  rw [Real.dist_eq, show (n : ℝ) - (n + 1 / n) = -(1 / n) by ring, abs_neg,
    abs_of_pos (one_div_pos.2 hnpos)]
  rw [div_lt_iff₀ hnpos]
  rw [div_lt_iff₀ hε] at hN2
  linarith

/-- **Ejercicio 11 (c), vuelta `⇒` FALSA.** Hay `A, B` cerrados, disjuntos, con `d̂(A, B) = 0`. -/
theorem ej11c_contraejemplo :
    ¬ (∀ A B : Set ℝ, A.Nonempty → B.Nonempty →
        dhat A B = 0 → (closure A ∩ closure B).Nonempty) := by
  intro h
  obtain ⟨x, hx⟩ := h _ _ A11_nonempty B11_nonempty A11_B11_dhat
  rw [A11_closure, B11_closure, A11_inter_B11] at hx
  exact hx

/-! ## (d) desigualdad triangular -/

/-- **Ejercicio 11 (d), valores.** Para `A = {0}`, `B = {2}`, `C = {0, 2}` en `ℝ`:
`d̂(A, B) = 2`, `d̂(A, C) = 0` y `d̂(C, B) = 0`. -/
theorem ej11d_valores :
    dhat ({0} : Set ℝ) {2} = 2 ∧ dhat ({0} : Set ℝ) {0, 2} = 0 ∧ dhat ({0, 2} : Set ℝ) {2} = 0 := by
  refine ⟨?_, ?_, ?_⟩
  · apply le_antisymm
    · have := dhat_le (A := ({0} : Set ℝ)) (B := {2}) rfl rfl
      rw [Real.dist_eq] at this
      norm_num at this
      exact this
    · refine le_dhat (A := ({0} : Set ℝ)) (B := {2}) (Set.singleton_nonempty 0)
        (Set.singleton_nonempty 2) ?_
      rintro a rfl b rfl
      rw [Real.dist_eq]
      norm_num
  · apply le_antisymm
    · have := dhat_le (A := ({0} : Set ℝ)) (B := {0, 2}) rfl (Set.mem_insert _ _)
      rwa [dist_self] at this
    · exact dhat_nonneg ⟨0, rfl⟩ ⟨0, Set.mem_insert _ _⟩
  · apply le_antisymm
    · have := dhat_le (A := ({0, 2} : Set ℝ)) (B := {2}) (Set.mem_insert_of_mem _ rfl) rfl
      rwa [dist_self] at this
    · exact dhat_nonneg ⟨0, Set.mem_insert _ _⟩ ⟨2, rfl⟩

/-- **Ejercicio 11 (d), FALSA.** No vale `d̂(A, B) ≤ d̂(A, C) + d̂(C, B)` para todo
`A, B, C` no vacíos: con `A = {0}`, `B = {2}`, `C = {0, 2}` sería `2 ≤ 0 + 0`. -/
theorem ej11d_contraejemplo :
    ¬ (∀ A B C : Set ℝ, A.Nonempty → B.Nonempty → C.Nonempty →
        dhat A B ≤ dhat A C + dhat C B) := by
  intro h
  obtain ⟨h1, h2, h3⟩ := ej11d_valores
  have := h {0} {2} {0, 2} ⟨0, rfl⟩ ⟨2, rfl⟩ ⟨0, Set.mem_insert _ _⟩
  rw [h1, h2, h3] at this
  norm_num at this

/-! ## Conclusión: `d̂` no es una distancia -/

/-- El conjunto `𝒳` de los subconjuntos no vacíos de `ℝ`. -/
abbrev X : Type := {A : Set ℝ // A.Nonempty}

/-- `d̂` como función `𝒳 × 𝒳 → ℝ`. -/
noncomputable def dhatX (A B : X) : ℝ := dhat A.1 B.1

/-- `d̂` incumple la separación (Def. 4.1 (ii)): `(0, 1) ≠ (1, 2)` pero `d̂ = 0`. -/
theorem no_separa : ¬ (∀ A B : X, dhatX A B = 0 ↔ A = B) := by
  intro h
  obtain ⟨h0, -⟩ := ej11b_conjuntos
  have hA : (Set.Ioo (0 : ℝ) 1).Nonempty := ⟨1 / 2, by norm_num⟩
  have hB : (Set.Ioo (1 : ℝ) 2).Nonempty := ⟨3 / 2, by norm_num⟩
  have heq := (h ⟨_, hA⟩ ⟨_, hB⟩).1 h0
  have h12 : (1 / 2 : ℝ) ∈ Set.Ioo (0 : ℝ) 1 := by norm_num
  have hval : Set.Ioo (0 : ℝ) 1 = Set.Ioo 1 2 := congrArg Subtype.val heq
  rw [hval] at h12
  norm_num [Set.mem_Ioo] at h12

/-- `d̂` incumple la desigualdad triangular (Def. 4.1 (iv)). -/
theorem no_triangular : ¬ (∀ A B C : X, dhatX A C ≤ dhatX A B + dhatX B C) := by
  intro h
  apply ej11d_contraejemplo
  intro A B C hA hB hC
  have := h ⟨A, hA⟩ ⟨C, hC⟩ ⟨B, hB⟩
  exact this

/-- **Conclusión del Ejercicio 11.** `d̂` no es una distancia en `𝒳`
(`EsMetrica` es la Definición 4.1): fallan la separación y la desigualdad triangular. -/
theorem no_es_metrica : ¬ Comun.EsMetrica dhatX := by
  intro hm
  exact no_triangular hm.triangle

/-! ### La conclusión para un `E` cualquiera con al menos dos puntos -/

/-- `𝒳(E)`: los subconjuntos no vacíos de `E`. -/
abbrev XE (E : Type*) [MetricSpace E] : Type _ := {A : Set E // A.Nonempty}

/-- `d̂` como función `𝒳(E) × 𝒳(E) → ℝ`. -/
noncomputable def dhatXE (A B : XE E) : ℝ := dhat A.1 B.1

/-- **Conclusión del Ejercicio 11, para todo `E` con al menos dos puntos.** `d̂` no es una
distancia en `𝒳(E)`: si `p ≠ q`, los conjuntos `{p}` y `{p, q}` son distintos pero
`d̂({p}, {p, q}) = 0` (ítem (b), `⇐`), contra la separación (Def. 4.1 (ii)). -/
theorem no_es_metrica_general [Nontrivial E] : ¬ Comun.EsMetrica (dhatXE (E := E)) := by
  intro hm
  obtain ⟨p, q, hpq⟩ := exists_pair_ne E
  have hC : ({p, q} : Set E).Nonempty := ⟨p, Set.mem_insert _ _⟩
  have h0 : dhat ({p} : Set E) {p, q} = 0 :=
    dhat_eq_zero_of_inter (Set.singleton_nonempty p) hC ⟨p, rfl, Set.mem_insert _ _⟩
  have heq := (hm.eq_zero_iff ⟨{p}, Set.singleton_nonempty p⟩ ⟨{p, q}, hC⟩).1 h0
  have hval : ({p} : Set E) = {p, q} := congrArg Subtype.val heq
  have hq : q ∈ ({p} : Set E) := hval ▸ Set.mem_insert_of_mem _ rfl
  exact hpq (Set.mem_singleton_iff.1 hq).symm

end Guias.Guia3.Ej11
