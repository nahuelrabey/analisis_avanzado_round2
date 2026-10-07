== Ejercicio 10

#enunciado[Ejercicio 10][
  Sean $(x_n)_(n in NN), (y_n)_(n in NN)$ sucesiones de números reales tales que
  $x_n ->_(n -> oo) ell_1$ e $y_n ->_(n -> oo) ell_2$. Probar que si $x_n <= y_n$ para todo $n$,
  entonces $ell_1 <= ell_2$.
]
#estrategia[Por el absurdo: separar los dos límites con $epsilon = (ell_1 - ell_2) / 2$][
  Si fuera $ell_1 > ell_2$, el punto medio $(ell_1 + ell_2) / 2$ separa a los dos límites: con
  $epsilon = (ell_1 - ell_2) / 2$, los $x_n$ terminan por encima de $ell_1 - epsilon$ y los $y_n$
  por debajo de $ell_2 + epsilon$, y esos dos números son el mismo. Entonces, para $n$ grande,
  $x_n > y_n$, contra la hipótesis. Todo sale de la Definición 7 aplicada dos veces y de tomar
  $n_0 = op("máx")(n_1, n_2)$ para que las dos cotas valgan a la vez.
]

#resolucion[Propuesta: $ell_1 <= ell_2$][
  Supongamos, por el absurdo, que $ell_1 > ell_2$. Entonces
  $ epsilon = (ell_1 - ell_2) / 2 > 0, quad "y además" quad ell_1 - epsilon = (ell_1 + ell_2) / 2 = ell_2 + epsilon. $

  Como $x_n -> ell_1$, por la Definición 7 (Convergencia de Sucesiones) con este $epsilon$ existe
  $n_1 in NN$ tal que $abs(x_n - ell_1) < epsilon$ para todo $n >= n_1$. Del mismo modo, como
  $y_n -> ell_2$, existe $n_2 in NN$ tal que $abs(y_n - ell_2) < epsilon$ para todo $n >= n_2$.

  Sea $n_0 = op("máx")(n_1, n_2)$. Para $n = n_0$ valen las dos desigualdades a la vez. De
  $abs(x_(n_0) - ell_1) < epsilon$ se deduce $-epsilon < x_(n_0) - ell_1$, es decir
  $ x_(n_0) > ell_1 - epsilon, $
  y de $abs(y_(n_0) - ell_2) < epsilon$ se deduce $y_(n_0) - ell_2 < epsilon$, es decir
  $ y_(n_0) < ell_2 + epsilon. $
  Juntando las dos con la igualdad $ell_1 - epsilon = ell_2 + epsilon$,
  $ y_(n_0) < ell_2 + epsilon = ell_1 - epsilon < x_(n_0), $
  o sea $x_(n_0) > y_(n_0)$. Pero por hipótesis $x_n <= y_n$ para todo $n$, en particular
  $x_(n_0) <= y_(n_0)$: absurdo. Luego $ell_1 <= ell_2$. $qed$
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej10`][
  `ej10 {x y : ℕ → ℝ} {l₁ l₂ : ℝ} (hx : Converge x l₁) (hy : Converge y l₂) (hxy : ∀ n, x n ≤ y n) : l₁ ≤ l₂`.
  La prueba es la de arriba, paso por paso: `by_contra` y `push Not` dan $ell_2 < ell_1$, se
  aplica `hx` y `hy` con $epsilon = (ell_1 - ell_2) / 2$, se evalúan en `max n₁ n₂` y
  `abs_sub_lt_iff` desarma los dos valores absolutos; `linarith` cierra con $x_(n_0) <= y_(n_0)$.

  Este ejercicio es el ítem e de la Proposición 6 (Álgebra de límites), así que *no* se cita esa
  proposición (ni `algebra_limites_le` en Lean): se demuestra desde la Definición 7. En Lean
  tampoco se usa `le_of_tendsto_of_tendsto` ni `Filter.Tendsto`. La hipótesis del ejercicio es
  "para todo $n$"; el mismo argumento vale si $x_n <= y_n$ sólo desde algún $n_0'$ (basta tomar
  $n_0 = op("máx")(n_1, n_2, n_0')$), que es como lo enuncia la Proposición 6.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)
