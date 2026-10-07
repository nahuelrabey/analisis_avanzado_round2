/-
Práctica 1, Ejercicio 5 (monotonía de cotas, supremo e ínfimo respecto de la inclusión), con las
nociones del curso (`Comun`): `CotaSup`, `CotaInf`, `AcotadoSup`, `AcotadoInf`,
`Acotado` (Definiciones 1 y 4), `EsSup`, `EsInf` (Definiciones 2 y 5).
Resolución "a mano" en `apuntes-typst/guias-agente/guia_1_resuelta_agente.typ` (Ejercicio 5).

Hipótesis: `A ⊆ B ⊆ ℝ`, `A ≠ ∅`. Los ítems (a) y (b) se prueban sólo con las Definiciones 1, 2,
4 y 5 (toda cota de `B` es cota de `A`; el supremo de `B` es cota superior de `A`, luego mayor o
igual que el supremo de `A`). Para hablar de `sup A` hay que saber que existe: eso lo da el
Axioma de Completitud (`axioma_completitud`) con `A ≠ ∅` y `A` acotado, y lo mismo el Teorema 2
(`completitud_inf`) para el ínfimo; los teoremas `ej5a_sup` / `ej5b_inf` toman los dos extremos
como hipótesis (`EsSup A s`, `EsSup B t`) y concluyen `s ≤ t`, y `ej5a` / `ej5b` empaquetan la
existencia. El ítem (c) es el contrarrecíproco de (a) + (b), sólo con cotas.
No se usan `sSup`, `sInf`, `csSup_le_csSup` ni `BddAbove.mono`.
-/
import Mathlib
import Comun.Reales
import Comun.Supremos
import Comun.Sucesiones

open Comun

namespace Guias.Guia1.Ej05

/-! ## (a) Cotas superiores y supremos -/

/-- **Ej. 5 (a), acotación.** Si `A ⊆ B` y `B` está acotado superiormente, `A` también: toda
cota superior de `B` lo es de `A` (Definición 1). -/
theorem ej5a_acotado {A B : Set ℝ} (hAB : A ⊆ B) (hB : AcotadoSup B) : AcotadoSup A := by
  obtain ⟨c, hc⟩ := hB
  exact ⟨c, fun a ha => hc a (hAB ha)⟩

/-- **Ej. 5 (a), desigualdad.** Si `s = sup A` y `t = sup B`, entonces `s ≤ t`: `t` es cota
superior de `B`, luego de `A`, y `s` es la menor cota superior de `A` (Definición 2). -/
theorem ej5a_sup {A B : Set ℝ} (hAB : A ⊆ B) {s t : ℝ} (hs : EsSup A s) (ht : EsSup B t) :
    s ≤ t :=
  hs.2 t (fun a ha => ht.1 a (hAB ha))

/-- **Ej. 5 (a).** Si `A ⊆ B`, `A ≠ ∅` y `B` está acotado superiormente, entonces `A` está
acotado superiormente y `sup A ≤ sup B` (ambos supremos existen por el Axioma de Completitud). -/
theorem ej5a {A B : Set ℝ} (hAB : A ⊆ B) (hne : A.Nonempty) (hB : AcotadoSup B) :
    AcotadoSup A ∧ ∃ s t, EsSup A s ∧ EsSup B t ∧ s ≤ t := by
  have hA := ej5a_acotado hAB hB
  obtain ⟨s, hs⟩ := axioma_completitud hne hA
  obtain ⟨t, ht⟩ := axioma_completitud (hne.mono hAB) hB
  exact ⟨hA, s, t, hs, ht, ej5a_sup hAB hs ht⟩

/-! ## (b) Cotas inferiores e ínfimos -/

/-- **Ej. 5 (b), acotación.** Si `A ⊆ B` y `B` está acotado inferiormente, `A` también: toda
cota inferior de `B` lo es de `A` (Definición 4). -/
theorem ej5b_acotado {A B : Set ℝ} (hAB : A ⊆ B) (hB : AcotadoInf B) : AcotadoInf A := by
  obtain ⟨c, hc⟩ := hB
  exact ⟨c, fun a ha => hc a (hAB ha)⟩

/-- **Ej. 5 (b), desigualdad.** Si `i = ínf A` y `j = ínf B`, entonces `j ≤ i`: `j` es cota
inferior de `B`, luego de `A`, e `i` es la mayor cota inferior de `A` (Definición 5). -/
theorem ej5b_inf {A B : Set ℝ} (hAB : A ⊆ B) {i j : ℝ} (hi : EsInf A i) (hj : EsInf B j) :
    j ≤ i :=
  hi.2 j (fun a ha => hj.1 a (hAB ha))

/-- **Ej. 5 (b).** Si `A ⊆ B`, `A ≠ ∅` y `B` está acotado inferiormente, entonces `A` está
acotado inferiormente e `ínf B ≤ ínf A` (ambos ínfimos existen por el Teorema 2). -/
theorem ej5b {A B : Set ℝ} (hAB : A ⊆ B) (hne : A.Nonempty) (hB : AcotadoInf B) :
    AcotadoInf A ∧ ∃ i j, EsInf A i ∧ EsInf B j ∧ j ≤ i := by
  have hA := ej5b_acotado hAB hB
  obtain ⟨i, hi⟩ := completitud_inf hne hA
  obtain ⟨j, hj⟩ := completitud_inf (hne.mono hAB) hB
  exact ⟨hA, i, j, hi, hj, ej5b_inf hAB hi hj⟩

/-! ## (c) Conjuntos no acotados -/

/-- **Ej. 5 (c).** Si `A ⊆ B` y `A` no está acotado, `B` tampoco: es el contrarrecíproco de
"`B` acotado ⇒ `A` acotado", que sale de (a) y (b) (sólo la parte de cotas). -/
theorem ej5c {A B : Set ℝ} (hAB : A ⊆ B) (hA : ¬ Acotado A) : ¬ Acotado B := by
  intro hB
  exact hA ⟨ej5a_acotado hAB hB.1, ej5b_acotado hAB hB.2⟩

end Guias.Guia1.Ej05
