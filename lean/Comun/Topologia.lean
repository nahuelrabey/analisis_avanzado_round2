/-
Librería común `Comun`: definiciones del curso y resultados de `apuntes.typ` compartidos por las
guías (`Guias/`), los parciales (`Parciales/`) y los ejemplos (`Ejemplos/`). Ver
`apuntes-agente/lean-lemas-compartidos-y-organizacion.md` para el diseño.

`Comun.Topologia`: topología de un `MetricSpace` de Mathlib leída con las definiciones por bolas del
curso (interior, Definición 4.11; clausura, Definición 4.22), compartida por las prácticas y los
parciales.
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

end Comun
