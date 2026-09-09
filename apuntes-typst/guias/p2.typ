#import "../utils.typ": *
#show figure.where(kind: "frame"): set figure(numbering: none)
#show figure.where(kind: "frame"): set block(breakable: true)
#show: frame-style(styles.boxy)

#show grid.cell: it => {
  if it.fill != none {
    set text(fill: white, weight: "bold", style: "italic")
    it
  } else {
    it
  }
}

#align(center)[
  #text(14pt, weight: "bold")[Análisis Avanzado - Segundo cuatrimestre de 2025] \
  #v(2pt)
  #text(12pt, weight: "medium")[Práctica 2]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(6pt)

#progreso[
  *Resueltos:* Ej. 1 (d) y Ej. 3 (b). 2 ítems sobre 33. \
  *Transcritos en este archivo:* los dos. \
  *Lo que sigue:* el Ej. 1 (a), (b), (c), que completan el primer ejercicio.
]

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
    [+ $X backslash f^(-1)(D) = f^(-1)(Y backslash D)$.],
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
    [+ $(-1, 1) inter QQ$ #hecho]
  )

+ Sea $A$ y $B$ conjuntos contables. Pruebe que $A union B$ es contable.

+ Sean $A subset.eq B$ conjuntos tales que $A$ es contable y $B backslash A$ es infinito.
  #set enum(numbering: "(a)")
  + Pruebe que existe $C subset.eq B backslash A$ tal que $C ~ C union A$.
  + Deduzca que $B backslash A ~ B$. #hecho

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

+ Calcule el cardinal del conjunto $\{B subset.eq NN : \# B = \# (NN backslash B) = aleph_0\}$.

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

#v(10pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#enunciado[Ejercicio 3 (b)][
  Sean $A subset.eq B$ conjuntos tales que $A$ es contable y $B backslash A$ es infinito.
  Sabiendo que existe $C subset.eq B backslash A$ tal que $C tilde.op C union A$, deduzca que
  $B backslash A tilde.op B$.
]

#solucion[Propuesta 1][
  Podemos construir dos uniones disjuntas

  $
    B backslash A &= C union (B backslash A backslash C) &&= C union [B backslash (A union C)] \
    B &= A union (B backslash A) &&= (A union C) union [B backslash (A union C)]
  $

  Notemos que $(A union C) union [B backslash (A union C)]$ es una unión disjunta.

  Además, como $C tilde.op A union C$ puedo plantear que existe $f : C -> A union C$ biyectiva.
  Y, por supuesto, tengo $id : (B backslash (A union C)) -> (B backslash (A union C))$ también
  biyectiva. Luego, planteo dos funciones.

  $phi : B backslash A -> B$ tal que

  $
    phi(x) = cases(
      f(x) & "si" x in C,
      id(x) & "si" x in B backslash (A union C)
    )
  $

  $psi : B -> B backslash A$ tal que

  $
    psi(x) = cases(
      f^(-1)(x) & "si" x in A union C,
      id(x) & "si" x in B backslash (A union C)
    )
  $

  Por la disjunción entre los conjuntos $(C, B backslash (A union C))$ y
  $(A union C, B backslash (A union C))$, ningún elemento del dominio de estas funciones tiene
  dos imágenes. A su vez, la imagen de ambas funciones cae en el codominio declarado,

  $
    f(C) union id(B backslash (A union C)) &subset.eq B \
    f^(-1)(A union C) union id(B backslash (A union C)) &subset.eq B backslash A
  $

  Podemos afirmar que están bien definidas.

  Luego, notemos que $(phi compose psi)(x)$ tiene dos caminos:

  - $x in B backslash (A union C)$, entonces $psi(x) = id_(B backslash (A union C))(x)$, y luego
    $(phi compose psi)(x) = (phi compose id_(B backslash (A union C)))(x) = id_(B backslash (A union C))(x)$.
  - $x in A union C$, entonces $psi(x) = f^(-1)(x)$, y luego
    $(phi compose psi)(x) = (phi compose f^(-1))(x) = (f compose f^(-1))(x)$, pues $f^(-1)(x) in C$;
    finalmente $(f compose f^(-1))(x) = id_(A union C)(x)$.

  Hemos visto que

  $
    (phi compose psi)(x) = cases(
      id_(B backslash (A union C))(x) & "si" x in B backslash (A union C),
      id_(A union C)(x) & "si" x in A union C
    )
  $

  Por lo tanto $phi compose psi = id_B$.

  De forma análoga, estudiando $psi compose phi$,

  $
    (psi compose phi)(x) = cases(
      (psi compose id_(B backslash (A union C)))(x) = id_(B backslash (A union C))(x)
        & "si" x in B backslash (A union C),
      (psi compose f)(x) = (f^(-1) compose f)(x) = id_C (x) & "si" x in C
    )
  $

  Es decir, $psi compose phi = id_(B backslash A)$.

  Hemos encontrado que $psi$ es la función inversa de $phi$, por lo tanto existe una biyección
  entre $B$ y $B backslash A$. Es decir, $B tilde.op B backslash A$, tal como queríamos
  demostrar.
]

#v(10pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#enunciado[Ejercicio 1 (d)][
  Halle el cardinal de $(-1,1) inter QQ$.
]

#solucion[Propuesta 1][
  Notemos que puedo definir una función $f : QQ -> (-1,1) inter QQ$ biyectiva de la siguiente
  forma:

  $ f(x) = x/(1 + abs(x)) $

  *La función está bien definida.* Observemos que para todo $q in QQ$ sabemos que
  $abs(q) in QQ$ también, pues $abs(dot)$ lo único que hace es multiplicar por $1$ o por $-1$,
  y ambos son racionales, por lo tanto el producto se mantiene en los racionales. Además
  $1 + abs(q) in QQ$, puesto que sumar racionales se mantiene en los racionales, y en particular
  $1 + abs(q) > 0$. Finalmente

  $ q/(1 + abs(q)) in QQ, $

  pues la división de dos racionales, con denominador no nulo, está permitida y vive dentro de
  los racionales.

  Hay que probar ahora que $abs(f(q)) < 1$, para lo cual necesitamos ver que

  $ -1 < f(q) < 1. $

  Como $1 + abs(q) > 0$, multiplicar por ese factor no invierte las desigualdades, y entonces

  $ -1 < q/(1 + abs(q)) < 1 quad <==> quad -1 - abs(q) < q < 1 + abs(q). $

  Si $q < 0$ tenemos $abs(q) = -q$, y la desigualdad de la derecha se lee $-1 + q < q < 1 - q$:
  la primera vale porque $-1 < 0$, y la segunda porque $q < -q < 1 - q$. Si $q >= 0$ tenemos
  $abs(q) = q$, y se lee $-1 - q < q < 1 + q$: la primera vale porque $-1 < 2q$ y la segunda
  porque $0 < 1$.

  Notemos entonces que para todo $q in QQ$ vale $f(q) in (-1,1) inter QQ$, y con esto vemos que
  $f$ está bien definida.

  *La inversa.* Puedo definir también otra función $f^(-1) : (-1,1) inter QQ -> QQ$ tal que

  $ f^(-1)(x) = x/(1 - abs(x)) $

  Para esta función podemos ver que $1 - abs(x) = 0 <==> abs(x) = 1$, pero como
  $"Dom"(f^(-1)) subset.eq (-1,1)$, sabemos que $abs(x) != 1$ siempre, por lo tanto nuestra
  función está bien definida en su dominio. Además, para todo $x in (-1,1) inter QQ$ también se
  cumple que $f^(-1)(x) in QQ$ por el mismo argumento de arriba, es decir, está bien definida en
  su codominio.

  *Primera composición.* Calculemos $f compose f^(-1)$:

  $
    (f compose f^(-1))(x)
      &= x/(1 - abs(x)) dot 1/(1 + abs(x/(1 - abs(x)))) \
      &= x/(1 - abs(x)) dot (1 + abs(x)/abs(1 - abs(x)))^(-1)
  $

  Notemos que si $x in (-1,1) inter QQ$, tenemos que
  $-1 < x < 1 <==> abs(x) < 1 <==> 1 - abs(x) > 0$. Por lo tanto, en este dominio
  $abs(1 - abs(x)) = 1 - abs(x)$, y vale lo siguiente

  $
    (f compose f^(-1))(x)
      &= x/(1 - abs(x)) dot (1 + abs(x)/(1 - abs(x)))^(-1)
       = x/(1 - abs(x)) dot ((1 - abs(x) + abs(x))/(1 - abs(x)))^(-1) \
      &= x/(1 - abs(x)) dot (1/(1 - abs(x)))^(-1)
       = x/(1 - abs(x)) dot (1 - abs(x))
       = x
  $

  Luego, $f compose f^(-1) = id_((-1,1) inter QQ)$.

  *Segunda composición.* La cuenta es la misma con $1 - abs(x)$ y $1 + abs(x)$ intercambiados
  (ver Galerazo 4 en `galerazos.typ`), y esta vez el paso del módulo es gratis: $1 + abs(x) > 0$
  para todo $x in QQ$, sin ninguna hipótesis sobre $x$, así que
  $abs(1 + abs(x)) = 1 + abs(x)$. Para $x in QQ$,

  $
    (f^(-1) compose f)(x)
      &= x/(1 + abs(x)) dot 1/(1 - abs(x/(1 + abs(x))))
       = x/(1 + abs(x)) dot (1 - abs(x)/(1 + abs(x)))^(-1) \
      &= x/(1 + abs(x)) dot ((1 + abs(x) - abs(x))/(1 + abs(x)))^(-1)
       = x/(1 + abs(x)) dot (1/(1 + abs(x)))^(-1) \
      &= x/(1 + abs(x)) dot (1 + abs(x))
       = x
  $

  Es decir, $f^(-1) compose f = id_(QQ)$, y así hemos demostrado que $f$ es biyectiva.

  *Conclusión.* Como sabemos que $NN tilde.op QQ$ (Numerabilidad de $QQ$ en `apuntes.typ`) y
  $f$ es una biyección, tenemos que $QQ tilde.op (-1,1) inter QQ$, y por transitividad
  $NN tilde.op (-1,1) inter QQ$. Por la Definición 3.6, eso dice que $(-1,1) inter QQ$ es
  numerable, o sea

  $ \#((-1,1) inter QQ) = aleph_0. $
]
