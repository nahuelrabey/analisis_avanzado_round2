#import "@preview/frame-it:2.0.0": *
#import "../utils.typ": *
#show figure.where(kind: "frame"): set figure(numbering: none)
#show figure.where(kind: "frame"): set block(breakable: true)
#show: frame-style(styles.boxy)

#show grid.cell: it => {
  if it.fill != none {
    set text(fill: white, weight: "bold", style: "italic")
    it
  } else {
    it
  }
}

// Fuente: `parciales/primer_parcial_2c2025.jpg` (foto del enunciado).
// La fuente no trae resolución. Después del enunciado: resoluciones propuestas de los cinco
// ejercicios, cada una verificada formalmente en `lean/Parciales/Parcial1_2C2025.lean`.

#align(center)[
  #text(14pt, weight: "bold")[Análisis Avanzado - Segundo cuatrimestre 2025] \
  #v(2pt)
  #text(12pt, weight: "medium")[Primer parcial - 16/10/25]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

*Ejercicio 1.* Calcular, si existen, el supremo y el ínfimo de
$ A = {m / (m + n) : m in NN, n in NN}. $

#line(length: 100%, stroke: 0.4pt)

*Ejercicio 2.* Calcular el cardinal de
$ A = {(a_n)_(n in NN) subset.eq QQ : exists k in NN "tal que" a_(n+k) = (a_k)^n space forall n in NN}. $

#line(length: 100%, stroke: 0.4pt)

*Ejercicio 3.* Sea $(E, d)$ un espacio métrico. Probar que dados $x, y in E$ con $x != y$ existen dos abiertos $U, V$ tales que $x in U$, $y in V$ y $overline(U) inter overline(V) = emptyset$.

#line(length: 100%, stroke: 0.4pt)

*Ejercicio 4.* Sea $(E, d)$ un espacio métrico. Recordemos que para $A, B subset.eq E$ no vacíos se define
$ tilde(d)(A, B) = op("ínf"){d(a, b) : a in A, b in B}. $
Sea $(M_n)_(n in NN) subset.eq E$ una familia de conjuntos no vacíos.

#set enum(numbering: "a)")
+ Probar que
  $ union.big_(n in NN) overline(M_n) subset.eq overline(union.big_(n in NN) M_n). $

+ Supongamos que existe $epsilon > 0$ tal que $tilde(d)(M_n, M_m) > epsilon$ para todo $n != m$. Probar que
  $ overline(union.big_(n in NN) M_n) = union.big_(n in NN) overline(M_n). $

#line(length: 100%, stroke: 0.4pt)

*Ejercicio 5.* Sea $C([0, 1]) = {f : [0, 1] -> RR : f "es continua"}$ visto como espacio métrico con la métrica $d_oo$. Definimos una métrica en $C([0, 1]) times [0, 1]$ mediante
$ d((f, x), (g, y)) := op("máx"){d_oo (f, g), abs(x - y)}. $
Sea $F : C([0, 1]) times [0, 1] -> RR$ la función definida como $F(f, x) = f(x)$. Probar que $F$ es continua.

#v(8pt)
#line(length: 100%, stroke: 0.7pt)
#v(6pt)

#align(center)[
  #text(10pt, weight: "bold")[JUSTIFICAR TODAS LAS RESPUESTAS]
]

#pagebreak()

= Resoluciones propuestas

#progreso[
  *Qué hay acá:* una resolución completa de cada uno de los cinco ejercicios, escrita como para
  entregar, usando sólo las cajas de `apuntes.typ` (citadas por nombre y número) y los
  enunciados de las guías (citados como "Práctica $k$, Ej. $m$"), que se toman como
  proposiciones ya demostradas.

  *Verificación en Lean:* cada resolución tiene su contraparte formal en
  `lean/Parciales/Parcial1_2C2025.lean`, compilada con Lean 4 + Mathlib (`cd lean && lake build`).
  Al final de cada ejercicio, una caja _Observación_ dice qué teorema de ese archivo certifica el
  resultado y en qué difiere la formalización de la escritura a mano. Ninguna demostración usa
  `sorry`; los únicos axiomas son los estándar de Lean.

  *Convención de índices:* en el curso $NN = {1, 2, dots}$; en Lean los índices arrancan en $0$.
  Donde importa, Lean escribe $n + 1$ o pide $1 <= n$ explícitamente.
]

#v(8pt)

== Ejercicio 1

#enunciado[Ejercicio 1][
  Calcular, si existen, el supremo y el ínfimo de $A = {m/(m+n) : m in NN, n in NN}$.
]

#estrategia[Fijar una de las dos variables y mandar la otra a infinito][
  Todo elemento está estrictamente entre $0$ y $1$. Con $n = 1$ y $m -> oo$, $m/(m+1) = 1 - 1/(m+1)$
  se acerca a $1$ tanto como se quiera; con $m = 1$ y $n -> oo$, $1/(1+n)$ se acerca a $0$. Las
  Proposiciones 3 y 5 (equivalencias de supremo e ínfimo) hacen el resto.
]

#resolucion[Propuesta: $op("sup")(A) = 1$ e $op("ínf")(A) = 0$, ninguno de los dos se alcanza][
  $A != emptyset$ (contiene a $1/2$, con $m = n = 1$).

  *Cotas.* Para $m, n in NN$ vale $0 < m < m + n$, así que $0 < m/(m+n) < 1$. Luego $0$ es cota
  inferior y $1$ es cota superior de $A$; por el Axioma de Completitud y el Teorema 2 existen
  $op("sup")(A)$ e $op("ínf")(A)$.

  *$op("sup")(A) = 1$.* Sea $epsilon > 0$. Por el Principio de Arquímedes (Proposición 1) existe
  $m in NN$ con $1/m < epsilon$. Tomando $n = 1$,
  $ m/(m+1) = 1 - 1/(m+1) > 1 - 1/m > 1 - epsilon, $
  y $m/(m+1) in A$. Como $1$ es cota superior y para todo $epsilon > 0$ hay un $a_epsilon in A$ con
  $1 - epsilon < a_epsilon$, la Proposición 3 (equivalencia de supremo) da $op("sup")(A) = 1$.

  *$op("ínf")(A) = 0$.* Sea $epsilon > 0$ y, de nuevo por Arquímedes, $n in NN$ con $1/n < epsilon$.
  Tomando $m = 1$, $1/(1+n) < 1/n < epsilon$ y $1/(1+n) in A$. Como $0$ es cota inferior y para
  todo $epsilon > 0$ hay $a_epsilon in A$ con $a_epsilon < 0 + epsilon$, la Proposición 5
  (equivalencia de ínfimo) da $op("ínf")(A) = 0$.

  *No hay máximo ni mínimo.* $1 in.not A$ y $0 in.not A$ porque todo elemento cumple
  $0 < m/(m+n) < 1$. $qed$
]

#observacion[Verificado en Lean: `Parcial1_2C2025.ej1_sSup`, `ej1_sInf`][
  `A1` es el conjunto con $m, n >= 1$ explícitos. `ej1_sSup : sSup A1 = 1` y
  `ej1_sInf : sInf A1 = 0` usan `csSup_eq_of_forall_le_of_forall_lt_exists_gt` y su dual, que
  son exactamente las Proposiciones 3 y 5; el $m$ sale de `exists_nat_gt` (Arquímedes).
  `ej1_one_notMem` y `ej1_zero_notMem` certifican que no hay máximo ni mínimo.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 2

#enunciado[Ejercicio 2][
  Calcular el cardinal de
  $A = {(a_n)_(n in NN) subset.eq QQ : exists k in NN "tal que" a_(n+k) = (a_k)^n space forall n in NN}$.
]

#estrategia[Una sucesión de $A$ está determinada por sus primeros $k$ términos][
  Si $k$ es el testigo, los términos $a_(k+1), a_(k+2), dots$ son $a_k, a_k^2, dots$: la sucesión
  queda fijada por $(a_1, dots, a_k) in QQ^k$. Entonces $A$ es unión numerable (en $k$) de
  imágenes de $QQ^k$, cada una contable; y es infinito porque contiene a las
  $(q, q, q^2, q^3, dots)$ para todo $q in QQ$.
]

#resolucion[Propuesta: $\#A = aleph_0$][
  *$A$ es contable.* Para cada $k in NN$ definimos $phi_k : QQ^k -> QQ^NN$ por
  $ phi_k (q_1, dots, q_k) = (b_n)_(n in NN), quad b_n = cases(q_n & "si " n <= k, q_k^(n-k) & "si " n > k). $
  Cada $phi_k (q_1, dots, q_k)$ está en $A$ con testigo $k$: para $n in NN$,
  $b_(n+k) = q_k^(n+k-k) = q_k^n = (b_k)^n$. Recíprocamente, si $(a_n)_n in A$ con testigo $k$,
  entonces $(a_n)_n = phi_k (a_1, dots, a_k)$: para $n <= k$ es obvio, y para $n > k$, escribiendo
  $n = (n - k) + k$ con $n - k in NN$, la condición da $a_n = (a_k)^(n-k)$. Por lo tanto
  $ A = union.big_(k in NN) phi_k (QQ^k). $
  Como $QQ tilde.op NN$ (Numerabilidad de $QQ$), $QQ^k tilde.op NN^k tilde.op NN$ (Práctica 2,
  Ej. 14 (c), con $NN$ en lugar de $RR$: $NN^k$ es numerable por inducción en $k$ usando
  $NN times NN tilde.op NN$, Ejemplo 3.12). Entonces $phi_k (QQ^k)$ es imagen sobreyectiva de un
  conjunto numerable, luego contable (Proposición 3.9). Una unión numerable de conjuntos
  contables es contable (Práctica 2, Ej. 6 (a)), así que $A$ es contable: $\#A <= aleph_0$.

  *$A$ es infinito.* La función $psi : QQ -> A$, $psi(q) = (q, q, q^2, q^3, dots)$ (es decir
  $a_1 = q$ y $a_n = q^(n-1)$ para $n >= 2$) toma valores en $A$ con testigo $k = 1$:
  $a_(n+1) = q^n = (a_1)^n$. Es inyectiva porque $psi(q)_1 = q$. Luego
  $aleph_0 = \#QQ <= \#A$ (Definición 3.8).

  Por el Teorema 3.11 (Cantor--Schröeder--Bernstein), $\#A = aleph_0$. $qed$
]

#observacion[Verificado en Lean: `Parcial1_2C2025.ej2`][
  Con índices desde $0$, `A2` es ${a : exists k, a(n+k+1) = a(k)^(n+1) forall n}$, que es la
  traducción exacta de la condición del enunciado. `extiende k` es $phi_k$ y `A2_subset` es la
  inclusión $A subset.eq union.big_k phi_k (QQ^(k+1))$; `A2_countable` la combina con que las
  imágenes son contables (`Set.countable_range`, `Set.countable_iUnion`). `geom q` es $psi(q)$ y
  `A2_infinite` es la inyectividad. `ej2 : #A2 = ℵ₀` cierra con `Cardinal.mk_eq_aleph0`
  (contable e infinito $=>$ numerable).
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 3

#enunciado[Ejercicio 3][
  Sea $(E, d)$ un espacio métrico. Probar que dados $x, y in E$ con $x != y$ existen abiertos
  $U, V$ con $x in U$, $y in V$ y $overline(U) inter overline(V) = emptyset$.
]

#estrategia[Bolas de radio un tercio de la distancia][
  Con $r = d(x, y) > 0$, las bolas $B(x, r/3)$ y $B(y, r/3)$ tienen clausuras dentro de las bolas
  cerradas del mismo radio, y dos bolas cerradas de radio $r/3$ centradas a distancia $r$ no se
  tocan: un punto común daría $r <= r/3 + r/3$.
]

#resolucion[Propuesta][
  Sea $r = d(x, y)$; como $x != y$, $r > 0$ (Definición 4.1 (ii)). Tomamos
  $ U = B(x, r/3), quad V = B(y, r/3). $
  Son abiertos (Práctica 3, Ej. 4 (b)), $x in U$ e $y in V$ porque $d(x, x) = 0 < r/3$ y lo mismo
  para $y$.

  Por la Práctica 3, Ej. 4 (e), $overline(U) subset.eq overline(B)(x, r/3) = {z : d(x, z) <= r/3}$ y
  $overline(V) subset.eq overline(B)(y, r/3)$. Si existiera $z in overline(U) inter overline(V)$,
  tendríamos $d(x, z) <= r/3$ y $d(z, y) <= r/3$, y por la desigualdad triangular
  $ r = d(x, y) <= d(x, z) + d(z, y) <= r/3 + r/3 = (2 r)/3 < r, $
  absurdo. Luego $overline(U) inter overline(V) = emptyset$. $qed$
]

#observacion[Verificado en Lean: `Parcial1_2C2025.ej3`][
  Enunciado idéntico. La inclusión $overline(B(x, s)) subset.eq overline(B)(x, s)$ es
  `Metric.closure_ball_subset_closedBall`, y el absurdo final es `linarith` con la desigualdad
  triangular `dist_triangle x z y`.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 4

#enunciado[Ejercicio 4][
  Sea $(E, d)$ un espacio métrico y, para $A, B subset.eq E$ no vacíos,
  $tilde(d)(A, B) = op("ínf"){d(a, b) : a in A, b in B}$. Sea $(M_n)_(n in NN)$ una familia de
  subconjuntos no vacíos de $E$.
  #set enum(numbering: "a)")
  + Probar que $union.big_(n in NN) overline(M_n) subset.eq overline(union.big_(n in NN) M_n)$.
  + Si existe $epsilon > 0$ tal que $tilde(d)(M_n, M_m) > epsilon$ para todo $n != m$, probar que
    $overline(union.big_(n in NN) M_n) = union.big_(n in NN) overline(M_n)$.
]

#estrategia[En (b), una bola chica alrededor de $x$ sólo puede tocar a un $M_n$][
  (a) es la monotonía de la clausura. En (b), si $x$ es adherente a la unión, alguna bola
  $B(x, epsilon/2)$ contiene un punto $y_0 in M_(n_0)$. Cualquier otro punto de la unión en esa
  bola está a distancia $< epsilon$ de $y_0$, y la separación $tilde(d)(M_n, M_m) > epsilon$ lo
  obliga a estar en el mismo $M_(n_0)$. Así, todas las bolas centradas en $x$ tocan a $M_(n_0)$.
]

#resolucion[Propuesta][
  *a)* Sea $x in union.big_n overline(M_n)$: existe $n$ con $x in overline(M_n)$. Dado $r > 0$,
  existe $y in B(x, r) inter M_n$ (Definición 4.22), y como $M_n subset.eq union.big_m M_m$,
  $y in B(x, r) inter union.big_m M_m$. Luego $x in overline(union.big_m M_m)$.

  *b)* Por (a) basta ver $overline(union.big_n M_n) subset.eq union.big_n overline(M_n)$.

  _Un lema sobre $tilde(d)$._ Si $a in A$ y $b in B$, entonces $tilde(d)(A, B) <= d(a, b)$, porque el
  ínfimo es cota inferior del conjunto ${d(a, b) : a in A, b in B}$ (que es no vacío y acotado
  inferiormente por $0$, así que el ínfimo existe, Teorema 2). En particular, de
  $tilde(d)(M_n, M_m) > epsilon$ se deduce $d(a, b) > epsilon$ para todo $a in M_n$, $b in M_m$,
  cuando $n != m$.

  Sea $x in overline(union.big_n M_n)$. Como $B(x, epsilon/2) inter union.big_n M_n != emptyset$,
  existen $n_0 in NN$ e $y_0 in M_(n_0)$ con $d(x, y_0) < epsilon/2$. Afirmamos que
  $x in overline(M_(n_0))$. Sea $r > 0$ y $rho = min{r, epsilon/2} > 0$. Existe
  $y in B(x, rho) inter union.big_n M_n$, digamos $y in M_m$. Si fuera $m != n_0$, por el lema
  $ epsilon < d(y, y_0) <= d(y, x) + d(x, y_0) < epsilon/2 + epsilon/2 = epsilon, $
  absurdo. Luego $m = n_0$, es decir $y in M_(n_0)$, y además $d(x, y) < rho <= r$, así que
  $y in B(x, r) inter M_(n_0)$. Como $r$ era arbitrario, $x in overline(M_(n_0)) subset.eq
  union.big_n overline(M_n)$. $qed$
]

#observacion[Verificado en Lean: `Parcial1_2C2025.ej4a`, `ej4b`][
  `dtilde A B` es $tilde(d)(A, B)$ definida como `sInf` del conjunto de distancias, y `dtilde_le` es
  el lema "el ínfimo es cota inferior" (`csInf_le`, con cota inferior $0$). `ej4a` es
  `Set.iUnion_subset` + `closure_mono`. `ej4b` sigue la resolución con `Metric.mem_closure_iff`
  (la Definición 4.22 en Mathlib) y el radio `min r (ε/2)`; la hipótesis está escrita como
  `∀ n m, n ≠ m → ε < dtilde (M n) (M m)`.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 5

#enunciado[Ejercicio 5][
  En $C([0,1]) times [0,1]$ con $d((f, x), (g, y)) = op("máx"){d_oo (f, g), abs(x - y)}$, probar que
  $F(f, x) = f(x)$ es continua.
]

#estrategia[Separar en "cambiar la función" y "mover el punto"][
  $abs(f(x) - g(y)) <= abs(f(x) - g(x)) + abs(g(x) - g(y))$. El primer sumando es a lo sumo
  $d_oo (f, g)$; el segundo es chico porque $g$ es continua en $y$. Cada uno se controla con una
  coordenada de la métrica producto.
]

#resolucion[Propuesta][
  Usamos la definición de continuidad en un punto: $F$ es continua en $(g, y)$ si para todo
  $epsilon > 0$ existe $delta > 0$ tal que $d((f, x), (g, y)) < delta$ implica
  $abs(F(f, x) - F(g, y)) < epsilon$.

  Fijemos $(g, y) in C([0,1]) times [0,1]$ y $epsilon > 0$. Como $g$ es continua en $y$, existe
  $delta_1 > 0$ tal que $abs(x - y) < delta_1$ implica $abs(g(x) - g(y)) < epsilon/2$ (para
  $x in [0,1]$). Sea $delta = min{delta_1, epsilon/2} > 0$.

  Sea $(f, x)$ con $d((f, x), (g, y)) < delta$. Como $d$ es un máximo, $d_oo (f, g) < delta <= epsilon/2$
  y $abs(x - y) < delta <= delta_1$. Entonces, usando que $abs(f(x) - g(x)) <= sup_t abs(f(t) - g(t)) = d_oo (f, g)$,
  $ abs(F(f, x) - F(g, y)) = abs(f(x) - g(y)) <= abs(f(x) - g(x)) + abs(g(x) - g(y))
    < epsilon/2 + epsilon/2 = epsilon. $
  Como $(g, y)$ era arbitrario, $F$ es continua. $qed$
]

#observacion[Verificado en Lean: `Parcial1_2C2025.ej5`][
  `C([0,1])` es `C(unitInterval, ℝ)` (con la métrica $d_oo$ de Mathlib) y la métrica producto de
  Mathlib es exactamente $op("máx"){d_oo, abs(dot)}$ (`dist_prod_eq`). `ej5 : Continuous F` sigue
  la cuenta de arriba con `Metric.continuous_iff`, `ContinuousMap.dist_apply_le_dist` (la cota
  $abs(f(x) - g(x)) <= d_oo (f, g)$) y la continuidad de `g` en `y`.
]
