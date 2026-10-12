// Clase práctica 2026 · 17/09/2026 (apunte tipeado de la cátedra, "Ejercicios para las clases — Clase 11: 17/09").
// Sus ejercicios llevan el tag `17/09-{k}` en `ejemplos/` (k = número de ejercicio del apunte).

= Abiertos y cerrados (Clase 11)

== Temas

- Puntos interiores y conjuntos abiertos.
- Puntos de adherencia y conjuntos cerrados.

== Ejercicios

_Recordatorio_: conjuntos abiertos. Sea $(X, d)$ un espacio métrico y $A subset.eq X$. Un punto $x in A$ es _interior_ a $A$ si existe $r > 0$ tal que
$
B_d (x, r) subset.eq A.
$
El conjunto de puntos interiores de $A$ se denota por $A^circle$ y siempre se cumple
$
A^circle subset.eq A.
$
El conjunto $A$ es _abierto_ si todos sus puntos son interiores, es decir,
$
A "es abierto" quad arrow.l.r.double quad A^circle = A.
$

_Ejercicio 1_: Sean $(X, d_1)$ e $(Y, d_2)$ espacios métricos. En $X times Y$ consideremos la métrica
$
d((x_1, y_1), (x_2, y_2)) = d_1 (x_1, x_2) + d_2 (y_1, y_2).
$
Sean $A subset.eq X$ y $B subset.eq Y$. Probar que $(A times B)^circle = A^circle times B^circle$.

Deducir que, si $A$ y $B$ son abiertos, entonces $A times B$ es abierto en $X times Y$.

_Observación_: En la inclusión $(supset.eq)$ hay que elegir el radio $r$ con cuidado, como en clase. Una tentación frecuente es tomar $r = r_1 + r_2$, imitando la forma de la métrica. El siguiente ejemplo muestra que esa elección _no_ funciona.

_Ejemplo_: Sea $X = Y = RR$ con $d_1 = d_2 = abs(dot.c)$, de modo que
$
d((x_1, y_1), (x_2, y_2)) = abs(x_1 - x_2) + abs(y_1 - y_2).
$
Tomemos
$
A = (-1, 1), quad B = (-2, 2), quad (a, b) = (0, 0), quad r_1 = 1, quad r_2 = 2.
$
Se cumple $B_(d_1) (0, 1) = (-1, 1) subset.eq A$ y $B_(d_2) (0, 2) = (-2, 2) subset.eq B$, así que $r_1$ y $r_2$ son radios admisibles en cada coordenada. Sin embargo, con $r_1 + r_2 = 3$ el punto
$
p = (3/2, 0) quad "cumple" quad d(p, (0, 0)) = abs(3/2) + abs(0) = 3/2 < 3,
$
o sea $p in B_d ((0, 0), r_1 + r_2)$, pero $3/2 in.not A = (-1, 1)$ y por lo tanto $p in.not A times B$. Es decir
$
B_d ((0, 0), r_1 + r_2) subset.eq.not A times B.
$

_Ejercicio 2_: Considerar el conjunto
$
A = {(x, y) in RR^2 : x in QQ}.
$
Decidir si $A$ es abierto. Calcular $A^circle$ con la métrica $d((x_1, y_1), (x_2, y_2)) = abs(x_1 - x_2) + abs(y_1 - y_2)$.

_Recordatorio_: clausura y conjuntos cerrados. Sea $(X, d)$ un espacio métrico y $A subset.eq X$. Un punto $x in X$ es _de adherencia_ de $A$ si
$
B(x, r) inter A != emptyset quad "para todo" r > 0.
$
La _clausura_ de $A$, denotada $overline(A)$, es el conjunto de todos sus puntos de adherencia y siempre se cumple
$
A subset.eq overline(A).
$
El conjunto $A$ es _cerrado_ si contiene todos sus puntos de adherencia, es decir,
$
A "es cerrado" quad arrow.l.r.double quad A = overline(A).
$

_Ejercicio 3_: Sea $(X, d)$ un espacio métrico. Dados $a in X$ y $r in RR_(> 0)$, llamamos _bola cerrada_ de centro $a$ y radio $r$ al conjunto
$
B[a, r] = {x in X : d(x, a) <= r}.
$

#[
#set enum(numbering: "(i)")
+ Probar que
  $
  overline(B(a, r)) subset.eq B[a, r].
  $
+ Dar un ejemplo de un espacio métrico y una bola abierta $B(a, r)$ cuya clausura no sea $B[a, r]$.
]

_Ejercicio 4_: Sea $(X, d)$ un espacio métrico y sea $A subset.eq X$. Probar que
$
x in overline(A) quad arrow.l.r.double quad "existe una sucesión" (x_n)_(n in NN) subset.eq A "tal que" x_n -> x.
$

_Solución_:

$arrow.l.double)$ Supongamos que existe $(x_n)_(n in NN) subset.eq A$ con $x_n -> x$. Por definición de convergencia de una sucesión en un espacio métrico, dado $epsilon > 0$ existe $n_0 in NN$ tal que $d(x_(n_0), x) < epsilon$, o sea $x_(n_0) in B(x, epsilon)$. Como además $x_(n_0) in A$, se tiene $B(x, epsilon) inter A != emptyset$. Como $epsilon > 0$ era arbitrario, $x in overline(A)$.

$=>)$ Supongamos $x in overline(A)$. Para cada $n in NN$ tomando $epsilon = 1/n$: obtenemos $B(x, 1/n) inter A != emptyset$, de modo que podemos elegir
$
x_n in B(x, 1/n) inter A.
$
Por construcción $(x_n)_(n in NN) subset.eq A$ y
$
0 <= d(x_n, x) < 1/n -->_(n -> infinity) 0,
$
así que, por el criterio del sándwich, $d(x_n, x) -> 0$, es decir $x_n -> x$. #align(right)[#square()]

_Ejercicio 5_: Sea $(RR^2, d)$ e.m. Consideramos el siguiente conjunto,
$
A = {(1/n, 1/m) : n, m in NN} subset.eq RR^2.
$
Calcular la clausura $overline(A)$.

$(*)$ $d((x_1, y_1), (x_2, y_2)) = abs(x_1 - x_2) + abs(y_1 - y_2)$.

_Solución_:

_Estrategia_. Usamos únicamente el Ejercicio 4: un punto está en la clausura _si y sólo si_ es límite de una sucesión de puntos de $A$. Entonces: proponemos el candidato, verificamos la inclusión $supset.eq$ exhibiendo sucesiones explícitas, y la inclusión $subset.eq$ analizando qué límites puede tener una sucesión genérica de $A$.

Llamemos
$
C = A union {(1/n, 0) : n in NN} union {(0, 1/m) : m in NN} union {(0, 0)}.
$

_Herramienta_: En $(RR^2, d)$ con $d((x_1, y_1), (x_2, y_2)) = abs(x_1 - x_2) + abs(y_1 - y_2)$ vale
$
abs(x_k - x) <= d((x_k, y_k), (x, y)) = abs(x_k - x) + abs(y_k - y), quad abs(y_k - y) <= d((x_k, y_k), (x, y)),
$
de donde $(x_k, y_k) -> (x, y)$ si y sólo si $x_k -> x$ e $y_k -> y$. Es decir: _convergencia en $d$ = convergencia coordenada a coordenada_.

*Afirmamos que $overline(A) = C$.*

$(supset.eq)$ Alcanza con exhibir, para cada punto de $C$, una sucesión contenida en $A$ que converja a él; por el Ejercicio 4.

- Si $p in A$, tomamos la sucesión constante $x_k = p$. Luego $A subset.eq overline(A)$.
- Fijado $n in NN$, la sucesión $(1/n, 1/k)_(k in NN) subset.eq A$ cumple $(1/n, 1/k) -> (1/n, 0)$, porque $d((1/n, 1/k), (1/n, 0)) = 0 + 1/k -> 0$.
- Simétricamente, fijado $m in NN$, la sucesión $(1/k, 1/m)_(k in NN) subset.eq A$ converge a $(0, 1/m)$, ya que la distancia vale $1/k -> 0$.
- La sucesión diagonal $(1/k, 1/k)_(k in NN) subset.eq A$ converge a $(0, 0)$, pues $d((1/k, 1/k), (0, 0)) = 2/k -> 0$.

Por lo tanto $C subset.eq overline(A)$.

$(subset.eq)$ Sea $(x, y) in overline(A)$. Por el Ejercicio 4 existe una sucesión contenida en $A$ que converge a $(x, y)$; escribámosla como
$
(1/n_k, 1/m_k) -->_(k -> infinity) (x, y), quad n_k, m_k in NN.
$
Esto equivale a
$
1/n_k -> x quad "y" quad 1/m_k -> y.
$
Veamos que necesariamente $x in {0} union {1/n : n in NN}$, distinguiendo dos casos según la sucesión de índices $(n_k)_(k in NN) subset.eq NN$:

- $(n_k)$ _no está acotada_. Entonces hay una subsucesión $n_(k_j) -> infinity$, luego $1/n_(k_j) -> 0$. Como toda subsucesión de una sucesión convergente converge al mismo límite, $x = 0$.
- $(n_k)$ _está acotada_. Entonces $(n_k)$ toma finitos valores, así que algún valor $n in NN$ se repite infinitas veces: hay una subsucesión constante $n_(k_j) = n$, es decir $1/n_(k_j) = 1/n$ para todo $j$. Pasando al límite, $x = 1/n$.

El mismo argumento aplicado a $(m_k)$ da $y in {0} union {1/m : m in NN}$.

Combinando ambas coordenadas, las cuatro posibilidades son:
$
(x, y) = (1/n, 1/m) in A, quad (x, y) = (1/n, 0), quad (x, y) = (0, 1/m), quad (x, y) = (0, 0),
$
y en todos los casos $(x, y) in C$. Por lo tanto $overline(A) subset.eq C$.

En resumen,
$
overline(A) = A union {(1/n, 0)}_(n in NN) union {(0, 1/m)}_(m in NN) union {(0, 0)} = ({0} union {1/n}_n) times ({0} union {1/m}_m).
$
#align(right)[#square()]
