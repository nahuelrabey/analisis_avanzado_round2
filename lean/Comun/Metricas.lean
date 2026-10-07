/-
Librería común `Comun`: definiciones del curso y resultados de `apuntes.typ` compartidos por las
guías (`Guias/`), los parciales (`Parciales/`) y los ejemplos (`Ejemplos/`). Ver
`apuntes-agente/lean-lemas-compartidos-y-organizacion.md` para el diseño.

`Comun.Metricas`: `EsMetrica d` es la Definición 4.1 de `apuntes.typ` tal cual (no negatividad,
separación, simetría, desigualdad triangular), para verificar "pruebe que `d` es una métrica" sobre
funciones definidas a mano sin depender de una instancia `MetricSpace`; `bola d` y `bolaCerrada d`
son las bolas de la Definición 4.5 para una `d` cualquiera.

Además:
* el constructor `EsMetrica.toMetricSpace`, que arma el `MetricSpace` de Mathlib sobre el sinónimo
  de tipo `Con X d` (así los parciales definen `d`, prueban `EsMetrica d` y obtienen la instancia,
  con `dist x y = d x y` por `rfl`);
* `EsMetrica.max` y `EsMetrica.const_mul` (máximo de dos métricas y múltiplo positivo);
* los puentes `bola dist x r = Metric.ball x r` y `bolaCerrada dist x r = Metric.closedBall x r`;
* `EsAbierto d`, `Equivalentes d d'`, `abiertos_iff`, `equivalentes_of_le` (la definición de
  métricas equivalentes adoptada en el Typst; Práctica 3, Ej. 12);
* `EsCauchy d` (Def. 4.51), `ConvergeMet d` (Def. 4.42, para una `d` cualquiera; la `Converge` de
  `ℝ` del capítulo de sucesiones vive en `Comun.Sucesiones`), `EsCompleto d` (Def. 4.55), sus
  puentes con `CauchySeq`/`Tendsto`/`CompleteSpace` cuando `d = dist`, y la transferencia de
  completitud por `c·d₀ ≤ d ≤ C·d₀` en los dos dialectos (`completo_of_equiv`, lema del Ej. 14 de
  la Práctica 3; `completeSpace_of_dist_le_of_le`, para los parciales).
-/
import Mathlib

open Filter Topology

namespace Comun

/-! ## Definición 4.1 y bolas -/

/-- Definición 4.1 (Métrica y espacio métrico): `d : X × X → ℝ` es una métrica en `X`. -/
structure EsMetrica {X : Type*} (d : X → X → ℝ) : Prop where
  /-- (i) `d(x, y) ≥ 0`. -/
  nonneg : ∀ x y, 0 ≤ d x y
  /-- (ii) `d(x, y) = 0 ↔ x = y`. -/
  eq_zero_iff : ∀ x y, d x y = 0 ↔ x = y
  /-- (iii) simetría. -/
  symm : ∀ x y, d x y = d y x
  /-- (iv) desigualdad triangular. -/
  triangle : ∀ x y z, d x z ≤ d x y + d y z

/-- Bola abierta `B(x₀, r) = {y : d(x₀, y) < r}` para una función de distancia cualquiera. -/
def bola {X : Type*} (d : X → X → ℝ) (x₀ : X) (r : ℝ) : Set X := {y | d x₀ y < r}

/-- Bola cerrada `B[x₀, r] = {y : d(x₀, y) ≤ r}`. -/
def bolaCerrada {X : Type*} (d : X → X → ℝ) (x₀ : X) (r : ℝ) : Set X := {y | d x₀ y ≤ r}

/-- La distancia de un `MetricSpace` de Mathlib es una métrica en el sentido de la Def. 4.1. -/
theorem esMetrica_dist (X : Type*) [MetricSpace X] : EsMetrica (fun x y : X => dist x y) where
  nonneg _ _ := dist_nonneg
  eq_zero_iff _ _ := dist_eq_zero
  symm := dist_comm
  triangle := dist_triangle

/-- Puente: para la distancia de Mathlib, `bola dist x r` es `Metric.ball x r`. -/
theorem bola_dist_eq_ball {X : Type*} [MetricSpace X] (x : X) (r : ℝ) :
    bola (fun a b : X => dist a b) x r = Metric.ball x r := by
  ext y
  simp only [bola, Set.mem_ofPred_eq, Metric.mem_ball, dist_comm]

/-- Puente: para la distancia de Mathlib, `bolaCerrada dist x r` es `Metric.closedBall x r`. -/
theorem bolaCerrada_dist_eq_closedBall {X : Type*} [MetricSpace X] (x : X) (r : ℝ) :
    bolaCerrada (fun a b : X => dist a b) x r = Metric.closedBall x r := by
  ext y
  simp only [bolaCerrada, Set.mem_ofPred_eq, Metric.mem_closedBall, dist_comm]

/-! ## De `EsMetrica` a `MetricSpace`

`Con X d` es `X` "con la métrica `d`": un sinónimo de tipo sobre el que se pone la instancia,
para no pisar la que `X` pueda tener (por ejemplo `Fin n → ℝ` con `d_∞`). -/

/-- `X` con la métrica `d`: sinónimo de tipo de `X`. -/
def Con (X : Type*) (_d : X → X → ℝ) : Type _ := X

/-- Un punto de `X` visto en `Con X d` (es la identidad). -/
def toCon {X : Type*} (d : X → X → ℝ) (x : X) : Con X d := x

/-- Un punto de `Con X d` visto en `X` (es la identidad). -/
def ofCon {X : Type*} {d : X → X → ℝ} (x : Con X d) : X := x

/-- Toda `EsMetrica d` (Def. 4.1) da un `MetricSpace` de Mathlib sobre `Con X d`. -/
@[instance_reducible]
noncomputable def EsMetrica.toMetricSpace {X : Type*} {d : X → X → ℝ} (h : EsMetrica d) :
    MetricSpace (Con X d) where
  dist x y := d (ofCon x) (ofCon y)
  dist_self x := (h.eq_zero_iff _ _).2 rfl
  dist_comm x y := h.symm _ _
  dist_triangle x y z := h.triangle _ _ _
  eq_of_dist_eq_zero hxy := (h.eq_zero_iff _ _).1 hxy

/-- En `Con X d` la distancia es `d`, por definición. -/
theorem Con.dist_eq {X : Type*} {d : X → X → ℝ} (h : EsMetrica d) (x y : Con X d) :
    letI := h.toMetricSpace; dist x y = d (ofCon x) (ofCon y) := rfl

/-! ## Construcciones de métricas -/

/-- El máximo de dos métricas es una métrica. -/
theorem EsMetrica.max {X : Type*} {d d' : X → X → ℝ} (h : EsMetrica d) (h' : EsMetrica d') :
    EsMetrica (fun x y => max (d x y) (d' x y)) where
  nonneg x y := le_max_of_le_left (h.nonneg x y)
  eq_zero_iff x y := by
    constructor
    · intro hxy
      have h1 : d x y ≤ 0 := hxy ▸ le_max_left _ _
      exact (h.eq_zero_iff x y).1 (le_antisymm h1 (h.nonneg x y))
    · rintro rfl
      simp [(h.eq_zero_iff x x).2 rfl, (h'.eq_zero_iff x x).2 rfl]
  symm x y := by simp only [h.symm x y, h'.symm x y]
  triangle x y z :=
    max_le ((h.triangle x y z).trans (add_le_add (le_max_left _ _) (le_max_left _ _)))
      ((h'.triangle x y z).trans (add_le_add (le_max_right _ _) (le_max_right _ _)))

/-- Un múltiplo positivo de una métrica es una métrica. -/
theorem EsMetrica.const_mul {X : Type*} {d : X → X → ℝ} (h : EsMetrica d) {c : ℝ} (hc : 0 < c) :
    EsMetrica (fun x y => c * d x y) where
  nonneg x y := mul_nonneg hc.le (h.nonneg x y)
  eq_zero_iff x y := by
    rw [mul_eq_zero, or_iff_right hc.ne']
    exact h.eq_zero_iff x y
  symm x y := by simp only [h.symm x y]
  triangle x y z := by
    have := h.triangle x y z
    nlinarith

/-! ## Abiertos y métricas equivalentes (Práctica 3, Ej. 12) -/

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

/-! ## Sucesiones de Cauchy, convergencia y completitud para una `d` cualquiera

Definiciones 4.42, 4.51 y 4.55 escritas con `ε`-`N`. Las sucesiones empiezan en `0` (en el
curso, en `1`). -/

/-- Definición 4.51: `(xₖ)` es de Cauchy para `d`. -/
def EsCauchy {X : Type*} (d : X → X → ℝ) (x : ℕ → X) : Prop :=
  ∀ ε > 0, ∃ N : ℕ, ∀ k ≥ N, ∀ j ≥ N, d (x k) (x j) < ε

-- La versión para sucesiones de reales es `Comun.Converge` (`Comun.Sucesiones`), que es
-- `ConvergeMet (fun x y => |x - y|)`: ver `converge_iff_convergeMet`.
/-- Definición 4.42: `xₖ → l` para `d`. -/
def ConvergeMet {X : Type*} (d : X → X → ℝ) (x : ℕ → X) (l : X) : Prop :=
  ∀ ε > 0, ∃ N : ℕ, ∀ k ≥ N, d (x k) l < ε

/-- Definición 4.55: `(X, d)` es completo si toda sucesión de Cauchy tiene límite. -/
def EsCompleto {X : Type*} (d : X → X → ℝ) : Prop :=
  ∀ x : ℕ → X, EsCauchy d x → ∃ l, ConvergeMet d x l

/-! ## Una desigualdad genérica -/

/-- Desigualdad clave: `|d(xₙ, yₙ) − d(x, y)| ≤ d(xₙ, x) + d(yₙ, y)`.
(Se deduce de la desigualdad triangular aplicada dos veces, en cada sentido.) -/
theorem abs_dist_sub_dist_le {E : Type*} [MetricSpace E] (a b a' b' : E) :
    |dist a b - dist a' b'| ≤ dist a a' + dist b b' := by
  rw [abs_le]
  constructor
  · -- `d(a',b') ≤ d(a',a) + d(a,b) + d(b,b')`
    have h1 := dist_triangle a' a b
    have h2 := dist_triangle a' b b'
    have h3 := dist_comm a a'
    have h4 := dist_comm b b'
    linarith
  · -- `d(a,b) ≤ d(a,a') + d(a',b') + d(b',b)`
    have h1 := dist_triangle a a' b
    have h2 := dist_triangle a' b' b
    have h3 := dist_comm b b'
    linarith

section Puentes

variable {X : Type*} [MetricSpace X]

/-- Puente: para `d = dist`, `EsCauchy` es `CauchySeq` de Mathlib. -/
theorem esCauchy_dist_iff {x : ℕ → X} : EsCauchy (fun a b : X => dist a b) x ↔ CauchySeq x := by
  rw [Metric.cauchySeq_iff]
  rfl

/-- Puente: para `d = dist`, `ConvergeMet` es `Tendsto … atTop (𝓝 l)` de Mathlib. -/
theorem convergeMet_dist_iff {x : ℕ → X} {l : X} :
    ConvergeMet (fun a b : X => dist a b) x l ↔ Tendsto x atTop (𝓝 l) := by
  rw [Metric.tendsto_atTop]
  rfl

/-- Puente: para `d = dist`, `EsCompleto` es `CompleteSpace` de Mathlib. -/
theorem esCompleto_dist_iff : EsCompleto (fun a b : X => dist a b) ↔ CompleteSpace X := by
  constructor
  · intro h
    apply Metric.complete_of_cauchySeq_tendsto
    intro u hu
    obtain ⟨l, hl⟩ := h u (esCauchy_dist_iff.2 hu)
    exact ⟨l, convergeMet_dist_iff.1 hl⟩
  · intro _ u hu
    obtain ⟨l, hl⟩ := cauchySeq_tendsto_of_complete (esCauchy_dist_iff.1 hu)
    exact ⟨l, convergeMet_dist_iff.2 hl⟩

end Puentes

/-! ## Transferencia de completitud entre métricas comparables -/

/-- **Lema del Ej. 14 de la Práctica 3**, general. Si `c · d₀ ≤ d ≤ C · d₀` con `c, C > 0` y
`(X, d₀)` es completo, entonces `(X, d)` es completo: una `d`-Cauchy es `d₀`-Cauchy, converge en
`d₀` a un `l`, y `d(xₖ, l) ≤ C · d₀(xₖ, l)` tiende a `0`. -/
theorem completo_of_equiv {X : Type*} {d₀ d : X → X → ℝ} (h₀ : EsCompleto d₀) {c C : ℝ}
    (hc : 0 < c) (hC : 0 < C) (hlow : ∀ x y, c * d₀ x y ≤ d x y)
    (hup : ∀ x y, d x y ≤ C * d₀ x y) : EsCompleto d := by
  intro x hx
  -- `d`-Cauchy ⇒ `d₀`-Cauchy
  have hx' : EsCauchy d₀ x := by
    intro ε hε
    obtain ⟨N, hN⟩ := hx (c * ε) (mul_pos hc hε)
    refine ⟨N, fun k hk j hj => ?_⟩
    have := (hlow _ _).trans_lt (hN k hk j hj)
    exact lt_of_mul_lt_mul_left this hc.le
  obtain ⟨l, hl⟩ := h₀ x hx'
  refine ⟨l, fun ε hε => ?_⟩
  obtain ⟨N, hN⟩ := hl (ε / C) (div_pos hε hC)
  refine ⟨N, fun k hk => ?_⟩
  calc d (x k) l ≤ C * d₀ (x k) l := hup _ _
    _ < C * (ε / C) := mul_lt_mul_of_pos_left (hN k hk) hC
    _ = ε := by field_simp

/-- Transferencia de `CompleteSpace` (para los parciales): si `f : X → Y` y `g : Y → X` son
mutuamente inversas (`f ∘ g = id`), `g` es Lipschitz (`dist (g y) (g y') ≤ c · dist y y'`) y `f`
es Lipschitz (`dist (f x) (f x') ≤ C · dist x x'`), y `X` es completo, entonces `Y` es completo.
El caso típico es la identidad entre dos métricas comparables sobre el mismo conjunto. -/
theorem completeSpace_of_dist_le_of_le {X Y : Type*} [MetricSpace X] [MetricSpace Y]
    [CompleteSpace X] (f : X → Y) (g : Y → X) (hfg : ∀ y, f (g y) = y) {c C : ℝ}
    (hg : ∀ y y', dist (g y) (g y') ≤ c * dist y y')
    (hf : ∀ x x', dist (f x) (f x') ≤ C * dist x x') : CompleteSpace Y := by
  apply Metric.complete_of_cauchySeq_tendsto
  intro u hu
  -- `g ∘ u` es de Cauchy en `X`
  have hc1 : 0 < max c 1 := lt_max_of_lt_right one_pos
  have hC1 : 0 < max C 1 := lt_max_of_lt_right one_pos
  have hgu : CauchySeq (fun k => g (u k)) := by
    rw [Metric.cauchySeq_iff] at hu ⊢
    intro ε hε
    obtain ⟨N, hN⟩ := hu (ε / max c 1) (div_pos hε hc1)
    refine ⟨N, fun k hk j hj => ?_⟩
    calc dist (g (u k)) (g (u j)) ≤ c * dist (u k) (u j) := hg _ _
      _ ≤ max c 1 * dist (u k) (u j) := mul_le_mul_of_nonneg_right (le_max_left _ _) dist_nonneg
      _ < max c 1 * (ε / max c 1) := mul_lt_mul_of_pos_left (hN k hk j hj) hc1
      _ = ε := by field_simp
  obtain ⟨x, hx⟩ := cauchySeq_tendsto_of_complete hgu
  refine ⟨f x, ?_⟩
  rw [Metric.tendsto_atTop] at hx ⊢
  intro ε hε
  obtain ⟨N, hN⟩ := hx (ε / max C 1) (div_pos hε hC1)
  refine ⟨N, fun k hk => ?_⟩
  calc dist (u k) (f x) = dist (f (g (u k))) (f x) := by rw [hfg]
    _ ≤ C * dist (g (u k)) x := hf _ _
    _ ≤ max C 1 * dist (g (u k)) x := mul_le_mul_of_nonneg_right (le_max_left _ _) dist_nonneg
    _ < max C 1 * (ε / max C 1) := mul_lt_mul_of_pos_left (hN k hk) hC1
    _ = ε := by field_simp

end Comun
