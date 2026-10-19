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
    Funciones continuas
  ]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

Los ejemplos están agrupados por *técnica*, no por orden de transcripción, y los bloques siguen el orden en que la guía los necesita. Cada bloque abre con la nota de qué ejercicios de `guias/p4.typ` desbloquea.

La pestaña dice de dónde viene cada ejemplo: un *número* es el ejemplo de `notas_materia.pdf` (con su numeración por capítulo entre paréntesis en el título), *`C{clase}-{ejemplo}`* es un ejercicio resuelto en clase, transcrito en `clases/` (un archivo por tema; la tabla clase $arrow$ archivo está en la skill `ejemplo`) y *`A{sección}`* es un resultado o ejercicio de Abbott, _Understanding Analysis_.

#v(6pt)

#show table.cell.where(y: 0): set text(fill: white, weight: "bold", size: 8.5pt)

#table(
  columns: (0.35fr, 2.4fr, 1.1fr),
  align: (center + horizon, left + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#065f46") } else if calc.even(y) { rgb("#f8fafc") } else { white },
  stroke: 0.4pt + rgb("#cbd5e1"),
  inset: (x: 6pt, y: 4pt),

  [*\#*], [*Bloque*], [*Desbloquea*],
  [1], [Imagen y preimagen de conjuntos], [conceptual para p4],
  [2], [Continuidad por definición ($epsilon$--$delta$)], [p4: Ej. 1],
  [3], [Continuidad por sucesiones y por preimágenes de abiertos], [p4: Ej. 4, 5],
)

#v(8pt)

== Bloque 1 · Imagen y preimagen de conjuntos

#sublema(titulo: "Qué desbloquea")[
  Calcular imágenes y preimágenes de conjuntos concretos (Definición 5.1). Es el vocabulario de base para la caracterización de continuidad por preimágenes de abiertos y cerrados que usa la Práctica 4.
]

#ejemplo[Imagen y preimagen por $f(n) = n^2$ (Ejemplo 5.2)][33][
  Sea $f : ZZ -> NN$ la función $f(n) = n^2$. Entonces, si $A = {1, 3, 4}$ y $B = {1, 3, 4}$,
  $
         f(A) & = {1, 9, 16} subset.eq NN quad "y" \
    f^(-1)(B) & = {1, -1, 2, -2} subset.eq ZZ.
  $
]

#observacion[Los elementos de $B$ fuera de la imagen no aportan a la preimagen][
  $3 in.not op("img")(f)$ porque no hay ningún $n in ZZ$ con $n^2 = 3$, así que el $3$ no aporta nada a la preimagen:
  $ 3 in.not op("img")(f) ==> f^(-1)(B) = f^(-1)(B without {3}). $
  En general, como $B subset.eq N$ no tiene por qué estar contenido en la imagen,
  $ f^(-1)(B) = f^(-1)(B inter op("img")(f)). $
]

== Bloque 2 · Continuidad por definición ($epsilon$--$delta$)

#sublema(titulo: "Qué desbloquea")[
  Leer la Definición 5.4 en casos concretos: ver que en $RR$ y en $RR^n$ recupera la continuidad de Análisis 1, y que en un punto aislado cualquier función es continua (alcanza con tomar $delta$ igual al radio que aísla al punto). Es el modelo para decidir continuidad en el *Ejercicio 1* de la Práctica 4.
]

#ejemplo[Continuidad en $RR$, en puntos aislados, en $NN$ y en $RR^n$ (Ejemplo 5.5)][34][
  #set enum(numbering: "a)")
  + Sea $f : (RR, abs(dot)) -> (RR, abs(dot))$. Entonces $f$ es continua en un punto $x$ si para todo $epsilon > 0$ existe $delta > 0$ tal que si $abs(x - y) < delta$ entonces $abs(f(x) - f(y)) < epsilon$. En este caso, recuperamos la definición de continuidad que ya conocemos.

  + Sea $f : (M, d) -> (N, d')$ y sea $x in M$ un punto aislado, es decir, $x$ es un punto tal que existe un $r > 0$ tal que $B(x, r) = {x}$. Entonces $f$ es continua en $x$: dado $epsilon > 0$, podemos tomar $delta = r$ (el de la definición de punto aislado) y tenemos que
    $ f(B(x, r)) = f({x}) = {f(x)} subset.eq B(f(x), epsilon). $

  + Sea $f : (NN, abs(dot)) -> (M, d)$ una función que llega a un espacio métrico cualquiera. Entonces $f$ es continua en $n$ para todo $n in NN$, dado que en $(NN, abs(dot))$ todos los puntos son aislados.

  + Sea $f : (RR^n, d_2) -> (RR, abs(dot))$. Entonces $f$ es continua en un punto $x$ si para todo $epsilon > 0$ existe un $delta > 0$ tal que si $d_2(x, y) < delta$ entonces $abs(f(x) - f(y)) < epsilon$. Recordando la notación que usamos en otras materias, esto es lo mismo que decir que
    $ norm(x - y) < delta => abs(f(x) - f(y)) < epsilon. $
    Es decir, recuperamos la definición de función continua que vimos en Análisis 1.
]

#observacion[En un punto aislado, el único $y$ cercano a $x$ es el propio $x$][
  El ítem b) escrito con bolas es la misma condición $epsilon$--$delta$: $f(B(x, delta)) subset.eq B(f(x), epsilon)$ dice que para todo $y$ con $d(x, y) < delta$ vale $d'(f(x), f(y)) < epsilon$. Con $delta = r$, si $d(x, y) < r$ entonces $y in B(x, r) = {x}$, es decir, $y = x$. Luego
  $ d'(f(x), f(y)) = d'(f(x), f(x)) = 0 < epsilon. $
  La condición "para todo $y$ cercano a $x$" se cumple porque el único $y$ que hay que revisar es el propio $x$, y toda bola contiene a su centro. Por eso en un espacio discreto (donde todos los puntos son aislados) *toda* función es continua.
]

== Bloque 3 · Continuidad por sucesiones y por preimágenes de abiertos

#sublema(titulo: "Qué desbloquea")[
  Usar las caracterizaciones de continuidad en vez de la definición: el Teorema 5.7 (sucesiones) para probar que una función es continua, y el Teorema 5.9 (preimágenes de abiertos) para probar que un conjunto es abierto escribiéndolo como preimagen de un abierto por una función continua. Es el modelo de los *Ejercicios 4 y 5* de la Práctica 4.
]

#ejemplo[Continuidad del determinante y $G l_2(RR)$ abierto (Ejemplo 5.11)][36][
  Sea
  $ M_2(RR) = {mat(a, b; c, d) : a, b, c, d in RR}, $
  el conjunto de las matrices de $2 times 2$ con coeficientes reales. En este conjunto tomamos la distancia infinito
  $ d_oo (A, B) = max_(1 <= i, j <= 2) abs(a_(i j) - b_(i j)). $
  Como ejercicio, ver que $(M_2(RR), d_oo)$ es un espacio métrico.

  En este espacio, consideremos la función determinante $det : (M_2(RR), d_oo) -> (RR, abs(dot))$ y veamos que es una función continua. Consideremos en este espacio el subconjunto de las matrices que son inversibles,
  $ G l_2(RR) = {A in M_2(RR) : A "es una matriz inversible"}, $
  y veamos que este conjunto es abierto.
]

#resolucion[
  *El determinante es continuo.* Supongamos que $(A_n)_(n in NN)$ es una sucesión de matrices que convergen a la matriz $A$. Entonces, si
  $ A_n = mat(a_n, b_n; c_n, d_n), quad A = mat(a, b; c, d), $
  sabemos que $A_n -> A$ en $d_oo$ si y sólo si $a_n -> a$, $b_n -> b$, $c_n -> c$ y $d_n -> d$ en $RR$ (probarlo como ejercicio).

  Para ver que el determinante es continua, por el Teorema 5.7, nos alcanza con ver que $det(A_n) -> det(A)$. Pero
  $ det(A_n) = a_n d_n - b_n c_n -> a d - b c = det(A), $
  lo que nos dice que la función es continua.

  *$G l_2(RR)$ es abierto.* Por el Teorema 5.9, nos alcanza con ver que este conjunto es la preimagen de un conjunto abierto via una función continua. De álgebra lineal, sabemos que una matriz es inversible si y sólo si su determinante es distinto de cero. Esto es lo mismo que decir que
  $ G l_2(RR) & = {A in M_2(RR) : det(A) != 0} = scripts(det)^(-1)(RR without {0}) \
              & = scripts(det)^(-1)((-oo, 0) union (0, +oo)), $
  y como $(-oo, 0) union (0, +oo) subset.eq RR$ es un conjunto abierto (por ejemplo, lo podríamos escribir como una unión de intervalos abiertos), nos sale que $G l_2(RR)$ es también un conjunto abierto.

  Como ejercicio, intentá probar que $G l_2(RR)$ es un conjunto abierto usando solo la definición: no es imposible, pero es mucho más difícil que lo que acabamos de hacer.
]
