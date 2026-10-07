/-
Práctica 1, Ejercicio 1 (el orden de `ℝ` y los `ε`): si `x < y + ε` para todo `ε > 0` entonces
`x ≤ y`, y si `|x - y| < ε` para todo `ε > 0` entonces `x = y`.
Resolución "a mano" en `apuntes-typst/guias-agente/guia_1_resuelta_agente.typ` (Ejercicio 1).

Sólo se usa el orden de `ℝ` (contrarrecíproco con `ε = x - y`) y el hecho de base
`|x - y| < ε ↔ -ε < x - y < ε` (`abs_lt`). No se usa la Unicidad del límite
(`unicidad_limite`), cuya demostración en `apuntes.typ` pasa por este ejercicio.
-/
import Mathlib
import Comun.Reales
import Comun.Supremos
import Comun.Sucesiones

open Comun

namespace Guias.Guia1.Ej01

/-- **Ej. 1, primera parte.** Si `x < y + ε` para todo `ε > 0`, entonces `x ≤ y`.
Por el contrarrecíproco: si `y < x`, el `ε = x - y > 0` da `x < y + (x - y) = x`, absurdo. -/
theorem ej1a {x y : ℝ} (h : ∀ ε > 0, x < y + ε) : x ≤ y := by
  by_contra hxy
  have hε : 0 < x - y := by linarith [not_le.1 hxy]
  have := h (x - y) hε
  linarith

/-- **Ej. 1, segunda parte.** Si `|x - y| < ε` para todo `ε > 0`, entonces `x = y`.
De `|x - y| < ε` salen `x < y + ε` y `y < x + ε`; la primera parte aplicada dos veces da `x ≤ y`
e `y ≤ x`. -/
theorem ej1b {x y : ℝ} (h : ∀ ε > 0, |x - y| < ε) : x = y := by
  have h1 : x ≤ y := ej1a fun ε hε => by linarith [(abs_lt.1 (h ε hε)).2]
  have h2 : y ≤ x := ej1a fun ε hε => by linarith [(abs_lt.1 (h ε hε)).1]
  exact le_antisymm h1 h2

end Guias.Guia1.Ej01
