/-
Práctica 1, Ejercicio 2 (densidad): (a) un entero entre `x` e `y` si `y - x > 1`, (b) un racional
entre dos reales, (c) un irracional entre dos racionales, (d) un irracional entre dos reales.
Resolución "a mano" en `apuntes-typst/guias-agente/guia_1_resuelta_agente.typ` (Ejercicio 2).

Los cuatro ítems están encadenados como en el texto: (a) construye el entero desde el Teorema 1
(`arquimedes`) y el buen orden de `ℕ` (`Nat.find`, sin `Int.floor` ni `Int.ceil`); (b) usa la
Proposición 1 (`arquimedes2`) y (a), sin `densidad_Q` ni `exists_rat_btwn`; (c) usa que `√2 ∉ ℚ`
(por paridad) y que racional + racional no nulo · irracional es irracional; (d) aplica (b) dos
veces y (c). `Irrational z` es sólo la definición `z ∉ Set.range ((↑) : ℚ → ℝ)`.
De `Comun.Reales` se importan `arquimedes`, `arquimedes2` y los tres sublemas de (c)
(`sqrt_two_irrational`, `irrational_rat_add`, `irrational_rat_mul`, deducción propia, probados
allí sin `irrational_sqrt_two` ni `Irrational.rat_add/mul`); los cuatro ítems quedan locales.
-/
import Mathlib
import Comun.Reales

open Comun

namespace Guias.Guia1.Ej02

/-! ## (a) Un entero entre `x` e `y` cuando `y - x > 1` -/

/-- **Ej. 2 (a).** Si `y - x > 1` hay `m ∈ ℤ` con `x < m < y`.
Se toma `m = mín {k ∈ ℤ : x < k}`: el conjunto es no vacío (Arquímedes para `x`) y acotado
inferiormente por `-N`, donde `-x ≤ N` (Arquímedes para `-x`). El buen orden de `ℤ` se implementa
con `Nat.find` sobre `k ↦ x < k - N` (`k ∈ ℕ`), de modo que `m = k₀ - N`. Por minimalidad
`m - 1 ≤ x`, luego `x < m ≤ x + 1 < y`. -/
theorem ej2a {x y : ℝ} (h : 1 < y - x) : ∃ m : ℤ, x < m ∧ m < y := by
  -- Arquímedes para `-x`: todo `k` con `x < k` cumple `k > -N`.
  obtain ⟨N, hN⟩ := arquimedes (-x)
  -- Arquímedes para `x + N`: el conjunto `{k ∈ ℕ : x < k - N}` es no vacío.
  have hex : ∃ k : ℕ, x < (k : ℝ) - N := by
    obtain ⟨n, hn⟩ := arquimedes (x + N)
    exact ⟨n + 1, by push_cast; linarith⟩
  classical
  -- buen orden: el menor `k₀` con `x < k₀ - N`
  obtain ⟨k₀, hk₀, hmin⟩ : ∃ k₀ : ℕ, x < (k₀ : ℝ) - N ∧ ∀ k < k₀, ¬ x < (k : ℝ) - N :=
    ⟨Nat.find hex, Nat.find_spec hex, fun _ hk => Nat.find_min hex hk⟩
  refine ⟨(k₀ : ℤ) - N, by push_cast; exact hk₀, ?_⟩
  push_cast
  -- `m - 1 ≤ x`: si `k₀ = 0`, `m - 1 = -N - 1 ≤ x`; si `k₀ = k + 1`, `k` no está en el conjunto.
  cases k₀ with
  | zero => push_cast; linarith
  | succ k =>
    have hk : (k : ℝ) - N ≤ x := not_lt.1 (hmin k (Nat.lt_succ_self k))
    push_cast
    linarith

/-! ## (b) Un racional entre dos reales -/

/-- **Ej. 2 (b).** Si `x < y` hay `q ∈ ℚ` con `x < q < y` (Proposición 2, probada acá).
Por la Proposición 1 hay `n` con `0 < 1/n < y - x`; multiplicando por `n > 0`,
`n·y - n·x > 1`, y (a) da `m ∈ ℤ` con `n·x < m < n·y`. Entonces `q = m/n`. -/
theorem ej2b {x y : ℝ} (h : x < y) : ∃ q : ℚ, x < q ∧ q < y := by
  obtain ⟨n, hn0, hn⟩ := arquimedes2 (sub_pos.2 h)
  have hnpos : (0 : ℝ) < n := one_div_pos.1 hn0
  have h1 : 1 < n * y - n * x := by
    have := (div_lt_iff₀ hnpos).1 hn
    linarith
  obtain ⟨m, hm1, hm2⟩ := ej2a h1
  refine ⟨(m : ℚ) / n, ?_, ?_⟩
  · push_cast
    rw [lt_div_iff₀ hnpos]
    linarith
  · push_cast
    rw [div_lt_iff₀ hnpos]
    linarith

/-! ## (c) Un irracional entre dos racionales -/

/-- **Ej. 2 (c).** Si `x < y` son racionales hay un irracional `z` con `x < z < y`:
`z = x + ((y - x)/2) · √2`. Es irracional por los sublemas `sqrt_two_irrational`,
`irrational_rat_mul` e `irrational_rat_add` de `Comun.Reales`, y está entre `x` e `y` porque
`0 < √2/2 < 1` (pues `0 < √2 < 2`). -/
theorem ej2c {x y : ℚ} (h : x < y) : ∃ z : ℝ, Irrational z ∧ (x : ℝ) < z ∧ z < y := by
  have hs0 : 0 < Real.sqrt 2 := Real.sqrt_pos.2 (by norm_num)
  have hs2 : Real.sqrt 2 < 2 := by
    nlinarith [Real.sq_sqrt (show (0 : ℝ) ≤ 2 by norm_num), Real.sqrt_nonneg 2]
  have hq : (y - x) / 2 ≠ 0 := div_ne_zero (sub_pos.2 h).ne' two_ne_zero
  have hyx : (0 : ℝ) < y - x := by exact_mod_cast sub_pos.2 h
  refine ⟨x + ((y - x) / 2 : ℚ) * Real.sqrt 2,
    irrational_rat_add (irrational_rat_mul sqrt_two_irrational hq) x, ?_, ?_⟩
  · push_cast
    nlinarith
  · push_cast
    nlinarith

/-! ## (d) Un irracional entre dos reales -/

/-- **Ej. 2 (d).** Si `x < y` son reales hay un irracional `z` con `x < z < y`: por (b) hay
racionales `x < q₁ < q₂ < y`, y por (c) un irracional `z` con `q₁ < z < q₂`. -/
theorem ej2d {x y : ℝ} (h : x < y) : ∃ z : ℝ, Irrational z ∧ x < z ∧ z < y := by
  obtain ⟨q₁, hq₁, hq₁'⟩ := ej2b h
  obtain ⟨q₂, hq₂, hq₂'⟩ := ej2b hq₁'
  have h12 : q₁ < q₂ := by exact_mod_cast hq₂
  obtain ⟨z, hz, hz1, hz2⟩ := ej2c h12
  exact ⟨z, hz, hq₁.trans hz1, hz2.trans hq₂'⟩

end Guias.Guia1.Ej02
