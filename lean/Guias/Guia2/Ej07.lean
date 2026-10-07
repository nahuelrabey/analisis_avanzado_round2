/-
Análisis Avanzado (FCEN-UBA) · Práctica 2 · Ejercicio 7
Enunciado en `apuntes-typst/guias/p2.typ`; resolución en
`apuntes-typst/guias-agente/guia_2_resuelta_agente.typ` (Ejercicio 7).

Sea `c = #ℝ`.
  (a) `#A = #B = c ⇒ #(A ∪ B) = c`. `≥`: `A ⊆ A ∪ B`. `≤`: `A ∪ B ↪ A ⊔ B ∼ ℝ ⊔ ℝ ∼ [0,1) ⊔ [1,2)
      ∼ [0,2) ∼ ℝ` (Observación 3.21). Se concluye con Cantor–Schröder–Bernstein (Teorema 3.11).
  (b) `#A n = c` para todo `n ⇒ #(⋃ n, A n) = c`. `≥`: `A 0 ⊆ ⋃ n, A n`. `≤`: eligiendo biyecciones
      `e n : A n ≃ ℝ` (axioma de elección) y el menor índice `n(x)` con `x ∈ A n(x)`, la asignación
      `x ↦ (n(x), e n(x) x)` inyecta la unión en `ℕ × ℝ ∼ ℕ × [0,1)`, y `(n, t) ↦ n + t` inyecta
      `ℕ × [0,1)` en `ℝ` (la parte entera de `n + t` es `n`). Se concluye con CSB.
-/
import Mathlib
import Comun.Cardinales

open Comun

namespace Guias.Guia2.Ej07

variable {X : Type*}

/-! ## (a) Unión de dos conjuntos de cardinal `c` -/

/-- `A ∪ B ↪ A ⊔ B`: cada `x` va a la copia de `A` si `x ∈ A`, y si no a la copia de `B`
(entonces `x ∈ B`). Es inyectiva porque en cada copia se guarda el propio `x`. -/
theorem cardLe_union_sum (A B : Set X) : CardLe ↥(A ∪ B) (↥A ⊕ ↥B) := by
  classical
  refine ⟨⟨fun x => if h : x.1 ∈ A then Sum.inl ⟨x.1, h⟩ else Sum.inr ⟨x.1, x.2.resolve_left h⟩,
    ?_⟩⟩
  intro x y hxy
  by_cases hx : x.1 ∈ A <;> by_cases hy : y.1 ∈ A <;> simp only [hx, hy, dite_true, dite_false,
    Sum.inl.injEq, Sum.inr.injEq, Subtype.mk.injEq, reduceCtorEq] at hxy <;> exact Subtype.ext hxy

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

/-- **Ej. 7 (a).** Si `#A = c` y `#B = c`, entonces `#(A ∪ B) = c` (CSB con las dos
desigualdades). -/
theorem ej7a {A B : Set X} (hA : CardC A) (hB : CardC B) : CardC ↥(A ∪ B) :=
  teorema_CSB (cardLe_union_real hA hB) (cardLe_real_union hA)

/-! ## (b) Unión numerable de conjuntos de cardinal `c` -/

/-- Sublema: `(n, t) ↦ n + t` es inyectiva en `ℕ × [0,1)`: la parte entera de `n + t` es `n`
(deducción propia; Práctica 1, Ej. 2 (a) / `Int.floor`). -/
theorem add_injective : Function.Injective fun p : ℕ × ↥(Set.Ico (0 : ℝ) 1) => (p.1 : ℝ) + p.2.1 := by
  have hfloor : ∀ p : ℕ × ↥(Set.Ico (0 : ℝ) 1), ⌊(p.1 : ℝ) + p.2.1⌋ = (p.1 : ℤ) := by
    intro p
    obtain ⟨ht0, ht1⟩ := p.2.2
    rw [Int.floor_eq_iff]
    push_cast
    constructor <;> linarith
  rintro ⟨n, t⟩ ⟨m, s⟩ h
  simp only at h
  have hnm : (n : ℤ) = m := by
    have h1 := hfloor (n, t)
    have h2 := hfloor (m, s)
    simp only at h1 h2
    rw [h] at h1
    exact h1.symm.trans h2
  have hnm' : n = m := by exact_mod_cast hnm
  subst hnm'
  have hts : t.1 = s.1 := by linarith
  rw [Subtype.ext hts]

/-- Sublema: `#(ℕ × ℝ) ≤ c` (deducción propia): `ℕ × ℝ ∼ ℕ × [0,1)` (Observación 3.21) y
`(n, t) ↦ n + t`. -/
theorem cardLe_nat_prod_real : CardLe (ℕ × ℝ) ℝ := by
  obtain ⟨e⟩ := cardC_Ico (show (0 : ℝ) < 1 by norm_num)
  have h1 : Coordinables (ℕ × ℝ) (ℕ × ↥(Set.Ico (0 : ℝ) 1)) := ⟨(Equiv.refl ℕ).prodCongr e.symm⟩
  exact cardLe_trans (cardLe_of_coordinables h1) ⟨⟨_, add_injective⟩⟩

section Union

variable (A : ℕ → Set X)

/-- Todo `x` de la unión está en algún `A n`. -/
theorem exists_mem (x : ↥(⋃ n, A n)) : ∃ n, x.1 ∈ A n := Set.mem_iUnion.1 x.2

open Classical in
/-- El índice `n(x)`: el menor `n` con `x ∈ A n` (como en el Ej. 6 (a)). -/
noncomputable def idx (x : ↥(⋃ n, A n)) : ℕ := Nat.find (exists_mem A x)

open Classical in
theorem mem_idx (x : ↥(⋃ n, A n)) : x.1 ∈ A (idx A x) := Nat.find_spec (exists_mem A x)

/-- La asignación `x ↦ (n(x), e n(x) x) ∈ ℕ × ℝ`, dadas biyecciones `e n : A n ≃ ℝ`. -/
noncomputable def G (e : ∀ n, ↥(A n) ≃ ℝ) (x : ↥(⋃ n, A n)) : ℕ × ℝ :=
  (idx A x, e (idx A x) ⟨x.1, mem_idx A x⟩)

/-- `G` es inyectiva: `G x = G y` da `n(x) = n(y) =: n` y `e n x = e n y`, luego `x = y`. -/
theorem G_injective (e : ∀ n, ↥(A n) ≃ ℝ) : Function.Injective (G A e) := by
  intro x y h
  simp only [G, Prod.mk.injEq] at h
  obtain ⟨h1, h2⟩ := h
  have key : ∀ (n m : ℕ) (hx : x.1 ∈ A n) (hy : y.1 ∈ A m), n = m →
      e n ⟨x.1, hx⟩ = e m ⟨y.1, hy⟩ → x = y := by
    intro n m hx hy hnm
    subst hnm
    intro he
    have hxy := Subtype.ext_iff.1 ((e n).injective he)
    exact Subtype.ext hxy
  exact key _ _ (mem_idx A x) (mem_idx A y) h1 h2

/-- `#(⋃ A n) ≤ c`: se eligen simultáneamente biyecciones `e n : A n ≃ ℝ` (axioma de elección),
la unión se inyecta en `ℕ × ℝ` y `#(ℕ × ℝ) ≤ c`. -/
theorem cardLe_iUnion_real (h : ∀ n, CardC (A n)) : CardLe ↥(⋃ n, A n) ℝ := by
  let e : ∀ n, ↥(A n) ≃ ℝ := fun n => Classical.choice (h n)
  exact cardLe_trans ⟨⟨G A e, G_injective A e⟩⟩ cardLe_nat_prod_real

/-- `c ≤ #(⋃ A n)`: `ℝ ∼ A 0 ⊆ ⋃ n, A n`. -/
theorem cardLe_real_iUnion (h : ∀ n, CardC (A n)) : CardLe ℝ ↥(⋃ n, A n) :=
  cardLe_trans (cardLe_of_coordinables (coordinables_symm (h 0)))
    (cardLe_of_subset (Set.subset_iUnion A 0))

/-- **Ej. 7 (b).** Si `#A n = c` para todo `n`, entonces `#(⋃ n, A n) = c` (CSB con las dos
desigualdades). -/
theorem ej7b (h : ∀ n, CardC (A n)) : CardC ↥(⋃ n, A n) :=
  teorema_CSB (cardLe_iUnion_real A h) (cardLe_real_iUnion A h)

end Union

end Guias.Guia2.Ej07
