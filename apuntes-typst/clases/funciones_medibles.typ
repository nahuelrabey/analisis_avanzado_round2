// Notas docentes 2025 · clase del 18/11/2025 (manuscrito "Análisis avanzado — Funciones medibles").
// Clase 11 de la transcripción: sus ejercicios llevan el tag `C11-{k}` en `ejemplos/`.

= Funciones medibles

_Recordatorio_: $f : E -> RR$ es medible si y sólo si

a) $f^(-1) ((a, +infinity)) = {x in E : f(x) > a}$ es medible para todo $a in RR$,

b) $f^(-1) ([a, +infinity)) = {x in E : f(x) >= a}$ es medible para todo $a in RR$,

c) $f^(-1) ((-infinity, a)) = {x in E : f(x) < a}$ es medible para todo $a in RR$,

d) $f^(-1) ((-infinity, a]) = {x in E : f(x) <= a}$ es medible para todo $a in RR$.

_Ejercicio 1_: Probar que si $f$ es medible, para todo intervalo $I$, $f^(-1) (I)$ es medible.

_Dem_: Sólo hay que verificar que $f^(-1) (I)$ es medible para intervalos acotados.

- Si $I = (a, b) = (a, +infinity) inter (-infinity, b)$, entonces
  $
  f^(-1) (I) = f^(-1) ((a, +infinity) inter (-infinity, b)) = f^(-1) ((a, +infinity)) inter f^(-1) ((-infinity, b)).
  $
  Como $f^(-1) ((a, +infinity))$, $f^(-1) ((-infinity, b))$ son medibles, se sigue que $f^(-1) (I)$ es intersección de medibles, y en consecuencia es medible.

- Si $I = [a, b], [a, b), (a, b]$, lo escribimos como intersecciones de intervalos no acotados como en el caso $(a, b)$. #align(right)[#square()]

_Ejercicio 2_: Sea $g : RR -> RR$ continua y $f : RR -> RR$ medible. Probar que $g compose f$ es medible.

_Dem_: Primero notemos que $(g compose f)^(-1) (A) = f^(-1) (g^(-1) (A))$. En efecto, $x in (g compose f)^(-1) (A)$ si y sólo si $(g compose f)(x) in A$, es decir, si y sólo si la imagen por $g$ de $f(x)$ está en $A$. Pero esto equivale a su vez a que $f(x) in g^(-1) (A)$, y finalmente, esto último es equivalente a $x in f^(-1) (g^(-1) (A))$. Para ver que $f compose g$ es medible, notemos que dado $a in RR$,
$
(g compose f)^(-1) ((-infinity, a)) = f^(-1) (g^(-1) ((-infinity, a))),
$
y como $g$ es _continua_, $g^(-1) ((-infinity, a))$ es abierto (preimágenes de abiertos por funciones continuas son abiertos). Por lo tanto $g^(-1) ((-infinity, a)) = union.big_(n in N) I_n$ con $I_n$ intervalo abierto y $N$ contable. Entonces
$
(g compose f)^(-1) ((-infinity, a)) = f^(-1) (union.big_(n in N) I_n) = union.big_(n in N) f^(-1) (I_n).
$
Por el Ejercicio 1, $f^(-1) (I_n)$ es medible para todo $n in N$. Como $(g compose f)^(-1) ((-infinity, a))$ es unión contable de medibles, resulta medible. Esto prueba que $g compose f$ es medible. #align(right)[#square()]

_Nota_: el manuscrito escribe en un lugar "para ver que $f compose g$ es medible"; se trata de $g compose f$, que es lo que se prueba.

_Obs_: si pedimos sólo que $g$ sea medible, ¡puede pasar que $g compose f$ no sea medible!

_Ejercicio 3_: Sea $f_n : RR -> RR$ medible. Definimos $A := {x in RR : f_n (x) "converge"}$. Probar que $A$ es medible.

_Dem_: Notemos que $f_n (x)$ converge si y sólo si $(f_n (x))_n$ es de Cauchy. Entonces
$
A &= {x in RR : forall epsilon > 0, exists n_0 forall n, m >= n_0, abs(f_n (x) - f_m (x)) < epsilon} \
&= inter.big_(epsilon > 0) union.big_(n_0 in NN) inter.big_((n, m) : n >= n_0, m >= n_0) {x in RR : abs(f_n (x) - f_m (x)) < epsilon} \
&= inter.big_(k in NN) union.big_(n_0 in NN) inter.big_(n >= n_0, m >= n_0) {x in RR : abs(f_n (x) - f_m (x)) < 1/k},
$
donde en la última igualdad usamos que podemos cambiar "$forall epsilon > 0$" por "$forall k in NN$" si ponemos $abs(f_n (x) - f_m (x)) < 1/k$. Como $(f_n)_n$ es medible, $abs(f_n - f_m)$ es medible. Por lo tanto, los conjuntos
$
A_(n, m, k) = {x in RR : abs(f_n (x) - f_m (x)) < 1/k}
$
son del tipo c) del recordatorio, y por lo tanto son medibles. Concluimos que

- $inter.big_(n >= n_0, m >= n_0) A_(n, m, k)$ es medible para todo $n_0, k$, por ser intersección numerable de medibles,

- $union.big_(n_0 in NN) inter.big_(n >= n_0, m >= n_0) A_(n, m, k)$ es medible para todo $k$, por ser unión numerable de medibles,

- $A = inter.big_(k in NN) union.big_(n_0 in NN) inter.big_(n >= n_0, m >= n_0) A_(n, m, k)$ es medible, por ser intersección numerable de medibles. #align(right)[#square()]

_Ejercicio 4_: Sea $f : [0, 1] -> RR$ tal que $f$ es derivable en $(0, 1)$. Probar que $f' : (0, 1) -> RR$ es medible.

_Dem_: Recordemos que
$
f'(x_0) = lim_(h -> 0) (f(x_0 + h) - f(x_0)) / h.
$
Sea $a > 0$. Consideramos
$
(f')^(-1) ((a, +infinity)) = {x in (0, 1) : f'(x) > a}.
$
Sea $F(x, h) = (f(x + h) - f(x)) / h$. Como $lim_(h -> 0) F(x, h) = f'(x)$, se tiene que
$
lim_(n -> +infinity) F(x, 1/n) = lim_(n -> +infinity) (f(x + 1/n) - f(x)) / (1/n) = f'(x).
$
Entonces, veamos que
$
f'(x) > a quad "si y sólo si" quad "existen" k in NN, n_0 in NN "tales que para todo" n >= n_0, F(x, 1/n) > a + 1/k.
$

$=>)$ Por definición, dado $epsilon > 0$ existe $n_0 in NN$ tal que para todo $n >= n_0$, $abs(F(x, 1/n) - f'(x)) < epsilon$. Entonces $F(x, 1/n) > f'(x) - epsilon$. Como $f'(x) > a$, existe $k in NN$ tal que $f'(x) > a + 1/k$. Por lo tanto $F(x, 1/n) > a + 1/k - epsilon$. Si elegimos $epsilon = 1/(2k)$, queda $F(x, 1/n) > a + 1/(2k)$.

$arrow.l.double)$ Tomar límite $n -> +infinity$. Queda $lim_(n -> +infinity) F(x, 1/n) = f'(x) >= a + 1/k > a$.

Entonces:
$
{x in (0, 1) : f'(x) > a} &= {x in (0, 1) : exists k in NN space exists n_0 in NN space forall n >= n_0 space F(x, 1/n) > a + 1/k} \
&= union.big_(k in NN) union.big_(n_0 in NN) inter.big_(n >= n_0) {x in (0, 1) : F(x, 1/n) > a + 1/k} \
&= union.big_(k in NN) union.big_(n_0 in NN) inter.big_(n >= n_0) {x in (0, 1) : (f(x + 1/n) - f(x)) / (1/n) > a + 1/k}.
$
Fijado $n$, $(f(x + 1/n) - f(x)) / (1/n)$ es medible, por lo tanto los conjuntos
$
A_(k, n_0, n) = {x in (0, 1) : (f(x + 1/n) - f(x)) / (1/n) > a + 1/k}
$
son medibles. Entonces:

- $inter.big_(n >= n_0) A_(k, n_0, n)$ es medible porque es intersección numerable de medibles,

- $union.big_(n_0 in NN) inter.big_(n >= n_0) A_(k, n_0, n)$ es medible porque es unión numerable de medibles,

- $inter.big_(k in NN) union.big_(n_0 in NN) inter.big_(n >= n_0) A_(k, n_0, n)$ es medible porque es intersección numerable de medibles.

_Nota_: tres observaciones sobre el manuscrito. (i) Escribe "sea $a > 0$", pero hay que ver que ${f' > a}$ es medible para _todo_ $a in RR$; el argumento no usa que $a$ sea positivo. (ii) En el último ítem escribe $inter.big_(k in NN)$ e "intersección numerable", pero el "$exists k$" de la descripción de ${f' > a}$ da una _unión_ sobre $k$, como en las dos líneas de arriba: $union.big_(k in NN) union.big_(n_0 in NN) inter.big_(n >= n_0) A_(k, n_0, n)$ es medible por ser unión numerable de medibles. (iii) En $=>)$ se obtiene $F(x, 1/n) > a + 1/(2k)$, así que el natural que sirve en el enunciado del "si y sólo si" es $2k$. Además, que $x |-> n (f(x + 1 \/ n) - f(x))$ sea medible usa que $f$ es continua en $(0, 1)$ (por ser derivable) y que la traslación $x |-> f(x + 1/n)$ preserva medibilidad; ese cociente sólo está definido para $x < 1 - 1/n$, pero para cada $x in (0, 1)$ lo está para todo $n$ grande, que es lo único que interviene en la intersección sobre $n >= n_0$.

_Ejercicio 5_: Sea $f : [0, 1] -> RR$ medible. Probar que para todo $epsilon > 0$ existen $M >= 0$ y $A subset.eq [0, 1]$ medible tales que

- $abs(f(x)) <= M$ para todo $x in [0, 1] without A$,

- $mu (A) < epsilon$.

_Dem_: Notemos que buscamos $M, A$ tales que

- $[0, 1] without A subset.eq {x in [0, 1] : abs(f(x)) <= M}$, o equivalentemente $A supset.eq {x in [0, 1] : abs(f(x)) > M}$,

- $mu (A) < epsilon$.

Sea $epsilon > 0$. Tenemos que
$
inter.big_(n in NN) {x in [0, 1] : abs(f(x)) > n} = emptyset.
$
Además, para todo $n in NN$, si $A_n = {x in [0, 1] : abs(f(x)) > n}$,

- $A_n$ es medible porque $f$ es medible,

- $A_(n+1) subset.eq A_n$, porque si $x in A_(n+1)$, cumple que $abs(f(x)) > n + 1$, entonces $abs(f(x)) > n + 1 > n$, y por lo tanto $x in A_n$.

Entonces $lim_(n -> +infinity) mu (A_n) = mu (inter.big_n A_n) = mu (emptyset) = 0$. Por lo tanto, se tiene que existe $n_0$ tal que para todo $n >= n_0$, $mu (A_n) < epsilon$. Sea $A = A_(n_0)$ y $M = n_0$.

- $A$ es medible.

- $mu (A) < epsilon$.

- $[0, 1] without A = {x in [0, 1] : abs(f(x)) <= n}$, o sea, $abs(f(x)) <= n_0$ para todo $x in [0, 1] without A$.

Concluimos que $M$ y $A$ cumplen lo pedido. #align(right)[#square()]

_Nota_: en el último ítem el manuscrito escribe "$abs(f(x)) <= n$"; es $n_0$, como dice a continuación. Dos detalles que el manuscrito no explicita: la intersección $inter.big_n A_n$ es vacía porque $f$ toma valores reales (finitos), y el paso $lim mu (A_n) = mu (inter.big_n A_n)$ (continuidad de $mu$ para sucesiones decrecientes) requiere $mu (A_1) < infinity$, que vale porque $A_1 subset.eq [0, 1]$.

_Ejercicio 6_: Sea $f : [0, 1] -> RR$ integrable. Probar que para todo $t > 0$, $f_t : [0, t] -> RR$ es integrable, y además
$
integral_([0, 1/t]) f(t x) dif mu (x) = 1/t integral_([0, 1]) f(x) dif mu (x). quad (*)
$

_Nota_: el manuscrito escribe el dominio de $f_t$ como $[0, t]$; por $(*)$ y por el resto de la resolución, $f_t (x) = f(t x)$ y su dominio es $[0, 1 \/ t]$ (que es donde $t x in [0, 1]$).

_Dem_: Supongamos primero que $f >= 0$. Entonces existe una sucesión $(s_n)_n$ de funciones simples $s_n : [0, 1] -> [0, +infinity)$ tales que

1) $s_n (x) <= f(x)$ para todo $x in [0, 1]$ y todo $n in NN$,

2) $0 <= s_n (x) <= s_(n+1) (x)$ para todo $x in [0, 1]$ y todo $n in NN$,

3) $lim_(n -> +infinity) s_n (x) = f(x)$ para todo $x in [0, 1]$.

Notemos que si
$
s(x) = sum_(i = 1)^m a_i chi_(A_i) (x), quad "con" A_i inter A_j = emptyset "si" i != j, quad union.big_(i = 1)^m A_i = [0, 1],
$
entonces
$
s(t x) = sum_(i = 1)^m a_i chi_(A_i) (t x) = sum_(i = 1)^m a_i chi_(1/t A_i) (x),
$
porque $t x in A_i$ si y sólo si $x in 1/t A_i$. Además, si $i != j$, $1/t A_i inter 1/t A_j = emptyset$, pues $x in 1/t A_i inter 1/t A_j$ si y sólo si $x = 1/t a = 1/t b$ con $a in A_i$, $b in A_j$, es decir $a = b in A_i inter A_j$. Además, $union.big_(i = 1)^m 1/t A_i = 1/t [0, 1] = [0, 1/t]$. Sea $tilde(s)_(n, t) (x) := s_n (t x)$. Se tiene que $(tilde(s)_(n, t))_n$ es una sucesión de funciones simples, tal que

1') $tilde(s)_(n, t) (x) <= f(t x)$ para todo $x in [0, 1/t]$ y todo $n in NN$,

2') $0 <= tilde(s)_(n, t) (x) <= tilde(s)_(n+1, t) (x)$ para todo $x in [0, 1/t]$ y todo $n in NN$,

3') $lim_(n -> +infinity) tilde(s)_(n, t) (x) = f(t x)$ para todo $x in [0, 1/t]$.

Como $tilde(f) (x) = f(t x)$ es límite de simples, resulta que $tilde(f)$ es medible. Para probar $(*)$, seguimos los siguientes pasos:

I) Si $f = chi_A$, con $A subset.eq [0, 1]$ medible,
$
integral_([0, 1/t]) f(t x) dif mu (x) &= integral_([0, 1/t]) chi_A (t x) dif mu (x) = integral_([0, 1/t]) chi_(1/t A) (x) dif mu (x) \
&= mu (1/t A) = 1/t mu (A) = 1/t integral_([0, 1]) f(x) dif mu (x),
$
donde $mu (1/t A) = 1/t mu (A)$ es el Ejercicio 14 de la Práctica 8.

II) Si $f = sum_(i = 1)^m a_i chi_(A_i)$ es simple,
$
integral_([0, 1/t]) f(t x) dif mu (x) &= integral_([0, 1/t]) sum_(i = 1)^m a_i chi_(A_i) (t x) dif mu (x) = sum_(i = 1)^m a_i integral_([0, 1/t]) chi_(1/t A_i) (x) dif mu (x) \
&= sum_(i = 1)^m a_i mu (1/t A_i) = sum_(i = 1)^m a_i 1/t mu (A_i) = 1/t sum_(i = 1)^m a_i mu (A_i) \
&= 1/t integral_([0, 1]) f(x) dif mu (x),
$
donde otra vez usamos el Ejercicio 14 de la Práctica 8 para $mu (1/t A_i) = 1/t mu (A_i)$.

III) Si $(s_n)_n$ es una sucesión de funciones simples cumpliendo 1), 2), 3), entonces $(tilde(s)_(n, t))_n$ es una sucesión de funciones cumpliendo 1'), 2'), 3'). Por el teorema de convergencia monótona,
$
integral_([0, 1/t]) f(x t) dif mu (x) &= integral_([0, 1/t]) lim_(n -> +infinity) tilde(s)_(n, t) (x) dif mu (x) \
&= lim_(n -> +infinity) integral_([0, 1/t]) tilde(s)_(n, t) (x) dif mu (x) quad "(convergencia monótona)" \
&= lim_(n -> +infinity) 1/t integral_([0, 1]) s_n (x) dif mu (x) quad "(por II)" \
&= 1/t integral_([0, 1]) lim_(n -> +infinity) s_n (x) dif mu (x) quad "(convergencia monótona)" \
&= 1/t integral_([0, 1]) f(x) dif mu (x).
$

Supongamos ahora que $f : [0, 1] -> RR$ es integrable. Podemos escribirla como $f = f_+ - f_-$, con $f_+, f_- : [0, 1] -> [0, +infinity)$ integrables. Entonces $f_+ (t x)$, $f_- (t x)$ son integrables en $[0, 1/t]$, y por el caso $f >= 0$, como $f(t x) = f_+ (t x) - f_- (t x)$,
$
integral_([0, 1/t]) f(t x) dif mu (x) &= integral_([0, 1/t]) [f_+ (t x) - f_- (t x)] dif mu (x) \
&= integral_([0, 1/t]) f_+ (t x) dif mu (x) - integral_([0, 1/t]) f_- (t x) dif mu (x) \
&= 1/t integral_([0, 1]) f_+ (x) dif mu (x) - 1/t integral_([0, 1]) f_- (x) dif mu (x) \
&= 1/t integral_([0, 1]) [f_+ (x) - f_- (x)] dif mu (x) = 1/t integral_([0, 1]) f(x) dif mu (x).
$
#align(right)[#square()]

_Nota_: que $f_+ (t x)$ y $f_- (t x)$ sean integrables en $[0, 1 \/ t]$ sale del caso $f >= 0$ ya probado: sus integrales valen $1/t integral_([0, 1]) f_plus.minus dif mu < infinity$. Esto es lo que da la integrabilidad de $f_t$ pedida en el enunciado.
