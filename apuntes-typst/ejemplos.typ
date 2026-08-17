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

Los ejemplos están agrupados por *técnica*, no por orden de transcripción, y los bloques siguen el orden en que la guía los necesita. Cada bloque abre con la nota de qué ejercicios de `guias/p1.typ` desbloquea.

La pestaña dice de dónde viene cada ejemplo: un *número* es el ejemplo de `notas_materia.pdf` (con su numeración por capítulo entre paréntesis en el título), y *`C{clase}-{ejemplo}`* es un ejercicio resuelto en clase --- `C1-4` es el Ejemplo 4 de `clases/apuntes_1.typ`.

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
  [4], [Límite por definición, y cómo acotar cuando no se puede despejar], [Ej. 1, 7, 8, 11],
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
  El *Ejercicio 3* de p1 pide demostrar exactamente esta caracterización, pero para el ínfimo; los ejemplos de abajo la *usan*, que es la mejor forma de entender qué dice. El *Ejercicio 13* (si $A$ no tiene máximo hay una sucesión creciente en $A$ que tiende a $op("sup")(A)$) es la versión general de estas construcciones.

  *La progresión del bloque:* el primero exhibe la sucesión de un tirón; el segundo la usa dos veces sobre un conjunto de dos parámetros, una para el ínfimo y otra para probar que no hay cota superior; el tercero *construye* la sucesión paso a paso por recursión y densidad --- que es exactamente lo que pide el Ej. 13, sólo que allá hay que subir hasta el supremo en lugar de bajar.
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

#ejemplo[Supremo e ínfimo de $A = {1/n + m : n, m in NN}$ (Clase 1 · Ejemplo 4)][C1-4][
  Hallar, si existen, supremo e ínfimo de $A = {1/n + m : n in NN, m in NN}$.
]

#estrategia[
  El lema de la clase tiene tres partes, y acá se usan dos: $s = op("sup")(A)$ si y sólo si $s$ es cota superior y existe una sucesión contenida en $A$ que converge a $s$; y si $A$ contiene una sucesión no acotada superiormente, entonces $A$ no está acotado superiormente. Con eso, todo el ejercicio se reduce a *exhibir dos sucesiones dentro de $A$*: una que se escape y otra que baje hasta el candidato a ínfimo. Fijar uno de los dos parámetros es lo que las produce.
]

#resolucion[
  Tenemos que $A != nothing$.

  #set enum(numbering: "1.")
  + $a_m = 1 + m$ define una sucesión contenida en $A$ (es el caso $n = 1$), y $lim_(m -> +oo) a_m = +oo$ por arquimedianidad. Entonces $A$ no está acotado superiormente.
  + $1/n + m > 1$ para todo $n, m in NN$. Como $a_n = 1/n + 1$ está en $A$ y cumple $lim_(n -> +oo) a_n = 1$, concluimos que $1$ es el ínfimo de $A$.
]

#ejemplo[Racionales estrictamente decrecientes hacia $x$ (Clase 1 · Ejemplo 6)][C1-6][
  Probar que para todo $x in RR$ existe $(q_n)_(n in NN) subset.eq QQ$ estrictamente decreciente tal que $lim_(n -> +oo) q_n = x$.
]

#estrategia[
  No hay una fórmula para $q_n$: hay que *construirla*. El truco es que cada término nuevo se elige por densidad dentro del intervalo $(x, (x + q_n)/2)$ --- el punto medio garantiza a la vez que se mantenga por encima de $x$ y que baje estrictamente. Después, la convergencia sale de monotonía + acotación, y el valor del límite se identifica pasando al límite en la propia desigualdad de la construcción.
]

#resolucion[
  Por arquimedianidad existe $m in NN$ tal que $x < m$. Tomamos $q_1 = m$.

  #recta([$x$],[$q_2$], [$(x+q_1)/2$], [$q_1$])

  Por la densidad de $QQ$ en $RR$ podemos elegir $q_2$ entre $x$ y $(x+q_1)/2$, es decir $x < q_2 < (x+q_1)/2$.

  En general, si definimos $q_1, q_2, ..., q_n$ racionales con $q_1 > q_2 > ... > q_n$, elegimos $q_(n+1) in QQ$ con $x < q_(n+1) < (x+q_n)/2$, que existe por densidad de $QQ$. Afirmamos que $q_(n+1) < q_n$ para todo $n$ y que $q_n -> x$.

  *(1) $q_(n+1) < q_n$ para todo $n in NN$.* Por inducción.

  Caso base: $n = 1$,
  $ q_2 < (x+q_1)/2 " y " (x+q_1)/2 < q_1, $
  porque
  $ (x+q_1)/2 < q_1 <=> x + q_1 < 2 q_1 <=> x < q_1. $

  Caso inductivo:
  $ q_(k+1) < (x+q_k)/2 " y " (x+q_k)/2 < q_k, $
  porque
  $ (x+q_k)/2 < q_k <=> x + q_k < 2 q_k <=> x < q_k. $

  *(2) $lim_(n -> +oo) q_n = x$.* Como $(q_n)_n$ es decreciente y acotada inferiormente por $x$, es convergente a algún $q in RR$.

  - $x < q_n$ para todo $n$, entonces $x <= q$.
  - $q_(n+1) < (x+q_n)/2$. Tomando límite, $q <= (x+q)/2 <=> q <= x$.

  Entonces $q = x$.
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

#ejemplo[Parte entera: el único $n in ZZ$ con $n <= x < n+1$ (Clase 1 · Ejemplo 5)][C1-5][
  Sea $x in RR$. Probar que existe un único entero $n$ tal que $n <= x < n+1$.
]

#estrategia[
  Este es el resultado que usa el *Ejercicio 2 (a)*: una vez que existe la parte entera, encajar un entero entre $x$ e $y$ cuando $y - x > 1$ es inmediato. La construcción es la de siempre --- definir el conjunto correcto y tomarle el supremo --- con un paso extra: hay que probar que ese supremo *es entero*, y eso sale de que una sucesión de enteros que converge es finalmente constante (Ejemplo C1-3).
]

#resolucion[
  Sea $A = {n in ZZ : n <= x}$.

  #set enum(numbering: "1.")
  + $A != nothing$. Por arquimedianidad, dado $x in RR$, existe $m in NN$ tal que $-x <= m$. Entonces $x >= -m$ y $-m in A$.
  + $A$ está acotado superiormente por $x$, así que por completitud existe $n = op("sup")(A)$. Es este $n$ el que vamos a ver que cumple lo pedido.
  + $n <= x$ porque $n$ es la menor cota superior (y $x$ es una de ellas).
  + $x < n+1$ porque, caso contrario, $n+1 <= x$ y $n+1 in A$, contradiciendo que $n$ sea cota superior.
  + $n in ZZ$: como es el supremo, existe $(a_k)_(k in NN) subset.eq A$ tal que $lim_(k -> +oo) a_k = n$. Pero, por el Ejemplo C1-3, existe $k_0 in NN$ tal que $a_k = n$ para todo $k >= k_0$. Entonces $n in ZZ$.
  + $n$ es único: si $n' in ZZ$ cumple que $n' <= x < n'+1$, entonces $n >= n'$ o $n' >= n$. Si $n >= n'$ resulta que $0 <= n - n' < 1$. Como $n, n' in ZZ$, resulta que $n = n'$.

  #recta(
    [$n'$],
    ([$n$], "arriba"),
    [$x$],
    [$n' + 1$]
  )
]

== Bloque 4 · Límite por definición

#sublema(titulo: "Qué desbloquea")[
  El *Ejercicio 7* de p1 son los tres primeros ejemplos con cuentas distintas: despejar la condición $abs(a_n - ell) < epsilon$ hasta que quede $n > "algo"(epsilon)$, y recién ahí invocar Arquímedes para exhibir $n_0$. El *Ejercicio 1* ($x < y + epsilon$ para todo $epsilon$ implica $x <= y$) es la contracara: acá se elige un $epsilon$ chico a propósito, allá se usa que la desigualdad vale para *todos*.

  *La progresión del bloque:* el Ejemplo 7 no demuestra nada --- presenta las dos sucesiones que aparecen en todo el resto del archivo y las dos formas de dibujarlas. El Ejemplo 8 ($1/n$) sale de una *equivalencia exacta*: se despeja y listo. Los dos de clase (C1-1.1 y C1-1.2) son los que importan para la guía, porque ahí la equivalencia exacta no existe y hay que *acotar primero* por algo más simple: son los Ej. 7 (c) y 7 (b) casi textuales, y el lema general que los ordena a los dos es el *Ejercicio 8*. El último (C1-3) usa la definición al revés: elige un $epsilon$ a propósito para forzar una conclusión.
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

#ejemplo[Límite de $a_n = 1/2^n$ acotando por $1/m$ (Clase 1 · Ejemplo 1.1)][C1-1.1][
  Demostrar que $lim_(n -> +oo) 1/2^n = 0$.
]

#estrategia[
  Acá no se puede despejar $n$ de $1/2^n < epsilon$ con las herramientas disponibles. La salida es *acotar por una sucesión que ya sabemos manejar*: como $m <= 2^m$, se tiene $1/2^m <= 1/m$, y el $m$ que da Arquímedes para $1/m < epsilon$ sirve directamente como $n_0$. Es el mismo movimiento que pide el *Ejercicio 7 (c)*, donde la cadena es $7/(2^n + 4) <= 7/2^n <= 7/n$.
]

#resolucion[
  Queremos ver que dado $epsilon > 0$ existe $n_0 in NN$ tal que $forall n >= n_0$
  $ abs(1/2^n) = 1/2^n < epsilon. $

  Por arquimedianidad existe $m in NN$ tal que $1/m < epsilon$. Alcanza con ver que
  $ 1/2^m <= 1/m <=> m <= 2^m. $

  Como $1/2^n <= 1/2^m$ si $n >= m$, tomamos $n_0 = m$ y concluimos que
  $ 1/2^n <= 1/2^m <= 1/m < epsilon " si " n >= n_0. $
]

#ejemplo[Límite de $a_n = ((-1)^n + 2)/sqrt(n+3)$ acotando el numerador (Clase 1 · Ejemplo 1.2)][C1-1.2][
  Demostrar que $lim_(n -> +oo) ((-1)^n + 2)/sqrt(n+3) = 0$.
]

#estrategia[
  El numerador oscila pero *está acotado*: $abs((-1)^n + 2) <= 3$. Esa cota se saca de la cuenta de entrada y el problema queda reducido a un límite conocido. Es exactamente el *Ejercicio 7 (b)* ($abs(sin(n)) <= 1$) y, en versión concreta, el *Ejercicio 11*: acotada por nula da nula. Segundo detalle a copiar: cuando la cota tiene una raíz, se aplica Arquímedes a $(epsilon\/3)^2$ y no a $epsilon\/3$.
]

#resolucion[
  Queremos ver que, dado $epsilon > 0$, podemos encontrar $n_0 in NN$ tal que $forall n >= n_0$
  $ abs(((-1)^n + 2)/sqrt(n+3)) < epsilon. $

  Notemos que $abs((-1)^n + 2) <= 1 + 2 = 3$. Por lo tanto
  $ abs(((-1)^n + 2)/sqrt(n+3)) <= 3/sqrt(n+3). $

  Veamos que existe $n_0 in NN$ tal que $forall n >= n_0$
  $ 1/sqrt(n+3) < epsilon/3. $

  Por arquimedianidad existe $m in NN$ tal que $1/m < (epsilon/3)^2$. Entonces $1/sqrt(m) < epsilon/3$. Basta que
  $ 1/sqrt(n+3) < 1/sqrt(m) <=> m < n+3. $

  Por lo tanto, si tomamos $n_0 = op("máx"){m-3, 1}$,
  $ 3/sqrt(n+3) <= 3/sqrt(m) < 3 dot epsilon/3 = epsilon. $
]

#ejemplo[Una sucesión convergente de enteros es finalmente constante (Clase 1 · Ejemplo 3)][C1-3][
  Sea $(a_n)_(n in NN)$ una sucesión convergente tal que existe $n_0 in NN$ para el cual $a_n in ZZ$ para todo $n > n_0$. Probar que existen $n_1 in NN$ y $a in RR$ tales que $a_n = a$ para todo $n >= n_1$.
]

#estrategia[
  Este es el uso "al revés" de la definición: en lugar de tomar $epsilon$ arbitrario y buscar $n_0$, se elige *un $epsilon$ concreto* ($1/2$) para que la conclusión sea imposible salvo en un caso. Se compara $a_n$ con un término fijo $a_(n_1)$ vía desigualdad triangular, y se aprovecha que dos enteros distintos nunca están a distancia menor que $1$. La cuenta con $2 epsilon$ es la misma de la unicidad del límite.
]

#resolucion[
  Supongamos que $lim_(n -> +oo) a_n = L$. Veamos que $L = a$ cumple lo pedido. Dado $epsilon > 0$ existe $tilde(n) in NN$ tal que $forall n > tilde(n)$ vale que
  $ abs(a_n - L) < epsilon. $

  En particular, $forall n >= op("máx"){tilde(n), n_0}$ se tiene que
  $ a_n in ZZ " y " abs(a_n - L) < epsilon. $

  Siguiendo el mismo rango de $n$, si $n_1 = op("máx"){tilde(n), n_0}$ y $n >= n_1$,
  $ abs(a_n - a_(n_1)) <= abs(a_n - L) + abs(a_(n_1) - L) < 2 epsilon. $

  Si el $epsilon$ lo tomamos $epsilon <= 1/2$, por ejemplo $epsilon = 1/2$, queda que
  $ abs(a_n - a_(n_1)) < 1. $

  Pero la diferencia entre dos enteros distintos es, al menos, $1$. Concluimos que $a_n = a_(n_1)$ para todo $n >= n_1$. Como $a_n$ converge, $lim_(n -> +oo) a_n = a_(n_1) = L$.
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
  Es el bloque que cubre toda la última parte de la guía, y tiene dos mitades.

  *Monotonía (Ejercicio 12).* El Ejemplo 11 fija qué cuenta como subsucesión y qué no. El 12 ($r^n$), C1-2 ($x^n$ para todo $x$) y C2-1 (una sucesión definida por recursión) son la misma receta con dificultad creciente: probar que es monótona y acotada para saber que el límite *existe*, y recién entonces *cerrar una ecuación sobre él* ($ell = ell^2$, $L = L x$, $L^2 = 2 + L$) usando álgebra de límites y unicidad. El paso final siempre es descartar la raíz que sobra con una desigualdad que valga para todos los términos.

  *Subsucesiones (Ejercicios 14, 15 y 16).* C2-2 es el *Ejercicio 16* con tres clases de restos en vez de dos, y viene con las dos pruebas posibles: la directa --- partir $NN$ y tomar el máximo de los índices, que es la del 16 (a) --- y la del absurdo, cuyo *lema auxiliar construye recursivamente la subsucesión que se aleja del límite*. Ese lema es el paso central del *Ejercicio 15* y la primera mitad del *14*. C2-3 cierra con un uso combinado: acotada $arrow.r$ hay subsucesión convergente.
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

#ejemplo[Para qué $x in RR$ converge $(x^n)_(n in NN)$ (Clase 1 · Ejemplo 2)][C1-2][
  Determinar todos los $x in RR$ para los cuales $(x^n)_(n in NN)$ converge.
]

#estrategia[
  Es el Ejemplo 12 llevado a todos los casos. Dos herramientas nuevas: el paso al valor absoluto (lema de abajo), que permite reducir $x < 0$ al caso ya hecho, y el argumento del caso $x > 1$, donde la contradicción sale de que *una sucesión creciente convergente converge al supremo de sus términos*, así que el límite no puede quedar por debajo de todos ellos.
]

#resolucion[
  Separamos en casos.

  *Caso $0 <= x <= 1$.* Acá $a_n = x^n$ es decreciente:
  $ a_(n+1) <= a_n <=> x^(n+1) <= x^n. $
  Pero
  $ x^(n+1) - x^n = x^n (x - 1) <= 0 $
  es verdadero porque $x^n >= 0$ y $x - 1 <= 0$. Además $x^n$ es acotada:
  $ 0 <= x^n <= 1^n = 1. $

  Por el teorema de monótonas acotadas, $(a_n)_(n in NN)$ converge. Para calcular el límite usamos que
  $ x^(n+1) = x^n dot x. quad (*) $

  Sea $L = lim_(n -> +oo) x^n$; entonces también $L = lim_(n -> +oo) x^(n+1)$, y por lo tanto
  $ L = lim_(n -> +oo) x^(n+1) = lim_(n -> +oo) x^n dot x = L x. $

  De $L = L x$ se sigue $L(1 - x) = 0$: tenemos dos opciones, $L = 0$ o $x = 1$. Si $x = 1$, entonces $a_n = 1^n -> 1$. En cualquier caso, el límite existe.

  *Caso $abs(x) < 1$.* Para esto usamos el siguiente lema:

  #set enum(numbering: "1.")
  + $(a_n)_n -> 0$ si $(abs(a_n))_n -> 0$;
  + si $(a_n)_n -> L$ entonces $(abs(a_n))_n -> abs(L)$.

  Entonces, si $a_n = x^n$, se tiene $abs(a_n) = abs(x)^n$ con $abs(x) < 1$. Por el caso anterior, $abs(a_n) -> 0$, y en consecuencia $a_n -> 0$.

  *Caso $x > 1$.* Acá $a_n = x^n$ es creciente:
  $ a_(n+1) >= a_n <=> x^(n+1) >= x^n, $
  y $x^(n+1) - x^n = x^n (x-1) >= 0$ ya que $x^n >= 0$ y $x - 1 > 0$. Si $(a_n)$ convergiera, repitiendo el argumento de tomar límite en $(*)$ nos daría que $x = 1$ o $L = 0$. Como $x > 1$, debe ser $L = 0$. Pero una sucesión *creciente* y convergente converge al supremo del conjunto de sus términos, por lo tanto $a_n = x^n <= L = 0$ para todo $n in NN$, lo cual es absurdo (pues $x^n > 1 > 0$). Concluimos que no converge.

  *Caso $x = -1$:* queda como ejercicio (es el Ejemplo 9).

  *Caso $x < -1$:* si $a_n = x^n$ fuera convergente, entonces $abs(a_n) = abs(x)^n$ sería convergente, pero $abs(x) > 1$ y por el caso anterior no lo es.

  #v(4pt)
  *Resumen:*
  $ (x^n)_(n in NN) "es " cases(
    "convergente a " 0 " cuando " abs(x) < 1,
    "convergente a " 1 " cuando " x = 1,
    "divergente cuando " abs(x) > 1
  ) $
]

#ejemplo[Sucesión definida por recursión: $a_(n+1) = sqrt(2 + a_n)$ (Clase 2 · Ejemplo 1)][C2-1][
  Sea $(a_n)_(n in NN)$ la sucesión definida recursivamente como
  $ cases(
    a_1 = sqrt(2),
    a_(n+1) = sqrt(2 + a_n) " para todo " n >= 1
  ) $
  Probar que $(a_n)_n$ es monótona y acotada superiormente por $2$. Determinar su límite.
]

#estrategia[
  Conviene hacer *primero la cuenta del límite* aunque todavía no sepamos que existe: sale una ecuación con dos raíces, y eso deja claros los dos problemas a resolver --- (I) por qué converge y (II) cómo se descarta la raíz de más. Como la sucesión está definida por recursión, tanto la monotonía como la cota se prueban por inducción, apoyándose en que $sqrt(dot)$ es creciente.
]

#estrategia[
  Notemos que si supiéramos que $(a_n)_n$ converge a $L$, como $a_(n+1)^2 = 2 + a_n$, resultaría
  $ L^2 = lim_(n->+oo) a_(n+1)^2 = lim_(n->+oo) (2 + a_n) = 2 + L, $
  es decir
  $ L^2 - L - 2 = 0 <=> L = 2 " o " L = -1. $

  Entonces $L = 2$ o $L = -1$. Problemas: \
  (I) ¿Cómo vemos que $(a_n)_n$ converge? \
  (II) ¿Cómo distinguimos entre los dos candidatos a límite?
]

#resolucion[
  *(I)* Veamos que $(a_n)_n$ es creciente y acotada superiormente. Por lo tanto será convergente.

  - _Creciente_ (por inducción). Caso base: $n = 1$, $a_1 = sqrt(2) <= sqrt(2 + a_1) = sqrt(2 + sqrt(2))$ es verdadero, porque $sqrt(dot)$ es creciente y $2 < 2 + sqrt(2)$. \
    Caso inductivo: si $a_k <= a_(k+1)$ entonces $2 + a_k <= 2 + a_(k+1)$ y $a_(k+1) = sqrt(2 + a_k) <= sqrt(2 + a_(k+1))$, o sea $a_(k+1) <= a_(k+2)$.

  - _Acotada superiormente_: veamos que $a_n <= 2$ para todo $n$, por inducción. Caso base: $a_1 = sqrt(2) <= 2$. \
    Caso inductivo: si $a_k <= 2$ entonces
    $ a_(k+1) = sqrt(2 + a_k) <= sqrt(2 + 2) = 2, $
    usando que $sqrt(dot)$ es creciente y que $2 + a_k <= 4$.

  *(II)* $(a_n)_n$ es creciente y $a_1 > 0$. Entonces $a_n > 0$ para todo $n in NN$, y por lo tanto $L = lim_(n->+oo) a_n >= 0$. Concluimos que $L = 2$.
]

#ejemplo[Tres clases de restos: si $(a_(3k)), (a_(3k+1)), (a_(3k+2))$ convergen al mismo límite (Clase 2 · Ejemplo 2)][C2-2][
  Sea $(a_n)_n$ una sucesión tal que $(a_(3k))_k$, $(a_(3k+1))_k$ y $(a_(3k+2))_k$ convergen a un mismo número. Probar que $(a_n)_n$ es convergente.
]

#estrategia[
  Las dos pruebas valen la pena y son las dos técnicas del *Ejercicio 16*. La primera es directa: como las tres familias de índices *parten* $NN$, todo $n$ cae en alguna, y basta pedir que $n$ supere a los tres umbrales a la vez --- por eso aparece el máximo. La segunda es por absurdo y es la que hay que tener a mano para el *Ejercicio 15*: de la negación de la convergencia se *extrae* una subsucesión que se queda lejos del límite, y después el principio del palomar (infinitos índices en tres cajas) obliga a que una de las tres familias contenga infinitos de ellos, contradiciendo su convergencia.
]

#resolucion[
  Supongamos que $(a_(3k))_k$, $(a_(3k+1))_k$ y $(a_(3k+2))_k$ convergen a $L$. Probemos que para todo $epsilon > 0$ existe $n_0$ tal que para todo $n >= n_0$, $abs(a_n - L) < epsilon$.

  *(I) Prueba directa.* Dado $epsilon > 0$,
  - existe $k_0 in NN$ tal que para todo $k >= k_0$, $abs(a_(3k) - L) < epsilon$,
  - existe $k_1 in NN$ tal que para todo $k >= k_1$, $abs(a_(3k+1) - L) < epsilon$,
  - existe $k_2 in NN$ tal que para todo $k >= k_2$, $abs(a_(3k+2) - L) < epsilon$.

  Puesto que $NN = {3k : k in NN} union.sq {3k+1 : k in NN_0} union.sq {3k+2 : k in NN_0}$,
  - si $n = 3k$, queremos $k >= k_0$: entonces $n >= 3 k_0$ hace que $k >= k_0$;
  - si $n = 3k+1$, queremos $k >= k_1$: entonces $n >= 3 k_1 + 1$ hace que $k >= k_1$;
  - si $n = 3k+2$, queremos $k >= k_2$: entonces $n >= 3 k_2 + 2$ hace que $k >= k_2$.

  Tomando $n_0 >= op("máx"){3k_0, 3k_1+1, 3k_2+2}$ vemos que para todo $n >= n_0$, $abs(a_n - L) < epsilon$.

  #v(4pt)
  *(II) Por el absurdo.* Supongamos que no. Entonces existe $epsilon > 0$ y una subsucesión $(a_(n_k))_k$ tal que
  $ abs(a_(n_k) - L) >= epsilon. $

  #sublema(titulo: "Lema auxiliar: construcción de la subsucesión mala")[
    Si $(a_n)_n$ no converge a $L$, entonces existe $epsilon > 0$ tal que para todo $n in NN$ existe $n_0 >= n$ tal que $abs(a_(n_0) - L) >= epsilon$.
    - Si $n = 1$, existe $n_1 >= 1$ tal que $abs(a_(n_1) - L) >= epsilon$.
    - Si $n = n_1 + 1$, existe $n_2 >= n_1 + 1$ tal que $abs(a_(n_2) - L) >= epsilon$.
    - Recursivamente, habiendo elegido $n_1 < n_2 < ... < n_k$ tales que $abs(a_(n_k) - L) >= epsilon$, poniendo $n = n_k + 1$ vemos que existe $n_(k+1) >= n_k + 1$ tal que $abs(a_(n_(k+1)) - L) >= epsilon$. \
    Por construcción, $(a_(n_k))_k$ cumple lo pedido.
  ]

  Como $NN = {3k : k in NN} union.sq {3k+1 : k in NN_0} union.sq {3k+2 : k in NN_0}$, en alguno de los tres conjuntos hay infinitos $n_k$. Por lo tanto existe una subsucesión $(a_(n_(k_j)))_j$ tal que $n_(k_j) in {3k + a : k in NN}$ para algún $a in {0, 1, 2}$. Pero entonces $a_(n_(k_j)) -> L$, así que existe $j_0 in NN$ tal que para todo $j > j_0$,
  $ abs(a_(n_(k_j)) - L) < epsilon. $

  Pero por la hipótesis del absurdo, $epsilon <= abs(a_(n_(k_j)) - L) < epsilon$, absurdo.
]

#ejemplo[Si $a_n \/ b_n$ tiende a un irracional, ninguna está acotada (Clase 2 · Ejemplo 3)][C2-3][
  Sea $r in.not QQ$. Supongamos que $(a_n)_n, (b_n)_n subset.eq NN$ cumplen que $lim_(n->+oo) a_n / b_n = r$. Probar que $(a_n)_n$ y $(b_n)_n$ no están acotadas.
]

#estrategia[
  Encadena tres cosas del bloque: si estuviera acotada tendría una subsucesión convergente (Bolzano--Weierstrass, que todavía no está en `apuntes.typ`), esa subsucesión es de naturales y entonces es finalmente constante (Ejemplo C1-3), y una constante sobre otra constante da un racional --- que es la contradicción. Es el argumento típico de "acotada $arrow.r$ subsucesión convergente" que también aparece en el *Ejercicio 14*, ahí en su forma negativa.
]

#resolucion[
  Supongamos que $(a_n)_n$ está acotada. Por lo tanto existe $(a_(n_k))_k$ convergente. Como $(a_(n_k))_k subset.eq NN$, resulta que es eventualmente constante, es decir existe $a in NN$ y $k_0 in NN$ tal que
  $ a_(n_k) = a " para todo " k > k_0. $

  Entonces
  $ a_(n_k) / b_(n_k) = a / b_(n_k) " para todo " k > k_0. $

  Como $r in.not QQ$ y $a != 0$ (pues $a in NN$), resulta que $(a / b_(n_k))^(-1) = b_(n_k) / a$ converge a $1/r$. Como $(b_(n_k))_k subset.eq NN$ es eventualmente constante, entonces existe $b in NN$ y $k_1 in NN$ tal que
  $ b_(n_k) = b " para todo " k > k_1. $

  Pero entonces $b/a = 1/r in QQ$, absurdo. Concluimos que $(a_n)_n$ no está acotada.

  Para ver que $(b_n)_n$ no es acotada, usamos que $1/r in.not QQ$ y que $b_n / a_n$ converge a $1/r$, por lo tanto el mismo argumento aplicado a $(b_n)_n$ permite deducir que no está acotada.
]

#v(10pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

#sublema(titulo: "Huecos frente a la Práctica 1")[
  Con los 12 ejemplos del apunte y los 10 de clase, quedan sólo dos técnicas sin ningún ejemplo trabajado en todo el repositorio. Cuando aparezca una en clase, cargala con `/ejemplo` en el bloque indicado:

  #set enum(numbering: "1.")
  + *Divergencia a $plus.minus oo$ por definición* --- *Ej. 9 (b)--(d)*, *Ej. 12 (b)*, y la segunda mitad del *Ej. 14*. De `apuntes.typ` sólo está la definición, y ninguna demostración usa el cuantificador "para todo $M > 0$": lo más cerca que hay es el Ejemplo C1-4, que invoca $a_m -> +oo$ sin probarlo por definición. → Bloque 6 o bloque nuevo.
  + *Punto fijo vía supremo* --- el ejercicio del anexo de p1 (edición 2025). Sin material de ningún tipo. → Bloque 1 o bloque nuevo.

  #v(4pt)
  _Pendiente aparte:_ el Ejemplo 4 de `clases/apuntes_2.typ` (cardinales) no se copió acá porque es del Cap. 3; va a la ruta de p2 cuando se arme.
]

#v(6pt)

#sublema(titulo: "Dónde está el modelo cuando no hay ejemplo")[
  El resto de la guía sí tiene material trabajado, aunque no esté en este archivo: está en `desafios.typ` o en las demostraciones de `apuntes.typ`.

  - *Ej. 1* → Desafío 5.3, resuelto completo.
  - *Ej. 2 (a)* → el Ejemplo C1-5 construye la parte entera, que es la herramienta; además los Desafíos "Existencia de un entero en $(x, x+1]$" y "número natural intermedio". *(b)* → es la demostración de la Densidad de $QQ$ (Prop. 2). *(c)--(d)* → Desafío 5.4, con las dos estrategias.
  - *Ej. 3* → la demostración de la *Equivalencia de Ínfimo* en `apuntes.typ` es este enunciado, con las dos implicaciones.
  - *Ej. 4 (a)* → Desafío "Ejercicio 1" ($op("sup")(a,b) = b$) y "Mínimo del intervalo $(a,b]$". *(b)--(c)* → el Ejemplo 6, con el Desafío "$2^n > n$" como puente. *(d)* → Desafío "Mínimo de una función cuadrática convexa", resuelto completo, y "No acotación de pares" para la parte de arriba.
  - *Ej. 6 (a)* → la demostración del Teorema 2 (completitud en términos de ínfimos) hace exactamente $-A$ e $op("ínf")(A) = -op("sup")(-A)$.
  - *Ej. 10* → Desafío 2.14 (a)--(c), resuelto: mismo truco de tomar $epsilon = (ell_1 - ell_2)/2$.
  - *Ej. 11* → el Ejemplo C1-1.2 es el caso concreto; en general, la demostración del álgebra de límites, ítem c, *caso $b = 0$*: $abs(a_n b_n) <= M abs(b_n)$ es el argumento completo.
  - *Ej. 12 (a)* → Proposición 8 (monótona creciente y acotada converge), en versión espejo.
  - *Ej. 13* → la demostración de la *Equivalencia del supremo 2* construye $a_n$ con $s - 1/n < a_n <= s$; el Desafío "Ejercicio 2.19" agrega que se la puede tomar estrictamente creciente.
  - *Ej. 16 (a)* → el Ejemplo 9 (partición por paridad) más la demostración de unicidad del límite (elegir $op("máx")(n_1, n_2)$).
]
