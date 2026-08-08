#import "../utils.typ": *

#align(center)[
  #text(14pt, weight: "bold")[Análisis Avanzado - Segundo cuatrimestre de 2025] \
  #v(2pt)
  #text(12pt, weight: "medium")[Práctica 3]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#set enum(numbering: "1.")

+ Pruebe que los siguientes son espacios métricos. Dibuje, en cada caso, una bola abierta.
  #set enum(numbering: "(a)")
  + $RR$ con $d(x, y) = |x - y|$.
  + $RR^n$ con $d_2(x, y) = (sum_(i=1)^n (x_i - y_i)^2)^(1/2)$.
  + $RR^n$ con $d_1(x, y) = sum_(i=1)^n |x_i - y_i|$.
  + $RR^n$ con $d_infinity(x, y) = max_(1 <= i <= n) |x_i - y_i|$.
  + $C([0, 1])$ con $d_infinity(f, g) = max_(0 <= t <= 1) |f(t) - g(t)|$.
  + $E$ un conjunto no vacío, con la métrica
    $ delta(x, y) = cases(
      0 &"si " x = y,,
      1 &"si " x != y.
    ) $

+ Decida cuáles de las siguientes funciones definidas en $RR times RR$ son métricas en $RR$:
  #set enum(numbering: "(a)")
  #grid(
    columns: (1fr, 1fr, 1fr),
    row-gutter: 10pt,
    [+ $d(x, y) = (x - y)^2$],
    [+ $d(x, y) = sqrt(|x - y|)$],
    [+ $d(x, y) = |x^2 - y^2|$]
  )

+ Halle interior y clausura de cada uno de los siguientes subconjuntos de $RR$. Determine cuáles son abiertos o cerrados.
  #set enum(numbering: "(a)")
  #grid(
    columns: (1fr, 1fr),
    row-gutter: 10pt,
    [+ $[0, 1]$],
    [+ $(0, 1)$],
    [+ $QQ$],
    [+ $QQ inter [0, 1]$],
    [+ $ZZ$],
    [+ $[0, 1) union \{2\}$],
    [+ $\{1/n : n in NN\}$],
    [+ $\{1/n : n in NN\} union \{0\}$]
  )

+ Sea $(E, d)$ un espacio métrico. Sean $x in E$ y $r > 0$.
  #set enum(numbering: "(a)")
  + Pruebe que $\{x\}$ es un conjunto cerrado.
  + Pruebe que $B(x, r)$ es un conjunto abierto.
  + Pruebe que si $r > r' > 0$ entonces $overline(B(x, r')) subset.eq B(x, r)$.
  + Pruebe que $overline(B)(x, r) = \{y in E : d(x, y) <= r\}$ es un conjunto cerrado.
  + Deduzca que $overline(B(x, r)) subset.eq overline(B)(x, r)$.
  + Dé un ejemplo en que $overline(B(x, r))$ sea un subconjunto propio de $overline(B)(x, r)$.
  + Pruebe que $\{y in E : 2 < d(y, x) < 3\}$ es un conjunto abierto.

+ Sea $E$ un espacio métrico y sea $A subset.eq E$. Pruebe que:
  #set enum(numbering: "(a)")
  + $E backslash A^compose = overline(E backslash A)$.
  + $E backslash overline(A) = (E backslash A)^compose$.

  ¿Son ciertas las igualdades $overline(A) = overline(A^compose)$ y $A^compose = (overline(A))^compose$?

+ Sea $E$ un espacio métrico y sean $A, B subset.eq E$. Pruebe que:
  #set enum(numbering: "(a)")
  + $(A inter B)^compose = A^compose inter B^compose$.
  + $A^compose union B^compose subset.eq (A union B)^compose$.
  + $overline(A union B) = overline(A) union overline(B)$.
  + $overline(A inter B) subset.eq overline(A) inter overline(B)$.

  Encuentre ejemplos en que no valga la igualdad en (b) y (d).

+ Sean $E$ un espacio métrico y $A, B subset.eq E$ subconjuntos acotados de $E$.
  #set enum(numbering: "(a)")
  + Pruebe que si $A subset.eq B$ entonces $op("diam")(A) <= op("diam")(B)$.
  + Pruebe que $op("diam")(A) = op("diam")(overline(A))$.

+ Halle frontera y puntos de acumulación de cada uno de los subconjuntos de $RR$ del Ejercicio 3.

+ Sea $E$ un espacio métrico y sea $A subset.eq E$.
  #set enum(numbering: "(a)")
  + Pruebe que $partial A = overline(A) backslash A^compose$, y concluya que $partial A$ es cerrado.
  + Pruebe que $partial A = overline(A) inter overline(E backslash A)$, y concluir que $partial A = partial(E backslash A)$.

+ Sea $(E, d)$ un espacio métrico. Dados $A subset.eq E$ no vacío y $x in E$, se define la _distancia de $x$ a $A$_ como
  $ d(x, A) = op("ínf")\{d(x, a) : a in A\}. $
  Pruebe que para todos $x, y in E$ y $r > 0$:
  #set enum(numbering: "(a)")
  + $|d(x, A) - d(y, A)| <= d(x, y)$.
  + $x in A => d(x, A) = 0$.
  + $d(x, A) = 0 <=> x in overline(A)$.
  + $B_A (r) = \{x in E : d(x, A) < r\}$ es abierto.
  + $overline(B)_A (r) = \{x in E : d(x, A) <= r\}$ es cerrado.

+ Sea $(E, d)$ un espacio métrico. Consideremos el conjunto $cal(X) = \{A subset.eq E : A != nothing\}$. Definimos la función $hat(d) : cal(X) times cal(X) -> RR$ como
  $ hat(d)(A, B) = op("ínf")\{d(a, b) : a in A, b in B\}. $
  Determine si las siguientes afirmaciones son verdaderas o falsas:
  #set enum(numbering: "(a)")
  + $hat(d)(A, B) = hat(d)(overline(A), B)$.
  + $hat(d)(A, B) = 0 <=> A inter B != nothing$.
  + $hat(d)(A, B) = 0 <=> overline(A) inter overline(B) != nothing$.
  + $hat(d)(A, B) <= hat(d)(A, C) + hat(d)(C, B)$.

  Concluya que $hat(d)$ no es una distancia.

+ Considere en $RR^n$ las distancias $d_1$, $d_2$ y $d_infinity$.
  #set enum(numbering: "(a)")
  + Pruebe que estas tres distancias son equivalentes; más aún, pruebe que
    $ d_infinity(x, y) <= d_2(x, y) <= d_1(x, y) <= n d_infinity(x, y). $
  + Denotemos por $B_1(x, r)$, $B_2(x, r)$ y $B_infinity(x, r)$ a la bola de centro $x$ y radio $r$ para cada una de las distancias, respectivamente. Deduzca de (a) que
    $ B_1(x, r) subset.eq B_2(x, r) subset.eq B_infinity(x, r) subset.eq B_1(x, n r). $
    Compare estas contenciones con los dibujos hechos en el Ejercicio 1.

+ Sea $(E, d)$ un espacio métrico y sean $(x_n)_(n in NN)$, $(y_n)_(n in NN)$ sucesiones en $E$.
  #set enum(numbering: "(a)")
  + Si $lim_(n -> oo) x_n = x$ y $lim_(n -> oo) y_n = y$, pruebe que $lim_(n -> oo) d(x_n, y_n) = d(x, y)$.
  + Si $(x_n)_(n in NN)$, $(y_n)_(n in NN)$ son dos sucesiones de Cauchy en $E$, pruebe que la sucesión de números reales $(d(x_n, y_n))_(n in NN)$ es convergente.

+ Pruebe que $(RR^n, d_1)$, $(RR^n, d_2)$ y $(RR^n, d_infinity)$ son completos.

+ Sea $(E, d)$ un espacio métrico completo y $A subset.eq E$ un subconjunto de $E$. Pruebe que si $A$ es cerrado entonces el espacio métrico $(A, d)$ es completo.

+ *Teorema de la intersección (Cantor).* Sea $E$ un espacio métrico completo. Sea $(A_n)_(n in NN)$ una sucesión de subconjuntos cerrados, acotados y no vacíos de $E$ tales que
  - $A_(n+1) subset.eq A_n$ para todo $n >= 1$.
  - $lim_(n -> oo) op("diam")(A_n) = 0$.

  Pruebe que existe un único elemento $x in inter_(n in NN) A_n$.
