/-
Práctica 2, Ejercicio 9 (partes de intersecciones, uniones y conjuntos coordinables).
Resolución "a mano" en `apuntes-typst/guias-agente/_partes2/ej09.typ`.

(a) `𝒫(A) ∩ 𝒫(B) = 𝒫(A ∩ B)` y (b) `𝒫(A) ∪ 𝒫(B) ⊆ 𝒫(A ∪ B)` son cuentas con la definición
    `S ∈ 𝒫(A) ⟺ S ⊆ A` (`Set.mem_powerset_iff`), elemento a elemento (`Set.ext`).
(c) Si `f : A → B` es biyectiva, `S ↦ f(S)` es una biyección `𝒫(A) → 𝒫(B)` con inversa
    `T ↦ f⁻¹(T)`: las dos composiciones son la identidad por `f⁻¹(f(S)) = S` (`f` inyectiva) y
    `f(f⁻¹(T)) = T` (`f` sobreyectiva).

Convenciones: en (a) y (b) `A, B : Set X` son subconjuntos de un conjunto ambiente y `𝒫 A` es
`Set.powerset A : Set (Set X)`; en (c) `A` y `B` son conjuntos abstractos (tipos) y `𝒫(A)` es
`Set A`.
-/
import Mathlib
import Comun.Cardinales

namespace Guias.Guia2.Ej09

open Comun
variable {X : Type*}

/-! ## (a) y (b): igualdad e inclusión de conjuntos -/

/-- **Ej. 9 (a).** `𝒫(A) ∩ 𝒫(B) = 𝒫(A ∩ B)`: `S ⊆ A` y `S ⊆ B` si y sólo si `S ⊆ A ∩ B`. -/
theorem ej9a (A B : Set X) : 𝒫 A ∩ 𝒫 B = 𝒫 (A ∩ B) := by
  ext S
  simp only [Set.mem_inter_iff, Set.mem_powerset_iff]
  constructor
  · rintro ⟨hA, hB⟩ s hs
    exact ⟨hA hs, hB hs⟩
  · intro h
    exact ⟨fun s hs => (h hs).1, fun s hs => (h hs).2⟩

/-- **Ej. 9 (b).** `𝒫(A) ∪ 𝒫(B) ⊆ 𝒫(A ∪ B)`: si `S ⊆ A` o `S ⊆ B`, entonces `S ⊆ A ∪ B`. -/
theorem ej9b (A B : Set X) : 𝒫 A ∪ 𝒫 B ⊆ 𝒫 (A ∪ B) := by
  intro S hS
  rw [Set.mem_powerset_iff]
  rcases hS with h | h <;> rw [Set.mem_powerset_iff] at h
  · exact fun s hs => Or.inl (h hs)
  · exact fun s hs => Or.inr (h hs)

/-- La inclusión de (b) es estricta en general: con `A = {0}` y `B = {1}` en `ℕ`, el conjunto
`{0, 1}` está en `𝒫(A ∪ B)` pero no en `𝒫(A) ∪ 𝒫(B)`. -/
theorem ej9b_estricta :
    ¬ (𝒫 ({0} : Set ℕ) ∪ 𝒫 ({1} : Set ℕ) = 𝒫 (({0} : Set ℕ) ∪ {1})) := by
  intro h
  have hmem : ({0, 1} : Set ℕ) ∈ 𝒫 (({0} : Set ℕ) ∪ {1}) := by
    rw [Set.mem_powerset_iff]
    rintro s (rfl | rfl)
    · exact Or.inl rfl
    · exact Or.inr rfl
  rw [← h] at hmem
  rcases hmem with h0 | h1
  · rw [Set.mem_powerset_iff] at h0
    have : (1 : ℕ) ∈ ({0} : Set ℕ) := h0 (by simp)
    simp at this
  · rw [Set.mem_powerset_iff] at h1
    have : (0 : ℕ) ∈ ({1} : Set ℕ) := h1 (by simp)
    simp at this

/-! ## (c) Transportar la biyección a las partes -/

/-- Si `f : A → B` es biyectiva, `S ↦ f(S)` es una biyección `𝒫(A) → 𝒫(B)` con inversa
`T ↦ f⁻¹(T)`. -/
def partesCongr {A B : Type*} (f : A ≃ B) : Set A ≃ Set B where
  toFun S := f '' S
  invFun T := f ⁻¹' T
  left_inv S := Set.preimage_image_eq S f.injective
  right_inv T := Set.image_preimage_eq T f.surjective

/-- **Ej. 9 (c).** `A ∼ B ⟹ 𝒫(A) ∼ 𝒫(B)`. -/
theorem ej9c {A B : Type*} (h : Coordinables A B) : Coordinables (Set A) (Set B) :=
  let ⟨f⟩ := h; ⟨partesCongr f⟩

end Guias.Guia2.Ej09
