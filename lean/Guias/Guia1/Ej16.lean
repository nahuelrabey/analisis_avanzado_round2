/-
Práctica 1, Ejercicio 16: (a) si las subsucesiones de índices pares e impares convergen al
mismo límite, la sucesión converge; (b) si las de índices pares, impares y múltiplos de 3
convergen, la sucesión converge. Nociones del curso: `Converge` (Definición 7) y subsucesión
(`x ∘ φ` con `StrictMono φ`), de `Comun`.
Resolución "a mano" en `apuntes-typst/guias-agente/guia_1_resuelta_agente.typ` (Ejercicio 16).

Los índices empiezan en `0`: los pares son `x (2 * k)` y los impares `x (2 * k + 1)` (en el
curso, `x_(2k)` y `x_(2k-1)` con `k ≥ 1`: los mismos términos, salvo `x_0`, que no existe allí).
(a) sigue el texto: dado `ε`, se toman `n₁` para los pares y `n₂` para los impares,
`n₀ = máx (2 n₁, 2 n₂ + 1)`, y todo `n ≥ n₀` es par o impar (`Nat.even_or_odd`).
(b) usa que `(x_(6k))` es subsucesión de `(x_(2k))` y de `(x_(3k))`, y `(x_(6k+3))` lo es de
`(x_(2k+1))` y de `(x_(3k))`: por Convergencia de subsucesiones (`convergencia_subsucesiones`)
y Unicidad del límite (`unicidad_limite`) los tres límites coinciden, y se cierra con (a).
No se usa `Tendsto`.
-/
import Mathlib
import Comun.Reales
import Comun.Supremos
import Comun.Sucesiones

namespace Guias.Guia1.Ej16

open Comun

/-! ## (a) Pares e impares con el mismo límite -/

/-- **Ej. 16 (a).** Si `x (2k) → ℓ` y `x (2k+1) → ℓ`, entonces `x n → ℓ`. Dado `ε > 0`, con
`n₁` (pares) y `n₂` (impares) se toma `n₀ = máx (2 n₁, 2 n₂ + 1)`; si `n ≥ n₀` es par,
`n = 2k` con `k ≥ n₁`; si es impar, `n = 2k + 1` con `k ≥ n₂`. -/
theorem ej16a {x : ℕ → ℝ} {l : ℝ} (he : Converge (fun k => x (2 * k)) l)
    (ho : Converge (fun k => x (2 * k + 1)) l) : Converge x l := by
  intro ε hε
  obtain ⟨n₁, hn₁⟩ := he ε hε
  obtain ⟨n₂, hn₂⟩ := ho ε hε
  refine ⟨max (2 * n₁) (2 * n₂ + 1), fun n hn => ?_⟩
  have h1 : 2 * n₁ ≤ n := le_trans (le_max_left _ _) hn
  have h2 : 2 * n₂ + 1 ≤ n := le_trans (le_max_right _ _) hn
  rcases Nat.even_or_odd n with ⟨k, hk⟩ | ⟨k, hk⟩
  · -- `n = k + k = 2k`, con `k ≥ n₁`
    have hk1 : n₁ ≤ k := by omega
    have h2k : |x (2 * k) - l| < ε := hn₁ k hk1
    rw [show 2 * k = n by omega] at h2k
    exact h2k
  · -- `n = 2k + 1`, con `k ≥ n₂`
    have hk2 : n₂ ≤ k := by omega
    have h2k : |x (2 * k + 1) - l| < ε := hn₂ k hk2
    rw [← hk] at h2k
    exact h2k

/-! ## (b) Pares, impares y múltiplos de 3 -/

/-- Convergencia de subsucesiones, en la forma "si `b k = a (φ k)` con `φ` estrictamente
creciente y `a → ℓ`, entonces `b → ℓ`" (es `convergencia_subsucesiones` más la identificación
término a término de `a ∘ φ` con `b`). -/
theorem converge_of_subseq {a b : ℕ → ℝ} {l : ℝ} (ha : Converge a l) {φ : ℕ → ℕ}
    (hφ : StrictMono φ) (hb : ∀ k, b k = a (φ k)) : Converge b l := by
  have h := convergencia_subsucesiones ha hφ
  have hab : b = a ∘ φ := funext hb
  rw [hab]
  exact h

/-- `k ↦ 3k` es estrictamente creciente. -/
theorem strictMono_three_mul : StrictMono (fun k : ℕ => 3 * k) :=
  strictMono_nat_of_lt_succ fun k => by show 3 * k < 3 * (k + 1); omega

/-- `k ↦ 2k` es estrictamente creciente. -/
theorem strictMono_two_mul : StrictMono (fun k : ℕ => 2 * k) :=
  strictMono_nat_of_lt_succ fun k => by show 2 * k < 2 * (k + 1); omega

/-- `k ↦ 3k + 1` es estrictamente creciente. -/
theorem strictMono_three_mul_add_one : StrictMono (fun k : ℕ => 3 * k + 1) :=
  strictMono_nat_of_lt_succ fun k => by show 3 * k + 1 < 3 * (k + 1) + 1; omega

/-- `k ↦ 2k + 1` es estrictamente creciente. -/
theorem strictMono_two_mul_add_one : StrictMono (fun k : ℕ => 2 * k + 1) :=
  strictMono_nat_of_lt_succ fun k => by show 2 * k + 1 < 2 * (k + 1) + 1; omega

/-- **Ej. 16 (b).** Si `(x (2k))`, `(x (2k+1))` y `(x (3k))` convergen (a `ℓ₁`, `ℓ₂`, `ℓ₃`),
entonces `(x n)` converge. `(x (6k))` es subsucesión de `(x (2k))` (con `k ↦ 3k`) y de
`(x (3k))` (con `k ↦ 2k`), así que `ℓ₁ = ℓ₃`; `(x (6k+3))` es subsucesión de `(x (2k+1))` (con
`k ↦ 3k + 1`) y de `(x (3k))` (con `k ↦ 2k + 1`), así que `ℓ₂ = ℓ₃`. Se concluye con (a). -/
theorem ej16b {x : ℕ → ℝ} (h₁ : ∃ l₁, Converge (fun k => x (2 * k)) l₁)
    (h₂ : ∃ l₂, Converge (fun k => x (2 * k + 1)) l₂)
    (h₃ : ∃ l₃, Converge (fun k => x (3 * k)) l₃) : ∃ l, Converge x l := by
  obtain ⟨l₁, he⟩ := h₁
  obtain ⟨l₂, ho⟩ := h₂
  obtain ⟨l₃, ht⟩ := h₃
  -- `x (6k) → ℓ₁` (subsucesión de los pares) y `x (6k) → ℓ₃` (subsucesión de los múltiplos de 3)
  have h6a : Converge (fun k => x (6 * k)) l₁ :=
    converge_of_subseq he strictMono_three_mul fun k => by
      show x (6 * k) = x (2 * (3 * k)); congr 1; ring
  have h6b : Converge (fun k => x (6 * k)) l₃ :=
    converge_of_subseq ht strictMono_two_mul fun k => by
      show x (6 * k) = x (3 * (2 * k)); congr 1; ring
  have h13 : l₁ = l₃ := unicidad_limite h6a h6b
  -- `x (6k+3) → ℓ₂` (subsucesión de los impares) y `x (6k+3) → ℓ₃` (de los múltiplos de 3)
  have h63a : Converge (fun k => x (6 * k + 3)) l₂ :=
    converge_of_subseq ho strictMono_three_mul_add_one fun k => by
      show x (6 * k + 3) = x (2 * (3 * k + 1) + 1); congr 1; ring
  have h63b : Converge (fun k => x (6 * k + 3)) l₃ :=
    converge_of_subseq ht strictMono_two_mul_add_one fun k => by
      show x (6 * k + 3) = x (3 * (2 * k + 1)); congr 1; ring
  have h23 : l₂ = l₃ := unicidad_limite h63a h63b
  -- pares e impares convergen a `ℓ₃`: ítem (a)
  refine ⟨l₃, ej16a ?_ ?_⟩
  · rw [← h13]; exact he
  · rw [← h23]; exact ho

end Guias.Guia1.Ej16
