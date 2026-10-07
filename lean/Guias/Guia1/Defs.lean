/-
Definiciones del curso sobre `ℝ` y sucesiones (`apuntes.typ`, capítulos 1 y 2) para la Práctica 1,
y los resultados de `apuntes.typ` que la Práctica toma como verdaderos, deducidos de Mathlib.

Convenciones:
- Un conjunto de reales es `A : Set ℝ`. `CotaSup A c` / `CotaInf A c` son "c es cota
  superior / inferior de A" (Definiciones 1 y 4), `AcotadoSup` / `AcotadoInf` / `Acotado` dicen que
  existe tal cota, `EsSup A s` / `EsInf A i` son las Definiciones 2 y 5 (la menor cota superior /
  la mayor cota inferior), `EsMax` / `EsMin` las Definiciones 3 y 6 (supremo / ínfimo que pertenece
  al conjunto).
- Una sucesión es `a : ℕ → ℝ`; los índices empiezan en `0` (en el curso, en `1`), lo que no cambia
  ningún argumento. `Converge a l` es la Definición 7 (`ε`-`n₀`), `DivergeMasInf` /
  `DivergeMenosInf` la Definición 8, `Acotada` la Definición 9 (`∃ M > 0, ∀ n, |a n| ≤ M`),
  `Creciente` / `Decreciente` la Definición 10 (para todo `n`), y una subsucesión de `a` es `a ∘ φ`
  con `φ : ℕ → ℕ` estrictamente creciente (`StrictMono φ`, Definición de subsucesión).
  `{a_n : n ∈ ℕ}` es `Set.range a`.
- Los resultados de `apuntes.typ` (Axioma de Completitud, Teorema 1 y Proposición 1 de Arquímedes,
  Proposición 2 (densidad de `ℚ`), Proposiciones 3 a 8 y las de subsucesiones) valen como
  verdaderos por las reglas del enunciado y acá se los deduce de Mathlib o de las definiciones.
  **Los `EjNN.lean` no deben usar el resultado de `apuntes.typ` que es literalmente el ejercicio**
  (Ej. 2 (b) ↔ `densidad_Q`; Ej. 3 ↔ `equiv_inf`; Ej. 9 (a) ↔ `algebra_limites_add`, cuya
  demostración `apuntes.typ` deja como ejercicio de la guía; Ej. 10 ↔ `algebra_limites_le`;
  Ej. 12 (a) ↔ espejo de `monotona_creciente_converge`), ni los lemas de Mathlib que lo son
  (`Filter.Tendsto.add`, `tendsto_atTop_ciInf`, `le_of_tendsto_of_tendsto`, …): esos ítems se
  prueban con `ε`-`n₀` a mano, como en el texto.
-/
import Mathlib

open Filter Topology

namespace Guias.Guia1

/-! ## Cotas, supremo e ínfimo (Definiciones 1 a 6) -/

/-- Definición 1: `c` es cota superior de `A`. -/
def CotaSup (A : Set ℝ) (c : ℝ) : Prop := ∀ a ∈ A, a ≤ c

/-- Definición 4: `c` es cota inferior de `A`. -/
def CotaInf (A : Set ℝ) (c : ℝ) : Prop := ∀ a ∈ A, c ≤ a

/-- Definición 1: `A` está acotado superiormente. -/
def AcotadoSup (A : Set ℝ) : Prop := ∃ c, CotaSup A c

/-- Definición 4: `A` está acotado inferiormente. -/
def AcotadoInf (A : Set ℝ) : Prop := ∃ c, CotaInf A c

/-- `A` está acotado: superior e inferiormente. -/
def Acotado (A : Set ℝ) : Prop := AcotadoSup A ∧ AcotadoInf A

/-- Definición 2: `s` es el supremo de `A` (cota superior, y menor que toda otra cota superior). -/
def EsSup (A : Set ℝ) (s : ℝ) : Prop := CotaSup A s ∧ ∀ t, CotaSup A t → s ≤ t

/-- Definición 5: `i` es el ínfimo de `A` (cota inferior, y mayor que toda otra cota inferior). -/
def EsInf (A : Set ℝ) (i : ℝ) : Prop := CotaInf A i ∧ ∀ t, CotaInf A t → t ≤ i

/-- Definición 3: `m` es el máximo de `A` (supremo que pertenece a `A`). -/
def EsMax (A : Set ℝ) (m : ℝ) : Prop := EsSup A m ∧ m ∈ A

/-- Definición 6: `m` es el mínimo de `A` (ínfimo que pertenece a `A`). -/
def EsMin (A : Set ℝ) (m : ℝ) : Prop := EsInf A m ∧ m ∈ A

/-! ### Puentes a Mathlib -/

theorem cotaSup_iff {A : Set ℝ} {c : ℝ} : CotaSup A c ↔ c ∈ upperBounds A := Iff.rfl

theorem cotaInf_iff {A : Set ℝ} {c : ℝ} : CotaInf A c ↔ c ∈ lowerBounds A := Iff.rfl

theorem acotadoSup_iff {A : Set ℝ} : AcotadoSup A ↔ BddAbove A := Iff.rfl

theorem acotadoInf_iff {A : Set ℝ} : AcotadoInf A ↔ BddBelow A := Iff.rfl

theorem esSup_iff_isLUB {A : Set ℝ} {s : ℝ} : EsSup A s ↔ IsLUB A s := Iff.rfl

theorem esInf_iff_isGLB {A : Set ℝ} {i : ℝ} : EsInf A i ↔ IsGLB A i := Iff.rfl

/-- El supremo, si existe, es único (dos menores cotas superiores son iguales). -/
theorem esSup_unique {A : Set ℝ} {s s' : ℝ} (h : EsSup A s) (h' : EsSup A s') : s = s' :=
  le_antisymm (h.2 s' h'.1) (h'.2 s h.1)

/-- El ínfimo, si existe, es único. -/
theorem esInf_unique {A : Set ℝ} {i i' : ℝ} (h : EsInf A i) (h' : EsInf A i') : i = i' :=
  le_antisymm (h'.2 i h.1) (h.2 i' h'.1)

theorem esSup_sSup {A : Set ℝ} {s : ℝ} (h : EsSup A s) (hne : A.Nonempty) : sSup A = s :=
  IsLUB.csSup_eq (esSup_iff_isLUB.1 h) hne

theorem esInf_sInf {A : Set ℝ} {i : ℝ} (h : EsInf A i) (hne : A.Nonempty) : sInf A = i :=
  IsGLB.csInf_eq (esInf_iff_isGLB.1 h) hne

/-! ## Resultados de `apuntes.typ` sobre `ℝ` -/

/-- **Axioma de Completitud.** Todo subconjunto no vacío y acotado superiormente de `ℝ` tiene
supremo. -/
theorem axioma_completitud {A : Set ℝ} (hne : A.Nonempty) (hb : AcotadoSup A) :
    ∃ s, EsSup A s :=
  Real.exists_isLUB hne hb

/-- **Teorema 1 (Principio de Arquímedes).** Para todo `x ∈ ℝ` hay `n ∈ ℕ` con `x ≤ n`. -/
theorem arquimedes (x : ℝ) : ∃ n : ℕ, x ≤ n := exists_nat_ge x

/-- **Proposición 1 (Principio de Arquímedes 2).** Si `y > 0` hay `n ∈ ℕ` con `0 < 1/n < y`
(`0 < 1/n` fuerza `n ≥ 1`). -/
theorem arquimedes2 {y : ℝ} (hy : 0 < y) : ∃ n : ℕ, 0 < (1 : ℝ) / n ∧ (1 : ℝ) / n < y := by
  obtain ⟨n, hn⟩ := exists_nat_one_div_lt hy
  refine ⟨n + 1, by positivity, ?_⟩
  simpa using hn

/-- **Proposición 2 (Densidad de `ℚ`).** Entre dos reales distintos hay un racional.
(Es el Ej. 2 (b): no usar en `Ej02.lean`.) -/
theorem densidad_Q {x y : ℝ} (h : x < y) : ∃ q : ℚ, x < q ∧ q < y := exists_rat_btwn h

/-- **Proposición 3 (Equivalencia de supremo).** `s = sup A` sii `s` es cota superior y para todo
`ε > 0` hay `a ∈ A` con `s - ε < a ≤ s`. -/
theorem equiv_sup {A : Set ℝ} {s : ℝ} :
    EsSup A s ↔ CotaSup A s ∧ ∀ ε > 0, ∃ a ∈ A, s - ε < a ∧ a ≤ s := by
  constructor
  · rintro ⟨hs, hmin⟩
    refine ⟨hs, fun ε hε => ?_⟩
    by_contra hcon
    push Not at hcon
    have ht : CotaSup A (s - ε) := fun a ha => by
      by_contra hlt
      exact absurd (hs a ha) (not_le.2 (hcon a ha (not_le.1 hlt)))
    linarith [hmin _ ht]
  · rintro ⟨hs, hε⟩
    refine ⟨hs, fun t ht => ?_⟩
    by_contra hlt
    obtain ⟨a, haA, ha1, _⟩ := hε (s - t) (by linarith [not_le.1 hlt])
    linarith [ht a haA]

/-- **Proposición 4 (Caracterización de Supremo y Máximo).** Una cota superior que pertenece a
`A` es el supremo (y el máximo). -/
theorem caract_sup_max {A : Set ℝ} {t : ℝ} (ht : CotaSup A t) (htA : t ∈ A) : EsMax A t :=
  ⟨⟨ht, fun _ hu => hu t htA⟩, htA⟩

/-- **Teorema 2 (Completitud en términos de ínfimos).** Todo subconjunto no vacío y acotado
inferiormente de `ℝ` tiene ínfimo. -/
theorem completitud_inf {A : Set ℝ} (hne : A.Nonempty) (hb : AcotadoInf A) :
    ∃ i, EsInf A i :=
  Real.exists_isGLB hne hb

/-- **Proposición 5 (Equivalencia de Ínfimo).** `i = ínf A` sii `i` es cota inferior y para todo
`ε > 0` hay `a ∈ A` con `a < i + ε`. (Es el Ej. 3: no usar en `Ej03.lean`.) -/
theorem equiv_inf {A : Set ℝ} {i : ℝ} :
    EsInf A i ↔ CotaInf A i ∧ ∀ ε > 0, ∃ a ∈ A, a < i + ε := by
  constructor
  · rintro ⟨hi, hmax⟩
    refine ⟨hi, fun ε hε => ?_⟩
    by_contra hcon
    push Not at hcon
    have ht : CotaInf A (i + ε) := fun a ha => hcon a ha
    linarith [hmax _ ht]
  · rintro ⟨hi, hε⟩
    refine ⟨hi, fun t ht => ?_⟩
    by_contra hlt
    obtain ⟨a, haA, ha⟩ := hε (t - i) (by linarith [not_le.1 hlt])
    linarith [ht a haA]

/-- **Proposición 6 (Caracterización de Ínfimo y Mínimo).** Una cota inferior que pertenece a
`A` es el ínfimo (y el mínimo). -/
theorem caract_inf_min {A : Set ℝ} {t : ℝ} (ht : CotaInf A t) (htA : t ∈ A) : EsMin A t :=
  ⟨⟨ht, fun _ hu => hu t htA⟩, htA⟩

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

end Guias.Guia1
