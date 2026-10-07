== Ejercicio 2

#enunciado[Ejercicio 2][
  #set enum(numbering: "(a)")
  + Sean $x, y in RR$ tales que $y - x > 1$. Probar que existe un entero entre $x$ e $y$.
  + Sean $x, y in RR$ tales que $x < y$. Probar que existe un racional entre $x$ e $y$.
  + Sean $x, y in QQ$ tales que $x < y$. Probar que existe un irracional entre $x$ e $y$.
  + Sean $x, y in RR$ tales que $x < y$. Probar que existe un irracional entre $x$ e $y$.
]

#estrategia[Construir el entero con Arquímedes y buen orden; el resto es encadenar][
  Los cuatro ítems se apoyan uno en el otro. Para (a) el entero es $m = op("mín") {k in ZZ : x < k}$: el conjunto es no vacío y acotado inferiormente por el Teorema 1 (Principio de Arquímedes), tiene mínimo por el buen orden, y la minimalidad da $m - 1 <= x$, con lo que $x < m <= x + 1 < y$. Para (b) se repite la demostración de la Proposición 2: con la Proposición 1 se separa $n x$ de $n y$ en más de $1$, (a) encaja un entero $m$ y $q = m / n$. Para (c) hace falta un irracional concreto, $sqrt(2)$ (paridad), y que sumar un racional o multiplicar por un racional no nulo no lo vuelve racional: $z = x + ((y - x)/2) sqrt(2)$ sirve porque $0 < sqrt(2)/2 < 1$. Para (d) se toman dos racionales entre $x$ e $y$ con (b) y un irracional entre ellos con (c).
]

// ---------------------------------------------------------------- (a)
#enunciado[Ejercicio 2 (a)][Sean $x, y in RR$ tales que $y - x > 1$. Probar que existe un entero entre $x$ e $y$.]

#resolucion[Propuesta: $m = op("mín") {k in ZZ : x < k}$ cumple $x < m < y$][
  Sean $x, y in RR$ con $y - x > 1$, es decir $x + 1 < y$. Consideremos el conjunto
  $ C = {k in ZZ : x < k}. $

  - *$C != nothing$.* Por el Teorema 1 (Principio de Arquímedes) aplicado a $x$, existe $n in NN$ con $x <= n$. Entonces $x < n + 1$ y $n + 1 in ZZ$, así que $n + 1 in C$.
  - *$C$ está acotado inferiormente.* Por el Teorema 1 aplicado a $-x$, existe $N in NN$ con $-x <= N$, es decir $-N <= x$. Si $k in C$ entonces $-N <= x < k$: el entero $-N$ es cota inferior de $C$.
  - *$C$ tiene mínimo.* Es un subconjunto no vacío de $ZZ$ acotado inferiormente, así que por el buen orden (hecho de base: trasladando por $N$, el conjunto ${k + N : k in C} subset.eq NN$ es no vacío y tiene primer elemento) existe $m = op("mín") C$.

  Veamos que $m$ es el entero buscado.

  - *$x < m$*, porque $m in C$.
  - *$m - 1 <= x$.* El entero $m - 1$ es menor que $m = op("mín") C$, así que $m - 1 in.not C$, o sea que no vale $x < m - 1$; por tricotomía, $m - 1 <= x$.

  Juntando todo,
  $ x < m <= x + 1 < y, $
  donde la última desigualdad es la hipótesis $y - x > 1$. Luego $m in ZZ$ y $x < m < y$.
]

// ---------------------------------------------------------------- (b)
#enunciado[Ejercicio 2 (b)][Sean $x, y in RR$ tales que $x < y$. Probar que existe un racional entre $x$ e $y$.]

#resolucion[Propuesta: $q = m / n$ con $n$ de la Proposición 1 y $m$ del ítem (a)][
  Sean $x, y in RR$ con $x < y$. Entonces $y - x > 0$, y por la Proposición 1 (Principio de Arquímedes 2) existe $n in NN$ tal que
  $ 0 < 1/n < y - x. $
  Multiplicando por $n > 0$ (no cambia el sentido de la desigualdad) queda
  $ 1 < n (y - x) = n y - n x. $
  Los números $n x$ y $n y$ son reales con $n y - n x > 1$, así que por el Ej. 2 (a) existe $m in ZZ$ con
  $ n x < m < n y. $
  Dividiendo por $n > 0$,
  $ x < m / n < y. $
  Como $m in ZZ$ y $n in NN$, $n != 0$, el número $q = m / n$ es racional y cumple $x < q < y$.
]

// ---------------------------------------------------------------- (c)
#sublema(titulo: "Sublema 1 (deducción propia): √2 no es racional")[
  Llamamos $sqrt(2)$ al real positivo cuyo cuadrado es $2$ (su existencia es un hecho de base; en Lean es `Real.sqrt 2`). Supongamos que $sqrt(2) in QQ$. Escribimos $sqrt(2) = a / b$ como fracción reducida, con $a in ZZ$, $b in NN$, $b >= 1$ y $op("mcd")(a, b) = 1$ (toda fracción tiene una forma reducida: hecho de base). Elevando al cuadrado y multiplicando por $b^2$,
  $ a^2 = 2 b^2. $

  - *$a$ es par.* Si $a$ fuera impar, $a = 2 k + 1$ con $k in ZZ$, tendríamos $a^2 = 4 k^2 + 4 k + 1 = 2 (2 k^2 + 2 k) + 1$, impar; pero $a^2 = 2 b^2$ es par. Luego $a = 2 k$ para algún $k in ZZ$.
  - *$b$ es par.* Reemplazando, $4 k^2 = 2 b^2$, es decir $b^2 = 2 k^2$ es par, y por el mismo argumento de paridad $b$ es par.

  Entonces $2 divides a$ y $2 divides b$, de modo que $2 divides op("mcd")(a, b) = 1$, absurdo. Por lo tanto $sqrt(2) in.not QQ$. $qed$
]

#sublema(titulo: "Sublema 2 (deducción propia): racional + irracional y racional no nulo · irracional")[
  Sea $t in RR$ con $t in.not QQ$ y sea $q in QQ$.

  - *$q + t in.not QQ$.* Si fuera $q + t = s in QQ$, entonces $t = s - q in QQ$ (la resta de racionales es racional), absurdo.
  - *Si $q != 0$, $q t in.not QQ$.* Si fuera $q t = s in QQ$, como $q != 0$ tendríamos $t = s / q in QQ$ (el cociente de racionales con denominador no nulo es racional), absurdo. $qed$
]

#enunciado[Ejercicio 2 (c)][Sean $x, y in QQ$ tales que $x < y$. Probar que existe un irracional entre $x$ e $y$.]

#resolucion[Propuesta: $z = x + ((y - x)/2) sqrt(2)$ es irracional y $x < z < y$][
  Sean $x, y in QQ$ con $x < y$ y sea
  $ z = x + (y - x)/2 dot sqrt(2). $

  *$z$ es irracional.* El número $(y - x)/2$ es racional y no nulo (porque $y - x > 0$). Por el Sublema 1, $sqrt(2) in.not QQ$; por el Sublema 2 (producto), $((y - x)/2) sqrt(2) in.not QQ$; y por el Sublema 2 (suma) con el racional $x$, $z in.not QQ$.

  *$0 < sqrt(2)/2 < 1$.* Por definición $sqrt(2) > 0$. Además $sqrt(2) < 2$: si fuera $sqrt(2) >= 2$, multiplicando por $sqrt(2) > 0$ tendríamos $2 = (sqrt(2))^2 >= 2 sqrt(2) >= 4$, absurdo. Dividiendo por $2$, $0 < sqrt(2)/2 < 1$.

  *$x < z < y$.* Como $y - x > 0$, multiplicando la desigualdad anterior por $y - x$ queda
  $ 0 < (y - x) dot sqrt(2)/2 < y - x, $
  y sumando $x$ en los tres miembros, $x < z < y$.
]

// ---------------------------------------------------------------- (d)
#enunciado[Ejercicio 2 (d)][Sean $x, y in RR$ tales que $x < y$. Probar que existe un irracional entre $x$ e $y$.]

#resolucion[Propuesta: dos racionales por (b) y un irracional entre ellos por (c)][
  Sean $x, y in RR$ con $x < y$. Por el Ej. 2 (b) existe $q_1 in QQ$ con $x < q_1 < y$. Como $q_1 < y$, otra vez por el Ej. 2 (b) existe $q_2 in QQ$ con $q_1 < q_2 < y$. Ahora $q_1, q_2 in QQ$ y $q_1 < q_2$, así que por el Ej. 2 (c) existe $z in.not QQ$ con $q_1 < z < q_2$. En total,
  $ x < q_1 < z < q_2 < y, $
  y $z$ es un irracional entre $x$ e $y$.
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej02`][
  Los cuatro ítems están en un solo archivo, encadenados como en el texto: `ej2a {x y : ℝ} (h : 1 < y - x) : ∃ m : ℤ, x < m ∧ m < y`, `ej2b {x y : ℝ} (h : x < y) : ∃ q : ℚ, x < q ∧ q < y`, `ej2c {x y : ℚ} (h : x < y) : ∃ z : ℝ, Irrational z ∧ x < z ∧ z < y` y `ej2d {x y : ℝ} (h : x < y) : ∃ z : ℝ, Irrational z ∧ x < z ∧ z < y`. `Irrational z` es sólo la definición de Mathlib `z ∉ Set.range ((↑) : ℚ → ℝ)`, "no es la imagen de ningún racional".

  - *(a)* usa `arquimedes` (Teorema 1) dos veces, para $-x$ y para $x + N$, y el buen orden vía `Nat.find` sobre el predicado trasladado $k |-> x < k - N$ con $k in NN$ (sin `Int.floor` ni `Int.ceil`): el mínimo $k_0$ da $m = k_0 - N$, y `Nat.find_min` es la minimalidad "$m - 1 in.not C$" (si $k_0 = 0$, $m - 1 = -N - 1 <= x$ directamente). Es exactamente la traslación por $N$ que el texto invoca para el buen orden de $ZZ$.
  - *(b)* usa `arquimedes2` (Proposición 1) y `ej2a`; las dos divisiones por $n$ son `lt_div_iff₀` y `div_lt_iff₀`. No se usa `densidad_Q` ni `exists_rat_btwn`.
  - *(c)*: `sqrt_two_irrational : Irrational (Real.sqrt 2)` es el Sublema 1, probado localmente por paridad con `r.num`, `r.den` y `Rat.reduced` (la forma reducida, hecho de base) y `Int.dvd_gcd`; el paso "$a^2$ par $=>$ $a$ par" es `Int.even_pow` (lema elemental de paridad de Mathlib, equivalente a "impar al cuadrado es impar"). `irrational_rat_add` e `irrational_rat_mul` son el Sublema 2. La existencia de $sqrt(2)$ es `Real.sqrt 2` con `Real.sq_sqrt`, y $sqrt(2) < 2$ sale con `nlinarith` de $(sqrt(2))^2 = 2$. No se usa `irrational_sqrt_two`, `Irrational.rat_add`, `Irrational.rat_mul` ni `exists_irrational_btwn`.
  - *(d)* es `ej2b` dos veces y `ej2c`, con la cadena $x < q_1 < z < q_2 < y$.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)
