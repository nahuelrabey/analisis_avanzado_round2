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
  [4], [Continuidad en productos y proyecciones], [p4: Ej. 1 (a), 4, 5],
  [5], [Funciones Lipschitz], [p4: Ej. 9, 12],
  [6], [Continuidad uniforme: ejemplos, contraejemplos y pegado], [p4: Ej. 13, 14, 15, 16],
  [7], [Conjuntos densos], [p4: Ej. 7, 8],
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

== Bloque 4 · Continuidad en productos y proyecciones

#sublema(titulo: "Qué desbloquea")[
  Trabajar en $X times Y$ con $d_infinity ((x, y), (x', y')) = max{d_1 (x, x'), d_2 (y, y')}$: las proyecciones $pi_1, pi_2$ son continuas y abiertas (pero no cerradas), una función a valores en el producto es continua si y sólo si lo son sus dos coordenadas, y una sucesión converge en $X times Y$ si y sólo si converge coordenada a coordenada. Es lo que está detrás del *Ejercicio 1 (a)* (una función de dos variables se evalúa en sucesiones $(x_n, y_n)$ que convergen coordenada a coordenada), del *Ejercicio 4* (la función $x |-> (f(x), g(x))$ es continua a valores en $E' times E'$) y del *Ejercicio 5* (las coordenadas $x, y, z$ de $RR^n$ son proyecciones continuas, y con ellas se arman las funciones cuya preimagen es el conjunto).
]

#definicion[Función abierta y función cerrada][
  Sea $f : (M, d) -> (N, d')$ una función. Decimos que
  - $f$ es *abierta* si para todo $U subset.eq M$ abierto, $f(U)$ es abierto en $N$;
  - $f$ es *cerrada* si para todo $F subset.eq M$ cerrado, $f(F)$ es cerrado en $N$.

  Es una propiedad de la función, no de su imagen: $f(M)$ es abierto en $f(M)$ siempre, lo que importa es que *cada* abierto del dominio vaya a parar a un abierto. Comparar con la continuidad (Teorema 5.9), que pide lo mismo pero con *preimágenes*. A diferencia de lo que pasa con preimágenes, pasando a complementos no se obtiene la equivalencia entre "abierta" y "cerrada", porque en general $f(M without A) != N without f(A)$; por eso son dos propiedades distintas, como muestra el ejemplo siguiente. Que una función continua no tiene por qué ser abierta ni cerrada es la Observación 5.12 ($x^2$ y $e^x$).

  _Nota_: esta definición no figura en `notas_materia.pdf` ni en el manuscrito de la clase, que la usa sin enunciarla; la agregó el agente.
]

#ejemplo[Proyecciones de $X times Y$ y continuidad coordenada a coordenada (Clase 6 · Ejemplo 1)][C6-1][
  Sean $(X, d_1)$ e $(Y, d_2)$ espacios métricos. Pensamos a $X times Y$ con $d_infinity$.

  #set enum(numbering: "a)")
  + Probar que $pi_1 : X times Y -> X$, $(x, y) |-> x$, y $pi_2 : X times Y -> Y$, $(x, y) |-> y$ son continuas y abiertas, pero pueden *no ser cerradas*.
  + Sea $(Z, delta)$ un espacio métrico y sea $f : Z -> X times Y$ una aplicación. Probar que $f$ es continua si y sólo si $f_1 = pi_1 compose f$ y $f_2 = pi_2 compose f$ lo son.
]

#resolucion[
  *a)* Probemos que $pi_1$ es continua y abierta. A lo largo de la resolución, los puntos de $X times Y$ se llaman $p, q$, y sus coordenadas $p = (x_p, y_p)$, $q = (x_q, y_q)$.

  Para ver que $pi_1$ es continua, dado $p in X times Y$, podemos ver que dado $epsilon > 0$, existe $delta > 0$ tal que si $d_infinity (q, p) < delta$ entonces
  $
  d_1 (pi_1 (q), pi_1 (p)) = d_1 (x_q, x_p) < epsilon.
  $
  Como
  $
  d_1 (x_q, x_p) <= max{d_1 (x_q, x_p), d_2 (y_q, y_p)} = d_infinity (q, p), quad (*)
  $
  si $delta < epsilon$ garantizamos $(*)$.

  Para ver que $pi_1$ es abierta, tenemos que ver que *para todo abierto $U subset.eq X times Y$, $pi_1 (U)$ es abierto*. Lo hacemos en dos pasos: primero para bolas y después para abiertos cualesquiera.

  *Paso 1: la proyección de una bola es una bola.* Sea $p in X times Y$ y $r > 0$. Veamos que $pi_1 (B(p, r)) = B(x_p, r)$; en particular, $pi_1 (B(p, r))$ es abierto. Por un lado,
  $
  B(p, r) &= {q in X times Y : d_infinity (q, p) < r} \
          &= {q in X times Y : max{d_1 (x_q, x_p), d_2 (y_q, y_p)} < r} \
          &= {q in X times Y : d_1 (x_q, x_p) < r " y " d_2 (y_q, y_p) < r}.
  $
  Por otro lado,
  $
  pi_1 (B(p, r)) = {x in X : "existe " y in Y " con " d_1 (x, x_p) < r " y " d_2 (y, y_p) < r}.
  $
  #block(breakable: false, width: 100%)[#align(center)[
    #cetz.canvas({
      import cetz.draw: *
      let (x0, y0, r) = (3.0, 3.0, 1.3)
      let azul = rgb("#1e3a8a")
      let verde = rgb("#059669")

      // Ejes.
      line((-0.3, 0), (6.4, 0), mark: (end: ">"), stroke: 0.8pt)
      line((0, -0.3), (0, 4.9), mark: (end: ">"), stroke: 0.8pt)
      content((6.4, -0.1), anchor: "north", text(size: 9pt, $X$))
      content((-0.1, 4.9), anchor: "east", text(size: 9pt, $Y$))

      // Bola de d_infinity: el cuadrado (x_p - r, x_p + r) × (y_p - r, y_p + r).
      rect(
        (x0 - r, y0 - r), (x0 + r, y0 + r),
        fill: azul.lighten(88%), stroke: (paint: azul, thickness: 1pt, dash: "dashed"),
      )
      content((x0 + r + 0.15, y0 + r), anchor: "north-west", text(size: 9pt, fill: azul, $B = B(p, r)$))
      circle((x0, y0), radius: 0.05, fill: black, stroke: none)
      content((x0, y0 + 0.12), anchor: "south", text(size: 9pt, $p = (x_p, y_p)$))
      line((x0, y0), (x0 + r, y0), stroke: 0.5pt + azul)
      content((x0 + r / 2, y0 - 0.08), anchor: "north", text(size: 9pt, $r$))

      // Proyección sobre el eje x: el intervalo abierto (x_p - r, x_p + r).
      for x in (x0 - r, x0 + r) {
        line((x, y0 - r), (x, 0), stroke: (paint: gray, thickness: 0.4pt, dash: "dotted"))
      }
      line((x0 - r, 0), (x0 + r, 0), stroke: 2.2pt + verde)
      for x in (x0 - r, x0 + r) {
        circle((x, 0), radius: 0.07, fill: white, stroke: 0.9pt + verde)
      }
      line((x0, -0.1), (x0, 0.1), stroke: 0.8pt)
      content((x0 - r, -0.15), anchor: "north", text(size: 9pt, $x_p - r$))
      content((x0, -0.15), anchor: "north", text(size: 9pt, $x_p$))
      content((x0 + r, -0.15), anchor: "north", text(size: 9pt, $x_p + r$))
      content((x0, 0.2), anchor: "south", text(size: 9pt, fill: verde, $pi_1 (B) = B(x_p, r)$))
      // Flecha de proyección.
      line((x0 - r / 2, y0 - r - 0.1), (x0 - r / 2, 0.75), mark: (end: ">"), stroke: 0.6pt + verde)
      content((x0 - r / 2 - 0.1, (y0 - r) / 2 + 0.35), anchor: "east", text(size: 9pt, fill: verde, $pi_1$))
    })
  ]]

  _Nota_: el manuscrito dibuja un disco de centro $p$ y radio $r$ y, sobre el eje $x$, su proyección: un intervalo de centro $x_p$ y del "mismo radio". Con $d_infinity$ la bola de $RR^2$ es en realidad el cuadrado $(x_p - r, x_p + r) times (y_p - r, y_p + r)$, que es lo que se dibuja acá; el disco es la bola euclídea. Las dos tienen la misma proyección.

  Las dos contenciones salen de la descripción de $pi_1 (B(p, r))$:

  ($subset.eq$) Todo $x in pi_1 (B(p, r))$ cumple $d_1 (x, x_p) < r$, es decir, $x in B(x_p, r)$.

  ($supset.eq$) Dado $x in B(x_p, r)$, tenemos $d_1 (x, x_p) < r$, y $y = y_p$ cumple $d_2 (y_p, y_p) = 0 < r$. Entonces $q = (x, y_p) in B(p, r)$ y $x = pi_1 (q) in pi_1 (B(p, r))$.

  *Paso 2: de bolas a abiertos.* Sea $U subset.eq X times Y$ abierto. Para todo $p in U$ existe $r_p > 0$ tal que $B(p, r_p) subset.eq U$. Entonces $U = union.big_(p in U) B(p, r_p)$, por lo tanto
  $
  pi_1 (U) = pi_1 (union.big_(p in U) B(p, r_p)) = union.big_(p in U) pi_1 (B(p, r_p)) = union.big_(p in U) B(x_p, r_p),
  $
  donde la última igualdad es el Paso 1. Es unión de abiertos, por lo tanto $pi_1 (U)$ es abierto.

  _Nota_: el manuscrito presenta primero el Paso 2, como reducción ("si probamos que para toda bola $B(x, r)$, $pi_1 (B(x, r))$ es abierto, entonces se sigue la misma conclusión para todo abierto $U$"), y después el Paso 1; acá se reordenó. Además escribe los puntos de $X times Y$ como $x$, $(x, y)$ o $(x_0, y_0)$ según el lugar; acá se unificó a $p$, $q$ con coordenadas $(x_p, y_p)$, $(x_q, y_q)$. Por último, sólo prueba la contención $supset.eq$ (verificando $q in B(p, r)$ con la cuenta $d_infinity (p, q) = max{d_1 (x_p, x), d_2 (y_p, y_p)} = d_1 (x_p, x) < r$). Sola no alcanza para el Paso 1: dice que $x_p$ es punto interior de $pi_1 (B(p, r))$, pero no que lo sean todos sus puntos. Con la igualdad, en cambio, la proyección es una bola y por lo tanto es abierta.

  Veamos que en general $pi_1$ *no es cerrada, es decir, existe $F subset.eq X times Y$ cerrado con $pi_1 (F)$ no cerrado*.

  _Idea_: sea $F subset.eq X times Y$ cerrado, y consideramos $pi_1 (F)$. Si $(x_n)_n subset.eq pi_1 (F)$ cumple que $x_n -> x$, querríamos ver que $x in pi_1 (F)$, es decir, existe $q in F$ con $x_q = x$. Como $x_n in pi_1 (F)$, existe $q_n in F$ con $x_(q_n) = x_n$. *Lo ideal sería que $q_n -> q$ para algún $q$*, porque en tal caso, al ser $F$ cerrado, $q in F$, y como la primera coordenada converge, $x_q = lim x_n = x$; entonces $x in pi_1 (F)$. El problema es que *las segundas coordenadas $(y_(q_n))_n$ no tienen por qué converger, o tener subsucesiones convergentes*.

  _Ej_: si $X = Y = RR$, en $RR^2$ con $d_infinity$, sea $F = {q in RR^2 : x_q y_q = 1}$. Es cerrado porque es la preimagen de ${1}$ vía $f(q) = x_q y_q$, o sea: $F = f^(-1)({1})$. Como $f$ es continua, $F$ es cerrado. Pero
  $
  pi_1 (F) = {x in RR : "existe " y in RR " con " x y = 1} = RR without {0},
  $
  que no es cerrado. _(Dibujo: la hipérbola $x y = 1$ y su proyección sobre el eje $x$, que cubre toda la recta salvo el $0$.)_

  Las afirmaciones para $pi_2$ se prueban de manera análoga.

  *b)* Notemos que si $f$ es continua, por el ítem a), $pi_1$ y $pi_2$ son continuas, y en consecuencia $f_1 = pi_1 compose f$ y $f_2 = pi_2 compose f$ son continuas por ser composición de continuas.

  Usemos sucesiones. Tenemos que $f$ es continua en $z_0 in Z$ si y sólo si para toda $(z_n)_n subset.eq Z$ con $z_n -> z_0$ se tiene que $f(z_n) -> f(z_0)$. Notemos que
  $
  f : Z -> X times Y, quad f(z) = (f_1 (z), f_2 (z)),
  $
  porque $f_1 = pi_1 compose f$ y $f_2 = pi_2 compose f$. Sea $(z_n)_n subset.eq Z$ con $z_n -> z_0$. Como $f_1$ y $f_2$ son continuas en $z_0$, $f_1 (z_n) -> f_1 (z_0)$ y $f_2 (z_n) -> f_2 (z_0)$. Sea $epsilon > 0$. Sabemos que existen $n_1, n_2 in NN$ tales que
  $
  d_1 (f_1 (z_0), f_1 (z_n)) &< epsilon " para todo " n >= n_1, \
  d_2 (f_2 (z_0), f_2 (z_n)) &< epsilon " para todo " n >= n_2.
  $
  Entonces, para todo $n >= n_0 = max{n_1, n_2}$,
  $
  d_infinity (f(z_0), f(z_n)) = max{d_1 (f_1 (z_0), f_1 (z_n)), d_2 (f_2 (z_0), f_2 (z_n))} < epsilon.
  $
  Concluimos que $f(z_n) -> f(z_0)$. #align(right)[$square$]
]

#observacion[Convergencia en $X times Y$ es convergencia coordenada a coordenada][
  De 1 b) sale que en $X times Y$ con $d_infinity$, la sucesión $(x_n, y_n) -> (x, y)$ si y sólo si $x_n -> x$ e $y_n -> y$, tomando $f : X times Y -> X times Y$, $f(x, y) = op("id")_(X times Y) (x, y) = (x, y)$, es decir $f_1 (x, y) = x$, $f_2 (x, y) = y$ (observación del docente). Lo que realmente se usa es el *argumento* de la demostración de b): dado $(x_n, y_n) -> (x, y)$, la desigualdad $d_1 (x_n, x) <= d_infinity ((x_n, y_n), (x, y))$ da $x_n -> x$, y recíprocamente el $max$ de dos cantidades que tienden a $0$ tiende a $0$.
]

== Bloque 5 · Funciones Lipschitz

#sublema(titulo: "Qué desbloquea")[
  Recordar que $f : (E, d) -> (E', d')$ es *Lipschitz* si existe $M > 0$ tal que $d'(f(x), f(y)) <= M d(x, y)$ para todo $x, y in E$, y que Lipschitz implica uniformemente continua (la vuelta es falsa: $x sin(1 \/ x)$ en $[-1, 1]$). Las herramientas son el teorema del valor medio (derivada acotada $==>$ Lipschitz), la negación cuantificada de "Lipschitz" para construir contraejemplos con sucesiones, y la acotación de integrales por el supremo para operadores en $C([0, 1])$. Es el modelo del *Ejercicio 12* (probar que $d(x, x_0)$ y $d(x, A)$ son Lipschitz) y ayuda en el *Ejercicio 9* (funcionales de $C([0, 1])$ con $d_infinity$ y $d_1$).
]

#ejemplo[Derivada acotada implica Lipschitz (Clase 6 · Ejemplo 2)][C6-2][
  Sea $f : (a, b) -> RR$ derivable, con derivada acotada. Probar que $f$ es Lipschitz.
]

#resolucion[
  Recordemos que por el teorema del valor medio, dados $x < y$, si $f$ es continua en $[x, y]$ y derivable en $(x, y)$, entonces existe $c in (x, y)$ tal que
  $
  f(x) - f(y) = f'(c)(x - y).
  $
  Con esto en mente, dados $x, y in (a, b)$, con $x < y$, existe $c in (x, y)$ tal que
  $
  abs(f(x) - f(y)) = abs(f'(c)) dot abs(x - y).
  $
  Como $f'(c)$ está acotada (pues $c in (x, y) subset.eq (a, b)$), digamos por $M$, se sigue que
  $
  abs(f(x) - f(y)) <= M abs(x - y).
  $
  Concluimos. #align(right)[$square$]

  _Ej_: si $f : (0, 1) -> RR$, $f(x) = x^3$, por el teorema del valor medio, para $0 < x < y < 1$, existe $c in (x, y)$ tal que
  $
  abs(f(x) - f(y)) = abs(f'(c)(x - y)) = 3 c^2 abs(x - y) <= 3 abs(x - y),
  $
  donde usamos que $c in (0, 1)$, por lo tanto $abs(c) <= 1$.
]

#ejemplo[$x sin(1 \/ x)$ es continua en $0$ pero no es Lipschitz cerca de $0$ (Clase 6 · Ejemplo 3)][C6-3][
  Sea $f : RR -> RR$ dada por
  $
  f(x) = cases(
    x sin(1 / x) & " si " x != 0,
    0 & " si " x = 0.
  )
  $
  #set enum(numbering: "a)")
  + Probar que $f$ es continua en $x = 0$.
  + Probar que $f$ no es Lipschitz en ningún intervalo que contenga al $0$.

  _Nota_: el manuscrito escribe "$0$ si $f(0) = 0$" en la segunda rama; es "$0$ si $x = 0$".
]

#resolucion[
  *a)* Sea $epsilon > 0$. Tenemos que
  $
  abs(f(x) - f(0)) = abs(f(x)) = abs(x sin(1 / x)) <= abs(x),
  $
  por lo tanto $abs(f(x)) < epsilon$ si $abs(x) < delta$ con $delta <= epsilon$.

  *b)* Sea $I = (a, b)$ que contiene al $0$. Como ser Lipschitz en $I$ significa que *existe $M > 0$ tal que para todo $x in I$, $y in I$, $abs(f(x) - f(y)) <= M abs(x - y)$*, no ser Lipschitz significa que *para todo $M > 0$, existen $x_M in I$, $y_M in I$, tales que $abs(f(x_M) - f(y_M)) > M abs(x_M - y_M)$*. Tomando $M = M_n$ con $M_n -> +infinity$, vemos que alcanza con probar que *existen $(x_n)_n subset.eq I$, $(y_n)_n subset.eq I$, tales que*
  $
  abs(f(x_n) - f(y_n)) >= M_n dot abs(x_n - y_n).
  $
  Sean
  $
  x_n = 1 / (pi / 2 + 2 pi n), quad y_n = 1 / ((3 pi) / 2 + 2 pi n);
  $
  tenemos que $x_n != 0$, $y_n != 0$ para todo $n$. Entonces
  $
  abs(f(x_n) - f(y_n)) &= abs(1 / (pi / 2 + 2 pi n) sin(pi / 2 + 2 pi n) - 1 / ((3 pi) / 2 + 2 pi n) sin((3 pi) / 2 + 2 pi n)) \
                       &= abs(1 / (pi / 2 + 2 pi n) + 1 / ((3 pi) / 2 + 2 pi n))
                        = abs(((3 pi) / 2 + 2 pi n + pi / 2 + 2 pi n) / ((pi / 2 + 2 pi n)((3 pi) / 2 + 2 pi n))) \
                       &= (2 pi + 4 pi n) / ((pi / 2 + 2 pi n)((3 pi) / 2 + 2 pi n))
                        = (2 pi + 4 pi n) / pi dot pi / ((pi / 2 + 2 pi n)((3 pi) / 2 + 2 pi n)) \
                       &= (2 + 4 n) abs(1 / (pi / 2 + 2 pi n) - 1 / ((3 pi) / 2 + 2 pi n))
                        = (2 + 4 n) dot abs(x_n - y_n) = M_n dot abs(x_n - y_n),
  $
  y como $M_n -> +infinity$, concluimos que $f$ *no es Lipschitz*. #align(right)[$square$]

  _Nota_: el manuscrito no dice por qué $x_n, y_n in I$: como $x_n, y_n -> 0$ y $0 in (a, b)$, están en $I$ para todo $n$ suficientemente grande, y con esos $n$ alcanza (dado $M > 0$, se elige $n$ grande con $M_n = 2 + 4n > M$; como $x_n != y_n$, la desigualdad $>= M_n abs(x_n - y_n)$ da la estricta $> M abs(x_n - y_n)$).
]

#observacion[Lipschitz implica uniformemente continua, pero no al revés][
  Si $f : E -> F$ es Lipschitz entonces $f$ es uniformemente continua. Pero no vale la vuelta; la función del ejemplo anterior en el dominio $[-1, 1]$ es uniformemente continua _(esto es consecuencia de un resultado que veremos más adelante)_ pero no es Lipschitz.

  _Nota_: el resultado aludido es que una función continua en un compacto es uniformemente continua (Práctica 5).
]

#ejemplo[$Psi(f)(x) = x f(x)$ de $(C([0, 1]), d_infinity)$ en $(C([0, 1]), d_1)$ es Lipschitz (Clase 6 · Ejemplo 4)][C6-4][
  Sea $Psi : (C([0, 1]), d_infinity) -> (C([0, 1]), d_1)$ dada por
  $
  (Psi(f))(x) := x f(x).
  $
  Decidir si $Psi$ es Lipschitz.
]

#resolucion[
  Dadas $f, g in C([0, 1])$, planteamos
  $
  d_1 (Psi(f), Psi(g)) &= integral_0^1 abs(x f(x) - x g(x)) dif x = integral_0^1 abs(x (f(x) - g(x))) dif x \
                       &<= integral_0^1 abs(x) abs(f(x) - g(x)) dif x <= integral_0^1 sup_(x in [0, 1]) abs(f(x) - g(x)) dif x \
                       &= d_infinity (f, g).
  $
  Entonces $Psi$ es Lipschitz. #align(right)[$square$]

  _Nota_: en 4), en particular vemos que es uniformemente continua.
]

#ejemplo[$cos(x)$, $sqrt(x)$ en $[1, +infinity)$ y la integral en $(C([0, 1]), d_infinity)$ son Lipschitz; $sqrt(x)$ en $[0, +infinity)$ no (Ejemplo 5.26)][39][
  #set enum(numbering: "a)")
  + Sea $f : (RR, abs(dot)) -> (RR, abs(dot))$, $f(x) = cos(x)$.
  + Sea $f : ([1, +infinity), abs(dot)) -> (RR, abs(dot))$, $f(x) = sqrt(x)$.
  + Sea $F : (C([0, 1]), d_infinity) -> (C([0, 1]), d_infinity)$ la función definida como
    $ F(f)(x) = integral_0^x f(t) dif t. $
]

#resolucion[
  *a)* Como $f$ es derivable, sabemos que para todo $x, y in RR$ existe un $z$ entre $x$ e $y$ tal que
  $ abs(cos(x) - cos(y)) = abs(sin(z)) dot abs(x - y) <= 1 dot abs(x - y), $
  lo que nos dice que $f$ es Lipschitz de constante $1$.

  *b)* Otra vez, como $f$ es derivable, sabemos que para todo $x, y in [1, +infinity)$ existe un $z$ entre $x$ e $y$ tal que
  $ abs(sqrt(x) - sqrt(y)) = 1 / (2 sqrt(z)) abs(x - y) <= 1 / 2 abs(x - y), $
  dado que $z >= 1$. Esto nos dice que $f$ es Lipschitz de constante $1 \/ 2$.

  Sin embargo, también usando el teorema del valor medio, podemos ver que $f$ no va a ser Lipschitz si la pensamos como función $f : [0, +infinity) -> RR$. Para ver esto, supongamos que sí lo es. Sea $C > 0$ la constante de Lipschitz de la función y sea $x in (0, +infinity)$ tal que $1 / (2 sqrt(x)) > C$. Como $x > 0$, podemos encontrar $y$ tal que $0 < y < x$. Como estamos suponiendo que $f$ es Lipschitz de constante $C$, tenemos que
  $ abs(sqrt(x) - sqrt(y)) <= C abs(x - y). $
  Por otro lado, por el teorema del valor medio, existe $y < z < x$ tal que
  $ abs(sqrt(x) - sqrt(y)) = 1 / (2 sqrt(z)) abs(x - y) >= 1 / (2 sqrt(x)) abs(x - y) > C abs(x - y), $
  lo cual es absurdo.

  *c)* Veamos que $F$ es Lipschitz:
  $
    abs(F(f)(x) - F(g)(x)) & = abs(integral_0^x f(t) dif t - integral_0^x g(t) dif t) = abs(integral_0^x f(t) - g(t) dif t) \
                           & <= integral_0^x abs(f(t) - g(t)) dif t <= integral_0^x d_infinity (f, g) dif t \
                           & = x d_infinity (f, g) <= d_infinity (f, g).
  $
  Como esto vale para todo $0 <= x <= 1$, tenemos que
  $ d_infinity (F(f), F(g)) <= d_infinity (f, g), $
  lo que nos dice que $F$ es Lipschitz de constante $1$.
]

== Bloque 6 · Continuidad uniforme: ejemplos, contraejemplos y pegado

#sublema(titulo: "Qué desbloquea")[
  Decidir continuidad uniforme: por la vía positiva (Lipschitz vía valor medio, o un $delta$ que no depende del punto) y por la negativa (dos sucesiones $(x_n)_n, (y_n)_n$ con $abs(x_n - y_n) -> 0$ pero $abs(f(x_n) - f(y_n)) >= epsilon$). Además, dos resultados de "pegado": si $f$ es uniformemente continua en dos piezas que se tocan en un punto, o en dos piezas a distancia positiva, lo es en la unión. Es el modelo de los *Ejercicios 13, 14, 15 y 16* de la Práctica 4 (contraejemplos con $1 \/ x$ y $sin(1 \/ x)$, continuidad uniforme y sucesiones de Cauchy, acotada y no uniformemente continua, $d(A, B) = 0 ==> d'(f(A), f(B)) = 0$).
]

#ejemplo[$sin(x)$ es uniformemente continua en $RR$; $x^2$ no lo es en $(0, +infinity)$ (Clase 6 · Ejemplo 5)][C6-5][
  Decidir si son uniformemente continuas.
  #set enum(numbering: "a)")
  + $f : RR -> RR$, $f(x) = sin(x)$.
  + $f : (0, +infinity) -> RR$, $f(x) = x^2$.
]

#resolucion[
  *a)* Una forma es viendo que es Lipschitz, mediante el teorema del valor medio: dados $x < y$, existe $c in (x, y)$ tal que
  $
  f(x) - f(y) = f'(c)(x - y).
  $
  Entonces
  $
  abs(f(x) - f(y)) = abs(sin(x) - sin(y)) = abs(cos(c)) dot abs(x - y) <= abs(x - y).
  $
  Como $f$ es Lipschitz, es uniformemente continua.

  *b)* Veamos que *no es uniformemente continua*. Para ello, razonamos como para ver que una $f$ no es Lipschitz: *existen $epsilon > 0$ y $(x_n)_n subset.eq RR$, $(y_n)_n subset.eq RR$ tales que $abs(x_n - y_n) -> 0$ pero*
  $
  abs(f(x_n) - f(y_n)) >= epsilon " para todo " n.
  $
  El problema ocurre cuando $x_n, y_n -> +infinity$. Sea $x_n = n$, $y_n = n + 1/n$. Tenemos que $abs(x_n - y_n) = 1/n -> 0$ pero
  $
  abs(f(x_n) - f(y_n)) = abs(n^2 - (n + 1/n)^2) = cancel(n^2) + 2 + 1/n^2 - cancel(n^2) > 2.
  $
  Tomando $epsilon = 2$ vemos que no es uniformemente continua.
]

#ejemplo[Producto de uniformemente continuas y acotadas (Clase 6 · Ejemplo 6)][C6-6][
  Sean $(X, d)$ un espacio métrico y $f, g : X -> RR$ uniformemente continuas y acotadas. Probar que $f dot g$ es uniformemente continua. Mostrar que el producto de funciones uniformemente continuas puede no serlo *incluso si una de ellas está acotada*. [Sugerencia: $f(x) = x sin(x)$.]
]

#resolucion[
  Sea $epsilon > 0$. Queremos ver que existe $delta > 0$ tal que $d(x, y) < delta$ implica que
  $
  abs(f(x) dot g(x) - f(y) dot g(y)) < epsilon.
  $
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
  Como $f, g$ son acotadas, existen $M_1 > 0$, $M_2 > 0$ tales que $abs(g(x)) <= M_1$ para todo $x in X$, $abs(f(x)) <= M_2$ para todo $x in X$. Entonces en $(*)$ acotamos
  $
  abs(f(x) g(x) - f(y) g(y)) <= M_1 epsilon' + M_2 epsilon' = (M_1 + M_2) epsilon'
  $
  si $d(x, y) < min{delta_1, delta_2}$. Tomando $epsilon' < epsilon / (M_1 + M_2)$, concluimos.

  Veamos que la hipótesis de acotadas es necesaria. Sea $f : RR -> RR$, $f(x) = x sin(x)$. Sean $x_n = pi + 2 pi n$, $y_n = pi + 2 pi n + 1/n$. Se tiene que $abs(x_n - y_n) = 1/n -> 0$, pero
  $
  abs(f(x_n) - f(y_n)) &= abs((pi + 2 pi n) underbrace(sin(pi + 2 pi n), = 0) - (pi + 2 pi n + 1/n) sin(pi + 2 pi n + 1/n)) \
                       &= abs((pi + 2 pi n + 1/n) sin((pi + 2 pi n) + 1/n)) \
                       &= abs((pi + 2 pi n + 1/n) [underbrace(sin(pi + 2 pi n), = 0) dot cos(1/n) + underbrace(cos(pi + 2 pi n), = -1) sin(1/n)]) \
                       &= underbrace(pi sin(1/n), -> 0) + underbrace(2 pi n sin(1/n), (star)) + underbrace(1/n sin(1/n), -> 0).
  $
  $(star)$ Como $2 pi n sin(1/n) = 2 pi sin(1/n) / (1/n) -> 2 pi$, tenemos que $abs(f(x_n) - f(y_n)) -> 2 pi$, y en consecuencia existe $epsilon > 0$ tal que $abs(f(x_n) - f(y_n)) >= epsilon$ para todo $n$ suficientemente grande. #align(right)[$square$]

  _Nota_: el manuscrito no explicita qué par de funciones multiplica en el contraejemplo: $x sin(x)$ es el producto de $op("id")_RR$ (uniformemente continua, no acotada) por $sin$ (uniformemente continua y acotada, Ejemplo 5 a)). En la última igualdad desaparece la barra de valor absoluto porque $sin(1/n) > 0$ para todo $n >= 1$, así que la expresión entre barras es $-(pi + 2 pi n + 1/n) sin(1/n)$ y su módulo es la suma escrita.
]

#ejemplo[Pegado de continuidad uniforme en $[0, a]$ y $[a, +infinity)$ (Clase 6 · Ejemplo 7)][C6-7][
  Sea $f : [0, +infinity) -> RR$. Supongamos que existe $a > 0$ tal que $f|_([0, a])$ y $f|_([a, +infinity))$ son uniformemente continuas. Probar que $f$ es uniformemente continua.
]

#resolucion[
  Sea $epsilon > 0$. Queremos ver que existe $delta > 0$ tal que $abs(x - y) < delta$ implica que $abs(f(x) - f(y)) < epsilon$.

  - Si $x, y in [0, a]$, existe $delta_1 > 0$ tal que $abs(x - y) < delta_1$ implica que $abs(f(x) - f(y)) < epsilon'$.
  - Si $x, y in [a, +infinity)$, existe $delta_2 > 0$ tal que $abs(x - y) < delta_2$ implica que $abs(f(x) - f(y)) < epsilon'$.
  - Sea $x in [0, a]$, $y in [a, +infinity)$. _(Dibujo: la semirrecta desde $0$, con $x$ a la izquierda de $a$ a distancia $< delta_1$ e $y$ a la derecha de $a$ a distancia $< delta_2$.)_

    La idea es que si $x$ e $y$ están muy cerca, estarán cerca de $a$, y si $abs(x - a) < delta_1$ entonces $abs(f(x) - f(a)) < epsilon'$ y similarmente $abs(y - a) < delta_2$, entonces $abs(f(y) - f(a)) < epsilon'$, por lo tanto $f(x)$ y $f(y)$ estarán muy cerca entre sí. Formalmente, sea $delta < min{delta_1, delta_2}$. Supongamos que $abs(x - y) < delta$. Como $x <= a <= y$, tenemos que
    $
    abs(x - a) &= a - x <= y - x = abs(y - x) < delta < delta_1, " entonces " abs(f(x) - f(a)) < epsilon', quad (1) \
    abs(y - a) &= y - a <= y - x = abs(y - x) < delta < delta_2, " entonces " abs(f(y) - f(a)) < epsilon'. quad (2)
    $
    Por lo tanto
    $
    abs(f(x) - f(y)) <= underbrace(abs(f(x) - f(a)), < epsilon' " por " (1)) + underbrace(abs(f(a) - f(y)), < epsilon' " por " (2)) < 2 epsilon'.
    $

  Tomando $epsilon' < 2 epsilon$, concluimos. #align(right)[$square$]

  _Nota_: el manuscrito cierra con "tomando $epsilon' < 2 epsilon$"; para que $2 epsilon' <= epsilon$ hay que tomar $epsilon' <= epsilon \/ 2$. En el párrafo de la idea escribe "$abs(x - a) < delta$ entonces $abs(f(x) - f(a)) < epsilon$" mezclando $delta$ con $delta_1$ y $epsilon$ con $epsilon'$; la versión formal de abajo es la correcta.
]

#ejemplo[Pegado de continuidad uniforme en $A union B$ con $d(A, B) > 0$ (Clase 6 · Ejemplo 8)][C6-8][
  Sean $(X, d)$, $(Y, d')$ espacios métricos y $f : X -> Y$. Supongamos que $X = A union B$, con $A, B$ tales que $d(A, B) > 0$. Si $f|_A$ y $f|_B$ son uniformemente continuas, entonces $f$ es uniformemente continua.
]

#resolucion[
  Sea $epsilon > 0$. Como $f|_A$ y $f|_B$ son uniformemente continuas, existen $delta_A > 0$, $delta_B > 0$ tales que
  - si $x, y in A$ y $d(x, y) < delta_A$ entonces $d'(f(x), f(y)) < epsilon'$;
  - si $x, y in B$ y $d(x, y) < delta_B$ entonces $d'(f(x), f(y)) < epsilon'$.

  _(Dibujo: dos intervalos $A$ y $B$ separados por una brecha de longitud $d(A, B)$; para $x in A$, $y in B$ se marca $d(x, y) >= d(A, B)$.)_ Notemos que si $d(A, B) > 0$ entonces $overline(A) inter overline(B) = emptyset$ (es el contrarrecíproco del ejercicio 11 c), $overline(A) inter overline(B) != emptyset ==> d(A, B) = 0$).

  La idea es que si tomamos $delta > 0$ muy pequeño, no puede pasar que $d(x, y) < delta$ con $x in A$, $y in B$. Si tomamos $delta < min{delta_A, delta_B, d(A, B)}$, si $x in A$, $y in B$, $d(x, y) < delta$, entonces
  $
  d(A, B) <= d(x, y) < delta < d(A, B),
  $
  absurdo. Por lo tanto $d(x, y) < delta$ implica que $x in A, y in A$, o $x in B, y in B$.
  - Si $x, y in A$, como $d(x, y) < delta < delta_A$, tenemos que $d'(f(x), f(y)) < epsilon'$;
  - si $x, y in B$, como $d(x, y) < delta < delta_B$, tenemos que $d'(f(x), f(y)) < epsilon'$.

  Tomando $epsilon' < epsilon$ concluimos. #align(right)[$square$]

  _Nota_: el "ejercicio 11 c)" citado es el Ejercicio 11 (c) de la Práctica 3 ($hat(d)(A, B) = 0 <=> overline(A) inter overline(B) != emptyset$); la implicación que se usa, $overline(A) inter overline(B) != emptyset ==> d(A, B) = 0$, es la dirección verdadera de ese ítem. Además, la observación $overline(A) inter overline(B) = emptyset$ no se vuelve a usar en la prueba: lo que hace falta es sólo la desigualdad $d(A, B) <= d(x, y)$ para $x in A$, $y in B$, que sale de la definición de ínfimo.
]

#ejemplo[$x^2$ no es uniformemente continua en $RR$; toda función desde un discreto lo es (Ejemplo 5.17)][37][
  #set enum(numbering: "a)")
  + Sea $f : (RR, abs(dot)) -> (RR, abs(dot))$ la función $f(x) = x^2$. Sabemos que $f$ es continua en todo $RR$. Veamos que $f$ no es uniformemente continua.
  + Sea $f : (M, d) -> (N, d')$ con $d$ la métrica discreta y $(N, d')$ cualquiera. Veamos que $f$ es uniformemente continua.
]

#resolucion[
  *a)* Para ver que $f$ no es uniformemente continua, deberíamos ver que existe $epsilon > 0$ tal que para todo $delta > 0$ existen $x, y$ tal que $abs(x - y) < delta$ pero $abs(f(x) - f(y)) >= epsilon$ (Observación 5.16).

  Esto se puede lograr de muchas formas distintas. Una de ellas es la siguiente: tomemos $epsilon = 1$. Dado $delta > 0$, si $x$ es cualquiera en $RR$ y si $y = x + delta \/ 2$, entonces tenemos que $abs(x - y) = delta \/ 2 < delta$. Veamos que pasa con $abs(f(x) - f(y))$:
  $
    abs(f(x) - f(y)) & = abs(x^2 - (x + delta \/ 2)^2) = abs(x^2 - (x^2 + delta x + delta^2 / 4)) \
                     & = abs(delta x + delta^2 / 4) = delta abs(x + delta / 4).
  $
  Si elegimos $x > 1 \/ delta$ (en particular, $x > 0$), nos sale que
  $ abs(f(x) - f(y)) = delta abs(x + delta / 4) >= delta x > 1 = epsilon, $
  lo que nos dice que la función $f$ *no* es uniformemente continua.

  *b)* Dado $epsilon > 0$, tomemos $delta = 1 \/ 2$. Entonces tenemos que para todo $x in M$, $B(x, 1 \/ 2) = {x}$ y por lo tanto
  $ f(B(x, 1 \/ 2)) = f({x}) = {f(x)} subset.eq B(f(x), epsilon). $
  Como la elección de $delta$ no depende del punto $x$, vemos que cualquier función $f$ es uniformemente continua.
]

== Bloque 7 · Conjuntos densos

#sublema(titulo: "Qué desbloquea")[
  Probar que un conjunto es denso (Definición 5.20) mostrando que todo punto del espacio es límite de una sucesión del conjunto (Proposición 4.46). Es el vocabulario de los *Ejercicios 7 y 8* de la Práctica 4 (dos continuas que coinciden en un denso son iguales; la imagen continua y suryectiva de un denso es densa).
]

#ejemplo[$QQ$ y $II = RR without QQ$ son densos en $RR$ (Ejemplo 5.21)][38][
  #set enum(numbering: "a)")
  + $QQ subset.eq (RR, abs(dot))$ es un conjunto denso.
  + $II = RR without QQ subset.eq (RR, abs(dot))$ el conjunto de los números irracionales también es denso.
]

#resolucion[
  *a)* Si $x in RR$, sabemos que existe una sucesión de racionales $(q_n) subset.eq QQ$ tal que $q_n -> x$. Esto nos dice que $x in overline(QQ)$.

  *b)* Dado $x in RR$, consideremos $y = x + 1 / n$. Como $x < y$, sabemos que debe existir un número irracional $z_n$ tal que $x < z_n < x + 1 / n$ (por el ejercicio 2 de la guía 1). Esto nos dice que
  $ abs(x - z_n) < 1 / n -> 0 quad "cuando " n -> infinity, $
  lo cual nos dice que $(z_n) subset.eq II$ es una sucesión tal que $z_n -> x$. Por lo tanto, $x in overline(II)$.
]
