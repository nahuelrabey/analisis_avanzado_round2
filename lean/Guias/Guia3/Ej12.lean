/-
Análisis Avanzado (FCEN-UBA) · Práctica 3 · Ejercicio 12
Enunciado en `apuntes-typst/guias/p3.typ`; resolución en `apuntes-typst/guias-agente/guia_3_resuelta_agente.typ` (Ejercicio 12).

En `ℝⁿ` (modelado como `Fin n → ℝ`, con `n ≥ 1`) se tienen las distancias `d₁`, `d₂`, `d∞`.

* (a) `d∞ ≤ d₂ ≤ d₁ ≤ n · d∞` (`dinf_le_d2`, `d2_le_d1`, `d1_le_n_dinf`) y de ahí la equivalencia
  de las tres métricas (`equivalentes_*`), con la definición de "métricas equivalentes" adoptada
  en el Typst: toda bola de una contiene una bola de la otra con el mismo centro, y viceversa.
  `abiertos_iff` formaliza "definen los mismos abiertos".
* (b) `B₁(x, r) ⊆ B₂(x, r) ⊆ B∞(x, r) ⊆ B₁(x, n r)` (`bola_inclusiones`).

Qué importa de `Comun`: las distancias y la cadena de desigualdades (`Comun.Metricas.Rn`:
`d1`, `d2`, `dinf`, `dinf_le_d2`, `d2_le_d1`, `d1_le_n_dinf`, `d2_le_n_dinf`, `d1_le_n_d2`,
`cadena`, `n_pos`) y la noción de métricas equivalentes (`Comun.Metricas`: `EsAbierto`,
`Equivalentes`, `abiertos_iff`, `equivalentes_of_le`). Quedan locales las tres equivalencias
del ítem (a) y las inclusiones de bolas del ítem (b).
-/
import Mathlib
import Comun.Metricas
import Comun.Metricas.Rn

namespace Guias.Guia3.Ej12

open Comun

variable {n : ℕ} [NeZero n]

/-! ## (a) Las desigualdades `d∞ ≤ d₂ ≤ d₁ ≤ n d∞` y la equivalencia de las tres métricas -/

/-- **Ej. 12 (a).** `d∞` y `d₂` son equivalentes. -/
theorem equivalentes_dinf_d2 : Equivalentes (dinf (n := n)) d2 :=
  equivalentes_of_le n_pos dinf_le_d2 d2_le_n_dinf

/-- **Ej. 12 (a).** `d₂` y `d₁` son equivalentes. -/
theorem equivalentes_d2_d1 : Equivalentes (d2 (n := n)) d1 :=
  equivalentes_of_le n_pos d2_le_d1 d1_le_n_d2

/-- **Ej. 12 (a).** `d∞` y `d₁` son equivalentes. -/
theorem equivalentes_dinf_d1 : Equivalentes (dinf (n := n)) d1 :=
  equivalentes_of_le n_pos (fun x y => (dinf_le_d2 x y).trans (d2_le_d1 x y)) d1_le_n_dinf

/-- **Ej. 12 (a), resumen.** La cadena completa de desigualdades (`Comun.cadena`). -/
theorem cadena (x y : Fin n → ℝ) :
    dinf x y ≤ d2 x y ∧ d2 x y ≤ d1 x y ∧ d1 x y ≤ n * dinf x y :=
  Comun.cadena x y

/-! ## (b) Inclusiones de bolas -/

/-- **Ej. 12 (b).** `B₁(x, r) ⊆ B₂(x, r) ⊆ B∞(x, r) ⊆ B₁(x, n r)`, para todo `r`. -/
theorem bola_inclusiones (x : Fin n → ℝ) (r : ℝ) :
    bola d1 x r ⊆ bola d2 x r ∧ bola d2 x r ⊆ bola dinf x r ∧
      bola dinf x r ⊆ bola d1 x (n * r) := by
  refine ⟨fun y hy => ?_, fun y hy => ?_, fun y hy => ?_⟩
  · exact lt_of_le_of_lt (d2_le_d1 x y) hy
  · exact lt_of_le_of_lt (dinf_le_d2 x y) hy
  · have hy' : dinf x y < r := hy
    calc d1 x y ≤ n * dinf x y := d1_le_n_dinf x y
      _ < n * r := mul_lt_mul_of_pos_left hy' n_pos

end Guias.Guia3.Ej12
