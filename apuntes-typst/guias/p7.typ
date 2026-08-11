#import "../utils.typ": *
#show: frame-style(styles.boxy)

#align(center)[
  #text(14pt, weight: "bold")[Análisis Avanzado - Segundo cuatrimestre de 2025] \
  #v(2pt)
  #text(12pt, weight: "medium")[Práctica 7]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#set enum(numbering: "1.")

+ Sea $A$ un conjunto, y sea $(Y, d)$ un espacio métrico. Sea $f : A -> Y$, y para cada $n in NN$, sea $f_n : A -> Y$. \
  Pruebe que la sucesión $(f_n)_(n >= 1)$ _no_ converge uniformemente a $f$ si y solo si existen $alpha > 0$, una subsucesión $(f_(n_k))_(k >= 1)$ y una sucesión $(a_k)_(k >= 1) subset.eq A$ tales que
  $ d(f_(n_k) (a_k), f(a_k)) >= alpha quad forall k in NN. $

+ Analice la convergencia puntual y uniforme de las siguientes sucesiones de funciones:
  #set enum(numbering: "(a)")
  + $f_n : RR -> RR$, $f_n (x) = 1/n sin(n x)$.
  + $f_n : RR -> RR$, $f_n (x) = sin(x/n)$.
  + $f_n : RR^2 -> RR^2$, $f_n (x, y) = n/(n + 1) (x, y)$.
  + $f_n : C([0, 1]) -> C([0, 1])$, $f_n (phi) = n/(n + 1) phi$.

  Aquí en $C([0, 1])$ consideramos la distancia $d_infinity$.

+ #set enum(numbering: "(a)")
  + Encuentre el límite puntual de la sucesión de funciones $f_n : A -> RR$ en cada uno de los siguientes casos:
    #set enum(numbering: "i.")
    + $f_n (x) = x^n$, $A = (-1, 1]$.
    + $f_n (x) = x^(-n) e^x$, $A = (1, +infinity)$.
    + $f_n (x) = n^2 x (1 - x^2)^n$, $A = [0, 1]$.
    + $f_n (x) = x e^(-n x^2)$, $A = RR$.

  + Para la sucesión de *i.*, pruebe que la convergencia es uniforme sobre $(0, 1/2)$, y para la de *ii.*, que es uniforme sobre $[2, 5]$.
  + ¿Es uniforme la convergencia de la sucesión sobre $A$ en alguno de los casos?

+ Sea $X$ un conjunto y sea $B(X)$ el conjunto de las funciones acotadas de $X$ en $RR$. Sea $(f_n)_(n >= 1)$ una sucesión en $B(X)$.
  #set enum(numbering: "(a)")
  + Si $(f_n)_(n >= 1)$ converge uniformemente a $f : X -> RR$, muestre que $f in B(X)$. ¿Sigue valiendo esto si la convergencia es solamente puntual?
  + Si $(f_n)_(n >= 1)$ converge uniformemente en $X$, muestre que existe $M > 0$ tal que $|f_n (x)| <= M$ para todo $x in X$ y todo $n in NN$. En otras palabras, la sucesión $(f_n)_(n >= 1)$ es _uniformemente acotada_, o es _acotada en_ $(B(X), ||.||_infinity)$.

+ Sea $(f_n)_(n >= 1)$ la sucesión de funciones dada por
  $ f_n : [0, 1] -> RR, quad f_n (x) = (n x^2)/(1 + n x^2). $
  Estudie la convergencia puntual y uniforme de las sucesiones $(f_n)_(n >= 1)$ y $(f_n')_(n >= 1)$.

+ Sea $X$ un espacio métrico y sean $(f_n)_(n >= 1), (g_n)_(n >= 1) : X -> RR$ dos sucesiones de funciones que convergen uniformemente a funciones $f, g : X -> RR$, respectivamente. Pruebe que:
  #set enum(numbering: "(a)")
  + La sucesión $(f_n + g_n)_(n >= 1)$ converge uniformemente a $f + g$.
  + Si ambas sucesiones están uniformemente acotadas, entonces $(f_n g_n)_(n >= 1)$ converge uniformemente a $f g$.

+ Sean $X, Y$ espacios métricos, y sea $(f_n)_(n >= 1)$ una sucesión de funciones $f_n : X -> Y$ uniformemente continuas que converge uniformemente a una función $f : X -> Y$. Pruebe que $f$ es uniformemente continua.

+ Sea $(f_n)_(n >= 1) : [a, b] -> RR$ una sucesión de funciones derivables que converge puntualmente a una función $f : [a, b] -> RR$. Pruebe que si existe $c > 0$ tal que $|f_n ' (x)| <= c$ para todo $x in [a, b]$ y para todo $n in NN$, entonces $f$ es continua.
