/-
Análisis Avanzado (FCEN-UBA) · Práctica 1 · Ejercicio 9
Enunciado en `apuntes-typst/guias/p1.typ`; resolución en
`apuntes-typst/guias-agente/guia_1_resuelta_agente.typ` (Ejercicio 9).

Suma de límites `x_n + y_n → ℓ₁ + ℓ₂` en cuatro casos, todo desplegando las Definiciones 7 y 8:
  (a) `ℓ₁, ℓ₂ ∈ ℝ`: `ε/2 + ε/2` con `n₀ = máx(n₁, n₂)`. Es el ítem b de la Proposición 6
      (Álgebra de límites), que `apuntes.typ` deja como ejercicio: NO se usa
      `algebra_limites_add` ni `Filter.Tendsto.add`.
  (b) `ℓ₁ ∈ ℝ`, `ℓ₂ = +∞`: `x_n > ℓ₁ - 1` desde `n₁` (con `ε = 1`) y `y_n > M'` desde `n₂`,
      con `M' = máx(M + 1 - ℓ₁, 1) > 0` (hace falta `M' > 0` para la Definición 8).
  (c) `ℓ₁ = ℓ₂ = +∞`: `M/2` para cada una.
  (d) `ℓ₁ = +∞`, `ℓ₂ = -∞`: no se puede decir nada. Tres pares de contraejemplos:
      `(n, -n)` suma `0` (converge), `(2n, -n)` suma `n` (→ +∞), `(n, -2n)` suma `-n` (→ -∞).
      Que `n → +∞` es el Teorema 1 (`arquimedes`); los índices empiezan en `0`, lo que no
      cambia nada.
-/
import Mathlib
import Guias.Guia1.Defs

namespace Guias.Guia1.Ej09

open Guias.Guia1

/-! ## (a) `ℓ₁, ℓ₂ ∈ ℝ` -/

/-- **Ej. 9 (a).** Dado `ε > 0`, `n₁` para `x_n` con `ε/2`, `n₂` para `y_n` con `ε/2`,
`n₀ = máx(n₁, n₂)`, y la desigualdad triangular. -/
theorem ej9a {x y : ℕ → ℝ} {l₁ l₂ : ℝ} (hx : Converge x l₁) (hy : Converge y l₂) :
    Converge (fun n => x n + y n) (l₁ + l₂) := by
  intro ε hε
  obtain ⟨n₁, hn₁⟩ := hx (ε / 2) (by positivity)
  obtain ⟨n₂, hn₂⟩ := hy (ε / 2) (by positivity)
  refine ⟨max n₁ n₂, fun n hn => ?_⟩
  have h1 := hn₁ n (le_trans (le_max_left _ _) hn)
  have h2 := hn₂ n (le_trans (le_max_right _ _) hn)
  calc |x n + y n - (l₁ + l₂)| = |(x n - l₁) + (y n - l₂)| := by ring_nf
    _ ≤ |x n - l₁| + |y n - l₂| := abs_add_le _ _
    _ < ε / 2 + ε / 2 := by linarith
    _ = ε := by ring

/-! ## (b) `ℓ₁ ∈ ℝ`, `ℓ₂ = +∞` -/

/-- **Ej. 9 (b).** Dado `M > 0`: con `ε = 1` hay `n₁` con `x_n > ℓ₁ - 1` para `n ≥ n₁`; con
`M' = máx(M + 1 - ℓ₁, 1) > 0` hay `n₂` con `y_n > M' ≥ M + 1 - ℓ₁` para `n ≥ n₂`. Para
`n ≥ máx(n₁, n₂)`, `x_n + y_n > (ℓ₁ - 1) + (M + 1 - ℓ₁) = M`. -/
theorem ej9b {x y : ℕ → ℝ} {l₁ : ℝ} (hx : Converge x l₁) (hy : DivergeMasInf y) :
    DivergeMasInf (fun n => x n + y n) := by
  intro M hM
  obtain ⟨n₁, hn₁⟩ := hx 1 one_pos
  have hM' : (0 : ℝ) < max (M + 1 - l₁) 1 := lt_of_lt_of_le one_pos (le_max_right _ _)
  obtain ⟨n₂, hn₂⟩ := hy (max (M + 1 - l₁) 1) hM'
  refine ⟨max n₁ n₂, fun n hn => ?_⟩
  have h1 := (abs_lt.1 (hn₁ n (le_trans (le_max_left _ _) hn))).1
  have h2 := hn₂ n (le_trans (le_max_right _ _) hn)
  have h3 := le_max_left (M + 1 - l₁) 1
  show M < x n + y n
  linarith

/-! ## (c) `ℓ₁ = ℓ₂ = +∞` -/

/-- **Ej. 9 (c).** Dado `M > 0`, `M/2 > 0`: `x_n > M/2` desde `n₁`, `y_n > M/2` desde `n₂`, y
`x_n + y_n > M` desde `máx(n₁, n₂)`. -/
theorem ej9c {x y : ℕ → ℝ} (hx : DivergeMasInf x) (hy : DivergeMasInf y) :
    DivergeMasInf (fun n => x n + y n) := by
  intro M hM
  obtain ⟨n₁, hn₁⟩ := hx (M / 2) (by positivity)
  obtain ⟨n₂, hn₂⟩ := hy (M / 2) (by positivity)
  refine ⟨max n₁ n₂, fun n hn => ?_⟩
  have h1 := hn₁ n (le_trans (le_max_left _ _) hn)
  have h2 := hn₂ n (le_trans (le_max_right _ _) hn)
  show M < x n + y n
  linarith

/-! ## (d) `ℓ₁ = +∞`, `ℓ₂ = -∞`: contraejemplos -/

/-- Hecho auxiliar (Teorema 1): dado `M > 0` hay `n₀` con `M < n` para todo `n ≥ n₀`
(se aplica Arquímedes a `M + 1`). -/
theorem exists_nat_gt_of_ge {M : ℝ} (_ : 0 < M) : ∃ n₀ : ℕ, ∀ n ≥ n₀, M < n := by
  obtain ⟨n₀, hn₀⟩ := arquimedes (M + 1)
  refine ⟨n₀, fun n hn => ?_⟩
  have : (n₀ : ℝ) ≤ n := by exact_mod_cast hn
  linarith

/-- `x_n = n → +∞` (Teorema 1). -/
theorem divergeMasInf_id : DivergeMasInf (fun n : ℕ => (n : ℝ)) := by
  intro M hM
  obtain ⟨n₀, hn₀⟩ := exists_nat_gt_of_ge hM
  exact ⟨n₀, fun n hn => hn₀ n hn⟩

/-- `x_n = 2n → +∞`: `2n ≥ n > M`. -/
theorem divergeMasInf_two_mul : DivergeMasInf (fun n : ℕ => 2 * (n : ℝ)) := by
  intro M hM
  obtain ⟨n₀, hn₀⟩ := exists_nat_gt_of_ge hM
  refine ⟨n₀, fun n hn => ?_⟩
  have := hn₀ n hn
  show M < 2 * (n : ℝ)
  linarith

/-- `y_n = -n → -∞`: `-n < -M`. -/
theorem divergeMenosInf_neg_id : DivergeMenosInf (fun n : ℕ => -(n : ℝ)) := by
  intro M hM
  obtain ⟨n₀, hn₀⟩ := exists_nat_gt_of_ge hM
  refine ⟨n₀, fun n hn => ?_⟩
  have := hn₀ n hn
  show -(n : ℝ) < -M
  linarith

/-- `y_n = -2n → -∞`: `-2n ≤ -n < -M`. -/
theorem divergeMenosInf_neg_two_mul : DivergeMenosInf (fun n : ℕ => -(2 * (n : ℝ))) := by
  intro M hM
  obtain ⟨n₀, hn₀⟩ := exists_nat_gt_of_ge hM
  refine ⟨n₀, fun n hn => ?_⟩
  have := hn₀ n hn
  show -(2 * (n : ℝ)) < -M
  linarith

/-- La sucesión constante `0` converge a `0`. -/
theorem converge_zero : Converge (fun _ : ℕ => (0 : ℝ)) 0 := by
  intro ε hε
  exact ⟨0, fun n _ => by simp [hε]⟩

/-- **Ej. 9 (d), primer par.** `x_n = n → +∞`, `y_n = -n → -∞`, y `x_n + y_n = 0 → 0`:
la suma converge. -/
theorem ej9d_converge :
    ∃ x y : ℕ → ℝ, DivergeMasInf x ∧ DivergeMenosInf y ∧ Converge (fun n => x n + y n) 0 := by
  refine ⟨fun n => (n : ℝ), fun n => -(n : ℝ), divergeMasInf_id, divergeMenosInf_neg_id, ?_⟩
  have h : (fun n : ℕ => (n : ℝ) + -(n : ℝ)) = fun _ => 0 := by
    funext n
    ring
  rw [h]
  exact converge_zero

/-- **Ej. 9 (d), segundo par.** `x_n = 2n → +∞`, `y_n = -n → -∞`, y `x_n + y_n = n → +∞`. -/
theorem ej9d_masInf :
    ∃ x y : ℕ → ℝ, DivergeMasInf x ∧ DivergeMenosInf y ∧ DivergeMasInf (fun n => x n + y n) := by
  refine ⟨fun n => 2 * (n : ℝ), fun n => -(n : ℝ), divergeMasInf_two_mul,
    divergeMenosInf_neg_id, ?_⟩
  have h : (fun n : ℕ => 2 * (n : ℝ) + -(n : ℝ)) = fun n : ℕ => (n : ℝ) := by
    funext n
    ring
  rw [h]
  exact divergeMasInf_id

/-- **Ej. 9 (d), tercer par.** `x_n = n → +∞`, `y_n = -2n → -∞`, y `x_n + y_n = -n → -∞`. -/
theorem ej9d_menosInf :
    ∃ x y : ℕ → ℝ, DivergeMasInf x ∧ DivergeMenosInf y ∧
      DivergeMenosInf (fun n => x n + y n) := by
  refine ⟨fun n => (n : ℝ), fun n => -(2 * (n : ℝ)), divergeMasInf_id,
    divergeMenosInf_neg_two_mul, ?_⟩
  have h : (fun n : ℕ => (n : ℝ) + -(2 * (n : ℝ))) = fun n : ℕ => -(n : ℝ) := by
    funext n
    ring
  rw [h]
  exact divergeMenosInf_neg_id

end Guias.Guia1.Ej09
