/-
Práctica 1, Ejercicio 3 (equivalencia de ínfimo con `ε`): para `A ⊆ ℝ` no vacío y acotado
inferiormente, `i = ínf A` sii `i` es cota inferior y para todo `ε > 0` hay `a ∈ A` con
`i ≤ a < i + ε`.
Resolución "a mano" en `apuntes-typst/guias-agente/guia_1_resuelta_agente.typ` (Ejercicio 3).

Se prueba desde la Definición 5 (`EsInf`), sin usar la Proposición 5 (`equiv_inf`), que es
literalmente este ejercicio. Las hipótesis `A ≠ ∅` y "acotado inferiormente" son las del
enunciado (dan sentido a `ínf A`) pero el argumento no las necesita.
-/
import Mathlib
import Comun.Reales
import Comun.Supremos
import Comun.Sucesiones

open Comun

namespace Guias.Guia1.Ej03

/-- **Ej. 3.** `i = ínf A` sii `i ≤ a` para todo `a ∈ A` y para todo `ε > 0` hay `a ∈ A` con
`i ≤ a < i + ε`.
(⇒) Si no hubiera tal `a`, como `i ≤ a` siempre vale, todo `a ∈ A` cumpliría `i + ε ≤ a`:
`i + ε` sería cota inferior y por la Definición 5 (b) `i + ε ≤ i`, absurdo.
(⇐) Si `t` es cota inferior y `i < t`, con `ε = t - i` hay `a ∈ A` con `a < t`, absurdo. -/
theorem ej3 {A : Set ℝ} (_hne : A.Nonempty) (_hb : AcotadoInf A) {i : ℝ} :
    EsInf A i ↔ CotaInf A i ∧ ∀ ε > 0, ∃ a ∈ A, i ≤ a ∧ a < i + ε := by
  constructor
  · rintro ⟨hi, hmax⟩
    refine ⟨hi, fun ε hε => ?_⟩
    by_contra hcon
    push Not at hcon
    have ht : CotaInf A (i + ε) := fun a ha => hcon a ha (hi a ha)
    linarith [hmax _ ht]
  · rintro ⟨hi, hε⟩
    refine ⟨hi, fun t ht => ?_⟩
    by_contra hlt
    obtain ⟨a, haA, _, ha⟩ := hε (t - i) (by linarith [not_le.1 hlt])
    linarith [ht a haA]

end Guias.Guia1.Ej03
