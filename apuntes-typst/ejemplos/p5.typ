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
    Compacidad y puntos fijos
  ]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

Los ejemplos están agrupados por *técnica*, no por orden de transcripción, y los bloques siguen el orden en que la guía los necesita. Cada bloque abre con la nota de qué ejercicios de `guias/p5.typ` desbloquea.

La pestaña dice de dónde viene cada ejemplo: un *número* es el ejemplo de `notas_materia.pdf` (con su numeración por capítulo entre paréntesis en el título) y *`C{clase}-{ejemplo}`* es un ejercicio resuelto en clase, transcrito en `clases/` (un archivo por tema; la tabla clase $arrow$ archivo está en la skill `ejemplo`) --- `C7-1` es el Ejercicio 1 de `clases/compactos.typ` y `C9-3` es el Ejercicio 3 de `clases/punto_fijo.typ`. El Ejercicio 2 de la Clase 9 tiene dos ítems que sirven en bloques distintos, así que va partido en `C9-2a` y `C9-2b`.

#v(6pt)

#show table.cell.where(y: 0): set text(fill: white, weight: "bold", size: 8.5pt)

#table(
  columns: (0.35fr, 2.4fr, 1.1fr),
  align: (center + horizon, left + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#065f46") } else if calc.even(y) { rgb("#f8fafc") } else { white },
  stroke: 0.4pt + rgb("#cbd5e1"),
  inset: (x: 6pt, y: 4pt),

  [*\#*], [*Bloque*], [*Desbloquea*],
  [1], [Compacidad por sucesiones: productos y sucesiones convergentes], [p5: Ej. 1 (es C7-2 con $x_n = 1\/n$), 3, 6, 7],
  [2], [Compactos, cerrados e intersecciones], [p5: Ej. 4 (es la ida de C7-3), 5, 9],
  [3], [Compacidad y funciones continuas: imagen y $K = inter.big_n f^n (X)$], [p5: Ej. 2, 8, 11, 13; conceptual para Ej. 12],
  [4], [Bolas cerradas no compactas en espacios de funciones], [p5: Ej. 10],
  [5], [Puntos fijos sin contracción estricta], [p5: Ej. 21, 22; contraste con Ej. 14, 15, 16, 17],
)

#v(4pt)

#text(size: 9pt, fill: rgb("#64748b"))[
  La numeración de ejercicios es la de la *guía 2025* (`guias/p5.typ`).
]

#v(8pt)

== Bloque 1 · Compacidad por sucesiones: productos y sucesiones convergentes

#sublema(titulo: "Qué desbloquea")[
  *Definición (Clase 7).* Un espacio métrico $K$ es _compacto_ si para toda sucesión $(x_n)_(n in NN) subset.eq K$ existe alguna subsucesión $(x_(n_k))_(k in NN)$ convergente a algún $x in K$. Un subconjunto de un espacio métrico es compacto si lo es con la métrica inducida.

  Toda la Práctica 5 arranca con esta definición, y los dos ejemplos del bloque son las dos maniobras básicas para probar compacidad "a mano", por sucesiones. C7-2 es *literalmente el Ejercicio 1* ($K = {0} union {1\/n : n in NN}$ es $(x_n)_n union {x}$ con $x_n = 1\/n$ y $x = 0$): la clave es que una sucesión en $(x_n)_n union {x}$ no tiene por qué ser una subsucesión de $(x_n)_n$, y la división en casos "finitos valores / infinitos valores" es la misma que necesita el *Ejercicio 7* (unión finita de compactos: alguno de los finitos compactos contiene infinitos términos) y el *Ejercicio 6* (compactos de un espacio discreto). C7-1 (producto finito de compactos con $d_oo$) enseña a extraer subsucesiones *coordenada a coordenada, anidadas*, con el error típico de usar el mismo subíndice para ambas coordenadas señalado en la clase; es la herramienta del *Ejercicio 3* ($S$ y $P$ son imágenes de $K times K$ por la suma y el producto, que son continuas) y reaparece en C9-1 (Bloque 5), donde se extrae una sub-subsucesión de $(x_n, y_n)_n$.
]

#ejemplo[Producto finito de compactos con $d_oo$ (Clase 7 · Ejercicio 1)][C7-1][
  Mostrar que dados finitos espacios compactos ${(K_i, d_i)}_(1 <= i <= n)$, su producto $product_(i = 1)^n K_i$ con la métrica
  $ d_oo ((x_1, dots, x_n), (y_1, dots, y_n)) := op("máx")_(1 <= i <= n) d_i (x_i, y_i) $
  es compacto.
]

#estrategia[Dos factores primero, subsucesión dentro de subsucesión, y después inducción][
  Con $d_oo$ una sucesión del producto converge si y sólo si convergen todas sus coordenadas. La tentación es extraer una subsucesión convergente de cada coordenada por separado y "juntarlas", pero las subsucesiones pueden usar índices distintos (pares en una, impares en la otra). Lo correcto es *anidar*: se extrae una subsucesión convergente de la primera coordenada y, *sobre esos índices*, otra de la segunda; la primera coordenada sigue convergiendo porque una subsucesión de una convergente converge. Eso prueba $n = 2$, y para $n$ factores se hace inducción agrupando los primeros $n$ en un solo compacto.
]

#resolucion[
  Vamos a probar por definición. Querríamos probar que dada una sucesión $(x_k^1, x_k^2, dots, x_k^n)_k subset.eq product_(i = 1)^n K_i$, la misma admite alguna subsucesión convergente. Esto se puede hacer, pero nos estamos complicando de más. Lo que vamos a hacer es probar el resultado para el caso $n = 2$ y después hacer inducción, siguiendo una estrategia similar a la que hicimos en su momento para probar que la unión de $n$ cerrados es cerrada.

  Observemos entonces que en el caso $n = 2$ este espacio es conocido: es el espacio producto con la métrica $d_oo$ del que hablamos varias veces. Pasamos entonces a probar el resultado, por definición.

  Sea $(x_n, y_n)_(n in NN) subset.eq K_1 times K_2$. Queremos encontrar alguna subsucesión convergente $(x_(n_k), y_(n_k))_k$. Recordemos que una sucesión en este espacio es convergente si y sólo si todas sus coordenadas lo son.

  Una primera estrategia entonces sería quizás extraer una subsucesión convergente $(x_(n_k))_k$ de $(x_n)_n$ (cosa que podemos hacer por ser $K_1$ compacto) y extraer otra subsucesión convergente $(y_(n_k))_k$ de $(y_n)_n$ y considerar $(x_(n_k), y_(n_k))_k$. _Pero esto está mal._ ¿Por qué? Porque estamos asumiendo que las subsucesiones son las mismas. Fíjense que podría ser el caso que la subsucesión convergente de $(x_n)_n$ sea $(x_(2n))_n$, y la de $(y_n)_n$ fuera $(y_(2n + 1))_n$, y en ese caso no habría forma de quedarse con una subsucesión de $(x_n, y_n)_n$ que tome valores pares en el subíndice de la primera coordenada e impares en el subíndice de la segunda. El error vino de tomar el mismo subíndice $k$ para ambas subsucesiones, y es común, así que tengan cuidado.

  Hay que hacer algo un poco más refinado: vamos a tomar una subsucesión convergente de la primera coordenada y _sobre esos índices_ vamos a tomar una subsucesión convergente de la segunda coordenada. Lo escribimos. Sea $(x_n, y_n)_(n in NN) subset.eq K_1 times K_2$ una sucesión. Como $(x_n)_n subset.eq K_1$ está contenida dentro de un compacto, $(x_n)_n$ admite una subsucesión $(x_(n_k))_k$ convergente. Ahora $(y_(n_k))_k subset.eq K_2$ es una sucesión contenida en un compacto, y por lo tanto admite una subsucesión $(y_(n_(k_j)))_j$ convergente. Además, $(x_(n_(k_j)))_j$ es una subsucesión de $(x_(n_k))_k$, que era convergente, y por lo tanto es convergente. Por lo tanto, como ambas coordenadas convergen, $(x_(n_(k_j)), y_(n_(k_j)))_j$ es una sub-sub-sucesión convergente, y en particular una subsucesión convergente, como queríamos encontrar. Esto prueba el caso $n = 2$.

  Procedemos ahora por inducción. Supongamos que el producto de $n$ compactos es compacto. Queremos ver que el producto de $n + 1$ compactos es compacto. Sean $K_1, dots, K_(n + 1)$ compactos. Tenemos que
  $ product_(i = 1)^(n + 1) K_i = product_(i = 1)^n K_i times K_(n + 1). $
  Esto es un producto de dos compactos, ya que el primer factor es compacto por hipótesis inductiva. Como ya probamos que el producto de dos compactos es compacto, esto concluye la inducción. (Hay un detalle acá, y es que habría que probar que el producto es asociativo, pero bueno...)

  _Nota_: el "detalle" es que la igualdad de arriba es una identificación: $(x_1, dots, x_(n + 1)) |-> ((x_1, dots, x_n), x_(n + 1))$ es una isometría entre $op("máx")_(1 <= i <= n + 1) d_i$ y la $d_oo$ del producto de dos factores, porque $op("máx")(op("máx")_(1 <= i <= n) d_i, d_(n + 1)) = op("máx")_(1 <= i <= n + 1) d_i$; por eso basta el caso de dos factores.

  _Comentario de la clase_: vale la vuelta (si el producto es compacto, cada factor lo es), pero las herramientas llegan después.
]

#ejemplo[Una sucesión convergente junto con su límite es un compacto (Clase 7 · Ejercicio 2)][C7-2][
  Sea $X$ un espacio métrico, $(x_n)_n subset.eq X$ una sucesión convergente con límite $x$. Probar que el conjunto $(x_n)_n union {x}$ es un compacto (con la métrica inducida por la de $X$).
]

#estrategia[Una sucesión en el conjunto no es una subsucesión: separar "finitos valores" de "infinitos valores"][
  Una sucesión $(y_n)_n$ dentro de ${x_n} union {x}$ puede repetir términos, ir para atrás o quedarse quieta en $x$: no es una subsucesión de $(x_n)_n$. Si toma finitos valores, alguno se repite infinitas veces y da una subsucesión constante (convergente). Si toma infinitos valores distintos, se puede elegir una subsucesión $y_(n_k) = x_(K_k)$ con $K_k$ estrictamente creciente, que es a la vez subsucesión de $(y_n)_n$ y de $(x_n)_n$, y entonces tiende a $x$, que está en el conjunto. Es exactamente el Ejercicio 1 de la guía con $x_n = 1\/n$ y $x = 0$.
]

#resolucion[
  Vamos, una vez más, por definición. Sea $(y_n)_n subset.eq (x_n)_n union {x}$ una sucesión. Ojo que acá esta sucesión no tiene por qué ser una subsucesión de $(x_n)_n$: podría esta sucesión por ejemplo consistir en sólo el primer término de $(x_n)_n$, o sólo $x$. Queremos ver entonces que $(y_n)_n$ admite alguna subsucesión convergente. Dividimos en dos casos.

  Si $(y_n)_n$ toma sólo finitos valores ${y_(j_1), y_(j_2), dots, y_(j_n)}$, entonces alguno de estos valores debe ocurrir infinitas veces. Esto es, hay algún $j_i$ tal que para todo $k$ existe $n >= k$ tal que $y_(n_k) = y_(j_i)$. Tomando la subsucesión $(y_(n_k))_k$ (que es constante) se obtiene lo pedido.

  _Nota_: en la fuente se mezclan los índices $n$ y $n_k$; lo que se quiere decir es que para todo $k$ existe $n_k >= k$ (con $n_k > n_(k - 1)$, para que sea subsucesión) tal que $y_(n_k) = y_(j_i)$, lo cual es posible porque el valor $y_(j_i)$ aparece infinitas veces.

  Si $(y_n)_n$ toma infinitos valores distintos, inductivamente para cada $k$ debe haber algún $n_k >= k$, $n_k >= n_(k - 1)$ tal que $y_(n_k) = x_(K_k)$ para cierto $K_k >= k$, $K_k >= K_(k - 1)$. Si no ven por qué que $(y_n)_n$ tome infinitos valores distintos implica lo que digo, ahí vamos, pero primero veamos que esto termina el problema: si $y_(n_k) = x_(K_k)$, entonces $(y_(n_k))_k$ es efectivamente una subsucesión de $(y_n)_n$, pero además es una subsucesión de $(x_n)_n$, y una subsucesión de una sucesión convergente es convergente. Además, $y_(n_k)$ tiende a $x$, que está en nuestro conjunto.

  Sobre la otra afirmación, es cuestión de ver los cuantificadores: supongamos que no, entonces hay algún $k in NN$ para el cual no hay ningún $n$ y $K_k$ tal que $y_n = x_(K_k)$. Esto significa que el conjunto ${y_n : n >= k, n_(k - 1)}$ no interseca al conjunto ${x_K : K >= k, K_(k - 1)}$, y por lo tanto está incluido en su complemento, que es finito, lo cual es absurdo.

  _Nota_: las desigualdades $n_k >= n_(k - 1)$ y $K_k >= K_(k - 1)$ deben ser estrictas para que haya subsucesiones (se puede, porque en cada paso se descartan finitos términos); "no hay ningún $n$ y $K_k$" quiere decir que no hay $n >= op("máx"){k, n_(k - 1)}$ ni $K >= op("máx"){k, K_(k - 1)}$ con $y_n = x_K$, y el "complemento" es dentro de $(x_n)_n union {x}$, o sea ${x_1, dots, x_(K - 1)} union {x}$ con $K = op("máx"){k, K_(k - 1)}$, que es finito; el absurdo es que la cola ${y_n : n >= op("máx"){k, n_(k - 1)}}$ de una sucesión con infinitos valores distintos también toma infinitos valores distintos y no cabe en un conjunto finito.
]

== Bloque 2 · Compactos, cerrados e intersecciones

#sublema(titulo: "Qué desbloquea")[
  Acá entran las dos relaciones básicas entre compactos y cerrados: *un compacto es cerrado* y *un cerrado dentro de un compacto es compacto*. El *Ejercicio 4* ($inter.big_i F_i$ con todos cerrados y uno compacto) es exactamente la "ida" de C7-3 ($F$ cerrado $=>$ $K inter F$ compacto), que la clase deja como ejercicio de la guía y no resuelve; lo que sí resuelve es la *vuelta*, por contrarrecíproco, construyendo el compacto $K = {x_n} union {lim x_n}$ de C7-2 a partir de una sucesión de $F$ que converge fuera de $F$. Esa construcción es el modelo para negar compacidad: basta exhibir una sucesión cuyas subsucesiones convergen todas a un punto que *no* está en el conjunto.

  C9-2a (continuidad y compactos decrecientes: $f(inter.big_n A_n) = inter.big_n f(A_n)$) usa como herramienta el *Ejercicio 5* (encaje decreciente de cerrados no vacíos en un compacto tiene intersección no vacía; la clase lo cita como "ejercicio 5 de la práctica 5") y muestra cómo se explota en la práctica: el límite de una subsucesión $x_(n_k) in A_(n_k)$ cae en *todos* los $A_j$ porque, a partir de $k >= j$, la cola de la subsucesión vive en el cerrado $A_j$. Esa cuenta con colas es también lo que pide el *Ejercicio 9* ($hat(d)(A, B) > 0$ para $A$ compacto y $B$ cerrado disjuntos: se toma una sucesión que realice el ínfimo y se pasa al límite en $A$).
]

#ejemplo[$F$ es cerrado si y sólo si $K inter F$ es compacto para todo compacto $K$ (Clase 7 · Ejercicio 3)][C7-3][
  Sea $X$ un espacio métrico. Mostrar que $F subset.eq X$ es cerrado si y sólo si para todo compacto $K$, $K inter F$ es compacto.
]

#estrategia[La vuelta por contrarrecíproco: un "para todo" se refuta con un ejemplo][
  Si $F$ no es cerrado, hay una sucesión $(x_n)_n subset.eq F$ que converge a un $x in.not F$. El compacto a elegir es $K = {x_n} union {x}$ (C7-2): entonces $K inter F = {x_n}$, y ninguna subsucesión de $(x_n)_n$ puede converger dentro de $K inter F$ porque todas convergen a $x$ (unicidad del límite). La ida ($F$ cerrado $=>$ $K inter F$ compacto) es el Ejercicio 4 de la guía y la clase la deja como tal.
]

#resolucion[
  La ida es un ejercicio de la guía. Para la vuelta, casi siempre cuando uno quiere probar un "para todo" conviene probar por contrarrecíproco. La ventaja es que cuando neguemos el enunciado vamos a tener que probar un "existe", y eso en principio es más fácil porque se puede hacer por construcción. Veamos: supongamos que $F$ no es cerrado, queremos ver entonces que hay algún compacto $K$ tal que $K inter F$ no es compacto. Como estamos trabajando con sucesiones, nos va a convenir usar la caracterización de cerrado por sucesiones: un conjunto $F$ es cerrado si y sólo si para toda sucesión convergente $(x_n)_n subset.eq F$, $lim_(n -> oo) x_n in F$. Un conjunto $F$ entonces no es cerrado si hay una cierta sucesión convergente $(x_n)_n subset.eq F$ tal que $lim_(n -> oo) x_n in.not F$. ¿Qué compacto vamos a tomar entonces?
  $ K = {x_n} union {lim_(n -> oo) x_n}. $
  Tenemos entonces que $K inter F = {x_n}$, que no es un compacto, pues la sucesión $(x_n)_n$ no tiene ninguna subsucesión convergente (en $K inter F$).

  _Nota_: $K$ es compacto por C7-2; la igualdad $K inter F = {x_n}$ usa que $x := lim_(n -> oo) x_n in.not F$ y que $(x_n)_n subset.eq F$; y que $(x_n)_n$ no tenga subsucesiones convergentes _en $K inter F$_ sale de la unicidad del límite: toda subsucesión converge en $X$ a $x in.not K inter F$, así que ninguna converge a un punto de $K inter F$, y $K inter F$ no es compacto por sucesiones.
]

#ejemplo[Imagen continua de una intersección decreciente de compactos (Clase 9 · Ejercicio 2 (a))][C9-2a][
  Sean $X$ e $Y$ espacios métricos y sea $f : X -> Y$ continua. Supongamos que $(A_n)_n subset.eq X$ es una familia de compactos con $A_n supset.eq A_(n + 1)$ para todo $n$. Probar que
  $ f (inter.big_n A_n) = inter.big_n f(A_n). $
]

#estrategia[La contención difícil: preimágenes $x_n in A_n$ de un mismo $y$, subsucesión en $A_1$ y colas en cada $A_j$][
  $f(inter A_n) subset.eq inter f(A_n)$ vale para cualquier función. Para la otra, dado $y$ en todos los $f(A_n)$ se eligen $x_n in A_n$ con $f(x_n) = y$; todos viven en el compacto $A_1$, así que hay una subsucesión $x_(n_k) -> x$. Como $n_k >= k$, la cola $(x_(n_(k + j)))_k$ está en el cerrado $A_(j + 1)$, y entonces $x in A_(j + 1)$ para todo $j$. Por continuidad, $f(x) = lim f(x_(n_k)) = y$. El Ejercicio 5 de la guía garantiza de paso que las intersecciones no son vacías.
]

#resolucion[
  Siempre $f(inter.big_n A_n) subset.eq inter.big_n f(A_n)$. Veamos la otra contención. Supongamos que $A_n != emptyset$ para todo $n$; caso contrario, $f(inter.big_n A_n) = inter.big_n f(A_n) = emptyset$. Por el ejercicio 5 de la práctica 5, $inter.big_n A_n != emptyset$. Además, como $f$ es continua, $f(A_n)$ es compacto, y por lo tanto cerrado, para todo $n$, y verifica que $f(A_n) supset.eq f(A_(n + 1))$. De nuevo por el ejercicio 5 de la práctica 5, $inter.big_n f(A_n) != emptyset$. Sea $y in inter.big_n f(A_n)$. Entonces, para todo $n$, existe $x_n in A_n$ tal que $y = f(x_n)$. Como $x_n in A_n subset.eq A_1$, tenemos que $(x_n)_n subset.eq A_1$. Como $A_1$ es compacto, existe $(x_(n_k))_k$ tal que $x_(n_k) -> x$, $x in A_1$. Si vemos que $x in A_n$ para todo $n$, resultaría que $y = f(x_(n_k)) -> f(x) = y$, por lo tanto $y in f(inter.big_n A_n)$. Dado que para todo $k$, $x_(n_k) in A_(n_k)$, tenemos que

  - $x in A_1$, pues $x_(n_k) in A_(n_k) subset.eq A_1$ y entonces $(x_(n_k)) subset.eq A_1$ para todo $k$. Por lo tanto $x_(n_k) -> x in A_1$ ($A_1$ es cerrado).

  - $x in A_2$, pues $x_(n_2) in A_(n_2) subset.eq A_2$ (usamos que $n_k >= k$ para todo $k$). Como $x_(n_k) in A_(n_k)$ para todo $k$, resulta que $x_(n_(k + 1)) in A_(n_(k + 1)) subset.eq A_(k + 1) subset.eq A_2$ para todo $k in NN$. Dado que $x_(n_(k + 1)) -> x$ y $A_2$ es cerrado, $x in A_2$.

  - En general, $x_(n_(k + j)) in A_(n_(k + j)) subset.eq A_(k + j) subset.eq A_(j + 1)$ para todo $k in NN$. Por lo tanto $x_(n_(k + j)) -> x$ cuando $k -> +oo$. Como $A_(j + 1)$ es cerrado, $x in A_(j + 1)$.

  Probamos que para todo $j in NN_0$, $x in A_(j + 1)$. Concluimos que $x in inter.big_n A_n$.
]

== Bloque 3 · Compacidad y funciones continuas: imagen y $K = inter.big_n f^n (X)$

#sublema(titulo: "Qué desbloquea")[
  El principio que organiza la segunda mitad de la parte de compacidad es: *la imagen continua de un compacto es compacta*, y en consecuencia es cerrada y acotada. De ahí salen el *Ejercicio 2* (un compacto no vacío de $RR$ tiene máximo y mínimo, aplicado a la identidad), el *Ejercicio 11* (una $f : E -> (0, +oo)$ continua en un compacto tiene mínimo positivo: $f(E)$ es compacto dentro de $(0, +oo)$), el *Ejercicio 8* (la distancia a un compacto se realiza: $d(x, dot.c)$ es continua) y el *Ejercicio 13* ($f$ continua y biyectiva de un compacto es homeomorfismo: $f$ manda cerrados, que son compactos, en compactos, que son cerrados). El *Ejercicio 12* usa la misma idea en versión "compacto más colas controladas".

  C9-2b itera una $f : X -> X$ continua en un compacto: los $A_n = f^n (X)$ forman una cadena decreciente de compactos (imagen continua de compacto, y $f(X) subset.eq X$), y C9-2a permite meter $f$ dentro de la intersección para obtener un compacto no vacío $K$ con $f(K) = K$. Es un modelo de cómo se combinan "imagen continua de compacto", "cerrado dentro de compacto es compacto" y el Ejercicio 5 en una sola cuenta, y además prepara la lectura de $f^n$ del *Ejercicio 17*.
]

#ejemplo[Un compacto invariante: $K = inter.big_n f^n (X)$ cumple $f(K) = K$ (Clase 9 · Ejercicio 2 (b))][C9-2b][
  Sea $X$ un espacio métrico compacto y $f : X -> X$ continua. Probar que existe $K subset.eq X$ compacto no vacío tal que $f(K) = K$.
]

#estrategia[Iterar $f$ y usar el ítem (a) con $A_n = f^n (X)$][
  Como $f(X) subset.eq X$, las imágenes iteradas decrecen: $f^(n + 1)(X) = (f^n compose f)(X) subset.eq f^n (X)$, y cada una es compacta por ser imagen continua de un compacto. Con $K = inter.big_n A_n$, el ítem (a) da $f(K) = inter.big_n f(A_n) = inter.big_(n >= 2) A_n$, y la cadena decreciente hace que quitar el primer término no cambie la intersección. $K$ es no vacío por el Ejercicio 5 de la guía y compacto por ser cerrado dentro del compacto $X$.
]

#resolucion[
  Sea $A_n = f^n (X)$. Como $f$ es continua y $X$ compacto, para todo $n$, $A_n$ es compacto. Además, $f(X) subset.eq X$, por lo tanto para todo $n$,
  $ A_(n + 1) = f^(n + 1) (X) = (f^n compose f)(X) subset.eq f^n (X) = A_n. $
  Por el ítem (a), $inter.big_n f(A_n) = f(inter.big_n A_n)$. Sea $K = inter.big_n f(A_n)$. Lo que probamos es que $inter.big_n f(A_n) = f(K)$. Por otro lado,
  $ inter.big_n f(A_n) &= inter.big_n (f compose f^n)(X) = inter.big_n f^(n + 1) (X) \
    &= inter.big_(n = 2)^(+oo) A_n limits(=)^((*)) inter.big_(n = 1)^(+oo) A_n = K, $
  donde $(*)$ es porque $inter.big_(n = 1)^(+oo) A_n subset.eq inter.big_(n = 2)^(+oo) A_n$ por definición, y $inter.big_(n = 2)^(+oo) A_n subset.eq inter.big_(n = 1)^(+oo) A_n = A_1 inter inter.big_(n = 2)^(+oo) A_n$ ya que $A_n subset.eq A_1$ para todo $n$. Resta ver que $K$ es compacto. Los $A_n$ son cerrados no vacíos y $A_n supset.eq A_(n + 1)$ para todo $n$. Por el ejercicio 5 de la práctica 5, $K != emptyset$. Además es compacto, porque es cerrado y está contenido en un compacto. Concluimos que $K$ cumple lo que pide el ejercicio.

  _Nota_: con $K = inter.big_n f(A_n)$ la cadena anterior muestra $K = inter.big_n A_n$, y entonces el ítem (a) da $f(K) = f(inter.big_n A_n) = inter.big_n f(A_n) = K$, que es lo que se quería; el manuscrito deja implícito este último paso.
]

== Bloque 4 · Bolas cerradas no compactas en espacios de funciones

#sublema(titulo: "Qué desbloquea")[
  En $RR^n$, cerrado y acotado equivale a compacto; en espacios de funciones no. El *Ejercicio 10* pide ver que $overline(B)(f_0, 1)$ en $(C[0, 1], d_oo)$ es cerrada y acotada pero no compacta. C9-3 trae la maniobra en $cal(C)(RR, [0, 1])$: construir, a partir de cerrados disjuntos de $RR$, una familia de funciones continuas a valores en $[0, 1]$ *a distancia $>= 1$ entre sí*. Una sucesión de ellas no puede tener subsucesiones de Cauchy, así que tampoco convergentes, y eso refuta la compacidad de la bola cerrada (la "Nota del manuscrito" al final del ejemplo hace exactamente esto con $f_n = f_({n})$). Para la bola de $C[0, 1]$ hay que fabricar una sucesión del mismo tipo dentro de $[0, 1]$ (por ejemplo con soportes disjuntos que se acumulan), y la cuenta de la norma es la misma.

  El resultado principal de C9-3 (no hay denso numerable) es más fuerte que lo que pide la guía y usa una familia *no numerable* de bolas abiertas disjuntas, indexada por $cal(P)(NN)$; es la generalización del Ejercicio 17 de la Práctica 2 y vale la pena tenerla como modelo de "separabilidad" en espacios de funciones.
]

#ejemplo[$cal(C)(RR, [0, 1])$ con $d_oo$ no tiene un denso numerable, y $overline(B)(0, 1)$ no es compacta (Clase 9 · Ejercicio 3)][C9-3][
  Sea $cal(C)(RR, [0, 1]) = {f : RR -> [0, 1] : f "es continua"}$, con $d_oo$. Probar que no existe un subconjunto denso numerable en $cal(C)(RR, [0, 1])$.
]

#estrategia[Una familia no numerable de bolas disjuntas no cabe en un espacio con denso numerable][
  Si $Y$ es denso y contable, cada abierto no vacío contiene un punto de $Y$, y abiertos disjuntos contienen puntos distintos: una familia de abiertos no vacíos disjuntos se inyecta en $Y$ y es contable. Para refutar la separabilidad alcanza entonces con exhibir *no numerables* abiertos no vacíos disjuntos. Se consigue con funciones $f_S$ ($S subset.eq NN$) que valen $0$ en $S$ y $1$ en $NN without S$ (existen por el Ejercicio 11 de la Práctica 4, versión de Urysohn para cerrados disjuntos de $RR$): dos distintas están a distancia $>= 1$, así que las bolas $B(f_S, 1\/2)$ son disjuntas, y hay tantas como $cal(P)(NN)$.
]

#resolucion[
  La idea es usar la siguiente generalización del ejercicio 17 de la práctica 2:

  Sea $(X, d)$ espacio métrico. Supongamos que existe $Y subset.eq X$ contable con $overline(Y) = X$. Si ${U_i}_(i in I)$ es una familia de abiertos tales que

  I) $\# U_i >= 1$ para todo $i in I$,

  II) $U_i inter U_j = emptyset$ si $i != j$,

  entonces $I$ es contable.

  _Nota_: en I) el manuscrito escribe "$\# U_i > 1$" (o "$>= 1$": la raya se confunde con el renglón); lo que se usa es que $U_i != emptyset$.

  Construyamos una familia de abiertos ${U_i}_(i in I)$ de $cal(C)(RR, [0, 1])$ que cumpla I) y II). Por el ejercicio 11 de la práctica 4, dados dos cerrados $A, B subset.eq RR$, no vacíos y disjuntos, existe $f : RR -> [0, 1]$ tal que $f|_A = 0$ y $f|_B = 1$. Sea $S subset.eq NN$. Si $A = S$ y $B = NN - S$, sea $f_S : RR -> [0, 1]$ tal que $f_S|_S = 0$ y $f_S|_(NN - S) = 1$. Notemos que:

  - Si $S, S' subset.eq NN$ y $S != S'$, entonces existe $x in S without S'$ o $x in S' without S$. Supongamos sin pérdida de generalidad que ocurre el primer caso. Entonces $f_S (x) = 0$ y $f_(S') (x) = 1$, por lo tanto
    $ abs(f_S (x) - f_(S') (x)) = abs(1 - 0) = 1 <= norm(f_S - f_(S'))_oo. quad (*) $

  - Si $I = cal(P)(NN)$, resulta que $I$ no es contable, por lo tanto si $U_S = B(f_S, 1\/2)$, la familia de abiertos ${U_S}_(S in I)$ es una _familia de abiertos no vacíos, disjuntos, no contable_.

  Concluimos que $cal(C)(RR, [0, 1])$ no admite un subconjunto denso contable.

  _Nota_: si $S = emptyset$ o $S = NN$, uno de los cerrados es vacío y el ejercicio 11 de la práctica 4 no aplica; en esos casos sirven las constantes $f_emptyset equiv 1$ y $f_NN equiv 0$, y $(*)$ sigue valiendo.

  _Nota del manuscrito_: la misma idea muestra que $overline(B)(0, 1)$ _no es compacta_. Si definimos $S_n = {n}$, $f_n = f_(S_n)$, entonces $(f_n)_n subset.eq overline(B)(0, 1)$ y no admite subsucesiones convergentes, pues si $(f_(n_k))_k$ es una subsucesión de $(f_n)_n$, por $(*)$, para $k != k'$,
  $ norm(f_(n_k) - f_(n_(k')))_oo = norm(f_(S_(n_k)) - f_(S_(n_(k'))))_oo >= 1, $
  y entonces no podría ser de Cauchy, y por lo tanto tampoco convergente.

  _Nota_: en la igualdad anterior el manuscrito escribe $f_(S_k)$ y $f_(S_(k'))$; es $f_(n_k) = f_(S_(n_k))$, y la conclusión no cambia.
]

== Bloque 5 · Puntos fijos sin contracción estricta

#sublema(titulo: "Qué desbloquea")[
  Los *Ejercicios 14 a 22* giran alrededor del teorema de punto fijo de Banach: una contracción ($d(f(x), f(y)) <= alpha d(x, y)$ con $alpha < 1$) en un espacio *completo* tiene un único punto fijo, que es el límite de las iteradas $f^n (x)$. C9-1 estudia qué pasa cuando sólo se tiene $d(f(x), f(y)) < d(x, y)$ (sin $alpha$) pero el espacio es *compacto*: sigue habiendo un único punto fijo. Es el modelo de los *Ejercicios 21 y 22* (puntos fijos sin contracción, por compacidad: en el 22, $f : [a, b] -> [a, b]$ continua, y en el 21, la condición $d_2 (x, f(x)) < epsilon$ en una bola de $RR^n$), donde la idea que funciona es la de la nota al final del ejemplo: *minimizar $g(x) = d(x, f(x))$ en el compacto* y ver que el mínimo es $0$. La unicidad sale siempre directamente de la desigualdad estricta.

  Como contraste sirve para los *Ejercicios 15, 16 y 17*: en el 16 ($f(x) = x\/3$ en $RR without {0}$) hay contracción pero el espacio no es completo; en C9-1 no hay contracción pero sí compacidad (que implica completitud), y el contraejemplo $f(x) = x - x^2 \/ 2$ en $[0, 1]$ de la nota muestra que $d(f(x), f(y)) < d(x, y)$ *no* implica contracción. La maniobra de extraer una sub-subsucesión de $(x_n, y_n)_n$ es la de C7-1. El *Ejercicio 14* (los puntos fijos forman un cerrado) es el hecho que se usa implícitamente al pasar al límite en $f(x_n) = x_n$.
]

#ejemplo[$d(f(x), f(y)) < d(x, y)$ en un compacto da un único punto fijo (Clase 9 · Ejercicio 1)][C9-1][
  Sea $K$ compacto. Si $f : K -> K$ cumple que $d(f(x), f(y)) < d(x, y)$ para todo $x, y in K$ (con $x != y$), entonces $f$ posee un único punto fijo $a in K$.
]

#estrategia[El manuscrito intenta fabricar un $alpha < 1$ por compacidad y reducirse a Banach][
  La idea del manuscrito es que la hipótesis "sin $alpha$" se puede mejorar a una contracción genuina usando la compacidad: si no hubiera $alpha < 1$, habría pares $(x_n, y_n)$ con $d(f(x_n), f(y_n)) >= (1 - 1\/n) d(x_n, y_n)$, se extrae una sub-subsucesión convergente (como en C7-1) y se llega a $d(x, y) <= d(f(x), f(y)) < d(x, y)$. Después, como compacto implica completo, se aplica Banach. *Ojo:* el argumento tiene un hueco (ver la nota al final: nada impide $x = y$); la prueba que sí funciona minimiza $d(x, f(x))$ en $K$.
]

#resolucion[
  La idea es similar a la del teorema de punto fijo de Banach: considerar $x_n = f^n (x)$, ver que $x_n -> x_0 in K$, y $f(x_0) = x_0$. Esa demostración usa que $d(f(x), f(y)) < alpha d(x, y)$ con $0 <= alpha < 1$. ¿Cómo podemos usar que $alpha = 1$? Veamos que _existe $0 <= alpha < 1$ tal que $d(f(x), f(y)) < alpha d(x, y)$_. Si no existiera $alpha$ como se pide, para todo $n in NN$, existen $(x_n)_n, (y_n)_n$ en $K$ tales que
  $ d(f(x_n), f(y_n)) >= (1 - 1/n) d(x_n, y_n). quad (1) $
  Como $K$ es compacto, existe $(x_(n_k))_k$ convergente en $K$. De nuevo usamos la compacidad para hallar $(y_(n_(k_j)))_j$ convergente en $K$. En particular, $(x_(n_(k_j)))_j$ converge en $K$. Supongamos que $x, y in K$ son tales que $x_(n_(k_j)) -> x$, $y_(n_(k_j)) -> y$. Como
  $ d(f(x_(n_(k_j))), f(y_(n_(k_j)))) &<= d(f(x_(n_(k_j))), f(x)) + d(f(x), f(y)) + d(f(y), f(y_(n_(k_j)))) \
    &< d(x_(n_(k_j)), x) + d(f(x), f(y)) + d(y, y_(n_(k_j))), $
  tomando límite concluimos que
  $ lim_(j -> +oo) d(f(x_(n_(k_j))), f(y_(n_(k_j)))) <= d(f(x), f(y)) < d(x, y). quad (2) $
  Por otro lado, de $(1)$ sale que
  $ (1 - 1/n) d(x_n, y_n) <= d(f(x_n), f(y_n)) <= d(f(x), f(y)). $
  Como $lim_(n -> +oo) (1 - 1/n) d(x_n, y_n) = d(x, y)$, queda
  $ d(x, y) <= d(f(x), f(y)). quad (3) $
  Combinando $(2)$ y $(3)$:
  $ d(x, y) <= d(f(x), f(y)) < d(x, y), $
  que es absurdo. Entonces existe $0 <= alpha < 1$ tal que $d(f(x), f(y)) < alpha d(x, y)$. Como $K$ es compacto, es completo, por lo tanto podemos usar el teorema de punto fijo de Banach para concluir que $f$ tiene un único punto fijo.

  _Nota del manuscrito_: la prueba anterior se basó en probar que $F : K times K -> RR$, $F(x, y) = d(f(x), f(y)) - d(x, y)$ tiene un máximo negativo; esto saldría de que $K times K$ es compacto con $d_oo$ y de que $F$ es continua para esa métrica.
]

#sublema(titulo: "Nota: el argumento del manuscrito tiene un hueco")[
  La hipótesis (y las desigualdades estrictas de la resolución) deben leerse para $x != y$. En $(2)$ el manuscrito escribe el lado izquierdo sin el límite, y en $(3)$ omite los índices de la subsucesión: la desigualdad $d(f(x_n), f(y_n)) <= d(f(x), f(y))$ sólo tiene sentido como límite a lo largo de $(n_(k_j))_j$.

  Más importante: *el argumento tiene un hueco*, porque nada garantiza que los límites $x$ e $y$ sean distintos, y si $x = y$ el paso "$d(f(x), f(y)) < d(x, y)$" de $(2)$ no vale (de hecho $F(x, x) = 0$, así que el máximo de $F$ nunca es negativo). La afirmación intermedia es falsa en general: $f(x) = x - x^2 \/ 2$ en $K = [0, 1]$ cumple $abs(f(x) - f(y)) = abs(x - y) (1 - (x + y) \/ 2) < abs(x - y)$ para $x != y$, pero el cociente tiende a $1$ cerca de $0$, así que no hay $alpha < 1$.

  El enunciado sí es cierto: la prueba usual (deducción del transcriptor, no está en la clase) minimiza la función continua $g(x) = d(x, f(x))$ en el compacto $K$; si el mínimo $x_0$ no fuera fijo, el punto $x_1 = f(x_0) != x_0$ cumpliría
  $ g(x_1) = d(x_1, f(x_1)) = d(f(x_0), f(x_1)) < d(x_0, x_1) = g(x_0), $
  absurdo. La unicidad sale directamente de la hipótesis: dos puntos fijos distintos $a != b$ darían $d(a, b) = d(f(a), f(b)) < d(a, b)$.
]
