/-
Librería común `Comun`: definiciones del curso y resultados de `apuntes.typ` compartidos por las
guías (`Guias/`), los parciales (`Parciales/`) y los ejemplos (`Ejemplos/`). Ver
`apuntes-agente/lean-lemas-compartidos-y-organizacion.md` para el diseño.

`Comun.Supremos`: cotas, supremo, ínfimo, máximo y mínimo de un conjunto de reales (Definiciones 1 a
6 de `apuntes.typ`), sus puentes a Mathlib y los resultados del capítulo 1 que las prácticas toman
como verdaderos: Axioma de Completitud, Proposiciones 3 a 6 y Teorema 2. Convención: `CotaSup A c`
es "c es cota superior de A"; `EsSup A s` es la Definición 2 (es `IsLUB A s` definicionalmente).
`equiv_inf` es el Ej. 3 de la Práctica 1 y no se usa en `Guias/Guia1/Ej03`.
Al final están los lemas genéricos sobre cotas que son ejercicios de la Práctica 1 y que los
`Guias/Guia1/EjNN.lean` re-enuncian en una línea: monotonía respecto de la inclusión
(`acotadoSup_mono`, `esSup_mono`, … = Ej. 5 (a)(b)), `-A` (`esInf_neg` = Ej. 6 (a), probado desde
las Definiciones, sin `completitud_inf`, `Set.neg`, `IsLUB.neg` ni `csSup_neg`), `c·A`
(`esSup_smul` = Ej. 6 (b), sin `Real.sSup_smul`) y el conjunto suma `A + B` (`sumSet`,
`sSup_sumSet`, `sInf_sumSet`, en el dialecto de Mathlib que usan los parciales, y `esSup_sumSet`,
`esInf_sumSet` en el del curso).
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

/-! ## Lemas genéricos sobre cotas (ejercicios de la Práctica 1) -/

/-- **Práctica 1, Ej. 5 (a), acotación.** Si `A ⊆ B` y `B` está acotado superiormente, `A`
también: toda cota superior de `B` lo es de `A` (Definición 1); la demostración sigue el texto de
`guias-agente/guia_1_resuelta_agente.typ`. -/
theorem acotadoSup_mono {A B : Set ℝ} (hAB : A ⊆ B) (hB : AcotadoSup B) : AcotadoSup A := by
  obtain ⟨c, hc⟩ := hB
  exact ⟨c, fun a ha => hc a (hAB ha)⟩

/-- **Práctica 1, Ej. 5 (b), acotación.** Si `A ⊆ B` y `B` está acotado inferiormente, `A`
también: toda cota inferior de `B` lo es de `A` (Definición 4); la demostración sigue el texto de
`guias-agente/guia_1_resuelta_agente.typ`. -/
theorem acotadoInf_mono {A B : Set ℝ} (hAB : A ⊆ B) (hB : AcotadoInf B) : AcotadoInf A := by
  obtain ⟨c, hc⟩ := hB
  exact ⟨c, fun a ha => hc a (hAB ha)⟩

/-- **Práctica 1, Ej. 5 (a), desigualdad.** Si `A ⊆ B`, `s = sup A` y `t = sup B`, entonces
`s ≤ t`: `t` es cota superior de `B`, luego de `A`, y `s` es la menor cota superior de `A`
(Definición 2); la demostración sigue el texto de `guias-agente/guia_1_resuelta_agente.typ`. -/
theorem esSup_mono {A B : Set ℝ} (hAB : A ⊆ B) {s t : ℝ} (hs : EsSup A s) (ht : EsSup B t) :
    s ≤ t :=
  hs.2 t (fun a ha => ht.1 a (hAB ha))

/-- **Práctica 1, Ej. 5 (b), desigualdad.** Si `A ⊆ B`, `i = ínf A` y `j = ínf B`, entonces
`j ≤ i`: `j` es cota inferior de `B`, luego de `A`, e `i` es la mayor cota inferior de `A`
(Definición 5); la demostración sigue el texto de `guias-agente/guia_1_resuelta_agente.typ`. -/
theorem esInf_mono {A B : Set ℝ} (hAB : A ⊆ B) {i j : ℝ} (hi : EsInf A i) (hj : EsInf B j) :
    j ≤ i :=
  hi.2 j (fun a ha => hj.1 a (hAB ha))

/-- Si `s` es cota superior de `A`, `-s` es cota inferior de `-A = (fun a => -a) '' A`:
`a ≤ s` da `-s ≤ -a`. -/
theorem cotaInf_neg {A : Set ℝ} {s : ℝ} (hs : CotaSup A s) :
    CotaInf ((fun a => -a) '' A) (-s) := by
  rintro _ ⟨a, ha, rfl⟩
  have := hs a ha
  linarith

/-- **Práctica 1, Ej. 6 (a), acotación.** Si `A` está acotado superiormente, `-A` está acotado
inferiormente; la demostración sigue el texto de `guias-agente/guia_1_resuelta_agente.typ`. -/
theorem acotadoInf_neg_of_acotadoSup {A : Set ℝ} (hb : AcotadoSup A) :
    AcotadoInf ((fun a => -a) '' A) := by
  obtain ⟨c, hc⟩ := hb
  exact ⟨-c, cotaInf_neg hc⟩

/-- **Práctica 1, Ej. 6 (a), ínfimo.** Si `s = sup A`, entonces `ínf (-A) = -s`: `-s` es cota
inferior de `-A`, y si `t` es cota inferior de `-A`, entonces `-t` es cota superior de `A`
(`t ≤ -a` da `a ≤ -t`), luego `s ≤ -t` (Definición 2) y `t ≤ -s`; la demostración sigue el texto
de `guias-agente/guia_1_resuelta_agente.typ`. -/
theorem esInf_neg {A : Set ℝ} {s : ℝ} (hs : EsSup A s) : EsInf ((fun a => -a) '' A) (-s) := by
  refine ⟨cotaInf_neg hs.1, fun t ht => ?_⟩
  have hct : CotaSup A (-t) := fun a ha => by
    have := ht (-a) ⟨a, ha, rfl⟩
    linarith
  linarith [hs.2 (-t) hct]

/-- Si `c > 0` y `s` es cota superior de `A`, `c s` es cota superior de
`c A = (fun a => c * a) '' A`: `a ≤ s` da `c a ≤ c s` (multiplicar por `c > 0` no invierte). -/
theorem cotaSup_smul {A : Set ℝ} {c s : ℝ} (hc : 0 < c) (hs : CotaSup A s) :
    CotaSup ((fun a => c * a) '' A) (c * s) := by
  rintro _ ⟨a, ha, rfl⟩
  exact mul_le_mul_of_nonneg_left (hs a ha) hc.le

/-- **Práctica 1, Ej. 6 (b), acotación.** Si `c > 0` y `A` está acotado superiormente, `c A`
también; la demostración sigue el texto de `guias-agente/guia_1_resuelta_agente.typ`. -/
theorem acotadoSup_smul {A : Set ℝ} {c : ℝ} (hc : 0 < c) (hb : AcotadoSup A) :
    AcotadoSup ((fun a => c * a) '' A) := by
  obtain ⟨d, hd⟩ := hb
  exact ⟨c * d, cotaSup_smul hc hd⟩

/-- **Práctica 1, Ej. 6 (b), supremo.** Si `c > 0` y `s = sup A`, entonces `sup (c A) = c s`:
`c s` es cota superior de `c A`, y si `t` es cota superior de `c A`, entonces `t / c` es cota
superior de `A` (`c a ≤ t` da `a ≤ t / c`, dividiendo por `c > 0`), luego `s ≤ t / c`
(Definición 2) y `c s ≤ t`; la demostración sigue el texto de
`guias-agente/guia_1_resuelta_agente.typ`. -/
theorem esSup_smul {A : Set ℝ} {c s : ℝ} (hc : 0 < c) (hs : EsSup A s) :
    EsSup ((fun a => c * a) '' A) (c * s) := by
  refine ⟨cotaSup_smul hc hs.1, fun t ht => ?_⟩
  have hct : CotaSup A (t / c) := fun a ha => by
    have := ht (c * a) ⟨a, ha, rfl⟩
    rw [le_div_iff₀ hc]
    linarith
  have := hs.2 (t / c) hct
  rwa [le_div_iff₀ hc, mul_comm] at this

/-! ## El conjunto suma `A + B` -/

/-- El conjunto suma `A + B = {a + b : a ∈ A, b ∈ B}`. -/
def sumSet (A B : Set ℝ) : Set ℝ := {x | ∃ a ∈ A, ∃ b ∈ B, x = a + b}

/-- `sup (A + B) = sup A + sup B` para `A`, `B` no vacíos y acotados superiormente (dialecto de
Mathlib: es el Ej. 2 (a) del Recuperatorio del 1er parcial 1C 2025). `sup A + sup B` es cota
superior de `A + B`; para cada `ε > 0` hay `a ∈ A`, `b ∈ B` con `sup A - ε/2 < a`,
`sup B - ε/2 < b`, así que `sup A + sup B < sup (A + B) + ε`. -/
theorem sSup_sumSet (A B : Set ℝ) (hA : A.Nonempty) (hA' : BddAbove A)
    (hB : B.Nonempty) (hB' : BddAbove B) :
    sSup (sumSet A B) = sSup A + sSup B := by
  obtain ⟨a₀, ha₀⟩ := hA
  obtain ⟨b₀, hb₀⟩ := hB
  have hne : (sumSet A B).Nonempty := ⟨a₀ + b₀, a₀, ha₀, b₀, hb₀, rfl⟩
  -- `sup A + sup B` es cota superior de `A + B`.
  have hub : ∀ x ∈ sumSet A B, x ≤ sSup A + sSup B := by
    rintro x ⟨a, ha, b, hb, rfl⟩
    exact add_le_add (le_csSup hA' ha) (le_csSup hB' hb)
  apply le_antisymm
  · -- `≤`: el supremo es la menor cota superior.
    exact csSup_le hne hub
  · -- `≥`: para cada `ε > 0` hay `a_ε ∈ A`, `b_ε ∈ B` con `sup A - ε/2 < a_ε`, `sup B - ε/2 < b_ε`.
    apply le_of_forall_pos_lt_add
    intro ε hε
    obtain ⟨a, ha, haε⟩ := exists_lt_of_lt_csSup ⟨a₀, ha₀⟩ (show sSup A - ε / 2 < sSup A by linarith)
    obtain ⟨b, hb, hbε⟩ := exists_lt_of_lt_csSup ⟨b₀, hb₀⟩ (show sSup B - ε / 2 < sSup B by linarith)
    have hab : a + b ≤ sSup (sumSet A B) :=
      le_csSup ⟨sSup A + sSup B, hub⟩ ⟨a, ha, b, hb, rfl⟩
    linarith

/-- `ínf (A + B) = ínf A + ínf B` para `A`, `B` no vacíos y acotados inferiormente (dialecto de
Mathlib: es el Ej. 1 del 1er parcial 2C 2024, allí enunciado como
`sInf A + sInf B = sInf (sumSet A B)`). Espejo de `sSup_sumSet`. -/
theorem sInf_sumSet (A B : Set ℝ) (hA : A.Nonempty) (hA' : BddBelow A)
    (hB : B.Nonempty) (hB' : BddBelow B) :
    sInf (sumSet A B) = sInf A + sInf B := by
  obtain ⟨a₀, ha₀⟩ := hA
  obtain ⟨b₀, hb₀⟩ := hB
  have hne : (sumSet A B).Nonempty := ⟨a₀ + b₀, a₀, ha₀, b₀, hb₀, rfl⟩
  -- `ínf A + ínf B` es cota inferior del conjunto suma.
  have hlb : ∀ x ∈ sumSet A B, sInf A + sInf B ≤ x := by
    rintro x ⟨a, ha, b, hb, rfl⟩
    exact add_le_add (csInf_le hA' ha) (csInf_le hB' hb)
  apply le_antisymm
  · -- `ínf (A + B) ≤ ínf A + ínf B + ε` para todo `ε > 0`, con `a`, `b` a menos de `ε/2`.
    apply le_of_forall_pos_lt_add
    intro ε hε
    obtain ⟨a, ha, haε⟩ := exists_lt_of_csInf_lt ⟨a₀, ha₀⟩ (show sInf A < sInf A + ε / 2 by linarith)
    obtain ⟨b, hb, hbε⟩ := exists_lt_of_csInf_lt ⟨b₀, hb₀⟩ (show sInf B < sInf B + ε / 2 by linarith)
    have hab : sInf (sumSet A B) ≤ a + b :=
      csInf_le ⟨sInf A + sInf B, hlb⟩ ⟨a, ha, b, hb, rfl⟩
    linarith
  · -- `ínf (A + B) ≥ ínf A + ínf B`: el ínfimo es la mayor cota inferior.
    exact le_csInf hne hlb

/-- `sup (A + B) = sup A + sup B` en el dialecto del curso: si `s = sup A` y `t = sup B`,
entonces `s + t = sup (A + B)`. Por la Proposición 3: `s + t` es cota superior, y dado `ε > 0`
hay `a ∈ A`, `b ∈ B` con `s - ε/2 < a ≤ s`, `t - ε/2 < b ≤ t`, así que
`s + t - ε < a + b ≤ s + t`. -/
theorem esSup_sumSet {A B : Set ℝ} {s t : ℝ} (hs : EsSup A s) (ht : EsSup B t) :
    EsSup (sumSet A B) (s + t) := by
  refine equiv_sup.2 ⟨?_, fun ε hε => ?_⟩
  · rintro _ ⟨a, ha, b, hb, rfl⟩
    exact add_le_add (hs.1 a ha) (ht.1 b hb)
  · obtain ⟨a, ha, ha₁, ha₂⟩ := (equiv_sup.1 hs).2 (ε / 2) (by positivity)
    obtain ⟨b, hb, hb₁, hb₂⟩ := (equiv_sup.1 ht).2 (ε / 2) (by positivity)
    exact ⟨a + b, ⟨a, ha, b, hb, rfl⟩, by linarith, by linarith⟩

/-- `ínf (A + B) = ínf A + ínf B` en el dialecto del curso: si `i = ínf A` y `j = ínf B`,
entonces `i + j = ínf (A + B)`. Por la Proposición 5, espejo de `esSup_sumSet`. -/
theorem esInf_sumSet {A B : Set ℝ} {i j : ℝ} (hi : EsInf A i) (hj : EsInf B j) :
    EsInf (sumSet A B) (i + j) := by
  refine equiv_inf.2 ⟨?_, fun ε hε => ?_⟩
  · rintro _ ⟨a, ha, b, hb, rfl⟩
    exact add_le_add (hi.1 a ha) (hj.1 b hb)
  · obtain ⟨a, ha, ha₁⟩ := (equiv_inf.1 hi).2 (ε / 2) (by positivity)
    obtain ⟨b, hb, hb₁⟩ := (equiv_inf.1 hj).2 (ε / 2) (by positivity)
    exact ⟨a + b, ⟨a, ha, b, hb, rfl⟩, by linarith⟩

end Comun
