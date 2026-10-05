/-
Análisis Avanzado (FCEN-UBA) · Práctica 2 · Ejercicio 3
Enunciado en `apuntes-typst/guias/p2.typ`; resolución en
`apuntes-typst/guias-agente/guia_2_resuelta_agente.typ` (Ejercicio 3).

Sean `A ⊆ B` con `A` contable y `B \ A` infinito.
  (a) Existe `C ⊆ B \ A` con `C ∼ C ∪ A`: `C` es el subconjunto numerable de `B \ A` que da la
      Proposición 3.14; `C ∪ A` es contable (Ej. 2) e infinito, luego numerable, luego `∼ C`.
  (b) `B \ A ∼ B`: se pega la biyección `C → C ∪ A` con la identidad en `(B \ A) \ C`.

El Ej. 2 se reprueba localmente (`union_contable`): los archivos de la práctica son independientes.
-/
import Mathlib
import Guias.Guia2.Defs

namespace Guias.Guia2.Ej03

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

/-! ## Ej. 3 -/

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

/-- **Ej. 3 (a).** Si `A` es contable y `B \ A` es infinito, existe `C ⊆ B \ A` con `C ∼ C ∪ A`.
(La hipótesis `A ⊆ B` del enunciado no se usa en este ítem.) -/
theorem ej3a {X : Type*} {A B : Set X} (hA : Contable A) (hBA : Infinito ↥(B \ A)) :
    ∃ C : Set X, C ⊆ B \ A ∧ Coordinables C ↥(C ∪ A) :=
  exists_C_coordinables hA hBA

/-- **Ej. 3 (b).** Si `A ⊆ B`, `A` es contable y `B \ A` es infinito, entonces `B \ A ∼ B`. -/
theorem ej3b {X : Type*} {A B : Set X} (hAB : A ⊆ B) (hA : Contable A)
    (hBA : Infinito ↥(B \ A)) : Coordinables ↥(B \ A) ↥B :=
  diff_coordinables hAB hA hBA

end Guias.Guia2.Ej03
