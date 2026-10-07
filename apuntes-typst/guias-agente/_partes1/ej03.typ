== Ejercicio 3

#enunciado[Ejercicio 3][
  Sea $A subset.eq RR$ no vacío y acotado inferiormente. Probar la siguiente equivalencia:
  $ i = op("ínf") A <=> cases(
    i <= a "para todo " a in A,,
    "para todo " epsilon > 0 "existe " a in A "tal que " i <= a < i + epsilon.
  ) $
]

#estrategia[Las dos implicaciones por el absurdo, desde la Definición 5][
  La Definición 5 dice que $i = op("ínf") A$ es (a) cota inferior y (b) mayor o igual que toda cota inferior. La primera condición del enunciado es (a) tal cual, así que lo que se intercambia es (b) por la condición con $epsilon$. Para $=>$, si para algún $epsilon$ no hubiera $a in A$ con $a < i + epsilon$, entonces $i + epsilon$ sería una cota inferior mayor que $i$. Para $arrow.l.double$, si $t > i$ fuera cota inferior, el $epsilon = t - i$ produce un $a in A$ con $a < t$. Es la demostración de la Proposición 5 (Equivalencia de Ínfimo), rehecha acá porque este ejercicio _es_ esa proposición.
]

#resolucion[Propuesta: vale la equivalencia][
  Sea $A subset.eq RR$ no vacío y acotado inferiormente, y sea $i in RR$. Llamemos
  - (I): $i <= a$ para todo $a in A$ (es decir, $i$ es cota inferior de $A$, Definición 4);
  - (II): para todo $epsilon > 0$ existe $a in A$ tal que $i <= a < i + epsilon$.

  Por la Definición 5, $i = op("ínf") A$ significa: (a) $i$ es cota inferior de $A$, y (b) si $t$ es cota inferior de $A$ entonces $t <= i$.

  *($=>$)* Supongamos $i = op("ínf") A$. La condición (I) es exactamente (a). Para (II), fijemos $epsilon > 0$ y supongamos, por el absurdo, que no existe $a in A$ con $i <= a < i + epsilon$. Como por (a) todo $a in A$ cumple $i <= a$, lo que falla es la segunda desigualdad: para todo $a in A$ no vale $a < i + epsilon$, es decir (tricotomía) $a >= i + epsilon$. Entonces $i + epsilon$ es cota inferior de $A$, y por (b) $i + epsilon <= i$, o sea $epsilon <= 0$, contra $epsilon > 0$. Luego existe $a in A$ con $i <= a < i + epsilon$.

  *($arrow.l.double$)* Supongamos (I) y (II). Por (I), $i$ es cota inferior de $A$: vale (a). Para (b), sea $t$ una cota inferior de $A$ y supongamos, por el absurdo, que $t > i$. Entonces $epsilon = t - i > 0$ y por (II) existe $a in A$ tal que
  $ a < i + epsilon = i + (t - i) = t. $
  Pero $t$ es cota inferior de $A$, así que $t <= a$; junto con $a < t$ esto es absurdo. Luego $t <= i$ para toda cota inferior $t$, que es (b). Por la Definición 5, $i = op("ínf") A$.
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej03`][
  `ej3 {A : Set ℝ} (_hne : A.Nonempty) (_hb : AcotadoInf A) {i : ℝ} : EsInf A i ↔ CotaInf A i ∧ ∀ ε > 0, ∃ a ∈ A, i ≤ a ∧ a < i + ε`. `EsInf` es la Definición 5 (`CotaInf A i ∧ ∀ t, CotaInf A t → t ≤ i`) y la prueba la despliega tal cual: en $=>$, `by_contra` + `push Not` convierte "no hay $a$ con $i <= a < i + epsilon$" en "todo $a in A$ con $i <= a$ cumple $i + epsilon <= a$", que con la cota inferior $i$ da `CotaInf A (i + ε)` y `linarith` cierra con (b); en $arrow.l.double$ se toma `ε = t - i`. No se usa la Proposición 5 (`equiv_inf`), que es literalmente este ejercicio, ni `esInf_iff_isGLB`. Las hipótesis "$A != nothing$" y "acotado inferiormente" son las del enunciado (dan sentido a $op("ínf") A$) pero el argumento no las necesita: por eso en Lean van con guión bajo (`_hne`, `_hb`).
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)
