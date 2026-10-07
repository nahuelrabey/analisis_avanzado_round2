/-
Análisis Avanzado (FCEN-UBA) · Práctica 2 · Ejercicio 14
Enunciado en `apuntes-typst/guias/p2.typ`; resolución en
`apuntes-typst/guias-agente/guia_2_resuelta_agente.typ` (Ejercicio 14).

  (a) `#(𝒫(ℕ) × 𝒫(ℕ)) = c`: `𝒫(ℕ) × 𝒫(ℕ) ∼ {0,1}^ℕ × {0,1}^ℕ ∼ {0,1}^ℕ ∼ 𝒫(ℕ)` (intercalando
      pares e impares) y `#𝒫(ℕ) = c` (Ej. 10 (b), reprobado acá).
  (b) `#([0,1) × [0,1)) = c`: `[0,1) ∼ ℝ` (Obs. 3.21) y `ℝ × ℝ ∼ ℝ`, con
      `ℝ × ℝ ↪ 𝒫(ℚ) × 𝒫(ℚ) ∼ 𝒫(ℕ) × 𝒫(ℕ) ∼ 𝒫(ℕ) ↪ ℝ` para `≤`.
  (c) `#ℝ^k = c` para `k ≥ 1`, por inducción con `ℝ^(k+1) ∼ ℝ × ℝ^k`.

`𝒫(A)` es `Set A`, `{0,1}` es `Bool`, `ℝ^k` es `Fin k → ℝ`. Los auxiliares (`setEquivBool`, cortes,
serie) se repiten en `Ej13.lean` y `Ej15.lean` porque los archivos son independientes.
-/
import Mathlib
import Comun.Cardinales

open Comun

namespace Guias.Guia2.Ej14

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

/-- `#𝒫(ℕ) = c` (es el Ej. 10 (b); reprobado acá con CSB). -/
theorem cardC_set_nat : CardC (Set ℕ) := teorema_CSB cardLe_set_nat_real cardLe_real_set_nat

/-! ### Intercalar: `{0,1}^ℕ × {0,1}^ℕ ∼ {0,1}^ℕ` (pares / impares) -/

/-- `(a, b) ↦ c` con `c_{2n} = a_n`, `c_{2n+1} = b_n`. -/
def intercalar : (ℕ → Bool) × (ℕ → Bool) ≃ (ℕ → Bool) where
  toFun p := fun m => if m % 2 = 0 then p.1 (m / 2) else p.2 (m / 2)
  invFun c := (fun n => c (2 * n), fun n => c (2 * n + 1))
  left_inv p := by
    refine Prod.ext (funext fun n => ?_) (funext fun n => ?_)
    · have h1 : 2 * n % 2 = 0 := by omega
      have h2 : 2 * n / 2 = n := by omega
      simp [h1, h2]
    · have h1 : (2 * n + 1) % 2 = 1 := by omega
      have h2 : (2 * n + 1) / 2 = n := by omega
      simp [h1, h2]
  right_inv c := by
    funext m
    simp only
    split_ifs with h
    · congr 1; omega
    · congr 1; omega

/-- `𝒫(ℕ) × 𝒫(ℕ) ∼ 𝒫(ℕ)`. -/
noncomputable def setProdEquiv : Set ℕ × Set ℕ ≃ Set ℕ :=
  ((setEquivBool ℕ).prodCongr (setEquivBool ℕ)).trans (intercalar.trans (setEquivBool ℕ).symm)

/-! ### `ℝ × ℝ ∼ ℝ` y `ℝ^k ∼ ℝ` -/

/-- `#(ℝ × ℝ) ≤ #ℝ`: `ℝ × ℝ ↪ 𝒫(ℚ) × 𝒫(ℚ) ∼ 𝒫(ℕ) × 𝒫(ℕ) ∼ 𝒫(ℕ) ↪ ℝ`. -/
theorem cardLe_real_prod_real : CardLe (ℝ × ℝ) ℝ :=
  ⟨(corteEmb.prodMap corteEmb).trans
    (((setRatEquivSetNat.prodCongr setRatEquivSetNat).trans setProdEquiv).toEmbedding.trans
      ((setEquivBool ℕ).toEmbedding.trans serieEmb))⟩

/-- `#ℝ ≤ #(ℝ × ℝ)`: `x ↦ (x, 0)`. -/
theorem cardLe_real_real_prod : CardLe ℝ (ℝ × ℝ) :=
  ⟨⟨fun x => (x, 0), fun _ _ h => (Prod.mk.inj h).1⟩⟩

/-- `#(ℝ × ℝ) = c`. -/
theorem cardC_real_prod : CardC (ℝ × ℝ) := teorema_CSB cardLe_real_prod_real cardLe_real_real_prod

/-- `#ℝ^(k+1) = c` por inducción en `k`, con `ℝ^(k+2) ∼ ℝ × ℝ^(k+1) ∼ ℝ × ℝ ∼ ℝ`. -/
theorem cardC_pi : ∀ k : ℕ, CardC (Fin (k + 1) → ℝ)
  | 0 => ⟨Equiv.funUnique (Fin 1) ℝ⟩
  | k + 1 => by
    obtain ⟨e⟩ := cardC_pi k
    obtain ⟨f⟩ := cardC_real_prod
    exact ⟨(Fin.consEquiv fun _ : Fin (k + 2) => ℝ).symm.trans (((Equiv.refl ℝ).prodCongr e).trans f)⟩

/-! ### Los tres ítems -/

/-- **Ej. 14 (a).** `#(𝒫(ℕ) × 𝒫(ℕ)) = c`. -/
theorem ej14a : CardC (Set ℕ × Set ℕ) := coordinables_trans ⟨setProdEquiv⟩ cardC_set_nat

/-- **Ej. 14 (b).** `#([0,1) × [0,1)) = c`. -/
theorem ej14b : CardC (Set.Ico (0 : ℝ) 1 × Set.Ico (0 : ℝ) 1) := by
  obtain ⟨e⟩ := cardC_Ico (zero_lt_one' ℝ)
  exact coordinables_trans ⟨e.prodCongr e⟩ cardC_real_prod

/-- **Ej. 14 (c).** `#ℝ^k = c` para todo `k ≥ 1`. -/
theorem ej14c (k : ℕ) (hk : 1 ≤ k) : CardC (Fin k → ℝ) := by
  obtain ⟨j, rfl⟩ := Nat.exists_eq_add_of_le' hk
  exact cardC_pi j

end Guias.Guia2.Ej14
