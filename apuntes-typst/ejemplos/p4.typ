#import "@preview/frame-it:2.0.0": *
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

#show heading.where(level: 2): it => block(width: 100%)[
  #v(6pt)
  #text(size: 12pt, weight: "bold", fill: rgb("#059669"))[#it.body]
  #v(2pt)
  #line(length: 100%, stroke: 0.7pt + rgb("#a7f3d0"))
]

// --- Ejemplos de la Práctica 4 ---

#align(center)[
  #text(14pt, weight: "bold")[Ejemplos resueltos --- Práctica 4] \
  #v(2pt)
  #text(10pt, style: "italic", fill: rgb("#475569"))[
    Continuidad, funciones lipschitz y continuidad uniforme
  ]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

Los ejemplos están agrupados por *técnica*, no por orden de transcripción, y los bloques siguen el orden en que la guía los necesita. Cada bloque abre con la nota de qué ejercicios de `guias/p4.typ` desbloquea.

La pestaña dice de dónde viene cada ejemplo: *`C{clase}-{ejemplo}`* es un ejercicio resuelto en clase, transcrito en `clases/` (un archivo por tema; la tabla clase $arrow$ archivo está en la skill `ejemplo`). En este archivo hay dos fuentes. `C6-*` es `clases/continuidad.typ` (clase del 07/10/2025, apunte tipeado de Mateo Mauri), que numera sus resultados por sección: `C6-2.2` es el Problema 2.2 y `C6-1.1` la Proposición 1.1; como esa clase tiene un Lema 3.1 y un Problema 3.1, el lema lleva `C6-3.1` y el problema `C6-3.1b`. `C8-*` es `clases/continuidad_uniforme.typ` (clase del 23/10/2025): `C8-4` es su Ejercicio 4.

#v(6pt)

#show table.cell.where(y: 0): set text(fill: white, weight: "bold", size: 8.5pt)

#table(
  columns: (0.35fr, 2.4fr, 1.1fr),
  align: (center + horizon, left + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#065f46") } else if calc.even(y) { rgb("#f8fafc") } else { white },
  stroke: 0.4pt + rgb("#cbd5e1"),
  inset: (x: 6pt, y: 4pt),

  [*\#*], [*Bloque*], [*Desbloquea*],
  [1], [Continuidad: suma, producto, proyecciones y polinomios], [p4: Ej. 1 (a), 3; la pregunta "¿cambia algo con $d_1$ o $d_oo$?" de Ej. 1 y 5 vía C8-1],
  [2], [Abiertos y cerrados como preimágenes], [p4: Ej. 4, 5, 6],
  [3], [Continuidad y densidad], [p4: Ej. 7 (a) (es C6-3.2), Ej. 8 (es C6-3.1); conceptual para Ej. 2],
  [4], [Funciones entre $C([0,1])$ con $d_oo$ y $d_1$], [p4: Ej. 9],
  [5], [Lipschitz], [p4: Ej. 12; refutación con sucesiones para Ej. 13 (b)],
  [6], [Continuidad uniforme: probarla y refutarla], [p4: Ej. 13, 15; conceptual para Ej. 14, 16],
  [7], [Pegado de dominios], [p4: Ej. 13 (a), 15 (b); Ej. 16 (contrarrecíproco)],
)

#v(4pt)

#text(size: 9pt, fill: rgb("#64748b"))[
  La numeración de ejercicios es la de la *guía 2025* (`guias/p4.typ`).
]

#v(8pt)

== Bloque 1 · Continuidad: suma, producto, proyecciones y polinomios

#sublema(titulo: "Qué desbloquea")[
  El *Ejercicio 1* de la Práctica 4 pide decidir si son continuas $f(x, y) = x^2 + y^2$, una función definida por casos y la identidad de $RR^2$ entre la métrica discreta y la euclídea, y pregunta si cambia algo al reemplazar $d_2$ por $d_1$ o $d_oo$; el *Ejercicio 3* es la primera manipulación de la definición (si $f(x_0) > 0$, $f$ es positiva en una bola). La clase del 07/10 construye la herramienta que resuelve el ítem (a) de una vez: suma y producto de continuas son continuas (C6-1.1, por sucesiones y álgebra de límites), las proyecciones $pi_i : RR^n -> RR$ son continuas para $d_oo$ (C6-1.2, cuyo único paso es $abs(x^i_k - x^i) <= d_oo$, desigualdad que también vale con $d_1$ y $d_2$: ése es el "no cambia nada" que pide la guía), y por lo tanto todo *polinomio en varias variables* es continuo (C6-1.6).

  La clase define: $P : RR^n -> RR$ es un *polinomio en varias variables* si puede escribirse como
  $ P(x_1, dots, x_n) = sum_(e_1 + dots.c + e_n <= r) a_((e_1, dots, e_n)) x_1^(e_1) dots.c x_n^(e_n) $
  para algún $r in NN$ (Definición 1.4); por ejemplo $P(x, y, z) = x^4 + x y z^2 + x y + z^2 - y + 18$ (Ejemplo 1.5). El Ejemplo 1.3 de la clase ($pi_2 (x, y, z) = y$ es continua) queda en la fuente como ejercicio y es el caso particular del Lema 1.2, así que no se carga aparte.

  La clase del 23/10 generaliza las proyecciones a un producto $X times Y$ de espacios métricos cualesquiera con $d_oo ((x, y), (x', y')) = op("máx"){d_1 (x, x'), d_2 (y, y')}$: son continuas y abiertas, pueden no ser cerradas, y una $f : Z -> X times Y$ es continua si y sólo si lo son sus dos coordenadas (C8-1). Es el criterio para tratar funciones a valores en $RR^2$ y, de paso, un primer ejemplo de que la imagen de un cerrado por una continua puede no ser cerrada (Ejercicio 6 (b)).
]

#ejemplo[Suma y producto de funciones continuas son continuas (Clase 6 · Proposición 1.1)][C6-1.1][
  Sean $X$ e $Y$ dos espacios métricos, y $f, g : X -> Y$ dos funciones continuas entre estos espacios. Se tiene entonces que $f + g$ y $f dot.c g$ también son funciones continuas entre estos espacios.

  _Nota_: para que $f + g$ y $f dot.c g$ tengan sentido hace falta que en $Y$ se pueda sumar y multiplicar; en lo que sigue se usa con $Y = RR$ (con la métrica usual), que es el caso que interesa para los polinomios.
]

#estrategia[Continuidad por sucesiones y álgebra de límites][
  Con la caracterización sucesional, probar que $f + g$ es continua es probar que $(f + g)(x_n) -> (f + g)(x)$ para toda $x_n -> x$. Pero $(f + g)(x_n) = f(x_n) + g(x_n)$ es la suma de dos sucesiones convergentes (por continuidad de $f$ y de $g$), y el álgebra de límites de $RR$ hace el resto. Para el producto es la misma frase con "producto" en lugar de "suma".
]

#resolucion[
  Comencemos por demostrar que la suma de funciones continuas es una función continua. Sea $(x_n)_(n in NN)$ una sucesión de elementos de $X$ convergente, y sea $x$ su límite; veamos que
  $ lim_(n -> oo) (f + g)(x_n) = (f + g)(x). $
  En efecto, notar que
  $
    lim_(n -> oo) (f + g)(x_n) &= lim_(n -> oo) f(x_n) + g(x_n) = lim_(n -> oo) f(x_n) + lim_(n -> oo) g(x_n) \
    &= f(x) + g(x) = (f + g)(x),
  $
  donde la única igualdad que no se deduce directamente de las definiciones es la tercera, que se debe al álgebra de límites (la sucesión dada por una suma de sucesiones convergentes converge a la suma de los límites).

  Exactamente de la misma forma uno puede probar que el producto de funciones continuas es continua, observando que
  $
    lim_(n -> oo) (f dot.c g)(x_n) &= lim_(n -> oo) f(x_n) dot.c g(x_n) = lim_(n -> oo) f(x_n) dot.c lim_(n -> oo) g(x_n) \
    &= f(x) dot.c g(x) = (f dot.c g)(x).
  $
]

#ejemplo[Las proyecciones $pi_i : RR^n -> RR$ son continuas para $d_oo$ (Clase 6 · Lema 1.2)][C6-1.2][
  Sea $pi_i : RR^n -> RR$ la función que proyecta en la $i$-ésima coordenada, es decir, la función tal que $pi_i (x_1, x_2, dots, x_n) = x_i$. Esta función es continua en la métrica dada por la distancia $d_oo$.
]

#estrategia[Convergencia en $d_oo$ implica convergencia coordenada a coordenada][
  Hay que ver que si $(x^1_k, dots, x^n_k) -> (x^1, dots, x^n)$ en $(RR^n, d_oo)$ entonces $x^i_k -> x^i$ en $RR$. Como $abs(x^i_k - x^i)$ es uno de los números cuyo máximo es $d_oo$, está acotado por la distancia: el $n_0$ de la convergencia en $RR^n$ sirve para la coordenada.
]

#resolucion[
  Sea ${(x^1_k, x^2_k, dots, x^n_k)}_(k in NN)$ una sucesión cualquiera convergente a algún punto de $RR^n$, que denotaremos como $(x^1, x^2, dots, x^n)$. Para probar la continuidad, debemos ver que
  $ lim_(k -> oo) pi_i (x^1_k, x^2_k, dots, x^n_k) = pi_i (x^1, x^2, dots, x^n). $
  Por todo lo que acabamos de definir, esto es lo mismo que probar que
  $ lim_(k -> oo) x^i_k = x^i, $
  pero esto se deduce de que la convergencia de una sucesión en $RR^n$ con la métrica dada por la distancia $d_oo$ implica la convergencia de las sucesiones de sus coordenadas. En efecto, dado $epsilon > 0$, existe un $n_0 in NN$ tal que $d_oo ((x^1_k, dots, x^n_k), (x^1, dots, x^n)) <= epsilon$ para todo $k >= n_0$, pero esto implica que
  $ abs(x^i_k - x^i) <= d_oo ((x^1_k, x^2_k, dots, x^n_k), (x^1, x^2, dots, x^n)) <= epsilon, $
  y se concluye lo deseado.
]

#ejemplo[Los polinomios en varias variables son continuos (Clase 6 · Proposición 1.6)][C6-1.6][
  Los polinomios en varias variables (Definición 1.4) son funciones continuas de $RR^n$ a $RR$.
]

#resolucion[
  Basta con observar que los polinomios son sumas y productos de las funciones estudiadas en el Lema 1.2 (las proyecciones $x_i = pi_i (x_1, dots, x_n)$, y las constantes), y que sumas y productos de continuas son continuas por la Proposición 1.1.
]

#sublema(titulo: "Para qué sirve")[
  En el Ejercicio 1 (a), $f(x, y) = x^2 + y^2$ es un polinomio: continua sin $epsilon$ ni $delta$. Y en el Ejercicio 5, cada conjunto está descripto por desigualdades entre polinomios (o entre funciones armadas con polinomios y $sin$, $exp$, que también son continuas), que es lo que necesita el Bloque 2.
]

#sublema(titulo: [$d_oo$ en $X times Y$ es una métrica])[
  Sean $(X, d_1)$ e $(Y, d_2)$ espacios métricos. En $X times Y$ se define $d_oo ((x, y), (x', y')) = op("máx"){d_1 (x, x'), d_2 (y, y')}$. La clase del 23/10 verifica que es una métrica: vale $0$ si y sólo si $d_1 (x, x') = 0$ y $d_2 (y, y') = 0$, o sea $(x, y) = (x', y')$; es simétrica porque $d_1$ y $d_2$ lo son; y para la triangular, dado $(z, w) in X times Y$, de $d_1 (x, x') <= d_1 (x, z) + d_1 (z, x')$ sale
  $
    d_1 (x, x') &<= op("máx"){d_1 (x, z), d_2 (y, w)} + op("máx"){d_1 (z, x'), d_2 (w, y')} \
    &= d_oo ((x, y), (z, w)) + d_oo ((z, w), (x', y')),
  $
  lo mismo para $d_2 (y, y')$, y tomando máximo de los dos lados izquierdos queda
  $ d_oo ((x, y), (x', y')) <= d_oo ((x, y), (z, w)) + d_oo ((z, w), (x', y')). $
]

#ejemplo[Las proyecciones de $X times Y$ son continuas y abiertas, no siempre cerradas; $f$ es continua sii lo son sus coordenadas (Clase 8 · Ejercicio 1)][C8-1][
  Sean $(X, d_1)$ e $(Y, d_2)$ espacios métricos. Pensamos a $X times Y$ con $d_oo$.

  #set enum(numbering: "a)")
  + Probar que $pi_1 : X times Y -> X$, $(x, y) |-> x$, y $pi_2 : X times Y -> Y$, $(x, y) |-> y$, son continuas y abiertas, pero pueden _no ser cerradas_.
  + Sea $(Z, delta)$ un espacio métrico y sea $f : Z -> X times Y$ una aplicación. Probar que $f$ es continua si y sólo si $f_1 = pi_1 compose f$ y $f_2 = pi_2 compose f$ lo son.
]

#estrategia[La bola de $d_oo$ es un "cuadrado" cuya sombra es una bola; la hipérbola $x y = 1$ se proyecta sobre $RR without {0}$][
  Continuidad: $d_1 (x, x_0) <= d_oo ((x, y), (x_0, y_0))$, así que $delta = epsilon$ sirve. Abierta: alcanza con bolas (todo abierto es unión de bolas y $pi_1$ respeta uniones), y la bola $B((x_0, y_0), r)$ de $d_oo$ es ${d_1 (x, x_0) < r "y" d_2 (y, y_0) < r}$, cuya proyección es exactamente $B(x_0, r)$. No cerrada: hace falta un cerrado $F$ cuyas "alturas" $y_n$ se escapen; la hipérbola $x y = 1$ es cerrada (preimagen de ${1}$ por un polinomio) y su proyección es $RR without {0}$. Para (b), la ida es composición de continuas; la vuelta, por sucesiones, usa que $d_oo (f(z_n), f(z_0))$ es el máximo de las dos distancias coordenada a coordenada, cada una chica a partir de su $n_i$.
]

#resolucion[
  *a)* Probemos que $pi_1$ es continua y abierta. Para ver que es continua, dado $(x_0, y_0) in X times Y$, hay que ver que dado $epsilon > 0$ existe $delta > 0$ tal que si $d_oo ((x, y), (x_0, y_0)) < delta$ entonces
  $ d_1 (pi_1 (x, y), pi_1 (x_0, y_0)) = d_1 (x, x_0) < epsilon. $
  Como
  $ d_1 (x, x_0) <= op("máx"){d_1 (x, x_0), d_2 (y, y_0)} = d_oo ((x, y), (x_0, y_0)), quad (*) $
  si $delta <= epsilon$ garantizamos lo pedido gracias a $(*)$.

  Para ver que $pi_1$ es abierta, tenemos que ver que _para todo abierto $U subset.eq X times Y$, $pi_1 (U)$ es abierto_. Notemos que si probamos que _para toda bola $B(x, r)$, $pi_1 (B(x, r))$ es abierto_, entonces se sigue la misma conclusión para todo abierto $U$: para todo $x in U$ existe $r_x > 0$ tal que $B(x, r_x) subset.eq U$. Entonces $U = union.big_(x in U) B(x, r_x)$, por lo tanto
  $ pi_1 (U) = pi_1 (union.big_(x in U) B(x, r_x)) = union.big_(x in U) pi_1 (B(x, r_x)) $
  y es unión de abiertos, por lo tanto es abierto.

  Sea $(x_0, y_0) in X times Y$ y $r > 0$. Entonces
  $
    B((x_0, y_0), r) &= {(x, y) : d_oo ((x, y), (x_0, y_0)) < r} \
    &= {(x, y) : op("máx"){d_1 (x, x_0), d_2 (y, y_0)} < r} \
    &= {(x, y) : d_1 (x, x_0) < r "y" d_2 (y, y_0) < r}.
  $
  Por otro lado,
  $ pi_1 (B((x_0, y_0), r)) = {x in X : "existe" y in Y "con" d_1 (x, x_0) < r "y" d_2 (y, y_0) < r}. $
  (Dibujo de la clase: en el plano $x y$, la bola centrada en $(x_0, y_0)$ y, debajo, su sombra sobre el eje $x$: un intervalo centrado en $x_0$ del "mismo radio".)

  Veamos que $B(x_0, r) subset.eq pi_1 (B((x_0, y_0), r))$. Dado $x in B(x_0, r)$, resulta que $d_1 (x, x_0) < r$. Sea $y in B(y_0, r)$, por ejemplo $y = y_0$. Tenemos que $(x, y_0) in B((x_0, y_0), r)$, pues
  $ d_oo ((x_0, y_0), (x, y_0)) = op("máx"){d_1 (x_0, x), underbrace(d_2 (y_0, y_0), = 0)} = d_1 (x_0, x) < r. $
  Entonces $B(x_0, r) subset.eq pi_1 (B((x_0, y_0), r))$.

  _Nota_: el manuscrito prueba sólo esta inclusión; la otra es inmediata de la descripción anterior (si $x in pi_1 (B((x_0, y_0), r))$ entonces $d_1 (x, x_0) < r$), así que $pi_1 (B((x_0, y_0), r)) = B(x_0, r)$, que es abierto, y eso es lo que se necesitaba.

  Veamos que en general $pi_1$ _no es cerrada_, es decir, existe $F subset.eq X times Y$ cerrado con $pi_1 (F)$ no cerrado.

  _Idea_: sea $F subset.eq X times Y$ cerrado, y consideremos $pi_1 (F)$. Si $(x_n)_n subset.eq pi_1 (F)$ cumple que $x_n -> x$, querríamos ver que $x in pi_1 (F)$, es decir, que existe $y in Y$ tal que $(x, y) in F$. Como $x_n in pi_1 (F)$, existe $y_n in Y$ tal que $(x_n, y_n) in F$. Lo ideal sería que $(x_n, y_n) -> (x, y)$, porque en tal caso, al ser $F$ cerrado, $(x, y) in F$ y entonces $x in pi_1 (F)$. El problema es que $(y_n)_n$ no tiene por qué converger, ni tener subsucesiones convergentes.

  _Ejemplo_: si $X = Y = RR$, en $RR^2$ con $d_oo$, sea $F = {(x, y) : x y = 1}$. Es cerrado porque es la preimagen de ${1}$ vía $f(x, y) = x y$, o sea $F = f^(-1) ({1})$; como $f$ es continua, $F$ es cerrado. Pero
  $ pi_1 (F) = {x in RR : "existe" y in RR "con" x y = 1} = RR without {0}, $
  que no es cerrado. (Dibujo de la clase: la hipérbola $x y = 1$ con flechas que la proyectan sobre el eje $x$; la proyección cubre toda la recta salvo el $0$.)

  Las afirmaciones para $pi_2$ se prueban de manera análoga.

  *b)* Notemos que si $f$ es continua, por el ítem (a) $pi_1$ y $pi_2$ son continuas, y en consecuencia $f_1 = pi_1 compose f$ y $f_2 = pi_2 compose f$ son continuas por ser composición de continuas. Para la vuelta usemos sucesiones: $f$ es continua en $z_0 in Z$ sii para toda $(z_n)_n subset.eq Z$ con $z_n -> z_0$ se tiene que $f(z_n) -> f(z_0)$. Notemos que
  $ f : Z -> X times Y, quad f(z) = (f_1 (z), f_2 (z)), $
  porque $f_1 = pi_1 compose f$, $f_2 = pi_2 compose f$. Sea $(z_n)_n subset.eq Z$ con $z_n -> z_0$. Como $f_1$ y $f_2$ son continuas en $z_0$, $f_1 (z_n) -> f_1 (z_0)$ y $f_2 (z_n) -> f_2 (z_0)$. Sea $epsilon > 0$. Sabemos que existen $n_1, n_2 in NN$ tales que
  $
    d_1 (f_1 (z_0), f_1 (z_n)) &< epsilon " para todo " n >= n_1, \
    d_2 (f_2 (z_0), f_2 (z_n)) &< epsilon " para todo " n >= n_2.
  $
  Entonces, para todo $n >= n_0 = op("máx"){n_1, n_2}$,
  $ d_oo (f(z_0), f(z_n)) = op("máx"){d_1 (f_1 (z_0), f_1 (z_n)), d_2 (f_2 (z_0), f_2 (z_n))} < epsilon. $
  Concluimos que $f(z_n) -> f(z_0)$.
]

#sublema(titulo: "Para qué sirve")[
  De (b), tomando $f = op("id")_(X times Y)$ (es decir $f_1 (x, y) = x$, $f_2 (x, y) = y$), sale que en $X times Y$ con $d_oo$ una sucesión $(x_n, y_n) -> (x, y)$ si y sólo si $x_n -> x$ e $y_n -> y$: la convergencia en el producto es coordenada a coordenada. Esto es lo que usan C6-1.2 en $RR^n$ y la pregunta "¿cambia algo con $d_1$ o $d_oo$?" de los Ejercicios 1 y 5. El ejemplo de la hipérbola es, además, el modelo del Ejercicio 6 (b): una continua puede mandar un cerrado a un no cerrado.
]

== Bloque 2 · Abiertos y cerrados como preimágenes

#sublema(titulo: "Qué desbloquea")[
  Los *Ejercicios 4 y 5* de la Práctica 4 piden probar que conjuntos descriptos por igualdades y desigualdades son abiertos o cerrados, y el *Ejercicio 6* que la imagen (no la preimagen) de un abierto o de un cerrado por una continua puede no serlo. La maniobra única de este bloque es escribir el conjunto como $f^(-1) (C)$ con $f$ continua y $C$ un abierto o un cerrado conocido de $RR$: ${f >= 0} = f^(-1) ([0, +oo))$ es cerrado, ${f != 0} = f^(-1) (RR without {0})$ es abierto. C6-2.1 lo hace para una región del plano acotada por una curva polinomial (modelo del Ejercicio 5 (a)--(b)) y C6-2.2 para $op("GL")_n (RR)$, donde la gracia es ver que $det$ es un polinomio en los coeficientes (por inducción con la fórmula de cofactores). Para el Ejercicio 4, ${f != g} = (f - g)^(-1) (E' without {"punto"})$ no sirve en un $E'$ métrico general, pero la idea de "preimagen por algo continuo" se adapta con $x |-> d'(f(x), g(x))$, que es continua (Bloque 1 + Ejercicio 10).
]

#ejemplo[Un conjunto cerrado del plano como preimagen por un polinomio (Clase 6 · Problema 2.1)][C6-2.1][
  Probar que el conjunto $A = {(x, y) in RR^2 : x^3 >= x^2 + y - x}$ es cerrado con la métrica dada por la distancia $d_oo$.

  _Observación 2.1 (de la clase)_: puede graficarse el conjunto: es la región por debajo de la curva $y = x^3 - x^2 + x$, es decir $A = {(x, y) : y <= x^3 - x^2 + x}$.
]

#estrategia[Pasar todo de un lado y leer el conjunto como ${f >= 0}$][
  La desigualdad $x^3 >= x^2 + y - x$ es $f(x, y) >= 0$ con $f(x, y) = x^3 - x^2 + x - y$, un polinomio y por lo tanto continuo (C6-1.6). Así $A = f^(-1) ([0, +oo))$: preimagen de un cerrado por una continua, cerrado.
]

#resolucion[
  Si tomamos la función $f : RR^2 -> RR$ dada por $f(x, y) = x^3 - x^2 + x - y$, podemos caracterizar al conjunto $A$ como
  $ A = {(x, y) : f(x, y) >= 0} = f^(-1) ([0, +oo)). $
  Visto de esta manera, $A$ es la preimagen de un conjunto cerrado a través de una función continua (cosa que se ve de que $f$ es un polinomio), y por lo tanto es cerrado.

  _Nota_: el apunte escribe $f^(-1) ((0, +oo))$ y "preimagen de un conjunto abierto", pero $A$ está definido con $>=$: es $A = {f >= 0} = f^(-1) ([0, +oo))$, la preimagen del _cerrado_ $[0, +oo)$, y por eso $A$ es cerrado (que es lo que pide el problema); con $(0, +oo)$ se obtendría el abierto ${f > 0}$, que no es $A$.
]

#ejemplo[$op("GL")_n (RR)$ es abierto en $op("M")_n (RR)$ (Clase 6 · Problema 2.2)][C6-2.2][
  Probar que el conjunto de matrices inversibles con coeficientes reales, $op("GL")_n (RR)$, es abierto en el conjunto $op("M")_n (RR)$ de matrices de $n times n$ con coeficientes reales, si a las matrices las dotamos de la distancia $d_oo$ (identificando $op("M")_n (RR) = RR^(n times n)$).
]

#estrategia[Inversible es $det != 0$, y el determinante es un polinomio en las entradas][
  $op("GL")_n (RR) = det^(-1) (RR without {0})$, preimagen de un abierto. Falta ver que $det : RR^(n times n) -> RR$ es continua, y es más: es un polinomio en los $n^2$ coeficientes. Esto sale por inducción en $n$ con el desarrollo por cofactores, que escribe $det_(n+1)$ como suma de productos de una entrada por un $det_n$.
]

#resolucion[
  Una caracterización común de $op("GL")_n (RR)$ estudiada en el CBC es la dada por el determinante. En efecto, podemos pensar a este conjunto como
  $ op("GL")_n (RR) = {A in op("M")_n (RR) : det(A) != 0}. $
  En vista del ejercicio anterior, esto nos da una pista de cómo probar que este conjunto es abierto: si pudiésemos ver que la función determinante es continua, podríamos entender a las matrices inversibles como la preimagen de un abierto ($det^(-1) (RR without {0})$), y por ende sería abierto. En efecto, la función determinante es una función $det : RR^(n times n) -> RR$ y es más que continua: es un polinomio.

  Para ver esto último vayamos por inducción. La hipótesis inductiva es: "la función $det_n$, pensada como el determinante para matrices de $n times n$, es una función polinomial en los coeficientes de la matriz (y por ende de $RR^(n times n)$ a $RR$)".

  El caso base es sencillo, ya que $det_1$ es la identidad, que es trivialmente un polinomio. Para el paso inductivo, asumamos que la función $det_n$ es un polinomio y veamos que lo mismo ocurre para la función $det_(n+1)$. Sea $A = (a_(i j))_(1 <= i, j <= n+1)$ una matriz de tamaño $(n+1) times (n+1)$. Para cada par de índices $1 <= i, j <= n+1$ denotamos por $A_(i j)$ a la matriz que se obtiene de $A$ al eliminar la fila $i$ y la columna $j$. Con esta notación, la fórmula para calcular el determinante por cofactores viene dada por
  $
    cases(
      det_1 (a_(11)) = a_(11)\,,
      det_(n+1) (A) = limits(sum)_(j = 1)^(n+1) (-1)^(1+j) a_(1 j) det_n (A_(1 j)).
    )
  $
  Mirando esta definición, es claro que si por hipótesis inductiva la función $det_n$ es un polinomio en los coeficientes de una matriz de $n times n$, la función $det_(n+1)$ también debe serlo, ya que se fabrica como suma y producto de polinomios en los coeficientes de una matriz de $(n+1) times (n+1)$.

  Habiendo probado que el determinante es una función polinomial, y que las funciones polinomiales son continuas (C6-1.6), concluimos el resultado observando que
  $ op("GL")_n (RR) = det^(-1) (RR without {0}), $
  que es la preimagen de un abierto a través de una función continua, y por ende abierto también.
]

== Bloque 3 · Continuidad y densidad

#sublema(titulo: "Qué desbloquea")[
  Dos resultados de la clase del 07/10 son *literalmente* ejercicios de la guía: el Lema 3.1 (la imagen de un denso por una continua es densa, C6-3.1) es el *Ejercicio 8*, y el Lema 3.2 (dos continuas que coinciden en un denso coinciden en todo, C6-3.2) es el *Ejercicio 7 (a)*. Vale la pena comparar los enunciados: la guía agrega en el Ejercicio 8 la hipótesis "$f$ suryectiva", que la clase omite y que hace falta (ver la nota en C6-3.1). El Problema 3.1 (C6-3.1b) muestra para qué sirve el Lema 3.2: para determinar una función continua alcanza con conocerla en $QQ$, que es denso en $RR$, y eso resuelve la ecuación funcional $f(x + y) = f(x) f(y)$. La misma idea (aproximar un real por racionales, o por irracionales) es la que decide el *Ejercicio 2*, donde $f$ vale $x$ en $QQ$ y $0$ fuera.
]

#ejemplo[La imagen continua de un denso es densa (Clase 6 · Lema 3.1 $=$ Ejercicio 8 de la guía)][C6-3.1][
  Sea $f : X -> Y$ una función continua entre dos espacios métricos. Se tiene que $f(D) subset.eq Y$ es un conjunto denso siempre que $D subset.eq X$ sea denso.

  _Nota_: tal como está enunciado, el lema necesita además que $f$ sea sobreyectiva (o bien debe leerse "$f(D)$ es denso en $f(X)$"); la guía lo pide con "$f$ continua y suryectiva". Si la imagen de $f$ no es todo $Y$, un abierto $A subset.eq Y$ disjunto de $f(X)$ tiene $f^(-1) (A) = emptyset$ y el argumento de la demostración, que supone $f^(-1) (A)$ no vacío, no se aplica.
]

#estrategia[Denso es "toca a todo abierto", y la continuidad transporta abiertos hacia atrás][
  Hay que ver que todo abierto $A subset.eq Y$ corta a $f(D)$. Como $f$ es continua, $f^(-1) (A)$ es abierto en $X$ (y no vacío si $f$ es sobreyectiva y $A != emptyset$), así que por densidad de $D$ contiene un punto $d in D$; entonces $f(d) in A inter f(D)$.
]

#resolucion[
  Sea $A subset.eq Y$ un conjunto abierto cualquiera (no vacío). Para ver que $f(D)$ es denso basta con probar que $f(D)$ interseca a $A$, ya que $A$ era arbitrario. Como $A$ es abierto y $f$ es continua, $f^(-1) (A)$ es un abierto de $X$ (no vacío, por la sobreyectividad), y como $D$ es denso en $X$, debe ocurrir que $f^(-1) (A) inter D != emptyset$. Esto último implica directamente que $A inter f(D) != emptyset$, y concluimos lo deseado.
]

#ejemplo[Dos continuas que coinciden en un denso coinciden en todo (Clase 6 · Lema 3.2 $=$ Ejercicio 7 (a) de la guía)][C6-3.2][
  Sean $f, g : X -> Y$ dos funciones continuas entre espacios métricos y sea $D$ un conjunto denso en $X$. Si $f(x) = g(x)$ para todo $x in D$, tiene que ser que $f equiv g$.
]

#estrategia[Todo punto es límite de una sucesión del denso][
  Fijado $x in X$, la densidad de $D$ da $(x_n)_n subset.eq D$ con $x_n -> x$. Sobre $D$ las dos funciones son la misma sucesión $f(x_n) = g(x_n)$, y la continuidad de ambas obliga a que sus límites, $f(x)$ y $g(x)$, coincidan.
]

#resolucion[
  Sea $x in X$ un elemento cualquiera, y sea $(x_n)_(n in NN)$ una sucesión convergente a $x$ de elementos de $D$ (esto puede hacerse ya que $D$ es denso). Por continuidad, notar que
  $ f(x) = lim_(n -> oo) f(x_n) = lim_(n -> oo) g(x_n) = g(x), $
  de lo que concluimos lo deseado.

  _Nota_: el apunte dice "una sucesión convergente a $X$ de elementos de $D$"; se refiere a una sucesión convergente al punto $x$.
]

#ejemplo[Las continuas con $f(x + y) = f(x) f(y)$ y $f(1) = 2$ (Clase 6 · Problema 3.1)][C6-3.1b][
  Caracterizar todas las funciones continuas $f : RR -> RR$ tales que $f(x + y) = f(x) f(y)$ para cualesquiera $x, y in RR$ y $f(1) = 2$.
]

#estrategia[Primero $NN$, después $QQ$, y la continuidad hace el resto][
  La ecuación funcional determina $f$ en $NN$ ($f(n) = 2^n$, sumando unos), en los racionales positivos ($f(p \/ q)^q = f(p) = 2^p$) y en los negativos (de $2 = f(1) = f(1) f(p \/ q) f(-p \/ q)$ se despeja $f(-p \/ q)$). Así $f = 2^x$ en $QQ$, y como $f$ y $x |-> 2^x$ son continuas e iguales en un denso, el Lema 3.2 (C6-3.2) da $f(x) = 2^x$ en todo $RR$.
]

#resolucion[
  Notemos primero que, si $n in NN$, se tiene que
  $ f(n) = f(1 + dots.c + 1) = f(1) dots.c f(1) = 2 dots.c 2 = 2^n. $
  Por otro lado, si evaluamos en $p \/ q$ con $p, q in NN$, se tiene
  $ f(p/q) = f(p/q)^(q/q) = (f(p/q)^q)^(1/q) = f(p)^(1/q) = (2^p)^(1/q) = 2^(p/q). $
  Además, es claro que si tomamos $p \/ q$ con $p, q in NN$, se tiene que
  $ 2 = f(1) = f(1 + p/q - p/q) = f(1) dot.c f(p/q) dot.c f(-p/q) = 2 dot.c f(p/q) dot.c f(-p/q), $
  de lo que se concluye que, como $f(p \/ q) = 2^(p \/ q)$, debe tenerse que $f(-p \/ q) = 2^(-p \/ q)$.

  Con todo lo probado hasta ahora, obtuvimos que si $x in QQ$ entonces $f(x) = 2^x$. Por hipótesis sabemos que $f$ es continua, y asumiremos la continuidad de la exponencial como un hecho. Tenemos entonces que, dado un $x in RR$ cualquiera, si tomamos una sucesión de racionales $(x_n)_(n in NN)$ convergente a $x$ (cosa que podemos hacer porque los racionales son densos en $RR$), se tiene que
  $ f(x) = lim_(n -> oo) f(x_n) = lim_(n -> oo) 2^(x_n) = 2^x, $
  lo que termina de caracterizar a nuestra función.

  _Nota_: dos detalles que el apunte deja implícitos: el caso $x = 0$ sale de $2 = f(1) = f(1 + 0) = 2 f(0)$, o sea $f(0) = 1 = 2^0$; y para tomar la raíz $q$-ésima real en $(f(p \/ q)^q)^(1 \/ q) = f(p \/ q)$ hace falta $f(p \/ q) >= 0$, que vale porque $f(p \/ q) = f(p \/ (2q))^2$.
]

== Bloque 4 · Funciones entre $C([0,1])$ con $d_oo$ y $d_1$

#sublema(titulo: "Qué desbloquea")[
  El *Ejercicio 9* de la Práctica 4 estudia dos funcionales en $C([0, 1])$, la evaluación $cal(E)(f) = f(0)$ y la integral $cal(I)(f) = integral_0^1 f$, y pide ver que ambas son continuas para $d_oo$, que para $d_1$ sólo $cal(I)$ lo es, y si puede haber una continua para $d_1$ pero no para $d_oo$. El único ejemplo de clase con este sabor es C8-4: $Psi(f)(x) = x f(x)$, de $(C[0, 1], d_oo)$ a $(C[0, 1], d_1)$, es lipschitz con constante $1$. La cuenta que lo prueba, $integral_0^1 abs(h) <= sup abs(h)$, es decir $d_1 <= d_oo$, es exactamente la que hace continua a $cal(I)$ para $d_oo$ y la que responde a la pregunta (c): todo lo que es continuo "desde $d_1$" lo es "desde $d_oo$", porque $d_oo$ es la métrica más fina de las dos. Lo que la clase no hace (y la guía sí pide) es la refutación para $cal(E)$ con $d_1$: hay que fabricar $f_n$ con $integral_0^1 abs(f_n) -> 0$ pero $f_n (0)$ lejos de $0$.
]

#ejemplo[$Psi(f)(x) = x f(x)$ es lipschitz de $(C[0,1], d_oo)$ a $(C[0,1], d_1)$ (Clase 8 · Ejercicio 4)][C8-4][
  Sea $Psi : (C[0, 1], d_oo) -> (C[0, 1], d_1)$ dada por
  $ (Psi(f))(x) := x f(x). $
  Decidir si $Psi$ es lipschitz.
]

#estrategia[Acotar la integral del módulo por el supremo del módulo][
  $d_1 (Psi(f), Psi(g)) = integral_0^1 abs(x) abs(f(x) - g(x)) dif x$; como $abs(x) <= 1$ en $[0, 1]$ y $abs(f(x) - g(x)) <= d_oo (f, g)$ para todo $x$, la integral queda acotada por $d_oo (f, g)$. Constante de lipschitz $M = 1$.
]

#resolucion[
  Dadas $f, g in C[0, 1]$, planteamos
  $
    d_1 (Psi(f), Psi(g)) &= integral_0^1 abs(x f(x) - x g(x)) dif x = integral_0^1 abs(x (f(x) - g(x))) dif x \
    &<= integral_0^1 abs(x) abs(f(x) - g(x)) dif x <= integral_0^1 sup_(x in [0, 1]) abs(f(x) - g(x)) dif x \
    &= d_oo (f, g).
  $
  Entonces $Psi$ es lipschitz (con constante $1$).

  _Nota del manuscrito_: en particular, $Psi$ es uniformemente continua.
]

== Bloque 5 · Lipschitz

#sublema(titulo: "Qué desbloquea")[
  Recordemos que $f : (E, d) -> (E', d')$ es *lipschitz* si existe $M > 0$ tal que $d'(f(x), f(y)) <= M d(x, y)$ para todo $x, y in E$. El *Ejercicio 12* pide probar que $x |-> d(x, x_0)$ y $x |-> d(x, A)$ (Ejercicios 10 y 11) son lipschitz, y deducir que son uniformemente continuas; la clase del 23/10 da el criterio más usado en $RR$ para producirlas (derivada acotada, por el teorema del valor medio: C8-2, con $x^3$ en $(0, 1)$ como ejemplo) y el esquema para *refutarlas*: negar "existe $M$" es exhibir pares $(x_n, y_n)$ con $abs(f(x_n) - f(y_n)) >= M_n abs(x_n - y_n)$ y $M_n -> +oo$ (C8-3, con $x sin(1 \/ x)$ cerca del $0$). Ese mismo juego de sucesiones, con picos de $sin$ cada vez más apretados, es el que necesita el *Ejercicio 13 (b)* para $sin(1 \/ x)$ en $(0, 1)$.

  _Obs. de la clase_: si $f$ es lipschitz entonces es uniformemente continua, pero no vale la vuelta: la función de C8-3 restringida a $[-1, 1]$ es uniformemente continua (consecuencia de un resultado posterior sobre compactos) pero no es lipschitz.
]

#ejemplo[Derivada acotada implica lipschitz (Clase 8 · Ejercicio 2)][C8-2][
  Sea $f : (a, b) -> RR$ derivable, con derivada acotada. Probar que $f$ es lipschitz.
]

#estrategia[Teorema del valor medio][
  Para $x < y$ en $(a, b)$, el teorema del valor medio da $c in (x, y)$ con $f(x) - f(y) = f'(c)(x - y)$; tomando módulo y usando $abs(f'(c)) <= M$ queda la desigualdad de lipschitz con la cota de la derivada como constante.
]

#resolucion[
  Recordemos que por el teorema del valor medio, dados $x < y$, si $f$ es continua en $[x, y]$ y derivable en $(x, y)$, entonces existe $c in (x, y)$ tal que $f(x) - f(y) = f'(c) (x - y)$. Con esto en mente, dados $x, y in (a, b)$ con $x < y$, existe $c in (x, y)$ tal que
  $ abs(f(x) - f(y)) = abs(f'(c)) dot.c abs(x - y). $
  Como $f'$ está acotada (y $c in (x, y) subset.eq (a, b)$), digamos por $M$, se sigue que
  $ abs(f(x) - f(y)) <= M dot.c abs(x - y). $
  Concluimos.

  _Ejemplo de la clase_: si $f : (0, 1) -> RR$, $f(x) = x^3$, por el teorema del valor medio, para $0 < x < y < 1$ existe $c in (x, y)$ tal que
  $ abs(f(x) - f(y)) = abs(f'(c) (x - y)) = 3 c^2 abs(x - y) <= 3 abs(x - y), $
  donde usamos que $c in (0, 1)$, por lo tanto $abs(c) <= 1$.
]

#ejemplo[$x sin(1\/x)$ es continua en $0$ pero no es lipschitz cerca del $0$ (Clase 8 · Ejercicio 3)][C8-3][
  Sea $f : RR -> RR$ dada por
  $
    f(x) = cases(
      x sin(1/x) & " si " x != 0,
      0 & " si " x = 0.
    )
  $
  #set enum(numbering: "a)")
  + Probar que $f$ es continua en $x = 0$.
  + Probar que $f$ no es lipschitz en ningún intervalo que contenga al $0$.

  _Nota_: el manuscrito escribe la segunda rama como "$0$ si $f(0) = 0$"; claramente es "si $x = 0$".
]

#estrategia[Para (a), $abs(x sin(1\/x)) <= abs(x)$; para (b), picos consecutivos de $sin$ en $pi\/2 + 2 pi n$ y $3 pi\/2 + 2 pi n$][
  La continuidad en $0$ es el sándwich $abs(f(x)) <= abs(x)$, así que $delta = epsilon$. Para negar lipschitz hace falta, para cada $M$, un par de puntos con cociente incremental mayor que $M$: se eligen $x_n, y_n$ donde $sin(1 \/ x)$ vale $1$ y $-1$ respectivamente, de modo que $abs(f(x_n) - f(y_n)) = x_n + y_n$, y se compara con $abs(x_n - y_n)$; el cociente resulta $2 + 4 n -> +oo$.
]

#resolucion[
  *a)* Sea $epsilon > 0$. Tenemos que
  $ abs(f(x) - f(0)) = abs(f(x)) = abs(x sin(1/x)) <= abs(x), $
  por lo tanto $abs(f(x)) < epsilon$ si $abs(x) < delta$ con $delta <= epsilon$.

  *b)* Sea $I = (a, b)$ que contiene al $0$. Como ser lipschitz en $I$ significa que _existe $M > 0$ tal que para todo $x, y in I$, $abs(f(x) - f(y)) <= M abs(x - y)$_, no ser lipschitz significa que _para todo $M > 0$ existen $x_M, y_M in I$ tales que $abs(f(x_M) - f(y_M)) > M abs(x_M - y_M)$_. Tomando $M = M_n$ con $M_n -> +oo$, vemos que alcanza con probar que _existen $(x_n)_n, (y_n)_n subset.eq I$ tales que_
  $ abs(f(x_n) - f(y_n)) >= M_n dot.c abs(x_n - y_n). $
  Sean $x_n = 1/(pi/2 + 2 pi n)$, $y_n = 1/((3 pi)/2 + 2 pi n)$; tenemos que $x_n != 0$, $y_n != 0$ para todo $n$. Entonces
  $
    abs(f(x_n) - f(y_n)) &= abs(1/(pi/2 + 2 pi n) sin(pi/2 + 2 pi n) - 1/((3 pi)/2 + 2 pi n) sin((3 pi)/2 + 2 pi n)) \
    &= abs(1/(pi/2 + 2 pi n) + 1/((3 pi)/2 + 2 pi n))
    = abs(((3 pi)/2 + 2 pi n + pi/2 + 2 pi n) / ((pi/2 + 2 pi n) ((3 pi)/2 + 2 pi n))) \
    &= (2 pi + 4 pi n) / ((pi/2 + 2 pi n) ((3 pi)/2 + 2 pi n))
    = (2 pi + 4 pi n) / pi dot.c pi / ((pi/2 + 2 pi n) ((3 pi)/2 + 2 pi n)) \
    &= (2 + 4 n) abs(1/(pi/2 + 2 pi n) - 1/((3 pi)/2 + 2 pi n))
    = (2 + 4 n) dot.c abs(x_n - y_n) = M_n dot.c abs(x_n - y_n),
  $
  y como $M_n -> +oo$, concluimos que $f$ _no es lipschitz_.

  _Nota_: el manuscrito no lo dice, pero para que $(x_n)_n, (y_n)_n subset.eq I$ hay que quedarse con $n$ grande: como $x_n, y_n -> 0$ e $I$ es un intervalo abierto que contiene al $0$, $x_n, y_n in I$ para todo $n >= n_0$, y eso alcanza (dado $M$, se toma $n >= n_0$ con $M_n > M$, y la desigualdad estricta sale porque $x_n != y_n$).
]

== Bloque 6 · Continuidad uniforme: probarla y refutarla

#sublema(titulo: "Qué desbloquea")[
  La clase del 23/10 fija el esquema para *refutar* continuidad uniforme, que es el corazón del *Ejercicio 13* ($1 \/ x$ en $(0, +oo)$, $sin(1 \/ x)$ en $(0, 1)$) y del *Ejercicio 15 (a)*: negar "para todo $epsilon$ existe $delta$" es exhibir $epsilon > 0$ y dos sucesiones $(x_n)_n, (y_n)_n$ con $d(x_n, y_n) -> 0$ pero $d'(f(x_n), f(y_n)) >= epsilon$ para todo $n$. C8-5 lo hace con $x^2$ en $(0, +oo)$ ($x_n = n$, $y_n = n + 1 \/ n$) y prueba, en contraste, que $sin$ es uniformemente continua porque es lipschitz (vía C8-2: es el camino del *Ejercicio 15 (b)*, una función no acotada y uniformemente continua). C8-6 es la cuenta "sumar y restar un término cruzado" para el producto de uniformemente continuas *acotadas*, y el contraejemplo $x sin(x)$ muestra que la acotación no es decorativa. Los *Ejercicios 14 y 16* (una uniformemente continua manda Cauchy en Cauchy y conserva $d(A, B) = 0$) usan la misma observación que todas estas resoluciones: el $delta$ de la continuidad uniforme no depende del punto, así que sirve para pares $(x_n, y_n)$ que se mueven.
]

#ejemplo[$sin$ es uniformemente continua en $RR$; $x^2$ no lo es en $(0, +oo)$ (Clase 8 · Ejercicio 5)][C8-5][
  Decidir si son uniformemente continuas.
  #set enum(numbering: "a)")
  + $f : RR -> RR$, $f(x) = sin(x)$.
  + $f : (0, +oo) -> RR$, $f(x) = x^2$.
]

#estrategia[Para probar, lipschitz; para refutar, dos sucesiones que se acercan pero cuyas imágenes no][
  (a) $abs(sin x - sin y) = abs(cos c) abs(x - y) <= abs(x - y)$ por el valor medio: lipschitz con $M = 1$, luego uniformemente continua. (b) El problema está en el infinito, donde la pendiente de $x^2$ crece: $x_n = n$, $y_n = n + 1 \/ n$ están a distancia $1 \/ n -> 0$ pero $y_n^2 - x_n^2 = 2 + 1 \/ n^2 > 2$.
]

#resolucion[
  *a)* Una forma es viendo que es lipschitz, mediante el teorema del valor medio: dados $x < y$, existe $c in (x, y)$ tal que
  $ f(x) - f(y) = f'(c) (x - y). $
  Entonces
  $ abs(f(x) - f(y)) = abs(sin(x) - sin(y)) = abs(cos(c)) dot.c abs(x - y) <= abs(x - y). $
  Como $f$ es lipschitz, es uniformemente continua.

  *b)* Veamos que _no es uniformemente continua_. Para ello razonamos como para ver que una $f$ no es lipschitz: hay que ver que _existen $epsilon > 0$ y $(x_n)_n, (y_n)_n subset.eq (0, +oo)$ tales que $abs(x_n - y_n) -> 0$ pero_
  $ abs(f(x_n) - f(y_n)) >= epsilon " para todo " n. $
  El problema ocurre cuando $x_n, y_n -> +oo$. Sean $x_n = n$, $y_n = n + 1 \/ n$. Tenemos que $abs(x_n - y_n) = 1 \/ n -> 0$ pero
  $ abs(f(x_n) - f(y_n)) = abs(n^2 - (n + 1/n)^2) = cancel(n^2) + 2 + 1/n^2 - cancel(n^2) > 2. $
  Tomando $epsilon = 2$ vemos que no es uniformemente continua.
]

#ejemplo[Producto de uniformemente continuas acotadas; sin acotación puede fallar (Clase 8 · Ejercicio 6)][C8-6][
  Sean $(X, d)$ un espacio métrico y $f, g : X -> RR$ uniformemente continuas y acotadas. Probar que $f dot.c g$ es uniformemente continua. Mostrar que el producto de funciones uniformemente continuas puede no serlo _incluso si una de ellas está acotada_. [Sugerencia: $f(x) = x sin(x)$.]
]

#estrategia[Sumar y restar $f(y) g(x)$, y acotar cada factor que sobra][
  $abs(f(x) g(x) - f(y) g(y)) <= abs(g(x)) abs(f(x) - f(y)) + abs(f(y)) abs(g(x) - g(y))$: las cotas $M_1, M_2$ controlan los factores $abs(g(x))$, $abs(f(y))$ y los $delta$ de $f$ y $g$ controlan los incrementos. Sin acotación, $x sin(x) = x dot.c sin(x)$ (producto de $op("id")$ y $sin$, ambas uniformemente continuas, la segunda acotada) falla: en $x_n = pi + 2 pi n$ vale $0$ y en $y_n = x_n + 1 \/ n$ vale cerca de $2 pi$.
]

#resolucion[
  Sea $epsilon > 0$. Queremos ver que existe $delta > 0$ tal que $d(x, y) < delta$ implica que
  $ abs(f(x) dot.c g(x) - f(y) dot.c g(y)) < epsilon. $
  Como $f, g$ son uniformemente continuas, existen $delta_1 > 0$, $delta_2 > 0$ tales que
  $
    d(x, y) < delta_1 &==> abs(f(x) - f(y)) < epsilon', \
    d(x, y) < delta_2 &==> abs(g(x) - g(y)) < epsilon',
  $
  donde $epsilon' > 0$ lo elegiremos después. Entonces
  $
    abs(f(x) g(x) - f(y) g(y)) &<= abs(f(x) g(x) - f(y) g(x)) + abs(f(y) g(x) - f(y) g(y)) \
    &= abs(g(x)) abs(f(x) - f(y)) + abs(f(y)) abs(g(x) - g(y)). quad (*)
  $
  Como $f, g$ son acotadas, existen $M_1 > 0$, $M_2 > 0$ tales que $abs(g(x)) <= M_1$ para todo $x in X$ y $abs(f(x)) <= M_2$ para todo $x in X$. Entonces en $(*)$ acotamos
  $ abs(f(x) g(x) - f(y) g(y)) <= M_1 dot.c epsilon' + M_2 dot.c epsilon' = (M_1 + M_2) dot.c epsilon' $
  si $d(x, y) < op("mín"){delta_1, delta_2}$. Tomando $epsilon' < epsilon \/ (M_1 + M_2)$, concluimos.

  Veamos que la hipótesis de acotadas es necesaria. Sea $f : RR -> RR$, $f(x) = x sin(x)$. Sean $x_n = pi + 2 pi n$, $y_n = pi + 2 pi n + 1 \/ n$. Se tiene que $abs(x_n - y_n) = 1 \/ n -> 0$, pero
  $
    abs(f(x_n) - f(y_n)) &= abs((pi + 2 pi n) underbrace(sin(pi + 2 pi n), = 0) - (pi + 2 pi n + 1/n) sin(pi + 2 pi n + 1/n)) \
    &= abs((pi + 2 pi n + 1/n) sin((pi + 2 pi n) + 1/n)) \
    &= abs((pi + 2 pi n + 1/n) [underbrace(sin(pi + 2 pi n), = 0) dot.c cos(1/n) + underbrace(cos(pi + 2 pi n), = -1) dot.c sin(1/n)]) \
    &= underbrace(pi sin(1/n), -> 0) + underbrace(2 pi n sin(1/n), (star)) + underbrace(1/n sin(1/n), -> 0).
  $
  $(star)$ Como $2 pi n sin(1 \/ n) = 2 pi sin(1 \/ n) \/ (1 \/ n) -> 2 pi$, tenemos que $abs(f(x_n) - f(y_n)) -> 2 pi$, y en consecuencia existe $epsilon > 0$ tal que $abs(f(x_n) - f(y_n)) >= epsilon$ para todo $n$ suficientemente grande.
]

== Bloque 7 · Pegado de dominios

#sublema(titulo: "Qué desbloquea")[
  Los dos últimos ejercicios de la clase del 23/10 responden a la pregunta "si $f$ es uniformemente continua en cada pedazo del dominio, ¿lo es en todo?". Con dos pedazos que comparten el punto $a$, sí: en $[0, a]$ y en $[a, +oo)$ (C8-7), haciendo pasar por $f(a)$ a los pares $x <= a <= y$. Con dos pedazos a distancia positiva, también (C8-8): un $delta < d(A, B)$ impide que un par cercano tenga un punto en cada lado. Es la herramienta para el *Ejercicio 13 (a)* ($1 \/ x$ sí es uniformemente continua en $[epsilon, +oo)$, por derivada acotada, y la pregunta es qué se rompe al acercarse al $0$) y para construir el ejemplo del *Ejercicio 15 (b)* por tramos. C8-8 usa además que $d(A, B) > 0$ implica $overline(A) inter overline(B) = emptyset$, el contrarrecíproco de "$overline(A) inter overline(B) != emptyset => d(A, B) = 0$", y es el telón de fondo del *Ejercicio 16*: lo que una uniformemente continua no puede hacer es separar dos conjuntos que están a distancia cero.
]

#ejemplo[Uniformemente continua en $[0, a]$ y en $[a, +oo)$ implica en $[0, +oo)$ (Clase 8 · Ejercicio 7)][C8-7][
  Sea $f : [0, +oo) -> RR$. Supongamos que existe $a > 0$ tal que $f|_([0, a])$ y $f|_([a, +oo))$ son uniformemente continuas. Probar que $f$ es uniformemente continua.
]

#estrategia[El caso mixto $x <= a <= y$ pasa por $f(a)$][
  Si $x, y$ caen en el mismo tramo, sirve el $delta$ de ese tramo. Si $x < a < y$ y $abs(x - y) < delta <= op("mín"){delta_1, delta_2}$, entonces $x$ e $y$ están ambos a distancia $< delta$ de $a$ (porque $a$ está entre ellos), así que $abs(f(x) - f(a))$ y $abs(f(y) - f(a))$ son chicos y se suma con la triangular.
]

#resolucion[
  Sea $epsilon > 0$. Queremos ver que existe $delta > 0$ tal que $abs(x - y) < delta$ implica que $abs(f(x) - f(y)) < epsilon$.

  - Si $x, y in [0, a]$, existe $delta_1 > 0$ tal que $abs(x - y) < delta_1$ implica que $abs(f(x) - f(y)) < epsilon'$.
  - Si $x, y in [a, +oo)$, existe $delta_2 > 0$ tal que $abs(x - y) < delta_2$ implica que $abs(f(x) - f(y)) < epsilon'$.
  - Sea $x in [0, a]$, $y in [a, +oo)$:

  #recta([$0$], [$x$], ([$a$], "arriba"), [$y$])

  (En el dibujo, $x$ está a distancia $< delta_1$ de $a$ e $y$ a distancia $< delta_2$.)

  La idea es que si $x$ e $y$ están muy cerca, estarán cerca de $a$: si $abs(x - a) < delta_1$ entonces $abs(f(x) - f(a)) < epsilon'$, y similarmente si $abs(y - a) < delta_2$ entonces $abs(f(y) - f(a)) < epsilon'$, por lo tanto $f(x)$ y $f(y)$ estarán muy cerca entre sí. Formalmente, sea $delta < op("mín"){delta_1, delta_2}$ y supongamos que $abs(x - y) < delta$. Como $x <= a <= y$, tenemos que
  $
    abs(x - a) &= a - x <= y - x = abs(y - x) < delta < delta_1, " entonces " abs(f(x) - f(a)) < epsilon', quad (1) \
    abs(y - a) &= y - a <= y - x = abs(y - x) < delta < delta_2, " entonces " abs(f(y) - f(a)) < epsilon'. quad (2)
  $
  Por lo tanto
  $ abs(f(x) - f(y)) <= underbrace(abs(f(x) - f(a)), < epsilon' "por" (1)) + underbrace(abs(f(a) - f(y)), < epsilon' "por" (2)) < 2 epsilon'. $
  Tomando $epsilon' <= epsilon \/ 2$, concluimos.

  _Nota_: el manuscrito cierra con "tomando $epsilon' < 2 epsilon$"; lo que hace falta es $2 epsilon' <= epsilon$, o sea $epsilon' <= epsilon \/ 2$ (con $epsilon' < 2 epsilon$ sólo se obtiene $abs(f(x) - f(y)) < 4 epsilon$).
]

#ejemplo[Uniformemente continua en $A$ y en $B$ con $d(A, B) > 0$ implica en $A union B$ (Clase 8 · Ejercicio 8)][C8-8][
  Sean $(X, d)$, $(Y, d')$ espacios métricos y $f : X -> Y$. Supongamos que $X = A union B$, con $A, B$ tales que $d(A, B) > 0$. Si $f|_A$ y $f|_B$ son uniformemente continuas, entonces $f$ es uniformemente continua.
]

#estrategia[Un $delta$ menor que $d(A, B)$ no deja pares mixtos][
  Si $x in A$, $y in B$, entonces $d(x, y) >= d(A, B)$; así que con $delta < op("mín"){delta_A, delta_B, d(A, B)}$, todo par con $d(x, y) < delta$ cae dentro de $A$ o dentro de $B$, y ahí manda el $delta$ del tramo correspondiente. Comparar con C8-7, donde los tramos se tocan y el caso mixto hay que tratarlo.
]

#resolucion[
  Sea $epsilon > 0$. Como $f|_A$ y $f|_B$ son uniformemente continuas, existen $delta_A > 0$, $delta_B > 0$ tales que

  - si $x, y in A$ y $d(x, y) < delta_A$ entonces $d'(f(x), f(y)) < epsilon'$;
  - si $x, y in B$ y $d(x, y) < delta_B$ entonces $d'(f(x), f(y)) < epsilon'$.

  (Dibujo de la clase: sobre una recta, dos intervalos $A$ y $B$ separados por una brecha de longitud $d(A, B)$; $x in A$, $y in B$, y se marca que $d(x, y) >= d(A, B)$.)

  Notemos que si $d(A, B) > 0$ entonces $overline(A) inter overline(B) = emptyset$ (es el contrarrecíproco del "ejercicio 11 c)" que cita la clase, de la práctica de espacios métricos: $overline(A) inter overline(B) != emptyset => d(A, B) = 0$).

  La idea es que si tomamos $delta > 0$ muy pequeño, no puede pasar que $d(x, y) < delta$ con $x in A$, $y in B$. Si tomamos $delta < op("mín"){delta_A, delta_B, d(A, B)}$ y $x in A$, $y in B$ con $d(x, y) < delta$, entonces
  $ d(A, B) <= d(x, y) < delta < d(A, B), $
  absurdo. Por lo tanto $d(x, y) < delta$ implica que $x, y in A$ o bien $x, y in B$.

  - Si $x, y in A$, como $d(x, y) < delta < delta_A$, tenemos que $d'(f(x), f(y)) < epsilon'$.
  - Si $x, y in B$, como $d(x, y) < delta < delta_B$, tenemos que $d'(f(x), f(y)) < epsilon'$.

  Tomando $epsilon' < epsilon$ concluimos.
]
