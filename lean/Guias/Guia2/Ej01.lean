/-
Análisis Avanzado (FCEN-UBA) · Práctica 2 · Ejercicio 1
Enunciado en `apuntes-typst/guias/p2.typ`; resolución en
`apuntes-typst/guias-agente/guia_2_resuelta_agente.typ` (Ejercicio 1).

Se halla el cardinal de
  (a) `ℤ_{≤ -3}`          numerable (biyección `n ↦ -3 - n`).
  (b) `5ℤ`                numerable (`ℕ ∼ ℤ ∼ 5ℤ`, biyecciones explícitas).
  (c) `ℤ × ℕ`             numerable (`ℕ × ℕ ∼ ℕ` por CSB con `(n, m) ↦ 2^n 3^m`, y `ℤ ∼ ℕ`).
  (d) `(-1, 1) ∩ ℚ`       numerable (`n ↦ 1/(n+2)` lo hace infinito, y está adentro de `ℚ`).

Los sublemas `ℤ ∼ ℕ` y `ℕ × ℕ ∼ ℕ` NO están en `apuntes.typ`: acá se prueban a mano
(`natEquivInt`, `natProdNat_numerable`), sin `Equiv.intEquivNat`, `Nat.pairEquiv` ni
`Denumerable`.
-/
import Mathlib
import Guias.Guia2.Defs

namespace Guias.Guia2.Ej01

open Guias.Guia2

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

/-! ## Sublema: `ℤ ∼ ℕ` (deducción propia, no está en `apuntes.typ`) -/

/-- `n ↦ n/2` si `n` es par, `n ↦ -(n/2) - 1` si es impar (pares a los `≥ 0`, impares a los `< 0`). -/
def natToInt (n : ℕ) : ℤ := if n % 2 = 0 then ((n / 2 : ℕ) : ℤ) else -((n / 2 : ℕ) : ℤ) - 1

/-- La inversa: `k ↦ 2k` para `k ≥ 0` y `-(k+1) ↦ 2k + 1`. -/
def intToNat : ℤ → ℕ
  | Int.ofNat k => 2 * k
  | Int.negSucc k => 2 * k + 1

/-- Sublema: `ℕ ∼ ℤ`, con la biyección explícita de arriba. -/
def natEquivInt : ℕ ≃ ℤ where
  toFun := natToInt
  invFun := intToNat
  left_inv n := by
    unfold natToInt
    split_ifs with h
    · show intToNat (Int.ofNat (n / 2)) = n
      simp only [intToNat]
      omega
    · have : -((n / 2 : ℕ) : ℤ) - 1 = Int.negSucc (n / 2) := by
        rw [Int.negSucc_eq]; ring
      rw [this]
      simp only [intToNat]
      omega
  right_inv z := by
    cases z with
    | ofNat k =>
      simp only [intToNat, natToInt]
      have h2 : (2 * k) % 2 = 0 := by omega
      have h3 : (2 * k) / 2 = k := by omega
      simp [h2, h3]
    | negSucc k =>
      simp only [intToNat, natToInt]
      have h2 : ¬ ((2 * k + 1) % 2 = 0) := by omega
      have h3 : (2 * k + 1) / 2 = k := by omega
      simp only [h2, ite_false, h3, Int.negSucc_eq]
      ring

theorem int_coordinables_nat : Coordinables ℤ ℕ := ⟨natEquivInt.symm⟩

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

/-- **Ej. 1 (b).** `#5ℤ = ℵ₀`: `ℕ ∼ ℤ ∼ 5ℤ` (Proposición 3.2, transitividad). -/
theorem ej1b : Numerable cincoZ := ⟨natEquivInt.trans intEquivCincoZ⟩

/-! ## Sublema: `ℕ × ℕ ∼ ℕ` (deducción propia, no está en `apuntes.typ`) -/

/-- Si `2^a 3^b = 2^c 3^d` entonces `a = c` (y por lo tanto `b = d`): inducción en `a` mirando la
paridad. -/
theorem pow_two_three_inj : ∀ (a c b d : ℕ), 2 ^ a * 3 ^ b = 2 ^ c * 3 ^ d → a = c ∧ b = d := by
  intro a
  induction a with
  | zero =>
    intro c b d h
    cases c with
    | zero =>
      simp only [pow_zero, one_mul] at h
      exact ⟨rfl, Nat.pow_right_injective (by norm_num : 2 ≤ 3) h⟩
    | succ c =>
      exfalso
      -- `3^b` es impar y `2^(c+1) 3^d` es par
      have hodd : (3 ^ b) % 2 = 1 := Nat.odd_iff.mp (Odd.pow (by decide))
      have heven : (2 ^ (c + 1) * 3 ^ d) % 2 = 0 := by
        apply Nat.even_iff.mp
        exact (Nat.even_pow.mpr ⟨even_two, Nat.succ_ne_zero c⟩).mul_right _
      simp only [pow_zero, one_mul] at h
      omega
  | succ a ih =>
    intro c b d h
    cases c with
    | zero =>
      exfalso
      have hodd : (3 ^ d) % 2 = 1 := Nat.odd_iff.mp (Odd.pow (by decide))
      have heven : (2 ^ (a + 1) * 3 ^ b) % 2 = 0 := by
        apply Nat.even_iff.mp
        exact (Nat.even_pow.mpr ⟨even_two, Nat.succ_ne_zero a⟩).mul_right _
      simp only [pow_zero, one_mul] at h
      omega
    | succ c =>
      -- se cancela un factor `2`
      have h' : 2 ^ a * 3 ^ b = 2 ^ c * 3 ^ d := by
        have : 2 * (2 ^ a * 3 ^ b) = 2 * (2 ^ c * 3 ^ d) := by
          rw [pow_succ, pow_succ] at h; linarith
        omega
      obtain ⟨h1, h2⟩ := ih c b d h'
      exact ⟨by rw [h1], h2⟩

/-- La inyección `ℕ × ℕ → ℕ`, `(n, m) ↦ 2^n 3^m`. -/
def pairEmb : ℕ × ℕ ↪ ℕ where
  toFun p := 2 ^ p.1 * 3 ^ p.2
  inj' := by
    rintro ⟨a, b⟩ ⟨c, d⟩ h
    obtain ⟨h1, h2⟩ := pow_two_three_inj a c b d h
    simp [h1, h2]

/-- La inyección `ℕ → ℕ × ℕ`, `n ↦ (n, 0)`. -/
def diagEmb : ℕ ↪ ℕ × ℕ where
  toFun n := (n, 0)
  inj' := fun _ _ h => (Prod.mk.inj h).1

/-- Sublema: `ℕ × ℕ ∼ ℕ`, por Cantor–Schröder–Bernstein (Teorema 3.11). -/
theorem natProdNat_numerable : Numerable (ℕ × ℕ) :=
  teorema_CSB ⟨diagEmb⟩ ⟨pairEmb⟩

/-! ## (c) `ℤ × ℕ` -/

/-- **Ej. 1 (c).** `#(ℤ × ℕ) = ℵ₀`: `ℕ ∼ ℕ × ℕ ∼ ℤ × ℕ`, la segunda vía `ℕ ∼ ℤ` en la primera
coordenada. -/
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
    exact cardLe_trans hIQ (cardLe_of_coordinables (coordinables_symm numerable_rat))
  exact teorema_CSB h1 h2

end Guias.Guia2.Ej01
