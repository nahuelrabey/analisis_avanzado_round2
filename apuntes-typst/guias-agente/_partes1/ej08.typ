== Ejercicio 8

#enunciado[Ejercicio 8][
  Sean $(x_n)_(n in NN)$ y $(a_n)_(n in NN)$ sucesiones de números reales. Probar que si
  $abs(x_n - ell) <= a_n$ para todo $n in NN$ y $a_n ->_(n -> oo) 0$ entonces
  $x_n ->_(n -> oo) ell$.
]

#estrategia[El $n_0$ de $a_n -> 0$ sirve tal cual para $x_n -> ell$][
  Es el lema general detrás de los ítems (b) y (c) del Ejercicio 7: si la distancia
  $abs(x_n - ell)$ está dominada por algo que tiende a $0$, también tiende a $0$. Dado
  $epsilon > 0$, la Definición 7 para $a_n -> 0$ da un $n_0$ con $abs(a_n - 0) < epsilon$ a partir
  de $n_0$; y como $abs(x_n - ell) <= a_n <= abs(a_n) = abs(a_n - 0)$, el mismo $n_0$ funciona
  para $x_n$. No hace falta ninguna otra herramienta.
]

#resolucion[Propuesta: $abs(x_n - ell) <= a_n <= abs(a_n - 0) < epsilon$ desde el mismo $n_0$][
  Sea $epsilon > 0$. Como $a_n -> 0$, por la Definición 7 (con $ell = 0$) existe $n_0 in NN$ tal
  que
  $ abs(a_n - 0) < epsilon quad "para todo " n >= n_0. $
  Veamos que ese mismo $n_0$ sirve para $(x_n)_(n in NN)$ y $ell$. Sea $n >= n_0$. Por
  hipótesis $abs(x_n - ell) <= a_n$; además todo real es menor o igual que su valor absoluto
  (hecho de base), así que $a_n <= abs(a_n) = abs(a_n - 0)$. Encadenando,
  $ abs(x_n - ell) <= a_n <= abs(a_n - 0) < epsilon. $
  (De paso: $a_n >= abs(x_n - ell) >= 0$, así que en realidad $a_n = abs(a_n)$, pero no hace
  falta usarlo.) Como $epsilon > 0$ era arbitrario, la Definición 7 dice que
  $x_n ->_(n -> oo) ell$.
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej08`][
  `ej8 {x a : ℕ → ℝ} {l : ℝ} (h : ∀ n, |x n - l| ≤ a n) (ha : Converge a 0) : Converge x l`.
  La prueba despliega `Converge`: `intro ε hε`, `obtain ⟨n₀, hn₀⟩ := ha ε hε`, se devuelve el
  mismo `n₀` y se cierra con el `calc` de tres pasos `h n`, `le_abs_self (a n)` y `hn₀ n hn`
  (después de `rw [sub_zero]`). No se usa `squeeze_zero` ni `Tendsto`. Como las hipótesis valen
  para todo $n$ y el $n_0$ es el mismo, que en Lean los índices empiecen en $0$ no cambia nada.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)
