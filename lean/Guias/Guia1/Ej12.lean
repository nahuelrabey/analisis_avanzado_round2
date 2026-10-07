/-
Análisis Avanzado (FCEN-UBA) · Práctica 1 · Ejercicio 12
Enunciado en `apuntes-typst/guias/p1.typ`; resolución en
`apuntes-typst/guias-agente/guia_1_resuelta_agente.typ` (Ejercicio 12).

`(x_n)` decreciente (`Decreciente`: `x_(n+1) ≤ x_n` para todo `n`).
(a) Si está acotada inferiormente, converge al ínfimo de `{x_n}`: es el espejo de la Proposición 8
    hecho con ínfimos (Teorema 2 para que exista `i`, Proposición 5 para encontrar `x_(n₀) < i + ε`,
    y `i ≤ x_n ≤ x_(n₀)` para `n ≥ n₀`). No se usa `monotona_creciente_converge` ni
    `tendsto_atTop_ciInf`.
(b) Si no está acotada inferiormente, `x_n → -∞`: dado `M > 0`, `-M` no es cota inferior, hay
    `x_(n₀) < -M`, y `x_n ≤ x_(n₀) < -M` para `n ≥ n₀`.
El hecho "`m ≤ n ⇒ x_n ≤ x_m`" (inducción en `n`) es el sublema `decreciente_le`.
-/
import Mathlib
import Guias.Guia1.Defs

namespace Guias.Guia1.Ej12

open Guias.Guia1

/-- Sublema: si `(x_n)` es decreciente y `m ≤ n`, entonces `x_n ≤ x_m` (inducción en `n`
desde `m`). -/
theorem decreciente_le {x : ℕ → ℝ} (hd : Decreciente x) {m n : ℕ} (h : m ≤ n) : x n ≤ x m := by
  induction h with
  | refl => exact le_rfl
  | step _ ih => exact (hd _).trans ih

/-- **Ej. 12 (a).** Si `(x_n)` es decreciente y acotada inferiormente, existe
`i = ínf {x_n : n ∈ ℕ}` y `x_n → i`. Dado `ε > 0`, la Proposición 5 da `x_(n₀) < i + ε`, y para
`n ≥ n₀` es `i ≤ x_n ≤ x_(n₀) < i + ε`. -/
theorem ej12a {x : ℕ → ℝ} (hd : Decreciente x) (hb : AcotadoInf (Set.range x)) :
    ∃ i, EsInf (Set.range x) i ∧ Converge x i := by
  -- Teorema 2: existe el ínfimo
  obtain ⟨i, hi⟩ := completitud_inf (Set.range_nonempty x) hb
  refine ⟨i, hi, fun ε hε => ?_⟩
  -- Proposición 5: hay un término `x_(n₀) < i + ε`
  obtain ⟨_, ⟨n₀, rfl⟩, hlt⟩ := (equiv_inf.1 hi).2 ε hε
  refine ⟨n₀, fun n hn => ?_⟩
  have h₁ : i ≤ x n := hi.1 (x n) ⟨n, rfl⟩
  have h₂ : x n ≤ x n₀ := decreciente_le hd hn
  rw [abs_lt]
  constructor <;> linarith

/-- **Ej. 12 (b).** Si `(x_n)` es decreciente y no está acotada inferiormente, `x_n → -∞`.
Dado `M > 0`, `-M` no es cota inferior: hay `x_(n₀) < -M`, y `x_n ≤ x_(n₀) < -M` para `n ≥ n₀`. -/
theorem ej12b {x : ℕ → ℝ} (hd : Decreciente x) (hb : ¬ AcotadoInf (Set.range x)) :
    DivergeMenosInf x := by
  intro M _
  have hM : ¬ CotaInf (Set.range x) (-M) := fun h => hb ⟨-M, h⟩
  unfold CotaInf at hM
  push Not at hM
  obtain ⟨_, ⟨n₀, rfl⟩, hlt⟩ := hM
  exact ⟨n₀, fun n hn => (decreciente_le hd hn).trans_lt hlt⟩

end Guias.Guia1.Ej12
