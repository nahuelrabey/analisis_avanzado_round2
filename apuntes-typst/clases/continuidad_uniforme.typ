// Notas docentes 2025 · clase del 23/10/2025 (manuscrito "Análisis avanzado — Continuidad uniforme").
// Clase 8 de la transcripción: sus ejercicios llevan el tag `C8-{k}` en `ejemplos/`.
// La primera página del manuscrito lleva el encabezado "Continuidad".
#import "../utils.typ": recta

= Continuidad uniforme

Sean $(X, d_1)$ e $(Y, d_2)$ espacios métricos. En $X times Y$ definimos
$
d_infinity ((x, y), (x', y')) = op("máx") {d_1 (x, x'), d_2 (y, y')}.
$
Notemos que $d_infinity$ es una métrica:

- $d_infinity ((x, y), (x', y')) = 0$ sii $d_1 (x, x') = 0$ y $d_2 (y, y') = 0$. Como $d_1, d_2$ son métricas, $d_1 (x, x') = 0$ sii $x = x'$ y $d_2 (y, y') = 0$ sii $y = y'$. Concluimos que $d_infinity ((x, y), (x', y')) = 0$ sii $(x, y) = (x', y')$.

- $d_infinity ((x, y), (x', y')) = d_infinity ((x', y'), (x, y))$ (por simetría de $d_1, d_2$).

- Como
  $
  d_1 (x, x') <= d_1 (x, z) + d_1 (z, x') quad "y" quad d_2 (y, y') <= d_2 (y, w) + d_2 (w, y'),
  $
  dado $(z, w) in X times Y$,
  $
  d_1 (x, x') &<= op("máx") {d_1 (x, z), d_2 (y, w)} + op("máx") {d_1 (z, x'), d_2 (w, y')} \
  &= d_infinity ((x, y), (z, w)) + d_infinity ((z, w), (x', y')),
  $
  y similarmente
  $
  d_2 (y, y') <= d_infinity ((x, y), (z, w)) + d_infinity ((z, w), (x', y')),
  $
  tenemos que
  $
  d_infinity ((x, y), (x', y')) &= op("máx") {d_1 (x, x'), d_2 (y, y')} \
  &<= d_infinity ((x, y), (z, w)) + d_infinity ((z, w), (x', y')).
  $

_Ejercicio 1_: Sean $(X, d_1)$ e $(Y, d_2)$ espacios métricos. Pensamos a $X times Y$ con $d_infinity$.

a- Probar que $pi_1 : X times Y -> X$, $(x, y) |-> x$, $pi_2 : X times Y -> Y$, $(x, y) |-> y$ son continuas y abiertas, pero pueden _no ser cerradas_.

b- Sea $(Z, delta)$ un espacio métrico y sea $f : Z -> X times Y$ una aplicación. Probar que $f$ es continua si y sólo si $f_1 = pi_1 compose f$ y $f_2 = pi_2 compose f$ lo son.

_Res_:

a- Probemos que $pi_1$ es continua y abierta. Para ver que es continua, dado $(x_0, y_0) in X times Y$, podemos ver que dado $epsilon > 0$, existe $delta > 0$ tal que si $d_infinity ((x, y), (x_0, y_0)) < delta$ entonces
$
d_1 (pi_1 (x, y), pi_1 (x_0, y_0)) = d_1 (x, x_0) < epsilon.
$
Como
$
d_1 (x, x_0) <= op("máx") {d_1 (x, x_0), d_2 (y, y_0)} = d_infinity ((x, y), (x_0, y_0)), quad (*)
$
si $delta < epsilon$ garantizamos $(*)$.

Para ver que $pi_1$ es abierta, tenemos que ver _para todo abierto $U subset.eq X times Y$, $pi_1 (U)$ es abierto_. Notemos que si probamos que _para toda bola $B(x, r)$, $pi_1 (B(x, r))$ es abierto_, entonces se sigue la misma conclusión para todo abierto $U$: para todo $x in U$, existe $r_x > 0$ tal que $B(x, r_x) subset.eq U$. Entonces $U = union.big_(x in U) B(x, r_x)$, por lo tanto
$
pi_1 (U) = pi_1 (union.big_(x in U) B(x, r_x)) = union.big_(x in U) pi_1 (B(x, r_x))
$
y es unión de abiertos, por lo tanto es abierto.

Sea $(x_0, y_0) in X times Y$ y $r > 0$. Entonces
$
B((x_0, y_0), r) &= {(x, y) : d_infinity ((x, y), (x_0, y_0)) < r} \
&= {(x, y) : op("máx") {d_1 (x, x_0), d_2 (y, y_0)} < r} \
&= {(x, y) : d_1 (x, x_0) < r "y" d_2 (y, y_0) < r}.
$
Por otro lado,
$
pi_1 (B((x_0, y_0), r)) = {x in X : "existe" y in Y "con" d_1 (x, x_0) < r "y" d_2 (y, y_0) < r}.
$
(dibujo: en el plano $x y$, la bola centrada en $(x_0, y_0)$ y, debajo, su sombra sobre el eje $x$: un intervalo centrado en $x_0$ del "mismo radio".)

Veamos que $B(x_0, r) subset.eq pi_1 (B((x_0, y_0), r))$. Dado $x in B(x_0, r)$, resulta que $d_1 (x, x_0) < r$. Sea $y in B(y_0, r)$, por ejemplo $y = y_0$. Tenemos que $(x, y_0) in B((x_0, y_0), r)$, pues
$
d_infinity ((x_0, y_0), (x, y_0)) = op("máx") {d_1 (x_0, x), underbrace(d_2 (y_0, y_0), = 0)} = d_1 (x_0, x) < r.
$
Entonces $B(x_0, r) subset.eq pi_1 (B((x_0, y_0), r))$.

_Nota_: el manuscrito prueba sólo esta inclusión. La otra es inmediata de la descripción anterior: si $x in pi_1 (B((x_0, y_0), r))$ entonces $d_1 (x, x_0) < r$, o sea $x in B(x_0, r)$. Así $pi_1 (B((x_0, y_0), r)) = B(x_0, r)$, que es abierto, y eso es lo que se necesitaba.

Veamos que en general $pi_1$ _no es cerrada, es decir, existe $F subset.eq X times Y$ cerrado con $pi_1 (F)$ no cerrado_.

_Idea_: sea $F subset.eq X times Y$ cerrado, y consideramos $pi_1 (F)$. Si $(x_n)_n subset.eq pi_1 (F)$ cumple que $x_n -> x$, querríamos ver que $x in pi_1 (F)$, es decir, existe $y in Y$ tal que $(x, y) in F$. Como $x_n in pi_1 (F)$, existe $y_n in Y$ tal que $(x_n, y_n) in F$. _Lo ideal sería que $(x_n, y_n) -> (x, y)$, porque en tal caso, al ser $F$ cerrado, $(x, y) in F$ y entonces $x in pi_1 (F)$. El problema es que $(y_n)_n$ no tiene por qué converger, o tener subsucesiones convergentes._

_Ej_: si $X = Y = RR$, en $RR^2$ con $d_infinity$, sea $F = {(x, y) : x y = 1}$. Es cerrado porque es la preimagen de ${1}$ vía $f(x, y) = x y$, o sea: $F = f^(-1) ({1})$. Como $f$ es continua, $F$ es cerrado. Pero
$
pi_1 (F) = {x in RR : "existe" y in RR "con" x y = 1} = RR - {0},
$
que no es cerrado.

(dibujo: la hipérbola $x y = 1$ en el plano, con flechas que la proyectan sobre el eje $x$; la proyección cubre toda la recta salvo el $0$.)

Las afirmaciones para $pi_2$ se prueban de manera análoga.

b) Notemos que si $f$ es continua, por el ítem a), $pi_1$ y $pi_2$ son continuas, y en consecuencia $f_1 = pi_1 compose f$ y $f_2 = pi_2 compose f$ son continuas por ser composición de continuas. Usemos sucesiones. Tenemos que $f$ es continua en $z_0 in Z$ sii para toda $(z_n)_n subset.eq Z$ con $z_n -> z_0$ se tiene que $f(z_n) -> f(z_0)$. Notemos que
$
f : Z -> X times Y, quad f(z) = (f_1 (z), f_2 (z)),
$
porque $f_1 = pi_1 compose f$, $f_2 = pi_2 compose f$. Sea $(z_n)_n subset.eq Z$ con $z_n -> z_0$. Como $f_1$ y $f_2$ son continuas en $z_0$, $f_1 (z_n) -> f_1 (z_0)$ y $f_2 (z_n) -> f_2 (z_0)$. Sea $epsilon > 0$. Sabemos que existen $n_1, n_2 in NN$ tales que
$
d_1 (f_1 (z_0), f_1 (z_n)) &< epsilon " para todo " n >= n_1, \
d_2 (f_2 (z_0), f_2 (z_n)) &< epsilon " para todo " n >= n_2.
$
Entonces, para todo $n >= n_0 = op("máx") {n_1, n_2}$,
$
d_infinity (f(z_0), f(z_n)) = op("máx") {d_1 (f_1 (z_0), f_1 (z_n)), d_2 (f_2 (z_0), f_2 (z_n))} < epsilon.
$
Concluimos que $f(z_n) -> f(z_0)$. #align(right)[#square()]

_Obs_: de 1 b) sale que en $X times Y$ con $d_infinity$, la sucesión $(x_n, y_n) -> (x, y)$ sii $x_n -> x$ e $y_n -> y$, tomando $f : X times Y -> X times Y$, $f(x, y) = op("id")_(X times Y) (x, y) = (x, y)$, es decir $f_1 (x, y) = x$, $f_2 (x, y) = y$.

Recordemos que $f : (E, d) -> (E, d')$ es lipschitz si existe $M > 0$ tal que
$
d' (f(x), f(y)) <= M d(x, y) " para todo " x, y in E.
$

_Nota_: el manuscrito escribe "para todo $x, y in M$" (el espacio se llama $E$; $M$ es la constante).

_Ejercicio 2_: Sea $f : (a, b) -> RR$ derivable, con derivada acotada. Probar que $f$ es lipschitz.

_Res_: Recordemos que por el teorema del valor medio, dados $x < y$, si $f$ es continua en $[x, y]$ y derivable en $(x, y)$, entonces existe $c in (x, y)$ tal que $f(x) - f(y) = f'(c) (x - y)$. Con esto en mente, dados $x, y in (a, b)$, con $x < y$, existe $c in (x, y)$ tal que
$
abs(f(x) - f(y)) = abs(f'(c)) dot.c abs(x - y).
$
Como $f'(c)$ está acotada (pues $c in (x, y) subset.eq (a, b)$), digamos por $M$, se sigue que
$
abs(f(x) - f(y)) <= M dot.c abs(x - y).
$
Concluimos. #align(right)[#square()]

_Ej_: Si $f : (0, 1) -> RR$, $f(x) = x^3$, por el teorema del valor medio, para $0 < x < y < 1$, existe $c in (x, y)$ tal que
$
abs(f(x) - f(y)) = abs(f'(c) (x - y)) = 3 c^2 abs(x - y) <= 3 abs(x - y),
$
donde usamos que $c in (0, 1)$, por lo tanto $abs(c) <= 1$.

_Ejercicio 3_: Sea $f : RR -> RR$ dada por
$
f(x) = cases(
  x sin(1/x) & " si " x != 0,
  0 & " si " x = 0.
)
$

a) Probar que $f$ es continua en $x = 0$.

b) Probar que $f$ no es lipschitz en ningún intervalo que contenga al $0$.

_Nota_: el manuscrito escribe la segunda rama como "$0$ si $f(0) = 0$"; claramente es "si $x = 0$".

_Res_:

a) Sea $epsilon > 0$. Tenemos que
$
abs(f(x) - f(0)) = abs(f(x)) = abs(x sin(1/x)) <= abs(x),
$
por lo tanto $abs(f(x)) < epsilon$ si $abs(x) < delta$ con $delta <= epsilon$.

b) Sea $I = (a, b)$ que contiene al $0$. Como ser lipschitz en $I$ significa que _existe $M > 0$ tal que para todo $x in I$, $y in I$, $abs(f(x) - f(y)) <= M abs(x - y)$_, no ser lipschitz significa que _para todo $M > 0$, existen $x_M in I$, $y_M in I$, tales que $abs(f(x_M) - f(y_M)) > M abs(x_M - y_M)$_. Tomando $M = M_n$ con $M_n -> +infinity$, vemos que alcanza con probar que _existen $(x_n)_n subset.eq I$, $(y_n)_n subset.eq I$, tales que_
$
abs(f(x_n) - f(y_n)) >= M_n dot.c abs(x_n - y_n).
$
Sean $x_n = 1/(pi/2 + 2 pi n)$, $y_n = 1/((3 pi)/2 + 2 pi n)$; tenemos que $x_n != 0$, $y_n != 0$ para todo $n$. Entonces
$
abs(f(x_n) - f(y_n)) &= abs(1/(pi/2 + 2 pi n) sin(pi/2 + 2 pi n) - 1/((3 pi)/2 + 2 pi n) sin((3 pi)/2 + 2 pi n)) \
&= abs(1/(pi/2 + 2 pi n) + 1/((3 pi)/2 + 2 pi n))
= abs(((3 pi)/2 + 2 pi n + pi/2 + 2 pi n) / ((pi/2 + 2 pi n) ((3 pi)/2 + 2 pi n))) \
&= (2 pi + 4 pi n) / ((pi/2 + 2 pi n) ((3 pi)/2 + 2 pi n))
= (2 pi + 4 pi n) / pi dot.c pi / ((pi/2 + 2 pi n) ((3 pi)/2 + 2 pi n)) \
&= (2 + 4 n) abs(1/(pi/2 + 2 pi n) - 1/((3 pi)/2 + 2 pi n))
= (2 + 4 n) dot.c abs(x_n - y_n) = M_n dot.c abs(x_n - y_n),
$
y como $M_n -> +infinity$, concluimos que $f$ _no es lipschitz_.

_Nota_: el manuscrito no lo dice, pero para que $(x_n)_n, (y_n)_n subset.eq I$ hay que quedarse con $n$ grande: como $x_n, y_n -> 0$ e $I$ es un intervalo abierto que contiene al $0$, $x_n, y_n in I$ para todo $n >= n_0$, y eso alcanza (dado $M$, se toma $n >= n_0$ con $M_n > M$, y la desigualdad estricta sale porque $x_n != y_n$).

_Obs_: si $f : E -> F$ es lipschitz entonces $f$ es uniformemente continua. Pero no vale la vuelta; la función del ejemplo anterior en el dominio $[-1, 1]$ es uniformemente continua _(esto es consecuencia de un resultado que veremos más adelante)_ pero no es lipschitz.

_Ejercicio 4_: Sea $Psi : (C[0, 1], d_infinity) -> (C[0, 1], d_1)$ dada por
$
(Psi(f))(x) := x f(x).
$
Decidir si $Psi$ es lipschitz.

_Res_: dadas $f, g in C[0, 1]$, planteamos
$
d_1 (Psi(f), Psi(g)) &= integral_0^1 abs(x f(x) - x g(x)) dif x = integral_0^1 abs(x (f(x) - g(x))) dif x \
&<= integral_0^1 abs(x) abs(f(x) - g(x)) dif x <= integral_0^1 sup_(x in [0, 1]) abs(f(x) - g(x)) dif x \
&= d_infinity (f, g).
$
Entonces $Psi$ es lipschitz. #align(right)[#square()]

_Nota_ (del manuscrito): en 4), en particular vemos que es uniformemente continua.

_Ejercicio 5_: Decidir si son uniformemente continuas.

a) $f : RR -> RR$, $f(x) = sin(x)$.

b) $f : (0, +infinity) -> RR$, $f(x) = x^2$.

_Res_:

a) Una forma es viendo que es lipschitz, mediante el teorema del valor medio: dados $x < y$, existe $c in (x, y)$ tal que
$
f(x) - f(y) = f'(c) (x - y).
$
Entonces
$
abs(f(x) - f(y)) = abs(sin(x) - sin(y)) = abs(cos(c)) dot.c abs(x - y) <= abs(x - y).
$
Como $f$ es lipschitz, es uniformemente continua.

b) Veamos que _no es uniformemente continua_. Para ello, razonamos como para ver que una $f$ no es lipschitz: _existen $epsilon > 0$ y $(x_n)_n subset.eq RR$, $(y_n)_n subset.eq RR$ tales que $abs(x_n - y_n) -> 0$ pero_
$
abs(f(x_n) - f(y_n)) >= epsilon " para todo " n.
$
El problema ocurre cuando $x_n, y_n -> +infinity$. Sea $x_n = n$, $y_n = n + 1/n$. Tenemos que $abs(x_n - y_n) = 1/n -> 0$ pero
$
abs(f(x_n) - f(y_n)) = abs(n^2 - (n + 1/n)^2) = cancel(n^2) + 2 + 1/n^2 - cancel(n^2) > 2.
$
Tomando $epsilon = 2$ vemos que no es uniformemente continua.

_Ejercicio 6_: Sean $(X, d)$ un espacio métrico y $f, g : X -> RR$ uniformemente continuas y acotadas. Probar que $f dot.c g$ es uniformemente continua. Mostrar que el producto de funciones uniformemente continuas puede no serlo _incluso si una de ellas está acotada_. [Sugerencia: $f(x) = x sin(x)$]

_Res_: Sea $epsilon > 0$. Queremos ver que existe $delta > 0$ tal que $d(x, y) < delta$ implica que
$
abs(f(x) dot.c g(x) - f(y) dot.c g(y)) < epsilon.
$
Como $f, g$ son uniformemente continuas, existen $delta_1 > 0$, $delta_2 > 0$ tales que
$
d(x, y) < delta_1 &==> abs(f(x) - f(y)) < epsilon', \
d(x, y) < delta_2 &==> abs(g(x) - g(y)) < epsilon',
$
donde $epsilon' > 0$ lo elegiremos después. Entonces
$
abs(f(x) g(x) - f(y) g(y)) &<= abs(f(x) g(x) - f(y) g(x)) + abs(f(y) g(x) - f(y) g(y)) \
&= abs(g(x)) abs(f(x) - f(y)) + abs(f(y)) abs(g(x) - g(y)). quad (*)
$
Como $f, g$ son acotadas, existen $M_1 > 0$, $M_2 > 0$ tales que $abs(g(x)) <= M_1$ para todo $x in X$, $abs(f(x)) <= M_2$ para todo $x in X$. Entonces en $(*)$ acotamos
$
abs(f(x) g(x) - f(y) g(y)) <= M_1 dot.c epsilon' + M_2 dot.c epsilon' = (M_1 + M_2) dot.c epsilon'
$
si $d(x, y) < op("mín") {delta_1, delta_2}$. Tomando $epsilon' < epsilon / (M_1 + M_2)$, concluimos.

Veamos que la hipótesis de acotadas es necesaria. Sea $f : RR -> RR$, $f(x) = x sin(x)$. Sean $x_n = pi + 2 pi n$, $y_n = pi + 2 pi n + 1/n$. Se tiene que $abs(x_n - y_n) = 1/n -> 0$, pero
$
abs(f(x_n) - f(y_n)) &= abs((pi + 2 pi n) underbrace(sin(pi + 2 pi n), = 0) - (pi + 2 pi n + 1/n) sin(pi + 2 pi n + 1/n)) \
&= abs((pi + 2 pi n + 1/n) sin((pi + 2 pi n) + 1/n)) \
&= abs((pi + 2 pi n + 1/n) [underbrace(sin(pi + 2 pi n), = 0) dot.c cos(1/n) + underbrace(cos(pi + 2 pi n), = -1) dot.c sin(1/n)]) \
&= underbrace(pi sin(1/n), -> 0) + underbrace(2 pi n sin(1/n), (star)) + underbrace(1/n sin(1/n), -> 0).
$
$(star)$ Como $2 pi n sin(1/n) = 2 pi sin(1/n) / (1/n) -> 2 pi$, tenemos que $abs(f(x_n) - f(y_n)) -> 2 pi$, y en consecuencia, existe $epsilon > 0$ tal que $abs(f(x_n) - f(y_n)) >= epsilon$ para todo $n$ suficientemente grande. #align(right)[#square()]

_Ejercicio 7_: Sea $f : [0, +infinity) -> RR$. Supongamos que existe $a > 0$ tal que $f|_([0, a])$ y $f|_([a, +infinity))$ son uniformemente continuas. Probar que $f$ es uniformemente continua.

_Res_: sea $epsilon > 0$. Queremos ver que existe $delta > 0$ tal que $abs(x - y) < delta$ implica que $abs(f(x) - f(y)) < epsilon$.

- si $x, y in [0, a]$, existe $delta_1 > 0$ tal que $abs(x - y) < delta_1$ implica que $abs(f(x) - f(y)) < epsilon'$.

- si $x, y in [a, +infinity)$, existe $delta_2 > 0$ tal que $abs(x - y) < delta_2$ implica que $abs(f(x) - f(y)) < epsilon'$.

- sea $x in [0, a]$, $y in [a, +infinity)$,

#recta([$0$], [$x$], ([$a$], "arriba"), [$y$])

(en el dibujo, $x$ está a distancia $< delta_1$ de $a$ e $y$ a distancia $< delta_2$.)

La idea es que si $x$ e $y$ están muy cerca, estarán cerca de $a$, y si $abs(x - a) < delta_1$ entonces $abs(f(x) - f(a)) < epsilon'$ y similarmente $abs(y - a) < delta$, entonces $abs(f(y) - f(a)) < epsilon'$, por lo tanto $f(x)$ y $f(y)$ estarán muy cerca entre sí. Formalmente, sea $delta < op("mín") {delta_1, delta_2}$. Supongamos que $abs(x - y) < delta$. Como $x <= a <= y$, tenemos que
$
abs(x - a) &= a - x <= y - x = abs(y - x) < delta < delta_1, " entonces " abs(f(x) - f(a)) < epsilon', quad (1) \
abs(y - a) &= y - a <= y - x = abs(y - x) < delta < delta_2, " entonces " abs(f(y) - f(a)) < epsilon'. quad (2)
$
Por lo tanto
$
abs(f(x) - f(y)) <= underbrace(abs(f(x) - f(a)), < epsilon' "por" (1)) + underbrace(abs(f(a) - f(y)), < epsilon' "por" (2)) < 2 epsilon'.
$
Tomando $epsilon' < 2 epsilon$, concluimos. #align(right)[#square()]

_Nota_: el manuscrito cierra con "tomando $epsilon' < 2 epsilon$"; lo que hace falta es $2 epsilon' <= epsilon$, o sea $epsilon' <= epsilon \/ 2$ (con $epsilon' < 2 epsilon$ sólo se obtiene $abs(f(x) - f(y)) < 4 epsilon$).

_Ejercicio 8_: Sean $(X, d)$, $(Y, d')$ espacios métricos y $f : X -> Y$. Supongamos que $X = A union B$, con $A, B$ tales que $d(A, B) > 0$. Si $f|_A$ y $f|_B$ son uniformemente continuas, entonces $f$ es uniformemente continua.

_Res_: Sea $epsilon > 0$. Como $f|_A$ y $f|_B$ son uniformemente continuas, existen $delta_A > 0$, $delta_B > 0$ tales que

- si $x, y in A$ y $d(x, y) < delta_A$ entonces $d'(f(x), f(y)) < epsilon'$;

- si $x, y in B$ y $d(x, y) < delta_B$ entonces $d'(f(x), f(y)) < epsilon'$.

(dibujo: sobre una recta, dos intervalos $A$ y $B$ separados por una brecha de longitud $d(A, B)$; $x in A$, $y in B$, y se marca que $d(x, y) >= d(A, B)$.)

Notemos que si $d(A, B) > 0$ entonces $overline(A) inter overline(B) = emptyset$ (es el contrarrecíproco del ejercicio 11 c): $overline(A) inter overline(B) != emptyset => d(A, B) = 0$).

La idea es que si tomamos $delta > 0$ muy pequeño, no puede pasar que $d(x, y) < delta$ con $x in A$, $y in B$. Si tomamos $delta < op("mín") {delta_A, delta_B, d(A, B)}$, si $x in A$, $y in B$, $d(x, y) < delta$, entonces
$
d(A, B) <= d(x, y) < delta < d(A, B),
$
absurdo. Por lo tanto $d(x, y) < delta$ implica que $x in A, y in A$, o $x in B, y in B$.

- si $x, y in A$, como $d(x, y) < delta < delta_A$, tenemos que $d'(f(x), f(y)) < epsilon'$;

- si $x, y in B$, como $d(x, y) < delta < delta_B$, tenemos que $d'(f(x), f(y)) < epsilon'$.

Tomando $epsilon' < epsilon$ concluimos. #align(right)[#square()]
