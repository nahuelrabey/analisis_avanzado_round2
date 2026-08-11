#import "../utils.typ": *
#show: frame-style(styles.boxy)

#align(center)[
  #text(14pt, weight: "bold")[Análisis Avanzado - Segundo cuatrimestre de 2025] \
  #v(2pt)
  #text(12pt, weight: "medium")[Práctica 4]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#set enum(numbering: "1.")

+ Decida cuáles de las siguientes funciones son continuas:
  #set enum(numbering: "(a)")
  + $f : (RR^2, d_2) -> (RR, d_2)$, $f(x, y) = x^2 + y^2$.
  + $f : (RR^2, d_2) -> (RR, d_2)$,
    $ f(x, y) = cases(
      (x^2 y)/(1/2 x^2 + (x-1)^2 y^2) &"si " (x, y) != (0, 0),,
      0 &"si " (x, y) = (0, 0).
    ) $
  + $op("id")_(RR^2) : (RR^2, delta) -> (RR^2, d_2)$, la función identidad.
  + $op("id")_(RR^2) : (RR^2, d_2) -> (RR^2, delta)$, la función identidad.

  Aquí $d_2$ es la métrica euclídea usual, y $delta$ es la métrica discreta.
  ¿Cambia algo si en lugar de $d_2$ consideramos $d_1$ o $d_infinity$?

+ Sea $f : RR -> RR$ dada por
  $ f(x) = cases(
    x &"si " x in QQ,,
    0 &"si " x not in QQ.
  ) $
  Pruebe que $f$ es continua únicamente en $x = 0$.

+ Sea $E$ un espacio métrico, y sea $x_0 in E$. Sea $f : E -> RR$ una función continua en $x_0$. Pruebe que si $f(x_0) > 0$ entonces existe $r > 0$ tal que $f(x) > 0$ para todo $x in B(x_0, r)$.

+ Sean $E$ y $E'$ espacios métricos y $f, g : E -> E'$ funciones continuas.
  #set enum(numbering: "(a)")
  + Pruebe que $\{x in E : f(x) != g(x)\}$ es abierto.
  + Deduzca que $\{x in E : f(x) = g(x)\}$ es cerrado.

+ Considerando en cada $RR^n$ la métrica euclídea $d_2$, pruebe que:
  #set enum(numbering: "(a)")
  + $\{(x, y) in RR^2 : x^2 + y sin(e^x - 1) = -2\}$ es cerrado.
  + $\{(x, y, z) in RR^3 : -1 <= x^3 - 3y^4 + z - 2 <= 3\}$ es cerrado.
  + $\{(x_1, x_2, x_3, x_4, x_5) in RR^5 : 3 < x_1 - x_2\}$ es abierto.

  ¿Cambia algo si en lugar de $d_2$ consideramos las métricas $d_1$ o $d_infinity$?

+ Sean $f, g : RR -> RR$ dadas por $f(x) = x^2$, $g(x) = x^2 / (1 + x^2)$. Pruebe que:
  #set enum(numbering: "(a)")
  + $f$ es continua, y sin embargo existe $G subset.eq RR$ abierto tal que $f(G)$ no es abierto.
  + $g$ es continua, y sin embargo existe $F subset.eq RR$ cerrado tal que $g(F)$ no es cerrado.

+ Sean $E$ y $E'$ espacios métricos y $f, g : E -> E'$ funciones continuas.
  #set enum(numbering: "(a)")
  + Sea $D subset.eq E$ un subconjunto denso. Pruebe que si $f|_D = g|_D$, entonces $f = g$.
  + Concluya que la función $cal(R) : C([0, 1]) -> \{f : QQ inter [0, 1] -> RR\}$ dada por $cal(R)(f) = f|_(QQ inter [0, 1])$ es inyectiva.

+ Sean $E$ y $E'$ espacios métricos y $f : E -> E'$ una función continua y suryectiva. Pruebe que si $D$ es denso en $E$ entonces $f(D)$ es denso en $E'$.

+ Consideramos las funciones $cal(E), cal(I) : C([0, 1]) -> RR$ definidas por:
  $ cal(E)(f) = f(0), quad cal(I)(f) = integral_0^1 f(x) dif x. $
  #set enum(numbering: "(a)")
  + Demuestre que si utilizamos en $C([0, 1])$ la distancia $d_infinity$ ambas resultan continuas.
  + Demuestre que si en cambio utilizamos en $C([0, 1])$ la distancia $d_1$, $cal(I)$ es una función continua pero $cal(E)$ no lo es.
  + Analice si es posible que una función $cal(F) : C([0, 1]) -> RR$ sea continua para la distancia $d_1$ pero no para $d_infinity$.

+ Sea $(E, d)$ un espacio métrico.
  #set enum(numbering: "(a)")
  + Sea $x_0 in E$, y sea $f : E -> RR$ dada por $f(x) = d(x, x_0)$. Pruebe que $f$ es continua.
  + Usando esto rehaga los ítems (b), (d) y (g) del Ejercicio 4 de la Práctica 3.

+ Sea $(E, d)$ un espacio métrico.
  #set enum(numbering: "(a)")
  + Sea $A subset.eq E$, y sea $g : E -> RR$ dada por $g(x) = d(x, A)$.
    #set enum(numbering: "i.")
    + Pruebe que $g$ es continua.
    + Pruebe que si $A$ es cerrado entonces $g(x) > 0$ para todo $x not in A$.
  + Sean $A, B subset.eq E$ cerrados, no vacíos y disjuntos, y sea $h : E -> [0, 1]$ dada por
    $ h(x) = d(x, A) / (d(x, A) + d(x, B)). $
    Pruebe que $h$ es continua, y que $h(x) = 0$ $forall x in A$ y $h(x) = 1$ $forall x in B$.
  + Sean $A, B subset.eq E$ cerrados, no vacíos y disjuntos. Pruebe que existen conjuntos abiertos y disjuntos $U$ y $V$ tales que $A subset.eq U$ y $B subset.eq V$.

  _Nota: esta última afirmación está comprendida en el llamado Lema de Urysohn._

+ Pruebe que las funciones $f$ y $g$ de los ejercicios 10 y 11 son de tipo Lipschitz. Deduzca que son uniformemente continuas.

+ #set enum(numbering: "(a)")
  + Verifique que la función $f(x) = 1/x$ no es uniformemente continua en $(0, +oo)$. ¿Y en $[epsilon, +oo)$ para $epsilon > 0$?
  + Verifique que la función $f(x) = sin(1/x)$ no es uniformemente continua en $(0, 1)$.

+ Sean $E, E'$ espacios métricos y sea $f : E -> E'$ una función uniformemente continua. Sea $(x_n)_(n in NN)$ una sucesión de Cauchy en $E$. Pruebe que $(f(x_n))_(n in NN)$ es una sucesión de Cauchy en $E'$.

+ #set enum(numbering: "(a)")
  + Dé un ejemplo de una función $f : RR -> RR$ acotada y continua pero no uniformemente continua.
  + Dé un ejemplo de una función $f : RR -> RR$ no acotada y uniformemente continua.

+ Sea $f : (E, d) -> (E', d')$ una función uniformemente continua, y sean $A, B subset.eq E$ conjuntos no vacíos tales que $d(A, B) = 0$. Pruebe que $d'(f(A), f(B)) = 0$.
