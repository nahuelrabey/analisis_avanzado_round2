# Transcripción Práctica 1 - Ejercicio 2 (a)

## Enunciado
> **Ejercicio 2 (a):** Sean $x, y \in \mathbb{R}$ tales que $y - x > 1$. Pruebe que existe un entero entre $x$ e $y$.

## Bloque Typst preparado con `frame-it`

```typst
#enunciado[Ejercicio 2 (a)][
  Sean $x, y in RR$ tales que $y - x > 1$. Pruebe que existe un entero entre $x$ e $y$.
]

#solucion[Propuesta 1][
  Por el Principio de Arquímedes sabemos que $exists n in ZZ : x < n <= x + 1$. Además, $y - x > 1 => y > x + 1$. Juntando ambas desigualdades tenemos que:
  $ x < n <= x + 1 < y $
  Encontramos un entero entre $x$ e $y$, tal como queríamos ver.
]
```
