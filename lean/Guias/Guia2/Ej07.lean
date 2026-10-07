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

Las pruebas viven en `Comun.Cardinales.Continuo` (`cardC_union`, `cardC_iUnion`, con
`coordinables_real_sum_real`, `cardLe_union_real`, `cardLe_real_union`, `sumaEmb`,
`cardLe_nat_prod_real`, `cardLe_iUnion_real`, `cardLe_real_iUnion`; la inyección de la unión en
`ℕ × ℝ` es `Comun.cardLe_iUnion_prod` de `Comun.Cardinales.Numerables`); acá sólo se las
re-enuncia.
-/
import Mathlib
import Comun.Cardinales
import Comun.Cardinales.Numerables
import Comun.Cardinales.Continuo

open Comun

namespace Guias.Guia2.Ej07

variable {X : Type*}

/-- **Ej. 7 (a).** Si `#A = c` y `#B = c`, entonces `#(A ∪ B) = c` (CSB con las dos
desigualdades; `Comun.cardC_union`). -/
theorem ej7a {A B : Set X} (hA : CardC A) (hB : CardC B) : CardC ↥(A ∪ B) :=
  cardC_union hA hB

section Union

variable (A : ℕ → Set X)

/-- **Ej. 7 (b).** Si `#A n = c` para todo `n`, entonces `#(⋃ n, A n) = c` (CSB con las dos
desigualdades; `Comun.cardC_iUnion`). -/
theorem ej7b (h : ∀ n, CardC (A n)) : CardC ↥(⋃ n, A n) :=
  cardC_iUnion A h

end Union

end Guias.Guia2.Ej07
