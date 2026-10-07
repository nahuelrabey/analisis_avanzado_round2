/-
Análisis Avanzado (FCEN-UBA) · Práctica 3 · Ejercicio 12
Enunciado en `apuntes-typst/guias/p3.typ`; resolución en `apuntes-typst/guias-agente/guia_3_resuelta_agente.typ` (Ejercicio 12).

En `ℝⁿ` (modelado como `Fin n → ℝ`, con `n ≥ 1`) se tienen las distancias `d₁`, `d₂`, `d∞`.

* (a) `d∞ ≤ d₂ ≤ d₁ ≤ n · d∞` (`dinf_le_d2`, `d2_le_d1`, `d1_le_n_dinf`) y de ahí la equivalencia
  de las tres métricas (`equivalentes_*`), con la definición de "métricas equivalentes" adoptada
  en el Typst: toda bola de una contiene una bola de la otra con el mismo centro, y viceversa.
  `abiertos_iff` formaliza "definen los mismos abiertos".
* (b) `B₁(x, r) ⊆ B₂(x, r) ⊆ B∞(x, r) ⊆ B₁(x, n r)` (`bola_inclusiones`).
-/
import Mathlib
import Comun.Metricas
import Comun.Topologia

namespace Guias.Guia3.Ej12

open Comun

variable {n : ℕ} [NeZero n]

/-- `d₁(x, y) = ∑ᵢ |xᵢ - yᵢ|`. -/
def d1 (x y : Fin n → ℝ) : ℝ := ∑ i, |x i - y i|

/-- `d₂(x, y) = (∑ᵢ (xᵢ - yᵢ)²)^(1/2)`. -/
noncomputable def d2 (x y : Fin n → ℝ) : ℝ := Real.sqrt (∑ i, (x i - y i) ^ 2)

/-- `d∞(x, y) = máx_{1 ≤ i ≤ n} |xᵢ - yᵢ|` (máximo del conjunto finito no vacío de índices). -/
def dinf (x y : Fin n → ℝ) : ℝ := Finset.univ.sup' Finset.univ_nonempty (fun i => |x i - y i|)

/-! ## Definición de métricas equivalentes (la adoptada en el Typst) -/

/-- Un conjunto `U` es abierto para `d` si cada punto de `U` tiene una bola (de `d`) dentro de `U`. -/
def EsAbierto {X : Type*} (d : X → X → ℝ) (U : Set X) : Prop :=
  ∀ x ∈ U, ∃ r > 0, bola d x r ⊆ U

/-- `d` y `d'` son equivalentes: toda bola de una contiene una bola de la otra con el mismo centro. -/
def Equivalentes {X : Type*} (d d' : X → X → ℝ) : Prop :=
  (∀ x, ∀ r > 0, ∃ s > 0, bola d' x s ⊆ bola d x r) ∧
  (∀ x, ∀ r > 0, ∃ s > 0, bola d x s ⊆ bola d' x r)

/-- Métricas equivalentes definen los mismos abiertos. -/
theorem abiertos_iff {X : Type*} {d d' : X → X → ℝ} (h : Equivalentes d d') (U : Set X) :
    EsAbierto d U ↔ EsAbierto d' U := by
  obtain ⟨h1, h2⟩ := h
  constructor
  · intro hU x hx
    obtain ⟨r, hr, hrU⟩ := hU x hx
    obtain ⟨s, hs, hsr⟩ := h1 x r hr
    exact ⟨s, hs, hsr.trans hrU⟩
  · intro hU x hx
    obtain ⟨r, hr, hrU⟩ := hU x hx
    obtain ⟨s, hs, hsr⟩ := h2 x r hr
    exact ⟨s, hs, hsr.trans hrU⟩

/-- Criterio de equivalencia uniforme: si `d ≤ d' ≤ C · d` con `C > 0`, entonces `d ≈ d'`. -/
theorem equivalentes_of_le {X : Type*} {d d' : X → X → ℝ} {C : ℝ} (hC : 0 < C)
    (h1 : ∀ x y, d x y ≤ d' x y) (h2 : ∀ x y, d' x y ≤ C * d x y) : Equivalentes d d' := by
  constructor
  · intro x r hr
    refine ⟨r, hr, fun y hy => ?_⟩
    exact lt_of_le_of_lt (h1 x y) hy
  · intro x r hr
    refine ⟨r / C, div_pos hr hC, fun y hy => ?_⟩
    have hy' : d x y < r / C := hy
    have : C * d x y < r := by
      rw [lt_div_iff₀ hC] at hy'
      linarith
    exact lt_of_le_of_lt (h2 x y) this

/-! ## (a) Las desigualdades `d∞ ≤ d₂ ≤ d₁ ≤ n d∞` -/

omit [NeZero n] in
theorem d1_nonneg (x y : Fin n → ℝ) : 0 ≤ d1 x y :=
  Finset.sum_nonneg fun _ _ => abs_nonneg _

/-- Cada coordenada es a lo sumo `d∞` (es un máximo). -/
theorem abs_le_dinf (x y : Fin n → ℝ) (i : Fin n) : |x i - y i| ≤ dinf x y :=
  Finset.le_sup' (fun i => |x i - y i|) (Finset.mem_univ i)

omit [NeZero n] in
/-- Cada coordenada es a lo sumo `d₁` (un sumando de una suma de términos no negativos). -/
theorem abs_le_d1 (x y : Fin n → ℝ) (i : Fin n) : |x i - y i| ≤ d1 x y :=
  Finset.single_le_sum (f := fun i => |x i - y i|) (fun _ _ => abs_nonneg _) (Finset.mem_univ i)

/-- `d∞ ≤ d₂`: cada `|xᵢ - yᵢ| = √((xᵢ - yᵢ)²) ≤ √(∑ⱼ (xⱼ - yⱼ)²)`. -/
theorem dinf_le_d2 (x y : Fin n → ℝ) : dinf x y ≤ d2 x y := by
  apply Finset.sup'_le
  intro i _
  unfold d2
  rw [← Real.sqrt_sq_eq_abs]
  apply Real.sqrt_le_sqrt
  exact Finset.single_le_sum (f := fun j => (x j - y j) ^ 2) (fun _ _ => sq_nonneg _)
    (Finset.mem_univ i)

omit [NeZero n] in
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
theorem d1_le_n_dinf (x y : Fin n → ℝ) : d1 x y ≤ n * dinf x y := by
  calc d1 x y ≤ ∑ _i : Fin n, dinf x y := Finset.sum_le_sum fun i _ => abs_le_dinf x y i
    _ = n * dinf x y := by simp

theorem n_pos : (0 : ℝ) < n := by
  exact_mod_cast Nat.pos_of_ne_zero (NeZero.ne n)

/-- `d₂ ≤ n · d∞` (encadenando). -/
theorem d2_le_n_dinf (x y : Fin n → ℝ) : d2 x y ≤ n * dinf x y :=
  (d2_le_d1 x y).trans (d1_le_n_dinf x y)

/-- `d₁ ≤ n · d₂` (encadenando). -/
theorem d1_le_n_d2 (x y : Fin n → ℝ) : d1 x y ≤ n * d2 x y :=
  (d1_le_n_dinf x y).trans (mul_le_mul_of_nonneg_left (dinf_le_d2 x y) n_pos.le)

/-- **Ej. 12 (a).** `d∞` y `d₂` son equivalentes. -/
theorem equivalentes_dinf_d2 : Equivalentes (dinf (n := n)) d2 :=
  equivalentes_of_le n_pos dinf_le_d2 d2_le_n_dinf

/-- **Ej. 12 (a).** `d₂` y `d₁` son equivalentes. -/
theorem equivalentes_d2_d1 : Equivalentes (d2 (n := n)) d1 :=
  equivalentes_of_le n_pos d2_le_d1 d1_le_n_d2

/-- **Ej. 12 (a).** `d∞` y `d₁` son equivalentes. -/
theorem equivalentes_dinf_d1 : Equivalentes (dinf (n := n)) d1 :=
  equivalentes_of_le n_pos (fun x y => (dinf_le_d2 x y).trans (d2_le_d1 x y)) d1_le_n_dinf

/-- **Ej. 12 (a), resumen.** La cadena completa de desigualdades. -/
theorem cadena (x y : Fin n → ℝ) :
    dinf x y ≤ d2 x y ∧ d2 x y ≤ d1 x y ∧ d1 x y ≤ n * dinf x y :=
  ⟨dinf_le_d2 x y, d2_le_d1 x y, d1_le_n_dinf x y⟩

/-! ## (b) Inclusiones de bolas -/

/-- **Ej. 12 (b).** `B₁(x, r) ⊆ B₂(x, r) ⊆ B∞(x, r) ⊆ B₁(x, n r)`, para todo `r`. -/
theorem bola_inclusiones (x : Fin n → ℝ) (r : ℝ) :
    bola d1 x r ⊆ bola d2 x r ∧ bola d2 x r ⊆ bola dinf x r ∧
      bola dinf x r ⊆ bola d1 x (n * r) := by
  refine ⟨fun y hy => ?_, fun y hy => ?_, fun y hy => ?_⟩
  · exact lt_of_le_of_lt (d2_le_d1 x y) hy
  · exact lt_of_le_of_lt (dinf_le_d2 x y) hy
  · have hy' : dinf x y < r := hy
    calc d1 x y ≤ n * dinf x y := d1_le_n_dinf x y
      _ < n * r := mul_lt_mul_of_pos_left hy' n_pos

end Guias.Guia3.Ej12
