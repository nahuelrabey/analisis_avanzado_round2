#import "../utils.typ": recta, sublema

= Cardinales y métricas

_Ejercicio 1_: Hallar el cardinal de
$
X = {(x,y,z) in RR^3 : x in QQ, y in RR without QQ, z in NN "es par"}.
$

_Res_: Tenemos que $X subset.eq RR^3$. Por lo tanto hay una función inyectiva $f: X -> RR^3$. Como $RR^3 ~ RR$ tenemos una $f: X -> RR$ inyectiva. Por otro lado, la función
$
g: RR without QQ -> X, med g(y) = (0,y,2)
$
es inyectiva. Como $RR ~ RR without QQ$, existe $g: RR -> X$ inyectiva. Por el teorema de Cantor-Bernstein, existe $F: X -> RR$ biyectiva. Concluimos que $\#X = \#RR = frak(c)$.

_Ejercicio 2_: Hallar el cardinal de

a) $NN^NN$.

b) $A = {(a_n)_n in NN^NN : a_n != a_m " si " n != m}$.

c) $A = {(a_n)_n in NN^NN : a_n divides a_(n+1) med forall n in NN}$.

Para hacer este ejercicio vamos a usar que hay una biyección entre $(A^B)^C$ y $A^(B times C)$. Notemos que un elemento de $(A^B)^C$ es una función $f: C -> A^B$, mientras que un elemento de $A^(B times C)$ es una función $g: B times C -> A$. Con esto en mente, definimos
$
Phi: (A^B)^C -> A^(B times C), \
Phi(f)(b,c) := (f(c))(b),
$
donde usamos que $f(c) in A^B$, o sea, es una función.

La función está bien definida. Podemos ver que es biyectiva viendo que es inyectiva y suryectiva, o hallando su inversa. Definimos
$
Psi: A^(B times C) -> (A^B)^C, \
[Psi(g)(c)](b) := g(b,c).
$

La función está bien definida, y además
$
Phi(Psi(g))(b,c) = [Psi(g)(c)](b) = g(b,c), " es decir " Phi compose Psi = "id"_(A^(B times C)), \
[Psi(Phi(f))(c)](b) = Phi(f)(b,c) = (f(c))(b), " es decir " Psi compose Phi = "id"_((A^B)^C).
$
Concluimos que $(A^B)^C ~ A^(B times C)$. Esta propiedad se conoce como *ley exponencial*.

_Res (del ejercicio)_:

a) Tenemos una función inyectiva $f: {0,1}^NN -> NN^NN$, $f((a_n)_n) = (a_n)_n$. Como ${0,1}^NN ~ RR$, tenemos una $f: RR -> NN^NN$ inyectiva. Notemos que si tratamos a los cardinales como números,
$
\#NN^NN = aleph_0^aleph_0 <= (2^aleph_0)^aleph_0 = 2^(aleph_0 times aleph_0) = 2^aleph_0.
$
Esto *no es (a priori) un argumento formal*, pero sugiere una estrategia. Tenemos una función inyectiva
$
g: NN^NN -> RR^NN
$
dada por la inclusión. Como $RR ~ {0,1}^NN$, tenemos que $RR^NN ~ ({0,1}^NN)^NN$. Por la ley exponencial, $({0,1}^NN)^NN ~ {0,1}^(NN times NN)$. Finalmente, ${0,1}^(NN times NN) ~ cal(P)(NN times NN) ~ cal(P)(NN)$ porque $NN times NN ~ NN$.

Concluimos que $RR^NN ~ cal(P)(NN) ~ RR$, y por lo tanto existe $p: NN^NN -> RR$ inyectiva. Por el teorema de Cantor-Bernstein, $NN^NN ~ RR$.

b) Por a), tenemos una función inyectiva $f: A -> RR$. Por otro lado, tenemos
$
g: {B subset.eq NN : \#B = infinity} subset.eq cal(P)(NN) -> A
$
definida como sigue. Dado $B subset.eq NN$ con $\#B = infinity$, definimos inductivamente $(g(B)_n)_n$:
$
g(B)_1 := min(B) " (bien definido por ser " B != emptyset " y el principio de buena ordenación)",
$
$
g(B)_2 := min(B without {g(B)_1}) " (bien definido porque " B != {g(B)_1} " al ser infinito)",
$
definido $g(B)_1, ..., g(B)_k$, $k in NN$, definimos
$
g(B)_(k+1) := min(B without {g(B)_i : i <= k}) " (bien definido porque " B != {g(B)_i : i <= k} " al ser infinito)".
$

Tenemos que $g$ está bien definida (por construcción, $g(B)_1 < g(B)_2 < ... < g(B)_k < ...$, por lo tanto $g(B)_i != g(B)_j$ si $i != j$) y es inyectiva, pues $g(B) = g(tilde(B))$ equivale a que
$
g(B)_n = g(tilde(B))_n " para todo " n.
$
Supongamos que $B != tilde(B)$. Sea $k = min{k in NN : k in B without tilde(B)}$. Por definición, $g(B)_k != g(tilde(B))_k$. Esto prueba que $g$ es inyectiva.

Como ${B subset.eq NN : \#B = infinity} ~ RR$ (por el ejercicio 11 de la guía 2, ${B subset.eq NN : \#B < infinity}$ es numerable, entonces $cal(P)(NN) = {B subset.eq NN : \#B < infinity} union.sq {B subset.eq NN : \#B = infinity}$ y al ser $cal(P)(NN) ~ RR$, por el ejercicio 3a), ${B subset.eq NN : \#B = infinity} ~ RR$), concluimos que existe $g: RR -> A$ inyectiva. Por el teorema de Cantor-Bernstein, $A ~ RR$.

c) Por a), tenemos que existe una función inyectiva $f: A -> RR$. Notemos que si $a_n divides a_(n+1)$ entonces existe $k_n in NN$ tal que $a_(n+1) = k_n a_n$. Entonces, $(a_n)_n in A$ tiene la forma
$
a_1, med a_2 = k_1 a_1, med a_3 = k_2 a_2 = k_2 k_1 a_1, med a_4 = k_3 k_2 k_1 a_1, ..., med a_(n+1) = k_n dots.h.c k_1 a_1.
$
Entonces, la sucesión queda determinada por $a_1$ y la sucesión $(k_n)_(n in NN) subset.eq NN$. Definimos
$
g: NN times NN^NN -> A, med g(a,(k_n)_n) = (a, k_1 a, k_2 k_1 a, ..., k_n k_(n-1) dots.h.c k_1 a, ...)
$
O sea,
$
a_m := (g(a,(k_n)_n))_m = a dot product_(i=1)^(m-1) k_i, " donde interpretamos " product_(i=1)^0 k_i = 1.
$

La función $g$ está bien definida, pues $a_(m+1) = a dot product_(i=1)^m k_i = a dot (product_(i=1)^(m-1) k_i) dot k_m = a_m dot k_m$.

Es inyectiva: si $(a_m)_m = (g(a,(k_n)_n))_m$, $(b_m)_m = (g(tilde(a),(tilde(k)_n)_n))_m$ cumplen $a_m = b_m$ para todo $m$,
- $a_1 = a = tilde(a) = b_1$, entonces $a = tilde(a)$,
- dado $n in NN$, $a_(n+1) = a_n dot k_n = b_n dot tilde(k)_n = b_(n+1)$. Como $a_n = b_n != 0$, concluimos que $k_n = tilde(k)_n$.

Tenemos $NN times NN^NN ~ NN times RR$ y $NN times RR ~ RR$ ya que
$
NN times RR = union.sq_(m in NN) {m} times RR,
$
y ${m} times RR ~ RR$, por lo tanto $NN times RR$ es unión contable de conjuntos de cardinal $frak(c)$, por lo tanto tiene cardinal $frak(c)$, y en consecuencia $NN times RR ~ RR$. Concluimos que existe $g: RR -> A$ inyectiva. Por el teorema de Cantor-Bernstein, $A ~ RR$.

_Obs_: la función $g: NN times NN^NN -> A$ es, de hecho, biyectiva.

_Ejercicio 3_: Hallar el cardinal de
$
A = {(a_n)_n subset.eq ZZ : abs(a_(n+1) - a_n) = 1 med forall n in NN}.
$

_Res_: Notemos que si $a_1 = 1$, $abs(a_2 - a_1) = 1$, y como $a_2 in ZZ$, $a_2 = 2$ o $0$. El esquema general es un "árbol":

#align(center)[
$
a_1=1 -> cases(
  a_2=2 -> cases(a_3=3 -> dots.v, a_3=1 -> dots.v),
  a_2=0 -> cases(a_3=1 -> dots.v, a_3=-1 -> dots.v),
)
$
]

En cada paso tenemos *dos posibilidades*: $a_(n+1) = a_n + 1$ o $a_(n+1) = a_n - 1$. Esto sugiere usar *sucesiones de $0$'s y $1$'s*. Definimos $f: {0,1}^NN -> A$, $a_n := f((b_k)_k)_n$ mediante
$
cases(
  a_1 = 1\,,
  a_(n+1) = a_n + 1 " si " b_n = 1\, med n in NN,
  a_(n+1) = a_n - 1 " si " b_n = 0\, med n in NN,
)
$
o de manera más compacta,
$
cases(
  a_1 = 1\,,
  a_(n+1) = a_n + (-1)^(b_n+1) " para todo " n in NN.
)
$
Por ejemplo, si $b_1 = 1, b_2 = 0, b_3 = 0, b_4 = 1, b_5 = 0, b_6 = 0, b_7 = 1, ...$
$
a_1=1, a_2=2, a_3=1, a_4=0, a_5=1, a_6=0, a_7=-1, a_8=0, ...
$

- $f$ está bien definida: $abs(a_(n+1) - a_n) = abs((-1)^(b_n+1)) = 1$;
- $f$ es inyectiva: si $a_n := f((b_k)_k)_n$, $tilde(a)_n = f((c_k)_k)_n$, y $a_n = tilde(a)_n$ para todo $n in NN$, entonces
$
a_(n+1) = a_n + (-1)^(b_n+1) = tilde(a)_n + (-1)^(c_n+1) = tilde(a)_(n+1) " para todo " n in NN.
$
Por lo tanto $(-1)^(b_n) = (-1)^(c_n)$. Como $b_n, c_n in {0,1}$, se sigue que $b_n = c_n$ para todo $n in NN$.

Por otra parte, $A subset.eq ZZ^NN$. Como $ZZ ~ NN$, resulta $ZZ^NN ~ NN^NN ~ {0,1}^NN$, por lo tanto existe $g: A -> {0,1}^NN$ inyectiva. Por el teorema de Cantor-Bernstein, $A ~ {0,1}^NN ~ RR$. #align(right)[#square()]

_Nota_: el manuscrito original dice $A subset.eq NN^NN$, pero como $A$ contiene sucesiones con enteros negativos y el cero (cf. el ejemplo con $a_4=0$, $a_7=-1$ más arriba), en rigor $A subset.eq ZZ^NN$; se agregó el paso $ZZ ~ NN$ para completar el argumento.

_Ejercicio 4_: Sea $cal(F)$ una familia de subconjuntos no vacíos de $RR$ tal que para cada $x in RR$ existe $epsilon_x > 0$ tal que
$
\#{F in cal(F) : F inter (x-epsilon_x, x+epsilon_x) != emptyset} <= aleph_0.
$
Probar que $cal(F)$ es contable.

_Dem_: Dado $q in QQ$, existe $epsilon_q > 0$ tal que
$
cal(F)_q = {F in cal(F) : F inter (q-epsilon_q, q+epsilon_q) != emptyset}
$
es contable. Afirmamos que $cal(F) = union_(q in QQ) cal(F)_q$. En efecto, la contención $supset.eq$ es clara.

Sea $F in cal(F)$. Entonces $F != emptyset$. Sea $x in F$.
- Si $x in QQ$, $F inter (x-epsilon_x, x+epsilon_x) != emptyset$, entonces $F in cal(F)_x subset.eq union_(q in QQ) cal(F)_q$.
- Si $x in.not QQ$, por la densidad de $QQ$ en $RR$ existe $q in QQ$ tal que $abs(x-q) < epsilon_q$. Sea $y in QQ$ como el $q$ hallado, entonces $x in (q-epsilon_q, q+epsilon_q) inter F$, es decir $F in cal(F)_q subset.eq union_(q in QQ) cal(F)_q$.

Concluimos que $cal(F) subset.eq union_(q in QQ) cal(F)_q$.

Como $QQ$ es contable y $cal(F)_q$ es contable para todo $q in QQ$, $cal(F) = union_(q in QQ) cal(F)_q$ es unión contable de contables, por lo tanto es contable. #align(right)[#square()]

_Ejercicio 5_: Sea $d: M times M -> RR$ una función tal que

a) $d(x,y) = 0 <=> x = y$;

b) $d(x,z) <= d(x,y) + d(z,y)$ para todo $x,y,z in M$.

Probar que $d$ es una métrica.

_Dem_: Sólo hay que verificar las propiedades:

c) si $x != y$ entonces $d(x,y) > 0$,

d) $d(x,y) = d(y,x)$. [Entonces $d(x,y) <= d(x,z) + d(y,z) = d(x,z) + d(z,y)$.]

Para d), tenemos que
$
d(x,y) <=^"b)" d(x,x) + d(y,x) = d(y,x).
$
De manera completamente análoga, $d(y,x) <= d(x,y)$. Por lo tanto $d(x,y) = d(y,x)$.

Para c), tenemos
$
0 =^"a)" d(x,x) <=^"b)" d(x,y) + d(y,x) = 2 d(x,y).
$

Por lo tanto $d(x,y) >= 0$. Si $x != y$, por a) concluimos que $d(x,y) != 0$ y en consecuencia $d(x,y) > 0$. #align(right)[#square()]

En conclusión, para ver que $d$ es una métrica sólo requerimos ver que cumple la desigualdad triangular y la propiedad a).

_Ejercicio 6_: Probar que en $RR^2$ la función $d: RR^2 times RR^2 -> RR$ dada por
$
d((x,y),(x',y')) = cases(
  abs(y-y') & " si " x = x'\,,
  abs(x-x') + abs(y) + abs(y') & " si " x != x'.
)
$
es una métrica.

_Dem_: Vemos que $d((x,y),(x',y')) = d((x',y'),(x,y))$. Veamos que $d$ es una métrica.

a) $d((x,y),(x',y')) = 0 <=> (x,y) = (x',y')$.

Si $(x,y) = (x',y')$, resulta que $x = x'$ implica
$
d((x,y),(x',y')) = abs(y-y') = 0.
$
Recíprocamente, si $d((x,y),(x',y')) = 0$, si $x != x'$,
$
d((x,y),(x',y')) = abs(x-x') + abs(y) + abs(y') >= abs(x-x') > 0.
$
Entonces $x = x'$. Pero en tal caso
$
0 = d((x,y),(x',y')) = abs(y-y') <=> y = y'.
$
Concluimos.

b) Separamos en casos. Queremos ver que $d((x,y),(x',y')) <= d((x,y),(x'',y'')) + d((x'',y''),(x',y'))$.

- Si $x = x' = x''$,
$
d((x,y),(x',y')) = abs(y-y') <= abs(y-y'') + abs(y''-y') = d((x,y),(x'',y'')) + d((x'',y''),(x',y')).
$

- Si $x = x' != x''$,
$
d((x,y),(x',y')) &= abs(y-y') <= abs(y-y'') + abs(y''-y') <= abs(y)+abs(y'') + abs(y'')+abs(y') \
&<= abs(x-x'') + abs(y)+abs(y'') + abs(x''-x') + abs(y'')+abs(y') \
&= d((x,y),(x'',y'')) + d((x'',y''),(x',y')). #h(1fr) square
$

_Obs_: los casos restantes (con $x != x'$) se prueban de forma análoga a los desarrollados arriba, separando según $x''$ coincida o no con $x$ o $x'$.

_Ejercicio 7_: Sea $X = {f: [0,1] -> RR "continuas tales que" f' "es continua en" [0,1]}$. Definimos
$
d: X times X -> RR, med d(f,g) = norm(f-g)_infinity + norm(f'-g')_infinity = sup_(x in [0,1]) abs(f(x)-g(x)) + sup_(x in [0,1]) abs(f'(x)-g'(x)).
$
Probar que $d$ es una métrica.

_Dem_: Notemos que $d$ tiene sentido, porque por el teorema de Weierstrass, $f$ y $f'$ son acotadas. Vemos que $d(f,g) = d(g,f)$. Veamos que $d$ es una métrica.

a) Es claro que $d(f,f) = 0$. Como
$
0 = d(f,g) = sup_(x in [0,1]) abs(f(x)-g(x)) + sup_(x in [0,1]) abs(f'(x)-g'(x)) >= sup_(x in [0,1]) abs(f(x)-g(x)) >= abs(f(x)-g(x)), med x in [0,1],
$
entonces $abs(f(x)-g(x)) = 0$, por lo tanto $f(x) = g(x)$ para todo $x in [0,1]$, es decir $f = g$.

b) Tenemos que si $f,g,h in X$,
$
abs(f(x)-g(x)) <= abs(f(x)-h(x)) + abs(h(x)-g(x)) <= sup_(x in [0,1]) abs(f(x)-h(x)) + sup_(x in [0,1]) abs(h(x)-g(x)).
$
Tomando supremo,
$
sup_(x in [0,1]) abs(f(x)-g(x)) <= sup_(x in [0,1]) abs(f(x)-h(x)) + sup_(x in [0,1]) abs(h(x)-g(x)). med (1)
$
Similarmente,
$
sup_(x in [0,1]) abs(f'(x)-g'(x)) <= sup_(x in [0,1]) abs(f'(x)-h'(x)) + sup_(x in [0,1]) abs(h'(x)-g'(x)). med (2)
$
Sumando (1) y (2):
$
d(f,g) &= sup_(x in [0,1]) abs(f(x)-g(x)) + sup_(x in [0,1]) abs(f'(x)-g'(x)) \
&<= sup_(x in [0,1]) abs(f(x)-h(x)) + sup_(x in [0,1]) abs(h(x)-g(x)) + sup_(x in [0,1]) abs(f'(x)-h'(x)) + sup_(x in [0,1]) abs(h'(x)-g'(x)) \
&= d(f,h) + d(h,g).
$
Concluimos que $d$ es una métrica. #align(right)[#square()]

_Ejercicio 8_: Sea $d: X times X -> RR$ una métrica en $X$. Probar que $d'(x,y) := min{1, d(x,y)}$ es una métrica en $X$.

_Dem_: Vemos que $d'(x,y) = d'(y,x)$. Veamos que $d'$ es una métrica.

a) Si $x = y$, $d'(x,x) = min{1, d(x,x)} = min{1,0} = 0$, donde usamos que $d(x,x)=0$ por ser $d$ métrica.

b) Queremos ver que
$
min{1,d(x,y)} <= min{1,d(x,z)} + min{1,d(z,y)}. med (star)
$
Separamos en dos casos:

- Si $d(x,y) >= 1$, por la desigualdad triangular $1 <= d(x,y) <= d(x,z) + d(z,y)$. Entonces alguna entre $d(x,z), d(z,y)$ es al menos $1$, digamos $d(x,z) >= 1$. Por lo tanto $d'(x,z) = min{1,d(x,z)} = 1$. En este caso $(star)$ queda
$
1 <= 1 + min{1,d(z,y)},
$
que es verdadero.

- Si $d(x,y) <= 1$, $(star)$ es igual a
$
d(x,y) <= min{1,d(x,z)} + min{1,d(z,y)}. med (star star)
$
Si alguno entre $d(x,z), d(z,y)$ es al menos $1$, digamos $d(x,z) >= 1$, entonces queda que $d'(x,z) = min{1,d(x,z)} >= 1 >= d(x,y)$. Por lo tanto
$
d(x,y) = min{1,d(x,y)} = d(x,y) <= 1 = min{1,d(x,z)} <= min{1,d(x,z)} + min{1,d(z,y)} <= d'(x,z) + d'(z,y).
$
Si en cambio $d(x,z) <= 1$, $d(z,y) <= 1$, $(star star)$ se convierte en
$
d(x,y) <= d(x,z) + d(z,y),
$
verdadera porque $d$ es una métrica. #align(right)[#square()]
