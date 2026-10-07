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
La serie `a ↦ Σ a_n / 3^(n+1)` vive en `Comun.Cardinales.Continuo` (`serie`, `serie_mem`,
`serie_injective`, `serieIcoEmb`), igual que `𝒫(ℕ) ∼ {0,1}^ℕ` (`setEquivBool`, Ej. 8 (a)). El
bloque de desarrollos binarios (`digito`, …, `codigo_injective`) queda local;
`eq_of_forall_abs_sub_lt` (Arquímedes) está en `Comun.Reales`.
-/
import Mathlib
import Comun.Reales
import Comun.Cardinales
import Comun.Cardinales.Continuo

namespace Guias.Guia2.Ej10

open Comun
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

/-- La inyección `[0,1) → {0,1}^ℕ`: `x ↦ (d_n(x))_n`. -/
noncomputable def codigo (x : Set.Ico (0 : ℝ) 1) : ℕ → Bool := digito x.1

theorem codigo_injective : Function.Injective codigo := by
  intro x y h
  apply Subtype.ext
  apply eq_of_forall_abs_sub_lt
  intro n
  exact abs_sub_lt_of_floor_eq x.2.1 y.2.1
    (floor_eq_of_digitos_eq x.2 y.2 (fun n => congrFun h n) n)

/-! ## Inyección `{0,1}^ℕ → [0,1)`: la serie `Σ a_n / 3^(n+1)` (`Comun.serie`) -/

/-- La inyección `{0,1}^ℕ → [0,1)`: `a ↦ Σ a_n / 3^(n+1)` (`Comun.serie`, que cae en `[0,1)` por
`Comun.serie_mem` y es inyectiva por `Comun.serie_injective`). -/
noncomputable def decodigo (a : ℕ → Bool) : Set.Ico (0 : ℝ) 1 := ⟨serie a, serie_mem a⟩

theorem decodigo_injective : Function.Injective decodigo :=
  fun _ _ h => serie_injective (congrArg Subtype.val h)

/-! ## (a) y (b) -/

/-- **Ej. 10 (a).** `[0,1) ∼ {0,1}^ℕ`, por Cantor–Schröder–Bernstein con las inyecciones
`codigo` y `decodigo`. -/
theorem ej10a : Coordinables (Set.Ico (0 : ℝ) 1) (ℕ → Bool) :=
  teorema_CSB ⟨⟨codigo, codigo_injective⟩⟩ ⟨⟨decodigo, decodigo_injective⟩⟩

/-- **Ej. 10 (b).** `#𝒫(ℕ) = c`: `𝒫(ℕ) ∼ {0,1}^ℕ ∼ [0,1) ∼ ℝ` (Ej. 8 (a) como
`Comun.setEquivBool`, (a), Observación 3.21). (En `Comun.Cardinales.Continuo`, `cardC_set_nat` es
el mismo enunciado probado por CSB con cortes y serie.) -/
theorem ej10b : CardC (Set ℕ) :=
  coordinables_trans ⟨setEquivBool ℕ⟩
    (coordinables_trans (coordinables_symm ej10a) (cardC_Ico zero_lt_one))

end Guias.Guia2.Ej10
