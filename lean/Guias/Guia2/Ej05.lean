/-
Análisis Avanzado (FCEN-UBA) · Práctica 2 · Ejercicio 5
Enunciado en `apuntes-typst/guias/p2.typ`; resolución en
`apuntes-typst/guias-agente/guia_2_resuelta_agente.typ` (Ejercicio 5).

Dada una sucesión de conjuntos `A : ℕ → Set X` y `A = ⋃ n, A n`:
  (a) la sucesión `B n = A n ∖ ⋃ k < n, A k` ("disjuntización") es de conjuntos disjuntos dos a
      dos, con `B n ⊆ A n` y `⋃ n ≤ m, B n = ⋃ n ≤ m, A n` para todo `m`;
  (b) para TODA sucesión `B` con esas dos propiedades (sin usar la disjunción),
      `⋃ n, A n = ⋃ n, B n`.

En el apunte `ℕ` arranca en `1`; acá arranca en `0`, lo que no cambia nada (el rol de `B_1 = A_1`
lo cumple `B 0 = A 0`).
-/
import Mathlib
import Comun.Cardinales

open Comun

namespace Guias.Guia2.Ej05

variable {X : Type*}

/-- La disjuntización: `B n = A n ∖ (A 0 ∪ ⋯ ∪ A (n-1))`. -/
def B (A : ℕ → Set X) (n : ℕ) : Set X := A n \ ⋃ k < n, A k

/-! ## (a) La sucesión `B` cumple las tres propiedades -/

/-- `B n ⊆ A n`: se le quitaron puntos a `A n`. -/
theorem B_subset (A : ℕ → Set X) (n : ℕ) : B A n ⊆ A n := Set.sdiff_subset

/-- Si `k < n` entonces `B n` no toca a `A k`: por definición se le quitó `A k`. -/
theorem B_disjoint_A (A : ℕ → Set X) {k n : ℕ} (hkn : k < n) : Disjoint (B A n) (A k) := by
  rw [Set.disjoint_left]
  rintro x ⟨_, hx⟩ hxk
  exact hx (Set.mem_iUnion₂.2 ⟨k, hkn, hxk⟩)

/-- Los `B n` son disjuntos dos a dos: si `k < n`, `B k ⊆ A k` y `B n ∩ A k = ∅`. -/
theorem B_pairwise_disjoint (A : ℕ → Set X) :
    Pairwise fun m n => Disjoint (B A m) (B A n) := by
  intro m n hmn
  rcases lt_or_gt_of_ne hmn with h | h
  · exact ((B_disjoint_A A h).mono_right (B_subset A m)).symm
  · exact (B_disjoint_A A h).mono_right (B_subset A n)

/-- El menor índice `k` con `x ∈ A k` cumple `x ∈ B k` (buen orden de `ℕ`). -/
theorem mem_B_find (A : ℕ → Set X) {x : X} [DecidablePred fun n => x ∈ A n]
    (hx : ∃ n, x ∈ A n) : x ∈ B A (Nat.find hx) := by
  refine ⟨Nat.find_spec hx, ?_⟩
  intro hmem
  obtain ⟨k, hk, hxk⟩ := Set.mem_iUnion₂.1 hmem
  exact absurd (Nat.find_min' hx hxk) (not_le.2 hk)

/-- `⋃ n ≤ m, B n = ⋃ n ≤ m, A n` para todo `m`: `⊆` por `B n ⊆ A n`; `⊇` porque si `x ∈ A n` con
`n ≤ m`, el menor índice `k` con `x ∈ A k` cumple `k ≤ n ≤ m` y `x ∈ B k`. -/
theorem B_union_le (A : ℕ → Set X) (m : ℕ) : ⋃ n ≤ m, B A n = ⋃ n ≤ m, A n := by
  classical
  apply Set.Subset.antisymm
  · intro x hx
    obtain ⟨n, hn, hxn⟩ := Set.mem_iUnion₂.1 hx
    exact Set.mem_iUnion₂.2 ⟨n, hn, B_subset A n hxn⟩
  · intro x hx
    obtain ⟨n, hn, hxn⟩ := Set.mem_iUnion₂.1 hx
    have hex : ∃ k, x ∈ A k := ⟨n, hxn⟩
    exact Set.mem_iUnion₂.2 ⟨Nat.find hex, (Nat.find_min' hex hxn).trans hn, mem_B_find A hex⟩

/-- **Ej. 5 (a).** La sucesión `B n = A n ∖ ⋃ k < n, A k` es de conjuntos disjuntos dos a dos,
con `B n ⊆ A n` y `⋃ n ≤ m, B n = ⋃ n ≤ m, A n` para todo `m`. -/
theorem ej5a (A : ℕ → Set X) :
    (Pairwise fun m n => Disjoint (B A m) (B A n)) ∧
    (∀ n, B A n ⊆ A n) ∧
    (∀ m, ⋃ n ≤ m, B A n = ⋃ n ≤ m, A n) :=
  ⟨B_pairwise_disjoint A, B_subset A, B_union_le A⟩

/-! ## (b) Toda sucesión con las dos propiedades tiene la misma unión que `A` -/

/-- **Ej. 5 (b).** Si `B n ⊆ A n` para todo `n` y `⋃ n ≤ m, B n = ⋃ n ≤ m, A n` para todo `m`,
entonces `⋃ n, A n = ⋃ n, B n`. (No se usa que los `B n` sean disjuntos.) -/
theorem ej5b (A B : ℕ → Set X) (hsub : ∀ n, B n ⊆ A n)
    (hfin : ∀ m, ⋃ n ≤ m, B n = ⋃ n ≤ m, A n) : ⋃ n, A n = ⋃ n, B n := by
  apply Set.Subset.antisymm
  · intro x hx
    obtain ⟨n, hxn⟩ := Set.mem_iUnion.1 hx
    -- `x ∈ A n ⊆ ⋃ k ≤ n, A k = ⋃ k ≤ n, B k`, luego `x ∈ B k` para algún `k ≤ n`.
    have h1 : x ∈ ⋃ k ≤ n, A k := Set.mem_iUnion₂.2 ⟨n, le_rfl, hxn⟩
    rw [← hfin n] at h1
    obtain ⟨k, _, hxk⟩ := Set.mem_iUnion₂.1 h1
    exact Set.mem_iUnion.2 ⟨k, hxk⟩
  · intro x hx
    obtain ⟨n, hxn⟩ := Set.mem_iUnion.1 hx
    exact Set.mem_iUnion.2 ⟨n, hsub n hxn⟩

/-- La disjuntización de (a) tiene la misma unión que `A` (es (b) aplicado a (a)). -/
theorem iUnion_B (A : ℕ → Set X) : ⋃ n, A n = ⋃ n, B A n :=
  ej5b A (B A) (B_subset A) (B_union_le A)

end Guias.Guia2.Ej05
