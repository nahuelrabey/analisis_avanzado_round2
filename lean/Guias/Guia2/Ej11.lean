/-
Práctica 2, Ejercicio 11 (las partes finitas de un numerable son numerables).
Resolución "a mano" en `apuntes-typst/guias-agente/_partes2/ej11.typ`.

Si `e : ℕ → A` es biyectiva, `𝒫_f(A) = {B ⊆ A : B finito}` es numerable:
* es contable porque `B ↦ Σ_{a ∈ B} 2^(e⁻¹(a))` es una inyección `𝒫_f(A) → ℕ` (unicidad del
  desarrollo binario: un conjunto finito de naturales `S` queda determinado por `Σ_{k ∈ S} 2^k`,
  pues el `k`-ésimo dígito binario de esa suma es `1` exactamente cuando `k ∈ S`), y luego se
  aplica la Proposición 3.13;
* es infinito porque `n ↦ {e(n)}` es una inyección `ℕ → 𝒫_f(A)`.

Convenciones: `𝒫_f(A)` es el subtipo `{B : Set A // B.Finite}`; `ℕ` empieza en `0`.
-/
import Mathlib
import Guias.Guia2.Defs

namespace Guias.Guia2.Ej11

open Guias.Guia2

/-! ## Unicidad del desarrollo binario de un natural -/

/-- El código binario de un conjunto finito de naturales: `Σ_{k ∈ S} 2^k`. -/
def codigo (S : Finset ℕ) : ℕ := ∑ k ∈ S, 2 ^ k

/-- `Σ_{i < k} 2^i = 2^k - 1 < 2^k` (inducción en `k`). -/
theorem sum_range_two_pow_lt (k : ℕ) : ∑ i ∈ Finset.range k, 2 ^ i < 2 ^ k := by
  induction k with
  | zero => simp
  | succ k ih =>
    rw [Finset.sum_range_succ, pow_succ]
    omega

/-- Si todos los elementos de `S` son `< k`, entonces `codigo S < 2^k`. -/
theorem codigo_lt {S : Finset ℕ} {k : ℕ} (h : ∀ x ∈ S, x < k) : codigo S < 2 ^ k := by
  unfold codigo
  calc ∑ i ∈ S, 2 ^ i ≤ ∑ i ∈ Finset.range k, 2 ^ i :=
        Finset.sum_le_sum_of_subset (fun x hx => Finset.mem_range.2 (h x hx))
    _ < 2 ^ k := sum_range_two_pow_lt k

/-- El `i`-ésimo dígito binario de `codigo S` es `1` si y sólo si `i ∈ S`. Inducción en `S`
agregando cada vez el elemento máximo `k`: `codigo (S ∪ {k}) = 2^k · 1 + codigo S` con
`codigo S < 2^k`, así que los dígitos por debajo de `k` son los de `codigo S` y el dígito `k`
es `1`. -/
theorem testBit_codigo (S : Finset ℕ) (i : ℕ) : (codigo S).testBit i = decide (i ∈ S) := by
  induction S using Finset.induction_on_max with
  | empty => simp [codigo]
  | insert k S hS ih =>
    have hk : k ∉ S := fun h => lt_irrefl k (hS k h)
    have hlt := codigo_lt hS
    have hins : codigo (insert k S) = 2 ^ k * 1 + codigo S := by
      rw [codigo, Finset.sum_insert hk, mul_one]
      rfl
    rw [hins, Nat.testBit_two_pow_mul_add 1 hlt i, ih]
    split_ifs with hik
    · rw [decide_eq_decide, Finset.mem_insert]
      constructor
      · exact Or.inr
      · rintro (h | h)
        · omega
        · exact h
    · rw [show (1 : ℕ) = 2 ^ 0 from rfl, Nat.testBit_two_pow, decide_eq_decide, Finset.mem_insert]
      constructor
      · intro h0
        left
        omega
      · rintro (h | h)
        · omega
        · exact absurd (hS i h) (by omega)

/-- Unicidad del desarrollo binario: `codigo` es inyectiva. -/
theorem codigo_injective : Function.Injective codigo := by
  intro S T h
  ext i
  have := congrArg (fun m => Nat.testBit m i) h
  simp only [testBit_codigo, decide_eq_decide] at this
  exact this

/-! ## Las partes finitas de un numerable -/

variable {A : Type*}

/-- `B ↦ Σ_{a ∈ B} 2^(e⁻¹(a))`: la inyección `𝒫_f(A) → ℕ`. -/
noncomputable def codificar (e : ℕ ≃ A) (B : {B : Set A // B.Finite}) : ℕ :=
  codigo (B.2.toFinset.map e.symm.toEmbedding)

theorem codificar_injective (e : ℕ ≃ A) : Function.Injective (codificar e) := by
  intro B C h
  have h1 := codigo_injective h
  have h2 := Finset.map_injective e.symm.toEmbedding h1
  exact Subtype.ext (Set.Finite.toFinset_inj.1 h2)

/-- `𝒫_f(A)` es contable: `#𝒫_f(A) ≤ #ℕ` y Proposición 3.13. -/
theorem ej11_contable (h : Numerable A) : Contable {B : Set A // B.Finite} :=
  let ⟨e⟩ := h
  contable_of_cardLe_numerable numerable_nat ⟨⟨codificar e, codificar_injective e⟩⟩

/-- `n ↦ {e(n)}`: la inyección `ℕ → 𝒫_f(A)`. -/
def unitario (e : ℕ ≃ A) (n : ℕ) : {B : Set A // B.Finite} := ⟨{e n}, Set.finite_singleton _⟩

theorem unitario_injective (e : ℕ ≃ A) : Function.Injective (unitario e) := by
  intro n m h
  have := congrArg Subtype.val h
  simp only [unitario, Set.singleton_eq_singleton_iff] at this
  exact e.injective this

/-- `𝒫_f(A)` es infinito: contiene una copia de `ℕ` (`ℵ₀ ≤ #𝒫_f(A)`). -/
theorem ej11_infinito (h : Numerable A) : Infinito {B : Set A // B.Finite} := by
  obtain ⟨e⟩ := h
  rw [infinito_iff_infinite]
  exact Infinite.of_injective (unitario e) (unitario_injective e)

/-- **Ej. 11.** Si `A` es numerable, `𝒫_f(A) = {B ⊆ A : B finito}` es numerable
(contable e infinito, Definición 3.6). -/
theorem ej11 (h : Numerable A) : Numerable {B : Set A // B.Finite} :=
  numerable_iff_contable_infinito.2 ⟨ej11_contable h, ej11_infinito h⟩

end Guias.Guia2.Ej11
