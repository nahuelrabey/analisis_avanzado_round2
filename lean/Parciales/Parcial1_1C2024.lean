/-
Análisis Avanzado (FCEN-UBA) · Primer parcial · 1er cuatrimestre 2024
Enunciado y soluciones oficiales transcriptos en `apuntes-typst/parciales/2024_1c_parcial_1.typ`.

Este archivo verifica en Lean 4 + Mathlib las cuatro soluciones oficiales. Las diferencias
entre el texto de la cátedra y la formalización están anotadas en el `.typ`.
-/
import Mathlib

open Cardinal Filter Topology Polynomial

namespace Parcial1_1C2024

/-! ## Ejercicio 1

(a) `#ℚ[x] = ℵ₀`. (b) Los reales algebraicos `𝒜 = {α : ∃ p ∈ ℚ[x] ∖ {0}, p(α) = 0}` son numerables. -/

/-- La codificación "por grado" de la solución oficial: un polinomio de grado `n` queda
determinado por sus `n + 1` coeficientes. -/
def codif (p : ℚ[X]) : Σ n : ℕ, Fin (n + 1) → ℚ :=
  ⟨p.natDegree, fun i => p.coeff i⟩

/-- Dos pares `(n, f)`, `(m, g)` iguales tienen `n = m` y los mismos valores. -/
theorem sigma_eq_aux {n m : ℕ} {f : Fin (n + 1) → ℚ} {g : Fin (m + 1) → ℚ}
    (h : (⟨n, f⟩ : Σ k : ℕ, Fin (k + 1) → ℚ) = ⟨m, g⟩) (i : ℕ) (hi : i < n + 1)
    (hi' : i < m + 1) : f ⟨i, hi⟩ = g ⟨i, hi'⟩ := by
  cases h
  rfl

theorem codif_injective : Function.Injective codif := by
  intro p q h
  have hdeg : p.natDegree = q.natDegree := congrArg Sigma.fst h
  -- con el mismo grado, los coeficientes coinciden en `0, ..., n` ...
  have hcoef : ∀ i : ℕ, i ≤ p.natDegree → p.coeff i = q.coeff i :=
    fun i hi => sigma_eq_aux h i (by omega) (by omega)
  -- ... y son `0` después.
  apply Polynomial.ext
  intro n
  by_cases hn : n ≤ p.natDegree
  · exact hcoef n hn
  · push Not at hn
    rw [Polynomial.coeff_eq_zero_of_natDegree_lt hn,
      Polynomial.coeff_eq_zero_of_natDegree_lt (hdeg ▸ hn)]

/-- `ℚ[x]` es contable. -/
theorem countable_QX : Countable ℚ[X] := codif_injective.countable

/-- `ℚ[x]` es infinito: `n ↦ n` (el polinomio constante) es inyectiva. -/
theorem infinite_QX : Infinite ℚ[X] :=
  Infinite.of_injective (fun n : ℕ => (C (n : ℚ) : ℚ[X])) fun m n h => by
    have := congrArg (fun p : ℚ[X] => p.coeff 0) h
    simpa using this

/-- **Ejercicio 1 (a).** `#ℚ[x] = ℵ₀`. -/
theorem ej1a : #ℚ[X] = ℵ₀ :=
  have := countable_QX
  have := infinite_QX
  Cardinal.mk_eq_aleph0 ℚ[X]

/-- El conjunto `𝒜` de los reales algebraicos, como en el enunciado. -/
def 𝒜 : Set ℝ := {α | ∃ p : ℚ[X], p ≠ 0 ∧ aeval α p = 0}

/-- `R_p = {x ∈ ℝ : p(x) = 0}`. -/
def R (p : ℚ[X]) : Set ℝ := {x | aeval x p = 0}

/-- Cada `R_p` (con `p ≠ 0`) es finito. -/
theorem R_finite {p : ℚ[X]} (hp : p ≠ 0) : (R p).Finite := by
  have hmap : p.map (algebraMap ℚ ℝ) ≠ 0 := Polynomial.map_ne_zero hp
  have := Polynomial.finite_setOfPred_isRoot hmap
  apply this.subset
  intro x hx
  show (p.map (algebraMap ℚ ℝ)).IsRoot x
  rw [Polynomial.IsRoot, Polynomial.eval_map, ← Polynomial.aeval_def]
  exact hx

/-- `𝒜 = ⋃_{p ≠ 0} R_p`. -/
theorem 𝒜_eq : 𝒜 = ⋃ p ∈ {p : ℚ[X] | p ≠ 0}, R p := by
  ext x
  simp only [𝒜, R, Set.mem_ofPred_eq, Set.mem_iUnion, exists_prop]

/-- `ℚ ⊆ 𝒜`: `α` es raíz de `x - α`. -/
theorem rat_subset_𝒜 : Set.range ((↑) : ℚ → ℝ) ⊆ 𝒜 := by
  rintro _ ⟨q, rfl⟩
  refine ⟨X - C q, X_sub_C_ne_zero q, ?_⟩
  simp

/-- **Ejercicio 1 (b).** `#𝒜 = ℵ₀`. -/
theorem ej1b : #𝒜 = ℵ₀ := by
  have := countable_QX
  have hcount : 𝒜.Countable := by
    rw [𝒜_eq]
    exact Set.Countable.biUnion (Set.to_countable _) fun p hp => (R_finite hp).countable
  have hinf : 𝒜.Infinite :=
    (Set.infinite_range_of_injective Rat.cast_injective).mono rat_subset_𝒜
  have := hcount.to_subtype
  have := hinf.to_subtype
  exact Cardinal.mk_eq_aleph0 𝒜

/-! ## Ejercicio 2

`Ψ : (C[0,1], d_∞) → (C[0,1], d_1)`, `Ψ(f)(x) = x f(x)`, es uniformemente continua:
`d_1(Ψ f, Ψ g) ≤ d_∞(f, g) / 2`.

`C[0,1]` es `C(I, ℝ)` con la métrica `d_∞` de Mathlib; `d_1` se define como la integral de
`|f - g|` en `[0, 1]`, y la continuidad uniforme hacia `d_1` se escribe con `ε`-`δ`. -/

/-- Extiende `f : C(I, ℝ)` a `ℝ` (constante fuera de `[0, 1]`), para integrar en `ℝ`. -/
noncomputable def ext (f : C(unitInterval, ℝ)) : ℝ → ℝ :=
  fun x => f (Set.projIcc 0 1 zero_le_one x)

theorem continuous_ext (f : C(unitInterval, ℝ)) : Continuous (ext f) :=
  f.continuous.comp continuous_projIcc

theorem ext_of_mem (f : C(unitInterval, ℝ)) {x : ℝ} (hx : x ∈ Set.Icc (0 : ℝ) 1) :
    ext f x = f ⟨x, hx⟩ := by
  simp [ext, Set.projIcc_of_mem zero_le_one hx]

/-- La distancia `d_1(f, g) = ∫_0^1 |f(x) - g(x)| dx`. -/
noncomputable def d1 (f g : C(unitInterval, ℝ)) : ℝ :=
  ∫ x in (0 : ℝ)..1, |ext f x - ext g x|

/-- La función `Ψ` del enunciado. -/
def Ψ (f : C(unitInterval, ℝ)) : C(unitInterval, ℝ) :=
  ⟨fun x => (x : ℝ) * f x, by fun_prop⟩

@[simp] theorem Ψ_apply (f : C(unitInterval, ℝ)) (x : unitInterval) : Ψ f x = (x : ℝ) * f x := rfl

/-- La cuenta (2) de la solución oficial: `d_1(Ψ f, Ψ g) ≤ d_∞(f, g) / 2`. -/
theorem d1_Ψ_le (f g : C(unitInterval, ℝ)) : d1 (Ψ f) (Ψ g) ≤ dist f g / 2 := by
  unfold d1
  calc ∫ x in (0 : ℝ)..1, |ext (Ψ f) x - ext (Ψ g) x|
      ≤ ∫ x in (0 : ℝ)..1, x * dist f g := by
        apply intervalIntegral.integral_mono_on zero_le_one
        · exact ((continuous_ext _).sub (continuous_ext _)).abs.intervalIntegrable _ _
        · exact (continuous_id.mul continuous_const).intervalIntegrable _ _
        · intro x hx
          rw [ext_of_mem _ hx, ext_of_mem _ hx, Ψ_apply, Ψ_apply, ← mul_sub, abs_mul,
            abs_of_nonneg hx.1]
          apply mul_le_mul_of_nonneg_left _ hx.1
          rw [← Real.dist_eq]
          exact ContinuousMap.dist_apply_le_dist _
    _ = dist f g / 2 := by
        rw [intervalIntegral.integral_mul_const, integral_id]
        ring

/-- **Ejercicio 2.** `Ψ` es uniformemente continua de `(C[0,1], d_∞)` en `(C[0,1], d_1)`:
dado `ε`, sirve `δ = ε`. -/
theorem ej2 : ∀ ε > 0, ∃ δ > 0, ∀ f g, dist f g < δ → d1 (Ψ f) (Ψ g) < ε := by
  intro ε hε
  refine ⟨ε, hε, fun f g hfg => ?_⟩
  calc d1 (Ψ f) (Ψ g) ≤ dist f g / 2 := d1_Ψ_le f g
    _ < ε / 2 := by linarith
    _ < ε := by linarith

/-! ## Ejercicio 3

`X` compacto, `f : X → Y` continua ⇒ `f(cl A) = cl f(A)`. -/

/-- **Ejercicio 3.** -/
theorem ej3 {X Y : Type*} [MetricSpace X] [MetricSpace Y] [CompactSpace X]
    (f : X → Y) (hf : Continuous f) (A : Set X) :
    f '' closure A = closure (f '' A) := by
  apply subset_antisymm
  · -- `f(cl A) ⊆ cl f(A)`: vale por continuidad, sin compacidad.
    exact image_closure_subset_closure_image hf
  · -- `cl A` es cerrado en un compacto, luego compacto; su imagen es compacta, luego cerrada.
    have hcomp : IsCompact (f '' closure A) := isClosed_closure.isCompact.image hf
    exact closure_minimal (Set.image_mono subset_closure) hcomp.isClosed

/-! ## Ejercicio 4

`(ℝ, d)` con `d(x, y) = |x| + |y|` si `x ≠ y` y `d(x, x) = 0` es completo. -/

/-- `ℝ` con la métrica `d` del Ejercicio 4. -/
def Rd : Type := ℝ

/-- Ver un elemento de `Rd` como real, y viceversa. -/
def toR (x : Rd) : ℝ := x
def toRd (x : ℝ) : Rd := x

/-- La distancia del enunciado. -/
noncomputable def d (x y : ℝ) : ℝ := if x = y then 0 else |x| + |y|

/-- `(ℝ, d)` es un espacio métrico (el enunciado lo da por sabido; acá se verifica igual). -/
noncomputable instance : MetricSpace Rd where
  dist x y := d (toR x) (toR y)
  dist_self x := by simp [d]
  dist_comm x y := by
    simp only [d]
    by_cases h : toR x = toR y
    · rw [ite_eq_left h, ite_eq_left h.symm]
    · rw [ite_eq_right h, ite_eq_right (Ne.symm h)]; ring
  dist_triangle x y z := by
    simp only [d]
    by_cases hxz : toR x = toR z
    · rw [ite_eq_left hxz]; split_ifs <;> positivity
    · rw [ite_eq_right hxz]
      by_cases hxy : toR x = toR y
      · have hyz : toR y ≠ toR z := fun h => hxz (hxy.trans h)
        rw [ite_eq_left hxy, ite_eq_right hyz, hxy]; linarith
      · rw [ite_eq_right hxy]
        split_ifs with hyz
        · rw [← hyz]; linarith
        · linarith [abs_nonneg (toR y)]
  eq_of_dist_eq_zero := by
    intro x y h
    by_contra hxy
    have hxy' : toR x ≠ toR y := hxy
    simp only [d] at h
    rw [ite_eq_right hxy'] at h
    have hx : 0 ≤ |toR x| := abs_nonneg _
    have hy : 0 ≤ |toR y| := abs_nonneg _
    have hx0 : toR x = 0 := abs_eq_zero.1 (by linarith)
    have hy0 : toR y = 0 := abs_eq_zero.1 (by linarith)
    exact hxy' (hx0.trans hy0.symm)

theorem Rd.dist_eq (x y : Rd) :
    dist x y = if toR x = toR y then 0 else |toR x| + |toR y| := rfl

/-- `d(x, 0) ≤ |x|`. -/
theorem Rd.dist_zero_le (x : Rd) : dist x (toRd 0) ≤ |toR x| := by
  rw [Rd.dist_eq]
  split_ifs with h
  · exact abs_nonneg _
  · simp [toRd, toR]

/-- **Ejercicio 4.** `(ℝ, d)` es completo. Dada `(x_n)` de Cauchy: o es eventualmente constante
(y converge a esa constante), o `|x_n| → 0` (y converge a `0`, porque `d(x_n, 0) ≤ |x_n|`). -/
instance : CompleteSpace Rd := by
  apply Metric.complete_of_cauchySeq_tendsto
  intro x hx
  by_cases hconst : ∃ N c, ∀ n ≥ N, x n = c
  · -- Caso 1: eventualmente constante.
    obtain ⟨N, c, hc⟩ := hconst
    exact ⟨c, tendsto_atTop_of_eventually_const hc⟩
  · -- Caso 2: converge a `0`.
    push Not at hconst
    refine ⟨toRd 0, ?_⟩
    rw [Metric.tendsto_atTop]
    intro ε hε
    obtain ⟨N, hN⟩ := Metric.cauchySeq_iff.1 hx ε hε
    refine ⟨N, fun n hn => ?_⟩
    -- hay `m ≥ N` con `x m ≠ x n`; entonces `|x n| + |x m| = d(x n, x m) < ε`.
    obtain ⟨m, hm, hmn⟩ := hconst N (x n)
    have h := hN n hn m hm
    have hmn' : toR (x n) ≠ toR (x m) := fun h' => hmn (show x m = x n from h'.symm)
    rw [Rd.dist_eq, ite_eq_right hmn'] at h
    calc dist (x n) (toRd 0) ≤ |toR (x n)| := Rd.dist_zero_le _
      _ < ε := by linarith [abs_nonneg (toR (x m))]

end Parcial1_1C2024
