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

#desafio[Supremo de $C = {2 - 1/n : n in NN}$][
  Sea $C = {2 - 1/n : n in NN} = {2 - 1, 2 - 1/2, 2 - 1/3, ...}$. Claramente $2$ es una cota superior de $C$. Demostrar mediante el Principio de Arquímedes que $2 = op("sup")(C)$.
]
#solucion[
  + *Cota superior:* Como $n >= 1 > 0 => 1/n > 0$, tenemos $2 - 1/n < 2$ para todo $n in NN$. Luego $2$ es cota superior de $C$.
  + *Menor cota superior:* Supongamos que existe una cota superior $t < 2$. Sea $epsilon = 2 - t > 0$. Por el Principio de Arquímedes, existe $n_0 in NN$ tal que $1/n_0 < 2 - t => 2 - 1/n_0 > t$. Pero $x_0 = 2 - 1/n_0 in C$, contradicción.
  
  Concluimos que $2 = op("sup")(C)$.
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

#desafio[Supremo de $A = {r in QQ : r^2 < 2}$ en $RR$][
  Sea $A = {r in QQ : r^2 < 2}$. Probar que el supremo (en $RR$) de este conjunto es $s = sqrt(2)$.
]


#desafio[Equivalencia del Axioma de Completitud (Deducción desde el Teorema 2)][
  Suponiendo como cierto el Teorema 2 (todo conjunto $A subset.eq RR$ no vacío y acotado inferiormente tiene ínfimo en $RR$), deducir el Axioma de Completitud (todo conjunto acotado superiormente y no vacío de $RR$ tiene supremo en $RR$).
]

#desafio[Ejercicio 2 (Ínfimo del conjunto de cotas superiores)][
  Sea $A subset.eq RR$ no vacío y acotado superiormente. Sea $C = {"cotas superiores de " A}$. Probar que:

  #set enum(numbering: "1.")
  + $C != nothing$ y acotado inferiormente.
  + $op("ínf")(C) = op("sup")(A)$.
]

#desafio[Ejercicio 3 (Divergencia del valor absoluto)][
  Mostrar que si una sucesión $(a_n)_(n in NN)$ diverge a $plus.minus oo$ entonces la sucesión $(|a_n|)_(n in NN)$ diverge a $+oo$. Notar que no vale la vuelta.
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

#desafio[Existencia de un número natural intermedio][
  Sean $n, m in NN$ dos números naturales tales que $n > m$ y su distancia es estrictamente mayor a uno ($n - m > 1$).

  Demostrar que existe un número natural $t in NN$ comprendido estrictamente entre ambos, es decir:
  $ m < t < n $
]
#solucion[
  Demostración por absurdo.

  Nuestra hipótesis es que $n>m$ y $n-m>1$. Supongamos que $exists.not t in NN : m < t < n$. Por lo tanto $m<n$, y cómo no hay ningún número entre ellos, debe ocurrir que $n$ es el siguiente de $m$, por lo tanto $n = m+1$. Entonces $n-m = m+1-m =1$ ¡Absurdo! Pues nuestra hipótesis pedía que $n-m>1$. Por lo tanto, debe existir $t in NN$ tal que $m < t < n$
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

#desafio[Ejercicio 5 (No acotación vs. Divergencia a infinito)][
  Decidir si es verdadera o falsa la siguiente afirmación:

  Si $(a_n)_(n in NN)$ no está acotada entonces $(a_n)_(n in NN)$ diverge a $plus.minus oo$.
]

#desafio[Ejercicio 6 - Ítem b (Conservación de signo para límites negativos)][
  Sea $(a_n)_(n in NN)$ una sucesión de números reales tal que $a_n -> a$.

  Supongamos que $a < 0$. Probar que existe un $n_0 in NN$ tal que $a_n <= a/2$ para todo $n >= n_0$.
]

#desafio[Álgebra de Límites - Ítem b (Límite de la suma de sucesiones)][
  Sean $(a_n)_(n in NN)$ y $(b_n)_(n in NN)$ dos sucesiones reales tales que $lim_(n -> oo) a_n = a$ y $lim_(n -> oo) b_n = b$, con $a, b in RR$.

  Probar que $lim_(n -> oo) (a_n + b_n) = a + b$.
]

#desafio[Álgebra de Límites - Ítem e (Preservación del orden al límite)][
  Sean $(a_n)_(n in NN)$ y $(b_n)_(n in NN)$ dos sucesiones reales tales que $lim_(n -> oo) a_n = a$ y $lim_(n -> oo) b_n = b$, con $a, b in RR$.

  Si $a_n <= b_n$ para todo $n >= n_0$, probar que $a <= b$.
]

#desafio[Existencia de un entero en $(x, x + 1]$][
  Demostrar que, usando el Principio de Arquímedes, para todo $x in RR$ existe $n in ZZ$ tal que:
  $ x < n <= x + 1 $
]

#desafio[Consecuencia del Principio de Arquímedes ($2/n < x$)][
  Demostrar que, por el Principio de Arquímedes, para todo $x in RR$ con $x > 0$ existe $n in NN$ tal que:
  $ 2/n < x $
]

#desafio[Otra consecuencia del Principio de Arquímedes ($0 < m/n < x$)][
  Demostrar que dado cualquier $x > 0$ en $RR$ y para cualquier entero $m >= 1$ fijo, existe un $n in NN$ tal que:
  $ 0 < m/n < x $
]

#desafio[Mínimo del intervalo $(a, b]$][
  Dado el intervalo $(a, b] subset.eq RR$ con $a < b$, probar que no posee mínimo.
]

#desafio[Desigualdad $2^n > n$ para $n in NN$][
  Demostrar que $2^n > n$ para todo $n in NN$.
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

#desafio[Unión arbitraria de conjuntos acotados][
  Determinar la veracidad de la siguiente afirmación (demostrar o proveer un contraejemplo formal):

  _"La unión de cualquier cantidad de conjuntos acotados es un conjunto acotado."_
]

#desafio[Unión de dos conjuntos acotados superiormente][
  Determinar la veracidad de la siguiente afirmación (demostrar o proveer un contraejemplo formal):

  _"La unión de dos conjuntos acotados superiormente es un conjunto acotado superiormente."_
]

#desafio[Parte entera de un número real][
  Dado $x in RR$, se define la parte entera de $x$ como $[x] = max {k in ZZ : k <= x}$.
  
  Demostrar que $[x]$ está bien definido, es decir, que el conjunto $A = {k in ZZ : k <= x}$ tiene supremo y el supremo pertenece a $A$.
]

#desafio[Supremo de $A = {r in QQ : r^2 < 2}$][
  Sea $A = {r in QQ : r^2 < 2}$. Demostrar que $sqrt(2) = op("sup")(A)$.
]

#desafio[Cotas y extremos de $A = {n / (n + 1) : n in NN}$][
  Sea $A = {n / (n + 1) : n in NN} subset.eq RR$. Decidir si tiene supremo, máximo, ínfimo y mínimo.

  #v(4pt)
  - _*Estrategia (para el supremo):* Demostrar que $op("sup")(A) = 1$ mediante la caracterización con $epsilon$. Dado $epsilon > 0$, se busca un elemento $a_n = n/(n+1) in A$ tal que $1 - epsilon < n/(n+1)$, lo cual es equivalente a $1/epsilon - 1 < n$. Dicho $n in NN$ existe por el Principio de Arquímedes._
]

#desafio[Supremo de la suma de conjuntos $A + B$][
  Sean $A, B subset.eq RR$ no vacíos y acotados superiormente. Definimos $A + B = {a + b : a in A, b in B}$. Hallar, si existe, $op("sup")(A + B)$.

  #v(4pt)
  - _*Estrategia:* El supremo sí existe y el candidato es $op("sup")(A + B) = op("sup")(A) + op("sup")(B)$. Se demuestra utilizando la caracterización con $epsilon$, tomando $epsilon / 2$ para hallar $a in A$ y $b in B$ adecuados._
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





