/-
Librería común `Comun`: definiciones del curso y resultados de `apuntes.typ` compartidos por las
guías (`Guias/`), los parciales (`Parciales/`) y los ejemplos (`Ejemplos/`). Ver
`apuntes-agente/lean-lemas-compartidos-y-organizacion.md` para el diseño.

`Comun.Topologia.DistConjuntos`: las tres "distancias" definidas con supremos e ínfimos de
conjuntos de distancias en un espacio métrico `E`:
* el diámetro (Definición 4.9): `distsDiam A = {d(x, y) : x, y ∈ A}` y `diam A = sup`, para `A`
  acotado en el sentido de la Definición 4.8 (`AcotadoMet`, que se llama así para no chocar con el
  `Acotado` de subconjuntos de `ℝ` de `Comun.Supremos`); `diam_mono` y `diam_closure` son la
  **Práctica 3, Ej. 7 (a) y (b)**;
* la distancia de un punto a un conjunto: `distsPunto x A = {d(x, a) : a ∈ A}` y
  `distA x A = ínf`; `abs_distA_sub_le`, `distA_eq_zero_of_mem`, `distA_eq_zero_iff`,
  `isOpen_bolaA`, `isClosed_bolaCerradaA` son la **Práctica 3, Ej. 10 (a)-(e)**;
* la distancia entre dos conjuntos: `distsPar A B = {d(a, b) : a ∈ A, b ∈ B}` y
  `dhat A B = ínf` (la `d̂` del Ej. 11 y la `d̃` de los parciales); `dhat_closure_left`,
  `dhat_eq_zero_of_inter`, `dhat_eq_zero_of_closure_inter` son las partes verdaderas de la
  **Práctica 3, Ej. 11 (a), (b), (c)** (los contraejemplos quedan en `Guias/Guia3/Ej11`).
Como en el curso, el supremo y el ínfimo sólo tienen sentido para conjuntos no vacíos (y acotados):
en Lean `sSup`/`sInf` están siempre definidos y las propiedades útiles (`le_csSup`, `csSup_le`,
`csInf_le`, `le_csInf`) piden esas hipótesis. `closure` es la clausura de Mathlib, leída por bolas
(`Metric.mem_closure_iff`, Definición 4.22).
-/
import Mathlib

namespace Comun

variable {E : Type*} [MetricSpace E]

/-! ## Diámetro (Definición 4.9; Práctica 3, Ej. 7) -/

/-- Definición 4.8: `A` es acotado si existe `C > 0` con `d(x, y) ≤ C` para todo `x, y ∈ A`. -/
def AcotadoMet (A : Set E) : Prop := ∃ C > 0, ∀ x ∈ A, ∀ y ∈ A, dist x y ≤ C

/-- El conjunto `{d(x, y) : x, y ∈ A}` de la Definición 4.9. -/
def distsDiam (A : Set E) : Set ℝ := {r | ∃ x ∈ A, ∃ y ∈ A, r = dist x y}

/-- Definición 4.9: `diam A = sup {d(x, y) : x, y ∈ A}`. -/
noncomputable def diam (A : Set E) : ℝ := sSup (distsDiam A)

theorem distsDiam_nonempty {A : Set E} (hA : A.Nonempty) : (distsDiam A).Nonempty := by
  obtain ⟨x, hx⟩ := hA
  exact ⟨dist x x, x, hx, x, hx, rfl⟩

/-- Un acotado tiene el conjunto de distancias acotado superiormente (Def. 4.8). -/
theorem distsDiam_bddAbove {A : Set E} (hA : AcotadoMet A) : BddAbove (distsDiam A) := by
  obtain ⟨C, -, hC⟩ := hA
  refine ⟨C, ?_⟩
  rintro r ⟨x, hx, y, hy, rfl⟩
  exact hC x hx y hy

/-- Cada distancia entre puntos de `A` es `≤ diam A` (el supremo es cota superior). -/
theorem dist_le_diam {A : Set E} (hA : AcotadoMet A) {x y : E} (hx : x ∈ A) (hy : y ∈ A) :
    dist x y ≤ diam A :=
  le_csSup (distsDiam_bddAbove hA) ⟨x, hx, y, hy, rfl⟩

/-- Si `c` es cota superior de las distancias en `A ≠ ∅`, entonces `diam A ≤ c`
(el supremo es la menor cota superior). -/
theorem diam_le_of_forall {A : Set E} (hA : A.Nonempty) {c : ℝ}
    (h : ∀ x ∈ A, ∀ y ∈ A, dist x y ≤ c) : diam A ≤ c := by
  apply csSup_le (distsDiam_nonempty hA)
  rintro r ⟨x, hx, y, hy, rfl⟩
  exact h x hx y hy

/-- **Práctica 3, Ej. 7 (a).** Si `A ⊆ B` son acotados (`A ≠ ∅`), entonces `diam A ≤ diam B`;
la demostración sigue el texto de `guias-agente/guia_3_resuelta_agente.typ`. -/
theorem diam_mono {A B : Set E} (hA : A.Nonempty) (hB : AcotadoMet B) (hAB : A ⊆ B) :
    diam A ≤ diam B :=
  diam_le_of_forall hA fun _ hx _ hy => dist_le_diam hB (hAB hx) (hAB hy)

/-- Paso clave de (b): si `x, y ∈ cl A` entonces `d(x, y) ≤ diam A`.
Para cada `ε > 0` se eligen `a, b ∈ A` con `d(x, a) < ε/3` y `d(y, b) < ε/3`, y por la
desigualdad triangular `d(x, y) ≤ d(x, a) + d(a, b) + d(b, y) < diam A + ε`. -/
theorem dist_le_diam_of_mem_closure {A : Set E} (hA : AcotadoMet A) {x y : E}
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

/-- **Práctica 3, Ej. 7 (b).** Si `A ≠ ∅` es acotado, `cl A` es acotado y `diam A = diam (cl A)`;
la demostración sigue el texto de `guias-agente/guia_3_resuelta_agente.typ`. -/
theorem diam_closure {A : Set E} (hne : A.Nonempty) (hA : AcotadoMet A) :
    AcotadoMet (closure A) ∧ diam A = diam (closure A) := by
  have hcl : AcotadoMet (closure A) := by
    obtain ⟨C, hC, -⟩ := id hA
    refine ⟨max C (diam A), lt_max_of_lt_left hC, fun x hx y hy => ?_⟩
    exact (dist_le_diam_of_mem_closure hA hx hy).trans (le_max_right _ _)
  refine ⟨hcl, le_antisymm ?_ ?_⟩
  · -- `A ⊆ cl A`: parte (a) con `B = cl A`.
    exact diam_mono hne hcl subset_closure
  · -- `diam (cl A) ≤ diam A`: por el paso clave.
    exact diam_le_of_forall hne.closure fun x hx y hy => dist_le_diam_of_mem_closure hA hx hy

/-! ## Distancia de un punto a un conjunto (Práctica 3, Ej. 10) -/

/-- El conjunto `{d(x, a) : a ∈ A}`. -/
def distsPunto (x : E) (A : Set E) : Set ℝ := {r | ∃ a ∈ A, r = dist x a}

/-- Práctica 3, Ej. 10: `d(x, A) = ínf {d(x, a) : a ∈ A}`. -/
noncomputable def distA (x : E) (A : Set E) : ℝ := sInf (distsPunto x A)

theorem distsPunto_nonempty (x : E) {A : Set E} (hA : A.Nonempty) : (distsPunto x A).Nonempty := by
  obtain ⟨a, ha⟩ := hA
  exact ⟨dist x a, a, ha, rfl⟩

/-- El conjunto de distancias está acotado inferiormente por `0`. -/
theorem distsPunto_bddBelow (x : E) (A : Set E) : BddBelow (distsPunto x A) := by
  refine ⟨0, ?_⟩
  rintro r ⟨a, -, rfl⟩
  exact dist_nonneg

/-- `d(x, A)` es cota inferior: `d(x, A) ≤ d(x, a)` para `a ∈ A`. -/
theorem distA_le {x a : E} {A : Set E} (ha : a ∈ A) : distA x A ≤ dist x a :=
  csInf_le (distsPunto_bddBelow x A) ⟨a, ha, rfl⟩

/-- Es la mayor cota inferior: si `c ≤ d(x, a)` para todo `a ∈ A`, entonces `c ≤ d(x, A)`. -/
theorem le_distA {x : E} {A : Set E} (hA : A.Nonempty) {c : ℝ}
    (h : ∀ a ∈ A, c ≤ dist x a) : c ≤ distA x A := by
  apply le_csInf (distsPunto_nonempty x hA)
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

/-- **Práctica 3, Ej. 10 (a).** `|d(x, A) - d(y, A)| ≤ d(x, y)`; la demostración sigue el texto
de `guias-agente/guia_3_resuelta_agente.typ`. -/
theorem abs_distA_sub_le {A : Set E} (hA : A.Nonempty) (x y : E) :
    |distA x A - distA y A| ≤ dist x y := by
  rw [abs_sub_le_iff]
  have h1 := distA_le_add hA x y
  have h2 := distA_le_add hA y x
  rw [dist_comm y x] at h2
  constructor <;> linarith

/-- **Práctica 3, Ej. 10 (b).** `x ∈ A → d(x, A) = 0`: `0` es cota inferior y `0 = d(x, x)`
es un elemento del conjunto (Proposición 6). -/
theorem distA_eq_zero_of_mem {A : Set E} (hA : A.Nonempty) {x : E} (hx : x ∈ A) :
    distA x A = 0 := by
  apply le_antisymm
  · have := distA_le (x := x) hx
    rwa [dist_self] at this
  · exact distA_nonneg hA

/-- **Práctica 3, Ej. 10 (c).** `d(x, A) = 0 ↔ x ∈ cl A`. Se usa la caracterización por bolas
de la clausura (`Metric.mem_closure_iff`: para todo `ε > 0` hay `a ∈ A` con `d(x, a) < ε`)
y la Proposición 5 (equivalencia de ínfimo) en el sentido que corresponda; la demostración sigue
el texto de `guias-agente/guia_3_resuelta_agente.typ`. -/
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

/-- **Práctica 3, Ej. 10 (d).** `B_A(r) = {x : d(x, A) < r}` es abierto.
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

/-- **Práctica 3, Ej. 10 (e).** `B̄_A(r) = {x : d(x, A) ≤ r}` es cerrado: su complemento
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

/-! ## Distancia entre dos conjuntos (Práctica 3, Ej. 11) -/

/-- El conjunto `{d(a, b) : a ∈ A, b ∈ B}`. -/
def distsPar (A B : Set E) : Set ℝ := {r | ∃ a ∈ A, ∃ b ∈ B, r = dist a b}

/-- Práctica 3, Ej. 11: `d̂(A, B) = ínf {d(a, b) : a ∈ A, b ∈ B}` (la `d̃` de los parciales). -/
noncomputable def dhat (A B : Set E) : ℝ := sInf (distsPar A B)

theorem distsPar_nonempty {A B : Set E} (hA : A.Nonempty) (hB : B.Nonempty) :
    (distsPar A B).Nonempty := by
  obtain ⟨a, ha⟩ := hA
  obtain ⟨b, hb⟩ := hB
  exact ⟨dist a b, a, ha, b, hb, rfl⟩

/-- El conjunto de distancias está acotado inferiormente por `0`. -/
theorem distsPar_bddBelow (A B : Set E) : BddBelow (distsPar A B) := by
  refine ⟨0, ?_⟩
  rintro r ⟨a, -, b, -, rfl⟩
  exact dist_nonneg

/-- `d̂(A, B) ≤ d(a, b)` para `a ∈ A`, `b ∈ B` (el ínfimo es cota inferior). -/
theorem dhat_le {A B : Set E} {a b : E} (ha : a ∈ A) (hb : b ∈ B) : dhat A B ≤ dist a b :=
  csInf_le (distsPar_bddBelow A B) ⟨a, ha, b, hb, rfl⟩

/-- El ínfimo es la mayor cota inferior. -/
theorem le_dhat {A B : Set E} (hA : A.Nonempty) (hB : B.Nonempty) {c : ℝ}
    (h : ∀ a ∈ A, ∀ b ∈ B, c ≤ dist a b) : c ≤ dhat A B := by
  apply le_csInf (distsPar_nonempty hA hB)
  rintro r ⟨a, ha, b, hb, rfl⟩
  exact h a ha b hb

theorem dhat_nonneg {A B : Set E} (hA : A.Nonempty) (hB : B.Nonempty) : 0 ≤ dhat A B :=
  le_dhat hA hB fun _ _ _ _ => dist_nonneg

/-- `d̂` es simétrica: la propiedad (iii) de la Definición 4.1 sí vale. -/
theorem dhat_comm (A B : Set E) : dhat A B = dhat B A := by
  have : distsPar A B = distsPar B A := by
    ext r
    constructor
    · rintro ⟨a, ha, b, hb, rfl⟩
      exact ⟨b, hb, a, ha, dist_comm a b⟩
    · rintro ⟨b, hb, a, ha, rfl⟩
      exact ⟨a, ha, b, hb, dist_comm b a⟩
  unfold dhat
  rw [this]

/-- **Práctica 3, Ej. 11 (a).** VERDADERA: `d̂(A, B) = d̂(cl A, B)` para `A, B ≠ ∅` en todo
espacio métrico; la demostración sigue el texto de `guias-agente/guia_3_resuelta_agente.typ`.

`(≥)`: `A ⊆ cl A` y el ínfimo sobre un conjunto mayor es menor. `(≤)`: si `x ∈ cl A`, `b ∈ B`,
para `ε > 0` hay `a ∈ A` con `d(x, a) < ε`, y `d̂(A, B) ≤ d(a, b) ≤ d(a, x) + d(x, b) < ε + d(x, b)`;
luego `d̂(A, B) ≤ d(x, b)` y `d̂(A, B)` es cota inferior de las distancias de `(cl A, B)`. -/
theorem dhat_closure_left {A B : Set E} (hA : A.Nonempty) (hB : B.Nonempty) :
    dhat A B = dhat (closure A) B := by
  apply le_antisymm
  · apply le_dhat hA.closure hB
    intro x hx b hb
    apply le_of_forall_pos_le_add
    intro ε hε
    obtain ⟨a, ha, hxa⟩ := Metric.mem_closure_iff.1 hx ε hε
    have h1 : dhat A B ≤ dist a b := dhat_le ha hb
    have h2 : dist a b ≤ dist a x + dist x b := dist_triangle _ _ _
    rw [dist_comm a x] at h2
    linarith
  · -- `d̂(cl A, B) ≤ d̂(A, B)`: `d̂(cl A, B)` es cota inferior de las distancias de `(A, B)`.
    exact le_dhat hA hB fun a ha b hb => dhat_le (subset_closure ha) hb

/-- **Práctica 3, Ej. 11 (b), ida `⇐` (cierta en todo `E`).** Si `A ∩ B ≠ ∅` entonces
`d̂(A, B) = 0`: si `x ∈ A ∩ B`, `0 ≤ d̂(A, B) ≤ d(x, x) = 0`. -/
theorem dhat_eq_zero_of_inter {A B : Set E} (hA : A.Nonempty) (hB : B.Nonempty)
    (h : (A ∩ B).Nonempty) : dhat A B = 0 := by
  obtain ⟨x, hxA, hxB⟩ := h
  apply le_antisymm _ (dhat_nonneg hA hB)
  have := dhat_le hxA hxB
  rwa [dist_self] at this

/-- Si para todo `ε > 0` hay `a ∈ A`, `b ∈ B` con `d(a, b) < ε`, entonces `d̂(A, B) = 0`. -/
theorem dhat_eq_zero_of_approx {A B : Set E} (hA : A.Nonempty) (hB : B.Nonempty)
    (h : ∀ ε > 0, ∃ a ∈ A, ∃ b ∈ B, dist a b < ε) : dhat A B = 0 := by
  apply le_antisymm _ (dhat_nonneg hA hB)
  apply le_of_forall_pos_le_add
  intro ε hε
  obtain ⟨a, ha, b, hb, hab⟩ := h ε hε
  have := dhat_le ha hb
  linarith

/-- **Práctica 3, Ej. 11 (c), ida `⇐` (cierta en todo `E`).** Si `x ∈ cl A ∩ cl B` entonces
`d̂(A, B) = 0`: para `ε > 0` hay `a ∈ A`, `b ∈ B` con `d(x, a), d(x, b) < ε/2`, así que
`d(a, b) < ε`. -/
theorem dhat_eq_zero_of_closure_inter {A B : Set E} (hA : A.Nonempty) (hB : B.Nonempty)
    (h : (closure A ∩ closure B).Nonempty) : dhat A B = 0 := by
  obtain ⟨x, hxA, hxB⟩ := h
  apply dhat_eq_zero_of_approx hA hB
  intro ε hε
  obtain ⟨a, ha, hxa⟩ := Metric.mem_closure_iff.1 hxA (ε / 2) (by positivity)
  obtain ⟨b, hb, hxb⟩ := Metric.mem_closure_iff.1 hxB (ε / 2) (by positivity)
  refine ⟨a, ha, b, hb, ?_⟩
  have h2 : dist a b ≤ dist a x + dist x b := dist_triangle _ _ _
  rw [dist_comm a x] at h2
  linarith

end Comun
