/-
Análisis Avanzado (FCEN-UBA) · Práctica 2 · Ejercicio 13
Enunciado en `apuntes-typst/guias/p2.typ`; resolución en
`apuntes-typst/guias-agente/guia_2_resuelta_agente.typ` (Ejercicio 13).

  `Ω = {B ⊆ ℕ : #B = #(ℕ \ B) = ℵ₀}` tiene cardinal `c`.

  `≤`: `Ω ⊆ 𝒫(ℕ)` y `#𝒫(ℕ) = c` (Ej. 10 (b)); acá se reprueba `𝒫(ℕ) ∼ {0,1}^ℕ ↪ ℝ` con la serie
       `a ↦ Σ a_n / 3^(n+1)`.
  `≥`: `ℝ ↪ 𝒫(ℚ)` por cortes (densidad de `ℚ`), `𝒫(ℚ) ∼ 𝒫(ℕ) ∼ {0,1}^ℕ`, y `{0,1}^ℕ ↪ Ω` vía
       `a ↦ {2n : a_n = 1} ∪ {2n+1 : a_n = 0}`.
  Se cierra con Cantor–Schröder–Bernstein (`teorema_CSB`).

Los auxiliares (`setEquivBool`, cortes `corteEmb`, `setRatEquivSetNat`, serie `serieEmb`,
`cardLe_set_nat_real`) se importan de `Comun.Cardinales.Continuo`, y "subconjunto infinito de `ℕ`
es numerable" de `Comun.Cardinales` (`numerable_of_infinito_subset_nat`). Quedan locales `Omega`,
`Phi` y sus lemas.
-/
import Mathlib
import Comun.Cardinales
import Comun.Cardinales.Continuo

open Comun

namespace Guias.Guia2.Ej13

/-! ### El conjunto `Ω` -/

/-- `Ω = {B ⊆ ℕ : B y ℕ \ B numerables}`. -/
def Omega : Set (Set ℕ) := {B | Numerable B ∧ Numerable ↥(Bᶜ)}

/-! ### `≤`: `Ω ⊆ 𝒫(ℕ)` -/

/-- `#Ω ≤ #ℝ`: la inclusión `Ω ↪ 𝒫(ℕ)` seguida de `𝒫(ℕ) ∼ {0,1}^ℕ ↪ ℝ`
(`Comun.cardLe_set_nat_real`). -/
theorem cardLe_Omega_real : CardLe Omega ℝ :=
  cardLe_trans ⟨Function.Embedding.subtype _⟩ cardLe_set_nat_real

/-! ### `≥`: `{0,1}^ℕ ↪ Ω` -/

/-- `Φ(a) = {2n : a_n = 1} ∪ {2n+1 : a_n = 0}`, escrito como
`{m : a_{m/2} = 1 ↔ m es par}`. -/
def Phi (a : ℕ → Bool) : Set ℕ := {m | a (m / 2) = true ↔ m % 2 = 0}

theorem mem_Phi_even (a : ℕ → Bool) (n : ℕ) : 2 * n ∈ Phi a ↔ a n = true := by
  have h1 : 2 * n % 2 = 0 := by omega
  have h2 : 2 * n / 2 = n := by omega
  simp [Phi, h1, h2]

theorem mem_Phi_odd (a : ℕ → Bool) (n : ℕ) : 2 * n + 1 ∈ Phi a ↔ a n = false := by
  have h1 : (2 * n + 1) % 2 = 1 := by omega
  have h2 : (2 * n + 1) / 2 = n := by omega
  simp [Phi, h1, h2]

/-- `Φ(a)` es infinito: contiene, para cada `n`, a `2n` o a `2n+1`. -/
theorem infinito_Phi (a : ℕ → Bool) : Infinito (Phi a) := by
  refine infinito_of_cardLe_nat
    ⟨⟨fun n : ℕ => (⟨if a n then 2 * n else 2 * n + 1, ?_⟩ : Phi a), ?_⟩⟩
  · cases h : a n
    · simpa [h] using (mem_Phi_odd a n).2 h
    · simpa [h] using (mem_Phi_even a n).2 h
  · intro n m hnm
    have h := congrArg Subtype.val hnm
    simp only at h
    split_ifs at h <;> omega

/-- `ℕ \ Φ(a)` es infinito: contiene, para cada `n`, al otro de `2n`, `2n+1`. -/
theorem infinito_compl_Phi (a : ℕ → Bool) : Infinito ↥((Phi a)ᶜ) := by
  refine infinito_of_cardLe_nat
    ⟨⟨fun n : ℕ => (⟨if a n then 2 * n + 1 else 2 * n, ?_⟩ : ↥((Phi a)ᶜ)), ?_⟩⟩
  · rw [Set.mem_compl_iff]
    cases h : a n
    · simp only [Bool.false_eq_true, ite_false]
      rw [mem_Phi_even]; simp [h]
    · simp only [ite_true]
      rw [mem_Phi_odd]; simp [h]
  · intro n m hnm
    have h := congrArg Subtype.val hnm
    simp only at h
    split_ifs at h <;> omega

/-- `Φ(a) ∈ Ω`. -/
theorem Phi_mem (a : ℕ → Bool) : Phi a ∈ Omega :=
  ⟨numerable_of_infinito_subset_nat _ (infinito_Phi a),
    numerable_of_infinito_subset_nat _ (infinito_compl_Phi a)⟩

/-- `Φ` es inyectiva: `a_n` se recupera como `[2n ∈ Φ(a)]`. -/
theorem Phi_injective : Function.Injective Phi := by
  intro a b hab
  funext n
  rw [Bool.eq_iff_iff, ← mem_Phi_even a n, ← mem_Phi_even b n, hab]

/-- `{0,1}^ℕ ↪ Ω`. -/
def PhiEmb : (ℕ → Bool) ↪ Omega :=
  ⟨fun a => ⟨Phi a, Phi_mem a⟩, fun _ _ h => Phi_injective (congrArg Subtype.val h)⟩

/-- `#ℝ ≤ #Ω`: `ℝ ↪ 𝒫(ℚ) ∼ 𝒫(ℕ) ∼ {0,1}^ℕ ↪ Ω`. -/
theorem cardLe_real_Omega : CardLe ℝ Omega :=
  ⟨corteEmb.trans ((setRatEquivSetNat.trans (setEquivBool ℕ)).toEmbedding.trans PhiEmb)⟩

/-- **Ej. 13.** `#{B ⊆ ℕ : #B = #(ℕ \ B) = ℵ₀} = c` (Cantor–Schröder–Bernstein). -/
theorem ej13 : CardC Omega := teorema_CSB cardLe_Omega_real cardLe_real_Omega

end Guias.Guia2.Ej13
