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
    Escalera de preparación para la Práctica 1, con la ruta de cardinalidad de la Práctica 2 y el arranque de la Práctica 3
  ]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

Los ejemplos están agrupados por *técnica*, no por orden de transcripción, y los bloques siguen el orden en que la guía los necesita. Cada bloque abre con la nota de qué ejercicios de `guias/p{N}.typ` desbloquea.

La pestaña dice de dónde viene cada ejemplo: un *número* es el ejemplo de `notas_materia.pdf` (con su numeración por capítulo entre paréntesis en el título), *`C{clase}-{ejemplo}`* es un ejercicio resuelto en clase --- `C1-4` es el Ejemplo 4 de `clases_2023/apuntes_1.typ` --- y *`A{sección}`* es un resultado o ejercicio de Abbott, _Understanding Analysis_ --- `A1.5.9` es el Ejercicio 1.5.9 del libro.

#v(6pt)

#show table.cell.where(y: 0): set text(fill: white, weight: "bold", size: 8.5pt)

#table(
  columns: (0.35fr, 2.4fr, 1.1fr),
  align: (center + horizon, left + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#065f46") } else if calc.even(y) { rgb("#f8fafc") } else { white },
  stroke: 0.4pt + rgb("#cbd5e1"),
  inset: (x: 6pt, y: 4pt),

  [*\#*], [*Bloque*], [*Desbloquea*],
  [1], [Supremo, ínfimo, máximo y mínimo por definición], [p1: Ej. 4, 5, 6],
  [2], [Densidad y completitud: por qué $QQ$ no alcanza], [p1: Ej. 2 (a--d)],
  [3], [Límite por definición, y cómo acotar cuando no se puede despejar], [p1: Ej. 1, 7, 8, 11],
  [4], [La equivalencia del supremo por sucesiones], [p1: Ej. 13 (intro)],
  [5], [Negar la convergencia], [p1: Ej. 16 (a)],
  [6], [Monotonía, álgebra de límites y subsucesiones], [p1: Ej. 12, 13, 14, 15, 16],
  [7], [Coordinabilidad y biyecciones explícitas], [p2: Ej. 1, 4, 8, 9 (c), 14, 16, 17 (a)],
  [8], [Métricas: verificar los axiomas], [p3: Ej. 1, 2],
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

== Bloque 2 · Densidad y completitud: por qué $QQ$ no alcanza

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

== Bloque 3 · Límite por definición

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

#ejemplo[Límite de la raíz cuadrada: si $a_n -> l$, entonces $sqrt(a_n) -> sqrt(l)$][Prop][
  Sea $(a_n)_(n in NN)$ con $a_n >= 0$ tal que $a_n -> l in RR$. Demostrar que $sqrt(a_n) -> sqrt(l)$.
]

#estrategia[
  Se analizan dos casos según el valor del límite $l$:
  - Si $l > 0$, no se puede despejar directamente $n$. Se multiplica y divide por el conjugado $sqrt(a_n) + sqrt(l)$ y se acota el denominador por $sqrt(l)$, reduciendo la cota a $|a_n - l| < epsilon sqrt(l)$.
  - Si $l = 0$, el truco del conjugado no se aplica (daría división por cero); en su lugar se aprovecha directamente la definición de $a_n -> 0$ eligiendo $epsilon^2$.
]

#resolucion[
  Como $a_n >= 0$ para todo $n in NN$, se tiene que $l >= 0$. Estudiamos los dos casos:

  *Caso 1: $l > 0$.* Dado $epsilon > 0$, como $a_n -> l$, existe $n_0 in NN$ tal que
  $ abs(a_n - l) < epsilon sqrt(l) quad forall n >= n_0. $

  En particular, para $n >= n_0$, usando el conjugado:
  $ abs(sqrt(a_n) - sqrt(l)) = abs(sqrt(a_n) - sqrt(l)) dot abs(sqrt(a_n) + sqrt(l)) / abs(sqrt(a_n) + sqrt(l)) = abs(a_n - l) / (sqrt(a_n) + sqrt(l)). $

  Como $a_n >= 0$, se cumple que $sqrt(a_n) + sqrt(l) >= sqrt(l) > 0$, por lo que $1 / (sqrt(a_n) + sqrt(l)) <= 1 / sqrt(l)$. Luego, para todo $n >= n_0$:
  $ abs(sqrt(a_n) - sqrt(l)) <= abs(a_n - l) / sqrt(l) < (epsilon sqrt(l)) / sqrt(l) = epsilon. $

  *Caso 2: $l = 0$.* Dado $epsilon > 0$, como $a_n -> 0$, existe $n_0 in NN$ tal que
  $ abs(a_n) < epsilon^2 quad forall n >= n_0. $

  Como $a_n >= 0$, la desigualdad es $a_n < epsilon^2$. Aplicando raíz cuadrada (que es una función estrictamente creciente):
  $ sqrt(a_n) < epsilon quad ("pues " epsilon > 0), $
  es decir, $abs(sqrt(a_n) - 0) < epsilon$ para todo $n >= n_0$.

  En ambos casos, demostramos que $forall epsilon > 0, exists n_0 in NN : abs(sqrt(a_n) - sqrt(l)) < epsilon, forall n >= n_0$.
]

#ejemplo[Límite de las medias de Cesàro: si $a_n -> 0$, entonces $S_n = 1/n sum_(i=1)^n a_i -> 0$][Prop][
  Sea $(a_n)_(n in NN) subset.eq RR$ tal que $a_n -> 0$. Definimos $S_n$ como
  $ S_n = (sum_(i=1)^n a_i) / n. $
  Demostrar que $S_n -> 0$.
]

#estrategia[
  La técnica clave es *partir la suma en dos tramos*:
  - Los primeros $n_1$ términos se acotan por una suma constante $K = sum_(i=1)^(n_1) abs(a_i)$, la cual decae a cero al dividir por $n$ cuando $n$ crece (por arquimedianidad).
  - Los términos restantes ($i > n_1$) se acotan por $epsilon / 2$ usando la convergencia de $a_n -> 0$.
  Elegir $n_0 = op("máx"){n_1, n_2}$ permite controlar ambas partes simultáneamente por $epsilon / 2 + epsilon / 2 = epsilon$.
]

#resolucion[
  Dado $epsilon > 0$, como $a_n -> 0$, existe $n_1 in NN$ tal que
  $ abs(a_i) < epsilon / 2 quad forall i >= n_1. $

  Para $n >= n_1$, aplicando desigualdad triangular y separando la suma en los primeros $n_1$ términos y la cola:
  $ abs(S_n) <= (sum_(i=1)^n abs(a_i)) / n = (sum_(i=1)^(n_1) abs(a_i) + sum_(i=n_1 + 1)^n abs(a_i)) / n. $

  Como cada uno de los $n - n_1$ términos del segundo tramo cumple $abs(a_i) < epsilon / 2$:
  $ sum_(i=n_1 + 1)^n abs(a_i) < (n - n_1) dot epsilon / 2 <= n dot epsilon / 2. $

  Luego:
  $ abs(S_n) < (sum_(i=1)^(n_1) abs(a_i)) / n + (n epsilon / 2) / n = (sum_(i=1)^(n_1) abs(a_i)) / n + epsilon / 2. $

  Llamemos $K = sum_(i=1)^(n_1) abs(a_i) >= 0$.
  - Si $K = 0$, la primera fracción es $0 < epsilon / 2$.
  - Si $K > 0$, por el Principio de Arquímedes existe $n_2 in NN$ tal que $K / n_2 < epsilon / 2$. Entonces para todo $n >= n_2$, se cumple $K / n <= K / n_2 < epsilon / 2$.

  Tomando $n_0 = op("máx"){n_1, n_2}$, resulta que para todo $n >= n_0$:
  $ abs(S_n) < epsilon / 2 + epsilon / 2 = epsilon. $

  Concluimos que $forall epsilon > 0, exists n_0 in NN : abs(S_n) < epsilon, forall n >= n_0$, es decir, $S_n -> 0$.
]

== Bloque 4 · La equivalencia del supremo por sucesiones

#sublema(titulo: "Qué desbloquea")[
  Esta es la equivalencia del supremo *por sucesiones* --- distinta de la de $epsilon$ ($s - epsilon < a <= s$ para algún $a in A$), que es la que pide el *Ejercicio 3* de p1 (para el ínfimo) y que no usa límites en absoluto. Por eso este bloque va recién acá: citar "existe una sucesión en $A$ que converge a $s$" no tiene sentido antes de saber qué significa que una sucesión converja.

  *(Ej. 3 sigue sin ejemplo propio en este archivo: sólo está cubierto por la demostración de la Equivalencia de Ínfimo en `apuntes.typ`.)*

  *La progresión del bloque:* los dos ejemplos exhiben una sucesión *ya conocida* (no la construyen) y cierran con el lema "$s = op(\"sup\")(A)$ sii es cota superior y hay una sucesión en $A$ que converge a $s$" --- alcanza con la noción de límite, nada de monotonía. La construcción más fina que pide el *Ejercicio 13* (fabricar la sucesión por recursión cuando no hay una a mano, y probar su convergencia por monotonía + acotación) queda para el Ejemplo C1-6, al final del Bloque 6, que es donde esas herramientas recién están disponibles.
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

  *Cierre con el Ejercicio 13.* El Ejemplo C1-6, al final del bloque, es la versión espejada de este ejercicio: en vez de construir una sucesión creciente que suba hasta el supremo vía la caracterización $epsilon$ (eso ya está resuelto en `apuntes.typ` y en el Bloque 4), construye por recursión y densidad una sucesión de racionales *decreciente* hacia un $x in RR$ cualquiera, y recién identifica el límite invocando el Teorema de sucesiones monótonas acotadas y pasaje al límite en la desigualdad de la construcción --- las dos herramientas que este bloque acaba de instalar con 12, C1-2 y C2-1.
]

#ejemplo[Qué es y qué no es una subsucesión (Ejemplo 2.22)][11][
  Sea $(a_n)_(n in NN) = (1, 1/2, 1/3, ...)$. Entonces $(a_(2k))_(k in NN) = (1/2, 1/4, 1/6, 1/8, ...)$ es una subsucesión (sólo nos quedamos con los términos pares).

  La sucesión $(b_n)_(n in NN) = (1/2, 1/4, 1, 1/5, 1/6, ...)$ *no* es una subsucesión de $(a_n)_(n in NN)$, dado que no se respeta el orden original de la sucesión.

  La sucesión $(c_n)_(n in NN) = (1, 1, 1/2, 1/3, ...)$ tampoco es una subsucesión de $(a_n)_(n in NN)$, dado que se repite el primer término y eso no está permitido.
]

#ejemplo[No convergencia de $a_n = cos(n/2 pi)$ vía subsucesiones][Prop][
  Sea $(a_n)_(n in NN)$ dada por $a_n = cos(n/2 pi)$. Probar que $(a_n)_(n in NN)$ *no* converge.
]

#estrategia[
  Si una sucesión converge a $ell in RR$, entonces toda subsucesión suya debe converger al mismo límite $ell$. Por lo tanto, si se exhiben dos subsucesiones que convergen a límites distintos, la sucesión original no puede converger.
]

#resolucion[
  Analicemos los primeros términos de la sucesión:
  $
  a_1 &= cos(pi/2) = 0, \
  a_2 &= cos(pi) = -1, \
  a_3 &= cos(3/2 pi) = 0, \
  a_4 &= cos(2 pi) = 1.
  $

  Consideremos la subsucesión $a_(4k+1)$ con $k in NN_0$:
  $
  a_(4k+1) = cos((4k+1)/2 pi) = cos(2k pi + pi/2) = 0 quad forall k in NN_0.
  $
  Luego, $a_(4k+1) -> 0$.

  Por otro lado, consideremos la subsucesión $a_(4k)$ con $k in NN$:
  $
  a_(4k) = cos((4k)/2 pi) = cos(2k pi) = 1 quad forall k in NN.
  $
  Por lo tanto, $a_(4k) -> 1$.

  Como tenemos dos subsucesiones que convergen a límites distintos ($0 != 1$), concluimos que $(a_n)_(n in NN)$ no converge.
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

#ejemplo[Producto de acotadas con subsucesiones nulas: $c_n = a_n b_n -> 0$][Prop][
  Sean $(a_n)_(n in NN)$ y $(b_n)_(n in NN)$ sucesiones acotadas de números reales tales que $a_(2k) -> 0$ y $b_(2k-1) -> 0$. Sea $c_n = a_n b_n$. Demostrar que $c_n -> 0$.
]

#estrategia[
  Queremos ver que para todo $epsilon > 0$ existe $n_0 in NN$ tal que $abs(c_n) < epsilon$ para todo $n >= n_0$.
  
  Como $abs(c_n) = abs(a_n) abs(b_n)$, usamos que ambas sucesiones están acotadas ($abs(a_n) <= M_1$ y $abs(b_n) <= M_2$) y separamos según la paridad de $n$:
  - En los términos pares ($n = 2k$), $a_(2k) -> 0$ compensa la cota de $b_(2k)$.
  - En los términos impares ($n = 2k-1$), $b_(2k-1) -> 0$ compensa la cota de $a_(2k-1)$.
  
  Tomando $n_0 = op("máx"){2k_1, 2k_2 - 1}$, garantizamos que cualquier $n >= n_0$ cumpla la cota correspondiente según sea par o impar.
]

#resolucion[
  Como $(a_n)_(n in NN)$ está acotada, existe $M_1 > 0$ tal que $abs(a_n) <= M_1$ para todo $n in NN$. \
  Como $(b_n)_(n in NN)$ está acotada, existe $M_2 > 0$ tal que $abs(b_n) <= M_2$ para todo $n in NN$.

  Dado $epsilon > 0$:
  - Como $a_(2k) -> 0$, existe $k_1 in NN$ tal que $abs(a_(2k)) < epsilon / M_2$ para todo $k >= k_1$.
  - Como $b_(2k-1) -> 0$, existe $k_2 in NN$ tal que $abs(b_(2k-1)) < epsilon / M_1$ para todo $k >= k_2$.

  Definimos $n_0 = op("máx"){2k_1, 2k_2 - 1}$ y tomemos $n >= n_0$. Analizamos según la paridad de $n$:

  #set enum(numbering: "1.")
  + *Si $n$ es par:* existe $k in NN$ tal que $n = 2k$. Por lo tanto,
    $ 2k = n >= n_0 >= 2k_1 <=> k >= k_1. $
    Luego,
    $ abs(c_n) = abs(a_n) abs(b_n) = abs(a_(2k)) abs(b_(2k)) < epsilon / M_2 dot M_2 = epsilon. $

  + *Si $n$ es impar:* existe $k in NN$ tal que $n = 2k - 1$. Por lo tanto,
    $ 2k - 1 = n >= n_0 >= 2k_2 - 1 <=> k >= k_2. $
    Luego,
    $ abs(c_n) = abs(a_n) abs(b_n) = abs(a_(2k-1)) abs(b_(2k-1)) <= M_1 dot abs(b_(2k-1)) < M_1 dot epsilon / M_1 = epsilon. $

  Concluimos que para todo $n >= n_0$ se cumple $abs(c_n) < epsilon$, y por lo tanto $c_n -> 0$.
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

#ejemplo[Racionales estrictamente decrecientes hacia $x$ (Clase 1 · Ejemplo 6)][C1-6][
  Probar que para todo $x in RR$ existe $(q_n)_(n in NN) subset.eq QQ$ estrictamente decreciente tal que $lim_(n -> +oo) q_n = x$.
]

#estrategia[
  No hay una fórmula para $q_n$: hay que *construirla*. El truco es que cada término nuevo se elige por densidad dentro del intervalo $(x, (x+q_n)/2)$ --- el punto medio garantiza a la vez que se mantenga por encima de $x$ y que baje estrictamente. Después, la convergencia sale de monotonía + acotación, y el valor del límite se identifica pasando al límite en la propia desigualdad de la construcción.
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

== Bloque 7 · Coordinabilidad y biyecciones explícitas

#sublema(titulo: "Qué desbloquea")[
  El *Ejercicio 1* de la Práctica 2 (cardinalidad de subconjuntos de $ZZ$, múltiplos y productos) requiere construir biyecciones o inyecciones explícitas. La partición de $NN$ en pares e impares para coordinar con $ZZ$ es el modelo fundamental para entrelazar conjuntos o cubrir signos opuestos. El uso del Teorema de Cantor-Schröeder-Bernstein y la codificación con factores primos ($2^n 3^m$) desbloquea el producto cartesiano de conjuntos numerables. Por último, transportar una función con las biyecciones dadas ($h |-> g compose h compose f^(-1)$) es la herramienta detrás de los *Ejercicios 8* y *9 (c)*, donde hay que coordinar conjuntos de funciones y partes de un conjunto.
]

#ejemplo[Coordinabilidad de $NN$ con los pares, con $ZZ$ y con $QQ^+$ (Ejemplo 3.3)][13][
  #set enum(numbering: "a)")
  + $NN tilde.op {"números naturales pares"}$. Son coordinables mediante la función $f(n) = 2n$, que es biyectiva.
  + $NN tilde.op ZZ$: podemos tomar la función
    $ f(n) = cases(
      n/2 &"si" n "es par",
      -((n - 1)/2) &"si" n "es impar".
    ) $
  + $NN tilde.op QQ^+ = {q in QQ : q > 0}$: para ver esto, vamos a hacer el siguiente procedimiento.

    Pensemos que armamos una grilla infinita donde ubicamos a la fracción $m/n$ en la columna $m$ y fila $n$. Nuestra biyección $f : NN -> QQ^+$ va a recorrer la grilla como en el gráfico que hicimos más abajo, teniendo en cuenta que debemos "saltarnos" a los repetidos: las fracciones $1/1$ y $2/2$ representan el mismo número, y queremos que nuestra $f$ sea inyectiva.

    Nos quedaría:
    $ f(1) = 1, quad f(2) = 2, quad f(3) = 1/2, quad f(4) = 1/3, quad f(5) = 3, quad dots $

    #v(4pt)
    #align(center)[
      #cetz.canvas({
        import cetz.draw: *

        let spacing = 1.4
        let rows = 5
        let cols = 5

        // Título Numeradores arriba
        content(((cols + 1) * spacing / 2, 1.4), text(12pt, weight: "bold")[Numeradores ($m$)])

        // Etiquetas de columnas m
        for m in range(1, cols + 1) {
          content((m * spacing, 0.65), text(11pt)[$m = #m$])
        }

        // Título Denominadores a la izquierda
        content((-1.8, - (rows - 1) * spacing / 2), angle: 90deg, text(12pt, weight: "bold")[Denominadores ($n$)])

        // Etiquetas de filas n
        for n in range(1, rows + 1) {
          let y = - (n - 1) * spacing
          content((-0.4, y), text(11pt)[$n = #n$])
        }

        // Dibujar puntos y etiquetas de fracciones
        for n in range(1, rows + 1) {
          for m in range(1, cols + 1) {
            let x = m * spacing
            let y = - (n - 1) * spacing
            circle((x, y), radius: 0.08, fill: black, stroke: black)
            
            if m <= 4 and n <= 4 {
              content((x, y + 0.28), text(8pt, fill: rgb("#64748b"))[$#m/#n$])
            }
          }
        }

        // Cruces rojas en los repetidos
        let repetidos = ((2, 2), (4, 2), (3, 3), (2, 4))
        for (m, n) in repetidos {
          let x = m * spacing
          let y = - (n - 1) * spacing
          line((x - 0.2, y - 0.2), (x + 0.2, y + 0.2), stroke: 1.5pt + rgb("#dc2626"))
          line((x - 0.2, y + 0.2), (x + 0.2, y - 0.2), stroke: 1.5pt + rgb("#dc2626"))
        }

        // Trayectoria azul
        let pt(m, n) = (m * spacing, - (n - 1) * spacing)

        line(
          pt(1, 1),
          pt(2, 1),
          pt(1, 2),
          pt(1, 3),
          pt(3, 1),
          pt(4, 1),
          pt(1, 4),
          pt(1, 5),
          pt(5, 1),
          stroke: 1.3pt + rgb("#2563eb"),
          mark: (end: "stealth")
        )
      })
    ]
]

#estrategia[
  Informalmente, notemos que esta función le asigna a cada número natural par su mitad y con esto estaríamos "cubriendo" los enteros positivos. Por otro lado, "cubrimos" los enteros negativos y el cero con los naturales impares asignándole a cada uno, $-$ la mitad de su par anterior.
]

#resolucion[
  Formalmente tenemos que probar que $f$ resulta biyectiva:

  - *Inyectiva:* supongamos que $n != m$. Si $n$ es par y $m$ es impar, entonces $f(n) != f(m)$ porque uno es positivo y el otro negativo. Si ambos son pares, es fácil ver que $f(n) != f(m)$ porque $n/2 != m/2$. Si ambos son impares podemos hacer un razonamiento parecido.
  - *Sobreyectiva:* sea $a in ZZ$. Si $a > 0$, entonces $a = f(2a)$, dado que $2a$ es un número natural par. Si $a <= 0$, entonces $a = f(-2a + 1)$, dado que $-2a + 1$ es un número natural impar.
]

#ejemplo[$QQ$ es numerable partiéndolo en bloques finitos (Abbott, Teorema 1.5.6 (i))][A1.5.6a][
  Probar que $QQ$ es numerable, sin construir ninguna fórmula explícita: agrupando los racionales en pedazos finitos y listándolos uno tras otro.
]

#estrategia[Cuando la fórmula es incómoda, se lista por bloques][
  El Ejemplo 3.3 (c) recorre la grilla de $QQ^+$ en diagonal salteando repetidos, y ahí la biyección existe pero escribirla es un engorro. La alternativa es partir $QQ$ en *bloques finitos*: si cada bloque tiene finitos elementos y hay una cantidad numerable de bloques, la lista se arma concatenándolos, y todo elemento cae en una posición finita.

  La señal es tener un *parámetro natural* que ordene el conjunto en capas finitas. Para una fracción irreducible $p\/q$ el parámetro natural es $p + q$.
]

#resolucion[
  Definimos $A_1 = {0}$ y, para cada $n >= 2$,
  $ A_n = {plus.minus p/q : p, q in NN "coprimos con" p + q = n}. $

  Los primeros bloques son
  $ A_1 = {0}, quad A_2 = {1/1, -1/1}, quad A_3 = {1/2, -1/2, 2/1, -2/1}, \
    A_4 = {1/3, -1/3, 3/1, -3/1}, quad A_5 = {1/4, -1/4, 2/3, -2/3, 3/2, -3/2, 4/1, -4/1}. $

  Notemos que en $A_4$ no aparece $2/2$, porque no está escrito en forma irreducible (ya apareció como $1/1$ en $A_2$).

  Las dos observaciones que hacen funcionar todo son:

  #set enum(numbering: "a)")
  + *Cada $A_n$ es finito.* Hay a lo sumo $n - 1$ pares $(p, q) in NN times NN$ con $p + q = n$, y cada uno aporta a lo sumo dos elementos.
  + *Cada racional aparece en exactamente un bloque.* Escrito en forma irreducible como $plus.minus p\/q$, el número cae en $A_(p+q)$ y en ningún otro: los $A_n$ son disjuntos dos a dos.

  La correspondencia con $NN$ se obtiene listando consecutivamente los elementos de $A_1$, después los de $A_2$, después los de $A_3$, y así siguiendo. Es *sobreyectiva*: por ejemplo $22\/7 in A_29$, y como $A_1 union dots union A_28$ es finito, $22\/7$ aparece en un lugar finito de la lista; el mismo razonamiento vale para cualquier $p\/q$. Es *inyectiva* porque los bloques son disjuntos y dentro de cada bloque no repetimos elementos.
]

#sublema(titulo: "Qué técnica es ésta")[
  Es *unión numerable de conjuntos finitos*, el caso más manso del resultado que se trabaja en `ruta_union_contables.typ`. Vale la pena notar que Abbott no escribe la fórmula de la biyección y aclara que intentarlo no es un buen uso del tiempo: lo que hay que ver es que cada elemento ocupa una posición finita en la lista.

  La misma maniobra resuelve varios ítems de la Práctica 2: en el Ejemplo C2-4 (b) aparece como $(0,1) inter QQ = union.sq_(m in NN) {m\/n : 0 < m < n}$, con cada pedazo finito.
]

#ejemplo[Numerabilidad de $NN times NN$ vía Cantor-Schröeder-Bernstein (Ejemplo 3.12)][14][
  Usemos el Teorema de Cantor-Schröeder-Bernstein para ver que $NN times NN$ es numerable.
]

#resolucion[
  - Sea $f : NN -> NN times NN$ la función $f(n) = (n, 1)$. La función $f$ es inyectiva, lo que nos dice que $\#NN <= \#(NN times NN)$.

  - Sea $g : NN times NN -> NN$ la función $g(n, m) = 2^n 3^m$. La función $g$ es inyectiva (por descomposición única en factores primos), con lo cual $\#(NN times NN) <= \#NN$.
]

#ejemplo[Coordinabilidad de $RR$ con $(0, 1)$ (Ejemplo 3.20)][15][
  Veamos que $RR tilde.op (0, 1)$.
]

#resolucion[
  Para esto, vemos primero que $RR tilde.op (-1, 1)$ vía la función
  $ f : RR -> (-1, 1), quad f(x) = x / (1 + abs(x)), $
  que resulta biyectiva. Esto lo podemos ver, por ejemplo, comprobando que $f^(-1)(x) = x / (1 - abs(x))$.

  Por otro lado, podemos probar también que $(-1, 1) tilde.op (0, 1)$, vía la función
  $ g : (-1, 1) -> (0, 1), quad g(x) = (x + 1) / 2, $
  que también resulta biyectiva.

  Por transitividad de la relación de equivalencia concluimos que $RR tilde.op (0, 1)$.
]

#ejemplo[$RR$ no es numerable, sin usar desarrollos decimales (Abbott, Teorema 1.5.6 (ii))][A1.5.6b][
  Probar que $RR$ no es numerable atrapando al número que falta con una sucesión de intervalos cerrados encajados, en lugar de fabricarlo dígito a dígito.
]

#estrategia[La misma contradicción, pero con intervalos en vez de dígitos][
  La demostración del Teorema 3.19 supone que existe una lista $(x_n)_(n in NN)$ de todos los reales y construye un $y$ que no está en ella, eligiendo cada dígito de $y$ distinto del correspondiente de $x_n$. El precio es que hay que discutir la no unicidad del desarrollo decimal (Observación 3.22, que en `desafios.typ` figura como desafío).

  La versión de Abbott produce el mismo $y$ *sin escribirlo*: en vez de controlar sus dígitos, se lo encierra en una sucesión de intervalos cerrados encajados, cada uno de los cuales deja afuera un término más de la lista. El número que la propiedad de intervalos encajados entrega no puede estar en la lista, y no hubo que representarlo de ninguna manera particular.
]

#resolucion[
  Supongamos que $RR$ es numerable, es decir que podemos escribir
  $ RR = {x_1, x_2, x_3, dots}. $

  Construimos inductivamente intervalos cerrados y acotados $I_1 supset.eq I_2 supset.eq I_3 supset.eq dots$ tales que $x_n in.not I_n$ para todo $n$:

  - Tomamos $I_1$ cualquier intervalo cerrado con $x_1 in.not I_1$ (por ejemplo $I_1 = [x_1 + 1, x_1 + 2]$).
  - Dado $I_n = [a, b]$ con $a < b$, consideramos los dos intervalos cerrados *disjuntos*
    $ [a, a + (b - a)/3] quad "y" quad [b - (b - a)/3, b]. $
    Como son disjuntos, $x_(n+1)$ puede pertenecer a lo sumo a uno de los dos; elegimos como $I_(n+1)$ al otro. Así se cumplen $I_(n+1) subset.eq I_n$ y $x_(n+1) in.not I_(n+1)$.

  Por la propiedad de los intervalos encajados existe $x in inter.big_(n in NN) I_n$. Pero si $x$ estuviera en la lista, sería $x = x_(n_0)$ para algún $n_0 in NN$, y por construcción $x_(n_0) in.not I_(n_0)$, mientras que $x in inter.big_(n in NN) I_n subset.eq I_(n_0)$. Absurdo.

  Por lo tanto $x$ es un número real que no aparece en la lista, lo que contradice que la lista fuera todo $RR$. Concluimos que $RR$ no es numerable.
]

#sublema(titulo: "La propiedad de intervalos encajados no está en el apunte del curso")[
  Abbott la usa como resultado previo (su Teorema 1.4.1), pero en `notas_materia.pdf` no aparece, así que conviene tenerla probada:

  *Enunciado.* Si $I_n = [a_n, b_n]$ son intervalos cerrados y acotados con $I_(n+1) subset.eq I_n$ para todo $n$, entonces $inter.big_(n in NN) I_n != nothing$.

  *Demostración.* Del encaje se sigue que $a_n <= b_m$ para *todo* par $n, m$: si $n <= m$ vale $a_n <= a_m <= b_m$, y si $n > m$ vale $a_n <= b_n <= b_m$. Entonces el conjunto $A = {a_n : n in NN}$ es no vacío y está acotado superiormente (por cualquier $b_m$), así que por el axioma de completitud existe $x = op("sup")(A)$. Como $x$ es cota superior, $a_n <= x$ para todo $n$; y como cada $b_m$ es cota superior de $A$ y $x$ es la menor de ellas, $x <= b_m$ para todo $m$. Luego $x in [a_n, b_n]$ para todo $n$. #h(1fr) $qed$

  Las dos hipótesis se usan: *cerrados* para que el supremo pertenezca al intervalo, y *acotados* para poder tomar supremo. Con $I_n = (0, 1/n)$ la intersección es vacía.
]

#ejemplo[Cinco cálculos de cardinal: $ZZ times ZZ$, $(0,1) inter QQ$, $pi QQ$, $QQ + QQ$ y las sucesiones enteras convergentes (Clase 2 · Ejemplo 4)][C2-4][
  Calcular el cardinal de los siguientes conjuntos:

  #set enum(numbering: "a)")
  + $ZZ times ZZ$.
  + $(0, 1) inter QQ$.
  + ${pi q : q in QQ}$.
  + $QQ + QQ = {a + b : a in QQ, b in QQ}$.
  + ${(a_n)_(n in NN) subset.eq ZZ : (a_n)_(n in NN) "es convergente"}$.
]

#estrategia[Tres recetas que se repiten][
  Los cinco ítems salen con alguna de estas tres, y casi todos admiten más de un camino:

  #set enum(numbering: "1.")
  + *Componer biyecciones conocidas.* Teniendo $ZZ tilde.op NN$ y $NN times NN tilde.op NN$, cualquier construcción armada sobre $ZZ$ se transporta.
  + *Escribir el conjunto como unión contable de contables.* Es la receta más flexible: partirlo en pedazos indexados por algo contable y ver que cada pedazo es contable.
  + *Encajar entre conjuntos conocidos.* Una inyección hacia un contable ya da contable; si además el conjunto es infinito, es numerable.

  El ítem (d) agrega una cuarta, que es la *Proposición 3.9* de `apuntes.typ`: para probar que $A$ es contable alcanza con exhibir una *suryección* desde un conjunto contable.
]

#resolucion[
  *(a) $ZZ times ZZ$ es numerable.* La función

  $ f : ZZ -> NN, quad f(n) = cases(
    2n & "si" n >= 0,
    2(-n) - 1 & "si" n < 0,
  ) $

  es biyectiva. Entonces $F : ZZ times ZZ -> NN times NN$, $F(n, m) = (f(n), f(m))$, también lo es:

  - *inyectiva:* $F(n, m) = F(n', m')$ equivale a $f(n) = f(n')$ y $f(m) = f(m')$; como $f$ es inyectiva, $n = n'$ y $m = m'$;
  - *suryectiva:* dado $(y_1, y_2) in NN times NN$, como $f$ es suryectiva existen $n, m in ZZ$ con $f(n) = y_1$ y $f(m) = y_2$, y entonces $F(n, m) = (y_1, y_2)$.

  Finalmente, $NN times NN -> NN$ dada por $(n, m) |-> 2^n (2m - 1)$ es biyectiva, porque todo natural se escribe de forma única como una potencia de $2$ por un impar (Teorema Fundamental de la Aritmética). Componiendo, $ZZ times ZZ tilde.op NN$, luego $ZZ times ZZ$ es numerable.

  _Otra resolución:_ podemos escribir $ZZ times ZZ = union.sq_(n in ZZ) A_n$ con $A_n = {n} times ZZ$. Como $A_n tilde.op ZZ$ para cada $n$, resulta que $ZZ times ZZ$ es unión contable de numerables y por lo tanto es numerable.

  *(b) $(0, 1) inter QQ$ es numerable.*

  _Paso 1: $QQ_(>0)$ es numerable._ La función $QQ_(>0) -> NN times NN$ que a $x = a/b$ con $(a, b) = 1$ le asigna $(a, b)$ es inyectiva (cada racional positivo tiene una única representación como fracción irreducible), y $NN times NN$ es numerable por la parte (a). Así que $QQ_(>0)$ es coordinable con un subconjunto de un numerable, es decir, es contable; siendo infinito, es numerable.

  _Paso 2: biyección auxiliar $(0, +oo) -> (0, 1)$._ Consideramos $f : (0, +oo) -> (0, 1)$, $f(x) = x/(x+1)$.

  - *bien definida:* $0 < x < x + 1$, con lo cual $0 < x/(x+1) < 1$;
  - *inyectiva:* $x/(x+1) = y/(y+1) <=> x(y+1) = (x+1)y <=> x y + x = x y + y <=> x = y$;
  - *suryectiva:* dado $y in (0, 1)$, de $x/(x+1) = y$ se despeja $x - y x = y$, o sea $x = y/(1-y) > 0$.

  Luego $f$ es biyectiva, con inversa $f^(-1)(y) = y/(1-y)$.

  _Paso 3: restricción de $f$ a $QQ_(>0)$._ Idea general a recordar: *si $f : A -> B$ es biyección y $A_0 subset.eq A$ es tal que $f(A_0) = B_0$ exactamente, entonces $f|_(A_0) : A_0 -> B_0$ también es biyección.*

  Acá se aplica con $A_0 = QQ_(>0)$ y $B_0 = (0, 1) inter QQ$. Hay que verificar que $f(QQ_(>0)) = (0, 1) inter QQ$:

  - si $x in QQ_(>0)$, entonces $f(x) = x/(x+1)$ es cociente de racionales, y ya sabemos que $f(x) in (0, 1)$; luego $f(x) in (0, 1) inter QQ$;
  - si $y in (0, 1) inter QQ$, entonces $x = f^(-1)(y) = y/(1-y)$ es cociente de racionales, y como $y in (0, 1)$ sabemos que $x in (0, +oo)$; luego $x in QQ_(>0)$ y $f(x) = y$.

  Por lo tanto $f$ manda $QQ_(>0)$ biyectivamente sobre $(0, 1) inter QQ$, es decir,
  $ QQ_(>0) tilde.op (0, 1) inter QQ. $

  Como $QQ_(>0)$ es numerable (Paso 1) y la numerabilidad se preserva por biyecciones, $(0, 1) inter QQ$ es numerable.

  _Otras formas:_ la inclusión $(0,1) inter QQ arrow.hook QQ$ es inyectiva, así que el conjunto es contable; como contiene a ${1/n : n in NN, n >= 2}$, es infinito, y por lo tanto numerable. También sirve escribirlo como $union.sq_(m in NN) A_m$ con $A_m = {m/n : 0 < m < n}$, que es unión contable de conjuntos finitos.

  *(c) ${pi q : q in QQ}$ es numerable.* La función $QQ -> {pi q : q in QQ}$, $q |-> pi q$, es biyectiva.

  *(d) $QQ + QQ$ es numerable.* Como $QQ + QQ subset.eq QQ$, es contable; y como es infinito, es numerable.

  _Otra forma, con suryecciones:_ la función $QQ times QQ -> QQ + QQ$, $(a, b) |-> a + b$, es suryectiva ($a$ es la imagen de $(a, 0)$). Alcanza entonces con el siguiente lema, que es la Proposición 3.9 de `apuntes.typ` leída en el caso contable.

  #sublema(titulo: "Lema: una suryección desde un contable alcanza")[
    Si $f : NN -> A$ es suryectiva, entonces $A$ es contable.

    _Demostración:_ dado $a in A$ existe $n_a in NN$ con $f(n_a) = a$; definimos $tilde(f) : A -> NN$, $a |-> n_a$, que es inyectiva.

    _Nota:_ acá el "elegir" $n_a$ se puede hacer sin axioma de elección tomando $n_a = op("mín"){n in NN : f(n) = a}$, por el principio de buena ordenación. En general, si $f : B -> A$ es suryectiva existe $tilde(f) : A -> B$ inyectiva, pero elegir una preimagen para cada $a$ sí requiere el axioma de elección.
  ]

  Como $QQ tilde.op NN$, componiendo obtenemos una suryección $NN -> QQ + QQ$, y por el lema $QQ + QQ$ es contable.

  _Una manera más:_ $QQ + QQ = union.sq_(a in QQ) (a + QQ)$, y $a + QQ tilde.op QQ$ vía $q |-> a + q$. Es unión contable de contables.

  *(e) ${(a_n)_n subset.eq ZZ : (a_n)_n "es convergente"}$ es numerable.* Por el Ejemplo C1-3, una sucesión convergente de enteros es finalmente constante: existe $n_0 in NN$ tal que $a_n = a_(n_0)$ para todo $n >= n_0$. Entonces

  $ {(a_n)_n subset.eq ZZ : (a_n)_n "converge"} = union.sq_((a, k) in ZZ times NN) A_(a,k), \
    "donde" quad A_(a,k) = {(a_n)_n subset.eq ZZ : a_n = a "para todo" n >= k}. $

  Cada $A_(a,k)$ es contable, porque la función $A_(a,k) -> ZZ^(k-1)$, $(a_n)_n |-> (a_1, a_2, dots, a_(k-1))$, es biyectiva y $ZZ^(k-1)$ es numerable. Como $ZZ times NN$ es contable, el conjunto es unión contable de contables y por lo tanto contable; siendo infinito, es numerable.
]

#sublema(titulo: "Sobre la observación del manuscrito en (a)")[
  Después del ítem (a) el manuscrito anota una observación sobre particiones de $NN$: dado $N in NN$ vale $NN = union.sq_(i=1)^N B_i$ con $B_i = {k N + i : k in NN_0}$ y $1 <= i <= N$, y también hay particiones infinitas, por ejemplo indexadas por primos,

  $ B_2 = {n in NN : 2 divides n}, quad B_3 = {n in NN : 2 divides.not n "y" 3 divides n}, \
    B_p = {n in NN : q divides.not n "para todo primo" q < p "pero" p divides n}. $

  El paso final del manuscrito, que quería armar la biyección $ZZ times ZZ = union.sq_m A_m -> union.sq_(p in P) B_p = NN$, queda incompleto en el original (aparece una familia $h_(g(m))$ que nunca se define), así que no se transcribe: para (a) ya alcanza con cualquiera de las dos resoluciones de arriba.
]

#ejemplo[Un conjunto de reales positivos con todas sus sumas finitas acotadas es contable (Abbott, Ejercicio 1.5.8)][A1.5.8][
  Sea $B$ un conjunto de números reales positivos tal que la suma de los elementos de cualquier subconjunto finito de $B$ es siempre menor o igual a $2$. Probar que $B$ es finito o numerable.
]

#estrategia[Partir por tamaño][
  No hay ninguna biyección a la vista ni ninguna estructura que copiar: lo único que se sabe de $B$ es una cota sobre sus sumas finitas. La idea es que *no puede haber muchos elementos grandes*, porque unos pocos ya se comerían el presupuesto de $2$.

  Eso sugiere cortar $B$ en capas según el tamaño: $B_n = {x in B : x > 1/n}$. Cada capa tiene que ser finita por la cota, y las capas cubren todo $B$ porque ningún elemento de $B$ es $0$ y vale el Principio de Arquímedes. De nuevo, unión numerable de finitos.
]

#resolucion[
  Para cada $n in NN$ definimos
  $ B_n = {x in B : x > 1/n}. $

  *Cada $B_n$ es finito.* Supongamos que $B_n$ tuviera al menos $2n + 1$ elementos y tomemos $2n + 1$ de ellos, digamos $x_1, dots, x_(2n+1)$. Como cada uno es mayor que $1\/n$,
  $ sum_(i=1)^(2n+1) x_i > (2n+1) · 1/n = 2 + 1/n > 2, $
  y encontramos un subconjunto finito de $B$ cuya suma supera $2$, contra la hipótesis. Luego $B_n$ tiene a lo sumo $2n$ elementos.

  *Las capas cubren $B$.* Sea $x in B$. Como $x > 0$, por el Principio de Arquímedes (Proposición 1 de `apuntes.typ`) existe $n in NN$ con $1\/n < x$, es decir $x in B_n$. Por lo tanto
  $ B = union.big_(n in NN) B_n. $

  Así, $B$ es una unión numerable de conjuntos finitos y en consecuencia es contable: finito o numerable.
]

#sublema(titulo: "La misma forma en la Práctica 2")[
  El Ejercicio 12 (a) de la Práctica 2 --- una familia de intervalos disjuntos dos a dos, cada uno con más de un punto, tiene que estar indexada por un conjunto contable --- tiene exactamente esta estructura: no hay biyección para construir, hay que *cortar en capas contables* y usar que un conjunto no puede tener demasiados elementos "grandes" (allá, intervalos que contienen un racional distinto cada uno). El Ejemplo C3-4 es la versión con entornos.
]

#ejemplo[Los números algebraicos son numerables (Abbott, Ejercicio 1.5.9)][A1.5.9][
  Un número $x in RR$ se dice *algebraico* si existen enteros $a_0, a_1, dots, a_n in ZZ$, no todos nulos, tales que
  $ a_n x^n + a_(n-1) x^(n-1) + dots + a_1 x + a_0 = 0, $
  es decir, si es raíz de un polinomio no nulo con coeficientes enteros. Los reales que no son algebraicos se llaman *trascendentes*.

  #set enum(numbering: "a)")
  + Probar que $sqrt(2)$, $root(3, 2)$ y $sqrt(2) + sqrt(3)$ son algebraicos.
  + Fijado $n in NN$, sea $A_n$ el conjunto de los números algebraicos que son raíces de polinomios de grado $n$ con coeficientes enteros. Probar que $A_n$ es contable.
  + Concluir que el conjunto de todos los números algebraicos es numerable. ¿Qué se deduce sobre los trascendentes?
]

#estrategia[Dos uniones encadenadas][
  Es el ejemplo que junta todas las herramientas del bloque, y conviene ver el esqueleto antes de las cuentas:

  #set enum(numbering: "1.")
  + Un polinomio de grado $n$ *es* su lista de coeficientes: los polinomios de grado $n$ con coeficientes enteros se identifican con un subconjunto de $ZZ^(n+1)$, que es numerable por ser producto finito de numerables.
  + Cada polinomio no nulo aporta *finitas* raíces (a lo sumo $n$).
  + Entonces $A_n$ es una unión, indexada por un numerable, de conjuntos finitos.
  + Y el conjunto de todos los algebraicos es $union.big_(n in NN) A_n$: otra vez unión numerable, ahora de contables.
]

#resolucion[
  *(a)* $sqrt(2)$ es raíz de $x^2 - 2$ y $root(3, 2)$ es raíz de $x^3 - 2$. Para $x = sqrt(2) + sqrt(3)$ elevamos al cuadrado dos veces:
  $ x^2 = 5 + 2 sqrt(6) quad ==> quad x^2 - 5 = 2 sqrt(6) quad ==> quad (x^2 - 5)^2 = 24, $
  de donde $x^4 - 10 x^2 + 25 = 24$, es decir que $sqrt(2) + sqrt(3)$ es raíz de $x^4 - 10 x^2 + 1$.

  *(b)* Llamemos $P_n$ al conjunto de los polinomios de grado $n$ con coeficientes enteros. La función que a $p(x) = a_n x^n + dots + a_0$ le asigna la tupla $(a_0, a_1, dots, a_n)$ es inyectiva de $P_n$ en $ZZ^(n+1)$, y $ZZ^(n+1)$ es numerable (producto finito de conjuntos numerables, iterando el Ejemplo 3.12). Por la Proposición 3.13, $P_n$ es contable.

  Para cada $p in P_n$, el conjunto $R_p$ de sus raíces reales es finito: tiene a lo sumo $n$ elementos, porque $p$ no es el polinomio nulo. Entonces
  $ A_n = union.big_(p in P_n) R_p $
  es una unión indexada por un conjunto contable de conjuntos finitos, y por lo tanto $A_n$ es contable.

  *(c)* El conjunto de todos los números algebraicos es
  $ A = union.big_(n in NN) A_n, $
  unión numerable de contables, así que $A$ es contable. Además $A$ es infinito, porque contiene a $QQ$: todo racional $p\/q$ es raíz de $q x - p$. Luego $A$ es numerable.

  Sea $T = RR backslash A$ el conjunto de los trascendentes. Si $T$ fuera contable, entonces $RR = A union T$ sería unión de dos contables y por lo tanto contable, contradiciendo el Teorema 3.19. Concluimos que $T$ no es contable: *existen números trascendentes* y, de hecho, son "casi todos" los reales.
]

#sublema(titulo: "Por qué este ejemplo vale la pena")[
  Es el mismo movimiento que el cardinal de los irracionales (Ejercicio 4 de la Práctica 2), pero con un conjunto que no se puede describir de manera explícita: la existencia de números trascendentes se demuestra *contando*, sin exhibir ninguno. Exhibir uno concreto ($e$, $pi$) es muchísimo más difícil que probar que hay una cantidad no numerable.

  Para la Práctica 2 la parte reutilizable es la identificación *polinomio $<-->$ tupla de coeficientes*, que es la que resuelve el Ejercicio 13 (cardinal de $RR[X]$): con coeficientes reales en lugar de enteros, la misma identificación da $RR[X] tilde.op union.big_(n in NN) RR^(n+1)$.
]

#ejemplo[Transportar funciones: si $A tilde.op X$ y $B tilde.op Y$ entonces $B^A tilde.op Y^X$][Prop][
  Sean $A, B, X, Y$ conjuntos no vacíos, y notemos $B^A = {h : h "es una función" A -> B}$ al conjunto de todas las funciones de $A$ en $B$.

  Probar que si $A tilde.op X$ y $B tilde.op Y$, entonces $B^A tilde.op Y^X$.
]

#estrategia[Entrar y salir con las biyecciones que ya tenemos][
  Un elemento de $B^A$ es una función $h : A -> B$, y lo que queremos es fabricar con ella una función $X -> Y$. Las biyecciones $f : A -> X$ y $g : B -> Y$ son justamente los adaptadores que faltan: entramos por $f^(-1)$, atravesamos con $h$ y salimos por $g$,

  $ X ->^(f^(-1)) A ->^(h) B ->^(g) Y, $

  o sea $phi(h) = g compose h compose f^(-1)$. Recorriendo el camino al revés aparece sola la candidata a inversa, $psi(k) = g^(-1) compose k compose f$.

  Para probar que $phi$ es biyectiva conviene exhibir su inversa antes que verificar inyectividad y sobreyectividad por separado. *Pero ojo:* exhibir una inversa obliga a chequear las *dos* composiciones, $psi compose phi = op("id")_(B^A)$ y $phi compose psi = op("id")_(Y^X)$. Con una sola alcanza para la inyectividad de $phi$, no para su biyectividad.
]

#resolucion[
  Como $A tilde.op X$ y $B tilde.op Y$, existen biyecciones $f : A -> X$ y $g : B -> Y$; por ser biyectivas, existen también sus inversas $f^(-1) : X -> A$ y $g^(-1) : Y -> B$.

  *Las candidatas.* Definimos

  $ phi : B^A -> Y^X, quad phi(h) = g compose h compose f^(-1), $
  $ psi : Y^X -> B^A, quad psi(k) = g^(-1) compose k compose f. $

  Las dos están bien definidas: si $h : A -> B$, la composición $g compose h compose f^(-1)$ recorre $X -> A -> B -> Y$ y por lo tanto es una función de $X$ en $Y$, es decir $phi(h) in Y^X$. Simétricamente, si $k : X -> Y$, entonces $g^(-1) compose k compose f$ recorre $A -> X -> Y -> B$ y $psi(k) in B^A$.

  *Primera composición: $psi compose phi = op("id")_(B^A)$.* Sea $h in B^A$. Usando la asociatividad de la composición para reagrupar,

  $ psi(phi(h)) &= psi(g compose h compose f^(-1)) \
    &= g^(-1) compose (g compose h compose f^(-1)) compose f \
    &= (g^(-1) compose g) compose h compose (f^(-1) compose f) \
    &= op("id")_B compose h compose op("id")_A \
    &= h. $

  Como esto vale para todo $h in B^A$, tenemos $psi compose phi = op("id")_(B^A)$.

  *Segunda composición: $phi compose psi = op("id")_(Y^X)$.* Sea $k in Y^X$. De la misma manera,

  $ phi(psi(k)) &= phi(g^(-1) compose k compose f) \
    &= g compose (g^(-1) compose k compose f) compose f^(-1) \
    &= (g compose g^(-1)) compose k compose (f compose f^(-1)) \
    &= op("id")_Y compose k compose op("id")_X \
    &= k, $

  y por lo tanto $phi compose psi = op("id")_(Y^X)$.

  Esta segunda cuenta *no* es la primera escrita al revés: acá las identidades que se arman son $g compose g^(-1) = op("id")_Y$ y $f compose f^(-1) = op("id")_X$, mientras que en la primera eran $g^(-1) compose g = op("id")_B$ y $f^(-1) compose f = op("id")_A$. Son composiciones distintas, y por eso hace falta hacer las dos: una sola de ellas prueba que $phi$ es inyectiva, pero no que sea sobreyectiva.

  Habiendo verificado ambas, $psi = phi^(-1)$ y $phi : B^A -> Y^X$ resulta biyectiva. Es decir, $B^A tilde.op Y^X$.
]

#sublema(titulo: "Dónde se usa")[
  Encadenado con el *Ejercicio 8 (a)* de la Práctica 2 ($cal(P)(A) tilde.op {0, 1}^A$), este ejemplo da el *Ejercicio 9 (c)* casi gratis. Si $A tilde.op B$, entonces

  $ cal(P)(A) tilde.op {0, 1}^A tilde.op {0, 1}^B tilde.op cal(P)(B), $

  donde el paso del medio es exactamente este resultado, aplicado con la biyección dada $A -> B$ y con $op("id")_({0, 1})$ del otro lado.
]

#ejemplo[Pegar funciones sobre dominios disjuntos: $C^A times C^B tilde.op C^(A union B)$][Prop][
  Sean $A, B, C$ conjuntos no vacíos tales que $A inter B = nothing$. Probar que
  $ C^A times C^B tilde.op C^(A union B). $
]

#estrategia[Un par de funciones es lo mismo que una función partida en dos][
  Darse una función $h : A union B -> C$, cuando $A$ y $B$ son disjuntos, es exactamente lo mismo que decir por separado qué hace sobre $A$ y qué hace sobre $B$. Esa frase *es* la biyección: en un sentido *pegamos* el par $(f, g)$ en una sola función, y en el otro *restringimos* $h$ a cada pedazo.

  El punto delicado no es ninguna de las dos verificaciones, sino que el pegado sea realmente una función: si hubiera algún $x in A inter B$ con $f(x) != g(x)$, la fórmula le asignaría dos valores distintos a un mismo punto. *Ahí, y sólo ahí, se usa la hipótesis $A inter B = nothing$*: ni la inyectividad ni la sobreyectividad la necesitan.
]

#resolucion[Vía inyectividad y sobreyectividad][
  Un elemento de $C^A times C^B$ es un par $(f, g)$ con $f : A -> C$ y $g : B -> C$. Dado un par así, definimos $phi_(f,g) : A union B -> C$ por

  $ phi_(f,g)(x) = cases(
    f(x) & "si" x in A,
    g(x) & "si" x in B,
  ) $

  y con eso definimos $phi : C^A times C^B -> C^(A union B)$ como $phi(f, g) = phi_(f,g)$.

  *$phi$ está bien definida.* Sea $x in A union B$. Por definición de unión, $x in A$ o $x in B$, así que los dos casos cubren todo el dominio. Y como $A inter B = nothing$, no puede pasar que $x$ esté en los dos a la vez: los casos son excluyentes. Por lo tanto a cada $x in A union B$ le corresponde un único valor, $phi_(f,g)$ es una función de $A union B$ en $C$ y $phi(f, g) in C^(A union B)$. Notemos que *éste es el único lugar del ejercicio donde se usa la hipótesis de disjunción*.

  *$phi$ es inyectiva.* Sean $(f, g)$ y $(tilde(f), tilde(g))$ en $C^A times C^B$ tales que $phi(f, g) = phi(tilde(f), tilde(g))$. Que dos funciones sean iguales significa que coinciden en cada punto del dominio, es decir

  $ phi_(f,g)(x) = phi_(tilde(f), tilde(g))(x) quad "para todo" x in A union B. $

  Tomemos primero $x in A$. Por la definición de ambas funciones, $f(x) = phi_(f,g)(x) = phi_(tilde(f), tilde(g))(x) = tilde(f)(x)$. Como esto vale para *todo* $x in A$, y $f$ y $tilde(f)$ tienen el mismo dominio y el mismo codominio, resulta $f = tilde(f)$. Tomando ahora $x in B$ se obtiene de la misma forma $g = tilde(g)$. Luego $(f, g) = (tilde(f), tilde(g))$ y $phi$ es inyectiva.

  *$phi$ es sobreyectiva.* Sea $h in C^(A union B)$, es decir, $h : A union B -> C$. Como $A subset.eq A union B$ y $B subset.eq A union B$, podemos restringir $h$ a cada pedazo y definir

  $ f = h|_A : A -> C, quad g = h|_B : B -> C, $

  o sea $f(x) = h(x)$ para todo $x in A$ y $g(x) = h(x)$ para todo $x in B$. Estas dos funciones existen sin necesidad de ninguna hipótesis: restringir una función a un subconjunto de su dominio siempre da una función. Tenemos entonces $(f, g) in C^A times C^B$.

  Falta ver que ese par es efectivamente una preimagen de $h$, o sea que $phi(f, g) = h$. Las dos son funciones de $A union B$ en $C$, así que alcanza con compararlas punto a punto. Sea $x in A union B$:

  - si $x in A$, entonces $phi_(f,g)(x) = f(x) = h(x)$;
  - si $x in B$, entonces $phi_(f,g)(x) = g(x) = h(x)$.

  En cualquier caso $phi_(f,g)(x) = h(x)$, con lo cual $phi(f, g) = h$ y $phi$ es sobreyectiva.

  Siendo $phi$ inyectiva y sobreyectiva, es biyectiva, y por lo tanto $C^A times C^B tilde.op C^(A union B)$.
]

#resolucion[Alternativa: construyendo $phi^(-1)$ explícitamente][
  El argumento de sobreyectividad de arriba, en el fondo, ya construye la inversa: dado $h$, el par que se exhibe es siempre el mismo, $(h|_A, h|_B)$. Vale la pena escribirlo directamente, con el mismo esquema del ejemplo anterior ($B^A tilde.op Y^X$): exhibir la candidata y verificar las *dos* composiciones.

  Definimos

  $ psi : C^(A union B) -> C^A times C^B, quad psi(h) = (h|_A, h|_B). $

  *$psi$ está bien definida* (y sin usar ninguna hipótesis sobre $A$ y $B$): las restricciones de $h$ a los subconjuntos $A$ y $B$ de su dominio son funciones $A -> C$ y $B -> C$, así que $psi(h) in C^A times C^B$.

  *$psi compose phi = op("id")_(C^A times C^B)$.* Sea $(f, g) in C^A times C^B$ y llamemos $h = phi(f, g) = phi_(f,g)$. Por la definición de $phi_(f,g)$ tenemos $h(x) = f(x)$ para todo $x in A$, es decir $h|_A = f$; y $h(x) = g(x)$ para todo $x in B$, es decir $h|_B = g$. Entonces

  $ psi(phi(f, g)) = psi(h) = (h|_A, h|_B) = (f, g). $

  *$phi compose psi = op("id")_(C^(A union B))$.* Sea $h in C^(A union B)$ y llamemos $f = h|_A$ y $g = h|_B$, de modo que $psi(h) = (f, g)$. Las funciones $phi(f, g)$ y $h$ van ambas de $A union B$ en $C$, así que las comparamos punto a punto: si $x in A$ entonces $phi_(f,g)(x) = f(x) = h(x)$, y si $x in B$ entonces $phi_(f,g)(x) = g(x) = h(x)$. Como $A union B$ no tiene otros elementos,

  $ phi(psi(h)) = phi(f, g) = h. $

  Verificadas las dos composiciones, $phi$ es biyectiva con $phi^(-1) = psi$.

  Observemos que la hipótesis $A inter B = nothing$ no reaparece en ningún paso de esta segunda resolución: se gastó entera en que $phi$ estuviera bien definida. La construcción de $psi$ y las dos verificaciones valen para $A$ y $B$ cualesquiera --- lo que falla sin disjunción es el punto de partida.
]

#ejemplo[Ley exponencial y el cardinal de $NN^NN$ y sus subconjuntos (Clase 3 · Ejercicio 2)][C3-2][
  Hallar el cardinal de:

  #set enum(numbering: "a)")
  + $NN^NN$.
  + $A = {(a_n)_n in NN^NN : a_n != a_m "si" n != m}$ (las sucesiones inyectivas).
  + $A = {(a_n)_n in NN^NN : a_n divides a_(n+1) "para todo" n in NN}$.
]

#estrategia[Contar con exponentes, y después justificar][
  Si tratamos a los cardinales como si fueran números, el ítem (a) se "adivina" en una línea:

  $ \#NN^NN = aleph_0^(aleph_0) <= (2^(aleph_0))^(aleph_0) = 2^(aleph_0 times aleph_0) = 2^(aleph_0). $

  Esto *no es un argumento formal*, pero dice exactamente qué hay que probar: el paso $(2^(aleph_0))^(aleph_0) = 2^(aleph_0 times aleph_0)$ es la *ley exponencial* $(A^B)^C tilde.op A^(B times C)$, y el resto son coordinabilidades que ya conocemos. Los ítems (b) y (c) son subconjuntos de $NN^NN$: para ellos la inyección hacia $RR$ sale gratis de (a), y lo que hay que construir es la inyección de vuelta.
]

#sublema(titulo: "Lema auxiliar: la ley exponencial")[
  Para conjuntos $A$, $B$, $C$ cualesquiera vale $(A^B)^C tilde.op A^(B times C)$.

  Un elemento de $(A^B)^C$ es una función $f : C -> A^B$, y uno de $A^(B times C)$ es una función $g : B times C -> A$. Definimos

  $ Phi : (A^B)^C -> A^(B times C), quad Phi(f)(b, c) := (f(c))(b), $

  donde usamos que $f(c) in A^B$, o sea que $f(c)$ es a su vez una función. Definimos también

  $ Psi : A^(B times C) -> (A^B)^C, quad [Psi(g)(c)](b) := g(b, c). $

  Las dos están bien definidas, y

  $ Phi(Psi(g))(b, c) &= [Psi(g)(c)](b) = g(b, c), quad & "es decir" Phi compose Psi = op("id")_(A^(B times C)), \
    [Psi(Phi(f))(c)](b) &= Phi(f)(b, c) = (f(c))(b), quad & "es decir" Psi compose Phi = op("id")_((A^B)^C). $

  Concluimos que $(A^B)^C tilde.op A^(B times C)$. Es el mismo esquema de los dos ejemplos anteriores: exhibir la inversa y verificar las dos composiciones.
]

#resolucion[
  *(a) $NN^NN tilde.op RR$.* Una inyección en un sentido es fácil: $f : {0,1}^NN -> NN^NN$, $f((a_n)_n) = (a_n)_n$, es inyectiva, y como ${0,1}^NN tilde.op RR$, tenemos $RR -> NN^NN$ inyectiva.

  Para la otra, la inclusión da una inyección $NN^NN -> RR^NN$, y ahora encadenamos:

  $ RR^NN tilde.op ({0,1}^NN)^NN tilde.op {0,1}^(NN times NN) tilde.op cal(P)(NN times NN) tilde.op cal(P)(NN), $

  donde el primer paso usa $RR tilde.op {0,1}^NN$, el segundo es la *ley exponencial*, el tercero es el Ejercicio 8 (a) de la Práctica 2 y el último usa $NN times NN tilde.op NN$ (Ejemplo 14). Como $cal(P)(NN) tilde.op RR$, resulta $RR^NN tilde.op RR$ y por lo tanto existe $p : NN^NN -> RR$ inyectiva. Por el Teorema de Cantor-Schröeder-Bernstein, $NN^NN tilde.op RR$.

  *(b) Las sucesiones inyectivas.* Por (a) tenemos $f : A -> RR$ inyectiva. Para la vuelta construimos

  $ g : {B subset.eq NN : \#B = aleph_0} -> A $

  que a cada subconjunto infinito de $NN$ le asigna su *enumeración creciente*, definida inductivamente:

  $ g(B)_1 := op("mín")(B), quad g(B)_(k+1) := op("mín")(B without {g(B)_i : i <= k}), $

  todos bien definidos por el principio de buena ordenación y porque $B$, al ser infinito, nunca se agota. Por construcción $g(B)_1 < g(B)_2 < dots$, así que $g(B)$ es una sucesión inyectiva y $g$ está bien definida.

  $g$ es inyectiva: si $B != tilde(B)$, sea $m$ el mínimo elemento en el que difieren, digamos $m in B without tilde(B)$. Como $B$ y $tilde(B)$ coinciden por debajo de $m$, sus enumeraciones crecientes coinciden en los primeros $j$ lugares, donde $j = \#{x in B : x < m}$, y en el lugar $j + 1$ vale $g(B)_(j+1) = m$ mientras que $g(tilde(B))_(j+1) > m$. Luego $g(B) != g(tilde(B))$.

  Falta ver que ${B subset.eq NN : \#B = aleph_0} tilde.op RR$. Por el Ejercicio 11 de la Práctica 2, ${B subset.eq NN : B "finito"}$ es numerable; como

  $ cal(P)(NN) = {B subset.eq NN : B "finito"} union.sq {B subset.eq NN : \#B = aleph_0} $

  y $cal(P)(NN) tilde.op RR$, por el Ejercicio 3 (a) de la Práctica 2 el segundo pedazo tiene cardinal $frak(c)$. Existe entonces $g : RR -> A$ inyectiva y, por Cantor-Schröeder-Bernstein, $A tilde.op RR$.

  *(c) Las cadenas de divisibilidad.* Por (a), existe $f : A -> RR$ inyectiva. Para la vuelta, notemos que si $a_n divides a_(n+1)$ entonces $a_(n+1) = k_n a_n$ para algún $k_n in NN$, y por lo tanto la sucesión queda determinada por $a_1$ y por $(k_n)_n$:

  $ a_1, quad a_2 = k_1 a_1, quad a_3 = k_2 k_1 a_1, quad dots, quad a_(n+1) = k_n dots.h.c k_1 a_1. $

  Definimos entonces $g : NN times NN^NN -> A$ por

  $ (g(a, (k_n)_n))_m := a dot product_(i=1)^(m-1) k_i, quad "con la convención" product_(i=1)^0 k_i = 1. $

  Está bien definida, porque $a_(m+1) = a product_(i=1)^m k_i = (a product_(i=1)^(m-1) k_i) k_m = a_m k_m$, o sea $a_m divides a_(m+1)$.

  Es inyectiva: si $(a_m)_m = g(a, (k_n)_n)$ y $(b_m)_m = g(tilde(a), (tilde(k)_n)_n)$ cumplen $a_m = b_m$ para todo $m$, entonces $a = a_1 = b_1 = tilde(a)$; y dado $n in NN$, de $a_n k_n = a_(n+1) = b_(n+1) = b_n tilde(k)_n$ con $a_n = b_n != 0$ se concluye $k_n = tilde(k)_n$.

  Por último, $NN times NN^NN tilde.op NN times RR$ por (a), y $NN times RR tilde.op RR$: en efecto, $NN times RR = union.sq_(m in NN) {m} times RR$ con ${m} times RR tilde.op RR$, o sea que es unión contable de conjuntos de cardinal $frak(c)$ y por lo tanto tiene cardinal $frak(c)$ (Ejercicio 7 (b) de la Práctica 2). Existe entonces $g : RR -> A$ inyectiva y, por Cantor-Schröeder-Bernstein, $A tilde.op RR$.

  _Observación:_ la función $g : NN times NN^NN -> A$ del ítem (c) es, de hecho, biyectiva.
]

#sublema(titulo: "Corrección al manuscrito en (b)")[
  El original prueba la inyectividad de $g$ así: "supongamos $B != tilde(B)$; sea $k = op("mín"){k in NN : k in B without tilde(B)}$; por definición $g(B)_k != g(tilde(B))_k$".

  El paso usa a $k$ a la vez como *elemento* de $B$ y como *índice* de la sucesión, y eso no cierra: el elemento $m$ donde los conjuntos empiezan a diferir no tiene por qué ocupar el lugar $m$ de la enumeración. La conclusión igual vale, y arreglarlo es contar cuántos elementos de $B$ hay por debajo de $m$ para saber en qué lugar aparece; es la versión que se transcribió arriba.
]

#ejemplo[Cardinal de un subconjunto de $RR^3$ definido por condiciones (Clase 3 · Ejercicio 1)][C3-1][
  Hallar el cardinal de
  $ X = {(x, y, z) in RR^3 : x in QQ, med y in RR without QQ, med z in NN "es par"}. $
]

#estrategia[Sándwich: una inyección para cada lado][
  Cuando el conjunto está "encajado" entre dos conjuntos de cardinal conocido, no hace falta construir ninguna biyección: se exhibe una inyección en cada sentido y se invoca Cantor-Schröeder-Bernstein. Para la inyección que sale de $X$ alcanza con la inclusión en $RR^3$; para la que entra, basta con encontrar *una sola* copia grande adentro de $X$, fijando todas las coordenadas menos una.
]

#resolucion[
  Como $X subset.eq RR^3$, la inclusión da una función inyectiva $X -> RR^3$. Y como $RR^3 tilde.op RR$ (Ejercicio 14 (c) de la Práctica 2), componiendo obtenemos $f : X -> RR$ inyectiva, es decir $\#X <= \#RR$.

  Por otro lado, la función

  $ g : RR without QQ -> X, quad g(y) = (0, y, 2) $

  es inyectiva (si $g(y) = g(y')$, comparando la segunda coordenada, $y = y'$), y está bien definida porque $0 in QQ$, $y in RR without QQ$ y $2 in NN$ es par. Como $RR tilde.op RR without QQ$ (el cardinal de los irracionales es $frak(c)$, Ejercicio 4 de la Práctica 2), componiendo obtenemos $g : RR -> X$ inyectiva, o sea $\#RR <= \#X$.

  Por el Teorema de Cantor-Schröeder-Bernstein existe $F : X -> RR$ biyectiva, y concluimos que $\#X = \#RR = frak(c)$.
]

#ejemplo[Cardinal de las sucesiones enteras que se mueven de a un paso (Clase 3 · Ejercicio 3)][C3-3][
  Hallar el cardinal de
  $ A = {(a_n)_n subset.eq ZZ : abs(a_(n+1) - a_n) = 1 "para todo" n in NN}. $
]

#estrategia[Cuando en cada paso hay dos opciones, aparece ${0,1}^NN$][
  Si $a_1 = 1$, entonces $a_2 in {0, 2}$; para cada uno de esos hay de nuevo dos posibilidades, y así siguiendo. El esquema es un árbol binario:

  #align(center)[
    $ a_1 = 1 -> cases(
      a_2 = 2 -> cases(a_3 = 3 -> dots.v, a_3 = 1 -> dots.v),
      a_2 = 0 -> cases(a_3 = 1 -> dots.v, a_3 = -1 -> dots.v),
    ) $
  ]

  En cada paso hay exactamente *dos posibilidades*, $a_(n+1) = a_n + 1$ o $a_(n+1) = a_n - 1$. Elegir un elemento de $A$ con $a_1$ fijo es entonces lo mismo que elegir una sucesión de decisiones binarias: eso es lo que sugiere codificar con ${0,1}^NN$.
]

#resolucion[
  Definimos $f : {0,1}^NN -> A$ mandando $(b_k)_k$ a la sucesión $a_n := f((b_k)_k)_n$ dada por

  $ cases(
    a_1 = 1,
    a_(n+1) = a_n + 1 & "si" b_n = 1,
    a_(n+1) = a_n - 1 & "si" b_n = 0,
  ) $

  o, de manera más compacta, $a_1 = 1$ y $a_(n+1) = a_n + (-1)^(b_n + 1)$ para todo $n in NN$.

  Por ejemplo, si $b_1 = 1, b_2 = 0, b_3 = 0, b_4 = 1, b_5 = 0, b_6 = 0, b_7 = 1, dots$, queda

  $ a_1 = 1, med a_2 = 2, med a_3 = 1, med a_4 = 0, med a_5 = 1, med a_6 = 0, med a_7 = -1, med a_8 = 0, dots $

  - *$f$ está bien definida:* $abs(a_(n+1) - a_n) = abs((-1)^(b_n + 1)) = 1$, así que $f((b_k)_k) in A$.
  - *$f$ es inyectiva:* sean $a_n := f((b_k)_k)_n$ y $tilde(a)_n := f((c_k)_k)_n$ con $a_n = tilde(a)_n$ para todo $n in NN$. Entonces
    $ a_n + (-1)^(b_n + 1) = a_(n+1) = tilde(a)_(n+1) = tilde(a)_n + (-1)^(c_n + 1) quad "para todo" n in NN, $
    y como $a_n = tilde(a)_n$ resulta $(-1)^(b_n) = (-1)^(c_n)$. Siendo $b_n, c_n in {0, 1}$, se sigue $b_n = c_n$ para todo $n$.

  Por otra parte, $A subset.eq ZZ^NN$, y como $ZZ tilde.op NN$ vale $ZZ^NN tilde.op NN^NN tilde.op {0,1}^NN$ (esta última por el ítem (a) del Ejercicio C3-2). Existe entonces $g : A -> {0,1}^NN$ inyectiva.

  Por el Teorema de Cantor-Schröeder-Bernstein, $A tilde.op {0,1}^NN tilde.op RR$.

  _Nota:_ el manuscrito original dice $A subset.eq NN^NN$, pero $A$ contiene sucesiones con el cero y con enteros negativos (mirá el ejemplo de arriba, con $a_4 = 0$ y $a_7 = -1$), así que en rigor $A subset.eq ZZ^NN$; se agregó el paso $ZZ tilde.op NN$ para completar el argumento.
]

#ejemplo[Una familia con condición local de contabilidad es contable (Clase 3 · Ejercicio 4)][C3-4][
  Sea $cal(F)$ una familia de subconjuntos no vacíos de $RR$ tal que para cada $x in RR$ existe $epsilon_x > 0$ con
  $ \#{F in cal(F) : F inter (x - epsilon_x, x + epsilon_x) != nothing} <= aleph_0. $
  Probar que $cal(F)$ es contable.
]

#estrategia[Pasar de un índice no contable a uno contable][
  La hipótesis da un entorno bueno alrededor de *cada* real, y los reales no son contables: si armamos la unión indexada por $RR$ no ganamos nada, porque unión no contable de contables no tiene por qué ser contable. Hay que reindexar por algo contable.

  Lo natural es usar intervalos *con centro y radio racionales*: hay una cantidad contable de ellos, y por densidad de $QQ$ todo entorno $(x - epsilon_x, x + epsilon_x)$ contiene uno de ellos que además contiene a $x$. Cada intervalo racional que entra adentro de un entorno bueno hereda la contabilidad, y ahí sí la unión es contable de contables.
]

#resolucion[
  Llamemos, para $q in QQ$ y $r in QQ_(>0)$,
  $ cal(F)_(q,r) = {F in cal(F) : F inter (q - r, q + r) != nothing}, $
  y sea
  $ P = {(q, r) in QQ times QQ_(>0) : cal(F)_(q,r) "es contable"}. $

  Como $QQ times QQ_(>0)$ es contable (es un subconjunto de $QQ times QQ$, numerable por ser producto de numerables), $P$ es contable. Afirmamos que
  $ cal(F) = union_((q,r) in P) cal(F)_(q,r). $

  La contención $supset.eq$ es clara, porque cada $cal(F)_(q,r)$ es un subconjunto de $cal(F)$.

  Para la otra, sea $F in cal(F)$. Como $F != nothing$, podemos tomar $x in F$, y la hipótesis nos da $epsilon_x > 0$ tal que ${G in cal(F) : G inter (x - epsilon_x, x + epsilon_x) != nothing}$ es contable. Por densidad de $QQ$ elegimos $q in QQ$ con $abs(x - q) < epsilon_x / 2$, y de nuevo por densidad un racional $r$ con
  $ abs(x - q) < r < epsilon_x / 2. $

  Con esa elección:

  - $x in (q - r, q + r)$, porque $abs(x - q) < r$;
  - $(q - r, q + r) subset.eq (x - epsilon_x, x + epsilon_x)$, porque si $abs(y - q) < r$ entonces
    $ abs(y - x) <= abs(y - q) + abs(q - x) < r + epsilon_x / 2 < epsilon_x / 2 + epsilon_x / 2 = epsilon_x. $

  De la segunda propiedad se sigue que $cal(F)_(q,r) subset.eq {G in cal(F) : G inter (x - epsilon_x, x + epsilon_x) != nothing}$, que es contable; luego $cal(F)_(q,r)$ es contable y $(q, r) in P$. De la primera, $x in F inter (q - r, q + r)$, así que $F in cal(F)_(q,r)$.

  Concluimos que $cal(F) subset.eq union_((q,r) in P) cal(F)_(q,r)$ y por lo tanto vale la igualdad. Siendo $P$ contable y cada $cal(F)_(q,r)$ con $(q,r) in P$ contable, $cal(F)$ es unión contable de contables y por lo tanto es contable.
]

#sublema(titulo: "Corrección al manuscrito")[
  El original indexa directamente por $QQ$: aplica la hipótesis en cada $q in QQ$ para obtener $epsilon_q > 0$, define $cal(F)_q = {F : F inter (q - epsilon_q, q + epsilon_q) != nothing}$ y, para cubrir un $F$ con $x in F$ irracional, pide un $q in QQ$ con $abs(x - q) < epsilon_q$.

  Ese último paso no se puede conseguir. El $epsilon_q$ viene dado por la hipótesis *en $q$*, no lo elegimos nosotros, y nada impide que los $epsilon_q$ de todos los racionales cercanos a $x$ sean mucho más chicos que la distancia de $x$ a ellos; la densidad de $QQ$ da racionales arbitrariamente cerca de $x$, pero no controla el radio que cada uno trae puesto.

  La reparación es no dejar que el radio venga impuesto: se lo elige uno, racional, adentro del entorno bueno de $x$. Eso es lo que hace la resolución de arriba, y es *razonamiento agregado*, no transcripción del manuscrito.
]

#v(10pt)

== Bloque 8 · Métricas: verificar los axiomas

#sublema(titulo: "Qué desbloquea")[
  El *Ejercicio 1* de la Práctica 3 pide probar que varios espacios son métricos, y el *Ejercicio 2* decidir cuáles de unas funciones dadas lo son. Los cuatro ejemplos de este bloque cubren el repertorio completo de maniobras: reducir la lista de axiomas a verificar, tratar una métrica definida por casos, trabajar con supremos de funciones, y truncar una métrica existente. Los tres últimos son, además, los modelos para $C([0,1])$ del Ejercicio 1 (e) y para el Ejercicio 11.
]

#ejemplo[Dos axiomas alcanzan para tener una métrica (Clase 3 · Ejercicio 5)][C3-5][
  Sea $d : M times M -> RR$ una función tal que

  #set enum(numbering: "a)")
  + $d(x, y) = 0 <==> x = y$;
  + $d(x, z) <= d(x, y) + d(z, y)$ para todos $x, y, z in M$.

  Probar que $d$ es una métrica.
]

#estrategia[Sacarle la simetría y la positividad a la desigualdad triangular torcida][
  Notemos que (b) *no* es la desigualdad triangular usual: el último término es $d(z, y)$ y no $d(y, z)$. Esa asimetría es a propósito, y es lo que permite obtener la simetría gratis: especializando $y = x$ en (b) queda $d(x, y) <= d(x, x) + d(y, x) = d(y, x)$, y por el mismo argumento con los papeles cambiados sale la otra desigualdad. Una vez que hay simetría, (b) *es* la desigualdad triangular, y la positividad sale de aplicarla con $z = x$.
]

#resolucion[
  Sólo hay que verificar las dos propiedades que faltan:

  - *(c)* si $x != y$ entonces $d(x, y) > 0$;
  - *(d)* $d(x, y) = d(y, x)$.

  *(d) Simetría.* Usando (b) con $y$ reemplazado por $x$, y después (a) para $d(x,x) = 0$,
  $ d(x, y) <=^("b") d(x, x) + d(y, x) = d(y, x). $
  De manera completamente análoga, intercambiando los papeles de $x$ e $y$, se obtiene $d(y, x) <= d(x, y)$. Por lo tanto $d(x, y) = d(y, x)$.

  *(c) Positividad.* Aplicando (a) y luego (b) con $z = x$, y usando la simetría recién probada,
  $ 0 =^("a") d(x, x) <=^("b") d(x, y) + d(y, x) = 2 d(x, y), $
  con lo cual $d(x, y) >= 0$ para todos $x, y in M$. Si además $x != y$, por (a) sabemos que $d(x, y) != 0$, y en consecuencia $d(x, y) > 0$.

  Con la simetría, la propiedad (b) es exactamente la desigualdad triangular, así que $d$ es una métrica.
]

#sublema(titulo: "Para qué sirve")[
  La moraleja es práctica: para verificar que una función es métrica alcanza con chequear (a) y la desigualdad triangular en la forma torcida de (b). La simetría y la positividad se deducen. Conviene tenerlo a mano para los ítems del Ejercicio 1 de la Práctica 3.
]

#ejemplo[La métrica del peine en $RR^2$ (Clase 3 · Ejercicio 6)][C3-6][
  Probar que la función $d : RR^2 times RR^2 -> RR$ dada por
  $ d((x, y), (x', y')) = cases(
    abs(y - y') & "si" x = x',
    abs(x - x') + abs(y) + abs(y') & "si" x != x',
  ) $
  es una métrica en $RR^2$.
]

#estrategia[Métrica definida por casos: separar según cuántas abscisas coinciden][
  Para moverse entre dos puntos con abscisas distintas hay que "bajar al eje $x$", cruzar, y volver a subir: eso es lo que mide el segundo caso. Al verificar la desigualdad triangular con un tercer punto $(x'', y'')$, lo único que importa es cuáles de las tres abscisas $x, x', x''$ coinciden, así que la demostración se organiza en esos casos. La cota que hace funcionar todo es $abs(y - y'') <= abs(y) + abs(y'')$: pasar por el eje nunca es más barato que ir derecho.
]

#resolucion[
  Empecemos observando que $d((x, y), (x', y')) = d((x', y'), (x, y))$: los dos casos son simétricos en las dos entradas, y $abs(y - y') = abs(y' - y)$, $abs(x - x') = abs(x' - x)$.

  *(a) $d((x, y), (x', y')) = 0 <==> (x, y) = (x', y')$.*

  Si $(x, y) = (x', y')$, en particular $x = x'$, así que estamos en el primer caso y $d((x,y),(x',y')) = abs(y - y') = 0$.

  Recíprocamente, supongamos $d((x, y), (x', y')) = 0$. Si fuera $x != x'$, tendríamos
  $ d((x, y), (x', y')) = abs(x - x') + abs(y) + abs(y') >= abs(x - x') > 0, $
  absurdo. Entonces $x = x'$, y en tal caso $0 = d((x,y),(x',y')) = abs(y - y')$, de donde $y = y'$.

  *(b) Desigualdad triangular.* Queremos ver que
  $ d((x, y), (x', y')) <= d((x, y), (x'', y'')) + d((x'', y''), (x', y')). $

  - Si $x = x' = x''$, los tres términos caen en el primer caso y
    $ abs(y - y') <= abs(y - y'') + abs(y'' - y'), $
    que es la desigualdad triangular en $RR$.
  - Si $x = x' != x''$, el término de la izquierda cae en el primer caso y los dos de la derecha en el segundo:
    $ abs(y - y') &<= abs(y - y'') + abs(y'' - y') <= abs(y) + abs(y'') + abs(y'') + abs(y') \
      &<= abs(x - x'') + abs(y) + abs(y'') + abs(x'' - x') + abs(y'') + abs(y') \
      &= d((x, y), (x'', y'')) + d((x'', y''), (x', y')). $

  _Observación:_ los casos restantes (los que tienen $x != x'$) se prueban de forma análoga a los desarrollados arriba, separando según $x''$ coincida o no con $x$ o con $x'$.
]

#ejemplo[La métrica $C^1$ en $[0,1]$ (Clase 3 · Ejercicio 7)][C3-7][
  Sea $X = {f : [0,1] -> RR "continuas tales que" f' "es continua en" [0,1]}$ y definamos
  $ d : X times X -> RR, quad d(f, g) = norm(f - g)_infinity + norm(f' - g')_infinity = sup_(x in [0,1]) abs(f(x) - g(x)) + sup_(x in [0,1]) abs(f'(x) - g'(x)). $
  Probar que $d$ es una métrica.
]

#estrategia[Primero que la fórmula tenga sentido, después acotar puntualmente y tomar supremo][
  Antes de verificar los axiomas hay que asegurarse de que los dos supremos son finitos: eso lo da el teorema de Weierstrass, porque $f$ y $f'$ son continuas en un compacto.

  Para la desigualdad triangular, la maniobra es la de siempre con supremos: se acota *puntualmente* por una cota que ya no depende de $x$, y recién ahí se toma supremo del lado izquierdo. Se hace por separado para $f$ y para $f'$, y se suman las dos desigualdades.
]

#resolucion[
  Notemos primero que $d$ tiene sentido: por el teorema de Weierstrass, $f$ y $f'$ son continuas en el compacto $[0,1]$ y por lo tanto acotadas, así que los dos supremos son finitos. Notemos también que $d(f, g) = d(g, f)$, porque $abs(f(x) - g(x)) = abs(g(x) - f(x))$ para todo $x$ y lo mismo para las derivadas.

  *(a) $d(f, g) = 0 <==> f = g$.* Es claro que $d(f, f) = 0$. Recíprocamente, si $d(f, g) = 0$, como los dos sumandos son no negativos,
  $ 0 = d(f, g) >= sup_(x in [0,1]) abs(f(x) - g(x)) >= abs(f(x) - g(x)) quad "para todo" x in [0,1], $
  con lo cual $abs(f(x) - g(x)) = 0$, es decir $f(x) = g(x)$ para todo $x in [0,1]$, o sea $f = g$.

  *(b) Desigualdad triangular.* Sean $f, g, h in X$. Para cada $x in [0,1]$,
  $ abs(f(x) - g(x)) <= abs(f(x) - h(x)) + abs(h(x) - g(x)) <= sup_(x in [0,1]) abs(f(x) - h(x)) + sup_(x in [0,1]) abs(h(x) - g(x)). $
  El miembro derecho no depende de $x$, así que es una cota superior del conjunto de la izquierda y podemos tomar supremo:
  $ sup_(x in [0,1]) abs(f(x) - g(x)) <= sup_(x in [0,1]) abs(f(x) - h(x)) + sup_(x in [0,1]) abs(h(x) - g(x)). quad (1) $
  El mismo razonamiento aplicado a las derivadas da
  $ sup_(x in [0,1]) abs(f'(x) - g'(x)) <= sup_(x in [0,1]) abs(f'(x) - h'(x)) + sup_(x in [0,1]) abs(h'(x) - g'(x)). quad (2) $
  Sumando $(1)$ y $(2)$ y reagrupando,
  $ d(f, g) &= sup_(x in [0,1]) abs(f(x) - g(x)) + sup_(x in [0,1]) abs(f'(x) - g'(x)) \
    &<= sup_(x in [0,1]) abs(f(x) - h(x)) + sup_(x in [0,1]) abs(f'(x) - h'(x)) + sup_(x in [0,1]) abs(h(x) - g(x)) + sup_(x in [0,1]) abs(h'(x) - g'(x)) \
    &= d(f, h) + d(h, g). $

  Concluimos que $d$ es una métrica.
]

#ejemplo[Truncar una métrica: $d' = min{1, d}$ (Clase 3 · Ejercicio 8)][C3-8][
  Sea $d : X times X -> RR$ una métrica en $X$. Probar que $d'(x, y) := min{1, d(x, y)}$ es una métrica en $X$.
]

#estrategia[Separar según el lado izquierdo llegue o no a 1][
  La simetría y el axioma (a) son inmediatos. Lo único que hay trabajo es la desigualdad triangular
  $ min{1, d(x,y)} <= min{1, d(x,z)} + min{1, d(z,y)}, $
  y conviene partir según el miembro izquierdo valga $1$ (o sea $d(x,y) >= 1$) o valga $d(x,y)$.

  En el primer caso hay que probar que el miembro derecho llega a $1$; en el segundo, alcanza con ver que cada término truncado no perdió demasiado. En los dos, la observación clave es que $min{1, t} = t$ cuando $t <= 1$ y $min{1, t} = 1 >= t'$ para cualquier $t' <= 1$.
]

#resolucion[
  Notemos primero que $d'(x, y) = d'(y, x)$, porque $d$ es simétrica.

  *(a)* Si $x = y$, entonces $d'(x, x) = min{1, d(x, x)} = min{1, 0} = 0$, usando que $d(x,x) = 0$ por ser $d$ métrica. Recíprocamente, si $d'(x, y) = 0$ entonces $min{1, d(x,y)} = 0$, y como $1 != 0$ debe ser $d(x, y) = 0$, o sea $x = y$.

  *(b)* Queremos ver que
  $ min{1, d(x,y)} <= min{1, d(x,z)} + min{1, d(z,y)}. quad (star) $

  *Caso 1: $d(x, y) >= 1$.* El miembro izquierdo de $(star)$ vale $1$, así que hay que ver que el derecho es $>= 1$. Si alguno de $d(x,z)$, $d(z,y)$ es $>= 1$, el término correspondiente vale $1$ y listo. Si en cambio los dos son $< 1$, entonces $min{1, d(x,z)} = d(x,z)$ y $min{1, d(z,y)} = d(z,y)$, y por la desigualdad triangular de $d$,
  $ min{1, d(x,z)} + min{1, d(z,y)} = d(x,z) + d(z,y) >= d(x,y) >= 1. $

  *Caso 2: $d(x, y) <= 1$.* Ahora $(star)$ es
  $ d(x, y) <= min{1, d(x,z)} + min{1, d(z,y)}. quad (star star) $
  Si alguno de $d(x,z)$, $d(z,y)$ es $>= 1$, digamos $d(x,z) >= 1$, entonces
  $ d(x, y) <= 1 = min{1, d(x,z)} <= min{1, d(x,z)} + min{1, d(z,y)}. $
  Si en cambio $d(x,z) <= 1$ y $d(z,y) <= 1$, los dos mínimos son los propios valores y $(star star)$ se convierte en
  $ d(x, y) <= d(x, z) + d(z, y), $
  que es cierta por ser $d$ una métrica.

  En todos los casos vale $(star)$, así que $d'$ es una métrica.
]

#sublema(titulo: "Corrección al manuscrito")[
  En el Caso 1 el original razona: de $1 <= d(x,y) <= d(x,z) + d(z,y)$ se sigue que "alguna entre $d(x,z), d(z,y)$ es al menos $1$".

  Eso no se sigue: dos números pueden sumar $1$ o más sin que ninguno llegue a $1$ (por ejemplo $0,5 + 0,5$). La conclusión del caso igual vale, y el arreglo es una línea: si ninguno llega a $1$, entonces los dos mínimos son los propios valores y su suma es $d(x,z) + d(z,y) >= d(x,y) >= 1$. Es la versión que se transcribió arriba.
]

#v(10pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

#sublema(titulo: "Huecos frente a la Práctica 1")[
  Con los 12 ejemplos del apunte y los 19 de clase, quedan sólo dos técnicas sin ningún ejemplo trabajado en todo el repositorio. Cuando aparezca una en clase, cargala con `/ejemplo` en el bloque indicado:

  #set enum(numbering: "1.")
  + *Divergencia a $plus.minus oo$ por definición* --- *Ej. 9 (b)--(d)*, *Ej. 12 (b)*, y la segunda mitad del *Ej. 14*. De `apuntes.typ` sólo está la definición, y ninguna demostración usa el cuantificador "para todo $M > 0$": lo más cerca que hay es el Ejemplo C1-4, que invoca $a_m -> +oo$ sin probarlo por definición. → Bloque 6 o bloque nuevo.
  + *Punto fijo vía supremo* --- el ejercicio del anexo de p1 (edición 2025). Sin material de ningún tipo. → Bloque 1 o bloque nuevo.
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
