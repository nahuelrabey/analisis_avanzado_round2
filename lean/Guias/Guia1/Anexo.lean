/-
Práctica 1, Anexo (Ejercicio 7 de la edición 2025: punto fijo de una función creciente), con las
nociones del curso (`Comun`): `EsSup`, `CotaSup` (Definiciones 1 y 2).
Resolución "a mano" en `apuntes-typst/guias-agente/guia_1_resuelta_agente.typ` (Anexo).

`f : ℝ → ℝ` aplica `[a, b]` en `[a, b]` (`Set.MapsTo f (Set.Icc a b) (Set.Icc a b)`) y es
creciente en `[a, b]` (`x ≤ y ⇒ f x ≤ f y`, no estricta); `f a > a`. El conjunto es
`S = {x ∈ [a, b] | x < f x}` y `x₀ = sup S` viene dado como hipótesis `EsSup S x₀` (existe por
el Axioma de Completitud: `S ≠ ∅` porque `a ∈ S`, y `b` es cota superior; `anexo_existe` lo
registra). La prueba sigue el texto: `a ≤ x₀ ≤ b`; `f x₀` es cota superior de `S` (para `x ∈ S`,
`x < f x ≤ f x₀`), luego `x₀ ≤ f x₀`; y si fuera `x₀ < f x₀`, el punto medio `m = (x₀ + f x₀)/2`
estaría en `[a, b]` con `f m ≥ f x₀ > m`, es decir `m ∈ S` con `m > x₀ = sup S`, absurdo.
No se usa la Proposición 3 ni ninguna continuidad; tampoco `sSup`, `IsLUB` ni teoremas de punto
fijo de Mathlib.
-/
import Mathlib
import Comun.Reales
import Comun.Supremos
import Comun.Sucesiones

open Comun

namespace Guias.Guia1.Anexo

/-- El conjunto `S = {x ∈ [a, b] : f(x) > x}`. -/
def S (f : ℝ → ℝ) (a b : ℝ) : Set ℝ := {x ∈ Set.Icc a b | x < f x}

/-- `S ≠ ∅` (porque `a ∈ S`) y `b` es cota superior de `S`: por el Axioma de Completitud existe
`x₀ = sup S`. -/
theorem anexo_existe {f : ℝ → ℝ} {a b : ℝ} (hab : a ≤ b) (ha : a < f a) :
    ∃ x₀, EsSup (S f a b) x₀ :=
  axioma_completitud ⟨a, ⟨le_rfl, hab⟩, ha⟩ ⟨b, fun _ hx => hx.1.2⟩

/-- **Anexo (Ej. 7, ed. 2025).** Si `f : [a, b] → [a, b]` es creciente, `f(a) > a` y
`x₀ = sup {x ∈ [a, b] : f(x) > x}`, entonces `f(x₀) = x₀`. -/
theorem anexo {f : ℝ → ℝ} {a b : ℝ} (hab : a ≤ b)
    (hf : Set.MapsTo f (Set.Icc a b) (Set.Icc a b))
    (hmono : ∀ x ∈ Set.Icc a b, ∀ y ∈ Set.Icc a b, x ≤ y → f x ≤ f y)
    (ha : a < f a) {x₀ : ℝ} (hx₀ : EsSup (S f a b) x₀) : f x₀ = x₀ := by
  -- `a ≤ x₀ ≤ b`: `a ∈ S` y `b` es cota superior de `S`.
  have haS : a ∈ S f a b := ⟨⟨le_rfl, hab⟩, ha⟩
  have hax₀ : a ≤ x₀ := hx₀.1 a haS
  have hx₀b : x₀ ≤ b := hx₀.2 b (fun _ hx => hx.1.2)
  have hx₀I : x₀ ∈ Set.Icc a b := ⟨hax₀, hx₀b⟩
  have hfx₀I : f x₀ ∈ Set.Icc a b := hf hx₀I
  -- (1) `x₀ ≤ f x₀`: `f x₀` es cota superior de `S`.
  have h1 : x₀ ≤ f x₀ := by
    refine hx₀.2 (f x₀) ?_
    intro x hx
    have hxx₀ : x ≤ x₀ := hx₀.1 x hx
    have := hmono x hx.1 x₀ hx₀I hxx₀
    exact le_trans hx.2.le this
  -- (2) `f x₀ ≤ x₀`: si no, el punto medio `m` está en `S` y supera a `x₀ = sup S`.
  have h2 : f x₀ ≤ x₀ := by
    by_contra hlt
    have hlt' : x₀ < f x₀ := not_le.1 hlt
    set m := (x₀ + f x₀) / 2 with hm
    have hx₀m : x₀ < m := by rw [hm]; linarith
    have hmf : m < f x₀ := by rw [hm]; linarith
    have hmI : m ∈ Set.Icc a b := ⟨by linarith, by linarith [hfx₀I.2]⟩
    have hfm : f x₀ ≤ f m := hmono x₀ hx₀I m hmI hx₀m.le
    have hmS : m ∈ S f a b := ⟨hmI, lt_of_lt_of_le hmf hfm⟩
    linarith [hx₀.1 m hmS]
  exact le_antisymm h2 h1

end Guias.Guia1.Anexo
