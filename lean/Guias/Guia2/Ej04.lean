/-
Análisis Avanzado (FCEN-UBA) · Práctica 2 · Ejercicio 4
Enunciado en `apuntes-typst/guias/p2.typ`; resolución en
`apuntes-typst/guias-agente/guia_2_resuelta_agente.typ` (Ejercicio 4).

`#(ℝ \ ℚ) = c`. Se aplica el Ej. 3 (b) con `A = ℚ ⊆ B = ℝ`: `ℚ` es contable (Proposición
"Numerabilidad de ℚ") y `ℝ \ ℚ` es infinito (si fuera finito, `ℝ = ℚ ∪ (ℝ \ ℚ)` sería contable
por el Ej. 2, contra el Teorema 3.19). Entonces `ℝ \ ℚ ∼ ℝ`.

Los irracionales se escriben como `{x : ℝ | Irrational x}`; como `Irrational x` es, por
definición en Mathlib, `x ∉ Set.range ((↑) : ℚ → ℝ)`, ese conjunto es literalmente
`(Set.range ((↑) : ℚ → ℝ))ᶜ = Set.univ \ Set.range (↑)`, que es el `B \ A` del Ej. 3.
Los Ej. 2 y 3 se importan de `Comun.Cardinales.Numerables` (`union_contable`,
`diff_coordinables`); quedan locales `Qr`, `Qr_numerable` e `irracionales_infinito`.
-/
import Mathlib
import Comun.Cardinales
import Comun.Cardinales.Numerables

namespace Guias.Guia2.Ej04

open Comun

/-- `ℚ` visto adentro de `ℝ`: la imagen de la inclusión `ℚ → ℝ`. -/
def Qr : Set ℝ := Set.range ((↑) : ℚ → ℝ)

/-- `ℚ ⊆ ℝ` es numerable: `ℕ ∼ ℚ ∼ Qr` (la inclusión `ℚ → ℝ` es inyectiva). -/
theorem Qr_numerable : Numerable Qr :=
  coordinables_trans (numerable_rat : Coordinables ℕ ℚ)
    ⟨Equiv.ofInjective ((↑) : ℚ → ℝ) Rat.cast_injective⟩

/-- `ℝ \ ℚ` es infinito: si fuera finito, `ℝ = ℚ ∪ (ℝ \ ℚ)` sería contable (Ej. 2), contra el
Teorema 3.19. -/
theorem irracionales_infinito : Infinito ↥(Set.univ \ Qr) := by
  intro hfin
  apply no_contable_real
  have h := union_contable Qr (Set.univ \ Qr) (contable_of_numerable Qr_numerable)
    (contable_of_finito hfin)
  have e : ↥(Qr ∪ (Set.univ \ Qr)) ≃ ℝ :=
    (Set.equivOfEq (show Qr ∪ (Set.univ \ Qr) = Set.univ by
      rw [Set.union_sdiff_self, Set.union_univ])).trans (Equiv.Set.univ ℝ)
  exact contable_of_cardLe h ⟨e.symm.toEmbedding⟩

/-- **Ej. 4.** `#(ℝ \ ℚ) = c`, con `ℝ \ ℚ = Set.univ \ Qr` (el `B \ A` del Ej. 3 (b)). -/
theorem ej4 : CardC ↥(Set.univ \ Qr) :=
  coordinables_trans
    (diff_coordinables (Set.subset_univ Qr) (contable_of_numerable Qr_numerable)
      irracionales_infinito)
    ⟨Equiv.Set.univ ℝ⟩

/-- **Ej. 4** (misma afirmación, con el complemento): `#(Set.range (↑ : ℚ → ℝ))ᶜ = c`. -/
theorem ej4_compl : CardC ↥(Set.range ((↑) : ℚ → ℝ))ᶜ := by
  rw [Set.compl_eq_univ_sdiff]
  exact ej4

/-- **Ej. 4** (con `Irrational` de Mathlib): `#{x : ℝ | Irrational x} = c`. El conjunto es
definicionalmente `(Set.range (↑))ᶜ`, porque `Irrational x := x ∉ Set.range ((↑) : ℚ → ℝ)`. -/
theorem ej4_irracionales : CardC ↥{x : ℝ | Irrational x} := ej4_compl

end Guias.Guia2.Ej04
