/-
Análisis Avanzado (FCEN-UBA) · Primer parcial · 19/10/2024
Enunciado y resolución oficial transcriptos en `apuntes-typst/parciales/2024_2c_parcial_1.typ`.

Este archivo verifica en Lean 4 + Mathlib las cuatro resoluciones oficiales: cada ejercicio
tiene su enunciado formalizado y una demostración que sigue, paso a paso, el argumento de la
cátedra. Las diferencias entre el texto y la formalización están anotadas en el `.typ`.

Qué usa de `Comun`: el conjunto suma `sumSet` con `sInf_sumSet` (`Comun.Supremos`; el Ej. 1 es
un alias), la distancia integral `C01.d1` de `C([0,1])` con `C01.ext`, `C01.d1_le_dist` y la
evaluación `C01.E` (`Comun.Metricas.C01`), los hechos sobre `1/(n+1)` y Arquímedes
`one_div_succ_antitone`, `exists_n0_forall_lt` (`Comun.Reales`) y el puente
`cardC_iff_mk_eq_continuum` para el corolario `_curso` (`Comun.Cardinales`). Quedan locales:
`𝒜`, `Φ`, el Ej. 3 y la "carpa" de `ej4_reciproca_falsa`.
-/
import Mathlib
import Comun.Reales
import Comun.Supremos
import Comun.Cardinales
import Comun.Metricas.C01

open Cardinal Filter Topology Comun

namespace Parcial1_2C2024

/-! ## Ejercicio 1

`ínf A + ínf B = ínf (A + B)` para `A, B ⊆ ℝ` no vacíos y acotados. -/

/-- **Ejercicio 1.** (Alcanza con que `A` y `B` estén acotados inferiormente.) El conjunto suma
es `Comun.sumSet` y la igualdad es `Comun.sInf_sumSet`: `ínf A + ínf B` es cota inferior de
`A + B`, y para cada `ε > 0` hay `a ∈ A`, `b ∈ B` a menos de `ε/2` de los ínfimos. -/
theorem ej1 (A B : Set ℝ) (hA : A.Nonempty) (hA' : BddBelow A)
    (hB : B.Nonempty) (hB' : BddBelow B) :
    sInf A + sInf B = sInf (sumSet A B) :=
  (sInf_sumSet A B hA hA' hB hB').symm

/-- **Ejercicio 1**, en el dialecto del curso: si `i = ínf A` y `j = ínf B` (Definición 5),
entonces `i + j = ínf (A + B)` (`Comun.esInf_sumSet`). -/
theorem ej1_curso {A B : Set ℝ} {i j : ℝ} (hi : EsInf A i) (hj : EsInf B j) :
    EsInf (sumSet A B) (i + j) :=
  esInf_sumSet hi hj

/-! ## Ejercicio 2

`𝒜 = {B ⊆ ℚ : #B = #(ℚ ∖ B)}` tiene cardinal `𝔠`. -/

/-- El conjunto `𝒜` del Ejercicio 2. -/
def 𝒜 : Set (Set ℚ) := {B | #B = #(Bᶜ : Set ℚ)}

/-- Un subconjunto de `ℚ` que contiene un conjunto infinito tiene cardinal `ℵ₀`. -/
theorem mk_eq_aleph0_of_infinite_subset {S T : Set ℚ} (hT : T.Infinite) (hTS : T ⊆ S) :
    #S = ℵ₀ := by
  apply le_antisymm
  · exact Cardinal.mk_le_aleph0_iff.2 (Set.to_countable S)
  · exact Cardinal.aleph0_le_mk_iff.2 (Set.infinite_coe_iff.2 (hT.mono hTS))

/-- La inyección `𝒫(ℕ) → 𝒜` de la resolución oficial: `B ↦ B ∪ ((1, 2) ∩ ℚ)`. -/
def Φ (B : Set ℕ) : Set ℚ := (Nat.cast '' B) ∪ Set.Ioo 1 2

theorem Φ_mem (B : Set ℕ) : Φ B ∈ 𝒜 := by
  show #(Φ B) = #((Φ B)ᶜ : Set ℚ)
  have h1 : #(Φ B) = ℵ₀ :=
    mk_eq_aleph0_of_infinite_subset (Set.Ioo_infinite (by norm_num)) Set.subset_union_right
  have h2 : #((Φ B)ᶜ : Set ℚ) = ℵ₀ := by
    apply mk_eq_aleph0_of_infinite_subset (T := Set.Ioo 2 3) (Set.Ioo_infinite (by norm_num))
    -- `(2, 3) ∩ ℚ` está en el complemento: no contiene naturales ni puntos de `(1, 2)`.
    rintro q ⟨hq2, hq3⟩ (⟨n, _, rfl⟩ | ⟨_, hq⟩)
    · have h2' : (2 : ℚ) < n := hq2
      have h3' : (n : ℚ) < 3 := hq3
      norm_cast at h2' h3'
      omega
    · linarith
  rw [h1, h2]

theorem Φ_injective : Function.Injective Φ := by
  intro B₁ B₂ h
  -- `n ∈ B ↔ (n : ℚ) ∈ Φ B`, porque ningún natural está en `(1, 2)`.
  have key : ∀ B : Set ℕ, ∀ n : ℕ, n ∈ B ↔ (n : ℚ) ∈ Φ B := by
    intro B n
    constructor
    · intro hn; exact Or.inl ⟨n, hn, rfl⟩
    · rintro (⟨m, hm, hmn⟩ | ⟨h1, h2⟩)
      · rwa [Nat.cast_injective hmn] at hm
      · exfalso
        have h1' : (1 : ℕ) < n := by exact_mod_cast h1
        have h2' : n < (2 : ℕ) := by exact_mod_cast h2
        omega
  ext n
  rw [key B₁, key B₂, h]

/-- **Ejercicio 2.** `#𝒜 = 𝔠`. -/
theorem ej2 : #𝒜 = 𝔠 := by
  apply le_antisymm
  · -- `𝒜 ⊆ 𝒫(ℚ)` y `#𝒫(ℚ) = 2 ^ ℵ₀ = 𝔠`.
    calc #𝒜 ≤ #(Set ℚ) := Cardinal.mk_set_le 𝒜
      _ = 𝔠 := by rw [Cardinal.mk_set, Cardinal.mk_denumerable, Cardinal.two_power_aleph0]
  · -- `𝒫(ℕ) ↪ 𝒜` y `#𝒫(ℕ) = 𝔠`.
    have hinj : Function.Injective (fun B : Set ℕ => (⟨Φ B, Φ_mem B⟩ : 𝒜)) := by
      intro B₁ B₂ h
      exact Φ_injective (congrArg Subtype.val h)
    calc 𝔠 = #(Set ℕ) := by rw [Cardinal.mk_set, Cardinal.mk_nat, Cardinal.two_power_aleph0]
      _ ≤ #𝒜 := Cardinal.mk_le_of_injective hinj

/-- **Ejercicio 2**, en el dialecto del curso: `𝒜` tiene el cardinal del continuo, `#𝒜 = c`
(Definición 3.8, `CardC`). -/
theorem ej2_curso : CardC 𝒜 := cardC_iff_mk_eq_continuum.2 ej2

/-! ## Ejercicio 3

Si en `(X, d)` toda sucesión decreciente de cerrados, acotados y no vacíos con diámetro
tendiendo a `0` tiene intersección no vacía, entonces `X` es completo.

(Se agrega la hipótesis "acotados" porque en el curso el diámetro sólo está definido para
conjuntos acotados; en Mathlib `diam` de un conjunto no acotado vale `0` por convención. Con
"acotados" la hipótesis de Lean es la del enunciado de la Práctica 3, Ej. 16.) -/

/-- **Ejercicio 3.** -/
theorem ej3 {X : Type*} [MetricSpace X]
    (H : ∀ A : ℕ → Set X, (∀ n, IsClosed (A n)) → (∀ n, (A n).Nonempty) →
      (∀ n, Bornology.IsBounded (A n)) → (∀ n, A (n + 1) ⊆ A n) →
      Tendsto (fun n => Metric.diam (A n)) atTop (𝓝 0) → (⋂ n, A n).Nonempty) :
    CompleteSpace X := by
  apply Metric.complete_of_cauchySeq_tendsto
  intro x hx
  -- Los conjuntos de la resolución oficial: `A n = cl (⋃_{m ≥ n} B(x m, 1/(n+1)))`.
  let r : ℕ → ℝ := fun n => 1 / ((n : ℝ) + 1)
  have hr : ∀ n, 0 < r n := fun n => by positivity
  have hr1 : ∀ n, r n ≤ 1 := fun n => by
    simp only [r]; rw [div_le_one (by positivity)]; linarith [(Nat.cast_nonneg n : (0:ℝ) ≤ n)]
  have hr_anti : ∀ n, r (n + 1) ≤ r n := fun n => one_div_succ_antitone (Nat.le_succ n)
  let S : ℕ → Set X := fun n => ⋃ m, ⋃ (_ : n ≤ m), Metric.ball (x m) (r n)
  let A : ℕ → Set X := fun n => closure (S n)
  have hmemS : ∀ n y, y ∈ S n ↔ ∃ m, n ≤ m ∧ y ∈ Metric.ball (x m) (r n) := by
    intro n y; simp only [S, Set.mem_iUnion, exists_prop]
  have hxS : ∀ n, x n ∈ S n := fun n => (hmemS n _).2 ⟨n, le_rfl, Metric.mem_ball_self (hr n)⟩
  -- Cerrados, no vacíos, decrecientes.
  have hclosed : ∀ n, IsClosed (A n) := fun n => isClosed_closure
  have hne : ∀ n, (A n).Nonempty := fun n => ⟨x n, subset_closure (hxS n)⟩
  have hanti : ∀ n, A (n + 1) ⊆ A n := by
    intro n
    apply closure_mono
    intro y hy
    obtain ⟨m, hm, hym⟩ := (hmemS _ _).1 hy
    exact (hmemS _ _).2 ⟨m, by omega, Metric.ball_subset_ball (hr_anti n) hym⟩
  -- Acotados: toda sucesión de Cauchy es acotada.
  obtain ⟨R, hR0, hR⟩ := cauchySeq_bdd hx
  have hbdd : ∀ n, Bornology.IsBounded (A n) := by
    intro n
    apply Bornology.IsBounded.closure
    rw [Metric.isBounded_iff_subset_closedBall (x 0)]
    refine ⟨R + 1, ?_⟩
    intro y hy
    obtain ⟨m, _, hym⟩ := (hmemS _ _).1 hy
    rw [Metric.mem_closedBall]
    rw [Metric.mem_ball] at hym
    calc dist y (x 0) ≤ dist y (x m) + dist (x m) (x 0) := dist_triangle _ _ _
      _ ≤ r n + R := add_le_add hym.le (hR m 0).le
      _ ≤ R + 1 := by linarith [hr1 n]
  -- El diámetro tiende a cero: `diam (A n) ≤ 2 r n + sup_{m, j ≥ n} d(x m, x j)`.
  have hdiam : Tendsto (fun n => Metric.diam (A n)) atTop (𝓝 0) := by
    rw [Metric.tendsto_atTop]
    intro ε hε
    obtain ⟨N₁, hN₁⟩ := Metric.cauchySeq_iff.1 hx (ε / 5) (by positivity)
    obtain ⟨N₂, hN₂⟩ := exists_n0_forall_lt (5 / ε)
    refine ⟨max N₁ N₂, fun n hn => ?_⟩
    have hn₁ : N₁ ≤ n := le_trans (le_max_left _ _) hn
    have hn₂ : N₂ ≤ n := le_trans (le_max_right _ _) hn
    have hrn : r n < ε / 5 := by
      simp only [r]
      rw [div_lt_iff₀ (by positivity)]
      have : (5 : ℝ) / ε < n + 1 := by linarith [hN₂ n hn₂]
      rw [div_lt_iff₀ hε] at this
      linarith
    have hdS : Metric.diam (S n) ≤ 2 * r n + ε / 5 := by
      apply Metric.diam_le_of_forall_dist_le (by linarith [hr n])
      intro y hy z hz
      obtain ⟨m, hm, hym⟩ := (hmemS _ _).1 hy
      obtain ⟨j, hj, hzj⟩ := (hmemS _ _).1 hz
      rw [Metric.mem_ball] at hym hzj
      have hmj : dist (x m) (x j) < ε / 5 := hN₁ m (by omega) j (by omega)
      calc dist y z ≤ dist y (x m) + dist (x m) (x j) + dist (x j) z := dist_triangle4 _ _ _ _
        _ ≤ r n + ε / 5 + r n := by
            gcongr
            rw [dist_comm]; exact hzj.le
        _ = 2 * r n + ε / 5 := by ring
    rw [Real.dist_eq, sub_zero, abs_of_nonneg Metric.diam_nonneg]
    show Metric.diam (closure (S n)) < ε
    rw [Metric.diam_closure]
    linarith
  -- Por hipótesis, la intersección es no vacía; su punto es el límite.
  obtain ⟨p, hp⟩ := H A hclosed hne hbdd hanti hdiam
  rw [Set.mem_iInter] at hp
  refine ⟨p, ?_⟩
  rw [Metric.tendsto_atTop]
  intro ε hε
  obtain ⟨N, hN⟩ := Metric.tendsto_atTop.1 hdiam ε hε
  refine ⟨N, fun n hn => ?_⟩
  have h1 : dist (x n) p ≤ Metric.diam (A n) :=
    Metric.dist_le_diam_of_mem (hbdd n) (subset_closure (hxS n)) (hp n)
  have h2 := hN n hn
  rw [Real.dist_eq, sub_zero, abs_of_nonneg Metric.diam_nonneg] at h2
  linarith

/-! ## Ejercicio 4

`X = C([0, 1])`. Si `𝓕 : X → Y` es continua con `d_1`, también lo es con `d_∞`; la recíproca
es falsa (la evaluación `f ↦ f(0)` es `d_∞`-continua y no `d_1`-continua).

`C([0, 1])` se modela como `C(I, ℝ)` (`I = [0, 1]`), que en Mathlib lleva la métrica `d_∞`.
La distancia `d_1` es la integral de `|f - g|` sobre `[0, 1]` (`Comun.C01.d1`, que integra la
extensión `C01.ext` a `ℝ`; `C01.d1_le_dist` es `d_1 ≤ d_∞`), y la "continuidad con `d_1`" se
escribe con `ε`-`δ`. -/

open Comun.C01 (ext continuous_ext ext_of_mem d1_le_dist)

/-- La distancia `d_1(f, g) = ∫_0^1 |f(x) - g(x)| dx` (`Comun.C01.d1`). -/
noncomputable abbrev d1 (f g : C(unitInterval, ℝ)) : ℝ := C01.d1 f g

/-- **Ejercicio 4, ida.** Si `𝓕` es continua para `d_1` (en `ε`-`δ`), es continua para `d_∞`. -/
theorem ej4 {Y : Type*} [MetricSpace Y] (F : C(unitInterval, ℝ) → Y)
    (hF : ∀ f, ∀ ε > 0, ∃ δ > 0, ∀ g, d1 g f < δ → dist (F g) (F f) < ε) :
    Continuous F := by
  rw [Metric.continuous_iff]
  intro f ε hε
  obtain ⟨δ, hδ, h⟩ := hF f ε hε
  exact ⟨δ, hδ, fun g hg => h g (lt_of_le_of_lt (d1_le_dist g f) hg)⟩

/-- La evaluación en `0` (`Comun.C01.E`). -/
noncomputable abbrev E (f : C(unitInterval, ℝ)) : ℝ := C01.E f

/-- **Ejercicio 4, recíproca falsa.** `E` es continua para `d_∞` pero no para `d_1`: la función
"carpa" `g_h(x) = máx{0, 1 - x/h}` tiene `d_1(g_h, 0) ≤ h` y `E(g_h) = 1`. -/
theorem ej4_reciproca_falsa :
    Continuous E ∧ ¬ (∀ ε > 0, ∃ δ > 0, ∀ g, d1 g 0 < δ → dist (E g) (E 0) < ε) := by
  refine ⟨continuous_eval_const _, ?_⟩
  intro h
  obtain ⟨δ, hδ, hδ'⟩ := h 1 one_pos
  set r : ℝ := min (δ / 2) (1 / 2) with hr
  have hr0 : 0 < r := by positivity
  have hrδ : r < δ := lt_of_le_of_lt (min_le_left _ _) (by linarith)
  have hr1 : r ≤ 1 := le_trans (min_le_right _ _) (by norm_num)
  -- la carpa
  let g : C(unitInterval, ℝ) := ⟨fun t => max 0 (1 - (t : ℝ) / r), by fun_prop⟩
  have hg_ext : ∀ x ∈ Set.Icc (0 : ℝ) 1, ext g x = max 0 (1 - x / r) := fun x hx => by
    rw [ext_of_mem g hx]; rfl
  have hg_le : ∀ x ∈ Set.Icc (0 : ℝ) r, ext g x ≤ 1 := by
    intro x hx
    rw [hg_ext x ⟨hx.1, le_trans hx.2 hr1⟩]
    apply max_le zero_le_one
    have : 0 ≤ x / r := div_nonneg hx.1 hr0.le
    linarith
  have hg_zero : ∀ x ∈ Set.Icc r 1, ext g x = 0 := by
    intro x hx
    rw [hg_ext x ⟨le_trans hr0.le hx.1, hx.2⟩]
    apply max_eq_left
    rw [sub_nonpos, le_div_iff₀ hr0]; linarith [hx.1]
  -- `d1 g 0 = ∫_0^r g + ∫_r^1 g ≤ r + 0`.
  have hcont : Continuous (fun x => |ext g x - ext 0 x|) :=
    ((continuous_ext g).sub (continuous_ext 0)).abs
  have hab : IntervalIntegrable (fun x => |ext g x - ext 0 x|) MeasureTheory.volume 0 r :=
    hcont.intervalIntegrable _ _
  have hbc : IntervalIntegrable (fun x => |ext g x - ext 0 x|) MeasureTheory.volume r 1 :=
    hcont.intervalIntegrable _ _
  have hd1 : d1 g 0 ≤ r := by
    unfold d1 C01.d1
    rw [← intervalIntegral.integral_add_adjacent_intervals hab hbc]
    have h1 : ∫ x in (0 : ℝ)..r, |ext g x - ext 0 x| ≤ r := by
      calc ∫ x in (0 : ℝ)..r, |ext g x - ext 0 x| ≤ ∫ _x in (0 : ℝ)..r, (1 : ℝ) := by
            apply intervalIntegral.integral_mono_on hr0.le
            · exact ((continuous_ext g).sub (continuous_ext 0)).abs.intervalIntegrable _ _
            · exact intervalIntegrable_const
            · intro x hx
              have h0 : ext 0 x = 0 := by simp [ext]
              rw [h0, sub_zero, abs_of_nonneg]
              · exact hg_le x hx
              · rw [hg_ext x ⟨hx.1, le_trans hx.2 hr1⟩]; exact le_max_left _ _
        _ = r := by simp
    have h2 : ∫ x in r..1, |ext g x - ext 0 x| = 0 := by
      rw [intervalIntegral.integral_congr (g := fun _ => (0 : ℝ))]
      · simp
      · intro x hx
        rw [Set.uIcc_of_le hr1] at hx
        show |ext g x - ext 0 x| = 0
        rw [hg_zero x hx]
        simp [ext]
    linarith
  have := hδ' g (lt_of_le_of_lt hd1 hrδ)
  -- `E g = 1`, `E 0 = 0`.
  have hE : E g = 1 := by simp [E, C01.E, g]
  have hE0 : E 0 = 0 := by simp [E, C01.E]
  rw [hE, hE0, Real.dist_eq, sub_zero, abs_one] at this
  exact lt_irrefl _ this

end Parcial1_2C2024
