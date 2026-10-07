/-
Práctica 2, Ejercicio 8 (el conjunto de partes y `{0,1}^A`).
Resolución "a mano" en `apuntes-typst/guias-agente/_partes2/ej08.typ`.

(a) `𝒫(A) ∼ {0,1}^A` por la función característica `S ↦ χ_S`, con inversa `f ↦ f⁻¹({1})`.
(b) Si `#A = n` entonces `#𝒫(A) = 2^n`: por (a) basta `{0,1}^{1..n} ∼ {1..2^n}`, que sale por
    inducción en `n` partiendo una función en `{1..n+1}` en su restricción a `{1..n}` y su valor
    en `n+1`, y usando que `X × {0,1} ∼ X ⊔ X` tiene el doble de elementos que `X`.

Convenciones: `𝒫(A)` es `Set A`, `{0,1}` es `Bool`, `{1, …, n}` es `Fin n`.
La biyección de (a) vive en `Comun.Cardinales.Continuo` (`setEquivBool`: `toFun` es la función
característica `χ_S = decide (· ∈ S)` e `invFun` es `f ↦ f⁻¹({1})`); acá `equivCaracteristica` es
un alias. La inducción de (b) queda local.
-/
import Mathlib
import Comun.Cardinales
import Comun.Cardinales.Continuo

namespace Guias.Guia2.Ej08

open Comun
/-! ## (a) La función característica -/

/-- `S ↦ χ_S` es una biyección `𝒫(A) → {0,1}^A` con inversa `f ↦ f⁻¹({1})`
(`Comun.setEquivBool`). -/
noncomputable abbrev equivCaracteristica (A : Type*) : Set A ≃ (A → Bool) := setEquivBool A

/-- **Ej. 8 (a).** `𝒫(A) ∼ {0,1}^A`. -/
theorem ej8a (A : Type*) : Coordinables (Set A) (A → Bool) := ⟨equivCaracteristica A⟩

/-! ## (b) `{0,1}^{1..n} ∼ {1..2^n}`, por inducción en `n` -/

/-- Lema 2 del texto: una función en `{1, …, n+1}` es su valor en `n+1` junto con su restricción
a `{1, …, n}`. -/
def partirUltimo (n : ℕ) : (Fin (n + 1) → Bool) ≃ Bool × (Fin n → Bool) :=
  (Fin.snocEquiv (fun _ => Bool)).symm

/-- Lema 1 del texto: si `X ∼ {1, …, m}`, entonces `{0,1} × X ∼ {1, …, m + m}`
(las funciones con último valor `0` van a `{1, …, m}`, las de último valor `1` a
`{m+1, …, 2m}`). -/
def doble {X : Type*} {m : ℕ} (g : X ≃ Fin m) : Bool × X ≃ Fin (m + m) :=
  ((Equiv.boolProdEquivSum X).trans (Equiv.sumCongr g g)).trans finSumFinEquiv

/-- `{0,1}^{1..n} ∼ {1, …, 2^n}` para todo `n` (inducción en `n`). -/
theorem funBool_equiv_fin (n : ℕ) : Nonempty ((Fin n → Bool) ≃ Fin (2 ^ n)) := by
  induction n with
  | zero =>
    refine ⟨{ toFun := fun _ => 0, invFun := fun _ => Fin.elim0, left_inv := ?_, right_inv := ?_ }⟩
    · intro f
      funext i
      exact i.elim0
    · intro i
      exact Fin.ext (by have := i.isLt; simp at this; omega)
  | succ n ih =>
    obtain ⟨g⟩ := ih
    have h : 2 ^ n + 2 ^ n = 2 ^ (n + 1) := by ring
    exact ⟨((partirUltimo n).trans (doble g)).trans (finCongr h)⟩

/-- **Ej. 8 (b).** Si `#A = n` entonces `#𝒫(A) = 2^n`: se encadenan
`𝒫(A) ∼ {0,1}^A ∼ {0,1}^{1..n} ∼ {1..2^n}`. -/
theorem ej8b {A : Type*} {n : ℕ} (h : CardEq A n) : CardEq (Set A) (2 ^ n) := by
  obtain ⟨σ⟩ := h
  obtain ⟨g⟩ := funBool_equiv_fin n
  exact ⟨((equivCaracteristica A).trans (Equiv.arrowCongr σ (Equiv.refl Bool))).trans g⟩

end Guias.Guia2.Ej08
