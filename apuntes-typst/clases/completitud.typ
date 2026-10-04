// Notas docentes 2025 · clase del 01/10/2025 (manuscrito "Análisis avanzado — Completitud").
// Clase 5 de la transcripción: sus ejercicios llevan el tag `C5-{k}` en `ejemplos/`.

= Completitud

_Ejercicio 1_: Probar que $X = {a in RR^NN : a "es acotada"}$ es completo con
$
d_infinity (a, b) = sup_(k in NN) abs(a_k - b_k).
$

_Dem_: Sea $(a_n)_n subset.eq X$ sucesión de Cauchy. Entonces
$
a_n = (a_(n 1), a_(n 2), a_(n 3), dots),
$
y se tiene que para todo $epsilon > 0$ existe $n_0 in NN$ tal que para todo $n, m >= n_0$,
$
d_infinity (a_n, a_m) < epsilon.
$
Entonces para todo $i$, $(a_(n i))_n$ cumple que para todo $n, m >= n_0$,
$
abs(a_(n i) - a_(m i)) <= sup_(k in NN) abs(a_(n k) - a_(m k)) = d_infinity (a_n, a_m) < epsilon. quad (*)
$
Es decir, $(a_(n i))_n$ es de Cauchy en $RR$. Como $RR$ es completo, existe $tilde(a)_i in RR$ tal que $lim_(n -> +infinity) a_(n i) = tilde(a)_i$. Sea $tilde(a) = (tilde(a)_k)_k$ la sucesión cuya coordenada $k$-ésima es el límite $lim_(n -> +infinity) a_(n k)$. Veamos que $tilde(a) in X$, es decir, que existe $tilde(M) > 0$ tal que para todo $k in NN$ se tiene que
$
abs(tilde(a)_k) <= tilde(M).
$
Esto se sigue del hecho de que $(a_n)_n$ es de Cauchy. Específicamente, usamos:

_Prop_: si $(a_n)_n subset.eq X$ es de Cauchy entonces existen $a in X$ y $M in RR_(> 0)$ tales que $(a_n)_n subset.eq B(a, M)$.

_Dem_: Como $(a_n)_n$ es de Cauchy, existe $n_0 in NN$ tal que para todo $n, m >= n_0$,
$
d(a_n, a_m) < 1.
$
Entonces, para todo $n >= n_0$,
$
d(a_1, a_n) <= d(a_1, a_(n_0)) + d(a_(n_0), a_n) < d(a_1, a_(n_0)) + 1.
$
Tomando $a = a_1$ y $M = d(a_1, a_(n_0)) + 1$ concluimos. #align(right)[#square()]

_Nota_: el manuscrito escribe "para todo $n$"; la cota anterior vale para $n >= n_0$, y para los finitos $n < n_0$ basta agrandar $M$ a $max{d(a_1, a_(n_0)) + 1, d(a_1, a_2), dots, d(a_1, a_(n_0 - 1))}$ (y sumarle $1$ para que la inclusión en la bola abierta sea estricta).

Volviendo al ejercicio, tenemos que $(a_n)_n subset.eq B(a_1, M)$ para algún $M > 0$. Es decir,
$
d_infinity (a_n, a_1) = sup_k abs(a_(n k) - a_(1 k)) <= M
$
para todo $n$. Entonces, para todo $n$ y $k$, se tiene que
$
abs(a_(n k)) <= abs(a_(n k) - a_(1 k)) + abs(a_(1 k)) <= sup_(k in NN) abs(a_(n k) - a_(1 k)) + underbrace(sup_(k in NN) abs(a_(1 k)), "acotado porque" a_1 in X) <= M + sup_(k in NN) abs(a_(1 k)) =: tilde(M).
$
Como $a_(n k) -> tilde(a)_k$, por álgebra de límites concluimos que para todo $k in NN$,
$
abs(tilde(a)_k) <= tilde(M),
$
y por lo tanto $tilde(a) = (tilde(a)_k)_k in X$.

Veamos que $lim_(n -> +infinity) a_n = tilde(a)$. O sea, veamos que dado $epsilon > 0$, existe $n_0 in NN$ tal que para todo $n >= n_0$ se tiene que
$
d_infinity (a_n, tilde(a)) = sup_(k in NN) abs(a_(n k) - tilde(a)_k) < epsilon.
$
Escribimos
$
a_n &= (a_(n 1), a_(n 2), a_(n 3), dots, a_(n i), dots), \
tilde(a) &= (tilde(a)_1, tilde(a)_2, tilde(a)_3, dots, tilde(a)_i, dots), quad (* *)
$
donde cada columna converge: $a_(n i) -> tilde(a)_i$ cuando $n -> +infinity$. Las cantidades $abs(a_(n k) - tilde(a)_k)$ se pueden acotar para $n$ grande, _dependiente de $k$_. Entonces necesitamos argumentar de manera que no tengamos que acotar infinitas coordenadas. Como $(a_n)_n$ es de Cauchy, para $epsilon'$ existe $n_0$ tal que para todo $n, m >= n_0$ vale $(*)$. Entonces
$
d_infinity (a_n, tilde(a)) <= underbrace(d_infinity (a_n, a_(n_0)), (1)) + underbrace(d_infinity (a_(n_0), tilde(a)), (2)).
$
$(1)$ es menor que $epsilon'$ por $(*)$.

$(2)$: por $(*)$,
$
abs(a_(n_0 k) - a_(n k)) <= sup_(k in NN) abs(a_(n_0 k) - a_(n k)) = d_infinity (a_(n_0), a_n) < epsilon'.
$
Como $a_(n k) -> tilde(a)_k$ cuando $n -> +infinity$ (ver el dibujo $(* *)$), por álgebra de límites,
$
abs(a_(n_0 k) - tilde(a)_k) <= epsilon' " para todo " k in NN.
$
Por lo tanto $(2)$ puede acotarse como
$
d_infinity (a_(n_0), tilde(a)) = sup_(k in NN) abs(a_(n_0 k) - tilde(a)_k) <= epsilon'.
$

Concluimos que para todo $n >= n_0$,
$
d_infinity (a_n, tilde(a)) < epsilon' + epsilon' = 2 epsilon'.
$
Como $epsilon'$ fue arbitrario, podríamos haberlo elegido como $epsilon' = epsilon \/ 2$, y en consecuencia
$
d_infinity (a_n, tilde(a)) < epsilon " para todo " n >= n_0.
$
#align(right)[#square()]

_Nota_: el manuscrito concluye "$d_infinity (a_n, tilde(a)) <= epsilon'$" y después "$<= epsilon \/ 2 < epsilon$"; la suma de $(1)$ y $(2)$ da en realidad $< 2 epsilon'$, que con $epsilon' = epsilon \/ 2$ es exactamente lo que hace falta.

_Ejercicio 2_: Sea $(E, d)$ un espacio métrico completo.

a) Probar que $A subset.eq E$ es completo si y sólo si $A$ es cerrado.

b) Si $E = (RR^2, d_2)$, decidir si $A = {(x, y) in RR^2 : exists n in NN "con" y = x^n}$ y $B = {(x, y) : x^2 + y^2 = 1}$ son completos con la métrica $d_2$.

_Res_:

a) $arrow.l.double)$ es el Ejercicio 15 de la Práctica 3.

$=>)$ Sea $a in overline(A)$. Entonces existe $(a_n)_n subset.eq A$ tal que $a_n -> a$. Entonces $(a_n)_n$ es de Cauchy en $E$, y por lo tanto también lo es en $A$. Como $A$ es completo, $(a_n)_n$ converge en $A$, es decir, $a in A$.

b) Notemos que $A$ tiene la siguiente forma: es la unión de los gráficos de $y = x$, $y = x^2$, $y = x^3$, ...; todas las curvas pasan por $(0, 0)$ y por $(1, 1)$, y entre $0$ y $1$ se van "aplastando" contra el eje $x$ a medida que crece $n$.

Consideremos $(x_n, y_n) = (1/2, 1/2^n) in A$. Tenemos que $(x_n, y_n) -> (1/2, 0) in overline(A)$. Pero $(1/2, 0) in.not A$, pues para todo $n$, $0 != 1/2^n$. Entonces $A$ _no es cerrado_, y por lo tanto _no es completo_.

Para $B = {(x, y) : x^2 + y^2 = 1}$, veamos que es cerrado, o sea, $B = overline(B)$. Basta ver que $overline(B) subset.eq B$. Sea $((x_n, y_n))_n subset.eq B$ tal que $(x_n, y_n) -> (x, y)$. Por lo tanto $x_n -> x$, $y_n -> y$. Como $(x_n, y_n) in B$,
$
x_n^2 + y_n^2 = 1.
$
Pero tomando límite y usando álgebra de límites, $x^2 + y^2 = 1$, es decir, $(x, y) in B$. Concluimos que $B$ es cerrado. Como $(RR^2, d_2)$ es completo, $B$ es completo. #align(right)[#square()]

_Ejercicio 3_: Consideremos la función $d : RR times RR -> RR$ definida por
$
d(x, y) = cases(
  0 & " si " x = y,
  abs(x) + abs(y) & " si " x != y.
)
$

a) Probar que $d$ es una métrica en $RR$.

b) Probar que $(RR, d)$ es completo.

c) ¿La métrica $d$ es equivalente a la métrica usual de $RR$?

_Res_:

a) Como $abs(x) + abs(y) = 0$ si y sólo si $x = y = 0$, para ver que $d$ es una métrica sólo hay que verificar que vale la desigualdad triangular. Sean $x, y, z in RR$. Si $x = y = z$ la desigualdad es inmediata. Si $x = y$,
$
d(x, y) = 0 <= d(x, z) + d(z, y)
$
es inmediato. Si $x != y$ pero $x = z$,
$
d(x, y) = abs(x) + abs(y) <= d(x, z) + d(z, y) = 0 + d(x, y).
$
Similarmente se ve que la desigualdad vale si $x != y$ pero $y = z$. Si $x, y, z$ son distintos dos a dos,
$
d(x, y) = abs(x) + abs(y) <= d(x, z) + d(z, y) = abs(x) + abs(z) + abs(z) + abs(y)
$
es verdadero. Concluimos que $d$ es una métrica.

b) Sea $(a_n)_n subset.eq RR$ sucesión de Cauchy. Dado $epsilon > 0$, existe $n_0 in NN$ tal que para todo $n, m >= n_0$,
$
d(a_n, a_m) < epsilon. quad (*)
$
En particular, si $a_n != a_m$ y $n, m >= n_0$,
$
d(a_n, a_m) = abs(a_n) + abs(a_m) < epsilon.
$
Separamos en dos casos:

- ${a_n : n in NN}$ es infinito. Esto significa que hay una subsucesión $(a_(n_k))_k$ con la propiedad de que $a_(n_k) != a_(n_(k'))$ si $k != k'$. Entonces $(a_(n_k))_k$ es de Cauchy, porque es subsucesión de una sucesión de Cauchy. Por lo tanto dado $epsilon > 0$, existe $k_0 in NN$ tal que si $k, k' >= k_0$,
  $
  d(a_(n_k), a_(n_(k'))) = abs(a_(n_k)) + abs(a_(n_(k'))) < epsilon.
  $
  Pero entonces $abs(a_(n_k)) < epsilon$ para todo $k >= k_0$. Concluimos que $a_(n_k) -> 0$. Pero como $(a_n)_n$ es de Cauchy, el tener una subsucesión convergente a $0$ implica que $a_n -> 0$.

- ${a_n : n in NN}$ es finito. Si los finitos valores que toma $a_n$ son $a_(n_1), a_(n_2), dots, a_(n_k)$, tenemos que
  $
  NN = union.big_(i = 1)^k {n in NN : a_n = a_(n_i)}.
  $
  Como $NN$ es infinito, para algún $i$, ${n in NN : a_n = a_(n_i)}$ es infinito. Por lo tanto existe una subsucesión $(a_(n_k))_k$ tal que $a_(n_k) = a_(n_i)$ para todo $k$. Pero entonces $a_(n_k) -> a_(n_i)$ (porque $(a_(n_k))_k$ es constante) y como $(a_n)_n$ es de Cauchy, se sigue que $a_n -> a_(n_i)$.

En cualquier caso, se sigue que $(a_n)_n$ es convergente.

c) Por el ítem b), las únicas sucesiones convergentes convergen a $0$ o son eventualmente constantes. Esto sugiere que lejos del $0$, $(RR, d)$ es "distinto" a $(RR, abs(dot.c))$. Por ejemplo, si $x != 1$,
$
d(x, 1) = abs(x) + 1 > 1.
$
Entonces $B(1, 1) = {1}$ es abierto en $(RR, d)$, pero no es abierto en $(RR, abs(dot.c))$. Entonces las métricas _no son equivalentes_. #align(right)[#square()]

_Ejercicio 4_: Sea $(E, d)$ un espacio métrico y $F$ cerrado. Probar que
$
F = inter.big_(n in NN) {x in E : d(x, F) < 1/n}.
$

_Nota_: el manuscrito escribe $x in X$ (el espacio se llama $E$) y, a continuación de la igualdad, "es cerrado"; la resolución prueba la igualdad, que expresa al cerrado $F$ como intersección numerable de los abiertos ${x : d(x, F) < 1\/n}$ (abiertos por el Ejercicio 10 (d) de la Práctica 3).

_Res_: Recordemos que $d(x, F) = inf{d(x, y) : y in F}$. Por lo tanto, si $x in F$, $d(x, F) = 0$ pues $d(x, x) = 0$. Esto prueba que
$
F subset.eq inter.big_(n in NN) {x in E : d(x, F) < 1/n}.
$
Para la otra contención, sea $x in E$ tal que $d(x, F) < 1/n$ para todo $n$. Entonces, para todo $n in NN$ existe $y_n in F$ tal que
$
d(x, y_n) < 1/n.
$
Entonces $y_n -> x$ cuando $n -> +infinity$. Como $F$ es cerrado y $(y_n)_n subset.eq F$, resulta que $x in F$. #align(right)[#square()]

_Ejercicio 5_: Sea $(E, d)$ un espacio métrico. Supongamos que para _toda_ sucesión $(A_n)_n$ de subconjuntos cerrados, acotados y no vacíos de $E$ tales que

- $A_(n+1) subset.eq A_n$ para todo $n >= 1$;
- $lim_(n -> +infinity) op("diam")(A_n) = 0$;

se tiene que $inter.big_(n in NN) A_n != emptyset$. Probar que $E$ es completo.

_Res_: Sea $(a_n)_n subset.eq E$ sucesión de Cauchy, o sea, dado $epsilon > 0$, existe $n_0 in NN$ tal que si $n, m >= n_0$,
$
d(a_n, a_m) < epsilon.
$

- Si $epsilon = 1$, sea $n_1 in NN$ tal que para todo $n, m >= n_1$,
  $
  d(a_n, a_m) < 1.
  $
  Sea
  $
  A_1 = overline({a_n : n >= n_1}).
  $
  Tenemos que
  - $A_1$ es cerrado y no vacío por definición;
  - dados $a_n, a_m in {a_n : n >= n_1}$, es $n, m >= n_1$, por lo tanto $d(a_n, a_m) < 1$. Entonces
    $
    op("diam") {a_n : n >= n_1} <= 1,
    $
    y por el Ejercicio 7 de la Práctica 3, $op("diam")(A_1) <= 1$.

- Si $epsilon = 1/2$, sea $n_2 in NN$, $n_2 >= n_1$, tal que para todo $n, m >= n_2$,
  $
  d(a_n, a_m) < 1/2.
  $
  Sea
  $
  A_2 = overline({a_n : n >= n_2}).
  $
  Como con $A_1$ se puede ver que $A_2$ es cerrado, no vacío, y $op("diam")(A_2) <= 1/2$. Además,
  $
  {a_n : n >= n_2} subset.eq {a_n : n >= n_1}
  $
  porque $n_2 >= n_1$. Entonces
  $
  A_2 = overline({a_n : n >= n_2}) subset.eq overline({a_n : n >= n_1}) = A_1.
  $

- En general, sea $k in NN$, $n_k in NN$, y $A_k := overline({a_n : n >= n_k})$. Existe $n_(k+1) in NN$, $n_(k+1) >= n_k$, tal que para todo $n, m >= n_(k+1)$,
  $
  d(a_n, a_m) < 1/(k+1).
  $
  Sea
  $
  A_(k+1) := overline({a_n : n >= n_(k+1)}).
  $
  Se tiene que $A_(k+1)$ es cerrado, no vacío, y $op("diam")(A_(k+1)) <= 1/(k+1)$. Como
  $
  {a_n : n >= n_(k+1)} subset.eq {a_n : n >= n_k}
  $
  porque $n_(k+1) >= n_k$, y tomando clausura, $A_(k+1) subset.eq A_k$. Por inducción concluimos que $(n_k)_k$ y $(A_k)_k$ cumplen para todo $k in NN$:
  - $(n_k)_k$ es creciente;
  - $A_k$ es cerrado, no vacío, $op("diam")(A_k) <= 1/k$;
  - $A_(k+1) subset.eq A_k$.

Entonces $op("diam")(A_k) -> 0$, y por hipótesis, $inter.big_(k in NN) A_k != emptyset$. Sea $a in inter.big_(k in NN) A_k$. Veamos que $a_n -> a$. Supongamos que no. Entonces existe $epsilon > 0$ y $(a_(n_j))_j$ subsucesión tal que
$
d(a_(n_j), a) >= epsilon.
$
Sea $k in NN$ tal que $2/k < epsilon$. Tenemos que $a in A_k$, por lo tanto existe $a_m in B(a, 1/k) inter {a_n : n >= n_k}$, o sea, $m >= n_k$ y $d(a, a_m) < 1/k$. Como $n_j -> +infinity$, sea $j_0 in NN$ tal que $n_(j_0) >= n_k$. Entonces
$
epsilon <= d(a_(n_(j_0)), a) <= underbrace(d(a_(n_(j_0)), a_m), <= op("diam")(A_k) <= 1/k "porque" a_m\, a_(n_(j_0)) in A_k) + underbrace(d(a_m, a), < 1/k "porque" a_m in B(a, 1/k)) < 1/k + 1/k = 2/k.
$
Como $2/k < epsilon$, llegamos a un absurdo. Concluimos que $a_n -> a$. #align(right)[#square()]

_Ejercicio 6_: Probar que $(E, d)$ es completo si y sólo si toda bola cerrada es completa.

_Res_: $=>)$ es por el Ejercicio 15 de la Práctica 3.

$arrow.l.double)$ Sea $(a_n)_n subset.eq E$ de Cauchy. Entonces $(a_n)_n$ es acotada: existe $M > 0$ tal que $(a_n)_n subset.eq overline(B)(a_1, M)$, con
$
overline(B)(a_1, M) = {x in E : d(x, a_1) <= M}.
$
Por hipótesis, este conjunto es completo, por lo tanto $(a_n)_n$ es convergente en $overline(B)(a_1, M)$, y en consecuencia, converge en $(E, d)$. #align(right)[#square()]
