/-
Práctica 1, Ejercicio 4 (hallar supremo, ínfimo, máximo y mínimo), con las nociones del curso
(`Comun`): `EsSup`, `EsInf`, `EsMax`, `EsMin` (Definiciones 2, 5, 3 y 6),
`CotaSup`, `CotaInf`, `AcotadoSup` (Definiciones 1 y 4).
Resolución "a mano" en `apuntes-typst/guias-agente/guia_1_resuelta_agente.typ` (Ejercicio 4).

Los cuatro conjuntos son `Set.Ioc a b` (el intervalo `(a, b]`, con `a < b`),
`B = {x | ∃ n : ℕ, 0 < n ∧ x = 1 / 2 ^ n}` (en el curso `ℕ` empieza en `1`, por eso el `0 < n`),
`B ∪ {0}` y `Set.range (fun x : ℝ => x ^ 2 - x - 1)`.
Las demostraciones siguen el texto: cuando el extremo existe se usa la Proposición 4 / 6
(`caract_sup_max` / `caract_inf_min`: cota que pertenece al conjunto) o directamente la
Definición 2 / 5; cuando no existe, se exhibe el elemento del conjunto que lo contradice
(punto medio, `1/2^(n+1)`, Principio de Arquímedes). Los sublemas `n ≤ 2^n` (por inducción,
`natCast_le_two_pow`) y `1/2^n ≤ 1/2` para `n ≥ 1` (`one_div_two_pow_le`) se importan de
`Comun.Reales`, junto con `arquimedes` y `arquimedes2`; de `Comun.Supremos`, las Definiciones y
las Proposiciones 4 y 6. Los conjuntos `B`, `C` y todos los ítems quedan locales.
No se usan `sSup`, `sInf`, `IsLUB`, `IsGLB` ni `Nat.lt_two_pow_self`.
-/
import Mathlib
import Comun.Reales
import Comun.Supremos

open Comun

namespace Guias.Guia1.Ej04

/-! ## (a) El intervalo `(a, b]`, con `a < b` -/

/-- **Ej. 4 (a), supremo y máximo.** `b` es cota superior de `(a, b]` y pertenece al conjunto
(porque `a < b`), así que es el máximo (Proposición 4), y en particular el supremo. -/
theorem ej4a_max {a b : ℝ} (hab : a < b) : EsMax (Set.Ioc a b) b :=
  caract_sup_max (fun _ hx => (Set.mem_Ioc.1 hx).2) (Set.mem_Ioc.2 ⟨hab, le_rfl⟩)

/-- **Ej. 4 (a), supremo.** `sup (a, b] = b`. -/
theorem ej4a_sup {a b : ℝ} (hab : a < b) : EsSup (Set.Ioc a b) b := (ej4a_max hab).1

/-- **Ej. 4 (a), ínfimo.** `ínf (a, b] = a`: `a` es cota inferior, y si `t` fuera una cota
inferior con `a < t`, entonces `t ≤ b` (porque `b ∈ (a, b]`) y el punto medio `(a + t) / 2`
estaría en `(a, b]` y sería menor que `t`. -/
theorem ej4a_inf {a b : ℝ} (hab : a < b) : EsInf (Set.Ioc a b) a := by
  refine ⟨fun _ hx => (Set.mem_Ioc.1 hx).1.le, fun t ht => ?_⟩
  by_contra hlt
  have hat : a < t := not_le.1 hlt
  have htb : t ≤ b := ht b (Set.mem_Ioc.2 ⟨hab, le_rfl⟩)
  have hmem : (a + t) / 2 ∈ Set.Ioc a b := Set.mem_Ioc.2 ⟨by linarith, by linarith⟩
  linarith [ht _ hmem]

/-- **Ej. 4 (a), mínimo.** `(a, b]` no tiene mínimo: si `m` fuera el mínimo, `m ∈ (a, b]` da
`a < m`, y el punto medio `(a + m) / 2 ∈ (a, b]` es menor que `m`, contra `m` cota inferior. -/
theorem ej4a_no_min {a b : ℝ} : ¬ ∃ m, EsMin (Set.Ioc a b) m := by
  rintro ⟨m, ⟨hinf, _⟩, hm⟩
  obtain ⟨ham, hmb⟩ := Set.mem_Ioc.1 hm
  have hmem : (a + m) / 2 ∈ Set.Ioc a b := Set.mem_Ioc.2 ⟨by linarith, by linarith⟩
  linarith [hinf _ hmem]

/-! ## (b) `B = {1 / 2^n : n ∈ ℕ, n ≥ 1}` -/

/-- El conjunto `B = {1/2^n : n ∈ ℕ}` del enunciado, con `ℕ = {1, 2, 3, …}`. -/
def B : Set ℝ := {x | ∃ n : ℕ, 0 < n ∧ x = 1 / 2 ^ n}

/-- **Ej. 4 (b), supremo y máximo.** `1/2 ∈ B` (es `n = 1`) y es cota superior
(`1/2^n ≤ 1/2` para `n ≥ 1`): es el máximo por la Proposición 4. -/
theorem ej4b_max : EsMax B (1 / 2) := by
  refine caract_sup_max ?_ ⟨1, by norm_num, by norm_num⟩
  rintro x ⟨n, hn, rfl⟩
  exact one_div_two_pow_le hn

/-- **Ej. 4 (b), supremo.** `sup B = 1/2`. -/
theorem ej4b_sup : EsSup B (1 / 2) := ej4b_max.1

/-- **Ej. 4 (b), ínfimo.** `ínf B = 0`: `0` es cota inferior; si `t > 0` fuera cota inferior, la
Proposición 1 (Arquímedes 2) da `n` con `0 < 1/n < t`, y como `n ≤ 2^n` (sublema
`natCast_le_two_pow`), `1/2^n ≤ 1/n < t` con `1/2^n ∈ B`, absurdo. -/
theorem ej4b_inf : EsInf B 0 := by
  refine ⟨?_, fun t ht => ?_⟩
  · rintro x ⟨n, _, rfl⟩
    positivity
  · by_contra hlt
    have ht0 : 0 < t := not_le.1 hlt
    obtain ⟨n, hn0, hnt⟩ := arquimedes2 ht0
    have hnpos : (0 : ℝ) < n := by
      by_contra h
      push Not at h
      have : (1 : ℝ) / n ≤ 0 := div_nonpos_of_nonneg_of_nonpos zero_le_one h
      linarith
    have hn1 : 0 < n := by exact_mod_cast hnpos
    have hle : (1 : ℝ) / 2 ^ n ≤ 1 / n := one_div_le_one_div_of_le hnpos (natCast_le_two_pow n)
    have hmem : (1 : ℝ) / 2 ^ n ∈ B := ⟨n, hn1, rfl⟩
    linarith [ht _ hmem]

/-- **Ej. 4 (b), mínimo.** `B` no tiene mínimo: si `m = 1/2^n ∈ B` fuera el mínimo, entonces
`1/2^(n+1) ∈ B` y `1/2^(n+1) < 1/2^n = m`, contra `m` cota inferior. -/
theorem ej4b_no_min : ¬ ∃ m, EsMin B m := by
  rintro ⟨m, ⟨hinf, _⟩, n, hn, rfl⟩
  have hmem : (1 : ℝ) / 2 ^ (n + 1) ∈ B := ⟨n + 1, Nat.succ_pos n, rfl⟩
  have hlt : (1 : ℝ) / 2 ^ (n + 1) < 1 / 2 ^ n := by
    apply one_div_lt_one_div_of_lt (by positivity)
    rw [pow_succ]
    have : (0 : ℝ) < 2 ^ n := by positivity
    linarith
  linarith [hinf _ hmem]

/-! ## (c) `B ∪ {0}` -/

/-- **Ej. 4 (c), supremo y máximo.** `1/2 ∈ B ∪ {0}` y sigue siendo cota superior
(`0 ≤ 1/2`): es el máximo (Proposición 4). -/
theorem ej4c_max : EsMax (B ∪ {0}) (1 / 2) := by
  refine caract_sup_max ?_ (Or.inl ej4b_max.2)
  rintro x (hx | hx)
  · exact ej4b_max.1.1 x hx
  · rw [Set.mem_singleton_iff.1 hx]; norm_num

/-- **Ej. 4 (c), supremo.** `sup (B ∪ {0}) = 1/2`. -/
theorem ej4c_sup : EsSup (B ∪ {0}) (1 / 2) := ej4c_max.1

/-- **Ej. 4 (c), ínfimo y mínimo.** `0 ∈ B ∪ {0}` y es cota inferior (`0 ≤ 0` y `0 < 1/2^n`):
es el mínimo (Proposición 6). -/
theorem ej4c_min : EsMin (B ∪ {0}) 0 := by
  refine caract_inf_min ?_ (Or.inr rfl)
  rintro x (hx | hx)
  · exact ej4b_inf.1 x hx
  · rw [Set.mem_singleton_iff.1 hx]

/-- **Ej. 4 (c), ínfimo.** `ínf (B ∪ {0}) = 0`. -/
theorem ej4c_inf : EsInf (B ∪ {0}) 0 := ej4c_min.1

/-! ## (d) `C = {x² - x - 1 : x ∈ ℝ}` -/

/-- El conjunto `C = {x² - x - 1 : x ∈ ℝ}`. -/
def C : Set ℝ := Set.range (fun x : ℝ => x ^ 2 - x - 1)

/-- **Ej. 4 (d), ínfimo y mínimo.** Completando cuadrados, `x² - x - 1 = (x - 1/2)² - 5/4 ≥ -5/4`,
con igualdad en `x = 1/2`: `-5/4` es cota inferior y pertenece a `C`, luego es el mínimo
(Proposición 6). -/
theorem ej4d_min : EsMin C (-5 / 4) := by
  refine caract_inf_min ?_ ⟨1 / 2, by norm_num⟩
  rintro y ⟨x, rfl⟩
  show -5 / 4 ≤ x ^ 2 - x - 1
  have h : x ^ 2 - x - 1 = (x - 1 / 2) ^ 2 - 5 / 4 := by ring
  rw [h]
  nlinarith [sq_nonneg (x - 1 / 2)]

/-- **Ej. 4 (d), ínfimo.** `ínf C = -5/4`. -/
theorem ej4d_inf : EsInf C (-5 / 4) := ej4d_min.1

/-- **Ej. 4 (d), no acotado superiormente.** Dado `c`, el Teorema 1 (Arquímedes) da `n ∈ ℕ` con
`|c| + 2 ≤ n`; entonces `n ≥ 2` y `n² - n - 1 = n (n - 1) - 1 ≥ n - 1 ≥ |c| + 1 > c`, con
`n² - n - 1 ∈ C`. -/
theorem ej4d_no_acotadoSup : ¬ AcotadoSup C := by
  rintro ⟨c, hc⟩
  obtain ⟨n, hn⟩ := arquimedes (|c| + 2)
  have hmem : ((n : ℝ) ^ 2 - n - 1) ∈ C := ⟨n, rfl⟩
  have hc' := hc _ hmem
  have habs := le_abs_self c
  nlinarith [abs_nonneg c]

/-- **Ej. 4 (d), supremo.** `C` no tiene supremo: un supremo es en particular una cota superior
(Definición 2), y `C` no tiene ninguna. -/
theorem ej4d_no_sup : ¬ ∃ s, EsSup C s := by
  rintro ⟨s, hs, _⟩
  exact ej4d_no_acotadoSup ⟨s, hs⟩

/-- **Ej. 4 (d), máximo.** `C` no tiene máximo (un máximo es un supremo, Definición 3). -/
theorem ej4d_no_max : ¬ ∃ m, EsMax C m := by
  rintro ⟨m, hm, _⟩
  exact ej4d_no_sup ⟨m, hm⟩

end Guias.Guia1.Ej04
