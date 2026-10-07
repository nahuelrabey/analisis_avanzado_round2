/-
Librería común `Comun`: definiciones del curso y resultados de `apuntes.typ` compartidos por las
guías (`Guias/`), los parciales (`Parciales/`) y los ejemplos (`Ejemplos/`). Ver
`apuntes-agente/lean-lemas-compartidos-y-organizacion.md` para el diseño.

`Comun.Reales`: hechos sobre `ℝ` que no son de ningún ejercicio en particular. Los Principios de
Arquímedes (Teorema 1 y Proposición 1 de `apuntes.typ`), la densidad de `ℚ` (Proposición 2) y
lemas genéricos que las prácticas y los parciales usaban como sublemas locales: la forma
"`∃ n₀, ∀ n ≥ n₀, M < n`" de Arquímedes, `n ≤ 2^n`, monotonía de `1/(n+1)`, la irracionalidad
de `√2` y de `q + t`, `q · t` con `t` irracional, y "`|x - y| < 1/2^n` para todo `n` ⇒ `x = y`".
La Proposición 2 es el Ej. 2 (b) de la Práctica 1: no se usa en `Guias/Guia1/Ej02`. Los
sublemas de irracionalidad son los del Ej. 2 (c) (deducción propia, no son el ejercicio) y se
prueban sin `irrational_sqrt_two`, `Irrational.rat_add` ni `Irrational.rat_mul`.
-/
import Mathlib

namespace Comun

/-! ## Principios de Arquímedes y densidad de `ℚ` -/

/-- **Teorema 1 (Principio de Arquímedes).** Para todo `x ∈ ℝ` hay `n ∈ ℕ` con `x ≤ n`. -/
theorem arquimedes (x : ℝ) : ∃ n : ℕ, x ≤ n := exists_nat_ge x

/-- **Proposición 1 (Principio de Arquímedes 2).** Si `y > 0` hay `n ∈ ℕ` con `0 < 1/n < y`
(`0 < 1/n` fuerza `n ≥ 1`). -/
theorem arquimedes2 {y : ℝ} (hy : 0 < y) : ∃ n : ℕ, 0 < (1 : ℝ) / n ∧ (1 : ℝ) / n < y := by
  obtain ⟨n, hn⟩ := exists_nat_one_div_lt hy
  refine ⟨n + 1, by positivity, ?_⟩
  simpa using hn

/-- **Proposición 2 (Densidad de `ℚ`).** Entre dos reales distintos hay un racional.
(Es el Ej. 2 (b): no usar en `Ej02.lean`.) -/
theorem densidad_Q {x y : ℝ} (h : x < y) : ∃ q : ℚ, x < q ∧ q < y := exists_rat_btwn h

/-- Arquímedes en la forma "desde algún `n₀` en adelante, `n > M`": se aplica el Teorema 1 a
`M + 1`. -/
theorem exists_n0_forall_lt (M : ℝ) : ∃ n₀ : ℕ, ∀ n ≥ n₀, M < n := by
  obtain ⟨n₀, hn₀⟩ := arquimedes (M + 1)
  refine ⟨n₀, fun n hn => ?_⟩
  have : (n₀ : ℝ) ≤ n := by exact_mod_cast hn
  linarith

/-! ## Desigualdades elementales -/

/-- `n ≤ 2^n` para todo `n ∈ ℕ`, por inducción. Caso `0`: `0 ≤ 1`. Paso:
`n + 1 ≤ 2^n + 1 ≤ 2^n + 2^n = 2^(n+1)` porque `1 ≤ 2^n`. -/
theorem le_two_pow (n : ℕ) : n ≤ 2 ^ n := by
  induction n with
  | zero => norm_num
  | succ k ih =>
    have h1 : 1 ≤ 2 ^ k := Nat.one_le_two_pow
    rw [pow_succ]
    omega

/-- `n ≤ 2^n`, visto en `ℝ` (corolario de `le_two_pow`). -/
theorem natCast_le_two_pow (n : ℕ) : (n : ℝ) ≤ 2 ^ n := by exact_mod_cast le_two_pow n

/-- Para `n ≥ 1`, `1 / 2 ^ n ≤ 1 / 2` (porque `2 ≤ 2 ^ n`). -/
theorem one_div_two_pow_le {n : ℕ} (hn : 0 < n) : (1 : ℝ) / 2 ^ n ≤ 1 / 2 := by
  have h2 : (2 : ℝ) ≤ 2 ^ n := by
    calc (2 : ℝ) = 2 ^ 1 := by norm_num
      _ ≤ 2 ^ n := pow_le_pow_right₀ (by norm_num) hn
  exact one_div_le_one_div_of_le (by norm_num) h2

/-- `1/(n+1)` es decreciente: si `N ≤ n` entonces `1/(n+1) ≤ 1/(N+1)`. -/
theorem one_div_succ_antitone {N n : ℕ} (h : N ≤ n) :
    (1 : ℝ) / ((n : ℝ) + 1) ≤ 1 / ((N : ℝ) + 1) :=
  one_div_le_one_div_of_le (by positivity) (by exact_mod_cast Nat.add_le_add_right h 1)

/-- Si `|x - y| < 1 / 2^n` para todo `n`, entonces `x = y`. Se usa que `n < 2^n` y que hay `n`
con `1 / (n + 1) < ε` para todo `ε > 0`. -/
theorem eq_of_forall_abs_sub_lt {x y : ℝ} (h : ∀ n : ℕ, |x - y| < 1 / 2 ^ n) : x = y := by
  by_contra hne
  have hpos : 0 < |x - y| := abs_pos.2 (sub_ne_zero.2 hne)
  obtain ⟨n, hn⟩ := exists_nat_one_div_lt hpos
  have h1 : (1 : ℝ) / 2 ^ n ≤ 1 / ((n : ℝ) + 1) := by
    apply one_div_le_one_div_of_le (by positivity)
    have := Nat.succ_le_of_lt (@Nat.lt_two_pow_self n)
    exact_mod_cast this
  linarith [h n]

/-! ## Irracionales -/

/-- **`√2 ∉ ℚ`** (sublema del Ej. 2 (c) de la Práctica 1, deducción propia). Si `√2 = r ∈ ℚ`,
con `r = a/b` reducida, entonces `a² = 2 b²`, así que `a²` es par, luego `a` es par, `a = 2k`;
entonces `b² = 2 k²` y `b` es par: `2` divide a `a` y a `b`, contra `mcd(a, b) = 1`. -/
theorem sqrt_two_irrational : Irrational (Real.sqrt 2) := by
  rintro ⟨r, hr⟩
  have h2 : (r : ℝ) ^ 2 = 2 := by rw [hr]; exact Real.sq_sqrt (by norm_num)
  have h2q : r ^ 2 = 2 := by exact_mod_cast h2
  -- `a² = 2 b²` con `a = r.num`, `b = r.den`
  have hden : (r.den : ℚ) ≠ 0 := by exact_mod_cast r.den_nz
  have hnd : (r.num : ℚ) ^ 2 = 2 * (r.den : ℚ) ^ 2 := by
    have hr' : r = r.num / r.den := (Rat.num_div_den r).symm
    rw [hr'] at h2q
    field_simp at h2q
    linarith
  have hZ : r.num ^ 2 = 2 * (r.den : ℤ) ^ 2 := by exact_mod_cast hnd
  -- `a` es par (si `a` fuera impar, `a²` sería impar)
  have hnum : Even r.num := by
    have : Even (r.num ^ 2) := ⟨(r.den : ℤ) ^ 2, by rw [hZ]; ring⟩
    exact (Int.even_pow.1 this).1
  obtain ⟨k, hk⟩ := hnum
  -- `b² = 2 k²`, así que `b` es par
  have hden2 : Even (r.den : ℤ) := by
    have hsq : (r.den : ℤ) ^ 2 = k ^ 2 + k ^ 2 := by
      have e : 2 * (r.den : ℤ) ^ 2 = 2 * (k ^ 2 + k ^ 2) := by
        rw [hk] at hZ
        linear_combination -hZ
      linarith
    exact (Int.even_pow.1 ⟨k ^ 2, hsq⟩).1
  -- contradicción con `mcd(a, b) = 1`
  have h2num : (2 : ℤ) ∣ r.num := even_iff_two_dvd.1 ⟨k, hk⟩
  have h2den : (2 : ℤ) ∣ (r.den : ℤ) := even_iff_two_dvd.1 hden2
  have hgcd : Int.gcd r.num (r.den : ℤ) = 1 := by
    show Nat.gcd r.num.natAbs (r.den : ℤ).natAbs = 1
    rw [Int.natAbs_natCast]
    exact r.reduced
  have := Int.dvd_gcd (c := 2) h2num h2den
  rw [hgcd] at this
  omega

/-- Racional más irracional es irracional. Si `q + t = s ∈ ℚ`, entonces `t = s - q ∈ ℚ`. -/
theorem irrational_rat_add {t : ℝ} (ht : Irrational t) (q : ℚ) : Irrational (q + t) := by
  rintro ⟨s, hs⟩
  exact ht ⟨s - q, by push_cast; linarith⟩

/-- Racional no nulo por irracional es irracional. Si `q · t = s ∈ ℚ` con `q ≠ 0`, entonces
`t = s / q ∈ ℚ`. -/
theorem irrational_rat_mul {t : ℝ} (ht : Irrational t) {q : ℚ} (hq : q ≠ 0) :
    Irrational (q * t) := by
  rintro ⟨s, hs⟩
  have hq' : (q : ℝ) ≠ 0 := by exact_mod_cast hq
  refine ht ⟨s / q, ?_⟩
  push_cast
  rw [hs]
  exact mul_div_cancel_left₀ t hq'

end Comun
