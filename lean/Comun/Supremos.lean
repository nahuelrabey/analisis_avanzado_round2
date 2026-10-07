/-
Librería común `Comun`: definiciones del curso y resultados de `apuntes.typ` compartidos por las
guías (`Guias/`), los parciales (`Parciales/`) y los ejemplos (`Ejemplos/`). Ver
`apuntes-agente/lean-lemas-compartidos-y-organizacion.md` para el diseño.

`Comun.Supremos`: cotas, supremo, ínfimo, máximo y mínimo de un conjunto de reales (Definiciones 1 a
6 de `apuntes.typ`), sus puentes a Mathlib y los resultados del capítulo 1 que las prácticas toman
como verdaderos: Axioma de Completitud, Proposiciones 3 a 6 y Teorema 2. Convención: `CotaSup A c`
es "c es cota superior de A"; `EsSup A s` es la Definición 2 (es `IsLUB A s` definicionalmente).
`equiv_inf` es el Ej. 3 de la Práctica 1 y no se usa en `Guias/Guia1/Ej03`.
-/
import Mathlib

namespace Comun

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

end Comun
