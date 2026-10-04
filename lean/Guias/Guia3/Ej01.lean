/-
Análisis Avanzado (FCEN-UBA) · Práctica 3 · Ejercicio 1
Enunciado en `apuntes-typst/guias/p3.typ`; resolución en `apuntes-typst/guias-agente/guia_3_resuelta_agente.typ` (Ejercicio 1).

Para cada espacio de la lista se prueba `EsMetrica d` (los cuatro axiomas de la Definición 4.1,
ver `Guias/Common.lean`) sobre una función `d` definida a mano, y se verifica la descripción
conjuntista de la bola abierta que se dibuja en el Typst:

* (a) `ℝ`, `|x - y|`:                    `B(x, r) = (x - r, x + r)`.
* (b) `ℝⁿ`, `d₂`:                        `B₂(c, r) = {x : ∑ (xᵢ - cᵢ)² < r²}`; en `ℝ²`, el disco unitario.
* (c) `ℝⁿ`, `d₁`:                        `B₁(0, 1) = {abs x₀ + abs x₁ < 1}` en `ℝ²` (rombo).
* (d) `ℝⁿ`, `d∞` (con `max`):            `B∞(c, r) = {x : ∀ i, |xᵢ - cᵢ| < r}`; en `ℝ²`, el cuadrado.
* (e) `C([0,1])`, `d∞` (con `max`):      `B(f, r) = {g : ∀ t, f t - r < g t < f t + r}` (banda).
* (f) `E`, `δ`:                          `B(x, r) = {x}` si `0 < r ≤ 1` y `B(x, r) = E` si `r > 1`.

Desvíos respecto del texto: `ℝⁿ` es `Fin n → ℝ` con `n ≥ 1` (`[NeZero n]`, para que el máximo
sobre `{1, …, n}` tenga sentido); `C([0,1])` es `C(unitInterval, ℝ)`; el máximo de `d∞` en
`C([0,1])` se formaliza como `⨆` y se prueba aparte (`dC_eq_max`) que se alcanza (Weierstrass,
vía `IsCompact.exists_isMaxOn`, el teorema de los valores extremos en un compacto: es el
mismo teorema que cita la guía al escribir "máx").
-/
import Mathlib
import Guias.Common

namespace Guias.Guia3.Ej01

open Guias

/-! ## (a) `ℝ` con `d(x, y) = |x - y|` -/

/-- `d(x, y) = |x - y|` en `ℝ`. -/
def dA (x y : ℝ) : ℝ := |x - y|

/-- **Ej. 1 (a).** `|x - y|` es una métrica en `ℝ`. -/
theorem ej1a : EsMetrica dA where
  nonneg x y := abs_nonneg _
  eq_zero_iff x y := by
    unfold dA
    rw [abs_eq_zero, sub_eq_zero]
  symm x y := abs_sub_comm x y
  triangle x y z := abs_sub_le x y z

/-- Bola abierta del dibujo (a): `B(x, r) = (x - r, x + r)`. -/
theorem bola_dA (x r : ℝ) : bola dA x r = Set.Ioo (x - r) (x + r) := by
  ext y
  simp only [bola, dA, Set.mem_ofPred_eq, Set.mem_Ioo]
  rw [abs_sub_lt_iff]
  constructor <;> rintro ⟨h1, h2⟩ <;> constructor <;> linarith

/-! ## (b) `ℝⁿ` con la distancia euclídea `d₂` -/

/-- `d₂(x, y) = (∑ᵢ (xᵢ - yᵢ)²)^(1/2)` en `ℝⁿ = Fin n → ℝ`. -/
noncomputable def d2 {n : ℕ} (x y : Fin n → ℝ) : ℝ := Real.sqrt (∑ i, (x i - y i) ^ 2)

/-- Desigualdad de Cauchy–Schwarz en `ℝⁿ`: `∑ aᵢbᵢ ≤ √(∑ aᵢ²)·√(∑ bᵢ²)`.

Argumento elemental (el del Typst): con `A = √(∑ aᵢ²)` y `B = √(∑ bᵢ²)`, si `A = 0` (o `B = 0`)
todos los `aᵢ` (o `bᵢ`) son nulos y vale con igualdad; si no, `0 ≤ ∑ (B aᵢ - A bᵢ)² = 2A²B² - 2AB ∑ aᵢbᵢ`
y se divide por `2AB > 0`. -/
theorem cauchy_schwarz {n : ℕ} (a b : Fin n → ℝ) :
    ∑ i, a i * b i ≤ Real.sqrt (∑ i, a i ^ 2) * Real.sqrt (∑ i, b i ^ 2) := by
  have hSa : 0 ≤ ∑ i, a i ^ 2 := Finset.sum_nonneg fun _ _ => sq_nonneg _
  have hSb : 0 ≤ ∑ i, b i ^ 2 := Finset.sum_nonneg fun _ _ => sq_nonneg _
  set A := Real.sqrt (∑ i, a i ^ 2) with hA
  set B := Real.sqrt (∑ i, b i ^ 2) with hB
  have hA2 : A ^ 2 = ∑ i, a i ^ 2 := Real.sq_sqrt hSa
  have hB2 : B ^ 2 = ∑ i, b i ^ 2 := Real.sq_sqrt hSb
  have hA0 : 0 ≤ A := Real.sqrt_nonneg _
  have hB0 : 0 ≤ B := Real.sqrt_nonneg _
  rcases hA0.eq_or_lt with hA0' | hApos
  · -- A = 0: todos los aᵢ son 0
    have hz : ∑ i, a i ^ 2 = 0 := by rw [← hA2, ← hA0']; ring
    have ha : ∀ i, a i = 0 := fun i => by
      have := (Finset.sum_eq_zero_iff_of_nonneg (fun j _ => sq_nonneg (a j))).1 hz i
        (Finset.mem_univ i)
      exact pow_eq_zero_iff (two_ne_zero) |>.1 this
    simp [ha, ← hA0']
  rcases hB0.eq_or_lt with hB0' | hBpos
  · have hz : ∑ i, b i ^ 2 = 0 := by rw [← hB2, ← hB0']; ring
    have hb : ∀ i, b i = 0 := fun i => by
      have := (Finset.sum_eq_zero_iff_of_nonneg (fun j _ => sq_nonneg (b j))).1 hz i
        (Finset.mem_univ i)
      exact pow_eq_zero_iff (two_ne_zero) |>.1 this
    simp [hb, ← hB0']
  -- A, B > 0
  have key : 0 ≤ ∑ i, (B * a i - A * b i) ^ 2 := Finset.sum_nonneg fun _ _ => sq_nonneg _
  have expand : ∑ i, (B * a i - A * b i) ^ 2
      = B ^ 2 * ∑ i, a i ^ 2 - 2 * (A * B) * ∑ i, a i * b i + A ^ 2 * ∑ i, b i ^ 2 := by
    rw [Finset.mul_sum, Finset.mul_sum, Finset.mul_sum, ← Finset.sum_sub_distrib,
      ← Finset.sum_add_distrib]
    refine Finset.sum_congr rfl fun i _ => ?_
    ring
  rw [expand, ← hA2, ← hB2] at key
  have hAB : 0 < A * B := mul_pos hApos hBpos
  nlinarith

/-- **Ej. 1 (b).** `d₂` es una métrica en `ℝⁿ`. La desigualdad triangular es Minkowski, que se
deduce de Cauchy–Schwarz. -/
theorem ej1b (n : ℕ) : EsMetrica (d2 (n := n)) where
  nonneg x y := Real.sqrt_nonneg _
  eq_zero_iff x y := by
    unfold d2
    rw [Real.sqrt_eq_zero (Finset.sum_nonneg fun _ _ => sq_nonneg _),
      Finset.sum_eq_zero_iff_of_nonneg (fun _ _ => sq_nonneg _)]
    constructor
    · intro h
      funext i
      have := h i (Finset.mem_univ i)
      exact sub_eq_zero.1 (pow_eq_zero_iff two_ne_zero |>.1 this)
    · intro h i _
      rw [h]; simp
  symm x y := by
    unfold d2
    congr 1
    refine Finset.sum_congr rfl fun i _ => ?_
    ring
  triangle x y z := by
    unfold d2
    -- a = x - y, b = y - z; entonces x - z = a + b.
    set a : Fin n → ℝ := fun i => x i - y i with ha
    set b : Fin n → ℝ := fun i => y i - z i with hb
    have hSa : 0 ≤ ∑ i, a i ^ 2 := Finset.sum_nonneg fun _ _ => sq_nonneg _
    have hSb : 0 ≤ ∑ i, b i ^ 2 := Finset.sum_nonneg fun _ _ => sq_nonneg _
    have hcs := cauchy_schwarz a b
    have hxz : ∑ i, (x i - z i) ^ 2 = ∑ i, a i ^ 2 + 2 * ∑ i, a i * b i + ∑ i, b i ^ 2 := by
      rw [Finset.mul_sum, ← Finset.sum_add_distrib, ← Finset.sum_add_distrib]
      refine Finset.sum_congr rfl fun i _ => ?_
      simp only [ha, hb]
      ring
    have hA2 := Real.sq_sqrt hSa
    have hB2 := Real.sq_sqrt hSb
    have hA0 := Real.sqrt_nonneg (∑ i, a i ^ 2)
    have hB0 := Real.sqrt_nonneg (∑ i, b i ^ 2)
    show Real.sqrt (∑ i, (x i - z i) ^ 2) ≤
      Real.sqrt (∑ i, a i ^ 2) + Real.sqrt (∑ i, b i ^ 2)
    rw [Real.sqrt_le_iff]
    refine ⟨by positivity, ?_⟩
    rw [hxz]
    nlinarith

/-- Bola abierta de `d₂` (dibujo (b)): para `r > 0`, `B₂(c, r) = {x : ∑ (cᵢ - xᵢ)² < r²}`. -/
theorem bola_d2 {n : ℕ} (c : Fin n → ℝ) {r : ℝ} (hr : 0 < r) :
    bola d2 c r = {x | ∑ i, (c i - x i) ^ 2 < r ^ 2} := by
  ext x
  simp only [bola, d2, Set.mem_ofPred_eq]
  exact Real.sqrt_lt' hr

/-- En `ℝ²`: `B₂(0, 1)` es el disco unitario abierto `{x₀² + x₁² < 1}`. -/
theorem bola_d2_R2 : bola d2 (0 : Fin 2 → ℝ) 1 = {x | x 0 ^ 2 + x 1 ^ 2 < 1} := by
  rw [bola_d2 _ one_pos]
  ext x
  simp [Fin.sum_univ_two]

/-! ## (c) `ℝⁿ` con la distancia taxista `d₁` -/

/-- `d₁(x, y) = ∑ᵢ |xᵢ - yᵢ|`. -/
def d1 {n : ℕ} (x y : Fin n → ℝ) : ℝ := ∑ i, |x i - y i|

/-- **Ej. 1 (c).** `d₁` es una métrica en `ℝⁿ`. -/
theorem ej1c (n : ℕ) : EsMetrica (d1 (n := n)) where
  nonneg x y := Finset.sum_nonneg fun _ _ => abs_nonneg _
  eq_zero_iff x y := by
    unfold d1
    rw [Finset.sum_eq_zero_iff_of_nonneg (fun _ _ => abs_nonneg _)]
    constructor
    · intro h
      funext i
      exact sub_eq_zero.1 (abs_eq_zero.1 (h i (Finset.mem_univ i)))
    · intro h i _
      rw [h]; simp
  symm x y := by
    unfold d1
    exact Finset.sum_congr rfl fun i _ => abs_sub_comm _ _
  triangle x y z := by
    unfold d1
    rw [← Finset.sum_add_distrib]
    exact Finset.sum_le_sum fun i _ => abs_sub_le _ _ _

/-- En `ℝ²`: `B₁(0, 1)` es el rombo abierto `{|x₀| + |x₁| < 1}`. -/
theorem bola_d1_R2 : bola d1 (0 : Fin 2 → ℝ) 1 = {x | |x 0| + |x 1| < 1} := by
  ext x
  simp [bola, d1, Fin.sum_univ_two]

/-! ## (d) `ℝⁿ` con la distancia del máximo `d∞` -/

/-- `d∞(x, y) = máx_{1 ≤ i ≤ n} |xᵢ - yᵢ|` (máximo del conjunto finito no vacío de índices). -/
def dinf {n : ℕ} [NeZero n] (x y : Fin n → ℝ) : ℝ :=
  Finset.univ.sup' Finset.univ_nonempty (fun i => |x i - y i|)

/-- Cada coordenada es a lo sumo el máximo. -/
theorem abs_le_dinf {n : ℕ} [NeZero n] (x y : Fin n → ℝ) (i : Fin n) : |x i - y i| ≤ dinf x y :=
  Finset.le_sup' (fun i => |x i - y i|) (Finset.mem_univ i)

/-- **Ej. 1 (d).** `d∞` es una métrica en `ℝⁿ` (`n ≥ 1`). -/
theorem ej1d (n : ℕ) [NeZero n] : EsMetrica (dinf (n := n)) where
  nonneg x y := le_trans (abs_nonneg _) (abs_le_dinf x y ⟨0, Nat.pos_of_ne_zero (NeZero.ne n)⟩)
  eq_zero_iff x y := by
    constructor
    · intro h
      funext i
      have h1 : |x i - y i| ≤ 0 := h ▸ abs_le_dinf x y i
      exact sub_eq_zero.1 (abs_nonpos_iff.1 h1)
    · intro h
      subst h
      unfold dinf
      simp
  symm x y := by
    unfold dinf
    exact congrArg _ (funext fun i => abs_sub_comm _ _)
  triangle x y z := by
    unfold dinf
    apply Finset.sup'_le
    intro i _
    calc |x i - z i| ≤ |x i - y i| + |y i - z i| := abs_sub_le _ _ _
      _ ≤ dinf x y + dinf y z := add_le_add (abs_le_dinf x y i) (abs_le_dinf y z i)

/-- Bola abierta de `d∞` (dibujo (d)): `B∞(c, r) = {x : ∀ i, |cᵢ - xᵢ| < r}`. -/
theorem bola_dinf {n : ℕ} [NeZero n] (c : Fin n → ℝ) (r : ℝ) :
    bola dinf c r = {x | ∀ i, |c i - x i| < r} := by
  ext x
  simp only [bola, dinf, Set.mem_ofPred_eq]
  rw [Finset.sup'_lt_iff]
  simp

/-- En `ℝ²`: `B∞(0, 1)` es el cuadrado abierto `(-1, 1) × (-1, 1)`. -/
theorem bola_dinf_R2 : bola dinf (0 : Fin 2 → ℝ) 1 = {x | |x 0| < 1 ∧ |x 1| < 1} := by
  rw [bola_dinf]
  ext x
  simp [Fin.forall_fin_two]

/-! ## (e) `C([0, 1])` con la distancia `d∞(f, g) = máx_t |f t - g t|` -/

/-- `C([0, 1])`. -/
abbrev C01 := C(unitInterval, ℝ)

/-- `d∞(f, g) = máx_{t ∈ [0,1]} |f t - g t|`, escrito como supremo (es un máximo: `dC_eq_max`). -/
noncomputable def dC (f g : C01) : ℝ := ⨆ t, |f t - g t|

theorem continuous_absdiff (f g : C01) : Continuous fun t => |f t - g t| :=
  (f.continuous.sub g.continuous).abs

/-- El conjunto de valores `{|f t - g t|}` está acotado (compacidad de `[0, 1]`). -/
theorem bdd_absdiff (f g : C01) : BddAbove (Set.range fun t => |f t - g t|) :=
  (isCompact_range (continuous_absdiff f g)).bddAbove

/-- Weierstrass: la función continua `t ↦ |f t - g t|` alcanza su máximo en `[0, 1]`. -/
theorem exists_max (f g : C01) : ∃ t₀, ∀ t, |f t - g t| ≤ |f t₀ - g t₀| :=
  let ⟨t₀, _, ht₀⟩ := isCompact_univ.exists_isMaxOn Set.univ_nonempty
    (continuous_absdiff f g).continuousOn
  ⟨t₀, fun t => ht₀ (Set.mem_univ t)⟩

/-- El supremo es un máximo: `d∞(f, g) = |f t₀ - g t₀|` para un `t₀` donde se alcanza. -/
theorem dC_eq_max (f g : C01) : ∃ t₀, dC f g = |f t₀ - g t₀| ∧ ∀ t, |f t - g t| ≤ dC f g := by
  obtain ⟨t₀, ht₀⟩ := exists_max f g
  refine ⟨t₀, le_antisymm (ciSup_le ht₀) (le_ciSup (bdd_absdiff f g) t₀), fun t => ?_⟩
  exact le_ciSup (bdd_absdiff f g) t

theorem abs_le_dC (f g : C01) (t : unitInterval) : |f t - g t| ≤ dC f g :=
  le_ciSup (bdd_absdiff f g) t

/-- **Ej. 1 (e).** `d∞` es una métrica en `C([0, 1])`. -/
theorem ej1e : EsMetrica dC where
  nonneg f g := Real.iSup_nonneg fun _ => abs_nonneg _
  eq_zero_iff f g := by
    constructor
    · intro h
      ext t
      have h1 : |f t - g t| ≤ 0 := h ▸ abs_le_dC f g t
      exact sub_eq_zero.1 (abs_nonpos_iff.1 h1)
    · intro h
      subst h
      unfold dC
      simp
  symm f g := by
    unfold dC
    exact congrArg _ (funext fun t => abs_sub_comm _ _)
  triangle f g h := by
    apply ciSup_le
    intro t
    calc |f t - h t| ≤ |f t - g t| + |g t - h t| := abs_sub_le _ _ _
      _ ≤ dC f g + dC g h := add_le_add (abs_le_dC f g t) (abs_le_dC g h t)

/-- Bola abierta de `d∞` en `C([0,1])` (dibujo (e)): la banda de semiancho `r` alrededor de `f`.
Aquí es esencial que el supremo sea un máximo (se alcanza). -/
theorem bola_dC (f : C01) (r : ℝ) :
    bola dC f r = {g | ∀ t, f t - r < g t ∧ g t < f t + r} := by
  ext g
  simp only [bola, Set.mem_ofPred_eq]
  constructor
  · intro h t
    have h1 : |f t - g t| < r := lt_of_le_of_lt (abs_le_dC f g t) h
    rw [abs_sub_lt_iff] at h1
    constructor <;> linarith [h1.1, h1.2]
  · intro h
    obtain ⟨t₀, ht₀, _⟩ := dC_eq_max f g
    rw [ht₀, abs_sub_lt_iff]
    obtain ⟨h1, h2⟩ := h t₀
    constructor <;> linarith

/-! ## (f) La métrica discreta `δ` en un conjunto `E` -/

/-- `δ(x, y) = 0` si `x = y`, `1` si `x ≠ y`. -/
def δ {E : Type*} [DecidableEq E] (x y : E) : ℝ := if x = y then 0 else 1

/-- **Ej. 1 (f).** `δ` es una métrica en `E` (para todo `E`; si es no vacío es un espacio métrico
no trivial, y si es vacío no hay nada que chequear). -/
theorem ej1f (E : Type*) [DecidableEq E] : EsMetrica (δ (E := E)) where
  nonneg x y := by unfold δ; split_ifs <;> norm_num
  eq_zero_iff x y := by
    unfold δ
    by_cases h : x = y <;> simp [h]
  symm x y := by
    unfold δ
    by_cases h : x = y
    · simp [h]
    · simp [h, Ne.symm h]
  triangle x y z := by
    unfold δ
    by_cases hxz : x = z
    · subst hxz
      have h0 : (if x = x then (0 : ℝ) else 1) = 0 := by simp
      rw [h0]
      split_ifs <;> norm_num
    · -- x ≠ z: no pueden valer a la vez x = y e y = z
      have h : ¬ (x = y ∧ y = z) := fun ⟨h1, h2⟩ => hxz (h1.trans h2)
      by_cases hxy : x = y
      · have hyz : ¬ y = z := fun h2 => h ⟨hxy, h2⟩
        simp [hxy, hyz]
      · by_cases hyz : y = z
        · simp [hxz, hyz]
        · simp [hxz, hxy, hyz]

/-- Bola discreta de radio `0 < r ≤ 1`: `B(x, r) = {x}`. -/
theorem bola_delta_le {E : Type*} [DecidableEq E] (x : E) {r : ℝ} (hr0 : 0 < r) (hr : r ≤ 1) :
    bola δ x r = {x} := by
  ext y
  simp only [bola, δ, Set.mem_ofPred_eq, Set.mem_singleton_iff]
  by_cases h : x = y
  · simp [h, hr0]
  · simp [h, Ne.symm h, not_lt.2 hr]

/-- Bola discreta de radio `r > 1`: `B(x, r) = E`. -/
theorem bola_delta_gt {E : Type*} [DecidableEq E] (x : E) {r : ℝ} (hr : 1 < r) :
    bola δ x r = Set.univ := by
  ext y
  simp only [bola, δ, Set.mem_ofPred_eq, Set.mem_univ, iff_true]
  split_ifs <;> linarith

end Guias.Guia3.Ej01
