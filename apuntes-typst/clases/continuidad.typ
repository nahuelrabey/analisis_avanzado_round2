// Notas docentes 2025 · clase del 23/10/2025 (manuscrito "Continuidad").
// Clase 6 de la transcripción: sus ejercicios llevan el tag `C6-{k}` en `ejemplos/`.
#import "../utils.typ": *

#show figure.where(kind: "frame"): set figure(numbering: none)
#show figure.where(kind: "frame"): set block(breakable: true)
#show: frame-style(styles.boxy)

= Continuidad

Sean $(X, d_1)$ e $(Y, d_2)$ espacios métricos. En $X times Y$ definimos
$
d_infinity ((x, y), (x', y')) = max{d_1 (x, x'), d_2 (y, y')}.
$

#sublema(titulo: [$d_infinity$ es una métrica en $X times Y$])[
  Notemos que $d_infinity$ es una métrica:

  - $d_infinity ((x, y), (x', y')) = 0$ si y sólo si $d_1 (x, x') = 0$ y $d_2 (y, y') = 0$. Como $d_1, d_2$ son métricas, $d_1 (x, x') = 0$ si $x = x'$ y $d_2 (y, y') = 0$ si $y = y'$. Concluimos que $d_infinity ((x, y), (x', y')) = 0$ si $(x, y) = (x', y')$.

  - $d_infinity ((x, y), (x', y')) = d_infinity ((x', y'), (x, y))$ (por simetría de $d_1, d_2$).

  - Como
    $
    d_1 (x, x') <= d_1 (x, z) + d_1 (z, x') quad "y" quad d_2 (y, y') <= d_2 (y, w) + d_2 (w, y'),
    $
    dado $(z, w) in X times Y$,
    $
    d_1 (x, x') &<= max{d_1 (x, z), d_2 (y, w)} + max{d_1 (z, x'), d_2 (w, y')} \
                &= d_infinity ((x, y), (z, w)) + d_infinity ((z, w), (x', y')),
    $
    y similarmente
    $
    d_2 (y, y') <= d_infinity ((x, y), (z, w)) + d_infinity ((z, w), (x', y')),
    $
    tenemos que
    $
    d_infinity ((x, y), (x', y')) &= max{d_1 (x, x'), d_2 (y, y')} \
                                  &<= d_infinity ((x, y), (z, w)) + d_infinity ((z, w), (x', y')).
    $
]

#ejemplo[Proyecciones de $X times Y$ y continuidad coordenada a coordenada (Clase 6 · Ejemplo 1)][C6-1][
  Sean $(X, d_1)$ e $(Y, d_2)$ espacios métricos. Pensamos a $X times Y$ con $d_infinity$.

  #set enum(numbering: "a)")
  + Probar que $pi_1 : X times Y -> X$, $(x, y) |-> x$, y $pi_2 : X times Y -> Y$, $(x, y) |-> y$ son continuas y abiertas, pero pueden *no ser cerradas*.
  + Sea $(Z, delta)$ un espacio métrico y sea $f : Z -> X times Y$ una aplicación. Probar que $f$ es continua si y sólo si $f_1 = pi_1 compose f$ y $f_2 = pi_2 compose f$ lo son.
]

#resolucion[
  *a)* Probemos que $pi_1$ es continua y abierta. Para ver que es continua, dado $(x_0, y_0) in X times Y$, podemos ver que dado $epsilon > 0$, existe $delta > 0$ tal que si $d_infinity ((x, y), (x_0, y_0)) < delta$ entonces
  $
  d_1 (pi_1 (x, y), pi_1 (x_0, y_0)) = d_1 (x, x_0) < epsilon.
  $
  Como
  $
  d_1 (x, x_0) <= max{d_1 (x, x_0), d_2 (y, y_0)} = d_infinity ((x, y), (x_0, y_0)), quad (*)
  $
  si $delta < epsilon$ garantizamos $(*)$.

  Para ver que $pi_1$ es abierta, tenemos que ver que *para todo abierto $U subset.eq X times Y$, $pi_1 (U)$ es abierto*. Notemos que si probamos que *para toda bola $B(x, r)$, $pi_1 (B(x, r))$ es abierto*, entonces se sigue la misma conclusión para todo abierto $U$: para todo $x in U$, existe $r_x > 0$ tal que $B(x, r_x) subset.eq U$. Entonces $U = union.big_(x in U) B(x, r_x)$, por lo tanto
  $
  pi_1 (U) = pi_1 (union.big_(x in U) B(x, r_x)) = union.big_(x in U) pi_1 (B(x, r_x))
  $
  y es unión de abiertos, por lo tanto es abierto.

  Sea $(x_0, y_0) in X times Y$ y $r > 0$. Entonces
  $
  B((x_0, y_0), r) &= {(x, y) : d_infinity ((x, y), (x_0, y_0)) < r} \
                   &= {(x, y) : max{d_1 (x, x_0), d_2 (y, y_0)} < r} \
                   &= {(x, y) : d_1 (x, x_0) < r " y " d_2 (y, y_0) < r}.
  $
  Por otro lado,
  $
  pi_1 (B((x_0, y_0), r)) = {x in X : "existe " y in Y " con " d_1 (x, x_0) < r " y " d_2 (y, y_0) < r}.
  $
  _(Dibujo: en $RR^2$, el disco de centro $(x_0, y_0)$ y radio $r$ y, sobre el eje $x$, su proyección: un intervalo de centro $x_0$ y del "mismo radio".)_

  Veamos que $B(x_0, r) subset.eq pi_1 (B((x_0, y_0), r))$. Dado $x in B(x_0, r)$, resulta que $d_1 (x, x_0) < r$. Sea $y in B(y_0, r)$, por ejemplo $y = y_0$. Tenemos que $(x, y_0) in B((x_0, y_0), r)$, pues
  $
  d_infinity ((x_0, y_0), (x, y_0)) = max{d_1 (x_0, x), underbrace(d_2 (y_0, y_0), = 0)} = d_1 (x_0, x) < r.
  $
  Entonces $B(x_0, r) subset.eq pi_1 (B((x_0, y_0), r))$.

  _Nota_: el manuscrito escribe "Sea $(x, y) in X times Y$ y $r > 0$. Entonces $B((x, y), r) = dots$" y a continuación usa $(x_0, y_0)$ como centro; acá se unificó a $(x_0, y_0)$. Además, sólo prueba la contención $B(x_0, r) subset.eq pi_1 (B((x_0, y_0), r))$; la otra es inmediata de la descripción de $pi_1 (B((x_0, y_0), r))$ (todo $x$ ahí cumple $d_1 (x, x_0) < r$), así que $pi_1 (B((x_0, y_0), r)) = B(x_0, r)$, que es abierto, y eso es lo que cierra el argumento.

  Veamos que en general $pi_1$ *no es cerrada, es decir, existe $F subset.eq X times Y$ cerrado con $pi_1 (F)$ no cerrado*.

  _Idea_: sea $F subset.eq X times Y$ cerrado, y consideramos $pi_1 (F)$. Si $(x_n)_n subset.eq pi_1 (F)$ cumple que $x_n -> x$, querríamos ver que $x in pi_1 (F)$, es decir, existe $y in Y$ tal que $(x, y) in F$. Como $x_n in pi_1 (F)$, existe $y_n in Y$ tal que $(x_n, y_n) in F$. *Lo ideal sería que $(x_n, y_n) -> (x, y)$*, porque en tal caso, al ser $F$ cerrado, $(x, y) in F$ y entonces $x in pi_1 (F)$. El problema es que *$(y_n)_n$ no tiene por qué converger, o tener subsucesiones convergentes*.

  _Ej_: si $X = Y = RR$, en $RR^2$ con $d_infinity$, sea $F = {(x, y) : x y = 1}$. Es cerrado porque es la preimagen de ${1}$ vía $f(x, y) = x y$, o sea: $F = f^(-1)({1})$. Como $f$ es continua, $F$ es cerrado. Pero
  $
  pi_1 (F) = {x in RR : "existe " y in RR " con " x y = 1} = RR without {0},
  $
  que no es cerrado. _(Dibujo: la hipérbola $x y = 1$ y su proyección sobre el eje $x$, que cubre toda la recta salvo el $0$.)_

  Las afirmaciones para $pi_2$ se prueban de manera análoga.

  *b)* Notemos que si $f$ es continua, por el ítem a), $pi_1$ y $pi_2$ son continuas, y en consecuencia $f_1 = pi_1 compose f$ y $f_2 = pi_2 compose f$ son continuas por ser composición de continuas.

  Usemos sucesiones. Tenemos que $f$ es continua en $z_0 in Z$ si y sólo si para toda $(z_n)_n subset.eq Z$ con $z_n -> z_0$ se tiene que $f(z_n) -> f(z_0)$. Notemos que
  $
  f : Z -> X times Y, quad f(z) = (f_1 (z), f_2 (z)),
  $
  porque $f_1 = pi_1 compose f$ y $f_2 = pi_2 compose f$. Sea $(z_n)_n subset.eq Z$ con $z_n -> z_0$. Como $f_1$ y $f_2$ son continuas en $z_0$, $f_1 (z_n) -> f_1 (z_0)$ y $f_2 (z_n) -> f_2 (z_0)$. Sea $epsilon > 0$. Sabemos que existen $n_1, n_2 in NN$ tales que
  $
  d_1 (f_1 (z_0), f_1 (z_n)) &< epsilon " para todo " n >= n_1, \
  d_2 (f_2 (z_0), f_2 (z_n)) &< epsilon " para todo " n >= n_2.
  $
  Entonces, para todo $n >= n_0 = max{n_1, n_2}$,
  $
  d_infinity (f(z_0), f(z_n)) = max{d_1 (f_1 (z_0), f_1 (z_n)), d_2 (f_2 (z_0), f_2 (z_n))} < epsilon.
  $
  Concluimos que $f(z_n) -> f(z_0)$. #align(right)[$square$]
]

_Obs_: de 1 b) sale que en $X times Y$ con $d_infinity$, la sucesión $(x_n, y_n) -> (x, y)$ si y sólo si $x_n -> x$ e $y_n -> y$, tomando $f : X times Y -> X times Y$, $f(x, y) = op("id")_(X times Y) (x, y) = (x, y)$, es decir $f_1 (x, y) = x$, $f_2 (x, y) = y$.

_Nota_: tal como está enunciado, 1 b) habla de continuidad de $f$ y no de convergencia de una sucesión dada; lo que realmente se usa es el *argumento* de la demostración de b) (dado $(x_n, y_n) -> (x, y)$, la desigualdad $d_1 (x_n, x) <= d_infinity ((x_n, y_n), (x, y))$ da $x_n -> x$, y recíprocamente el $max$ de dos cantidades que tienden a $0$ tiende a $0$).

Recordemos que $f : (E, d) -> (E', d')$ es Lipschitz si existe $M > 0$ tal que
$
d' (f(x), f(y)) <= M d(x, y) " para todo " x, y in E.
$

_Nota_: el manuscrito escribe $f : (E, d) -> (E, d')$ y "para todo $x, y in M$"; el codominio es otro espacio $(E', d')$ y los puntos se toman en el dominio $E$.

#ejemplo[Derivada acotada implica Lipschitz (Clase 6 · Ejemplo 2)][C6-2][
  Sea $f : (a, b) -> RR$ derivable, con derivada acotada. Probar que $f$ es Lipschitz.
]

#resolucion[
  Recordemos que por el teorema del valor medio, dados $x < y$, si $f$ es continua en $[x, y]$ y derivable en $(x, y)$, entonces existe $c in (x, y)$ tal que
  $
  f(x) - f(y) = f'(c)(x - y).
  $
  Con esto en mente, dados $x, y in (a, b)$, con $x < y$, existe $c in (x, y)$ tal que
  $
  abs(f(x) - f(y)) = abs(f'(c)) dot abs(x - y).
  $
  Como $f'(c)$ está acotada (pues $c in (x, y) subset.eq (a, b)$), digamos por $M$, se sigue que
  $
  abs(f(x) - f(y)) <= M abs(x - y).
  $
  Concluimos. #align(right)[$square$]

  _Ej_: si $f : (0, 1) -> RR$, $f(x) = x^3$, por el teorema del valor medio, para $0 < x < y < 1$, existe $c in (x, y)$ tal que
  $
  abs(f(x) - f(y)) = abs(f'(c)(x - y)) = 3 c^2 abs(x - y) <= 3 abs(x - y),
  $
  donde usamos que $c in (0, 1)$, por lo tanto $abs(c) <= 1$.
]

#ejemplo[$x sin(1 \/ x)$ es continua en $0$ pero no es Lipschitz cerca de $0$ (Clase 6 · Ejemplo 3)][C6-3][
  Sea $f : RR -> RR$ dada por
  $
  f(x) = cases(
    x sin(1 / x) & " si " x != 0,
    0 & " si " x = 0.
  )
  $
  #set enum(numbering: "a)")
  + Probar que $f$ es continua en $x = 0$.
  + Probar que $f$ no es Lipschitz en ningún intervalo que contenga al $0$.

  _Nota_: el manuscrito escribe "$0$ si $f(0) = 0$" en la segunda rama; es "$0$ si $x = 0$".
]

#resolucion[
  *a)* Sea $epsilon > 0$. Tenemos que
  $
  abs(f(x) - f(0)) = abs(f(x)) = abs(x sin(1 / x)) <= abs(x),
  $
  por lo tanto $abs(f(x)) < epsilon$ si $abs(x) < delta$ con $delta <= epsilon$.

  *b)* Sea $I = (a, b)$ que contiene al $0$. Como ser Lipschitz en $I$ significa que *existe $M > 0$ tal que para todo $x in I$, $y in I$, $abs(f(x) - f(y)) <= M abs(x - y)$*, no ser Lipschitz significa que *para todo $M > 0$, existen $x_M in I$, $y_M in I$, tales que $abs(f(x_M) - f(y_M)) > M abs(x_M - y_M)$*. Tomando $M = M_n$ con $M_n -> +infinity$, vemos que alcanza con probar que *existen $(x_n)_n subset.eq I$, $(y_n)_n subset.eq I$, tales que*
  $
  abs(f(x_n) - f(y_n)) >= M_n dot abs(x_n - y_n).
  $
  Sean
  $
  x_n = 1 / (pi / 2 + 2 pi n), quad y_n = 1 / ((3 pi) / 2 + 2 pi n);
  $
  tenemos que $x_n != 0$, $y_n != 0$ para todo $n$. Entonces
  $
  abs(f(x_n) - f(y_n)) &= abs(1 / (pi / 2 + 2 pi n) sin(pi / 2 + 2 pi n) - 1 / ((3 pi) / 2 + 2 pi n) sin((3 pi) / 2 + 2 pi n)) \
                       &= abs(1 / (pi / 2 + 2 pi n) + 1 / ((3 pi) / 2 + 2 pi n))
                        = abs(((3 pi) / 2 + 2 pi n + pi / 2 + 2 pi n) / ((pi / 2 + 2 pi n)((3 pi) / 2 + 2 pi n))) \
                       &= (2 pi + 4 pi n) / ((pi / 2 + 2 pi n)((3 pi) / 2 + 2 pi n))
                        = (2 pi + 4 pi n) / pi dot pi / ((pi / 2 + 2 pi n)((3 pi) / 2 + 2 pi n)) \
                       &= (2 + 4 n) abs(1 / (pi / 2 + 2 pi n) - 1 / ((3 pi) / 2 + 2 pi n))
                        = (2 + 4 n) dot abs(x_n - y_n) = M_n dot abs(x_n - y_n),
  $
  y como $M_n -> +infinity$, concluimos que $f$ *no es Lipschitz*. #align(right)[$square$]

  _Nota_: el manuscrito no dice por qué $x_n, y_n in I$: como $x_n, y_n -> 0$ y $0 in (a, b)$, están en $I$ para todo $n$ suficientemente grande, y con esos $n$ alcanza (dado $M > 0$, se elige $n$ grande con $M_n = 2 + 4n > M$; como $x_n != y_n$, la desigualdad $>= M_n abs(x_n - y_n)$ da la estricta $> M abs(x_n - y_n)$).
]

_Obs_: si $f : E -> F$ es Lipschitz entonces $f$ es uniformemente continua. Pero no vale la vuelta; la función del ejemplo anterior en el dominio $[-1, 1]$ es uniformemente continua _(esto es consecuencia de un resultado que veremos más adelante)_ pero no es Lipschitz.

#ejemplo[$Psi(f)(x) = x f(x)$ de $(C([0, 1]), d_infinity)$ en $(C([0, 1]), d_1)$ es Lipschitz (Clase 6 · Ejemplo 4)][C6-4][
  Sea $Psi : (C([0, 1]), d_infinity) -> (C([0, 1]), d_1)$ dada por
  $
  (Psi(f))(x) := x f(x).
  $
  Decidir si $Psi$ es Lipschitz.
]

#resolucion[
  Dadas $f, g in C([0, 1])$, planteamos
  $
  d_1 (Psi(f), Psi(g)) &= integral_0^1 abs(x f(x) - x g(x)) dif x = integral_0^1 abs(x (f(x) - g(x))) dif x \
                       &<= integral_0^1 abs(x) abs(f(x) - g(x)) dif x <= integral_0^1 sup_(x in [0, 1]) abs(f(x) - g(x)) dif x \
                       &= d_infinity (f, g).
  $
  Entonces $Psi$ es Lipschitz. #align(right)[$square$]

  _Nota_: en 4), en particular vemos que es uniformemente continua.
]

#ejemplo[$sin(x)$ es uniformemente continua en $RR$; $x^2$ no lo es en $(0, +infinity)$ (Clase 6 · Ejemplo 5)][C6-5][
  Decidir si son uniformemente continuas.
  #set enum(numbering: "a)")
  + $f : RR -> RR$, $f(x) = sin(x)$.
  + $f : (0, +infinity) -> RR$, $f(x) = x^2$.
]

#resolucion[
  *a)* Una forma es viendo que es Lipschitz, mediante el teorema del valor medio: dados $x < y$, existe $c in (x, y)$ tal que
  $
  f(x) - f(y) = f'(c)(x - y).
  $
  Entonces
  $
  abs(f(x) - f(y)) = abs(sin(x) - sin(y)) = abs(cos(c)) dot abs(x - y) <= abs(x - y).
  $
  Como $f$ es Lipschitz, es uniformemente continua.

  *b)* Veamos que *no es uniformemente continua*. Para ello, razonamos como para ver que una $f$ no es Lipschitz: *existen $epsilon > 0$ y $(x_n)_n subset.eq (0, +infinity)$, $(y_n)_n subset.eq (0, +infinity)$ tales que $abs(x_n - y_n) -> 0$ pero*
  $
  abs(f(x_n) - f(y_n)) >= epsilon " para todo " n.
  $
  El problema ocurre cuando $x_n, y_n -> +infinity$. Sea $x_n = n$, $y_n = n + 1/n$. Tenemos que $abs(x_n - y_n) = 1/n -> 0$ pero
  $
  abs(f(x_n) - f(y_n)) = abs(n^2 - (n + 1/n)^2) = cancel(n^2) + 2 + 1/n^2 - cancel(n^2) > 2.
  $
  Tomando $epsilon = 2$ vemos que no es uniformemente continua.
]

#ejemplo[Producto de uniformemente continuas y acotadas (Clase 6 · Ejemplo 6)][C6-6][
  Sean $(X, d)$ un espacio métrico y $f, g : X -> RR$ uniformemente continuas y acotadas. Probar que $f dot g$ es uniformemente continua. Mostrar que el producto de funciones uniformemente continuas puede no serlo *incluso si una de ellas está acotada*. [Sugerencia: $f(x) = x sin(x)$.]
]

#resolucion[
  Sea $epsilon > 0$. Queremos ver que existe $delta > 0$ tal que $d(x, y) < delta$ implica que
  $
  abs(f(x) dot g(x) - f(y) dot g(y)) < epsilon.
  $
  Como $f, g$ son uniformemente continuas, existen $delta_1 > 0$, $delta_2 > 0$ tales que
  $
  d(x, y) < delta_1 &==> abs(f(x) - f(y)) < epsilon', \
  d(x, y) < delta_2 &==> abs(g(x) - g(y)) < epsilon',
  $
  donde $epsilon' > 0$ lo elegiremos después. Entonces
  $
  abs(f(x) g(x) - f(y) g(y)) &<= abs(f(x) g(x) - f(y) g(x)) + abs(f(y) g(x) - f(y) g(y)) \
                             &= abs(g(x)) abs(f(x) - f(y)) + abs(f(y)) abs(g(x) - g(y)). quad (*)
  $
  Como $f, g$ son acotadas, existen $M_1 > 0$, $M_2 > 0$ tales que $abs(g(x)) <= M_1$ para todo $x in X$, $abs(f(x)) <= M_2$ para todo $x in X$. Entonces en $(*)$ acotamos
  $
  abs(f(x) g(x) - f(y) g(y)) <= M_1 epsilon' + M_2 epsilon' = (M_1 + M_2) epsilon'
  $
  si $d(x, y) < min{delta_1, delta_2}$. Tomando $epsilon' < epsilon / (M_1 + M_2)$, concluimos.

  Veamos que la hipótesis de acotadas es necesaria. Sea $f : RR -> RR$, $f(x) = x sin(x)$. Sean $x_n = pi + 2 pi n$, $y_n = pi + 2 pi n + 1/n$. Se tiene que $abs(x_n - y_n) = 1/n -> 0$, pero
  $
  abs(f(x_n) - f(y_n)) &= abs((pi + 2 pi n) underbrace(sin(pi + 2 pi n), = 0) - (pi + 2 pi n + 1/n) sin(pi + 2 pi n + 1/n)) \
                       &= abs((pi + 2 pi n + 1/n) sin((pi + 2 pi n) + 1/n)) \
                       &= abs((pi + 2 pi n + 1/n) [underbrace(sin(pi + 2 pi n), = 0) dot cos(1/n) + underbrace(cos(pi + 2 pi n), = -1) sin(1/n)]) \
                       &= underbrace(pi sin(1/n), -> 0) + underbrace(2 pi n sin(1/n), (star)) + underbrace(1/n sin(1/n), -> 0).
  $
  $(star)$ Como $2 pi n sin(1/n) = 2 pi sin(1/n) / (1/n) -> 2 pi$, tenemos que $abs(f(x_n) - f(y_n)) -> 2 pi$, y en consecuencia existe $epsilon > 0$ tal que $abs(f(x_n) - f(y_n)) >= epsilon$ para todo $n$ suficientemente grande. #align(right)[$square$]

  _Nota_: el manuscrito no explicita qué par de funciones multiplica en el contraejemplo: $x sin(x)$ es el producto de $op("id")_RR$ (uniformemente continua, no acotada) por $sin$ (uniformemente continua y acotada, Ejemplo 5 a)). En la última igualdad desaparece la barra de valor absoluto porque $sin(1/n) > 0$ para todo $n >= 1$, así que la expresión entre barras es $-(pi + 2 pi n + 1/n) sin(1/n)$ y su módulo es la suma escrita.

  _Nota_: el límite $n sin(1/n) -> 1$ no está probado en las guías anteriores. Sale por valor medio, como en el Ejemplo 5 a): para cada $n >= 1$ existe $c_n in (0, 1/n)$ tal que
  $
  sin(1/n) = sin(1/n) - sin(0) = cos(c_n) dot (1/n - 0).
  $
  Multiplicando ambos lados por $n$, el factor $1/n$ se cancela:
  $
  n sin(1/n) = n dot cos(c_n) dot 1/n = cos(c_n).
  $
  Como $0 < c_n < 1/n$, se tiene $c_n -> 0$, y por continuidad del coseno $cos(c_n) -> cos(0) = 1$. Luego $2 pi n sin(1/n) -> 2 pi$.

  _Nota_: en $(star)$ alcanza con que el límite sea *positivo*. Sea $a_n = abs(f(x_n) - f(y_n))$, con $a_n -> 2 pi > 0$. Usando $epsilon = pi$ como tolerancia en la definición de límite, existe $N$ tal que para todo $n >= N$
  $
  abs(a_n - 2 pi) < pi ==> a_n > 2 pi - pi = pi = epsilon.
  $
  (Sirve cualquier $epsilon in (0, 2 pi)$.) Que valga sólo para $n$ suficientemente grande no es un problema (ver la observación siguiente). Lo esencial es el signo del límite: si $a_n -> 0$, ningún $epsilon > 0$ acota a $a_n$ por debajo y el argumento no funciona.
]
#observacion[De "$n$ suficientemente grande" a "para todo $n$"][
  El criterio con sucesiones pide $abs(f(x_n) - f(y_n)) >= epsilon$ *para todo* $n$, pero en $(star)$ lo obtuvimos sólo para $n >= N$. Hay dos formas de cerrar la brecha.

  *1. Reindexar.* Descartamos los primeros términos: sean
  $
  x'_k = x_(N + k), quad y'_k = y_(N + k), quad k >= 0.
  $
  Entonces $abs(x'_k - y'_k) -> 0$ (una cola de una sucesión que tiende a $0$ también tiende a $0$) y $abs(f(x'_k) - f(y'_k)) = a_(N + k) >= epsilon$ para *todo* $k$, porque $N + k >= N$. El $N$ no forma parte de la definición: es la herramienta que da el límite para saber desde dónde empezar. Esto sirve siempre que $a_n$ tienda a algo positivo, aunque no sepamos acotar los primeros términos.

  *2. Acotar directamente.* Por la nota anterior, $n sin(1/n) = cos(c_n)$ con $c_n in (0, 1/n) subset.eq (0, 1]$. Como el coseno es decreciente en $[0, pi]$ y $1 < pi$, se tiene $cos(c_n) >= cos(1) > 0$. Descartando los sumandos positivos $pi sin(1/n)$ y $1/n sin(1/n)$, para todo $n >= 1$
  $
  a_n = (pi + 2 pi n + 1/n) sin(1/n) >= 2 pi n sin(1/n) = 2 pi cos(c_n) >= 2 pi cos(1).
  $
  Tomando $epsilon = 2 pi cos(1) approx 3.39$, la desigualdad vale para todo $n$ sin reindexar. Es más directo, pero exige encontrar una cota que valga para todos los términos.
]

#ejemplo[Pegado de continuidad uniforme en $[0, a]$ y $[a, +infinity)$ (Clase 6 · Ejemplo 7)][C6-7][
  Sea $f : [0, +infinity) -> RR$. Supongamos que existe $a > 0$ tal que $f|_([0, a])$ y $f|_([a, +infinity))$ son uniformemente continuas. Probar que $f$ es uniformemente continua.
]

#resolucion[
  Sea $epsilon > 0$. Queremos ver que existe $delta > 0$ tal que $abs(x - y) < delta$ implica que $abs(f(x) - f(y)) < epsilon$.

  - Si $x, y in [0, a]$, existe $delta_1 > 0$ tal que $abs(x - y) < delta_1$ implica que $abs(f(x) - f(y)) < epsilon'$.
  - Si $x, y in [a, +infinity)$, existe $delta_2 > 0$ tal que $abs(x - y) < delta_2$ implica que $abs(f(x) - f(y)) < epsilon'$.
  - Sea $x in [0, a]$, $y in [a, +infinity)$.

    #block(breakable: false, width: 100%)[#align(center)[
      #cetz.canvas({
        import cetz.draw: *
        let azul = rgb("#1e3a8a")
        let rojo = rgb("#b91c1c")
        let (a, d1, d2, x, y) = (5, 2, 2.4, 3.7, 6.1)

        // Tramos donde valen las cotas de cada lado.
        rect((a - d1, -0.12), (a, 0.12), fill: azul.lighten(80%), stroke: none)
        rect((a, -0.12), (a + d2, 0.12), fill: rojo.lighten(80%), stroke: none)

        // Semirrecta desde 0.
        line((0, 0), (10, 0), mark: (end: ">"), stroke: 0.8pt)
        for (p, l) in ((0, $0$), (a, $a$)) {
          line((p, -0.15), (p, 0.15), stroke: 0.8pt)
          content((p, -0.25), anchor: "north", text(size: 9pt, l))
        }

        // Distancias a a: menos que delta_1 a izquierda, menos que delta_2 a derecha.
        line((a - d1, 0.45), (a, 0.45), mark: (start: "|", end: "|"), stroke: 0.7pt + azul)
        content((a - d1 / 2, 0.55), anchor: "south", text(size: 9pt, fill: azul, $delta_1$))
        line((a, 0.45), (a + d2, 0.45), mark: (start: "|", end: "|"), stroke: 0.7pt + rojo)
        content((a + d2 / 2, 0.55), anchor: "south", text(size: 9pt, fill: rojo, $delta_2$))

        // Los puntos x <= a <= y.
        circle((x, 0), radius: 0.07, fill: azul, stroke: none)
        content((x, -0.25), anchor: "north", text(size: 9pt, fill: azul, $x$))
        circle((y, 0), radius: 0.07, fill: rojo, stroke: none)
        content((y, -0.25), anchor: "north", text(size: 9pt, fill: rojo, $y$))

        // Distancia entre x e y.
        line((x, -0.85), (y, -0.85), mark: (start: "|", end: "|"), stroke: 0.7pt)
        content(((x + y) / 2, -0.95), anchor: "north", text(size: 9pt, $abs(x - y) < delta$))
      })
    ]]

    La idea es que si $x$ e $y$ están muy cerca, estarán cerca de $a$, y si $abs(x - a) < delta_1$ entonces $abs(f(x) - f(a)) < epsilon'$ y similarmente $abs(y - a) < delta_2$, entonces $abs(f(y) - f(a)) < epsilon'$, por lo tanto $f(x)$ y $f(y)$ estarán muy cerca entre sí. Formalmente, sea $delta < min{delta_1, delta_2}$. Supongamos que $abs(x - y) < delta$. Como $x <= a <= y$, tenemos que
    $
    abs(x - a) &= a - x <= y - x = abs(y - x) < delta < delta_1, " entonces " abs(f(x) - f(a)) < epsilon', quad (1) \
    abs(y - a) &= y - a <= y - x = abs(y - x) < delta < delta_2, " entonces " abs(f(y) - f(a)) < epsilon'. quad (2)
    $
    Por lo tanto
    $
    abs(f(x) - f(y)) <= underbrace(abs(f(x) - f(a)), < epsilon' " por " (1)) + underbrace(abs(f(a) - f(y)), < epsilon' " por " (2)) < 2 epsilon'.
    $

  Tomando $epsilon' <= epsilon \/ 2$, se tiene $abs(f(x) - f(y)) < 2 epsilon' <= epsilon$ y concluimos. #align(right)[$square$]

  _Nota_: el manuscrito cierra con "tomando $epsilon' < 2 epsilon$", que no alcanza: sólo da $abs(f(x) - f(y)) < 4 epsilon$. Para que $2 epsilon' <= epsilon$ hay que tomar $epsilon' <= epsilon \/ 2$, como arriba. En el párrafo de la idea escribe "$abs(x - a) < delta$ entonces $abs(f(x) - f(a)) < epsilon$" mezclando $delta$ con $delta_1$ y $epsilon$ con $epsilon'$; la versión formal de abajo es la correcta.
]

#ejemplo[Pegado de continuidad uniforme en $A union B$ con $d(A, B) > 0$ (Clase 6 · Ejemplo 8)][C6-8][
  Sean $(X, d)$, $(Y, d')$ espacios métricos y $f : X -> Y$. Supongamos que $X = A union B$, con $A, B$ tales que $d(A, B) > 0$. Si $f|_A$ y $f|_B$ son uniformemente continuas, entonces $f$ es uniformemente continua.
]

#resolucion[
  Sea $epsilon > 0$. Como $f|_A$ y $f|_B$ son uniformemente continuas, existen $delta_A > 0$, $delta_B > 0$ tales que
  - si $x, y in A$ y $d(x, y) < delta_A$ entonces $d'(f(x), f(y)) < epsilon'$;
  - si $x, y in B$ y $d(x, y) < delta_B$ entonces $d'(f(x), f(y)) < epsilon'$.

  #block(breakable: false, width: 100%)[#align(center)[
    #cetz.canvas({
      import cetz.draw: *
      let azul = rgb("#1e3a8a")
      let rojo = rgb("#b91c1c")
      let (a1, a2, b1, b2, x, y) = (0.5, 3.5, 6, 9.5, 2.2, 7.6)

      // Los conjuntos A y B, separados por una brecha.
      line((0, 0), (10, 0), stroke: 0.5pt + gray)
      line((a1, 0), (a2, 0), stroke: 3pt + azul.lighten(50%))
      line((b1, 0), (b2, 0), stroke: 3pt + rojo.lighten(50%))
      content(((a1 + a2) / 2, 0.25), anchor: "south", text(size: 9pt, fill: azul, $A$))
      content(((b1 + b2) / 2, 0.25), anchor: "south", text(size: 9pt, fill: rojo, $B$))

      // La brecha entre A y B mide d(A, B).
      line((a2, 0.45), (b1, 0.45), mark: (start: "|", end: "|"), stroke: 0.7pt)
      content(((a2 + b1) / 2, 0.55), anchor: "south", text(size: 9pt, $d(A, B)$))

      // Los puntos x in A, y in B.
      circle((x, 0), radius: 0.07, fill: azul, stroke: none)
      content((x, -0.25), anchor: "north", text(size: 9pt, fill: azul, $x$))
      circle((y, 0), radius: 0.07, fill: rojo, stroke: none)
      content((y, -0.25), anchor: "north", text(size: 9pt, fill: rojo, $y$))

      // Distancia entre x e y.
      line((x, -0.85), (y, -0.85), mark: (start: "|", end: "|"), stroke: 0.7pt)
      content(((x + y) / 2, -0.95), anchor: "north", text(size: 9pt, $d(x, y) >= d(A, B)$))
    })
  ]]

  Notemos que si $d(A, B) > 0$ entonces $overline(A) inter overline(B) = emptyset$ (es el contrarrecíproco de la Práctica 3, ejercicio 11 c), $overline(A) inter overline(B) != emptyset ==> d(A, B) = 0$).

  La idea es que si tomamos $delta > 0$ muy pequeño, no puede pasar que $d(x, y) < delta$ con $x in A$, $y in B$. Si tomamos $delta < min{delta_A, delta_B, d(A, B)}$, si $x in A$, $y in B$, $d(x, y) < delta$, entonces
  $
  d(A, B) <= d(x, y) < delta < d(A, B),
  $
  absurdo. Por lo tanto $d(x, y) < delta$ implica que $x in A, y in A$, o $x in B, y in B$.
  - Si $x, y in A$, como $d(x, y) < delta < delta_A$, tenemos que $d'(f(x), f(y)) < epsilon'$;
  - si $x, y in B$, como $d(x, y) < delta < delta_B$, tenemos que $d'(f(x), f(y)) < epsilon'$.

  Tomando $epsilon' < epsilon$ concluimos. #align(right)[$square$]

  _Nota_: el "ejercicio 11 c)" citado es el Ejercicio 11 (c) de la Práctica 3 ($hat(d)(A, B) = 0 <=> overline(A) inter overline(B) != emptyset$); la implicación que se usa, $overline(A) inter overline(B) != emptyset ==> d(A, B) = 0$, es la dirección verdadera de ese ítem. Además, la observación $overline(A) inter overline(B) = emptyset$ no se vuelve a usar en la prueba: lo que hace falta es sólo la desigualdad $d(A, B) <= d(x, y)$ para $x in A$, $y in B$, que sale de la definición de ínfimo.
]
