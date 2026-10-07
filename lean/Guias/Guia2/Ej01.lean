/-
Análisis Avanzado (FCEN-UBA) · Práctica 2 · Ejercicio 1
Enunciado en `apuntes-typst/guias/p2.typ`; resolución en
`apuntes-typst/guias-agente/guia_2_resuelta_agente.typ` (Ejercicio 1).

Se halla el cardinal de
  (a) `ℤ_{≤ -3}`          numerable (biyección `n ↦ -3 - n`).
  (b) `5ℤ`                numerable (`ℕ ∼ ℤ ∼ 5ℤ`, biyecciones explícitas).
  (c) `ℤ × ℕ`             numerable (`ℕ × ℕ ∼ ℕ` por CSB con `(n, m) ↦ 2^n 3^m`, y `ℤ ∼ ℕ`).
  (d) `(-1, 1) ∩ ℚ`       numerable (`n ↦ 1/(n+2)` lo hace infinito, y está adentro de `ℚ`).

Importa de `Comun.Cardinales.Numerables` los sublemas `ℤ ∼ ℕ` (`natEquivInt`) y `ℕ × ℕ ∼ ℕ`
(`natProdNat_numerable`, vía `pairEmb : (n, m) ↦ 2^n 3^m`), que NO están en `apuntes.typ` y se
prueban a mano ahí, sin `Equiv.intEquivNat`, `Nat.pairEquiv` ni `Denumerable`. Quedan locales los
conjuntos del enunciado y sus biyecciones.
-/
import Mathlib
import Comun.Cardinales
import Comun.Cardinales.Numerables

namespace Guias.Guia2.Ej01

open Comun
/-! ## (a) `ℤ_{≤ -3}` -/

/-- El conjunto `ℤ_{≤ -3} = {z ∈ ℤ : z ≤ -3}`. -/
def Zle3 : Set ℤ := {z : ℤ | z ≤ -3}

/-- La biyección `ℕ → ℤ_{≤ -3}`, `n ↦ -3 - n` (en el texto, con `ℕ` desde `1`, es `n ↦ -2 - n`). -/
def natEquivZle3 : ℕ ≃ Zle3 where
  toFun n := ⟨-3 - n, by simp only [Zle3, Set.mem_ofPred_eq]; omega⟩
  invFun z := (-3 - z.1).toNat
  left_inv n := by simp
  right_inv z := by
    obtain ⟨z, hz⟩ := z
    simp only [Zle3, Set.mem_ofPred_eq] at hz
    ext
    simp only
    omega

/-- **Ej. 1 (a).** `#ℤ_{≤ -3} = ℵ₀`. -/
theorem ej1a : Numerable Zle3 := ⟨natEquivZle3⟩

/-! ## (b) `5ℤ` -/

/-- El conjunto `5ℤ = {5k : k ∈ ℤ}`, escrito como los múltiplos de `5`. -/
def cincoZ : Set ℤ := {z : ℤ | 5 ∣ z}

/-- La biyección `ℤ → 5ℤ`, `k ↦ 5k`. -/
def intEquivCincoZ : ℤ ≃ cincoZ where
  toFun k := ⟨5 * k, by simp [cincoZ]⟩
  invFun z := z.1 / 5
  left_inv k := by simp
  right_inv z := by
    obtain ⟨z, hz⟩ := z
    simp only [cincoZ, Set.mem_ofPred_eq] at hz
    obtain ⟨k, rfl⟩ := hz
    ext
    simp

/-- **Ej. 1 (b).** `#5ℤ = ℵ₀`: `ℕ ∼ ℤ ∼ 5ℤ` (Proposición 3.2, transitividad; `ℕ ∼ ℤ` es
`Comun.natEquivInt`). -/
theorem ej1b : Numerable cincoZ := ⟨natEquivInt.trans intEquivCincoZ⟩

/-! ## (c) `ℤ × ℕ` -/

/-- **Ej. 1 (c).** `#(ℤ × ℕ) = ℵ₀`: `ℕ ∼ ℕ × ℕ ∼ ℤ × ℕ`, la primera es `Comun.natProdNat_numerable`
(CSB con `(n, m) ↦ 2^n 3^m`) y la segunda vía `ℕ ∼ ℤ` en la primera coordenada. -/
theorem ej1c : Numerable (ℤ × ℕ) := by
  obtain ⟨e⟩ := natProdNat_numerable
  exact ⟨e.trans (Equiv.prodCongr natEquivInt (Equiv.refl ℕ))⟩

/-! ## (d) `(-1, 1) ∩ ℚ` -/

/-- El conjunto `(-1, 1) ∩ ℚ`, visto como subconjunto de `ℚ`. -/
def I : Set ℚ := Set.Ioo (-1) 1

/-- La inyección `ℕ → (-1, 1) ∩ ℚ`, `n ↦ 1/(n + 2)`: muestra que el conjunto es infinito. -/
def natEmbI : ℕ ↪ I where
  toFun n := ⟨1 / ((n : ℚ) + 2), by
    simp only [I, Set.mem_Ioo]
    constructor
    · have : (0 : ℚ) < 1 / ((n : ℚ) + 2) := by positivity
      linarith
    · rw [div_lt_one (by positivity)]
      have : (0 : ℚ) ≤ n := Nat.cast_nonneg n
      linarith⟩
  inj' := by
    intro n m h
    simp only [Subtype.mk.injEq, one_div, inv_inj, add_left_inj, Nat.cast_inj] at h
    exact h

/-- **Ej. 1 (d).** `#((-1, 1) ∩ ℚ) = ℵ₀`: `ℵ₀ ≤ #I` por `natEmbI` y `#I ≤ #ℚ = ℵ₀` por ser
subconjunto (Proposición "Numerabilidad de ℚ"); se concluye con CSB (Teorema 3.11). -/
theorem ej1d : Numerable I := by
  have h1 : CardLe ℕ I := ⟨natEmbI⟩
  have h2 : CardLe I ℕ := by
    have hIQ : CardLe I ℚ := ⟨Function.Embedding.subtype _⟩
    exact cardLe_trans hIQ cardLe_rat_nat
  exact teorema_CSB h1 h2

end Guias.Guia2.Ej01
