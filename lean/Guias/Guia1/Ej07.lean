/-
Análisis Avanzado (FCEN-UBA) · Práctica 1 · Ejercicio 7
Enunciado en `apuntes-typst/guias/p1.typ`; resolución en
`apuntes-typst/guias-agente/guia_1_resuelta_agente.typ` (Ejercicio 7).

Tres límites "por definición" (Definición 7, `Converge`): se fija `ε > 0`, se calcula
`|a_n - ℓ|` exactamente, se lo acota por algo de la forma `c / n` y el `n₀` sale del Principio de
Arquímedes (Teorema 1, `arquimedes`) o de su segunda forma (Proposición 1, `arquimedes2`).
  (a) `|a_n + 2| = 5 / (n + 1)`;
  (b) `|sen n / n| ≤ 1 / n` por `|sen n| ≤ 1` (hecho de base: `Real.abs_sin_le_one`);
  (c) `|a_n - 1| = 7 / (2^n + 4) ≤ 7 / n` por el sublema `n ≤ 2^n` (inducción local).
No se usa `Tendsto` ni ningún lema de límites de Mathlib. Los índices empiezan en `0`: en (a) y
(c) la cuenta vale igual para `n = 0`; en (b) `sen 0 / 0 = 0` en Lean, pero de todos modos
`0 < 1/n₀` fuerza `n₀ ≥ 1`, así que los `n ≥ n₀` que se miran son los del curso.
-/
import Mathlib
import Guias.Guia1.Defs

namespace Guias.Guia1.Ej07

open Guias.Guia1

/-! ## (a) `(3 - 2n)/(n + 1) → -2` -/

/-- **Ej. 7 (a).** `|a_n - (-2)| = 5/(n + 1)`. Dado `ε > 0`, el Teorema 1 da `n₀ ≥ 5/ε`; si
`n ≥ n₀` entonces `n + 1 > 5/ε`, es decir `5/(n + 1) < ε`. -/
theorem ej7a : Converge (fun n : ℕ => (3 - 2 * (n : ℝ)) / (n + 1)) (-2) := by
  intro ε hε
  obtain ⟨n₀, hn₀⟩ := arquimedes (5 / ε)
  refine ⟨n₀, fun n hn => ?_⟩
  have hn' : (n₀ : ℝ) ≤ n := by exact_mod_cast hn
  have hpos : (0 : ℝ) < n + 1 := by positivity
  -- la cuenta exacta: a_n - (-2) = 5/(n + 1)
  have hdiff : (3 - 2 * (n : ℝ)) / (n + 1) - (-2) = 5 / (n + 1) := by
    field_simp
    ring
  rw [hdiff, abs_of_pos (by positivity), div_lt_iff₀ hpos]
  -- 5/ε ≤ n₀ ≤ n < n + 1, luego 5 < ε (n + 1)
  have h1 : 5 / ε < n + 1 := by linarith
  have h2 := (div_lt_iff₀ hε).1 h1
  linarith

/-! ## (b) `sen n / n → 0` -/

/-- **Ej. 7 (b).** `|sen n / n - 0| = |sen n| / n ≤ 1/n` (hecho de base `|sen x| ≤ 1`). Dado
`ε > 0`, la Proposición 1 da `n₀` con `0 < 1/n₀ < ε`; para `n ≥ n₀`, `1/n ≤ 1/n₀ < ε`. -/
theorem ej7b : Converge (fun n : ℕ => Real.sin n / n) 0 := by
  intro ε hε
  obtain ⟨n₀, hn₀pos, hn₀⟩ := arquimedes2 hε
  refine ⟨n₀, fun n hn => ?_⟩
  -- `0 < 1/n₀` fuerza `n₀ ≥ 1` (en Lean `1/0 = 0`), así que `n ≥ n₀ ≥ 1`
  have hn₀r : (0 : ℝ) < n₀ := one_div_pos.1 hn₀pos
  have hnr : (0 : ℝ) < n := lt_of_lt_of_le hn₀r (by exact_mod_cast hn)
  rw [sub_zero, abs_div, abs_of_pos hnr]
  calc |Real.sin n| / n ≤ 1 / n := by
        apply div_le_div_of_nonneg_right (Real.abs_sin_le_one _) hnr.le
    _ ≤ 1 / n₀ := one_div_le_one_div_of_le hn₀r (by exact_mod_cast hn)
    _ < ε := hn₀

/-! ## (c) `(2^n - 3)/(2^n + 4) → 1` -/

/-- Sublema (deducción propia, por inducción): `n ≤ 2^n`. Caso `0`: `0 ≤ 1`. Paso:
`n + 1 ≤ 2^n + 1 ≤ 2^n + 2^n = 2^(n+1)` porque `1 ≤ 2^n`. -/
theorem le_two_pow (n : ℕ) : n ≤ 2 ^ n := by
  induction n with
  | zero => norm_num
  | succ k ih =>
    have h1 : 1 ≤ 2 ^ k := Nat.one_le_two_pow
    rw [pow_succ]
    omega

/-- **Ej. 7 (c).** `|a_n - 1| = 7/(2^n + 4) < 7/2^n ≤ 7/n` (sublema `n ≤ 2^n`). Dado `ε > 0`,
la Proposición 1 aplicada a `ε/7` da `n₀` con `0 < 1/n₀ < ε/7`; para `n ≥ n₀`,
`7/n ≤ 7/n₀ < ε`. -/
theorem ej7c : Converge (fun n : ℕ => ((2 : ℝ) ^ n - 3) / (2 ^ n + 4)) 1 := by
  intro ε hε
  obtain ⟨n₀, hn₀pos, hn₀⟩ := arquimedes2 (by positivity : (0 : ℝ) < ε / 7)
  refine ⟨n₀, fun n hn => ?_⟩
  have hn₀r : (0 : ℝ) < n₀ := one_div_pos.1 hn₀pos
  have hnr : (0 : ℝ) < n := lt_of_lt_of_le hn₀r (by exact_mod_cast hn)
  have h2n : (n : ℝ) ≤ 2 ^ n := by exact_mod_cast le_two_pow n
  have hpow : (0 : ℝ) < 2 ^ n := by positivity
  -- la cuenta exacta: a_n - 1 = -7/(2^n + 4)
  have hdiff : ((2 : ℝ) ^ n - 3) / (2 ^ n + 4) - 1 = -(7 / (2 ^ n + 4)) := by
    field_simp
    ring
  rw [hdiff, abs_neg, abs_of_pos (by positivity)]
  calc (7 : ℝ) / (2 ^ n + 4) ≤ 7 / 2 ^ n := by
        apply div_le_div_of_nonneg_left (by norm_num) hpow
        linarith
    _ ≤ 7 / n := div_le_div_of_nonneg_left (by norm_num) hnr h2n
    _ = 7 * (1 / n) := by ring
    _ ≤ 7 * (1 / n₀) := by
        apply mul_le_mul_of_nonneg_left _ (by norm_num)
        exact one_div_le_one_div_of_le hn₀r (by exact_mod_cast hn)
    _ < 7 * (ε / 7) := by linarith
    _ = ε := by ring

end Guias.Guia1.Ej07
