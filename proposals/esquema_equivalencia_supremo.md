# Propuesta: Rediseño del Esquema Geométrico de Equivalencia de Supremo en `apuntes-typst/apuntes.typ`

## Contexto y Problema
En el esquema actual ([`apuntes.typ:L160-174`](file:///home/nahuel/study/analisis-avanzado/apuntes-typst/apuntes.typ#L160-L174)), la llave `overbrace` de $\varepsilon$ estaba centrada únicamente sobre el punto medio $a_\varepsilon$, en lugar de abarcar la distancia completa del intervalo entre $s - \varepsilon$ y $s$.

---

## Solución Propuesta con CeTZ

Reemplazar la estructura anterior por un gráfico vectorial claro realizado en `cetz` que abarque la distancia $\varepsilon$ desde $s - \varepsilon$ hasta $s$:

```typst
  #align(center)[
    #cetz.canvas({
      import cetz.draw: *
      
      // Eje real principal
      line((0, 0), (7, 0), stroke: 1pt)
      
      // Marcas de posición para s - epsilon y s
      line((1.5, -0.15), (1.5, 0.15), stroke: 1pt)
      line((5.5, -0.15), (5.5, 0.15), stroke: 1pt)
      
      // Etiquetas inferiores
      content((1.5, -0.45), [$s - epsilon$])
      content((5.5, -0.45), [$s$])
      
      // Punto azul a_epsilon en el interior (s - epsilon < a_epsilon <= s)
      circle((4.2, 0), radius: 0.08, fill: rgb("#2563eb"), stroke: rgb("#2563eb"))
      content((4.2, -0.45), [$a_epsilon$])
      
      // Cota superior que abarca la distancia epsilon entre s-epsilon y s
      line((1.5, 0.5), (5.5, 0.5), stroke: 0.8pt + rgb("#475569"), mark: (start: "|", end: "|"))
      content((3.5, 0.85), text(weight: "bold")[$epsilon$])
    })
  ]
```
