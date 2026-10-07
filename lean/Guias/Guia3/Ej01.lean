/-
Análisis Avanzado (FCEN-UBA) · Práctica 3 · Ejercicio 1
Enunciado en `apuntes-typst/guias/p3.typ`; resolución en `apuntes-typst/guias-agente/guia_3_resuelta_agente.typ` (Ejercicio 1).

Para cada espacio de la lista se prueba `EsMetrica d` (los cuatro axiomas de la Definición 4.1,
ver `Comun/Metricas.lean`) sobre una función `d` definida a mano, y se verifica la descripción
conjuntista de la bola abierta que se dibuja en el Typst:

* (a) `ℝ`, `|x - y|`:                    `B(x, r) = (x - r, x + r)`.
* (b) `ℝⁿ`, `d₂`:                        `B₂(c, r) = {x : ∑ (xᵢ - cᵢ)² < r²}`; en `ℝ²`, el disco unitario.
* (c) `ℝⁿ`, `d₁`:                        `B₁(0, 1) = {abs x₀ + abs x₁ < 1}` en `ℝ²` (rombo).
* (d) `ℝⁿ`, `d∞` (con `max`):            `B∞(c, r) = {x : ∀ i, |xᵢ - cᵢ| < r}`; en `ℝ²`, el cuadrado.
* (e) `C([0,1])`, `d∞` (con `max`):      `B(f, r) = {g : ∀ t, f t - r < g t < f t + r}` (banda).
* (f) `E`, `δ`:                          `B(x, r) = {x}` si `0 < r ≤ 1` y `B(x, r) = E` si `r > 1`.

Qué importa de `Comun`: las distancias `d1`, `d2`, `dinf` de `ℝⁿ` con sus axiomas y bolas
(`Comun.Metricas.Rn`: `esMetrica_d2/d1/dinf`, `bola_d2`, `bola_dinf`, `cauchy_schwarz`), `C01` y
`dC` (`Comun.Metricas.C01`: `esMetrica_dC`, `bola_dC`, `dC_eq_max`) y la métrica discreta `δ`
(`Comun.Metricas.Discreta`: `esMetrica_delta`, `bola_delta_le/gt`). Los ítems (b)-(f) son
alias de esos lemas. Queda local el ítem (a) (`dA`, `ej1a`, `bola_dA`) y los tres dibujos en `ℝ²`.

Desvíos respecto del texto: `ℝⁿ` es `Fin n → ℝ` con `n ≥ 1` (`[NeZero n]`, para que el máximo
sobre `{1, …, n}` tenga sentido); `C([0,1])` es `C(unitInterval, ℝ)`; el máximo de `d∞` en
`C([0,1])` se formaliza como `⨆` y se prueba aparte (`dC_eq_max`) que se alcanza (Weierstrass,
vía `IsCompact.exists_isMaxOn`, el teorema de los valores extremos en un compacto: es el
mismo teorema que cita la guía al escribir "máx").
-/
import Mathlib
import Comun.Metricas
import Comun.Metricas.Rn
import Comun.Metricas.C01
import Comun.Metricas.Discreta

namespace Guias.Guia3.Ej01

open Comun

/-! ## (a) `ℝ` con `d(x, y) = |x - y|` -/

/-- `d(x, y) = |x - y|` en `ℝ`. -/
def dA (x y : ℝ) : ℝ := |x - y|

/-- **Ej. 1 (a).** `|x - y|` es una métrica en `ℝ`. -/
theorem ej1a : EsMetrica dA where
  nonneg x y := abs_nonneg _
  eq_zero_iff x y := by
    unfold dA
    rw [abs_eq_zero, sub_eq_zero]
  symm x y := abs_sub_comm x y
  triangle x y z := abs_sub_le x y z

/-- Bola abierta del dibujo (a): `B(x, r) = (x - r, x + r)`. -/
theorem bola_dA (x r : ℝ) : bola dA x r = Set.Ioo (x - r) (x + r) := by
  ext y
  simp only [bola, dA, Set.mem_ofPred_eq, Set.mem_Ioo]
  rw [abs_sub_lt_iff]
  constructor <;> rintro ⟨h1, h2⟩ <;> constructor <;> linarith

/-! ## (b) `ℝⁿ` con la distancia euclídea `d₂` -/

/-- **Ej. 1 (b).** `d₂` es una métrica en `ℝⁿ` (`Comun.esMetrica_d2`). -/
theorem ej1b (n : ℕ) : EsMetrica (d2 (n := n)) := esMetrica_d2 n

/-- En `ℝ²`: `B₂(0, 1)` es el disco unitario abierto `{x₀² + x₁² < 1}`. -/
theorem bola_d2_R2 : bola d2 (0 : Fin 2 → ℝ) 1 = {x | x 0 ^ 2 + x 1 ^ 2 < 1} := by
  rw [bola_d2 _ one_pos]
  ext x
  simp [Fin.sum_univ_two]

/-! ## (c) `ℝⁿ` con la distancia taxista `d₁` -/

/-- **Ej. 1 (c).** `d₁` es una métrica en `ℝⁿ` (`Comun.esMetrica_d1`). -/
theorem ej1c (n : ℕ) : EsMetrica (d1 (n := n)) := esMetrica_d1 n

/-- En `ℝ²`: `B₁(0, 1)` es el rombo abierto `{|x₀| + |x₁| < 1}`. -/
theorem bola_d1_R2 : bola d1 (0 : Fin 2 → ℝ) 1 = {x | |x 0| + |x 1| < 1} := by
  ext x
  simp [bola, d1, Fin.sum_univ_two]

/-! ## (d) `ℝⁿ` con la distancia del máximo `d∞` -/

/-- **Ej. 1 (d).** `d∞` es una métrica en `ℝⁿ` (`n ≥ 1`) (`Comun.esMetrica_dinf`). -/
theorem ej1d (n : ℕ) [NeZero n] : EsMetrica (dinf (n := n)) := esMetrica_dinf n

/-- En `ℝ²`: `B∞(0, 1)` es el cuadrado abierto `(-1, 1) × (-1, 1)`. -/
theorem bola_dinf_R2 : bola dinf (0 : Fin 2 → ℝ) 1 = {x | |x 0| < 1 ∧ |x 1| < 1} := by
  rw [bola_dinf]
  ext x
  simp [Fin.forall_fin_two]

/-! ## (e) `C([0, 1])` con la distancia `d∞(f, g) = máx_t |f t - g t|` -/

/-- **Ej. 1 (e).** `d∞` es una métrica en `C([0, 1])` (`Comun.esMetrica_dC`). -/
theorem ej1e : EsMetrica dC := esMetrica_dC

/-! ## (f) La métrica discreta `δ` en un conjunto `E` -/

/-- **Ej. 1 (f).** `δ` es una métrica en `E` (para todo `E`; si es no vacío es un espacio métrico
no trivial, y si es vacío no hay nada que chequear) (`Comun.esMetrica_delta`). -/
theorem ej1f (E : Type*) [DecidableEq E] : EsMetrica (δ (E := E)) := esMetrica_delta E

end Guias.Guia3.Ej01
