/-
Práctica 2, Ejercicio 10 (`[0,1) ∼ {0,1}^ℕ` y `#𝒫(ℕ) = c`).
Resolución "a mano" en `apuntes-typst/guias-agente/_partes2/ej10.typ`.

(a) Cantor–Schröder–Bernstein (`teorema_CSB`) con dos inyecciones:
  * `[0,1) → {0,1}^ℕ`, `x ↦ (d_n(x))_n` con `d_n(x) = ⌊2^(n+1) x⌋ mod 2` (los dígitos binarios,
    definidos por una fórmula: no hace falta elegir un desarrollo). Si todos los dígitos de `x` e
    `y` coinciden, por inducción `⌊2^n x⌋ = ⌊2^n y⌋` para todo `n` (recurrencia
    `⌊2^(n+1) x⌋ = 2 ⌊2^n x⌋ + d_n(x)`), luego `|x - y| < 1/2^n` para todo `n`, y `x = y` por
    Arquímedes.
  * `{0,1}^ℕ → [0,1)`, `a ↦ Σ_n a_n / 3^(n+1)`: converge por comparación con la geométrica y vale
    `≤ 1/2 < 1`; es inyectiva porque en el primer índice `k` donde `a` y `b` difieren el término
    `1/3^(k+1)` supera a toda la cola `Σ_{n>k} 1/3^(n+1) = (1/2) · 1/3^(k+1)`.
(b) `𝒫(ℕ) ∼ {0,1}^ℕ ∼ [0,1) ∼ ℝ` (Ej. 8 (a), (a), Observación 3.21).

Convenciones: `{0,1}` es `Bool`, `{0,1}^ℕ` es `ℕ → Bool`, `𝒫(ℕ)` es `Set ℕ`, los índices
empiezan en `0`.
-/
import Mathlib
import Guias.Guia2.Defs

namespace Guias.Guia2.Ej10

open Guias.Guia2

/-! ## Inyección `[0,1) → {0,1}^ℕ`: los dígitos binarios -/

/-- El dígito binario `d_n(x) = ⌊2^(n+1) x⌋ mod 2`, como booleano (`true` si vale `1`). -/
noncomputable def digito (x : ℝ) (n : ℕ) : Bool := decide (⌊2 ^ (n + 1) * x⌋₊ % 2 = 1)

/-- Recurrencia de las partes enteras: `⌊2^(n+1) x⌋ = 2 ⌊2^n x⌋ + (⌊2^(n+1) x⌋ mod 2)`.
Sale de `⌊t / 2⌋ = ⌊t⌋ / 2` (división entera) y de `2 (m / 2) + m mod 2 = m`. -/
theorem floor_succ (x : ℝ) (n : ℕ) :
    ⌊2 ^ (n + 1) * x⌋₊ = 2 * ⌊2 ^ n * x⌋₊ + ⌊2 ^ (n + 1) * x⌋₊ % 2 := by
  have h : ⌊2 ^ n * x⌋₊ = ⌊2 ^ (n + 1) * x⌋₊ / 2 := by
    have := Nat.floor_div_ofNat (2 ^ (n + 1) * x) 2
    rw [← this]
    congr 1
    ring
  rw [h, Nat.div_add_mod]

/-- Si los dígitos `n`-ésimos coinciden, los restos módulo `2` coinciden. -/
theorem mod_eq_of_digito_eq {x y : ℝ} {n : ℕ} (h : digito x n = digito y n) :
    ⌊2 ^ (n + 1) * x⌋₊ % 2 = ⌊2 ^ (n + 1) * y⌋₊ % 2 := by
  unfold digito at h
  rcases Nat.mod_two_eq_zero_or_one ⌊2 ^ (n + 1) * x⌋₊ with hx | hx <;>
    rcases Nat.mod_two_eq_zero_or_one ⌊2 ^ (n + 1) * y⌋₊ with hy | hy <;>
    rw [hx, hy] at h ⊢ <;> simp at h

/-- Sublema B (inducción): si `x, y ∈ [0,1)` tienen los mismos dígitos, entonces
`⌊2^n x⌋ = ⌊2^n y⌋` para todo `n`. -/
theorem floor_eq_of_digitos_eq {x y : ℝ} (hx : x ∈ Set.Ico (0 : ℝ) 1) (hy : y ∈ Set.Ico (0 : ℝ) 1)
    (h : ∀ n, digito x n = digito y n) (n : ℕ) : ⌊2 ^ n * x⌋₊ = ⌊2 ^ n * y⌋₊ := by
  induction n with
  | zero =>
    simp only [pow_zero, one_mul]
    rw [Nat.floor_eq_zero.2 hx.2, Nat.floor_eq_zero.2 hy.2]
  | succ n ih =>
    rw [floor_succ x n, floor_succ y n, ih, mod_eq_of_digito_eq (h n)]

/-- Si `⌊2^n x⌋ = ⌊2^n y⌋` (con `x, y ≥ 0`) entonces `|x - y| < 1 / 2^n`. -/
theorem abs_sub_lt_of_floor_eq {x y : ℝ} (hx : 0 ≤ x) (hy : 0 ≤ y) {n : ℕ}
    (h : ⌊2 ^ n * x⌋₊ = ⌊2 ^ n * y⌋₊) : |x - y| < 1 / 2 ^ n := by
  have h2 : (0 : ℝ) < 2 ^ n := by positivity
  have hxf := Nat.floor_le (show (0 : ℝ) ≤ 2 ^ n * x by positivity)
  have hxl := Nat.lt_floor_add_one (2 ^ n * x)
  have hyf := Nat.floor_le (show (0 : ℝ) ≤ 2 ^ n * y by positivity)
  have hyl := Nat.lt_floor_add_one (2 ^ n * y)
  rw [h] at hxf hxl
  rw [abs_sub_lt_iff, lt_div_iff₀ h2, lt_div_iff₀ h2]
  constructor <;> nlinarith

/-- Arquímedes: si `|x - y| < 1 / 2^n` para todo `n`, entonces `x = y`. Se usa que `n < 2^n` y
que hay `n` con `1 / (n + 1) < ε` para todo `ε > 0`. -/
theorem eq_of_forall_abs_sub_lt {x y : ℝ} (h : ∀ n : ℕ, |x - y| < 1 / 2 ^ n) : x = y := by
  by_contra hne
  have hpos : 0 < |x - y| := abs_pos.2 (sub_ne_zero.2 hne)
  obtain ⟨n, hn⟩ := exists_nat_one_div_lt hpos
  have h1 : (1 : ℝ) / 2 ^ n ≤ 1 / ((n : ℝ) + 1) := by
    apply one_div_le_one_div_of_le (by positivity)
    have := Nat.succ_le_of_lt (@Nat.lt_two_pow_self n)
    exact_mod_cast this
  linarith [h n]

/-- La inyección `[0,1) → {0,1}^ℕ`: `x ↦ (d_n(x))_n`. -/
noncomputable def codigo (x : Set.Ico (0 : ℝ) 1) : ℕ → Bool := digito x.1

theorem codigo_injective : Function.Injective codigo := by
  intro x y h
  apply Subtype.ext
  apply eq_of_forall_abs_sub_lt
  intro n
  exact abs_sub_lt_of_floor_eq x.2.1 y.2.1
    (floor_eq_of_digitos_eq x.2 y.2 (fun n => congrFun h n) n)

/-! ## Inyección `{0,1}^ℕ → [0,1)`: la serie `Σ a_n / 3^(n+1)` -/

/-- El término `n`-ésimo: `a_n / 3^(n+1)`. -/
noncomputable def termino (a : ℕ → Bool) (n : ℕ) : ℝ := if a n then (1 / 3) ^ (n + 1) else 0

theorem termino_nonneg (a : ℕ → Bool) (n : ℕ) : 0 ≤ termino a n := by
  unfold termino
  split_ifs
  · positivity
  · exact le_rfl

theorem termino_le (a : ℕ → Bool) (n : ℕ) : termino a n ≤ (1 / 3) ^ (n + 1) := by
  unfold termino
  split_ifs
  · exact le_rfl
  · positivity

/-- La geométrica desplazada: `Σ_n (1/3)^(n+k) = (1/3)^k · 3/2` (`hasSum_geometric_of_lt_one`). -/
theorem hasSum_geom_shift (k : ℕ) :
    HasSum (fun n : ℕ => (1 / 3 : ℝ) ^ (n + k)) ((1 / 3) ^ k * (3 / 2)) := by
  have h := (hasSum_geometric_of_lt_one (r := (1 / 3 : ℝ)) (by norm_num) (by norm_num)).mul_left
    ((1 / 3) ^ k)
  have e1 : (fun n : ℕ => (1 / 3 : ℝ) ^ k * (1 / 3) ^ n) = fun n => (1 / 3) ^ (n + k) := by
    funext n
    rw [pow_add, mul_comm]
  have e2 : (1 - (1 / 3 : ℝ))⁻¹ = 3 / 2 := by norm_num
  rw [e1, e2] at h
  exact h

/-- Convergencia por comparación con la geométrica. -/
theorem summable_termino (a : ℕ → Bool) : Summable (termino a) :=
  Summable.of_nonneg_of_le (termino_nonneg a) (termino_le a) (hasSum_geom_shift 1).summable

/-- La suma `Σ_n a_n / 3^(n+1)`. -/
noncomputable def suma (a : ℕ → Bool) : ℝ := ∑' n, termino a n

theorem hasSum_suma (a : ℕ → Bool) : HasSum (termino a) (suma a) := (summable_termino a).hasSum

/-- `0 ≤ Σ a_n / 3^(n+1) ≤ Σ 1 / 3^(n+1) = 1/2 < 1`. -/
theorem suma_mem (a : ℕ → Bool) : suma a ∈ Set.Ico (0 : ℝ) 1 := by
  refine ⟨hasSum_le (fun n => termino_nonneg a n) hasSum_zero (hasSum_suma a), ?_⟩
  have := hasSum_le (termino_le a) (hasSum_suma a) (hasSum_geom_shift 1)
  norm_num at this
  linarith

/-- Inyectividad de la suma: si `a ≠ b`, en el primer índice `k` con `a_k ≠ b_k` el término
`1/3^(k+1)` domina a la cola `Σ_{n>k} 1/3^(n+1) = (1/2) · 1/3^(k+1)`. -/
theorem suma_injective : Function.Injective suma := by
  intro a b hab
  by_contra hne
  have hex : ∃ n, a n ≠ b n := by
    by_contra h
    push Not at h
    exact hne (funext h)
  -- el primer índice donde difieren
  set k := Nat.find hex with hk_def
  have hk : a k ≠ b k := Nat.find_spec hex
  have hlt : ∀ m < k, a m = b m := by
    intro m hm
    have := Nat.find_min hex hm
    push Not at this
    exact this
  -- la serie de las diferencias suma 0
  set h : ℕ → ℝ := fun n => termino a n - termino b n with hh
  have hsum : HasSum h 0 := by
    have := (hasSum_suma a).sub (hasSum_suma b)
    rwa [hab, sub_self] at this
  -- la cola a partir de `k+1` suma `-(Σ_{i ≤ k} h i) = -h k`
  have htail : HasSum (fun n => h (n + (k + 1))) (-(∑ i ∈ Finset.range (k + 1), h i)) := by
    rw [hasSum_nat_add_iff (k + 1), neg_add_cancel]
    exact hsum
  have hfin : ∑ i ∈ Finset.range (k + 1), h i = h k := by
    rw [Finset.sum_range_succ, Finset.sum_eq_zero, zero_add]
    intro i hi
    rw [Finset.mem_range] at hi
    simp only [hh, termino, hlt i hi, sub_self]
  rw [hfin] at htail
  -- `|h k| = 1/3^(k+1)`
  have hk' : |h k| = (1 / 3 : ℝ) ^ (k + 1) := by
    simp only [hh, termino]
    rcases Bool.eq_false_or_eq_true (a k) with ha | ha <;>
      rcases Bool.eq_false_or_eq_true (b k) with hb | hb
    · exact absurd (ha.trans hb.symm) hk
    · rw [ha, hb]
      simp only [Bool.false_eq_true, ite_true, ite_false, sub_zero]
      exact abs_of_nonneg (by positivity)
    · rw [ha, hb]
      simp only [Bool.false_eq_true, ite_true, ite_false, zero_sub, abs_neg]
      exact abs_of_nonneg (by positivity)
    · exact absurd (ha.trans hb.symm) hk
  -- la cola está acotada por la geométrica desplazada
  have hbound : ∀ n, -(1 / 3 : ℝ) ^ (n + (k + 2)) ≤ h (n + (k + 1)) ∧
      h (n + (k + 1)) ≤ (1 / 3) ^ (n + (k + 2)) := by
    intro n
    have h1 := termino_nonneg a (n + (k + 1))
    have h2 := termino_nonneg b (n + (k + 1))
    have h3 := termino_le a (n + (k + 1))
    have h4 := termino_le b (n + (k + 1))
    have e : n + (k + 1) + 1 = n + (k + 2) := by ring
    rw [e] at h3 h4
    constructor <;> simp only [hh] <;> linarith
  have hgeo := hasSum_geom_shift (k + 2)
  have hup : -h k ≤ (1 / 3 : ℝ) ^ (k + 2) * (3 / 2) :=
    hasSum_le (fun n => (hbound n).2) htail hgeo
  have hlo : -((1 / 3 : ℝ) ^ (k + 2) * (3 / 2)) ≤ -h k :=
    hasSum_le (fun n => (hbound n).1) hgeo.neg htail
  -- contradicción: `1/3^(k+1) = |h k| ≤ (1/2) · 1/3^(k+1)`
  have habs : |h k| ≤ (1 / 3 : ℝ) ^ (k + 2) * (3 / 2) := abs_le.2 ⟨by linarith, by linarith⟩
  have hc : (0 : ℝ) < (1 / 3) ^ (k + 1) := by positivity
  have e : (1 / 3 : ℝ) ^ (k + 2) = (1 / 3) ^ (k + 1) * (1 / 3) := pow_succ _ _
  rw [hk', e] at habs
  linarith

/-- La inyección `{0,1}^ℕ → [0,1)`: `a ↦ Σ a_n / 3^(n+1)`. -/
noncomputable def decodigo (a : ℕ → Bool) : Set.Ico (0 : ℝ) 1 := ⟨suma a, suma_mem a⟩

theorem decodigo_injective : Function.Injective decodigo :=
  fun _ _ h => suma_injective (congrArg Subtype.val h)

/-! ## (a) y (b) -/

/-- **Ej. 10 (a).** `[0,1) ∼ {0,1}^ℕ`, por Cantor–Schröder–Bernstein con las inyecciones
`codigo` y `decodigo`. -/
theorem ej10a : Coordinables (Set.Ico (0 : ℝ) 1) (ℕ → Bool) :=
  teorema_CSB ⟨⟨codigo, codigo_injective⟩⟩ ⟨⟨decodigo, decodigo_injective⟩⟩

/-- Ej. 8 (a) para `ℕ`, reprobado localmente: `𝒫(ℕ) ∼ {0,1}^ℕ` por la función característica. -/
noncomputable def partesEquivFun : Set ℕ ≃ (ℕ → Bool) where
  toFun S := fun n => by classical exact decide (n ∈ S)
  invFun f := {n | f n = true}
  left_inv S := by
    ext n
    simp
  right_inv f := by
    funext n
    simp

/-- **Ej. 10 (b).** `#𝒫(ℕ) = c`: `𝒫(ℕ) ∼ {0,1}^ℕ ∼ [0,1) ∼ ℝ`. -/
theorem ej10b : CardC (Set ℕ) :=
  coordinables_trans ⟨partesEquivFun⟩
    (coordinables_trans (coordinables_symm ej10a) (cardC_Ico zero_lt_one))

end Guias.Guia2.Ej10
