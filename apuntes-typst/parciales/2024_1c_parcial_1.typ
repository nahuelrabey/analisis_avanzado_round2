#import "@preview/frame-it:2.0.0": *
#import "../utils.typ": *
#show figure.where(kind: "frame"): set figure(numbering: none)
#show figure.where(kind: "frame"): set block(breakable: true)
#show: frame-style(styles.boxy)

// Fuente: `parciales/primer_parcial_1c2024_soluciones.pdf` (enunciado + soluciones de la cátedra).
// Las resoluciones de abajo son transcripción de ese documento, sin agregados. Las erratas
// evidentes del original se conservan y están marcadas con un comentario `// sic`.

#align(center)[
  #text(14pt, weight: "bold")[Análisis Avanzado] \
  #v(2pt)
  #text(12pt, weight: "medium")[1er. cuatrimestre 2024 - Primer Parcial]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#set enum(numbering: "1.")

+ Calcular el cardinal de:
  #set enum(numbering: "(a)")
  + El conjunto de polinomios de una variable con coeficientes racionales, $QQ[x]$.
  + El conjunto $cal(A)$ de los números reales algebraicos, definido por
    $ cal(A) := {alpha in RR : exists p in QQ[x] without {0}, space p(alpha) = 0}. $
    Sugerencia: Use el ítem (a).

+ Sea $Psi : (C[0, 1], d_oo) -> (C[0, 1], d_1)$ dada por
  $ (Psi(f))(x) = x f(x) quad quad forall f in C[0, 1], forall x in [0, 1]. $
  Probar que $Psi$ es uniformemente continua.

+ Sean $X$, $Y$ espacios métricos y $f : X -> Y$ una función continua. Probar que si $X$ es compacto, entonces $f(overline(A)) = overline(f(A))$ para cualquier subconjunto $A$ de $X$.

+ Sea la métrica $d : RR times RR -> RR$, definida por
  $ d(x, y) = cases(0\, & quad "si" x = y\,, abs(x) + abs(y)\, & quad "si" x != y.) $
  Probar que $(RR, d)$ es un espacio métrico completo (no hace falta probar que $d$ es una métrica).

#v(12pt)
#line(length: 100%, stroke: 0.7pt)
#v(6pt)

#align(center)[
  #text(9pt, style: "italic")[
    Complete esta hoja con sus datos y entréguela con el resto del examen. \
    Justifique todas sus respuestas.
  ]
]

#pagebreak()

= Soluciones (oficiales)

== Ejercicio 1

#resolucion[Cátedra][
  *(a)* Primero notemos que existe una función inyectiva $Psi : NN -> QQ[x]$ tal que
  $Psi(n) = n$, es decir que envía cada número natural $n$ al polinomio de grado cero que puede
  identificarse naturalmente con $n$. Por lo tanto, $\#(QQ[x]) >= \#(NN)$, así que si vemos que
  $QQ[x]$ es contable, se sigue que es numerable. Para cada $n in NN_0$, sea $QQ_n [x]$ el
  conjunto de polinomios de grado $NN$. // sic: debería decir "de grado n".
  Luego,
  $ QQ[x] = {0} union union.big_(n in NN_0) QQ_n [x]. $
  (el cero lo ponemos aparte porque no tiene grado). Hemos escrito a $QQ[x]$ como una unión
  contable de conjuntos. Como las uniones contables de conjuntos contables son contables, basta
  ver que cada uno de esos conjuntos es contable. Es claro que ${0}$ es contable porque es
  finito, y también que $QQ_0 [x]$ es contable porque podemos identificar cada polinomio de grado
  cero con un número racional y sabemos que los racionales son contables. Por lo tanto, para
  completar la prueba de que $QQ[x]$ es contable (y por lo que ya dijimos, numerable), basta con
  ver que para cada $n in NN$ fijo, se tiene que $QQ_n [x]$ es contable. Dado $n in NN$, sea
  $phi : QQ -> NN$ una función inyectiva (que existe porque sabemos que $QQ approx NN$), y sean
  ${p_0, p_1, p_2, dots, p_n}$ números naturales primos distintos. Definimos
  $Phi : QQ_n [x] -> NN$ de la siguiente manera:
  // sic: el original escribe x_j (por x^j) y los exponentes phi(a_1), phi(a_2), ..., phi(a_n)
  // sobre p_0, p_1, ..., p_n.
  $ Phi(sum_(j=0)^n a_j x_j) := p_0^(phi(a_1)) p_1^(phi(a_2)) dots p_n^(phi(a_n)). quad quad (1) $
  Como la escritura de un polinomio de grado $n$ como la suma en (1) es única (notemos que
  $a_n != 0$), se tiene que $Phi$ está bien definida. Ahora bien, si
  $ Phi(sum_(j=0)^n a_j x_j) = Phi(sum_(j=0)^n b_j x_j), $
  entonces por la unicidad de la descomposición en primos en $NN$, tenemos que
  $p_j^(phi(a_j)) = p_j^(phi(b_j))$ para cada $0 <= j <= n$. Como $phi$ es inyectiva, se sigue que
  $a_j = b_j$ para todo $0 <= j <= n$, así que $sum_(j=0)^n a_j x_j = sum_(j=0)^n b_j x_j$. Hemos
  probado así que $Phi$ es una función inyectiva de $QQ_n [x]$ a $NN$, y por lo tanto, que
  $QQ_n [x]$ es contable. Por lo dicho anteriormente, esto completa la demostración de que
  $QQ[x]$ es numerable.

  *(b)* Para cada $p in QQ[x]$, sea $R_p := {x in RR : p(x) = 0}$. Notemos que $R_p$ es finito.
  Como las uniones contables de conjuntos contables son contables, por (a) el conjunto
  $ cal(B) := union.big_(p in QQ[x]) R_p $
  es contable. Más aún, como para cada $alpha in QQ$, se tiene que $alpha in R_p$ para
  $p(x) = x - alpha$, tenemos que $QQ subset cal(B)$, así que $cal(B)$ no es finito. Por lo tanto,
  $cal(B)$ es numerable. Afirmamos que $cal(B) = cal(A)$. En efecto, si $x in cal(B)$, entonces
  existe $p in QQ[x]$ tal que $x in R_p$. Luego, $p(x) = 0$, lo que implica que $x in cal(A)$. Por
  otra parte, si $y in cal(A)$, entonces existe $p in QQ[x]$ tal que $p(y) = 0$. Por lo tanto,
  $y in R_p subset cal(B)$. Hemos probado que $cal(A) = cal(B)$, y como $cal(B)$ es numerable,
  $cal(A)$ es numerable. #h(1fr) $square$
]

== Ejercicio 2

#resolucion[Cátedra][
  Dadas $f, g in C[0, 1]$, tenemos que
  $ d_1(Psi(f), Psi(g)) & = integral_0^1 abs(x f(x) - x g(x)) dif x
      = integral_0^1 x abs(f(x) - g(x)) dif x
      <= integral_0^1 x d_oo (f, g) dif x \
    & = d_oo (f, g) integral_0^1 x dif x
      = d_oo (f, g) lr(x^2 / 2 bar.v)_0^1
      = (d_oo (f, g)) / 2. quad quad (2) $
  Esto prueba que $Psi$ es Lipschitz, y por lo visto en la clase práctica, es uniformemente
  continua.

  Sin usar que Lipschitz implica uniformemente continua, podemos igualmente usar (2) para ver que
  $Psi$ es uniformemente continua, por ejemplo por definición: dado $epsilon > 0$, sea
  $delta = epsilon$. Se sigue de (2) que si $d_oo (f, g) < delta$, entonces
  $ d_1(Psi(f), Psi(g)) < delta / 2 = epsilon / 2 < epsilon. $
  Esto prueba por definición que $Psi$ es uniformemente continua.

  Nota al margen: Aunque no vamos a hacerlo de esta manera, también es posible resolver este
  ejercicio usando la equivalencia de continuidad uniforme por sucesiones que se vio en la clase
  práctica, y que dice que dados espacios métricos $(X, d_X)$ e $(Y, d_Y)$, una función
  $f : (X, d_X) -> (Y, d_Y)$ es uniformemente continua si y solo si dadas sucesiones
  $(x_n)_(n in NN), (x'_n)_(n in NN) subset X$ tales que
  $ d_X (x_n, x'_n) limits(-->)_(n -> +oo) 0, $
  se tiene que
  $ d_Y (f(x_n), f(x'_n)) limits(-->)_(n -> +oo) 0. $
  #h(1fr) $square$
]

== Ejercicio 3

#resolucion[Cátedra][
  La inclusión $f(overline(A)) subset overline(f(A))$ vale por la continuidad de $f$ (y sin
  necesidad de que $X$ sea compacto), y este resultado se vio en la clase teórica, así que puede
  usarse en el parcial y no hace falta probarlo. De todas maneras, se puede probar por ejemplo
  usando la equivalencia de continuidad por sucesiones (también vista en la teórica), del
  siguiente modo:

  Dado $y in f(overline(A))$, tomamos $x in overline(A)$ tal que $f(x) = y$. Como
  $x in overline(A)$, existe una sucesión $(a_n)_(n in NN) subset A$ tal que
  $ lim_(n -> +oo) a_n = x. quad quad (3) $
  Por la continuidad de $f$, tenemos que
  $ lim_(n -> +oo) f(a_n) = f(x) = y. quad quad (4) $
  // sic: el original dice "la sucesión (a_n) está en f(A)"; debería ser (f(a_n)).
  Puesto que la sucesión $(a_n)_(n in NN)$ está en $f(A)$, esto prueba que
  $ y in overline(f(A)). $
  Como $y$ es un elemento de $f(overline(A))$ elegido arbitrariamente, esto concluye la prueba de
  que $f(overline(A)) subset overline(f(A))$.

  Para probar la inclusión recíproca, es decir que $f(overline(A)) supset overline(f(A))$,
  podemos usar el siguiente argumento: Como $A subset overline(A)$, tenemos que
  $f(A) subset f(overline(A))$. Por lo tanto, tomando clausura obtenemos
  $ overline(f(A)) subset overline(f(overline(A))). quad quad (5) $
  Ahora bien, como $overline(A)$ es un subconjunto cerrado del espacio compacto $X$, se tiene que
  $overline(A)$ es compacto. Como $f$ es continua, manda compactos en compactos, así que
  $f(overline(A))$ es compacto. Como los compactos son cerrados, $f(overline(A))$ es cerrado, así
  que $f(overline(A)) = overline(f(overline(A)))$, lo que junto con (5) nos da que
  $overline(f(A)) subset f(overline(A))$.

  Una manera alternativa de probar que $overline(f(A)) subset f(overline(A))$ es por medio de
  sucesiones: Sea $y in overline(f(A))$. Por hipótesis, existe una sucesión
  $(y_n)_(n in NN) subset f(A)$ tal que
  $ lim_(n -> +oo) y_n = y. quad quad (6) $
  Ahora bien, para cada $n in NN$, existe $a_n in A$ tal que $f(a_n) = y_n$. Por la compacidad de
  $X$, existen $x in X$ y una subsucesión $(a_(n_k))_(k in NN)$ de $(a_n)_(n in NN)$ tales que
  $ lim_(k -> oo) a_(n_k) = x. quad quad (7) $
  Como $f$ es continua, esto implica que
  $ lim_(k -> oo) f(a_(n_k)) = f(x). quad quad (8) $
  Se sigue de (6) y (8) que $f(x) = y$, y se sigue de (7) que $x in overline(A)$. Esto prueba que
  $y in f(overline(A))$, lo que concluye la demostración porque $y$ es un elemento de
  $y in overline(f(A))$ elegido arbitrariamente.

  Nota al margen: la convergencia en (3) y (7) es en $X$ con la distancia de $X$, mientras que la
  convergencia en (4), (6) y (8), es en $Y$ con la distancia de $Y$. #h(1fr) $square$
]

== Ejercicio 4

#resolucion[Cátedra][
  Sea $(x_n)_(n in NN) subset RR$ una sucesión de Cauchy con respecto a la métrica $d$. Para ver
  que converge, veamos primero qué implica ser de Cauchy para esta métrica. Dado $epsilon > 0$,
  existe $n(epsilon) in NN$ tal que para todo $j, m >= n(epsilon)$, se tiene que
  $d(x_j, x_m) < epsilon$. Esto implica que o bien $x_j = x_m$, o bien
  $abs(x_j) + abs(x_m) < epsilon$. Consideremos entonces dos casos:

  *Caso 1:* Si
  $ abs(x_n) limits(arrow.r.not)_(n -> +oo) 0, $
  entonces existen $epsilon_0 > 0$ y una subsucesión $(x_(n_k))_(k in NN)$ tales que
  $abs(x_(n_k)) >= epsilon_0$ para todo $k in NN$. Tomemos $n(epsilon_0)$ como antes, es decir, de
  manera que para todo $j, m >= n(epsilon_0)$, se tiene que $d(x_j, x_m) < epsilon_0$. Ahora
  elijamos $k_0 in NN$ de manera que si $k >= k_0$, entonces $n_k >= n(epsilon_0)$. Tenemos
  entonces que si $j > k_0$, entonces
  $ d(x_(n_j), x_(n_(k_0))) < epsilon_0. quad quad (9) $
  Ahora bien, por la elección de la subsucesión $(x_(n_k))_(k in NN)$, se tiene que
  $ abs(x_(n_j)) + abs(x_(n_(k_0))) >= 2 epsilon_0. quad quad (10) $
  Se sigue de (9) y (10) que
  $ d(x_(n_j), x_(n_(k_0))) < abs(x_(n_j)) + abs(x_(n_(k_0))). $
  Esto solo es posible si $x_(n_j) = x_(n_(k_0))$. Pero como $j$ es cualquier natural mayor que
  $k_0$, esto prueba que
  // sic: el original escribe x_(n_j) con el cuantificador sobre k.
  $ x_(n_j) = x_(n_(k_0)) quad quad forall k >= k_0. $
  Como hay infinitos valores de $k in NN$ para los cuales $x_(n_k) = x_(n_(k_0))$, la sucesión
  $(x_n)_(n in NN)$ tiene una subsucesión constante, y por lo tanto convergente para la métrica
  $d$. Como toda sucesión de Cauchy que tiene una subsucesión convergente es convergente (lo que
  se vio en la clase práctica), se sigue que $(x_n)_(n in NN)$ es convergente en la métrica $d$
  (y, aunque no hace falta esto, se puede decir que converge a $x_(n_(k_0))$ porque tiene una
  subsucesión que converge a $x_(n_(k_0))$).

  *Caso 2:* Si
  $ abs(x_n) limits(-->)_(n -> +oo) 0, $
  veamos que la sucesión $(x_n)_(n in NN)$ converge a cero también para la métrica $d$. En
  efecto, dado $epsilon > 0$, tomemos $n_0 in NN$ tal que
  $ abs(x_n) < epsilon quad quad forall n >= n_0. $
  Entonces para todo $n >= n_0$, tenemos que
  $ d(x_n, 0) = cases(0\, & quad "si" x_n = 0\,, abs(x_n) + abs(0) < epsilon\, & quad "si" x_n != 0.) $
  Como en ambos casos la distancia es menor que $epsilon$, esto prueba que
  $ d(x_n, 0) < epsilon quad quad forall n >= n_0, $
  lo que a su vez muestra que
  $ x_n limits(-->)_(n -> +oo)^d 0. $

  Como hemos considerado todos los casos posibles, hemos probado que $(RR, d)$ es completo.
  #h(1fr) $square$
]
