/-
Definiciones comunes para las resoluciones de las guías (`apuntes-typst/guias-agente/`).

`EsMetrica d` es la Definición 4.1 de `apuntes.typ` tal cual: no negatividad, separación,
simetría y desigualdad triangular. Se usa para verificar ejercicios del tipo "pruebe que `d`
es una métrica" sobre funciones definidas a mano, sin depender de que Mathlib ya traiga la
instancia.
-/
import Mathlib

namespace Guias

/-- Definición 4.1 (Métrica y espacio métrico): `d : X × X → ℝ` es una métrica en `X`. -/
structure EsMetrica {X : Type*} (d : X → X → ℝ) : Prop where
  /-- (i) `d(x, y) ≥ 0`. -/
  nonneg : ∀ x y, 0 ≤ d x y
  /-- (ii) `d(x, y) = 0 ↔ x = y`. -/
  eq_zero_iff : ∀ x y, d x y = 0 ↔ x = y
  /-- (iii) simetría. -/
  symm : ∀ x y, d x y = d y x
  /-- (iv) desigualdad triangular. -/
  triangle : ∀ x y z, d x z ≤ d x y + d y z

/-- Bola abierta `B(x₀, r) = {y : d(x₀, y) < r}` para una función de distancia cualquiera. -/
def bola {X : Type*} (d : X → X → ℝ) (x₀ : X) (r : ℝ) : Set X := {y | d x₀ y < r}

/-- Bola cerrada `B[x₀, r] = {y : d(x₀, y) ≤ r}`. -/
def bolaCerrada {X : Type*} (d : X → X → ℝ) (x₀ : X) (r : ℝ) : Set X := {y | d x₀ y ≤ r}

end Guias
