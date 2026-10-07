== Ejercicio 12

#enunciado[Ejercicio 12][
  Sea $(x_n)_(n in NN) subset.eq RR$ decreciente. Probar que:
  #set enum(numbering: "(a)")
  + Si $(x_n)_(n in NN)$ es acotada inferiormente, entonces tiene límite y
    $ lim_(n -> oo) x_n = op("ínf")\{x_n : n in NN\}. $
  + Si $(x_n)_(n in NN)$ es no acotada inferiormente, entonces $x_n ->_(n -> oo) -oo$.
]
#estrategia[El espejo de la Proposición 8, con ínfimos en lugar de supremos][
  Llamamos $X = {x_n : n in NN}$. En (a), el Teorema 2 garantiza que existe $i = op("ínf")(X)$,
  y la Proposición 5 (Equivalencia de Ínfimo) da, para cada $epsilon > 0$, un término
  $x_(n_0) < i + epsilon$. Como la sucesión es decreciente, todos los términos posteriores quedan
  encajados: $i <= x_n <= x_(n_0) < i + epsilon$ para $n >= n_0$. En (b) el cuantificador es el
  de la Definición 8: dado $M > 0$, el número $-M$ no puede ser cota inferior, así que algún
  $x_(n_0) < -M$ y, otra vez por decreciente, $x_n <= x_(n_0) < -M$ de ahí en adelante. Las dos
  veces hace falta "$x_n <= x_m$ si $n >= m$", que es el sublema de abajo.

  *Sobre la hipótesis "decreciente".* Tomamos la Definición 10 en su primera forma:
  $x_(n+1) <= x_n$ *para todo* $n in NN$ (así está también en `Defs.lean`). La Definición 10
  admite además "a partir de algún $n_0$", pero con esa lectura el ítem (a) es falso tal como está
  escrito: la sucesión $x_1 = -10$, $x_n = 1 / n$ para $n >= 2$ es decreciente a partir de
  $n_0 = 2$, está acotada inferiormente, converge a $0$, y sin embargo
  $op("ínf")\{x_n : n in NN\} = -10 != 0$. Con monotonía desde $n_0$ lo que vale es
  $lim x_n = op("ínf")\{x_n : n >= n_0\}$, y el ítem (b) sigue valiendo igual (el argumento
  sólo usa los índices $n >= n_0$).
]

#sublema(titulo: "Sublema (deducción propia): una decreciente lo es entre índices cualesquiera")[
  Si $(x_n)_(n in NN)$ es decreciente (es decir, $x_(k+1) <= x_k$ para todo $k$) y $m <= n$,
  entonces $x_n <= x_m$.

  *Prueba.* Fijado $m$, por inducción en $n >= m$. Si $n = m$ es $x_m <= x_m$. Si vale
  $x_n <= x_m$ para un $n >= m$, entonces $x_(n+1) <= x_n <= x_m$, donde la primera desigualdad es
  la Definición 10 en $k = n$. $qed$
]

// ---------------------------------------------------------------- (a)
#enunciado[Ejercicio 12 (a)][
  Si $(x_n)_(n in NN)$ es acotada inferiormente, entonces tiene límite y
  $lim_(n -> oo) x_n = op("ínf")\{x_n : n in NN\}$.
]
#resolucion[Propuesta: $x_n -> op("ínf")\{x_n : n in NN\}$][
  Sea $X = {x_n : n in NN} subset.eq RR$. Es no vacío ($x_1 in X$) y, por hipótesis, acotado
  inferiormente. Por el Teorema 2 (Completitud en términos de ínfimos) existe $i = op("ínf")(X)$.
  Veamos que $x_n -> i$ por la Definición 7.

  Sea $epsilon > 0$. Por la Proposición 5 (Equivalencia de Ínfimo), como $i = op("ínf")(X)$,
  existe un elemento de $X$ menor que $i + epsilon$; los elementos de $X$ son los términos de la
  sucesión, así que existe $n_0 in NN$ tal que
  $ x_(n_0) < i + epsilon. $

  Sea $n >= n_0$. Por un lado $i <= x_n$, porque $i$ es cota inferior de $X$ y $x_n in X$
  (Definición 5, ítem a). Por el otro, $x_n <= x_(n_0)$ por el Sublema (con $m = n_0$). Entonces
  $ 0 <= x_n - i <= x_(n_0) - i < epsilon, $
  y por lo tanto $abs(x_n - i) = x_n - i < epsilon$. Esto vale para todo $n >= n_0$, que es la
  Definición 7 de $x_n -> i$. Así, $(x_n)_(n in NN)$ tiene límite y
  $lim_(n -> oo) x_n = i = op("ínf")\{x_n : n in NN\}$. $qed$
]

// ---------------------------------------------------------------- (b)
#enunciado[Ejercicio 12 (b)][
  Si $(x_n)_(n in NN)$ es no acotada inferiormente, entonces $x_n ->_(n -> oo) -oo$.
]
#resolucion[Propuesta: $x_n -> -oo$][
  Usamos la Definición 8 (Divergencia de Sucesiones). Sea $M > 0$. Como
  $X = {x_n : n in NN}$ no está acotado inferiormente, ningún número real es cota inferior de $X$
  (Definición 4); en particular $-M$ no lo es. Negar "$-M <= x$ para todo $x in X$" da que existe
  $x in X$ con $x < -M$, es decir, existe $n_0 in NN$ tal que
  $ x_(n_0) < -M. $

  Sea $n >= n_0$. Por el Sublema, $x_n <= x_(n_0)$, y entonces
  $ x_n <= x_(n_0) < -M. $
  Encontramos, para cada $M > 0$, un $n_0$ tal que $x_n < -M$ para todo $n >= n_0$: es la
  Definición 8 de $x_n -> -oo$. $qed$
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej12`][
  Con `hd : Decreciente x` (`∀ n, x (n + 1) ≤ x n`):
  `ej12a (hd) (hb : AcotadoInf (Set.range x)) : ∃ i, EsInf (Set.range x) i ∧ Converge x i` y
  `ej12b (hd) (hb : ¬ AcotadoInf (Set.range x)) : DivergeMenosInf x`. El Sublema es
  `decreciente_le (hd) (h : m ≤ n) : x n ≤ x m`, por inducción sobre la prueba de `m ≤ n`.
  En (a) el ínfimo viene de `completitud_inf` (Teorema 2) y el término $x_(n_0)$ de
  `equiv_inf` (Proposición 5, legítima acá: el ejercicio circular con ella es el 3); `abs_lt` y
  `linarith` hacen la cuenta $i <= x_n <= x_(n_0) < i + epsilon$. En (b), `push Not` sobre
  "$-M$ no es cota inferior" produce el $x_(n_0) < -M$ y se cierra con el Sublema.
  No se usa la Proposición 8 (`monotona_creciente_converge`), que es el espejo de (a), ni
  `tendsto_atTop_ciInf`, ni ningún lema `Tendsto`. Los índices en Lean empiezan en $0$ (el
  conjunto $X$ es `Set.range x`, no vacío por `Set.range_nonempty`), lo que no cambia nada.
  El contraejemplo de la estrategia ($x_1 = -10$, $x_n = 1/n$) es sólo un comentario sobre la
  lectura de la Definición 10 y no está formalizado.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)
