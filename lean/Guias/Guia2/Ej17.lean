/-
Análisis Avanzado (FCEN-UBA) · Práctica 2 · Ejercicio 17
Enunciado en `apuntes-typst/guias/p2.typ`; resolución en
`apuntes-typst/guias-agente/guia_2_resuelta_agente.typ` (Ejercicio 17).

  (a) Una familia `{A_i}_{i ∈ I}` de intervalos de `ℝ`, disjuntos dos a dos y con `#A_i > 1`,
      tiene índice contable (`ej17a`).
  (b) Las discontinuidades de una función monótona `f : ℝ → ℝ` forman un conjunto contable
      (`ej17b`; `ej17b_mono` para creciente, `ej17b_anti` para decreciente).

Argumento (el mismo del Typst):
  * (a) cada `A_i` tiene dos puntos `u < v`; por densidad de `ℚ` (Proposición 2) hay un racional
    `q_i` entre ellos, que cae en `A_i` porque `A_i` es un intervalo (conjunto convexo). La
    asignación `i ↦ q_i` es inyectiva por la disjunción, así que `#I ≤ #ℚ = ℵ₀` y `I` es
    contable (Proposición 3.13 en la forma `contable_of_cardLe_numerable`).
  * (b) para `f` creciente y `x ∈ ℝ` se definen `L x = sup {f y : y < x}` y
    `R x = inf {f y : y > x}`. Se prueba `L x ≤ f x ≤ R x`, que `f` es continua en `x` si y sólo si
    `L x = R x` (`ε`-`δ`, deducción propia), y que `R x ≤ L y` si `x < y`. Entonces los intervalos
    `(L x, R x)`, `x` discontinuidad, son disjuntos y no degenerados, y (a) termina. El caso
    decreciente se reduce al creciente con `-f`.

"Intervalo" se define a mano como conjunto convexo de `ℝ` (`EsIntervalo`), y `#A > 1` como
`CardLt (Fin 1) A` (Definición 3.8); `cardLt_fin_one_iff` muestra que equivale a tener dos puntos
distintos. La continuidad es `ContinuousAt` de Mathlib, traducida a `ε`-`δ` con
`Metric.continuousAt_iff` (la definición estándar, que no está en `apuntes.typ`).
-/
import Mathlib
import Guias.Guia2.Defs

namespace Guias.Guia2.Ej17

open Guias.Guia2

/-! ## Preliminares -/

/-- Un subconjunto `A ⊆ ℝ` es un intervalo si es convexo: contiene todo punto entre dos de sus
puntos. -/
def EsIntervalo (A : Set ℝ) : Prop := ∀ u ∈ A, ∀ v ∈ A, ∀ w, u ≤ w → w ≤ v → w ∈ A

theorem esIntervalo_Ioo (a b : ℝ) : EsIntervalo (Set.Ioo a b) :=
  fun _ hu _ hv _ huw hwv => ⟨lt_of_lt_of_le hu.1 huw, lt_of_le_of_lt hwv hv.2⟩

/-- `#A > 1` (Definición 3.8, con `{1} = Fin 1`) equivale a que `A` tenga dos puntos distintos. -/
theorem cardLt_fin_one_iff (A : Type*) : CardLt (Fin 1) A ↔ ∃ a b : A, a ≠ b := by
  constructor
  · rintro ⟨⟨e⟩, hne⟩
    by_contra hcon
    push Not at hcon
    apply hne
    exact ⟨{ toFun := fun _ => e 0
             invFun := fun _ => 0
             left_inv := fun i => Fin.ext (by have := i.isLt; simp only [Fin.val_zero]; omega)
             right_inv := fun b => hcon _ _ }⟩
  · rintro ⟨a, b, hab⟩
    refine ⟨⟨⟨fun _ => a, fun i j _ => ?_⟩⟩, fun ⟨e⟩ => hab ?_⟩
    · exact Fin.ext (by have := i.isLt; have := j.isLt; omega)
    · have h1 : e.symm a = e.symm b :=
        Fin.ext (by have := (e.symm a).isLt; have := (e.symm b).isLt; omega)
      exact e.symm.injective h1

/-! ## (a) Familias disjuntas de intervalos no degenerados -/

/-- **Ej. 17 (a).** Si `{A_i}_{i ∈ I}` son intervalos de `ℝ` disjuntos dos a dos con `#A_i > 1`,
entonces `I` es contable. -/
theorem ej17a {I : Type*} (A : I → Set ℝ) (hint : ∀ i, EsIntervalo (A i))
    (hcard : ∀ i, CardLt (Fin 1) (A i)) (hdisj : ∀ i j, i ≠ j → A i ∩ A j = ∅) :
    Contable I := by
  -- en cada `A_i` hay un racional (elección: Proposición 2 aplicada a dos puntos de `A_i`)
  have hq : ∀ i, ∃ q : ℚ, (q : ℝ) ∈ A i := by
    intro i
    obtain ⟨⟨u, hu⟩, ⟨v, hv⟩, huv⟩ := (cardLt_fin_one_iff _).1 (hcard i)
    have huv' : u ≠ v := fun h => huv (Subtype.ext h)
    rcases lt_or_gt_of_ne huv' with h | h
    · obtain ⟨q, hq1, hq2⟩ := exists_rat_btwn h
      exact ⟨q, hint i u hu v hv q hq1.le hq2.le⟩
    · obtain ⟨q, hq1, hq2⟩ := exists_rat_btwn h
      exact ⟨q, hint i v hv u hu q hq1.le hq2.le⟩
  choose q hq using hq
  -- `i ↦ q_i` es inyectiva por la disjunción
  have hinj : Function.Injective q := by
    intro i j hij
    by_contra hne
    have : (q i : ℝ) ∈ A i ∩ A j := ⟨hq i, hij ▸ hq j⟩
    rw [hdisj i j hne] at this
    exact this
  exact contable_of_cardLe_numerable numerable_rat ⟨⟨q, hinj⟩⟩

/-! ## (b) Discontinuidades de una función monótona -/

section Monotona

variable {f : ℝ → ℝ} (hf : Monotone f)

/-- `L x = sup {f y : y < x}`. -/
noncomputable def L (f : ℝ → ℝ) (x : ℝ) : ℝ := sSup (f '' Set.Iio x)

/-- `R x = inf {f y : y > x}`. -/
noncomputable def R (f : ℝ → ℝ) (x : ℝ) : ℝ := sInf (f '' Set.Ioi x)

theorem nonempty_Iio (x : ℝ) : (f '' Set.Iio x).Nonempty :=
  ⟨f (x - 1), x - 1, by simp, rfl⟩

theorem nonempty_Ioi (x : ℝ) : (f '' Set.Ioi x).Nonempty :=
  ⟨f (x + 1), x + 1, by simp, rfl⟩

include hf in
/-- `f x` es cota superior de `{f y : y < x}` (monotonía). -/
theorem bddAbove_Iio (x : ℝ) : BddAbove (f '' Set.Iio x) :=
  ⟨f x, by rintro _ ⟨y, hy, rfl⟩; exact hf (le_of_lt hy)⟩

include hf in
/-- `f x` es cota inferior de `{f y : y > x}` (monotonía). -/
theorem bddBelow_Ioi (x : ℝ) : BddBelow (f '' Set.Ioi x) :=
  ⟨f x, by rintro _ ⟨y, hy, rfl⟩; exact hf (le_of_lt hy)⟩

include hf in
/-- `L x ≤ f x`: el supremo es la menor de las cotas superiores (Definición 2). -/
theorem L_le (x : ℝ) : L f x ≤ f x :=
  csSup_le (nonempty_Iio x) (by rintro _ ⟨y, hy, rfl⟩; exact hf (le_of_lt hy))

include hf in
/-- `f x ≤ R x`: el ínfimo es la mayor de las cotas inferiores (Definición 5). -/
theorem le_R (x : ℝ) : f x ≤ R f x :=
  le_csInf (nonempty_Ioi x) (by rintro _ ⟨y, hy, rfl⟩; exact hf (le_of_lt hy))

include hf in
/-- Si `y < x` entonces `f y ≤ L x` (`L x` es cota superior). -/
theorem le_L_of_lt {x y : ℝ} (h : y < x) : f y ≤ L f x :=
  le_csSup (bddAbove_Iio hf x) ⟨y, h, rfl⟩

include hf in
/-- Si `x < y` entonces `R x ≤ f y` (`R x` es cota inferior). -/
theorem R_le_of_lt {x y : ℝ} (h : x < y) : R f x ≤ f y :=
  csInf_le (bddBelow_Ioi hf x) ⟨y, h, rfl⟩

include hf in
/-- Si `x < y` entonces `R x ≤ L y`: con `z = (x + y)/2`, `R x ≤ f z ≤ L y`. -/
theorem R_le_L {x y : ℝ} (h : x < y) : R f x ≤ L f y := by
  have h1 : x < (x + y) / 2 := by linarith
  have h2 : (x + y) / 2 < y := by linarith
  exact (R_le_of_lt hf h1).trans (le_L_of_lt hf h2)

include hf in
/-- Continuidad en `x` implica `L x = R x` (deducción propia, `ε`-`δ`): para cada `ε > 0`,
`f(x - δ/2) > f x - ε` fuerza `L x ≥ f x - ε`, y `f(x + δ/2) < f x + ε` fuerza `R x ≤ f x + ε`. -/
theorem L_eq_R_of_continuousAt {x : ℝ} (hc : ContinuousAt f x) : L f x = R f x := by
  rw [Metric.continuousAt_iff] at hc
  have hL : ∀ ε > 0, f x - ε ≤ L f x := by
    intro ε hε
    obtain ⟨δ, hδ, hδε⟩ := hc ε hε
    have h1 : dist (x - δ / 2) x < δ := by rw [Real.dist_eq]; rw [abs_lt]; constructor <;> linarith
    have h2 := hδε h1
    rw [Real.dist_eq, abs_lt] at h2
    have h3 := le_L_of_lt hf (show x - δ / 2 < x by linarith)
    linarith [h2.1]
  have hR : ∀ ε > 0, R f x ≤ f x + ε := by
    intro ε hε
    obtain ⟨δ, hδ, hδε⟩ := hc ε hε
    have h1 : dist (x + δ / 2) x < δ := by rw [Real.dist_eq]; rw [abs_lt]; constructor <;> linarith
    have h2 := hδε h1
    rw [Real.dist_eq, abs_lt] at h2
    have h3 := R_le_of_lt hf (show x < x + δ / 2 by linarith)
    linarith [h2.2]
  have hL' : f x ≤ L f x := le_of_forall_sub_le hL
  have hR' : R f x ≤ f x := le_of_forall_pos_le_add hR
  linarith [L_le hf x, le_R hf x]

include hf in
/-- `L x = R x` implica continuidad en `x` (deducción propia, `ε`-`δ`): dado `ε`, por la
caracterización del supremo y del ínfimo (Proposiciones 3 y 5) hay `y₁ < x < y₂` con
`f y₁ > L x - ε` y `f y₂ < R x + ε`; con `δ = mín(x - y₁, y₂ - x)`, todo `y` con `|y - x| < δ`
cumple `y₁ < y < y₂`, luego `L x - ε < f y₁ ≤ f y ≤ f y₂ < R x + ε`, y `L x = f x = R x`. -/
theorem continuousAt_of_L_eq_R {x : ℝ} (h : L f x = R f x) : ContinuousAt f x := by
  have hLx : L f x = f x := le_antisymm (L_le hf x) (h ▸ le_R hf x)
  have hRx : R f x = f x := h ▸ hLx
  rw [Metric.continuousAt_iff]
  intro ε hε
  -- un punto a la izquierda con `f y₁ > L x - ε`
  obtain ⟨_, ⟨y₁, hy₁, rfl⟩, hfy₁⟩ :=
    exists_lt_of_lt_csSup (nonempty_Iio x) (show L f x - ε < L f x by linarith)
  -- un punto a la derecha con `f y₂ < R x + ε`
  obtain ⟨_, ⟨y₂, hy₂, rfl⟩, hfy₂⟩ :=
    exists_lt_of_csInf_lt (nonempty_Ioi x) (show R f x < R f x + ε by linarith)
  simp only [Set.mem_Iio] at hy₁
  simp only [Set.mem_Ioi] at hy₂
  refine ⟨min (x - y₁) (y₂ - x), lt_min (by linarith) (by linarith), ?_⟩
  intro y hy
  rw [Real.dist_eq, abs_lt] at hy
  have hmin1 := min_le_left (x - y₁) (y₂ - x)
  have hmin2 := min_le_right (x - y₁) (y₂ - x)
  have hy1 : y₁ ≤ y := by linarith
  have hy2 : y ≤ y₂ := by linarith
  have h1 := hf hy1
  have h2 := hf hy2
  rw [Real.dist_eq, abs_lt]
  constructor <;> linarith

include hf in
/-- Continuidad en `x` si y sólo si `L x = R x`. -/
theorem continuousAt_iff_L_eq_R (x : ℝ) : ContinuousAt f x ↔ L f x = R f x :=
  ⟨L_eq_R_of_continuousAt hf, continuousAt_of_L_eq_R hf⟩

include hf in
/-- En una discontinuidad el salto es genuino: `L x < R x`. -/
theorem L_lt_R_of_not_continuousAt {x : ℝ} (hx : ¬ ContinuousAt f x) : L f x < R f x :=
  lt_of_le_of_ne ((L_le hf x).trans (le_R hf x)) fun h => hx (continuousAt_of_L_eq_R hf h)

include hf in
/-- **Ej. 17 (b), caso creciente.** Las discontinuidades de `f` creciente son contables: los
intervalos `(L x, R x)` son disjuntos y no degenerados, y se aplica (a). -/
theorem ej17b_mono : Contable {x : ℝ // ¬ ContinuousAt f x} := by
  refine ej17a (fun x : {x : ℝ // ¬ ContinuousAt f x} => Set.Ioo (L f x.1) (R f x.1))
    (fun x => esIntervalo_Ioo _ _) (fun x => ?_) (fun x y hxy => ?_)
  · -- dos puntos distintos de `(L x, R x)`
    have hlt := L_lt_R_of_not_continuousAt hf x.2
    rw [cardLt_fin_one_iff]
    refine ⟨⟨(3 * L f x.1 + R f x.1) / 4, by constructor <;> linarith⟩,
      ⟨(L f x.1 + 3 * R f x.1) / 4, by constructor <;> linarith⟩, fun h => ?_⟩
    have := congrArg Subtype.val h
    simp only at this
    linarith
  · -- disjunción: si `x < y`, `R x ≤ L y`, así que nada está en ambos intervalos
    have hne : x.1 ≠ y.1 := fun h => hxy (Subtype.ext h)
    rw [Set.eq_empty_iff_forall_notMem]
    rintro w ⟨⟨hw1, hw2⟩, ⟨hw3, hw4⟩⟩
    rcases lt_or_gt_of_ne hne with h | h
    · have := R_le_L hf h
      linarith
    · have := R_le_L hf h
      linarith

end Monotona

/-- **Ej. 17 (b), caso decreciente.** Se reduce al creciente con `-f`, que tiene las mismas
discontinuidades. -/
theorem ej17b_anti {f : ℝ → ℝ} (hf : Antitone f) : Contable {x : ℝ // ¬ ContinuousAt f x} := by
  have hg : Monotone (fun x => -f x) := hf.neg
  have hiff : ∀ x, ¬ ContinuousAt f x ↔ ¬ ContinuousAt (fun x => -f x) x := by
    intro x
    constructor
    · intro h hc
      apply h
      have h2 : ContinuousAt (fun y => -(-f y)) x := hc.neg
      simp only [neg_neg] at h2
      exact h2
    · intro h hc
      exact h hc.neg
  exact contable_of_cardLe (ej17b_mono hg) ⟨(Equiv.subtypeEquivRight hiff).toEmbedding⟩

/-- **Ej. 17 (b).** Si `f : ℝ → ℝ` es monótona (creciente o decreciente), el conjunto de sus
discontinuidades es contable. -/
theorem ej17b {f : ℝ → ℝ} (hf : Monotone f ∨ Antitone f) :
    Contable {x : ℝ // ¬ ContinuousAt f x} :=
  hf.elim ej17b_mono ej17b_anti

end Guias.Guia2.Ej17
