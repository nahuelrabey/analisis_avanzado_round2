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
Al final, en "Lemas genéricos", están los sublemas que los ejercicios de la Práctica 1 probaban
localmente (ninguno es un ejercicio): monotonía término a término (`creciente_le`,
`decreciente_le`, Ej. 12), la construcción recursiva de índices (`exists_strictMono_of_step`,
Ej. 14 y 15), el máximo de finitos términos y la negación de "acotado superiormente"
(`exists_bound_finite`, `exists_gt_of_not_acotadoSup`, Ej. 14), la "subsucesión mala" de una
sucesión que no converge (`exists_subseq_far_of_not_converge`, Ej. 15, probada desplegando la
Definición 7, sin `tendsto_of_subseq_tendsto` ni `Filter.extraction_of_*`), subsucesiones dadas
término a término (`converge_of_subseq`, `strictMono_mul_add`, Ej. 16) y los ejemplos básicos de
límites (`converge_const`, `divergeMasInf_id`, `divergeMenosInf_neg_id`, `divergeMasInf_const_mul`,
`divergeMenosInf_const_mul`, Ej. 9 (d)), todos desplegando las Definiciones 7 y 8.
-/
import Mathlib
import Comun.Reales
import Comun.Supremos
import Comun.Metricas

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

/-- `Converge` es la Definición 4.42 (`ConvergeMet`, `Comun.Metricas`) para la distancia usual de `ℝ`. -/
theorem converge_iff_convergeMet {a : ℕ → ℝ} {l : ℝ} :
    Converge a l ↔ ConvergeMet (fun x y : ℝ => |x - y|) a l := Iff.rfl

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

/-! ## Lemas genéricos -/

/-- Si `(x_n)` es creciente y `m ≤ n`, entonces `x_m ≤ x_n` (inducción en `n` desde `m`). -/
theorem creciente_le {x : ℕ → ℝ} (hc : Creciente x) {m n : ℕ} (h : m ≤ n) : x m ≤ x n := by
  induction h with
  | refl => exact le_rfl
  | step _ ih => exact ih.trans (hc _)

/-- Si `(x_n)` es decreciente y `m ≤ n`, entonces `x_n ≤ x_m` (inducción en `n` desde `m`). -/
theorem decreciente_le {x : ℕ → ℝ} (hd : Decreciente x) {m n : ℕ} (h : m ≤ n) : x n ≤ x m := by
  induction h with
  | refl => exact le_rfl
  | step _ ih => exact (hd _).trans ih

/-- Construcción recursiva de índices: si para cada `k` y cada `N` hay `n > N` con `P k n`,
entonces hay `φ` estrictamente creciente con `P k (φ k)` para todo `k`. Se elige `φ 0` con
`P 0 (φ 0)` y, dado `φ k`, se elige `φ (k + 1) > φ k` con `P (k + 1) (φ (k + 1))`. -/
theorem exists_strictMono_of_step {P : ℕ → ℕ → Prop} (h : ∀ k N, ∃ n > N, P k n) :
    ∃ φ : ℕ → ℕ, StrictMono φ ∧ ∀ k, P k (φ k) := by
  choose f hf using h
  let φ : ℕ → ℕ := fun k => Nat.rec (f 0 0) (fun k ih => f (k + 1) ih) k
  have hφ0 : P 0 (φ 0) := (hf 0 0).2
  have hφs : ∀ k, φ k < φ (k + 1) ∧ P (k + 1) (φ (k + 1)) := fun k =>
    ⟨(hf (k + 1) (φ k)).1, (hf (k + 1) (φ k)).2⟩
  refine ⟨φ, strictMono_nat_of_lt_succ fun k => (hφs k).1, fun k => ?_⟩
  cases k with
  | zero => exact hφ0
  | succ k => exact (hφs k).2

/-- `k ↦ c k + r` es estrictamente creciente si `c > 0` (los índices pares `2k`, impares
`2k + 1`, múltiplos de 3, …). -/
theorem strictMono_mul_add {c : ℕ} (hc : 0 < c) (r : ℕ) : StrictMono (fun k => c * k + r) :=
  strictMono_nat_of_lt_succ fun k => by
    show c * k + r < c * (k + 1) + r
    rw [Nat.mul_succ]
    omega

/-- Hecho de base: finitos números tienen un máximo. Por inducción en `N`, hay `c` con
`x_n ≤ c` para todo `n ≤ N` (`c = máx {x_0, …, x_N}`). -/
theorem exists_bound_finite (x : ℕ → ℝ) (N : ℕ) : ∃ c : ℝ, ∀ n ≤ N, x n ≤ c := by
  induction N with
  | zero => exact ⟨x 0, fun n hn => by rw [Nat.le_zero.1 hn]⟩
  | succ N ih =>
    obtain ⟨c, hc⟩ := ih
    refine ⟨max c (x (N + 1)), fun n hn => ?_⟩
    rcases Nat.lt_or_ge n (N + 1) with h | h
    · exact (hc n (Nat.lt_succ_iff.1 h)).trans (le_max_left _ _)
    · rw [le_antisymm hn h]; exact le_max_right _ _

/-- Si `{x_n}` no está acotado superiormente, para todo `K ∈ ℝ` y todo `N ∈ ℕ` hay `n > N` con
`x_n > K`. Si no, `máx {x_0, …, x_N, K}` sería cota superior de `{x_n}`. -/
theorem exists_gt_of_not_acotadoSup {x : ℕ → ℝ} (h : ¬ AcotadoSup (Set.range x)) (K : ℝ)
    (N : ℕ) : ∃ n > N, K < x n := by
  by_contra hcon
  push Not at hcon
  obtain ⟨c, hc⟩ := exists_bound_finite x N
  apply h
  refine ⟨max c K, ?_⟩
  rintro _ ⟨n, rfl⟩
  rcases Nat.lt_or_ge N n with hn | hn
  · exact (hcon n hn).trans (le_max_right _ _)
  · exact (hc n hn).trans (le_max_left _ _)

/-- Negación de la Definición 7 más la "subsucesión mala": si `x_n` no converge a `ℓ`, hay
`ε₀ > 0` y una subsucesión `(x_(φ k))` con `|x_(φ k) - ℓ| ≥ ε₀` para todo `k`. -/
theorem exists_subseq_far_of_not_converge {x : ℕ → ℝ} {l : ℝ} (h : ¬ Converge x l) :
    ∃ ε₀ > 0, ∃ φ : ℕ → ℕ, StrictMono φ ∧ ∀ k, ε₀ ≤ |x (φ k) - l| := by
  unfold Converge at h
  push Not at h
  obtain ⟨ε₀, hε₀, hbad⟩ := h
  refine ⟨ε₀, hε₀, ?_⟩
  have hstep : ∀ (k : ℕ) (N : ℕ), ∃ n > N, ε₀ ≤ |x n - l| := fun _ N => by
    obtain ⟨n, hn, hfar⟩ := hbad (N + 1)
    exact ⟨n, by omega, hfar⟩
  obtain ⟨φ, hφ, hfar⟩ := exists_strictMono_of_step hstep
  exact ⟨φ, hφ, hfar⟩

/-- Convergencia de subsucesiones, en la forma "si `b k = a (φ k)` con `φ` estrictamente
creciente y `a → ℓ`, entonces `b → ℓ`" (es `convergencia_subsucesiones` más la identificación
término a término de `a ∘ φ` con `b`). -/
theorem converge_of_subseq {a b : ℕ → ℝ} {l : ℝ} (ha : Converge a l) {φ : ℕ → ℕ}
    (hφ : StrictMono φ) (hb : ∀ k, b k = a (φ k)) : Converge b l := by
  have h := convergencia_subsucesiones ha hφ
  have hab : b = a ∘ φ := funext hb
  rw [hab]
  exact h

/-- La sucesión constante `c` converge a `c` (`|c - c| = 0 < ε`). -/
theorem converge_const (c : ℝ) : Converge (fun _ : ℕ => c) c := by
  intro ε hε
  exact ⟨0, fun _ _ => by simp [hε]⟩

/-- `x_n = n → +∞` (Teorema 1, en la forma `exists_n0_forall_lt`). -/
theorem divergeMasInf_id : DivergeMasInf (fun n : ℕ => (n : ℝ)) := by
  intro M _
  obtain ⟨n₀, hn₀⟩ := exists_n0_forall_lt M
  exact ⟨n₀, fun n hn => hn₀ n hn⟩

/-- `y_n = -n → -∞`: `-n < -M`. -/
theorem divergeMenosInf_neg_id : DivergeMenosInf (fun n : ℕ => -(n : ℝ)) := by
  intro M _
  obtain ⟨n₀, hn₀⟩ := exists_n0_forall_lt M
  refine ⟨n₀, fun n hn => ?_⟩
  have := hn₀ n hn
  show -(n : ℝ) < -M
  linarith

/-- Si `x_n → +∞` y `c > 0`, entonces `c x_n → +∞`: dado `M > 0`, se usa la Definición 8 para
`x_n` con `M / c > 0`, y `c x_n > c (M / c) = M`. -/
theorem divergeMasInf_const_mul {x : ℕ → ℝ} {c : ℝ} (hc : 0 < c) (hx : DivergeMasInf x) :
    DivergeMasInf (fun n => c * x n) := by
  intro M hM
  obtain ⟨n₀, hn₀⟩ := hx (M / c) (div_pos hM hc)
  refine ⟨n₀, fun n hn => ?_⟩
  have h1 := mul_lt_mul_of_pos_left (hn₀ n hn) hc
  have h2 : c * (M / c) = M := by field_simp
  show M < c * x n
  linarith

/-- Si `x_n → -∞` y `c > 0`, entonces `c x_n → -∞`: dado `M > 0`, se usa la Definición 8 para
`x_n` con `M / c > 0`, y `c x_n < c (-(M / c)) = -M`. -/
theorem divergeMenosInf_const_mul {x : ℕ → ℝ} {c : ℝ} (hc : 0 < c) (hx : DivergeMenosInf x) :
    DivergeMenosInf (fun n => c * x n) := by
  intro M hM
  obtain ⟨n₀, hn₀⟩ := hx (M / c) (div_pos hM hc)
  refine ⟨n₀, fun n hn => ?_⟩
  have h1 := mul_lt_mul_of_pos_left (hn₀ n hn) hc
  have h2 : c * (M / c) = M := by field_simp
  show c * x n < -M
  linarith [mul_neg c (M / c)]

end Comun
