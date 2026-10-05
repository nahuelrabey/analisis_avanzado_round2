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

Los archivos de la Práctica son independientes: los auxiliares (`setEquivBool`, cortes, serie)
se repiten en `Ej14.lean` y `Ej15.lean`.
-/
import Mathlib
import Guias.Guia2.Defs

namespace Guias.Guia2.Ej13

/-! ### 𝒫(X) ∼ {0,1}^X (es el Ej. 8 (a); reprobado acá) -/

open Classical in
/-- `𝒫(X) ∼ {0,1}^X`: a cada subconjunto su función característica. -/
noncomputable def setEquivBool (X : Type*) : Set X ≃ (X → Bool) where
  toFun s := fun x => decide (x ∈ s)
  invFun f := {x | f x = true}
  left_inv s := by ext x; simp
  right_inv f := by funext x; simp

/-! ### Cortes: `ℝ ↪ 𝒫(ℚ)`, inyectiva por densidad de `ℚ` (Prop. 2) -/

/-- El corte de `x`: los racionales menores que `x`. -/
def corte (x : ℝ) : Set ℚ := {q | (q : ℝ) < x}

theorem corte_injective : Function.Injective corte := by
  intro x y hxy
  by_contra hne
  rcases lt_or_gt_of_ne hne with h | h
  · obtain ⟨q, hxq, hqy⟩ := exists_rat_btwn h
    have hq : q ∈ corte y := hqy
    rw [← hxy] at hq
    exact absurd hq (not_lt.2 hxq.le)
  · obtain ⟨q, hyq, hqx⟩ := exists_rat_btwn h
    have hq : q ∈ corte x := hqx
    rw [hxy] at hq
    exact absurd hq (not_lt.2 hyq.le)

/-- `ℝ ↪ 𝒫(ℚ)`. -/
def corteEmb : ℝ ↪ Set ℚ := ⟨corte, corte_injective⟩

/-- `𝒫(ℚ) ∼ 𝒫(ℕ)` vía `𝒫(ℚ) ∼ {0,1}^ℚ ∼ {0,1}^ℕ ∼ 𝒫(ℕ)` (Ej. 9 (c) + numerabilidad de `ℚ`). -/
noncomputable def setRatEquivSetNat : Set ℚ ≃ Set ℕ :=
  (setEquivBool ℚ).trans
    (((Classical.choice numerable_rat).symm.arrowCongr (Equiv.refl Bool)).trans (setEquivBool ℕ).symm)

/-- `#ℝ ≤ #𝒫(ℕ)`. -/
theorem cardLe_real_set_nat : CardLe ℝ (Set ℕ) :=
  ⟨corteEmb.trans setRatEquivSetNat.toEmbedding⟩

/-! ### Series: `{0,1}^ℕ ↪ ℝ`, `a ↦ Σ a_n / 3^(n+1)` -/

/-- El término `n`-ésimo: `a_n / 3^(n+1)`. -/
noncomputable def term (a : ℕ → Bool) (n : ℕ) : ℝ := if a n then (1 / 3 : ℝ) ^ (n + 1) else 0

theorem term_nonneg (a : ℕ → Bool) (n : ℕ) : 0 ≤ term a n := by
  unfold term; split_ifs <;> positivity

theorem term_le (a : ℕ → Bool) (n : ℕ) : term a n ≤ (1 / 3 : ℝ) ^ (n + 1) := by
  unfold term; split_ifs <;> [exact le_refl _; positivity]

theorem summable_geom_succ : Summable (fun n : ℕ => (1 / 3 : ℝ) ^ (n + 1)) :=
  (summable_nat_add_iff 1).2 (summable_geometric_of_lt_one (by norm_num) (by norm_num))

theorem summable_term (a : ℕ → Bool) : Summable (term a) :=
  Summable.of_nonneg_of_le (term_nonneg a) (term_le a) summable_geom_succ

/-- La cola desde `N` vale a lo sumo `(1/3)^N / 2`. -/
theorem tsum_tail_le (a : ℕ → Bool) (N : ℕ) :
    ∑' n, term a (n + N) ≤ (1 / 3 : ℝ) ^ N / 2 := by
  have hs : Summable (fun n : ℕ => (1 / 3 : ℝ) ^ (N + 1) * (1 / 3) ^ n) :=
    (summable_geometric_of_lt_one (by norm_num) (by norm_num)).mul_left _
  calc ∑' n, term a (n + N) ≤ ∑' n : ℕ, (1 / 3 : ℝ) ^ (N + 1) * (1 / 3) ^ n := by
        refine Summable.tsum_le_tsum ?_ ((summable_nat_add_iff N).2 (summable_term a)) hs
        intro n
        calc term a (n + N) ≤ (1 / 3 : ℝ) ^ (n + N + 1) := term_le a _
          _ = (1 / 3 : ℝ) ^ (N + 1) * (1 / 3) ^ n := by ring
    _ = (1 / 3 : ℝ) ^ (N + 1) * (1 - 1 / 3)⁻¹ := by
        rw [tsum_mul_left, tsum_geometric_of_lt_one (by norm_num) (by norm_num)]
    _ = (1 / 3 : ℝ) ^ N / 2 := by ring

/-- La suma de la serie. -/
noncomputable def serie (a : ℕ → Bool) : ℝ := ∑' n, term a n

/-- Descomposición `serie a = (parcial hasta N) + a_N/3^(N+1) + cola`. -/
theorem serie_split (a : ℕ → Bool) (N : ℕ) :
    serie a = ∑ i ∈ Finset.range N, term a i + (term a N + ∑' n, term a (n + (N + 1))) := by
  have h1 := (summable_term a).sum_add_tsum_nat_add N
  have h2 := ((summable_nat_add_iff N).2 (summable_term a)).tsum_eq_zero_add
  have h3 : (fun n => term a (n + 1 + N)) = fun n => term a (n + (N + 1)) := by
    funext n; rw [add_assoc, add_comm 1 N]
  unfold serie
  rw [← h1, h2, zero_add, h3]

/-- Si `a` y `b` coinciden antes de `N`, `a_N = 1` y `b_N = 0`, entonces `serie b < serie a`. -/
theorem serie_lt {a b : ℕ → Bool} {N : ℕ} (hN : ∀ n < N, a n = b n)
    (ha : a N = true) (hb : b N = false) : serie b < serie a := by
  rw [serie_split a N, serie_split b N]
  have hsum : ∑ i ∈ Finset.range N, term a i = ∑ i ∈ Finset.range N, term b i :=
    Finset.sum_congr rfl (fun i hi => by
      rw [Finset.mem_range] at hi; unfold term; rw [hN i hi])
  have hta : term a N = (1 / 3 : ℝ) ^ (N + 1) := by simp [term, ha]
  have htb : term b N = 0 := by simp [term, hb]
  have h1 : 0 ≤ ∑' n, term a (n + (N + 1)) := tsum_nonneg (fun n => term_nonneg a _)
  have h2 := tsum_tail_le b (N + 1)
  have h3 : (0 : ℝ) < (1 / 3 : ℝ) ^ (N + 1) := by positivity
  rw [hsum, hta, htb]
  linarith

theorem serie_injective : Function.Injective serie := by
  intro a b hab
  by_contra hne
  have hex : ∃ n, a n ≠ b n := by
    by_contra h
    exact hne (funext fun n => by_contra fun hn => h ⟨n, hn⟩)
  have hN : a (Nat.find hex) ≠ b (Nat.find hex) := Nat.find_spec hex
  have hlt : ∀ n < Nat.find hex, a n = b n := fun n hn =>
    by_contra fun h => Nat.find_min hex hn h
  cases ha : a (Nat.find hex) <;> cases hb : b (Nat.find hex)
  · exact hN (ha.trans hb.symm)
  · exact absurd hab (ne_of_lt (serie_lt (fun n hn => (hlt n hn).symm) hb ha))
  · exact absurd hab (ne_of_gt (serie_lt hlt ha hb))
  · exact hN (ha.trans hb.symm)

/-- `{0,1}^ℕ ↪ ℝ`. -/
noncomputable def serieEmb : (ℕ → Bool) ↪ ℝ := ⟨serie, serie_injective⟩

/-- `#𝒫(ℕ) ≤ #ℝ`. -/
theorem cardLe_set_nat_real : CardLe (Set ℕ) ℝ :=
  ⟨(setEquivBool ℕ).toEmbedding.trans serieEmb⟩

/-! ### El conjunto `Ω` -/

/-- `Ω = {B ⊆ ℕ : B y ℕ \ B numerables}`. -/
def Omega : Set (Set ℕ) := {B | Numerable B ∧ Numerable ↥(Bᶜ)}

/-- Un subconjunto infinito de `ℕ` es numerable (Prop. 3.13 + Prop. 3.14). -/
theorem numerable_of_infinito (B : Set ℕ) (h : Infinito B) : Numerable B :=
  numerable_iff_contable_infinito.2
    ⟨contable_of_cardLe_numerable numerable_nat ⟨Function.Embedding.subtype _⟩, h⟩

/-! ### `≤`: `Ω ⊆ 𝒫(ℕ)` -/

/-- `#Ω ≤ #ℝ`: la inclusión `Ω ↪ 𝒫(ℕ)` seguida de `𝒫(ℕ) ∼ {0,1}^ℕ ↪ ℝ`. -/
theorem cardLe_Omega_real : CardLe Omega ℝ :=
  ⟨(Function.Embedding.subtype _).trans ((setEquivBool ℕ).toEmbedding.trans serieEmb)⟩

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
  rw [infinito_iff_infinite]
  refine Infinite.of_injective (fun n : ℕ => (⟨if a n then 2 * n else 2 * n + 1, ?_⟩ : Phi a)) ?_
  · cases h : a n
    · simpa [h] using (mem_Phi_odd a n).2 h
    · simpa [h] using (mem_Phi_even a n).2 h
  · intro n m hnm
    have h := congrArg Subtype.val hnm
    simp only at h
    split_ifs at h <;> omega

/-- `ℕ \ Φ(a)` es infinito: contiene, para cada `n`, al otro de `2n`, `2n+1`. -/
theorem infinito_compl_Phi (a : ℕ → Bool) : Infinito ↥((Phi a)ᶜ) := by
  rw [infinito_iff_infinite]
  refine Infinite.of_injective
    (fun n : ℕ => (⟨if a n then 2 * n + 1 else 2 * n, ?_⟩ : ↥((Phi a)ᶜ))) ?_
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
  ⟨numerable_of_infinito _ (infinito_Phi a), numerable_of_infinito _ (infinito_compl_Phi a)⟩

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
