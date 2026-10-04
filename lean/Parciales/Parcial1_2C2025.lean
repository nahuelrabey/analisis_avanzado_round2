/-
Análisis Avanzado (FCEN-UBA) · Primer parcial · 16/10/2025
Enunciado transcripto en `apuntes-typst/parciales/2025_2c_parcial_1.typ`.

Cada ejercicio tiene acá su enunciado formalizado y una demostración verificada por
Lean 4 + Mathlib. Las resoluciones "a mano" están en el archivo Typst.

Convención sobre índices: en el curso `ℕ = {1, 2, ...}` y las sucesiones arrancan en `1`; en
Lean arrancan en `0`. Donde importa, se escribe `1 ≤ n` o se usa `n + 1`.
-/
import Mathlib

open Cardinal Filter Topology

namespace Parcial1_2C2025

/-! ## Ejercicio 1

`A = {m / (m + n) : m, n ∈ ℕ}`: `sup A = 1` e `ínf A = 0`, ninguno alcanzado. -/

/-- El conjunto `A` del Ejercicio 1 (con `m, n ≥ 1`). -/
def A1 : Set ℝ := {x | ∃ m n : ℕ, 1 ≤ m ∧ 1 ≤ n ∧ x = (m : ℝ) / (m + n)}

theorem A1_nonempty : A1.Nonempty := ⟨1 / 2, 1, 1, le_rfl, le_rfl, by norm_num⟩

theorem mem_A1_lt_one {x : ℝ} (hx : x ∈ A1) : x < 1 := by
  obtain ⟨m, n, hm, hn, rfl⟩ := hx
  have hn' : (1 : ℝ) ≤ n := by exact_mod_cast hn
  rw [div_lt_one (by positivity)]; linarith

theorem mem_A1_pos {x : ℝ} (hx : x ∈ A1) : 0 < x := by
  obtain ⟨m, n, hm, hn, rfl⟩ := hx
  have hm' : (1 : ℝ) ≤ m := by exact_mod_cast hm
  positivity

/-- **Ejercicio 1, supremo.** `sup A = 1` (y `1 ∉ A`, así que no es máximo). -/
theorem ej1_sSup : sSup A1 = 1 := by
  apply csSup_eq_of_forall_le_of_forall_lt_exists_gt A1_nonempty
  · intro x hx; exact (mem_A1_lt_one hx).le
  · intro w hw
    -- `m / (m + 1) > w` apenas `m (1 - w) > 1`.
    obtain ⟨m, hm⟩ := exists_nat_gt (1 / (1 - w))
    have h1w : 0 < 1 - w := by linarith
    have hm1 : (1 : ℝ) < m * (1 - w) := by
      rw [div_lt_iff₀ h1w] at hm; linarith
    have hmpos : 0 < m := by exact_mod_cast lt_trans (one_div_pos.2 h1w) hm
    have hm0 : (1 : ℝ) ≤ m := by exact_mod_cast hmpos
    refine ⟨(m : ℝ) / (m + 1), ⟨m, 1, by exact_mod_cast hm0, le_rfl, by push_cast; rfl⟩, ?_⟩
    rw [lt_div_iff₀ (by positivity)]
    nlinarith

theorem ej1_one_notMem : (1 : ℝ) ∉ A1 := fun h => lt_irrefl _ (mem_A1_lt_one h)

/-- **Ejercicio 1, ínfimo.** `ínf A = 0` (y `0 ∉ A`, así que no es mínimo). -/
theorem ej1_sInf : sInf A1 = 0 := by
  apply csInf_eq_of_forall_ge_of_forall_gt_exists_lt A1_nonempty
  · intro x hx; exact (mem_A1_pos hx).le
  · intro w hw
    -- `1 / (1 + n) < w` apenas `n > 1 / w`.
    obtain ⟨n, hn⟩ := exists_nat_gt (1 / w)
    have hnpos : 0 < n := by exact_mod_cast lt_trans (one_div_pos.2 hw) hn
    have hn0 : (1 : ℝ) ≤ n := by exact_mod_cast hnpos
    refine ⟨(1 : ℝ) / (1 + n), ⟨1, n, le_rfl, by exact_mod_cast hn0, by push_cast; rfl⟩, ?_⟩
    rw [div_lt_iff₀ (by positivity)]
    rw [div_lt_iff₀ hw] at hn
    linarith

theorem ej1_zero_notMem : (0 : ℝ) ∉ A1 := fun h => lt_irrefl _ (mem_A1_pos h)

/-! ## Ejercicio 2

`A = {(a_n) ⊆ ℚ : ∃ k, a_{n+k} = (a_k)^n ∀ n}` tiene cardinal `ℵ₀`.

Con índices desde `0`: `a (n + k + 1) = (a k) ^ (n + 1)` para todo `n`. Una sucesión de `A`
queda determinada por sus primeros `k + 1` términos, así que `A ⊆ ⋃_k (imagen de ℚ^(k+1))`. -/

/-- El conjunto `A` del Ejercicio 2. -/
def A2 : Set (ℕ → ℚ) := {a | ∃ k, ∀ n, a (n + k + 1) = (a k) ^ (n + 1)}

/-- Extiende `k + 1` valores iniciales a la única sucesión de `A` que empieza así. -/
def extiende (k : ℕ) (v : Fin (k + 1) → ℚ) : ℕ → ℚ := fun n =>
  if h : n ≤ k then v ⟨n, by omega⟩ else (v ⟨k, by omega⟩) ^ (n - k)

theorem A2_subset : A2 ⊆ ⋃ k, Set.range (extiende k) := by
  rintro a ⟨k, hk⟩
  rw [Set.mem_iUnion]
  refine ⟨k, fun i => a i, ?_⟩
  funext n
  simp only [extiende]
  split_ifs with h
  · rfl
  · push Not at h
    have := hk (n - k - 1)
    rw [show n - k - 1 + k + 1 = n by omega, show n - k - 1 + 1 = n - k by omega] at this
    exact this.symm

theorem A2_countable : A2.Countable :=
  (Set.countable_iUnion fun k => Set.countable_range (extiende k)).mono A2_subset

/-- Las sucesiones `(q, q, q², q³, ...)` están en `A` (con `k = 0`) y son distintas. -/
def geom (q : ℚ) : ℕ → ℚ := fun n => if n = 0 then q else q ^ n

theorem geom_mem (q : ℚ) : geom q ∈ A2 :=
  ⟨0, fun n => by simp [geom]⟩

theorem A2_infinite : Infinite A2 := by
  apply Infinite.of_injective (fun q : ℚ => (⟨geom q, geom_mem q⟩ : A2))
  intro q₁ q₂ h
  have := congrFun (congrArg Subtype.val h) 0
  simpa [geom] using this

/-- **Ejercicio 2.** `#A = ℵ₀`. -/
theorem ej2 : #A2 = ℵ₀ :=
  haveI := A2_countable.to_subtype
  haveI := A2_infinite
  Cardinal.mk_eq_aleph0 A2

/-! ## Ejercicio 3

Dos puntos distintos tienen entornos abiertos con clausuras disjuntas. -/

/-- **Ejercicio 3.** -/
theorem ej3 {E : Type*} [MetricSpace E] (x y : E) (hxy : x ≠ y) :
    ∃ U V : Set E, IsOpen U ∧ IsOpen V ∧ x ∈ U ∧ y ∈ V ∧ closure U ∩ closure V = ∅ := by
  have hr : 0 < dist x y := dist_pos.2 hxy
  refine ⟨Metric.ball x (dist x y / 3), Metric.ball y (dist x y / 3), Metric.isOpen_ball,
    Metric.isOpen_ball, Metric.mem_ball_self (by positivity), Metric.mem_ball_self (by positivity),
    ?_⟩
  rw [Set.eq_empty_iff_forall_notMem]
  rintro z ⟨hzU, hzV⟩
  have h1 := Metric.closure_ball_subset_closedBall hzU
  have h2 := Metric.closure_ball_subset_closedBall hzV
  rw [Metric.mem_closedBall] at h1 h2
  have := dist_triangle x z y
  rw [dist_comm z x] at h1
  linarith

/-! ## Ejercicio 4

`d̃(A, B) = ínf {d(a, b) : a ∈ A, b ∈ B}`.
(a) `⋃ cl(M_n) ⊆ cl(⋃ M_n)`.
(b) Si `d̃(M_n, M_m) > ε` para `n ≠ m`, vale la igualdad. -/

/-- La distancia entre conjuntos del enunciado. -/
noncomputable def dtilde {E : Type*} [MetricSpace E] (A B : Set E) : ℝ :=
  sInf {r | ∃ a ∈ A, ∃ b ∈ B, r = dist a b}

/-- `d̃(A, B) ≤ d(a, b)` para todo `a ∈ A`, `b ∈ B`. -/
theorem dtilde_le {E : Type*} [MetricSpace E] {A B : Set E} {a b : E} (ha : a ∈ A) (hb : b ∈ B) :
    dtilde A B ≤ dist a b := by
  apply csInf_le
  · refine ⟨0, ?_⟩
    rintro r ⟨a', _, b', _, rfl⟩
    exact dist_nonneg
  · exact ⟨a, ha, b, hb, rfl⟩

/-- **Ejercicio 4 (a).** -/
theorem ej4a {E : Type*} [MetricSpace E] (M : ℕ → Set E) :
    ⋃ n, closure (M n) ⊆ closure (⋃ n, M n) :=
  Set.iUnion_subset fun n => closure_mono (Set.subset_iUnion M n)

/-- **Ejercicio 4 (b).** -/
theorem ej4b {E : Type*} [MetricSpace E] (M : ℕ → Set E) (ε : ℝ) (hε : 0 < ε)
    (hsep : ∀ n m, n ≠ m → ε < dtilde (M n) (M m)) :
    closure (⋃ n, M n) = ⋃ n, closure (M n) := by
  apply subset_antisymm _ (ej4a M)
  intro x hx
  rw [Metric.mem_closure_iff] at hx
  -- un punto `y₀ ∈ M n₀` a distancia `< ε/2` de `x`
  obtain ⟨y₀, hy₀, hd₀⟩ := hx (ε / 2) (by positivity)
  rw [Set.mem_iUnion] at hy₀
  obtain ⟨n₀, hn₀⟩ := hy₀
  rw [Set.mem_iUnion]
  refine ⟨n₀, ?_⟩
  rw [Metric.mem_closure_iff]
  intro r hr
  -- todo punto de `⋃ M_n` a distancia `< ε/2` de `x` está en `M n₀`
  obtain ⟨y, hy, hdy⟩ := hx (min r (ε / 2)) (by positivity)
  rw [Set.mem_iUnion] at hy
  obtain ⟨m, hm⟩ := hy
  by_cases h : m = n₀
  · subst h
    exact ⟨y, hm, lt_of_lt_of_le hdy (min_le_left _ _)⟩
  · exfalso
    have h1 : ε < dist y y₀ := lt_of_lt_of_le (hsep m n₀ h) (dtilde_le hm hn₀)
    have h2 : dist y y₀ ≤ dist y x + dist x y₀ := dist_triangle _ _ _
    have h3 : dist x y < ε / 2 := lt_of_lt_of_le hdy (min_le_right _ _)
    rw [dist_comm y x] at h2
    linarith

/-! ## Ejercicio 5

`F(f, x) = f(x)` es continua en `C([0, 1]) × [0, 1]` con la métrica
`d((f, x), (g, y)) = máx{d_∞(f, g), |x - y|}`, que es la métrica producto de Mathlib. -/

/-- La evaluación `F(f, x) = f(x)`. -/
def F (p : C(unitInterval, ℝ) × unitInterval) : ℝ := p.1 p.2

/-- La métrica de `C([0,1]) × [0,1]` en Mathlib es exactamente la del enunciado. -/
theorem dist_prod_eq (p q : C(unitInterval, ℝ) × unitInterval) :
    dist p q = max (dist p.1 q.1) |(p.2 : ℝ) - q.2| := by
  rw [Prod.dist_eq, Subtype.dist_eq, Real.dist_eq]

/-- **Ejercicio 5.** -/
theorem ej5 : Continuous F := by
  rw [Metric.continuous_iff]
  rintro ⟨g, y⟩ ε hε
  -- continuidad de `g` en `y`
  obtain ⟨δ₁, hδ₁, hg⟩ := Metric.continuous_iff.1 g.continuous y (ε / 2) (by positivity)
  refine ⟨min δ₁ (ε / 2), by positivity, ?_⟩
  rintro ⟨f, x⟩ hfx
  rw [Prod.dist_eq, max_lt_iff] at hfx
  obtain ⟨hf, hx⟩ := hfx
  have h1 : dist (f x) (g x) < ε / 2 :=
    lt_of_le_of_lt (ContinuousMap.dist_apply_le_dist x) (lt_of_lt_of_le hf (min_le_right _ _))
  have h2 : dist (g x) (g y) < ε / 2 := hg x (lt_of_lt_of_le hx (min_le_left _ _))
  calc dist (F (f, x)) (F (g, y)) = dist (f x) (g y) := rfl
    _ ≤ dist (f x) (g x) + dist (g x) (g y) := dist_triangle _ _ _
    _ < ε / 2 + ε / 2 := add_lt_add h1 h2
    _ = ε := by ring

end Parcial1_2C2025
