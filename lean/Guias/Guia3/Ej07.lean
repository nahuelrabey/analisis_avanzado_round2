/-
Análisis Avanzado (FCEN-UBA) · Práctica 3 · Ejercicio 7 (diámetro).
Enunciado en `apuntes-typst/guias/p3.typ`; resolución en `apuntes-typst/guias-agente/_partes/ej07.typ`.

Sea `E` un espacio métrico y `A, B ⊆ E` acotados.
(a) Si `A ⊆ B` entonces `diam A ≤ diam B`.
(b) `diam A = diam (cl A)`.

El diámetro se define como en la Definición 4.9 de `apuntes.typ`:
`diam A = sup {d(x, y) : x, y ∈ A}`, con `sSup` del conjunto de distancias. Como la definición
del curso sólo tiene sentido para `A ≠ ∅` (el supremo de un conjunto vacío no está definido),
se pide `A.Nonempty`. `closure` es la clausura de Mathlib, pero las pruebas pasan por su
caracterización por bolas (`Metric.mem_closure_iff`, Definición 4.22).
-/
import Mathlib

namespace Guias.Guia3.Ej07

variable {E : Type*} [MetricSpace E]

/-- Definición 4.8: `A` es acotado si existe `C > 0` con `d(x, y) ≤ C` para todo `x, y ∈ A`. -/
def Acotado (A : Set E) : Prop := ∃ C > 0, ∀ x ∈ A, ∀ y ∈ A, dist x y ≤ C

/-- El conjunto `{d(x, y) : x, y ∈ A}` de la Definición 4.9. -/
def distancias (A : Set E) : Set ℝ := {r | ∃ x ∈ A, ∃ y ∈ A, r = dist x y}

/-- Definición 4.9: `diam A = sup {d(x, y) : x, y ∈ A}`. -/
noncomputable def diam (A : Set E) : ℝ := sSup (distancias A)

theorem distancias_nonempty {A : Set E} (hA : A.Nonempty) : (distancias A).Nonempty := by
  obtain ⟨x, hx⟩ := hA
  exact ⟨dist x x, x, hx, x, hx, rfl⟩

/-- Un acotado tiene el conjunto de distancias acotado superiormente (Def. 4.8). -/
theorem distancias_bddAbove {A : Set E} (hA : Acotado A) : BddAbove (distancias A) := by
  obtain ⟨C, -, hC⟩ := hA
  refine ⟨C, ?_⟩
  rintro r ⟨x, hx, y, hy, rfl⟩
  exact hC x hx y hy

/-- Cada distancia entre puntos de `A` es `≤ diam A` (el supremo es cota superior). -/
theorem dist_le_diam {A : Set E} (hA : Acotado A) {x y : E} (hx : x ∈ A) (hy : y ∈ A) :
    dist x y ≤ diam A :=
  le_csSup (distancias_bddAbove hA) ⟨x, hx, y, hy, rfl⟩

/-- Si `c` es cota superior de las distancias en `A ≠ ∅`, entonces `diam A ≤ c`
(el supremo es la menor cota superior). -/
theorem diam_le_of_forall {A : Set E} (hA : A.Nonempty) {c : ℝ}
    (h : ∀ x ∈ A, ∀ y ∈ A, dist x y ≤ c) : diam A ≤ c := by
  apply csSup_le (distancias_nonempty hA)
  rintro r ⟨x, hx, y, hy, rfl⟩
  exact h x hx y hy

/-- **Ejercicio 7 (a).** Si `A ⊆ B` son acotados (`A ≠ ∅`), entonces `diam A ≤ diam B`. -/
theorem diam_mono {A B : Set E} (hA : A.Nonempty) (hB : Acotado B) (hAB : A ⊆ B) :
    diam A ≤ diam B :=
  diam_le_of_forall hA fun _ hx _ hy => dist_le_diam hB (hAB hx) (hAB hy)

/-- Paso clave de (b): si `x, y ∈ cl A` entonces `d(x, y) ≤ diam A`.
Para cada `ε > 0` se eligen `a, b ∈ A` con `d(x, a) < ε/3` y `d(y, b) < ε/3`, y por la
desigualdad triangular `d(x, y) ≤ d(x, a) + d(a, b) + d(b, y) < diam A + ε`. -/
theorem dist_le_diam_of_mem_closure {A : Set E} (hA : Acotado A) {x y : E}
    (hx : x ∈ closure A) (hy : y ∈ closure A) : dist x y ≤ diam A := by
  apply le_of_forall_pos_le_add
  intro ε hε
  obtain ⟨a, ha, hxa⟩ := Metric.mem_closure_iff.1 hx (ε / 3) (by positivity)
  obtain ⟨b, hb, hyb⟩ := Metric.mem_closure_iff.1 hy (ε / 3) (by positivity)
  have hab : dist a b ≤ diam A := dist_le_diam hA ha hb
  have h1 : dist x y ≤ dist x a + dist a b + dist b y :=
    calc dist x y ≤ dist x a + dist a y := dist_triangle _ _ _
      _ ≤ dist x a + (dist a b + dist b y) := by gcongr; exact dist_triangle _ _ _
      _ = dist x a + dist a b + dist b y := by ring
  rw [dist_comm b y] at h1
  linarith

/-- **Ejercicio 7 (b).** Si `A ≠ ∅` es acotado, `cl A` es acotado y `diam A = diam (cl A)`. -/
theorem diam_closure {A : Set E} (hne : A.Nonempty) (hA : Acotado A) :
    Acotado (closure A) ∧ diam A = diam (closure A) := by
  have hcl : Acotado (closure A) := by
    obtain ⟨C, hC, -⟩ := id hA
    refine ⟨max C (diam A), lt_max_of_lt_left hC, fun x hx y hy => ?_⟩
    exact (dist_le_diam_of_mem_closure hA hx hy).trans (le_max_right _ _)
  refine ⟨hcl, le_antisymm ?_ ?_⟩
  · -- `A ⊆ cl A`: parte (a) con `B = cl A`.
    exact diam_mono hne hcl subset_closure
  · -- `diam (cl A) ≤ diam A`: por el paso clave.
    exact diam_le_of_forall hne.closure fun x hx y hy => dist_le_diam_of_mem_closure hA hx hy

end Guias.Guia3.Ej07
