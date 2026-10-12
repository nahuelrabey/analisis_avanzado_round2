// Notas docentes 2025 · clase del 11/11/2025 (manuscrito "Análisis Avanzado — Conjuntos medibles").
// Clase 10 de la transcripción: sus ejercicios llevan el tag `C10-{k}` en `ejemplos/`.

= Conjuntos medibles Lebesgue

_Ejercicio 1_: Sea $cal(A) = {A subset.eq [0, 1] : A "es nulo o" A^c "es nulo"}$. Probar que $cal(A)$ es $sigma$-álgebra.

_Dem_: Verificamos que

1. $[0, 1] in cal(A)$ porque $[0, 1]^c = emptyset$ es nulo, pues está contenido en $(0, 1/n)$ para todo $n$, que tiene longitud $1/n -> 0$.

2. Si $A in cal(A)$ entonces $A$ es nulo o $A^c$ es nulo. Como $A = (A^c)^c$, esto significa que $A^c in cal(A)$.

3. Si $(A_n)_n subset.eq cal(A)$ consideremos $inter.big_(n in NN) A_n$.

  - Si algún $A_(n_0)$ es nulo, $inter.big_(n in NN) A_n subset.eq A_(n_0)$, y entonces para todo $epsilon > 0$ existen ${U_n}_n$ intervalos abiertos tales que
    $
    A_(n_0) subset.eq union.big_(n in NN) U_n quad "y" quad sum_(n = 1)^(+infinity) op("length")(U_n) < epsilon.
    $
    Pero entonces $inter.big_(n in NN) A_n subset.eq union.big_(n = 1)^(+infinity) U_n$, de donde inferimos que $inter.big_(n in NN) A_n$ es nulo, y por lo tanto está en $cal(A)$.

  - Si ningún $A_n$ es nulo, como son elementos de $cal(A)$, resulta que para todo $n$, $A_n^c$ es nulo. Consideremos
    $
    (inter.big_(n in NN) A_n)^c = union.big_(n in NN) A_n^c.
    $
    Sea $epsilon > 0$. Dado $n$, como $A_n^c$ es nulo, existe una familia de abiertos ${U_(n, m)}_(m in NN)$ tal que
    $
    A_n^c subset.eq union.big_(m in NN) U_(n, m) quad "y" quad sum_(m in NN) op("length")(U_(n, m)) < epsilon / 2^n.
    $
    Sea ${U_(n, m)}_((n, m) in NN^2)$; es una colección _contable_ de intervalos abiertos tal que
    $
    union.big_(n in NN) A_n^c &subset.eq union.big_(n in NN) union.big_(m in NN) U_(n, m) = union.big_((n, m) in NN^2) U_(n, m); \
    sum_((n, m) in NN^2) op("length")(U_(n, m)) &= underbrace(sum_(n = 1)^(+infinity) sum_(m = 1)^(+infinity) op("length")(U_(n, m)), "todos los términos son no negativos") < sum_(n = 1)^(+infinity) epsilon / 2^n = epsilon.
    $
    Concluimos que $union.big_(n in NN) A_n^c$ es nulo. #align(right)[#square()]

_Nota_: el manuscrito verifica la clausura por intersecciones numerables en lugar de por uniones numerables; como $cal(A)$ es cerrada por complementos (ítem 2) y $union.big_n A_n = (inter.big_n A_n^c)^c$, ambas condiciones son equivalentes.

_Ejercicio 2_: Definimos por $cal(B)$ a la _menor $sigma$-álgebra_ de subconjuntos de $RR$ que contiene todos los intervalos abiertos de $RR$. Sean

a) $cal(B)_1$ la menor $sigma$-álgebra que contiene a los intervalos cerrados de $RR$.

b) $cal(B)_2$ la menor $sigma$-álgebra que contiene a los abiertos de $RR$.

c) $cal(B)_3$ la menor $sigma$-álgebra que contiene a los cerrados de $RR$.

Probar que $cal(B)_1 = cal(B)_2 = cal(B)_3 = cal(B)$.

_Dem_:

a) Vemos cada inclusión por separado.

- $cal(B)_1 subset.eq cal(B)$: notemos que _no es obvio_ qué forma tiene un $A in cal(B)_1$. Pero sí conocemos _los conjuntos generadores de $cal(B)_1$_. Sea $[a, b]$ un intervalo finito. Queremos ver que $[a, b] in cal(B)$. Se tiene que
  $
  [a, b] = inter.big_(n in NN) (a - 1/n, b + 1/n).
  $
  En efecto, si $x in [a, b]$, $a - 1/n < a <= x <= b < b + 1/n$ para todo $n$, por lo tanto $x in inter.big_(n in NN) (a - 1/n, b + 1/n)$. Recíprocamente, si $x in inter.big_(n in NN) (a - 1/n, b + 1/n)$, resulta que $a - 1/n < x < b + 1/n$ para todo $n$. Tomando límite, $a <= x <= b$. Entonces $[a, b] in cal(B)$ porque es intersección numerable de intervalos abiertos. Si consideramos intervalos de la forma $[a, +infinity)$, $(-infinity, b]$, podemos razonar igual, notando que
  $
  [a, +infinity) = inter.big_(n in NN) (a - 1/n, +infinity), quad (-infinity, b] = inter.big_(n in NN) (-infinity, b + 1/n).
  $
  Concluimos que todo intervalo cerrado de $RR$ es un elemento de $cal(B)$. Como $cal(B)_1$ es _la menor $sigma$-álgebra_ que contiene a los intervalos cerrados, tenemos que $cal(B)_1 subset.eq cal(B)$.

- $cal(B) subset.eq cal(B)_1$: Razonamos como en el caso anterior. Sean $(a, b)$, $(a, +infinity)$, $(-infinity, b)$. Tenemos que
  $
  (a, b) = union.big_(n in NN) [a - 1/n, b + 1/n], quad (a, +infinity) = union.big_(n in NN) [a - 1/n, +infinity), quad (-infinity, b) = union.big_(n in NN) (-infinity, b + 1/n].
  $
  En cualquier caso, los intervalos son uniones numerables de intervalos cerrados, por lo tanto son elementos de $cal(B)_1$. Como $cal(B)$ es la menor $sigma$-álgebra que contiene a los intervalos abiertos, se sigue que $cal(B) subset.eq cal(B)_1$.

_Nota_: los signos de las tres igualdades anteriores están al revés en el manuscrito: $union.big_n [a - 1/n, b + 1/n] = [a - 1, b + 1]$, que contiene estrictamente a $(a, b)$. Las igualdades correctas son
$
(a, b) = union.big_(n in NN) [a + 1/n, b - 1/n], quad (a, +infinity) = union.big_(n in NN) [a + 1/n, +infinity), quad (-infinity, b) = union.big_(n in NN) (-infinity, b - 1/n]
$
(los $[a + 1\/n, b - 1\/n]$ con $a + 1\/n > b - 1\/n$ son vacíos y no aportan). El argumento sigue igual.

b) Vemos cada inclusión por separado.

- $cal(B) subset.eq cal(B)_2$: esto es porque todo intervalo abierto es un conjunto abierto, y en consecuencia es un elemento de $cal(B)_2$. Como $cal(B)$ es la menor $sigma$-álgebra que contiene a los intervalos abiertos, $cal(B) subset.eq cal(B)_2$.

- $cal(B)_2 subset.eq cal(B)$: sea $U subset.eq RR$ abierto. Afirmamos que
  $
  U = union.big_((q, r) in QQ times QQ_(> 0) \ q in U\, r "cumple que" B(q, r) subset.eq U) (q - r, q + r). quad (⊛)
  $
  - Notemos que como $QQ$ es denso en $RR$, $U inter QQ != emptyset$.
  - La contención $supset.eq)$ es por definición. Para la otra contención, sea $x in U$. Como $U$ es abierto, existe $tilde(r) > 0$ tal que $(x - tilde(r), x + tilde(r)) subset.eq U$. Más aún, por arquimedianidad, podemos tomar $tilde(r) in QQ$. Sea $q in (x - tilde(r), x + tilde(r))$. Como el intervalo es abierto, existe $r > 0$ tal que $(q - r, q + r) subset.eq (x - tilde(r), x + tilde(r)) subset.eq U$. De nuevo, podemos tomar $r in QQ$. Concluimos que $x$ está en el conjunto del lado derecho de la igualdad de $(⊛)$. Por definición de $cal(B)_2$, se sigue que $cal(B)_2 subset.eq cal(B)$.

_Nota_: en la contención $subset.eq)$ el manuscrito no pide $q in QQ$ ni garantiza que $x in (q - r, q + r)$, que es lo que hace falta para que $x$ esté en el lado derecho de $(⊛)$. Se arregla eligiendo $q in QQ$ con $abs(x - q) < tilde(r) \/ 2$ (existe por densidad) y luego $r in QQ$ con $abs(x - q) < r < tilde(r) \/ 2$: así $x in (q - r, q + r) subset.eq (x - tilde(r), x + tilde(r)) subset.eq U$, y $(q, r)$ está en el conjunto de índices. Observar además que $(⊛)$ es una unión _numerable_ de intervalos abiertos (porque $QQ times QQ_(> 0)$ es numerable), y por eso $U in cal(B)$.

c) Vemos cada inclusión por separado.

- $cal(B) subset.eq cal(B)_3$: se sigue de la misma idea de la inclusión $cal(B) subset.eq cal(B)_1$, porque todo intervalo abierto es unión numerable de intervalos cerrados.

- $cal(B)_3 subset.eq cal(B)$: dado $F subset.eq RR$ cerrado, tenemos que
  $
  F attach(=, t: (⊛ ⊛)) inter.big_(n in NN) B(F, 1/n), quad B(F, 1/n) = {x in RR : d(x, F) < 1/n}.
  $
  Vimos que $B(F, 1/n)$ es abierto. Por el ítem b), $B(F, 1/n) in cal(B)$, y por lo tanto, si probamos $(⊛ ⊛)$ se sigue que $F in cal(B)$, y en consecuencia que $cal(B)_3 subset.eq cal(B)$. Veamos $(⊛ ⊛)$:
  - $F subset.eq inter.big_(n in NN) B(F, 1/n)$, porque para todo $x in F$, $d(x, F) = 0 < 1/n$ para todo $n$.
  - $inter.big_(n in NN) B(F, 1/n) subset.eq F$: dado $x in inter.big_(n in NN) B(F, 1/n)$, para todo $n$ se tiene que $d(x, F) < 1/n$. Por definición de $d(x, F)$, existe $x_n in F$ tal que
    $
    d(x, x_n) < d(x, F) + 1/n < 2/n.
    $
    Entonces $(x_n)_n subset.eq F$ converge a $x$, y como $F$ es cerrado, $x in F$. #align(right)[#square()]

_Nota_: el manuscrito usa la misma etiqueta $(⊛)$ para la igualdad de b) y para la de c); acá la segunda se escribe $(⊛ ⊛)$ para distinguirlas.

_Nota (del manuscrito)_: en la resolución usamos los siguientes hechos generales para espacios métricos $(X, d)$.

a) Dado $F subset.eq X$ _cerrado_, $F$ es intersección _contable_ de abiertos, y de hecho,
$
F = inter.big_(n in NN) B(F, 1/n).
$

b) Dado $U subset.eq X$ _abierto_, $U$ es unión _contable_ de cerrados.

c) Si $X$ es _separable_, con denso $D subset.eq X$, entonces todo abierto $U subset.eq X$ es unión _contable_ de bolas abiertas de $X$.

_Ejercicio 3_: Sea $A_n = (0, 1 - 1/n) union ([n + 1/4, n + 3/4] inter QQ)$. Calcular $mu(union.big_(n = 1)^(+infinity) A_n)$.

_Res_: notemos que
$
A_1 &= (0, 0) union ([5/4, 7/4] inter QQ) = [5/4, 7/4] inter QQ, \
A_2 &= (0, 1/2) union ([9/4, 11/4] inter QQ), \
A_3 &= (0, 2/3) union ([13/4, 15/4] inter QQ), \
&dots.v
$
El intervalo $(0, 1 - 1/n)$ de cada $A_n$ contiene al intervalo abierto de $A_(n - 1)$, $n >= 2$, mientras que los $[n + 1/4, n + 3/4] inter QQ$ son todos disjuntos entre sí, y de los $(0, 1 - 1/n)$. Podemos escribir (con $union.sq$ la unión disjunta):
$
union.big_(n in NN) A_n &= union.big_(n in NN) (0, 1 - 1/n) union ([n + 1/4, n + 3/4] inter QQ) \
&= [union.big_(n in NN) (0, 1 - 1/n)] union.sq union.big_(n in NN) ([n + 1/4, n + 3/4] inter QQ) \
&= underbrace([union.big_(n in NN) (0, 1 - 1/n)], = B) union.sq underbrace({[union.big_(n in NN) [n + 1/4, n + 3/4]] inter QQ}, = C).
$
Por la $sigma$-aditividad de la medida, $mu(union.big_(n in NN) A_n) = mu(B) + mu(C)$.

- Como $mu((0, 1 - 1/n)) = 1 - 1/n -> 1$ y $(0, 1 - 1/n) subset.eq (0, 1 - 1/(n + 1))$ para todo $n in NN$,
  $
  mu(B) = lim_(n -> +infinity) mu((0, 1 - 1/n)) = 1.
  $

- Como $C subset.eq QQ$, es contable, y por lo tanto $mu(C) = 0$.

Concluimos que $mu(union.big_(n in NN) A_n) = 1$.

_Ejercicio 4_: Sea $A subset.eq [0, 1]$ que consiste de todos los números que no tienen al dígito $4$ en su expansión decimal. Probar que $A$ es medible y hallar su medida.

_Res_: Sea $A_1 = {x in [0, 1] : "el primer dígito de" x "no es" 4}$. Entonces $x = 0","a_1 dots$ con $a_1 != 4$. Por lo tanto, extraemos del $[0, 1]$ los $x$'s que comienzan con $0","4$ y terminan en $0","4 hat(9) = 0","5$. O sea, el intervalo $I_1 = [0.4, 0.5]$ y
$
A_1 = [0, 0.4) union (0.5, 1)
$
es medible. Tenemos que
$
mu(A_1) = mu(I - I_1) = mu(I) - mu(I_1) = 1 - 0.1 = 0.9 = 9/10.
$

_Nota_: los extremos son ambiguos por las expansiones decimales dobles ($0.5 = 0.4 hat(9)$, $1 = 0.hat(9)$), y el manuscrito no es del todo consistente con ellos (deja $0.5$ y $1$ afuera de $A_1$, y más abajo quita intervalos cerrados $[0.a_1 dots a_n 4, 0.a_1 dots a_n 5]$ cuyo extremo derecho no tiene $4$). Son finitos puntos en cada paso, así que no afectan ni la medibilidad ni la medida.

Consideremos $A_2 = {x in [0, 1] : "entre los primeros dos dígitos de" x "no está" 4}$. Notemos que $A_2 subset.eq A_1$. Lo que tendríamos que hacer es dividir cada uno de los intervalos $[0, 0.1]$, $[0.1, 0.2]$, $[0.3, 0.4]$, $(0.5, 0.6]$, ..., $[0.9, 1]$ en $10$ partes y extraer el intervalo correspondiente a que el segundo dígito sea $4$.

(dibujo: la recta $[0, 1]$ marcada en décimos $0, .1, .2, dots, .9, 1$, con el subintervalo "segundo dígito $4$" pintado dentro de cada décimo salvo el $[.4, .5]$; debajo, un zoom del $[0, 0.1]$ dividido en centésimos $0.01, dots, 0.09$ con el $[0.04, 0.05]$ pintado. En $[0, 0.1]$ eliminamos el intervalo $[0.04, 0.05]$.)

Entonces
$
A_2 = A_1 - ([0.04, 0.05] union.sq [0.14, 0.15] union.sq [0.24, 0.25] union.sq [0.34, 0.35] union.sq [0.54, 0.55] union dots)
$
es medible, y
$
mu(A_2) = mu(A_1) - 0.01 dot.c 9 = 9/10 - 9/100 = 9/10 (1 - 1/10) = (9/10)^2.
$
Para cerrar el ejercicio, podríamos probar por inducción que los conjuntos
$
A_n := {x in [0, 1] : x "no tiene al" 4 "entre sus primeros" n "dígitos"}
$
cumplen que:

I) $A_(n + 1) subset.eq A_n$ para todo $n in NN$.

II) $A_n$ es unión finita de intervalos, por lo tanto es medible, y además $mu(A_n) = (9/10)^n$.

En tal caso, $A = inter.big_n A_n$, por lo tanto es medible, y
$
mu(A) = lim_(n -> +infinity) mu(A_n) = lim_(n -> +infinity) (9/10)^n = 0.
$
Notemos que I) vale por definición de los conjuntos $A_n$. Veamos que II) se sigue por inducción. El caso base $n = 1$ ya lo vimos. Supongamos que $A_n$ cumple II). Los $x$'s que están en $A_n without A_(n + 1)$ son aquellos que _no tienen $4$'s en sus primeros $n$ dígitos, pero tienen un $4$ en su dígito $n + 1$_. Entonces, tienen la forma $0.a_1 a_2 dots a_n 4 dots$ con $(a_1, a_2, dots, a_n) in {0, 1, 2, 3, 5, 6, 7, 8, 9}^n = C^n$. Entonces
$
A_(n + 1) = A_n - union.sq.big_((a_1, dots, a_n) in C^n) [0.a_1 a_2 dots a_n 4, 0.a_1 a_2 dots a_n 5].
$
Esto prueba que $A_(n + 1)$ es unión finita de intervalos, y por lo tanto es medible. Además, como $[0.a_1 a_2 dots a_n 4, 0.a_1 a_2 dots a_n 5] subset.eq A_n$ para todo $(a_1, a_2, dots, a_n) in C^n$, se sigue que
$
mu(A_(n + 1)) &= mu(A_n) - mu(union.sq.big_((a_1, dots, a_n) in C^n) [0.a_1 a_2 dots a_n 4, 0.a_1 a_2 dots a_n 5]) \
&= (9/10)^n - sum_((a_1, dots, a_n) in C^n) mu([0.a_1 dots a_n 4, 0.a_1 dots a_n 5]) \
&= (9/10)^n - sum_((a_1, dots, a_n) in C^n) 10^(-(n + 1)) = (9/10)^n - 10^(-(n + 1)) dot.c 9^n = (9/10)^n - 9^n / 10^(n + 1) \
&= (9/10)^n (1 - 1/10) = (9/10)^(n + 1).
$
Concluimos. #align(right)[#square()]

_Nota_: el paso $mu(A) = lim_n mu(A_n)$ usa la continuidad de la medida por arriba para sucesiones decrecientes, que vale porque $mu(A_1) < +infinity$.

_Ejercicio 5_: Sea $F subset.eq [0, 1]$ cerrado tal que $mu(F) = 1$. Probar que $F = [0, 1]$.

_Dem_: Tenemos que $[0, 1] without F$ es abierto, y
$
mu([0, 1] without F) = mu([0, 1]) - mu(F) = 1 - 1 = 0.
$
Por el ejercicio 9 de la práctica 7, $([0, 1] without F)^circle = emptyset$. Entonces $[0, 1] without F = ([0, 1] without F)^circle = emptyset$, y por lo tanto $F = [0, 1]$. #align(right)[#square()]

_Nota_: $[0, 1] without F$ es abierto _relativo a $[0, 1]$_, no necesariamente abierto en $RR$ (por ejemplo si $0 in.not F$). El argumento se arregla así: si existiera $x in [0, 1] without F$, como $F^c$ es abierto en $RR$ habría $r > 0$ con $(x - r, x + r) subset.eq F^c$, y entonces $(x - r, x + r) inter [0, 1]$ es un intervalo no degenerado contenido en $[0, 1] without F$, de medida positiva, absurdo.
