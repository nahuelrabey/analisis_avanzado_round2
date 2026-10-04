/-
Práctica 3, Ejercicio 4 (bolas, conjuntos abiertos y cerrados), con las nociones del curso:
interior (Definición 4.11), abierto (4.14), clausura (4.22) y cerrado (4.27).
Resolución "a mano" en `apuntes-typst/guias-agente/guia_3_resuelta_agente.typ` (Ejercicio 4).

Los objetos son los de Mathlib (`interior`, `closure`, `Metric.ball`, `Metric.closedBall`,
`IsOpen`, `IsClosed`), pero las demostraciones pasan por las caracterizaciones por bolas
(`Guias.mem_closure_iff_ball`, `Guias.closure_mono_ball` de `Common.lean`; `Metric.isOpen_iff`,
`dist_triangle`) y no por los lemas de Mathlib que son literalmente los ítems. "Abierto" es
`IsOpen`, que `Metric.isOpen_iff` lee como "todo punto tiene una bola adentro" (`A ⊆ A°`, que con
la Observación 4.12 es la Definición 4.14).
-/
import Mathlib
import Guias.Common

open Metric Set Guias

namespace Guias.Guia3.Ej04

variable {E : Type*} [MetricSpace E]

/-- Teorema 4.29: `F` es cerrado (`cl F = F`, Definición 4.27) si y sólo si `Fᶜ` es abierto. -/
theorem isClosed_iff_isOpen_compl_ball {F : Set E} : IsClosed F ↔ IsOpen Fᶜ := by
  rw [← closure_eq_iff_isClosed, Metric.isOpen_iff]
  constructor
  · intro h x hx
    by_contra hcon
    push Not at hcon
    have hxF : x ∈ closure F := by
      rw [mem_closure_iff_ball]
      intro r hr
      obtain ⟨z, hz1, hz2⟩ := not_subset.1 (hcon r hr)
      exact ⟨z, hz1, not_not.1 hz2⟩
    exact hx (h ▸ hxF)
  · intro h
    refine Subset.antisymm ?_ (subset_closure_ball F)
    intro x hx
    by_contra hxF
    obtain ⟨r, hr, hball⟩ := h x hxF
    obtain ⟨z, hz1, hz2⟩ := (mem_closure_iff_ball.1 hx) r hr
    exact hball hz1 hz2

/-- Teorema 4.18 (para dos abiertos): se toma `r = mín {r₁, r₂}`. -/
theorem isOpen_inter_ball {A B : Set E} (hA : IsOpen A) (hB : IsOpen B) : IsOpen (A ∩ B) := by
  rw [Metric.isOpen_iff] at hA hB ⊢
  intro x hx
  obtain ⟨r₁, hr₁, h₁⟩ := hA x hx.1
  obtain ⟨r₂, hr₂, h₂⟩ := hB x hx.2
  refine ⟨min r₁ r₂, lt_min hr₁ hr₂, fun y hy => ⟨h₁ ?_, h₂ ?_⟩⟩
  · exact ball_subset_ball (min_le_left _ _) hy
  · exact ball_subset_ball (min_le_right _ _) hy

/-! ## (a) `{x}` es cerrado -/

/-- **Ej. 4 (a).** `{x}` es cerrado: si `y ∈ cl {x}`, toda bola `B(y, r)` contiene a `x`, así que
`d(y, x) < r` para todo `r > 0` y por lo tanto `y = x`. -/
theorem ej4a (x : E) : IsClosed ({x} : Set E) := by
  rw [← closure_eq_iff_isClosed]
  refine Subset.antisymm ?_ (subset_closure_ball _)
  intro y hy
  rw [mem_closure_iff_ball] at hy
  by_contra hne
  have hpos : 0 < dist y x := dist_pos.2 hne
  obtain ⟨z, hz1, hz2⟩ := hy (dist y x) hpos
  have hzx : z = x := hz2
  subst hzx
  have := mem_ball.1 hz1
  rw [dist_comm] at this
  exact lt_irrefl _ this

/-! ## (b) `B(x, r)` es abierta -/

/-- **Ej. 4 (b).** `B(x, r)` es abierta (vale para todo `r`, en particular para `r > 0`):
si `y ∈ B(x, r)`, la bola `B(y, r - d(y, x))` queda dentro de `B(x, r)` por la triangular. -/
theorem ej4b (x : E) (r : ℝ) : IsOpen (ball x r) := by
  rw [Metric.isOpen_iff]
  intro y hy
  have hy' := mem_ball.1 hy
  refine ⟨r - dist y x, by linarith, ?_⟩
  intro z hz
  have hz' := mem_ball.1 hz
  rw [mem_ball]
  calc dist z x ≤ dist z y + dist y x := dist_triangle _ _ _
    _ < r := by linarith

/-! ## (c) `cl B(x, r') ⊆ B(x, r)` si `r' < r` -/

/-- **Ej. 4 (c).** Si `r' < r` (el argumento no usa `r' > 0`) entonces `cl B(x, r') ⊆ B(x, r)`:
para `y ∈ cl B(x, r')` se toma `ε = r - r'` y un `z ∈ B(x, r') ∩ B(y, ε)`, de modo que
`d(y, x) ≤ d(y, z) + d(z, x) < (r - r') + r' = r`. -/
theorem ej4c (x : E) {r r' : ℝ} (hrr : r' < r) : closure (ball x r') ⊆ ball x r := by
  intro y hy
  rw [mem_closure_iff_ball] at hy
  obtain ⟨z, hz1, hz2⟩ := hy (r - r') (by linarith)
  have h1 := mem_ball.1 hz1
  have h2 := mem_ball.1 hz2
  rw [mem_ball]
  calc dist y x ≤ dist y z + dist z x := dist_triangle _ _ _
    _ < r := by rw [dist_comm y z]; linarith

/-! ## (d) `B̄(x, r)` es cerrada -/

/-- **Ej. 4 (d).** `B̄(x, r) = {y | d(x, y) ≤ r}` es cerrada: su complemento es abierto, pues si
`d(y, x) > r` entonces `B(y, d(y, x) - r)` no corta a `B̄(x, r)` (Teorema 4.29). -/
theorem ej4d (x : E) (r : ℝ) : IsClosed (closedBall x r) := by
  rw [isClosed_iff_isOpen_compl_ball, Metric.isOpen_iff]
  intro y hy
  have hy' : r < dist y x := by simpa [mem_closedBall] using hy
  refine ⟨dist y x - r, by linarith, ?_⟩
  intro z hz
  have hz' := mem_ball.1 hz
  have htri := dist_triangle y z x
  rw [dist_comm y z] at htri
  rw [mem_compl_iff, mem_closedBall, not_le]
  linarith

/-! ## (e) `cl B(x, r) ⊆ B̄(x, r)` -/

/-- **Ej. 4 (e).** `B(x, r) ⊆ B̄(x, r)`, la clausura es monótona y `B̄(x, r)` es cerrada por (d),
luego `cl B(x, r) ⊆ cl B̄(x, r) = B̄(x, r)`. -/
theorem ej4e (x : E) (r : ℝ) : closure (ball x r) ⊆ closedBall x r := by
  have hsub : ball x r ⊆ closedBall x r := fun z hz => mem_closedBall.2 (mem_ball.1 hz).le
  intro y hy
  have hy2 : y ∈ closure (closedBall x r) := closure_mono_ball hsub hy
  rwa [(ej4d x r).closure_eq] at hy2

/-! ## (f) Un ejemplo con inclusión estricta: la métrica discreta -/

/-- Un conjunto `X` con la métrica discreta `δ(x, y) = 0` si `x = y`, `1` si no. -/
def Disc (X : Type*) : Type _ := X

-- Sólo la instancia y los dos cálculos de bolas necesitan decidir `x = y`.
open scoped Classical in
noncomputable instance {X : Type*} : MetricSpace (Disc X) where
  dist x y := if x = y then 0 else 1
  dist_self x := by simp
  dist_comm x y := by
    show (if x = y then (0 : ℝ) else 1) = if y = x then 0 else 1
    by_cases h : x = y
    · rw [ite_eq_left h, ite_eq_left h.symm]
    · rw [ite_eq_right h, ite_eq_right (Ne.symm h)]
  dist_triangle x y z := by
    show (if x = z then (0 : ℝ) else 1) ≤ (if x = y then 0 else 1) + (if y = z then 0 else 1)
    by_cases hxz : x = z
    · rw [ite_eq_left hxz]; split_ifs <;> norm_num
    · rw [ite_eq_right hxz]
      by_cases hxy : x = y
      · have hyz : y ≠ z := fun h => hxz (hxy.trans h)
        rw [ite_eq_left hxy, ite_eq_right hyz]; norm_num
      · rw [ite_eq_right hxy]; split_ifs <;> norm_num
  eq_of_dist_eq_zero := by
    intro x y h
    by_contra hxy
    change (if x = y then (0 : ℝ) else 1) = 0 at h
    rw [ite_eq_right hxy] at h
    exact one_ne_zero h

open scoped Classical in
theorem Disc.dist_eq {X : Type*} (x y : Disc X) : dist x y = if x = y then 0 else 1 := rfl

open scoped Classical in
/-- En la métrica discreta, `B(x, 1) = {x}`. -/
theorem Disc.ball_one {X : Type*} (x : Disc X) : ball x 1 = {x} := by
  ext z
  rw [mem_ball, Disc.dist_eq, mem_singleton_iff]
  by_cases h : z = x
  · simp [h]
  · simp [h]

open scoped Classical in
/-- En la métrica discreta, `B̄(x, 1)` es todo el espacio. -/
theorem Disc.closedBall_one {X : Type*} (x : Disc X) : closedBall x 1 = univ := by
  ext z
  rw [mem_closedBall, Disc.dist_eq]
  simp only [mem_univ, iff_true]
  split_ifs <;> norm_num

/-- **Ej. 4 (f).** En `X` con la métrica discreta y al menos dos puntos,
`cl B(x, 1) = {x} ⊊ X = B̄(x, 1)`: la inclusión de (e) puede ser estricta. -/
theorem ej4f {X : Type*} [Nontrivial X] (x : Disc X) :
    closure (ball x 1) ⊂ closedBall x 1 := by
  have hcl : closure (ball x 1) = {x} := by
    rw [Disc.ball_one]
    exact (ej4a x).closure_eq
  refine ⟨ej4e x 1, fun h => ?_⟩
  obtain ⟨y, hy⟩ : ∃ y : Disc X, y ≠ x := exists_ne (show X from x)
  have hy1 : y ∈ closedBall x 1 := by rw [Disc.closedBall_one]; trivial
  have := h hy1
  rw [hcl, mem_singleton_iff] at this
  exact hy this

/-- Caso concreto de (f): el conjunto `{false, true}` con la métrica discreta. -/
theorem ej4f_bool (x : Disc Bool) : closure (ball x 1) ⊂ closedBall x 1 := ej4f x

/-! ## (g) `{y | 2 < d(y, x) < 3}` es abierto -/

/-- **Ej. 4 (g).** `{y | 2 < d(y, x) < 3} = B(x, 3) ∩ (B̄(x, 2))ᶜ` es intersección de dos abiertos:
`B(x, 3)` por (b) y `(B̄(x, 2))ᶜ` por (d) y el Teorema 4.29; se concluye con el Teorema 4.18. -/
theorem ej4g (x : E) : IsOpen {y : E | 2 < dist y x ∧ dist y x < 3} := by
  have h : {y : E | 2 < dist y x ∧ dist y x < 3} = ball x 3 ∩ (closedBall x 2)ᶜ := by
    ext y
    constructor
    · rintro ⟨h1, h2⟩
      exact ⟨mem_ball.2 h2, fun h => absurd (mem_closedBall.1 h) (not_le.2 h1)⟩
    · rintro ⟨h1, h2⟩
      exact ⟨not_le.1 fun h => h2 (mem_closedBall.2 h), mem_ball.1 h1⟩
  rw [h]
  exact isOpen_inter_ball (ej4b x 3) (isClosed_iff_isOpen_compl_ball.1 (ej4d x 2))

end Guias.Guia3.Ej04
