/-
Práctica 3, Ejercicio 6 (interior y clausura frente a unión e intersección).
Resolución "a mano" en `apuntes-typst/guias-agente/guia_3_resuelta_agente.typ` (Ejercicio 6).

Se prueban (a) `(A ∩ B)° = A° ∩ B°`, (b) `A° ∪ B° ⊆ (A ∪ B)°`, (c) `cl (A ∪ B) = cl A ∪ cl B` y
(d) `cl (A ∩ B) ⊆ cl A ∩ cl B`, más los ejemplos de desigualdad estricta en (b) y (d).

Las demostraciones pasan por las definiciones por bolas (4.11, 4.22), vía
`Comun.mem_interior_iff_ball` y `Comun.mem_closure_iff_ball`; los cálculos en `ℝ` también se hacen
con bolas (no con `interior_Icc`), leídas como intervalos con `Comun.mem_ball_iff`.

Qué importa de `Comun`: los cuatro ítems son `Comun.interior_inter_bolas`,
`Comun.interior_union_subset_bolas`, `Comun.closure_union_bolas` y
`Comun.closure_inter_subset_bolas` (`Comun.Topologia`). Quedan locales los dos ejemplos de
desigualdad estricta.
-/
import Mathlib
import Comun.Topologia
import Comun.Topologia.Real

open Metric Set Comun

namespace Guias.Guia3.Ej06

variable {E : Type*} [MetricSpace E]

/-! ## (a) `(A ∩ B)° = A° ∩ B°` -/

/-- **Ej. 6 (a).** `⊆`: una bola dentro de `A ∩ B` está dentro de `A` y de `B`. `⊇`: si
`B(x, r₁) ⊆ A` y `B(x, r₂) ⊆ B`, la bola de radio `mín {r₁, r₂}` está en ambos
(`Comun.interior_inter_bolas`). -/
theorem ej6a (A B : Set E) : interior (A ∩ B) = interior A ∩ interior B :=
  interior_inter_bolas A B

/-! ## (b) `A° ∪ B° ⊆ (A ∪ B)°` y un ejemplo con desigualdad estricta -/

/-- **Ej. 6 (b).** Una bola dentro de `A` (o de `B`) está dentro de `A ∪ B`
(`Comun.interior_union_subset_bolas`). -/
theorem ej6b (A B : Set E) : interior A ∪ interior B ⊆ interior (A ∪ B) :=
  interior_union_subset_bolas A B

/-- **Ej. 6 (b), ejemplo.** Con `A = [0, 1]` y `B = [1, 2]` en `ℝ`: `1 ∈ (A ∪ B)°` (la bola
`B(1, 1) = (0, 2)` está en `[0, 2]`) pero `1 ∉ A°` (los puntos `1 + r/2` salen de `A`) y
`1 ∉ B°` (los puntos `1 - r/2` salen de `B`). -/
theorem ej6b_ejemplo :
    interior (Icc (0 : ℝ) 1) ∪ interior (Icc (1 : ℝ) 2) ≠
      interior (Icc (0 : ℝ) 1 ∪ Icc (1 : ℝ) 2) := by
  intro h
  have h1 : (1 : ℝ) ∈ interior (Icc (0 : ℝ) 1 ∪ Icc (1 : ℝ) 2) := by
    refine mem_interior_iff_ball.2 ⟨1, one_pos, fun z hz => ?_⟩
    have hz' := mem_ball_iff.1 hz
    rcases le_total z 1 with hle | hle
    · exact Or.inl ⟨by linarith, hle⟩
    · exact Or.inr ⟨hle, by linarith⟩
  rw [← h] at h1
  rcases h1 with h1 | h1
  · obtain ⟨r, hr, hsub⟩ := mem_interior_iff_ball.1 h1
    have hz : (1 + r / 2 : ℝ) ∈ ball 1 r := mem_ball_iff.2 ⟨by linarith, by linarith⟩
    have := (hsub hz).2
    linarith
  · obtain ⟨r, hr, hsub⟩ := mem_interior_iff_ball.1 h1
    have hz : (1 - r / 2 : ℝ) ∈ ball 1 r := mem_ball_iff.2 ⟨by linarith, by linarith⟩
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
luego `x ∉ cl (A ∪ B)` (`Comun.closure_union_bolas`). -/
theorem ej6c (A B : Set E) : closure (A ∪ B) = closure A ∪ closure B := closure_union_bolas A B

/-! ## (d) `cl (A ∩ B) ⊆ cl A ∩ cl B` y un ejemplo con desigualdad estricta -/

/-- **Ej. 6 (d).** Por monotonía de la clausura, con `A ∩ B ⊆ A` y `A ∩ B ⊆ B`
(`Comun.closure_inter_subset_bolas`). -/
theorem ej6d (A B : Set E) : closure (A ∩ B) ⊆ closure A ∩ closure B :=
  closure_inter_subset_bolas A B

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
      refine ⟨1 - min r 1 / 2, mem_ball_iff.2 ⟨by linarith, by linarith⟩, ?_, ?_⟩
      · linarith
      · linarith
    · rw [mem_closure_iff_ball]
      intro r hr
      have hm0 : 0 < min r 1 := lt_min hr one_pos
      have hm1 : min r 1 ≤ r := min_le_left _ _
      have hm2 : min r 1 ≤ 1 := min_le_right _ _
      refine ⟨1 + min r 1 / 2, mem_ball_iff.2 ⟨by linarith, by linarith⟩, ?_, ?_⟩
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
