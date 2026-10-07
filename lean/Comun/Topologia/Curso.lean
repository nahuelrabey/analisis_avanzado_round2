/-
Librería común `Comun`: definiciones del curso y resultados de `apuntes.typ` compartidos por las
guías (`Guias/`), los parciales (`Parciales/`) y los ejemplos (`Ejemplos/`). Ver
`apuntes-agente/lean-lemas-compartidos-y-organizacion.md` para el diseño.

`Comun.Topologia.Curso`: las nociones topológicas del curso definidas con bolas, tal cual
`apuntes.typ`, en un espacio métrico `E` cualquiera: interior (`interiorCurso`, Def. 4.11),
abierto (`AbiertoCurso`, Def. 4.14), clausura (`clausuraCurso`, Def. 4.22), cerrado
(`CerradoCurso`, Def. 4.27), punto de acumulación y conjunto derivado (`acumulacion`,
`derivadoCurso`, Def. 4.33), y `∂S = S̄ ∖ S°` para la frontera `fronteraCurso` de
`Comun.Topologia` (`fronteraCurso_eq`). Con ellas, los Ejercicios 3 y 8 de la Práctica 3 calculan
interior, clausura, derivado y frontera de subconjuntos de `ℝ` "a mano".

El puente con Mathlib (`interior_eq_interiorCurso`, `closure_eq_clausuraCurso`,
`isOpen_iff_abiertoCurso`, `isClosed_iff_cerradoCurso`, `frontier_eq_fronteraCurso`) se prueba
sólo con las caracterizaciones por bolas `Comun.mem_interior_iff_ball` y
`Comun.mem_closure_iff_ball`, nunca con los cálculos concretos de los ejercicios.

Al final hay una sección para `ℝ`: las reescrituras con intervalos (`mem_interiorCurso_real`,
`mem_clausuraCurso_real`, `mem_derivadoCurso_real`) y los lemas sobre intervalos y racionales
(`clausuraCurso_sub_Icc`, `interiorCurso_sub_Ioo`, `Ioo_sub_interiorCurso`,
`interiorCurso_vacio_of_racional`) que usan los Ej. 3 y 8.
-/
import Mathlib
import Comun.Topologia
import Comun.Topologia.Real

namespace Comun

section General

variable {E : Type*} [MetricSpace E]

/-! ## Nociones del curso, definidas con bolas -/

/-- Definición 4.11: `x` es *punto interior* de `S` si `x ∈ S` y existe `r > 0` con
`B(x, r) ⊆ S`. El *interior* es el conjunto de todos ellos. -/
def interiorCurso (S : Set E) : Set E := {x | x ∈ S ∧ ∃ r > 0, Metric.ball x r ⊆ S}

/-- Definición 4.22: `x` es *punto de adherencia* de `S` si para todo `r > 0` se tiene
`B(x, r) ∩ S ≠ ∅`. La *clausura* es el conjunto de todos ellos. -/
def clausuraCurso (S : Set E) : Set E := {x | ∀ r > 0, (Metric.ball x r ∩ S).Nonempty}

/-- Definición 4.14: `S` es *abierto* si `S = S°`. -/
def AbiertoCurso (S : Set E) : Prop := interiorCurso S = S

/-- Definición 4.27: `S` es *cerrado* si `S̄ = S`. -/
def CerradoCurso (S : Set E) : Prop := clausuraCurso S = S

/-- Definición 4.33: `x` es *punto de acumulación* de `S` si para todo `r > 0` existe
`y ∈ B(x, r) ∩ S` con `y ≠ x`. -/
def acumulacion (S : Set E) (x : E) : Prop :=
  ∀ r > 0, ∃ y ∈ Metric.ball x r ∩ S, y ≠ x

/-- Definición 4.33: el *conjunto derivado* `S'` es el de los puntos de acumulación. -/
def derivadoCurso (S : Set E) : Set E := {x | acumulacion S x}

theorem mem_interiorCurso {S : Set E} {x : E} :
    x ∈ interiorCurso S ↔ x ∈ S ∧ ∃ r > 0, Metric.ball x r ⊆ S := Iff.rfl

theorem mem_clausuraCurso {S : Set E} {x : E} :
    x ∈ clausuraCurso S ↔ ∀ r > 0, (Metric.ball x r ∩ S).Nonempty := Iff.rfl

theorem mem_derivadoCurso {S : Set E} {x : E} :
    x ∈ derivadoCurso S ↔ ∀ r > 0, ∃ y ∈ Metric.ball x r ∩ S, y ≠ x := Iff.rfl

/-! ## Puente con Mathlib

Las nociones del curso coinciden con `interior`, `closure`, `IsOpen`, `IsClosed` y `frontier` de
Mathlib. Se prueban con las caracterizaciones por bolas de `Comun.Topologia`. -/

theorem interior_eq_interiorCurso (S : Set E) : interior S = interiorCurso S := by
  ext x
  rw [mem_interior_iff_ball, mem_interiorCurso]
  constructor
  · rintro ⟨r, hr, h⟩
    exact ⟨h (Metric.mem_ball_self hr), r, hr, h⟩
  · rintro ⟨_, r, hr, h⟩
    exact ⟨r, hr, h⟩

theorem closure_eq_clausuraCurso (S : Set E) : closure S = clausuraCurso S := by
  ext x
  exact mem_closure_iff_ball

theorem isOpen_iff_abiertoCurso (S : Set E) : IsOpen S ↔ AbiertoCurso S := by
  unfold AbiertoCurso
  rw [← interior_eq_interiorCurso, interior_eq_iff_isOpen]

theorem isClosed_iff_cerradoCurso (S : Set E) : IsClosed S ↔ CerradoCurso S := by
  unfold CerradoCurso
  rw [← closure_eq_clausuraCurso, closure_eq_iff_isClosed]

/-! ## Propiedades elementales -/

/-- Observación 4.12: `S° ⊆ S`. -/
theorem interiorCurso_subset (S : Set E) : interiorCurso S ⊆ S := fun _ h => h.1

/-- Observación 4.23 (a): `S ⊆ S̄`. -/
theorem subset_clausuraCurso (S : Set E) : S ⊆ clausuraCurso S := by
  rw [← closure_eq_clausuraCurso]
  exact subset_closure_ball S

/-- Si `S ⊆ T` entonces `S̄ ⊆ T̄`. -/
theorem clausuraCurso_mono {S T : Set E} (h : S ⊆ T) : clausuraCurso S ⊆ clausuraCurso T := by
  rw [← closure_eq_clausuraCurso, ← closure_eq_clausuraCurso]
  exact closure_mono_ball h

/-- Para refutar "abierto": basta un punto de `S` que no es interior. -/
theorem not_abierto_of {S : Set E} {x : E} (hx : x ∈ S) (hn : x ∉ interiorCurso S) :
    ¬ AbiertoCurso S := by
  intro h
  apply hn
  unfold AbiertoCurso at h
  rw [h]
  exact hx

/-- Para refutar "cerrado": basta un punto de adherencia que no está en `S`. -/
theorem not_cerrado_of {S : Set E} {x : E} (hx : x ∈ clausuraCurso S) (hn : x ∉ S) :
    ¬ CerradoCurso S := by
  intro h
  apply hn
  unfold CerradoCurso at h
  rw [← h]
  exact hx

/-- `S' ⊆ S̄`: un punto de acumulación es de adherencia. -/
theorem derivadoCurso_sub_clausura (S : Set E) : derivadoCurso S ⊆ clausuraCurso S := by
  intro x hx r hr
  obtain ⟨y, hy, _⟩ := hx r hr
  exact ⟨y, hy⟩

/-- Si `S ⊆ T` entonces `S' ⊆ T'`. -/
theorem derivadoCurso_mono {S T : Set E} (h : S ⊆ T) : derivadoCurso S ⊆ derivadoCurso T := by
  intro x hx r hr
  obtain ⟨y, ⟨hy1, hy2⟩, hyx⟩ := hx r hr
  exact ⟨y, ⟨hy1, h hy2⟩, hyx⟩

/-! ## Frontera -/

/-- `∂S = S̄ ∖ S°` (se deduce directo de las definiciones 4.38, 4.22 y 4.11): que ninguna bola
centrada en `x` esté contenida en `S` equivale a que todas intersequen a `Sᶜ`. -/
theorem fronteraCurso_eq (S : Set E) : fronteraCurso S = clausuraCurso S \ interiorCurso S := by
  ext x
  constructor
  · intro h
    refine ⟨fun r hr => (h r hr).1, ?_⟩
    rintro ⟨_, r, hr, hsub⟩
    obtain ⟨y, hyb, hyc⟩ := (h r hr).2
    exact hyc (hsub hyb)
  · rintro ⟨hc, hi⟩ r hr
    refine ⟨hc r hr, ?_⟩
    by_contra hemp
    have hsub : Metric.ball x r ⊆ S := by
      intro y hy
      by_contra hyS
      exact hemp ⟨y, hy, hyS⟩
    exact hi ⟨hsub (Metric.mem_ball_self hr), r, hr, hsub⟩

/-- Puente con la frontera de Mathlib (`frontier S = cl S ∖ S°` por definición). -/
theorem frontier_eq_fronteraCurso (S : Set E) : frontier S = fronteraCurso S := by
  rw [fronteraCurso_eq, ← interior_eq_interiorCurso, ← closure_eq_clausuraCurso]
  rfl

end General

/-! ## En `ℝ`: reescrituras con intervalos y lemas sobre intervalos -/

section Real

/-- Reescritura de la clausura con intervalos. -/
theorem mem_clausuraCurso_real {S : Set ℝ} {x : ℝ} :
    x ∈ clausuraCurso S ↔ ∀ r > 0, ∃ y ∈ S, x - r < y ∧ y < x + r := by
  constructor
  · intro h r hr
    obtain ⟨y, hyb, hyS⟩ := h r hr
    exact ⟨y, hyS, mem_ball_iff.1 hyb⟩
  · intro h r hr
    obtain ⟨y, hyS, hy⟩ := h r hr
    exact ⟨y, mem_ball_iff.2 hy, hyS⟩

/-- Reescritura del interior con intervalos. -/
theorem mem_interiorCurso_real {S : Set ℝ} {x : ℝ} :
    x ∈ interiorCurso S ↔ x ∈ S ∧ ∃ r > 0, ∀ y, x - r < y → y < x + r → y ∈ S := by
  constructor
  · rintro ⟨hx, r, hr, h⟩
    exact ⟨hx, r, hr, fun y h1 h2 => h (mem_ball_iff.2 ⟨h1, h2⟩)⟩
  · rintro ⟨hx, r, hr, h⟩
    exact ⟨hx, r, hr, fun y hy => h y (mem_ball_iff.1 hy).1 (mem_ball_iff.1 hy).2⟩

/-- Reescritura del conjunto derivado con intervalos. -/
theorem mem_derivadoCurso_real {S : Set ℝ} {x : ℝ} :
    x ∈ derivadoCurso S ↔ ∀ r > 0, ∃ y ∈ S, y ≠ x ∧ x - r < y ∧ y < x + r := by
  constructor
  · intro h r hr
    obtain ⟨y, ⟨hyb, hyS⟩, hyx⟩ := h r hr
    exact ⟨y, hyS, hyx, mem_ball_iff.1 hyb⟩
  · intro h r hr
    obtain ⟨y, hyS, hyx, hy⟩ := h r hr
    exact ⟨y, ⟨mem_ball_iff.2 hy, hyS⟩, hyx⟩

/-- Un conjunto contenido en `[a, b]` tiene la clausura contenida en `[a, b]`. -/
theorem clausuraCurso_sub_Icc {S : Set ℝ} {a b : ℝ} (h : S ⊆ Set.Icc a b) :
    clausuraCurso S ⊆ Set.Icc a b := by
  intro x hx
  rw [mem_clausuraCurso_real] at hx
  constructor
  · by_contra hxa
    have hxa' : x < a := not_le.1 hxa
    obtain ⟨y, hyS, _, hy2⟩ := hx (a - x) (by linarith)
    have := (h hyS).1
    linarith
  · by_contra hxb
    have hxb' : b < x := not_le.1 hxb
    obtain ⟨y, hyS, hy1, _⟩ := hx (x - b) (by linarith)
    have := (h hyS).2
    linarith

/-- Un conjunto contenido en `[a, b]` tiene el interior contenido en `(a, b)`: si
`B(x, r) ⊆ S ⊆ [a, b]`, los puntos `x ± r/2` están en `[a, b]`. -/
theorem interiorCurso_sub_Ioo {S : Set ℝ} {a b : ℝ} (h : S ⊆ Set.Icc a b) :
    interiorCurso S ⊆ Set.Ioo a b := by
  intro x hx
  rw [mem_interiorCurso_real] at hx
  obtain ⟨_, r, hr, hball⟩ := hx
  have h1 := (h (hball (x - r / 2) (by linarith) (by linarith))).1
  have h2 := (h (hball (x + r / 2) (by linarith) (by linarith))).2
  exact ⟨by linarith, by linarith⟩

/-- Un intervalo abierto contenido en `S` está contenido en `S°`: para `x ∈ (a, b)` sirve
`r = mín{x - a, b - x}`. -/
theorem Ioo_sub_interiorCurso {S : Set ℝ} {a b : ℝ} (h : Set.Ioo a b ⊆ S) :
    Set.Ioo a b ⊆ interiorCurso S := by
  intro x hx
  rw [mem_interiorCurso_real]
  refine ⟨h hx, min (x - a) (b - x), lt_min (by linarith [hx.1]) (by linarith [hx.2]), ?_⟩
  intro y hy1 hy2
  have h1 := min_le_left (x - a) (b - x)
  have h2 := min_le_right (x - a) (b - x)
  exact h ⟨by linarith, by linarith⟩

/-- Un conjunto formado sólo por racionales tiene interior vacío,
porque toda bola `(x - r, x + r)` contiene un irracional (Práctica 1, Ej. 2 (d)). -/
theorem interiorCurso_vacio_of_racional {S : Set ℝ} (hS : S ⊆ Q) : interiorCurso S = ∅ := by
  ext x
  simp only [Set.mem_empty_iff_false, iff_false]
  intro hx
  rw [mem_interiorCurso_real] at hx
  obtain ⟨_, r, hr, h⟩ := hx
  obtain ⟨z, hz, hz1, hz2⟩ := exists_irrational_btwn (show x - r < x + r by linarith)
  exact hz (hS (h z hz1 hz2))

end Real

end Comun
