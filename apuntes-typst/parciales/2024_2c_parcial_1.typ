#import "@preview/frame-it:2.0.0": *
#import "../utils.typ": *
#show figure.where(kind: "frame"): set figure(numbering: none)
#show figure.where(kind: "frame"): set block(breakable: true)
#show: frame-style(styles.boxy)

// Fuente: `parciales/resolucion_oficial_1er_parcial_2c2024.pdf` (enunciado + resolución oficial
// de la cátedra). Las resoluciones de abajo son transcripción de ese documento, sin agregados.

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

== Ejercicio 3

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
