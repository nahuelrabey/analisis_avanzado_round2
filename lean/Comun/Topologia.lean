/-
Librería común `Comun`: definiciones del curso y resultados de `apuntes.typ` compartidos por las
guías (`Guias/`), los parciales (`Parciales/`) y los ejemplos (`Ejemplos/`). Ver
`apuntes-agente/lean-lemas-compartidos-y-organizacion.md` para el diseño.

`Comun.Topologia`: topología de un `MetricSpace` de Mathlib leída con las definiciones por bolas del
curso (interior, Definición 4.11; clausura, Definición 4.22), compartida por las prácticas y los
parciales. Los objetos son los de Mathlib (`interior`, `closure`, `IsOpen`, `IsClosed`,
`Metric.ball`, `Metric.closedBall`), pero todas las demostraciones pasan por las caracterizaciones
por bolas (`mem_interior_iff_ball`, `mem_closure_iff_ball`, `Metric.isOpen_iff`) y no por los lemas
de Mathlib que son literalmente los resultados (`isClosed_singleton`, `Metric.isOpen_ball`,
`isOpen_interior`, `interior_inter`, `closure_union`, `frontier_eq_closure_inter_closure`, …);
los que coinciden con uno de Mathlib llevan el sufijo `_bolas`.

Ejercicios de la Práctica 3 que viven acá (los `Guias/Guia3/EjNN.lean` los re-enuncian):
* Ej. 4 (a)-(e): `isClosed_singleton_bolas`, `isOpen_ball_bolas`, `closure_ball_subset_ball_of_lt`,
  `isClosed_closedBall_bolas`, `closure_ball_subset_closedBall_bolas` (con el Teorema 4.29
  `isClosed_iff_isOpen_compl_ball` y el Teorema 4.18 `isOpen_inter_ball`);
* Ej. 5 (a)(b): `compl_interior_eq`, `compl_closure_eq`, más las inclusiones
  `closure_interior_subset`, `interior_subset_interior_closure`;
* Ej. 6 (a)-(d): `interior_inter_bolas`, `interior_union_subset_bolas`, `closure_union_bolas`,
  `closure_inter_subset_bolas`;
* Ej. 9 (a)(b): la frontera `fronteraCurso` (Definición 4.38) con `frontera_eq_sdiff`,
  `frontera_isClosed`, `closure_frontera_eq`, `frontera_eq_inter`, `frontera_compl`, y el Paso 3
  del texto (`isOpen_interior_bolas`, `isClosed_closure_bolas`).
Al final, dos lemas genéricos: `closure_subset_of_sep` (un conjunto `δ`-separado es cerrado; Ej. 11)
e `isOpen_of_subset_interior` (cierre habitual de los parciales).
-/
import Mathlib

namespace Comun

/-! ## Puente entre Mathlib y las definiciones por bolas del curso

Para un `MetricSpace` de Mathlib, `interior` y `closure` se leen con las Definiciones 4.11 y 4.22
de `apuntes.typ` (bolas abiertas `Metric.ball`). Son los únicos lemas de Mathlib sobre `interior`
y `closure` que usan los ejercicios 4, 5, 6 y 9 de la Práctica 3. -/

section Puente

variable {E : Type*} [MetricSpace E]

/-- Definición 4.11: `x` es interior de `A` si hay una bola abierta `B(x, r) ⊆ A`. -/
theorem mem_interior_iff_ball {A : Set E} {x : E} :
    x ∈ interior A ↔ ∃ r > 0, Metric.ball x r ⊆ A := by
  rw [mem_interior_iff_mem_nhds, Metric.mem_nhds_iff]

/-- Definición 4.22: `x` es de adherencia de `A` si toda bola `B(x, r)` corta a `A`. -/
theorem mem_closure_iff_ball {A : Set E} {x : E} :
    x ∈ closure A ↔ ∀ r > 0, (Metric.ball x r ∩ A).Nonempty := by
  rw [Metric.mem_closure_iff]
  constructor
  · intro h r hr
    obtain ⟨b, hb, hd⟩ := h r hr
    exact ⟨b, Metric.mem_ball.2 (by rwa [dist_comm]), hb⟩
  · intro h r hr
    obtain ⟨b, hb, hbA⟩ := h r hr
    exact ⟨b, hbA, by rw [dist_comm]; exact Metric.mem_ball.1 hb⟩

/-- Negación de la Definición 4.22: existe una bola `B(x, r)` que no corta a `A`. -/
theorem notMem_closure_iff_ball {A : Set E} {x : E} :
    x ∉ closure A ↔ ∃ r > 0, ∀ z ∈ Metric.ball x r, z ∉ A := by
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

/-- Observación 4.23 (a): `A ⊆ cl A`. -/
theorem subset_closure_ball (A : Set E) : A ⊆ closure A := by
  intro x hx
  rw [mem_closure_iff_ball]
  exact fun r hr => ⟨x, Metric.mem_ball_self hr, hx⟩

/-- La clausura es monótona (inmediato de la Definición 4.22). -/
theorem closure_mono_ball {A B : Set E} (h : A ⊆ B) : closure A ⊆ closure B := by
  intro x hx
  rw [mem_closure_iff_ball] at hx ⊢
  intro r hr
  obtain ⟨z, hz1, hz2⟩ := hx r hr
  exact ⟨z, hz1, h hz2⟩

end Puente

/-! ## Abiertos y cerrados por bolas (Práctica 3, Ej. 4) -/

section Ej4

open Metric Set

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

/-- **Práctica 3, Ej. 4 (a).** `{x}` es cerrado: si `y ∈ cl {x}`, toda bola `B(y, r)` contiene a
`x`, así que `d(y, x) < r` para todo `r > 0` y por lo tanto `y = x`. La demostración sigue el
texto de `guias-agente/guia_3_resuelta_agente.typ`. -/
theorem isClosed_singleton_bolas (x : E) : IsClosed ({x} : Set E) := by
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

/-- **Práctica 3, Ej. 4 (b).** `B(x, r)` es abierta (vale para todo `r`, en particular para
`r > 0`): si `y ∈ B(x, r)`, la bola `B(y, r - d(y, x))` queda dentro de `B(x, r)` por la
triangular. La demostración sigue el texto de `guias-agente/guia_3_resuelta_agente.typ`. -/
theorem isOpen_ball_bolas (x : E) (r : ℝ) : IsOpen (ball x r) := by
  rw [Metric.isOpen_iff]
  intro y hy
  have hy' := mem_ball.1 hy
  refine ⟨r - dist y x, by linarith, ?_⟩
  intro z hz
  have hz' := mem_ball.1 hz
  rw [mem_ball]
  calc dist z x ≤ dist z y + dist y x := dist_triangle _ _ _
    _ < r := by linarith

/-- **Práctica 3, Ej. 4 (c).** Si `r' < r` (el argumento no usa `r' > 0`) entonces
`cl B(x, r') ⊆ B(x, r)`: para `y ∈ cl B(x, r')` se toma `ε = r - r'` y un
`z ∈ B(x, r') ∩ B(y, ε)`, de modo que `d(y, x) ≤ d(y, z) + d(z, x) < (r - r') + r' = r`.
La demostración sigue el texto de `guias-agente/guia_3_resuelta_agente.typ`. -/
theorem closure_ball_subset_ball_of_lt (x : E) {r r' : ℝ} (hrr : r' < r) :
    closure (ball x r') ⊆ ball x r := by
  intro y hy
  rw [mem_closure_iff_ball] at hy
  obtain ⟨z, hz1, hz2⟩ := hy (r - r') (by linarith)
  have h1 := mem_ball.1 hz1
  have h2 := mem_ball.1 hz2
  rw [mem_ball]
  calc dist y x ≤ dist y z + dist z x := dist_triangle _ _ _
    _ < r := by rw [dist_comm y z]; linarith

/-- **Práctica 3, Ej. 4 (d).** `B̄(x, r) = {y | d(x, y) ≤ r}` es cerrada: su complemento es
abierto, pues si `d(y, x) > r` entonces `B(y, d(y, x) - r)` no corta a `B̄(x, r)` (Teorema 4.29).
La demostración sigue el texto de `guias-agente/guia_3_resuelta_agente.typ`. -/
theorem isClosed_closedBall_bolas (x : E) (r : ℝ) : IsClosed (closedBall x r) := by
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

/-- **Práctica 3, Ej. 4 (e).** `B(x, r) ⊆ B̄(x, r)`, la clausura es monótona y `B̄(x, r)` es
cerrada por (d), luego `cl B(x, r) ⊆ cl B̄(x, r) = B̄(x, r)`. La demostración sigue el texto de
`guias-agente/guia_3_resuelta_agente.typ`. -/
theorem closure_ball_subset_closedBall_bolas (x : E) (r : ℝ) :
    closure (ball x r) ⊆ closedBall x r := by
  have hsub : ball x r ⊆ closedBall x r := fun z hz => mem_closedBall.2 (mem_ball.1 hz).le
  intro y hy
  have hy2 : y ∈ closure (closedBall x r) := closure_mono_ball hsub hy
  rwa [(isClosed_closedBall_bolas x r).closure_eq] at hy2

end Ej4

/-! ## Interior y clausura del complemento (Práctica 3, Ej. 5) -/

section Ej5

open Metric Set

variable {E : Type*} [MetricSpace E]

/-- **Práctica 3, Ej. 5 (a).** `E ∖ A° = cl (E ∖ A)`: `x ∉ A°` ⟺ ninguna bola `B(x, r)` está
contenida en `A` ⟺ toda bola `B(x, r)` corta a `E ∖ A` ⟺ `x ∈ cl (E ∖ A)`. La demostración
sigue el texto de `guias-agente/guia_3_resuelta_agente.typ`. -/
theorem compl_interior_eq (A : Set E) : (interior A)ᶜ = closure Aᶜ := by
  ext x
  rw [Set.mem_compl_iff, mem_interior_iff_ball, mem_closure_iff_ball]
  push Not
  refine forall₂_congr fun r _ => ?_
  rw [Set.not_subset]
  constructor
  · rintro ⟨y, hy, hyA⟩
    exact ⟨y, hy, hyA⟩
  · rintro ⟨y, hy, hyA⟩
    exact ⟨y, hy, hyA⟩

/-- **Práctica 3, Ej. 5 (b).** `E ∖ cl A = (E ∖ A)°` (es el (a) aplicado a `E ∖ A`). -/
theorem compl_closure_eq (A : Set E) : (closure A)ᶜ = interior Aᶜ := by
  rw [← compl_compl (interior Aᶜ), compl_interior_eq, compl_compl]

/-- `cl (A°) ⊆ cl A`, pues `A° ⊆ A` (Observación 4.12) y la clausura es monótona. -/
theorem closure_interior_subset (A : Set E) : closure (interior A) ⊆ closure A := by
  apply closure_mono_ball
  intro x hx
  obtain ⟨r, hr, hsub⟩ := mem_interior_iff_ball.1 hx
  exact hsub (mem_ball_self hr)

/-- `A° ⊆ (cl A)°`, pues `A ⊆ cl A` (Observación 4.23 (a)): la misma bola sirve. -/
theorem interior_subset_interior_closure (A : Set E) : interior A ⊆ interior (closure A) := by
  intro x hx
  obtain ⟨r, hr, hsub⟩ := mem_interior_iff_ball.1 hx
  exact mem_interior_iff_ball.2 ⟨r, hr, hsub.trans (subset_closure_ball A)⟩

/-- Paso 3 del Ej. 9: `A°` es abierto. Si `B(x, r) ⊆ A` e `y ∈ B(x, r)`, la bola
`B(y, r - d(y, x))` queda dentro de `B(x, r) ⊆ A` (triangular), así que `y ∈ A°`. -/
theorem isOpen_interior_bolas (A : Set E) : IsOpen (interior A) := by
  rw [Metric.isOpen_iff]
  intro x hx
  obtain ⟨r, hr, hsub⟩ := mem_interior_iff_ball.1 hx
  refine ⟨r, hr, fun y hy => ?_⟩
  rw [Metric.mem_ball] at hy
  refine mem_interior_iff_ball.2 ⟨r - dist y x, by linarith, fun z hz => hsub ?_⟩
  rw [Metric.mem_ball] at hz ⊢
  calc dist z x ≤ dist z y + dist y x := dist_triangle _ _ _
    _ < r := by linarith

/-- Paso 3 del Ej. 9: `cl A` es cerrado, porque su complemento `(E ∖ A)°` es abierto
(Ej. 5 (b) y Teorema 4.29, que acá es `isOpen_compl_iff`). -/
theorem isClosed_closure_bolas (A : Set E) : IsClosed (closure A) := by
  rw [← isOpen_compl_iff, compl_closure_eq]
  exact isOpen_interior_bolas Aᶜ

end Ej5

/-! ## Interior y clausura frente a unión e intersección (Práctica 3, Ej. 6) -/

section Ej6

open Metric Set

variable {E : Type*} [MetricSpace E]

/-- **Práctica 3, Ej. 6 (a).** `(A ∩ B)° = A° ∩ B°`. `⊆`: una bola dentro de `A ∩ B` está dentro
de `A` y de `B`. `⊇`: si `B(x, r₁) ⊆ A` y `B(x, r₂) ⊆ B`, la bola de radio `mín {r₁, r₂}` está
en ambos. La demostración sigue el texto de `guias-agente/guia_3_resuelta_agente.typ`. -/
theorem interior_inter_bolas (A B : Set E) : interior (A ∩ B) = interior A ∩ interior B := by
  ext x
  rw [mem_inter_iff, mem_interior_iff_ball, mem_interior_iff_ball, mem_interior_iff_ball]
  constructor
  · rintro ⟨r, hr, h⟩
    exact ⟨⟨r, hr, h.trans inter_subset_left⟩, ⟨r, hr, h.trans inter_subset_right⟩⟩
  · rintro ⟨⟨r₁, hr₁, h₁⟩, ⟨r₂, hr₂, h₂⟩⟩
    refine ⟨min r₁ r₂, lt_min hr₁ hr₂, fun z hz => ⟨?_, ?_⟩⟩
    · exact h₁ (ball_subset_ball (min_le_left _ _) hz)
    · exact h₂ (ball_subset_ball (min_le_right _ _) hz)

/-- **Práctica 3, Ej. 6 (b).** `A° ∪ B° ⊆ (A ∪ B)°`: una bola dentro de `A` (o de `B`) está dentro
de `A ∪ B`. -/
theorem interior_union_subset_bolas (A B : Set E) :
    interior A ∪ interior B ⊆ interior (A ∪ B) := by
  rintro x (hx | hx)
  · obtain ⟨r, hr, h⟩ := mem_interior_iff_ball.1 hx
    exact mem_interior_iff_ball.2 ⟨r, hr, h.trans subset_union_left⟩
  · obtain ⟨r, hr, h⟩ := mem_interior_iff_ball.1 hx
    exact mem_interior_iff_ball.2 ⟨r, hr, h.trans subset_union_right⟩

/-- **Práctica 3, Ej. 6 (c).** `cl (A ∪ B) = cl A ∪ cl B`. `⊇` por monotonía. `⊆`: si `x ∉ cl A`
y `x ∉ cl B` hay `B(x, r₁)` que no corta a `A` y `B(x, r₂)` que no corta a `B`; la bola de radio
`mín {r₁, r₂}` no corta a `A ∪ B`, luego `x ∉ cl (A ∪ B)`. La demostración sigue el texto de
`guias-agente/guia_3_resuelta_agente.typ`. -/
theorem closure_union_bolas (A B : Set E) : closure (A ∪ B) = closure A ∪ closure B := by
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

/-- **Práctica 3, Ej. 6 (d).** `cl (A ∩ B) ⊆ cl A ∩ cl B`, por monotonía de la clausura, con
`A ∩ B ⊆ A` y `A ∩ B ⊆ B`. -/
theorem closure_inter_subset_bolas (A B : Set E) : closure (A ∩ B) ⊆ closure A ∩ closure B :=
  fun _ hx => ⟨closure_mono_ball inter_subset_left hx, closure_mono_ball inter_subset_right hx⟩

end Ej6

/-! ## Frontera (Definición 4.38; Práctica 3, Ej. 9) -/

section Frontera

variable {E : Type*} [MetricSpace E]

/-- Definición 4.38: `x ∈ ∂A` si toda bola `B(x, r)` corta a `A` y a `E ∖ A`. -/
def fronteraCurso (A : Set E) : Set E :=
  {x | ∀ r > 0, (Metric.ball x r ∩ A).Nonempty ∧ (Metric.ball x r ∩ Aᶜ).Nonempty}

/-- **Práctica 3, Ej. 9 (b), igualdad.** `∂A = cl A ∩ cl (E ∖ A)`: reescritura por definición
(ambas se leen por bolas). -/
theorem frontera_eq_inter (A : Set E) : fronteraCurso A = closure A ∩ closure Aᶜ := by
  ext x
  rw [Set.mem_inter_iff, mem_closure_iff_ball, mem_closure_iff_ball]
  constructor
  · intro h
    exact ⟨fun r hr => (h r hr).1, fun r hr => (h r hr).2⟩
  · rintro ⟨h1, h2⟩ r hr
    exact ⟨h1 r hr, h2 r hr⟩

/-- **Práctica 3, Ej. 9 (a), igualdad.** `∂A = cl A ∖ A°`. Se usa `∂A = cl A ∩ cl (E ∖ A)` y
el Ej. 5 (a): `cl (E ∖ A) = E ∖ A°`. -/
theorem frontera_eq_sdiff (A : Set E) : fronteraCurso A = closure A \ interior A := by
  rw [frontera_eq_inter, ← compl_interior_eq]
  rfl

/-- **Práctica 3, Ej. 9 (a), cerrado.** `∂A = cl A ∩ (E ∖ A°)` es intersección de dos cerrados
(Teorema 4.31 (a)): `cl A` por `isClosed_closure_bolas` y `E ∖ A°` por el Teorema 4.29
(`isClosed_compl_iff`) con `isOpen_interior_bolas`. -/
theorem frontera_isClosed (A : Set E) : IsClosed (fronteraCurso A) := by
  rw [frontera_eq_sdiff, Set.sdiff_eq]
  exact (isClosed_closure_bolas A).inter (isClosed_compl_iff.2 (isOpen_interior_bolas A))

/-- Lo mismo en la forma de la Definición 4.27: `cl (∂A) = ∂A`. -/
theorem closure_frontera_eq (A : Set E) : closure (fronteraCurso A) = fronteraCurso A :=
  (frontera_isClosed A).closure_eq

/-- **Práctica 3, Ej. 9 (b), conclusión.** `∂A = ∂(E ∖ A)`: como `E ∖ (E ∖ A) = A`, la fórmula
`∂A = cl A ∩ cl (E ∖ A)` aplicada a `E ∖ A` da `cl (E ∖ A) ∩ cl A`, que es lo mismo por
conmutatividad. -/
theorem frontera_compl (A : Set E) : fronteraCurso A = fronteraCurso Aᶜ := by
  rw [frontera_eq_inter A, frontera_eq_inter Aᶜ, compl_compl, Set.inter_comm]

end Frontera

/-! ## Dos lemas genéricos -/

section Genericos

variable {E : Type*} [MetricSpace E]

/-- Un conjunto `S` con puntos distintos a distancia `≥ δ > 0` es cerrado: `cl S ⊆ S`.
Si `x ∈ cl S`, hay `a ∈ S` con `d(x, a) < δ/2`; si fuera `x ≠ a`, tomando
`ε = mín(d(x, a), δ/2)` hay `a' ∈ S` con `d(x, a') < ε`, y entonces `d(a, a') < δ`, luego
`a' = a`, pero `d(x, a') < d(x, a) = d(x, a')`. -/
theorem closure_subset_of_sep {S : Set E} {δ : ℝ} (hδ : 0 < δ)
    (hS : ∀ a ∈ S, ∀ a' ∈ S, a ≠ a' → δ ≤ dist a a') : closure S ⊆ S := by
  intro x hx
  obtain ⟨a, ha, hxa⟩ := Metric.mem_closure_iff.1 hx (δ / 2) (by positivity)
  by_cases hxeq : x = a
  · rw [hxeq]; exact ha
  · exfalso
    have hpos : 0 < dist x a := dist_pos.2 hxeq
    obtain ⟨a', ha', hxa'⟩ := Metric.mem_closure_iff.1 hx (min (dist x a) (δ / 2))
      (lt_min hpos (by positivity))
    have h1 : dist x a' < dist x a := lt_of_lt_of_le hxa' (min_le_left _ _)
    have h2 : dist x a' < δ / 2 := lt_of_lt_of_le hxa' (min_le_right _ _)
    have h3 : dist a a' ≤ dist a x + dist x a' := dist_triangle _ _ _
    rw [dist_comm a x] at h3
    by_cases haa : a = a'
    · rw [haa] at h1
      exact lt_irrefl _ h1
    · have := hS a ha a' ha' haa
      linarith

/-- Si todo punto de `A` es interior (`A ⊆ A°`), `A` es abierto (Definición 4.14 vía
`Metric.isOpen_iff`). -/
theorem isOpen_of_subset_interior {A : Set E} (h : A ⊆ interior A) : IsOpen A := by
  rw [Metric.isOpen_iff]
  intro x hx
  exact mem_interior_iff_ball.1 (h hx)

end Genericos

/-! ## Sucesiones decrecientes de conjuntos -/

/-- Si `A (n+1) ⊆ A n` para todo `n` (sucesión decreciente de conjuntos), `A m ⊆ A n` cuando
`n ≤ m`. Es el esqueleto de `Comun.decreciente_le` para conjuntos (Práctica 3, Ej. 16). -/
theorem antitone_subset_of_succ {X : Type*} (A : ℕ → Set X) (hdec : ∀ n, A (n + 1) ⊆ A n) {n m : ℕ} (h : n ≤ m) :
    A m ⊆ A n := by
  induction h with
  | refl => exact subset_rfl
  | step _ ih => exact (hdec _).trans ih

end Comun
