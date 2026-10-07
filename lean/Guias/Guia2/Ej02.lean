/-
Análisis Avanzado (FCEN-UBA) · Práctica 2 · Ejercicio 2
Enunciado en `apuntes-typst/guias/p2.typ`; resolución en
`apuntes-typst/guias-agente/guia_2_resuelta_agente.typ` (Ejercicio 2).

Si `A` y `B` son contables, `A ∪ B` es contable. El argumento es una cadena de inyecciones
  `A ∪ B ↪ A ⊕ B ↪ ℕ ⊕ ℕ ↪ ℕ`
(la primera manda `x` a su copia en `A` si `x ∈ A` y a su copia en `B` si no; la segunda es
"contable ⇒ `#A ≤ #ℕ`"; la tercera es pares/impares), y después la Proposición 3.13.
No se usa `Set.Countable.union` ni ninguna instancia `Countable`.

La prueba vive en `Comun.Cardinales.Numerables` (`union_contable`, con los sublemas
`cardLe_nat_of_contable` en `Comun.Cardinales`, `sumNatEmb` y `unionEmb`); acá sólo se la
re-enuncia.
-/
import Mathlib
import Comun.Cardinales
import Comun.Cardinales.Numerables

namespace Guias.Guia2.Ej02

open Comun

/-- **Ej. 2.** Si `A` y `B` son contables, `A ∪ B` es contable (`Comun.union_contable`). -/
theorem ej2 {X : Type*} (A B : Set X) (hA : Contable A) (hB : Contable B) :
    Contable ↥(A ∪ B) :=
  union_contable A B hA hB

end Guias.Guia2.Ej02
