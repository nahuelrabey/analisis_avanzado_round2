/-
Análisis Avanzado (FCEN-UBA) · Práctica 3 · Ejercicio 10 (distancia de un punto a un conjunto).
Enunciado en `apuntes-typst/guias/p3.typ`; resolución en `apuntes-typst/guias-agente/_partes/ej10.typ`.

Sea `A ⊆ E` no vacío y `d(x, A) = ínf {d(x, a) : a ∈ A}` (`distA`, con `sInf`). Se prueba, para
todos `x, y ∈ E` y `r`:
(a) `|d(x, A) - d(y, A)| ≤ d(x, y)`;
(b) `x ∈ A → d(x, A) = 0`;
(c) `d(x, A) = 0 ↔ x ∈ cl A`;
(d) `B_A(r) = {x : d(x, A) < r}` es abierto;
(e) `B̄_A(r) = {x : d(x, A) ≤ r}` es cerrado.

El ínfimo existe porque el conjunto de distancias es no vacío y está acotado inferiormente por
`0` (Teorema 2, completitud en términos de ínfimos); en Lean, `sInf` está siempre definido y
las propiedades útiles (`csInf_le`, `le_csInf`) piden esas dos hipótesis.
-/
import Mathlib

namespace Guias.Guia3.Ej10

variable {E : Type*} [MetricSpace E]

/-- El conjunto `{d(x, a) : a ∈ A}`. -/
def distancias (x : E) (A : Set E) : Set ℝ := {r | ∃ a ∈ A, r = dist x a}

/-- Ejercicio 10: `d(x, A) = ínf {d(x, a) : a ∈ A}`. -/
noncomputable def distA (x : E) (A : Set E) : ℝ := sInf (distancias x A)

theorem distancias_nonempty (x : E) {A : Set E} (hA : A.Nonempty) : (distancias x A).Nonempty := by
  obtain ⟨a, ha⟩ := hA
  exact ⟨dist x a, a, ha, rfl⟩

/-- El conjunto de distancias está acotado inferiormente por `0`. -/
theorem distancias_bddBelow (x : E) (A : Set E) : BddBelow (distancias x A) := by
  refine ⟨0, ?_⟩
  rintro r ⟨a, -, rfl⟩
  exact dist_nonneg

/-- `d(x, A)` es cota inferior: `d(x, A) ≤ d(x, a)` para `a ∈ A`. -/
theorem distA_le {x a : E} {A : Set E} (ha : a ∈ A) : distA x A ≤ dist x a :=
  csInf_le (distancias_bddBelow x A) ⟨a, ha, rfl⟩

/-- Es la mayor cota inferior: si `c ≤ d(x, a)` para todo `a ∈ A`, entonces `c ≤ d(x, A)`. -/
theorem le_distA {x : E} {A : Set E} (hA : A.Nonempty) {c : ℝ}
    (h : ∀ a ∈ A, c ≤ dist x a) : c ≤ distA x A := by
  apply le_csInf (distancias_nonempty x hA)
  rintro r ⟨a, ha, rfl⟩
  exact h a ha

theorem distA_nonneg {x : E} {A : Set E} (hA : A.Nonempty) : 0 ≤ distA x A :=
  le_distA hA fun _ _ => dist_nonneg

/-- Cota de un lado de (a): `d(x, A) ≤ d(x, y) + d(y, A)`. Para `a ∈ A`,
`d(x, A) ≤ d(x, a) ≤ d(x, y) + d(y, a)`, o sea `d(x, A) - d(x, y) ≤ d(y, a)` para todo
`a ∈ A`; luego `d(x, A) - d(x, y)` es cota inferior de `{d(y, a)}` y es `≤ d(y, A)`. -/
theorem distA_le_add {A : Set E} (hA : A.Nonempty) (x y : E) :
    distA x A ≤ dist x y + distA y A := by
  have h : distA x A - dist x y ≤ distA y A := by
    apply le_distA hA
    intro a ha
    have h1 : distA x A ≤ dist x a := distA_le ha
    have h2 : dist x a ≤ dist x y + dist y a := dist_triangle _ _ _
    linarith
  linarith

/-- **Ejercicio 10 (a).** `|d(x, A) - d(y, A)| ≤ d(x, y)`. -/
theorem abs_distA_sub_le {A : Set E} (hA : A.Nonempty) (x y : E) :
    |distA x A - distA y A| ≤ dist x y := by
  rw [abs_sub_le_iff]
  have h1 := distA_le_add hA x y
  have h2 := distA_le_add hA y x
  rw [dist_comm y x] at h2
  constructor <;> linarith

/-- **Ejercicio 10 (b).** `x ∈ A → d(x, A) = 0`: `0` es cota inferior y `0 = d(x, x)`
es un elemento del conjunto (Proposición 6). -/
theorem distA_eq_zero_of_mem {A : Set E} (hA : A.Nonempty) {x : E} (hx : x ∈ A) :
    distA x A = 0 := by
  apply le_antisymm
  · have := distA_le (x := x) hx
    rwa [dist_self] at this
  · exact distA_nonneg hA

/-- **Ejercicio 10 (c).** `d(x, A) = 0 ↔ x ∈ cl A`. Se usa la caracterización por bolas
de la clausura (`Metric.mem_closure_iff`: para todo `ε > 0` hay `a ∈ A` con `d(x, a) < ε`)
y la Proposición 5 (equivalencia de ínfimo) en el sentido que corresponda. -/
theorem distA_eq_zero_iff {A : Set E} (hA : A.Nonempty) (x : E) :
    distA x A = 0 ↔ x ∈ closure A := by
  rw [Metric.mem_closure_iff]
  constructor
  · -- (⇒) `ínf = 0`: para `ε > 0`, `ε` no es cota inferior, así que hay `a` con `d(x, a) < ε`.
    intro h ε hε
    by_contra hcon
    push Not at hcon
    have : ε ≤ distA x A := le_distA hA fun a ha => hcon a ha
    linarith
  · -- (⇐) `d(x, A) ≤ d(x, a) < ε` para todo `ε > 0`; luego `d(x, A) ≤ 0`.
    intro h
    apply le_antisymm _ (distA_nonneg hA)
    apply le_of_forall_pos_le_add
    intro ε hε
    obtain ⟨a, ha, hxa⟩ := h ε hε
    have := distA_le (x := x) ha
    linarith

/-- **Ejercicio 10 (d).** `B_A(r) = {x : d(x, A) < r}` es abierto.
Si `d(x, A) < r`, con `ρ = r - d(x, A)` vale `B(x, ρ) ⊆ B_A(r)` por (a). -/
theorem isOpen_bolaA {A : Set E} (hA : A.Nonempty) (r : ℝ) :
    IsOpen {x : E | distA x A < r} := by
  rw [Metric.isOpen_iff]
  intro x hx
  have hx' : distA x A < r := hx
  refine ⟨r - distA x A, by linarith, fun y hy => ?_⟩
  have hy' : dist y x < r - distA x A := Metric.mem_ball.1 hy
  have h := abs_distA_sub_le hA y x
  have h' := (abs_sub_le_iff.1 h).1
  show distA y A < r
  linarith

/-- **Ejercicio 10 (e).** `B̄_A(r) = {x : d(x, A) ≤ r}` es cerrado: su complemento
`{x : d(x, A) > r}` es abierto. Si `d(x, A) > r`, con `ρ = d(x, A) - r` vale
`B(x, ρ) ⊆ {d(·, A) > r}` por (a). -/
theorem isClosed_bolaCerradaA {A : Set E} (hA : A.Nonempty) (r : ℝ) :
    IsClosed {x : E | distA x A ≤ r} := by
  rw [← isOpen_compl_iff, Metric.isOpen_iff]
  intro x hx
  have hx' : r < distA x A := by
    have : ¬ distA x A ≤ r := hx
    linarith
  refine ⟨distA x A - r, by linarith, fun y hy => ?_⟩
  have hy' : dist y x < distA x A - r := Metric.mem_ball.1 hy
  have h := abs_distA_sub_le hA x y
  have h' := (abs_sub_le_iff.1 h).1
  rw [dist_comm] at hy'
  show ¬ distA y A ≤ r
  intro hle
  linarith

end Guias.Guia3.Ej10
