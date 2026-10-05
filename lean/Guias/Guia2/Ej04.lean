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
Los Ej. 2 y 3 se reprueban localmente (los archivos son independientes).
-/
import Mathlib
import Guias.Guia2.Defs

namespace Guias.Guia2.Ej04

open Guias.Guia2

/-! ## Ej. 2, reprobado localmente (los archivos son independientes entre sí) -/

/-- (Ej. 2, Sublema 1) Si `A` es contable entonces `#A ≤ #ℕ`. -/
theorem cardLe_nat_of_contable {A : Type*} (h : Contable A) : CardLe A ℕ := by
  rcases h with ⟨n, ⟨e⟩⟩ | h
  · exact ⟨e.toEmbedding.trans Fin.valEmbedding⟩
  · obtain ⟨e⟩ := h
    exact ⟨e.symm.toEmbedding⟩

/-- (Ej. 2, Sublema 2) `ℕ ⊕ ℕ ↪ ℕ`: pares e impares. -/
def sumNatEmb : ℕ ⊕ ℕ ↪ ℕ where
  toFun := Sum.elim (fun n => 2 * n) (fun n => 2 * n + 1)
  inj' := by
    rintro (n | n) (m | m) h <;>
      simp only [Sum.elim_inl, Sum.elim_inr, Sum.inl.injEq, Sum.inr.injEq, reduceCtorEq] at h ⊢ <;>
      omega

/-- (Ej. 2, Sublema 3) `A ∪ B ↪ A ⊕ B`. -/
noncomputable def unionEmb {X : Type*} (A B : Set X) : ↥(A ∪ B) ↪ ↥A ⊕ ↥B where
  toFun x := by
    classical
    exact if h : (x : X) ∈ A then Sum.inl ⟨x, h⟩ else Sum.inr ⟨x, x.2.resolve_left h⟩
  inj' := by
    classical
    rintro ⟨x, hx⟩ ⟨y, hy⟩ h
    by_cases h1 : x ∈ A <;> by_cases h2 : y ∈ A <;>
      simp only [h1, h2, dite_true, dite_false, Sum.inl.injEq, Sum.inr.injEq, Subtype.mk.injEq,
        reduceCtorEq] at h <;>
      exact Subtype.ext h

/-- (Ej. 2) Si `A` y `B` son contables, `A ∪ B` es contable. -/
theorem union_contable {X : Type*} (A B : Set X) (hA : Contable A) (hB : Contable B) :
    Contable ↥(A ∪ B) := by
  obtain ⟨fA⟩ := cardLe_nat_of_contable hA
  obtain ⟨fB⟩ := cardLe_nat_of_contable hB
  have h : CardLe ↥(A ∪ B) ℕ :=
    ⟨((unionEmb A B).trans (Function.Embedding.sumMap fA fB)).trans sumNatEmb⟩
  exact contable_of_cardLe_numerable numerable_nat h

/-! ## Ej. 3, reprobado localmente -/

/-- Hecho de base: un conjunto que contiene a uno infinito es infinito (acá, `C ⊆ C ∪ A` con
`C` numerable). En Mathlib es `Set.Infinite.mono`. -/
theorem infinito_union_left {X : Type*} {C A : Set X} (hC : Numerable C) :
    Infinito ↥(C ∪ A) := by
  rw [infinito_iff_infinite, Set.infinite_coe_iff]
  have : Infinite C := (numerable_iff.1 hC).2
  exact (Set.infinite_coe_iff.1 this).mono Set.subset_union_left

/-- (Ej. 3 (a)) Si `A` es contable y `B \ A` es infinito, hay `C ⊆ B \ A` con `C ∼ C ∪ A`:
`C` es el numerable de la Proposición 3.14, y `C ∪ A` es contable (Ej. 2) e infinito, luego
numerable. La hipótesis `A ⊆ B` no hace falta en este ítem. -/
theorem exists_C_coordinables {X : Type*} {A B : Set X} (hA : Contable A)
    (hBA : Infinito ↥(B \ A)) : ∃ C : Set X, C ⊆ B \ A ∧ Coordinables C ↥(C ∪ A) := by
  -- Proposición 3.14: una inyección `ℕ → B \ A`; su imagen es el `C` buscado
  obtain ⟨f⟩ := cardLe_nat_of_infinito hBA
  let g : ℕ → X := fun n => (f n : X)
  have hg : Function.Injective g := fun n m h => f.injective (Subtype.ext h)
  refine ⟨Set.range g, ?_, ?_⟩
  · rintro x ⟨n, rfl⟩
    exact (f n).2
  · have hC : Numerable ↥(Set.range g) := ⟨Equiv.ofInjective g hg⟩
    -- `C ∪ A` es contable (Ej. 2) e infinito (contiene a `C`), luego numerable (Prop. 3.13/3.14)
    have hCA : Numerable ↥(Set.range g ∪ A) :=
      numerable_iff_contable_infinito.2
        ⟨union_contable _ _ (contable_of_numerable hC) hA, infinito_union_left hC⟩
    -- `C ∼ ℕ ∼ C ∪ A` (Proposición 3.2)
    exact coordinables_trans (coordinables_symm (hC : Coordinables ℕ _)) (hCA : Coordinables ℕ _)

/-- (Ej. 3 (b), el pegado) Si `A ⊆ B`, `C ⊆ B \ A` y `h : C → C ∪ A` es biyectiva, la función
`B \ A → B` que vale `h` en `C` y la identidad en `(B \ A) \ C` es biyectiva. Se formaliza
descomponiendo `B \ A = C ⊔ ((B \ A) \ C)` y `B = (C ∪ A) ⊔ ((B \ A) \ C)`. -/
theorem pegar {X : Type*} {A B C : Set X} (hAB : A ⊆ B) (hC : C ⊆ B \ A)
    (h : Coordinables C ↥(C ∪ A)) : Coordinables ↥(B \ A) ↥B := by
  classical
  obtain ⟨e⟩ := h
  have h1 : B \ A = C ∪ ((B \ A) \ C) := (Set.union_sdiff_cancel hC).symm
  have h2 : B = (C ∪ A) ∪ ((B \ A) \ C) := by
    ext x
    have := @hC x
    have := @hAB x
    simp only [Set.mem_union, Set.mem_sdiff] at *
    tauto
  have hd1 : Disjoint C ((B \ A) \ C) := Set.disjoint_sdiff_right
  have hd2 : Disjoint (C ∪ A) ((B \ A) \ C) := by
    rw [Set.disjoint_left]
    rintro x (hx | hx) ⟨⟨_, hxA⟩, hxC⟩
    · exact hxC hx
    · exact hxA hx
  exact ⟨(Set.equivOfEq h1).trans ((Equiv.Set.union hd1).trans
    ((Equiv.sumCongr e (Equiv.refl _)).trans ((Equiv.Set.union hd2).symm.trans
      (Set.equivOfEq h2.symm))))⟩

/-- (Ej. 3 (b)) `B \ A ∼ B`. -/
theorem diff_coordinables {X : Type*} {A B : Set X} (hAB : A ⊆ B) (hA : Contable A)
    (hBA : Infinito ↥(B \ A)) : Coordinables ↥(B \ A) ↥B := by
  obtain ⟨C, hC, h⟩ := exists_C_coordinables hA hBA
  exact pegar hAB hC h

/-! ## Ej. 4 -/

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
