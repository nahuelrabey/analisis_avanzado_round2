#import "../utils.typ": *

#align(center)[
  #text(14pt, weight: "bold")[Análisis Avanzado - Segundo cuatrimestre de 2025] \
  #v(2pt)
  #text(12pt, weight: "medium")[Práctica 5]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#set enum(numbering: "1.")

*Compacidad*

+ Sea $K = \{0\} union \{1/n : n in NN\} subset.eq RR$. Pruebe, por definición, que $K$ es compacto.

+ Sea $K$ un subconjunto compacto no vacío de $RR$. Pruebe que $K$ tiene mínimo y máximo.

+ Sea $K subset.eq RR$ compacto. Pruebe que los subconjuntos de $RR$
  $ S = \{x + y : x, y in K\}, quad P = \{x \cdot y : x, y in K\} $
  también son compactos.

+ Sea $E$ un espacio métrico y sea $\{F_i\}_(i in I)$ una familia de subconjuntos cerrados de $E$. Pruebe que si existe $i_0 in I$ tal que $F_(i_0)$ es compacto, entonces $inter_(i in I) F_i$ es compacto.

+ Sea $E$ un espacio métrico. Pruebe que $E$ es compacto si y solo si para toda sucesión $(F_n)_(n >= 1)$ decreciente (es decir, $F_(n+1) subset.eq F_n$ para todo $n in NN$) de cerrados no vacíos de $E$ se tiene que $inter_(n >= 1) F_n != nothing$.

+ Sea $E$ un espacio métrico discreto. ¿Cuáles son los subconjuntos compactos de $E$?

+ Pruebe que la unión de un número finito de conjuntos compactos es compacto.

+ Pruebe que en un espacio métrico $(E, d)$ la distancia de un punto a un compacto _se realiza_. Esto es, que para todo compacto $K subset.eq E$ y para todo $x in E$ existe $y in K$ tal que $d(x, y) = d(x, K)$.

+ Sea $(E, d)$ un espacio métrico, y sea $hat(d)$ la función definida en el Ejercicio 11 de la Práctica 3. Pruebe que si $A subset.eq E$ es compacto, $B subset.eq E$ es cerrado y se cumple que $A inter B = nothing$, entonces $hat(d)(A, B) > 0$. ¿Sucede lo mismo si $A$ es solo cerrado?

+ Consideremos en $(C[0, 1], d_infinity)$ la función $f_0$ nula. Pruebe que $overline(B(f_0, 1))$ no es compacta (pero sí es cerrada y acotada). ¿Qué pasa si cambiamos $d_infinity$ por $d_1$?

+ Sea $E$ un espacio métrico compacto, y sea $f : E -> (0, +oo)$ una función continua. Pruebe que existe $alpha > 0$ tal que $f(x) > alpha$ para todo $x in E$.

+ Sea $f : RR -> RR$ continua tal que
  $ lim_(x -> -oo) f(x) = lim_(x -> +oo) f(x) = 0. $
  Pruebe que $f$ es uniformemente continua en $RR$.

+ Sean $E$ y $E'$ espacios métricos y $f : E -> E'$ continua. Pruebe que si $E$ es compacto y $f$ es biyectiva, entonces $f$ es un homeomorfismo.

#v(6pt)
*Teoremas de punto fijo*
#v(4pt)

+ Sea $E$ un espacio métrico y sea $f : E -> E$ continua. Pruebe que el conjunto de puntos fijos de $f$ es cerrado.

+ Sea $f : RR -> RR$ dada por $f(x) = 1/2 arctan(x) + 3$. Pruebe que $f$ es una contracción.

+ Sea $E = RR backslash \{0\}$, con la distancia usual de $RR$. Sea $f : E -> E$ dada por $f(x) = 1/3 x$. Pruebe que $f$ es una contracción pero no tiene punto fijo. ¿Qué falla del Teorema de Banach?

+ Sea $E$ un espacio métrico y sea $f : E -> E$ una función. Para $n in NN$ denotemos por $f^n : E -> E$ a la función $f compose f compose dots compose f$ ($n$ veces). Pruebe las siguientes afirmaciones:
  #set enum(numbering: "(a)")
  + Si $x in E$ es punto fijo de $f$, entonces es punto fijo de $f^n$.
  + Si $E$ es completo y existe $n in NN$ tal que $f^n$ es una contracción, entonces existe un único punto fijo de $f$ en $E$.

    _Sugerencia: pruebe que si $x in E$ es punto fijo de $f^n$, entonces $f(x)$ también lo es._

  + Deduzca que existe un único $x in RR$ tal que $cos(x) = x$.

+ Considere en $RR^n$ la métrica $d_2$. Sea $f : RR^n -> RR^n$ una función continua. Supongamos que existe $M > 0$ tal que para todo $epsilon > 0$ existe $x in B(0, M)$ tal que $d_2(x, f(x)) < epsilon$. Pruebe que $f$ tiene un punto fijo.

+ Sea $f : [a, b] -> [a, b]$ continua. Pruebe que $f$ tiene un punto fijo.

  _Sugerencia: use el teorema de Bolzano._
