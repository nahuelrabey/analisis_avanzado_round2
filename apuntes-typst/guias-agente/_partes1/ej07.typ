== Ejercicio 7

#enunciado[Ejercicio 7][
  Probar, usando la definición de límite:
  #set enum(numbering: "(a)")
  + $lim_(n -> oo) (3 - 2n)/(n + 1) = -2$.
  + $lim_(n -> oo) (op("sen")(n))/n = 0$.
  + $lim_(n -> oo) (2^n - 3)/(2^n + 4) = 1$.
]

#estrategia[Calcular $abs(a_n - ell)$ exactamente, acotarla por $c/n$ y pedirle a Arquímedes el $n_0$][
  Los tres ítems siguen la Definición 7 al pie de la letra: se fija $epsilon > 0$, se calcula
  $abs(a_n - ell)$ con una cuenta exacta (en (a) da $5/(n + 1)$, en (c) da $7/(2^n + 4)$, en (b)
  es $abs(op("sen")(n))/n$) y se la acota por algo de la forma $c/n$. En (a) se despeja
  directamente $n + 1 > 5/epsilon$ y el Teorema 1 (Principio de Arquímedes) da el $n_0$; en (b)
  y (c) primero hay que acotar el numerador ($abs(op("sen")(n)) <= 1$) o el denominador
  ($2^n >= n$, un sublema por inducción), y después la Proposición 1 (Principio de Arquímedes 2)
  da un $n_0$ con $1/n_0 < epsilon/c$. En los tres casos la cuenta final es
  $abs(a_n - ell) <= c/n <= c/n_0 < epsilon$ para todo $n >= n_0$.
]

// ---------------------------------------------------------------- (a)
#enunciado[Ejercicio 7 (a)][
  $lim_(n -> oo) (3 - 2n)/(n + 1) = -2$.
]

#resolucion[Propuesta: $abs(a_n + 2) = 5/(n + 1)$ y el $n_0$ sale del Teorema 1][
  Sea $a_n = (3 - 2n)/(n + 1)$ y $ell = -2$. Primero la cuenta exacta: para todo $n in NN$
  (y de hecho para todo $n >= 0$, porque $n + 1 > 0$),
  $ a_n - (-2) = (3 - 2n)/(n + 1) + 2 = (3 - 2n + 2(n + 1))/(n + 1) = 5/(n + 1) > 0, $
  de modo que
  $ abs(a_n - (-2)) = 5/(n + 1). $

  Sea ahora $epsilon > 0$. Como $n + 1 > 0$ y $epsilon > 0$, multiplicando por el positivo
  $(n + 1)/epsilon$ se tiene la equivalencia
  $ 5/(n + 1) < epsilon <=> 5/epsilon < n + 1, $
  así que basta conseguir que $n + 1 > 5/epsilon$ a partir de algún $n_0$. Por el Teorema 1
  (Principio de Arquímedes) aplicado a $x = 5/epsilon in RR$, existe $n_0 in NN$ tal que
  $5/epsilon <= n_0$. Si $n >= n_0$, entonces
  $ n + 1 > n >= n_0 >= 5/epsilon, $
  luego $epsilon (n + 1) > 5$ y, dividiendo por $n + 1 > 0$,
  $ abs(a_n - (-2)) = 5/(n + 1) < epsilon quad "para todo " n >= n_0. $
  Esto es exactamente la Definición 7 con $ell = -2$: $lim_(n -> oo) a_n = -2$.
]

// ---------------------------------------------------------------- (b)
#enunciado[Ejercicio 7 (b)][
  $lim_(n -> oo) (op("sen")(n))/n = 0$.
]

#resolucion[Propuesta: $abs(a_n - 0) <= 1/n$ y el $n_0$ sale de la Proposición 1][
  Sea $a_n = (op("sen")(n))/n$ y $ell = 0$. Usamos el hecho de base $abs(op("sen")(x)) <= 1$ para
  todo $x in RR$ (no se puede despejar $n$ de $abs(op("sen")(n))/n < epsilon$: hay que acotar el
  numerador primero). Para todo $n in NN$ (es decir, $n >= 1$, de modo que $n > 0$ y
  $abs(n) = n$),
  $ abs(a_n - 0) = abs((op("sen")(n))/n) = abs(op("sen")(n))/n <= 1/n. $

  Sea $epsilon > 0$. Por la Proposición 1 (Principio de Arquímedes 2) aplicada a $y = epsilon$,
  existe $n_0 in NN$ tal que $0 < 1/n_0 < epsilon$. Si $n >= n_0$, como $0 < n_0 <= n$,
  tomar inversos invierte la desigualdad (hecho de base del orden de $RR$): $1/n <= 1/n_0$.
  Entonces
  $ abs(a_n - 0) <= 1/n <= 1/n_0 < epsilon quad "para todo " n >= n_0, $
  que es la Definición 7 con $ell = 0$: $lim_(n -> oo) (op("sen")(n))/n = 0$.
]

// ---------------------------------------------------------------- (c)
#enunciado[Ejercicio 7 (c)][
  $lim_(n -> oo) (2^n - 3)/(2^n + 4) = 1$.
]

#sublema(titulo: "Sublema: n ≤ 2ⁿ para todo n ∈ ℕ (deducción propia, por inducción)")[
  Para $n = 1$: $1 <= 2 = 2^1$ (y también vale para $n = 0$: $0 <= 1 = 2^0$, que es el caso
  base que usa Lean). Paso inductivo: si $n <= 2^n$, entonces, como $2^n >= 1$,
  $ n + 1 <= 2^n + 1 <= 2^n + 2^n = 2 dot 2^n = 2^(n + 1). $
  Por inducción, $n <= 2^n$ para todo $n in NN$. En particular, como $n > 0$, también
  $1/2^n <= 1/n$ (tomar inversos de positivos invierte la desigualdad). $qed$
]

#resolucion[Propuesta: $abs(a_n - 1) <= 7/n$ y el $n_0$ sale de la Proposición 1][
  Sea $a_n = (2^n - 3)/(2^n + 4)$ y $ell = 1$. La cuenta exacta, válida para todo $n$ porque
  $2^n + 4 > 0$:
  $ a_n - 1 = (2^n - 3)/(2^n + 4) - (2^n + 4)/(2^n + 4) = (2^n - 3 - 2^n - 4)/(2^n + 4) = (-7)/(2^n + 4), $
  de modo que
  $ abs(a_n - 1) = 7/(2^n + 4). $

  Ahora acotamos el denominador por abajo para que quede algo de la forma $c/n$: como
  $2^n + 4 > 2^n >= n > 0$ (la segunda desigualdad es el Sublema), tomando inversos
  $ abs(a_n - 1) = 7/(2^n + 4) < 7/2^n <= 7/n quad "para todo " n in NN. $

  Sea $epsilon > 0$. Como $epsilon/7 > 0$, la Proposición 1 (Principio de Arquímedes 2) aplicada
  a $y = epsilon/7$ da $n_0 in NN$ con $0 < 1/n_0 < epsilon/7$. Si $n >= n_0$, entonces
  $1/n <= 1/n_0$ (inversos de positivos) y
  $ abs(a_n - 1) <= 7/n = 7 dot 1/n <= 7 dot 1/n_0 < 7 dot epsilon/7 = epsilon
    quad "para todo " n >= n_0. $
  Por la Definición 7, $lim_(n -> oo) a_n = 1$.
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej07`][
  `ej7a : Converge (fun n : ℕ => (3 - 2 * (n : ℝ)) / (n + 1)) (-2)`,
  `ej7b : Converge (fun n : ℕ => Real.sin n / n) 0` y
  `ej7c : Converge (fun n : ℕ => ((2 : ℝ) ^ n - 3) / (2 ^ n + 4)) 1`, con `Converge` desplegada
  (`intro ε hε`, `obtain ⟨n₀, _⟩ := arquimedes (5 / ε)` en (a) y `arquimedes2` en (b) y (c),
  `refine ⟨n₀, fun n hn => ?_⟩`) y la misma cadena de desigualdades que arriba: la cuenta exacta
  de $a_n - ell$ es un `field_simp; ring`, y las cotas son `div_le_div_of_nonneg_right`,
  `div_le_div_of_nonneg_left`, `one_div_le_one_div_of_le` y `linarith`. El hecho de base
  $abs(op("sen")(x)) <= 1$ es `Real.abs_sin_le_one`; el Sublema $n <= 2^n$ se prueba localmente
  por inducción (`le_two_pow`, con `Nat.one_le_two_pow` para $1 <= 2^n$), no se usa
  `Nat.lt_two_pow_self`. No se pasa por `Tendsto`.

  Desvíos: en Lean los índices empiezan en $n = 0$. En (a) y (c) la cuenta vale igual
  ($n + 1 > 0$ y $2^n + 4 > 0$ también para $n = 0$). En (b), `Real.sin 0 / 0 = 0` por la
  convención `x / 0 = 0` de Lean, pero no hace falta tratarlo aparte: `arquimedes2` entrega
  `0 < 1 / n₀`, que fuerza $n_0 >= 1$ (`one_div_pos`), así que los $n >= n_0$ que se miran son
  todos $>= 1$, como en el curso.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)
