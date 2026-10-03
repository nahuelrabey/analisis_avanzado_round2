/-
Análisis Avanzado (FCEN-UBA) · Primer parcial · 08/05/2025
Enunciado transcripto en `apuntes-typst/parciales/2025_1c_parcial_1.typ`.

Cada ejercicio del parcial tiene acá su enunciado formalizado y una demostración
verificada por Lean 4 + Mathlib. Las resoluciones "a mano" (las que se escribirían en el
examen) están en el archivo Typst; este archivo certifica que esas resoluciones son correctas.

Convención sobre índices: en el curso las sucesiones empiezan en `n = 1`; en Lean usamos
`ℕ = {0, 1, 2, ...}`. La traducción es `a_n (curso) = a (n-1) (Lean)`. Ningún argumento
depende de dónde empieza la numeración.
-/
import Mathlib

open Cardinal Filter Topology BoundedContinuousFunction

namespace Parcial1_1C2025

/-! ## Ejercicio 1

`A` = sucesiones de enteros con `a (n+1) - a n ∈ {1, 2}` para todo `n`. Se prueba `#A = 𝔠`
construyendo la biyección `A ≃ ℤ × {1,2}^ℕ` (el término inicial y la lista de pasos),
y después calculando `#(ℤ × (ℕ → Bool)) = ℵ₀ · 2^ℵ₀ = 𝔠`. -/

/-- El conjunto `A` del Ejercicio 1. -/
def A : Set (ℕ → ℤ) := {a | ∀ n, a (n + 1) - a n = 1 ∨ a (n + 1) - a n = 2}

/-- Dado el término inicial `z` y una sucesión de decisiones `b` (`true` = paso de longitud 2,
`false` = paso de longitud 1), reconstruye la sucesión. -/
def reconstruir (z : ℤ) (b : ℕ → Bool) : ℕ → ℤ
  | 0 => z
  | n + 1 => reconstruir z b n + (if b n then 2 else 1)

/-- La lista de pasos de una sucesión: `true` exactamente cuando el paso `n` vale 2. -/
def pasos (a : ℕ → ℤ) : ℕ → Bool := fun n => decide (a (n + 1) - a n = 2)

theorem reconstruir_mem (z : ℤ) (b : ℕ → Bool) : reconstruir z b ∈ A := by
  intro n
  simp only [reconstruir]
  by_cases h : b n <;> simp [h]

theorem reconstruir_pasos (a : ℕ → ℤ) (ha : a ∈ A) : reconstruir (a 0) (pasos a) = a := by
  funext n
  induction n with
  | zero => rfl
  | succ n ih =>
    simp only [reconstruir, pasos, ih]
    rcases ha n with h | h
    · have : a (n + 1) - a n ≠ 2 := by omega
      simp [this]; omega
    · simp [h]; omega

theorem pasos_reconstruir (z : ℤ) (b : ℕ → Bool) : pasos (reconstruir z b) = b := by
  funext n
  simp only [pasos, reconstruir]
  by_cases hb : b n = true <;> simp [hb]

/-- La biyección del Ejercicio 1: una sucesión de `A` es lo mismo que su término inicial
junto con la lista (infinita) de decisiones "paso 1 / paso 2". -/
def equivA : A ≃ ℤ × (ℕ → Bool) where
  toFun a := (a.1 0, pasos a.1)
  invFun p := ⟨reconstruir p.1 p.2, reconstruir_mem _ _⟩
  left_inv a := Subtype.ext (reconstruir_pasos a.1 a.2)
  right_inv p := by
    obtain ⟨z, b⟩ := p
    simp [pasos_reconstruir, reconstruir]

/-- **Ejercicio 1.** El cardinal de `A` es el del continuo, `𝔠 = #ℝ`. -/
theorem ej1 : #A = 𝔠 := by
  rw [Cardinal.mk_congr equivA, Cardinal.mk_prod, Cardinal.lift_id, Cardinal.lift_id,
    Cardinal.mk_int, ← Cardinal.power_def, Cardinal.mk_bool, Cardinal.mk_nat,
    Cardinal.two_power_aleph0]
  exact Cardinal.aleph0_mul_continuum

theorem ej1' : #A = #ℝ := by rw [ej1, Cardinal.mk_real]

/-! ## Ejercicio 2

`A ⊆ ℝ` no vacío y acotado.
(a) `ínf A = ínf (cl A)` es **verdadera**.
(b) `ínf A = ínf A°` es **falsa**: contraejemplo `A = {0} ∪ [1, 2]`, con `A° = (1, 2)`. -/

/-- **Ejercicio 2 (a).** Para `A` no vacío y acotado inferiormente, `ínf A = ínf (cl A)`.
(Sólo hace falta la cota inferior; la cota superior del enunciado no se usa.) -/
theorem ej2a (A : Set ℝ) (hne : A.Nonempty) (hbdd : BddBelow A) :
    sInf A = sInf (closure A) := by
  -- `ínf A` es cota inferior de `cl A`: `A ⊆ [ínf A, ∞)` y ese conjunto es cerrado.
  have hlow : closure A ⊆ Set.Ici (sInf A) :=
    closure_minimal (fun a ha => csInf_le hbdd ha) isClosed_Ici
  apply le_antisymm
  · -- `ínf A ≤ ínf (cl A)` porque `ínf A` es cota inferior de `cl A`.
    exact le_csInf hne.closure (fun x hx => hlow hx)
  · -- `ínf (cl A) ≤ ínf A` porque `A ⊆ cl A` (una cota inferior de `cl A` lo es de `A`).
    exact csInf_le_csInf ⟨sInf A, fun x hx => hlow hx⟩ hne subset_closure

/-- El contraejemplo del Ejercicio 2 (b). -/
def B : Set ℝ := {0} ∪ Set.Icc 1 2

theorem B_nonempty : B.Nonempty := ⟨0, Or.inl rfl⟩

theorem B_bddBelow : BddBelow B := ⟨0, by
  rintro x (rfl | ⟨h1, _⟩)
  · exact le_rfl
  · linarith⟩

theorem B_bddAbove : BddAbove B := ⟨2, by
  rintro x (rfl | ⟨_, h2⟩)
  · norm_num
  · exact h2⟩

theorem interior_B : interior B = Set.Ioo 1 2 := by
  have h0 : interior ({0} : Set ℝ) = ∅ := by
    rw [← Set.Icc_self, interior_Icc, Set.Ioo_self]
  rw [B, Set.union_comm, interior_union_isClosed_of_interior_empty isClosed_Icc h0, interior_Icc]

theorem sInf_B : sInf B = 0 := by
  rw [B, Set.singleton_union, csInf_insert bddBelow_Icc (Set.nonempty_Icc.2 (by norm_num)),
    csInf_Icc (by norm_num)]
  norm_num

theorem sInf_interior_B : sInf (interior B) = 1 := by
  rw [interior_B, csInf_Ioo (by norm_num)]

/-- **Ejercicio 2 (b).** Existe `A ⊆ ℝ` no vacío y acotado, con interior no vacío, tal que
`ínf A ≠ ínf A°`. -/
theorem ej2b : ∃ A : Set ℝ, A.Nonempty ∧ BddBelow A ∧ BddAbove A ∧ (interior A).Nonempty ∧
    sInf A ≠ sInf (interior A) := by
  refine ⟨B, B_nonempty, B_bddBelow, B_bddAbove, ?_, ?_⟩
  · rw [interior_B]; exact Set.nonempty_Ioo.2 (by norm_num)
  · rw [sInf_B, sInf_interior_B]; norm_num

/-! ## Ejercicio 3

`U` es abierto si y sólo si `U ∩ cl T ⊆ cl (U ∩ T)` para todo `T`. -/

/-- **Ejercicio 3.** -/
theorem ej3 {E : Type*} [MetricSpace E] (U : Set E) :
    IsOpen U ↔ ∀ T : Set E, U ∩ closure T ⊆ closure (U ∩ T) := by
  constructor
  · -- (⇒) Si `U` es abierto, la bola que lo atestigua en `x` se puede achicar hasta entrar
    -- en cualquier bola `B(x, ε)` y ahí hay puntos de `T`, que también están en `U`.
    intro hU T
    exact hU.inter_closure
  · -- (⇐) Se aplica la hipótesis a `T = E ∖ U`: el lado derecho es `cl ∅ = ∅`.
    intro h
    have h1 : U ∩ closure Uᶜ ⊆ closure (U ∩ Uᶜ) := h Uᶜ
    rw [Set.inter_compl_self, closure_empty, Set.subset_empty_iff, closure_compl] at h1
    -- `h1 : U ∩ (interior U)ᶜ = ∅`, es decir `U ⊆ U°`, es decir `U` es abierto.
    have hsub : U ⊆ interior U := by
      intro x hx
      by_contra hx'
      have : x ∈ U ∩ (interior U)ᶜ := ⟨hx, hx'⟩
      rw [h1] at this
      exact this
    exact interior_eq_iff_isOpen.1 (subset_antisymm interior_subset hsub)

/-! ## Ejercicio 4

`X` = sucesiones reales eventualmente nulas, con `d_∞(a, b) = sup |a_n - b_n|`.
Se modela `X` como subconjunto de `ℕ →ᵇ ℝ` (funciones acotadas `ℕ → ℝ`, que en Mathlib
llevan exactamente la métrica del supremo); la métrica de `X` es la inducida.

(a) `A = {a ∈ X : a_n = 0 ∀ n ≥ 4}` (en Lean: `∀ n ≥ 3`, por el corrimiento de índice):
    `A° = ∅` y `cl A = A`.
(b) `(X, d_∞)` no es completo. -/

/-- El espacio `X` de las sucesiones eventualmente nulas. -/
def X : Set (ℕ →ᵇ ℝ) := {f | ∃ n₀, ∀ n ≥ n₀, f n = 0}

/-- El subconjunto `A` del Ejercicio 4 (a): las sucesiones nulas a partir del cuarto término. -/
def A4 : Set X := {a | ∀ n ≥ 3, (a : ℕ →ᵇ ℝ) n = 0}

/-- La sucesión `e₃ = (0, 0, 0, 1, 0, 0, ...)` (vale `1` en el índice `3`, que es el cuarto). -/
noncomputable def e₃ : ℕ →ᵇ ℝ :=
  BoundedContinuousFunction.ofNormedAddCommGroupDiscrete (fun n => if n = 3 then 1 else 0) 1
    (fun n => by split_ifs <;> simp)

@[simp] theorem e₃_apply (n : ℕ) : e₃ n = if n = 3 then 1 else 0 := rfl

theorem norm_e₃_le : ‖e₃‖ ≤ 1 := by
  rw [BoundedContinuousFunction.norm_le zero_le_one]
  intro n
  simp only [e₃_apply]
  split_ifs <;> simp

/-- Evaluar en una coordenada es continuo en `X`. -/
theorem continuous_eval_X (n : ℕ) : Continuous fun a : X => (a : ℕ →ᵇ ℝ) n :=
  (continuous_eval_const n).comp continuous_subtype_val

/-- **Ejercicio 4 (a), interior.** `A° = ∅`: en cualquier bola `B(a, ε)` con `a ∈ A` está
`a + (ε/2) e₃`, que es eventualmente nula pero tiene cuarto término `ε/2 ≠ 0`. -/
theorem ej4a_interior : interior A4 = ∅ := by
  rw [Set.eq_empty_iff_forall_notMem]
  intro a ha
  have haA : a ∈ A4 := interior_subset ha
  rw [mem_interior_iff_mem_nhds, Metric.mem_nhds_iff] at ha
  obtain ⟨ε, hε, hball⟩ := ha
  -- la perturbación `g = a + (ε/2) e₃`, que sigue en `X`
  obtain ⟨n₀, hn₀⟩ := a.2
  let g : X := ⟨(a : ℕ →ᵇ ℝ) + (ε / 2) • e₃, max n₀ 4, fun n hn => by
    have h1 : n ≥ n₀ := le_trans (le_max_left _ _) hn
    have h2 : n ≠ 3 := by have := le_trans (le_max_right _ _) hn; omega
    simp [hn₀ n h1, h2]⟩
  have hg : g ∈ Metric.ball a ε := by
    rw [Metric.mem_ball, Subtype.dist_eq]
    change dist ((a : ℕ →ᵇ ℝ) + (ε / 2) • e₃) (a : ℕ →ᵇ ℝ) < ε
    rw [dist_self_add_left, norm_smul, Real.norm_eq_abs, abs_of_pos (by positivity)]
    calc ε / 2 * ‖e₃‖ ≤ ε / 2 * 1 := by gcongr; exact norm_e₃_le
      _ < ε := by linarith
  have hgA : g ∈ A4 := hball hg
  -- el cuarto término de `g` debería ser `0`, pero vale `a 3 + ε/2 = ε/2 > 0`.
  have h3 := hgA 3 le_rfl
  change ((a : ℕ →ᵇ ℝ) + (ε / 2) • e₃) 3 = 0 at h3
  have ha3 : (a : ℕ →ᵇ ℝ) 3 = 0 := haA 3 le_rfl
  simp [ha3] at h3
  linarith

/-- **Ejercicio 4 (a), clausura.** `A` es cerrado (intersección de las preimágenes del cerrado
`{0}` por las evaluaciones continuas en las coordenadas `n ≥ 3`), luego `cl A = A`. -/
theorem ej4a_isClosed : IsClosed A4 := by
  have : A4 = ⋂ n ∈ {n : ℕ | 3 ≤ n}, {a : X | (a : ℕ →ᵇ ℝ) n = 0} := by
    ext a; simp [A4]
  rw [this]
  exact isClosed_biInter fun n _ => isClosed_eq (continuous_eval_X n) continuous_const

theorem ej4a_closure : closure A4 = A4 := ej4a_isClosed.closure_eq

/-- La sucesión de la sugerencia, truncada: `a⁽ᴺ⁾ = (1, 1/2, ..., 1/N, 0, 0, ...)`.
En Lean (índices desde 0): `a⁽ᴺ⁾ n = 1/(n+1)` si `n < N`, y `0` si no. -/
noncomputable def aN (N : ℕ) : X :=
  ⟨BoundedContinuousFunction.ofNormedAddCommGroupDiscrete
      (fun n => if n < N then 1 / ((n : ℝ) + 1) else 0) 1 (fun n => by
        split_ifs
        · rw [Real.norm_eq_abs, abs_of_pos (by positivity)]
          rw [div_le_one (by positivity)]; linarith [(Nat.cast_nonneg n : (0:ℝ) ≤ n)]
        · simp),
    N, fun n hn => by simp [not_lt.2 hn]⟩

@[simp] theorem aN_apply (N n : ℕ) :
    (aN N : ℕ →ᵇ ℝ) n = if n < N then 1 / ((n : ℝ) + 1) else 0 := rfl

/-- `(a⁽ᴺ⁾)_N` es de Cauchy en `X`: para `n, m ≥ N`, `d_∞(a⁽ⁿ⁾, a⁽ᵐ⁾) ≤ 1/(N+1)`. -/
theorem aN_cauchySeq : CauchySeq aN := by
  refine cauchySeq_of_le_tendsto_0 (fun N : ℕ => 1 / ((N : ℝ) + 1)) ?_
    tendsto_one_div_add_atTop_nhds_zero_nat
  intro n m N hn hm
  rw [Subtype.dist_eq, BoundedContinuousFunction.dist_le (by positivity)]
  intro k
  simp only [aN_apply, Real.dist_eq]
  have hk : ∀ j : ℕ, N ≤ j → (1 : ℝ) / ((j : ℝ) + 1) ≤ 1 / ((N : ℝ) + 1) := fun j hj =>
    one_div_le_one_div_of_le (by positivity) (by exact_mod_cast Nat.add_le_add_right hj 1)
  split_ifs with h1 h2 h2
  · rw [sub_self, abs_zero]; positivity
  · rw [sub_zero, abs_of_pos (by positivity)]; exact hk k (by omega)
  · rw [zero_sub, abs_neg, abs_of_pos (by positivity)]; exact hk k (by omega)
  · rw [sub_self, abs_zero]; positivity

/-- **Ejercicio 4 (b).** `(X, d_∞)` no es completo: la sucesión de Cauchy `(a⁽ᴺ⁾)_N` no
converge en `X`, porque su único límite posible es `(1, 1/2, 1/3, ...)`, que no es
eventualmente nula. -/
theorem ej4b : ¬ CompleteSpace X := by
  intro hc
  obtain ⟨b, hb⟩ := cauchySeq_tendsto_of_complete aN_cauchySeq
  obtain ⟨n₀, hn₀⟩ := b.2
  -- la coordenada `n₀` converge a `b n₀ = 0` ...
  have hcoord : Tendsto (fun N => (aN N : ℕ →ᵇ ℝ) n₀) atTop (𝓝 ((b : ℕ →ᵇ ℝ) n₀)) :=
    ((continuous_eval_X n₀).tendsto b).comp hb
  -- ... pero esa coordenada vale `1/(n₀+1)` para todo `N > n₀`.
  have hconst : Tendsto (fun N => (aN N : ℕ →ᵇ ℝ) n₀) atTop (𝓝 (1 / ((n₀ : ℝ) + 1))) := by
    refine tendsto_const_nhds.congr' ?_
    filter_upwards [eventually_gt_atTop n₀] with N hN
    simp [hN]
  have := tendsto_nhds_unique hcoord hconst
  rw [hn₀ n₀ le_rfl] at this
  have : (0 : ℝ) < 1 / ((n₀ : ℝ) + 1) := by positivity
  linarith

end Parcial1_1C2025
