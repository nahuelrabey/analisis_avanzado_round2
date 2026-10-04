/-
Práctica 3, Ejercicio 6 (interior y clausura frente a unión e intersección).
Resolución "a mano" en `apuntes-typst/guias-agente/guia_3_resuelta_agente.typ` (Ejercicio 6).

Se prueban (a) `(A ∩ B)° = A° ∩ B°`, (b) `A° ∪ B° ⊆ (A ∪ B)°`, (c) `cl (A ∪ B) = cl A ∪ cl B` y
(d) `cl (A ∩ B) ⊆ cl A ∩ cl B`, más los ejemplos de desigualdad estricta en (b) y (d).

Las demostraciones pasan por las definiciones por bolas (4.11, 4.22), vía `Metric.mem_closure_iff`
y `Metric.mem_nhds_iff`; los cálculos en `ℝ` también se hacen con bolas (no con `interior_Icc`).
-/
import Mathlib

open Metric Set

namespace Guias.Guia3.Ej06

variable {E : Type*} [MetricSpace E]

/-! ## Herramientas del curso, por bolas -/

/-- Definición 4.11: `x` es interior de `A` si hay una bola abierta `B(x, r) ⊆ A`. -/
theorem mem_interior_iff_ball {A : Set E} {x : E} :
    x ∈ interior A ↔ ∃ r > 0, ball x r ⊆ A := by
  rw [mem_interior_iff_mem_nhds, Metric.mem_nhds_iff]

/-- Definición 4.22: `x` es de adherencia de `A` si toda bola `B(x, r)` corta a `A`. -/
theorem mem_closure_iff_ball {A : Set E} {x : E} :
    x ∈ closure A ↔ ∀ r > 0, (ball x r ∩ A).Nonempty := by
  rw [Metric.mem_closure_iff]
  constructor
  · intro h r hr
    obtain ⟨b, hb, hd⟩ := h r hr
    exact ⟨b, mem_ball.2 (by rwa [dist_comm]), hb⟩
  · intro h r hr
    obtain ⟨b, hb, hbA⟩ := h r hr
    exact ⟨b, hbA, by rw [dist_comm]; exact mem_ball.1 hb⟩

/-- Negación de la Definición 4.22: existe una bola `B(x, r)` que no corta a `A`. -/
theorem notMem_closure_iff_ball {A : Set E} {x : E} :
    x ∉ closure A ↔ ∃ r > 0, ∀ z ∈ ball x r, z ∉ A := by
  rw [mem_closure_iff_ball]
  constructor
  · intro h
    by_contra hne
    apply h
    intro r hr
    by_contra hemp
    exact hne ⟨r, hr, fun z hz hzA => hemp ⟨z, hz, hzA⟩⟩
  · rintro ⟨r, hr, h⟩ hc
    obtain ⟨z, hz, hzA⟩ := hc r hr
    exact h z hz hzA

/-- La clausura es monótona (inmediato de la Definición 4.22). -/
theorem closure_mono_ball {A B : Set E} (h : A ⊆ B) : closure A ⊆ closure B := by
  intro x hx
  rw [mem_closure_iff_ball] at hx ⊢
  intro r hr
  obtain ⟨z, hz1, hz2⟩ := hx r hr
  exact ⟨z, hz1, h hz2⟩

/-! ## (a) `(A ∩ B)° = A° ∩ B°` -/

/-- **Ej. 6 (a).** `⊆`: una bola dentro de `A ∩ B` está dentro de `A` y de `B`. `⊇`: si
`B(x, r₁) ⊆ A` y `B(x, r₂) ⊆ B`, la bola de radio `mín {r₁, r₂}` está en ambos. -/
theorem ej6a (A B : Set E) : interior (A ∩ B) = interior A ∩ interior B := by
  ext x
  rw [mem_inter_iff, mem_interior_iff_ball, mem_interior_iff_ball, mem_interior_iff_ball]
  constructor
  · rintro ⟨r, hr, h⟩
    exact ⟨⟨r, hr, h.trans inter_subset_left⟩, ⟨r, hr, h.trans inter_subset_right⟩⟩
  · rintro ⟨⟨r₁, hr₁, h₁⟩, ⟨r₂, hr₂, h₂⟩⟩
    refine ⟨min r₁ r₂, lt_min hr₁ hr₂, fun z hz => ⟨?_, ?_⟩⟩
    · exact h₁ (ball_subset_ball (min_le_left _ _) hz)
    · exact h₂ (ball_subset_ball (min_le_right _ _) hz)

/-! ## (b) `A° ∪ B° ⊆ (A ∪ B)°` y un ejemplo con desigualdad estricta -/

/-- **Ej. 6 (b).** Una bola dentro de `A` (o de `B`) está dentro de `A ∪ B`. -/
theorem ej6b (A B : Set E) : interior A ∪ interior B ⊆ interior (A ∪ B) := by
  rintro x (hx | hx)
  · obtain ⟨r, hr, h⟩ := mem_interior_iff_ball.1 hx
    exact mem_interior_iff_ball.2 ⟨r, hr, h.trans subset_union_left⟩
  · obtain ⟨r, hr, h⟩ := mem_interior_iff_ball.1 hx
    exact mem_interior_iff_ball.2 ⟨r, hr, h.trans subset_union_right⟩

/-- **Ej. 6 (b), ejemplo.** Con `A = [0, 1]` y `B = [1, 2]` en `ℝ`: `1 ∈ (A ∪ B)°` (la bola
`B(1, 1) = (0, 2)` está en `[0, 2]`) pero `1 ∉ A°` (los puntos `1 + r/2` salen de `A`) y
`1 ∉ B°` (los puntos `1 - r/2` salen de `B`). -/
theorem ej6b_ejemplo :
    interior (Icc (0 : ℝ) 1) ∪ interior (Icc (1 : ℝ) 2) ≠
      interior (Icc (0 : ℝ) 1 ∪ Icc (1 : ℝ) 2) := by
  intro h
  have h1 : (1 : ℝ) ∈ interior (Icc (0 : ℝ) 1 ∪ Icc (1 : ℝ) 2) := by
    refine mem_interior_iff_ball.2 ⟨1, one_pos, fun z hz => ?_⟩
    have hz' := abs_lt.1 (Real.dist_eq z 1 ▸ mem_ball.1 hz)
    rcases le_total z 1 with hle | hle
    · exact Or.inl ⟨by linarith, hle⟩
    · exact Or.inr ⟨hle, by linarith⟩
  rw [← h] at h1
  rcases h1 with h1 | h1
  · obtain ⟨r, hr, hsub⟩ := mem_interior_iff_ball.1 h1
    have hz : (1 + r / 2 : ℝ) ∈ ball 1 r := by
      rw [mem_ball, Real.dist_eq, abs_lt]; constructor <;> linarith
    have := (hsub hz).2
    linarith
  · obtain ⟨r, hr, hsub⟩ := mem_interior_iff_ball.1 h1
    have hz : (1 - r / 2 : ℝ) ∈ ball 1 r := by
      rw [mem_ball, Real.dist_eq, abs_lt]; constructor <;> linarith
    have := (hsub hz).1
    linarith

/-- El ejemplo de (b) como inclusión estricta: `A° ∪ B° ⊊ (A ∪ B)°`. -/
theorem ej6b_ejemplo_ssubset :
    interior (Icc (0 : ℝ) 1) ∪ interior (Icc (1 : ℝ) 2) ⊂
      interior (Icc (0 : ℝ) 1 ∪ Icc (1 : ℝ) 2) :=
  ⟨ej6b _ _, fun h => ej6b_ejemplo (Subset.antisymm (ej6b _ _) h)⟩

/-! ## (c) `cl (A ∪ B) = cl A ∪ cl B` -/

/-- **Ej. 6 (c).** `⊇` por monotonía. `⊆`: si `x ∉ cl A` y `x ∉ cl B` hay `B(x, r₁)` que no corta
a `A` y `B(x, r₂)` que no corta a `B`; la bola de radio `mín {r₁, r₂}` no corta a `A ∪ B`,
luego `x ∉ cl (A ∪ B)`. -/
theorem ej6c (A B : Set E) : closure (A ∪ B) = closure A ∪ closure B := by
  refine Subset.antisymm ?_ ?_
  · intro x hx
    by_contra hn
    rw [mem_union, not_or] at hn
    obtain ⟨r₁, hr₁, h₁⟩ := notMem_closure_iff_ball.1 hn.1
    obtain ⟨r₂, hr₂, h₂⟩ := notMem_closure_iff_ball.1 hn.2
    obtain ⟨z, hz, hzu⟩ := mem_closure_iff_ball.1 hx (min r₁ r₂) (lt_min hr₁ hr₂)
    rcases hzu with h | h
    · exact h₁ z (ball_subset_ball (min_le_left _ _) hz) h
    · exact h₂ z (ball_subset_ball (min_le_right _ _) hz) h
  · rintro x (hx | hx)
    · exact closure_mono_ball subset_union_left hx
    · exact closure_mono_ball subset_union_right hx

/-! ## (d) `cl (A ∩ B) ⊆ cl A ∩ cl B` y un ejemplo con desigualdad estricta -/

/-- **Ej. 6 (d).** Por monotonía de la clausura, con `A ∩ B ⊆ A` y `A ∩ B ⊆ B`. -/
theorem ej6d (A B : Set E) : closure (A ∩ B) ⊆ closure A ∩ closure B :=
  fun _ hx => ⟨closure_mono_ball inter_subset_left hx, closure_mono_ball inter_subset_right hx⟩

/-- **Ej. 6 (d), ejemplo.** Con `A = (0, 1)` y `B = (1, 2)` en `ℝ`: `A ∩ B = ∅` y `cl ∅ = ∅`,
pero `1 ∈ cl A ∩ cl B` (los puntos `1 ∓ m/2` con `m = mín {r, 1}` están en `A` y en `B`
respectivamente, a distancia `< r` de `1`). -/
theorem ej6d_ejemplo :
    closure (Ioo (0 : ℝ) 1 ∩ Ioo (1 : ℝ) 2) ≠ closure (Ioo (0 : ℝ) 1) ∩ closure (Ioo (1 : ℝ) 2) := by
  intro h
  have hempty : Ioo (0 : ℝ) 1 ∩ Ioo (1 : ℝ) 2 = ∅ :=
    eq_empty_of_forall_notMem fun z hz => lt_asymm hz.1.2 hz.2.1
  have h1 : (1 : ℝ) ∈ closure (Ioo (0 : ℝ) 1) ∩ closure (Ioo (1 : ℝ) 2) := by
    constructor
    · rw [mem_closure_iff_ball]
      intro r hr
      have hm0 : 0 < min r 1 := lt_min hr one_pos
      have hm1 : min r 1 ≤ r := min_le_left _ _
      have hm2 : min r 1 ≤ 1 := min_le_right _ _
      refine ⟨1 - min r 1 / 2, mem_ball.2 ?_, ?_, ?_⟩
      · rw [Real.dist_eq, abs_lt]; constructor <;> linarith
      · linarith
      · linarith
    · rw [mem_closure_iff_ball]
      intro r hr
      have hm0 : 0 < min r 1 := lt_min hr one_pos
      have hm1 : min r 1 ≤ r := min_le_left _ _
      have hm2 : min r 1 ≤ 1 := min_le_right _ _
      refine ⟨1 + min r 1 / 2, mem_ball.2 ?_, ?_, ?_⟩
      · rw [Real.dist_eq, abs_lt]; constructor <;> linarith
      · linarith
      · linarith
  rw [← h, hempty] at h1
  obtain ⟨z, _, hz⟩ := mem_closure_iff_ball.1 h1 1 one_pos
  exact hz

/-- El ejemplo de (d) como inclusión estricta: `cl (A ∩ B) ⊊ cl A ∩ cl B`. -/
theorem ej6d_ejemplo_ssubset :
    closure (Ioo (0 : ℝ) 1 ∩ Ioo (1 : ℝ) 2) ⊂ closure (Ioo (0 : ℝ) 1) ∩ closure (Ioo (1 : ℝ) 2) :=
  ⟨ej6d _ _, fun h => ej6d_ejemplo (Subset.antisymm (ej6d _ _) h)⟩

end Guias.Guia3.Ej06
