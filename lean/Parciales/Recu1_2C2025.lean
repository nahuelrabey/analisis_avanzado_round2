/-
Análisis Avanzado (FCEN-UBA) · Recuperatorio del primer parcial · 04/12/2025
Enunciado transcripto en `apuntes-typst/parciales/2025_2c_recuperatorio_1.typ`.

Cada ejercicio tiene acá su enunciado formalizado y una demostración verificada por
Lean 4 + Mathlib. Las resoluciones "a mano" están en el archivo Typst.

Convención sobre índices: en el curso `ℕ = {1, 2, ...}`; donde importa, se escribe
explícitamente `1 ≤ n` o se usa `n + 1`.

Qué usa de `Comun`: las Definiciones 2, 3, 5 y 6 (`EsSup`, `EsMax`, `EsInf`, `EsMin`) con sus
puentes `esSup_iff_isLUB`, `esInf_iff_isGLB`, `esInf_unique` para los corolarios `_curso` del
Ej. 1 (`Comun.Supremos`), el puente `numerable_iff_mk_eq_aleph0` para el del Ej. 2
(`Comun.Cardinales`), y la métrica discreta `Disc ℝ` con su instancia y `Disc.dist_eq`
(`Comun.Metricas.Discreta`; `Rδ` es un alias). Quedan locales: `A1`, `C`, los Ej. 3 y 5 y el
plano `P` del Ej. 4.
-/
import Mathlib
import Comun.Supremos
import Comun.Cardinales
import Comun.Metricas.Discreta

open Cardinal Filter Topology Comun
open scoped Classical

namespace Recu1_2C2025

/-! ## Ejercicio 1

`A = {1 / (n² - 8n + 18) : n ∈ ℕ}`. Como `n² - 8n + 18 = (n - 4)² + 2 ≥ 2`, con igualdad sólo
en `n = 4`: `sup A = máx A = 1/2`, `ínf A = 0` y no hay mínimo. -/

/-- El conjunto `A` del Ejercicio 1 (con `n ≥ 1`, como en el curso). -/
def A1 : Set ℝ := {x | ∃ n : ℕ, 1 ≤ n ∧ x = 1 / ((n : ℝ) ^ 2 - 8 * n + 18)}

theorem denom_eq (n : ℕ) : (n : ℝ) ^ 2 - 8 * n + 18 = ((n : ℝ) - 4) ^ 2 + 2 := by ring

theorem denom_ge_two (n : ℕ) : 2 ≤ (n : ℝ) ^ 2 - 8 * n + 18 := by
  rw [denom_eq]; nlinarith [sq_nonneg ((n : ℝ) - 4)]

theorem denom_pos (n : ℕ) : 0 < (n : ℝ) ^ 2 - 8 * n + 18 := by linarith [denom_ge_two n]

/-- **Ejercicio 1, supremo y máximo.** `1/2 ∈ A` y es cota superior. -/
theorem ej1_isGreatest : IsGreatest A1 (1 / 2) := by
  constructor
  · exact ⟨4, by norm_num, by norm_num⟩
  · rintro x ⟨n, _, rfl⟩
    exact one_div_le_one_div_of_le (by norm_num) (denom_ge_two n)

theorem ej1_sSup : sSup A1 = 1 / 2 := ej1_isGreatest.csSup_eq

theorem ej1_max_mem : (1 / 2 : ℝ) ∈ A1 := ej1_isGreatest.1

/-- **Ejercicio 1, ínfimo.** `ínf A = 0`. -/
theorem ej1_sInf : sInf A1 = 0 := by
  apply csInf_eq_of_forall_ge_of_forall_gt_exists_lt ⟨1 / 2, ej1_isGreatest.1⟩ ?_ ?_
  · rintro x ⟨n, _, rfl⟩
    exact le_of_lt (one_div_pos.2 (denom_pos n))
  · intro w hw
    -- un `n ≥ 5` con `n - 4 > 1/w` hace `(n-4)² + 2 > 1/w`.
    obtain ⟨N, hN⟩ := exists_nat_gt (4 + 1 / w)
    refine ⟨1 / ((N : ℝ) ^ 2 - 8 * N + 18), ⟨N, ?_, rfl⟩, ?_⟩
    · have : (4 : ℝ) < N := by linarith [one_div_pos.2 hw]
      exact_mod_cast (show (1 : ℝ) ≤ N by linarith)
    · rw [div_lt_iff₀ (denom_pos N), denom_eq]
      have h1 : 1 / w < (N : ℝ) - 4 := by linarith
      have h3 : 1 / w < ((N : ℝ) - 4) ^ 2 + 2 := by
        nlinarith [sq_nonneg ((N : ℝ) - 4 - 1 / 2)]
      calc (1 : ℝ) = 1 / w * w := by field_simp
        _ < (((N : ℝ) - 4) ^ 2 + 2) * w := mul_lt_mul_of_pos_right h3 hw
        _ = w * (((N : ℝ) - 4) ^ 2 + 2) := by ring

/-- **Ejercicio 1, no hay mínimo.** `0 ∉ A`. -/
theorem ej1_no_min : (0 : ℝ) ∉ A1 := by
  rintro ⟨n, _, hn⟩
  have := one_div_pos.2 (denom_pos n)
  linarith

/-- **Ejercicio 1, supremo y máximo**, en el dialecto del curso: `1/2` es el máximo de `A`
(Definición 3: es el supremo y pertenece a `A`). -/
theorem ej1_max_curso : EsMax A1 (1 / 2) :=
  ⟨esSup_iff_isLUB.2 ej1_isGreatest.isLUB, ej1_max_mem⟩

/-- **Ejercicio 1, ínfimo**, en el dialecto del curso: `0` es el ínfimo de `A` (Definición 5). -/
theorem ej1_sInf_curso : EsInf A1 0 := by
  have h := isGLB_csInf ⟨1 / 2, ej1_max_mem⟩
    ⟨0, by rintro x ⟨n, _, rfl⟩; exact (one_div_pos.2 (denom_pos n)).le⟩
  rwa [ej1_sInf] at h

/-- **Ejercicio 1, no hay mínimo**, en el dialecto del curso (Definición 6): un mínimo sería el
ínfimo `0`, que no pertenece a `A`. -/
theorem ej1_no_min_curso : ¬ ∃ m, EsMin A1 m := by
  rintro ⟨m, hm, hmem⟩
  rw [esInf_unique hm ej1_sInf_curso] at hmem
  exact ej1_no_min hmem

/-! ## Ejercicio 2

`C = {f : ℚ → ℕ : f(q) = 3 salvo finitos q}` tiene cardinal `ℵ₀`. -/

/-- El conjunto `C` del Ejercicio 2. -/
def C : Set (ℚ → ℕ) := {f | {q | f q ≠ 3}.Finite}

/-- El "gráfico reducido" de `f`: los pares `(q, f q)` con `f q ≠ 3`. Es un conjunto finito. -/
def grafico (f : ℚ → ℕ) : Set (ℚ × ℕ) := {p | f p.1 = p.2 ∧ p.2 ≠ 3}

theorem grafico_finite (f : C) : (grafico f.1).Finite := by
  have : grafico f.1 ⊆ (fun q => (q, f.1 q)) '' {q | f.1 q ≠ 3} := by
    rintro ⟨q, k⟩ ⟨h1, h2⟩
    simp only at h1 h2
    refine ⟨q, ?_, Prod.ext rfl h1⟩
    show f.1 q ≠ 3
    rw [h1]; exact h2
  exact (f.2.image _).subset this

theorem grafico_injective : Function.Injective (fun f : C => grafico f.1) := by
  intro f g h
  apply Subtype.ext
  funext q
  have key : ∀ f g : C, grafico f.1 = grafico g.1 → f.1 q ≠ 3 → f.1 q = g.1 q := by
    intro f g h hf
    have : (q, f.1 q) ∈ grafico f.1 := ⟨rfl, hf⟩
    rw [h] at this
    exact this.1.symm
  by_cases hf : f.1 q = 3
  · by_cases hg : g.1 q = 3
    · rw [hf, hg]
    · exact (key g f h.symm hg).symm
  · exact key f g h hf

/-- `C` es contable: se inyecta en los subconjuntos finitos de `ℚ × ℕ`, que son contables. -/
theorem C_countable : Countable C := by
  have hcount : Countable {t : Set (ℚ × ℕ) | t.Finite ∧ t ⊆ Set.univ} :=
    (Set.countable_ofPred_finite_subset (Set.countable_univ)).to_subtype
  let Ψ : C → {t : Set (ℚ × ℕ) | t.Finite ∧ t ⊆ Set.univ} :=
    fun f => ⟨grafico f.1, grafico_finite f, Set.subset_univ _⟩
  have hΨ : Function.Injective Ψ := by
    intro f g h
    exact grafico_injective (congrArg Subtype.val h)
  exact hΨ.countable

/-- `C` es infinito: las funciones `f_k = 3` salvo `f_k(0) = k` son distintas y están en `C`. -/
theorem C_infinite : Infinite C := by
  let f : ℕ → C := fun k => ⟨fun q => if q = 0 then k else 3, by
    apply Set.Finite.subset (Set.finite_singleton (0 : ℚ))
    intro q hq
    simp only [Set.mem_ofPred_eq] at hq
    by_contra h0
    exact hq (ite_eq_right_iff.2 fun h => absurd h h0)⟩
  apply Infinite.of_injective f
  intro k₁ k₂ h
  have := congrFun (congrArg Subtype.val h) 0
  simpa [f] using this

/-- **Ejercicio 2.** `#C = ℵ₀`. -/
theorem ej2 : #C = ℵ₀ :=
  haveI := C_countable
  haveI := C_infinite
  Cardinal.mk_eq_aleph0 C

/-- **Ejercicio 2**, en el dialecto del curso: `C` es numerable (Definición 3.6). -/
theorem ej2_curso : Numerable C := numerable_iff_mk_eq_aleph0.2 ej2

/-! ## Ejercicio 3

(a) `A` abierto y `A ∩ cl B ≠ ∅` ⇒ `A ∩ B ≠ ∅`.
(b) Sin `A` abierto es falso: `A = {0}`, `B = (0, 1)` en `ℝ`. -/

/-- **Ejercicio 3 (a).** -/
theorem ej3a {E : Type*} [MetricSpace E] (A B : Set E) (hA : IsOpen A)
    (h : (A ∩ closure B).Nonempty) : (A ∩ B).Nonempty :=
  closure_nonempty_iff.1 (h.mono hA.inter_closure)

/-- **Ejercicio 3 (b).** -/
theorem ej3b : ∃ A B : Set ℝ, (A ∩ closure B).Nonempty ∧ A ∩ B = ∅ := by
  refine ⟨{0}, Set.Ioo 0 1, ⟨0, rfl, ?_⟩, ?_⟩
  · rw [closure_Ioo zero_ne_one]; exact ⟨le_rfl, zero_le_one⟩
  · rw [Set.eq_empty_iff_forall_notMem]
    rintro x ⟨rfl, h1, _⟩
    exact lt_irrefl _ h1

/-! ## Ejercicio 4

`d((x₁, y₁), (x₂, y₂)) = √(|x₁ - x₂|² + δ(y₁, y₂)²)` con `δ` la métrica discreta en `ℝ`.
Es la métrica producto "ℓ²" de `(ℝ, |·|)` y `(ℝ, δ)`, que en Mathlib es `WithLp 2 (ℝ × Rδ)`. -/

/-- `ℝ` con la métrica discreta (`Comun.Disc ℝ`, con su instancia de `MetricSpace`). -/
abbrev Rδ : Type := Disc ℝ

theorem Rδ.dist_eq (x y : Rδ) : dist x y = if x = y then 0 else 1 := Disc.dist_eq x y

/-- El plano con la métrica `d` del enunciado. -/
abbrev P := WithLp 2 (ℝ × Rδ)

/-- Un punto de `P` a partir de sus coordenadas. -/
def pt (x y : ℝ) : P := WithLp.toLp 2 (x, (y : Rδ))

theorem P.dist_eq (p q : P) :
    dist p q = Real.sqrt (|p.fst - q.fst| ^ 2 + (if p.snd = q.snd then 0 else 1) ^ 2) := by
  rw [WithLp.prod_dist_eq_add (by norm_num : (0 : ℝ) < (2 : ENNReal).toReal), Real.sqrt_eq_rpow,
    Real.dist_eq, Rδ.dist_eq]
  norm_num

/-- **Ejercicio 4 (a).** `B((0, 0), 1/2) = (-1/2, 1/2) × {0}`. -/
theorem ej4a : Metric.ball (pt 0 0) (1 / 2) =
    {p : P | p.fst ∈ Set.Ioo (-(1 / 2)) (1 / 2) ∧ p.snd = (0 : ℝ)} := by
  ext p
  rw [Metric.mem_ball, P.dist_eq, Real.sqrt_lt' (by norm_num)]
  change |p.fst - 0| ^ 2 + (if p.snd = (0 : ℝ) then 0 else 1) ^ 2 < (1 / 2) ^ 2 ↔
    (-(1 / 2) < p.fst ∧ p.fst < 1 / 2) ∧ p.snd = (0 : ℝ)
  by_cases h : p.snd = (0 : ℝ)
  · rw [ite_eq_left h, zero_pow two_ne_zero, add_zero, sub_zero,
      sq_lt_sq₀ (abs_nonneg _) (by norm_num), abs_lt]
    exact (and_iff_left h).symm
  · rw [ite_eq_right h]
    simp only [h, and_false, iff_false, not_lt]
    norm_num
    nlinarith [sq_nonneg (WithLp.fst p)]

/-- **Ejercicio 4 (b).** La sucesión `(1/n, 1/n)` no converge a `(0, 0)`: todos sus términos
están a distancia `≥ 1` de `(0, 0)`, porque `δ(1/n, 0) = 1`. -/
theorem ej4b : ¬ Tendsto (fun n : ℕ => pt (1 / ((n : ℝ) + 1)) (1 / ((n : ℝ) + 1))) atTop
    (𝓝 (pt 0 0)) := by
  intro h
  rw [Metric.tendsto_atTop] at h
  obtain ⟨N, hN⟩ := h 1 one_pos
  have h1 := hN N le_rfl
  rw [P.dist_eq] at h1
  have hne : (1 / ((N : ℝ) + 1) : ℝ) ≠ 0 := by positivity
  change Real.sqrt (|1 / ((N : ℝ) + 1) - 0| ^ 2 +
    (if (1 / ((N : ℝ) + 1) : ℝ) = 0 then 0 else 1) ^ 2) < 1 at h1
  rw [ite_eq_right hne, one_pow] at h1
  have h2 : (1 : ℝ) ≤ Real.sqrt (|1 / ((N : ℝ) + 1) - 0| ^ 2 + 1) :=
    Real.one_le_sqrt.2 (by nlinarith [sq_nonneg (|1 / ((N : ℝ) + 1) - 0|)])
  linarith

/-! ## Ejercicio 5

`f` es continua si y sólo si `f⁻¹(B°) ⊆ (f⁻¹(B))°` para todo `B`. -/

/-- **Ejercicio 5.** -/
theorem ej5 {E E' : Type*} [MetricSpace E] [MetricSpace E'] (f : E → E') :
    Continuous f ↔ ∀ B : Set E', f ⁻¹' (interior B) ⊆ interior (f ⁻¹' B) := by
  constructor
  · intro hf B
    exact preimage_interior_subset_interior_preimage hf
  · intro h
    rw [continuous_def]
    intro V hV
    have := h V
    rw [hV.interior_eq] at this
    exact interior_eq_iff_isOpen.1 (subset_antisymm interior_subset this)

end Recu1_2C2025
