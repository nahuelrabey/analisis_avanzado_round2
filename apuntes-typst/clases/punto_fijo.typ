// Notas docentes 2025 · clase del 11/11/2025 (manuscrito "Análisis avanzado — Punto fijo").
// Clase 9 de la transcripción: sus ejercicios llevan el tag `C9-{k}` en `ejemplos/`.

= Punto fijo

_Ejercicio 1_: Sea $K$ compacto. Si $f : K -> K$ cumple que $d(f(x), f(y)) < d(x, y)$ para todo $x, y in K$, entonces $f$ posee un único punto fijo $a in K$.

_Res_: La idea es similar a la del teorema de punto fijo de Banach: considerar $x_n = f^n (x)$, ver que $x_n -> x_0 in K$, y $f(x_0) = x_0$. Esa demostración usa que $d(f(x), f(y)) < alpha d(x, y)$ con $0 <= alpha < 1$. ¿Cómo podemos usar que $alpha = 1$? Veamos que _existe $0 <= alpha < 1$ tal que $d(f(x), f(y)) < alpha d(x, y)$_. Si no existiera $alpha$ como se pide, para todo $n in NN$, existen $(x_n)_n, (y_n)_n$ en $K$ tales que
$
d(f(x_n), f(y_n)) >= (1 - 1/n) d(x_n, y_n). quad (1)
$
Como $K$ es compacto, existe $(x_(n_k))_k$ convergente en $K$. De nuevo usamos la compacidad para hallar $(y_(n_(k_j)))_j$ convergente en $K$. En particular, $(x_(n_(k_j)))_j$ converge en $K$. Supongamos que $x, y in K$ son tales que $x_(n_(k_j)) -> x$, $y_(n_(k_j)) -> y$. Como
$
d(f(x_(n_(k_j))), f(y_(n_(k_j)))) &<= d(f(x_(n_(k_j))), f(x)) + d(f(x), f(y)) + d(f(y), f(y_(n_(k_j)))) \
&< d(x_(n_(k_j)), x) + d(f(x), f(y)) + d(y, y_(n_(k_j))),
$
tomando límite concluimos que
$
lim_(j -> +infinity) d(f(x_(n_(k_j))), f(y_(n_(k_j)))) <= d(f(x), f(y)) < d(x, y). quad (2)
$
Por otro lado, de $(1)$ sale que
$
(1 - 1/n) d(x_n, y_n) <= d(f(x_n), f(y_n)) <= d(f(x), f(y)).
$
Como $lim_(n -> +infinity) (1 - 1/n) d(x_n, y_n) = d(x, y)$, queda
$
d(x, y) <= d(f(x), f(y)). quad (3)
$
Combinando $(2)$ y $(3)$:
$
d(x, y) <= d(f(x), f(y)) < d(x, y),
$
que es absurdo. Entonces existe $0 <= alpha < 1$ tal que $d(f(x), f(y)) < alpha d(x, y)$. Como $K$ es compacto, es completo, por lo tanto podemos usar el teorema de punto fijo de Banach para concluir que $f$ tiene un único punto fijo. #align(right)[#square()]

_Nota del manuscrito_: la prueba anterior se basó en probar que $F : K times K -> RR$, $F(x, y) = d(f(x), f(y)) - d(x, y)$ tiene un máximo negativo. Esto sale de que $K times K$ es compacto con $d_infinity$, y para esta métrica, $F$ es continua.

_Nota_: la hipótesis (y las desigualdades estrictas de la resolución) deben leerse para $x != y$. En $(2)$ el manuscrito escribe el lado izquierdo sin el límite, y en $(3)$ omite los índices de la subsucesión: la desigualdad $d(f(x_n), f(y_n)) <= d(f(x), f(y))$ sólo tiene sentido como límite a lo largo de $(n_(k_j))_j$. Más importante: el argumento tiene un hueco, porque nada garantiza que los límites $x$ e $y$ sean distintos, y si $x = y$ el paso "$d(f(x), f(y)) < d(x, y)$" de $(2)$ no vale (de hecho $F(x, x) = 0$, así que el máximo de $F$ nunca es negativo). La afirmación intermedia es falsa en general: $f(x) = x - x^2 \/ 2$ en $K = [0, 1]$ cumple $abs(f(x) - f(y)) = abs(x - y) (1 - (x + y) \/ 2) < abs(x - y)$ para $x != y$, pero el cociente tiende a $1$ cerca de $0$, así que no hay $alpha < 1$. El enunciado sí es cierto: la prueba usual (deducción mía, no está en la clase) minimiza la función continua $g(x) = d(x, f(x))$ en el compacto $K$; si el mínimo $x_0$ no fuera fijo, el punto $x_1 = f(x_0) != x_0$ cumpliría $g(x_1) = d(x_1, f(x_1)) = d(f(x_0), f(x_1)) < d(x_0, x_1) = g(x_0)$, absurdo. La unicidad sale directamente de la hipótesis.

_Ejercicio 2_: Sean $X$ e $Y$ espacios métricos y sea $f : X -> Y$ continua.

a) Supongamos que $(A_n)_n subset.eq X$ es una familia de compactos con $A_n supset.eq A_(n+1)$ para todo $n$. Probar que $f(inter.big_n A_n) = inter.big_n f(A_n)$.

b) Si $X = Y$ es compacto, probar que existe $K subset.eq X$ compacto no vacío tal que $f(K) = K$.

_Res_:

a) Siempre $f(inter.big_n A_n) subset.eq inter.big_n f(A_n)$. Veamos la otra contención. Supongamos que $A_n != emptyset$ para todo $n$; caso contrario, $f(inter.big_n A_n) = inter.big_n f(A_n) = emptyset$. Por el ejercicio 5 de la práctica 5, $inter.big_n A_n != emptyset$. Además, como $f$ es continua, $f(A_n)$ es compacto, y por lo tanto cerrado, para todo $n$, y verifica que $f(A_n) supset.eq f(A_(n+1))$. De nuevo por el ejercicio 5 de la práctica 5, $inter.big_n f(A_n) != emptyset$. Sea $y in inter.big_n f(A_n)$. Entonces, para todo $n$, existe $x_n in A_n$ tal que $y = f(x_n)$. Como $x_n in A_n subset.eq A_1$, tenemos que $(x_n)_n subset.eq A_1$. Como $A_1$ es compacto, existe $(x_(n_k))_k$ tal que $x_(n_k) -> x$, $x in A_1$. Si vemos que $x in A_n$ para todo $n$, resultaría que $y = f(x_(n_k)) -> f(x) = y$, por lo tanto $y in f(inter.big_n A_n)$. Dado que para todo $k$, $x_(n_k) in A_(n_k)$, tenemos que

- $x in A_1$, pues $x_(n_k) in A_(n_k) subset.eq A_1$ y entonces $(x_(n_k)) subset.eq A_1$ para todo $k$. Por lo tanto $x_(n_k) -> x in A_1$ ($A_1$ es cerrado).

- $x in A_2$, pues $x_(n_2) in A_(n_2) subset.eq A_2$ (usamos que $n_k >= k$ para todo $k$). Como $x_(n_k) in A_(n_k)$ para todo $k$, resulta que $x_(n_(k+1)) in A_(n_(k+1)) subset.eq A_(k+1) subset.eq A_2$ para todo $k in NN$. Dado que $x_(n_(k+1)) -> x$ y $A_2$ es cerrado, $x in A_2$.

- En general, $x_(n_(k+j)) in A_(n_(k+j)) subset.eq A_(k+j) subset.eq A_(j+1)$ para todo $k in NN$. Por lo tanto $x_(n_(k+j)) -> x$ cuando $k -> +infinity$. Como $A_(j+1)$ es cerrado, $x in A_(j+1)$.

Probamos que para todo $j in NN_0$, $x in A_(j+1)$. Concluimos que $x in inter.big_n A_n$. #align(right)[#square()]

b) Sea $A_n = f^n (X)$. Como $f$ es continua y $X$ compacto, para todo $n$, $A_n$ es compacto. Además, $f(X) subset.eq X$, por lo tanto para todo $n$,
$
A_(n+1) = f^(n+1) (X) = (f^n compose f)(X) subset.eq f^n (X) = A_n.
$
Por el ítem (a), $inter.big_n f(A_n) = f(inter.big_n A_n)$. Sea $K = inter.big_n f(A_n)$. Lo que probamos es que $inter.big_n f(A_n) = f(K)$. Por otro lado,
$
inter.big_n f(A_n) = inter.big_n (f compose f^n)(X) = inter.big_n f^(n+1) (X) = inter.big_(n = 2)^(+infinity) A_n limits(=)^((*)) inter.big_(n = 1)^(+infinity) A_n = K,
$
donde $(*)$ es porque $inter.big_(n = 1)^(+infinity) A_n subset.eq inter.big_(n = 2)^(+infinity) A_n$ por definición, y $inter.big_(n = 2)^(+infinity) A_n subset.eq inter.big_(n = 1)^(+infinity) A_n = A_1 inter inter.big_(n = 2)^(+infinity) A_n$ ya que $A_n subset.eq A_1$ para todo $n$. Resta ver que $K$ es compacto. Los $A_n$ son cerrados no vacíos y $A_n supset.eq A_(n+1)$ para todo $n$. Por el ejercicio 5 de la práctica 5, $K != emptyset$. Además es compacto, porque es cerrado y está contenido en un compacto. Concluimos que $K$ cumple lo que pide el ejercicio. #align(right)[#square()]

_Nota_: con $K = inter.big_n f(A_n)$, la cadena anterior muestra $K = inter.big_n A_n$, y entonces el ítem (a) da $f(K) = f(inter.big_n A_n) = inter.big_n f(A_n) = K$, que es lo que se quería; el manuscrito deja implícito este último paso.

_Ejercicio 3_: Sea $cal(C)(RR, [0, 1]) = {f : RR -> [0, 1] : f "es continua"}$, con $d_infinity$. Probar que no existe un subconjunto denso numerable en $cal(C)(RR, [0, 1])$.

_Res_: La idea es usar la siguiente generalización del ejercicio 17 de la práctica 2:

Sea $(X, d)$ espacio métrico. Supongamos que existe $Y subset.eq X$ contable con $overline(Y) = X$. Si ${U_i}_(i in I)$ es una familia de abiertos tales que

I) $\# U_i >= 1$ para todo $i in I$,

II) $U_i inter U_j = emptyset$ si $i != j$,

entonces $I$ es contable.

_Nota_: en I) el manuscrito escribe "$\# U_i > 1$" (o "$>= 1$": la raya se confunde con el renglón); lo que se usa es que $U_i != emptyset$.

Construyamos una familia de abiertos ${U_i}_(i in I)$ de $cal(C)(RR, [0, 1])$ que cumpla I) y II). Por el ejercicio 11 de la práctica 4, dados dos cerrados $A, B subset.eq RR$, no vacíos y disjuntos, existe $f : RR -> [0, 1]$ tal que $f|_A = 0$ y $f|_B = 1$. Sea $S subset.eq NN$. Si $A = S$ y $B = NN - S$, sea $f_S : RR -> [0, 1]$ tal que $f_S|_S = 0$ y $f_S|_(NN - S) = 1$. Notemos que:

- Si $S, S' subset.eq NN$ y $S != S'$, entonces existe $x in S without S'$ o $x in S' without S$. Supongamos sin pérdida de generalidad que ocurre el primer caso. Entonces $f_S (x) = 0$ y $f_(S') (x) = 1$, por lo tanto
  $
  abs(f_S (x) - f_(S') (x)) = abs(1 - 0) = 1 <= norm(f_S - f_(S'))_infinity. quad (*)
  $

- Si $I = cal(P)(NN)$, resulta que $I$ no es contable, por lo tanto si $U_S = B(f_S, 1/2)$, la familia de abiertos ${U_S}_(S in I)$ es una _familia de abiertos no vacíos, disjuntos, no contable_.

Concluimos que $cal(C)(RR, [0, 1])$ no admite un subconjunto denso contable. #align(right)[#square()]

_Nota_: si $S = emptyset$ o $S = NN$, uno de los cerrados es vacío y el ejercicio 11 de la práctica 4 no aplica; en esos casos sirven las constantes $f_emptyset equiv 1$ y $f_NN equiv 0$, y $(*)$ sigue valiendo.

_Nota del manuscrito_: la misma idea del ejercicio anterior muestra que $overline(B)(0, 1)$ _no es compacta_. Si definimos $S_n = {n}$, $f_n = f_(S_n)$, entonces $(f_n)_n subset.eq overline(B)(0, 1)$ y no admite subsucesiones convergentes, pues si $(f_(n_k))_k$ es una subsucesión de $(f_n)_n$, por $(*)$, para $k != k'$,
$
norm(f_(n_k) - f_(n_(k')))_infinity = norm(f_(S_k) - f_(S_(k')))_infinity >= 1,
$
y entonces no podría ser de Cauchy, y por lo tanto tampoco convergente.

_Nota_: en la igualdad anterior debería decir $f_(S_(n_k))$ y $f_(S_(n_(k')))$ (es $f_(n_k) = f_(S_(n_k))$); la conclusión no cambia.

_Ejercicio 4_: Sea $(E, norm(dot.c))$ un espacio normado. Sea
$
S = {x in E : norm(x) = 1}.
$
Probar que $E$ es un espacio de Banach si y sólo si toda sucesión de Cauchy $(x_n)_(n >= 1) subset.eq S$ converge.

_Res_: La implicación $=>)$ es porque $S$ es cerrado, y por el ejercicio 15 de la práctica 3, es completo. Para la vuelta, sea $(x_n)_n subset.eq E$ de Cauchy. Si $x_n -> 0$, no hay nada que probar. Supongamos que $x_n arrow.r.not 0$. Tenemos que $(norm(x_n))_n$ es de Cauchy, porque
$
norm(x_n) <= norm(x_n - x_m) + norm(x_m),
$
entonces
$
norm(x_n) - norm(x_m) <= norm(x_n - x_m),
$
y por simetría,
$
norm(x_m) - norm(x_n) <= norm(x_n - x_m).
$
Entonces
$
abs(norm(x_n) - norm(x_m)) <= norm(x_n - x_m),
$
y el segundo término se puede hacer menor a $epsilon$ para todo $n, m$ suficientemente grandes, porque $(x_n)_n$ es de Cauchy. Por lo tanto $(norm(x_n))_n$ converge, porque $RR$ es completo, digamos $norm(x_n) -> L$. Además, $L != 0$; caso contrario, $norm(x_n) -> 0$ equivale a decir que $x_n -> 0$. Como $norm(x_n) >= 0$, $L > 0$. Entonces existen $n_0 in NN$ y $delta > 0$ tales que $norm(x_n) >= delta$ para todo $n >= n_0$. Por lo tanto, podemos _normalizar_ $(x_n)_n$. Para todo $n >= n_0$ definimos $y_n = x_n / norm(x_n)$. Se tiene que
$
norm(y_n - y_m) &= norm(x_n / norm(x_n) - x_m / norm(x_m)) = norm((norm(x_m) x_n - x_m norm(x_n)) / (norm(x_n) norm(x_m))) \
&<= 1 / (norm(x_n) norm(x_m)) [norm(norm(x_m) x_n - L x_n) + norm(L x_n - L x_m) + norm(L x_m - x_m norm(x_n))] \
&<= 1 / (norm(x_n) norm(x_m)) [abs(norm(x_m) - L) norm(x_n) + norm(x_n - x_m) L + abs(L - norm(x_n)) norm(x_m)].
$
Como $norm(x_n) -> L != 0$, el lado derecho tiende a $0$. Por lo tanto $(y_n)_(n >= n_0)$ es de Cauchy. Como $S$ es completo, $y_n -> y$ con $y in S$. Pero entonces $y_n = x_n / norm(x_n) -> y$ implica que $x_n$ converge a $L y$, ya que para todo $n >= n_0$,
$
norm(x_n - L y) &<= norm(x_n - x_n / norm(x_n) L) + norm(x_n / norm(x_n) L - L y) \
&= abs(1 - L / norm(x_n)) norm(x_n) + norm(x_n / norm(x_n) - y) L \
&= abs((norm(x_n) - L) / norm(x_n)) norm(x_n) + norm(y_n - y) L,
$
y el lado derecho tiende a $0$. Concluimos que $(x_n)_n$ es convergente. #align(right)[#square()]

_Nota_: el manuscrito escribe los factores escalares $abs(1 - L \/ norm(x_n))$ y $abs((norm(x_n) - L) \/ norm(x_n))$ con barras dobles; son valores absolutos en $RR$. "Como $S$ es completo" es la hipótesis de la vuelta: toda sucesión de Cauchy en $S$ converge (y el límite está en $S$ porque $S$ es cerrado).

_Ejercicio 5_: Sean $E, F$ espacios normados. Sea $T : E -> F$ una transformación lineal. Probar que $T$ es continua si y sólo si para toda sucesión $(x_n)_(n >= 1)$ en $E$ que tiende a $0$, $(T(x_n))_n$ es acotada.

_Res_: La implicación $=>)$ es consecuencia directa de la continuidad, pues $T(x_n) -> T(0) = 0$. Para la implicación $arrow.l.double)$, alcanza con ver que para todo $A subset.eq E$ acotado, $T(A)$ es acotado, porque por el ejercicio 8 de la práctica 6, esto equivale a que $T$ sea continua. Si _existiera $A subset.eq E$ acotado con $T(A)$ no acotado_, entonces para todo $n in NN$, existe $x_n in A$ tal que $norm(T(x_n)) >= n$. Por lo tanto $(T(x_n))_n$ no está acotada. Esto no finaliza la prueba, porque $x_n$ no tiene por qué tender a $0$. Si $x_n arrow.r.not 0$, existen $(x_(n_k))_k$ y $delta > 0$ tales que $norm(x_(n_k)) > delta$ para todo $k in NN$. Entonces, para todo $k in NN$, sea $y_k = x_(n_k) / (sqrt(n_k) norm(x_(n_k)))$. Tenemos que $norm(y_k) = 1 / sqrt(n_k) -> 0$, y
$
norm(T(y_k)) = norm(T(x_(n_k)) / (sqrt(n_k) norm(x_(n_k)))) >= n_k / (sqrt(n_k) norm(x_(n_k))) = sqrt(n_k) / norm(x_(n_k)).
$
Como $A$ está acotado, $A subset.eq B(0, R)$ para algún $R > 0$. Entonces $norm(x_n) <= R$, por lo tanto
$
norm(T(y_k)) >= sqrt(n_k) / R,
$
y concluimos que $(T(y_k))_k$ no está acotada, con $y_k -> 0$. #align(right)[#square()]

_Nota_: el caso $x_n -> 0$ queda cubierto por la hipótesis: entonces $(T(x_n))_n$ debería ser acotada, y no lo es. Por eso la resolución sólo trata el caso $x_n arrow.r.not 0$.
