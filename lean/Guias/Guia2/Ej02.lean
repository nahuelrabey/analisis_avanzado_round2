/-
Análisis Avanzado (FCEN-UBA) · Práctica 2 · Ejercicio 2
Enunciado en `apuntes-typst/guias/p2.typ`; resolución en
`apuntes-typst/guias-agente/guia_2_resuelta_agente.typ` (Ejercicio 2).

Si `A` y `B` son contables, `A ∪ B` es contable. El argumento es una cadena de inyecciones
  `A ∪ B ↪ A ⊕ B ↪ ℕ ⊕ ℕ ↪ ℕ`
(la primera manda `x` a su copia en `A` si `x ∈ A` y a su copia en `B` si no; la segunda es
"contable ⇒ `#A ≤ #ℕ`"; la tercera es pares/impares), y después la Proposición 3.13.
No se usa `Set.Countable.union` ni ninguna instancia `Countable`.
-/
import Mathlib
import Comun.Cardinales

namespace Guias.Guia2.Ej02

open Comun
/-! ## Sublemas -/

/-- Sublema 1: si `A` es contable entonces `#A ≤ #ℕ`. Finito: `A ∼ {0, …, n-1} ⊆ ℕ`;
numerable: la biyección `ℕ → A` al revés. -/
theorem cardLe_nat_of_contable {A : Type*} (h : Contable A) : CardLe A ℕ := by
  rcases h with ⟨n, ⟨e⟩⟩ | h
  · exact ⟨e.toEmbedding.trans Fin.valEmbedding⟩
  · obtain ⟨e⟩ := h
    exact ⟨e.symm.toEmbedding⟩

/-- Sublema 2: la inyección `ℕ ⊕ ℕ → ℕ` que manda la primera copia a los pares y la segunda a los
impares. -/
def sumNatEmb : ℕ ⊕ ℕ ↪ ℕ where
  toFun := Sum.elim (fun n => 2 * n) (fun n => 2 * n + 1)
  inj' := by
    rintro (n | n) (m | m) h <;>
      simp only [Sum.elim_inl, Sum.elim_inr, Sum.inl.injEq, Sum.inr.injEq, reduceCtorEq] at h ⊢ <;>
      omega

/-- Sublema 3: la inyección `A ∪ B → A ⊕ B`: `x ↦ (x, en A)` si `x ∈ A`, y `x ↦ (x, en B)` si no
(entonces `x ∈ B`). -/
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

/-! ## El ejercicio -/

/-- **Ej. 2.** Si `A` y `B` son contables, `A ∪ B` es contable. -/
theorem ej2 {X : Type*} (A B : Set X) (hA : Contable A) (hB : Contable B) :
    Contable ↥(A ∪ B) := by
  obtain ⟨fA⟩ := cardLe_nat_of_contable hA
  obtain ⟨fB⟩ := cardLe_nat_of_contable hB
  -- `A ∪ B ↪ A ⊕ B ↪ ℕ ⊕ ℕ ↪ ℕ`
  have h : CardLe ↥(A ∪ B) ℕ :=
    ⟨((unionEmb A B).trans (Function.Embedding.sumMap fA fB)).trans sumNatEmb⟩
  -- Proposición 3.13: `#(A ∪ B) ≤ ℵ₀` ⇒ `A ∪ B` contable
  exact contable_of_cardLe_numerable numerable_nat h

end Guias.Guia2.Ej02
