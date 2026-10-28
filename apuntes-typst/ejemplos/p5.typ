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

// --- Ejemplos de la Práctica 5 ---

#align(center)[
  #text(14pt, weight: "bold")[Ejemplos resueltos --- Práctica 5] \
  #v(2pt)
  #text(10pt, style: "italic", fill: rgb("#475569"))[
    Compacidad y teoremas de punto fijo
  ]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

Los ejemplos están agrupados por *técnica*, no por orden de transcripción, y los bloques siguen el orden en que la guía los necesita. Cada bloque abre con la nota de qué ejercicios de `guias/p5.typ` desbloquea.

La pestaña dice de dónde viene cada ejemplo: un *número* es el ejemplo de `notas_materia.pdf` (con su numeración por capítulo entre paréntesis en el título), *`C{clase}-{ejemplo}`* es un ejercicio resuelto en clase, transcrito en `clases/` (un archivo por tema; la tabla clase $arrow$ archivo está en la skill `ejemplo`) --- `C7-1` es el Ejercicio 1 de `clases/compactos.typ` y `C8-1` el Ejercicio 1 de `clases/punto_fijo.typ` ---, *`{día}-{mes}/{n}`* es el ejemplo $n$ de una clase de 2026 cargado directo de los apuntes del pizarrón (`27-10/1` es el primero de la clase del 27/10/2026), y *`A{sección}`* es un resultado o ejercicio de Abbott, _Understanding Analysis_.

#v(6pt)

#show table.cell.where(y: 0): set text(fill: white, weight: "bold", size: 8.5pt)

#table(
  columns: (0.35fr, 2.4fr, 1.1fr),
  align: (center + horizon, left + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#065f46") } else if calc.even(y) { rgb("#f8fafc") } else { white },
  stroke: 0.4pt + rgb("#cbd5e1"),
  inset: (x: 6pt, y: 4pt),

  [*\#*], [*Bloque*], [*Desbloquea*],
  [1], [Compacidad por definición (sucesiones)], [p5: Ej. 1, 6; conceptual para Ej. 7],
  [2], [Compactos y cerrados], [p5: Ej. 4, 5],
  [3], [Productos de compactos], [p5: Ej. 3; conceptual para Ej. 9],
  [4], [Cerrado y acotado no alcanza: bolas en espacios de funciones], [p5: Ej. 10],
  [5], [Compacidad y funciones continuas: encajes de compactos], [p5: Ej. 11, 13 (usa el Ej. 5); conceptual para Ej. 2, 8, 9, 12],
  [6], [Compacidad y punto fijo], [p5: Ej. 14--19 (conceptual)],
  [7], [Cubrimientos por abiertos], [conceptual (Definición 6.11)],
)

#v(4pt)

#text(size: 9pt, fill: rgb("#64748b"))[
  La numeración de ejercicios es la de `guias/p5.typ` (Práctica 5, edición 2026).
]

#v(8pt)

== Bloque 1 · Compacidad por definición (sucesiones)

#sublema(titulo: "Qué desbloquea")[
  Un espacio métrico $K$ es *compacto* si toda sucesión en $K$ tiene una subsucesión que converge a un punto de $K$. El *Ejercicio 1* de la Práctica 5 pide probar _por definición_ que $K = {0} union {1 \/ n : n in NN}$ es compacto: es exactamente el ejemplo de este bloque con $x_n = 1 \/ n$ y $x = 0$. La maniobra a aprender es cómo tratar una sucesión arbitraria $(y_n)_n$ del conjunto, que *no* tiene por qué ser una subsucesión de $(x_n)_n$: se separa según tome finitos o infinitos valores. El *Ejercicio 6* (compactos de un espacio discreto) es el Ejemplo 6.2 (pestaña `42`): los finitos son compactos y los infinitos no. La partición finitos/infinitos valores es también la base del *Ejercicio 7* (unión finita de compactos: alguno de los finitos compactos contiene infinitos términos).
]

#ejemplo[Una sucesión convergente junto con su límite es un compacto (Clase 7 · Ejercicio 2)][C7-2][
  Sea $X$ un espacio métrico y $(x_n)_n subset.eq X$ una sucesión convergente con límite $x$. Probar que el conjunto ${x_n : n in NN} union {x}$ es compacto (con la métrica inducida por la de $X$).
]

#estrategia[Finitos valores: alguno se repite infinitas veces. Infinitos valores: se extrae una subsucesión de $(x_n)_n$][
  Una sucesión $(y_n)_n$ del conjunto puede ser, por ejemplo, constante igual a $x_1$, o constante igual a $x$: no es en general una subsucesión de $(x_n)_n$. Si toma finitos valores, uno de ellos aparece infinitas veces y da una subsucesión constante, que converge. Si toma infinitos valores distintos, se la puede recorrer eligiendo términos que sean $x_(K_k)$ con $K_k$ estrictamente creciente: eso es una subsucesión de $(x_n)_n$, así que converge a $x$, que está en el conjunto.
]

#resolucion[
  Vamos por definición. Sea $(y_n)_n subset.eq {x_n : n in NN} union {x}$ una sucesión. Queremos ver que $(y_n)_n$ admite alguna subsucesión convergente en el conjunto. Dividimos en dos casos.

  *Si $(y_n)_n$ toma sólo finitos valores* ${y_(j_1), y_(j_2), dots, y_(j_m)}$, entonces alguno de estos valores debe ocurrir infinitas veces: hay algún $j_i$ tal que para todo $k$ existe $n_k >= k$, $n_k > n_(k - 1)$ (para que sea subsucesión), con $y_(n_k) = y_(j_i)$; esto es posible porque el valor $y_(j_i)$ aparece infinitas veces. Tomando la subsucesión $(y_(n_k))_k$, que es constante, se obtiene lo pedido.

  *Si $(y_n)_n$ toma infinitos valores distintos*, inductivamente para cada $k$ hay algún $n_k >= k$, $n_k > n_(k - 1)$, tal que $y_(n_k) = x_(K_k)$ para cierto $K_k >= k$, $K_k > K_(k - 1)$. Esto termina el problema: $(y_(n_k))_k$ es una subsucesión de $(y_n)_n$, pero además es una subsucesión de $(x_n)_n$, y una subsucesión de una sucesión convergente es convergente. Más aún, $y_(n_k) -> x$, que está en nuestro conjunto.

  Sobre la existencia de los $n_k$, es cuestión de ver los cuantificadores. Supongamos que no: hay algún $k$ para el cual no existe ningún $n >= max{k, n_(k - 1) + 1}$ con $y_n = x_K$, $K >= max{k, K_(k - 1) + 1}$. Entonces la cola ${y_n : n >= max{k, n_(k - 1) + 1}}$ no interseca a ${x_K : K >= max{k, K_(k - 1) + 1}}$, y por lo tanto está incluida en su complemento dentro del conjunto, que es finito (son los primeros $x_K$ y el punto $x$). Junto con los finitos términos anteriores a la cola, $(y_n)_n$ tomaría finitos valores, lo cual es absurdo.
]

#sublema(titulo: "Corrección al manuscrito")[
  El original pide $n_k >= n_(k - 1)$ y $K_k >= K_(k - 1)$; para que $(x_(K_k))_k$ sea una subsucesión de $(x_n)_n$ hace falta $K_k > K_(k - 1)$, estricto. Como los $y_(n_k)$ se eligen con valores distintos dos a dos, los $K_k$ son distintos y se los puede tomar estrictamente crecientes, que es lo que se escribió arriba. El absurdo final también necesita observar que los términos anteriores a la cola son finitos: el original sólo dice que la cola "está incluida en un complemento finito". En el caso de finitos valores, el original mezcla los índices ("para todo $k$ existe $n >= k$ tal que $y_(n_k) = y_(j_i)$"); lo que se quiere decir es lo que se escribió arriba, eligiendo los $n_k$ estrictamente crecientes.
]

#ejemplo[Un intervalo cerrado, un infinito con la métrica discreta y un conjunto finito (Ejemplo 6.2)][42][
  #set enum(numbering: "a)")
  + $K = [a, b] subset.eq (RR, abs(dot))$ es compacto.
  + Sea $(M, delta)$ un espacio con la métrica discreta y sea $K subset.eq M$ un subconjunto infinito. Entonces $K$ no puede ser compacto.
  + Si $(M, d)$ es un espacio métrico cualquiera y $K subset.eq M$ es un conjunto finito, entonces $K$ es compacto.
]

#resolucion[
  *a)* Para ver esto, tomemos $(x_n)_(n in NN) subset.eq K$. Como $a <= x_n <= b$ para todo $n in NN$, tenemos que $x_n$ admite una subsucesión convergente (probarlo como ejercicio --- para esto, ver la demostración del Teorema 4.57).

  *b)* Como $K$ es infinito, existe una sucesión $(x_n)_(n in NN) subset.eq K$ tal que $x_n != x_m$ para todo $n != m in NN$. Como $delta(x_n, x_m) = 1$ para todo $n != m in NN$, vemos que $(x_n)_(n in NN)$ no admite subsucesiones de Cauchy y por lo tanto, no admite subsucesiones convergentes.

  *c)* Si $(x_n)_(n in NN) subset.eq K$ es una sucesión, entonces $(x_n)$ tiene que tomar el mismo valor infinitas veces (porque $K$ es finito). Pero esto es lo mismo que decir que $(x_n)$ tiene una subsucesión $(x_(n_k))$ constante y por lo tanto convergente.
]

#sublema(titulo: "Detalle que el apunte omite")[
  En *a)*, la definición de compacto pide además que el límite $x$ de la subsucesión esté en $K$. Eso sale de que $a <= x_(n_k) <= b$ para todo $k$ y las desigualdades no estrictas se preservan al tomar límite: $a <= x <= b$. En *b)*, juntando con *c)*: en un espacio discreto los compactos son exactamente los subconjuntos finitos, que es el *Ejercicio 6* de la Práctica 5.
]

#v(10pt)

== Bloque 2 · Compactos y cerrados

#sublema(titulo: "Qué desbloquea")[
  Dos hechos se usan todo el tiempo: un compacto es cerrado, y un cerrado dentro de un compacto es compacto. El *Ejercicio 4* de la Práctica 5 (intersección de una familia de cerrados en la que al menos uno es compacto) es exactamente la "ida" del ejemplo de este bloque; la "vuelta" muestra cómo se *caracteriza* a los cerrados por medio de los compactos, y de paso enseña la táctica de probar un "para todo $K$" por contrarrecíproco, construyendo el compacto $K$ que falla. El compacto que se construye es el del Bloque 1, y la construcción es el modelo para _negar_ compacidad: basta exhibir una sucesión del conjunto cuyas subsucesiones convergen todas a un punto que *no* está en el conjunto. El *Ejercicio 5* (compacidad $<==>$ encajes de cerrados no vacíos tienen intersección no vacía) usa la misma caracterización de cerrado por sucesiones, y es la herramienta que después usa el Bloque 5.
]

#ejemplo[$F$ es cerrado si y sólo si $K inter F$ es compacto para todo compacto $K$ (Clase 7 · Ejercicio 3)][C7-3][
  Sea $X$ un espacio métrico. Mostrar que $F subset.eq X$ es cerrado si y sólo si para todo compacto $K subset.eq X$, $K inter F$ es compacto.
]

#estrategia[Probar un "para todo" por contrarrecíproco: negar y construir el $K$ que falla][
  Casi siempre, cuando uno quiere probar un "para todo" conviene ir por contrarrecíproco. La ventaja es que al negar el enunciado hay que probar un "existe", y eso en principio es más fácil porque se hace por construcción. Acá: si $F$ no es cerrado, hay una sucesión $(x_n)_n subset.eq F$ convergente con $lim x_n in.not F$, y el compacto $K = {x_n} union {lim x_n}$ (Bloque 1) corta a $F$ exactamente en ${x_n : n in NN}$, que no es compacto.
]

#resolucion[
  $=>)$ Es el Ejercicio 4 de la Práctica 5: $K$ compacto es cerrado, así que $K inter F$ es un cerrado contenido en el compacto $K$, y por lo tanto compacto.

  $arrow.l.double)$ Supongamos que $F$ no es cerrado; queremos ver que hay algún compacto $K$ tal que $K inter F$ no es compacto. Como estamos trabajando con sucesiones, conviene usar la caracterización de cerrado por sucesiones: $F$ es cerrado si y sólo si para toda sucesión convergente $(x_n)_n subset.eq F$, $lim_(n -> oo) x_n in F$. Que $F$ _no_ sea cerrado dice entonces que hay una sucesión convergente $(x_n)_n subset.eq F$ con $lim_(n -> oo) x_n in.not F$. Tomamos
  $ K = {x_n : n in NN} union {lim_(n -> oo) x_n}, $
  que es compacto por C7-2. Entonces $K inter F = {x_n : n in NN}$, que no es compacto: la sucesión $(x_n)_n$ no tiene ninguna subsucesión convergente en $K inter F$, porque toda subsucesión suya converge a $lim x_n in.not F$.
]

#sublema(titulo: "Detalle que el manuscrito omite")[
  La clase anota "la ida es un ejercicio de la guía (?)": es el Ejercicio 4 de la Práctica 5. La igualdad $K inter F = {x_n : n in NN}$ usa que $(x_n)_n subset.eq F$ y que $lim x_n in.not F$. Para la última afirmación se usa la unicidad del límite (toda subsucesión de $(x_n)_n$ converge al mismo punto, que no está en $K inter F$); en particular ningún valor $x_n$ se repite infinitas veces, porque si no ese valor sería el límite, y el límite no está en $F$.
]

#v(10pt)

== Bloque 3 · Productos de compactos

#sublema(titulo: "Qué desbloquea")[
  El *Ejercicio 3* de la Práctica 5 pide ver que $S = {x + y : x, y in K}$ y $P = {x y : x, y in K}$ son compactos cuando $K subset.eq RR$ lo es: son imágenes de $K times K$ por las funciones continuas $(x, y) |-> x + y$ y $(x, y) |-> x y$, así que lo que hace falta es saber que $K times K$ es compacto con $d_oo$, que es el ejemplo de este bloque, y que la imagen continua de un compacto es compacta (Bloque 5). El mismo producto $K times K$ aparece en la nota del docente del Bloque 6 y en el *Ejercicio 9* (distancia entre un compacto y un cerrado disjuntos).

  La enseñanza técnica es la extracción *anidada* de subsucesiones: primero una subsucesión convergente de la primera coordenada y, _sobre esos índices_, una de la segunda. Usar el mismo subíndice $k$ para las dos coordenadas es un error común.
]

#ejemplo[Producto finito de compactos con $d_oo$ es compacto (Clase 7 · Ejercicio 1)][C7-1][
  Mostrar que dados finitos espacios compactos ${(K_i, d_i)}_(1 <= i <= n)$, su producto $product_(i = 1)^n K_i$ con la métrica
  $ d_oo ((x_1, dots, x_n), (y_1, dots, y_n)) := max_(1 <= i <= n) d_i (x_i, y_i) $
  es compacto.
]

#estrategia[Caso $n = 2$ con subsucesiones anidadas, después inducción][
  Probar directamente por definición para $n$ coordenadas se puede, pero es complicarse de más: se prueba el caso $n = 2$ y después se hace inducción, como para ver que la unión de $n$ cerrados es cerrada. En el caso $n = 2$ el espacio es el producto con la métrica $d_oo$ de siempre, donde una sucesión converge si y sólo si convergen sus dos coordenadas.

  *El error común.* Una primera estrategia sería extraer una subsucesión convergente $(x_(n_k))_k$ de $(x_n)_n$ (se puede, porque $K_1$ es compacto), extraer otra subsucesión convergente $(y_(n_k))_k$ de $(y_n)_n$ y considerar $(x_(n_k), y_(n_k))_k$. *Esto está mal*: estamos asumiendo que las dos subsucesiones tienen los mismos índices. Podría ser que la subsucesión convergente de $(x_n)_n$ sea $(x_(2n))_n$ y la de $(y_n)_n$ sea $(y_(2n + 1))_n$, y no hay forma de quedarse con una subsucesión de $(x_n, y_n)_n$ que tome índices pares en la primera coordenada e impares en la segunda. El error viene de usar el mismo subíndice $k$ para las dos, y es común, así que cuidado. Lo correcto: extraer la subsucesión de la segunda coordenada *sobre los índices* de la primera.
]

#resolucion[
  *Caso $n = 2$.* Sea $(x_n, y_n)_(n in NN) subset.eq K_1 times K_2$ una sucesión. Como $(x_n)_n subset.eq K_1$ está contenida en un compacto, admite una subsucesión $(x_(n_k))_k$ convergente. Ahora $(y_(n_k))_k subset.eq K_2$ es una sucesión contenida en un compacto, y por lo tanto admite una subsucesión $(y_(n_(k_j)))_j$ convergente. Además, $(x_(n_(k_j)))_j$ es una subsucesión de $(x_(n_k))_k$, que era convergente, así que es convergente. Como ambas coordenadas convergen, $(x_(n_(k_j)), y_(n_(k_j)))_j$ es una sub-sub-sucesión convergente de $(x_n, y_n)_n$, y en particular una subsucesión convergente, como queríamos. Esto prueba el caso $n = 2$.

  *Inducción.* Supongamos que el producto de $n$ compactos es compacto, y sean $K_1, dots, K_(n + 1)$ compactos. Tenemos que
  $ product_(i = 1)^(n + 1) K_i = product_(i = 1)^n K_i times K_(n + 1). $
  Esto es un producto de dos compactos, ya que el primer factor es compacto por hipótesis inductiva. Como ya probamos que el producto de dos compactos es compacto, esto concluye la inducción.
]

#sublema(titulo: "Dos comentarios del docente")[
  _Asociatividad._ Hay un detalle: habría que probar que el producto es asociativo, es decir, que $(product_(i = 1)^n K_i) times K_(n + 1)$ con la $d_oo$ "de dos factores" (el máximo entre la $d_oo$ de $n$ factores y $d_(n + 1)$) es el mismo espacio métrico que $product_(i = 1)^(n + 1) K_i$ con la $d_oo$ de $n + 1$ factores. Es inmediato porque un máximo de máximos es el máximo de todo, pero hay que decirlo.

  _La vuelta._ Vale el recíproco: si el producto es compacto, cada factor lo es. Las herramientas (las proyecciones son continuas, y la imagen continua de un compacto es compacta) llegan recién en la clase siguiente; ver el Bloque 5.
]

#v(10pt)

== Bloque 4 · Cerrado y acotado no alcanza: bolas en espacios de funciones

#sublema(titulo: "Qué desbloquea")[
  En $RR^n$ compacto equivale a cerrado y acotado (Heine--Borel). El *Ejercicio 10* de la Práctica 5 muestra que en $(C[0, 1], d_oo)$ eso falla: la bola cerrada $overline(B)(f_0, 1)$ es cerrada y acotada pero no compacta. La técnica es exhibir una sucesión en la bola cuyos términos están a distancia $>= 1$ dos a dos: entonces ninguna subsucesión es de Cauchy, y en particular ninguna converge. El ejemplo de este bloque hace exactamente eso en $C(RR, [0, 1])$ con las funciones $f_S$ que valen $0$ en $S subset.eq NN$ y $1$ en $NN without S$; para el Ejercicio 10 hay que fabricar en $[0, 1]$ una familia con la misma propiedad (por ejemplo, "picos" de altura $1$ con soportes disjuntos). El enunciado principal del ejemplo (no hay un denso numerable) es un resultado sobre densidad, pero su construcción es la que importa acá, y la nota del docente al final la convierte en la no compacidad de la bola cerrada. El Ejemplo 6.6 (pestaña `43`) es la versión más limpia del mismo truco, en el espacio de sucesiones eventualmente nulas: los "vectores canónicos" $a^m$ están todos a distancia $1$ entre sí.
]

#ejemplo[$C(RR, [0, 1])$ con $d_oo$ no tiene un subconjunto denso numerable, y su bola cerrada unitaria no es compacta (Clase 8 · Ejercicio 3)][C8-3][
  Sea $C(RR, [0, 1]) = {f : RR -> [0, 1] : f "es continua"}$ con $d_oo$. Probar que no existe un subconjunto denso numerable en $C(RR, [0, 1])$.
]

#estrategia[Una familia no numerable de bolas abiertas disjuntas: cada una tiene que contener un punto del denso][
  Es la generalización del Ejercicio 17 de la Práctica 2: si $Y$ es denso y ${U_i}_(i in I)$ es una familia de abiertos no vacíos y disjuntos dos a dos, cada $U_i$ contiene algún $y_i in Y$ y $i |-> y_i$ es inyectiva, así que $\# I <= \# Y$. Para fabricar la familia se usa el Ejercicio 11 de la Práctica 4 (versión de Urysohn en $RR$): para cada $S subset.eq NN$ hay $f_S$ continua que vale $0$ en $S$ y $1$ en $NN without S$. Dos de ellas distintas están a distancia $d_oo >= 1$, así que las bolas $B(f_S, 1 \/ 2)$ son disjuntas, y hay $\# cal(P)(NN)$ de ellas.
]

#resolucion[
  Usamos el siguiente lema, que generaliza el Ejercicio 17 de la Práctica 2.

  _Lema._ Sea $(X, d)$ un espacio métrico y supongamos que existe $Y subset.eq X$ contable con $overline(Y) = X$. Si ${U_i}_(i in I)$ es una familia de abiertos tales que (I) $U_i != emptyset$ para todo $i in I$, y (II) $U_i inter U_j = emptyset$ si $i != j$, entonces $I$ es contable. (Por densidad, cada $U_i$ contiene algún $y_i in Y$; por (II), $i |-> y_i$ es inyectiva.)

  Construyamos una familia de abiertos de $C(RR, [0, 1])$ que cumpla (I) y (II). Por el Ejercicio 11 de la Práctica 4, dados dos cerrados $A, B subset.eq RR$ no vacíos y disjuntos, existe $f : RR -> [0, 1]$ continua con $f|_A = 0$ y $f|_B = 1$. Para $S subset.eq NN$, tomando $A = S$ y $B = NN without S$ (cerrados de $RR$), sea $f_S : RR -> [0, 1]$ continua con $f_S |_S = 0$ y $f_S |_(NN without S) = 1$ (si $S = emptyset$ o $S = NN$, sirven las constantes $1$ y $0$). Notemos que:

  - Si $S, S' subset.eq NN$ y $S != S'$, existe $x in S without S'$ o $x in S' without S$; sin pérdida de generalidad, lo primero. Entonces $f_S (x) = 0$ y $f_(S') (x) = 1$, por lo tanto
    $ abs(f_S (x) - f_(S') (x)) = 1 <= norm(f_S - f_(S'))_oo. quad (*) $
  - Sea $I = cal(P)(NN)$, que no es contable, y $U_S = B(f_S, 1 \/ 2)$ para $S in I$. Cada $U_S$ es no vacío, y si $g in U_S inter U_(S')$ con $S != S'$, entonces $norm(f_S - f_(S'))_oo < 1 \/ 2 + 1 \/ 2 = 1$, contra $(*)$: la familia ${U_S}_(S in I)$ es una familia de abiertos no vacíos, disjuntos, no contable.

  Por el lema, $C(RR, [0, 1])$ no admite un subconjunto denso contable.
]

#observacion[La bola cerrada $overline(B)(0, 1)$ de $C(RR, [0, 1])$ no es compacta][
  La misma idea muestra que $overline(B)(0, 1)$ _no es compacta_. Si $S_n = {n}$ y $f_n = f_(S_n)$, entonces $(f_n)_n subset.eq overline(B)(0, 1)$ (las $f_n$ toman valores en $[0, 1]$) y no admite subsucesiones convergentes: si $(f_(n_k))_k$ es una subsucesión, por $(*)$, para $k != k'$,
  $ norm(f_(n_k) - f_(n_(k'))) _oo = norm(f_(S_(n_k)) - f_(S_(n_(k'))))_oo >= 1, $
  así que no puede ser de Cauchy, y por lo tanto tampoco convergente. Es el mismo mecanismo que pide el Ejercicio 10 de la Práctica 5 para $overline(B)(f_0, 1)$ en $(C[0, 1], d_oo)$.
]

#ejemplo[La bola cerrada unitaria de las sucesiones eventualmente nulas con $d_oo$ es cerrada y acotada pero no compacta (Ejemplo 6.6)][43][
  Sea
  $ M = {(a_n)_(n in NN) subset.eq RR : "existe un " n_0 " tal que " a_n = 0 " para todo " n >= n_0}, $
  el conjunto de las sucesiones de números reales que se hacen eventualmente $0$. Definamos en $M$ la distancia $d_oo (a, b) = max_(n in NN) abs(a_n - b_n)$. Notemos que esta distancia está bien definida porque tanto $a$ como $b$ tienen finitos términos distintos de cero. Como ejercicio, probá que $(M, d_oo)$ es un espacio métrico.

  Consideremos en $M$ el conjunto $K = {(a_n)_(n in NN) in M : abs(a_n) <= 1 "para todo " n in NN}$. Notemos que $K = B[0, 1]$, donde por $0$ entendemos a la sucesión que es constantemente $0$. Por lo tanto, $K$ es cerrado y acotado en este espacio métrico (las bolas cerradas siempre son cerradas y acotadas).

  Sin embargo, $K$ no es compacto.
]

#resolucion[
  Tomemos en $K$ la sucesión $(a^m)_(m in NN)$ definida como
  $ a_n^m = cases(1 quad & "si " n = m, 0 quad & "si " n != m.) $
  Es decir, $(a^m)$ es la sucesión
  $
    a^1 & = (1, 0, 0, dots) \
    a^2 & = (0, 1, 0, dots) \
    a^3 & = (0, 0, 1, 0, dots) \
    a^4 & = (0, 0, 0, 1, 0, dots) \
        & dots.v
  $
  Observemos que $d_oo (a^k, a^m) = 1$ para todo $k != m$ (porque tienen el $1$ en lugares distintos), lo cual nos dice que $(a^m)_(m in NN)$ no admite subsucesiones convergentes (porque no admite subsucesiones de Cauchy).
]

#observacion[Qué mirar en el Ejemplo 6.6][
  En el espacio $M$ de las sucesiones eventualmente nulas con la distancia $d_oo$, el conjunto cerrado, acotado y no compacto es $K = B[0, 1]$, no $M$: el espacio $M$ ni siquiera es acotado, porque $b^N = (N, 0, 0, dots) in M$ cumple $d_oo (b^N, 0) = N$. La sucesión testigo $(a^m)_(m in NN)$, con $a_n^m = 1$ si $n = m$ y $0$ si no, vive en $K$ y cumple $d_oo (a^k, a^m) = 1$ para todo $k != m$.

  - *Por qué ninguna subsucesión es de Cauchy.* Una subsucesión es $(a^(m_j))_(j in NN)$ con $m_1 < m_2 < dots$. Los términos $a^(m_j)$ y $a^(m_l)$ no son dos subsucesiones distintas, sino los términos en las posiciones $j$ y $l$ de la misma subsucesión. Si $j != l$, entonces $m_j != m_l$, y por lo tanto $d_oo (a^(m_j), a^(m_l)) = 1$. Con $epsilon = 1 / 2$ ningún $J$ sirve, porque $d_oo (a^(m_J), a^(m_(J + 1))) = 1$. Como toda sucesión convergente es de Cauchy, ninguna subsucesión converge, y $K$ no es compacto. Lo que se usa es que los índices de una subsucesión sean distintos: si se pudieran repetir, $a^1, a^1, dots$ sería de Cauchy.
  - *La sucesión tampoco converge*, porque es subsucesión de sí misma (con $m_j = j$). La vuelta es falsa: $(-1)^n$ no converge pero tiene subsucesiones convergentes. Por eso, para negar la compacidad hace falta que _ninguna_ subsucesión converja.
  - *Moraleja*: en general vale compacto $==>$ cerrado y acotado (Proposición 6.3), pero no la vuelta. Heine-Borel (Teorema 6.5) es propio de $(RR^m, d_2)$.
]

#v(10pt)

== Bloque 5 · Compacidad y funciones continuas: encajes de compactos

#sublema(titulo: "Qué desbloquea")[
  La imagen continua de un compacto es compacta, y por lo tanto cerrada. Con eso y el *Ejercicio 5* de la Práctica 5 (en un compacto, todo encaje decreciente de cerrados no vacíos tiene intersección no vacía) el ejemplo de este bloque prueba que $f$ "conmuta" con intersecciones decrecientes de compactos, y de ahí fabrica un compacto invariante $K = inter_n f^n (X)$. La maniobra central --- tomar $x_n in A_n$ con $f(x_n) = y$, extraer una subsucesión convergente en $A_1$ y ver que el límite queda en *todos* los $A_n$ porque cada cola de la subsucesión vive en $A_n$ cerrado --- es la que piden el *Ejercicio 11* (una función continua y positiva en un compacto está acotada lejos de $0$) y el *Ejercicio 13* (biyección continua desde un compacto es homeomorfismo: la imagen de un cerrado es compacta, luego cerrada). También cierra la "vuelta" pendiente del Bloque 3.

  El mismo principio (imagen continua de compacto es compacta, luego cerrada y acotada) es el que está detrás del *Ejercicio 2* (un compacto no vacío de $RR$ es cerrado y acotado, así que contiene a su supremo y a su ínfimo) y del *Ejercicio 8* ($d(x, dot.c)$ es continua, así que su imagen del compacto $K$ es un compacto de $RR$ y tiene mínimo). La cuenta con colas sirve también para el *Ejercicio 9*: se toma una sucesión que realice el ínfimo de $hat(d)(A, B)$ y se pasa al límite en el compacto $A$. El *Ejercicio 12* usa la misma idea en versión "compacto más colas controladas". El ítem (b) es además un primer contacto con las iteradas $f^n$ que aparecen en el *Ejercicio 17*.
]

#ejemplo[$f$ continua conmuta con intersecciones decrecientes de compactos; compacto invariante $f(K) = K$ (Clase 8 · Ejercicio 2)][C8-2][
  Sean $X$ e $Y$ espacios métricos y sea $f : X -> Y$ continua.

  #set enum(numbering: "a)")
  + Supongamos que $(A_n)_n subset.eq X$ es una familia de compactos con $A_n supset.eq A_(n + 1)$ para todo $n$. Probar que
    $ f(inter.big_n A_n) = inter.big_n f(A_n). $
  + Si $X = Y$ es compacto, probar que existe $K subset.eq X$ compacto no vacío tal que $f(K) = K$.
]

#estrategia[Un $y$ en todas las imágenes tiene preimágenes $x_n in A_n$; la subsucesión convergente de $(x_n)_n$ cae en cada $A_j$ porque sus colas viven en $A_j$ cerrado][
  La inclusión $f(inter A_n) subset.eq inter f(A_n)$ vale siempre. Para la otra, dado $y in inter f(A_n)$ se elige $x_n in A_n$ con $f(x_n) = y$; los $x_n$ están en el compacto $A_1$, así que una subsucesión converge a algún $x$. Como $n_k >= k$, la cola $(x_(n_(k + j)))_k$ está en $A_(j + 1)$, que es cerrado, y entonces $x in A_(j + 1)$ para todo $j$. Por continuidad, $f(x) = lim f(x_(n_k)) = y$. Para (b), se aplica (a) a $A_n = f^n (X)$, que decrecen porque $f(X) subset.eq X$; el Ejercicio 5 de la Práctica 5 garantiza que la intersección no es vacía.
]

#resolucion[
  *a)* Siempre $f(inter.big_n A_n) subset.eq inter.big_n f(A_n)$. Veamos la otra contención. Supongamos $A_n != emptyset$ para todo $n$; en caso contrario, $f(inter.big_n A_n) = inter.big_n f(A_n) = emptyset$. Por el Ejercicio 5 de la Práctica 5 (aplicado en el compacto $A_1$, del que los $A_n$ son cerrados), $inter.big_n A_n != emptyset$. Además, como $f$ es continua, $f(A_n)$ es compacto, y por lo tanto cerrado, para todo $n$, y $f(A_n) supset.eq f(A_(n + 1))$; de nuevo por el Ejercicio 5 (ahora en $f(A_1)$), $inter.big_n f(A_n) != emptyset$.

  Sea $y in inter.big_n f(A_n)$. Entonces para todo $n$ existe $x_n in A_n$ tal que $y = f(x_n)$. Como $x_n in A_n subset.eq A_1$, $(x_n)_n subset.eq A_1$, y como $A_1$ es compacto existe $(x_(n_k))_k$ con $x_(n_k) -> x in A_1$. Si vemos que $x in A_n$ para todo $n$, resultará $y = f(x_(n_k)) -> f(x)$, o sea $f(x) = y$ e $y in f(inter.big_n A_n)$.

  Dado que $x_(n_k) in A_(n_k)$ para todo $k$, y que $n_k >= k$:
  - $x in A_1$, pues $(x_(n_k))_k subset.eq A_1$ y $A_1$ es cerrado.
  - $x in A_2$, pues $x_(n_(k + 1)) in A_(n_(k + 1)) subset.eq A_(k + 1) subset.eq A_2$ para todo $k in NN$; como $x_(n_(k + 1)) -> x$ y $A_2$ es cerrado, $x in A_2$.
  - En general, $x_(n_(k + j)) in A_(n_(k + j)) subset.eq A_(k + j) subset.eq A_(j + 1)$ para todo $k in NN$, y $x_(n_(k + j)) -> x$ cuando $k -> +oo$. Como $A_(j + 1)$ es cerrado, $x in A_(j + 1)$.

  Probamos que $x in A_(j + 1)$ para todo $j in NN_0$, es decir, $x in inter.big_n A_n$.

  *b)* Sea $A_n = f^n (X)$. Como $f$ es continua y $X$ compacto, cada $A_n$ es compacto. Además $f(X) subset.eq X$, por lo tanto
  $ A_(n + 1) = f^(n + 1) (X) = f^n (f(X)) subset.eq f^n (X) = A_n. $
  Sea $K = inter.big_(n >= 1) A_n$. Por el ítem (a), $f(K) = inter.big_n f(A_n)$, y por otro lado
  $ inter.big_n f(A_n) = inter.big_n f(f^n (X)) = inter.big_n f^(n + 1) (X) = inter.big_(n = 2)^(+oo) A_n =^((*)) inter.big_(n = 1)^(+oo) A_n = K, $
  donde $(*)$ es porque $inter.big_(n = 1)^(+oo) A_n subset.eq inter.big_(n = 2)^(+oo) A_n$ por definición, y $inter.big_(n = 2)^(+oo) A_n subset.eq A_1 inter inter.big_(n = 2)^(+oo) A_n = inter.big_(n = 1)^(+oo) A_n$ ya que $A_n subset.eq A_1$ para todo $n$. Así $f(K) = K$. Resta ver que $K$ es compacto y no vacío: los $A_n$ son cerrados no vacíos con $A_n supset.eq A_(n + 1)$, así que por el Ejercicio 5 de la Práctica 5, $K != emptyset$; y $K$ es compacto porque es cerrado y está contenido en el compacto $X$.
]

#sublema(titulo: "Corrección al manuscrito")[
  El original escribe "sea $K = inter_n f(A_n)$. Lo que probamos es que $inter_n f(A_n) = f(K)$", pero el ítem (a) da $inter_n f(A_n) = f(inter_n A_n)$, no $f(K)$: con esa definición, $f(K) = K$ no sale directamente. La cuenta igual se puede cerrar: la cadena de igualdades muestra $K = inter_n f(A_n) = inter_n A_n$, y recién entonces el ítem (a) da $f(K) = f(inter_n A_n) = inter_n f(A_n) = K$; el manuscrito deja implícito este último paso. Arriba se definió directamente $K = inter_(n >= 1) f^n (X)$, que evita el rodeo.
]

#ejemplo[Una función continua y periódica es uniformemente continua (Clase del 27/10/2026 · Ejemplo 2)][27-10/2][
  Una función $f : RR -> RR$ se dice _periódica_ si
  $ exists T > 0 "tal que" forall x in RR, quad f(x + T) = f(x). $

  Sea $f : RR -> RR$ continua y periódica. Probar que $f$ es uniformemente continua.
]

#estrategia[Ojo: uniformemente continua en cada pedazo no alcanza][
  $f(x) = x^2$ es uniformemente continua en el intervalo $[k, k + 1]$ con $k in ZZ$, porque $[k, k + 1]$ es compacto y $x^2$ es continua, entonces es uniformemente continua en ese compacto (Teorema 6.17). ¡Pero! No es uniformemente continua en
  $ RR = union.big_(k in ZZ) [k, k + 1]. $
]

#resolucion[
  En particular, $f$ también "se repite hacia atrás": aplicando la definición en el punto $x - T$,
  $ f(x) = f((x - T) + T) = f(x - T) quad "para todo " x in RR. $
  Más en general,
  $ f(x + k T) = f(x) quad "para todo " x in RR, k in ZZ, $
  que se ve por inducción (no hace falta demostrarlo en el ejercicio).

  Sea $epsilon > 0$. Queremos ver que existe $delta > 0$ tal que
  $ forall x, y in RR, quad abs(x - y) < delta => abs(f(x) - f(y)) < epsilon. $

  Como $f|_([0, T])$ (la restricción de $f$ al intervalo $[0, T]$) es uniformemente continua, pues $[0, T]$ es compacto (Teorema 6.17), entonces
  $ exists delta_0 > 0 "tal que" forall x, y in [0, T], quad abs(x - y) < delta_0 => abs(f(x) - f(y)) < epsilon / 2. $

  Una observación antes de seguir: los intervalos $[k, k + 1)$ con $k in ZZ$ parten a la recta,
  $ RR = union.big_(k in ZZ) [k, k + 1). $
  Si $x in RR$, aplicando esto a $x / T$ existe $k in ZZ$ tal que
  $ k <= x / T < k + 1 => k T <= x < (k + 1) T. $
  Es decir, también los intervalos de largo $T$ parten a la recta:
  $ RR = union.big_(k in ZZ) [k T, (k + 1) T). $

  Tomo $delta = min{delta_0, T}$. Sean $x, y in RR$ con $abs(x - y) < delta$. Por la observación, existe $k in ZZ$ tal que $x - k T in [0, T)$. Llamemos
  $ tilde(x) = x - k T, quad tilde(y) = y - k T. $
  Notemos que $abs(tilde(x) - tilde(y)) = abs(x - y) < delta$, y que $f(tilde(x)) = f(x)$, $f(tilde(y)) = f(y)$ por la periodicidad. Así que alcanza con ver que $abs(f(tilde(x)) - f(tilde(y))) < epsilon$.

  _(Paso reconstruido.)_ Podemos suponer $x <= y$ (si no, intercambiamos los roles de $x$ e $y$, que no cambia ni $abs(x - y)$ ni $abs(f(x) - f(y))$). Entonces $0 <= tilde(x) <= tilde(y) < tilde(x) + delta <= tilde(x) + T < 2 T$, es decir, $tilde(y) in [0, 2 T)$.

  Tenemos dos casos:

  + $tilde(y) in [0, T]$. Como $tilde(x), tilde(y) in [0, T]$ y $abs(tilde(x) - tilde(y)) < delta <= delta_0$,
    $ abs(f(tilde(x)) - f(tilde(y))) < epsilon / 2 < epsilon. $

  + $tilde(y) in.not [0, T]$, es decir, $tilde(y) in (T, 2 T)$. Entonces $tilde(x) < T < tilde(y)$, y el punto $T$ queda entre los dos:
    $ tilde(x) < T < tilde(y) < tilde(x) + T < 2 T. $
    #block(breakable: false, width: 100%)[#align(center)[
      #cetz.canvas({
        import cetz.draw: *
        let rojo = rgb("#dc2626")
        let azul = rgb("#2563eb")
        let gris = luma(120)
        line((-0.6, 0), (8.8, 0), stroke: 0.8pt, mark: (end: ">"))
        content((9.1, 0), $RR$)
        // [0, T] resaltado
        line((0, 0), (4, 0), stroke: 2.5pt + azul.lighten(60%))
        content((2, 0.45), text(fill: azul, size: 8pt)[$[0, T]$])
        for (xx, l) in ((0, $0$), (4, $T$), (6.6, $tilde(x) + T$), (8, $2 T$)) {
          line((xx, -0.12), (xx, 0.12), stroke: 0.8pt)
          content((xx, -0.45), text(size: 9pt, l))
        }
        for (xx, l) in ((2.6, $tilde(x)$), (5.2, $tilde(y)$)) {
          circle((xx, 0), radius: 0.07, fill: rojo, stroke: none)
          content((xx, -0.45), text(fill: rojo, size: 9pt, l))
        }
        // |x~ - y~| < delta
        bezier((2.6, 0.15), (5.2, 0.15), (3.9, 1.0), stroke: 0.7pt + rojo)
        content((3.9, 0.85), text(fill: rojo, size: 8pt)[$< delta <= delta_0$])
        // y~ trasladado un período
        circle((1.2, 0), radius: 0.07, fill: gris, stroke: none)
        content((1.2, -0.45), text(fill: gris, size: 9pt)[$tilde(y) - T$])
        bezier((5.2, -0.75), (1.2, -0.75), (3.2, -1.6), stroke: (paint: gris, dash: "dashed", thickness: 0.7pt), mark: (end: ">"))
        content((3.2, -1.45), text(fill: gris, size: 8pt)[$- T$])
      })
    ]]
    Por un lado, $T, tilde(x) in [0, T]$ y $abs(tilde(x) - T) <= abs(tilde(x) - tilde(y)) < delta_0$, así que
    $ abs(f(tilde(x)) - f(T)) < epsilon / 2. $
    Por otro lado, $tilde(y)$ no está en $[0, T]$, pero $tilde(y) - T$ sí, y $abs((tilde(y) - T) - 0) <= abs(tilde(y) - tilde(x)) < delta_0$. Usando la periodicidad, $f(T) = f(0)$ y $f(tilde(y)) = f(tilde(y) - T)$, así que
    $ abs(f(T) - f(tilde(y))) = abs(f(0) - f(tilde(y) - T)) < epsilon / 2. $
    Por lo tanto
    $ abs(f(tilde(x)) - f(tilde(y))) & <= abs(f(tilde(x)) - f(T)) + abs(f(T) - f(tilde(y))) \
      & < epsilon / 2 + epsilon / 2 = epsilon. $

  En los dos casos, $abs(f(x) - f(y)) = abs(f(tilde(x)) - f(tilde(y))) < epsilon$, y como $delta$ no depende de $x$ ni de $y$, $f$ es uniformemente continua.
]

#v(10pt)

== Bloque 6 · Compacidad y punto fijo

#sublema(titulo: "Qué desbloquea")[
  El ejemplo de este bloque termina invocando el *teorema de punto fijo de Banach* (una contracción de un espacio métrico completo tiene un único punto fijo), que `guias/p5.typ` da por conocido pero no enuncia ni demuestra: los *Ejercicios 15, 16 y 17* de la Práctica 5 lo usan o preguntan qué falla cuando no se cumplen sus hipótesis, y el *Ejercicio 14* es la observación de que el conjunto de puntos fijos de una continua es cerrado. El único ejercicio de punto fijo anterior en las guías era el Ej. 7 de la Práctica 1 de 2025 (anexo de `guias/p1.typ`), que es de otra naturaleza (monotonía, sin métrica). Lo que sí enseña este ejemplo, y sirve para los *Ejercicios 18 y 19*, es la conexión compacidad $arrow$ punto fijo: en un compacto, "achicar distancias" alcanza, aunque el argumento del manuscrito para conseguir una constante $alpha < 1$ tiene un hueco (ver la corrección al final). La idea que sí funciona es la de esa corrección: *minimizar $g(x) = d(x, f(x))$ en un compacto* y ver que el mínimo es $0$; en el Ejercicio 18, $g(x) = d_2 (x, f(x))$ es continua en el compacto $overline(B)(0, M)$ y su ínfimo ahí es $0$. Como contraste con el *Ejercicio 16* ($f(x) = x \/ 3$ en $RR without {0}$, contracción en un espacio no completo): en este ejemplo no hay contracción, pero sí compacidad (que implica completitud).
]

#ejemplo[En un compacto, una función que achica distancias tiene un único punto fijo (Clase 8 · Ejercicio 1)][C8-1][
  Sea $K$ compacto. Si $f : K -> K$ cumple que $d(f(x), f(y)) < d(x, y)$ para todo $x != y$ en $K$, entonces $f$ posee un único punto fijo $a in K$.
]

#estrategia[Intentar reducir a Banach: usar la compacidad para conseguir $alpha < 1$][
  La idea es similar a la del teorema de punto fijo de Banach: considerar $x_n = f^n (x)$, ver que $x_n -> x_0 in K$ y $f(x_0) = x_0$. Esa demostración usa $d(f(x), f(y)) <= alpha d(x, y)$ con $0 <= alpha < 1$. ¿Cómo usar que acá sólo tenemos "$alpha = 1$"? El manuscrito intenta probar que la compacidad *fuerza* la existencia de un $alpha < 1$: si no, hay pares $(x_n, y_n)$ con $d(f(x_n), f(y_n)) >= (1 - 1 \/ n) d(x_n, y_n)$; se extraen subsucesiones convergentes (anidadas, como en C7-1) a $x, y$, y se pasa al límite para obtener $d(x, y) <= d(f(x), f(y)) < d(x, y)$. Como $K$ compacto es completo, Banach termina.
]

#resolucion[
  Veamos que _existe $0 <= alpha < 1$ tal que $d(f(x), f(y)) < alpha d(x, y)$_. Si no existiera, para todo $n in NN$ existen $x_n, y_n in K$ tales que
  $ d(f(x_n), f(y_n)) >= (1 - 1/n) d(x_n, y_n). quad (1) $
  Como $K$ es compacto, existe $(x_(n_k))_k$ convergente en $K$. De nuevo usamos la compacidad para hallar $(y_(n_(k_j)))_j$ convergente en $K$; en particular $(x_(n_(k_j)))_j$ converge en $K$. Sean $x, y in K$ con $x_(n_(k_j)) -> x$, $y_(n_(k_j)) -> y$. Como
  $ d(f(x_(n_(k_j))), f(y_(n_(k_j)))) &<= d(f(x_(n_(k_j))), f(x)) + d(f(x), f(y)) + d(f(y), f(y_(n_(k_j)))) \
    &<= d(x_(n_(k_j)), x) + d(f(x), f(y)) + d(y, y_(n_(k_j))), $
  tomando límite concluimos que
  $ lim_(j -> oo) d(f(x_(n_(k_j))), f(y_(n_(k_j)))) <= d(f(x), f(y)) < d(x, y). quad (2) $
  Por otro lado, de $(1)$ sale que
  $ (1 - 1/n) d(x_n, y_n) <= d(f(x_n), f(y_n)), $
  y como $lim_(n -> oo) (1 - 1 \/ n) d(x_n, y_n) = d(x, y)$ (a lo largo de la subsucesión $n_(k_j)$), queda
  $ d(x, y) <= d(f(x), f(y)). quad (3) $
  Combinando $(2)$ y $(3)$,
  $ d(x, y) <= d(f(x), f(y)) < d(x, y), $
  que es absurdo. Entonces existe $0 <= alpha < 1$ tal que $d(f(x), f(y)) < alpha d(x, y)$. Como $K$ es compacto, es completo; por lo tanto podemos usar el teorema de punto fijo de Banach para concluir que $f$ tiene un único punto fijo.

  _Nota del docente._ La prueba anterior se basó en probar que $F : K times K -> RR$, $F(x, y) = d(f(x), f(y)) - d(x, y)$, tiene un máximo negativo. Esto sale de que $K times K$ es compacto con $d_oo$ (C7-1) y de que, para esta métrica, $F$ es continua.
]

#sublema(titulo: [Corrección al manuscrito: el argumento tiene un hueco, y el $alpha < 1$ no siempre existe])[
  En $(2)$, la desigualdad "$d(f(x), f(y)) < d(x, y)$" necesita $x != y$, pero los límites $x$ e $y$ de las subsucesiones pueden coincidir; en ese caso $(2)$ y $(3)$ dicen $0 <= 0$ y no hay absurdo. (El manuscrito además escribe la hipótesis como "para todo $x, y in K$", que en $x = y$ es imposible.) Y el resultado intermedio es falso en general: $f(x) = sin x$ en $K = [0, 1]$ cumple $abs(sin x - sin y) < abs(x - y)$ para $x != y$, pero $abs(sin x - sin 0) \/ abs(x - 0) -> 1$ cuando $x -> 0^+$, así que no hay ningún $alpha < 1$. Otro, con la cuenta a la vista: $f(x) = x - x^2 \/ 2$ en $K = [0, 1]$ cumple $abs(f(x) - f(y)) = abs(x - y) (1 - (x + y) \/ 2) < abs(x - y)$ para $x != y$, pero el factor $1 - (x + y) \/ 2$ tiende a $1$ cuando $x, y -> 0$. Lo mismo le pasa a la nota del docente: $F(x, x) = 0$, de modo que el máximo de $F$ es $0$, no negativo. (Detalle menor: en la cadena de desigualdades antes de $(2)$, el segundo paso es "$<=$" y no "$<$", porque la hipótesis estricta sólo vale para puntos distintos y puede ser $x_(n_(k_j)) = x$, $y_(n_(k_j)) = y$; así quedó escrito arriba.)

  La conclusión del ejercicio sí es cierta (es el teorema de Edelstein): el camino estándar, que no está en el manuscrito, es minimizar la función continua $g(x) = d(x, f(x))$ en el compacto $K$ ($f$ es continua porque $d(f(x), f(y)) <= d(x, y)$) y ver que el mínimo tiene que valer $0$. Si el punto de mínimo $x_0$ no fuera fijo, el punto $x_1 = f(x_0) != x_0$ cumpliría
  $ g(x_1) = d(x_1, f(x_1)) = d(f(x_0), f(x_1)) < d(x_0, x_1) = g(x_0), $
  absurdo. La unicidad sí sale como en Banach: dos puntos fijos distintos $a != b$ darían $d(a, b) = d(f(a), f(b)) < d(a, b)$.
]

#v(10pt)

== Bloque 7 · Cubrimientos por abiertos

#sublema(titulo: "Qué desbloquea")[
  La Definición 6.11 de `apuntes.typ` introduce los *cubrimientos por abiertos* y los *subcubrimientos*. El ejemplo de este bloque fija las ideas con dos cubrimientos de intervalos de $RR$: en $(0, 1)$ se puede descartar infinitos abiertos y seguir cubriendo, pero no quedarse con finitos; en $[0, 1]$, en cambio, alcanza con *finitos*, porque un abierto que contiene al $0$ ya absorbe a todos los $U_n$ salvo finitos. Es la antesala de la caracterización de compacidad por cubrimientos. Ningún ejercicio de `guias/p5.typ` pide trabajar con cubrimientos, así que el bloque es conceptual.
]

#ejemplo[Cubrimientos por abiertos de $(0, 1)$ y de $[0, 1]$ (Ejemplo 6.12)][44][
  #set enum(numbering: "a)")
  + Sea $K = (0, 1) subset.eq (RR, abs(dot))$ y sean $U_n = (1 \/ n, 1)$ con $n in NN$. Entonces los $U_n$ forman un cubrimiento por abiertos de $K$, y ${U_(2 k)}_(k in NN)$ es un subcubrimiento.
  + Sea $K = [0, 1] subset.eq (RR, abs(dot))$ y sean $U_n = (1 \/ n, 1)$ con $n in NN$. Esto no es un cubrimiento de $K$, pero agregando $(-epsilon, epsilon)$ y $(1 - epsilon, 1 + epsilon)$ sí, y además se puede extraer un subcubrimiento _finito_.
]

#resolucion[
  *a)* Los $U_n$ son todos abiertos y
  $ (0, 1) = union.big_(n in NN) U_n = union.big_(n = 1)^infinity (1 / n, 1), $
  por lo tanto tenemos un cubrimiento por abiertos.

  Si sacamos algunos, por ejemplo si tomamos ${U_(2 k)}_(k in NN)$ (es decir, nos quedamos con los abiertos de índice par) entonces tenemos un subcubrimiento, dado que
  $ (0, 1) = union.big_(k = 1)^infinity (1 / (2 k), 1). $

  *b)* Los $U_n$ no forman un cubrimiento de $K$: el $0$ y el $1$ no están en ninguno de estos abiertos. Para tener un cubrimiento, tomemos $epsilon > 0$ y agreguemos los abiertos $(-epsilon, epsilon)$ (que cubre al $0$) y $(1 - epsilon, 1 + epsilon)$ (que cubre al $1$). Entonces la familia ${(-epsilon, epsilon), (1 - epsilon, 1 + epsilon), U_n : n in NN}$ es un cubrimiento por abiertos.

  Notemos que tenemos muchos abiertos redundantes. Como $epsilon > 0$, a partir de algún $n_0$ voy a tener que $1 \/ n_0 < epsilon$ y por lo tanto los intervalos $(1 \/ n, 1)$ no van a agregar ningún punto nuevo que no esté cubierto por los intervalos $(-epsilon, epsilon)$ y $(1 \/ n_0, 1)$.

  #align(center)[
    #cetz.canvas({
      import cetz.draw: *
      let rojo = rgb("#dc2626")
      let azul = rgb("#2563eb")
      // Recta real
      line((-3.5, 0), (7.5, 0), stroke: 0.8pt, mark: (end: ">"))
      content((7.9, 0), $RR$)
      // K = [0, 1], con 0 en x = 0 y 1 en x = 6
      line((0, 0), (6, 0), stroke: 2pt + azul)
      content((0, 0.05), text(fill: azul, size: 13pt)[$[$])
      content((6, 0.05), text(fill: azul, size: 13pt)[$]$])
      content((3, -0.45), text(fill: azul)[$K$])
      content((0, -0.85), $0$)
      content((6, -0.85), $1$)
      // (-ε, ε)
      line((-1.2, 0.9), (1.2, 0.9), stroke: 1pt + rojo)
      content((-1.2, 0.9), text(fill: rojo, size: 13pt)[$($])
      content((1.2, 0.9), text(fill: rojo, size: 13pt)[$)$])
      content((0, 1.3), text(fill: rojo, size: 8pt)[$(-epsilon, epsilon)$])
      content((-1.2, -0.4), text(size: 8pt)[$-epsilon$])
      content((1.2, -0.4), text(size: 8pt)[$epsilon$])
      line((1.2, 0), (1.2, 0.9), stroke: (paint: luma(150), dash: "dotted", thickness: 0.5pt))
      // (1/n_0, 1)
      line((0.6, 2.0), (6, 2.0), stroke: 1pt + rojo)
      content((0.6, 2.0), text(fill: rojo, size: 13pt)[$($])
      content((6, 2.0), text(fill: rojo, size: 13pt)[$)$])
      content((3.3, 2.4), text(fill: rojo, size: 8pt)[$(1 \/ n_0, 1)$])
      line((0.6, 0), (0.6, 2.0), stroke: (paint: luma(150), dash: "dotted", thickness: 0.5pt))
      content((0.6, -0.4), text(size: 8pt)[$1 \/ n_0$])
    })
  ]

  Esto me dice que puedo tomar un subcubrimiento _finito_: podemos tomar el subcubrimiento
  $ {(-epsilon, epsilon), (1 - epsilon, 1 + epsilon), U_n : n = 1, dots, n_0}, $
  y tenemos que
  $ [0, 1] = (-epsilon, epsilon) union (1 - epsilon, 1 + epsilon) union union.big_(n = 1)^(n_0) U_n. $
]

#ejemplo[Un compacto dentro de un abierto: un mismo radio para todos los puntos (Clase del 27/10/2026 · Ejemplo 1)][27-10/1][
  Sean $(E, d)$ un espacio métrico y $K subset.eq E$ compacto. Si $U subset.eq E$ es abierto tal que $K subset.eq U$, probar que
  $ exists r > 0 : forall x in K, quad B(x, r) subset.eq U. $
]

#estrategia[Dos trampas: un radio que depende del punto, y el ínfimo de los radios][
  Lo importante del enunciado es que el radio tiene que valer *para todo* $x in K$.

  Una primera idea (que *no funciona*): sea $x in K subset.eq U$. Como $x$ está en un abierto, existe $r > 0$ tal que $B(x, r) subset.eq U$. El problema es que elegimos $r > 0$ a partir de $x$, y nosotros queremos un $r$ que funcione *para todo* $x in K$. Lo que obtuvimos es en realidad un $r_x$: un radio distinto para cada punto. Es decir, tenemos $forall x in K, exists r_x > 0$, y el ejercicio pide invertir los cuantificadores: $exists r > 0, forall x in K$.

  Una vez que tenemos los $r_x$, uno estaría tentado a tomar
  $ r = inf {r_x / 2 : x in K}, $
  que tampoco funciona, porque _podría_ ser $0$. Como no tenemos control sobre la forma en la que se generan los $r_x$, esto no vale, ya que un radio debe ser mayor que $0$.

  La salida es usar la compacidad para quedarse con *finitos* radios, y tomar el mínimo.
]

#resolucion[
  Reescribamos lo anterior haciendo explícita la dependencia del radio:
  $ forall x in K, exists r_x > 0 "tal que" B(x, r_x / 2) subset.eq B(x, r_x) subset.eq U. $
  Para cubrir a $K$ serviría cualquier radio (cada $x$ está en su propia bola), pero nos conviene usar $r_x / 2$: la otra mitad es el margen que vamos a necesitar al final. Entonces
  $ K subset.eq union.big_(x in K) B(x, r_x / 2). $

  Como $K$ es compacto y ${B(x, r_x / 2)}_(x in K)$ es un cubrimiento por abiertos de $K$, sabemos que existe un subcubrimiento finito (Teorema 6.13, $1 => 3$). Por lo tanto, existen $x_1, x_2, dots, x_N in K$ tales que
  $ K subset.eq union.big_(i = 1)^N B(x_i, r_(x_i) / 2) subset.eq U. $

  #align(center)[
    #cetz.canvas({
      import cetz.draw: *
      let rojo = rgb("#dc2626")
      let azul = rgb("#2563eb")
      let verde = rgb("#059669")
      // Intervalo abierto (a, b) a altura h, con su centro marcado
      let intervalo(a, b, h, color) = {
        line((a, h), (b, h), stroke: 1pt + color)
        content((a, h), text(fill: color, size: 12pt)[$($])
        content((b, h), text(fill: color, size: 12pt)[$)$])
        line(((a + b) / 2, 0), ((a + b) / 2, h), stroke: (paint: luma(170), dash: "dotted", thickness: 0.5pt))
        circle(((a + b) / 2, 0), radius: 0.06, fill: black, stroke: none)
      }
      // U = (-1, 9.5)
      line((-1.8, 0), (10.3, 0), stroke: 0.8pt, mark: (end: ">"))
      line((-1, -0.05), (9.5, -0.05), stroke: 5pt + verde.lighten(70%))
      content((-1, 0), text(fill: verde, size: 12pt)[$($])
      content((9.5, 0), text(fill: verde, size: 12pt)[$)$])
      content((9.5, -0.5), text(fill: verde)[$U$])
      // K = [0, 8]
      line((0, 0), (8, 0), stroke: 2pt + azul)
      content((0, 0.03), text(fill: azul, size: 12pt)[$[$])
      content((8, 0.03), text(fill: azul, size: 12pt)[$]$])
      content((4.75, -0.5), text(fill: azul)[$K$])
      // B(x_i, r_(x_i) / 2), alternando alturas
      intervalo(-0.5, 0.5, 0.6, rojo)
      intervalo(0.4, 2.6, 1.1, rojo)
      intervalo(2.3, 4.7, 0.6, rojo)
      intervalo(4.5, 7.5, 1.1, rojo)
      intervalo(7.25, 8.75, 0.6, rojo)
      content((0, -0.5), text(size: 8pt)[$x_1$])
      content((1.5, -0.5), text(size: 8pt)[$x_2$])
      content((3.5, -0.5), text(size: 8pt)[$x_3$])
      content((6, -0.5), text(size: 8pt)[$x_4$])
      content((8, -0.5), text(size: 8pt)[$x_5$])
      content((3.5, 1.45), text(fill: rojo, size: 8pt)[$B(x_i, r_(x_i) \/ 2)$])
    })
  ]
  En la recta: finitos intervalos $B(x_i, r_(x_i) / 2)$ alcanzan para cubrir $K$. Cada uno tiene un radio distinto, y $r$ es la mitad del más chico de los $r_(x_i)$.

  Ahora sí, tomamos
  $ r = min_(1 <= i <= N) {r_(x_i) / 2}. $
  A diferencia del ínfimo de la trampa, este es un mínimo sobre *finitos* números positivos, así que $r > 0$.

  Sea $x in K$. Queremos ver que $B(x, r) subset.eq U$. Dado $y in B(x, r)$, si bien no sabemos si $y in K$, sabemos que $x in K$. Como $x in K$, existe $1 <= j <= N$ tal que
  $ x in B(x_j, r_(x_j) / 2). $
  Por la desigualdad triangular,
  $ d(y, x_j) <= d(y, x) + d(x, x_j). $
  Como $y in B(x, r)$, tenemos $d(y, x) < r <= r_(x_j) / 2$; y como $x in B(x_j, r_(x_j) / 2)$, tenemos $d(x, x_j) < r_(x_j) / 2$. Entonces
  $ d(y, x_j) < r_(x_j) / 2 + r_(x_j) / 2 = r_(x_j). $
  Por lo tanto $y in B(x_j, r_(x_j)) subset.eq U$. Como $y in B(x, r)$ era arbitrario, $B(x, r) subset.eq U$; y como $x in K$ era arbitrario, el mismo $r$ sirve para todo $x in K$.

  #block(breakable: false, width: 100%)[#align(center)[
    #cetz.canvas({
      import cetz.draw: *
      let rojo = rgb("#dc2626")
      let azul = rgb("#2563eb")
      let verde = rgb("#059669")
      let xj = (0, 0)
      let x = (0.7, 0)
      let y = (1.1, 0.69)
      // U
      circle((0.2, 0), radius: (3.3, 2.7), fill: verde.lighten(88%), stroke: 0.8pt + verde)
      content((3.0, 2.0), text(fill: verde)[$U$])
      // B(x_j, r_(x_j)) y B(x_j, r_(x_j) / 2)
      circle(xj, radius: 2, stroke: (paint: rojo, dash: "dashed", thickness: 0.8pt))
      circle(xj, radius: 1, stroke: 1pt + rojo)
      content((0, 2.3), text(fill: rojo, size: 8pt)[$B(x_j, r_(x_j))$])
      content((-0.3, -1.3), text(fill: rojo, size: 8pt)[$B(x_j, r_(x_j) \/ 2)$])
      // B(x, r)
      circle(x, radius: 0.9, stroke: 1pt + azul, fill: azul.transparentize(80%))
      content((1.05, -0.55), text(fill: azul, size: 7pt)[$B(x, r)$])
      // Segmentos de la desigualdad triangular
      line(xj, x, stroke: 0.9pt)
      line(x, y, stroke: 0.9pt)
      line(xj, y, stroke: (paint: black, dash: "dotted", thickness: 0.9pt))
      for (pt, l, d) in ((xj, $x_j$, (-0.2, -0.25)), (x, $x$, (0.05, -0.25)), (y, $y$, (0.2, 0.1))) {
        circle(pt, radius: 0.05, fill: black, stroke: none)
        content((pt.at(0) + d.at(0), pt.at(1) + d.at(1)), text(size: 9pt, l))
      }
    })
  ]]
  $ underbrace(d(x, x_j) < r_(x_j) / 2, "porque " x in B(x_j, r_(x_j) / 2)) quad quad underbrace(d(y, x) < r <= r_(x_j) / 2, "porque " y in B(x, r)) $
  En el plano: $x$ cae en la bola chica de algún centro $x_j$, y $y$ está a menos de $r <= r_(x_j) \/ 2$ de $x$. Las dos mitades suman $r_(x_j)$, así que $y$ no puede salirse de la bola grande $B(x_j, r_(x_j)) subset.eq U$.
]

#sublema(titulo: "Por qué hace falta la compacidad (agregado)")[
  Sin compacidad el resultado falla, y el ínfimo de los radios efectivamente da $0$. Tomemos $K = U = (0, 1) subset.eq (RR, abs(dot))$: $U$ es abierto y $K subset.eq U$, pero $K$ no es compacto. Para cada $x in K$, el radio más grande con $B(x, r_x) subset.eq U$ es $r_x = min{x, 1 - x}$, y
  $ inf_(x in K) r_x = 0. $
  No hay ningún $r > 0$ uniforme: si $0 < x < r$, entonces $B(x, r)$ contiene puntos negativos, que no están en $U$.

  #align(center)[
    #cetz.canvas({
      import cetz.draw: *
      let rojo = rgb("#dc2626")
      let azul = rgb("#2563eb")
      line((-0.8, 0), (9, 0), stroke: 0.8pt, mark: (end: ">"))
      line((0, 0), (8, 0), stroke: 2pt + azul)
      content((0, 0.03), text(fill: azul, size: 12pt)[$($])
      content((8, 0.03), text(fill: azul, size: 12pt)[$)$])
      content((0, -0.5), $0$)
      content((8, -0.5), $1$)
      content((5.5, -0.5), text(fill: azul)[$K = U$])
      // B(x, r_x) con r_x = x, para x = 1/2, 1/4, 1/10, 1/25
      for (i, (xx, lbl)) in ((4, $1 \/ 2$), (2, $1 \/ 4$), (0.8, $1 \/ 10$), (0.32, $1 \/ 25$)).enumerate() {
        let h = 0.5 + 0.45 * i
        line((0.03, h), (2 * xx - 0.03, h), stroke: 1pt + rojo)
        content((0, h), text(fill: rojo, size: 10pt)[$($])
        content((2 * xx, h), text(fill: rojo, size: 10pt)[$)$])
        circle((xx, h), radius: 0.05, fill: rojo, stroke: none)
        content((2 * xx + 0.25, h), text(fill: rojo, size: 7pt)[$x = lbl$], anchor: "west")
      }
    })
  ]
  Cuanto más cerca de $0$ está $x$, más chico tiene que ser $r_x$ para que $B(x, r_x)$ no se salga de $U$: los radios se achican hasta $0$.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

#sublema(titulo: "Huecos frente a la Práctica 5")[
  Sin ejemplo transcripto todavía: el *Ej. 2* (un compacto de $RR$ tiene máximo y mínimo), el *Ej. 8* (la distancia a un compacto se realiza), el *Ej. 9* ($hat(d)(A, B) > 0$ para compacto y cerrado disjuntos), el *Ej. 12* (continuidad uniforme en $RR$ con límites nulos en $plus.minus oo$) y, salvo por la conexión conceptual del Bloque 6, todo el tramo de *punto fijo* (Ej. 14--19): en particular no hay ningún ejemplo de verificar que una función es una contracción (Ej. 15) ni de usar iteradas $f^n$ (Ej. 17).

  Los Ejercicios 4 y 5 de `clases/punto_fijo.typ` (`C8-4`: un normado es Banach si y sólo si las Cauchy de la esfera unitaria convergen; `C8-5`: una transformación lineal es continua si y sólo si manda sucesiones nulas en sucesiones acotadas) no son de compacidad: pertenecen a completitud (Práctica 3, Ej. 14--16) y a operadores lineales (Práctica 6, Ej. 8), y están cargados en `ejemplos/p6.typ`.
]
