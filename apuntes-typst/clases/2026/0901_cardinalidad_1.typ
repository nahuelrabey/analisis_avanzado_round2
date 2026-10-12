// Clase práctica 2026 · 01/09/2026 (apunte tipeado de la cátedra, "Análisis Avanzado 01/09/2026. Cardinalidad (parte 1)").
// Sus ejercicios llevan el tag `01/09-{k}` en `ejemplos/` (k = número de ejercicio del apunte).

= Cardinalidad (parte 1)

== Notación y definiciones

- Dado un conjunto $A$, $cal(P)(A)$ denota el conjunto de partes de $A$, es decir el conjunto de subconjuntos de $A$.
- Dados dos conjuntos $A, B$ no vacíos, $A^B$ denota el conjunto de todas las funciones de $B$ a $A$.
- Se dice que una función $f : A -> B$ es _uno a uno_ (también lo podemos escribir "1 a 1" o "1-1") si es inyectiva (es decir, "uno a uno" significa lo mismo que "inyectiva").

== Ejercicios

_Ejercicio 1_: Sean $A$, $B$, $C$ y $D$ conjuntos no vacíos tales que $A tilde.op B$ y $C tilde.op D$. Probar lo siguiente:

#[
#set enum(numbering: "(a)")
+ $A times C tilde.op B times D$.
+ $A^C tilde.op B^D$.
+ $cal(P)(A) tilde.op cal(P)(B)$.
]

_Solución_: Por hipótesis, existen funciones biyectivas $phi : A -> B$ y $psi : C -> D$.

(a) Buscamos una función biyectiva de $A times C$ a $B times D$. Para eso, definimos
$
T(a, c) := (phi(a), psi(c)) quad forall (a, c) in A times C.
$
Para probar que $T$ es biyectiva, podemos usar una de las siguientes estrategias:

- Probar que $T$ es inyectiva y sobreyectiva.
- Definir una función $L : B times D -> A times C$ y probar que $L$ es la inversa de $T$. En otras palabras, esto es probar que
  $
  (L compose T)(a, c) &= (a, c) quad forall (a, c) in A times C quad "y" \
  (T compose L)(b, d) &= (b, d) quad forall (b, d) in B times D.
  $

En este caso, vamos a usar la primera estrategia. Queda como ejercicio resolverlo usando la segunda, chequeando que la función
$
L(b, d) := (phi^(-1)(b), psi^(-1)(d)) quad forall (b, d) in B times D
$
es la inversa de $T$.

Volviendo a la estrategia que elegimos en este caso, veamos primero que $T$ es inyectiva: sean $(a, c)$ y $(x, y)$ en $A times C$ tales que $T(a, c) = T(x, y)$. Por definición de $T$,
$
(phi(a), psi(c)) = (phi(x), psi(y)).
$
Luego, $phi(a) = phi(x)$ y $psi(c) = psi(y)$. Como $phi$ y $psi$ son ambas 1-1, se sigue que $a = x$ y $c = y$, y luego $(a, c) = (x, y)$. Esto quiere decir que $T$ es 1 a 1.

Ahora veamos que $T$ es sobreyectiva: dado $(b, d) in B times D$, buscamos $(a, c) in A times C$ tal que $T(a, c) = (b, d)$. Considerando la fórmula que define $T$, proponemos $a := phi^(-1)(b)$ y $c := psi^(-1)(d)$. Tenemos que
$
T(a, c) := (phi(a), psi(c)) = ((phi compose phi^(-1))(b), (psi compose psi^(-1))(d)) = (b, d).
$
Hemos probado que $T$ es sobreyectiva, lo que termina la solución del punto (a).

(b) Aquí también podemos usar cualquiera de las dos estrategias que mencionamos en el punto (a). En este caso, vamos a usar la segunda de ellas. En otras palabras, vamos a definir dos funciones $T : A^C -> B^D$ y $L : B^D -> A^C$, y luego probaremos que $T$ es la inversa de $L$ (y por lo tanto, también que $L$ es la inversa de $T$). De aquí se seguirá que ambas funciones son biyectivas, lo que implica que los conjuntos $A^C$ y $B^D$ tienen el mismo cardinal.

Recordemos que dados dos conjuntos no vacíos cualesquiera $X$ e $Y$, y dos funciones $F : X -> Y$ y $G : Y -> X$, la función $G$ es inversa de $F$ (y viceversa) si y sólo si vale lo siguiente:
$
(F compose G)(y) = y quad forall y in Y quad "y" quad (G compose F)(x) = x quad forall x in X.
$
Vamos a construir ahora las funciones que buscamos, para lo cual usaremos las funciones $phi$ y $psi$ que fijamos al principio del ejercicio.

Primero, buscamos $T : A^C -> B^D$. Observemos que para cada función $f$ de $C$ a $A$, $T(f)$ debe ser una función de $D$ a $B$. Componiendo adecuadamente, definimos para cada $f in A^C$,
$
T(f) := phi compose f compose psi^(-1).
$

_Ejercicio (para el lector)_: chequear que $T(f)$ es una función de $D$ a $B$.

De manera similar, definimos para cada $g in B^D$,
$
L(g) := phi^(-1) compose g compose psi.
$

_Ejercicio (para el lector)_: chequear que $L(g)$ es una función de $C$ a $A$.

Veamos ahora que se cumplen las condiciones que mencionamos anteriormente, es decir las que garantizan que $L$ y $T$ son inversas una de la otra. Dada $f in A^C$, tenemos que
$
(L compose T)(f) = L(phi compose f compose psi^(-1)) = phi^(-1) compose phi compose f compose psi^(-1) compose psi = f,
$
puesto que $psi^(-1) compose psi$ es la identidad sobre $C$ y $phi^(-1) compose phi$ es la identidad sobre $A$. De la misma manera, dada $g in B^D$, tenemos que
$
(T compose L)(g) = T(phi^(-1) compose g compose psi) = phi compose phi^(-1) compose g compose psi compose psi^(-1) = g.
$
Hemos probado que $L$ es la inversa de $T$ (y viceversa), y por lo tanto, que $A^C tilde.op B^D$.

(c) Nuevamente, vamos a definir $T : cal(P)(A) -> cal(P)(B)$ y $L : cal(P)(B) -> cal(P)(A)$, y ver que son inversas una de la otra. Definimos para cada $E in cal(P)(A)$ y cada $V in cal(P)(B)$,
$
T(E) &:= {phi(e) : e in E}, \
L(V) &:= {phi^(-1)(v) : v in V}.
$
Notemos que como $phi$ es una función de $A$ a $B$, para cada subconjunto $E$ de $A$, se tiene que $T(E)$ es un subconjunto de $B$ (es decir que $T(E) in cal(P)(B)$, como queríamos), así que $T$ está bien definida como función de $cal(P)(A)$ a $cal(P)(B)$, y lo mismo (intercambiando los roles de $A$ y $B$) puede decirse de $L$. Ahora bien, dado $E subset.eq A$, se tiene que
$
(L compose T)(E) = L({phi(e) : e in E}) = {(phi^(-1) compose phi)(e) : e in E} = {e : e in E} = E,
$
y razonando de la misma manera, obtenemos que $(T compose L)(V) = V$ para todo $V subset.eq B$. Concluimos que $T$ y $L$ son inversas recíprocas (es decir, una de la otra), y por lo tanto, biyectivas. Esto prueba que $cal(P)(A) tilde.op cal(P)(B)$. #align(right)[#square()]

_Nota_: en el punto (c) el apunte cambia la letra de la biyección de $A$ en $B$ (escribe $phi.alt$ en lugar de la $phi$ fijada al comienzo); se trata de la misma función, y acá se mantiene $phi$.

_Ejercicio 2_: Probar que:

#[
#set enum(numbering: "(i)")
+ $NN times NN tilde.op NN$ y $QQ tilde.op NN$.
+ $cal(P)(NN times NN) tilde.op cal(P)(NN)$.
+ $\# cal(P)(NN) <= \# NN^NN <= \# cal(P)(NN times NN)$.
]

Concluir que $cal(P)(QQ) tilde.op cal(P)(NN) tilde.op NN^NN tilde.op QQ^NN tilde.op QQ^QQ$.

_Sugerencia_: usar el Ejercicio 1 y el Teorema de CBS.

_Solución_: (i) Veamos primero que dado $d >= 2$, se tiene que $NN tilde.op NN^d$ (sólo hace falta el caso $d = 2$ para este ejercicio, pero es de interés ver el caso general). Para eso, por el Teorema de Cantor-Bernstein-Schröder (CBS), alcanza con encontrar funciones inyectivas $phi : NN -> NN^d$ y $psi : NN^d -> NN$. Para la primera, definimos
$
phi(n) := (n, 1, dots, 1) in NN^d.
$
Queda como ejercicio demostrar que $phi$ es inyectiva.

Para la segunda, sea ${p_1, dots, p_d}$ un conjunto de $d$ números naturales primos distintos. Definimos
$
psi(n_1, dots, n_d) := product_(k=1)^d p_k^(n_k).
$
Veamos que $psi$ es inyectiva: si $psi(n_1, dots, n_d) = psi(l_1, dots, l_d)$, entonces
$
product_(k=1)^d p_k^(n_k) = product_(k=1)^d p_k^(l_k).
$
Por la unicidad de la descomposición en primos, se sigue que $n_k = l_k$ para todo $1 <= k <= d$, es decir que $(n_1, dots, n_d) = (l_1, dots, l_d)$. Hemos probado que $psi$ es inyectiva. Como dijimos, por CBS, se sigue que $NN tilde.op NN^d$.

Nuevamente por CBS y por lo recién visto, para ver que $NN tilde.op QQ$ alcanza con ver que $\#(NN) <= \#(QQ)$ y $\#(QQ) = \#(NN^3)$. Para lo primero, sea $J : NN -> QQ$ dada por $J(n) = n$ para todo $n in NN$, que es claramente inyectiva. Para definir una función inyectiva $T : QQ -> NN^3$, notemos que si $q in QQ_(> 0)$, entonces existen dos números naturales coprimos únicos $n, m in NN$ tales que $q = m/n$, mientras que si $q in QQ_(< 0)$, entonces existen dos números naturales coprimos únicos $n, m in NN$ tales que $q = -m/n$. Por lo tanto, podemos definir
$
T(m/n) &:= (n, m, 1), \
T(-m/n) &:= (n, m, 2), \
T(0) &:= (1, 1, 3),
$
si $m, n in NN$ son coprimos. Como todo número racional se escribe de forma única como $m/n$, o $-m/n$ con $n$ y $m$ naturales coprimos, o cero, $T$ está bien definida. Veamos que $T$ es inyectiva: si $T(x) = T(y)$, sean $a, b, c in NN$ tales que $T(x) = (a, b, c) = T(y)$. Si $c = 3$, entonces debe ser $x = y = 0$, porque para cualquier $q in QQ$, se sigue de la definición que la tercera coordenada de $T(q)$ es $3$ si y sólo si $q = 0$. Por otra parte, si $c = 2$, entonces se sigue de la definición de $T$ que existen $m_1, n_1$ naturales coprimos y $m_2, n_2$ naturales coprimos tales que
$
x &= -m_1/n_1, \
y &= -m_2/n_2.
$
Como $T(x) = T(y)$, se sigue que $m_1 = m_2$ y $n_1 = n_2$, así que $x = y$. De manera similar, si $c = 1$, entonces se sigue de la definición de $T$ que existen $m_1, n_1$ naturales coprimos y $m_2, n_2$ naturales coprimos tales que
$
x &= m_1/n_1, \
y &= m_2/n_2.
$
Como $T(x) = T(y)$, se sigue que $m_1 = m_2$ y $n_1 = n_2$, así que $x = y$.

Como hemos considerado todos los casos posibles (porque $c$ puede ser $3$, $2$ o $1$; la definición de $T$ no deja otra posibilidad), deducimos que $T$ es inyectiva. Esto completa la prueba de que $\#(QQ) <= \#(NN^3)$. Como $NN^3 tilde.op NN$ y $\#(NN) <= \#(QQ)$, por CBS esto termina la prueba de que $NN tilde.op QQ$.

_Nota_: el apunte anuncia "$\#(QQ) = \#(NN^3)$", pero lo que efectivamente prueba (y lo único que hace falta para aplicar CBS junto con $\#(NN) <= \#(QQ)$ y $NN^3 tilde.op NN$) es la desigualdad $\#(QQ) <= \#(NN^3)$, como dice la conclusión.

(ii) Por (i), se tiene que $NN times NN tilde.op NN$. Luego, por el Ejercicio 1 (visto en la clase práctica), se sigue que $cal(P)(NN times NN) tilde.op cal(P)(NN)$.

(iii) Para ver que $\#(cal(P)(NN)) <= \# NN^NN$, definimos la siguiente función $T : cal(P)(NN) -> NN^NN$. Para cada $A subset.eq NN$, $T(A)$ es la función de $NN$ a $NN$ dada por
$
T(A)(n) := cases(
  1 & " si " n in A,
  2 & " si " n in.not A.
)
$
Como para cada elemento $A$ de $cal(P)(NN)$, $T(A)$ es un elemento de $NN^NN$, la función $T$ es una función de $cal(P)(NN)$ a $NN^NN$. Para probar que $\#(cal(P)(NN)) <= \# NN^NN$, hay que mostrar que $T$ es inyectiva. Veámoslo: supongamos que $A, B subset.eq NN$ son tales que $T(A) = T(B)$. Vamos a probar que $A subset.eq B$ y que $B subset.eq A$. Primero supongamos que $n in A$. Entonces $T(A)(n) = 1$. Por lo tanto $T(B)(n) = 1$, lo que implica que $n in B$. Hemos probado que $A subset.eq B$. La prueba de que $B subset.eq A$ se hace por medio del mismo razonamiento, y solamente hay que intercambiar los roles de $A$ y de $B$. Por lo tanto, concluimos que $T$ es inyectiva, y $\#(cal(P)(NN)) <= \# NN^NN$.

Veamos ahora que $\# NN^NN <= \# cal(P)(NN times NN)$. Para eso, definimos la función de $NN^NN$ a $cal(P)(NN times NN)$ que envía cada elemento del conjunto de funciones $NN^NN$ a su gráfico. Más precisamente, definimos para cada $f in NN^NN$,
$
L(f) := {(n, f(n)) : n in NN}.
$
Veamos que $L$ es inyectiva: supongamos que $L(f) = L(g)$. Queremos ver que $f = g$. A tal fin, fijemos $k in NN$. Tenemos que $(k, f(k)) in L(f)$ por definición de $L$. Luego, por hipótesis, $(k, f(k)) in L(g) = {(n, g(n)) : n in NN}$. Por lo tanto, existe $n in NN$ tal que $(k, f(k)) = (n, g(n))$. Esto implica que $n = k$, y luego $f(k) = g(k)$. Como $k$ era arbitrario, concluimos que $f = g$, es decir que $L$ es inyectiva. Esto prueba que $\# NN^NN <= \# cal(P)(NN times NN)$.

Para terminar el ejercicio, aplicamos el Ejercicio 1: como $QQ tilde.op NN$, entonces $cal(P)(QQ) tilde.op cal(P)(NN)$, y $NN^NN tilde.op QQ^NN tilde.op QQ^QQ$. Resta ver que $cal(P)(NN) tilde.op NN^NN$, pero esto se sigue de que
$
\#(cal(P)(NN)) <= \# NN^NN <= \#(cal(P)(NN times NN)) limits(=)_(NN tilde.op NN times NN) \#(cal(P)(NN))
$
y el Teorema de CBS. #align(right)[#square()]
