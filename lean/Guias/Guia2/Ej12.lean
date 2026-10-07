/-
Análisis Avanzado (FCEN-UBA) · Práctica 2 · Ejercicio 12
Enunciado en `apuntes-typst/guias/p2.typ`; resolución en
`apuntes-typst/guias-agente/guia_2_resuelta_agente.typ` (Ejercicio 12).

  (a) El conjunto de los números primos es numerable.
  (b) `ℕ` es unión numerable de conjuntos numerables disjuntos dos a dos.

Convención: acá `ℕ` empieza en `0`. Para (b) se usa `A_k = {n : n + 1 = 2^k (2m + 1) para algún m}`,
que es el `A_k = {2^k (2m+1)}` del texto corrido en una unidad.
-/
import Mathlib
import Comun.Cardinales

open Comun

namespace Guias.Guia2.Ej12

/-! ## (a) Los primos son numerables -/

/-- El conjunto de los números primos. -/
def Primos : Set ℕ := {p | Nat.Prime p}

/-- Hecho de base de aritmética: hay infinitos primos (`Nat.exists_infinite_primes`: para todo `N`
hay un primo `p ≥ N`). De ahí, `Primos` no es finito: un finito de naturales está acotado. -/
theorem infinito_primos : Infinito Primos := by
  rw [infinito_iff_infinite, Set.infinite_coe_iff]
  intro hfin
  obtain ⟨N, hN⟩ := hfin.bddAbove
  obtain ⟨p, hp, hprime⟩ := Nat.exists_infinite_primes (N + 1)
  have : p ≤ N := hN (show p ∈ Primos from hprime)
  omega

/-- **Ej. 12 (a).** El conjunto de los números primos es numerable: es un subconjunto de `ℕ`
(contable, Prop. 3.13) e infinito (Prop. 3.14). -/
theorem ej12a : Numerable Primos :=
  numerable_iff_contable_infinito.2
    ⟨contable_of_cardLe_numerable numerable_nat ⟨Function.Embedding.subtype _⟩, infinito_primos⟩

/-! ## (b) `ℕ = ⋃ₖ A_k`, con `A_k` numerables y disjuntos -/

/-- `A_k = {n : n + 1 = 2^k (2m + 1) para algún m}`: los `n` tales que `n + 1` tiene exactamente
`k` factores `2`. -/
def A (k : ℕ) : Set ℕ := {n | ∃ m, n + 1 = 2 ^ k * (2 * m + 1)}

/-- Unicidad de la escritura `2^k (2m+1)`: si `2^k (2m+1) = 2^l (2m'+1)` con `k < l` es absurdo
(cancelando `2^k` queda un impar igual a un par). -/
theorem no_lt {k l m m' : ℕ} (hkl : k < l) (h : 2 ^ k * (2 * m + 1) = 2 ^ l * (2 * m' + 1)) :
    False := by
  obtain ⟨d, rfl⟩ := Nat.exists_eq_add_of_lt hkl
  have h' : 2 ^ k * (2 * m + 1) = 2 ^ k * (2 * (2 ^ d * (2 * m' + 1))) := by
    rw [h]; ring
  have h'' := Nat.eq_of_mul_eq_mul_left (Nat.two_pow_pos k) h'
  omega

/-- Unicidad de la escritura `2^k (2m+1)`: el exponente y el impar quedan determinados. -/
theorem unicidad {k l m m' : ℕ} (h : 2 ^ k * (2 * m + 1) = 2 ^ l * (2 * m' + 1)) :
    k = l ∧ m = m' := by
  have hkl : k = l := by
    rcases lt_trichotomy k l with hlt | heq | hgt
    · exact (no_lt hlt h).elim
    · exact heq
    · exact (no_lt hgt h.symm).elim
  subst hkl
  refine ⟨rfl, ?_⟩
  have := Nat.eq_of_mul_eq_mul_left (Nat.two_pow_pos k) h
  omega

/-- Existencia de la escritura: todo `n ≥ 1` es `2^k (2m+1)` (inducción fuerte: si `n` es par,
`n = 2j` con `j < n`; si es impar, `k = 0`). (Deducción propia.) -/
theorem descomposicion (n : ℕ) (hn : 0 < n) : ∃ k m, n = 2 ^ k * (2 * m + 1) := by
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    rcases Nat.even_or_odd n with ⟨j, hj⟩ | ⟨j, hj⟩
    · obtain ⟨k, m, hk⟩ := ih j (by omega) (by omega)
      exact ⟨k + 1, m, by rw [hj, hk]; ring⟩
    · exact ⟨0, j, by rw [hj]; ring⟩

/-- `m ↦ 2^k (2m+1) - 1` es una biyección `ℕ → A_k`. -/
theorem numerable_A (k : ℕ) : Numerable (A k) := by
  have hpos : ∀ m : ℕ, 0 < 2 ^ k * (2 * m + 1) := fun m => by positivity
  refine ⟨Equiv.ofBijective (fun m => ⟨2 ^ k * (2 * m + 1) - 1, m, ?_⟩) ⟨?_, ?_⟩⟩
  · have := hpos m; omega
  · intro m m' h
    have h' : 2 ^ k * (2 * m + 1) - 1 = 2 ^ k * (2 * m' + 1) - 1 := congrArg Subtype.val h
    have h'' : 2 ^ k * (2 * m + 1) = 2 ^ k * (2 * m' + 1) := by
      have := hpos m; have := hpos m'; omega
    exact (unicidad h'').2
  · rintro ⟨n, m, hm⟩
    exact ⟨m, Subtype.ext (by simp only; omega)⟩

/-- Los `A_k` son disjuntos dos a dos. -/
theorem disjuntos_A {k l : ℕ} (hkl : k ≠ l) : Disjoint (A k) (A l) := by
  rw [Set.disjoint_left]
  rintro n ⟨m, hm⟩ ⟨m', hm'⟩
  exact hkl (unicidad (hm.symm.trans hm')).1

/-- Los `A_k` cubren `ℕ`. -/
theorem union_A : ⋃ k, A k = Set.univ := by
  apply Set.eq_univ_iff_forall.2
  intro n
  obtain ⟨k, m, hk⟩ := descomposicion (n + 1) (by omega)
  exact Set.mem_iUnion.2 ⟨k, m, hk⟩

/-- **Ej. 12 (b).** `ℕ` es unión numerable de conjuntos numerables disjuntos dos a dos. -/
theorem ej12b : ∃ A : ℕ → Set ℕ,
    (∀ k, Numerable (A k)) ∧ (∀ k l, k ≠ l → Disjoint (A k) (A l)) ∧ ⋃ k, A k = Set.univ :=
  ⟨A, numerable_A, fun _ _ h => disjuntos_A h, union_A⟩

end Guias.Guia2.Ej12
