// Notas docentes 2025 · octubre de 2025 (notas tipeadas, "Clase AA — Compactos").
// Clase 7 de la transcripción: sus ejercicios llevan el tag `C7-{k}` en `ejemplos/`.
#import "../utils.typ": sublema

= Compactos

_Definición_: Un espacio métrico $K$ se dice _compacto_ si para toda sucesión $(x_n)_(n in NN) subset.eq K$ existe alguna subsucesión $(x_(n_k))_(k in NN)$ convergente a algún $x in K$.

_Ejercicio 1_: Mostrar que dados finitos espacios compactos ${(K_i, d_i)}_(1 <= i <= n)$, su producto $product_(i = 1)^n K_i$ con la métrica
$
d_infinity ((x_1, dots, x_n), (y_1, dots, y_n)) := max_(1 <= i <= n) d_i (x_i, y_i)
$
es compacto.

_Res_: Vamos a probar por definición. Querríamos probar que dada una sucesión $(x_(1 k), x_(2 k), dots, x_(n k))_k subset.eq product_(i = 1)^n K_i$, la misma admite alguna subsucesión convergente. Esto se puede hacer, pero nos estamos complicando de más. Lo que vamos a hacer es probar el resultado para el caso $n = 2$ y después hacer inducción, siguiendo una estrategia similar a la que hicimos en su momento para probar que la unión de $n$ cerrados es cerrada.

Observemos entonces que en el caso $n = 2$ este espacio es conocido: es el espacio producto con la métrica $d_infinity$ del que hablamos varias veces. Pasamos entonces a probar el resultado, por definición.

Sea $(x_n, y_n)_(n in NN) subset.eq K_1 times K_2$. Queremos encontrar alguna subsucesión convergente $(x_(n_k), y_(n_k))_k$. Recordemos que una sucesión en este espacio es convergente si y sólo si todas sus coordenadas lo son.

#sublema(titulo: "Comentario del docente: el error común")[
  Una primera estrategia sería quizás extraer una subsucesión convergente $(x_(n_k))_k$ de $(x_n)_n$ (cosa que podemos hacer por ser $K_1$ compacto), extraer otra subsucesión convergente $(y_(n_k))_k$ de $(y_n)_n$, y considerar $(x_(n_k), y_(n_k))_k$. *Pero esto está mal.* ¿Por qué? Porque estamos asumiendo que las subsucesiones son las mismas. Fíjense que podría ser el caso de que la subsucesión convergente de $(x_n)_n$ sea $(x_(2n))_n$ y la de $(y_n)_n$ fuera $(y_(2n + 1))_n$, y en ese caso no habría forma de quedarse con una subsucesión de $(x_n, y_n)_n$ que tome valores pares en el subíndice de la primera coordenada e impares en el subíndice de la segunda. El error vino de tomar el mismo subíndice $k$ para ambas subsucesiones, y es común, así que tengan cuidado.
]

Hay que hacer algo un poco más refinado: vamos a tomar una subsucesión convergente de la primera coordenada y, _sobre esos índices_, vamos a tomar una subsucesión convergente de la segunda coordenada. Lo escribimos.

Sea $(x_n, y_n)_(n in NN) subset.eq K_1 times K_2$ una sucesión. Como $(x_n)_n subset.eq K_1$ está contenida dentro de un compacto, $(x_n)_n$ admite una subsucesión $(x_(n_k))_k$ convergente. Ahora $(y_(n_k))_k subset.eq K_2$ es una sucesión contenida en un compacto, y por lo tanto admite una subsucesión $(y_(n_(k_j)))_j$ convergente. Además, $(x_(n_(k_j)))_j$ es una subsucesión de $(x_(n_k))_k$, que era convergente, y por lo tanto es convergente. Por lo tanto, como ambas coordenadas convergen, $(x_(n_(k_j)), y_(n_(k_j)))_j$ es una sub-sub-sucesión convergente, y en particular una subsucesión convergente, como queríamos encontrar. Esto prueba el caso $n = 2$.

Procedemos ahora por inducción. Supongamos que el producto de $n$ compactos es compacto. Queremos ver que el producto de $n + 1$ compactos es compacto. Sean $K_1, dots, K_(n + 1)$ compactos. Tenemos que
$
product_(i = 1)^(n + 1) K_i = product_(i = 1)^n K_i times K_(n + 1).
$
Esto es un producto de dos compactos, ya que el primer factor es compacto por hipótesis inductiva. Como ya probamos que el producto de dos compactos es compacto, esto concluye la inducción. #align(right)[#square()]

_Nota (del docente)_: hay un detalle acá, y es que habría que probar que el producto es asociativo (es decir, que $(product_(i = 1)^n K_i) times K_(n + 1)$ con la $d_infinity$ "de dos factores" es el mismo espacio métrico que $product_(i = 1)^(n + 1) K_i$ con la $d_infinity$ de $n + 1$ factores), pero bueno... Comentario: vale la vuelta (si el producto es compacto, cada factor lo es), pero vamos a tener las herramientas recién el jueves.

_Ejercicio 2_: Sea $X$ un espacio métrico, $(x_n)_n subset.eq X$ una sucesión convergente con límite $x$. Probar que el conjunto ${x_n : n in NN} union {x}$ es un compacto (con la métrica inducida por la de $X$).

_Res_: Vamos, una vez más, por definición. Sea $(y_n)_n subset.eq {x_n : n in NN} union {x}$ una sucesión. Ojo que acá esta sucesión no tiene por qué ser una subsucesión de $(x_n)_n$: podría esta sucesión, por ejemplo, consistir en sólo el primer término de $(x_n)_n$, o sólo en $x$. Queremos ver entonces que $(y_n)_n$ admite alguna subsucesión convergente. Dividimos en dos casos:

- Si $(y_n)_n$ toma sólo finitos valores ${y_(j_1), y_(j_2), dots, y_(j_n)}$, entonces alguno de estos valores debe ocurrir infinitas veces. Esto es, hay algún $j_i$ tal que para todo $k$ existe $n >= k$ tal que $y_(n_k) = y_(j_i)$. Tomando la subsucesión $(y_(n_k))_k$ (que es constante) se obtiene lo pedido.

- Si $(y_n)_n$ toma infinitos valores distintos, inductivamente para cada $k$ debe haber algún $n_k >= k$, $n_k >= n_(k - 1)$, tal que $y_(n_k) = x_(K_k)$ para cierto $K_k >= k$, $K_k >= K_(k - 1)$. Si no ven por qué que $(y_n)_n$ tome infinitos valores distintos implica lo que digo, ahí vamos, pero primero veamos que esto termina el problema: si $y_(n_k) = x_(K_k)$, entonces $(y_(n_k))_k$ es efectivamente una subsucesión de $(y_n)_n$, pero además es una subsucesión de $(x_n)_n$, y una subsucesión de una sucesión convergente es convergente. Además, $y_(n_k)$ tiende a $x$, que está en nuestro conjunto.

  Sobre la otra afirmación, es cuestión de ver los cuantificadores: supongamos que no; entonces hay algún $k in NN$ para el cual no hay ningún $n$ y $K_k$ tal que $y_n = x_(K_k)$. Esto significa que el conjunto ${y_n : n >= k, n >= n_(k - 1)}$ no interseca al conjunto ${x_K : K >= k, K >= K_(k - 1)}$, y por lo tanto está incluido en su complemento, que es finito, lo cual es absurdo. #align(right)[#square()]

_Nota_: para que $(x_(K_k))_k$ sea una subsucesión de $(x_n)_n$ hace falta $K_k > K_(k - 1)$ (estricto), no sólo $K_k >= K_(k - 1)$; como los $y_(n_k)$ se eligen con valores distintos dos a dos, los $K_k$ resultan distintos y se los puede tomar estrictamente crecientes. En el absurdo final, el complemento de ${x_K : K >= k, K >= K_(k - 1)}$ dentro de ${x_n : n in NN} union {x}$ es ${x_1, dots, x_(K - 1), x}$ con $K = max{k, K_(k - 1)}$ (finito), así que la cola ${y_n : n >= max{k, n_(k - 1)}}$ toma finitos valores; junto con los finitos términos anteriores, $(y_n)_n$ tomaría finitos valores en total, contra la hipótesis del caso.

_Ejercicio 3_: Sea $X$ un espacio métrico. Mostrar que $F subset.eq X$ es cerrado si y sólo si para todo compacto $K$, $K inter F$ es compacto.

_Res_: La ida es un ejercicio de la guía (?).

#sublema(titulo: "Comentario del docente: probar un \"para todo\" por contrarrecíproco")[
  Para la vuelta, casi siempre cuando uno quiere probar un "para todo" conviene probar por contrarrecíproco. La ventaja es que cuando neguemos el enunciado vamos a tener que probar un "existe", y eso en principio es más fácil porque se puede hacer por construcción.
]

Veamos: supongamos que $F$ no es cerrado; queremos ver entonces que hay algún compacto $K$ tal que $K inter F$ no es compacto. Como estamos trabajando con sucesiones, nos va a convenir usar la caracterización de cerrado por sucesiones: un conjunto $F$ es cerrado si y sólo si para toda sucesión convergente $(x_n)_n subset.eq F$, $lim_(n -> infinity) x_n in F$. Un conjunto $F$ entonces _no_ es cerrado si hay una cierta sucesión convergente $(x_n)_n subset.eq F$ tal que $lim_(n -> infinity) x_n in.not F$. ¿Qué compacto vamos a tomar entonces?
$
K = {x_n : n in NN} union {lim_(n -> infinity) x_n}.
$
Tenemos entonces que $K inter F = {x_n : n in NN}$, que no es un compacto, pues la sucesión $(x_n)_n$ no tiene ninguna subsucesión convergente (en $K inter F$). #align(right)[#square()]

_Nota_: la ida ("$F$ cerrado y $K$ compacto $=>$ $K inter F$ compacto") es el Ejercicio 4 de la Práctica 5 (intersección de una familia de cerrados con al menos un compacto). Que $K$ es compacto es el Ejercicio 2 de esta clase. Para la última afirmación hace falta además que $x_n != lim x_m$ para todo $n$ (vale porque el límite no está en $F$ y los $x_n$ sí) y que toda subsucesión de $(x_n)_n$ converge al mismo límite, que no está en $K inter F$; si $(x_n)_n$ tomara un valor infinitas veces, ese valor sería el límite, lo cual tampoco puede pasar.
