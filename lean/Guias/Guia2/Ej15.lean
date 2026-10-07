/-
Análisis Avanzado (FCEN-UBA) · Práctica 2 · Ejercicio 15
Enunciado en `apuntes-typst/guias/p2.typ`; resolución en
`apuntes-typst/guias-agente/guia_2_resuelta_agente.typ` (Ejercicio 15).

  `#ℝ[X] = c`.
  `≥`: los polinomios constantes, `ℝ ↪ ℝ[X]`.
  `≤`: `p ↦ (gr p, (coeficientes 0..gr p))` es `ℝ[X] ↪ ⋃ₙ ℝ^(n+1)` (en Lean, `Σ n, (Fin (n+1) → ℝ)`);
       cada `ℝ^(n+1)` tiene cardinal `c` (Ej. 14 (c)) y la unión numerable de conjuntos de cardinal
       `c` tiene cardinal `c` (Ej. 7 (b)). Ambos se reprueban acá: `ℝ^(n+1) ∼ ℝ` por inducción con
       `ℝ × ℝ ∼ ℝ`, y `ℕ × ℝ ↪ ℝ` vía `ℝ ∼ [0,1)` y `(n, x) ↦ n + x`.
  Se cierra con Cantor–Schröder–Bernstein.

Los auxiliares (`setEquivBool`, cortes, serie, `ℝ × ℝ ∼ ℝ`) se repiten en `Ej13.lean` y
`Ej14.lean` porque los archivos son independientes.
-/
import Mathlib
import Comun.Cardinales

open Comun

namespace Guias.Guia2.Ej15

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

/-! ### `ℕ × ℝ ↪ ℝ` (Ej. 7 (b) para la unión `⋃ ℝ^(n+1)`) -/

/-- `(n, x) ↦ n + x` en `ℕ × [0,1)` es inyectiva (parte entera). -/
def sumaEmb : ℕ × Set.Ico (0 : ℝ) 1 ↪ ℝ where
  toFun p := (p.1 : ℝ) + p.2
  inj' := by
    rintro ⟨n, x, hx⟩ ⟨m, y, hy⟩ h
    simp only at h
    have h1 : ⌊(n : ℝ) + x⌋ = n := by
      rw [Int.floor_natCast_add, Int.floor_eq_zero_iff.2 hx, add_zero]
    have h2 : ⌊(m : ℝ) + y⌋ = m := by
      rw [Int.floor_natCast_add, Int.floor_eq_zero_iff.2 hy, add_zero]
    have hnm : (n : ℤ) = m := by rw [← h1, ← h2, h]
    have hnm' : n = m := by exact_mod_cast hnm
    subst hnm'
    have hxy : x = y := by linarith
    subst hxy
    rfl

/-- `#(ℕ × ℝ) ≤ #ℝ`. -/
theorem cardLe_nat_prod_real : CardLe (ℕ × ℝ) ℝ := by
  obtain ⟨e⟩ := cardC_Ico (zero_lt_one' ℝ)
  exact ⟨((Equiv.refl ℕ).prodCongr e.symm).toEmbedding.trans sumaEmb⟩

/-! ### `ℝ[X] ↪ ⋃ₙ ℝ^(n+1)` -/

/-- `p ↦ (gr p, (p_0, …, p_{gr p}))`. -/
def coefs (p : Polynomial ℝ) : Σ n : ℕ, (Fin (n + 1) → ℝ) :=
  ⟨p.natDegree, fun i => p.coeff i⟩

/-- Igualdad heterogénea de tuplas de la misma longitud: coordenada a coordenada. -/
theorem heq_apply {n m : ℕ} (hnm : n = m) {f : Fin (n + 1) → ℝ} {g : Fin (m + 1) → ℝ}
    (h : f ≍ g) (i : ℕ) (hi : i < n + 1) (hi' : i < m + 1) : f ⟨i, hi⟩ = g ⟨i, hi'⟩ := by
  subst hnm
  rw [eq_of_heq h]

/-- `coefs` es inyectiva: mismo grado y mismos coeficientes hasta el grado dan el mismo
polinomio, porque más allá del grado todos los coeficientes son `0` (`Polynomial.ext`). -/
theorem coefs_injective : Function.Injective coefs := by
  intro p q h
  unfold coefs at h
  rw [Sigma.mk.inj_iff] at h
  obtain ⟨hdeg, hcoef⟩ := h
  apply Polynomial.ext
  intro n
  by_cases hn : n ≤ p.natDegree
  · exact heq_apply hdeg hcoef n (by omega) (by omega)
  · rw [Polynomial.coeff_eq_zero_of_natDegree_lt (by omega),
      Polynomial.coeff_eq_zero_of_natDegree_lt (by omega)]

/-- `ℝ[X] ↪ Σ n, ℝ^(n+1)`. -/
def coefsEmb : Polynomial ℝ ↪ Σ n : ℕ, (Fin (n + 1) → ℝ) := ⟨coefs, coefs_injective⟩

/-- `Σ n, ℝ^(n+1) ↪ Σ n, ℝ ∼ ℕ × ℝ`: en cada `n` se usa la biyección `ℝ^(n+1) ∼ ℝ` del Ej. 14 (c). -/
noncomputable def sigmaEmb : (Σ n : ℕ, (Fin (n + 1) → ℝ)) ↪ ℕ × ℝ :=
  (Function.Embedding.sigmaMap (Function.Embedding.refl ℕ)
    (fun n => (Classical.choice (cardC_pi n)).toEmbedding)).trans
    (Equiv.sigmaEquivProd ℕ ℝ).toEmbedding

/-- `#ℝ[X] ≤ #ℝ`. -/
theorem cardLe_poly_real : CardLe (Polynomial ℝ) ℝ := by
  obtain ⟨f⟩ := cardLe_nat_prod_real
  exact ⟨coefsEmb.trans (sigmaEmb.trans f)⟩

/-- `#ℝ ≤ #ℝ[X]`: los polinomios constantes. -/
theorem cardLe_real_poly : CardLe ℝ (Polynomial ℝ) := ⟨⟨Polynomial.C, Polynomial.C_injective⟩⟩

/-- **Ej. 15.** `#ℝ[X] = c` (Cantor–Schröder–Bernstein). -/
theorem ej15 : CardC (Polynomial ℝ) := teorema_CSB cardLe_poly_real cardLe_real_poly

end Guias.Guia2.Ej15
