#import "utils.typ": *

#align(center)[
  #text(14pt, weight: "bold")[Análisis Avanzado] \
  #v(2pt)
  #text(12pt, weight: "medium")[Segundo parcial - 30 de noviembre de 2024]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(6pt)

#text(9pt)[
  _Nota: se aprueba con dos de los primeros cuatro ejercicios bien y completos. El *5* es optativo y *de ningún modo* influirá en la calificación. Además, recordar que la encuesta de finalización de cuatrimestre es obligatoria y *quienes no la completen reprobarán la materia*. Buena suerte, justifique *todas* sus respuestas y escriba con claridad._
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#set enum(numbering: "1.")

+ Sean $E$ un espacio métrico y $f : E -> E$ una función. Probar que si $E$ es completo y existe $n in NN$ tal que $f^n$ es una contracción, entonces existe un único punto fijo de $f$ en $E$. \
  _*Sugerencia:* probar que si $x in E$ es punto fijo de $f^n$, entonces $f(x)$ también lo es._

+ Probar que la función $c : RR -> RR$ dada por
  $ c(x) = sum_(n=0)^oo ((-1)^n x^(2n)) / ((2n)!) $
  está bien definida, es dos veces derivable y $c'' + c = 0$.

+ Sea $f : RR -> RR$ una función Lipschitz. Probar que $f(A)$ es medible y que $mu(f(A)) = 0$ para todo $A$ nulo.

+ Sean $f : E_1 -> RR$ una función y $(E_n)_(n in NN)$ una sucesión decreciente de subconjuntos medibles. Supongamos que existe $n_0 in NN$ tal que $f$ restringida a $E_(n_0)$ resulta integrable. Probar que
  $ lim_(n -> oo) integral_(E_n) f d mu = integral_(inter.big_(n in NN) E_n) f d mu. $

+ *(Optativo: Teorema de existencia de Picard.)* Sea $f : RR^d -> RR^d$ una función Lipschitz continua. Entonces, dado $y_0 in RR^d$, existe $epsilon > 0$ tal que el problema de valores iniciales
  $ y'(t) = f(y(t)), quad y(0) = y_0 $
  tiene solución en el intervalo $[-epsilon, epsilon]$. \
  _*Sugerencia:* definir $X = C([-epsilon, epsilon], RR^d)$ con $epsilon$ adecuado tal que $phi : X -> X$ dada por_
  $ phi(y)(t) = y_0 + integral_0^t f(y(s)) d mu(s) $
  _*sea una contracción.*_
