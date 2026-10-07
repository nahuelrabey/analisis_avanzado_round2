/-
Análisis Avanzado (FCEN-UBA) · Práctica 2 · Ejercicio 16
Enunciado en `apuntes-typst/guias/p2.typ`; resolución en
`apuntes-typst/guias-agente/guia_2_resuelta_agente.typ` (Ejercicio 16).

Se calcula el cardinal de
  (a) `{(a_n) ⊆ ℤ : (a_n) converge}`      → `ℵ₀` (`ej16a : Numerable Conv`),
  (b) `{(a_n) ⊆ ℚ : (a_n) es periódica}`  → `ℵ₀` (`ej16b : Numerable Per`).

Argumento (el mismo del Typst):
  * (a) una sucesión de enteros convergente es eventualmente constante (`ε = 1/2`: dos enteros a
    distancia `< 1` son iguales), así que queda determinada por `(N, a_0, …, a_N)`, un elemento de
    `⋃_N ℤ^{N+1}`, modelado como `Σ N, (Fin (N+1) → ℤ)`.
  * (b) una sucesión periódica de período `p ≥ 1` queda determinada por `(p - 1, a_0, …, a_{p-1})`,
    un elemento de `⋃_N ℚ^{N+1}`.
  * `⋃_N X^{N+1}` se inyecta en `ℕ` si `X` lo hace, componiendo las codificaciones explícitas
    `ℕ × ℕ ↪ ℕ` (`(m, n) ↦ 2^m (2n + 1)`), `ℤ ↪ ℕ`, `ℚ ↪ ℕ` (numerabilidad de `ℚ`) y
    `ℕ^{N+1} ↪ ℕ` (por inducción en `N`). Esto reemplaza, dentro de Lean, a la cita del Ej. 6 (a)
    (unión contable de contables) que hace el texto.
  * Ambos conjuntos contienen a las sucesiones constantes, así que son infinitos; contable e
    infinito es numerable (Definición 3.6, vía `numerable_iff_contable_infinito`).

Convergencia: se usa la Definición 7 de `apuntes.typ` tal cual (`ε`-`n₀`), con los enteros vistos
en `ℝ`; `converge_iff_tendsto` muestra que coincide con `Tendsto` de Mathlib.
-/
import Mathlib
import Comun.Cardinales

namespace Guias.Guia2.Ej16

open Comun
/-! ## Codificaciones explícitas (deducción propia) -/

/-- Sublema: la codificación `(m, n) ↦ 2^m (2n + 1)` de `ℕ × ℕ` en `ℕ`. -/
def par (m n : ℕ) : ℕ := 2 ^ m * (2 * n + 1)

/-- `par` es inyectiva: si `2^m (2n+1) = 2^m' (2n'+1)`, comparando la paridad después de cancelar
tantos `2` como se pueda, `m = m'`, y luego `n = n'`. -/
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

/-- Sublema: `ℤ ↪ ℕ`, con `z ↦ 2z` si `z ≥ 0` y `z ↦ -2z - 1` si `z < 0`. -/
def codZ (z : ℤ) : ℕ := if 0 ≤ z then (2 * z).toNat else (-2 * z - 1).toNat

theorem codZ_injective : Function.Injective codZ := by
  intro a b h
  unfold codZ at h
  split_ifs at h <;> omega

/-- Sublema: `ℕ^{k+1} ↪ ℕ`, por inducción en `k` usando `par`. -/
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

/-- Sublema (producto finito y unión numerable de contables, versión inyectiva): si `#X ≤ ℵ₀`
entonces `#(⋃_N X^{N+1}) ≤ ℵ₀`. -/
theorem cardLe_sigma_nat {X : Type*} (hX : CardLe X ℕ) :
    CardLe (Σ N : ℕ, (Fin (N + 1) → X)) ℕ :=
  let ⟨c⟩ := hX
  ⟨⟨codSigma c, codSigma_injective c.injective⟩⟩

/-! ## (a) Sucesiones convergentes de enteros -/

/-- Definición 7 (`apuntes.typ`): `(a_n)` converge si existe `ℓ ∈ ℝ` tal que para todo `ε > 0`
hay `n₀` con `|a_n - ℓ| < ε` para `n ≥ n₀`. (Los enteros se miran dentro de `ℝ`.) -/
def Converge (a : ℕ → ℤ) : Prop :=
  ∃ ℓ : ℝ, ∀ ε : ℝ, 0 < ε → ∃ n₀ : ℕ, ∀ n, n₀ ≤ n → |(a n : ℝ) - ℓ| < ε

/-- La Definición 7 coincide con `Tendsto` de Mathlib (sólo para dejar constancia). -/
theorem converge_iff_tendsto (a : ℕ → ℤ) :
    Converge a ↔ ∃ ℓ : ℝ, Filter.Tendsto (fun n => (a n : ℝ)) Filter.atTop (nhds ℓ) := by
  simp only [Converge, Metric.tendsto_atTop, Real.dist_eq, gt_iff_lt, ge_iff_le]

/-- El conjunto del ítem (a). -/
def Conv : Set (ℕ → ℤ) := {a | Converge a}

/-- `(a_n)` es eventualmente constante: `a_n = a_N` para todo `n ≥ N`. -/
def EventualmenteConstante (a : ℕ → ℤ) : Prop := ∃ N, ∀ n, N ≤ n → a n = a N

/-- Lema (deducción propia): una sucesión de enteros convergente es eventualmente constante.
Con `ε = 1/2`, para `n ≥ n₀` vale `|a_n - a_{n₀}| ≤ |a_n - ℓ| + |ℓ - a_{n₀}| < 1`, y dos
enteros a distancia menor que `1` son iguales. -/
theorem eventualmenteConstante_of_converge {a : ℕ → ℤ} (h : Converge a) :
    EventualmenteConstante a := by
  obtain ⟨ℓ, hℓ⟩ := h
  obtain ⟨N, hN⟩ := hℓ (1 / 2) (by norm_num)
  refine ⟨N, fun n hn => ?_⟩
  have h1 := hN n hn
  have h2 := hN N le_rfl
  have h3 : |((a n : ℝ) - a N)| < 1 := by
    calc |((a n : ℝ) - a N)| = |((a n : ℝ) - ℓ) + (ℓ - a N)| := by ring_nf
      _ ≤ |((a n : ℝ) - ℓ)| + |ℓ - a N| := abs_add_le _ _
      _ < 1 / 2 + 1 / 2 := by rw [abs_sub_comm ℓ]; exact add_lt_add h1 h2
      _ = 1 := by norm_num
  have h4 : |a n - a N| < 1 := by
    have : ((|a n - a N| : ℤ) : ℝ) < 1 := by push_cast; exact h3
    exact_mod_cast this
  rcases abs_lt.1 h4 with ⟨h5, h6⟩
  omega

/-- Recíproca (trivial): una sucesión eventualmente constante converge (a su valor final). -/
theorem converge_of_eventualmenteConstante {a : ℕ → ℤ} (h : EventualmenteConstante a) :
    Converge a := by
  obtain ⟨N, hN⟩ := h
  refine ⟨a N, fun ε hε => ⟨N, fun n hn => ?_⟩⟩
  rw [hN n hn, sub_self, abs_zero]
  exact hε

/-- El menor índice a partir del cual la sucesión convergente `a` es constante (buen orden de `ℕ`;
la decidibilidad es clásica). -/
noncomputable def indice (a : Conv) : ℕ :=
  open Classical in Nat.find (eventualmenteConstante_of_converge a.2)

theorem indice_spec (a : Conv) : ∀ n, indice a ≤ n → a.1 n = a.1 (indice a) :=
  open Classical in Nat.find_spec (eventualmenteConstante_of_converge a.2)

/-- La inyección `Conv → ⋃_N ℤ^{N+1}`: `a ↦ (N, a_0, …, a_N)` con `N = indice a`. -/
noncomputable def codConv (a : Conv) : Σ N : ℕ, (Fin (N + 1) → ℤ) :=
  ⟨indice a, fun i => a.1 i⟩

/-- `codConv` es inyectiva: si `a` y `b` tienen el mismo `N` y coinciden en `0, …, N`, coinciden
en todo `n` (para `n > N` ambas valen lo que valen en `N`). -/
theorem codConv_injective : Function.Injective codConv := by
  intro a b h
  have ha := indice_spec a
  have hb := indice_spec b
  unfold codConv at h
  revert h ha hb
  generalize indice a = N
  generalize indice b = M
  intro h ha hb
  obtain ⟨rfl, h2⟩ := Sigma.mk.inj_iff.1 h
  have h3 := eq_of_heq h2
  have hval : ∀ i : ℕ, i ≤ N → a.1 i = b.1 i := fun i hi => by
    have := congrFun h3 ⟨i, by omega⟩
    simpa using this
  apply Subtype.ext
  funext n
  by_cases hn : n ≤ N
  · exact hval n hn
  · rw [ha n (by omega), hb n (by omega)]
    exact hval N le_rfl

/-- `#Conv ≤ ℵ₀`: componiendo `Conv ↪ ⋃_N ℤ^{N+1} ↪ ℕ`. -/
theorem cardLe_conv_nat : CardLe Conv ℕ :=
  cardLe_trans ⟨⟨codConv, codConv_injective⟩⟩ (cardLe_sigma_nat ⟨⟨codZ, codZ_injective⟩⟩)

/-- Las sucesiones constantes `k, k, k, …` (`k ∈ ℕ`) están en `Conv`. -/
def constConv (k : ℕ) : Conv :=
  ⟨fun _ => (k : ℤ), converge_of_eventualmenteConstante ⟨0, fun _ _ => rfl⟩⟩

theorem constConv_injective : Function.Injective constConv := by
  intro k l h
  have : (k : ℤ) = l := congrFun (congrArg Subtype.val h) 0
  exact_mod_cast this

/-- `Conv` es infinito: contiene una copia de `ℕ`. -/
theorem infinito_conv : Infinito Conv :=
  infinito_iff_infinite.2 (Infinite.of_injective constConv constConv_injective)

/-- **Ej. 16 (a).** `#{(a_n) ⊆ ℤ : (a_n) converge} = ℵ₀`. -/
theorem ej16a : Numerable Conv :=
  numerable_iff_contable_infinito.2
    ⟨contable_of_cardLe_numerable numerable_nat cardLe_conv_nat, infinito_conv⟩

/-! ## (b) Sucesiones periódicas de racionales -/

/-- `(a_n)` es periódica si existe `p ≥ 1` con `a_{n+p} = a_n` para todo `n`. -/
def Periodica (a : ℕ → ℚ) : Prop := ∃ p : ℕ, 1 ≤ p ∧ ∀ n, a (n + p) = a n

/-- El conjunto del ítem (b). -/
def Per : Set (ℕ → ℚ) := {a | Periodica a}

/-- Lema (deducción propia): dos sucesiones con el mismo período `p ≥ 1` que coinciden en
`0, …, p - 1` son iguales (se escribe `n = r + k p` con `r < p` e inducción en `k`). -/
theorem periodica_ext {a b : ℕ → ℚ} {p : ℕ} (hp : 1 ≤ p) (ha : ∀ n, a (n + p) = a n)
    (hb : ∀ n, b (n + p) = b n) (h : ∀ i, i < p → a i = b i) : a = b := by
  have key : ∀ (c : ℕ → ℚ), (∀ n, c (n + p) = c n) → ∀ k r, c (r + k * p) = c r := by
    intro c hc k
    induction k with
    | zero => intro r; simp
    | succ k ih =>
      intro r
      calc c (r + (k + 1) * p) = c ((r + k * p) + p) := by ring_nf
        _ = c (r + k * p) := hc _
        _ = c r := ih r
  funext n
  have hn : n = n % p + (n / p) * p := by
    have := Nat.mod_add_div n p
    rw [mul_comm] at this
    omega
  rw [hn, key a ha, key b hb]
  exact h _ (Nat.mod_lt _ hp)

/-- El menor período de `a ∈ Per` (buen orden de `ℕ`; decidibilidad clásica). -/
noncomputable def periodo (a : Per) : ℕ := open Classical in Nat.find a.2

theorem periodo_spec (a : Per) : 1 ≤ periodo a ∧ ∀ n, a.1 (n + periodo a) = a.1 n :=
  open Classical in Nat.find_spec a.2

/-- La inyección `Per → ⋃_N ℚ^{N+1}`: `a ↦ (p - 1, a_0, …, a_{p-1})` con `p = periodo a`. -/
noncomputable def codPer (a : Per) : Σ N : ℕ, (Fin (N + 1) → ℚ) :=
  ⟨periodo a - 1, fun i => a.1 i⟩

theorem codPer_injective : Function.Injective codPer := by
  intro a b h
  have ha := periodo_spec a
  have hb := periodo_spec b
  unfold codPer at h
  revert h ha hb
  generalize periodo a = p
  generalize periodo b = q
  intro h ha hb
  obtain ⟨hpq, h2⟩ := Sigma.mk.inj_iff.1 h
  have hpq' : p = q := by omega
  subst hpq'
  have h3 := eq_of_heq h2
  apply Subtype.ext
  refine periodica_ext ha.1 ha.2 hb.2 (fun i hi => ?_)
  have := congrFun h3 ⟨i, by omega⟩
  simpa using this

/-- `#ℚ ≤ ℵ₀` (de la Proposición "Numerabilidad de `ℚ`"). -/
theorem cardLe_rat_nat : CardLe ℚ ℕ :=
  cardLe_of_coordinables (coordinables_symm numerable_rat)

/-- `#Per ≤ ℵ₀`: componiendo `Per ↪ ⋃_N ℚ^{N+1} ↪ ℕ`. -/
theorem cardLe_per_nat : CardLe Per ℕ :=
  cardLe_trans ⟨⟨codPer, codPer_injective⟩⟩ (cardLe_sigma_nat cardLe_rat_nat)

/-- Las sucesiones constantes `k, k, k, …` (`k ∈ ℕ`) son periódicas de período `1`. -/
def constPer (k : ℕ) : Per := ⟨fun _ => (k : ℚ), 1, le_rfl, fun _ => rfl⟩

theorem constPer_injective : Function.Injective constPer := by
  intro k l h
  have : (k : ℚ) = l := congrFun (congrArg Subtype.val h) 0
  exact_mod_cast this

/-- `Per` es infinito: contiene una copia de `ℕ`. -/
theorem infinito_per : Infinito Per :=
  infinito_iff_infinite.2 (Infinite.of_injective constPer constPer_injective)

/-- **Ej. 16 (b).** `#{(a_n) ⊆ ℚ : (a_n) es periódica} = ℵ₀`. -/
theorem ej16b : Numerable Per :=
  numerable_iff_contable_infinito.2
    ⟨contable_of_cardLe_numerable numerable_nat cardLe_per_nat, infinito_per⟩

end Guias.Guia2.Ej16
