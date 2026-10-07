/-
Práctica 3 · Ejercicio 14 (`apuntes-typst/guias/p3.typ`); resolución en
`apuntes-typst/guias-agente/guia_3_resuelta_agente.typ` (Ejercicio 14).

Pruebe que `(ℝⁿ, d₁)`, `(ℝⁿ, d₂)` y `(ℝⁿ, d∞)` son completos.

Formalización fiel al texto, sin instancias: trabajamos con las funciones de distancia
explícitas `d₁, d₂, d∞ : (Fin n → ℝ) → (Fin n → ℝ) → ℝ` de `Comun.Metricas.Rn` (las mismas del
Ej. 1 (b)-(d) y del Ej. 12) y con la Definición 4.55 de `apuntes.typ` ("toda sucesión de Cauchy
tiene límite") escrita con `ε`-`N` (Definiciones 4.42 y 4.51: `Comun.EsCauchy`,
`Comun.ConvergeMet`, `Comun.EsCompleto`). No se usa que Mathlib ya tenga `CompleteSpace` para
`PiLp`/`EuclideanSpace`.

Convención: `n ≥ 1` (`[NeZero n]`) y las sucesiones empiezan en `0` (en el curso, en `1`).

Estructura (la misma que el texto Typst), toda en `Comun`:
1. `d∞`: prueba por coordenadas del Corolario 4.58 y completitud de `ℝ` (Teorema 4.57)
   (`Comun.completo_dinf`).
2. Desigualdades `d∞ ≤ d₂ ≤ d₁ ≤ n d∞`: `Comun.dinf_le_d2`, `Comun.d2_le_d1`,
   `Comun.d1_le_n_dinf` (Ej. 12 (a), como cita el texto).
3. Lema: si `d∞ ≤ d ≤ n d∞`, y `(ℝⁿ, d∞)` es completo, entonces `(ℝⁿ, d)` es completo
   (`Comun.completo_of_equiv`, en general para `c · d₀ ≤ d ≤ C · d₀`).
4. Se aplica el lema a `d₁` y a `d₂` (`Comun.completo_d1`, `Comun.completo_d2`).
Este archivo sólo re-enuncia los tres casos y el lema con los nombres del texto.
-/
import Mathlib
import Comun.Metricas
import Comun.Metricas.Rn

open Comun

namespace Guias.Guia3.Ej14

variable {n : ℕ}

/-- **Ejercicio 14, caso `d∞`** (prueba por coordenadas del Corolario 4.58; `Comun.completo_dinf`). -/
theorem completo_dinf [NeZero n] : EsCompleto (dinf (n := n)) := Comun.completo_dinf

/-- Lema del texto: si `d∞ ≤ d ≤ n d∞` y `(ℝⁿ, d∞)` es completo, entonces `(ℝⁿ, d)` es completo
(caso `c = 1`, `C = n` de `Comun.completo_of_equiv`). -/
theorem completo_of_equiv [NeZero n] (d : (Fin n → ℝ) → (Fin n → ℝ) → ℝ)
    (hlow : ∀ x y, dinf x y ≤ d x y) (hup : ∀ x y, d x y ≤ n * dinf x y) :
    EsCompleto d :=
  Comun.completo_of_equiv completo_dinf one_pos n_pos (fun x y => by rw [one_mul]; exact hlow x y)
    hup

/-- **Ejercicio 14, caso `d₁`** (`Comun.completo_d1`). -/
theorem completo_d1 [NeZero n] : EsCompleto (d1 (n := n)) := Comun.completo_d1

/-- **Ejercicio 14, caso `d₂`** (`Comun.completo_d2`). -/
theorem completo_d2 [NeZero n] : EsCompleto (d2 (n := n)) := Comun.completo_d2

/-- **Ejercicio 14.** `(ℝⁿ, d₁)`, `(ℝⁿ, d₂)` y `(ℝⁿ, d∞)` son completos. -/
theorem ej14 [NeZero n] :
    EsCompleto (d1 (n := n)) ∧ EsCompleto (d2 (n := n)) ∧ EsCompleto (dinf (n := n)) :=
  ⟨completo_d1, completo_d2, completo_dinf⟩

end Guias.Guia3.Ej14
