/-
Análisis Avanzado (FCEN-UBA) · Primer recuperatorio · 08/07/2025
Enunciado transcripto en `apuntes-typst/parciales/2025_1c_recuperatorio_1.typ`.

Cada ejercicio tiene acá su enunciado formalizado y una demostración verificada por
Lean 4 + Mathlib. Las resoluciones "a mano" están en el archivo Typst.

Convención sobre índices: en el curso las sucesiones empiezan en `n = 1`; en Lean usamos
`ℕ = {0, 1, 2, ...}`. Ningún argumento depende de dónde empieza la numeración.

Qué usa de `Comun`: el conjunto suma `sumSet` con `sSup_sumSet`/`esSup_sumSet`
(`Comun.Supremos`; el Ej. 2 (a) es un alias), la distancia euclídea `d2` con `esMetrica_d2`,
`dinf_le_d2`, `d2_le_sqrt_n_dinf` y el puente `dinf_eq_dist` (`Comun.Metricas.Rn`), la
Definición 4.1 `EsMetrica` con `EsMetrica.max`, `EsMetrica.const_mul`, el constructor
`EsMetrica.toMetricSpace` y la transferencia de completitud `completeSpace_of_dist_le_of_le`
(`Comun.Metricas`), y el puente `cardC_iff_mk_eq_continuum` para el corolario `_curso`
(`Comun.Cardinales`). Quedan locales: `A`, `codif`, el contraejemplo `a2`/`b2`, el Ej. 3, la
métrica `d` del Ej. 4 con `Rd n` y el dibujo de la bola.
-/
import Mathlib
import Comun.Supremos
import Comun.Cardinales
import Comun.Metricas
import Comun.Metricas.Rn

open Cardinal Filter Topology Comun

namespace Recu1_1C2025

/-! ## Ejercicio 1

`A` = sucesiones de enteros con `a n ∣ a (n+1)` para todo `n`. Se prueba `#A = 𝔠`:
`A ⊆ ℤ^ℕ` da `#A ≤ 𝔠`, y la inyección `{0,1}^ℕ → A`, `b ↦ (2^(cantidad de unos entre
b_0, ..., b_{n-1}))_n`, da `𝔠 ≤ #A`. Se concluye por Cantor–Schröder–Bernstein. -/

/-- El conjunto `A` del Ejercicio 1. -/
def A : Set (ℕ → ℤ) := {a | ∀ n, a n ∣ a (n + 1)}

/-- `cuenta b n` = cantidad de `true` entre `b 0, ..., b (n-1)`. -/
def cuenta (b : ℕ → Bool) (n : ℕ) : ℕ := ∑ i ∈ Finset.range n, (if b i then 1 else 0)

theorem cuenta_succ (b : ℕ → Bool) (n : ℕ) :
    cuenta b (n + 1) = cuenta b n + (if b n then 1 else 0) := by
  unfold cuenta
  rw [Finset.sum_range_succ]

/-- La codificación `{0,1}^ℕ → A`: `codif b n = 2 ^ (cuenta b n)`. -/
def codif (b : ℕ → Bool) : ℕ → ℤ := fun n => ((2 ^ cuenta b n : ℕ) : ℤ)

theorem codif_mem (b : ℕ → Bool) : codif b ∈ A := by
  intro n
  simp only [codif]
  exact_mod_cast pow_dvd_pow 2 (by rw [cuenta_succ]; exact Nat.le_add_right _ _)

theorem codif_injective : Function.Injective codif := by
  intro b b' h
  -- de `codif b = codif b'` sale `cuenta b n = cuenta b' n` para todo `n` ...
  have hc : ∀ n, cuenta b n = cuenta b' n := by
    intro n
    have := congrFun h n
    simp only [codif, Nat.cast_inj] at this
    exact Nat.pow_right_injective le_rfl this
  -- ... y de ahí `b n = b' n` mirando el incremento `cuenta (n+1) - cuenta n`.
  funext n
  have h1 := hc (n + 1)
  rw [cuenta_succ, cuenta_succ, hc n] at h1
  by_cases hb : b n = true <;> by_cases hb' : b' n = true <;> simp [hb, hb'] at h1 ⊢

/-- **Ejercicio 1.** El cardinal de `A` es el del continuo. -/
theorem ej1 : #A = 𝔠 := by
  apply le_antisymm
  · -- `A ⊆ ℤ^ℕ` y `#(ℕ → ℤ) = ℵ₀ ^ ℵ₀ = 𝔠`.
    calc #A ≤ #(ℕ → ℤ) := Cardinal.mk_set_le A
      _ = 𝔠 := by
        rw [← Cardinal.power_def, Cardinal.mk_int, Cardinal.mk_nat, Cardinal.aleph0_power_aleph0]
  · -- `{0,1}^ℕ ↪ A` y `#(ℕ → Bool) = 2 ^ ℵ₀ = 𝔠`.
    have hinj : Function.Injective (fun b : ℕ → Bool => (⟨codif b, codif_mem b⟩ : A)) := by
      intro b b' h
      exact codif_injective (congrArg Subtype.val h)
    calc 𝔠 = #(ℕ → Bool) := by
          rw [← Cardinal.power_def, Cardinal.mk_bool, Cardinal.mk_nat, Cardinal.two_power_aleph0]
      _ ≤ #A := Cardinal.mk_le_of_injective hinj

theorem ej1' : #A = #ℝ := by rw [ej1, Cardinal.mk_real]

/-- **Ejercicio 1**, en el dialecto del curso: `#A = c` (Definición 3.8, `CardC`). -/
theorem ej1_curso : CardC A := cardC_iff_mk_eq_continuum.2 ej1

/-! ## Ejercicio 2

(a) `sup (A + B) = sup A + sup B` para `A, B` no vacíos y acotados: **verdadera**.
(b) `sup {a_n + b_n} = sup {a_n} + sup {b_n}` para sucesiones acotadas: **falsa**. -/

/-- **Ejercicio 2 (a).** (Alcanza con que `A` y `B` estén acotados superiormente.) El conjunto
suma es `Comun.sumSet` y la igualdad es `Comun.sSup_sumSet`: `sup A + sup B` es cota superior
de `A + B`, y para cada `ε > 0` hay `a ∈ A`, `b ∈ B` a menos de `ε/2` de los supremos. -/
theorem ej2a (A B : Set ℝ) (hA : A.Nonempty) (hA' : BddAbove A)
    (hB : B.Nonempty) (hB' : BddAbove B) :
    sSup (sumSet A B) = sSup A + sSup B :=
  sSup_sumSet A B hA hA' hB hB'

/-- **Ejercicio 2 (a)**, en el dialecto del curso: si `s = sup A` y `t = sup B` (Definición 2),
entonces `s + t = sup (A + B)` (`Comun.esSup_sumSet`). -/
theorem ej2a_curso {A B : Set ℝ} {s t : ℝ} (hs : EsSup A s) (ht : EsSup B t) :
    EsSup (sumSet A B) (s + t) :=
  esSup_sumSet hs ht

/-- Contraejemplo de 2 (b): `a = (1, 0, 0, ...)`, `b = (-1, 0, 0, ...)`. -/
def a2 : ℕ → ℝ := fun n => if n = 0 then 1 else 0
def b2 : ℕ → ℝ := fun n => if n = 0 then -1 else 0

theorem range_a2 : Set.range a2 = {1, 0} := by
  ext x
  simp only [Set.mem_range, a2, Set.mem_insert_iff, Set.mem_singleton_iff]
  constructor
  · rintro ⟨n, hn⟩; split_ifs at hn <;> simp [← hn]
  · rintro (rfl | rfl)
    · exact ⟨0, by simp⟩
    · exact ⟨1, by simp⟩

theorem range_b2 : Set.range b2 = {-1, 0} := by
  ext x
  simp only [Set.mem_range, b2, Set.mem_insert_iff, Set.mem_singleton_iff]
  constructor
  · rintro ⟨n, hn⟩; split_ifs at hn <;> simp [← hn]
  · rintro (rfl | rfl)
    · exact ⟨0, by simp⟩
    · exact ⟨1, by simp⟩

theorem sum_a2_b2 : (fun n => a2 n + b2 n) = fun _ => 0 := by
  funext n; simp only [a2, b2]; split_ifs <;> norm_num

/-- **Ejercicio 2 (b).** Hay sucesiones acotadas con
`sup {a_n + b_n} ≠ sup {a_n} + sup {b_n}`. -/
theorem ej2b : ∃ a b : ℕ → ℝ, BddAbove (Set.range a) ∧ BddBelow (Set.range a) ∧
    BddAbove (Set.range b) ∧ BddBelow (Set.range b) ∧
    sSup (Set.range (fun n => a n + b n)) ≠ sSup (Set.range a) + sSup (Set.range b) := by
  refine ⟨a2, b2, ?_, ?_, ?_, ?_, ?_⟩
  · rw [range_a2]; exact Set.Finite.bddAbove (by simp)
  · rw [range_a2]; exact Set.Finite.bddBelow (by simp)
  · rw [range_b2]; exact Set.Finite.bddAbove (by simp)
  · rw [range_b2]; exact Set.Finite.bddBelow (by simp)
  · rw [sum_a2_b2, range_a2, range_b2, Set.range_const, csSup_singleton, csSup_pair, csSup_pair]
    norm_num

/-! ## Ejercicio 3

`X` denso en `E` y `U` abierto ⇒ `cl (X ∩ U) = cl U`. -/

/-- **Ejercicio 3.** -/
theorem ej3 {E : Type*} [MetricSpace E] (X : Set E) (hX : closure X = Set.univ)
    (U : Set E) (hU : IsOpen U) : closure (X ∩ U) = closure U := by
  apply subset_antisymm
  · -- `X ∩ U ⊆ U` y la clausura es monótona.
    exact closure_mono Set.inter_subset_right
  · -- `U ⊆ cl (X ∩ U)`: todo punto de `U` está en `U ∩ cl X ⊆ cl (U ∩ X)` (`U` abierto).
    have h : U ⊆ closure (X ∩ U) := by
      intro x hx
      have hx' : x ∈ U ∩ closure X := ⟨hx, by rw [hX]; trivial⟩
      have := hU.inter_closure hx'
      rwa [Set.inter_comm] at this
    exact closure_minimal h isClosed_closure

/-! ## Ejercicio 4

`d(x, y) = máx {4/3 d_∞(x, y), d_2(x, y)}` en `ℝⁿ`.

En Mathlib, `Fin n → ℝ` lleva la métrica `d_∞` (`dist x y = máx |x i - y i|`); `d_2` es la
`Comun.d2` de la Práctica 3 (`d2_eq_dist_euclidean` la identifica con la distancia de
`EuclideanSpace ℝ (Fin n)`). Definimos `d` como en el enunciado.

(a) `d` es una métrica.
(b) `B_d(0, 1) = B_{d_∞}(0, 3/4) ∩ B_{d_2}(0, 1)` (un cuadrado con las esquinas recortadas).
(c) `d_2 ≤ d ≤ 4/3 d_2` y `d_∞ ≤ d ≤ (4/3)√n d_∞`; `(ℝⁿ, d)` es completo. -/

variable {n : ℕ}

/-- La distancia euclídea `d_2` en `ℝⁿ = Fin n → ℝ` es `Comun.d2`, por definición la fórmula
`√(∑ (xᵢ - yᵢ)²)`. -/
theorem d2_eq (x y : Fin n → ℝ) : d2 x y = Real.sqrt (∑ i, (x i - y i) ^ 2) := rfl

/-- La distancia `d` del Ejercicio 4. `dist x y` es `d_∞(x, y)`. -/
noncomputable def d (x y : Fin n → ℝ) : ℝ := max (4 / 3 * dist x y) (d2 x y)

/-- **Ejercicio 4 (a).** `d` es una métrica (Definición 4.1): es el máximo de dos métricas,
`4/3 · d_∞` (`Comun.EsMetrica.const_mul` de la métrica de Mathlib) y `d_2`
(`Comun.esMetrica_d2`, Práctica 3, Ej. 1 (b)), y `Comun.EsMetrica.max`. -/
theorem esMetrica_d : EsMetrica (d (n := n)) :=
  ((esMetrica_dist (Fin n → ℝ)).const_mul (by norm_num : (0 : ℝ) < 4 / 3)).max (esMetrica_d2 n)

/-- **Ejercicio 4 (a).** Los cuatro axiomas de métrica para `d`, uno por uno. -/
theorem d_nonneg (x y : Fin n → ℝ) : 0 ≤ d x y := esMetrica_d.nonneg x y

theorem d_eq_zero_iff (x y : Fin n → ℝ) : d x y = 0 ↔ x = y := esMetrica_d.eq_zero_iff x y

theorem d_self (x : Fin n → ℝ) : d x x = 0 := (d_eq_zero_iff x x).2 rfl

theorem d_comm (x y : Fin n → ℝ) : d x y = d y x := esMetrica_d.symm x y

theorem d_triangle (x y z : Fin n → ℝ) : d x z ≤ d x y + d y z := esMetrica_d.triangle x y z

/-- `ℝⁿ` con la métrica `d` (sinónimo de tipo de `Fin n → ℝ`). -/
def Rd (n : ℕ) : Type := Fin n → ℝ

/-- Pasar de `(ℝⁿ, d_∞)` a `(ℝⁿ, d)`: es la identidad. -/
def toRd (x : Fin n → ℝ) : Rd n := x
/-- Pasar de `(ℝⁿ, d)` a `(ℝⁿ, d_∞)`: es la identidad. -/
def ofRd (x : Rd n) : Fin n → ℝ := x

/-- **Ejercicio 4 (a).** `(ℝⁿ, d)` es un espacio métrico (`Comun.EsMetrica.toMetricSpace`). -/
noncomputable instance : MetricSpace (Rd n) :=
  show MetricSpace (Con (Fin n → ℝ) d) from esMetrica_d.toMetricSpace

theorem Rd.dist_eq (x y : Rd n) : dist x y = d (ofRd x) (ofRd y) := rfl

/-! ### Las desigualdades de (c) -/

/-- `d_∞ ≤ d_2` (`Comun.dinf_le_d2` con el puente `dinf_eq_dist`; si `n = 0` las dos valen `0`). -/
theorem dist_le_d2 (x y : Fin n → ℝ) : dist x y ≤ d2 x y := by
  cases n with
  | zero => rw [Subsingleton.elim x y, dist_self]; exact (esMetrica_d2 0).nonneg y y
  | succ n => rw [← dinf_eq_dist]; exact dinf_le_d2 x y

/-- `d_2 ≤ √n · d_∞` (`Comun.d2_le_sqrt_n_dinf`; si `n = 0` las dos valen `0`). -/
theorem d2_le_sqrt_mul_dist (x y : Fin n → ℝ) : d2 x y ≤ Real.sqrt n * dist x y := by
  cases n with
  | zero => rw [Subsingleton.elim x y, ((esMetrica_d2 0).eq_zero_iff y y).2 rfl, dist_self, mul_zero]
  | succ n => rw [← dinf_eq_dist]; exact d2_le_sqrt_n_dinf x y

/-- `d_2 ≤ d`. -/
theorem d2_le_d (x y : Fin n → ℝ) : d2 x y ≤ d x y := le_max_right _ _

/-- `d ≤ 4/3 · d_2`. -/
theorem d_le_d2 (x y : Fin n → ℝ) : d x y ≤ 4 / 3 * d2 x y := by
  apply max_le
  · gcongr; exact dist_le_d2 x y
  · linarith [(esMetrica_d2 n).nonneg x y]

/-- `d_∞ ≤ d`. -/
theorem dist_le_d (x y : Fin n → ℝ) : dist x y ≤ d x y :=
  (dist_le_d2 x y).trans (d2_le_d x y)

/-- `d ≤ (4/3) √n · d_∞`. -/
theorem d_le_dist (x y : Fin n → ℝ) : d x y ≤ 4 / 3 * Real.sqrt n * dist x y := by
  calc d x y ≤ 4 / 3 * d2 x y := d_le_d2 x y
    _ ≤ 4 / 3 * (Real.sqrt n * dist x y) := by gcongr; exact d2_le_sqrt_mul_dist x y
    _ = 4 / 3 * Real.sqrt n * dist x y := by ring

/-- **Ejercicio 4 (c), equivalencia.** La identidad `(ℝⁿ, d_∞) → (ℝⁿ, d)` es Lipschitz ... -/
theorem lipschitz_toRd :
    LipschitzWith (Real.toNNReal (4 / 3 * Real.sqrt n)) (toRd : (Fin n → ℝ) → Rd n) := by
  apply LipschitzWith.of_dist_le_mul
  intro x y
  rw [Real.coe_toNNReal _ (by positivity)]
  exact d_le_dist x y

/-- ... y su inversa `(ℝⁿ, d) → (ℝⁿ, d_∞)` también. En particular `d` y `d_∞` (y por lo tanto
también `d_2`, que es equivalente a `d_∞`) tienen los mismos abiertos, las mismas sucesiones
convergentes y las mismas sucesiones de Cauchy. -/
theorem lipschitz_ofRd : LipschitzWith 1 (ofRd : Rd n → Fin n → ℝ) := by
  apply LipschitzWith.of_dist_le_mul
  intro x y
  rw [NNReal.coe_one, one_mul, Rd.dist_eq]
  exact dist_le_d _ _

/-- Las dos métricas son uniformemente equivalentes: la identidad es un
isomorfismo uniforme `(ℝⁿ, d_∞) ≃ᵤ (ℝⁿ, d)`. -/
noncomputable def uniformEquivRd : (Fin n → ℝ) ≃ᵤ Rd n where
  toFun := toRd
  invFun := ofRd
  left_inv _ := rfl
  right_inv _ := rfl
  uniformContinuous_toFun := lipschitz_toRd.uniformContinuous
  uniformContinuous_invFun := lipschitz_ofRd.uniformContinuous

/-- **Ejercicio 4 (c), completitud.** `(ℝⁿ, d)` es completo: toda sucesión de Cauchy para `d`
lo es para `d_∞` (`d_∞ ≤ d`), converge para `d_∞` (que es completa) y entonces converge para `d`
(`d ≤ (4/3)√n · d_∞`). Es `Comun.completeSpace_of_dist_le_of_le` con la identidad
`toRd`/`ofRd`. -/
instance : CompleteSpace (Rd n) :=
  completeSpace_of_dist_le_of_le toRd ofRd (fun _ => rfl) (c := 1) (C := 4 / 3 * Real.sqrt n)
    (fun x y => by rw [one_mul, Rd.dist_eq]; exact dist_le_d _ _) (fun x y => d_le_dist x y)

/-- Misma conclusión vía el isomorfismo uniforme. -/
example : CompleteSpace (Rd n) := uniformEquivRd.completeSpace_iff.1 inferInstance

/-! ### El dibujo de (b): `B_d((0,0), 1)` en `ℝ²` -/

/-- **Ejercicio 4 (b).** La bola unitaria de `d` en `ℝ²` es el cuadrado abierto de lado `3/2`
intersecado con el disco abierto de radio `1`:
`B_d(0, 1) = {(x, y) : |x| < 3/4, |y| < 3/4, x² + y² < 1}`. -/
theorem ball_eq :
    Metric.ball (toRd (0 : Fin 2 → ℝ)) 1 =
      {p : Rd 2 | |ofRd p 0| < 3 / 4 ∧ |ofRd p 1| < 3 / 4 ∧ ofRd p 0 ^ 2 + ofRd p 1 ^ 2 < 1} := by
  ext p
  simp only [Metric.mem_ball, Rd.dist_eq, Set.mem_ofPred_eq, d, max_lt_iff]
  have hinf : 4 / 3 * dist (ofRd p) (ofRd (toRd 0)) < 1 ↔ |ofRd p 0| < 3 / 4 ∧ |ofRd p 1| < 3 / 4 := by
    rw [show (4 / 3 * dist (ofRd p) (ofRd (toRd 0)) < 1) ↔ dist (ofRd p) (ofRd (toRd 0)) < 3 / 4 by
      constructor <;> intro h <;> linarith]
    rw [dist_pi_lt_iff (by norm_num), Fin.forall_fin_two]
    simp [ofRd, toRd]
  have h2 : d2 (ofRd p) (ofRd (toRd 0)) < 1 ↔ ofRd p 0 ^ 2 + ofRd p 1 ^ 2 < 1 := by
    rw [d2_eq, Real.sqrt_lt' one_pos, one_pow, Fin.sum_univ_two]
    simp [ofRd, toRd]
  rw [hinf, h2, and_assoc]

/-- El vértice `(3/4, 3/4)` del cuadrado queda afuera de la bola (está a distancia `d_2` igual a
`3√2/4 > 1`): la bola es el cuadrado *con las esquinas recortadas*. -/
theorem vertice_notMem : toRd ![3 / 4, 3 / 4] ∉ Metric.ball (toRd (0 : Fin 2 → ℝ)) 1 := by
  rw [ball_eq]
  rintro ⟨-, -, h3⟩
  norm_num [ofRd, toRd] at h3

/-- El punto `(9/10, 0)` del disco queda afuera de la bola: la bola *no* es el disco entero. -/
theorem punto_disco_notMem : toRd ![9 / 10, 0] ∉ Metric.ball (toRd (0 : Fin 2 → ℝ)) 1 := by
  rw [ball_eq]
  rintro ⟨h1, -, -⟩
  norm_num [ofRd, toRd, abs_lt] at h1

/-- El punto `(7/10, 7/10)` está en la bola: la bola llega a tocar los lados del cuadrado. -/
theorem punto_mem : toRd ![7 / 10, 7 / 10] ∈ Metric.ball (toRd (0 : Fin 2 → ℝ)) 1 := by
  rw [ball_eq]
  refine ⟨?_, ?_, ?_⟩ <;> norm_num [ofRd, toRd, abs_lt]

end Recu1_1C2025
