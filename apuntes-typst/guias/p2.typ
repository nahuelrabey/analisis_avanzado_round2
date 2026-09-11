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
  *Resueltos:* Ej. 1 (a)-(d), Ej. 2, Ej. 3 (a)-(b), Ej. 4 y Ej. 5 (a). 9 ítems sobre 33. \
  *Transcritos en este archivo:* los nueve. \
  *Lo que sigue:* el Ej. 5 (b) y el resto de la guía (6 en adelante) sin encarar.
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
    [+ $ZZ_(<= -3)$ #hecho],
    [+ $5 ZZ$ #hecho],
    [+ $ZZ times NN$ #hecho],
    [+ $(-1, 1) inter QQ$ #hecho]
  )

+ Sea $A$ y $B$ conjuntos contables. Pruebe que $A union B$ es contable. #hecho

+ Sean $A subset.eq B$ conjuntos tales que $A$ es contable y $B backslash A$ es infinito.
  #set enum(numbering: "(a)")
  + Pruebe que existe $C subset.eq B backslash A$ tal que $C ~ C union A$. #hecho
  + Deduzca que $B backslash A ~ B$. #hecho

+ Halle el cardinal del conjunto de los números irracionales. #hecho

+ Sea $(A_n)_(n in NN)$ una sucesión de conjuntos y sea $A = union.big_(n in NN) A_n$.
  #set enum(numbering: "(a)")
  + Encuentre una sucesión $(B_n)_(n in NN)$ de conjuntos disjuntos dos a dos tales que: #hecho
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

#v(10pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#enunciado[Ejercicio 3 (a)][
  Sean $A subset.eq B$ conjuntos tales que $A$ es contable y $B backslash A$ es infinito.
  Pruebe que existe $C subset.eq B backslash A$ tal que $C tilde.op C union A$.
]

#solucion[Propuesta 1][
  Al ser $B backslash A$ infinito, por la Proposición 3.14 (`apuntes.typ`) sabemos que existe
  $C subset.eq B backslash A$ numerable.

  Como $C$ es numerable y $A$ es contable, por el Ejercicio 2 sabemos que la unión de dos
  contables es contable. En particular $C union A$ es contable, y como $C subset.eq C union A$
  y $C$ es infinito, $C union A$ también es infinito (todo conjunto que contiene un
  subconjunto infinito es infinito). Un contable infinito es, por la Definición 3.6, numerable.

  Por lo tanto, ambos conjuntos son numerables: $C tilde.op NN$ y $(C union A) tilde.op NN$.
  Por simetría y transitividad de $tilde.op$ (Proposición 3.2), $C tilde.op C union A$.
]

#v(10pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#enunciado[Ejercicio 1 (a)][
  Halle el cardinal de $ZZ_(<= -3)$.
]

#solucion[Propuesta 1][
  Defino $f : NN -> ZZ_(<= -3)$ y $g : ZZ_(<= -3) -> NN$, ambas con la misma fórmula
  $f(n) = g(n) = -2 - n$.

  *Están bien definidas.* Para $n in NN$ (es decir, $n >= 1$), $f(n) = -2 - n <= -3$, así que
  $f(n) in ZZ_(<= -3)$. Para $n in ZZ_(<= -3)$ (es decir, $n <= -3$), $g(n) = -2 - n >= 1$, así
  que $g(n) in NN$.

  *Son inversas.* Para $n in ZZ_(<= -3)$,

  $ (f compose g)(n) = -2 - (-2 - n) = n, $

  es decir $f compose g = id_(ZZ_(<= -3))$. La misma cuenta, con los roles de dominio y
  codominio intercambiados, da para $n in NN$

  $ (g compose f)(n) = -2 - (-2 - n) = n, $

  es decir $g compose f = id_(NN)$.

  Por lo tanto $f$ es biyectiva, $NN tilde.op ZZ_(<= -3)$, y en particular
  $\#ZZ_(<= -3) = aleph_0$.
]

#v(10pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#enunciado[Ejercicio 1 (b)][
  Halle el cardinal de $5 ZZ$.
]

#solucion[Propuesta 1][
  Notemos que $5 ZZ = {5k : k in ZZ}$.

  Planteo $f : ZZ -> 5 ZZ$, $f(k) = 5k$, que está bien definida porque $5k in 5 ZZ$ para todo
  $k in ZZ$ --- es la definición misma de $5ZZ$. Existe $f^(-1) : 5 ZZ -> ZZ$, $f^(-1)(n) = n/5$,
  que está bien definida porque si $n in 5ZZ$ entonces $n = 5k$ para algún $k in ZZ$, y luego
  $n/5 = k in ZZ$.

  Verifiquemos que son inversas. Para $n in 5ZZ$, escribiendo $n = 5k$ con $k in ZZ$,

  $ (f compose f^(-1))(n) = f(n/5) = 5 dot (n/5) = n, $

  es decir $f compose f^(-1) = id_(5ZZ)$. Para $k in ZZ$,

  $ (f^(-1) compose f)(k) = f^(-1)(5k) = (5k)/5 = k, $

  es decir $f^(-1) compose f = id_(ZZ)$.

  Por lo tanto $f$ es biyectiva, es decir $ZZ tilde.op 5 ZZ$. Como además sabemos que
  $NN tilde.op ZZ$ (Ejemplo 13 en `ejemplos.typ`), por transitividad $NN tilde.op 5 ZZ$.

  Finalmente, $\#(5 ZZ) = aleph_0$.
]

#v(10pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#enunciado[Ejercicio 1 (c)][
  Halle el cardinal de $ZZ times NN$.
]

#solucion[Propuesta 1][
  Sabemos que $ZZ tilde.op NN$ (Ejemplo 13 en `ejemplos.typ`), por lo tanto existe
  $f : ZZ -> NN$ biyectiva. Además, $NN tilde.op NN times NN$ (Ejemplo 14 en `ejemplos.typ`),
  con lo cual existe $g : NN times NN -> NN$ biyectiva.

  Con lo anterior, puedo definir $phi : ZZ times NN -> NN times NN$ tal que

  $ phi(m,n) = (f(m), n) $

  *$phi$ es inyectiva.* Si $phi(m,n) = phi(tilde(m), tilde(n))$ tenemos que
  $(f(tilde(m)), tilde(n)) = (f(m), n)$, con lo cual, al ser $f$ inyectiva (por ser biyectiva),
  $tilde(m) = m$; y de la igualdad de pares, $tilde(n) = n$.

  *$phi$ es sobreyectiva.* Dado $(p,q) in NN times NN$, como $f$ es sobreyectiva existe
  $m in ZZ$ tal que $f(m) = p$. Tomando $n = q$, tenemos $phi(m,n) = (f(m), n) = (p,q)$.

  Por ser inyectiva y sobreyectiva, $phi$ es biyectiva.

  Por lo tanto, puedo construir $h : ZZ times NN -> NN$ tal que $h = g compose phi$, que es
  biyectiva por ser composición de funciones biyectivas. Es decir, $ZZ times NN tilde.op NN$, y
  en particular

  $ \#(ZZ times NN) = aleph_0. $
]

#v(10pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#enunciado[Ejercicio 2][
  Sean $A$ y $B$ conjuntos contables. Pruebe que $A union B$ es contable.
]

#solucion[Propuesta 1][
  *Caso $A != emptyset$ y $B != emptyset$.* Si $A$ y $B$ son contables, entonces
  $\#A <= aleph_0$ y $\#B <= aleph_0$. En particular, por la Proposición 3.9, deben existir
  $f : NN -> A$ y $g : NN -> B$ sobreyectivas.

  Sé que existen funciones biyectivas $phi : NN_("pares") -> NN$ y $psi : NN_("impares") -> NN$.
  Por lo tanto, puedo definir $h : NN -> A union B$ tal que

  $
    h(n) = cases(
      (f compose phi)(n) & "si" n equiv 0 (mod 2),
      (g compose psi)(n) & "si" n equiv 1 (mod 2)
    )
  $

  Sea $x in A union B$, tenemos dos posibilidades: $x in A$ o $x in B$.

  - $x in A$ implica que existe $n in NN$ con $f(n) = x$, pues $f$ es sobreyectiva. Y, como
    $phi$ es sobreyectiva también, existe $m in NN_("pares")$ con $phi(m) = n$. Por lo tanto,
    hemos encontrado $m in NN$ con $h(m) = (f compose phi)(m) = x$.
  - $x in B$ implica que existe $n in NN$ con $g(n) = x$, pues $g$ es sobreyectiva. Y, como
    $psi$ es sobreyectiva también, existe $m in NN_("impares")$ con $psi(m) = n$. Por lo tanto,
    hemos encontrado $m in NN$ con $h(m) = (g compose psi)(m) = x$.

  ¿Qué pasa si $x in A inter B$? Nada, se repetirá la imagen, lo cual está permitido.

  Notemos que $forall x in A union B$, $exists m in NN$ con $h(m) = x$, es decir, $h$ es
  sobreyectiva.

  Como existe $h : NN -> A union B$ sobreyectiva y $A union B != emptyset$ (pues
  $A != emptyset$), por la Proposición 3.9 sabemos que $\#(A union B) <= aleph_0$, y por lo
  tanto $A union B$ es contable.

  *Caso $A = emptyset$ o $B = emptyset$.* Por la Definición 3.6, "finito" pide un $n in NN$ y
  una biyección ${1,...,n} -> A$; como en este apunte $NN = {1,2,3,...}$ (tal como se usa en el
  Ejemplo 13 de `ejemplos.typ`), ningún $n in NN$ da ${1,...,n} = emptyset$, y tampoco existe
  una biyección $NN -> emptyset$ (no hay función alguna de un dominio no vacío a $emptyset$). Es
  decir, $emptyset$ no es contable según esta definición. Por lo tanto, no puede ocurrir que
  $A = emptyset$ (o $B = emptyset$) y que a la vez $A$ (o $B$) sea contable: este caso queda
  descartado por la propia hipótesis del enunciado.

  *Caso $A = B = emptyset$.* Por la misma razón, tampoco puede ocurrir: si $A = B = emptyset$,
  ninguno de los dos es contable, así que la hipótesis del enunciado no se satisface.
]

#v(10pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#enunciado[Ejercicio 5 (a)][
  Sea $(A_n)_(n in NN)$ una sucesión de conjuntos y sea $A = union.big_(n in NN) A_n$.
  Encuentre una sucesión $(B_n)_(n in NN)$ de conjuntos disjuntos dos a dos tales que:
  - $B_n subset.eq A_n$ para todo $n in NN$, y
  - $union.big_(n <= m) B_n = union.big_(n <= m) A_n$ para todo $m in NN$.
]

#solucion[Propuesta 1][
  Propongo

  $
    B_1 &= A_1 \
    B_2 &= A_2 - B_1 \
    B_3 &= A_3 - (B_1 union B_2) \
    B_4 &= A_4 - (B_1 union B_2 union B_3) \
        &dots.v \
    B_n &= A_n - union.big_(k=1)^(n-1) B_k
  $

  *Son disjuntos dos a dos.* Que sean disjuntos dos a dos significa que, para todo $i != j$,
  $B_i inter B_j = emptyset$. Sin pérdida de generalidad, digo que $i < j$.

  Sea $x in B_j$; se cumple que $x in A_j$ y $x in.not union.big_(k=1)^(j-1) B_k$, en
  particular, $x in.not B_i$, pues $i <= j-1$.

  Hemos visto que ningún elemento de $B_j$ está en $B_i$, por lo tanto $B_j inter B_i =
  emptyset$ con $i != j$.

  *Cada $B_n subset.eq A_n$*, por construcción: cada $B_n$ es $A_n$ menos algún conjunto, y
  $A_n$ menos cualquier cosa sigue estando dentro de $A_n$.

  *Primera inclusión.* Sea $x in union.big_(n <= m) B_n$; entonces existe $k in NN$ con
  $k <= m$ y $x in B_k$, por lo tanto $x in A_k$ (pues $B_k subset.eq A_k$), con lo cual
  $x in union.big_(n <= m) A_n$.

  *Segunda inclusión.* Sea $x in union.big_(n <= m) A_n$; entonces existe $k in NN$ con
  $k <= m$ y $x in A_k$. Por la definición, $B_k = A_k - union.big_(i=1)^(k-1) B_i$, luego hay
  dos opciones:

  - Si $x in.not union.big_(i=1)^(k-1) B_i$, entonces $x in B_k$ y, por lo tanto,
    $x in union.big_(n <= m) B_n$.
  - Si $x in union.big_(i=1)^(k-1) B_i$, entonces $x in B_i$ para algún $i < k <= m$, con lo
    cual $x in union.big_(n <= m) B_n$.

  Hemos demostrado que $union.big_(n <= m) B_n subset.eq union.big_(n <= m) A_n$ y que
  $union.big_(n <= m) A_n subset.eq union.big_(n <= m) B_n$; por doble inclusión, ambos
  conjuntos son iguales.
]

#v(10pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#enunciado[Ejercicio 4][
  Halle el cardinal de los números irracionales.
]

#solucion[Propuesta 1][
  Como $QQ subset.eq RR$ es un conjunto numerable (Numerabilidad de $QQ$ en `apuntes.typ`),
  tenemos dos opciones para $RR - QQ$.

  Si $RR - QQ$ fuera finito, entonces $RR = (RR - QQ) union QQ$ sería unión de dos contables
  (Ejercicio 2), y por lo tanto contable. Esto es absurdo, pues $RR$ es infinito y no es
  numerable (Teorema 3.19), es decir, no es contable. Luego, $RR - QQ$ es infinito.

  Por el Ejercicio 3 (a) y (b), con $A = QQ$ contable y $B = RR$, sabemos que
  $RR - QQ tilde.op RR$. Es decir, llamando $II = RR - QQ$ al conjunto de los irracionales,

  $ \#II = \#RR. $
]
