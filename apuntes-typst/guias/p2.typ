#import "../utils.typ": *
#show: frame-style(styles.boxy)

#align(center)[
  #text(14pt, weight: "bold")[Análisis Avanzado - Segundo cuatrimestre de 2025] \
  #v(2pt)
  #text(12pt, weight: "medium")[Práctica 2]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(6pt)

#text(9pt)[
  *Recuerde:* Dadas $f : X -> Y$, $g : Y -> Z$ y dados $A, B subset.eq X$ y $C, D subset.eq Y$, se tiene:
  #set enum(numbering: "(a)")
  #grid(
    columns: (1fr, 1fr),
    row-gutter: 6pt,
    [+ $f(A union B) = f(A) union f(B)$.],
    [+ $f(A inter B) subset.eq f(A) inter f(B)$.],
    [+ $f^(-1)(C union D) = f^(-1)(C) union f^(-1)(D)$.],
    [+ $f^(-1)(C inter D) = f^(-1)(C) inter f^(-1)(D)$.],
    [+ $A subset.eq f^(-1)(f(A))$. Si $f$ es inyectiva vale la igualdad.],
    [+ $f(f^(-1)(C)) subset.eq C$. Si $f$ es sobreyectiva vale la igualdad.],
    [+ $X \ f^(-1)(D) = f^(-1)(Y \ D)$.],
    [+ Si $f$ y $g$ son inyectivas (resp. sobreyectivas, biyectivas), entonces $g compose f$ es inyectiva (resp. sobreyectiva, biyectiva).]
  )
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#set enum(numbering: "1.")

+ Halle el cardinal de los siguientes conjuntos:
  #set enum(numbering: "(a)")
  #grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    row-gutter: 10pt,
    [+ $ZZ_(<= -3)$],
    [+ $5 ZZ$],
    [+ $ZZ times NN$],
    [+ $(-1, 1) inter QQ$]
  )

+ Sea $A$ y $B$ conjuntos contables. Pruebe que $A union B$ es contable.

+ Sean $A subset.eq B$ conjuntos tales que $A$ es contable y $B \ A$ es infinito.
  #set enum(numbering: "(a)")
  + Pruebe que existe $C subset.eq B \ A$ tal que $C ~ C union A$.
  + Deduzca que $B \ A ~ B$.

+ Halle el cardinal del conjunto de los números irracionales.

+ Sea $(A_n)_(n in NN)$ una sucesión de conjuntos y sea $A = union.big_(n in NN) A_n$.
  #set enum(numbering: "(a)")
  + Encuentre una sucesión $(B_n)_(n in NN)$ de conjuntos disjuntos dos a dos tales que:
    - $B_n subset.eq A_n$ para todo $n in NN$, y
    - $union.big_(n <= m) B_n = union.big_(n <= m) A_n$ para todo $m in NN$.
  + Pruebe que para toda sucesión $(B_n)_(n in NN)$ como arriba se tiene que $A = union.big_(n in NN) B_n$.

+ #set enum(numbering: "(a)")
  + Sea $\{A_n\}_{n in NN}$ una familia de conjuntos contables. Pruebe que $union.big_(n in NN) A_n$ es contable.
  + Sea $A$ un conjunto finito y no vacío y $S = union.big_(m in NN) A^m$. Pruebe que $\# S = aleph_0$. \
    _*Deduzca que, dado un alfabeto (esto es, un conjunto de símbolos) finito, hay más números reales que palabras (esto es, sucesiones finitas de símbolos) definibles con ese alfabeto para nombrarlos.*_

+ Sea $c$ el cardinal de $RR$. Pruebe las siguientes afirmaciones:
  #set enum(numbering: "(a)")
  + Si $\# A = c$ y $\# B = c$, entonces $\# (A union B) = c$.
  + Si $\# A_n = c$ para todo $n in NN$, entonces $\# (union.big_(n in NN) A_n) = c$.

+ Sea $A$ un conjunto.
  #set enum(numbering: "(a)")
  + Pruebe que $cal(P)(A) ~ \{0, 1\}^A$.
  + Concluya que si $\# A = n$ entonces $\# cal(P)(A) = 2^n$.

+ Sean $A$ y $B$ conjuntos. Pruebe que:
  #set enum(numbering: "(a)")
  + $cal(P)(A) inter cal(P)(B) = cal(P)(A inter B)$.
  + $cal(P)(A) union cal(P)(B) subset.eq cal(P)(A union B)$.
  + $A ~ B => cal(P)(A) ~ cal(P)(B)$.

+ #set enum(numbering: "(a)")
  + Pruebe que $[0, 1) ~ \{0, 1\}^NN$. \
    _*Sugerencia:* considere el desarrollo binario de los números del intervalo $[0, 1)$. ¡Ojo!, dicho desarrollo no es único._
  + Concluya que $\# cal(P)(NN) = c$.

+ Pruebe que si $A$ es numerable entonces $cal(P)_f (A) = \{B subset.eq A : B "es finito"\}$ es numerable.

+ #set enum(numbering: "(a)")
  + Pruebe que el conjunto de números primos es numerable.
  + Escriba a $NN$ como unión numerable de conjuntos numerables disjuntos dos a dos.

+ Calcule el cardinal del conjunto $\{B subset.eq NN : \# B = \# (NN \ B) = aleph_0\}$.

+ #set enum(numbering: "(a)")
  + Calcule el cardinal de $cal(P)(NN) times cal(P)(NN)$.
  + Calcule el cardinal de $[0, 1) times [0, 1)$.
  + Calcule el cardinal de $RR^k$ para cada $k in NN$.

+ Calcule el cardinal de $RR[X]$, esto es, el conjunto formado por todos los polinomios con coeficientes reales.

+ Calcule el cardinal de los siguientes conjuntos:
  #set enum(numbering: "(a)")
  + \{(a_n)_(n in NN) subset.eq ZZ : (a_n)_(n in NN) "converge"\}.
  + \{(a_n)_(n in NN) subset.eq QQ : (a_n)_(n in NN) "es periódica"\}.

+ #set enum(numbering: "(a)")
  + Sea $I$ un conjunto (de índices). Supongamos que existe una familia de intervalos $\{A_i\}_{i in I}$ indexada por $I$ tal que:
    - $\# A_i > 1$ para todo $i in I$.
    - $A_i inter A_j = nothing$ si $i != j$. \
    Pruebe que $I$ es contable.
  + Sea $f : RR -> RR$ una función monótona. Pruebe que el conjunto de sus discontinuidades es contable.
