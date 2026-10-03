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

// Fuente: `parciales/recuperatorio_1_2c2025.jpg` (foto del enunciado).
// La fuente no trae resolución. Después del enunciado: resoluciones propuestas de los cinco
// ejercicios, cada una verificada formalmente en `lean/Parciales/Recu1_2C2025.lean`.

#align(center)[
  #text(14pt, weight: "bold")[Análisis Avanzado - Segundo cuatrimestre 2025] \
  #v(2pt)
  #text(12pt, weight: "medium")[Recuperatorio del primer parcial - 04/12/25]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

*Ejercicio 1.* Calcular, si existen, el supremo, ínfimo, máximo y mínimo de
$ A = {1 / (n^2 - 8n + 18) : n in NN}. $

#line(length: 100%, stroke: 0.4pt)

*Ejercicio 2.* Calcular el cardinal del conjunto
$ C = {f : QQ -> NN : f(q) = 3 "para todo" q in QQ "salvo finitos"}. $

#line(length: 100%, stroke: 0.4pt)

*Ejercicio 3.*

#set enum(numbering: "a)")
+ Sea $(E, d)$ un espacio métrico y sean $A, B subset.eq E$ con $A$ abierto. Probar que si $A inter overline(B) != emptyset$, entonces $A inter B != emptyset$.

+ Supongamos que $(E, d) = (RR, abs(dot.c))$, $A, B subset.eq RR$ pero $A$ no necesariamente es abierto. ¿Sigue valiendo la afirmación del ítem a)?

#line(length: 100%, stroke: 0.4pt)

*Ejercicio 4.* Sea $delta : RR times RR -> RR$ la métrica discreta en $RR$ dada por
$ delta(x, y) = cases(1 & quad "si" x != y, 0 & quad "si" x = y). $
Sea $d : RR^2 times RR^2 -> RR$ la métrica definida como
$ d((x_1, y_1), (x_2, y_2)) = sqrt(abs(x_1 - x_2)^2 + delta(y_1, y_2)^2). $

+ Probar que en el espacio métrico $(RR^2, d)$ vale que $B((0, 0), 1/2) = (-1/2, 1/2) times {0}$.

+ Decidir si la sucesión $(1/n, 1/n)_(n in NN)$ converge a $(0, 0)$ con la métrica $d$.

#line(length: 100%, stroke: 0.4pt)

*Ejercicio 5.* Sean $(E, d)$ y $(E', d')$ espacios métricos y $f : E -> E'$ una función. Probar que $f$ es continua si y sólo si $f^(-1)(B^circle) subset.eq (f^(-1)(B))^circle$ para todo $B subset.eq E'$.

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
  `lean/Parciales/Recu1_2C2025.lean`, compilada con Lean 4 + Mathlib (`cd lean && lake build`).
  Al final de cada ejercicio, una caja _Observación_ dice qué teorema de ese archivo certifica el
  resultado y en qué difiere la formalización de la escritura a mano. Ninguna demostración usa
  `sorry`; los únicos axiomas son los estándar de Lean.

  *Convención de índices:* en el curso $NN = {1, 2, dots}$; en Lean los índices arrancan en $0$.
  Donde importa, Lean escribe $n + 1$ o pide $1 <= n$ explícitamente.
]

#v(8pt)

== Ejercicio 1

#enunciado[Ejercicio 1][
  Calcular, si existen, el supremo, ínfimo, máximo y mínimo de
  $A = {1/(n^2 - 8n + 18) : n in NN}$.
]

#estrategia[Completar cuadrados en el denominador][
  $n^2 - 8n + 18 = (n - 4)^2 + 2$ vale al menos $2$, y vale exactamente $2$ sólo en $n = 4$. Así
  el elemento más grande es $a_4 = 1/2$, y los demás bajan hacia $0$ sin llegar.
]

#resolucion[Propuesta: $op("máx")(A) = op("sup")(A) = 1/2$, $op("ínf")(A) = 0$ y no hay mínimo][
  Para $n in NN$ sea $D_n = n^2 - 8n + 18 = (n - 4)^2 + 2$. Entonces $D_n >= 2 > 0$, con
  $D_4 = 2$, así que todos los elementos de $A$ están bien definidos y son positivos.

  *Máximo y supremo.* Para todo $n$, $D_n >= 2 = D_4$, luego $1/D_n <= 1/2 = a_4$. Es decir,
  $1/2$ es cota superior de $A$ y $1/2 in A$. Por la Proposición 4 (caracterización de supremo y
  máximo), $op("sup")(A) = op("máx")(A) = 1/2$.

  *Ínfimo.* Como $1/D_n > 0$ para todo $n$, el $0$ es cota inferior. Sea $epsilon > 0$; por el
  Principio de Arquímedes (Teorema 1) existe $n in NN$ con $n > 4 + 1/epsilon$. Entonces
  $n - 4 > 1/epsilon > 0$ y
  $ D_n = (n - 4)^2 + 2 > (n - 4) > 1/epsilon, $
  (usando $(n-4)^2 + 2 > n - 4$, que vale porque $t^2 - t + 2 = (t - 1/2)^2 + 7/4 > 0$), de donde
  $1/D_n < epsilon$. Como $0$ es cota inferior y para todo $epsilon > 0$ hay un elemento de $A$
  menor que $0 + epsilon$, la Proposición 5 (equivalencia de ínfimo) da $op("ínf")(A) = 0$.

  *No hay mínimo.* $0 in.not A$ porque todos los elementos son positivos (Definición 6). $qed$
]

#observacion[Verificado en Lean: `Recu1_2C2025.ej1_sSup`, `ej1_sInf`, `ej1_no_min`][
  `A1` es el conjunto con $n >= 1$ explícito; `denom_eq` es la identidad $(n-4)^2 + 2$.
  `ej1_isGreatest : IsGreatest A1 (1/2)` es la Proposición 4 ($1/2$ es cota superior y pertenece),
  de donde `ej1_sSup` y `ej1_max_mem`. `ej1_sInf` usa
  `csInf_eq_of_forall_ge_of_forall_gt_exists_lt` (la Proposición 5) con el $n$ de Arquímedes.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 2

#enunciado[Ejercicio 2][
  Calcular el cardinal de $C = {f : QQ -> NN : f(q) = 3 "para todo" q in QQ "salvo finitos"}$.
]

#estrategia[Una función de $C$ es su "gráfico reducido", que es un conjunto finito][
  $f$ queda determinada por el conjunto finito $G(f) = {(q, f(q)) : f(q) != 3} subset.eq QQ times NN$:
  afuera de las primeras coordenadas de $G(f)$ vale $3$. Los subconjuntos finitos de un conjunto
  numerable forman un conjunto numerable (Práctica 2, Ej. 10), y eso acota $\#C$ por $aleph_0$.
]

#resolucion[Propuesta: $\#C = aleph_0$][
  *$C$ es contable.* Para $f in C$ definimos $G(f) = {(q, f(q)) : q in QQ, f(q) != 3} subset.eq QQ times NN$.
  Es finito porque es la imagen de ${q : f(q) != 3}$, finito por hipótesis, por $q |-> (q, f(q))$.
  Así $G : C -> cal(P)_f (QQ times NN)$, el conjunto de subconjuntos finitos de $QQ times NN$.

  _$G$ es inyectiva._ Sean $f, g in C$ con $G(f) = G(g)$ y sea $q in QQ$. Si $f(q) != 3$, entonces
  $(q, f(q)) in G(f) = G(g)$, así que existe $q'$ con $g(q') != 3$ y $(q', g(q')) = (q, f(q))$;
  comparando coordenadas, $q' = q$ y $g(q) = f(q)$. Simétricamente, si $g(q) != 3$ entonces
  $f(q) = g(q)$. Y si $f(q) = 3 = g(q)$ también coinciden. Luego $f = g$.

  _El codominio es numerable._ $QQ times NN tilde.op NN times NN tilde.op NN$ (Numerabilidad de $QQ$,
  Ejemplo 3.12), así que $cal(P)_f (QQ times NN)$ es numerable (Práctica 2, Ej. 10). Por la
  Definición 3.8, $\#C <= aleph_0$.

  *$C$ es infinito.* Para $k in NN$ sea $f_k : QQ -> NN$ con $f_k (0) = k$ y $f_k (q) = 3$ si
  $q != 0$. Cada $f_k in C$ (difiere de $3$ a lo sumo en $q = 0$) y $k |-> f_k$ es inyectiva
  ($f_k (0) = k$). Luego $aleph_0 = \#NN <= \#C$.

  Por el Teorema 3.11 (Cantor--Schröeder--Bernstein), $\#C = aleph_0$. $qed$
]

#observacion[Verificado en Lean: `Recu1_2C2025.ej2`][
  `grafico f` es $G(f)$; `grafico_finite` y `grafico_injective` son los dos párrafos de arriba
  (la inyectividad se prueba coordenada a coordenada, con el caso $f(q) = 3 = g(q)$ aparte).
  `C_countable` inyecta a `C` en `{t : Set (ℚ × ℕ) | t.Finite ∧ t ⊆ univ}`, que Mathlib sabe
  contable (`Set.countable_ofPred_finite_subset`, la Práctica 2, Ej. 10). `C_infinite` son las
  $f_k$. `ej2 : #C = ℵ₀` cierra con `Cardinal.mk_eq_aleph0`.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 3

#enunciado[Ejercicio 3][
  #set enum(numbering: "a)")
  + Sea $(E, d)$ un espacio métrico y $A, B subset.eq E$ con $A$ abierto. Probar que si
    $A inter overline(B) != emptyset$, entonces $A inter B != emptyset$.
  + Si $(E, d) = (RR, abs(dot.c))$ y $A$ no es necesariamente abierto, ¿sigue valiendo a)?
]

#estrategia[La bola que da la apertura de $A$ es la que toca a $B$][
  Un punto $x in A inter overline(B)$ tiene una bola $B(x, r) subset.eq A$ (abierto) y esa misma
  bola corta a $B$ (adherencia). Sin apertura, un punto aislado de $A$ pegado a $B$ rompe todo.
]

#resolucion[Propuesta][
  *a)* Sea $x in A inter overline(B)$. Como $A$ es abierto y $x in A$, existe $r > 0$ con
  $B(x, r) subset.eq A$ (Definiciones 4.11 y 4.14). Como $x in overline(B)$, existe
  $y in B(x, r) inter B$ (Definición 4.22). Entonces $y in A$ (por $B(x, r) subset.eq A$) e
  $y in B$, así que $y in A inter B != emptyset$. $qed$

  *b)* *No.* En $(RR, abs(dot.c))$ tomemos $A = {0}$ y $B = (0, 1)$. Por un lado
  $overline(B) = [0, 1]$ (como en el Ejemplo 27 de `ejemplos/p3.typ`, que calcula la clausura de
  $(0,1) union {2}$), así que
  $0 in A inter overline(B)$ y $A inter overline(B) != emptyset$. Por otro lado $0 in.not (0, 1)$,
  así que $A inter B = emptyset$. El ítem a) falla porque $A = {0}$ no es abierto: ninguna bola
  $B(0, r) = (-r, r)$ está contenida en ${0}$.
]

#observacion[Verificado en Lean: `Recu1_2C2025.ej3a`, `ej3b`][
  `ej3a` es una línea: `IsOpen.inter_closure` ($A inter overline(B) subset.eq overline(A inter B)$,
  el Ejercicio 3 del primer parcial 1C 2025) más `closure_nonempty_iff`. `ej3b` exhibe
  $A = {0}$, $B = (0,1)$ con `closure_Ioo`.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 4

#enunciado[Ejercicio 4][
  Sea $delta$ la métrica discreta en $RR$ y $d((x_1, y_1), (x_2, y_2)) = sqrt(abs(x_1 - x_2)^2 + delta(y_1, y_2)^2)$
  en $RR^2$.
  #set enum(numbering: "a)")
  + Probar que en $(RR^2, d)$ vale $B((0,0), 1/2) = (-1/2, 1/2) times {0}$.
  + Decidir si $(1/n, 1/n)_(n in NN)$ converge a $(0, 0)$ con la métrica $d$.
]

#estrategia[La segunda coordenada sólo aporta $0$ o $1$][
  $delta(y_1, y_2)^2$ vale $0$ si $y_1 = y_2$ y $1$ si no. Para que $d < 1/2$ hace falta
  $delta = 0$, es decir, la misma segunda coordenada; y para una sucesión que converge a
  $(0, 0)$ hace falta que la segunda coordenada sea eventualmente $0$.
]

#resolucion[Propuesta][
  *a)* Sea $p = (x, y) in RR^2$. Como $sqrt(dot)$ es creciente y $1/2 > 0$,
  $ p in B((0,0), 1/2) <==> sqrt(abs(x)^2 + delta(y, 0)^2) < 1/2 <==> x^2 + delta(y, 0)^2 < 1/4. $
  - Si $y != 0$, entonces $delta(y, 0) = 1$ y $x^2 + 1 >= 1 > 1/4$: $p in.not B((0,0), 1/2)$.
  - Si $y = 0$, entonces $delta(y, 0) = 0$ y la condición es $x^2 < 1/4$, es decir $abs(x) < 1/2$,
    es decir $x in (-1/2, 1/2)$.
  Luego $B((0,0), 1/2) = {(x, 0) : abs(x) < 1/2} = (-1/2, 1/2) times {0}$. $qed$

  *b)* *No converge a $(0,0)$.* Para todo $n in NN$, $1/n != 0$, así que $delta(1/n, 0) = 1$ y
  $ d((1/n, 1/n), (0, 0)) = sqrt(1/n^2 + 1) >= sqrt(1) = 1. $
  Si la sucesión convergiera a $(0,0)$, tomando $epsilon = 1$ en la Definición 4.42 habría
  $n_0$ con $d((1/n, 1/n), (0,0)) < 1$ para $n >= n_0$, contradiciendo lo anterior. $qed$

  (Lo que sí converge a $(0, 0)$ con $d$ es, por ejemplo, $(1/n, 0)_n$: ahí la segunda coordenada
  ya es $0$ y $d((1/n, 0), (0,0)) = 1/n -> 0$.)
]

#observacion[Verificado en Lean: `Recu1_2C2025.ej4a`, `ej4b`][
  Lean construye $(RR^2, d)$ como un espacio métrico de verdad: `Rδ` es $RR$ con la métrica
  discreta (instancia `MetricSpace Rδ`, con los cuatro axiomas verificados) y `P` es
  `WithLp 2 (ℝ × Rδ)`, el producto con la métrica "$ell^2$" de Mathlib; `P.dist_eq` comprueba
  que su distancia es exactamente la $d$ del enunciado. Con eso, `Metric.ball` y `Tendsto` son
  las nociones estándar. `ej4a` es la igualdad de conjuntos (con `Real.sqrt_lt'` para
  $sqrt(t) < 1/2 <==> t < 1/4$) y `ej4b` es la no convergencia, con $epsilon = 1$ y
  `Real.one_le_sqrt`.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 5

#enunciado[Ejercicio 5][
  Sean $(E, d)$, $(E', d')$ espacios métricos y $f : E -> E'$. Probar que $f$ es continua si y
  sólo si $f^(-1)(B^compose) subset.eq (f^(-1)(B))^compose$ para todo $B subset.eq E'$.
]

#estrategia[Bolas en el codominio versus bolas en el dominio][
  Continuidad en $x$ dice: toda bola $B(f(x), epsilon)$ contiene la imagen de alguna bola
  $B(x, delta)$. La inclusión del enunciado dice lo mismo con "bola" reemplazada por "abierto
  contenido en $B$": la ida es la definición, y la vuelta se obtiene tomando $B = B(f(x), epsilon)$,
  que es abierta y por lo tanto su propio interior.
]

#resolucion[Propuesta][
  Usamos la definición: $f$ es continua si para todo $x in E$ y todo $epsilon > 0$ existe
  $delta > 0$ tal que $d(x, x') < delta$ implica $d'(f(x), f(x')) < epsilon$; equivalentemente,
  $f(B(x, delta)) subset.eq B(f(x), epsilon)$.

  *($=>$)* Sea $B subset.eq E'$ y $x in f^(-1)(B^compose)$, es decir $f(x) in B^compose$. Por la
  Definición 4.11 existe $epsilon > 0$ con $B(f(x), epsilon) subset.eq B$. Por continuidad en $x$
  existe $delta > 0$ con $f(B(x, delta)) subset.eq B(f(x), epsilon) subset.eq B$, es decir
  $B(x, delta) subset.eq f^(-1)(B)$. Luego $x$ es punto interior de $f^(-1)(B)$:
  $x in (f^(-1)(B))^compose$.

  *($arrow.l.double$)* Sea $x in E$ y $epsilon > 0$. Tomemos $B = B(f(x), epsilon)$, que es un
  abierto de $E'$ (Práctica 3, Ej. 4 (b)), así que $B^compose = B$ (Definición 4.14). Como
  $f(x) in B$, tenemos $x in f^(-1)(B) = f^(-1)(B^compose) subset.eq (f^(-1)(B))^compose$ por
  hipótesis. Por la Definición 4.11 existe $delta > 0$ con $B(x, delta) subset.eq f^(-1)(B)$, es
  decir: si $d(x, x') < delta$ entonces $f(x') in B(f(x), epsilon)$, o sea
  $d'(f(x), f(x')) < epsilon$. Luego $f$ es continua en $x$, y como $x$ era arbitrario, $f$ es
  continua. $qed$
]

#observacion[Verificado en Lean: `Recu1_2C2025.ej5`][
  Enunciado idéntico. En Mathlib `Continuous f` se define como "la preimagen de todo abierto es
  abierta" (equivalente a la definición $epsilon$-$delta$ en espacios métricos), así que la prueba
  formal es más corta: la ida es `preimage_interior_subset_interior_preimage` y la vuelta aplica la
  hipótesis a un abierto $V$ (que es su propio interior, `IsOpen.interior_eq`) para obtener
  $f^(-1)(V) subset.eq (f^(-1)(V))^compose$, es decir que $f^(-1)(V)$ es abierto.
]
