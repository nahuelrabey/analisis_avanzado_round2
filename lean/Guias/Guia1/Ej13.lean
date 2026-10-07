/-
Análisis Avanzado (FCEN-UBA) · Práctica 1 · Ejercicio 13
Enunciado en `apuntes-typst/guias/p1.typ`; resolución en
`apuntes-typst/guias-agente/guia_1_resuelta_agente.typ` (Ejercicio 13).

Si `A` es no vacío, acotado superiormente y sin máximo (`s = sup A ∉ A`), hay una sucesión
`(a_n) ⊆ A` estrictamente creciente con `a_n → s`. Construcción recursiva: `a₀ ∈ A` con
`s - 1 < a₀` (Proposición 3 con `ε = 1`); dado `a_n ∈ A`, como `a_n < s` (porque `a_n ≤ s` y
`s ∉ A`), se toma `ε = mín(s - a_n, 1/(n+2)) > 0` y `a_(n+1) ∈ A` con `s - ε < a_(n+1) ≤ s`
(Proposición 3): entonces `a_n < a_(n+1)` y `s - 1/(n+2) < a_(n+1)`. La convergencia sale de
`s - 1/(n+1) < a_n ≤ s` y la Proposición 1 (Arquímedes 2).
En Lean la elección de cada término se hace con `choose` (`Classical.choose`) sobre el paso
`paso`, y la sucesión se define con `Nat.rec` sobre el subtipo `{a // a ∈ A}`. Los índices
empiezan en `0`: `a_n` queda a menos de `1/(n+1)` de `s`. No se usa `equiv_sup2`,
`IsLUB.exists_seq_*` ni `Filter.Tendsto`.
-/
import Mathlib
import Comun.Reales
import Comun.Supremos
import Comun.Sucesiones

namespace Guias.Guia1.Ej13

open Comun

/-- Paso de la construcción: si `s = sup A ∉ A`, para todo `a ∈ A` y todo `n` hay `b ∈ A` con
`a < b`, `s - 1/(n+1) < b` y `b ≤ s`. Se aplica la Proposición 3 con
`ε = mín(s - a, 1/(n+1)) > 0` (positivo porque `a < s`: `a ≤ s` y `s ∉ A`). -/
theorem paso {A : Set ℝ} {s : ℝ} (hs : EsSup A s) (hmax : s ∉ A) (a : ℝ) (ha : a ∈ A) (n : ℕ) :
    ∃ b ∈ A, a < b ∧ s - 1 / ((n : ℝ) + 1) < b ∧ b ≤ s := by
  have has : a < s := lt_of_le_of_ne (hs.1 a ha) (fun h => hmax (h ▸ ha))
  have hε : 0 < min (s - a) (1 / ((n : ℝ) + 1)) := lt_min (by linarith) (by positivity)
  obtain ⟨b, hbA, hb₁, hb₂⟩ := (equiv_sup.1 hs).2 _ hε
  refine ⟨b, hbA, ?_, ?_, hb₂⟩
  · linarith [min_le_left (s - a) (1 / ((n : ℝ) + 1))]
  · linarith [min_le_right (s - a) (1 / ((n : ℝ) + 1))]

/-- **Ej. 13.** Si `A ≠ ∅` está acotado superiormente, `s = sup A` y `A` no tiene máximo
(`s ∉ A`), existe `(a_n) ⊆ A` estrictamente creciente con `a_n → s`. -/
theorem ej13 {A : Set ℝ} (_hne : A.Nonempty) (_hb : AcotadoSup A) {s : ℝ} (hs : EsSup A s)
    (hmax : s ∉ A) : ∃ a : ℕ → ℝ, (∀ n, a n ∈ A) ∧ StrictMono a ∧ Converge a s := by
  -- `_hne` y `_hb` son las hipótesis del enunciado (sirven para que exista `s = sup A`, Axioma
  -- de Completitud); una vez dado `hs`, el argumento no vuelve a usarlas.
  -- la función de elección del paso recursivo
  choose f hfA hf₁ hf₂ hf₃ using paso hs hmax
  -- primer término: Proposición 3 con `ε = 1`
  obtain ⟨a₀, ha₀A, ha₀, -⟩ := (equiv_sup.1 hs).2 1 one_pos
  -- la sucesión, por recursión, como función en el subtipo `{a // a ∈ A}`
  let g : ℕ → {a : ℝ // a ∈ A} := fun n =>
    Nat.rec (motive := fun _ => {a : ℝ // a ∈ A}) ⟨a₀, ha₀A⟩
      (fun k p => ⟨f p.1 p.2 (k + 1), hfA p.1 p.2 (k + 1)⟩) n
  have hg_succ : ∀ n, (g (n + 1)).1 = f (g n).1 (g n).2 (n + 1) := fun _ => rfl
  -- (i) `a_n < a_(n+1)`
  have hmono : StrictMono (fun n => (g n).1) :=
    strictMono_nat_of_lt_succ fun n => by rw [hg_succ]; exact hf₁ _ _ _
  -- (ii) `s - 1/(n+1) < a_n` para todo `n` (inducción en `n`)
  have hcerca : ∀ n : ℕ, s - 1 / ((n : ℝ) + 1) < (g n).1 := by
    intro n
    induction n with
    | zero =>
      have h0 : (g 0).1 = a₀ := rfl
      rw [h0]; simpa using ha₀
    | succ k _ => rw [hg_succ]; exact hf₂ _ _ _
  -- (iii) `a_n ≤ s` (es cota superior)
  have hcota : ∀ n, (g n).1 ≤ s := fun n => hs.1 _ (g n).2
  refine ⟨fun n => (g n).1, fun n => (g n).2, hmono, fun ε hε => ?_⟩
  -- Arquímedes 2: `0 < 1/n₀ < ε`
  obtain ⟨n₀, hn₀pos, hn₀⟩ := arquimedes2 hε
  refine ⟨n₀, fun n hn => ?_⟩
  have hn₀' : (0 : ℝ) < n₀ := by
    by_contra h
    push Not at h
    have : (n₀ : ℝ) = 0 := le_antisymm h (Nat.cast_nonneg _)
    rw [this, div_zero] at hn₀pos
    exact lt_irrefl _ hn₀pos
  -- `1/(n+1) ≤ 1/n₀` porque `n₀ ≤ n < n + 1`
  have hle : 1 / ((n : ℝ) + 1) ≤ 1 / (n₀ : ℝ) := by
    apply one_div_le_one_div_of_le hn₀'
    have : (n₀ : ℝ) ≤ n := by exact_mod_cast hn
    linarith
  rw [abs_lt]
  constructor
  · linarith [hcerca n]
  · linarith [hcota n]

end Guias.Guia1.Ej13
