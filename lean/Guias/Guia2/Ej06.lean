/-
Análisis Avanzado (FCEN-UBA) · Práctica 2 · Ejercicio 6
Enunciado en `apuntes-typst/guias/p2.typ`; resolución en
`apuntes-typst/guias-agente/guia_2_resuelta_agente.typ` (Ejercicio 6).

  (a) La unión contable de conjuntos contables es contable. Argumento: cada `A n` se inyecta en
      `ℕ` (`f n`, elegidas simultáneamente: axioma de elección); a cada `x` de la unión se le asigna
      el menor índice `n(x)` con `x ∈ A n(x)` (es el único `n` con `x ∈ B n`, para la
      disjuntización `B` del Ej. 5) y el par `(n(x), f n(x) x) ∈ ℕ × ℕ`; eso es inyectivo, y
      `ℕ × ℕ ↪ ℕ` vía `(n, m) ↦ 2^n 3^m`. Se concluye con la Proposición 3.13.
      NO se usa `Set.countable_iUnion` ni ninguna instancia `Countable` de Mathlib.
      La prueba vive en `Comun.Cardinales.Numerables` (`contable_iUnion`, con `idx`,
      `cardLe_iUnion_prod`, `cardLe_iUnion_nat_prod` y `pairEmb`); acá se la re-enuncia.
  (b) `A` finito y no vacío, `S = ⋃_{m ≥ 1} A^m`: `#S = ℵ₀`. Acá `A^m` es `Fin m → A` y `S` es el
      sigma-tipo `Σ m : ℕ, (Fin (m+1) → A)` (las tuplas de longitud `m+1`, `m ∈ ℕ` desde `0`, o sea
      las de longitud `≥ 1`, cada una recordando su longitud: la unión es disjunta porque tuplas de
      longitudes distintas son distintas). Cada `A^m` es finito (inducción, `Comun.finito_pow`),
      `S` es contable por (a) e infinito porque `m ↦ (a, …, a)` inyecta `ℕ`.
      Deducción: `#S = ℵ₀ < c = #ℝ` (`cardLt_nat_real`), formalizada como `CardLt S ℝ`.
      Quedan locales `S`, `T`, `T_equiv` y los lemas de (b).
-/
import Mathlib
import Comun.Cardinales
import Comun.Cardinales.Numerables

open Comun

namespace Guias.Guia2.Ej06

/-! ## (a) Unión contable de contables -/

section Union

variable {X : Type*} (A : ℕ → Set X)

/-- **Ej. 6 (a).** Si cada `A n` es contable, `⋃ n, A n` es contable: la unión se inyecta en
`ℕ × ℕ`, que se inyecta en `ℕ`, y se aplica la Proposición 3.13 (`Comun.contable_iUnion`). -/
theorem ej6a (h : ∀ n, Contable (A n)) : Contable ↥(⋃ n, A n) :=
  contable_iUnion A h

end Union

/-! ## (b) `S = ⋃_{m ≥ 1} A^m` con `A` finito y no vacío tiene cardinal `ℵ₀` -/

section Palabras

variable (A : Type*)

/-- `S`: las tuplas de longitud `≥ 1` con entradas en `A`, cada una con su longitud. Modela
`⋃_{m ∈ ℕ} A^m` con `ℕ = {1, 2, …}` (el índice `m : ℕ` de Lean, desde `0`, codifica `A^(m+1)`). -/
abbrev S : Type _ := Σ m : ℕ, (Fin (m + 1) → A)

/-- `T m ⊆ S`: las palabras de longitud `m + 1`, vistas como subconjunto de `S`. -/
def T (m : ℕ) : Set (S A) := {s | s.1 = m}

/-- `S = ⋃ m, T m`. -/
theorem iUnion_T : ⋃ m, T A m = Set.univ := by
  apply Set.eq_univ_of_forall
  intro s
  exact Set.mem_iUnion.2 ⟨s.1, rfl⟩

/-- `T m ∼ A^(m+1)`: una palabra de longitud `m + 1` es su tupla, y viceversa. -/
def T_equiv (m : ℕ) : ↥(T A m) ≃ (Fin (m + 1) → A) where
  toFun s := fun i => s.1.2 (Fin.cast (congrArg (· + 1) (show m = s.1.1 from s.2.symm)) i)
  invFun t := ⟨⟨m, t⟩, rfl⟩
  left_inv := by
    rintro ⟨⟨n, t⟩, hn⟩
    simp only [T, Set.mem_ofPred_eq] at hn
    subst hn
    rfl
  right_inv t := rfl

/-- Cada `T m` es contable (es finito, pues `∼ A^(m+1)`, y `A^(m+1)` es finito por
`Comun.finito_pow`). -/
theorem contable_T (hA : Finito A) (m : ℕ) : Contable ↥(T A m) := by
  obtain ⟨k, ⟨e⟩⟩ := finito_pow hA m
  exact Or.inl ⟨k, ⟨(T_equiv A m).trans e⟩⟩

/-- `S` es contable: es `⋃ m, T m`, unión numerable de finitos, por (a). -/
theorem contable_S (hA : Finito A) : Contable (S A) := by
  have h := ej6a (T A) (contable_T A hA)
  have e : ↥(⋃ m, T A m) ≃ S A := (Set.equivOfEq (iUnion_T A)).trans (Equiv.Set.univ (S A))
  exact contable_of_cardLe h ⟨e.symm.toEmbedding⟩

/-- `ℕ ↪ S`: `m ↦ (a, …, a)` (longitud `m + 1`), inyectiva por la longitud. -/
theorem nat_embedding_S [Nonempty A] : Nonempty (ℕ ↪ S A) := by
  obtain ⟨a⟩ := ‹Nonempty A›
  refine ⟨⟨fun m => ⟨m, fun _ => a⟩, ?_⟩⟩
  intro m m' h
  exact congrArg Sigma.fst h

/-- `S` es infinito: contiene una copia de `ℕ` (un conjunto finito no la contiene: palomar). -/
theorem infinito_S [Nonempty A] : Infinito (S A) := infinito_of_cardLe_nat (nat_embedding_S A)

/-- **Ej. 6 (b).** Si `A` es finito y no vacío, `#S = ℵ₀`: `S` es contable (por (a)) e infinito,
luego numerable (Definición 3.6). -/
theorem ej6b [Nonempty A] (hA : Finito A) : Numerable (S A) :=
  (contable_S A hA).resolve_left (infinito_S A)

/-- **Ej. 6 (b), deducción.** Hay más números reales que palabras: `#S = ℵ₀ < c`. La inyección
es `S ∼ ℕ ↪ ℝ`; si hubiera una biyección `S ∼ ℝ`, compuesta con `ℕ ∼ S` daría `ℕ ∼ ℝ`, contra el
Teorema 3.19. -/
theorem ej6b_deduccion [Nonempty A] (hA : Finito A) : CardLt (S A) ℝ := by
  obtain ⟨e⟩ := ej6b A hA
  refine ⟨cardLe_trans (cardLe_of_coordinables ⟨e.symm⟩) cardLt_nat_real.1, ?_⟩
  intro hSR
  exact cardLt_nat_real.2 (coordinables_trans ⟨e⟩ hSR)

end Palabras

end Guias.Guia2.Ej06
