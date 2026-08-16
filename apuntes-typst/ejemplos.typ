#import "@preview/frame-it:2.0.0": *
#import "utils.typ": *

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


// --- Archivo Acumulativo de Ejemplos ---

#align(center)[
  #text(14pt, weight: "bold")[Ejemplos resueltos --- Análisis Avanzado] \
  #v(2pt)
  #text(10pt, style: "italic", fill: rgb("#475569"))[
    Ordenados como escalera de preparación para la Práctica 1
  ]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

Los ejemplos están agrupados por *técnica*, no por orden de transcripción, y los bloques siguen el orden en que la guía los necesita. Cada bloque abre con la nota de qué ejercicios de `guias/p1.typ` desbloquea. El número de la pestaña es el del ejemplo en `notas_materia.pdf`, y entre paréntesis en el título va su numeración por capítulo.

#v(6pt)

#show table.cell.where(y: 0): set text(fill: white, weight: "bold", size: 8.5pt)

#table(
  columns: (0.35fr, 2.4fr, 1.1fr),
  align: (center + horizon, left + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#065f46") } else if calc.even(y) { rgb("#f8fafc") } else { white },
  stroke: 0.4pt + rgb("#cbd5e1"),
  inset: (x: 6pt, y: 4pt),

  [*\#*], [*Bloque*], [*Desbloquea de p1*],
  [1], [Supremo, ínfimo, máximo y mínimo por definición], [Ej. 4, 5, 6],
  [2], [La caracterización $epsilon$ y la sucesión que alcanza el supremo], [Ej. 3, 13],
  [3], [Densidad y completitud: por qué $QQ$ no alcanza], [Ej. 2 (a--d)],
  [4], [Límite por definición], [Ej. 1, 7 (a--c)],
  [5], [Negar la convergencia], [Ej. 16 (a)],
  [6], [Monotonía, álgebra de límites y subsucesiones], [Ej. 12, 14, 15, 16],
)

#v(4pt)

#text(size: 9pt, fill: rgb("#64748b"))[
  La numeración de ejercicios es la de la *guía 2026* (`apuntes-docentes/guias/p1.pdf`).
]

#v(8pt)

== Bloque 1 · Supremo, ínfimo, máximo y mínimo por definición

#sublema(titulo: "Qué desbloquea")[
  Todo el *Ejercicio 4* de p1 ($(a,b]$, $B = {1/2^n}$, $B union {0}$, ${x^2 - x - 1}$) se hace con las tres técnicas de este bloque: exhibir la cota, y después descartar cualquier cota mejor *o bien* por el punto medio *o bien* por Arquímedes. Los *Ejercicios 5 y 6* (monotonía de $op("sup")$, $-A$ y $c A$) son estos mismos argumentos aplicados a dos conjuntos a la vez.

  *El orden importa:* los dos primeros ejemplos son informales y fijan el vocabulario (un conjunto puede no tener máximo y sí tener supremo; una cota superior no tiene por qué ser la mejor). Recién el tercero introduce una técnica de demostración --- el punto medio, el argumento más elemental, que no usa Arquímedes --- y conviene tenerlo automatizado antes de pasar a los demás.
]

#ejemplo[Un conjunto sin máximo: $A = {0, 0.9, 0.99, 0.999, ...}$ (Ejemplo 1.1)][1][
  Sea $A = {0, 0.9, 0.99, 0.999, ...}$. ¿Existe algún elemento de $A$ que sea el más grande de todos?
]

#resolucion[
  Todos los elementos de $A$ son de la forma $0.99...9$. Supongamos que alguno es el más grande de todos: este elemento deberá ser

  $ underbrace(0.99 dots 9, k "nueves"). $

  Pero si le agrego un nueve a este número, obtengo el

  $ underbrace(0.99 dots 9, k+1 "nueves") $

  que es un elemento de $A$ pero es más grande que el anterior! Esto es absurdo, por lo que podemos concluir que el conjunto $A$ no tiene un elemento más grande que todos dentro de $A$.

  ¿Pero existe algún número real que sea más grande que todos los elementos de $A$? Acá la respuesta es que sí, podemos ver que todos los elementos de $A$ son menores a, por ejemplo, $1$ (pero también son menores a $1.5$, $2$, $100$, ...).

  Como los elementos del conjunto $A$ están cada vez más cerca de $1$, nos da la impresión de que $1$ es el número que mejor se ajusta a este problema. Es decir, que no va a ser posible conseguir otro número que cumpla, simultáneamente, que sea más grande que todos los elementos de $A$ y más chico que $1$.
]

#ejemplo[Cotas superiores (Ejemplo 1.3)][2][
  #set enum(numbering: "a)")
  + Sea $A = [0, 1] => 1$ es una cota superior; por lo tanto, $A$ está acotado. Notar que el número $2$ también es una cota superior.
  + $A = {-3, -1, 0, 1.5, 7/2}$. En este caso $7/2$ es cota superior (y también es un elemento del conjunto).
  + $A = {n in NN : n "es par"}$. Intuitivamente sabemos que $A$ no puede ser acotado superiormente. Para probarlo formalmente, tenemos que esperar un poco más.
]

#ejemplo[Supremo de $B = (0, 1)$ (Ejemplo 1.6 b)][3][
  Sea $B = (0, 1)$. Probar que $op("sup")(B) = 1$.
]

#estrategia[
  La estrategia es suponer que no es el supremo, por lo tanto hay un $t$ menor a él que es cota superior, y deberíamos ver una contradicción estudiando el punto medio entre $t$ y $1$.
]

#resolucion[
  Tenemos que $op("sup")(B) = 1$ ya que:

  - $s = 1$ es cota superior.
  - Supongamos que $t$ es una cota superior de $B$ y veamos que $t >= 1$. Supongamos que no, es decir, $t < 1$. Pero entonces puedo tomar $x = (t+1)/2$ (el punto medio entre $t$ y $1$) y nos sale que $t < x < 1$. Pero entonces tenemos que por un lado $x in B$ (porque es menor a 1) y por el otro es mayor a $t$ (que era una cota superior!). Esto es absurdo.
]

#ejemplo[Máximo y Supremo de $A = [0, 1]$ y $B = [0, 1)$ (Ejemplo 1.9)][4][
  Para $A = [0, 1]$, el $op("sup")(A) = 1$ y como $1 in A$, $op("máx")(A) = 1$. Sin embargo, para $B = [0, 1)$, el $op("sup")(B) = 1$ pero no tiene máximo porque $1 in.not B$.
]

#ejemplo[Ínfimo de $A = {1/n : n in NN}$ (Ejemplo 1.19)][6][
  Sea $A = {1/n : n in NN}$. Veamos que $op("ínf")(A) = 0$:
]

#resolucion[
  #set enum(numbering: "1.")
  + Es fácil ver que $0$ es cota inferior.
  + Supongamos que $t$ es una cota inferior "mejor" que $0$, es decir, que $t > 0$. Por el Principio de Arquímedes (Proposición 1), sabemos que debe existir un $n in NN$ tal que $t > 1/n > 0$. Pero esto nos dice que $t$ no puede ser cota inferior, lo cual es absurdo. Concluimos que si $t$ es cota inferior debe ser $t <= 0$, que es lo que queríamos ver.
]

#ejemplo[Supremo de $C = {2 - 1/n : n in NN}$ (Ejemplo 1.6 c)][3][
  Sea $C = {2 - 1/n : n in NN} = {2 - 1, 2 - 1/2, 2 - 1/3, ...}$. Probar que $op("sup")(C) = 2$.
]

#estrategia[
  Claramente $2$ es una cota superior de $C$. Mediante el Principio de Arquímedes se puede demostrar formalmente que $2 = op("sup")(C)$.
]

#ejemplo[Supremo de $D = {x in RR : 1/x^2 > 1/4}$ (Ejemplo 1.6 d)][3][
  Sea $D = {x in RR : 1/x^2 > 1/4}$. Determinar el conjunto $D$ y hallar su supremo.
]

#resolucion[
  Resolviendo la inecuación:

  $ 1/x^2 > 1/4 <=> 4 > x^2 and x != 0 <=> 2 > abs(x) and x != 0 $

  Esto nos da el conjunto $D = (-2, 0) union (0, 2)$, cuyo supremo es $op("sup")(D) = 2$.
]

== Bloque 2 · La caracterización $epsilon$ y la sucesión que alcanza el supremo

#sublema(titulo: "Qué desbloquea")[
  El *Ejercicio 3* de p1 pide demostrar exactamente esta caracterización, pero para el ínfimo; el ejemplo de abajo la *usa*, que es la mejor forma de entender qué dice. El *Ejercicio 13* (si $A$ no tiene máximo hay una sucesión creciente en $A$ que tiende a $op("sup")(A)$) es la versión general de la construcción que acá se hace a mano con $a_n = n/(n+1)$.
]

#ejemplo[Supremo de $A = {x/(x + 1) : x > 0}$ (Ejemplo 2.20)][10][
  Sea $A = {x / (x + 1) : x > 0}$. Veamos que $op("sup")(A) = 1$.
]

#resolucion[
  - *1 es cota superior:*
    $ x / (x + 1) <= 1 <=> x <= x + 1, $
    dado que $x > 0$ y por lo tanto 1 es cota superior.

  - *Veamos que existe una sucesión que converge a 1:* Consideremos $a_n = n / (n + 1) in A$ para todo $n in NN$ y sabemos que $lim_(n -> oo) a_n = 1$.

  Por la equivalencia del supremo nos sale que $1 = op("sup")(A)$. Podemos observar además que $1 in.not A$, por lo que $A$ no tiene máximo.
]

== Bloque 3 · Densidad y completitud: por qué $QQ$ no alcanza

#sublema(titulo: "Qué desbloquea")[
  Todo el *Ejercicio 2* de p1 (entero entre $x$ e $y$, racional entre reales, irracional entre racionales, irracional entre reales). El ejemplo de abajo va en la dirección inversa --- usa la densidad para probar que algo *no* existe en $QQ$ --- y por eso es el que fija la técnica: multiplicar por $n$ para separar, encajar un entero, volver a dividir.
]

#ejemplo[Inexistencia de supremo en $QQ$ para $A = {r in QQ : r^2 < 2}$ (Ejemplo 1.15)][5][
  Sea $A = {r in QQ : r^2 < 2}$. Demostrar que $A$ es acotado pero no tiene supremo en $QQ$.
]

#estrategia[
  Usar demostración por contradicción suponiendo que existe $s = op("sup")(A) in QQ$. Analizar las opciones $s^2 > 2$ y $s^2 < 2$ utilizando la densidad de $QQ$ en $RR$ para encontrar en ambos casos una contradicción.
]

#resolucion[
  Vemos que este conjunto es acotado (en $QQ$ y en $RR$). Sin embargo, $A$ no tiene supremo en $QQ$. Supongamos que sí tiene supremo, es decir, que existe $s = op("sup")(A)$ y $s in QQ$. Entonces tenemos que $s$ es cota superior de $A$ y si $t$ es otra cota superior, se debe cumplir que $t >= s$.

  Como $s in QQ subset.eq RR$ tenemos dos posibilidades: $s^2 > 2$ o $s^2 < 2$ (dado que $s^2 != 2$). Notar que acá estamos usando formalmente uno de los axiomas de orden: Tricotomía.

  - Si $s^2 > 2$, tenemos que $s > sqrt(2)$ (dado que $s > 0$). Por la Proposición 2, sabemos que existe un número racional $q$ tal que $s > q > sqrt(2)$. Elevando todo al cuadrado:
    $ q^2 > 2 > r^2 "para todo" r in A => q > r "para todo" r in A. $
    Esto último dice que $q$ es una cota superior de $A$. Pero $s > q$, que contradice que $s$ sea la menor cota superior en $QQ$.

  - Si $s^2 < 2$, tenemos que $s < sqrt(2)$. Al igual que antes, tiene que existir $q in QQ$ tal que $s < q < sqrt(2)$. Elevando al cuadrado:
    $ q^2 < 2 "y" q in QQ => q in A, $
    y por lo tanto se contradice que $s$ sea cota superior de $A$.

  Como llegamos a un absurdo con las dos únicas opciones, podemos concluir que no puede existir $s in QQ$.
]

== Bloque 4 · Límite por definición

#sublema(titulo: "Qué desbloquea")[
  El *Ejercicio 7* de p1 (tres límites por definición) es este ejemplo tres veces: despejar la condición $abs(a_n - ell) < epsilon$ hasta que quede $n > "algo"(epsilon)$, y recién ahí invocar Arquímedes para exhibir $n_0$. El *Ejercicio 1* ($x < y + epsilon$ para todo $epsilon$ implica $x <= y$) es la contracara: acá se elige un $epsilon$ chico a propósito, allá se usa que la desigualdad vale para *todos*.

  El primer ejemplo del bloque no demuestra nada: presenta las dos sucesiones que aparecen en todo el resto del archivo y las dos formas de dibujarlas (en el plano y sobre la recta). Vale la pena mirarlo antes de arrancar con $epsilon$.
]

#ejemplo[Las dos sucesiones de referencia y sus gráficos (Ejemplo 2.2)][7][
  #set enum(numbering: "a)")
  + Si escribimos $a_n = 1/n$, nos estamos refiriendo a la sucesión $(a_n)_(n in NN) = (1, 1/2, 1/3, 1/4, ...)$. Su gráfico sería:

    #grafico-plano(
      (1, 1/2, 1/3, 1/4, 1/5, 1/6, 1/7, 1/8, 1/9, 1/10),
      ticks-y: ((1, $1$), (0.5, $1/2$)),
    )

    También suele ser útil graficar solo las imágenes de la sucesión, es decir, ubicar a los elementos de la sucesión en la recta real:

    #grafico-recta(
      (1, 1/2, 1/3, 1/4, 1/5, 1/6, 1/7, 1/8, 1/9, 1/10),
      etiquetas: ($a_1$, $a_2$, $a_3$, $a_4$),
    )

  + Si $a_n = (-1)^n$, la sucesión completa es $(a_n)_(n in NN) = (-1, 1, -1, 1, -1, 1, ...)$.

    #grafico-plano(
      (-1, 1, -1, 1, -1, 1, -1, 1, -1, 1),
      ticks-y: ((-1, $-1$), (1, $1$)),
    )
]

#ejemplo[Límite de $a_n = 1/n$ (Ejemplo 2.4)][8][
  Sea $a_n = 1/n$. Veamos que $lim_(n -> oo) a_n = 0$. Acá "ver" quiere decir "probar por definición":

  Sea $epsilon > 0$. Queremos encontrar $n_0 in NN$ tal que $abs(1/n - 0) < epsilon$ para todo $n >= n_0$. Desmembrando un poco la condición $abs(1/n - 0) < epsilon$, vemos que
  $ abs(1/n - 0) < epsilon <=> 1/n < epsilon <=> 1/epsilon < n. $
]

#estrategia[
  La idea es la siguiente: el $epsilon$ viene dado y tenemos que ser capaces de exhibir un $n_0$ que cumpla lo que queremos. Por la condición de arriba, vemos que si $n_0$ es tal que $1/epsilon < n_0$, entonces
  $ n >= n_0 > 1/epsilon => 1/n <= 1/n_0 < epsilon. $

  Con lo cual, $n_0$ tiene que cumplir que $1/epsilon < n_0$ ya que esto garantiza que si tomamos $n >= n_0$, entonces $1/n < epsilon$.
]

#resolucion[
  Ahora, ¿qué es lo que permite afirmar que existe un $n_0$ tal que $1/epsilon < n_0$? La respuesta es el Principio de Arquímedes: para $x = 1/epsilon$ existe $n_0 in NN$ tal que $1/epsilon < n_0$.
]

== Bloque 5 · Negar la convergencia

#sublema(titulo: "Qué desbloquea")[
  El *Ejercicio 16 (a)* de p1 (si pares e impares convergen al mismo límite, la sucesión converge) es justamente el enunciado que explica *por qué* $(-1)^n$ falla: acá los dos límites parciales no coinciden. Practicar la negación --- dar vuelta los cuantificadores y elegir el $epsilon$ testigo --- es lo que después permite reconocer de un vistazo cuándo una sucesión no puede converger.
]

#ejemplo[No convergencia de $a_n = (-1)^n$ (Ejemplo 2.5)][9][
  La sucesión $a_n = (-1)^n$ *no converge*.
]

#estrategia[
  ¿Cómo probamos esto? Deberíamos ver que *para todo* candidato a límite $ell in RR$ *existe* un $epsilon > 0$ tal que *para toda* elección de $n_0$ *existe* un $n >= n_0$ con $abs(a_n - ell) >= epsilon$.
]

#resolucion[
  En el ejemplo que estábamos mirando: sea $ell in RR$. Entonces tenemos dos opciones: $ell >= 0$ o $ell < 0$.

  Supongamos que $ell >= 0$, y sea $epsilon = 1/2$. Dado $n_0 in NN$ cualquiera, tenemos que $n_0$ es par o es impar.
  - Si $n_0$ es par, podemos elegir $n = n_0 + 1$ (impar) y tenemos que:
    $ abs((-1)^n - ell) = abs((-1) - ell) = ell - (-1) = ell + 1 >= 1/2 $
    pues $ell >= 0$ y $n$ es impar.
  - Si $n_0$ es impar, podemos elegir $n = n_0$ (impar) y podemos hacer la misma cuenta.

  Finalmente, nos queda observar que si $ell < 0$ podemos hacer una cuenta muy parecida y llegamos a la misma conclusión.
]

== Bloque 6 · Monotonía, álgebra de límites y subsucesiones

#sublema(titulo: "Qué desbloquea")[
  El primer ejemplo fija qué cuenta como subsucesión y qué no (respetar el orden, no repetir términos): es lo que hay que tener claro antes de *construir* una en los *Ejercicios 14, 15 y 16 (b)*.

  El segundo junta de una sola vez las tres herramientas de la última parte de p1: *monótona y acotada implica convergente* (*Ejercicio 12*), *toda subsucesión hereda el límite* (*Ejercicios 14, 15 y 16*) y el truco de *cerrar una ecuación sobre el límite* ($ell = ell^2$) vía álgebra de límites y unicidad.
]

#ejemplo[Qué es y qué no es una subsucesión (Ejemplo 2.22)][11][
  Sea $(a_n)_(n in NN) = (1, 1/2, 1/3, ...)$. Entonces $(a_(2k))_(k in NN) = (1/2, 1/4, 1/6, 1/8, ...)$ es una subsucesión (sólo nos quedamos con los términos pares).

  La sucesión $(b_n)_(n in NN) = (1/2, 1/4, 1, 1/5, 1/6, ...)$ *no* es una subsucesión de $(a_n)_(n in NN)$, dado que no se respeta el orden original de la sucesión.

  La sucesión $(c_n)_(n in NN) = (1, 1, 1/2, 1/3, ...)$ tampoco es una subsucesión de $(a_n)_(n in NN)$, dado que se repite el primer término y eso no está permitido.
]

#ejemplo[Convergencia de $a_n = r^n$ con $r in (0,1)$ (Ejemplo 2.24)][12][
  Sea $r in (0, 1)$ y sea $a_n = r^n$. Usemos la proposición anterior para probar que $r^n -> 0$.
]

#resolucion[
  Como $r < 1$, multiplicando por $r^n$ ambos términos (que es un número positivo), vemos que $r^(n+1) < r^n$ y por lo tanto $(a_n)_(n in NN)$ es una sucesión decreciente. Además es acotada, por lo que sabemos que existe el límite de esta sucesión (además sabemos que este límite debe coincidir con el ínfimo, y esa es otra manera de terminar este ejercicio pero no es lo que vamos a hacer nosotros). Llamemos $ell in RR$ al límite de $(a_n)_(n in NN)$ y consideremos la subsucesión $a_(2k) = r^(2k)$ la subsucesión de los términos pares. Por la proposición anterior, sabemos que $(a_(2k))_(k in NN)$ también converge a $ell$. Observemos que

  $ a_(2k) = r^(2k) = r^k · r^k -> ell · ell = ell^2, $

  por álgebra de límites. Pero entonces, por unicidad del límite, tenemos que $ell = ell^2$ y por lo tanto $ell = 0$ o $ell = 1$. Finalmente, observamos que $ell$ no puede ser 1, porque el primer término de la sucesión es $r$ y después la sucesión es decreciente: esto nos dice que $abs(a_n - 1) >= 1 - r$ para todo $n in NN$. Concluimos que $ell = 0$, como queríamos ver.
]

#v(10pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

#sublema(titulo: "Huecos frente a la Práctica 1")[
  Con los 12 ejemplos del apunte transcritos, estas cuatro técnicas siguen sin tener ningún ejemplo trabajado. Cuando aparezca uno en clase, cargalo con `/ejemplo` en el bloque indicado.

  #set enum(numbering: "1.")
  + *Acotar $abs(a_n - ell)$ por una sucesión más simple* --- *Ej. 7 (b) y (c)*, *Ej. 8*, *Ej. 11*. Todos los límites por definición que hay resueltos salen de una equivalencia exacta ($1/n < epsilon <=> n > 1/epsilon$). Los de la guía no: hay que acotar ($abs(sin(n)) <= 1$; $7/(2^n + 4) <= 7/2^n <= 7/n$) y recién después aplicar Arquímedes. El *Ej. 8* de la guía es precisamente ese lema. → Bloque 4.
  + *Construir una subsucesión eligiendo los índices $n_k$* --- *Ej. 14, 15, 16 (b)*. El Ejemplo 11 dice qué es una subsucesión válida y la Prop. 2.23 usa una que ya viene dada, pero nada construye los índices de forma recursiva. → Bloque 6.
  + *Divergencia a $plus.minus oo$ por definición* --- *Ej. 12 (b)*, *Ej. 14*, *Ej. 9 (b)--(d)*. De `apuntes.typ` sólo está la definición: ninguna demostración del apunte usa el cuantificador "para todo $M > 0$". → Bloque 6 o bloque nuevo.
  + *Punto fijo vía supremo* --- el ejercicio del anexo de p1 (edición 2025). Sin material de ningún tipo. → Bloque 1 o bloque nuevo.
]

#v(6pt)

#sublema(titulo: "Dónde está el modelo cuando no hay ejemplo")[
  El resto de la guía sí tiene material trabajado, aunque no esté en este archivo: está en `desafios.typ` o en las demostraciones de `apuntes.typ`.

  - *Ej. 1* → Desafío 5.3, resuelto completo.
  - *Ej. 2 (a)* → Desafíos "Existencia de un entero en $(x, x+1]$" y "número natural intermedio". *(b)* → es la demostración de la Densidad de $QQ$ (Prop. 2). *(c)--(d)* → Desafío 5.4, con las dos estrategias.
  - *Ej. 3* → la demostración de la *Equivalencia de Ínfimo* en `apuntes.typ` es este enunciado, con las dos implicaciones.
  - *Ej. 4 (a)* → Desafío "Ejercicio 1" ($op("sup")(a,b) = b$) y "Mínimo del intervalo $(a,b]$". *(b)--(c)* → el Ejemplo 6, con el Desafío "$2^n > n$" como puente. *(d)* → Desafío "Mínimo de una función cuadrática convexa", resuelto completo, y "No acotación de pares" para la parte de arriba.
  - *Ej. 6 (a)* → la demostración del Teorema 2 (completitud en términos de ínfimos) hace exactamente $-A$ e $op("ínf")(A) = -op("sup")(-A)$.
  - *Ej. 10* → Desafío 2.14 (a)--(c), resuelto: mismo truco de tomar $epsilon = (ell_1 - ell_2)/2$.
  - *Ej. 11* → la demostración del álgebra de límites, ítem c, *caso $b = 0$*: $abs(a_n b_n) <= M abs(b_n)$ es el argumento completo.
  - *Ej. 12 (a)* → Proposición 8 (monótona creciente y acotada converge), en versión espejo.
  - *Ej. 13* → la demostración de la *Equivalencia del supremo 2* construye $a_n$ con $s - 1/n < a_n <= s$; el Desafío "Ejercicio 2.19" agrega que se la puede tomar estrictamente creciente.
  - *Ej. 16 (a)* → el Ejemplo 9 (partición por paridad) más la demostración de unicidad del límite (elegir $op("máx")(n_1, n_2)$).
]
