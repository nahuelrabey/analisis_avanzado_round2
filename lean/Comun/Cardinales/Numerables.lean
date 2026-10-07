/-
Librería común `Comun`: definiciones del curso y resultados de `apuntes.typ` compartidos por las
guías (`Guias/`), los parciales (`Parciales/`) y los ejemplos (`Ejemplos/`). Ver
`apuntes-agente/lean-lemas-compartidos-y-organizacion.md` para el diseño.

`Comun.Cardinales.Numerables`: las construcciones explícitas con las que la Práctica 2 prueba que
un conjunto es contable o numerable, probadas una sola vez (antes estaban copiadas en varios
`Guias/Guia2/EjNN.lean`):
- `ℤ ∼ ℕ` (`natEquivInt`, Ej. 1 (b)-(c)) y `ℕ × ℕ ∼ ℕ` (`pairEmb` con `(n, m) ↦ 2^n 3^m`, que es
  el texto del Ej. 1 (c) y del Ej. 6 (a), y `par`/`parEmb` con `(k, m) ↦ 2^k (2m+1)`, que es el
  del Ej. 12 (b) y del Ej. 16, con la existencia de la escritura, `descomposicion`);
- `ℕ ⊕ ℕ ↪ ℕ` (pares e impares) y `A ∪ B ↪ A ⊕ B`, de donde `union_contable` **es el Ej. 2**;
- `ℕ^(k+1) ↪ ℕ` y `(Σ N, X^(N+1)) ↪ ℕ` si `X ↪ ℕ` (`codTupla`, `codSigma`, `cardLe_sigma_nat`,
  del Ej. 16);
- el índice mínimo `idx` de un punto de una unión numerable y la inyección
  `⋃ A n ↪ ℕ × Y` dadas inyecciones `A n ↪ Y` (`cardLe_iUnion_prod`), de donde `contable_iUnion`
  **es el Ej. 6 (a)**;
- `exists_C_coordinables`, `pegar` y `diff_coordinables` (**Ej. 3 (a) y (b)**);
- el código binario `codigo : Finset ℕ → ℕ` y `partes_finitas_numerable` (**Ej. 11**).

Regla de circularidad (ver el encabezado de `Comun.Cardinales`): acá no se usan los lemas de
Mathlib que son literalmente estos resultados (`Set.countable_iUnion`, `Set.Countable.union`,
`Countable.prod`, `Set.countable_setOf_finite_subset`, `Nat.pairEquiv`, `Equiv.intEquivNat`,
`Equiv.natSumNatEquivNat`, `Denumerable`, instancias `Countable`, …); las pruebas son las del
texto de `guias-agente/guia_2_resuelta_agente.typ`.
-/
import Mathlib
import Comun.Cardinales

namespace Comun

/-! ## `ℤ ∼ ℕ` (Ej. 1 (b)-(c)) -/

/-- `n ↦ n/2` si `n` es par, `n ↦ -(n/2) - 1` si es impar (pares a los `≥ 0`, impares a los `< 0`). -/
def natToInt (n : ℕ) : ℤ := if n % 2 = 0 then ((n / 2 : ℕ) : ℤ) else -((n / 2 : ℕ) : ℤ) - 1

/-- La inversa: `k ↦ 2k` para `k ≥ 0` y `-(k+1) ↦ 2k + 1`. -/
def intToNat : ℤ → ℕ
  | Int.ofNat k => 2 * k
  | Int.negSucc k => 2 * k + 1

/-- Sublema del Ej. 1: `ℕ ∼ ℤ`, con la biyección explícita de arriba. -/
def natEquivInt : ℕ ≃ ℤ where
  toFun := natToInt
  invFun := intToNat
  left_inv n := by
    unfold natToInt
    split_ifs with h
    · show intToNat (Int.ofNat (n / 2)) = n
      simp only [intToNat]
      omega
    · have : -((n / 2 : ℕ) : ℤ) - 1 = Int.negSucc (n / 2) := by
        rw [Int.negSucc_eq]; ring
      rw [this]
      simp only [intToNat]
      omega
  right_inv z := by
    cases z with
    | ofNat k =>
      simp only [intToNat, natToInt]
      have h2 : (2 * k) % 2 = 0 := by omega
      have h3 : (2 * k) / 2 = k := by omega
      simp [h2, h3]
    | negSucc k =>
      simp only [intToNat, natToInt]
      have h2 : ¬ ((2 * k + 1) % 2 = 0) := by omega
      have h3 : (2 * k + 1) / 2 = k := by omega
      simp only [h2, ite_false, h3, Int.negSucc_eq]
      ring

/-- `ℤ ∼ ℕ`. -/
theorem int_coordinables_nat : Coordinables ℤ ℕ := ⟨natEquivInt.symm⟩

/-- `#ℤ ≤ ℵ₀`. -/
theorem cardLe_int_nat : CardLe ℤ ℕ := cardLe_of_coordinables int_coordinables_nat

/-! ## `ℕ × ℕ ∼ ℕ` con `(n, m) ↦ 2^n 3^m` (Ej. 1 (c), Ej. 6 (a)) -/

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

/-- Si `2^a 3^b = 2^c 3^d` entonces `a = c` y `b = d`: con `a ≤ c` (el otro caso es simétrico), se
cancela `2^a` y queda `3^b = 2^(c-a) 3^d`; por paridad `c - a = 0`, y `3^b = 3^d` da `b = d`. -/
theorem pow_two_three_inj (a c b d : ℕ) (h : 2 ^ a * 3 ^ b = 2 ^ c * 3 ^ d) : a = c ∧ b = d := by
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
  rcases le_total a c with hac | hca
  · exact key a b c d hac h
  · obtain ⟨h1, h2⟩ := key c d a b hca h.symm
    exact ⟨h1.symm, h2.symm⟩

/-- La inyección `ℕ × ℕ → ℕ`, `(n, m) ↦ 2^n 3^m`. -/
def pairEmb : ℕ × ℕ ↪ ℕ where
  toFun p := 2 ^ p.1 * 3 ^ p.2
  inj' := by
    rintro ⟨a, b⟩ ⟨c, d⟩ h
    obtain ⟨h1, h2⟩ := pow_two_three_inj a c b d h
    simp [h1, h2]

/-- La inyección `ℕ → ℕ × ℕ`, `n ↦ (n, 0)`. -/
def diagEmb : ℕ ↪ ℕ × ℕ where
  toFun n := (n, 0)
  inj' := fun _ _ h => (Prod.mk.inj h).1

/-- `#(ℕ × ℕ) ≤ ℵ₀` (vía `(n, m) ↦ 2^n 3^m`). -/
theorem cardLe_nat_prod_nat : CardLe (ℕ × ℕ) ℕ := ⟨pairEmb⟩

/-- Sublema del Ej. 1 (c): `ℕ × ℕ ∼ ℕ`, por Cantor–Schröder–Bernstein (Teorema 3.11). -/
theorem natProdNat_numerable : Numerable (ℕ × ℕ) := teorema_CSB ⟨diagEmb⟩ cardLe_nat_prod_nat

/-! ## `ℕ × ℕ ↪ ℕ` con `(k, m) ↦ 2^k (2m+1)` (Ej. 12 (b), Ej. 16) -/

/-- La codificación `(m, n) ↦ 2^m (2n + 1)` de `ℕ × ℕ` en `ℕ`. -/
def par (m n : ℕ) : ℕ := 2 ^ m * (2 * n + 1)

/-- `par` es inyectiva (unicidad de la escritura `2^m (2n+1)`): si `2^m (2n+1) = 2^m' (2n'+1)`,
comparando la paridad después de cancelar tantos `2` como se pueda, `m = m'`, y luego `n = n'`. -/
theorem par_injective : ∀ {m m' n n' : ℕ}, par m n = par m' n' → m = m' ∧ n = n' := by
  intro m
  induction m with
  | zero =>
    intro m' n n' h
    cases m' with
    | zero =>
      simp only [par, pow_zero, one_mul] at h
      omega
    | succ k =>
      simp only [par, pow_zero, one_mul, pow_succ, mul_comm (2 ^ k) 2, mul_assoc] at h
      omega
  | succ k ih =>
    intro m' n n' h
    cases m' with
    | zero =>
      simp only [par, pow_zero, one_mul, pow_succ, mul_comm (2 ^ k) 2, mul_assoc] at h
      omega
    | succ k' =>
      simp only [par, pow_succ, mul_comm (2 ^ k) 2, mul_comm (2 ^ k') 2, mul_assoc] at h
      have h' : 2 ^ k * (2 * n + 1) = 2 ^ k' * (2 * n' + 1) :=
        Nat.eq_of_mul_eq_mul_left (by norm_num : 0 < 2) h
      obtain ⟨h1, h2⟩ := ih h'
      exact ⟨by omega, h2⟩

/-- `ℕ × ℕ ↪ ℕ` vía `par`. -/
def parEmb : ℕ × ℕ ↪ ℕ where
  toFun p := par p.1 p.2
  inj' := by
    rintro ⟨a, b⟩ ⟨c, d⟩ h
    obtain ⟨h1, h2⟩ : a = c ∧ b = d := par_injective h
    rw [h1, h2]

/-- Existencia de la escritura: todo `n ≥ 1` es `2^k (2m+1)` (inducción fuerte: si `n` es par,
`n = 2j` con `j < n`; si es impar, `k = 0`). (Deducción propia, Ej. 12 (b).) -/
theorem descomposicion (n : ℕ) (hn : 0 < n) : ∃ k m, n = 2 ^ k * (2 * m + 1) := by
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    rcases Nat.even_or_odd n with ⟨j, hj⟩ | ⟨j, hj⟩
    · obtain ⟨k, m, hk⟩ := ih j (by omega) (by omega)
      exact ⟨k + 1, m, by rw [hj, hk]; ring⟩
    · exact ⟨0, j, by rw [hj]; ring⟩

/-! ## Uniones de dos contables (Ej. 2) -/

/-- (Ej. 2, Sublema 2) La inyección `ℕ ⊕ ℕ → ℕ` que manda la primera copia a los pares y la segunda
a los impares. -/
def sumNatEmb : ℕ ⊕ ℕ ↪ ℕ where
  toFun := Sum.elim (fun n => 2 * n) (fun n => 2 * n + 1)
  inj' := by
    rintro (n | n) (m | m) h <;>
      simp only [Sum.elim_inl, Sum.elim_inr, Sum.inl.injEq, Sum.inr.injEq, reduceCtorEq] at h ⊢ <;>
      omega

/-- (Ej. 2, Sublema 3) La inyección `A ∪ B → A ⊕ B`: `x ↦ (x, en A)` si `x ∈ A`, y `x ↦ (x, en B)`
si no (entonces `x ∈ B`). -/
noncomputable def unionEmb {X : Type*} (A B : Set X) : ↥(A ∪ B) ↪ ↥A ⊕ ↥B where
  toFun x := by
    classical
    exact if h : (x : X) ∈ A then Sum.inl ⟨x, h⟩ else Sum.inr ⟨x, x.2.resolve_left h⟩
  inj' := by
    classical
    rintro ⟨x, hx⟩ ⟨y, hy⟩ h
    by_cases h1 : x ∈ A <;> by_cases h2 : y ∈ A <;>
      simp only [h1, h2, dite_true, dite_false, Sum.inl.injEq, Sum.inr.injEq, Subtype.mk.injEq,
        reduceCtorEq] at h <;>
      exact Subtype.ext h

/-- `#(A ∪ B) ≤ #(A ⊔ B)`. -/
theorem cardLe_union_sum {X : Type*} (A B : Set X) : CardLe ↥(A ∪ B) (↥A ⊕ ↥B) := ⟨unionEmb A B⟩

/-- **Práctica 2, Ej. 2.** Si `A` y `B` son contables, `A ∪ B` es contable: la cadena de
inyecciones `A ∪ B ↪ A ⊕ B ↪ ℕ ⊕ ℕ ↪ ℕ` y la Proposición 3.13; la demostración sigue el texto de
`guias-agente/guia_2_resuelta_agente.typ`. -/
theorem union_contable {X : Type*} (A B : Set X) (hA : Contable A) (hB : Contable B) :
    Contable ↥(A ∪ B) := by
  obtain ⟨fA⟩ := cardLe_nat_of_contable hA
  obtain ⟨fB⟩ := cardLe_nat_of_contable hB
  -- `A ∪ B ↪ A ⊕ B ↪ ℕ ⊕ ℕ ↪ ℕ`
  have h : CardLe ↥(A ∪ B) ℕ :=
    ⟨((unionEmb A B).trans (Function.Embedding.sumMap fA fB)).trans sumNatEmb⟩
  -- Proposición 3.13: `#(A ∪ B) ≤ ℵ₀` ⇒ `A ∪ B` contable
  exact contable_of_cardLe_numerable numerable_nat h

/-! ## Tuplas y uniones de potencias (Ej. 16) -/

/-- `ℕ^{k+1} ↪ ℕ`, por inducción en `k` usando `par`. -/
def codTupla : (k : ℕ) → (Fin (k + 1) → ℕ) → ℕ
  | 0, f => f 0
  | k + 1, f => par (f 0) (codTupla k (fun i => f i.succ))

theorem codTupla_injective (k : ℕ) : Function.Injective (codTupla k) := by
  induction k with
  | zero =>
    intro f g h
    funext i
    have hi : i = 0 := Fin.ext (by have := i.isLt; simp only [Fin.val_zero]; omega)
    rw [hi]
    exact h
  | succ k ih =>
    intro f g h
    simp only [codTupla] at h
    obtain ⟨h0, h1⟩ := par_injective h
    have h2 := ih h1
    funext i
    refine Fin.cases h0 (fun j => ?_) i
    exact congrFun h2 j

/-- Codificación de `⋃_N X^{N+1}` (modelado como `Σ N, (Fin (N+1) → X)`) en `ℕ`, dada una
codificación `c : X → ℕ`: `(N, x_0, …, x_N) ↦ par N (codTupla N (c x_0, …, c x_N))`. -/
def codSigma {X : Type*} (c : X → ℕ) (s : Σ N : ℕ, (Fin (N + 1) → X)) : ℕ :=
  par s.1 (codTupla s.1 (fun i => c (s.2 i)))

theorem codSigma_injective {X : Type*} {c : X → ℕ} (hc : Function.Injective c) :
    Function.Injective (codSigma c) := by
  rintro ⟨N, f⟩ ⟨M, g⟩ h
  unfold codSigma at h
  obtain ⟨hNM, h2⟩ := par_injective h
  subst hNM
  have h3 := codTupla_injective N h2
  have hfg : f = g := funext fun i => hc (congrFun h3 i)
  rw [hfg]

/-- (Producto finito y unión numerable de contables, versión inyectiva; Ej. 16) Si `#X ≤ ℵ₀`
entonces `#(⋃_N X^{N+1}) ≤ ℵ₀`. -/
theorem cardLe_sigma_nat {X : Type*} (hX : CardLe X ℕ) :
    CardLe (Σ N : ℕ, (Fin (N + 1) → X)) ℕ :=
  let ⟨c⟩ := hX
  ⟨⟨codSigma c, codSigma_injective c.injective⟩⟩

/-! ## Uniones numerables (Ej. 6 (a), Ej. 7 (b)) -/

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

/-- La inyección `x ↦ (n(x), g_{n(x)}(x))` de la unión en `ℕ × Y`, dadas inyecciones
`g n : A n ↪ Y`. Es inyectiva: si las imágenes coinciden, las primeras coordenadas dan
`n(x) = n(y) =: n`, y las segundas, `g n x = g n y` con `x, y ∈ A n`; como `g n` es inyectiva,
`x = y`. (Es el `F` del Ej. 6 (a) con `Y = ℕ` y el `G` del Ej. 7 (b) con `Y = ℝ`.) -/
theorem cardLe_iUnion_prod {Y : Type*} (g : ∀ n, ↥(A n) ↪ Y) : CardLe ↥(⋃ n, A n) (ℕ × Y) := by
  refine ⟨⟨fun x => (idx A x, g (idx A x) ⟨x.1, mem_idx A x⟩), ?_⟩⟩
  intro x y h
  simp only [Prod.mk.injEq] at h
  obtain ⟨h1, h2⟩ := h
  -- Se generaliza el índice para poder sustituir `n(x) = n(y)`.
  have key : ∀ (n m : ℕ) (hx : x.1 ∈ A n) (hy : y.1 ∈ A m), n = m →
      g n ⟨x.1, hx⟩ = g m ⟨y.1, hy⟩ → x = y := by
    intro n m hx hy hnm
    subst hnm
    intro hg
    have hxy := Subtype.ext_iff.1 ((g n).injective hg)
    exact Subtype.ext hxy
  exact key _ _ (mem_idx A x) (mem_idx A y) h1 h2

/-- `#(⋃ A n) ≤ #(ℕ × ℕ)`, eligiendo simultáneamente una inyección `f n : A n ↪ ℕ` para cada `n`
(axioma de elección). -/
theorem cardLe_iUnion_nat_prod (h : ∀ n, Contable (A n)) : CardLe ↥(⋃ n, A n) (ℕ × ℕ) := by
  have hf : ∀ n, Nonempty (↥(A n) ↪ ℕ) := fun n => cardLe_nat_of_contable (h n)
  exact cardLe_iUnion_prod A fun n => Classical.choice (hf n)

/-- **Práctica 2, Ej. 6 (a).** Si cada `A n` es contable, `⋃ n, A n` es contable: la unión se
inyecta en `ℕ × ℕ`, que se inyecta en `ℕ` (`(n, m) ↦ 2^n 3^m`), y se aplica la Proposición 3.13;
la demostración sigue el texto de `guias-agente/guia_2_resuelta_agente.typ`. -/
theorem contable_iUnion (h : ∀ n, Contable (A n)) : Contable ↥(⋃ n, A n) :=
  contable_of_cardLe_numerable numerable_nat
    (cardLe_trans (cardLe_iUnion_nat_prod A h) cardLe_nat_prod_nat)

end Union

/-! ## `B \ A ∼ B` (Ej. 3) -/

/-- Hecho de base: un conjunto que contiene a uno infinito es infinito (acá, `C ⊆ C ∪ A` con
`C` numerable). En Mathlib es `Set.Infinite.mono`. -/
theorem infinito_union_left {X : Type*} {C A : Set X} (hC : Numerable C) :
    Infinito ↥(C ∪ A) := by
  rw [infinito_iff_infinite, Set.infinite_coe_iff]
  have : Infinite C := (numerable_iff.1 hC).2
  exact (Set.infinite_coe_iff.1 this).mono Set.subset_union_left

/-- **Práctica 2, Ej. 3 (a).** Si `A` es contable y `B \ A` es infinito, hay `C ⊆ B \ A` con
`C ∼ C ∪ A`: `C` es el numerable de la Proposición 3.14, y `C ∪ A` es contable (Ej. 2) e
infinito, luego numerable. La hipótesis `A ⊆ B` no hace falta en este ítem; la demostración sigue
el texto de `guias-agente/guia_2_resuelta_agente.typ`. -/
theorem exists_C_coordinables {X : Type*} {A B : Set X} (hA : Contable A)
    (hBA : Infinito ↥(B \ A)) : ∃ C : Set X, C ⊆ B \ A ∧ Coordinables C ↥(C ∪ A) := by
  -- Proposición 3.14: una inyección `ℕ → B \ A`; su imagen es el `C` buscado
  obtain ⟨f⟩ := cardLe_nat_of_infinito hBA
  let g : ℕ → X := fun n => (f n : X)
  have hg : Function.Injective g := fun n m h => f.injective (Subtype.ext h)
  refine ⟨Set.range g, ?_, ?_⟩
  · rintro x ⟨n, rfl⟩
    exact (f n).2
  · have hC : Numerable ↥(Set.range g) := ⟨Equiv.ofInjective g hg⟩
    -- `C ∪ A` es contable (Ej. 2) e infinito (contiene a `C`), luego numerable (Prop. 3.13/3.14)
    have hCA : Numerable ↥(Set.range g ∪ A) :=
      numerable_iff_contable_infinito.2
        ⟨union_contable _ _ (contable_of_numerable hC) hA, infinito_union_left hC⟩
    -- `C ∼ ℕ ∼ C ∪ A` (Proposición 3.2)
    exact coordinables_trans (coordinables_symm (hC : Coordinables ℕ _)) (hCA : Coordinables ℕ _)

/-- (Ej. 3 (b), el pegado) Si `A ⊆ B`, `C ⊆ B \ A` y `h : C → C ∪ A` es biyectiva, la función
`B \ A → B` que vale `h` en `C` y la identidad en `(B \ A) \ C` es biyectiva. Se formaliza
descomponiendo `B \ A = C ⊔ ((B \ A) \ C)` y `B = (C ∪ A) ⊔ ((B \ A) \ C)`. -/
theorem pegar {X : Type*} {A B C : Set X} (hAB : A ⊆ B) (hC : C ⊆ B \ A)
    (h : Coordinables C ↥(C ∪ A)) : Coordinables ↥(B \ A) ↥B := by
  classical
  obtain ⟨e⟩ := h
  have h1 : B \ A = C ∪ ((B \ A) \ C) := (Set.union_sdiff_cancel hC).symm
  have h2 : B = (C ∪ A) ∪ ((B \ A) \ C) := by
    ext x
    have := @hC x
    have := @hAB x
    simp only [Set.mem_union, Set.mem_sdiff] at *
    tauto
  have hd1 : Disjoint C ((B \ A) \ C) := Set.disjoint_sdiff_right
  have hd2 : Disjoint (C ∪ A) ((B \ A) \ C) := by
    rw [Set.disjoint_left]
    rintro x (hx | hx) ⟨⟨_, hxA⟩, hxC⟩
    · exact hxC hx
    · exact hxA hx
  exact ⟨(Set.equivOfEq h1).trans ((Equiv.Set.union hd1).trans
    ((Equiv.sumCongr e (Equiv.refl _)).trans ((Equiv.Set.union hd2).symm.trans
      (Set.equivOfEq h2.symm))))⟩

/-- **Práctica 2, Ej. 3 (b).** Si `A ⊆ B`, `A` es contable y `B \ A` es infinito, entonces
`B \ A ∼ B`; la demostración sigue el texto de `guias-agente/guia_2_resuelta_agente.typ`. -/
theorem diff_coordinables {X : Type*} {A B : Set X} (hAB : A ⊆ B) (hA : Contable A)
    (hBA : Infinito ↥(B \ A)) : Coordinables ↥(B \ A) ↥B := by
  obtain ⟨C, hC, h⟩ := exists_C_coordinables hA hBA
  exact pegar hAB hC h

/-! ## Partes finitas de un numerable (Ej. 11) -/

/-- El código binario de un conjunto finito de naturales: `Σ_{k ∈ S} 2^k`. -/
def codigo (S : Finset ℕ) : ℕ := ∑ k ∈ S, 2 ^ k

/-- `Σ_{i < k} 2^i = 2^k - 1 < 2^k` (inducción en `k`). -/
theorem sum_range_two_pow_lt (k : ℕ) : ∑ i ∈ Finset.range k, 2 ^ i < 2 ^ k := by
  induction k with
  | zero => simp
  | succ k ih =>
    rw [Finset.sum_range_succ, pow_succ]
    omega

/-- Si todos los elementos de `S` son `< k`, entonces `codigo S < 2^k`. -/
theorem codigo_lt {S : Finset ℕ} {k : ℕ} (h : ∀ x ∈ S, x < k) : codigo S < 2 ^ k := by
  unfold codigo
  calc ∑ i ∈ S, 2 ^ i ≤ ∑ i ∈ Finset.range k, 2 ^ i :=
        Finset.sum_le_sum_of_subset (fun x hx => Finset.mem_range.2 (h x hx))
    _ < 2 ^ k := sum_range_two_pow_lt k

/-- El `i`-ésimo dígito binario de `codigo S` es `1` si y sólo si `i ∈ S`. Inducción en `S`
agregando cada vez el elemento máximo `k`: `codigo (S ∪ {k}) = 2^k · 1 + codigo S` con
`codigo S < 2^k`, así que los dígitos por debajo de `k` son los de `codigo S` y el dígito `k`
es `1`. -/
theorem testBit_codigo (S : Finset ℕ) (i : ℕ) : (codigo S).testBit i = decide (i ∈ S) := by
  induction S using Finset.induction_on_max with
  | empty => simp [codigo]
  | insert k S hS ih =>
    have hk : k ∉ S := fun h => lt_irrefl k (hS k h)
    have hlt := codigo_lt hS
    have hins : codigo (insert k S) = 2 ^ k * 1 + codigo S := by
      rw [codigo, Finset.sum_insert hk, mul_one]
      rfl
    rw [hins, Nat.testBit_two_pow_mul_add 1 hlt i, ih]
    split_ifs with hik
    · rw [decide_eq_decide, Finset.mem_insert]
      constructor
      · exact Or.inr
      · rintro (h | h)
        · omega
        · exact h
    · rw [show (1 : ℕ) = 2 ^ 0 from rfl, Nat.testBit_two_pow, decide_eq_decide, Finset.mem_insert]
      constructor
      · intro h0
        left
        omega
      · rintro (h | h)
        · omega
        · exact absurd (hS i h) (by omega)

/-- Unicidad del desarrollo binario: `codigo` es inyectiva. -/
theorem codigo_injective : Function.Injective codigo := by
  intro S T h
  ext i
  have := congrArg (fun m => Nat.testBit m i) h
  simp only [testBit_codigo, decide_eq_decide] at this
  exact this

/-- `Finset ℕ ↪ ℕ`. -/
def codigoEmb : Finset ℕ ↪ ℕ := ⟨codigo, codigo_injective⟩

section PartesFinitas

variable {A : Type*}

/-- `B ↦ Σ_{a ∈ B} 2^(e⁻¹(a))`: la inyección `𝒫_f(A) → ℕ`. -/
noncomputable def codificar (e : ℕ ≃ A) (B : {B : Set A // B.Finite}) : ℕ :=
  codigo (B.2.toFinset.map e.symm.toEmbedding)

theorem codificar_injective (e : ℕ ≃ A) : Function.Injective (codificar e) := by
  intro B C h
  have h1 := codigo_injective h
  have h2 := Finset.map_injective e.symm.toEmbedding h1
  exact Subtype.ext (Set.Finite.toFinset_inj.1 h2)

/-- **Práctica 2, Ej. 11 (contable).** Si `A` es numerable, `𝒫_f(A)` es contable:
`#𝒫_f(A) ≤ #ℕ` por `codificar` y Proposición 3.13; la demostración sigue el texto de
`guias-agente/guia_2_resuelta_agente.typ`. -/
theorem partes_finitas_contable (h : Numerable A) : Contable {B : Set A // B.Finite} :=
  let ⟨e⟩ := h
  contable_of_cardLe_numerable numerable_nat ⟨⟨codificar e, codificar_injective e⟩⟩

/-- `n ↦ {e(n)}`: la inyección `ℕ → 𝒫_f(A)`. -/
def unitario (e : ℕ ≃ A) (n : ℕ) : {B : Set A // B.Finite} := ⟨{e n}, Set.finite_singleton _⟩

theorem unitario_injective (e : ℕ ≃ A) : Function.Injective (unitario e) := by
  intro n m h
  have := congrArg Subtype.val h
  simp only [unitario, Set.singleton_eq_singleton_iff] at this
  exact e.injective this

/-- **Práctica 2, Ej. 11 (infinito).** `𝒫_f(A)` es infinito: contiene una copia de `ℕ`
(`ℵ₀ ≤ #𝒫_f(A)`). -/
theorem partes_finitas_infinito (h : Numerable A) : Infinito {B : Set A // B.Finite} := by
  obtain ⟨e⟩ := h
  exact infinito_of_cardLe_nat ⟨⟨unitario e, unitario_injective e⟩⟩

/-- **Práctica 2, Ej. 11.** Si `A` es numerable, `𝒫_f(A) = {B ⊆ A : B finito}` es numerable
(contable e infinito, Definición 3.6). -/
theorem partes_finitas_numerable (h : Numerable A) : Numerable {B : Set A // B.Finite} :=
  numerable_iff_contable_infinito.2 ⟨partes_finitas_contable h, partes_finitas_infinito h⟩

end PartesFinitas

end Comun
