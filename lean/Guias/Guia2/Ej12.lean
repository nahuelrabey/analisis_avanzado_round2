/-
Análisis Avanzado (FCEN-UBA) · Práctica 2 · Ejercicio 12
Enunciado en `apuntes-typst/guias/p2.typ`; resolución en
`apuntes-typst/guias-agente/guia_2_resuelta_agente.typ` (Ejercicio 12).

  (a) El conjunto de los números primos es numerable.
  (b) `ℕ` es unión numerable de conjuntos numerables disjuntos dos a dos.

Convención: acá `ℕ` empieza en `0`. Para (b) se usa `A_k = {n : n + 1 = 2^k (2m + 1) para algún m}`,
que es el `A_k = {2^k (2m+1)}` del texto corrido en una unidad.
La unicidad y la existencia de la escritura `2^k (2m+1)` se importan de
`Comun.Cardinales.Numerables` (`par_injective`, `descomposicion`); quedan locales `Primos`, `A` y
los lemas sobre ellos.
-/
import Mathlib
import Comun.Cardinales
import Comun.Cardinales.Numerables

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
theorem ej12a : Numerable Primos := numerable_of_infinito_subset_nat Primos infinito_primos

/-! ## (b) `ℕ = ⋃ₖ A_k`, con `A_k` numerables y disjuntos -/

/-- `A_k = {n : n + 1 = 2^k (2m + 1) para algún m}`: los `n` tales que `n + 1` tiene exactamente
`k` factores `2`. -/
def A (k : ℕ) : Set ℕ := {n | ∃ m, n + 1 = 2 ^ k * (2 * m + 1)}

/-- `m ↦ 2^k (2m+1) - 1` es una biyección `ℕ → A_k` (inyectiva por `Comun.par_injective`). -/
theorem numerable_A (k : ℕ) : Numerable (A k) := by
  have hpos : ∀ m : ℕ, 0 < 2 ^ k * (2 * m + 1) := fun m => by positivity
  refine ⟨Equiv.ofBijective (fun m => ⟨2 ^ k * (2 * m + 1) - 1, m, ?_⟩) ⟨?_, ?_⟩⟩
  · have := hpos m; omega
  · intro m m' h
    have h' : 2 ^ k * (2 * m + 1) - 1 = 2 ^ k * (2 * m' + 1) - 1 := congrArg Subtype.val h
    have h'' : 2 ^ k * (2 * m + 1) = 2 ^ k * (2 * m' + 1) := by
      have := hpos m; have := hpos m'; omega
    exact (par_injective (show par k m = par k m' from h'')).2
  · rintro ⟨n, m, hm⟩
    exact ⟨m, Subtype.ext (by simp only; omega)⟩

/-- Los `A_k` son disjuntos dos a dos. -/
theorem disjuntos_A {k l : ℕ} (hkl : k ≠ l) : Disjoint (A k) (A l) := by
  rw [Set.disjoint_left]
  rintro n ⟨m, hm⟩ ⟨m', hm'⟩
  exact hkl (par_injective (show par k m = par l m' from hm.symm.trans hm')).1

/-- Los `A_k` cubren `ℕ` (`Comun.descomposicion`). -/
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
