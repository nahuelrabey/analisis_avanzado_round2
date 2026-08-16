#import "../utils.typ": *
#show: frame-style(styles.boxy)

#align(center)[
  #text(14pt, weight: "bold")[Análisis Avanzado 2026] \
  #v(2pt)
  #text(12pt, weight: "medium")[Práctica 1]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#progreso[
  *Resueltos:* ejercicios 1 a 6 completos --- 15 de los 32 ítems de la guía. Van marcados con #hecho en la lista de abajo.

  *Transcritos en este archivo:* Ej. 1, Ej. 2 (a--d) y Ej. 6 (a--b). Los ejercicios 3, 4 y 5 están resueltos pero todavía sin pasar en limpio: usá `/guia` cuando quieras incorporarlos.

  *Edición:* este archivo sigue la guía *2026* (`apuntes-docentes/guias/p1.pdf`). Respecto de la versión 2025 que estaba transcrita antes: el ejercicio de punto fijo ya no forma parte de la práctica (queda al final, como anexo), entraron dos ejercicios nuevos --- el *8* y el *9* --- y del 7 en adelante la numeración corre un lugar. Los ejercicios 1 a 6 no cambiaron.

  *Lo que sigue:* del Ej. 7 al 16 es todo sucesiones, así que conviene cerrar antes los pasos 2--4 del Cap. 2. Arrancá por el *Ej. 8*: es el lema que después usan el 7 (b), el 7 (c) y el 11.
]

#v(10pt)

#align(center)[
  #text(11.5pt, weight: "bold", fill: rgb("#0c4a6e"))[Qué leer antes de empezar]
]

#v(3pt)

Cada tramo de la guía se apoya en un puñado de cajas de `apuntes.typ` y en algunos ejemplos de `ejemplos.typ`. Las cajas del apunte van nombradas (los números de pestaña se repiten entre definiciones y proposiciones); los ejemplos van por número de pestaña. Las filas son acumulativas: cada una supone leídas las de arriba.

#v(5pt)

#show table.cell.where(y: 0): set text(fill: white, weight: "bold", size: 8.5pt)

#block[
  #set text(size: 8.5pt)
  #table(
    columns: (0.55fr, 4fr, 0.7fr),
    align: (center + horizon, left + top, center + horizon),
    fill: (x, y) => if y == 0 { rgb("#0c4a6e") } else if calc.even(y) { rgb("#f8fafc") } else { white },
    stroke: 0.4pt + rgb("#cbd5e1"),
    inset: (x: 6pt, y: 5pt),

    [*Ejercicios*], [*Leer en `apuntes.typ`*], [*Ejemplos*],

    [*1* y *2*],
    [*Principio de Arquímedes* (teorema) con su demostración · *Principio de Arquímedes 2* · *Densidad de $QQ$*: su demostración _es_ el ítem 2 (b), y deja planteado el 2 (a) como ejercicio.],
    [5],

    [*3*, *4* y *5*],
    [*Conjunto Acotado Superiormente* · *Supremo* · *Axioma de Completitud* · *Máximo* y *Caracterización de Supremo y Máximo* · *Conjunto Acotado Inferiormente*, *Ínfimo*, *Mínimo* y *Caracterización de Ínfimo y Mínimo* · *Equivalencia de supremo* (la de $epsilon$) y *Equivalencia de Ínfimo*: esta última demostración _es_ el Ej. 3.],
    [1--4, 6],

    [*6*],
    [*Completitud en términos de ínfimos*: su demostración es el ítem (a) con los roles cambiados --- prueba que si $A$ está acotado inferiormente entonces $-A$ lo está superiormente, y que $op("ínf")(A) = -op("sup")(-A)$. El ítem (b) es el mismo argumento multiplicando por $c$ en vez de por $-1$.],
    [---],

    [*7* y *8*],
    [*Sucesiones* · *Convergencia de Sucesiones* · otra vez el *Principio de Arquímedes*, que es lo que produce el $n_0$ al final de cada cuenta.],
    [7, 8],

    [*9*, *10* y *11*],
    [*Divergencia de Sucesiones* (para los casos $ell = plus.minus oo$ del Ej. 9) · *Álgebra de límites* con sus demostraciones: la del ítem c, caso $b = 0$, es el argumento completo del Ej. 11 · *Sucesión Acotada* y *Toda sucesión convergente está acotada* · *Unicidad del límite*.],
    [8],

    [*12* y *13*],
    [*Sucesión Monótona* · *Convergencia de sucesiones monótonas crecientes*: el Ej. 12 (a) es su espejo · *Equivalencia del supremo 2*, cuya demostración construye la sucesión que pide el Ej. 13.],
    [10, 12],

    [*14*, *15* y *16*],
    [*Subsucesión* · *Convergencia de subsucesiones* con su demostración · *Negación de la Convergencia*, que es por donde se entra al Ej. 15.],
    [9, 11, 12],
  )
]

#v(5pt)

#text(size: 9pt)[
  *Dónde no hay ejemplo:* los Ej. 7 (b)--(c), 8, 9, 11, 12 (b), 14, 15 y 16 (b) no tienen ninguno que los ensaye. El modelo más cercano de cada uno --- casi siempre un desafío resuelto o una demostración del apunte --- está listado al final de `ejemplos.typ`, en las notas *Huecos frente a la Práctica 1* y *Dónde está el modelo cuando no hay ejemplo*.
]

#v(10pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

#set enum(numbering: "1.")

+ Probar que si $x < y + epsilon$ para todo $epsilon > 0$, entonces $x <= y$. Deducir que si $abs(x - y) < epsilon$ para todo $epsilon > 0$, entonces $x = y$. #hecho

+ #set enum(numbering: "(a)")
  + Sean $x, y in RR$ tales que $y - x > 1$. Probar que existe un entero entre $x$ e $y$. #hecho
  + Sean $x, y in RR$ tales que $x < y$. Probar que existe un racional entre $x$ e $y$. #hecho
  + Sean $x, y in QQ$ tales que $x < y$. Probar que existe un irracional entre $x$ e $y$. #hecho
  + Sean $x, y in RR$ tales que $x < y$. Probar que existe un irracional entre $x$ e $y$. #hecho

+ Sea $A subset.eq RR$ no vacío y acotado inferiormente. Probar la siguiente equivalencia: #hecho
  $ i = op("ínf") A <=> cases(
    i <= a "para todo " a in A,,
    "para todo " epsilon > 0 "existe " a in A "tal que " i <= a < i + epsilon.
  ) $

+ Hallar, si existen, supremo, ínfimo, máximo y mínimo de los siguientes subconjuntos de $RR$, y probar que lo son:
  #set enum(numbering: "(a)")
  #grid(
    columns: (1fr, 1fr),
    row-gutter: 10pt,
    [#set enum(numbering: "(a)", start: 1)
     + $(a, b]$ #hecho],
    [#set enum(numbering: "(a)", start: 2)
     + $B = \{1/2^n : n in NN\}$ #hecho],
    [#set enum(numbering: "(a)", start: 3)
     + $B union \{0\}$ #hecho],
    [#set enum(numbering: "(a)", start: 4)
     + $\{x^2 - x - 1 : x in RR\}$ #hecho]
  )

+ Sean $A subset.eq B subset.eq RR$, con $A != nothing$. Probar las siguientes afirmaciones:
  #set enum(numbering: "(a)")
  + Si $B$ está acotado superiormente, entonces $A$ también lo está, y $op("sup") A <= op("sup") B$. #hecho
  + Si $B$ está acotado inferiormente, entonces $A$ también lo está, e $op("ínf") B <= op("ínf") A$. #hecho
  + Si $A$ no está acotado, entonces $B$ tampoco lo está. #hecho

+ Dados un conjunto de números reales $A$ y $c in RR$, denotamos $c A = \{c a : a in A\}$. Más aún, $-A$ denotará al conjunto $(-1)A$. Probar las siguientes afirmaciones:
  #set enum(numbering: "(a)")
  + Probar que si $A$ está acotado superiormente, entonces $-A$ está acotado inferiormente e $op("ínf")(-A) = -op("sup") A$. #hecho
  + Probar que si $c > 0$ y $A$ está acotado superiormente, entonces $c A$ está acotado superiormente y $op("sup")(c A) = c op("sup")(A)$. #hecho

+ Probar, usando la definición de límite:
  #set enum(numbering: "(a)")
  + $lim_(n -> oo) (3 - 2n)/(n + 1) = -2$.
  + $lim_(n -> oo) (sin(n))/n = 0$.
  + $lim_(n -> oo) (2^n - 3)/(2^n + 4) = 1$.

+ Sean $(x_n)_(n in NN)$ y $(a_n)_(n in NN)$ sucesiones de números reales. Probar que si $abs(x_n - ell) <= a_n$ para todo $n in NN$ y $a_n ->_(n -> oo) 0$ entonces $x_n ->_(n -> oo) ell$.

+ Si $(x_n)_(n in NN)$ e $(y_n)_(n in NN)$ son sucesiones de números reales tales que $x_n ->_(n -> oo) ell_1$ e $y_n ->_(n -> oo) ell_2$, probar que $x_n + y_n ->_(n -> oo) ell_1 + ell_2$ para el caso en que:
  #set enum(numbering: "(a)")
  + $ell_1, ell_2 in RR$.
  + $ell_1 in RR$ y $ell_2 = oo$.
  + $ell_1 = +oo = ell_2$.
  + Pensar por qué no vale en el caso en que $ell_1 = +oo$ y $ell_2 = -oo$. Dar un contraejemplo para este caso.

+ Sean $(x_n)_(n in NN), (y_n)_(n in NN)$ sucesiones de números reales tales que $x_n ->_(n -> oo) ell_1$ e $y_n ->_(n -> oo) ell_2$. Probar que si $x_n <= y_n$ para todo $n$, entonces $ell_1 <= ell_2$.

+ Si $(x_n)_(n in NN)$ e $(y_n)_(n in NN)$ son sucesiones de números reales tales que $(x_n)_(n in NN)$ converge a $0$ e $(y_n)_(n in NN)$ está acotada, probar que $(x_n y_n)_(n in NN)$ converge a $0$.

+ Sea $(x_n)_(n in NN) subset.eq RR$ decreciente. Probar que:
  #set enum(numbering: "(a)")
  + Si $(x_n)_(n in NN)$ es acotada inferiormente, entonces tiene límite y
    $ lim_(n -> oo) x_n = op("ínf")\{x_n : n in NN\}. $
  + Si $(x_n)_(n in NN)$ es no acotada inferiormente, entonces $x_n ->_(n -> oo) -oo$.

+ Sea $A subset.eq RR$ acotado superiormente y no vacío. Probar que si $A$ no tiene máximo entonces existe $(a_n)_(n in NN) subset.eq A$ estrictamente creciente tal que $a_n ->_(n -> oo) op("sup")(A)$.

+ Sea $(x_n)_(n in NN) subset.eq RR$ una sucesión no acotada superiormente. Probar que existe una subsucesión $(x_(n_k))_(k in NN)$ que diverge a $+oo$.

+ Sean $(x_n)_(n in NN) subset.eq RR$ y $ell in RR$. Probar que si toda subsucesión $(x_(n_k))_(k in NN)$ tiene una (sub)subsucesión $(x_(n_(k_j)))_(j in NN)$ que converge a $ell$, entonces la sucesión $(x_n)_(n in NN)$ converge a $ell$.

+ Sea $(x_n)_(n in NN) subset.eq RR$. Probar:
  #set enum(numbering: "(a)")
  + Si $(x_(2k))_(k in NN)$ y $(x_(2k-1))_(k in NN)$ son convergentes, y sus límites coinciden, entonces $(x_n)_(n in NN)$ es convergente.
  + Si $(x_(2k))_(k in NN)$, $(x_(2k-1))_(k in NN)$ y $(x_(3k))_(k in NN)$ son convergentes, entonces $(x_n)_(n in NN)$ es convergente.

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

#enunciado[Ejercicio 1][
  Probar que si $x < y + epsilon$ para todo $epsilon > 0$, entonces $x <= y$. Deducir que si $abs(x - y) < epsilon$ para todo $epsilon > 0$, entonces $x = y$.
]

#solucion[Propuesta 1][
  Demostración por contrarrecíproco. Si $forall epsilon > 0 : x < y + epsilon => x <= y$, debe ser verdadero también que $x > y => exists epsilon > 0 : x >= y + epsilon$.

  Notemos que si $x > y$, entonces $x - y > 0$. Podemos llamar $delta = x - y$. En particular, $x >= y + delta$. Por lo tanto, hemos encontrado $epsilon = delta$ que cumple $x >= y + epsilon$. Habiendo demostrado que el contrarrecíproco vale, el recíproco también debe valer.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

#enunciado[Ejercicio 2 (a)][
  Sean $x, y in RR$ tales que $y - x > 1$. Probar que existe un entero entre $x$ e $y$.
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
  Sean $x, y in RR$ tales que $x < y$. Probar que existe un racional entre $x$ e $y$.
]

#solucion[Propuesta 1][
  Como $x < y$, sabemos que $y - x > 0$. Por el Principio de Arquímedes $exists n in NN : y - x > 1/n => y n - x n > 1$. Por el punto anterior (2a), $exists m in ZZ : x n < m < y n => x < m/n < y$. Hemos encontrado un racional entre dos números reales.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

#enunciado[Ejercicio 2 (c)][
  Sean $x, y in QQ$ tales que $x < y$. Probar que existe un irracional entre $x$ e $y$.
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
  Sean $x, y in RR$ tales que $x < y$. Probar que existe un irracional entre $x$ e $y$.
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

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

#sublema(titulo: "Anexo: ejercicio de la edición 2025")[
  La guía 2026 no incluye el ejercicio de punto fijo, que figuraba como *Ejercicio 7* en la edición anterior. Se conserva acá porque es el único ejercicio de toda la práctica que se apoya sólo en el Cap. 1 y estaba marcado como el siguiente a resolver.
]

#enunciado[Ejercicio 7 (edición 2025)][
  Sea $f : [a, b] -> [a, b]$ creciente. Supongamos que $f(a) > a$. Sea
  $ x_0 = op("sup")(\{x in [a, b] : f(x) > x\}). $
  Pruebe que $f(x_0) = x_0$.
]
