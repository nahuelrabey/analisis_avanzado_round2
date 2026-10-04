/-
Práctica 3 · Ejercicio 14 (`apuntes-typst/guias/p3.typ`); resolución en
`apuntes-typst/guias-agente/guia_3_resuelta_agente.typ` (Ejercicio 14).

Pruebe que `(ℝⁿ, d₁)`, `(ℝⁿ, d₂)` y `(ℝⁿ, d∞)` son completos.

Formalización fiel al texto, sin instancias: trabajamos con las funciones de distancia
explícitas `d₁, d₂, d∞ : (Fin n → ℝ) → (Fin n → ℝ) → ℝ` **del Ejercicio 12** (importado, para
que sean los mismos objetos del Ej. 1 (d) y del Ej. 12) y con la Definición 4.55 de
`apuntes.typ` ("toda sucesión de Cauchy tiene límite") escrita con `ε`-`N` (Definiciones 4.42 y
4.51). No se usa que Mathlib ya tenga `CompleteSpace` para `PiLp`/`EuclideanSpace`.

Convención: `n ≥ 1` (`[NeZero n]`) y las sucesiones empiezan en `0` (en el curso, en `1`).

Estructura (la misma que el texto Typst):
1. `d∞`: prueba por coordenadas del Corolario 4.58 y completitud de `ℝ` (Teorema 4.57).
2. Desigualdades `d∞ ≤ d₂ ≤ d₁ ≤ n d∞`: son `Ej12.dinf_le_d2`, `Ej12.d2_le_d1`,
   `Ej12.d1_le_n_dinf` (Ej. 12 (a), como cita el texto).
3. Lema: si `d∞ ≤ d ≤ n d∞`, y `(ℝⁿ, d∞)` es completo, entonces `(ℝⁿ, d)` es completo.
4. Se aplica el lema a `d₁` y a `d₂`.
-/
import Mathlib
import Guias.Guia3.Ej12

open Filter Topology
open Guias.Guia3.Ej12 (d1 d2 dinf abs_le_dinf dinf_le_d2 d2_le_d1 d1_le_n_dinf d2_le_n_dinf)

namespace Guias.Guia3.Ej14

variable {n : ℕ}

/-! ### Definición 4.55: completitud, con `ε`-`N` -/

/-- Definición 4.51: `(xₖ)` es de Cauchy para `d`. -/
def EsCauchy {X : Type*} (d : X → X → ℝ) (x : ℕ → X) : Prop :=
  ∀ ε > 0, ∃ N : ℕ, ∀ k ≥ N, ∀ j ≥ N, d (x k) (x j) < ε

/-- Definición 4.42: `xₖ → l` para `d`. -/
def Converge {X : Type*} (d : X → X → ℝ) (x : ℕ → X) (l : X) : Prop :=
  ∀ ε > 0, ∃ N : ℕ, ∀ k ≥ N, d (x k) l < ε

/-- Definición 4.55: `(X, d)` es completo si toda sucesión de Cauchy tiene límite. -/
def EsCompleto {X : Type*} (d : X → X → ℝ) : Prop :=
  ∀ x : ℕ → X, EsCauchy d x → ∃ l, Converge d x l

/-! ### Cotas elementales para `d∞` (un máximo sobre `n ≥ 1` índices) -/

/-- Si todas las coordenadas están acotadas por `c`, entonces `d∞(x, y) ≤ c`. -/
theorem dinf_le [NeZero n] (x y : Fin n → ℝ) (c : ℝ) (h : ∀ i, |x i - y i| ≤ c) :
    dinf x y ≤ c :=
  Finset.sup'_le _ _ fun i _ => h i

/-- `d∞ ≤ d₁` (consecuencia de `d∞ ≤ d₂ ≤ d₁`, Ej. 12 (a)). -/
theorem dinf_le_d1 [NeZero n] (x y : Fin n → ℝ) : dinf x y ≤ d1 x y :=
  (dinf_le_d2 x y).trans (d2_le_d1 x y)

/-! ### `(ℝⁿ, d∞)` es completo: Corolario 4.58 -/

/-- **Ejercicio 14, caso `d∞`** (prueba por coordenadas del Corolario 4.58). -/
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

/-! ### Lema: métricas equivalentes a `d∞` heredan la completitud -/

/-- Si `d∞ ≤ d ≤ n d∞` y `(ℝⁿ, d∞)` es completo, entonces `(ℝⁿ, d)` es completo: una `d`-Cauchy
es `d∞`-Cauchy, converge en `d∞` a un `l`, y `d(xₖ, l) ≤ n d∞(xₖ, l)` tiende a `0`. -/
theorem completo_of_equiv [NeZero n] (d : (Fin n → ℝ) → (Fin n → ℝ) → ℝ)
    (hlow : ∀ x y, dinf x y ≤ d x y) (hup : ∀ x y, d x y ≤ n * dinf x y) :
    EsCompleto d := by
  intro x hx
  -- `d`-Cauchy ⇒ `d∞`-Cauchy
  have hx' : EsCauchy dinf x := by
    intro ε hε
    obtain ⟨N, hN⟩ := hx ε hε
    exact ⟨N, fun k hk j hj => lt_of_le_of_lt (hlow _ _) (hN k hk j hj)⟩
  obtain ⟨l, hl⟩ := completo_dinf x hx'
  refine ⟨l, fun ε hε => ?_⟩
  have hnpos : (0 : ℝ) < n := by exact_mod_cast Nat.pos_of_neZero n
  obtain ⟨N, hN⟩ := hl (ε / n) (div_pos hε hnpos)
  refine ⟨N, fun k hk => ?_⟩
  calc d (x k) l ≤ n * dinf (x k) l := hup _ _
    _ < n * (ε / n) := mul_lt_mul_of_pos_left (hN k hk) hnpos
    _ = ε := by field_simp

/-! ### Los tres casos -/

/-- **Ejercicio 14, caso `d₁`.** -/
theorem completo_d1 [NeZero n] : EsCompleto (d1 (n := n)) :=
  completo_of_equiv d1 dinf_le_d1 d1_le_n_dinf

/-- **Ejercicio 14, caso `d₂`.** -/
theorem completo_d2 [NeZero n] : EsCompleto (d2 (n := n)) :=
  completo_of_equiv d2 dinf_le_d2 d2_le_n_dinf

/-- **Ejercicio 14.** `(ℝⁿ, d₁)`, `(ℝⁿ, d₂)` y `(ℝⁿ, d∞)` son completos. -/
theorem ej14 [NeZero n] :
    EsCompleto (d1 (n := n)) ∧ EsCompleto (d2 (n := n)) ∧ EsCompleto (dinf (n := n)) :=
  ⟨completo_d1, completo_d2, completo_dinf⟩

end Guias.Guia3.Ej14
