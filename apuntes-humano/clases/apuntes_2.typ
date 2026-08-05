#import "../utils.typ": recta

= Sucesiones y cardinales

_Ejemplo 1_: Sea $(a_n)_(n in NN)$ la sucesión definida recursivamente como
$
cases(
  a_1 = sqrt(2),
  a_(n+1) = sqrt(2 + a_n) " para todo " n >= 1
)
$
Probar que $(a_n)_n$ es monótona y acotada superiormente por $2$. Determinar su límite.

_Demo_: Notemos que si supiéramos que $(a_n)_n$ convergiera a $L$, como
$
a_(n+1)^2 = 2 + a_n
$
resultaría
$
L^2 = lim_(n->+oo) a_(n+1)^2 = lim_(n->+oo) (2 + a_n) = 2 + L
$
es decir
$
L^2 - L - 2 = 0 <=> L = 2 " o " L = -1
$

Entonces $L = 2$ o $L = -1$. Problemas:
I) ¿Cómo vemos que $(a_n)_n$ converge?
II) ¿Cómo distinguimos entre los dos candidatos a límite?

I) Veamos que $(a_n)_n$ es creciente y acotada superiormente. Por lo tanto $(a_n)_n$ será convergente.

- _Creciente_: probamos por inducción. \
  Caso base: $n = 1$, $a_1 = sqrt(2) <= sqrt(2 + a_1) = sqrt(2 + sqrt(2))$ es verdadero, porque $sqrt(dot)$ es creciente y $2 < 2 + sqrt(2)$. \
  Caso inductivo: si $a_k <= a_(k+1)$ entonces $2 + a_k <= 2 + a_(k+1)$ y $a_(k+1) = sqrt(2 + a_k) <= sqrt(2 + a_(k+1))$ porque $sqrt(dot)$ es creciente. O sea $a_(k+1) <= a_(k+2)$.

- _Acotada superiormente_: veamos que $a_n <= 2$ para todo $n$. Probamos por inducción. \
  Caso base: $n = 1$, $a_1 = sqrt(2) <= 2$. \
  Caso inductivo: si $a_k <= 2$ entonces
  $
  a_(k+1) = sqrt(2 + a_k) <= sqrt(2 + 2) = 2
  $
  donde usamos que $sqrt(dot)$ es creciente y que $2 + a_k <= 2 + 2 = 4$.

II) $(a_n)_n$ es creciente y $a_1 > 0$. Entonces $a_n > 0$ para todo $n in NN$, y por lo tanto $L = lim_(n->+oo) a_n >= 0$.
Concluimos que $L = 2$. #align(right)[#square()]


_Ejemplo 2_: Sea $(a_n)_n$ una sucesión tal que $(a_(3k))_k, (a_(3k+1))_k, (a_(3k+2))_k$ convergen a un mismo número. Probar que $(a_n)_n$ es convergente.

_Demo_: Supongamos que $(a_(3k))_k, (a_(3k+1))_k, (a_(3k+2))_k$ convergen a $L$. Probemos que para todo $epsilon > 0$ existe $n_0$ tal que para todo $n >= n_0$,
$
abs(a_n - L) < epsilon
$

Damos dos pruebas:

(I) Dado $epsilon > 0$,
- existe $k_0 in NN$ tal que para todo $k >= k_0$, $abs(a_(3k) - L) < epsilon$,
- existe $k_1 in NN$ tal que para todo $k >= k_1$, $abs(a_(3k+1) - L) < epsilon$,
- existe $k_2 in NN$ tal que para todo $k >= k_2$, $abs(a_(3k+2) - L) < epsilon$.

Puesto que $NN = {3k : k in NN} union.sq {3k+1 : k in NN_0} union.sq {3k+2 : k in NN_0}$,
- si $n = 3k$, queremos $k >= k_0$, entonces $n >= 3 k_0$ hace que $k >= k_0$;
- si $n = 3k+1$, queremos $k >= k_1$, entonces $n >= 3 k_1 + 1$ hace que $k >= k_1$;
- si $n = 3k+2$, queremos $k >= k_2$, entonces $n >= 3 k_2 + 2$ hace que $k >= k_2$.

Tomando $n_0 >= max{3k_0, 3k_1+1, 3k_2+2}$ vemos que para todo $n >= n_0$, $abs(a_n - L) < epsilon$.

(II) Supongamos que no. Entonces existe $epsilon > 0$ y una subsucesión $(a_(n_k))_k$ tal que
$
abs(a_(n_k) - L) >= epsilon
$

[_Dem_: Si $(a_n)_n$ no converge a $L$, entonces existe $epsilon > 0$ tal que para todo $n in NN$ existe $n_0 >= n$ tal que $abs(a_(n_0) - L) >= epsilon$.
- Si $n = 1$, existe $n_1 >= 1$ tal que $abs(a_(n_1) - L) >= epsilon$.
- Si $n = n_1 + 1$, existe $n_2 >= n_1 + 1$ tal que $abs(a_(n_2) - L) >= epsilon$.
- Recursivamente, habiendo elegido $n_1 < n_2 < ... < n_k$ tales que $abs(a_(n_k) - L) >= epsilon$, poniendo $n = n_k + 1$, vemos que existe $n_(k+1) > n_k + 1$ tal que $abs(a_(n_(k+1)) - L) >= epsilon$. \
Por construcción, $(a_(n_k))_k$ cumple lo pedido.]

Como $NN = {3k : k in NN} union.sq {3k+1 : k in NN_0} union.sq {3k+2 : k in NN_0}$, en alguno de los tres conjuntos hay infinitos $n_k$'s. Por lo tanto existe una subsucesión $(a_(n_(k_j)))_j$ tal que $n_(k_j) in {3k + a : k in NN}$ para algún $a in {0, 1, 2}$. Pero entonces $a_(n_(k_j)) -> L$. \
Por lo tanto, existe $j_0 in NN$ tal que para todo $j > j_0$,
$
abs(a_(n_(k_j)) - L) < epsilon
$
Pero por la hipótesis del absurdo, $epsilon <= abs(a_(n_(k_j)) - L) < epsilon$, absurdo. #align(right)[#square()]


_Ejemplo 3_: Sea $r in.not QQ$. Supongamos que $(a_n)_n, (b_n)_n subset.eq NN$ cumplen que $lim_(n->+oo) a_n / b_n = r$. Probar que $(a_n)_n$ y $(b_n)_n$ no están acotadas.

_Res_: Supongamos que $(a_n)_n$ está acotada. Por lo tanto existe $(a_(n_k))_k$ convergente. Como $(a_(n_k))_k subset.eq NN$, resulta que es eventualmente constante, es decir existe $a in NN$ y $k_0 in NN$ tal que
$
a_(n_k) = a " para todo " k > k_0
$

Entonces
$
a_(n_k) / b_(n_k) = a / b_(n_k) " para todo " k > k_0
$

Como $r in.not QQ$ y $a != 0$ (pues $a in NN$), resulta que $1/a (a / b_(n_k))^(-1) = b_(n_k) / a$ converge a $1/r$. Como $(b_(n_k))_k subset.eq NN$ es eventualmente constante, entonces existe $b in NN$ y $k_1 in NN$ tal que
$
b_(n_k) = b " para todo " k > k_1
$

Pero entonces $b/a = 1/r in QQ$, absurdo. Concluimos que $(a_n)_n$ no está acotada. \
Para ver que $(b_n)_n$ no es acotada, usamos que $1/r in.not QQ$ y que $b_n / a_n$ converge a $1/r$, por lo tanto el argumento aplicado a $(b_n)_n$ se puede aplicar para deducir que no está acotada. #align(right)[#square()]


_Ejemplo 4_: Calcular el cardinal

a) $ZZ times ZZ$ \
_Res_: Notemos que $ZZ -> NN$, $f(n) = cases(2n "si" n >= 0, 2(-n)-1 "si" n < 0)$ es una biyección. Entonces
$
F: ZZ times ZZ -> NN times NN \
F(n,m) = (f(n), f(m))
$
es biyectiva, porque $f$ es biyectiva:
- _inyectiva_: $F(n,m) = F(n',m') <=> f(n) = f(n') " y " f(m) = f(m')$. Como $f$ es inyectiva, $n=n'$ y $m=m'$.
- _suryectiva_: dado $(y_1, y_2) in NN times NN$, como $f$ es suryectiva existen $n in ZZ, m in ZZ$ tales que $f(n)=y_1$ y $f(m)=y_2$. Entonces $F(n,m) = (y_1, y_2)$.

Pero $NN times NN -> NN$ es biyectiva vía $(n,m) |-> 2^n (2m-1)$, porque todo número entero admite esta escritura por el Teorema Fundamental de la Aritmética.

_Otra resolución_: podemos escribir
$
ZZ times ZZ = union.sq_(n in ZZ) A_n, " con " A_n = {n} times ZZ
$
Como $A_n ~ ZZ$, tenemos que $ZZ times ZZ$ es unión contable de numerables, por lo tanto es numerable.

_Obs_: dado $N in NN$ tenemos que $NN = union.sq_(i=1)^N B_i$. \
Esto se puede probar por inducción, o notando que $B_i = {k N + i : k in NN_0}$ con $1 <= i <= N$ cumplen lo pedido. \
En general, $NN = union.sq_(m in NN)^(+oo) B_m$ con $N$ numerable. \
Por ejemplo:
$B_2 = {n in NN : 2 mid n}$, $B_3 = {n in NN : 2 cancel("|") n " y " 3 mid n}$, \
$B_5 = {n in NN : 2 cancel("|") n, 3 cancel("|") n, 5 mid n}, ...$ \
$B_p = {n in NN : q cancel("|") n " para todo " q < p " primo pero " p mid n}$. \
Una razón por la cual $union.sq_(n in ZZ) B_n ~ NN$ es porque hay biyecciones $NN ->^g P = {p in NN " primos"}$, $B_p ~> NN$, entonces
$
A_m ~> B_(g(m)), (n,m) |-> h_(g(m))(m) \
ZZ times ZZ = union.sq_(m in ZZ) A_m ~> union.sq_(p in P) B_p = NN \
(n,m) |-> h_(g(m))(m)
$

b) $(0,1) inter QQ$ \
_Res_: Tenemos que $QQ_(>0)$ es numerable. Por ejemplo,
$
QQ_(>0) -> NN times NN \
x = a/b, (a,b)=1 |-> (a,b)
$
es inyectiva, y como $NN times NN$ es numerable, $QQ_(>0)$ es numerable (pues es infinito). \
Entonces podemos usar que $QQ_(>0) = (0,+oo) inter QQ$, y $f: (0,+oo) -> (0,1)$, $x |-> x/(x+1)$ es una biyección:
- _bien definida_: pues $0 < x < x+1$ y $0 < x/(x+1) < 1$;
- _inyectiva_: pues $x/(x+1) = y/(y+1) <=> x(y+1) = (x+1)y <=> x y + x = x y + y <=> x=y$;
- _suryectiva_: pues dado $y in (0,1)$, $x/(x+1) = y <=> x = y(x+1) = y x + y <=> x - y x = x(1-y) = y$, que equivale a $x = y/(1-y)$.

Como $f: (0,+oo) inter QQ -> (0,1) inter QQ$ sigue estando bien definida y es biyectiva, se sigue que $(0,1) inter QQ$ es numerable.

_Otras formas_:
- Tenemos una inyección $(0,1) inter QQ |-> QQ$, entonces $(0,1) inter QQ$ es contable. Como ${1/n : n in NN} |-> (0,1) inter QQ$ es infinito, $(0,1) inter QQ$ es numerable.
- Escribimos $(0,1) inter QQ = union.sq_(m in NN) A_m$ donde $A_m = {m/n : 0 < m < n}$. Como $A_m$ es finito para todo $m in NN$, y unión contable de contables es contable, se sigue. #align(right)[#square()]

c) ${pi q : q in QQ}$ \
_Res_: Tenemos que $f: QQ -> {pi q : q in QQ}$, $q |-> pi q$ es biyectiva. #align(right)[#square()]

d) $QQ + QQ = {a+b : a in QQ, b in QQ}$ \
_Res_: $QQ + QQ subset.eq QQ$ entonces es contable. Como es infinito, es numerable. \
_Otras formas_: la función $QQ times QQ -> QQ$, $(a,b) |-> a+b$ es suryectiva, pues $a in QQ$ es imagen de $(a,0)$. Entonces podemos usar: \
_Lema_: Si $f: NN -> A$ es suryectiva entonces $A$ es contable. \
_Demo_: Dado $a in A$ existe $n_a in NN$ tal que $f(n_a) = a$. Definimos $tilde(f): A -> NN$, $a |-> n_a$. $tilde(f)$ es inyectiva. \
_Nota_: cuando "elegimos" $a in A$ en verdad apelamos al principio de buena ordenación. En general, si $f: B -> A$ es suryectiva, existe $tilde(f): A -> B$ inyectiva, pero elegir el inverso de $a in A$ requiere el axioma de elección. \
En cualquier caso, como $QQ ~ NN$, concluimos que hay una suryección $NN -> QQ+QQ$, y por lo tanto $QQ+QQ$ es contable.

_Una manera más_: \
$QQ+QQ = {a+b : a in QQ, b in QQ} = union.sq_(a in QQ) (a + QQ)$. Como $a + QQ ~ QQ$ vía $q |-> a+q$, es contable. Entonces $QQ+QQ$ es unión contable de contables, por lo tanto es contable. #align(right)[#square()]

_Obs_: si $A, B subset.eq RR^n$ son contables entonces $A+B$ es contable.

e) ${(a_n)_n subset.eq ZZ : a_n "es convergente"}$ \
_Res_: Sabemos que existe $n_0 in NN$ tal que para todo $n >= n_0$, $a_n = a_(n_0) in ZZ$. Entonces
$
{(a_n)_n subset.eq ZZ : a_n "es convergente"} = union.sq_((a,k) in ZZ times NN) A_(a,k)
$
con
$
A_(a,k) = {(a_n)_n subset.eq ZZ : forall n >= k, a_n = a} ~> ZZ^(k-1) \
(a_n)_n |-> (a_1, a_2, ..., a_(k-1))
$
Entonces $A_(a,k)$ es contable. Como $ZZ times NN$ es contable, el conjunto es unión contable de contables, y por lo tanto es contable. #align(right)[#square()]
