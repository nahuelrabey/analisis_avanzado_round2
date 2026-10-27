#import "@preview/frame-it:2.0.0": *
#import "../utils.typ": *
#show figure.where(kind: "frame"): set figure(numbering: none)
#show figure.where(kind: "frame"): set block(breakable: true)
#show: frame-style(styles.boxy)

#show grid.cell: it => {
  if it.fill != none {
    set text(fill: white, weight: "bold", style: "italic")
    it
  } else {
    it
  }
}



// --- Desafíos de la Práctica 5 ---

#align(center)[
  #text(14pt, weight: "bold")[Desafíos --- Práctica 5] \
  #v(2pt)
  #text(10pt)[Compacidad y teoremas de punto fijo]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

Los desafíos están ordenados según *qué hay que hacer primero para desbloquear la guía*: cada bloque
supone resueltos los de arriba, y van en el orden de los ejercicios de `guias/p5.typ` que desbloquean.
La idea es intercalar: hacer cada bloque justo antes de los ejercicios de su última columna.

#v(5pt)

#show table.cell.where(y: 0): set text(fill: white, weight: "bold", size: 8.5pt)

#block[
  #set text(size: 8.5pt)
  #table(
    columns: (0.5fr, 3.5fr, 1.2fr),
    align: (center + horizon, left + top, center + horizon),
    fill: (x, y) => if y == 0 { rgb("#0c4a6e") } else if calc.even(y) { rgb("#f8fafc") } else { white },
    stroke: 0.4pt + rgb("#cbd5e1"),
    inset: (x: 6pt, y: 5pt),

    [*Bloque*], [*Tema*], [*Hacelo antes de*],

    [1], [Las métricas $d_1$, $d_2$, $d_oo$ en $RR^m$: convergencia y compacidad], [Ej. 3],
  )
]

#v(10pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Bloque 1 · Las métricas $d_1$, $d_2$, $d_oo$ en $RR^m$: convergencia y compacidad

#sublema(titulo: "Qué desbloquea")[
  En $RR^m$ da lo mismo trabajar con $d_1$, $d_2$ o $d_oo$: las tres tienen las mismas sucesiones convergentes (y convergen coordenada a coordenada), así que tienen los mismos compactos. Esto permite elegir la métrica más cómoda para cada cuenta. En el *Ejercicio 3* de la Práctica 5 hace falta que $K times K subset.eq RR^2$ sea compacto: el producto de compactos se prueba con $d_oo$ (Bloque 3 de `ejemplos/p5.typ`), y este desafío dice que entonces también lo es con $d_2$. Es además la puerta para usar que en $(RR^m, d_2)$ los cerrados y acotados son compactos (Observación posterior a la Proposición 6.3).
]

#desafio[Convergencia y compacidad con $d_1$, $d_2$ y $d_oo$ en $RR^m$ (Ejercicio 6.4)][
  #set enum(numbering: "a)")
  + Sea $(x_n)_(n in NN) subset.eq RR^m$ y $x in RR^m$. Probar que $x_n -> x$ con la distancia $d_1$ si y sólo si lo hace con la distancia $d_2$ si y sólo si lo hace con la distancia $d_oo$.
  + Si notamos $x_n = (x_n^1, x_n^2, dots, x_n^m)$ y $x = (x^1, x^2, dots, x^m)$, entonces tenemos que $x_n -> x$ (con cualquiera de las distancias del ítem anterior) si y sólo si $x_n^i -> x^i in RR$ para todo $i = 1, dots, m$.
  + Sea $K subset.eq RR^m$ un conjunto. Entonces $K$ es compacto en $(RR^m, d_2)$ si y sólo si es compacto en $(RR^m, d_1)$ si y sólo si es compacto en $(RR^m, d_oo)$.

  _Nota_: en el original, el ítem a) dice "Probar que si $x_n -> x$ con la distancia $d_1$ si y sólo si..." (sobra el primer "si") y el ítem b) cierra con "para todo $i = 1, dots, k$"; como las coordenadas van de $1$ a $m$, se escribió $m$.
]
