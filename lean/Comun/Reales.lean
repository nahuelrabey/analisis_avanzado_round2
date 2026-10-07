/-
Librería común `Comun`: definiciones del curso y resultados de `apuntes.typ` compartidos por las
guías (`Guias/`), los parciales (`Parciales/`) y los ejemplos (`Ejemplos/`). Ver
`apuntes-agente/lean-lemas-compartidos-y-organizacion.md` para el diseño.

`Comun.Reales`: hechos sobre `ℝ` que no son de ningún ejercicio en particular. Por ahora, los
Principios de Arquímedes (Teorema 1 y Proposición 1 de `apuntes.typ`) y la densidad de `ℚ`
(Proposición 2). La Proposición 2 es el Ej. 2 (b) de la Práctica 1: no se usa en `Guias/Guia1/Ej02`.
-/
import Mathlib

namespace Comun

/-- **Teorema 1 (Principio de Arquímedes).** Para todo `x ∈ ℝ` hay `n ∈ ℕ` con `x ≤ n`. -/
theorem arquimedes (x : ℝ) : ∃ n : ℕ, x ≤ n := exists_nat_ge x

/-- **Proposición 1 (Principio de Arquímedes 2).** Si `y > 0` hay `n ∈ ℕ` con `0 < 1/n < y`
(`0 < 1/n` fuerza `n ≥ 1`). -/
theorem arquimedes2 {y : ℝ} (hy : 0 < y) : ∃ n : ℕ, 0 < (1 : ℝ) / n ∧ (1 : ℝ) / n < y := by
  obtain ⟨n, hn⟩ := exists_nat_one_div_lt hy
  refine ⟨n + 1, by positivity, ?_⟩
  simpa using hn

/-- **Proposición 2 (Densidad de `ℚ`).** Entre dos reales distintos hay un racional.
(Es el Ej. 2 (b): no usar en `Ej02.lean`.) -/
theorem densidad_Q {x y : ℝ} (h : x < y) : ∃ q : ℚ, x < q ∧ q < y := exists_rat_btwn h

end Comun
