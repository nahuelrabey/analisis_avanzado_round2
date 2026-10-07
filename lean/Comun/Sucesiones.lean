/-
Librería común `Comun`: definiciones del curso y resultados de `apuntes.typ` compartidos por las
guías (`Guias/`), los parciales (`Parciales/`) y los ejemplos (`Ejemplos/`). Ver
`apuntes-agente/lean-lemas-compartidos-y-organizacion.md` para el diseño.

`Comun.Sucesiones`: sucesiones de reales (Definiciones 7 a 10 de `apuntes.typ` y subsucesiones),
puentes a Mathlib y los resultados del capítulo 2 que las prácticas toman como verdaderos
(Unicidad del límite, Álgebra de límites, convergente ⇒ acotada, monótona acotada ⇒ converge,
Equivalencia del supremo 2, Convergencia de subsucesiones). Los índices empiezan en `0` (en el
curso, en `1`); ningún argumento depende de eso. Una subsucesión de `a` es `a ∘ φ` con `StrictMono φ`.
Los `Guias/Guia1/EjNN.lean` no usan el resultado que es literalmente su ejercicio
(`algebra_limites_add` ↔ Ej. 9 (a), `algebra_limites_le` ↔ Ej. 10, `monotona_creciente_converge` ↔
espejo del Ej. 12 (a)) ni pasan por `Filter.Tendsto`.
-/
import Mathlib
import Comun.Supremos

open Filter Topology

namespace Comun

/-! ## Sucesiones (Definiciones 7 a 10 y subsucesiones) -/

/-- Definición 7: `a_n → l`. -/
def Converge (a : ℕ → ℝ) (l : ℝ) : Prop := ∀ ε > 0, ∃ n₀ : ℕ, ∀ n ≥ n₀, |a n - l| < ε

/-- Definición 8: `a_n → +∞`. -/
def DivergeMasInf (a : ℕ → ℝ) : Prop := ∀ M > 0, ∃ n₀ : ℕ, ∀ n ≥ n₀, M < a n

/-- Definición 8: `a_n → -∞`. -/
def DivergeMenosInf (a : ℕ → ℝ) : Prop := ∀ M > 0, ∃ n₀ : ℕ, ∀ n ≥ n₀, a n < -M

/-- Definición 9: `(a_n)` está acotada. -/
def Acotada (a : ℕ → ℝ) : Prop := ∃ M > 0, ∀ n, |a n| ≤ M

/-- Definición 10: `(a_n)` es monótona creciente (`a_n ≤ a_(n+1)` para todo `n`). -/
def Creciente (a : ℕ → ℝ) : Prop := ∀ n, a n ≤ a (n + 1)

/-- Definición 10: `(a_n)` es monótona decreciente (`a_n ≥ a_(n+1)` para todo `n`). -/
def Decreciente (a : ℕ → ℝ) : Prop := ∀ n, a (n + 1) ≤ a n

/-! ### Puentes a Mathlib -/

theorem converge_iff_tendsto {a : ℕ → ℝ} {l : ℝ} : Converge a l ↔ Tendsto a atTop (𝓝 l) := by
  rw [Metric.tendsto_atTop]
  simp only [Converge, Real.dist_eq]

theorem divergeMasInf_iff_tendsto {a : ℕ → ℝ} : DivergeMasInf a ↔ Tendsto a atTop atTop := by
  rw [tendsto_atTop_atTop]
  constructor
  · intro h b
    obtain ⟨n₀, hn₀⟩ := h (max b 1) (by positivity)
    exact ⟨n₀, fun n hn => le_trans (le_max_left _ _) (hn₀ n hn).le⟩
  · intro h M _
    obtain ⟨n₀, hn₀⟩ := h (M + 1)
    exact ⟨n₀, fun n hn => by linarith [hn₀ n hn]⟩

theorem divergeMenosInf_iff_tendsto {a : ℕ → ℝ} : DivergeMenosInf a ↔ Tendsto a atTop atBot := by
  rw [tendsto_atTop_atBot]
  constructor
  · intro h b
    obtain ⟨n₀, hn₀⟩ := h (max (-b) 1) (by positivity)
    exact ⟨n₀, fun n hn => by linarith [hn₀ n hn, le_max_left (-b) 1]⟩
  · intro h M _
    obtain ⟨n₀, hn₀⟩ := h (-M - 1)
    exact ⟨n₀, fun n hn => by linarith [hn₀ n hn]⟩

theorem creciente_iff_monotone {a : ℕ → ℝ} : Creciente a ↔ Monotone a :=
  ⟨fun h => monotone_nat_of_le_succ h, fun h n => h (Nat.le_succ n)⟩

theorem decreciente_iff_antitone {a : ℕ → ℝ} : Decreciente a ↔ Antitone a :=
  ⟨fun h => antitone_nat_of_succ_le h, fun h n => h (Nat.le_succ n)⟩

/-- `(a_n)` está acotada sii `{a_n : n ∈ ℕ}` está acotado (la primera frase de la Definición 9). -/
theorem acotada_iff_acotado_range {a : ℕ → ℝ} : Acotada a ↔ Acotado (Set.range a) := by
  constructor
  · rintro ⟨M, _, hM⟩
    refine ⟨⟨M, ?_⟩, ⟨-M, ?_⟩⟩
    · rintro _ ⟨n, rfl⟩; exact (abs_le.1 (hM n)).2
    · rintro _ ⟨n, rfl⟩; exact (abs_le.1 (hM n)).1
  · rintro ⟨⟨c, hc⟩, ⟨d, hd⟩⟩
    refine ⟨max (max c (-d)) 1, by positivity, fun n => ?_⟩
    have h1 := hc (a n) ⟨n, rfl⟩
    have h2 := hd (a n) ⟨n, rfl⟩
    rw [abs_le]
    constructor
    · linarith [le_max_left (max c (-d)) 1, le_max_right c (-d)]
    · linarith [le_max_left (max c (-d)) 1, le_max_left c (-d)]

/-! ## Resultados de `apuntes.typ` sobre sucesiones -/

/-- **Proposición 5 (Unicidad del límite).** -/
theorem unicidad_limite {a : ℕ → ℝ} {l₁ l₂ : ℝ} (h₁ : Converge a l₁) (h₂ : Converge a l₂) :
    l₁ = l₂ :=
  tendsto_nhds_unique (converge_iff_tendsto.1 h₁) (converge_iff_tendsto.1 h₂)

/-- **Proposición 6 (Álgebra de límites), ítem a.** -/
theorem algebra_limites_mul_const {a : ℕ → ℝ} {l : ℝ} (c : ℝ) (h : Converge a l) :
    Converge (fun n => c * a n) (c * l) :=
  converge_iff_tendsto.2 ((converge_iff_tendsto.1 h).const_mul c)

/-- **Proposición 6 (Álgebra de límites), ítem b.** (Es el Ej. 9 (a): no usar en `Ej09.lean`.) -/
theorem algebra_limites_add {a b : ℕ → ℝ} {l m : ℝ} (ha : Converge a l) (hb : Converge b m) :
    Converge (fun n => a n + b n) (l + m) :=
  converge_iff_tendsto.2 ((converge_iff_tendsto.1 ha).add (converge_iff_tendsto.1 hb))

/-- **Proposición 6 (Álgebra de límites), ítem c.** -/
theorem algebra_limites_mul {a b : ℕ → ℝ} {l m : ℝ} (ha : Converge a l) (hb : Converge b m) :
    Converge (fun n => a n * b n) (l * m) :=
  converge_iff_tendsto.2 ((converge_iff_tendsto.1 ha).mul (converge_iff_tendsto.1 hb))

/-- **Proposición 6 (Álgebra de límites), ítem d.** -/
theorem algebra_limites_div {a b : ℕ → ℝ} {l m : ℝ} (ha : Converge a l) (hb : Converge b m)
    (hm : m ≠ 0) : Converge (fun n => a n / b n) (l / m) :=
  converge_iff_tendsto.2 ((converge_iff_tendsto.1 ha).div (converge_iff_tendsto.1 hb) hm)

/-- **Proposición 6 (Álgebra de límites), ítem e.** (Es el Ej. 10: no usar en `Ej10.lean`.) -/
theorem algebra_limites_le {a b : ℕ → ℝ} {l m : ℝ} (ha : Converge a l) (hb : Converge b m)
    {n₀ : ℕ} (hab : ∀ n ≥ n₀, a n ≤ b n) : l ≤ m :=
  le_of_tendsto_of_tendsto (converge_iff_tendsto.1 ha) (converge_iff_tendsto.1 hb)
    (eventually_atTop.2 ⟨n₀, hab⟩)

/-- **Proposición 7 (Toda sucesión convergente está acotada).** -/
theorem convergente_acotada {a : ℕ → ℝ} {l : ℝ} (h : Converge a l) : Acotada a := by
  obtain ⟨r, hr⟩ := (Metric.isBounded_iff_subset_closedBall 0).1
    (Metric.isBounded_range_of_tendsto a (converge_iff_tendsto.1 h))
  refine ⟨max r 1, by positivity, fun n => ?_⟩
  have := hr ⟨n, rfl⟩
  rw [Metric.mem_closedBall, Real.dist_eq, sub_zero] at this
  exact this.trans (le_max_left _ _)

/-- **Proposición 8 (Convergencia de sucesiones monótonas crecientes).** Una sucesión creciente y
acotada converge, y su límite es `sup {a_n : n ∈ ℕ}`. -/
theorem monotona_creciente_converge {a : ℕ → ℝ} (hc : Creciente a) (hb : Acotada a) :
    ∃ s, EsSup (Set.range a) s ∧ Converge a s := by
  have hbdd : BddAbove (Set.range a) := (acotada_iff_acotado_range.1 hb).1
  refine ⟨sSup (Set.range a), isLUB_csSup (Set.range_nonempty a) hbdd, ?_⟩
  exact converge_iff_tendsto.2 (tendsto_atTop_ciSup (creciente_iff_monotone.1 hc) hbdd)

/-- **Equivalencia del supremo 2.** `s = sup A` sii `s` es cota superior y hay una sucesión en `A`
que converge a `s`. -/
theorem equiv_sup2 {A : Set ℝ} {s : ℝ} (hne : A.Nonempty) :
    EsSup A s ↔ CotaSup A s ∧ ∃ a : ℕ → ℝ, (∀ n, a n ∈ A) ∧ Converge a s := by
  constructor
  · intro hs
    obtain ⟨u, _, _, hu, huA⟩ := IsLUB.exists_seq_monotone_tendsto (esSup_iff_isLUB.1 hs) hne
    exact ⟨hs.1, u, huA, converge_iff_tendsto.2 hu⟩
  · rintro ⟨hs, a, haA, hlim⟩
    refine equiv_sup.2 ⟨hs, fun ε hε => ?_⟩
    obtain ⟨n₀, hn₀⟩ := hlim ε hε
    refine ⟨a n₀, haA n₀, ?_, hs _ (haA n₀)⟩
    linarith [(abs_lt.1 (hn₀ n₀ le_rfl)).1]

/-- Hecho de base sobre subsucesiones: si `φ` es estrictamente creciente, `n ≤ φ n`. -/
theorem le_of_strictMono {φ : ℕ → ℕ} (hφ : StrictMono φ) (n : ℕ) : n ≤ φ n := hφ.id_le n

/-- **Convergencia de subsucesiones.** Si `a_n → l`, toda subsucesión `a_(φ k)` converge a `l`. -/
theorem convergencia_subsucesiones {a : ℕ → ℝ} {l : ℝ} (h : Converge a l) {φ : ℕ → ℕ}
    (hφ : StrictMono φ) : Converge (a ∘ φ) l :=
  converge_iff_tendsto.2 ((converge_iff_tendsto.1 h).comp hφ.tendsto_atTop)

end Comun
