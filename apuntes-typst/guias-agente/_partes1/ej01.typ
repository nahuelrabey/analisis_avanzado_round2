== Ejercicio 1

#enunciado[Ejercicio 1][
  Probar que si $x < y + epsilon$ para todo $epsilon > 0$, entonces $x <= y$. Deducir que si $abs(x - y) < epsilon$ para todo $epsilon > 0$, entonces $x = y$.
]

#estrategia[Contrarrecíproco con $epsilon = x - y$, y después dos veces lo mismo][
  Para la primera parte suponemos $x > y$ y usamos la hipótesis con el único $epsilon$ que la rompe: $epsilon = x - y > 0$ da $x < y + (x - y) = x$. Para la segunda, $abs(x - y) < epsilon$ equivale a $-epsilon < x - y < epsilon$, que son las dos desigualdades $x < y + epsilon$ e $y < x + epsilon$; la primera parte aplicada a cada una da $x <= y$ e $y <= x$. No hace falta nada de sucesiones: todo sale del orden de $RR$.
]

// ---------------------------------------------------------------- primera parte
#enunciado[Ejercicio 1 (primera parte)][Si $x < y + epsilon$ para todo $epsilon > 0$, entonces $x <= y$.]

#resolucion[Propuesta: por el contrarrecíproco, con $epsilon_0 = x - y$][
  Sean $x, y in RR$ tales que $x < y + epsilon$ para todo $epsilon > 0$. Supongamos, por el absurdo, que $x > y$ (por tricotomía del orden de $RR$, es la única alternativa a $x <= y$). Entonces $epsilon_0 = x - y > 0$, y la hipótesis con $epsilon = epsilon_0$ dice
  $ x < y + epsilon_0 = y + (x - y) = x, $
  es decir $x < x$, que contradice la irreflexividad del orden. Luego $x <= y$.
]

// ---------------------------------------------------------------- segunda parte
#enunciado[Ejercicio 1 (segunda parte)][Si $abs(x - y) < epsilon$ para todo $epsilon > 0$, entonces $x = y$.]

#resolucion[Propuesta: la primera parte aplicada dos veces][
  Sean $x, y in RR$ tales que $abs(x - y) < epsilon$ para todo $epsilon > 0$. Fijemos $epsilon > 0$. Por la propiedad elemental del valor absoluto (hecho de base)
  $ abs(x - y) < epsilon <=> -epsilon < x - y < epsilon, $
  obtenemos las dos desigualdades
  $ x < y + epsilon quad "y" quad y < x + epsilon. $
  Como esto vale para todo $epsilon > 0$, la primera parte aplicada al par $(x, y)$ da $x <= y$, y aplicada al par $(y, x)$ da $y <= x$. Por antisimetría del orden, $x = y$.
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej01`][
  `ej1a {x y : ℝ} (h : ∀ ε > 0, x < y + ε) : x ≤ y` certifica la primera parte y `ej1b {x y : ℝ} (h : ∀ ε > 0, |x - y| < ε) : x = y` la segunda. La primera es el contrarrecíproco con `ε = x - y` (`by_contra` + `linarith`); la segunda aplica `ej1a` dos veces, con las dos mitades de `abs_lt` (`|x - y| < ε ↔ -ε < x - y ∧ x - y < ε`, el hecho de base sobre el valor absoluto) y cierra con `le_antisymm`. No se usa la Unicidad del límite (`unicidad_limite`, cuya demostración en `apuntes.typ` pasa por este ejercicio) ni ningún otro resultado de `Defs.lean`: la formalización sigue el texto sin desvíos.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)
