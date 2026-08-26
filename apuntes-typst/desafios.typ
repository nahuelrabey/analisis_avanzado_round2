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


// --- Archivo Acumulativo de Desafíos ---
// Ordenado por dependencias hacia `guias/p1.typ`: cada bloque supone hechos los anteriores.
// Ver `proposals/orden_desafios_p1.md` para el criterio completo.

#align(center)[
  #text(14pt, weight: "bold")[Desafíos --- Análisis Avanzado] \
  #v(2pt)
  #text(10pt)[Ordenados como cadena de insumos para la Práctica 1]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

Los desafíos están agrupados por *dependencia*, no por orden de transcripción: cada bloque
supone resueltos los de arriba. La última columna dice a qué ejercicios de `guias/p1.typ`
alimenta cada bloque.

#v(5pt)

#show table.cell.where(y: 0): set text(fill: white, weight: "bold", size: 8.5pt)

#block[
  #set text(size: 8.5pt)
  #table(
    columns: (0.5fr, 3.5fr, 1.2fr),
    align: (center + horizon, left + top, center + horizon),
    fill: (x, y) => if y == 0 { rgb("#0c4a6e") } else if calc.even(y) { rgb("#f8fafc") } else { white },
    stroke: 0.4pt + rgb("#cbd5e1"),
    inset: (x: 6pt, y: 5pt),

    [*Bloque*], [*Tema*], [*Alimenta*],

    [1], [Vocabulario de supremo, ínfimo, máximo y mínimo], [Ej. 3, 4 (a), 5],
    [2], [Principio de Arquímedes y sus consecuencias], [Ej. 1, 2, 4 (b--c)],
    [3], [Caracterización $epsilon$ y estructura del supremo], [Ej. 3, 5, 6],
    [4], [Parte entera], [Ej. 2 (a)],
    [5], [Densidad], [Ej. 1, 2],
    [6], [Límite por definición], [Ej. 7, 8],
    [7], [Álgebra de límites], [Ej. 9 (a), 10, 11],
    [8], [Divergencia a $plus.minus oo$], [Ej. 9 (b--d), 12 (b), 14],
    [9], [Monótonas: el supremo y el ínfimo como límite], [Ej. 12 (a), 13],
    [10], [Coordinabilidad y numerabilidad], [p2: Ej. 1, 2],
  )
]

#v(10pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Bloque 1 · Vocabulario de supremo, ínfimo, máximo y mínimo

#sublema(titulo: "Qué desbloquea")[
  El piso de todo lo demás: acá no se usa el Principio de Arquímedes ni sucesiones, sólo la
  definición de cota y de supremo. Alimenta el *Ejercicio 4 (a)* y el *Ejercicio 5*.

  *El orden importa:* los dos últimos son un par --- uno verdadero y uno falso sobre la misma
  operación --- y hacerlos seguidos, en ese orden, es lo que fija el rol de la finitud.
]

#desafio[Observación 1][
  El supremo de un conjunto, si existe, es único. (Demostración: ejercicio).
]
#solucion[
  Sean $s_1$ y $s_2$ dos supremos del conjunto $A subset.eq RR$.
  - Como $s_1$ es supremo y $s_2$ es cota superior de $A$, por definición de supremo se tiene $s_1 <= s_2$.
  - Análogamente, como $s_2$ es supremo y $s_1$ es cota superior de $A$, se tiene $s_2 <= s_1$.

  Por la propiedad antisimétrica del orden en $RR$, concluimos que $s_1 = s_2$.
]

#desafio[Ejercicio 1][
  Sean $a, b in RR$, con $a < b$. Sea $A = (a, b)$. Probar que $b = op("sup")(A)$.
]
#solucion[
  Sea $A = (a, b)$ con $a < b$.
  + *Cota superior:* Para todo $x in (a, b)$, se cumple $x < b <= b$. Luego $b$ es cota superior de $A$.
  + *Menor cota superior:* Sea $t$ una cota superior de $A$. Supongamos que $t < b$.
    - Si $t <= a$, el punto medio $x = (a + b)/2 in A$ cumple $x > a >= t$, contradicción.
    - Si $a < t < b$, elegimos $x = (t + b)/2 in A$, pero $x > t$, contradiciendo que $t$ sea cota superior.

    Por lo tanto, $t >= b$, demostrando que $b = op("sup")(A)$.
]

#desafio[Mínimo del intervalo $(a, b]$][
  Dado el intervalo $(a, b] subset.eq RR$ con $a < b$, probar que no posee mínimo.
]

#desafio[Mínimo de una función cuadrática convexa][
  Sea $f(x)$ una función cuadrática convexa y $A = {f(x) : x in RR}$, demostrar que el vértice es su punto mínimo.
]
#solucion[
  *Demostración:*

  + *Definición y condición de convexidad:*
    Una función cuadrática general $f: RR -> RR$ tiene la forma:
    $ f(x) = a x^2 + b x + c, quad "con " a, b, c in RR, a != 0 $

    Por definición, $f$ es convexa si y solo si su coeficiente principal satisface $a > 0$ (o equivalentemente, $f''(x) = 2a > 0$).

  + *Forma canónica y coordenadas del vértice:*
    Completando cuadrados en la expresión cuadrática:
    $ f(x) = a (x + b/(2a))^2 + (4a c - b^2)/(4a) $

    Definiendo las coordenadas del vértice $(x_v, y_v)$ como $x_v = -b/(2a)$ e $y_v = f(x_v) = (4a c - b^2)/(4a)$, la función se escribe como:
    $ f(x) = a(x - x_v)^2 + y_v $

  + *Prueba de que el vértice es el mínimo de $A$:*
    Para cualquier $x in RR$, se cumple $(x - x_v)^2 >= 0$.

    Como $a > 0$, al multiplicar por $a$ se mantiene el sentido de la desigualdad:
    $ a(x - x_v)^2 >= 0 quad forall x in RR $

    Sumando $y_v$ a ambos lados:
    $ f(x) = a(x - x_v)^2 + y_v >= y_v = f(x_v) quad forall x in RR $

    Esto demuestra que $y_v = f(x_v)$ es cota inferior del conjunto $A = {f(x) : x in RR}$. Como $x_v in RR$, se tiene que $f(x_v) in A$.

    Por lo tanto, $y_v = f(x_v) = min(A)$, probando que el vértice es el punto mínimo del conjunto $A$.
]

#desafio[Máximo de una función cuadrática cóncava][
  Sea $f(x)$ una función cuadrática cóncava y $A = {f(x) : x in RR}$, demostrar que el vértice es su punto máximo.
]
#solucion[
  *Demostración:*

  + *Definición y condición de concavidad:*
    Una función cuadrática general $f: RR -> RR$ tiene la forma:
    $ f(x) = a x^2 + b x + c, quad "con " a, b, c in RR, a != 0 $

    Por definición, $f$ es cóncava si y solo si su coeficiente principal satisface $a < 0$ (o equivalentemente, $f''(x) = 2a < 0$).

  + *Forma canónica y coordenadas del vértice:*
    Completando cuadrados en la expresión cuadrática:
    $ f(x) = a (x + b/(2a))^2 + (4a c - b^2)/(4a) $

    Definiendo las coordenadas del vértice $(x_v, y_v)$ como $x_v = -b/(2a)$ e $y_v = f(x_v) = (4a c - b^2)/(4a)$, la función se escribe como:
    $ f(x) = a(x - x_v)^2 + y_v $

  + *Prueba de que el vértice es el máximo de $A$:*
    Para cualquier $x in RR$, se cumple $(x - x_v)^2 >= 0$.

    Como $a < 0$, al multiplicar por $a$ se invierte el sentido de la desigualdad:
    $ a(x - x_v)^2 <= 0 quad forall x in RR $

    Sumando $y_v$ a ambos lados:
    $ f(x) = a(x - x_v)^2 + y_v <= y_v = f(x_v) quad forall x in RR $

    Esto demuestra que $y_v = f(x_v)$ es cota superior del conjunto $A = {f(x) : x in RR}$. Como $x_v in RR$, se tiene que $f(x_v) in A$.

    Por lo tanto, $y_v = f(x_v) = max(A)$, probando que el vértice es el punto máximo del conjunto $A$.
]

#desafio[Unión de dos conjuntos acotados superiormente][
  Determinar la veracidad de la siguiente afirmación (demostrar o proveer un contraejemplo formal):

  _"La unión de dos conjuntos acotados superiormente es un conjunto acotado superiormente."_
]

#desafio[Unión arbitraria de conjuntos acotados][
  Determinar la veracidad de la siguiente afirmación (demostrar o proveer un contraejemplo formal):

  _"La unión de cualquier cantidad de conjuntos acotados es un conjunto acotado."_
]

#v(10pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Bloque 2 · Principio de Arquímedes y sus consecuencias

#sublema(titulo: "Qué desbloquea")[
  Los *Ejercicios 1 y 2*, y la parte del *Ejercicio 4 (b)--(c)* donde aparece $B = {1/2^n}$.

  *El orden importa:* el primero es el uso más simple de Arquímedes (exhibir un natural
  grande). Los dos siguientes lo convierten en la forma que se usa siempre --- fabricar algo
  *chico* ---, y el cuarto lo aplica ya para cerrar un supremo. La desigualdad $2^n > n$ es
  la herramienta que traduce $1/2^n$ a $1/n$, y sin ella el Ejercicio 4 (b) se traba.
]

#desafio[No acotación de pares $A = {n in NN : n "es par"}$][
  Sea $A = {n in NN : n "es par"}$. Probar formalmente que $A$ no está acotado superiormente.
]
#solucion[
  Sea $M in RR$ arbitrario. Por el Principio de Arquímedes, existe $k in NN$ tal que $k > M$.
  - Si $k$ es par $=> k in A$ y $k > M$.
  - Si $k$ es impar $=> k + 1 in A$ y $k + 1 > k > M$.

  En ambos casos hallamos un elemento de $A$ strictly mayor que $M$. Por lo tanto, $A$ no está acotado superiormente.
]

#desafio[Consecuencia del Principio de Arquímedes ($2/n < x$)][
  Demostrar que, por el Principio de Arquímedes, para todo $x in RR$ con $x > 0$ existe $n in NN$ tal que:
  $ 2/n < x $
]

#desafio[Otra consecuencia del Principio de Arquímedes ($0 < m/n < x$)][
  Demostrar que dado cualquier $x > 0$ en $RR$ y para cualquier entero $m >= 1$ fijo, existe un $n in NN$ tal que:
  $ 0 < m/n < x $
]

#desafio[Supremo de $C = {2 - 1/n : n in NN}$][
  Sea $C = {2 - 1/n : n in NN} = {2 - 1, 2 - 1/2, 2 - 1/3, ...}$. Claramente $2$ es una cota superior de $C$. Demostrar mediante el Principio de Arquímedes que $2 = op("sup")(C)$.
]
#solucion[
  + *Cota superior:* Como $n >= 1 > 0 => 1/n > 0$, tenemos $2 - 1/n < 2$ para todo $n in NN$. Luego $2$ es cota superior de $C$.
  + *Menor cota superior:* Supongamos que existe una cota superior $t < 2$. Sea $epsilon = 2 - t > 0$. Por el Principio de Arquímedes, existe $n_0 in NN$ tal que $1/n_0 < 2 - t => 2 - 1/n_0 > t$. Pero $x_0 = 2 - 1/n_0 in C$, contradicción.

  Concluimos que $2 = op("sup")(C)$.
]

#desafio[Desigualdad $2^n > n$ para $n in NN$][
  Demostrar que $2^n > n$ para todo $n in NN$.
]

#desafio[Cotas y extremos de $A = {n / (n + 1) : n in NN}$][
  Sea $A = {n / (n + 1) : n in NN} subset.eq RR$. Decidir si tiene supremo, máximo, ínfimo y mínimo.

  #v(4pt)
  - _*Estrategia (para el supremo):* Demostrar que $op("sup")(A) = 1$ mediante la caracterización con $epsilon$. Dado $epsilon > 0$, se busca un elemento $a_n = n/(n+1) in A$ tal que $1 - epsilon < n/(n+1)$, lo cual es equivalente a $1/epsilon - 1 < n$. Dicho $n in NN$ existe por el Principio de Arquímedes._
]

#v(10pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Bloque 3 · Caracterización $epsilon$ y estructura del supremo

#sublema(titulo: "Qué desbloquea")[
  El *Ejercicio 3* (la equivalencia con $epsilon$ para el ínfimo), el *Ejercicio 5* y el
  *Ejercicio 6*.

  *El que más rinde:* la *Equivalencia del Axioma de Completitud* es el Ejercicio 6 (a) con
  otro nombre --- el mismo truco de reflejar el conjunto por $-1$ e intercambiar cotas
  superiores por inferiores. El *Supremo de la suma $A + B$* introduce el $epsilon\/2$, que
  reaparece intacto en la demostración de unicidad del límite (Bloque 7).
]

#desafio[Ejercicio 2 (Ínfimo del conjunto de cotas superiores)][
  Sea $A subset.eq RR$ no vacío y acotado superiormente. Sea $C = {"cotas superiores de " A}$. Probar que:

  #set enum(numbering: "1.")
  + $C != nothing$ y acotado inferiormente.
  + $op("ínf")(C) = op("sup")(A)$.
]

#desafio[Equivalencia del Axioma de Completitud (Deducción desde el Teorema 2)][
  Suponiendo como cierto el Teorema 2 (todo conjunto $A subset.eq RR$ no vacío y acotado inferiormente tiene ínfimo en $RR$), deducir el Axioma de Completitud (todo conjunto acotado superiormente y no vacío de $RR$ tiene supremo en $RR$).
]

#desafio[Supremo de la suma de conjuntos $A + B$][
  Sean $A, B subset.eq RR$ no vacíos y acotados superiormente. Definimos $A + B = {a + b : a in A, b in B}$. Hallar, si existe, $op("sup")(A + B)$.

  #v(4pt)
  - _*Estrategia:* El supremo sí existe y el candidato es $op("sup")(A + B) = op("sup")(A) + op("sup")(B)$. Se demuestra utilizando la caracterización con $epsilon$, tomando $epsilon / 2$ para hallar $a in A$ y $b in B$ adecuados._
]

#sublema(titulo: "Ojo: los dos siguientes son el mismo desafío")[
  Los dos enunciados de abajo piden lo mismo (que $sqrt(2) = op("sup")(A)$ para
  $A = {r in QQ : r^2 < 2}$) y ninguno está resuelto. Se conservan los dos porque la baja del
  duplicado no fue autorizada; resolvé uno solo. Ver `proposals/orden_desafios_p1.md`.
]

#desafio[Supremo de $A = {r in QQ : r^2 < 2}$ en $RR$][
  Sea $A = {r in QQ : r^2 < 2}$. Probar que el supremo (en $RR$) de este conjunto es $s = sqrt(2)$.
]

#desafio[Supremo de $A = {r in QQ : r^2 < 2}$][
  Sea $A = {r in QQ : r^2 < 2}$. Demostrar que $sqrt(2) = op("sup")(A)$.
]

#v(10pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Bloque 4 · Parte entera

#sublema(titulo: "Qué desbloquea")[
  El *Ejercicio 2 (a)*: una vez que existe la parte entera, encajar un entero entre $x$ e $y$
  cuando $y - x > 1$ es inmediato.

  *Advertencia de orden:* para probar que $op("sup")(A)$ *es entero*, `p1.typ` sugiere la ruta
  del Ejemplo C1-3 (una sucesión de enteros que converge es finalmente constante), que es
  material de sucesiones y todavía no está disponible acá. La alternativa que mantiene el
  bloque dentro del Capítulo 1 es usar la caracterización $epsilon$ del supremo: tomar
  $k in A$ con $s - 1 < k <= s$ y ver que $k + 1 in.not A$, con lo cual $k = max(A)$.
]

#desafio[Existencia de un número natural intermedio][
  Sean $n, m in NN$ dos números naturales tales que $n > m$ y su distancia es estrictamente mayor a uno ($n - m > 1$).

  Demostrar que existe un número natural $t in NN$ comprendido estrictamente entre ambos, es decir:
  $ m < t < n $
]
#solucion[
  Demostración por absurdo.

  Nuestra hipótesis es que $n>m$ y $n-m>1$. Supongamos que $exists.not t in NN : m < t < n$. Por lo tanto $m<n$, y cómo no hay ningún número entre ellos, debe ocurrir que $n$ es el siguiente de $m$, por lo tanto $n = m+1$. Entonces $n-m = m+1-m =1$ ¡Absurdo! Pues nuestra hipótesis pedía que $n-m>1$. Por lo tanto, debe existir $t in NN$ tal que $m < t < n$
]

#desafio[Parte entera de un número real][
  Dado $x in RR$, se define la parte entera de $x$ como $[x] = max {k in ZZ : k <= x}$.

  Demostrar que $[x]$ está bien definido, es decir, que el conjunto $A = {k in ZZ : k <= x}$ tiene supremo y el supremo pertenece a $A$.
]

#desafio[Existencia de un entero en $(x, x + 1]$][
  Demostrar que, usando el Principio de Arquímedes, para todo $x in RR$ existe $n in ZZ$ tal que:
  $ x < n <= x + 1 $
]

#v(10pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Bloque 5 · Densidad

#sublema(titulo: "Qué desbloquea")[
  Los *Ejercicios 1 y 2 completos*. El Desafío 5.3 *es* el Ejercicio 1, y el Desafío 5.4 *son*
  los cuatro ítems del Ejercicio 2.

  Depende del bloque anterior: el ítem 1 del Desafío 5.4 necesita la existencia de un entero
  en $(x, x+1]$.
]

#desafio[Desafío 5.3][
  Sean $x < y + epsilon$ para todo $epsilon > 0$, deducir que $x <= y$ y que si $|x - y| < epsilon$ para todo $epsilon > 0$ entonces $x = y$.
]
#solucion[
  *Demostración:*

  - *Parte 1 ($x <= y$):* Supongamos que $x > y$, de modo que $x - y > 0$. Sea $delta = x - y$, entonces tomando $delta / 2$ tenemos que $x > y + delta / 2$ pues:
    $ x - y = delta > delta / 2 $
    de modo que existe un $epsilon = delta / 2$ tal que $x lt.eq.not y + epsilon$, esto es el contrarrecíproco que se quería probar.

  - *Parte 2 ($|x - y| < epsilon => x = y$):* Sabiendo que si $x < y + epsilon$ es para todo $epsilon$ entonces $x <= y$, veamos que si $|x - y| < epsilon$ para todo $epsilon$ entonces son iguales.

    Supongamos que $x != y$. De modo que $x < y$ o $y < x$. Supongamos sin pérdida de generalidad que es $x < y$. Entonces, $y - x > 0$, sea $delta = y - x$ entonces tomando $delta / 2$ tenemos que:
    $ |x - y| = y - x > delta / 2 > 0 $

    Por absurdo, supongo que $x < y + epsilon$ para todo $epsilon$ y que $|x - y| < epsilon$ pero que $x != y$. Como por la primera parte $x < y + epsilon => x <= y$ y $x != y$ entonces $x < y$. Tomando $delta = y - x = |x - y|$ tenemos que $y - x = |x - y| > delta / 2$ absurdo, pues supusimos que $|x - y| < epsilon$ para todo $epsilon > 0$.
]

#desafio[Desafío 5.4][
  #set enum(numbering: "1.")
  + Sean $x, y in RR$, si $y - x > 1$, probar que existe un entero entre $x, y$.
  + Si ahora $x < y$, probar que existe un racional entre $x, y$.
  + Si ahora $x, y$ son racionales y $x < y$, probar que existe un irracional entre ellos.
  + Si $x, y$ son reales, probar que existe un irracional entre ellos.

  #v(4pt)
  - _*Estrategia (para el punto 3):* El truco es usar que un intervalo es convexo. La idea es: si tomo $x, y$ racionales en un intervalo, la línea que los une es $sigma(t) = (1 - t)x + t y = x + t(y - x)$. Aprovechando que $x, y$ son racionales, eligiendo un $t$ irracional (por ejemplo $pi/4$ o el que más te guste), se tiene que $x + t(y - x)$ es irracional._
  - _*Estrategia (para el punto 4):* Usar el punto 2 para encontrar números racionales entre los reales $x < y$, y luego aplicar el resultado del punto 3 a esos racionales para hallar el irracional buscado._
]

#v(10pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Bloque 6 · Límite por definición

#sublema(titulo: "Qué desbloquea")[
  Los *Ejercicios 7 y 8*, y la entrada al *Ejercicio 15* por el lado de la negación.

  *El orden importa:* el primero cierra el conjunto $A = {n/(n+1)}$ del Bloque 2, pero ahora
  con la otra herramienta --- allá se buscaba el supremo, acá el límite de la misma expresión.
  El segundo usa la definición *al revés*: elige un $epsilon$ a propósito para forzar que la
  convergencia falle.
]

#desafio[Límite de la sucesión $a_n = n / (n + 1)$][
  Demostrar que $lim_(n -> +oo) n / (n + 1) = 1$.
]

#desafio[Ejemplo 3.1.7][
  La sucesión $(a_n) = (0, 2, 0, 2, ..., 0, 2, ...)$ no converge al número $0$.
]
#solucion[
  *Demostración por absurdo:*

  Supongamos por el absurdo que $(a_n)$ converge a $0$, es decir, $\lim_(n -> oo) a_n = 0$.

  Por definición de límite, para todo $epsilon > 0$, existe un $n_0 in NN$ tal que para todo $n >= n_0$ se cumple:
  $ |a_n - 0| = |a_n| < epsilon $

  Como la afirmación debe cumplirse para todo $epsilon > 0$, elegimos en particular $epsilon = 1 > 0$.

  Por lo tanto, debe existir algún $n_0 in NN$ tal que para todo $n >= n_0$ se satisface $|a_n| < 1$.

  Sin embargo, para cualquier $n_0 in NN$, siempre existe un índice par $n >= n_0$ (por ejemplo, $n = 2 n_0$). Para todo elemento par de esta sucesión, se cumple $a_n = 2$.

  Sustituyendo en la desigualdad del límite obtenemos:
  $ |a_n| = |2| = 2 < 1 $

  ¡Absurdo! (pues $2 < 1$ es falso).

  Por lo tanto, la suposición inicial es falsa y concluimos que la sucesión $(a_n)$ *no converge al número 0*.
]

#v(10pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Bloque 7 · Álgebra de límites

#sublema(titulo: "Qué desbloquea")[
  El *Ejercicio 9 (a)* (que es literalmente el ítem b del álgebra), el *Ejercicio 10* (el ítem
  e) y el *Ejercicio 11*.

  *El orden importa:* el Ejercicio 2.14 va en el medio a propósito --- es la herramienta que
  hace falta para el ítem del cociente, y sus ítems (a) y (b) ya están resueltos.
]

#desafio[Álgebra de Límites - Ítem b (Límite de la suma de sucesiones)][
  Sean $(a_n)_(n in NN)$ y $(b_n)_(n in NN)$ dos sucesiones reales tales que $lim_(n -> oo) a_n = a$ y $lim_(n -> oo) b_n = b$, con $a, b in RR$.

  Probar que $lim_(n -> oo) (a_n + b_n) = a + b$.
]

#desafio[Ejercicio 2.14][
  Sea $(a_n)_(n in NN)$ una sucesión de números reales tal que $a_n -> a$.

  #set enum(numbering: "a)")
  + Supongamos que $a > 0$. Probar que existe un $n_0$ tal que $a_n >= a/2$ para todo $n >= n_0$.
  + Supongamos que $a < 0$. Probar que existe un $n_0$ tal que $a_n <= a/2$ para todo $n >= n_0$.
  + Concluir, juntando los ítems anteriores, que si $a_n -> a$ y $a != 0$ entonces existe un $n_0$ tal que $|a_n| >= abs(a)/2 > 0$ para todo $n >= n_0$.
  + Supongamos ahora que $a = 0$. ¿Se puede concluir algo parecido al ítem (a) o (b)?
]
#solucion[
  *Demostración del inciso a):*

  Dado que $a_n -> a$, por definición de límite tenemos que para todo $epsilon > 0$ existe $n_0 in NN$ tal que para todo $n >= n_0$:
  $ |a_n - a| < epsilon $

  En particular, como $a > 0$, tomando $epsilon = a/2 > 0$ existe $n_0 in NN$ tal que para todo $n >= n_0$:
  $ |a_n - a| < a/2 $

  Descomponiendo el valor absoluto:
  $ -a/2 < a_n - a < a/2 \
    a/2 < a_n < (3a)/2 $

  Por lo tanto, $a_n > a/2 => a_n >= a/2$ para todo $n >= n_0$, como se quería probar.

  #v(8pt)
  *Demostración del inciso b):*

  Dado que $a_n -> a$, por definición de límite tenemos que para todo $epsilon > 0$ existe $n_0 in NN$ tal que para todo $n >= n_0$:
  $ |a_n - a| < epsilon $

  En particular, para $epsilon = |a/2| = -a/2 > 0$ (pues $a < 0$), existe $n_0 in NN$ tal que para todo $n >= n_0$:
  $ |a_n - a| < -a/2 $

  Descomponiendo el valor absoluto:
  $ a/2 < a_n - a < -a/2 \
    (3a)/2 < a_n < a/2 $

  Por lo tanto, $a_n < a/2 => a_n <= a/2$ para todo $n >= n_0$, como se quería probar.

  #v(8pt)
  *Demostración del inciso c):*

  Si $a_n -> a$ y $a != 0$, tenemos dos posibilidades según el signo de $a$:

  - *Caso $a > 0$:*
    + $|a| = a$, por definición de valor absoluto.
    + Por el inciso (a), existe $n_1 in NN$ tal que $a_n > a/2$ para todo $n >= n_1$. Como $a > 0$, resulta $a_n > 0$, con lo cual $|a_n| = a_n$.

    Tomando en cuenta ambas cosas:
    $ |a_n| >= |a|/2 > 0 quad forall n >= n_1 $

  - *Caso $a < 0$:*
    + $|a| = -a$, por definición de valor absoluto.
    + Por el inciso (b), existe $n_2 in NN$ tal que $a_n <= a/2$ para todo $n >= n_2$. Como $a < 0$, se tiene $a/2 < 0$, por lo cual $a_n < 0$ y por ende $|a_n| = -a_n$.

    Tomando en cuenta ambas cosas:
    $ a_n <= a/2 <=> -a_n >= -a/2 <=> |a_n| >= |a|/2 > 0 quad forall n >= n_2 $

  Por los dos casos anteriores, concluimos que existe $n_0 in NN$ tal que $|a_n| >= |a|/2 > 0$ para todo $n >= n_0$.
]

#sublema(titulo: "Ojo: el siguiente ya está resuelto arriba")[
  "Ejercicio 6 - Ítem b" es literalmente el ítem (b) del Ejercicio 2.14, que acaba de quedar
  demostrado. Se conserva porque la baja no fue autorizada; no hace falta rehacerlo. Ver
  `proposals/orden_desafios_p1.md`.
]

#desafio[Ejercicio 6 - Ítem b (Conservación de signo para límites negativos)][
  Sea $(a_n)_(n in NN)$ una sucesión de números reales tal que $a_n -> a$.

  Supongamos que $a < 0$. Probar que existe un $n_0 in NN$ tal que $a_n <= a/2$ para todo $n >= n_0$.
]

#desafio[Álgebra de Límites - Ítem e (Preservación del orden al límite)][
  Sean $(a_n)_(n in NN)$ y $(b_n)_(n in NN)$ dos sucesiones reales tales que $lim_(n -> oo) a_n = a$ y $lim_(n -> oo) b_n = b$, con $a, b in RR$.

  Si $a_n <= b_n$ para todo $n >= n_0$, probar que $a <= b$.
]

#v(10pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Bloque 8 · Divergencia a $plus.minus oo$

#sublema(titulo: "Qué desbloquea")[
  Los *Ejercicios 9 (b)--(d)*, el *12 (b)* y la segunda mitad del *14*. Es el tramo que
  `ejemplos.typ` registra como *hueco 1*: de `apuntes.typ` sólo está la Definición 2.6, y
  ninguna demostración usa todavía el cuantificador "para todo $M > 0$".

  Los tres primeros son, textualmente, los Ejercicios 2.7, 2.13 y 2.17 de las notas de
  cátedra --- los que las notas dejan planteados sin resolver. El material de apoyo está en
  `apuntes-agente/huecos-p1-divergencia-y-punto-fijo.md`.

  *El orden importa:* el primero estrena el cuantificador $M$ en el caso más simple; el
  segundo marca qué *no* se puede concluir (no acotada no alcanza); el tercero es el puente
  con la monotonía y da el Ejercicio 12 (b) espejado; y el cuarto necesita a los tres.
]

#desafio[Ejercicio 3 (Divergencia del valor absoluto)][
  Mostrar que si una sucesión $(a_n)_(n in NN)$ diverge a $plus.minus oo$ entonces la sucesión $(|a_n|)_(n in NN)$ diverge a $+oo$. Notar que no vale la vuelta.
]

#desafio[Ejercicio 5 (No acotación vs. Divergencia a infinito)][
  Decidir si es verdadera o falsa la siguiente afirmación:

  Si $(a_n)_(n in NN)$ no está acotada entonces $(a_n)_(n in NN)$ diverge a $plus.minus oo$.
]

#desafio[Ejercicio 2.17][
  Sea $(a_n)_(n in NN)$ creciente y no acotada. Probar que $a_n -> +oo$.
]

#desafio[Ejercicio 4 (Álgebra de límites en el infinito)][
  Considerando las propiedades del Álgebra de límites para sucesiones reales $a_n -> a$ y $b_n -> b$:

  #set enum(numbering: "a)")
  + $lim_(n -> oo) (c · a_n) = c · a$ para todo $c in RR$.
  + $lim_(n -> oo) (a_n + b_n) = a + b$.
  + $lim_(n -> oo) (a_n b_n) = a b$.
  + Si $b != 0$, entonces $lim_(n -> oo) (a_n / b_n) = a / b$.
  + Si $a_n <= b_n$ para todo $n >= n_0$ entonces $a <= b$.

  Determinar cuáles de las anteriores propiedades siguen valiendo si tomamos $a = plus.minus oo$ y $b in RR$, o si $a = -oo$ y $b = +oo$.
]

#v(10pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Bloque 9 · Monótonas: el supremo y el ínfimo como límite

#sublema(titulo: "Qué desbloquea")[
  El *Ejercicio 12 (a)* (una sucesión decreciente y acotada inferiormente converge a su
  ínfimo) y el *Ejercicio 13* (si $A$ no tiene máximo, hay una sucesión creciente en $A$ que
  tiende al supremo).

  Es el último bloque porque necesita las tres patas: la caracterización $epsilon$ del
  supremo (Bloque 3), el límite por definición (Bloque 6) y la monotonía (Bloque 8).

  *El orden importa:* el primero *aplica* el teorema de monotonía (es el Ejercicio 12 (a)
  usado como herramienta) y de paso cierra el ínfimo de ${1/2^n}$ que pide el *Ejercicio 4
  (b)*, tomando $r = 1\/2$. El segundo, en cambio, pide *modificar una demostración*, que es
  un paso más.
]

#desafio[Convergencia de $a_n = r^n$ por el ínfimo (Ejemplo 2.24)][
  Sea $r in (0, 1)$ y sea $a_n = r^n$. Probar que $r^n -> 0$.

  #v(4pt)
  *Se pide expresamente resolverlo identificando el límite como el ínfimo* del conjunto
  ${r^n : n in NN}$: probar que $(a_n)_(n in NN)$ es decreciente y acotada inferiormente,
  concluir por el Ejercicio 12 (a) que converge a $op("ínf"){r^n : n in NN}$, y recién
  entonces probar que ese ínfimo vale $0$. *No vale resolverlo por subsucesiones.*

  #v(4pt)
  - _*Por qué se pide este camino:* la fuente (Ejemplo 2.24 de las notas de cátedra) lo
    descarta explícitamente --- "sabemos que este límite debe coincidir con el ínfimo, y esa
    es otra manera de terminar este ejercicio pero no es lo que vamos a hacer nosotros" --- y
    resuelve por subsucesiones, cerrando la ecuación $ell = ell^2$. Esa versión ya está en
    `ejemplos.typ` como Ejemplo 12. Este desafío recorre la ruta que las notas dejan sin
    hacer._
  - _*Estrategia (para el ínfimo):* que $0$ sea cota inferior es inmediato. Para ver que es
    la *mayor*, dado $epsilon > 0$ hay que exhibir un $n$ con $r^n < epsilon$. Escribir
    $r = 1\/(1 + h)$ con $h > 0$ (se puede, porque $1\/r > 1$) y acotar
    $(1 + h)^n >= 1 + n h$ --- la desigualdad de Bernoulli, pariente de la $2^n > n$ del
    Bloque 2. Con eso, $r^n <= 1\/(1 + n h)$ y el $n$ que hace falta sale del Principio de
    Arquímedes._
]

#desafio[Ejercicio 2.19][
  En la equivalencia de supremo se puede tomar la sucesión $(a_n)_(n in NN)$ monótona creciente. Es decir, vale la siguiente proposición: Sea $A subset.eq RR$ acotado superiormente. Entonces $s = op("sup")(A)$ si y sólo si:

  #set enum(numbering: "1.")
  + $s$ es cota superior de $A$, y
  + existe una sucesión monótona creciente $(a_n) subset.eq A$ tal que $lim_(n -> oo) a_n = s$.

  #v(4pt)
  Modificar la demostración anterior para probar esta nueva equivalencia.
]

#v(10pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Bloque 10 · Coordinabilidad y numerabilidad

#sublema(titulo: "Qué desbloquea")[
  Alimenta la *Práctica 2* (cardinalidad y conjuntos numerables / contables). En particular, combina biyecciones conocidas ($NN tilde.op ZZ$ y $NN tilde.op QQ^+$) para deducir la numerabilidad de $QQ$.
]

#desafio[Ejercicio 3.4 ($NN tilde.op QQ$)][
  Usar los ítems b) y c) del Ejemplo 3.3 para probar que $NN tilde.op QQ$.
]

#desafio[Ejercicio 3.9][
  Probar que $\#A <= \#B$ si y solo si existe una función sobreyectiva $g : B -> A$.
]
