#import "../utils.typ": *

#align(center)[
  #text(14pt, weight: "bold")[Análisis Avanzado - Segundo cuatrimestre de 2025] \
  #v(2pt)
  #text(12pt, weight: "medium")[Práctica 9]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

_En lo que sigue $cal(M)$ será la $sigma$-álgebra de los conjuntos medibles Lebesgue de $RR$ y $mu$ la medida de Lebesgue. Además, $E$ denotará a un subconjunto medible Lebesgue de $RR$._

#set enum(numbering: "1.")

+ Sea $f$ una función simple. Pruebe que $|f|$ es simple.

+ Pruebe que dada una $sigma$-álgebra $cal(A)$ de subconjuntos de $X$ y dada $f : X -> RR$, son equivalentes:
  #set enum(numbering: "(a)")
  + $\{x in X : f(x) > a\} in cal(A)$ para todo $a in RR$.
  + $\{x in X : f(x) <= a\} in cal(A)$ para todo $a in RR$.
  + $\{x in X : f(x) >= a\} in cal(A)$ para todo $a in RR$.
  + $\{x in X : f(x) < a\} in cal(A)$ para todo $a in RR$.

  Concluya que si $X in cal(M)$ y $cal(A) = cal(M)$, entonces $f$ es medible si y solo si vale alguno de (y por lo tanto, todos) los ítems de arriba.

+ Sean $f, g : E -> RR$. Pruebe que:
  #set enum(numbering: "(a)")
  + Si $f$ es medible entonces $\{x in E : f(x) = a\} in cal(M)$ para todo $a in RR$.
  + Si $f$ y $g$ son medibles entonces $\{x in E : f(x) <= g(x)\} in cal(M)$.
  + Si $f$ es medible y $f(x) = g(x)$ para casi todo $x in E$, entonces $g$ es medible.

+ Sean $f, g : E -> RR$ funciones medibles. Pruebe que:
  #set enum(numbering: "(a)")
  + $f + g$ es medible.
  + $alpha f$ es medible para todo $alpha in RR$.
  + $f^2$ es medible.
  + $f dot g$ es medible. \
    _Sugerencia:_ $f dot g = ((f + g)^2 - (f - g)^2)/4$.

+ Sea $f : RR -> RR$ monótona. Pruebe que $f$ es medible.

+ Sea $f : [0, 1] -> RR$ una función. Pruebe que:
  #set enum(numbering: "(a)")
  + Si $f$ es continua en $[0, 1]$, entonces es medible.
  + Si $f$ es continua en casi todo punto de $[0, 1]$ (esto es, si su conjunto de discontinuidades es nulo), entonces es medible.

+ Dada una sucesión $(f_n)_n$ de funciones en $E$, consideremos las funciones
  $ S(x) = sup_(n in NN) f_n (x) quad y quad I(x) = inf_(n in NN) f_n (x). $
  Pruebe que si las funciones $f_n$ son medibles, entonces $S$ e $I$ también lo son.

+ Dada $(f_n)_n$ una sucesión de funciones medibles y no negativas con $f_n : E -> RR$ para todo $n in NN$, sea $f(x) = sum_(n=1)^infinity f_n (x)$. Pruebe que $f$ es medible, y que
  $ integral_E f d mu = sum_(n=1)^infinity integral_E f_n d mu. $

+ Sea $f : E -> RR$ una función medible, no negativa e integrable. Pruebe que si $A in cal(M)$, entonces
  $ integral_A f(x + y) d mu(x) = integral_(A + y) f(x) d mu(x) $
  para todo $y in RR$ tal que $A + y subset.eq E$.

+ Sea $f : E -> RR$ una función medible y acotada. Supongamos que $E$ tiene medida finita. Pruebe que $f$ es integrable.

+ Sean $f, g : E -> RR$ funciones medibles e integrables tales que para todo $A subset.eq E$ medible se tiene que $integral_A f d mu = integral_A g d mu$. Pruebe que $f = g$ en casi todo punto de $E$.

+ Sea $E = [0, +infinity)$. Considere, para cada $n in NN$, $f_n : E -> RR$ dada por $f_n = (-1/n) chi_([0, n])$. Pruebe que la sucesión $(f_n)_n$ converge uniformemente a la función nula en $E$. Pruebe que, sin embargo $integral_E f_n d mu = -1$, de manera que
  $ lim inf_(n -> oo) integral_E f_n d mu = -1 < 0 = integral_E lim inf_(n -> oo) f_n d mu. $
  Deduzca que el lema de Fatou no vale si las funciones $f_n$ no son no negativas, aún cuando converjan uniformemente.

+ Sean $f : E -> RR$ una función integrable y $(E_n)_(n in NN)$ una sucesión de subconjuntos medibles de $E$ tales que $E = union_(n in NN) E_n$. Pruebe que:
  #set enum(numbering: "(a)")
  + Si los $E_n$ son disjuntos dos a dos entonces
    $ integral_E f d mu = sum_(n=1)^infinity integral_(E_n) f d mu. $
  + Si $(E_n)_(n in NN)$ es creciente entonces
    $ lim_(n -> oo) integral_(E_n) f d mu = integral_E f d mu quad y quad lim_(n -> oo) integral_(E \ E_n) f d mu = 0. $
