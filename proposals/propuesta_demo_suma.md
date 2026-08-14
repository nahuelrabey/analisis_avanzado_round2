# Propuesta de Transcripción y Completitud: Demostración Álgebra de Límites (Suma)

Se ha redactado la demostración del límite de la suma de sucesiones para ser incorporada tanto en [`apuntes-typst/apuntes.typ`](file:///home/nahuel/study/analisis-avanzado/apuntes-typst/apuntes.typ) como en [`apuntes-typst/desafios.typ`](file:///home/nahuel/study/analisis-avanzado/apuntes-typst/desafios.typ).

---

## 1. Cambio propuesto para `apuntes-typst/apuntes.typ`

Reemplazar en las líneas 405-407 el bloque de demostración incompleto:

```typst
#demostracion[Álgebra de límites: Ítem b ($lim_(n -> oo) (a_n + b_n) = a + b$)][
  Sea $epsilon > 0$. Como $a_n -> a$ y $b_n -> b$, tenemos que:
  - Existe $n_1 in NN$ tal que para todo $n >= n_1$ se cumple $|a_n - a| < epsilon/2$.
  - Existe $n_2 in NN$ tal que para todo $n >= n_2$ se cumple $|b_n - b| < epsilon/2$.

  Tomando $n_0 = op("máx")(n_1, n_2)$, si $n >= n_0$ se cumplen ambas desigualdades simultáneamente. Por lo tanto:

  $
    abs((a_n + b_n) - (a + b)) &= abs((a_n - a) + (b_n - b)) \
      &<= abs(a_n - a) + abs(b_n - b) \
      &< epsilon/2 + epsilon/2 = epsilon.
  $

  Esto demuestra que $lim_(n -> oo) (a_n + b_n) = a + b$.
]
```

---

## 2. Cambio propuesto para `apuntes-typst/desafios.typ`

Agregar la etiqueta `#solucion[...]` inmediatamente después del `#desafio[Álgebra de Límites - Ítem b (Límite de la suma de sucesiones)]` en la línea 181:

```typst
#desafio[Álgebra de Límites - Ítem b (Límite de la suma de sucesiones)][
  Sean $(a_n)_(n in NN)$ y $(b_n)_(n in NN)$ dos sucesiones reales tales que $lim_(n -> oo) a_n = a$ y $lim_(n -> oo) b_n = b$, con $a, b in RR$.

  Probar que $lim_(n -> oo) (a_n + b_n) = a + b$.
]
#solucion[
  *Demostración:*

  Sea $epsilon > 0$. Como $a_n -> a$ y $b_n -> b$, tenemos lo siguiente:
  - Existe $n_1 in NN$ tal que para todo $n >= n_1$ se cumple $|a_n - a| < epsilon/2$.
  - Existe $n_2 in NN$ tal que para todo $n >= n_2$ se cumple $|b_n - b| < epsilon/2$.

  Por lo tanto, llamando $n_0 = op("máx")(n_1, n_2)$, para todo $n >= n_0$ se cumple la siguiente desigualdad:

  $
    abs((a_n + b_n) - (a + b)) &= abs((a_n - a) + (b_n - b)) \
      &<= abs(a_n - a) + abs(b_n - b) \
      &< epsilon/2 + epsilon/2 = epsilon.
  $

  Es decir, $abs((a_n + b_n) - (a + b)) < epsilon$. Concluimos que $(a_n + b_n) -> (a + b)$.
]
```
