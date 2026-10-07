/-
Librería común `Comun`: definiciones del curso y resultados de `apuntes.typ` compartidos por las
guías (`Guias/`), los parciales (`Parciales/`) y los ejemplos (`Ejemplos/`). Ver
`apuntes-agente/lean-lemas-compartidos-y-organizacion.md` para el diseño.

`Comun.Metricas.Discreta`: la métrica discreta `δ(x, y) = 0` si `x = y`, `1` si no (Ejemplo de la
Definición 4.1). `esMetrica_delta` es el **Ej. 1 (f) de la Práctica 3** (`δ` es una métrica);
`bola_delta_le` y `bola_delta_gt` son las bolas del dibujo (f). `Disc X` es `X` con la métrica
discreta como `MetricSpace` de Mathlib (vía `EsMetrica.toMetricSpace`), con `Disc.dist_eq`,
`Disc.ball_one` y `Disc.closedBall_one` (Práctica 3, Ej. 4 (f)); los parciales usan `Disc ℝ`.
-/
import Mathlib
import Comun.Metricas

open Metric Set

namespace Comun

/-! ## `δ` como función y como `EsMetrica` -/

/-- `δ(x, y) = 0` si `x = y`, `1` si `x ≠ y`. -/
def δ {E : Type*} [DecidableEq E] (x y : E) : ℝ := if x = y then 0 else 1

/-- **Práctica 3, Ej. 1 (f).** `δ` es una métrica en `E` (para todo `E`; si es no vacío es un
espacio métrico no trivial, y si es vacío no hay nada que chequear). La demostración sigue el
texto de `guias-agente/guia_3_resuelta_agente.typ`: la triangular se chequea por casos. -/
theorem esMetrica_delta (E : Type*) [DecidableEq E] : EsMetrica (δ (E := E)) where
  nonneg x y := by unfold δ; split_ifs <;> norm_num
  eq_zero_iff x y := by
    unfold δ
    by_cases h : x = y <;> simp [h]
  symm x y := by
    unfold δ
    by_cases h : x = y
    · simp [h]
    · simp [h, Ne.symm h]
  triangle x y z := by
    unfold δ
    by_cases hxz : x = z
    · subst hxz
      have h0 : (if x = x then (0 : ℝ) else 1) = 0 := by simp
      rw [h0]
      split_ifs <;> norm_num
    · -- x ≠ z: no pueden valer a la vez x = y e y = z
      have h : ¬ (x = y ∧ y = z) := fun ⟨h1, h2⟩ => hxz (h1.trans h2)
      by_cases hxy : x = y
      · have hyz : ¬ y = z := fun h2 => h ⟨hxy, h2⟩
        simp [hxy, hyz]
      · by_cases hyz : y = z
        · simp [hxz, hyz]
        · simp [hxz, hxy, hyz]

/-- Bola discreta de radio `0 < r ≤ 1`: `B(x, r) = {x}`. -/
theorem bola_delta_le {E : Type*} [DecidableEq E] (x : E) {r : ℝ} (hr0 : 0 < r) (hr : r ≤ 1) :
    bola δ x r = {x} := by
  ext y
  simp only [bola, δ, Set.mem_ofPred_eq, Set.mem_singleton_iff]
  by_cases h : x = y
  · simp [h, hr0]
  · simp [h, Ne.symm h, not_lt.2 hr]

/-- Bola discreta de radio `r > 1`: `B(x, r) = E`. -/
theorem bola_delta_gt {E : Type*} [DecidableEq E] (x : E) {r : ℝ} (hr : 1 < r) :
    bola δ x r = Set.univ := by
  ext y
  simp only [bola, δ, Set.mem_ofPred_eq, Set.mem_univ, iff_true]
  split_ifs <;> linarith

/-! ## `Disc X`: el espacio métrico discreto de Mathlib -/

/-- Un conjunto `X` con la métrica discreta `δ(x, y) = 0` si `x = y`, `1` si no. -/
def Disc (X : Type*) : Type _ := X

-- Sólo la instancia y los dos cálculos de bolas necesitan decidir `x = y`.
open scoped Classical in
noncomputable instance {X : Type*} : MetricSpace (Disc X) :=
  show MetricSpace (Con X δ) from (esMetrica_delta X).toMetricSpace

open scoped Classical in
theorem Disc.dist_eq {X : Type*} (x y : Disc X) : dist x y = if x = y then 0 else 1 := rfl

open scoped Classical in
/-- En la métrica discreta, `B(x, 1) = {x}`. -/
theorem Disc.ball_one {X : Type*} (x : Disc X) : ball x 1 = {x} := by
  ext z
  rw [mem_ball, Disc.dist_eq, mem_singleton_iff]
  by_cases h : z = x
  · simp [h]
  · simp [h]

open scoped Classical in
/-- En la métrica discreta, `B̄(x, 1)` es todo el espacio. -/
theorem Disc.closedBall_one {X : Type*} (x : Disc X) : closedBall x 1 = univ := by
  ext z
  rw [mem_closedBall, Disc.dist_eq]
  simp only [mem_univ, iff_true]
  split_ifs <;> norm_num

end Comun
