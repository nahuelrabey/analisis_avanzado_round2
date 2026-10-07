/-
Análisis Avanzado (FCEN-UBA) · Práctica 3 · Ejercicio 9 (frontera).
Enunciado en `apuntes-typst/guias/p3.typ`; resolución en `apuntes-typst/guias-agente/guia_3_resuelta_agente.typ` (Ejercicio 9).

Sea `E` un espacio métrico y `A ⊆ E`.
(a) `∂A = cl A ∖ A°`, y `∂A` es cerrado.
(b) `∂A = cl A ∩ cl (E ∖ A)`, y por lo tanto `∂A = ∂(E ∖ A)`.

La frontera es la de la Definición 4.38 de `apuntes.typ` (`Comun.fronteraCurso`), definida por
bolas. `interior` y `closure` son los de Mathlib, pero se manejan siempre a través de su
caracterización por bolas (Definiciones 4.11 y 4.22: `Comun.mem_interior_iff_ball` y
`Comun.mem_closure_iff_ball`). Los Ejercicios 5 (a) y 5 (b) (`Comun.compl_interior_eq`,
`Comun.compl_closure_eq`) dan "`A°` es abierto" y "`cl A` es cerrado" (Paso 3 del texto:
`Comun.isOpen_interior_bolas`, `Comun.isClosed_closure_bolas`), sin usar
`isOpen_interior`/`isClosed_closure` de Mathlib.

Qué importa de `Comun`: todo (`Comun.Topologia`: `fronteraCurso`, `frontera_eq_inter`,
`frontera_eq_sdiff`, `frontera_isClosed`, `closure_frontera_eq`, `frontera_compl`). Este archivo
sólo re-enuncia los ítems.
-/
import Mathlib
import Comun.Topologia

open Comun

namespace Guias.Guia3.Ej09

variable {E : Type*} [MetricSpace E]

/-- **Ejercicio 9 (a), igualdad.** `∂A = cl A ∖ A°`.
Se usa `∂A = cl A ∩ cl (E ∖ A)` y el Ejercicio 5 (a): `cl (E ∖ A) = E ∖ A°`
(`Comun.frontera_eq_sdiff`). -/
theorem frontera_eq_sdiff (A : Set E) : fronteraCurso A = closure A \ interior A :=
  Comun.frontera_eq_sdiff A

/-- **Ejercicio 9 (a), cerrado.** `∂A = cl A ∩ (E ∖ A°)` es intersección de dos cerrados
(Teorema 4.31 (a)): `cl A` por `isClosed_closure_bolas` y `E ∖ A°` por el Teorema 4.29
(`isClosed_compl_iff`) con `isOpen_interior_bolas` (`Comun.frontera_isClosed`). -/
theorem frontera_isClosed (A : Set E) : IsClosed (fronteraCurso A) := Comun.frontera_isClosed A

/-- Lo mismo en la forma de la Definición 4.27: `cl (∂A) = ∂A` (`Comun.closure_frontera_eq`). -/
theorem closure_frontera_eq (A : Set E) : closure (fronteraCurso A) = fronteraCurso A :=
  Comun.closure_frontera_eq A

/-- **Ejercicio 9 (b), igualdad.** `∂A = cl A ∩ cl (E ∖ A)` (`Comun.frontera_eq_inter`). -/
theorem frontera_eq_inter (A : Set E) : fronteraCurso A = closure A ∩ closure Aᶜ :=
  Comun.frontera_eq_inter A

/-- **Ejercicio 9 (b), conclusión.** `∂A = ∂(E ∖ A)`: como `E ∖ (E ∖ A) = A`, la fórmula
anterior aplicada a `E ∖ A` da `cl (E ∖ A) ∩ cl A`, que es lo mismo por conmutatividad
(`Comun.frontera_compl`). -/
theorem frontera_compl (A : Set E) : fronteraCurso A = fronteraCurso Aᶜ := Comun.frontera_compl A

end Guias.Guia3.Ej09
