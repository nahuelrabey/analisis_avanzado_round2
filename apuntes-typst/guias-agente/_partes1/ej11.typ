== Ejercicio 11

#enunciado[Ejercicio 11][
  Si $(x_n)_(n in NN)$ e $(y_n)_(n in NN)$ son sucesiones de números reales tales que
  $(x_n)_(n in NN)$ converge a $0$ e $(y_n)_(n in NN)$ está acotada, probar que
  $(x_n y_n)_(n in NN)$ converge a $0$.
]
#estrategia[Acotar $abs(x_n y_n) <= M abs(x_n)$ y pedirle a $abs(x_n)$ que sea menor que $epsilon / M$][
  La sucesión acotada aporta una constante $M > 0$ con $abs(y_n) <= M$ para todo $n$
  (Definición 9). Entonces $abs(x_n y_n) = abs(x_n) abs(y_n) <= M abs(x_n)$, y como $x_n -> 0$
  podemos hacer $abs(x_n)$ tan chico como queramos: lo pedimos menor que $epsilon / M$. Es la
  misma cuenta que el caso $b = 0$ de la demostración del ítem c de la Proposición 6, pero acá
  no hace falta la Proposición 7 porque la cota $M$ ya viene en la hipótesis.
]

#resolucion[Propuesta: $x_n y_n -> 0$][
  Como $(y_n)_(n in NN)$ está acotada, por la Definición 9 (Sucesión Acotada) existe $M > 0$ tal
  que $abs(y_n) <= M$ para todo $n in NN$.

  Sea $epsilon > 0$. Como $M > 0$, el número $epsilon / M$ es positivo, así que por la
  Definición 7 (Convergencia de Sucesiones) aplicada a $x_n -> 0$ con $epsilon / M$ existe
  $n_0 in NN$ tal que
  $ abs(x_n - 0) = abs(x_n) < epsilon / M quad "para todo" n >= n_0. $

  Con ese $n_0$, para todo $n >= n_0$ tenemos
  $ abs(x_n y_n - 0) = abs(x_n y_n) = abs(x_n) abs(y_n) <= abs(x_n) dot M < epsilon / M dot M = epsilon. $
  En el "$<=$" usamos $abs(y_n) <= M$ y que $abs(x_n) >= 0$ (multiplicar una desigualdad por un
  número no negativo la conserva); en el "$<$" usamos $abs(x_n) < epsilon / M$ y $M > 0$.
  Esto es exactamente la Definición 7 para $x_n y_n -> 0$. $qed$
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej11`][
  `ej11 {x y : ℕ → ℝ} (hx : Converge x 0) (hy : Acotada y) : Converge (fun n => x n * y n) 0`.
  Se destruye `hy` en `M`, `0 < M` y `|y n| ≤ M`; dado $epsilon$, se aplica `hx` con `ε / M`
  (`div_pos`) y el mismo $n_0$ sirve; la cuenta es un `calc` con `abs_mul`,
  `mul_le_mul_of_nonneg_left` y `lt_div_iff₀` (que traduce $abs(x_n) < epsilon / M$ en
  $abs(x_n) dot M < epsilon$). No se usa la Proposición 7 (`convergente_acotada`), ni el ítem c
  de la Proposición 6 (`algebra_limites_mul`), ni ningún lema `Tendsto`: sólo las Definiciones
  7 y 9. No hay desvíos respecto del texto.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)
