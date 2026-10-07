/-
Librería común `Comun`: definiciones del curso y resultados de `apuntes.typ` compartidos por las
guías (`Guias/`), los parciales (`Parciales/`) y los ejemplos (`Ejemplos/`). Ver
`apuntes-agente/lean-lemas-compartidos-y-organizacion.md` para el diseño.

`Comun.Cardinales.Continuo`: las construcciones con las que la Práctica 2 prueba que un conjunto
tiene cardinal `c = #ℝ`, probadas una sola vez (antes estaban copiadas en `Guias/Guia2/Ej07`,
`Ej08`, `Ej09`, `Ej10`, `Ej13`, `Ej14` y `Ej15`):
- `𝒫(X) ∼ {0,1}^X` por la función característica (`setEquivBool`, **Ej. 8 (a)**) y
  `A ∼ B ⇒ 𝒫(A) ∼ 𝒫(B)` (`partesCongr`, **Ej. 9 (c)**);
- los cortes `ℝ ↪ 𝒫(ℚ)` (densidad de `ℚ`) y `𝒫(ℚ) ∼ 𝒫(ℕ)`, de donde `#ℝ ≤ #𝒫(ℕ)`;
- la serie `a ↦ Σ a_n / 3^(n+1)`, inyección `{0,1}^ℕ ↪ [0,1) ⊆ ℝ` (`serie`, `serie_injective`,
  `serie_mem`), de donde `#𝒫(ℕ) ≤ #ℝ` y, por CSB, `cardC_set_nat` (**Ej. 10 (b)**);
- `ℝ × ℝ ∼ ℝ` intercalando dígitos (`intercalar`, `cardC_real_prod`), `ℝ^k ∼ ℝ` (`cardC_pi`,
  **Ej. 14 (c)**), `ℝ ⊔ ℝ ∼ ℝ` y `ℕ × ℝ ↪ ℝ` (`sumaEmb`, parte entera);
- uniones de dos o de una sucesión de conjuntos de cardinal `c` (`cardC_union`, `cardC_iUnion`,
  **Ej. 7**);
- polinomio ↦ (grado, coeficientes) sobre un semianillo cualquiera (`coefsEmb`, Ej. 15; el
  parcial 1C2024 lo usa con `ℚ`).

Regla de circularidad (ver el encabezado de `Comun.Cardinales`): acá no se usan `Cardinal.mk_real`,
`Cardinal.mk_set`, `Cardinal.mk_prod`, `Cardinal.mk_pi`, `Equiv.Set.prod`, ni ninguna instancia que
resuelva sola; las pruebas son las del texto de `guias-agente/guia_2_resuelta_agente.typ`.
-/
import Mathlib
import Comun.Cardinales
import Comun.Cardinales.Numerables

namespace Comun

/-! ## `𝒫(X) ∼ {0,1}^X` (Ej. 8 (a)) y `𝒫(A) ∼ 𝒫(B)` (Ej. 9 (c)) -/

open Classical in
/-- **Práctica 2, Ej. 8 (a).** `𝒫(X) ∼ {0,1}^X`: a cada subconjunto su función característica
`χ_S = fun x => decide (x ∈ S)`, con inversa `f ↦ f⁻¹({1}) = {x | f x = true}`. -/
noncomputable def setEquivBool (X : Type*) : Set X ≃ (X → Bool) where
  toFun s := fun x => decide (x ∈ s)
  invFun f := {x | f x = true}
  left_inv s := by ext x; simp
  right_inv f := by funext x; simp

/-- **Práctica 2, Ej. 8 (a)**, como coordinabilidad. -/
theorem coordinables_set_fun_bool (X : Type*) : Coordinables (Set X) (X → Bool) :=
  ⟨setEquivBool X⟩

/-- Si `f : A → B` es biyectiva, `S ↦ f(S)` es una biyección `𝒫(A) → 𝒫(B)` con inversa
`T ↦ f⁻¹(T)`: `f⁻¹(f(S)) = S` (`f` inyectiva) y `f(f⁻¹(T)) = T` (`f` sobreyectiva). -/
def partesCongr {A B : Type*} (f : A ≃ B) : Set A ≃ Set B where
  toFun S := f '' S
  invFun T := f ⁻¹' T
  left_inv S := Set.preimage_image_eq S f.injective
  right_inv T := Set.image_preimage_eq T f.surjective

/-- **Práctica 2, Ej. 9 (c).** `A ∼ B ⟹ 𝒫(A) ∼ 𝒫(B)`. -/
theorem coordinables_set {A B : Type*} (h : Coordinables A B) : Coordinables (Set A) (Set B) :=
  let ⟨f⟩ := h; ⟨partesCongr f⟩

/-! ## Cortes: `ℝ ↪ 𝒫(ℚ)`, inyectiva por densidad de `ℚ` (Prop. 2) -/

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

/-- `𝒫(ℚ) ∼ 𝒫(ℕ)` (Ej. 9 (c) + numerabilidad de `ℚ`). -/
noncomputable def setRatEquivSetNat : Set ℚ ≃ Set ℕ :=
  partesCongr (Classical.choice numerable_rat).symm

/-- `#ℝ ≤ #𝒫(ℕ)`. -/
theorem cardLe_real_set_nat : CardLe ℝ (Set ℕ) :=
  ⟨corteEmb.trans setRatEquivSetNat.toEmbedding⟩

/-! ## Series: `{0,1}^ℕ ↪ [0,1) ⊆ ℝ`, `a ↦ Σ a_n / 3^(n+1)` -/

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

/-- La suma de la serie, `Σ_n a_n / 3^(n+1)`. -/
noncomputable def serie (a : ℕ → Bool) : ℝ := ∑' n, term a n

/-- `0 ≤ Σ a_n / 3^(n+1) ≤ Σ 1 / 3^(n+1) = 1/2 < 1` (Ej. 10 (a)). -/
theorem serie_mem (a : ℕ → Bool) : serie a ∈ Set.Ico (0 : ℝ) 1 := by
  refine ⟨tsum_nonneg (term_nonneg a), ?_⟩
  have h := tsum_tail_le a 0
  simp only [add_zero, pow_zero] at h
  unfold serie
  linarith

/-- Descomposición `serie a = (parcial hasta N) + a_N/3^(N+1) + cola`. -/
theorem serie_split (a : ℕ → Bool) (N : ℕ) :
    serie a = ∑ i ∈ Finset.range N, term a i + (term a N + ∑' n, term a (n + (N + 1))) := by
  have h1 := (summable_term a).sum_add_tsum_nat_add N
  have h2 := ((summable_nat_add_iff N).2 (summable_term a)).tsum_eq_zero_add
  have h3 : (fun n => term a (n + 1 + N)) = fun n => term a (n + (N + 1)) := by
    funext n; rw [add_assoc, add_comm 1 N]
  unfold serie
  rw [← h1, h2, zero_add, h3]

/-- Si `a` y `b` coinciden antes de `N`, `a_N = 1` y `b_N = 0`, entonces `serie b < serie a`:
el término `1/3^(N+1)` domina a toda la cola `Σ_{n>N} 1/3^(n+1) = (1/2) · 1/3^(N+1)`. -/
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

/-- Inyectividad de la serie: en el primer índice donde `a` y `b` difieren se aplica `serie_lt`. -/
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

/-- `{0,1}^ℕ ↪ [0,1)` (la misma serie, con `serie_mem`). -/
noncomputable def serieIcoEmb : (ℕ → Bool) ↪ Set.Ico (0 : ℝ) 1 :=
  ⟨fun a => ⟨serie a, serie_mem a⟩, fun _ _ h => serie_injective (congrArg Subtype.val h)⟩

/-- `#𝒫(ℕ) ≤ #ℝ`. -/
theorem cardLe_set_nat_real : CardLe (Set ℕ) ℝ :=
  ⟨(setEquivBool ℕ).toEmbedding.trans serieEmb⟩

/-- **Práctica 2, Ej. 10 (b).** `#𝒫(ℕ) = c`, por Cantor–Schröder–Bernstein con los cortes y la
serie (`Guias/Guia2/Ej10` lo prueba por la vía del enunciado, `𝒫(ℕ) ∼ {0,1}^ℕ ∼ [0,1) ∼ ℝ`). -/
theorem cardC_set_nat : CardC (Set ℕ) := teorema_CSB cardLe_set_nat_real cardLe_real_set_nat

/-! ## Intercalar: `{0,1}^ℕ × {0,1}^ℕ ∼ {0,1}^ℕ` (pares / impares) y `ℝ × ℝ ∼ ℝ` (Ej. 14) -/

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

/-- **Práctica 2, Ej. 14 (a).** `#(𝒫(ℕ) × 𝒫(ℕ)) = c`. -/
theorem cardC_set_nat_prod : CardC (Set ℕ × Set ℕ) :=
  coordinables_trans ⟨setProdEquiv⟩ cardC_set_nat

/-- `#(ℝ × ℝ) ≤ #ℝ`: `ℝ × ℝ ↪ 𝒫(ℚ) × 𝒫(ℚ) ∼ 𝒫(ℕ) × 𝒫(ℕ) ∼ 𝒫(ℕ) ↪ ℝ`. -/
theorem cardLe_real_prod_real : CardLe (ℝ × ℝ) ℝ :=
  ⟨(corteEmb.prodMap corteEmb).trans
    (((setRatEquivSetNat.prodCongr setRatEquivSetNat).trans setProdEquiv).toEmbedding.trans
      ((setEquivBool ℕ).toEmbedding.trans serieEmb))⟩

/-- `#ℝ ≤ #(ℝ × ℝ)`: `x ↦ (x, 0)`. -/
theorem cardLe_real_real_prod : CardLe ℝ (ℝ × ℝ) :=
  ⟨⟨fun x => (x, 0), fun _ _ h => (Prod.mk.inj h).1⟩⟩

/-- `#(ℝ × ℝ) = c` (CSB). -/
theorem cardC_real_prod : CardC (ℝ × ℝ) := teorema_CSB cardLe_real_prod_real cardLe_real_real_prod

/-- **Práctica 2, Ej. 14 (c).** `#ℝ^(k+1) = c` por inducción en `k`, con
`ℝ^(k+2) ∼ ℝ × ℝ^(k+1) ∼ ℝ × ℝ ∼ ℝ`. -/
theorem cardC_pi : ∀ k : ℕ, CardC (Fin (k + 1) → ℝ)
  | 0 => ⟨Equiv.funUnique (Fin 1) ℝ⟩
  | k + 1 => by
    obtain ⟨e⟩ := cardC_pi k
    obtain ⟨f⟩ := cardC_real_prod
    exact ⟨(Fin.consEquiv fun _ : Fin (k + 2) => ℝ).symm.trans (((Equiv.refl ℝ).prodCongr e).trans f)⟩

/-! ## `ℝ ⊔ ℝ ∼ ℝ`, `ℕ × ℝ ↪ ℝ` y uniones de conjuntos de cardinal `c` (Ej. 7) -/

/-- Sublema: `ℝ ⊔ ℝ ∼ ℝ` (deducción propia). `ℝ ⊔ ℝ ∼ [0,1) ⊔ [1,2)` (Observación 3.21 en cada
copia), `[0,1) ⊔ [1,2) ∼ [0,1) ∪ [1,2) = [0,2)` (pegar dos funciones con dominios disjuntos), y
`[0,2) ∼ ℝ` (Observación 3.21). -/
theorem coordinables_real_sum_real : Coordinables (ℝ ⊕ ℝ) ℝ := by
  classical
  obtain ⟨e₁⟩ := cardC_Ico (show (0 : ℝ) < 1 by norm_num)
  obtain ⟨e₂⟩ := cardC_Ico (show (1 : ℝ) < 2 by norm_num)
  obtain ⟨e₃⟩ := cardC_Ico (show (0 : ℝ) < 2 by norm_num)
  have hdisj : Disjoint (Set.Ico (0 : ℝ) 1) (Set.Ico 1 2) := Set.Ico_disjoint_Ico_same
  have hunion : Set.Ico (0 : ℝ) 1 ∪ Set.Ico 1 2 = Set.Ico 0 2 :=
    Set.Ico_union_Ico_eq_Ico (by norm_num) (by norm_num)
  -- `ℝ ⊕ ℝ ≃ [0,1) ⊕ [1,2) ≃ [0,1) ∪ [1,2) = [0,2) ≃ ℝ`
  exact ⟨((e₁.symm.sumCongr e₂.symm).trans (Equiv.Set.union hdisj).symm).trans
    ((Set.equivOfEq hunion).trans e₃)⟩

/-- `(n, x) ↦ n + x` en `ℕ × [0,1)` es inyectiva: la parte entera de `n + x` es `n`. -/
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

/-- `#(ℕ × ℝ) ≤ c`: `ℕ × ℝ ∼ ℕ × [0,1)` (Observación 3.21) y `(n, t) ↦ n + t`. -/
theorem cardLe_nat_prod_real : CardLe (ℕ × ℝ) ℝ := by
  obtain ⟨e⟩ := cardC_Ico (zero_lt_one' ℝ)
  exact ⟨((Equiv.refl ℕ).prodCongr e.symm).toEmbedding.trans sumaEmb⟩

section Uniones

variable {X : Type*}

/-- `#(A ∪ B) ≤ c`: `A ∪ B ↪ A ⊔ B ∼ ℝ ⊔ ℝ ∼ ℝ`. -/
theorem cardLe_union_real {A B : Set X} (hA : CardC A) (hB : CardC B) : CardLe ↥(A ∪ B) ℝ := by
  obtain ⟨eA⟩ := hA
  obtain ⟨eB⟩ := hB
  have h1 : Coordinables (↥A ⊕ ↥B) (ℝ ⊕ ℝ) := ⟨eA.sumCongr eB⟩
  exact cardLe_trans (cardLe_union_sum A B)
    (cardLe_of_coordinables (coordinables_trans h1 coordinables_real_sum_real))

/-- `c ≤ #(A ∪ B)`: `ℝ ∼ A ⊆ A ∪ B`. -/
theorem cardLe_real_union {A B : Set X} (hA : CardC A) : CardLe ℝ ↥(A ∪ B) :=
  cardLe_trans (cardLe_of_coordinables (coordinables_symm hA))
    (cardLe_of_subset Set.subset_union_left)

/-- **Práctica 2, Ej. 7 (a).** Si `#A = c` y `#B = c`, entonces `#(A ∪ B) = c` (CSB con las dos
desigualdades); la demostración sigue el texto de `guias-agente/guia_2_resuelta_agente.typ`. -/
theorem cardC_union {A B : Set X} (hA : CardC A) (hB : CardC B) : CardC ↥(A ∪ B) :=
  teorema_CSB (cardLe_union_real hA hB) (cardLe_real_union hA)

variable (A : ℕ → Set X)

/-- `#(⋃ A n) ≤ c`: se eligen simultáneamente biyecciones `e n : A n ≃ ℝ` (axioma de elección),
la unión se inyecta en `ℕ × ℝ` (`cardLe_iUnion_prod`) y `#(ℕ × ℝ) ≤ c`. -/
theorem cardLe_iUnion_real (h : ∀ n, CardC (A n)) : CardLe ↥(⋃ n, A n) ℝ :=
  cardLe_trans (cardLe_iUnion_prod A fun n => (Classical.choice (h n)).toEmbedding)
    cardLe_nat_prod_real

/-- `c ≤ #(⋃ A n)`: `ℝ ∼ A 0 ⊆ ⋃ n, A n`. -/
theorem cardLe_real_iUnion (h : ∀ n, CardC (A n)) : CardLe ℝ ↥(⋃ n, A n) :=
  cardLe_trans (cardLe_of_coordinables (coordinables_symm (h 0)))
    (cardLe_of_subset (Set.subset_iUnion A 0))

/-- **Práctica 2, Ej. 7 (b).** Si `#A n = c` para todo `n`, entonces `#(⋃ n, A n) = c` (CSB con
las dos desigualdades); la demostración sigue el texto de
`guias-agente/guia_2_resuelta_agente.typ`. -/
theorem cardC_iUnion (h : ∀ n, CardC (A n)) : CardC ↥(⋃ n, A n) :=
  teorema_CSB (cardLe_iUnion_real A h) (cardLe_real_iUnion A h)

end Uniones

/-! ## Polinomios: `R[X] ↪ ⋃ₙ R^(n+1)` (Ej. 15) -/

/-- Igualdad heterogénea de tuplas de la misma longitud: coordenada a coordenada. -/
theorem heq_apply {α : Type*} {n m : ℕ} (hnm : n = m) {f : Fin (n + 1) → α} {g : Fin (m + 1) → α}
    (h : f ≍ g) (i : ℕ) (hi : i < n + 1) (hi' : i < m + 1) : f ⟨i, hi⟩ = g ⟨i, hi'⟩ := by
  subst hnm
  rw [eq_of_heq h]

section Polinomios

variable {R : Type*} [Semiring R]

/-- `p ↦ (gr p, (p_0, …, p_{gr p}))`. -/
def coefs (p : Polynomial R) : Σ n : ℕ, (Fin (n + 1) → R) :=
  ⟨p.natDegree, fun i => p.coeff i⟩

/-- `coefs` es inyectiva: mismo grado y mismos coeficientes hasta el grado dan el mismo
polinomio, porque más allá del grado todos los coeficientes son `0` (`Polynomial.ext`). -/
theorem coefs_injective : Function.Injective (coefs (R := R)) := by
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

/-- `R[X] ↪ Σ n, R^(n+1)`. -/
def coefsEmb : Polynomial R ↪ Σ n : ℕ, (Fin (n + 1) → R) := ⟨coefs, coefs_injective⟩

end Polinomios

end Comun
