/-
Práctica 3 · Ejercicio 15 (`apuntes-typst/guias/p3.typ`).

Sea `(E, d)` un espacio métrico completo y `A ⊆ E`. Si `A` es cerrado, entonces `(A, d)` es
completo.

`↥A` es el subtipo con la métrica restringida (la de Mathlib es exactamente `d|_{A×A}`:
`Subtype.dist_eq`). La prueba sigue el argumento por sucesiones del texto:
1. una sucesión de Cauchy en `A` es de Cauchy en `E`;
2. por completitud de `E` converge a un `l ∈ E` (Definición 4.55);
3. `l ∈ A` por ser `A` cerrado (Corolario 4.47);
4. entonces la sucesión converge a `l` *dentro de `A`*, pues las distancias coinciden.
-/
import Mathlib

open Filter Topology

namespace Guias.Guia3.Ej15

/-- **Ejercicio 15.** Un cerrado de un espacio métrico completo es completo con la métrica
restringida. -/
theorem ej15 {E : Type*} [MetricSpace E] [CompleteSpace E] (A : Set E) (hA : IsClosed A) :
    CompleteSpace A := by
  -- Es completo si toda sucesión de Cauchy converge (Definición 4.55).
  apply Metric.complete_of_cauchySeq_tendsto
  intro u hu
  -- 1. `(uₙ)` vista en `E` es de Cauchy: las distancias son las mismas.
  have hv : CauchySeq (fun n => (u n : E)) := by
    rw [Metric.cauchySeq_iff] at hu ⊢
    intro ε hε
    obtain ⟨N, hN⟩ := hu ε hε
    refine ⟨N, fun m hm n hn => ?_⟩
    have := hN m hm n hn
    rwa [Subtype.dist_eq] at this
  -- 2. `E` es completo: `uₙ → l` en `E`.
  obtain ⟨l, hl⟩ := cauchySeq_tendsto_of_complete hv
  -- 3. `A` es cerrado y `uₙ ∈ A`, luego `l ∈ A` (Corolario 4.47).
  have hlA : l ∈ A := hA.mem_of_tendsto hl (Eventually.of_forall fun n => (u n).2)
  -- 4. `uₙ → ⟨l, hlA⟩` en `A`: `d(uₙ, l)` es la misma cantidad en `A` y en `E`.
  refine ⟨⟨l, hlA⟩, ?_⟩
  rw [Metric.tendsto_atTop] at hl ⊢
  intro ε hε
  obtain ⟨N, hN⟩ := hl ε hε
  refine ⟨N, fun n hn => ?_⟩
  rw [Subtype.dist_eq]
  exact hN n hn

end Guias.Guia3.Ej15
