== Ejercicio 9

#enunciado[Ejercicio 9][
  Si $(x_n)_(n in NN)$ e $(y_n)_(n in NN)$ son sucesiones de números reales tales que
  $x_n ->_(n -> oo) ell_1$ e $y_n ->_(n -> oo) ell_2$, probar que
  $x_n + y_n ->_(n -> oo) ell_1 + ell_2$ para el caso en que:
  #set enum(numbering: "(a)")
  + $ell_1, ell_2 in RR$.
  + $ell_1 in RR$ y $ell_2 = oo$.
  + $ell_1 = +oo = ell_2$.
  + Pensar por qué no vale en el caso en que $ell_1 = +oo$ y $ell_2 = -oo$. Dar un contraejemplo
    para este caso.
]

#estrategia[Repartir el $epsilon$ (o el $M$) entre las dos sucesiones y tomar $n_0 = op("máx")(n_1, n_2)$][
  En los tres casos positivos la receta es la misma: cada hipótesis da un umbral ($n_1$ para
  $x_n$, $n_2$ para $y_n$) y a partir de $n_0 = op("máx")(n_1, n_2)$ valen las dos cotas a la
  vez. En (a) se reparte $epsilon/2 + epsilon/2$ y se usa la desigualdad triangular; en (c) se
  reparte $M/2 + M/2$. En (b) la sucesión convergente aporta una *cota inferior* $x_n > ell_1 - 1$
  (Definición 7 con $epsilon = 1$) y la divergente aporta el resto, $y_n > M + 1 - ell_1$
  (Definición 8, con un $M' > 0$ adecuado). En (d) ese esquema se rompe: $y_n -> -oo$ no da
  ninguna cota inferior de $y_n$, y los contraejemplos muestran que la suma puede hacer cualquier
  cosa. El ítem (a) es el ítem b de la Proposición 6 (Álgebra de límites), que `apuntes.typ`
  deja como ejercicio de la guía: acá se demuestra desde la Definición 7, sin citarlo.
]

// ---------------------------------------------------------------- (a)
#enunciado[Ejercicio 9 (a)][
  $ell_1, ell_2 in RR$: si $x_n -> ell_1$ e $y_n -> ell_2$, entonces $x_n + y_n -> ell_1 + ell_2$.
]

#resolucion[Propuesta: $epsilon/2 + epsilon/2$ con $n_0 = op("máx")(n_1, n_2)$][
  Sea $epsilon > 0$. Como $epsilon/2 > 0$, la Definición 7 para $x_n -> ell_1$ da $n_1 in NN$
  con $abs(x_n - ell_1) < epsilon/2$ para todo $n >= n_1$, y para $y_n -> ell_2$ da $n_2 in NN$
  con $abs(y_n - ell_2) < epsilon/2$ para todo $n >= n_2$. Sea $n_0 = op("máx")(n_1, n_2)$. Si
  $n >= n_0$, entonces $n >= n_1$ y $n >= n_2$, así que valen las dos cotas y, por la desigualdad
  triangular (hecho de base),
  $ abs((x_n + y_n) - (ell_1 + ell_2)) = abs((x_n - ell_1) + (y_n - ell_2))
    <= abs(x_n - ell_1) + abs(y_n - ell_2) < epsilon/2 + epsilon/2 = epsilon. $
  Como $epsilon > 0$ era arbitrario, la Definición 7 dice que $x_n + y_n -> ell_1 + ell_2$.
]

// ---------------------------------------------------------------- (b)
#enunciado[Ejercicio 9 (b)][
  $ell_1 in RR$ y $ell_2 = +oo$: si $x_n -> ell_1$ e $y_n -> +oo$, entonces $x_n + y_n -> +oo$.
]

#resolucion[Propuesta: $x_n > ell_1 - 1$ desde $n_1$ e $y_n > M + 1 - ell_1$ desde $n_2$][
  Sea $M > 0$. Hay que encontrar $n_0$ con $x_n + y_n > M$ para todo $n >= n_0$ (Definición 8).

  _Cota inferior de $x_n$._ Por la Definición 7 con $epsilon = 1$, existe $n_1 in NN$ tal que
  $abs(x_n - ell_1) < 1$ para todo $n >= n_1$; en particular $x_n - ell_1 > -1$, es decir
  $ x_n > ell_1 - 1 quad "para todo " n >= n_1. $

  _Cota inferior de $y_n$._ Queremos $y_n > M + 1 - ell_1$, pero la Definición 8 sólo se puede
  aplicar a un número *positivo*, y $M + 1 - ell_1$ podría ser $<= 0$ (si $ell_1 >= M + 1$). Por
  eso tomamos
  $ M' = op("máx")(M + 1 - ell_1, 1) >= 1 > 0. $
  Por la Definición 8 para $y_n -> +oo$ aplicada a $M'$, existe $n_2 in NN$ tal que
  $y_n > M' >= M + 1 - ell_1$ para todo $n >= n_2$.

  _Conclusión._ Sea $n_0 = op("máx")(n_1, n_2)$. Si $n >= n_0$ valen las dos cotas y, sumándolas,
  $ x_n + y_n > (ell_1 - 1) + (M + 1 - ell_1) = M. $
  Como $M > 0$ era arbitrario, $x_n + y_n -> +oo$ por la Definición 8.
]

// ---------------------------------------------------------------- (c)
#enunciado[Ejercicio 9 (c)][
  $ell_1 = +oo = ell_2$: si $x_n -> +oo$ e $y_n -> +oo$, entonces $x_n + y_n -> +oo$.
]

#resolucion[Propuesta: $M/2 + M/2$ con $n_0 = op("máx")(n_1, n_2)$][
  Sea $M > 0$. Como $M/2 > 0$, la Definición 8 para $x_n -> +oo$ da $n_1 in NN$ con
  $x_n > M/2$ para todo $n >= n_1$, y para $y_n -> +oo$ da $n_2 in NN$ con $y_n > M/2$ para todo
  $n >= n_2$. Sea $n_0 = op("máx")(n_1, n_2)$. Si $n >= n_0$ valen las dos cotas y
  $ x_n + y_n > M/2 + M/2 = M. $
  Como $M > 0$ era arbitrario, $x_n + y_n -> +oo$ por la Definición 8.
]

// ---------------------------------------------------------------- (d)
#enunciado[Ejercicio 9 (d)][
  Pensar por qué no vale en el caso en que $ell_1 = +oo$ y $ell_2 = -oo$. Dar un contraejemplo
  para este caso.
]

#sublema(titulo: "Sublema: n → +∞, 2n → +∞, −n → −∞ y −2n → −∞ (deducción propia)")[
  Sea $M > 0$. Por el Teorema 1 (Principio de Arquímedes) aplicado a $x = M + 1$, existe
  $n_0 in NN$ con $M + 1 <= n_0$. Si $n >= n_0$, entonces $n >= M + 1 > M$. De ahí, para todo
  $n >= n_0$:
  $ 2n >= n > M, quad -n < -M, quad -2n <= -n < -M $
  (la última usa $n >= 0$). Por la Definición 8, $n -> +oo$, $2n -> +oo$, $-n -> -oo$ y
  $-2n -> -oo$. $qed$
]

#resolucion[Propuesta: no hay conclusión posible; tres contraejemplos distintos][
  _Por qué falla el argumento._ En (b) y (c) la suma se controla porque *las dos* sucesiones
  aportan una cota inferior a partir de algún $n$: $x_n > "algo"$ e $y_n > "algo"$, y sumar cotas
  inferiores da una cota inferior de $x_n + y_n$. Si $y_n -> -oo$, la Definición 8 dice
  $y_n < -M'$ a partir de un $n_2$: es una cota *superior*, no inferior, y de hecho $y_n$ no está
  acotada inferiormente. Entonces las hipótesis $x_n > M$ e $y_n < -M'$ no dicen nada sobre el
  signo ni el tamaño de $x_n + y_n$: es una "indeterminación $oo - oo$", y lo que pase depende de
  cuán rápido crece cada una.

  _Contraejemplos._ En los tres pares, $x_n -> +oo$ e $y_n -> -oo$ por el Sublema, y sin embargo:

  + $x_n = n$, $y_n = -n$: $x_n + y_n = 0$ para todo $n$, y la sucesión constante $0$ converge a
    $0$ (Definición 7: $abs(0 - 0) = 0 < epsilon$ para todo $n$, con cualquier $n_0$).
  + $x_n = 2n$, $y_n = -n$: $x_n + y_n = n -> +oo$ (Sublema).
  + $x_n = n$, $y_n = -2n$: $x_n + y_n = -n -> -oo$ (Sublema).

  Estos tres comportamientos son incompatibles entre sí (por ejemplo, una sucesión que converge
  a $0$ cumple $abs(a_n) < 1$ a partir de un $n_0$, mientras que una que diverge a $+oo$ cumple
  $a_n > 1$ a partir de otro; las dos cosas no pueden pasar a la vez para $n$ grande), así que no
  hay ningún enunciado general de la forma "$x_n + y_n -> ell$" que valga con las hipótesis
  $ell_1 = +oo$, $ell_2 = -oo$: la primera pareja ya es el contraejemplo pedido.
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej09`][
  `ej9a (hx : Converge x l₁) (hy : Converge y l₂) : Converge (fun n => x n + y n) (l₁ + l₂)`,
  `ej9b (hx : Converge x l₁) (hy : DivergeMasInf y) : DivergeMasInf (fun n => x n + y n)`,
  `ej9c (hx : DivergeMasInf x) (hy : DivergeMasInf y) : DivergeMasInf (fun n => x n + y n)`, y
  para (d) tres teoremas de existencia, `ej9d_converge`, `ej9d_masInf` y `ej9d_menosInf`, de la
  forma `∃ x y : ℕ → ℝ, DivergeMasInf x ∧ DivergeMenosInf y ∧ P (fun n => x n + y n)` con
  `P` igual a `Converge · 0`, `DivergeMasInf` y `DivergeMenosInf` respectivamente, con los testigos
  $(n, -n)$, $(2n, -n)$ y $(n, -2n)$ del texto.

  Todo se hace desplegando `Converge` y `DivergeMasInf` / `DivergeMenosInf`: en (a) el mismo
  $n_0 = $ `max n₁ n₂`, `abs_add_le` para la triangular y `linarith`; en (b) `hx 1 one_pos`,
  `abs_lt` para pasar de $abs(x_n - ell_1) < 1$ a $x_n > ell_1 - 1$, y el mismo
  `M' = max (M + 1 - l₁) 1` con `le_max_right` para ver $M' > 0$; en (c) `M / 2`. El ítem (a)
  **no** usa `algebra_limites_add` (es el ítem b de la Proposición 6, excluido por circularidad)
  ni `Filter.Tendsto.add`. El Sublema es `exists_nat_gt_of_ge` (Teorema 1, `arquimedes (M + 1)`)
  y de él salen `divergeMasInf_id`, `divergeMasInf_two_mul`, `divergeMenosInf_neg_id` y
  `divergeMenosInf_neg_two_mul`; la suma de cada par se reescribe con `funext; ring`. No se pasa
  por `Tendsto` en ningún ítem.

  Desvío: en Lean los índices empiezan en $n = 0$. En (a)-(c) no interviene; en el Sublema la
  desigualdad $-2n <= -n$ usa $n >= 0$, que vale también para $n = 0$, y el $n_0$ que da
  `arquimedes (M + 1)` es el mismo.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)
