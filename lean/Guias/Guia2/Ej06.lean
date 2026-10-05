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
  (b) `A` finito y no vacío, `S = ⋃_{m ≥ 1} A^m`: `#S = ℵ₀`. Acá `A^m` es `Fin m → A` y `S` es el
      sigma-tipo `Σ m : ℕ, (Fin (m+1) → A)` (las tuplas de longitud `m+1`, `m ∈ ℕ` desde `0`, o sea
      las de longitud `≥ 1`, cada una recordando su longitud: la unión es disjunta porque tuplas de
      longitudes distintas son distintas). Cada `A^m` es finito (inducción), `S` es contable por (a)
      e infinito porque `m ↦ (a, …, a)` inyecta `ℕ`.
      Deducción: `#S = ℵ₀ < c = #ℝ` (`cardLt_nat_real`), formalizada como `CardLt S ℝ`.
-/
import Mathlib
import Guias.Guia2.Defs

namespace Guias.Guia2.Ej06

/-! ## Sublema: `ℕ × ℕ ↪ ℕ` vía `(n, m) ↦ 2^n 3^m` -/

/-- Si `3^b = 2^k * 3^d` entonces `k = 0`: si `k > 0`, el miembro derecho es par y `3^b` es impar
(`2 ∣ 3^b ⇒ 2 ∣ 3`, absurdo). -/
theorem k_eq_zero {b k d : ℕ} (h : 3 ^ b = 2 ^ k * 3 ^ d) : k = 0 := by
  rcases Nat.eq_zero_or_pos k with hk | hk
  · exact hk
  · exfalso
    have h2 : 2 ∣ 3 ^ b := by
      rw [h]
      exact Dvd.dvd.mul_right (dvd_pow_self 2 hk.ne') _
    have h3 : 2 ∣ 3 := Nat.Prime.dvd_of_dvd_pow Nat.prime_two h2
    omega

/-- `(n, m) ↦ 2^n 3^m` es inyectiva: con `a ≤ c` (el otro caso es simétrico), se cancela `2^a` y
queda `3^b = 2^(c-a) 3^d`; por paridad `c - a = 0`, y `3^b = 3^d` da `b = d`. -/
theorem pow23_injective : Function.Injective fun p : ℕ × ℕ => 2 ^ p.1 * 3 ^ p.2 := by
  -- Primero el caso `a ≤ c`, después se lo aplica en los dos órdenes.
  have key : ∀ a b c d : ℕ, a ≤ c → 2 ^ a * 3 ^ b = 2 ^ c * 3 ^ d → a = c ∧ b = d := by
    intro a b c d hac h
    obtain ⟨k, rfl⟩ := Nat.exists_eq_add_of_le hac
    rw [pow_add, mul_assoc] at h
    have h' : 3 ^ b = 2 ^ k * 3 ^ d := Nat.eq_of_mul_eq_mul_left (by positivity) h
    have hk : k = 0 := k_eq_zero h'
    subst hk
    rw [pow_zero, one_mul] at h'
    exact ⟨by simp, Nat.pow_right_injective (by norm_num : 2 ≤ 3) h'⟩
  rintro ⟨a, b⟩ ⟨c, d⟩ h
  simp only at h
  rcases le_total a c with hac | hca
  · obtain ⟨h1, h2⟩ := key a b c d hac h
    rw [h1, h2]
  · obtain ⟨h1, h2⟩ := key c d a b hca h.symm
    rw [h1, h2]

/-- Sublema: `#(ℕ × ℕ) ≤ ℵ₀` (deducción propia). -/
theorem cardLe_nat_prod_nat : CardLe (ℕ × ℕ) ℕ := ⟨⟨_, pow23_injective⟩⟩

/-! ## (a) Unión contable de contables -/

/-- Un conjunto contable se inyecta en `ℕ`: si es finito, `A ≃ Fin k` seguido de la inclusión
`Fin k ⊆ ℕ`; si es numerable, la inversa de la biyección `ℕ ≃ A`. -/
theorem embedding_nat_of_contable {A : Type*} (h : Contable A) : Nonempty (A ↪ ℕ) := by
  rcases h with hfin | hnum
  · exact let ⟨k, ⟨e⟩⟩ := hfin; ⟨e.toEmbedding.trans Fin.valEmbedding⟩
  · exact let ⟨e⟩ := hnum; ⟨e.symm.toEmbedding⟩

section Union

variable {X : Type*} (A : ℕ → Set X)

/-- Todo `x` de la unión está en algún `A n`. -/
theorem exists_mem (x : ↥(⋃ n, A n)) : ∃ n, x.1 ∈ A n := Set.mem_iUnion.1 x.2

open Classical in
/-- El índice `n(x)`: el menor `n` con `x ∈ A n` (es el único `n` con `x ∈ B n` para la
disjuntización del Ej. 5). -/
noncomputable def idx (x : ↥(⋃ n, A n)) : ℕ := Nat.find (exists_mem A x)

open Classical in
theorem mem_idx (x : ↥(⋃ n, A n)) : x.1 ∈ A (idx A x) := Nat.find_spec (exists_mem A x)

/-- La inyección `x ↦ (n(x), f_{n(x)}(x))` de la unión en `ℕ × ℕ`, dadas inyecciones
`f n : A n ↪ ℕ`. -/
noncomputable def F (f : ∀ n, ↥(A n) ↪ ℕ) (x : ↥(⋃ n, A n)) : ℕ × ℕ :=
  (idx A x, f (idx A x) ⟨x.1, mem_idx A x⟩)

/-- `F` es inyectiva: si `F x = F y`, las primeras coordenadas dan `n(x) = n(y) =: n`, y las
segundas, `f n x = f n y` con `x, y ∈ A n`; como `f n` es inyectiva, `x = y`. -/
theorem F_injective (f : ∀ n, ↥(A n) ↪ ℕ) : Function.Injective (F A f) := by
  intro x y h
  simp only [F, Prod.mk.injEq] at h
  obtain ⟨h1, h2⟩ := h
  -- Se generaliza el índice para poder sustituir `n(x) = n(y)`.
  have key : ∀ (n m : ℕ) (hx : x.1 ∈ A n) (hy : y.1 ∈ A m), n = m →
      f n ⟨x.1, hx⟩ = f m ⟨y.1, hy⟩ → x = y := by
    intro n m hx hy hnm
    subst hnm
    intro hf
    have hxy := Subtype.ext_iff.1 ((f n).injective hf)
    exact Subtype.ext hxy
  exact key _ _ (mem_idx A x) (mem_idx A y) h1 h2

/-- `#(⋃ A n) ≤ #(ℕ × ℕ)`, eligiendo simultáneamente una inyección `f n : A n ↪ ℕ` para cada `n`
(axioma de elección). -/
theorem cardLe_iUnion_nat_prod (h : ∀ n, Contable (A n)) : CardLe ↥(⋃ n, A n) (ℕ × ℕ) := by
  have hf : ∀ n, Nonempty (↥(A n) ↪ ℕ) := fun n => embedding_nat_of_contable (h n)
  let f : ∀ n, ↥(A n) ↪ ℕ := fun n => Classical.choice (hf n)
  exact ⟨⟨F A f, F_injective A f⟩⟩

/-- **Ej. 6 (a).** Si cada `A n` es contable, `⋃ n, A n` es contable: la unión se inyecta en
`ℕ × ℕ`, que se inyecta en `ℕ`, y se aplica la Proposición 3.13. -/
theorem ej6a (h : ∀ n, Contable (A n)) : Contable ↥(⋃ n, A n) :=
  contable_of_cardLe_numerable numerable_nat
    (cardLe_trans (cardLe_iUnion_nat_prod A h) cardLe_nat_prod_nat)

end Union

/-! ## (b) `S = ⋃_{m ≥ 1} A^m` con `A` finito y no vacío tiene cardinal `ℵ₀` -/

section Palabras

variable (A : Type*)

/-- `S`: las tuplas de longitud `≥ 1` con entradas en `A`, cada una con su longitud. Modela
`⋃_{m ∈ ℕ} A^m` con `ℕ = {1, 2, …}` (el índice `m : ℕ` de Lean, desde `0`, codifica `A^(m+1)`). -/
abbrev S : Type _ := Σ m : ℕ, (Fin (m + 1) → A)

/-- El producto de dos conjuntos finitos es finito: `Fin p × Fin q ∼ Fin (p q)` (deducción propia;
la biyección es `(i, j) ↦ i q + j`, `finProdFinEquiv` en Mathlib). -/
theorem finito_prod {P Q : Type*} (hP : Finito P) (hQ : Finito Q) : Finito (P × Q) := by
  obtain ⟨p, ⟨eP⟩⟩ := hP
  obtain ⟨q, ⟨eQ⟩⟩ := hQ
  exact ⟨p * q, ⟨(eP.prodCongr eQ).trans finProdFinEquiv⟩⟩

/-- Sublema: `A^m` es finito para todo `m ≥ 1` (inducción en `m`). `A^1 ∼ A`, y
`A^(m+2) ∼ A × A^(m+1)` separando la primera coordenada. -/
theorem finito_pow (hA : Finito A) (m : ℕ) : Finito (Fin (m + 1) → A) := by
  induction m with
  | zero => exact
      let ⟨k, ⟨e⟩⟩ := hA
      ⟨k, ⟨(Equiv.funUnique (Fin 1) A).trans e⟩⟩
  | succ m ih =>
    obtain ⟨k, ⟨e⟩⟩ := finito_prod hA ih
    exact ⟨k, ⟨(Fin.consEquiv fun _ : Fin (m + 2) => A).symm.trans e⟩⟩

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

/-- Cada `T m` es contable (es finito, pues `∼ A^(m+1)`). -/
theorem contable_T (hA : Finito A) (m : ℕ) : Contable ↥(T A m) := by
  obtain ⟨k, ⟨e⟩⟩ := finito_pow A hA m
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
theorem infinito_S [Nonempty A] : Infinito (S A) := by
  obtain ⟨f⟩ := nat_embedding_S A
  exact infinito_iff_infinite.2 (Infinite.of_injective f f.injective)

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
