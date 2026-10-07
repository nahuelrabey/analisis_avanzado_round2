/-
Práctica 2, Ejercicio 11 (las partes finitas de un numerable son numerables).
Resolución "a mano" en `apuntes-typst/guias-agente/_partes2/ej11.typ`.

Si `e : ℕ → A` es biyectiva, `𝒫_f(A) = {B ⊆ A : B finito}` es numerable:
* es contable porque `B ↦ Σ_{a ∈ B} 2^(e⁻¹(a))` es una inyección `𝒫_f(A) → ℕ` (unicidad del
  desarrollo binario: un conjunto finito de naturales `S` queda determinado por `Σ_{k ∈ S} 2^k`,
  pues el `k`-ésimo dígito binario de esa suma es `1` exactamente cuando `k ∈ S`), y luego se
  aplica la Proposición 3.13;
* es infinito porque `n ↦ {e(n)}` es una inyección `ℕ → 𝒫_f(A)`.

Convenciones: `𝒫_f(A)` es el subtipo `{B : Set A // B.Finite}`; `ℕ` empieza en `0`.
Toda la prueba vive en `Comun.Cardinales.Numerables` (`codigo`, `testBit_codigo`,
`codigo_injective`, `codificar`, `unitario`, `partes_finitas_contable`, `partes_finitas_infinito`,
`partes_finitas_numerable`); acá sólo se la re-enuncia.
-/
import Mathlib
import Comun.Cardinales
import Comun.Cardinales.Numerables

namespace Guias.Guia2.Ej11

open Comun

variable {A : Type*}

/-- `𝒫_f(A)` es contable: `#𝒫_f(A) ≤ #ℕ` y Proposición 3.13 (`Comun.partes_finitas_contable`). -/
theorem ej11_contable (h : Numerable A) : Contable {B : Set A // B.Finite} :=
  partes_finitas_contable h

/-- `𝒫_f(A)` es infinito: contiene una copia de `ℕ` (`ℵ₀ ≤ #𝒫_f(A)`;
`Comun.partes_finitas_infinito`). -/
theorem ej11_infinito (h : Numerable A) : Infinito {B : Set A // B.Finite} :=
  partes_finitas_infinito h

/-- **Ej. 11.** Si `A` es numerable, `𝒫_f(A) = {B ⊆ A : B finito}` es numerable
(contable e infinito, Definición 3.6; `Comun.partes_finitas_numerable`). -/
theorem ej11 (h : Numerable A) : Numerable {B : Set A // B.Finite} :=
  partes_finitas_numerable h

end Guias.Guia2.Ej11
