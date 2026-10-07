/-
Librería común `Comun`: definiciones del curso y resultados de `apuntes.typ` compartidos por las
guías (`Guias/`), los parciales (`Parciales/`) y los ejemplos (`Ejemplos/`). Ver
`apuntes-agente/lean-lemas-compartidos-y-organizacion.md` para el diseño.

`Comun.Metricas.Rn`: las tres distancias usuales de `ℝⁿ` (modelado como `Fin n → ℝ`):
`d₁` (taxista), `d₂` (euclídea) y `d∞` (del máximo; pide `n ≥ 1`, `[NeZero n]`, para que el
máximo sobre `{1, …, n}` tenga sentido). Contiene:
* `esMetrica_d2`, `esMetrica_d1`, `esMetrica_dinf`: **Práctica 3, Ej. 1 (b), (c), (d)**, con
  Cauchy–Schwarz (`cauchy_schwarz`) para la triangular de `d₂`;
* las bolas `bola_d2`, `bola_dinf` de los dibujos del Ej. 1;
* la cadena `d∞ ≤ d₂ ≤ d₁ ≤ n · d∞` (`cadena`, Práctica 3, Ej. 12 (a)) y `d₂ ≤ √n · d∞`;
* los puentes con Mathlib: `dinf_eq_dist` (`d∞` es la distancia de Mathlib en `Fin n → ℝ`) y
  `d2_eq_dist_euclidean` (`d₂` es la de `EuclideanSpace ℝ (Fin n)`);
* la completitud de las tres, **Práctica 3, Ej. 14** (`completo_dinf`, `completo_d1`,
  `completo_d2`), con la Definición 4.55 escrita con `ε`-`N` (`EsCompleto`), sin usar que Mathlib
  ya tiene `CompleteSpace` para `PiLp`/`EuclideanSpace`: `d∞` por coordenadas (Corolario 4.58 y
  completitud de `ℝ`, Teorema 4.57) y las otras dos por `completo_of_equiv`.
-/
import Mathlib
import Comun.Metricas

open Filter Topology

namespace Comun

variable {n : ℕ}

/-! ## Las tres distancias -/

/-- `d₁(x, y) = ∑ᵢ |xᵢ - yᵢ|`. -/
def d1 (x y : Fin n → ℝ) : ℝ := ∑ i, |x i - y i|

/-- `d₂(x, y) = (∑ᵢ (xᵢ - yᵢ)²)^(1/2)` en `ℝⁿ = Fin n → ℝ`. -/
noncomputable def d2 (x y : Fin n → ℝ) : ℝ := Real.sqrt (∑ i, (x i - y i) ^ 2)

/-- `d∞(x, y) = máx_{1 ≤ i ≤ n} |xᵢ - yᵢ|` (máximo del conjunto finito no vacío de índices). -/
def dinf [NeZero n] (x y : Fin n → ℝ) : ℝ :=
  Finset.univ.sup' Finset.univ_nonempty (fun i => |x i - y i|)

/-! ## Cotas elementales -/

theorem d1_nonneg (x y : Fin n → ℝ) : 0 ≤ d1 x y :=
  Finset.sum_nonneg fun _ _ => abs_nonneg _

/-- Cada coordenada es a lo sumo `d₁` (un sumando de una suma de términos no negativos). -/
theorem abs_le_d1 (x y : Fin n → ℝ) (i : Fin n) : |x i - y i| ≤ d1 x y :=
  Finset.single_le_sum (f := fun i => |x i - y i|) (fun _ _ => abs_nonneg _) (Finset.mem_univ i)

/-- Cada coordenada es a lo sumo `d∞` (es un máximo). -/
theorem abs_le_dinf [NeZero n] (x y : Fin n → ℝ) (i : Fin n) : |x i - y i| ≤ dinf x y :=
  Finset.le_sup' (fun i => |x i - y i|) (Finset.mem_univ i)

/-- Si todas las coordenadas están acotadas por `c`, entonces `d∞(x, y) ≤ c`. -/
theorem dinf_le [NeZero n] (x y : Fin n → ℝ) (c : ℝ) (h : ∀ i, |x i - y i| ≤ c) :
    dinf x y ≤ c :=
  Finset.sup'_le _ _ fun i _ => h i

theorem dinf_nonneg [NeZero n] (x y : Fin n → ℝ) : 0 ≤ dinf x y :=
  le_trans (abs_nonneg _) (abs_le_dinf x y ⟨0, Nat.pos_of_ne_zero (NeZero.ne n)⟩)

theorem n_pos [NeZero n] : (0 : ℝ) < n := by
  exact_mod_cast Nat.pos_of_ne_zero (NeZero.ne n)

/-- Desigualdad de Cauchy–Schwarz en `ℝⁿ`: `∑ aᵢbᵢ ≤ √(∑ aᵢ²)·√(∑ bᵢ²)`.

Argumento elemental (el del Typst): con `A = √(∑ aᵢ²)` y `B = √(∑ bᵢ²)`, si `A = 0` (o `B = 0`)
todos los `aᵢ` (o `bᵢ`) son nulos y vale con igualdad; si no, `0 ≤ ∑ (B aᵢ - A bᵢ)² = 2A²B² - 2AB ∑ aᵢbᵢ`
y se divide por `2AB > 0`. -/
theorem cauchy_schwarz (a b : Fin n → ℝ) :
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

/-! ## Los axiomas de métrica (Práctica 3, Ej. 1 (b), (c), (d)) -/

/-- **Práctica 3, Ej. 1 (b).** `d₂` es una métrica en `ℝⁿ`. La desigualdad triangular es
Minkowski, que se deduce de Cauchy–Schwarz; la demostración sigue el texto de
`guias-agente/guia_3_resuelta_agente.typ`. -/
theorem esMetrica_d2 (n : ℕ) : EsMetrica (d2 (n := n)) where
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

/-- **Práctica 3, Ej. 1 (c).** `d₁` es una métrica en `ℝⁿ`; la demostración sigue el texto de
`guias-agente/guia_3_resuelta_agente.typ`. -/
theorem esMetrica_d1 (n : ℕ) : EsMetrica (d1 (n := n)) where
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

/-- **Práctica 3, Ej. 1 (d).** `d∞` es una métrica en `ℝⁿ` (`n ≥ 1`); la demostración sigue el
texto de `guias-agente/guia_3_resuelta_agente.typ`. -/
theorem esMetrica_dinf (n : ℕ) [NeZero n] : EsMetrica (dinf (n := n)) where
  nonneg x y := dinf_nonneg x y
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

/-! ## Bolas (dibujos del Ej. 1) -/

/-- Bola abierta de `d₂` (dibujo (b)): para `r > 0`, `B₂(c, r) = {x : ∑ (cᵢ - xᵢ)² < r²}`. -/
theorem bola_d2 (c : Fin n → ℝ) {r : ℝ} (hr : 0 < r) :
    bola d2 c r = {x | ∑ i, (c i - x i) ^ 2 < r ^ 2} := by
  ext x
  simp only [bola, d2, Set.mem_ofPred_eq]
  exact Real.sqrt_lt' hr

/-- Bola abierta de `d∞` (dibujo (d)): `B∞(c, r) = {x : ∀ i, |cᵢ - xᵢ| < r}`. -/
theorem bola_dinf [NeZero n] (c : Fin n → ℝ) (r : ℝ) :
    bola dinf c r = {x | ∀ i, |c i - x i| < r} := by
  ext x
  simp only [bola, dinf, Set.mem_ofPred_eq]
  rw [Finset.sup'_lt_iff]
  simp

/-! ## La cadena `d∞ ≤ d₂ ≤ d₁ ≤ n · d∞` (Práctica 3, Ej. 12 (a)) -/

/-- `d∞ ≤ d₂`: cada `|xᵢ - yᵢ| = √((xᵢ - yᵢ)²) ≤ √(∑ⱼ (xⱼ - yⱼ)²)`. -/
theorem dinf_le_d2 [NeZero n] (x y : Fin n → ℝ) : dinf x y ≤ d2 x y := by
  apply Finset.sup'_le
  intro i _
  unfold d2
  rw [← Real.sqrt_sq_eq_abs]
  apply Real.sqrt_le_sqrt
  exact Finset.single_le_sum (f := fun j => (x j - y j) ^ 2) (fun _ _ => sq_nonneg _)
    (Finset.mem_univ i)

/-- `d₂ ≤ d₁`: `∑ aᵢ² = ∑ |aᵢ|·|aᵢ| ≤ d₁ · ∑ |aᵢ| = d₁²`, pues `|aᵢ| ≤ d₁`. -/
theorem d2_le_d1 (x y : Fin n → ℝ) : d2 x y ≤ d1 x y := by
  unfold d2
  rw [Real.sqrt_le_left (d1_nonneg x y)]
  calc ∑ i, (x i - y i) ^ 2 = ∑ i, |x i - y i| * |x i - y i| := by
        refine Finset.sum_congr rfl fun i _ => ?_
        rw [← sq, sq_abs]
    _ ≤ ∑ i, d1 x y * |x i - y i| := by
        refine Finset.sum_le_sum fun i _ => ?_
        exact mul_le_mul_of_nonneg_right (abs_le_d1 x y i) (abs_nonneg _)
    _ = d1 x y * d1 x y := by rw [← Finset.mul_sum]; rfl
    _ = d1 x y ^ 2 := by ring

/-- `d₁ ≤ n · d∞`: cada uno de los `n` sumandos es a lo sumo `d∞`. -/
theorem d1_le_n_dinf [NeZero n] (x y : Fin n → ℝ) : d1 x y ≤ n * dinf x y := by
  calc d1 x y ≤ ∑ _i : Fin n, dinf x y := Finset.sum_le_sum fun i _ => abs_le_dinf x y i
    _ = n * dinf x y := by simp

/-- `d₂ ≤ n · d∞` (encadenando). -/
theorem d2_le_n_dinf [NeZero n] (x y : Fin n → ℝ) : d2 x y ≤ n * dinf x y :=
  (d2_le_d1 x y).trans (d1_le_n_dinf x y)

/-- `d₁ ≤ n · d₂` (encadenando). -/
theorem d1_le_n_d2 [NeZero n] (x y : Fin n → ℝ) : d1 x y ≤ n * d2 x y :=
  (d1_le_n_dinf x y).trans (mul_le_mul_of_nonneg_left (dinf_le_d2 x y) n_pos.le)

/-- `d∞ ≤ d₁` (consecuencia de `d∞ ≤ d₂ ≤ d₁`). -/
theorem dinf_le_d1 [NeZero n] (x y : Fin n → ℝ) : dinf x y ≤ d1 x y :=
  (dinf_le_d2 x y).trans (d2_le_d1 x y)

/-- **Práctica 3, Ej. 12 (a), resumen.** La cadena completa de desigualdades. -/
theorem cadena [NeZero n] (x y : Fin n → ℝ) :
    dinf x y ≤ d2 x y ∧ d2 x y ≤ d1 x y ∧ d1 x y ≤ n * dinf x y :=
  ⟨dinf_le_d2 x y, d2_le_d1 x y, d1_le_n_dinf x y⟩

/-- La cota fina `d₂ ≤ √n · d∞`: `∑ (xᵢ - yᵢ)² ≤ n · d∞²`. -/
theorem d2_le_sqrt_n_dinf [NeZero n] (x y : Fin n → ℝ) : d2 x y ≤ Real.sqrt n * dinf x y := by
  unfold d2
  rw [← Real.sqrt_sq (dinf_nonneg x y), ← Real.sqrt_mul (Nat.cast_nonneg n)]
  apply Real.sqrt_le_sqrt
  calc ∑ i, (x i - y i) ^ 2 ≤ ∑ _i : Fin n, dinf x y ^ 2 := by
        apply Finset.sum_le_sum
        intro i _
        calc (x i - y i) ^ 2 = |x i - y i| ^ 2 := (sq_abs _).symm
          _ ≤ dinf x y ^ 2 := by gcongr; exact abs_le_dinf x y i
    _ = n * dinf x y ^ 2 := by simp

/-! ## Puentes con Mathlib -/

/-- `d∞` es la distancia de Mathlib en `Fin n → ℝ` (producto con la métrica del supremo). -/
theorem dinf_eq_dist [NeZero n] (x y : Fin n → ℝ) : dinf x y = dist x y := by
  apply le_antisymm
  · apply dinf_le
    intro i
    rw [← Real.dist_eq]
    exact dist_le_pi_dist x y i
  · rw [dist_pi_le_iff (dinf_nonneg x y)]
    intro i
    rw [Real.dist_eq]
    exact abs_le_dinf x y i

/-- `d₂` es la distancia de `EuclideanSpace ℝ (Fin n)`. -/
theorem d2_eq_dist_euclidean (x y : Fin n → ℝ) :
    d2 x y = dist (WithLp.toLp 2 x : EuclideanSpace ℝ (Fin n)) (WithLp.toLp 2 y) := by
  simp [d2, EuclideanSpace.dist_eq, Real.dist_eq, sq_abs]

/-! ## Completitud (Práctica 3, Ej. 14) -/

/-- **Práctica 3, Ej. 14, caso `d∞`** (prueba por coordenadas del Corolario 4.58; la demostración
sigue el texto de `guias-agente/guia_3_resuelta_agente.typ`). Cada coordenada es de Cauchy en
`ℝ`, converge por completitud de `ℝ` (Teorema 4.57), y `N₀ = máx Nᵢ` sirve para todas a la vez. -/
theorem completo_dinf [NeZero n] : EsCompleto (dinf (n := n)) := by
  intro x hx
  -- cada coordenada `(xₖ i)ₖ` es de Cauchy en `ℝ`, pues `|xₖ i − xⱼ i| ≤ d∞(xₖ, xⱼ)`
  have hcoord : ∀ i : Fin n, CauchySeq (fun k => x k i) := by
    intro i
    rw [Metric.cauchySeq_iff]
    intro ε hε
    obtain ⟨N, hN⟩ := hx ε hε
    refine ⟨N, fun k hk j hj => ?_⟩
    rw [Real.dist_eq]
    exact lt_of_le_of_lt (abs_le_dinf (x k) (x j) i) (hN k hk j hj)
  -- `ℝ` es completo (Teorema 4.57): cada coordenada converge a un `lᵢ`
  have hlim : ∀ i : Fin n, ∃ li : ℝ, Tendsto (fun k => x k i) atTop (𝓝 li) :=
    fun i => cauchySeq_tendsto_of_complete (hcoord i)
  choose l hl using hlim
  refine ⟨l, fun ε hε => ?_⟩
  -- para cada coordenada, un `Nᵢ` con `|xₖ i − lᵢ| < ε / 2` para `k ≥ Nᵢ`
  have hN : ∀ i : Fin n, ∃ Ni : ℕ, ∀ k ≥ Ni, |x k i - l i| < ε / 2 := by
    intro i
    obtain ⟨Ni, hNi⟩ := Metric.tendsto_atTop.1 (hl i) (ε / 2) (by linarith)
    exact ⟨Ni, fun k hk => by simpa [Real.dist_eq] using hNi k hk⟩
  choose N hN using hN
  -- `N₀ = máx{N₁, …, Nₙ}` sirve para todas las coordenadas a la vez
  refine ⟨Finset.univ.sup N, fun k hk => ?_⟩
  have hcada : ∀ i, |x k i - l i| ≤ ε / 2 := fun i =>
    (hN i k (le_trans (Finset.le_sup (f := N) (Finset.mem_univ i)) hk)).le
  have := dinf_le (x k) l (ε / 2) hcada
  linarith

/-- **Práctica 3, Ej. 14, caso `d₁`**: `d∞ ≤ d₁ ≤ n · d∞` y `completo_of_equiv`. -/
theorem completo_d1 [NeZero n] : EsCompleto (d1 (n := n)) :=
  completo_of_equiv completo_dinf one_pos n_pos (fun x y => by rw [one_mul]; exact dinf_le_d1 x y)
    d1_le_n_dinf

/-- **Práctica 3, Ej. 14, caso `d₂`**: `d∞ ≤ d₂ ≤ n · d∞` y `completo_of_equiv`. -/
theorem completo_d2 [NeZero n] : EsCompleto (d2 (n := n)) :=
  completo_of_equiv completo_dinf one_pos n_pos (fun x y => by rw [one_mul]; exact dinf_le_d2 x y)
    d2_le_n_dinf

end Comun
