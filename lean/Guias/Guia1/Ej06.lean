/-
Práctica 1, Ejercicio 6 (`-A` y `c A`), con las nociones del curso (`Comun`):
`CotaSup`, `CotaInf`, `AcotadoSup`, `AcotadoInf` (Definiciones 1 y 4), `EsSup`, `EsInf`
(Definiciones 2 y 5).
Resolución "a mano" en `apuntes-typst/guias-agente/guia_1_resuelta_agente.typ` (Ejercicio 6).

El conjunto `c A = {c a : a ∈ A}` es la imagen `(fun a => c * a) '' A` (`Set.image`), y
`-A = {-a : a ∈ A}` es `(fun a => -a) '' A`. Un elemento de la imagen es `⟨a, ha, rfl⟩`: un
`a ∈ A` y la igualdad `f a = y`.
Las demostraciones siguen el texto: se prueba que `-s` (resp. `c s`) es cota inferior (resp.
superior) de la imagen, y que toda cota inferior `t` de `-A` da la cota superior `-t` de `A`
(resp. toda cota superior `t` de `c A` da la cota superior `t / c` de `A`), de donde `s ≤ -t`
(resp. `s ≤ t / c`) por la Definición 2. Esas pruebas viven en `Comun.Supremos` (`cotaInf_neg`,
`acotadoInf_neg_of_acotadoSup`, `esInf_neg`, `cotaSup_smul`, `acotadoSup_smul`, `esSup_smul`,
probadas allí sin `completitud_inf`, `Set.neg`, `IsLUB.neg`, `csSup_neg` ni `Real.sSup_smul`);
acá `ej6a_acotado` / `ej6a_inf` / `ej6b_acotado` / `ej6b_sup` las re-enuncian en una línea y
`ej6a` / `ej6b` las empaquetan.
-/
import Mathlib
import Comun.Supremos

open Comun

namespace Guias.Guia1.Ej06

/-! ## (a) `-A` -/

/-- **Ej. 6 (a), acotación.** Si `A` está acotado superiormente, `-A` está acotado
inferiormente (`-s` es cota inferior de `-A` si `s` lo es superior de `A`). Es
`Comun.acotadoInf_neg_of_acotadoSup`. -/
theorem ej6a_acotado {A : Set ℝ} (hb : AcotadoSup A) : AcotadoInf ((fun a => -a) '' A) :=
  acotadoInf_neg_of_acotadoSup hb

/-- **Ej. 6 (a), ínfimo.** Si `s = sup A`, entonces `ínf (-A) = -s`: `-s` es cota inferior de
`-A`, y si `t` es cota inferior de `-A`, entonces `-t` es cota superior de `A` (`t ≤ -a` da
`a ≤ -t`), luego `s ≤ -t` (Definición 2) y `t ≤ -s`. Es `Comun.esInf_neg`. -/
theorem ej6a_inf {A : Set ℝ} {s : ℝ} (hs : EsSup A s) : EsInf ((fun a => -a) '' A) (-s) :=
  esInf_neg hs

/-- **Ej. 6 (a).** Si `A` está acotado superiormente y `s = sup A`, entonces `-A` está acotado
inferiormente e `ínf (-A) = -sup A`. -/
theorem ej6a {A : Set ℝ} (hb : AcotadoSup A) {s : ℝ} (hs : EsSup A s) :
    AcotadoInf ((fun a => -a) '' A) ∧ EsInf ((fun a => -a) '' A) (-s) :=
  ⟨ej6a_acotado hb, ej6a_inf hs⟩

/-! ## (b) `c A` con `c > 0` -/

/-- **Ej. 6 (b), acotación.** Si `c > 0` y `A` está acotado superiormente, `c A` también
(`c s` es cota superior de `c A` si `s` lo es de `A`). Es `Comun.acotadoSup_smul`. -/
theorem ej6b_acotado {A : Set ℝ} {c : ℝ} (hc : 0 < c) (hb : AcotadoSup A) :
    AcotadoSup ((fun a => c * a) '' A) :=
  acotadoSup_smul hc hb

/-- **Ej. 6 (b), supremo.** Si `c > 0` y `s = sup A`, entonces `sup (c A) = c s`: `c s` es cota
superior de `c A`, y si `t` es cota superior de `c A`, entonces `t / c` es cota superior de `A`
(`c a ≤ t` da `a ≤ t / c`, dividiendo por `c > 0`), luego `s ≤ t / c` (Definición 2) y
`c s ≤ t`. Es `Comun.esSup_smul`. -/
theorem ej6b_sup {A : Set ℝ} {c s : ℝ} (hc : 0 < c) (hs : EsSup A s) :
    EsSup ((fun a => c * a) '' A) (c * s) :=
  esSup_smul hc hs

/-- **Ej. 6 (b).** Si `c > 0`, `A` está acotado superiormente y `s = sup A`, entonces `c A` está
acotado superiormente y `sup (c A) = c sup A`. -/
theorem ej6b {A : Set ℝ} {c : ℝ} (hc : 0 < c) (hb : AcotadoSup A) {s : ℝ} (hs : EsSup A s) :
    AcotadoSup ((fun a => c * a) '' A) ∧ EsSup ((fun a => c * a) '' A) (c * s) :=
  ⟨ej6b_acotado hc hb, ej6b_sup hc hs⟩

end Guias.Guia1.Ej06
