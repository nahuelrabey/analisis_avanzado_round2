// #let ge = $epsilon$
#import "../utils.typ": recta

= Sucesiones y Supremos

*Def*: una sucesión $(a_n)_(n in NN)$ *converge a $L$* si dado $epsilon > 0$ existe $n_0 in NN$ tal que $forall n >= n_0$ se tiene que $abs(a_n - L)<epsilon$. Escribimos que $lim_(n->+oo)a_n = L$

*Ejemplo 1*: Demostrar los siguientes límites

_Ejemplo 1.1_

$
lim_(n->+oo) 1/(2^n) = 0
$

_Demo_: Queremos ver que dado $epsilon > 0$ existe $n_0 in NN$ tal que $forall n>=n_0$
$
abs(1/2^n) = 1/2^n < epsilon
$

Por _arquimedianidad_ existe $m in NN$ tal que $1/m < epsilon$. Alcanza con ver que 
$
1/(2^m) <= 1/m <=> m <= 2^m
$

Cómo $1/2^n <= 1/2^m$ si $n >= m$, tomamos $n_0 = m$ y concluimos que

$
1/2^n <= 1/2^m <= 1/m <= epsilon " si " n >= n_0
$

_Ejemplo 1.2_

$
lim_(n->+oo) [(-1)^n+2]/sqrt(n+3) = 0
$

_Demo_: Queremos ver que, dado $epsilon > 0$ podemos encontrar $n_0 in NN$ tal que $forall n >= n_0$ 

$
abs([(-1)^n+2]/sqrt(n+3)) < epsilon
$

Notemos que $abs([(-1)^n+2]) <= 1+2 = 3$. Por lo tanto

$
abs([(-1)^n+2]/sqrt(n+3)) <= 3/sqrt(n+3)
$

Veamos que exise $n_0 in NN$ tal que $forall n > n_0$

$
1/sqrt(n+3) < epsilon/3
$

Por arquimedianidad $exists m in NN$ tal que $1/m < (epsilon/3)²$. Entonces $1/sqrt(m) < epsilon/3$

Basta que

$
1/sqrt(n+3) < 1/sqrt(m) <=> m < n+3
$

Por lo tanto, si tomamos $n_0 = max{m-3,1}$,
$
3/sqrt(n+3) <= 3/sqrt(m) < 3 dot epsilon/3 = epsilon
$

Cosas útiles para probar que $(a_n)_(n in NN)$ converge. Lo primero es el siguiente teorema

_Teorema_: Una sucesión $(a_n)_n$ monótona es convergente si es acotada.

- Si $(a_n)$ es creciente y acotada, entonces converge al $sup{a_n : n in NN}$
- Si $(a_n)$ es decreciente y acotada, entonces converge al $inf{a_n : n in NN}$

_Ejemplo 2_: Determinar todos los $x in RR$ para los cuales $(x^n)_(n in NN)$ converge

_Demo_: Separamos en casos 

Caso $0<=x<=1$. Acá $a_n = x^n$ es decreciente:
$
  a_(n+1) <= a_n <=> x^(n+1) <= x^n
$

Pero 

$
  x^(n+1) <= x^n \
  x^(n+1) - x^n <= x^n - x^n\
  x^n (x - 1) <= 0 & " factoricé el lado izquierdo "
$

Esta última desigualdad es verdadero porque $x^n >= 0$, $x-1 <= 0$. Además $x^n$ es acotada:
$
0 <= x^n <= 1^n = 1
$

Por el teorema anterior, $(a_n)_(n in NN)$ converje. Para calcular el límite usamos que 

$
x^(n+1) =  x^n x " (*) "
$

#let lmn = $lim_(n->+oo)$

Sea $L =lmn x^n$, entonces $L = lmn x^(n+1)$, y por lo tanto

$
L = lmn x^(n) = lmn x^(n+1) = lmn x^n x = L x
$

De lo anterior se simplifica

$
L = L x \
L - L x = L x - L x \
L (1 - x) = 0
$

Tenos dos opciones, $L = 0$ o $x = 1$. Si $x = 1$, entonces $a_n = x^(n) = 1^n ->_(n->oo) 1$. En cualquier caso, el límite existe.

Caso $abs(x) < 1$

Para esto usamos el siguiente

_Lema_: 
+ $(a_n)_n -> 0$ si $(abs(a_n))_n -> 0$
+ si $(a_n)_n -> L$ entonces $(abs(a_n))_n -> abs(L)$

Entonces, si $a_n = x^n$, $abs(a_n) = abs(x)^n$ tiene $abs(x) < 1$. Por el caso anterior, $abs(a_n) -> 0$, y en consecuencia $a_n -> 0$

Caso $x > 1$

Acá, $a_n = x^n$ es creciente.

$
a_(n+1) >= a_n <=> x^(n+1) >= x^n
$

Pero $x^(n+1) - x^n = x^(n) (x-1) >= 0$ ya que $x^n >= 0$, $x-1 > 0$. Si $(a_n)$ convergiera, repitiendo el argumento de tomar el límite en (\*) nos daría que $x = 1$ o $L = 0$. Cómo x > 1, debe ser $L = 0$. Pero una sucesión convergente converge al supremo, por lo tanto $a_n = x^n <=L = 0$, para todo $n in NN$, lo cuál es absurdo, y por lo tanto no converge.

Caso $x = -1$: _ejercicio 1_

Caso $x < -1$: Si a_n = x^n fuera convergente, entonces $abs(a_n) = abs(x)^n$ sería convergente, pero $abs(x) > 1$ y por el caso anterior no es convergente.

Resumen
$
(x^n)_(n in NN) "es " cases(
  " convergente a " 0 " cuando " abs(x) < 1,
  " convergente a " 1 " cuando " x = 1,
  " diveregente cuando " abs(x) > 1
)
$

_Ejemplo 3_

Sea $(a_n)_(n in NN)$ una sucesión convergente tal que existe $n_0 in NN$ para el cual $a_n in ZZ$ para todo $n > n_0$. Probar que existen $n_1 in NN$ y $a in RR$ tales que $a_n = a$ para todo $n >= n_1$.

_Demo_

Supongamos que $lmn a_n = L$. Veamos que $L = a$ cumple lo pedido. Dado $epsilon > 0$ existe $ñ in NN$ tal que $forall n > ñ$ vale que:

$
  abs(a_n - L) < epsilon
$

En particular, $forall n>=max{ñ,n_0}$ se tiene que

$
  a_n in ZZ " y " abs(a_n -L) < epsilon
$

Siguiendo el mismo rango de $n$, si $n_1 = max{ñ,n_0}$ y $n >= n_1$

$
  abs(a_n - a_(n_1)) <= abs(a_n - L) + abs(a_(n_1) - L) < 2 epsilon
$

Si el $epsilon$ lo tomamos $epsilon <= 1/2$, por ejemplo $epsilon=1/2$ queda que 

$
  abs(a_n - a_(n_1)) <= 1
$

Pero la diferencia entre dos enteros distintos es, al menos, $1$. Concluimos que $a_n = a_n_1$. Por lo tanto $a_n = a_n_1$ $forall n>=n_1$. Cómo $a_n$ converge, $lmn a_n = a_n_1 = L$.

Podemos usar sucesiones para calcular supremos e infimos

_Lema_: Sea $A in RR$ np vacío y acotado superiormente. Tenemos que $s = sup A$ sii:
+ $s$ es cota superior de $A$ y
+ $exists (a_n)_(n in NN) subset.eq A$ convergente a $s$.
+ Si $A subset.eq RR$ no vacío contiene una sucesión no acotada superiormente, entones $A$ no está acotado superiormente.

Vale un resultado análogo para ínfimos

_Ejemplo 4_: Hallar, si existen, supremo e ínfimo de $A = {1/n + m: n in NN, m in NN}$

_Res_:
Tenemos que $A != emptyset$
+ $a_m = 1+m$ está contenido en $A$, y $lmn a_m = +oo$ (por arquimedianidad). Entonces $A$ no está acotado superiormente.
+ $1/n + m >1$ para todo $n,m in NN$. Cómo $a_n = 1/n + 1$ cumple que $lmn a_n = 1$. Concluimos que 1 es el ínfimo de $A$.cumple que $lmn a_n = 1$. Concluimos que 1 es el ínfimo de $A$.

#let lmk = $lim_(k->+oo)$

_Ejemplo 5_ Sea $x in RR$. Probar que existe un único entero $n$ tal que $n <= x < n+1$.

_Dem_ Sea $A = {n in ZZ : n <= x}$
+ $A != emptyset$. Por arquimedianidad, dado $x in RR$, $exists m in NN$ tal que $-x <= m$. Entonces $x >=-m$ y $m in A$.
+ $n <= x$ porque $n$ es la menor cota superior. 
+ $n < n+1$ porque, caso contrario, $n+1 <= x$ y $n+1 in A$, contradiciendo que $n$ sea cota superior $n < n+1$
+ $n in ZZ$: Cómo es el supremo, existe $(a_k)_k subset.eq A$ tal que $lmn a_k$. Pero, por el _Ejemplo 3_, existe $k_0 in NN$ tal que $a_k = n$ para todo $k >= k_0$. Entonces $n in ZZ$
+ $n$ es único: si $n' in ZZ$ cumple que $n' < x < n'+1$, entonces $n >= n'$ o $n' >= n$. Si $n>= n'$ resulta que $0<=n-n'<1$. Cómo $n,n' in ZZ$, resulta que $n = n'$

#recta(
  [$n'$],
  ([$n$], "arriba"),
  [$x$],
  [$n' + 1$]
)

_Ejemplo 6_: Probar que para todo $x in RR$ existe $(q_n)_n in QQ$ estrictametne decreciente tal que $lmn q_n = x$.

_Dem_:

#recta([$x$],[$q$])

Por arquimedianidad existe $n in NN$ tal que $x <= m$. Tomamos $q_1 = m$

#recta([$x$],[$q_2$], [$(x+q_2)/2$)], [$q_1$])

Por la densidad de $Q$ en $RR$ podemos elegir $q_2$ entre $x$ y $(x+q_1)/2$, es decir $x<q_2<(x+q_1)/2$.

En general, si definimos $q_1,q_2,...,q_n$ racionales con $q_1>q_2>...>q_n$, elegimos $q_(n+1) in QQ$ con $x < q_(n+1) < (x+q_1)/2$, que existe por densidad de $QQ$. Afirmamos que $q_(n+1) <= q_n$ para todo $n$ y que $q_n -> x$.

(1) $q_(n+1) <= q_n$ para todo $n in NN$. Probemos esto por inducción.

Caso base: $n = 1$

$
q_2 < (x+q_1)/2 " y " (x+q_1)/2 <q_1
$

porque 

$
(x+q_1)/2 < q_1 <=> x + q_1 < 2q_1  <=> x < q_1
$

Caso inductivo:

$
q_(k+1) < (x+q_k)/2, " y " (x+q_k)/2 < q_k 
$

Porque 

$
(x+q_k)/2 < q_k\
x + q_k < 2q_k\
x < q_k
$

(2) $lmn q_n = x$. Cómo $(q_n)_n$ es decreciente y acotada inferiormente por $x$, es convergente a $q in RR$ 
- $x < q_n$ para todo $n$, entonces $x <= q$
- $q_(n+1) < (x+q_n)/2$. Tomando límite, $q <= (x+q)/2 <=> q<=x$
Entonces $q = x$
