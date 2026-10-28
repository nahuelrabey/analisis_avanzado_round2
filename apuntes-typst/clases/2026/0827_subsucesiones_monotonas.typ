// Clase práctica 2026 · 27/08/2026 (apunte tipeado de la cátedra, "27082026sols": soluciones de los ejercicios de la clase).
// Sus ejercicios llevan el tag `27-08/{k}` en `ejemplos/` (k = número de ejercicio del apunte).

= Subsucesiones monótonas y divergentes

_Ejercicio 1_: Sea $(a_n)_(n in NN)$ una sucesión de números reales que no tiene cota superior. Probar que $(a_n)_(n in NN)$ tiene una subsucesión estrictamente creciente que diverge a $+infinity$.

_Sugerencia_: Mirar el ejercicio de la clase del martes, y buscar la manera de modificar la solución para que la subsucesión sea estrictamente creciente (también tener en cuenta que en este ejercicio los elementos de la sucesión no son necesariamente todos positivos).

_Solución_: Buscamos $(a_(n_k))_(k in NN)$ que cumpla las siguientes condiciones:

- Condición (a): Para todo $k in NN$, $n_k < n_(k+1)$. Esto dice que $(a_(n_k))_(k in NN)$ es una subsucesión.
- Condición (b): Para todo $k in NN$, $a_(n_k) < a_(n_(k+1))$. Esto dice que $(a_(n_k))_(k in NN)$ es estrictamente creciente.
- Condición (c): Para todo $M > 0$, existe $k_M$ tal que si $k >= k_M$, entonces $a_(n_k) > M$. Esto dice que $(a_(n_k))_(k in NN)$ diverge a $+infinity$ (también se usa la expresión sinónima "tiende a $+infinity$").

Para obtener la Condición (c), vamos a construir $(a_(n_k))_(k in NN)$ de manera que
$
a_(n_k) > k quad forall k in NN. quad (1)
$
Esta no es la única manera de obtener la Condición (c); por ejemplo, podríamos pedir $a_(n_k) > sqrt(k)$ o $a_(n_k) > k + 1$, etc., pero $(1)$ es una manera conveniente de obtener la Condición (c).

Empecemos ahora la construcción: lo que sabemos es que $(a_n)_(n in NN)$ no tiene cota superior; esto significa que para todo $M > 0$ existe $n(M)$ tal que $a_(n(M)) > M$. Entonces podemos empezar tomando $n_1$ tal que $a_(n_1) > 1$. Aunque podemos simplemente decir esto sin decir "quién" es $n_1$, para concretar, podemos definir por ejemplo
$
n_1 := op("mín") {n in NN : a_n > 1}.
$
Notemos que el mínimo existe porque el conjunto ${n in NN : a_n > 1}$ es un conjunto de números naturales y es no vacío porque $(a_n)_(n in NN)$ no tiene cota superior.

Ahora veamos cómo elegimos $a_(n_2)$: para que se cumpla que $a_(n_2) > a_(n_1)$ y $a_(n_2) > 2$, podríamos por ejemplo elegir $n_2$ de manera que
$
a_(n_2) > op("máx") {2, a_(n_1)}. quad (2)
$
Sin embargo, esto no garantizaría que $n_2 > n_1$, y nosotros queremos una subsucesión, es decir, queremos que se cumpla la Condición (a). Una manera de lograrlo es la siguiente: en lugar de $(2)$, vamos a tomar (para concretar, pero hay otras maneras de elegir)
$
n_2 := op("mín") {n in NN : a_n > op("máx") {2, op("máx") {a_k : 1 <= k <= n_1}}}. quad (3)
$
Este número está nuevamente bien definido porque el conjunto ${n in NN : a_n > op("máx") {2, op("máx") {a_k : 1 <= k <= n_1}}}$ es un conjunto no vacío de números naturales (es no vacío porque $(a_n)_(n in NN)$ no tiene cota superior, y entonces en particular $op("máx") {2, op("máx") {a_k : 1 <= k <= n_1}}$ no es cota superior de la sucesión, así que para algún $n in NN$, $a_n$ es más grande que ese número).

¿Por qué $(3)$ sí nos alcanza para garantizar que $n_2 > n_1$? Es porque para cualquier $1 <= n <= n_1$, se tiene que
$
a_n <= op("máx") {a_k : 1 <= k <= n_1} < a_(n_2),
$
y como no puede ser que $a_(n_2) < a_(n_2)$, entonces no puede ser que $n_2$ sea uno de los $n$ tales que $1 <= n <= n_1$.

Resumiendo, hemos encontrado $n_2$ tal que
$
n_2 &> n_1; \
a_(n_2) &> a_(n_1); \
a_(n_2) &> 2.
$
Ahora vamos a usar la misma idea para dar una definición recursiva: tenemos que $a_(n_1) > 1$, y supongamos que para un cierto $k in NN_(>= 2)$ se cumple que para cada $1 <= j <= k - 1$,
$
n_(j+1) > n_j, quad a_(n_(j+1)) > a_(n_j), quad a_(n_(j+1)) > j + 1. quad (4)
$
(en otras palabras, hemos construido los primeros $k$ elementos de nuestra sucesión, de manera que se cumpla lo que buscamos). Entonces tomamos
$
n_(k+1) := op("mín") {n in NN : a_n > op("máx") {k + 1, op("máx") {a_l : 1 <= l <= n_k}}}.
$
Esta elección hace que para $j = k + 1$, también valga $(4)$. Recursivamente, hemos construido entonces $(a_(n_k))_(k in NN)$ de manera que valgan (a), (b) y $(1)$, y por lo tanto, esto concluye el ejercicio. #align(right)[#square()]

_Nota_: en el apunte, en $(3)$, en la definición de $n_(k+1)$ y en las Observaciones 1 y 2, falta una llave de cierre (se escribe `}}` donde hacen falta tres); acá las llaves están balanceadas.

_Observación 1_: Notemos que en la solución del Ejercicio 1, no era necesario elegir "a mano" $n_2$; lo elegimos de esa manera para que se viera más claramente qué hacíamos, pero podríamos simplemente haber definido $(n_k)_(k in NN)$ de la siguiente manera:
$
n_1 &:= op("mín") {n in NN : a_n > 1}; \
n_(k+1) &:= op("mín") {n in NN : a_n > op("máx") {k + 1, op("máx") {a_l : 1 <= l <= n_k}}} quad forall k in NN.
$

_Observación 2_: Elegir el mínimo en la solución del Ejercicio 1 y en la Observación 1 es una manera conveniente de definir la sucesión, pero no hacía falta hacer esto. Por ejemplo, podríamos haber dicho: tomamos $n_1$ tal que $a_(n_1) > 1$ y, recursivamente, tomamos $n_(k+1)$ de manera que $a_(n_(k+1)) > op("máx") {k + 1, op("máx") {a_l : 1 <= l <= n_k}}$.

_Observación 3_: Aunque no hace falta, podemos probar que la Condición $(1)$ garantiza que $a_(n_k) limits(-->)_(k -> infinity) +infinity$: Dado $M > 0$, el conjunto ${k in NN : k > M}$ es no vacío por arquimedianidad. Como es un conjunto de números naturales, se sigue que tiene un mínimo, al que podemos llamar por ejemplo $k_M$. Para cada $k >= k_M$, tenemos que
$
a_(n_k) > k >= k_M > M.
$
Esto prueba, por definición, que $a_(n_k) limits(-->)_(k -> infinity) +infinity$.

_Ejercicio 2_: Sea $(a_n)_(n in NN)$ una sucesión de números reales que tiene cota superior. Para cada $m in NN$ sea
$
A_m := {a_n : n >= m}.
$
Probar que si existe $m in NN$ tal que el conjunto $A_m$ no tiene máximo, entonces $(a_n)_(n in NN)$ tiene una subsucesión estrictamente creciente.

_Sugerencia_: Tomar $m in NN$ tal que $A_m$ no tiene máximo, sea $s_m := sup (A_m)$, y pensar cómo construir una subsucesión estrictamente creciente que converja a $s_m$.

_Solución_: Tomamos $m in NN$ tal que $A_m$ no tiene máximo. Como $A_m subset.eq A_1$ y $A_1$ tiene cota superior (por hipótesis, ya que esto es equivalente a que la sucesión $(a_n)_(n in NN)$ tenga cota superior), entonces $A_m$ tiene cota superior. Luego, $A_m$ tiene supremo, al que podemos llamar (por ejemplo) $s_m$. Vamos a construir una subsucesión $(a_(n_k))_(k in NN)$ que converja a $s_m$, siguiendo la sugerencia. Para esto, nos hace falta que se cumplan las siguientes condiciones:

- Condición (a): Para todo $k in NN$, $n_k < n_(k+1)$. Esto dice que $(a_(n_k))_(k in NN)$ es una subsucesión.
- Condición (b): Para todo $k in NN$, $a_(n_k) < a_(n_(k+1))$. Esto dice que $(a_(n_k))_(k in NN)$ es estrictamente creciente.
- Condición (c): Para todo $epsilon > 0$, existe $k_epsilon$ tal que si $k >= k_epsilon$, entonces $abs(a_(n_k) - s_m) < epsilon$. Esto dice que $(a_(n_k))_(k in NN)$ converge a $s_m$.

Para obtener la Condición (c), vamos a construir $(a_(n_k))_(k in NN)$ de manera que
$
a_(n_k) > s_m - 1/k quad forall k in NN. quad (5)
$
Esta no es la única manera de obtener la Condición (c); por ejemplo, podríamos pedir $a_(n_k) > 1 - 1/sqrt(k)$, etc., pero $(5)$ es una manera conveniente de obtener la Condición (c).

_Nota_: el apunte escribe "$a_(n_k) > 1 - 1/sqrt(k)$"; por el contexto (comparar con $(5)$), la alternativa que se quiere sugerir es $a_(n_k) > s_m - 1/sqrt(k)$.

Entonces comencemos con la construcción. Primero, como $s_m$ es la menor cota superior de $A_m$, entonces $s_m - 1$ no es cota superior de $A_m$, así que existe $x in A_m$ tal que $x > s_m - 1$. Por lo tanto, podemos definir
$
n_1 := op("mín") {n in NN_(>= m) : a_n > s_m - 1},
$
y se tiene que $a_(n_1) > s_m - 1$. Puesto que el conjunto $A_m$ no tiene máximo y la menor cota superior es $s_m$, se tiene que el número
$
op("máx") {s_m - 1/2, op("máx") {a_n : 1 <= n <= n_1}}
$
no es cota superior de $A_m$. Luego, existe $x in A_m$ tal que $x > op("máx") {s_m - 1/2, op("máx") {a_n : 1 <= n <= n_1}}$. Podemos entonces definir
$
n_2 := op("mín") {n in NN : a_n > op("máx") {s_m - 1/2, op("máx") {a_n : 1 <= n <= n_1}}}.
$
Notemos que como
$
a_(n_2) > op("máx") {s_m - 1/2, op("máx") {a_n : 1 <= n <= n_1}} >= a_n quad forall 1 <= n <= n_1,
$
se tiene que $n_2 > n_1$ (porque no puede ser que $a_(n_2) > a_(n_2)$). Además, también tenemos por construcción que $a_(n_2) > a_(n_1)$, y que $a_(n_2) > s_m - 1/2$. Como en el Ejercicio 1, hacemos la definición recursiva como sigue: Tenemos que $a_(n_1) > s_m - 1$, y supongamos que para un cierto $k in NN_(>= 2)$, se cumple que para $1 <= j <= k - 1$
$
n_(j+1) > n_j, quad a_(n_(j+1)) > a_(n_j); quad a_(n_(j+1)) > s_m - 1/(j+1). quad (6)
$
(en otras palabras, hemos construido los primeros $k$ elementos de nuestra sucesión, de manera que se cumpla lo pedido). Entonces definimos
$
n_(k+1) := op("mín") {n in NN : a_n > op("máx") {s_(k+1) - 1/(k+1), op("máx") {a_j : 1 <= j <= n_k}}}.
$
Esta elección hace que para $j = k + 1$, también valga $(6)$. Recursivamente, hemos construido entonces $(a_(n_k))_(k in NN)$ de manera que valgan (a), (b) y $(5)$, y por lo tanto, esto termina la construcción pedida en el ejercicio. #align(right)[#square()]

_Nota_: el apunte escribe "$s_(k+1) - 1/(k+1)$" en la definición de $n_(k+1)$; el supremo en juego es siempre el de $A_m$, así que debería decir $s_m - 1/(k+1)$ (es lo que hace falta para que valga $(6)$ con $j = k$, es decir, $(5)$ para $k + 1$).

_Nota_: hay otro desliz en los rangos de índices: el apunte toma $op("máx") {a_n : 1 <= n <= n_1}$ (y $op("máx") {a_j : 1 <= j <= n_k}$) y busca $n in NN$ sin pedir $n >= m$. Si algún término anterior a $m$ es grande, ese máximo sí es cota superior de $A_m$ y el conjunto cuyo mínimo se toma queda vacío: por ejemplo $a_1 = 5$, $a_n = 1 - 1/n$ para $n >= 2$, con $m = 2$. Lo que hace funcionar el argumento es tomar los máximos sobre $m <= n <= n_1$ (resp. $m <= j <= n_k$) y $n in NN_(>= m)$, como en $n_1$; así está escrito en `ejemplos/p1.typ` (tag 27-08/2). La alternativa de la Observación 4 ($n_1 := 1$ y máximo desde $1$) tiene el mismo problema.

_Observación 4_: En el Ejercicio 2, construimos una sucesión que converge al supremo del conjunto $A_m$, siguiendo la sugerencia. Pero notemos que eso no era necesario para cumplir con el enunciado del ejercicio, que sólo pedía que la sucesión fuera estrictamente creciente. Queda como ejercicio verificar que si sólo queremos que la subsucesión sea estrictamente creciente (como pide el enunciado del ejercicio), pero no nos interesa que tienda al supremo de $A_m$, la siguiente alternativa también está bien definida y cumple lo pedido:
$
n_1 &:= 1; \
n_(k+1) &:= op("mín") {n in NN_(>= m) : a_n > op("máx") {a_j : 1 <= j <= n_k}} quad forall k in NN.
$

_Observación 5_: Aunque no hace falta, podemos probar que la Condición $(5)$ garantiza que $a_(n_k) limits(-->)_(k -> infinity) s_m$: Dado $epsilon > 0$, el conjunto ${k in NN : 1/k < epsilon}$ es no vacío por arquimedianidad. Como es un conjunto de números naturales, esto implica que tiene un mínimo, digamos $k_epsilon$. Para cada $k >= k_epsilon$, tenemos que
$
abs(s_m - a_(n_k)) = s_m - a_(n_k) < 1/k <= 1/k_epsilon < epsilon.
$
Esto prueba, por definición, que $a_(n_k) limits(-->)_(k -> infinity) s_m$.

_Ejercicio 3_: Sea $(a_n)_(n in NN)$ una sucesión de números reales. Probar que $(a_n)_(n in NN)$ tiene una subsucesión monótona (es decir, o bien $(a_n)_(n in NN)$ tiene una subsucesión creciente, o bien $(a_n)_(n in NN)$ tiene una subsucesión decreciente).

_Sugerencia_: Considerar los siguientes casos:

- Caso 1: Se cumplen las hipótesis del Ejercicio 1.
- Caso 2: Se cumplen las hipótesis del Ejercicio 2.
- Caso 3: No se cumplen ni las hipótesis del Ejercicio 1 ni las hipótesis del Ejercicio 2.

_Solución_: Sigamos la sugerencia: Si $(a_n)_(n in NN)$ es no acotada superiormente, entonces por el Ejercicio 1, $(a_n)_(n in NN)$ tiene una subsucesión creciente. Si $(a_n)_(n in NN)$ es acotada superiormente y existe $m in NN$ tal que $A_m$ no tiene máximo, entonces por el Ejercicio 2, $(a_n)_(n in NN)$ tiene una subsucesión creciente.

¿Qué caso falta considerar? El caso en que $(a_n)_(n in NN)$ es acotada superiormente y, para todo $m in NN$, $A_m$ tiene máximo: veamos este caso, en el que vamos a construir una subsucesión decreciente.

Primero, notemos que para todo $m in NN$, $A_(m+1) subset.eq A_m$, y por lo tanto, $op("máx") (A_(m+1)) <= op("máx") (A_m)$. Entonces procedemos de la siguiente manera: Como $A_1$ tiene máximo, existe algún $n in NN$ tal que $a_n = op("máx") (A_1)$. Entonces podemos definir
$
n_1 := op("mín") {n in NN : a_n = op("máx") (A_1)}.
$
Ahora queremos $n_2 > n_1$ tal que $a_(n_2) <= a_(n_1)$. Dado que $A_(n_1 + 1)$ tiene máximo, podemos definir
$
n_2 := op("mín") {n in NN_(>= n_1 + 1) : a_n = op("máx") (A_(n_1 + 1))}.
$
Como $a_(n_1)$ es el máximo del conjunto $A_1$, $a_(n_2)$ es el máximo del conjunto $A_(n_1 + 1)$, y $A_(n_1 + 1) subset.eq A_1$, se tiene que $a_(n_2) <= a_(n_1)$. Además, $n_2 > n_1$ por cómo lo elegimos. En general, para $k >= 2$, definimos
$
n_(k+1) := op("mín") {n in NN_(>= n_k + 1) : a_n = op("máx") (A_(n_k + 1))}.
$
Por construcción, $n_(k+1) > n_k$ para todo $k in NN$. Ya vimos que $a_(n_1) >= a_(n_2)$. Para cada $k >= 2$, como $a_(n_(k+1))$ es el máximo de $A_(n_k + 1)$ mientras que $a_(n_k)$ es el máximo de $A_(n_(k-1) + 1)$ y $A_(n_(k-1) + 1) supset.eq A_(n_k + 1)$ (porque $n_k > n_(k-1)$), se tiene que $a_(n_(k+1)) <= a_(n_k)$. Luego, hemos probado que para todo $k in NN$,
$
n_(k+1) > n_k quad "y" quad a_(n_(k+1)) <= a_(n_k).
$
En otras palabras, hemos construido una subsucesión $(a_(n_k))_(k in NN)$ que es decreciente. Como ya consideramos todos los casos posibles, y hemos visto que en cada uno de ellos, $(a_n)_(n in NN)$ tiene una subsucesión monótona, esto completa la solución del ejercicio. #align(right)[#square()]

_Observación 6_: Notar que en el Ejercicio 3, a diferencia de los dos anteriores, para elegir $n_2$ no usamos el "truco" de considerar el máximo de los $a_n$ con $1 <= n <= n_1$, ya que estamos tomando un máximo de $A_(n_1 + 1)$, y por lo tanto va a haber un $n >= n_1 + 1$ en donde $a_n$ alcance ese máximo. Lo mismo pasa para la elección de $n_(k+1)$, para cada $k >= 2$.
