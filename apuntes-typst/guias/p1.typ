#import "../utils.typ": *
#show: frame-style(styles.boxy)

#align(center)[
  #text(14pt, weight: "bold")[Análisis Avanzado - Segundo cuatrimestre de 2025] \
  #v(2pt)
  #text(12pt, weight: "medium")[Práctica 1]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#set enum(numbering: "1.")

+ Pruebe que si $x < y + epsilon$ para todo $epsilon > 0$, entonces $x <= y$. Deduzca que si $|x - y| < epsilon$ para todo $epsilon > 0$, entonces $x = y$.

+ #set enum(numbering: "(a)")
  + Sean $x, y in RR$ tales que $y - x > 1$. Pruebe que existe un entero entre $x$ e $y$.
  + Sean $x, y in RR$ tales que $x < y$. Pruebe que existe un racional entre $x$ e $y$.
  + Sean $x, y in QQ$ tales que $x < y$. Pruebe que existe un irracional entre $x$ e $y$.
  + Sean $x, y in RR$ tales que $x < y$. Pruebe que existe un irracional entre $x$ e $y$.

+ Sea $A subset.eq RR$ no vacío y acotado inferiormente. Pruebe la siguiente equivalencia:
  $ i = op("ínf") A <=> cases(
    i <= a "para todo " a in A,,
    "para todo " epsilon > 0 "existe " a in A "tal que " i <= a < i + epsilon.
  ) $

+ Halle, si existen, supremo, ínfimo, máximo y mínimo de los siguientes subconjuntos de $RR$, y pruebe que lo son:
  #set enum(numbering: "(a)")
  #grid(
    columns: (1fr, 1fr),
    row-gutter: 10pt,
    [+ $(a, b]$],
    [+ $B union \{0\}$],
    [+ $B = \{1/2^n : n in NN\}$],
    [+ $\{x^2 - x - 1 : x in RR\}$]
  )

+ Sean $A subset.eq B subset.eq RR$, con $A != nothing$. Pruebe las siguientes afirmaciones:
  #set enum(numbering: "(a)")
  + Si $B$ está acotado superiormente, entonces $A$ también lo está, y $op("sup") A <= op("sup") B$.
  + Si $B$ está acotado inferiormente, entonces $A$ también lo está, e $op("ínf") B <= op("ínf") A$.
  + Si $A$ no está acotado, entonces $B$ tampoco lo está.

+ Dados un conjunto de números reales $A$ y $c in RR$, denotamos $c A = \{c a : a in A\}$. Más aún, $-A$ denotará al conjunto $(-1)A$. Pruebe las siguientes afirmaciones:
  #set enum(numbering: "(a)")
  + Si $A$ está acotado superiormente, entonces $-A$ está acotado inferiormente e $op("ínf")(-A) = -op("sup") A$.
  + Si $c > 0$ y $A$ está acotado superiormente, entonces $c A$ está acotado superiormente y $op("sup")(c A) = c op("sup")(A)$.

+ Sea $f : [a, b] -> [a, b]$ creciente. Supongamos que $f(a) > a$. Sea
  $ x_0 = op("sup")(\{x in [a, b] : f(x) > x\}). $
  Pruebe que $f(x_0) = x_0$.

+ Pruebe, usando la definición de límite:
  #set enum(numbering: "(a)")
  + $lim_(n -> oo) (3 - 2n)/(n + 1) = -2$.
  + $lim_(n -> oo) (sin(n))/n = 0$.
  + $lim_(n -> oo) (2^n - 3)/(2^n + 4) = 1$.

+ Sean $(x_n)_(n in NN), (y_n)_(n in NN)$ sucesiones de números reales tales que $x_n ->_(n -> oo) ell_1$ e $y_n ->_(n -> oo) ell_2$. Pruebe que si $x_n <= y_n$ para todo $n$, entonces $ell_1 <= ell_2$.

+ Si $(x_n)_(n in NN)$ e $(y_n)_(n in NN)$ son sucesiones de números reales tales que $(x_n)_(n in NN)$ converge a $0$ e $(y_n)_(n in NN)$ está acotada, pruebe que $(x_n y_n)_(n in NN)$ converge a $0$.

+ Sea $(x_n)_(n in NN) subset.eq RR$ decreciente. Pruebe que:
  #set enum(numbering: "(a)")
  + Si $(x_n)_(n in NN)$ es acotada inferiormente, entonces tiene límite y
    $ lim_(n -> oo) x_n = op("ínf")\{x_n : n in NN\}. $
  + Si $(x_n)_(n in NN)$ es no acotada inferiormente, entonces $x_n ->_(n -> oo) -oo$.

+ Sea $A subset.eq RR$ acotado superiormente y no vacío. Pruebe que si $A$ no tiene máximo entonces existe $(a_n)_(n in NN) subset.eq A$ estrictamente creciente tal que $a_n ->_(n -> oo) op("sup")(A)$.

+ Sea $(x_n)_(n in NN) subset.eq RR$ una sucesión no acotada superiormente. Pruebe que existe una subsucesión $(x_(n_k))_(k in NN)$ que diverge a $+oo$.

+ Sean $(x_n)_(n in NN) subset.eq RR$ y $ell in RR$. Pruebe que si toda subsucesión $(x_(n_k))_(k in NN)$ tiene una (sub)subsucesión $(x_(n_(k_j)))_(j in NN)$ que converge a $ell$, entonces la sucesión $(x_n)_(n in NN)$ converge a $ell$.

+ Sea $(x_n)_(n in NN) subset.eq RR$. Pruebe:
  #set enum(numbering: "(a)")
  + Si $(x_(2k))_(k in NN)$ y $(x_(2k-1))_(k in NN)$ son convergentes, y sus límites coinciden, entonces $(x_n)_(n in NN)$ es convergente.
  + Si $(x_(2k))_(k in NN)$, $(x_(2k-1))_(k in NN)$ y $(x_(3k))_(k in NN)$ son convergentes, entonces $(x_n)_(n in NN)$ es convergente.

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

#enunciado[Ejercicio 1][
  Pruebe que si $x < y + epsilon$ para todo $epsilon > 0$, entonces $x <= y$. Deduzca que si $|x - y| < epsilon$ para todo $epsilon > 0$, entonces $x = y$.
]

#solucion[Propuesta 1][
  Demostración por contrarrecíproco. Si $forall epsilon > 0 : x < y + epsilon => x <= y$, debe ser verdadero también que $x > y => exists epsilon > 0 : x >= y + epsilon$.

  Notemos que si $x > y$, entonces $x - y > 0$. Podemos llamar $delta = x - y$. En particular, $x >= y + delta$. Por lo tanto, hemos encontrado $epsilon = delta$ que cumple $x >= y + epsilon$. Habiendo demostrado que el contrarrecíproco vale, el recíproco también debe valer.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

#enunciado[Ejercicio 2 (a)][
  Sean $x, y in RR$ tales que $y - x > 1$. Pruebe que existe un entero entre $x$ e $y$.
]

#solucion[Propuesta 1][
  Por el Principio de Arquímedes sabemos que $exists n in ZZ : x < n <= x + 1$. Además, $y - x > 1 => y > x + 1$. Juntando ambas desigualdades tenemos que:
  $ x < n <= x + 1 < y $
  Encontramos un entero entre $x$ e $y$, tal como queríamos ver.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

#enunciado[Ejercicio 2 (b)][
  Sean $x, y in RR$ tales que $x < y$. Pruebe que existe un racional entre $x$ e $y$.
]

#solucion[Propuesta 1][
  Como $x < y$, sabemos que $y - x > 0$. Por el Principio de Arquímedes $exists n in NN : y - x > 1/n => y n - x n > 1$. Por el punto anterior (2a), $exists m in ZZ : x n < m < y n => x < m/n < y$. Hemos encontrado un racional entre dos números reales.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

#enunciado[Ejercicio 2 (c)][
  Sean $x, y in QQ$ tales que $x < y$. Pruebe que existe un irracional entre $x$ e $y$.
]

#solucion[Propuesta 1][
  Como $x < y => y - x > 0$. Por el Principio de Arquímedes $exists n in NN : y - x > 1/n => y n - x n > 1$. Como $sqrt(2) > 1$, tenemos $sqrt(2) n y - sqrt(2) n x > sqrt(2) > 1$.

  Por lo tanto, utilizando el resultado del punto 2 (a), existe $m in ZZ$ tal que:
  $
    sqrt(2) n x < m < sqrt(2) n y \
    x < sqrt(2)/2 dot m / n < y
  $
  Como $sqrt(2)/2 in RR backslash QQ$ y $m/n in QQ$ (con $m/n != 0$), resulta que $sqrt(2)/2 dot m/n in RR backslash QQ$. Con esto hemos hallado un número irracional estrictamente entre $x$ e $y$.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

#enunciado[Ejercicio 2 (d)][
  Sean $x, y in RR$ tales que $x < y$. Pruebe que existe un irracional entre $x$ e $y$.
]

#solucion[Propuesta 1][
  Por el punto 2 (b) podemos hallar racionales $q_1, q_2 in QQ$ tales que $x < q_1 < q_2 < y$. Luego, por el punto 2 (c), como $q_1, q_2 in QQ$ con $q_1 < q_2$, sabemos que existe un irracional $z in RR backslash QQ$ tal que:
  $ q_1 < z < q_2 $
  Por transitividad del orden, concluimos que $x < q_1 < z < q_2 < y$, es decir, $x < z < y$. Por lo tanto, hemos encontrado un número irracional entre los reales $x$ e $y$.
]






