#import "../utils.typ": recta, sublema

= Espacios métricos

_Ejercicio 1_: Determinar el interior, la clausura, los puntos aislados, los puntos de acumulación y la frontera de
$
A = {1/n + 1/m : n,m in NN}.
$

_Res_: Notemos que $A^compose subset.eq A$ y $A subset.eq overline(A)$.

- $A^compose = emptyset$: en efecto, dado $a in A$, $a = 1/n + 1/m$ para algún $n,m in NN$. Sea $r > 0$. Consideremos $B(a,r) = (a-r,a+r)$. Como existe $y in RR without QQ$ en $(a-r,a+r)$, y $A subset.eq QQ$, tenemos que $y in.not A$. Por lo tanto $B(a,r) subset.eq.not A$. Concluimos que $a in.not A^compose$.

- $overline(A) = A union {0} union {1/n : n in NN}$: probamos las dos contenciones.

  $supset.eq)$ Siempre $A subset.eq overline(A)$. Por otro lado, $1/n + 1/(n+1) in A$ para todo $n$, por lo tanto $a_n := 1/n + 1/(n+1) -> 0 in overline(A)$, así que $0 in overline(A)$. Por último, si fijamos $n in NN$, $a_m := 1/n + 1/m -> 1/n$ cuando $m -> +infinity$, por lo tanto $1/n in overline(A)$.

  $subset.eq)$ Sea $a in overline(A)$. Entonces existe $(a_k)_k subset.eq A$ tal que $a_k -> a$ cuando $k -> +infinity$. Dado $k$, $a_k in A$, por lo tanto existen $n_k, m_k in NN$ tales que $a_k = 1/n_k + 1/m_k$. Notemos que las sucesiones $(n_k)_k, (m_k)_k$ *no tienen por qué* tender a $+infinity$. Tenemos los siguientes casos:

  (1) $(n_k)_k, (m_k)_k$ están acotadas superiormente. Por el teorema de Bolzano-Weierstrass aplicado a $(n_k)_k$, existe $(n_(k_j))_j$ convergente. Como $(n_(k_j))_j subset.eq NN$, debe ser eventualmente constante, es decir, existen $j_0 in NN$ y $n in NN$ tales que $n_(k_j) = n$ para todo $j >= j_0$. Ahora aplicamos el teorema de Bolzano-Weierstrass a $(m_(k_j))_(j >= j_0)$ (la condición $j >= j_0$ es para que $(n_(k_j))_(j >= j_0)$ sea constantemente $n$). Existe $(m_(k_(j_l)))_l$ subsucesión convergente. Como $(m_(k_(j_l)))_l subset.eq NN$, debe ser eventualmente constante, y por lo tanto existen $l_0 in NN$ y $m in NN$ tales que $m_(k_(j_l)) = m$ para todo $l >= l_0$. Más aún, como $(n_(k_(j_l)))_l$ es subsucesión de $(n_(k_j))_(j >= j_0)$, resulta que $n_(k_(j_l)) = n$ para todo $l$. En conclusión,
  $
  a_(k_(j_l)) = 1/n_(k_(j_l)) + 1/m_(k_(j_l)) = 1/n + 1/m in A union {0} union {1/n : n in NN}.
  $

  (2) $(n_k)_k$ o $(m_k)_k$ no está acotada superiormente. Sin pérdida de generalidad, podemos suponer que $(n_k)_k$ no está acotada superiormente. Por el Ejercicio 13 de la Práctica 1, existe una subsucesión $(n_(k_j))_j$ con $n_(k_j) -> +infinity$ cuando $j -> +infinity$. Separamos en dos casos.

  - Si $(m_(k_j))_j$ está acotada superiormente, podemos razonar como en el caso (1) para hallar una subsucesión $(m_(k_(j_l)))_l$ convergente, y en consecuencia hay $m in NN$ y $l_0 in NN$ tales que $m_(k_(j_l)) = m$ para todo $l >= l_0$. Como $(n_(k_(j_l)))_l$ también tiende a $+infinity$ cuando $l -> +infinity$ por ser subsucesión de $(n_(k_j))_j$, tenemos que
  $
  a_(k_(j_l)) = 1/n_(k_(j_l)) + 1/m_(k_(j_l)) -> 1/m in A union {0} union {1/n : n in NN}.
  $

  - Si $(m_(k_j))_j$ no está acotada superiormente, de nuevo por el Ejercicio 13 de la Práctica 1, existe una subsucesión $(m_(k_(j_l)))_l$ tal que $m_(k_(j_l)) -> +infinity$. Por lo tanto
  $
  a_(k_(j_l)) = 1/n_(k_(j_l)) + 1/m_(k_(j_l)) -> 0 in A union {0} union {1/n : n in NN}.
  $

- $partial A = {0} union {1/n : n in NN}$: por el Ejercicio 9 de la Práctica 3, $partial A = overline(A) without A^compose = {0} union {1/n : n in NN}$.

- Puntos aislados: afirmamos que todos los puntos de $A$ son aislados. Dado $a in A$, buscamos $r > 0$ tal que $B(a,r) inter A = {a}$. Dado $b = 1/n' + 1/m' in A$, notemos que
$
abs(a - b) = abs(1/n + 1/m - 1/n' - 1/m') = abs((n'm m' + n m m' - n n' m' - n m n')/(n n' m m')).
$
Si $a != b$, el numerador es un entero no nulo, y por lo tanto su módulo es al menos $1$. Entonces
$
abs(a-b) >= 1/(n n' m m').
$
Por lo tanto, si tomamos $r < 1/(n n' m m')$, vemos que $B(a,r) inter A = {a}$.

- $A' = {0} union {1/n : n in NN}$. Esto es porque $overline(A) = A' union A$, y como $A$ consta de puntos aislados, $A' inter A = emptyset$; de $overline(A) = A union {0} union {1/n : n in NN}$ se sigue lo afirmado.

_Ejercicio 2_: Repetir el Ejercicio 1 para $A = {(x,y) in RR^2 : y > x}$.

_Res_: Gráficamente, $A$ es el semiplano estrictamente por encima de la recta $y = x$.

- $A^compose = A$: ya sabemos que $A^compose subset.eq A$. Veamos la otra contención. Sea $a = (a_1,a_2) in A$, es decir $a_2 > a_1$. Buscamos $r > 0$ de manera que $B(a,r) subset.eq A$. Como $d_2$ es equivalente a $d_infinity$, podemos trabajar con $d_infinity$, es decir,
$
B(a,r) = {(x,y) : d_infinity(a,(x,y)) = sup{abs(a_1-x), abs(a_2-y)} < r}.
$
Como $a_2 > a_1$, $a_2 - a_1 > 0$. Tomamos $r = delta(a_2-a_1)$, con $delta > 0$ a elegir. Sea $(x,y) in B(a,r)$, es decir $abs(x-a_1) < r$, $abs(y-a_2) < r$. Queremos ver que $y > x$, es decir $y - x > 0$. Pero
$
y - x = y - a_2 + a_2 - a_1 + a_1 - x > (a_2-a_1) - 2r = (a_2-a_1) - 2delta(a_2-a_1) = (1-2delta)(a_2-a_1).
$
Por lo tanto, si $1 - 2delta > 0$, es decir $delta < 1/2$, se tiene $y > x$. Entonces para $r = 1/2 (a_2-a_1)$ se tiene que $B(a,r) subset.eq A$.

- $overline(A) = {(x,y) in RR^2 : y >= x}$. Probamos la doble inclusión.

  $subset.eq)$ Sea $((x_m,y_m))_m subset.eq A$ tal que $(x_m,y_m) -> (x,y)$ cuando $m -> +infinity$. Vale que $x_m -> x$, $y_m -> y$: por ejemplo, para $d_infinity$ esto es porque dado $epsilon > 0$ existe $n_0 in NN$ tal que $d_infinity((x_m,y_m),(x,y)) < epsilon$ para todo $m >= n_0$. Pero entonces,
  $
  abs(x_m-x) <= sup{abs(x_m-x),abs(y_m-y)} = d_infinity((x_m,y_m),(x,y)) < epsilon, \
  abs(y_m-y) <= sup{abs(x_m-x),abs(y_m-y)} = d_infinity((x_m,y_m),(x,y)) < epsilon,
  $
  para todo $m >= n_0$. Como $(x_m,y_m) in A$ para todo $m$, resulta que $y_m > x_m$ para todo $m$. Por lo tanto
  $
  y = lim_(m->+infinity) y_m >= lim_(m->+infinity) x_m = x,
  $
  y por lo tanto $(x,y) in {(x,y) : y >= x}$.

  $supset.eq)$ Como $A subset.eq overline(A)$ basta ver que los $(x,y)$ con $x=y$ están en $overline(A)$. Consideramos $(x_m,y_m) := (x, x+1/m)$. Como $x + 1/m > x$, tenemos que $(x_m,y_m) in A$ para todo $m$. Además,
  $
  d_infinity((x,x+1/m),(x,x)) = sup{abs(x-x), abs(x+1/m-x)} = 1/m,
  $
  y como $1/m -> 0$, dado $epsilon > 0$ existe $n_0 in NN$ tal que para todo $n >= n_0$, $d_infinity((x_m,y_m),(x,x)) < epsilon$. Concluimos que $(x_m,y_m) -> (x,x)$, y por lo tanto $(x,x) in overline(A)$.

- $partial A = {(x,y) : y = x}$: por el Ejercicio 9 de la Práctica 3, $partial A = overline(A) without A^compose = {(x,y) : y = x}$.

- $A' = overline(A) = {(x,y) : y >= x}$: como $A' subset.eq overline(A)$, basta ver la otra contención. El argumento es el mismo que el usado en el cálculo de $overline(A)$. Dado $(x,y) in overline(A)$, sea $(x_m,y_m) := (x, y+1/m)$. Tenemos que $(x_m,y_m) in A$, pues $y_m = y+1/m >= x+1/m > x = x_m$ (usando $y>=x$). Como $(x_m,y_m) -> (x,y)$ y $(x_m,y_m) != (x,y)$ para todo $m$, se sigue que $(x,y) in A'$.

- Puntos aislados: como $A' = overline(A)$, se sigue que $A$ no tiene puntos aislados.

_Nota_: para calcular $A^compose$, podríamos haber probado que $RR^2 without A = {(x,y) : y <= x}$ es cerrado, lo cual se razona igual que la prueba de $overline(A) = {(x,y) : y >= x}$.

_Ejercicio 3_: Sea $A = {(x,y) in RR^2 : y = m x " para algún " m in ZZ}$. Calcular $overline(A)$.

_Res_: Notemos que $A = union_(m in ZZ) {(x,y) in RR^2 : y = m x}$, es decir, unión infinita de cerrados (gráficamente, son todas las rectas por el origen de pendiente entera; a medida que $abs(m)$ crece, estas rectas se van "pegando" al eje $y$).

Veamos que $overline(A) = A union {(0,y) : y != 0}$, donde excluimos $(0,0)$ de ${(0,y) : y != 0}$ porque ya está contenido en $A$.

$subset.eq)$ Sea $((x_n,y_n))_n subset.eq A$ tal que $(x_n,y_n) -> (x,y)$. Entonces $x_n -> x$, $y_n -> y$. Tenemos que para todo $n$ existe $m_n in ZZ$ tal que $y_n = m_n x_n$.

Supongamos que $x_n -> x != 0$. Por el ejercicio sobre sucesiones a valores enteros, existe $n_0 in NN$ tal que para todo $n >= n_0$, $x_n != 0$. Entonces tiene sentido $m_n = y_n/x_n$ para todo $n >= n_0$, y $(m_n)_(n>=n_0)$ es una sucesión convergente de enteros (converge a $y/x$ por álgebra de límites), por lo tanto existen $n_1 in NN$, $m_0 in ZZ$ tales que $m_n = m_0$ para todo $n >= n_1$. Pero entonces $y_n = m_n x_n = m_0 x_n$ para todo $n >= max{n_0,n_1}$, lo que implica que
$
y = lim_(n->+infinity) y_n = lim_(n->+infinity) m_0 x_n = m_0 dot x,
$
es decir, $(x,y) in A$.

Supongamos ahora que $x_n -> 0$. Entonces $(x_n,y_n) -> (0,y)$, de donde concluimos que $(x,y) = (0,y) in A union {(0,y) : y != 0}$.

$supset.eq)$ Sólo hay que verificar que los puntos $(0,y)$, $y != 0$, son elementos de $overline(A)$. Para ver eso, consideramos $(x_m,y_m) := (y/m, y)$. Tenemos que $(x_m,y_m) in A$, pues $y = m dot (y/m)$. Como $(y/m,y) -> (0,y)$ cuando $m -> +infinity$, concluimos que $(0,y) in overline(A)$. #align(right)[#square()]

_Ejercicio 4_: Sea $E = {f : [0,1] -> RR : f "es acotada"}$ con la métrica $d_infinity$. Sea $A = {f : [0,1] -> RR : f "es inyectiva"}$. ¿Es $A$ abierto? ¿Y cerrado?

_Res_: Sea $f(x) = x$. Dado $epsilon > 0$, definimos
$
tilde(f)(x) = cases(
  0 & " si " x in [0,epsilon/2],
  x & " si " x in.not [0,epsilon/2].
)
$
Es claro que $tilde(f)$ no es inyectiva y es acotada. Además,
$
abs(f(x)-tilde(f)(x)) = cases(
  abs(0-x) = abs(x) = epsilon/2 < epsilon & " si " x in [0,epsilon/2],
  abs(x-x) = 0 < epsilon & " si " x in.not [0,epsilon/2],
)
$
es decir, $d_infinity(f,tilde(f)) <= epsilon/2 < epsilon$. Entonces $tilde(f) in B(f,epsilon)$. En consecuencia $f in.not A^compose$, y por lo tanto $A$ no es abierto.

$A$ no es cerrado: $f_n(x) = x/n$ cumple que $(f_n)_n subset.eq A$ para todo $n$ (es inyectiva, por ser lineal con pendiente no nula), pero $f_n -> 0$, porque
$
abs(f_n(x)) = abs(x/n) <= abs(x)/n <= 1/n med (x in [0,1]),
$
entonces $d_infinity(f_n,0) <= 1/n$ y por lo tanto $d_infinity(f_n,0) -> 0$. Como la función nula no es inyectiva, $0 in.not A$, así que $A$ no es cerrado. #align(right)[#square()]

_Nota_: el manuscrito numera dos ejercicios distintos como "4)"; para evitar ambigüedad, llamamos al siguiente _Ejercicio 4 (bis)_.

_Ejercicio 4 (bis)_: Recordamos que dados $A subset.eq RR^m$, $B subset.eq RR^m$, $A+B = {a+b : a in A, b in B}$.

a) Probar que si $A$ es abierto, $A+B$ es abierto.

b) Probar que si $A$ es cerrado y $B = {b}$, entonces $A+B$ es cerrado.

c) Probar que si $A$ es denso y $B = B(0,epsilon)$ con $epsilon > 0$, entonces $A+B = RR^m$.

_Nota_: $A$ es denso (en $RR^m$) si $overline(A) = RR^m$.

_Dem_:

a) Sea $x in A+B$. Entonces $x = a+b$, con $a in A$, $b in B$. Como $A$ es abierto, existe $r > 0$ tal que $B(a,r) subset.eq A$. Si consideramos $B(x,r)$, veamos que $y in B(x,r)$ implica que $y in A+B$. Tenemos que si $y in B(x,r)$ entonces $d(x,y) < r$ y
$
d(x,y) = norm(x-y) = norm(a+b-y) = norm(a-(y-b)) < r.
$
Entonces $y - b in B(a,r) subset.eq A$. Como $y = (y-b)+b in A+B$, concluimos que $B(x,r) subset.eq A+B$.

b) Queremos ver que $overline(A+B) = A+B$. Basta probar que $overline(A+B) subset.eq A+B$. Sea $(x_m)_m subset.eq A+B$ tal que $x_m -> x$. Tenemos que $x_m = a_m + b$, con $(a_m)_m subset.eq A$. Resulta que
$
norm(x_m-x) = norm(a_m+b-x) = norm(a_m-(x-b)) -> 0 " cuando " m -> +infinity,
$
por lo tanto $a_m -> x-b$. Como $A$ es cerrado, tenemos que $x-b in A$. Concluimos que $x = (x-b)+b in A+B$.

c) Sea $x in RR^m$. Como $A$ es denso, existe $y in A$ tal que $norm(x-y) < epsilon$. Pero entonces
$
norm(x-y) = norm((x-y)-0) < epsilon.
$
Entonces $x-y in B(0,epsilon)$. Como $x = y + (x-y) in A+B$, concluimos. #align(right)[#square()]

_Ejercicio 5_: Sea $(E,d)$ un espacio métrico. Probar que $A subset.eq E$ es abierto si y sólo si para toda $(x_n)_n subset.eq A$ con $x_n -> a$ cuando $n -> +infinity$, $a in A$, existe $n_0 in NN$ tal que $x_n in A$ para todo $n >= n_0$.

_Dem_:

$=>)$ Sea $(x_n)_n subset.eq A$ cumpliendo las condiciones indicadas. Como $A$ es abierto, existe $r > 0$ tal que $B(a,r) subset.eq A$. Como $x_n -> a$, tomando $epsilon = r$ sabemos que existe $n_0 in NN$ tal que $d(x_n,a) < r$ para todo $n >= n_0$. Por lo tanto $x_n in B(a,r) subset.eq A$ para todo $n >= n_0$.

$arrow.l.double)$ Supongamos que $A$ no es abierto. Entonces existe $a in A$ tal que para todo $r > 0$, $B(a,r) subset.eq.not A$. Esto significa que dado $n in NN$, si $r = 1/n$, existe $x_n in B(a,r) without A$. Tenemos que $d(x_n,a) < 1/n$ para todo $n in NN$.

Tenemos que $lim_(n->+infinity) x_n = a$. En efecto, esto es porque dado $epsilon > 0$ existe $n in NN$ tal que $1/n < epsilon$. Pero para *todo* $n$, $x_n in.not A$, por lo tanto no existe $n_0 in NN$ para el cual $n >= n_0$ implique que $x_n in A$. Esto contradice la hipótesis. #align(right)[#square()]

_Ejercicio 6_: Sea $(E,d)$ un espacio métrico, y sea $U subset.eq E$ un subconjunto. Probar que $U$ es abierto si y sólo si para todo $T subset.eq E$ vale que $U inter overline(T) subset.eq overline(U inter T)$.

_Dem_:

$=>)$ Sea $T subset.eq E$. Queremos ver que $U inter overline(T) subset.eq overline(U inter T)$. Sea $x in U inter overline(T)$. Queremos ver que $x in overline(U inter T)$, es decir, que para todo abierto $V subset.eq E$ con $x in V$, vale que $V inter U inter T != emptyset$. Como $x in U$, $x in V inter U$ y $V inter U$ es abierto. Como $x in overline(T)$, $(V inter U) inter T != emptyset$, como queríamos ver.

$arrow.l.double)$ Sea $T = E without U$. Debe valer que $U inter overline(E without U) subset.eq overline(U inter (E without U)) = overline(emptyset) = emptyset$, es decir $overline(E without U) inter U = emptyset$. Pero entonces $overline(E without U) = E without U$, pues
$
overline(E without U) = (overline(E without U) inter U) union (overline(E without U) inter (E without U)) = overline(E without U) inter (E without U) subset.eq E without U.
$
Concluimos que $E without U$ es cerrado, y por lo tanto $U$ es abierto. #align(right)[#square()]

_Ejercicio 7_: Sea $(E,d)$ un espacio métrico. Tenemos que $F subset.eq E$ es la frontera de un abierto si y sólo si $F$ es cerrado y tiene interior vacío.

_Dem_:

$=>)$ Si $F = partial U$ con $U$ abierto, por el Ejercicio 9 de la Práctica 3, $F = overline(U) inter overline(E without U)$ es intersección de cerrados, por lo tanto es cerrado. Notemos que si $x in U$, existe $r > 0$ tal que $B(x,r) subset.eq U$. Por lo tanto $B(x,r) inter (E without U) = emptyset$, y en consecuencia $x in.not partial U = F$. Con esto en mente, veamos que $F^compose = emptyset$. Sea $x in F = overline(U) inter overline(E without U)$. Dado $r > 0$, $B(x,r) inter U != emptyset$. Como $x in.not U$, concluimos que existe $y != x$, $y in B(x,r) inter U$. Pero $y in U$, y por lo tanto $y in.not F$.

$arrow.l.double)$ Veamos que, tomando $U = E without F$, vale $partial U = F$. Tenemos que
$
partial U = overline(U) inter overline(E without U) = overline(E without F) inter overline(F) = overline(E without F) inter F subset.eq F,
$
donde usamos que $F = overline(F)$ por ser $F$ cerrado. Para ver la otra contención, sea $x in F$. Como $F^compose = emptyset$, para todo $r > 0$, $B(x,r) inter (E without F) != emptyset$. Por lo tanto $x in overline(E without F)$. Como $x in F subset.eq overline(F)$, concluimos que $x in overline(F) inter overline(E without F) = partial U$. #align(right)[#square()]

_Ejercicio 8_: Sea $E$ un conjunto no vacío. Dos métricas $d, d'$ son *equivalentes* si y sólo si $(x_n)_n subset.eq E$ converge para $d$ si y sólo si converge para $d'$.

_Recordamos_: $d$ y $tilde(d)$ son equivalentes si y sólo si para todo $x in E$ y todo $r > 0$, existen $r', r'' > 0$ tales que $B_d(x,r') subset.eq B_tilde(d)(x,r)$ y $B_tilde(d)(x,r'') subset.eq B_d(x,r)$.

_Dem_: Supongamos que $(x_n)_n$ converge con respecto a $d$. Entonces existe $x in E$ tal que $x_n -> x$. Dado $epsilon > 0$, queremos ver que existe $n_0 in NN$ tal que para todo $n >= n_0$, $tilde(d)(x_n,x) < epsilon$, esto es, que $(x_n)_(n>=n_0) subset.eq B_tilde(d)(x,epsilon)$. Como $d$ y $tilde(d)$ son equivalentes, existe $r' > 0$ tal que $B_d(x,r') subset.eq B_tilde(d)(x,epsilon)$. Como $(x_n)_n$ converge respecto de $d$, existe $ñ in NN$ tal que para todo $n >= ñ$, $d(x_n,x) < r'$, esto es, que $(x_n)_(n>=ñ) subset.eq B_d(x,r')$. Tomando $n_0 >= ñ$, resulta que
$
(x_n)_(n>=n_0) subset.eq B_d(x,r') subset.eq B_tilde(d)(x,epsilon).
$

El argumento para ver que $(x_n)_n$ converge con respecto de $d'$ implica que $(x_n)_n$ converge con respecto a $d$ es análogo. Concluimos. #align(right)[#square()]
