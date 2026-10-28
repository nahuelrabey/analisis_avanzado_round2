// Clase práctica 2026 · 29/09/2026 (apunte tipeado de la cátedra, "Análisis Avanzado 29/09/2026. Clase de repaso").
// Sus ejercicios llevan el tag `29-09/{k}` en `ejemplos/` (k = número de ejercicio del apunte).

= Clase de repaso

== Notación y algunas definiciones

- Si $n, m in NN$, $n perp m$ significa que $n$ y $m$ son coprimos.
- Si $A$ es un conjunto, $cal(P)(A)$ denota su conjunto de partes.
- Si $A$ y $B$ son conjuntos no vacíos, $A^B$ denota el conjunto de funciones de $B$ a $A$ (nota: esta notación también se usa si $A$ o $B$ es vacío, pero no consideramos ese caso en esta materia). Tengamos en cuenta de que en el caso en que $B = NN$, las funciones de $B$ a $A$ son las sucesiones de elementos de $A$.
- Si $x in RR^n$, escribimos a sus coordenadas como $(x_1, dots, x_n)$.
- A menos que se indique lo contrario, a cualquier subconjunto de $RR^n$ le damos la distancia euclídea, es decir la distancia $d_2$, dada por
  $
  d_2 (x, y) := (sum_(j=1)^n (x_j - y_j)^2)^(1/2).
  $
  En particular, cuando tomamos límite sin aclarar la distancia, el límite es con respecto a esta distancia. Notemos que en el caso $n = 1$, esta es la distancia inducida por el módulo, es decir $d_2 (x, y) = abs(x - y)$.
- Si $A$ es un conjunto y $f, g : A -> RR$ son funciones, entonces $f >= g$ quiere decir que $f(a) >= g(a)$ para todo $a in A$. Usamos una notación similar para $<=$, $>$, $<$, e $=$ (notemos que podemos tomar $g$ constante, por ejemplo $g = 0$).
- Si $(X, d)$ es un espacio métrico, $x in X$ y $r > 0$, denotamos $B_d (x, r)$ a la bola abierta de centro $x$ y radio $r$ con respecto a la métrica $d$, es decir que
  $
  B_d (x, r) = {y in X : d(x, y) < r}.
  $

== Temas

Esta es una clase con ejercicios de repaso de algunos de los temas vistos hasta ahora.

== Ejercicios

El Ejercicio 1 es un ejercicio optativo, que no vimos en la clase, pero es casi igual a uno que sí vimos en la clase del 15/09/26, que también está en el campus. Este nuevo ejercicio puede usarse como manera alternativa para resolver la primera parte del Ejercicio 2 (en la clase, resolvimos la primera parte del Ejercicio 2 "a mano", comprobando que $D$ cumple con todas las propiedades para ser una métrica).

_Ejercicio 1_: Sean $(X, d)$ un espacio métrico y $A subset.eq X$ un subconjunto no vacío. Sea $f : A -> A$ una función inyectiva. Probar que la función
$
D_f (x, y) := d(f(x), f(y)) quad forall x, y in A
$
es una métrica sobre $A$ (en otras palabras, $(A, D)$ es un espacio métrico).

_Nota_: en el paréntesis final la fuente escribe $(A, D)$; la métrica del enunciado es $D_f$, así que debería leerse $(A, D_f)$.

_Solución_: Esto se puede probar con el mismo argumento usado en la clase del 15/09/26, que es el siguiente:

Para ver que $D_f$ es una métrica, hay que probar lo siguiente:

+ $D_f (x, y) >= 0$ para todo $x, y in A$.
+ $D_f (x, y) = 0$ si y sólo si $x = y$.
+ Para todos $x, y in A$, se tiene que $D_f (x, y) = D_f (y, x)$.
+ Para todos $x, y, z in A$, se tiene que
  $
  D_f (x, y) <= D_f (x, z) + D_f (y, z).
  $

(1) vale porque $d$ es una métrica, y por lo tanto es no negativa.

(2) Si $x = y$, entonces $D_f (x, y) = d(f(x), f(x)) = 0$. Por otra parte, si $D_f (x, y) = 0$, entonces $f(x) = f(y)$ (porque $d$ es una métrica). Como $f$ es inyectiva, se sigue que $x = y$.

(3) Sean $x, y in A$. Como $d$ es una métrica, tenemos que $D_f (x, y) = d(f(x), f(y)) = d(f(y), f(x)) = D_f (y, x)$.

(4) Sean $x, y, z in A$. Nuevamente, usando que $d$ es una métrica obtenemos
$
D_f (x, y) = d(f(x), f(y)) <= d(f(x), f(z)) + d(f(z), f(y)) = D_f (x, z) + D_f (z, y).
$
#align(right)[#square()]

_Ejercicio 2_: Sea $X = (0, 1] subset.eq RR$. Definimos en $X times X$ las siguientes funciones con valores en $RR_(>= 0)$:
$
d(x, y) &:= abs(x - y); \
D(x, y) &:= abs(1/x - 1/y).
$
(notemos que $d$ es simplemente la restricción a $X$ de la métrica inducida por el módulo). Probar que:

#enum(numbering: "(i)",
  [$D$ es una métrica.],
  [La convergencia en $(X, d)$ es la misma que en $(X, D)$. En otras palabras, si $(a_n)_(n in NN) subset.eq X$ es una sucesión y $a in X$, entonces
  $
  a_n limits(-->)^((X, d))_(n -> infinity) a <==> a_n limits(-->)^((X, D))_(n -> infinity) a.
  $],
  [$(X, d)$ no es un espacio métrico completo.],
  [$(X, D)$ es un espacio métrico completo.],
)

_Solución_: (i) Notemos que la función $f(x) := 1/x$ es una función inyectiva de $(0, +infinity)$ en $(0, +infinity)$. Luego, por el Ejercicio 1, se sigue que si definimos $tilde(D) : (0, +infinity) times (0, +infinity) -> RR_(>= 0)$ como
$
tilde(D)(x, y) := abs(1/x - 1/y),
$
entonces $tilde(D)$ es una métrica. Restringiendo esta métrica a $(0, 1] times (0, 1]$, obtenemos la $D$ del enunciado, y por lo tanto, $D$ es una métrica sobre $[0, 1)$. Queda como ejercicio dar una solución alternativa, probando "a mano" que $D$ es una métrica sobre $(0, 1]$.

_Nota_: la fuente dice "métrica sobre $[0, 1)$"; es un desliz, el conjunto es $X = (0, 1]$ (como dice la oración siguiente).

(ii) Para probar la equivalencia, supongamos primero que
$
a_n limits(-->)^((X, d))_(n -> infinity) a.
$
Entonces $abs(a_n - a) limits(-->)_(n -> infinity) 0$ (como siempre, si no aclaramos la convergencia es en $RR$, con la distancia usual). Queremos ver que
$
abs(1/a_n - 1/a) limits(-->)_(n -> infinity) 0.
$
Tomando denominador común $a a_n$ se tiene que
$
abs(1/a_n - 1/a) = abs(a_n - a)/(a a_n). quad (1)
$
Ya sabemos que el numerador tiende a cero. Para ver que el cociente lo hace, hay que asegurarse de que el denominador esté alejado de cero. A tal fin, usamos la convergencia de $abs(a - a_n)$ a cero, de la siguiente manera: existe un $n_0$ tal que si $n >= n_0$, entonces $abs(a - a_n) < a/2$. Por lo tanto, si $n >= n_0$, entonces
$
a - a_n <= abs(a - a_n) < a/2,
$
lo que implica que $a_n > a/2$. Luego,
$
abs(a_n - a)/(a a_n) = 1/a_n 1/a abs(a_n - a) <= 2/a 1/a abs(a_n - a) = 2/a^2 abs(a_n - a),
$
lo que combinado con (1) implica que
$
D(a, a_n) = abs(1/a_n - 1/a) <= 2/a^2 abs(a_n - a) quad forall n >= n_0. quad (2)
$
Observemos que ya sacamos el $a_n$ del denominador, y ahora sí podemos usar directamente que el numerador tiende a cero. Más concretamente, fijemos $epsilon > 0$. Como $abs(a_n - a) limits(-->)_(n -> infinity) 0$, existe $n_1 in NN$ tal que
$
abs(a_n - a) < (a^2 epsilon)/2 quad forall n >= n_1.
$
De esto y (2) se sigue que
$
D(a, a_n) <= 2/a^2 abs(a_n - a) < epsilon quad forall n >= op("máx"){n_0, n_1}.
$
Hemos probado entonces que
$
a_n limits(-->)^((X, D))_(n -> infinity) a. quad (3)
$
La vuelta es más fácil. En efecto, para todo $x, y in X$, tenemos que
$
D(x, y) = abs(1/x - 1/y) = abs(x - y)/(x y) >= abs(x - y) = d(x, y). quad (4)
$
Luego, dado $epsilon > 0$, por (3) podemos tomar $n_0$ tal que si $n >= n_0$, entonces $D(a_n, a) < epsilon$, y entonces por (4) resulta que $d(a_n, a) < epsilon$. Esto completa la demostración de (ii).

(iii) Para ver que $(X, d)$ no es completo, tenemos que encontrar una sucesión de Cauchy que no sea convergente. Proponemos $x_n := 1/n$ para todo $n in NN$. Como toda sucesión convergente es de Cauchy (en cualquier espacio métrico), y como $x_n limits(-->)^((RR, abs(dot.c)))_(n -> infinity) 0$, entonces $(x_n)_(n in NN)$ es de Cauchy en $RR$ (con la distancia usual). Esto significa que dado $epsilon > 0$, existe $n_0$ tal que si $n, m >= n_0$, entonces $abs(x_n - x_m) < epsilon$. Pero esto es lo mismo que ser sucesión de Cauchy en $(X, d)$, por definición de $d$. Entonces ya tenemos una sucesión de Cauchy en $(X, d)$. Veamos que no converge, por el absurdo: supongamos que existe $x in X$ tal que
$
x_n limits(-->)^((X, d))_(n -> infinity) x.
$
Esto dice que $abs(x_n - x)$ tiende a cero. Pero ya sabemos que $abs(x_n)$ tiende a cero. Luego,
$
0 <= x = abs(x - x_n + x_n) <= abs(x - x_n) + abs(x_n) limits(-->)_(n -> infinity) 0.
$
Se sigue que $x = 0$, lo que es absurdo porque $x in (0, 1]$.

(iv) Para terminar este ejercicio, tenemos que ver que $(X, D)$ es completo. A tal fin, sea $(a_n)_(n in NN)$ una sucesión de Cauchy en $(X, D)$. Notemos que también es de Cauchy en $RR$ con el módulo: en efecto, dado $epsilon > 0$, tomemos $n_0$ tal que si $n, m >= n_0$, entonces $D(x_n, x_m) < epsilon$. Por (4), se tiene que también $abs(x_n - x_m) < epsilon$, que es la condición de ser de Cauchy. Como $(RR, abs(dot.c))$ es un espacio métrico completo, existe $x in RR$ tal que
$
abs(x - x_n) limits(-->)_(n -> infinity) 0. quad (5)
$

_Nota_: la fuente nombra a la sucesión $(a_n)_(n in NN)$ al presentarla y de ahí en adelante la llama $(x_n)_(n in NN)$; es la misma sucesión.

Ahora bien, para todo $n in NN$,
$
0 <= x_n <= 1,
$
y entonces tomando límite se tiene que $0 <= x <= 1$. Para completar la demostración de que $(x_n)_(n in NN)$ es convergente en $(X, D)$, tenemos que probar dos cosas:

#enum(numbering: "(a)",
  [$x in X$.],
  [$x_n limits(-->)^((X, D))_(n -> infinity) x$.],
)

Veamos (a), por el absurdo. Supongamos que $x in.not X$. Como $x in [0, 1]$ y $X = (0, 1]$, se sigue que $x = 0$, es decir que $x_n limits(-->)^((RR, abs(dot.c)))_(n -> infinity) 0$. Ahora bien $(x_n)_(n in NN)$ es de Cauchy en $(X, D)$, así que en particular existe $n_0 in NN$ tal que si $n, m >= n_0$, entonces $D(x_n, x_m) <= 1$. Tomando $m = n_0$ se tiene que
$
abs(1/x_n - 1/x_(n_0)) <= 1 quad forall n >= n_0.
$
Esto implica que para todo $n >= n_0$,
$
1/x_n = abs(1/x_n - 1/x_(n_0) + 1/x_(n_0)) <= abs(1/x_n - 1/x_(n_0)) + 1/x_(n_0) = (1 + x_(n_0))/x_(n_0).
$
(notemos que podemos sacar el módulo cuando tenemos números positivos). Se deduce que
$
x_(n_0)/(1 + x_(n_0)) <= x_n quad forall n >= n_0,
$
lo que es absurdo porque $x_n limits(-->)^((RR, abs(dot.c)))_(n -> infinity) 0$.

Ahora probemos (b): como $x in X$, y la convergencia en $(X, d)$ es la misma que en $(X, D)$ (por (ii)), para probar (b) alcanza con ver que $x_n limits(-->)^((X, d))_(n -> infinity) x$. Pero esto es lo mismo que (5), y entonces vale. #align(right)[#square()]

_Ejercicio 3_: Consideremos los siguientes subconjuntos de $NN^NN$:
$
A_1 &:= {(a_n)_(n in NN) : a_n perp a_m quad forall n, m in NN : n != m}; \
A_2 &:= {(a_n)_(n in NN) : a_n "es primo" quad forall n in NN}; \
A_3 &:= {(a_n)_(n in NN) : a_n < a_(n+1) quad forall n in NN}; \
A_4 &:= A_1 inter A_2; \
A_5 &:= A_1 inter A_3; \
A_6 &:= A_2 inter A_3.
$
Calcular el cardinal de los conjuntos $A_j$ para cada $1 <= j <= 6$.

_Solución_: Como todos estos conjuntos son subconjuntos del conjunto de todas las sucesiones de números naturales (es decir, de $NN^NN$, el conjunto de todas las funciones de $NN$ a $NN$), se tiene que para todo $1 <= j <= 6$,
$
\#(A_j) <= \#(NN^NN). quad (6)
$
Esto nos da una cota superior.

Notemos también que si $(a_n)_(n in NN) in A_6$, entonces para cada $n, m in NN$ con $n != m$, se tiene que $a_n != a_m$, y como tanto $a_n$ como $a_m$ son primos, se sigue que son coprimos entre sí. Luego, $A_6 = A_2 inter A_3 subset.eq A_1$, lo que implica que $A_6 = A_1 inter A_2 inter A_3$, y entonces
$
\#(A_6) <= \#(A_j) quad forall 1 <= j <= 6. quad (7)
$
Considerando (6) y (7), como asimismo el Teorema de CBS, concluimos que si probamos que $\#(NN^NN) <= \#(A_6)$, entonces podremos concluir también que todos estos conjuntos tienen el mismo cardinal, que es el de $NN^NN$.

Para probar lo dicho, buscamos una función inyectiva $phi : NN^NN -> A_6$. Una manera de hacerlo es la siguiente: Sea $(p_k)_(k in NN)$ una sucesión estrictamente creciente de números naturales primos (pueden ser todos los primos o no, lo que importa es que sea estrictamente creciente y sean primos). Definimos una función $phi : NN^NN -> A_6$ de la siguiente manera. Dada una sucesión de números naturales $(a_n)_(n in NN)$, $phi((a_n)_(n in NN))$ es la sucesión cuyo término $m$ es $p_(sum_(n=1)^m a_n)$. En otras palabras, $phi$ es la asignación
$
(a_1, a_2, a_3, dots) limits(-->)_phi (p_(a_1), p_(a_1 + a_2), p_(a_1 + a_2 + a_3), dots).
$
Notemos que dada una sucesión de números naturales $(a_n)_(n in NN)$, la sucesión $phi((a_n)_(n in NN))$ es un elemento de $A_6$: en efecto, como para todo $m in NN$, en la posición $m$ la sucesión $phi((a_n)_(n in NN))$ tiene el número
$
(phi((a_n)_(n in NN)))_m = p_(sum_(n=1)^m a_n) < p_(sum_(n=1)^(m+1) a_n) = (phi((a_n)_(n in NN)))_(m+1),
$
se tiene que $phi((a_n)_(n in NN))$ es estrictamente creciente, y por lo tanto es un elemento de $A_3$. Además, por construcción todos los números de la sucesión son primos, y luego $phi((a_n)_(n in NN)) in A_2$. Por lo tanto, $phi((a_n)_(n in NN)) in A_6$. Para ver que $phi$ es inyectiva, supongamos que $phi((a_n)_(n in NN)) = phi((b_n)_(n in NN))$. Se sigue de la definición que para todo $m in NN$,
$
p_(sum_(n=1)^m a_n) = p_(sum_(n=1)^m b_n). quad (8)
$
Tomando $m = 1$ en (8), se tiene que $p_(a_1) = p_(b_1)$, y por lo tanto, $a_1 = b_1$. Para el paso inductivo, supongamos que existe $m_0$ tal que $a_n = b_n$ para todo $1 <= n <= m_0$. Tomando $m_0 + 1$ en (8) obtenemos
$
p_(sum_(n=1)^(m_0 + 1) a_n) = p_(sum_(n=1)^(m_0 + 1) b_n),
$
y entonces
$
sum_(n=1)^(m_0 + 1) a_n = sum_(n=1)^(m_0 + 1) b_n,
$
lo que junto con la hipótesis inductiva que dice que $a_n = b_n$ para todo $1 <= n <= m_0$, implica que $a_(m_0 + 1) = b_(m_0 + 1)$. Hemos probado inductivamente que $(a_n)_(n in NN) = (b_n)_(n in NN)$, y por lo tanto, que la función $phi$ es inyectiva. Se sigue que $\#(NN^NN) <= \#(A_6)$, como buscábamos.

Esto nos dice que el cardinal de cada uno de los $A_j$, $1 <= j <= 6$, es igual al de $NN^NN$. También vimos en clases anteriores que $NN^NN tilde.op cal(P)(NN)$ (ver clase del 01/09/26), y como también vimos que $cal(P)(NN) tilde.op RR$, concluimos que $\#(A_j) = frak(c)$ para todo $1 <= j <= 6$. #align(right)[#square()]

_Ejercicio 4_: Sea $X$ un conjunto, $n in NN$, y $D_1, dots, D_n$ sean métricas sobre $X$. Definimos $D : X times X -> RR_(>= 0)$ por medio de la fórmula
$
D(x, y) := op("máx", limits: #true)_(1 <= j <= n) {D_j (x, y)}.
$

#enum(numbering: "(i)",
  [Probar que $D$ es una métrica.],
  [Si cambiamos el máximo por el mínimo en la definición de $D$, ¿sigue funcionando el argumento del punto anterior para probar que es una métrica? Ejercicio optativo (más difícil): determinar si, tomando el mínimo, $D$ es una métrica.],
)

_Solución_: (i) Para probar que $D$ es una métrica, tenemos que ver que vale lo siguiente:

+ $D(x, y) >= 0$ para todo $x, y in X$.
+ $D(x, y) = 0$ si y sólo si $x = y$.
+ Para todos $x, y in X$, se tiene que $D(x, y) = D(y, x)$.
+ Para todos $x, y, z in X$, se tiene que
  $
  D(x, y) <= D(x, z) + D(y, z).
  $

Para ver esto, notemos primero que $D >= 0$ porque es el máximo de funciones no negativas. Por otra parte, $D >= d_1$. Luego, si $D(x, y) = 0$, entonces $D_1 (x, y) = 0$, lo que implica que $x = y$ porque $D_1$ es una métrica. Por otra parte, si $x = y$, entonces $D_j (x, y) = 0$ para todo $1 <= j <= n$, así que $D(x, y) = 0$. Hemos probado hasta ahora (1) y (2). Probemos (3):
$
D(x, y) := op("máx", limits: #true)_(1 <= j <= n) {D_j (x, y)} = op("máx", limits: #true)_(1 <= j <= n) {D_j (y, x)} = D(y, x),
$
en donde usamos para la segunda igualdad que las $D_j$ son métricas.

_Nota_: la fuente escribe "$D >= d_1$"; se refiere a $D >= D_1$ (la primera de las métricas $D_j$), que es lo que se usa en la oración siguiente.

Resta ver (4), para lo cual usamos nuevamente que son métricas: Dados $x, y, z in X$, sea $1 <= k <= n$ tal que $D(x, y) = D_k (x, y)$ (es decir, dados $x$ e $y$, elegimos $k$ donde se alcanza el máximo). Tenemos que
$
D(x, y) = D_k (x, y) <= D_k (x, z) + D_k (z, y) <= D(x, z) + D(z, y).
$

(ii) En este caso, argumentos similares a los anteriores muestran que las propiedades (1), (2), (3) valen (queda como ejercicio demostrarlo). Pero el argumento para probar (4) ya no funciona, ya que no tenemos un máximo sino un mínimo, y no tendría en principio por qué ser menor que la suma de los mínimos. Este razonamiento, sin embargo, no alcanza para probar que $D$ así definida no es métrica, ya que esto no muestra que no haya otro argumento que sí funcione. Lo que tenemos que hacer si queremos probar que $D$ no es necesariamente métrica si la definimos con el mínimo, es encontrar un contraejemplo. ¿Cómo lo hacemos? Primero, para hacerlo más fácil tomamos $n = 2$. Segundo, como lo que queremos ver es que no vale (4), nos hace falta algún conjunto $X$ y dos métricas $D_1$ y $D_2$ tales que para algunos $x, y, z in X$, el mínimo entre $D_1 (x, y)$ y $D_2 (x, y)$ sea más grande que la suma de los mínimos entre $D_1 (x, z)$ y $D_2 (x, z)$ por un lado, y $D_1 (z, y)$ y $D_2 (z, y)$ por otro. Podemos hacerlo con un ejemplo en un conjunto de pocos elementos, para simplificar las cosas. Por ejemplo consideremos el conjunto $X = {1, 2, 3}$. Definimos dos métricas $D_1$ y $D_2$ como sigue: $D_1$ es la restricción a $X$ de la métrica usual en $RR$, es decir, $D_1 (x, y) = abs(x - y)$. Para $D_2$ tenemos que imaginarnos algo más: notemos que $D_1 (1, 3) = 2 = D_1 (1, 2) + D_1 (2, 3)$. Entonces buscamos que $D_2$ mantenga la distancia entre $1$ y $3$, pero reduzca una de las otras. Pero al hacer esto, tenemos que agrandar la otra, para garantizar que $D_2$ sí sea una métrica. Por ejemplo,
$
D_2 (1, 3) &:= 2; \
D_2 (1, 2) &:= 1/2; \
D_2 (2, 3) &:= 2.
$
¿Es $D_2$ una métrica? Sí; queda como ejercicio demostrarlo. Queda también como ejercicio probar que si hubiéramos tomado $D_2 (2, 3) = 1$ en la definición de $D_2$, entonces no nos habría quedado una métrica (el valor más chico que habríamos podido tomar para que nos quedase una métrica es $3/2$; el más grande es $5/2$. Fuera de ese rango, no valdría la desigualdad triangular).

Y entonces, tomando mínimo se tiene que $D(1, 3) = 2$, $D(1, 2) = 1/2$ y $D(2, 3) = 1$, y entonces no se cumple la desigualdad triangular, así que $D$ no es una métrica. Esto prueba que si queremos obtener una métrica, no podemos reemplazar el máximo por el mínimo en la definición de $D$. #align(right)[#square()]
