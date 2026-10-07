/-
Análisis Avanzado (FCEN-UBA) · Práctica 2 · Ejercicio 3
Enunciado en `apuntes-typst/guias/p2.typ`; resolución en
`apuntes-typst/guias-agente/guia_2_resuelta_agente.typ` (Ejercicio 3).

Sean `A ⊆ B` con `A` contable y `B \ A` infinito.
  (a) Existe `C ⊆ B \ A` con `C ∼ C ∪ A`: `C` es el subconjunto numerable de `B \ A` que da la
      Proposición 3.14; `C ∪ A` es contable (Ej. 2) e infinito, luego numerable, luego `∼ C`.
  (b) `B \ A ∼ B`: se pega la biyección `C → C ∪ A` con la identidad en `(B \ A) \ C`.

Las pruebas viven en `Comun.Cardinales.Numerables` (`exists_C_coordinables`, `pegar`,
`diff_coordinables`, que usan el Ej. 2 como `union_contable`); acá sólo se las re-enuncia.
-/
import Mathlib
import Comun.Cardinales
import Comun.Cardinales.Numerables

namespace Guias.Guia2.Ej03

open Comun

/-- **Ej. 3 (a).** Si `A` es contable y `B \ A` es infinito, existe `C ⊆ B \ A` con `C ∼ C ∪ A`.
(La hipótesis `A ⊆ B` del enunciado no se usa en este ítem.) Es `Comun.exists_C_coordinables`. -/
theorem ej3a {X : Type*} {A B : Set X} (hA : Contable A) (hBA : Infinito ↥(B \ A)) :
    ∃ C : Set X, C ⊆ B \ A ∧ Coordinables C ↥(C ∪ A) :=
  exists_C_coordinables hA hBA

/-- **Ej. 3 (b).** Si `A ⊆ B`, `A` es contable y `B \ A` es infinito, entonces `B \ A ∼ B`.
Es `Comun.diff_coordinables` (el pegado es `Comun.pegar`). -/
theorem ej3b {X : Type*} {A B : Set X} (hAB : A ⊆ B) (hA : Contable A)
    (hBA : Infinito ↥(B \ A)) : Coordinables ↥(B \ A) ↥B :=
  diff_coordinables hAB hA hBA

end Guias.Guia2.Ej03
