#import "../utils.typ": *

#align(center)[
  #text(14pt, weight: "bold")[Análisis Avanzado - Segundo cuatrimestre de 2025] \
  #v(2pt)
  #text(12pt, weight: "medium")[Práctica 8]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

_En lo que sigue $cal(M)$ será la $sigma$-álgebra de los conjuntos medibles Lebesgue de $RR$ y $mu$ la medida de Lebesgue._

#set enum(numbering: "1.")

+ Sea $X$ un conjunto y sea
  $ cal(A) = \{A subset.eq X : A " es contable o " X \ A " es contable"\}. $
  Pruebe que $cal(A)$ es una $sigma$-álgebra.

+ Sea $X$ un conjunto y sea $cal(A)$ una $sigma$-álgebra de subconjuntos de $X$. Pruebe que:
  #set enum(numbering: "(a)")
  + $nothing in cal(A)$.
  + Si $A, B in cal(A)$ entonces $A \ B in cal(A)$ y $A Delta B in cal(A)$.
  + $cal(A)$ es cerrada por intersecciones numerables.

+ Pruebe que todo subconjunto numerable de $RR$ es nulo.

+ Pruebe que para todos $a, b in RR$ los intervalos $[a, b)$, $[a, b]$, $[a, +infinity)$ son medibles Lebesgue, y calcule su medida.

+ Sea $A subset.eq RR$.
  #set enum(numbering: "(a)")
  + Pruebe que si $A$ es abierto entonces $A in cal(M)$.
  + Deduzca que si $A$ es cerrado entonces $A in cal(M)$.

+ Calcule la medida de Lebesgue de $QQ$ y la de los irracionales del $[0, 1]$. ¿Por qué son medibles estos conjuntos?

+ Pruebe que todo conjunto acotado de $cal(M)$ tiene medida finita. Muestre un conjunto de $cal(M)$ que tenga medida de Lebesgue finita pero que no sea acotado.

+ Si $A, B in cal(M)$, pruebe que $mu(A union B) + mu(A inter B) = mu(A) + mu(B)$.

+ Sea $A in cal(M)$. Pruebe que si $mu(A) = 0$ entonces $A^circle = nothing$. ¿Vale la recíproca?

+ Sea $A subset.eq [0, 1]$ un conjunto medible Lebesgue tal que $mu(A) = 1$. Pruebe que $A$ es denso en $[0, 1]$.

+ Sea $A subset.eq RR$. Pruebe que las siguientes afirmaciones son equivalentes:
  #set enum(numbering: "(a)")
  + $A in cal(M)$.
  + Existen una sucesión $(F_n)_(n in NN)$ de conjuntos cerrados contenidos en $A$ y un conjunto $Z$ de medida nula tales que $A = (union_(n in NN) F_n) union Z$.
  + Existen una sucesión $(G_n)_(n in NN)$ de conjuntos abiertos que contienen a $A$ y un conjunto $H$ de medida nula tales que $A = (inter_(n in NN) G_n) \ H$.

+ Sea $A subset.eq RR$. Pruebe que $A in cal(M)$ si y sólo si para todo $epsilon > 0$ existen conjuntos $G$ abierto y $F$ cerrado tales que $F subset.eq A subset.eq G$ y $mu(G \ F) < epsilon$.

+ Sea $(A_n)_(n in NN) subset.eq cal(M)$ y $B in cal(M)$ tales que $lim_(n -> oo) mu(A_n Delta B) = 0$. Pruebe que $lim_(n -> oo) mu(A_n) = mu(B)$.

+ Recordemos que para $c in RR$ y $A subset.eq RR$ denotamos
  $ c A = \{c a : a in A\}. $
  #set enum(numbering: "(a)")
  + Pruebe que si $A in cal(M)$ entonces $c A in cal(M)$.
  + Pruebe que si $c > 0$ entonces $mu(c A) = c mu(A)$.
  + ¿Qué se puede decir de $mu(c A)$ en el caso $c < 0$?

+ Pruebe que existe una función sobreyectiva $f : [0, 1] -> RR$ que vale $0$ en casi todo punto de $[0, 1]$. ¿Puede una tal función ser continua?
