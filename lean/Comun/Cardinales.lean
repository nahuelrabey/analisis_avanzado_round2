/-
Librería común `Comun`: definiciones del curso y resultados de `apuntes.typ` compartidos por las
guías (`Guias/`), los parciales (`Parciales/`) y los ejemplos (`Ejemplos/`). Ver
`apuntes-agente/lean-lemas-compartidos-y-organizacion.md` para el diseño.

`Comun.Cardinales`: definiciones del curso sobre cardinales (`apuntes.typ`, sección 3) y los
resultados de `apuntes.typ` que la Práctica 2 toma como verdaderos, tomados de Mathlib.

Convenciones:
- Un "conjunto" es un tipo `A : Type*`; un subconjunto `S : Set X` se usa como el subtipo `↥S`.
- `Coordinables A B` es la Definición 3.1 (`A ∼ B`: hay una biyección), `CardLe A B` la
  Definición 3.8 (`#A ≤ #B`: hay una inyección), `Finito`/`Infinito`/`Numerable`/`Contable` la
  Definición 3.6 (`{1, …, n}` se modela con `Fin n` y `ℕ` empieza en `0`, lo que no cambia nada),
  `CardEq A n` es `#A = n`, `CardC A` es `#A = c` (la clase de `ℝ`, Definición 3.5).
- Los resultados de `apuntes.typ` (Proposiciones 3.2, 3.9, 3.13, 3.14, numerabilidad de `ℚ`,
  Teoremas 3.11 y 3.19, Observación 3.21) valen como verdaderos por las reglas del enunciado y
  acá se los deduce de Mathlib; **nada más de Mathlib sobre cardinales** debería hacer falta en
  los `EjNN.lean`, y en particular no los lemas que son literalmente los ejercicios
  (`Set.countable_iUnion`, `Countable.prod`, `Set.countable_setOf_finite_subset`,
  `Cardinal.mk_real`, `Cardinal.mk_set`, `Fintype.card_set`, `Monotone.countable_not_continuousAt`,
  …).
-/
import Mathlib

namespace Comun

/-! ## Definiciones (3.1, 3.5, 3.6, 3.8) -/

/-- Definición 3.1: `A ∼ B` si existe una biyección `A → B`. -/
def Coordinables (A B : Type*) : Prop := Nonempty (A ≃ B)

/-- Definición 3.8: `#A ≤ #B` si existe una inyección `A → B`. -/
def CardLe (A B : Type*) : Prop := Nonempty (A ↪ B)

/-- Definición 3.8: `#A < #B` si `#A ≤ #B` y no son coordinables. -/
def CardLt (A B : Type*) : Prop := CardLe A B ∧ ¬ Coordinables A B

/-- Definición 3.6: `A` es finito si es coordinable con `{1, …, n}` para algún `n`. -/
def Finito (A : Type*) : Prop := ∃ n : ℕ, Nonempty (A ≃ Fin n)

/-- Definición 3.6: `#A = n`. -/
def CardEq (A : Type*) (n : ℕ) : Prop := Nonempty (A ≃ Fin n)

/-- Definición 3.6: infinito es no finito. -/
def Infinito (A : Type*) : Prop := ¬ Finito A

/-- Definición 3.6: `A` es numerable (`#A = ℵ₀`) si existe una biyección `ℕ → A`. -/
def Numerable (A : Type*) : Prop := Nonempty (ℕ ≃ A)

/-- Definición 3.6: contable (a lo sumo numerable) es finito o numerable. -/
def Contable (A : Type*) : Prop := Finito A ∨ Numerable A

/-- `#A = c`: la clase de coordinabilidad de `ℝ` (Definición 3.5). -/
def CardC (A : Type*) : Prop := Coordinables A ℝ

/-! ## Puentes con Mathlib (las definiciones del curso leídas en Mathlib) -/

section Puentes

variable {A B : Type*}

theorem finito_iff_finite : Finito A ↔ Finite A := by
  constructor
  · rintro ⟨n, ⟨e⟩⟩
    exact Finite.of_equiv (Fin n) e.symm
  · intro h
    exact Finite.exists_equiv_fin A

theorem infinito_iff_infinite : Infinito A ↔ Infinite A := by
  unfold Infinito
  rw [finito_iff_finite, not_finite_iff_infinite]

theorem numerable_iff : Numerable A ↔ (Countable A ∧ Infinite A) := by
  constructor
  · rintro ⟨e⟩
    exact ⟨Countable.of_equiv ℕ e, e.infinite_iff.1 inferInstance⟩
  · intro h
    obtain ⟨d⟩ := nonempty_denumerable_iff.2 h
    exact ⟨(Denumerable.eqv A).symm⟩

theorem contable_iff_countable : Contable A ↔ Countable A := by
  constructor
  · rintro (h | h)
    · have := finito_iff_finite.1 h
      exact Finite.to_countable
    · exact (numerable_iff.1 h).1
  · intro h
    rcases finite_or_infinite A with hf | hi
    · exact Or.inl (finito_iff_finite.2 hf)
    · exact Or.inr (numerable_iff.2 ⟨h, hi⟩)

theorem cardEq_iff_card [Fintype A] {n : ℕ} : CardEq A n ↔ Fintype.card A = n := by
  constructor
  · rintro ⟨e⟩
    simpa using Fintype.card_congr e
  · intro h
    exact ⟨Fintype.equivFinOfCardEq h⟩

theorem contable_of_numerable (h : Numerable A) : Contable A := Or.inr h

theorem contable_of_finito (h : Finito A) : Contable A := Or.inl h

end Puentes

/-! ## Resultados de `apuntes.typ` tomados como verdaderos -/

section Apuntes

variable {A B C : Type*}

/-- Proposición 3.2: `∼` es reflexiva. -/
theorem coordinables_refl (A : Type*) : Coordinables A A := ⟨Equiv.refl A⟩

/-- Proposición 3.2: `∼` es simétrica. -/
theorem coordinables_symm (h : Coordinables A B) : Coordinables B A :=
  let ⟨e⟩ := h; ⟨e.symm⟩

/-- Proposición 3.2: `∼` es transitiva. -/
theorem coordinables_trans (h₁ : Coordinables A B) (h₂ : Coordinables B C) : Coordinables A C :=
  let ⟨e₁⟩ := h₁; let ⟨e₂⟩ := h₂; ⟨e₁.trans e₂⟩

/-- Observación 3.10: `≤` es reflexiva. -/
theorem cardLe_refl (A : Type*) : CardLe A A := ⟨Function.Embedding.refl A⟩

/-- Observación 3.10: `≤` es transitiva. -/
theorem cardLe_trans (h₁ : CardLe A B) (h₂ : CardLe B C) : CardLe A C :=
  let ⟨f⟩ := h₁; let ⟨g⟩ := h₂; ⟨f.trans g⟩

/-- Coordinables implica `≤` (una biyección es inyectiva). -/
theorem cardLe_of_coordinables (h : Coordinables A B) : CardLe A B :=
  let ⟨e⟩ := h; ⟨e.toEmbedding⟩

/-- Observación 3.10: `≤` no depende del representante: si `#A ≤ #B`, `A ∼ X` y `B ∼ Y`,
entonces `#X ≤ #Y` (`g ∘ f ∘ h⁻¹` es inyectiva). -/
theorem cardLe_congr {X Y : Type*} (hA : Coordinables A X) (hB : Coordinables B Y)
    (h : CardLe A B) : CardLe X Y :=
  let ⟨hX⟩ := hA; let ⟨g⟩ := hB; let ⟨f⟩ := h
  ⟨hX.symm.toEmbedding.trans (f.trans g.toEmbedding)⟩

/-- Observación tras 3.14: si `S ⊆ T` entonces `#S ≤ #T` (la inclusión es inyectiva). -/
theorem cardLe_of_subset {X : Type*} {S T : Set X} (h : S ⊆ T) : CardLe S T :=
  ⟨Set.embeddingOfSubset S T h⟩

/-- Proposición 3.9 (ida): si `#A ≤ #B` y `A ≠ ∅`, hay una sobreyección `B → A`. -/
theorem exists_surj_of_cardLe [Nonempty A] (h : CardLe A B) : ∃ g : B → A, Function.Surjective g :=
  let ⟨f⟩ := h; ⟨Function.invFun f, Function.invFun_surjective f.injective⟩

/-- Proposición 3.9 (vuelta): una sobreyección `B → A` da `#A ≤ #B`. -/
theorem cardLe_of_surj {g : B → A} (hg : Function.Surjective g) : CardLe A B :=
  ⟨Function.Embedding.ofSurjective g hg⟩

/-- Teorema 3.11 (Cantor–Schröder–Bernstein). -/
theorem teorema_CSB (h₁ : CardLe A B) (h₂ : CardLe B A) : Coordinables A B :=
  let ⟨f⟩ := h₁; let ⟨g⟩ := h₂; Function.Embedding.antisymm f g

/-- Proposición 3.13 (con la inyección en lugar de la inclusión): si `#B ≤ #A` y `A` es
numerable, `B` es contable. (El curso pide `B ≠ ∅`; con `B = ∅` es finito y la conclusión vale.) -/
theorem contable_of_cardLe_numerable (hA : Numerable A) (h : CardLe B A) : Contable B := by
  rw [contable_iff_countable]
  obtain ⟨f⟩ := h
  have : Countable A := (numerable_iff.1 hA).1
  exact f.injective.countable

/-- Proposición 3.13 (versión contable): si `#B ≤ #A` y `A` es contable, `B` es contable. -/
theorem contable_of_cardLe (hA : Contable A) (h : CardLe B A) : Contable B := by
  rw [contable_iff_countable] at *
  obtain ⟨f⟩ := h
  exact f.injective.countable

/-- Proposición 3.14: todo conjunto infinito contiene un subconjunto numerable; equivalentemente,
`ℵ₀ ≤ #A` (hay una inyección `ℕ → A`). -/
theorem cardLe_nat_of_infinito (h : Infinito A) : CardLe ℕ A := by
  have := infinito_iff_infinite.1 h
  exact ⟨Infinite.natEmbedding A⟩

/-- Consecuencia de 3.13 y 3.14: un conjunto es numerable si y sólo si es contable e infinito. -/
theorem numerable_iff_contable_infinito : Numerable A ↔ (Contable A ∧ Infinito A) := by
  rw [numerable_iff, contable_iff_countable, infinito_iff_infinite]

/-- `ℕ` es numerable. -/
theorem numerable_nat : Numerable ℕ := ⟨Equiv.refl ℕ⟩

/-- Proposición "Numerabilidad de `ℚ`": `#ℚ = ℵ₀`. -/
theorem numerable_rat : Numerable ℚ := ⟨(Denumerable.eqv ℚ).symm⟩

/-- Teorema 3.19: `ℝ` no es numerable (ni contable). -/
theorem no_contable_real : ¬ Contable ℝ := by
  rw [contable_iff_countable]
  intro h
  exact Cardinal.not_countable_real (Set.countable_univ)

theorem no_numerable_real : ¬ Numerable ℝ := fun h => no_contable_real (Or.inr h)

/-- `#ℝ = c` (trivialmente). -/
theorem cardC_real : CardC ℝ := coordinables_refl ℝ

/-- Observación 3.21: `ℝ ∼ (a, b)`. -/
theorem cardC_Ioo {a b : ℝ} (h : a < b) : CardC (Set.Ioo a b) :=
  Cardinal.eq.1 ((Cardinal.mk_Ioo_real h).trans Cardinal.mk_real.symm)

/-- Observación 3.21: `ℝ ∼ [a, b]`. -/
theorem cardC_Icc {a b : ℝ} (h : a < b) : CardC (Set.Icc a b) :=
  Cardinal.eq.1 ((Cardinal.mk_Icc_real h).trans Cardinal.mk_real.symm)

/-- Observación 3.21: `ℝ ∼ [a, b)`. -/
theorem cardC_Ico {a b : ℝ} (h : a < b) : CardC (Set.Ico a b) :=
  Cardinal.eq.1 ((Cardinal.mk_Ico_real h).trans Cardinal.mk_real.symm)

/-- Observación 3.21: `ℝ ∼ (a, b]`. -/
theorem cardC_Ioc {a b : ℝ} (h : a < b) : CardC (Set.Ioc a b) :=
  Cardinal.eq.1 ((Cardinal.mk_Ioc_real h).trans Cardinal.mk_real.symm)

/-- Un conjunto con `#A = c` no es contable (Teorema 3.19 transportado por la biyección). -/
theorem no_contable_of_cardC (h : CardC A) : ¬ Contable A := by
  intro hc
  obtain ⟨e⟩ := h
  apply no_contable_real
  rw [contable_iff_countable] at *
  exact Countable.of_equiv A e

/-- `ℵ₀ < c`: hay una inyección `ℕ → ℝ` y no una biyección. -/
theorem cardLt_nat_real : CardLt ℕ ℝ :=
  ⟨⟨⟨((↑) : ℕ → ℝ), Nat.cast_injective⟩⟩, fun h => no_numerable_real h⟩

end Apuntes

end Comun
