/-
Práctica 3, Ejercicio 4 (bolas, conjuntos abiertos y cerrados), con las nociones del curso:
interior (Definición 4.11), abierto (4.14), clausura (4.22) y cerrado (4.27).
Resolución "a mano" en `apuntes-typst/guias-agente/guia_3_resuelta_agente.typ` (Ejercicio 4).

Los objetos son los de Mathlib (`interior`, `closure`, `Metric.ball`, `Metric.closedBall`,
`IsOpen`, `IsClosed`), pero las demostraciones pasan por las caracterizaciones por bolas
(`Comun.mem_closure_iff_ball`, `Comun.closure_mono_ball`; `Metric.isOpen_iff`, `dist_triangle`)
y no por los lemas de Mathlib que son literalmente los ítems. "Abierto" es `IsOpen`, que
`Metric.isOpen_iff` lee como "todo punto tiene una bola adentro" (`A ⊆ A°`, que con la
Observación 4.12 es la Definición 4.14).

Qué importa de `Comun`: los ítems (a)-(e) viven en `Comun.Topologia` (`isClosed_singleton_bolas`,
`isOpen_ball_bolas`, `closure_ball_subset_ball_of_lt`, `isClosed_closedBall_bolas`,
`closure_ball_subset_closedBall_bolas`, más `isClosed_iff_isOpen_compl_ball` e
`isOpen_inter_ball`), y la métrica discreta `Disc X` con `Disc.ball_one`/`Disc.closedBall_one`
en `Comun.Metricas.Discreta`. Quedan locales (f) y (g).
-/
import Mathlib
import Comun.Metricas
import Comun.Metricas.Discreta
import Comun.Topologia

open Metric Set Comun

namespace Guias.Guia3.Ej04

variable {E : Type*} [MetricSpace E]

/-! ## (a) `{x}` es cerrado -/

/-- **Ej. 4 (a).** `{x}` es cerrado: si `y ∈ cl {x}`, toda bola `B(y, r)` contiene a `x`, así que
`d(y, x) < r` para todo `r > 0` y por lo tanto `y = x` (`Comun.isClosed_singleton_bolas`). -/
theorem ej4a (x : E) : IsClosed ({x} : Set E) := isClosed_singleton_bolas x

/-! ## (b) `B(x, r)` es abierta -/

/-- **Ej. 4 (b).** `B(x, r)` es abierta (vale para todo `r`, en particular para `r > 0`):
si `y ∈ B(x, r)`, la bola `B(y, r - d(y, x))` queda dentro de `B(x, r)` por la triangular
(`Comun.isOpen_ball_bolas`). -/
theorem ej4b (x : E) (r : ℝ) : IsOpen (ball x r) := isOpen_ball_bolas x r

/-! ## (c) `cl B(x, r') ⊆ B(x, r)` si `r' < r` -/

/-- **Ej. 4 (c).** Si `r' < r` (el argumento no usa `r' > 0`) entonces `cl B(x, r') ⊆ B(x, r)`:
para `y ∈ cl B(x, r')` se toma `ε = r - r'` y un `z ∈ B(x, r') ∩ B(y, ε)`, de modo que
`d(y, x) ≤ d(y, z) + d(z, x) < (r - r') + r' = r` (`Comun.closure_ball_subset_ball_of_lt`). -/
theorem ej4c (x : E) {r r' : ℝ} (hrr : r' < r) : closure (ball x r') ⊆ ball x r :=
  closure_ball_subset_ball_of_lt x hrr

/-! ## (d) `B̄(x, r)` es cerrada -/

/-- **Ej. 4 (d).** `B̄(x, r) = {y | d(x, y) ≤ r}` es cerrada: su complemento es abierto, pues si
`d(y, x) > r` entonces `B(y, d(y, x) - r)` no corta a `B̄(x, r)` (Teorema 4.29)
(`Comun.isClosed_closedBall_bolas`). -/
theorem ej4d (x : E) (r : ℝ) : IsClosed (closedBall x r) := isClosed_closedBall_bolas x r

/-! ## (e) `cl B(x, r) ⊆ B̄(x, r)` -/

/-- **Ej. 4 (e).** `B(x, r) ⊆ B̄(x, r)`, la clausura es monótona y `B̄(x, r)` es cerrada por (d),
luego `cl B(x, r) ⊆ cl B̄(x, r) = B̄(x, r)` (`Comun.closure_ball_subset_closedBall_bolas`). -/
theorem ej4e (x : E) (r : ℝ) : closure (ball x r) ⊆ closedBall x r :=
  closure_ball_subset_closedBall_bolas x r

/-! ## (f) Un ejemplo con inclusión estricta: la métrica discreta -/

/-- **Ej. 4 (f).** En `X` con la métrica discreta y al menos dos puntos,
`cl B(x, 1) = {x} ⊊ X = B̄(x, 1)`: la inclusión de (e) puede ser estricta. -/
theorem ej4f {X : Type*} [Nontrivial X] (x : Disc X) :
    closure (ball x 1) ⊂ closedBall x 1 := by
  have hcl : closure (ball x 1) = {x} := by
    rw [Disc.ball_one]
    exact (ej4a x).closure_eq
  refine ⟨ej4e x 1, fun h => ?_⟩
  obtain ⟨y, hy⟩ : ∃ y : Disc X, y ≠ x := exists_ne (show X from x)
  have hy1 : y ∈ closedBall x 1 := by rw [Disc.closedBall_one]; trivial
  have := h hy1
  rw [hcl, mem_singleton_iff] at this
  exact hy this

/-- Caso concreto de (f): el conjunto `{false, true}` con la métrica discreta. -/
theorem ej4f_bool (x : Disc Bool) : closure (ball x 1) ⊂ closedBall x 1 := ej4f x

/-! ## (g) `{y | 2 < d(y, x) < 3}` es abierto -/

/-- **Ej. 4 (g).** `{y | 2 < d(y, x) < 3} = B(x, 3) ∩ (B̄(x, 2))ᶜ` es intersección de dos abiertos:
`B(x, 3)` por (b) y `(B̄(x, 2))ᶜ` por (d) y el Teorema 4.29; se concluye con el Teorema 4.18. -/
theorem ej4g (x : E) : IsOpen {y : E | 2 < dist y x ∧ dist y x < 3} := by
  have h : {y : E | 2 < dist y x ∧ dist y x < 3} = ball x 3 ∩ (closedBall x 2)ᶜ := by
    ext y
    constructor
    · rintro ⟨h1, h2⟩
      exact ⟨mem_ball.2 h2, fun h => absurd (mem_closedBall.1 h) (not_le.2 h1)⟩
    · rintro ⟨h1, h2⟩
      exact ⟨not_le.1 fun h => h2 (mem_closedBall.2 h), mem_ball.1 h1⟩
  rw [h]
  exact isOpen_inter_ball (ej4b x 3) (isClosed_iff_isOpen_compl_ball.1 (ej4d x 2))

end Guias.Guia3.Ej04
