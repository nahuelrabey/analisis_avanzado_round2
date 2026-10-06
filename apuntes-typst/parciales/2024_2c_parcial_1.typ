#import "@preview/frame-it:2.0.0": *
#import "../utils.typ": *
#show figure.where(kind: "frame"): set figure(numbering: none)
#show figure.where(kind: "frame"): set block(breakable: true)
#show: frame-style(styles.boxy)

// Fuente: `parciales/resolucion_oficial_1er_parcial_2c2024.pdf` (enunciado + resolución oficial
// de la cátedra). Las resoluciones de abajo son transcripción de ese documento, sin agregados.
// Al final: sección "Verificación en Lean", con la formalización de las cuatro resoluciones en
// `lean/Parciales/Parcial1_2C2024.lean`.

#align(center)[
  #text(14pt, weight: "bold")[Análisis Avanzado] \
  #v(2pt)
  #text(12pt, weight: "medium")[Primer parcial - 19 de octubre de 2024]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(6pt)

#text(9pt)[
  _Nota: se aprueba con dos ejercicios bien y completos. Buena suerte, *justifique todas sus respuestas* y escriba con claridad._
]

#v(4pt)

#set enum(numbering: "1.")

+ Consideremos $A$ y $B$ conjuntos en $RR$ no vacíos y acotados. Probar que $op("ínf")(A) + op("ínf")(B) = op("ínf")(A + B)$.#footnote[Definimos el conjunto suma como $A + B = {a + b : a in A, b in B}$.]

+ Calcular el cardinal del conjunto ${B subset.eq QQ : \#B = \#(QQ without B)}$.

+ Sea $(X, d)$ un espacio métrico. Supongamos que toda sucesión $(A_n)_(n in NN)$ de subconjuntos cerrados y no vacíos tal que $A_(n+1) subset.eq A_n$ para todo $n in NN$ con $op("diam")(A_n) -> 0$ cuando $n$ tiende a infinito cumple que $inter.big_(n in NN) A_n != emptyset$. Probar que $X$ es completo.

+ Sean $(X, d)$ y $(Y, d')$ espacios métricos con $X = C([0, 1])$ y $cal(F) : X -> Y$ una función. Probar que si $cal(F)$ es continua con $d = d_1$ entonces también es continua con $d = d_oo$. ¿Vale la recíproca?

#v(8pt)
#line(length: 100%, stroke: 0.7pt)
#v(6pt)

#align(center)[
  #block(width: 75%)[
    #text(9pt)[
      Maryam Mirzakhani (1977 -- 2017) fue una matemática iraní profesora en la Universidad de
      Stanford que trabajó en teoría de Teichmüller, geometría hiperbólica, teoría ergódica y
      topología simpléctica. En 2014 fue la primera mujer en recibir la medalla Fields.
    ]
  ]
]

#pagebreak()

= Resoluciones (oficiales)

== Ejercicio 1

#enunciado[Ejercicio 1][
  Consideremos $A$ y $B$ conjuntos en $RR$ no vacíos y acotados. Probar que $op("ínf")(A) + op("ínf")(B) = op("ínf")(A + B)$, donde $A + B = {a + b : a in A, b in B}$.
]

#resolucion[Cátedra][
  Dado un elemento en $A + B$ podemos escribirlo como $a + b$ con $a in A$ y $b in B$. Luego
  $ a + b >= op("ínf")(A) + op("ínf")(B) $
  y llegamos a que $op("ínf")(A) + op("ínf")(B)$ es una cota inferior del conjunto suma. Es decir,
  $ op("ínf")(A + B) >= op("ínf")(A) + op("ínf")(B). $

  Resta ver la otra desigualdad. Fijemos $epsilon > 0$ cualquiera. Existen $a in A$ y $b in B$
  tales que
  $ op("ínf")(A) & >= a - epsilon / 2, \
    op("ínf")(B) & >= b - epsilon / 2 $
  y así
  $ op("ínf")(A) + op("ínf")(B) >= a + b - epsilon >= op("ínf")(A + B) - epsilon $
  pues $a + b in A + B$. Y como $epsilon$ era cualquiera, llegamos al resultado.
]

== Ejercicio 2

#enunciado[Ejercicio 2][
  Calcular el cardinal del conjunto ${B subset.eq QQ : \#B = \#(QQ without B)}$.
]

#resolucion[Cátedra][
  Llamemos $cal(A) = {B subset.eq QQ : \#B = \#(QQ without B)}$. Notemos que
  $cal(A) subset.eq cal(P)(QQ)$ que tiene el mismo cardinal que $cal(P)(NN)$ y que es el cardinal
  de los reales $bold(c)$. Por lo tanto $\#cal(A) <= bold(c)$.

  Nuevamente usando que $bold(c) = \#cal(P)(NN)$ construimos una función inyectiva
  $ cal(P)(NN) & -> cal(A) \
    B & |-> B union ((1, 2) inter QQ) $
  que está bien definida pues
  $ aleph_0 = \#((1, 2) inter QQ) <= \#(B union ((1, 2) inter QQ)) <= \#QQ <= aleph_0 $
  y
  $ aleph_0 = \#((2, 3) inter QQ) <= \#(QQ without (B union ((1, 2) inter QQ))) <= \#QQ <= aleph_0. $
  Esto implica que el cardinal de $cal(A)$ no puede ser menor al de $cal(P)(NN)$. Por lo tanto
  $bold(c) <= \#cal(A)$ y obtenemos $bold(c) = \#cal(A)$.
]

// Agregado (no es parte de la resolución oficial).
#observacion[Por qué $aleph_0 = \#((1, 2) inter QQ)$][
  Son dos desigualdades y Cantor–Bernstein.

  - $\#((1, 2) inter QQ) <= aleph_0$: es un subconjunto de $QQ$ (la inclusión es inyectiva) y
    $\#QQ = aleph_0$.
  - $aleph_0 <= \#((1, 2) inter QQ)$: la función
    $ phi : NN -> (1, 2) inter QQ, quad phi(n) = 1 + 1 / (n + 1) $
    está bien definida, porque $1 / (n + 1) in (0, 1) inter QQ$, y es inyectiva, porque
    $1 + 1 / (n + 1) = 1 + 1 / (m + 1)$ implica $n = m$.

  Lo mismo vale para $(2, 3) inter QQ$ con $n |-> 2 + 1 / (n + 1)$. En general, todo intervalo
  abierto no vacío tiene infinitos racionales, y todo subconjunto infinito de $QQ$ es numerable.
]

// Agregado (no es parte de la resolución oficial).
#observacion[Por qué la función está bien definida y es inyectiva][
  Sea $Phi(B) = B union ((1, 2) inter QQ)$ con $B subset.eq NN$. Que $Phi$ esté bien definida
  significa que $Phi(B) in cal(A)$, es decir, $\#Phi(B) = \#(QQ without Phi(B))$. Las dos
  cadenas de la resolución son *independientes*: no se compara un lado con el otro, sino que se
  prueba que *los dos valen $aleph_0$*.

  Cada cadena tiene la forma $aleph_0 <= \#X <= aleph_0$, así que $\#X = aleph_0$
  (Cantor–Bernstein). Cada $<=$ sale de una inclusión ($S subset.eq T => \#S <= \#T$):

  - Primera cadena, $X = Phi(B)$:
    $ (1, 2) inter QQ subset.eq Phi(B) subset.eq QQ, $
    la primera inclusión por definición de la unión y la segunda porque
    $B subset.eq NN subset.eq QQ$.
  - Segunda cadena, $X = QQ without Phi(B)$:
    $ (2, 3) inter QQ subset.eq QQ without Phi(B) subset.eq QQ. $
    Si $q in (2, 3) inter QQ$, entonces $q in.not (1, 2)$ porque $q > 2$, y $q in.not B$ porque
    $B subset.eq NN$ y el intervalo abierto $(2, 3)$ no tiene naturales. Luego
    $q in.not Phi(B)$.

  Por eso se eligen intervalos sin naturales: así $B$, que puede ser cualquier subconjunto de
  $NN$, no "invade" ninguno de los dos intervalos. En ambas cadenas el extremo izquierdo vale
  $aleph_0$ por la observación anterior, y $\#QQ = aleph_0$.

  *Inyectividad.* El texto dice "construimos una función inyectiva" pero no lo verifica. Como
  $(1, 2)$ no tiene naturales, al cortar con $NN$ se recupera $B$:
  $ Phi(B) inter NN = B. $
  Entonces $Phi(B) = Phi(B')$ implica $B = Phi(B) inter NN = Phi(B') inter NN = B'$.

  *Conclusión.* $\#S <= \#T$ significa que existe una función inyectiva $S -> T$. Las cadenas dan
  que $Phi$ va de $cal(P)(NN)$ a $cal(A)$, y acabamos de ver que es inyectiva, así que
  $bold(c) = \#cal(P)(NN) <= \#cal(A)$. Esto es lo que el texto llama "el cardinal de $cal(A)$
  no puede ser menor al de $cal(P)(NN)$". Junto con $\#cal(A) <= bold(c)$, Cantor–Bernstein da
  $\#cal(A) = bold(c)$.
]

== Ejercicio 3

#enunciado[Ejercicio 3][
  Sea $(X, d)$ un espacio métrico. Supongamos que toda sucesión $(A_n)_(n in NN)$ de subconjuntos cerrados y no vacíos tal que $A_(n+1) subset.eq A_n$ para todo $n in NN$ con $op("diam")(A_n) -> 0$ cuando $n$ tiende a infinito cumple que $inter.big_(n in NN) A_n != emptyset$. Probar que $X$ es completo.
]

#resolucion[Cátedra][
  Consideremos una sucesión $(x_n)_(n in NN) subset.eq X$ de Cauchy, debemos probar que tiene
  límite. Para cada $n in NN$ definamos
  $ A_n = union.big_(m = n)^oo B(x_m, 1 \/ n). $
  Notemos que $A_n supset.eq A_(n+1)$ y que son no vacíos. Por lo tanto $overline(A_n)$ es
  cerrado, no vacío y $overline(A_n) supset.eq overline(A_(n+1))$.

  Necesitamos estudiar el diámetro. Fijado $epsilon > 0$ existe $n_0$ tal que
  $1 \/ n_0 <= epsilon \/ 5$ y $d(x_n, x_m) < epsilon \/ 5$ si $m, n >= n_0$ (pues la sucesión es
  de Cauchy). Entonces, dados dos elementos $a, b in overline(A_n)$ con $n >= n_0$, resulta que
  existen $a', b' in A_n$ tales que $d(a, a'), d(b, b') < epsilon \/ 5$. Además existen $x_m$ y
  $x_j$ elementos de la sucesión tales que $a' in B(x_m, 1 \/ n)$, $b' in B(x_j, 1 \/ n)$ (con
  $m, j >= n_0$). Entonces
  $ d(a, b) & <= d(a, a') + d(a', b) \
    & <= d(a, a') + d(a', x_m) + d(x_m, x_j) + d(x_j, b') + d(b', b) \
    & < epsilon \/ 5 + 1 \/ n + epsilon \/ 5 + 1 \/ n + epsilon \/ 5 \
    & < epsilon \/ 5 + epsilon \/ 5 + epsilon \/ 5 + epsilon \/ 5 + epsilon \/ 5 = epsilon $
  y probamos que el diámetro tiende a cero.

  Entonces existe $x in inter.big_(n in NN) overline(A_n)$. Resta ver que es el límite de la
  sucesión original. Dado $epsilon > 0$ existe $n_0$ tal que si $n >= n_0$ entonces
  $op("diam")(overline(A_n)) < epsilon$ y luego $d(x, x_n) < epsilon$ pues ambos están en
  $overline(A_n)$.
]

== Ejercicio 4

#enunciado[Ejercicio 4][
  Sean $(X, d)$ y $(Y, d')$ espacios métricos con $X = C([0, 1])$ y $cal(F) : X -> Y$ una función. Probar que si $cal(F)$ es continua con $d = d_1$ entonces también es continua con $d = d_oo$. ¿Vale la recíproca?
]

#resolucion[Cátedra][
  Primero veamos que dados $f in X$ y $r > 0$ sucede que
  $B^(d_oo)(f, r) subset.eq B^(d_1)(f, r)$ donde la primera bola está considerada en el espacio
  $(X, d_oo)$ y la segunda, en $(X, d_1)$. Entonces sea $g in X$ tal que $d_oo (f, g) < r$, luego
  $ d_1(f, g) & = integral_0^1 abs(f(x) - g(x)) dif x \
    & <= integral_0^1 op("máx", limits: #true)_(z in [0, 1]) abs(f(z) - g(z)) dif x \
    & = d_oo (f, g) $
  y obtenemos lo buscado.

  Entonces probemos el ejercicio. Por la teórica sabemos que $cal(F)$ es continua con la métrica
  $d_1$ es equivalente a que dados $f$ y $epsilon > 0$ existe $delta > 0$ tal que
  $ cal(F)(B^(d_1)(f, delta)) subset.eq B(cal(F)(f), epsilon) $
  donde la última bola es en $(Y, d')$. Por lo anterior tenemos que
  $cal(F)(B^(d_oo)(f, delta)) subset.eq cal(F)(B^(d_1)(f, delta))$ y así
  $ cal(F)(B^(d_oo)(f, delta)) subset.eq B(cal(F)(f), epsilon) $
  que prueba la continuidad de $cal(F)$ en $(X, d_oo)$.

  Para la última pregunta vimos en clase que la función evaluación $cal(E) : X -> RR$ es continua
  en $d_oo$ y no en $d_1$, por lo cual no vale la vuelta.
]

#v(12pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

= Verificación en Lean

#progreso[
  Las cuatro resoluciones oficiales están formalizadas en `lean/Parciales/Parcial1_2C2024.lean`
  (Lean 4 + Mathlib, `cd lean && lake build`). Cada enunciado está escrito tal cual y cada
  demostración sigue el argumento de la cátedra; abajo se anota, ejercicio por ejercicio, qué
  teorema lo certifica y en qué se aparta la formalización del texto. Ninguna demostración usa
  `sorry`; los únicos axiomas son los estándar de Lean.
]

#observacion[Ejercicio 1: `ej1`][
  Calco del texto: $op("ínf")(A) + op("ínf")(B)$ es cota inferior de $A + B$ (`csInf_le`), y para
  cada $epsilon > 0$ hay $a in A$, $b in B$ con $a < op("ínf")(A) + epsilon/2$,
  $b < op("ínf")(B) + epsilon/2$ (`exists_lt_of_csInf_lt`); "como $epsilon$ era cualquiera" es
  `le_of_forall_pos_lt_add`. Sólo se usa que $A$ y $B$ estén acotados *inferiormente*.
]

#observacion[Ejercicio 2: `ej2 : #𝒜 = 𝔠`][
  `𝒜` es ${B subset.eq QQ : \#B = \#(QQ without B)}$ y `Φ B = B ∪ ((1,2) ∩ ℚ)` es la función del
  texto. `Φ_mem` reproduce las dos cadenas de desigualdades (los dos lados contienen a
  $(1,2) inter QQ$ y a $(2,3) inter QQ$, infinitos, y están dentro de $QQ$, contable, así que
  ambos tienen cardinal $aleph_0$). El texto dice "construimos una función inyectiva" sin
  verificar la inyectividad; `Φ_injective` la prueba: $n in B <==> n in Phi(B)$, porque ningún
  natural está en $(1, 2)$. La cota superior usa $\#cal(P)(QQ) = 2^(aleph_0) = frak(c)$.
]

#observacion[Ejercicio 3: `ej3`][
  La hipótesis del enunciado se formaliza para sucesiones de cerrados, *acotados* y no vacíos:
  en el curso el diámetro sólo está definido para conjuntos acotados (Definición 4.9), mientras
  que en Mathlib `diam` de un conjunto no acotado vale $0$ por convención, y sin la palabra
  "acotados" la hipótesis de Lean sería más fuerte que la del parcial. Con ella, es el enunciado
  de la Práctica 3, Ej. 16.

  La prueba sigue el texto: `A n` es $overline(union.big_(m >= n) B(x_m, 1/(n+1)))$ (índices desde
  $0$), se verifica que son cerrados, no vacíos, decrecientes y acotados (toda sucesión de Cauchy
  es acotada, `cauchySeq_bdd`), y el diámetro se acota con $epsilon/5$ como en el texto
  (`Metric.diam_le_of_forall_dist_le`, `Metric.diam_closure`). El punto $x$ de la intersección es
  el límite porque $d(x_n, x) <= op("diam")(A_n)$ (`Metric.dist_le_diam_of_mem`).
]

#observacion[Ejercicio 4: `d1_le_dist`, `ej4` y `ej4_reciproca_falsa`][
  $X = C[0,1]$ es `C(unitInterval, ℝ)` con $d_oo$; $d_1$ se define a mano como integral (`d1`) y
  "continua con $d_1$" se escribe con $epsilon$-$delta$. `d1_le_dist` es la inclusión de bolas
  $B^(d_oo)(f, r) subset.eq B^(d_1)(f, r)$ del texto, en la forma $d_1 (f, g) <= d_oo (f, g)$.
  `ej4` deduce `Continuous F` (para $d_oo$) de la hipótesis $epsilon$-$delta$ en $d_1$.

  Para la recíproca el texto cita lo visto en clase (la evaluación $cal(E)$ es continua para
  $d_oo$ y no para $d_1$; Práctica 4, Ej. 9). `ej4_reciproca_falsa` lo prueba: `E f = f 0` es
  continua para $d_oo$ (`continuous_eval_const`) y no es $d_1$-continua en $0$, porque la función
  "carpa" $g_h (x) = max{0, 1 - x/h}$ cumple $d_1 (g_h, 0) <= h$ (se parte la integral en $[0, h]$ y
  $[h, 1]$) pero $cal(E)(g_h) = 1$.
]
