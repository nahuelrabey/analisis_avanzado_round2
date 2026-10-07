/-
Librería común `Comun`: definiciones del curso y resultados de `apuntes.typ` compartidos por las
guías (`Guias/`), los parciales (`Parciales/`) y los ejemplos (`Ejemplos/`). Ver
`apuntes-agente/lean-lemas-compartidos-y-organizacion.md` para el diseño.

`Comun.Metricas.C01`: el espacio `C([0, 1])` de las funciones continuas en `[0, 1]`
(`C01 = C(unitInterval, ℝ)`) con sus dos distancias del curso:
* `dC f g = máx_{t ∈ [0,1]} |f t - g t|` (la `d∞`), escrita como supremo `⨆` y con `dC_eq_max`
  (el supremo se alcanza: Weierstrass, `IsCompact.exists_isMaxOn`, la única entrada de
  compacidad). `esMetrica_dC` es el **Ej. 1 (e) de la Práctica 3**; `bola_dC` es la banda del
  dibujo (e); `dC_eq_dist` identifica `dC` con la distancia de Mathlib en `C(I, ℝ)`.
* `C01.d1 f g = ∫₀¹ |f - g|` (la `d₁` de los parciales), definida integrando la extensión
  `C01.ext f` de `f` a `ℝ` (constante fuera de `[0, 1]`), con `C01.d1_le_dist` (`d₁ ≤ d∞`) y la
  evaluación `C01.E f = f 0`. Este bloque va en el namespace `Comun.C01` para no chocar con la
  `d1` de `ℝⁿ` (`Comun.Metricas.Rn`).
-/
import Mathlib
import Comun.Metricas

namespace Comun

/-! ## `C([0, 1])` y la distancia del máximo `dC` -/

/-- `C([0, 1])`. -/
abbrev C01 := C(unitInterval, ℝ)

/-- `d∞(f, g) = máx_{t ∈ [0,1]} |f t - g t|`, escrito como supremo (es un máximo: `dC_eq_max`). -/
noncomputable def dC (f g : C01) : ℝ := ⨆ t, |f t - g t|

theorem continuous_absdiff (f g : C01) : Continuous fun t => |f t - g t| :=
  (f.continuous.sub g.continuous).abs

/-- Weierstrass (supuesto externo declarado en el texto): la función continua
`t ↦ |f t - g t|` alcanza su máximo en el compacto `[0, 1]`. Es la única entrada de
compacidad del archivo. -/
theorem exists_max (f g : C01) : ∃ t₀, ∀ t, |f t - g t| ≤ |f t₀ - g t₀| :=
  let ⟨t₀, _, ht₀⟩ := isCompact_univ.exists_isMaxOn Set.univ_nonempty
    (continuous_absdiff f g).continuousOn
  ⟨t₀, fun t => ht₀ (Set.mem_univ t)⟩

/-- El conjunto de valores `{|f t - g t|}` está acotado: por el máximo de `exists_max`. -/
theorem bdd_absdiff (f g : C01) : BddAbove (Set.range fun t => |f t - g t|) :=
  let ⟨t₀, ht₀⟩ := exists_max f g
  ⟨|f t₀ - g t₀|, by rintro _ ⟨t, rfl⟩; exact ht₀ t⟩

/-- El supremo es un máximo: `d∞(f, g) = |f t₀ - g t₀|` para un `t₀` donde se alcanza. -/
theorem dC_eq_max (f g : C01) : ∃ t₀, dC f g = |f t₀ - g t₀| ∧ ∀ t, |f t - g t| ≤ dC f g := by
  obtain ⟨t₀, ht₀⟩ := exists_max f g
  refine ⟨t₀, le_antisymm (ciSup_le ht₀) (le_ciSup (bdd_absdiff f g) t₀), fun t => ?_⟩
  exact le_ciSup (bdd_absdiff f g) t

theorem abs_le_dC (f g : C01) (t : unitInterval) : |f t - g t| ≤ dC f g :=
  le_ciSup (bdd_absdiff f g) t

/-- **Práctica 3, Ej. 1 (e).** `d∞` es una métrica en `C([0, 1])`; la demostración sigue el texto
de `guias-agente/guia_3_resuelta_agente.typ`. -/
theorem esMetrica_dC : EsMetrica dC where
  nonneg f g := Real.iSup_nonneg fun _ => abs_nonneg _
  eq_zero_iff f g := by
    constructor
    · intro h
      ext t
      have h1 : |f t - g t| ≤ 0 := h ▸ abs_le_dC f g t
      exact sub_eq_zero.1 (abs_nonpos_iff.1 h1)
    · intro h
      subst h
      unfold dC
      simp
  symm f g := by
    unfold dC
    exact congrArg _ (funext fun t => abs_sub_comm _ _)
  triangle f g h := by
    apply ciSup_le
    intro t
    calc |f t - h t| ≤ |f t - g t| + |g t - h t| := abs_sub_le _ _ _
      _ ≤ dC f g + dC g h := add_le_add (abs_le_dC f g t) (abs_le_dC g h t)

/-- Bola abierta de `d∞` en `C([0,1])` (dibujo (e)): la banda de semiancho `r` alrededor de `f`.
Aquí es esencial que el supremo sea un máximo (se alcanza). -/
theorem bola_dC (f : C01) (r : ℝ) :
    bola dC f r = {g | ∀ t, f t - r < g t ∧ g t < f t + r} := by
  ext g
  simp only [bola, Set.mem_ofPred_eq]
  constructor
  · intro h t
    have h1 : |f t - g t| < r := lt_of_le_of_lt (abs_le_dC f g t) h
    rw [abs_sub_lt_iff] at h1
    constructor <;> linarith [h1.1, h1.2]
  · intro h
    obtain ⟨t₀, ht₀, _⟩ := dC_eq_max f g
    rw [ht₀, abs_sub_lt_iff]
    obtain ⟨h1, h2⟩ := h t₀
    constructor <;> linarith

/-- Puente: `dC` es la distancia de Mathlib en `C(I, ℝ)` (la del supremo). -/
theorem dC_eq_dist (f g : C01) : dC f g = dist f g := by
  rw [ContinuousMap.dist_eq_iSup]
  unfold dC
  simp only [Real.dist_eq]

/-! ## La distancia integral `d₁` (parciales) -/

namespace C01

/-- Extiende `f : C(I, ℝ)` a `ℝ` (constante fuera de `[0, 1]`), para integrar en `ℝ`. -/
noncomputable def ext (f : C01) : ℝ → ℝ :=
  fun x => f (Set.projIcc 0 1 zero_le_one x)

theorem continuous_ext (f : C01) : Continuous (ext f) :=
  f.continuous.comp continuous_projIcc

theorem ext_of_mem (f : C01) {x : ℝ} (hx : x ∈ Set.Icc (0 : ℝ) 1) :
    ext f x = f ⟨x, hx⟩ := by
  simp [ext, Set.projIcc_of_mem zero_le_one hx]

/-- La distancia `d_1(f, g) = ∫_0^1 |f(x) - g(x)| dx`. -/
noncomputable def d1 (f g : C01) : ℝ :=
  ∫ x in (0 : ℝ)..1, |ext f x - ext g x|

/-- `d_1(f, g) ≤ d_∞(f, g)`: la bola de `d_∞` está dentro de la bola de `d_1`. -/
theorem d1_le_dist (f g : C01) : d1 f g ≤ dist f g := by
  unfold d1
  calc ∫ x in (0 : ℝ)..1, |ext f x - ext g x| ≤ ∫ _x in (0 : ℝ)..1, dist f g := by
        apply intervalIntegral.integral_mono_on zero_le_one
        · exact ((continuous_ext f).sub (continuous_ext g)).abs.intervalIntegrable _ _
        · exact intervalIntegrable_const
        · intro x hx
          rw [ext_of_mem f hx, ext_of_mem g hx, ← Real.dist_eq]
          exact ContinuousMap.dist_apply_le_dist _
    _ = dist f g := by simp

/-- La evaluación en `0`. -/
noncomputable def E (f : C01) : ℝ := f ⟨0, by norm_num⟩


/-- La métrica producto de `C([0,1]) × [0,1]` en Mathlib es `máx {d_∞(f, g), |x - y|}`
(1er parcial 2C 2025, Ej. 5). -/
theorem dist_prod_eq (p q : C(unitInterval, ℝ) × unitInterval) :
    dist p q = max (dist p.1 q.1) |(p.2 : ℝ) - q.2| := by
  rw [Prod.dist_eq, Subtype.dist_eq, Real.dist_eq]

end C01

end Comun
