# Transcripción Práctica 1 - Ejercicio 1

## Enunciado (extraído de la imagen)
> **Ejercicio 1:** Pruebe que si $x < y + \varepsilon$ para todo $\varepsilon > 0$, entonces $x \le y$. Deduzca que si $|x - y| < \varepsilon$ para todo $\varepsilon > 0$, entonces $x = y$.

## Bloque Typst preparado con `frame-it`

```typst
#enunciado[Ejercicio 1][
  Pruebe que si $x < y + epsilon$ para todo $epsilon > 0$, entonces $x <= y$. Deduzca que si $|x - y| < epsilon$ para todo $epsilon > 0$, entonces $x = y$.
]

#solucion[Propuesta 1][
  Demostración por contrarrecíproco. Si $forall epsilon > 0 : x < y + epsilon => x <= y$, debe ser verdadero también que $x > y => exists epsilon > 0 : x >= y + epsilon$.

  Notemos que si $x > y$, entonces $x - y > 0$. Podemos llamar $delta = x - y$. En particular, $x >= y + delta$. Por lo tanto, hemos encontrado $epsilon = delta$ que cumple $x >= y + epsilon$. Habiendo demostrado que el contrarrecíproco vale, el recíproco también debe valer.
]
```
