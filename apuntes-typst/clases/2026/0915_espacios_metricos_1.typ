// Clase práctica 2026 · 15/09/2026 (apunte tipeado de la cátedra, "Análisis Avanzado 15/09/2026. Espacios métricos, primera parte").
// Tags en `ejemplos/`: el Ejercicio 1 es `15/09-7` y el Ejercicio 2 es `15/09-8` (los tags `15/09-1`..`15/09-6` ya están asignados a los ejemplos de pizarrón de esta misma clase, en ejemplos/p3.typ).

= Espacios métricos, primera parte

== Notación y algunas definiciones

- Si $x in RR^n$, escribimos a sus coordenadas como $(x_1, dots, x_n)$.

- A menos que se indique lo contrario, a cualquier subconjunto de $RR^n$ le damos la distancia euclídea, es decir la distancia $d_2$, dada por
  $
  d_2 (x, y) := (sum_(j=1)^n (x_j - y_j)^2)^(1/2).
  $
  En particular, cuando tomamos límite sin aclarar la distancia, el límite es con respecto a esta distancia. Notemos que en el caso $n = 1$, esta es la distancia inducida por el módulo, es decir $d_2 (x, y) = abs(x - y)$.

- Si $(X, d)$ es un espacio métrico, $x in X$ y $r > 0$, denotamos $B_d (x, r)$ a la bola abierta de centro $x$ y radio $r$ con respecto a la métrica $d$, es decir que
  $
  B_d (x, r) = {y in X : d(x, y) < r}.
  $

- Si $(X, d)$ es un espacio métrico y $A subset.eq X$, el _diámetro_ $op("diam")_d (A)$ de $A$ con respecto a la métrica $d$ es $op("diam")_d (A) := sup_(x, y in A) d(x, y)$, y es o bien un número real no negativo o bien $infinity$.

_Observación 1_: Notemos que si tenemos un conjunto $X$ con dos métricas distintas $d$ y $D$, esto nos da dos espacios métricos $(X, d)$ y $(X, D)$. En particular, si tenemos un subconjunto $A subset.eq X$, podemos considerar su diámetro para la métrica $d$ o para la métrica $D$.

== Temas

Los temas de esta clase son:

- Espacios métricos. Concepto de métrica.
- Ejemplos de métricas.
- Diámetro de un conjunto en un espacio métrico.
- Bolas abiertas.

== Ejercicios

_Ejercicio 1_: Sea $n in NN$, $f : RR^n -> RR^n$ una función inyectiva, y sea $d : RR^n times RR^n -> [0, +infinity)$ una métrica en $RR^n$. Definimos
$
D_f (x, y) := d(f(x), f(y)) quad forall x, y in RR^n.
$

#[
  #set enum(numbering: "(i)")
  + Probar que $D_f$ es una métrica.
  + Probar que el resultado no vale si reemplazamos "inyectiva" por "sobreyectiva" en el enunciado.
]

_Solución_: (i) Para ver que $D_f$ es una métrica, hay que probar lo siguiente:

#[
  #set enum(numbering: "(1)")
  + $D_f (x, y) >= 0$ para todo $x, y in RR^n$.
  + $D_f (x, y) = 0$ si y sólo si $x = y$.
  + Para todos $x, y in RR^n$, se tiene que $D_f (x, y) = D_f (y, x)$.
  + Para todos $x, y, z in RR^n$, se tiene que
    $
    D_f (x, y) <= D_f (x, z) + D_f (y, z).
    $
]

(1) vale porque $d$ es una distancia, y por lo tanto es no negativa.

(2) Si $x = y$, entonces $D_f (x, y) = d(f(x), f(x)) = 0$. Por otra parte, si $D_f (x, y) = 0$, entonces $f(x) = f(y)$ (porque $d$ es una métrica). Como $f$ es inyectiva, se sigue que $x = y$.

(3) Sean $x, y in RR^n$. Como $d$ es una métrica, tenemos que $D_f (x, y) = d(f(x), f(y)) = d(f(y), f(x)) = D_f (y, x)$.

(4) Sean $x, y, z in RR^n$. Nuevamente, usando que $d$ es una distancia obtenemos
$
D_f (x, y) = d(f(x), f(y)) <= d(f(x), f(z)) + d(f(z), f(y)) = D_f (x, z) + D_f (z, y).
$

(ii) Si $f$ no es inyectiva, entonces existen $x, y in RR^n$ tales que $x != y$ pero $f(x) = f(y)$. Esto implica que $D_f (x, y) = 0$, y por lo tanto, la función $D_f$ no es una métrica. Luego, para probar que el resultado no vale para funciones sobreyectivas, es suficiente con probar que existe $f : RR^n -> RR^n$ que es sobreyectiva pero no inyectiva. Eso puede hacerse de la siguiente manera: primero notemos que como
$
RR^n without {0}
$
es coordinable con $RR^n$, existe $g : RR^n without {0} -> RR^n$ biyectiva. Fijamos cualquier $z in RR^n$ y definimos $f : RR^n -> RR^n$ como
$
f(x) := cases(
  g(x) & " si " x != 0";",
  z & " si " x = 0.
)
$
Como $g$ es sobreyectiva, existe $y in RR^n without {0}$ tal que $f(y) = z$. Luego, $f(y) = g(y) = z = f(0)$, y entonces $f$ no es inyectiva.

Por otra parte, como $g$ es sobreyectiva, también lo es $f$. #align(right)[#square()]

_Observación 2_: Notemos que:

- Para la solución del Ejercicio 1, punto (i), podríamos haber reemplazado $RR^n$ por cualquier conjunto no vacío $X$.
- Para la solución del Ejercicio 1, punto (ii), podríamos haber reemplazado $RR^n$ por cualquier conjunto infinito $X$. Ejercicio: ver qué pasa si el conjunto $X$ es finito.
- En la solución del Ejercicio 1, punto (ii), probamos la recíproca de (i): en efecto, probamos (por el contrarrecíproco) que si $D_f$ es una métrica, entonces $f$ es inyectiva.

_Ejercicio 2_: Sea $(X, d)$ un espacio métrico. Definimos $tilde(d) : X times X -> [0, +infinity)$ como
$
tilde(d) (x, y) := op("mín") {1, d(x, y)}.
$
Probar que

#[
  #set enum(numbering: "(i)")
  + $tilde(d)$ es una métrica.
  + Para todo $x in X$ y todo $r > 0$, $B_d (x, r) subset.eq B_(tilde(d)) (x, r)$.
  + Sea $0 < r <= 1$. Entonces $B_d (x, r) = B_(tilde(d)) (x, r)$.
  + Para todo $x in X$ y todo $r > 0$, se tiene que
    $
    B_(tilde(d)) (x, op("mín") {r, 1}) subset.eq B_d (x, r).
    $
  + Sea $r > 1$. Supongamos que $X = RR$ y $d$ es el módulo. Calcular el diámetro de la bola abierta $B_(tilde(d)) (0, r)$ en el espacio métrico $(RR, tilde(d))$ y en el espacio métrico $(RR, d)$.
]

_Solución_: (i) Como en el ejercicio anterior, tenemos que probar lo siguiente:

#[
  #set enum(numbering: "(a)")
  + $tilde(d) (x, y) >= 0$ para todo $x, y in X$.
  + $tilde(d) (x, y) = 0$ si y sólo si $x = y$.
  + Para todos $x, y in X$ se tiene que $tilde(d) (x, y) = tilde(d) (y, x)$.
  + Para todos $x, y, z in X$, se tiene que
    $
    tilde(d) (x, y) <= tilde(d) (x, z) + tilde(d) (y, z).
    $
]

(a) es claro porque $tilde(d)$ es el mínimo entre dos números no negativos.

(b) Si $x = y$, entonces $d(x, y) = 0$, y por lo tanto, también $tilde(d) (x, y) = 0$. Por otra parte, si $tilde(d) (x, y) = 0$, el mínimo entre $d(x, y)$ y $1$ es cero, lo que implica que $d(x, y) = 0$, y entonces $x = y$ porque $d$ es una métrica.

(c) Dados $x, y in X$, como $d$ es una métrica se tiene que
$
tilde(d) (x, y) = op("mín") {1, d(x, y)} = op("mín") {1, d(y, x)} = tilde(d) (y, x).
$

(d) Dados $x, y, z in X$, consideremos los dos casos posibles:

_Caso 1_. Si $tilde(d) (x, z) = 1$ o $tilde(d) (z, y) = 1$, entonces
$
tilde(d) (x, y) <= 1 <= tilde(d) (x, z) + tilde(d) (z, y).
$

_Caso 2_. Si $tilde(d) (x, z) = d(x, z)$ y $tilde(d) (z, y) = d(z, y)$, entonces
$
tilde(d) (x, y) <= d(x, y) <= d(x, z) + d(z, y) = tilde(d) (x, z) + tilde(d) (z, y).
$

Como estos son todos los casos posibles, hemos completado la prueba de (d), y por lo tanto, también de (i).

(ii) Probemos la inclusión: Dados $x in X$, $r > 0$ e $y in B_d (x, r)$, se tiene que
$
tilde(d) (x, y) = op("mín") {1, d(x, y)} <= d(x, y) < r,
$
así que $y in B_(tilde(d)) (x, r)$.

(iii) Por (ii), ya tenemos una inclusión. Probemos la otra: sea $y in B_(tilde(d)) (x, r)$. Entonces
$
op("mín") {1, d(x, y)} < r <= 1.
$
Se sigue que $op("mín") {1, d(x, y)} = d(x, y)$. Por lo tanto, $d(x, y) = tilde(d) (x, y) < r$, lo que implica que $y in B_d (x, r)$, y concluye la prueba de la inclusión que faltaba.

(iv) Fijemos $x in X$ y $r > 0$. Aplicando (iii), obtenemos
$
B_(tilde(d)) (x, op("mín") {r, 1}) = B_d (x, op("mín") {r, 1}) subset.eq B_d (x, r).
$

(v) Notemos que en este caso, para todo $x in RR$ se tiene que $tilde(d) (x, 0) <= 1 < r$. Por lo tanto $B_(tilde(d)) (0, r) = RR$. Entonces tenemos que
$
op("diam")_d (B_(tilde(d)) (0, r)) = op("diam")_d (RR) = sup_(x, y in RR) abs(x - y) = infinity.
$
Por otra parte,
$
op("diam")_(tilde(d)) (B_(tilde(d)) (0, r)) = op("diam")_(tilde(d)) (RR) = sup_(x, y in RR) op("mín") {1, abs(x - y)} = 1.
$
#align(right)[#square()]

_Nota_: en el apunte, la primera igualdad de (v) aparece tipeada como "$op("diam")_d (B_(tilde(d))) (0, r))$", con un paréntesis de más; lo que se calcula es $op("diam")_d (B_(tilde(d)) (0, r))$, como está escrito arriba.
