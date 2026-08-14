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

#progreso[
  *Resueltos:* ejercicios 1 a 6 completos --- 15 de los 28 ítems de la guía. Van marcados con #hecho en la lista de abajo.

  *Transcritos en este archivo:* Ej. 1, Ej. 2 (a--d) y Ej. 6 (a--b). Los ejercicios 3, 4 y 5 están resueltos pero todavía sin pasar en limpio: usá `/guia` cuando quieras incorporarlos.

  *Lo que sigue:* el Ej. 7 (punto fijo vía supremo) es lo último de la guía que se apoya sólo en el Cap. 1. Del Ej. 8 al 15 todo es sucesiones, así que conviene cerrar antes los pasos 2--4 de ese capítulo.
]

#v(8pt)

#set enum(numbering: "1.")

+ Pruebe que si $x < y + epsilon$ para todo $epsilon > 0$, entonces $x <= y$. Deduzca que si $|x - y| < epsilon$ para todo $epsilon > 0$, entonces $x = y$. #hecho

+ #set enum(numbering: "(a)")
  + Sean $x, y in RR$ tales que $y - x > 1$. Pruebe que existe un entero entre $x$ e $y$. #hecho
  + Sean $x, y in RR$ tales que $x < y$. Pruebe que existe un racional entre $x$ e $y$. #hecho
  + Sean $x, y in QQ$ tales que $x < y$. Pruebe que existe un irracional entre $x$ e $y$. #hecho
  + Sean $x, y in RR$ tales que $x < y$. Pruebe que existe un irracional entre $x$ e $y$. #hecho

+ Sea $A subset.eq RR$ no vacío y acotado inferiormente. Pruebe la siguiente equivalencia: #hecho
  $ i = op("ínf") A <=> cases(
    i <= a "para todo " a in A,,
    "para todo " epsilon > 0 "existe " a in A "tal que " i <= a < i + epsilon.
  ) $

+ Halle, si existen, supremo, ínfimo, máximo y mínimo de los siguientes subconjuntos de $RR$, y pruebe que lo son:
  #set enum(numbering: "(a)")
  #grid(
    columns: (1fr, 1fr),
    row-gutter: 10pt,
    [+ $(a, b]$ #hecho],
    [+ $B union \{0\}$ #hecho],
    [+ $B = \{1/2^n : n in NN\}$ #hecho],
    [+ $\{x^2 - x - 1 : x in RR\}$ #hecho]
  )

+ Sean $A subset.eq B subset.eq RR$, con $A != nothing$. Pruebe las siguientes afirmaciones:
  #set enum(numbering: "(a)")
  + Si $B$ está acotado superiormente, entonces $A$ también lo está, y $op("sup") A <= op("sup") B$. #hecho
  + Si $B$ está acotado inferiormente, entonces $A$ también lo está, e $op("ínf") B <= op("ínf") A$. #hecho
  + Si $A$ no está acotado, entonces $B$ tampoco lo está. #hecho

+ Dados un conjunto de números reales $A$ y $c in RR$, denotamos $c A = \{c a : a in A\}$. Más aún, $-A$ denotará al conjunto $(-1)A$. Pruebe las siguientes afirmaciones:
  #set enum(numbering: "(a)")
  + Si $A$ está acotado superiormente, entonces $-A$ está acotado inferiormente e $op("ínf")(-A) = -op("sup") A$. #hecho
  + Si $c > 0$ y $A$ está acotado superiormente, entonces $c A$ está acotado superiormente y $op("sup")(c A) = c op("sup")(A)$. #hecho

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

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

#enunciado[Ejercicio 6 (a)][
  Dado un conjunto $A subset.eq RR$ acotado superiormente, pruebe que $-A = \{(-1)a : a in A\}$ está acotado inferiormente e $op("ínf")(-A) = -op("sup")(A)$.
]

#solucion[Propuesta 1][
  Como $A$ está acotado superiormente, $exists c in RR : a <= c, forall a in A$. Por lo tanto, $-c <= -a, forall -a in -A$ (pues $forall a in A$ se tiene $-a in -A$ y $forall -a in -A$ se tiene $a in A$). Es decir, $exists tilde(c) = -c in RR : tilde(c) <= -a, forall -a in -A$, con lo cual $-A$ está acotado inferiormente.

  _(Nota: Denotamos por $O(A)$ al conjunto de cotas superiores de $A$ y por $Omega(A)$ al conjunto de cotas inferiores de $A$)_.

  Más aún, para todo $c in RR$ tal que $a <= c, forall a in A$, existe $tilde(c) = -c$ que es cota inferior de $-A$. Y recíprocamente, para todo $tilde(c) in RR$ tal que $tilde(c) <= -a, forall -a in -A$, podemos encontrar $c = -tilde(c)$ tal que $a <= c, forall a in A$. Es decir, $-O(A) = Omega(-A)$: el conjunto de cotas superiores de $A$ reflejado es igual al conjunto de cotas inferiores de $-A$.

  Como $A$ está acotado superiormente, por el Axioma de Completitud existe $s = op("sup")(A)$. Luego, para todo $t in O(A)$ se cumple $s <= t$, por lo cual $-t <= -s$. Como $-O(A) = Omega(-A)$, se tiene que para todo $k in Omega(-A)$ vale $k <= -s$. Además, $-s$ es cota inferior de $-A$, por lo que es la mayor de todas las cotas inferiores. Concluimos que:
  $ -s = -op("sup")(A) = op("ínf")(-A) $
]

#duda[Consulta para docentes][
  ¿Es necesario demostrar rigurosamente la igualdad de conjuntos de cotas $-O(A) = Omega(-A)$ paso a paso o alcanza con argumentar la biyección mediante el cambio de signo $c |-> -c$?
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

#enunciado[Ejercicio 6 (b)][
  Sean $c > 0$ y $A subset.eq RR$ acotado superiormente. Pruebe que $c A$ está acotado superiormente y $op("sup")(c A) = c op("sup")(A)$.
]

#solucion[Propuesta 1][
  Como $A$ está acotado superiormente, $exists k in RR : a <= k, forall a in A$. Como $c > 0$, multiplicando por $c$ obtenemos $c a <= c k$, por lo que hemos encontrado $tilde(k) = c k$ tal que $c a <= tilde(k), forall c a in c A$. Por lo tanto, $c A$ está acotado superiormente.

  Más aún, para todo $k in RR$ tal que $a <= k, forall a in A$, podemos construir $tilde(k) = c k$ cota superior de $c A$. Recíprocamente, para todo $tilde(k) in RR$ tal que $c a <= tilde(k), forall c a in c A$, podemos definir $k = tilde(k)/c$ (dado que $c > 0$), resultando $a <= k, forall a in A$. Es decir, $c O(A) = O(c A)$.

  Dado que $A$ está acotado superiormente, por el Axioma de Completitud existe $s = op("sup")(A)$. Sabemos que $s <= t, forall t in O(A)$, de donde $c s <= c t$. Como $c O(A) = O(c A)$, se tiene que $c s <= tilde(t), forall tilde(t) in O(c A)$. Dado que $c s$ es cota superior de $c A$ y es menor o igual a cualquier otra cota superior de $c A$, es el supremo de $c A$:
  $ op("sup")(c A) = c s = c op("sup")(A) $
]






