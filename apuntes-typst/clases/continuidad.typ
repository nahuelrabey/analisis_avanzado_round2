// Notas docentes 2025 · clase del 07/10/2025 (apunte tipeado de Mateo Mauri, "Continuidad").
// Clase 6 de la transcripción: sus ejercicios llevan el tag `C6-{k}` en `ejemplos/`.

= Continuidad

== 1. Funciones continuas

El objetivo de la primer parte de la clase es demostrar que los polinomios en varias variables son funciones continuas de $RR^n$ a $RR$. Para hacer esto, enunciaremos y demostraremos varios resultados:

_Proposición 1.1_: Sean $X$ e $Y$ dos espacios métricos, y $f, g : X -> Y$ dos funciones continuas entre estos espacios. Se tiene entonces que $f + g$ y $f . g$ también son funciones continuas entre estos espacios.

_Nota_: para que $f + g$ y $f . g$ tengan sentido hace falta que en $Y$ se pueda sumar y multiplicar; en lo que sigue se usa con $Y = RR$ (con la métrica usual), que es el caso que interesa para los polinomios.

_Dem_: Comencemos por demostrar que la suma de funciones continuas es una función continua. Sea $(x_n)_(n in NN)$ una sucesión de elementos de $X$ convergente, veamos que
$
lim_(n -> infinity) (f + g)(x_n) = (f + g)(x),
$
donde $x$ es el límite de la sucesión $(x_n)_(n in NN)$. En efecto, notar que
$
lim_(n -> infinity) (f + g)(x_n) &= lim_(n -> infinity) f(x_n) + g(x_n) = lim_(n -> infinity) f(x_n) + lim_(n -> infinity) g(x_n) \
&= f(x) + g(x) = (f + g)(x),
$
donde la única igualdad que no se deduce directamente de las definiciones es la tercera, que se debe al álgebra de límites (la sucesión dada por una suma de sucesiones convergentes converge a la suma de los límites).

Exactamente de la misma forma uno puede probar que el producto de funciones continuas es continua, observando que
$
lim_(n -> infinity) (f . g)(x_n) &= lim_(n -> infinity) f(x_n) . g(x_n) = lim_(n -> infinity) f(x_n) . lim_(n -> infinity) g(x_n) \
&= f(x) . g(x) = (f . g)(x).
$
#align(right)[#square()]

_Lema 1.2_: Sea $pi_i : RR^n -> RR$ la función que proyecta en la $i$-ésima coordenada, es decir, la función tal que $pi_i (x_1, x_2, dots, x_n) = x_i$. Esta función es continua en la métrica dada por la distancia $d_infinity$.

_Ejemplo 1.3_: Para digerir la notación, considerar la función $pi_2 : RR^3 -> RR$ dada por
$
pi_2 (x, y, z) = y.
$
Es claro que esta función es continua, y dejamos como ejercicio ver cómo la demostración de este hecho particular puede generalizarse a la demostración que daremos a continuación.

_Dem del Lema 1.2_: Sea ${(x^1_k, x^2_k, dots, x^n_k)}_(k in NN)$ una sucesión cualquiera convergente a algún punto de $RR^n$, que denotaremos como $(x^1, x^2, dots, x^n)$. Para probar la continuidad, debemos ver que
$
lim_(k -> infinity) pi_i (x^1_k, x^2_k, dots, x^n_k) = pi_i (x^1, x^2, dots, x^n).
$
Por todo lo que acabamos de definir, esto es lo mismo que probar que
$
lim_(k -> infinity) x^i_k = x^i,
$
pero esto se deduce de que la convergencia de una sucesión en $RR^n$ con la métrica dada por la distancia $d_infinity$ implica la convergencia de las sucesiones de sus coordenadas. En efecto, dado $epsilon > 0$, existe un $n_0 in NN$ tal que $d_infinity ((x^1_k, x^2_k, dots, x^n_k), (x^1, x^2, dots, x^n)) <= epsilon$ para todo $k >= n_0$, pero esto implica que
$
abs(x^i_k - x^i) <= d_infinity ((x^1_k, x^2_k, dots, x^n_k), (x^1, x^2, dots, x^n)) <= epsilon,
$
y se concluye lo deseado. #align(right)[#square()]

_Definición 1.4_: Decimos que una función $P : RR^n -> RR$ es un polinomio en varias variables si puede escribirse como una función de la forma
$
P(x_1, x_2, dots, x_n) = sum_(e_1 + dots.c + e_n <= r) a_((e_1, dots, e_n)) x_1^(e_1) dots.c x_n^(e_n)
$
para algún $r in NN$.

_Ejemplo 1.5_: La función $P(x, y, z) = x^4 + x y z^2 + x y + z^2 - y + 18$ es un polinomio.

_Proposición 1.6_: Los polinomios en varias variables son funciones continuas.

_Dem_: Basta con observar que los polinomios son sumas y productos de las funciones estudiadas en el Lema 1.2. #align(right)[#square()]

== 2. Funciones continuas aplicadas al estudio de conjuntos

_Problema 2.1_: Probar que el conjunto $A = {(x, y) in RR^2 : x^3 >= x^2 + y - x}$ es cerrado con la métrica dada por la distancia $d_infinity$.

_Observación 2.1_: Puede graficarse el conjunto en cuestión de la siguiente manera: (dibujo: la curva $y = x^3 - x^2 + x$ en el plano, con la región $A = {(x, y) : y <= x^3 - x^2 + x}$ sombreada, es decir, todo lo que queda por debajo de la curva).

_Res_: Si tomamos la función $f : RR^2 -> RR$ dada por $f(x, y) = x^3 - x^2 + x - y$, podemos caracterizar al conjunto $A$ como
$
A = f^(-1) ((0, +infinity)).
$
Visto de esta manera, $A$ es la preimagen de un conjunto abierto a través de una función continua, cosa que se ve de que $f$ es un polinomio.

_Nota_: el apunte escribe $f^(-1) ((0, +infinity))$ y "preimagen de un conjunto abierto", pero $A$ está definido con $>=$: es $A = {f >= 0} = f^(-1) ([0, +infinity))$, la preimagen del _cerrado_ $[0, +infinity)$ por la función continua $f$, y por eso $A$ es cerrado (que es lo que pide el problema). Con $(0, +infinity)$ se obtendría el abierto ${f > 0}$, que no es $A$.

Para el siguiente problema será conveniente recordar un poco de notación. El conjunto de matrices de dimensión $n times n$ con coeficientes reales suele notarse como $op("M")_n (RR)$, mientras que el subconjunto compuesto por las matrices inversibles suele llamarse $op("GL")_n (RR)$ (la $op("M")$ en la notación proviene de "matrices", mientras que el $op("GL")$ viene de "general linear group").

_Problema 2.2_: Probar que el conjunto de matrices inversibles con coeficientes reales, $op("GL")_n (RR)$, es abierto en el conjunto de matrices de $n times n$ con coeficientes reales, si a las matrices las dotamos de la distancia $d_infinity$.

_Res_: Una caracterización común de $op("GL")_n (RR)$ estudiada en el CBC es la dada por el determinante. En efecto, podemos pensar a este conjunto como
$
op("GL")_n (RR) = {A in op("M")_n (RR) : det(A) != 0}.
$
En vista del ejercicio anterior, esto nos da una pista de cómo probar que este conjunto es abierto: si pudiésemos ver que la función determinante es continua, podríamos entender a las matrices inversibles como la preimagen de un abierto ($det^(-1) (RR - {0})$), y por ende sería abierto. En efecto, la función determinante es una función definida como $det : RR^(n times n) -> RR$ y es más que continua: es un polinomio.

Para ver esto último vayamos por inducción. La hipótesis inductiva en este caso es "La función $det_n$, pensada como el determinante para matrices de $n times n$, es una función polinomial en los coeficientes de la matriz (y por ende de $RR^(n times n)$ a $RR$)".

El caso base es sencillo, ya que $det_1$ es la identidad, que es trivialmente un polinomio. Para el paso inductivo, asumamos que la función $det_n$ es un polinomio y veamos que lo mismo ocurre para la función $det_(n+1)$. Sea $A = (a_(i j))_(1 <= i, j <= n+1)$ una matriz de tamaño $(n+1) times (n+1)$. Para cada par de índices $1 <= i, j <= n+1$ denotamos por $A_(i j)$ a la matriz que se obtiene de $A$ al eliminar la fila $i$ y la columna $j$. Con esta notación la fórmula para calcular el determinante por cofactores (así se llama a la manera típica que vemos en el CBC) viene dada por:
$
cases(
  det_1 (a_(11)) = a_(11)\,,
  det_(n+1) (A) = limits(sum)_(j = 1)^(n+1) (-1)^(1+j) a_(1 j) det_n (A_(1 j)).
)
$
Mirando esta definición, es claro que si por hipótesis inductiva la función $det_n$ es un polinomio en los coeficientes de una matriz de $n times n$, la función $det_(n+1)$ también debe serlo, ya que se fabrica como suma y producto de polinomios en los coeficientes de una matriz de $(n+1) times (n+1)$.

Habiendo probado que el determinante es una función polinomial, y que las funciones polinomiales son continuas, concluimos el resultado, observando que
$
op("GL")_n (RR) = op("det")^(-1) (RR - {0}),
$
que es la preimagen de un abierto a través de una función continua, y por ende abierto también.

== 3. Funciones continuas en conjuntos densos

_Lema 3.1_: Sea $f : X -> Y$ una función continua entre dos espacios métricos. Se tiene que $f(D) subset.eq Y$ es un conjunto denso siempre que $D subset.eq X$ sea denso.

_Nota_: tal como está enunciado, el lema necesita además que $f$ sea sobreyectiva (o bien debe leerse "$f(D)$ es denso en $f(X)$"): si la imagen de $f$ no es todo $Y$, un abierto $A subset.eq Y$ disjunto de $f(X)$ tiene $f^(-1) (A) = emptyset$, y el argumento de la demostración (que supone $f^(-1) (A)$ no vacío) no se aplica.

_Dem_: Sea $A subset.eq Y$ un conjunto abierto cualquiera. Para ver que $f(D)$ es denso basta con probar que $f(D)$ interseca a $A$, ya que $A$ era arbitrario. Como $A$ es abierto y $f$ es continua, $f^(-1) (A)$ es un abierto de $X$, y como $D$ es denso en $X$, debe ocurrir que $f^(-1) (A) inter D != emptyset$. Esto último implica directamente que $A inter f(D) != emptyset$, y concluimos lo deseado. #align(right)[#square()]

_Lema 3.2_: Sean $f, g : X -> Y$ dos funciones continuas entre espacios métricos y sea $D$ un conjunto denso en $X$. Si $f(x) = g(x)$ para todo $x in D$, tiene que ser que $f equiv g$.

_Dem_: Sea $x in X$ un elemento cualquiera, y sea $(x_n)_(n in NN)$ una sucesión convergente a $x$ de elementos de $D$ (esto puede hacerse ya que $D$ es denso). Por continuidad, notar que
$
f(x) = lim_(n -> infinity) f(x_n) = lim_(n -> infinity) g(x_n) = g(x),
$
de lo que concluimos lo deseado. #align(right)[#square()]

_Nota_: el apunte dice "una sucesión convergente a $X$ de elementos de $D$"; se refiere a una sucesión convergente al punto $x$.

_Problema 3.1_: Caracterizar todas las funciones continuas $f : RR -> RR$ tales que $f(x + y) = f(x) f(y)$ para cualesquiera $x, y in RR$ y $f(1) = 2$.

_Res_: Notemos primero que, si $n in NN$, se tiene que
$
f(n) = f(1 + dots.c + 1) = f(1) dots.c f(1) = 2 dots.c 2 = 2^n.
$
Por otro lado, si evaluamos en $p/q$ con $p, q in NN$, se tiene
$
f(p/q) = f(p/q)^(q/q) = (f(p/q)^q)^(1/q) = f(p)^(1/q) = (2^p)^(1/q) = 2^(p/q).
$
Además, es claro que si tomamos $p/q$ con $p, q in NN$, se tiene que
$
2 = f(1) = f(1 + p/q - p/q) = f(1) . f(p/q) . f(-p/q) = 2 . f(p/q) . f(-p/q),
$
de lo que se concluye que, como $f(p/q) = 2^(p/q)$, debe tenerse que $f(-p/q) = 2^(-p/q)$.

Con todo lo probado hasta ahora, obtuvimos que si $x in QQ$ entonces $f(x) = 2^x$. Por hipótesis sabemos que $f$ es continua, y asumiremos la continuidad de la exponencial como un hecho. Tenemos entonces que, dado un $x in RR$ cualquiera, si tomamos una sucesión de racionales $(x_n)_(n in NN)$ convergentes a $x$ (cosa que podemos hacer porque los racionales son densos en $RR$), se tiene que
$
f(x) = lim_(n -> infinity) f(x_n) = lim_(n -> infinity) 2^(x_n) = 2^x,
$
lo que termina de caracterizar a nuestra función.

_Nota_: dos detalles que el apunte deja implícitos: el caso $x = 0$ sale de $2 = f(1) = f(1 + 0) = 2 f(0)$, o sea $f(0) = 1 = 2^0$; y para tomar la raíz $q$-ésima real en $(f(p/q)^q)^(1/q) = f(p/q)$ hace falta $f(p/q) >= 0$, que vale porque $f(p/q) = f(p/(2q))^2$.
