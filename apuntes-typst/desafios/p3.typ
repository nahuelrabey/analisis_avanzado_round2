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



// --- Desafíos de la Práctica 3 ---

#align(center)[
  #text(14pt, weight: "bold")[Desafíos --- Práctica 3] \
  #v(2pt)
  #text(10pt)[Espacios métricos y topología]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

Los desafíos están agrupados por *dependencia*, no por orden de transcripción: cada bloque
supone resueltos los de arriba. La última columna dice a qué ejercicios de `guias/p3.typ`
alimenta cada bloque.

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

    [*Bloque*], [*Tema*], [*Alimenta*],

    [1], [Espacios métricos y topología], [Ej. 1 (e)],
  )
]

#v(10pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Bloque 1 · Espacios métricos y topología

#sublema(titulo: "Qué desbloquea")[
  Alimenta la *Práctica 3* (espacios métricos, bolas y topología). En particular, el Ejercicio 1 (e) de la guía pide verificar que $C([0, 1])$ con la métrica del supremo es un espacio métrico.
]

#desafio[Ejercicio 4.3 ($d_oo$ y $d_1$ en $C([a, b])$)][
  Probar que $d_oo$ y $d_1$ son métricas en $C([a, b])$.
]

#desafio[Equivalencia de las definiciones de conjunto acotado (Definición 4.8)][
  Sea $(M, d)$ un espacio métrico y $E subset.eq M$. Probar que las siguientes dos condiciones son equivalentes:

  + Existe $C > 0$ tal que $d(x, y) <= C$ para todo $x, y in E$.
  + Existe $x_0 in M$ y $R > 0$ tal que $E subset.eq B(x_0, R)$.
]

#desafio[Toda bola es abierta, caso $RR^2$ (Ejercicio 5)][
  En $(RR^2, d_2)$, sea $E = B(p, R)$. Probar que $E$ es abierto.

  *Pista:* dado $(x_0, y_0) in E$, tomar
  $ r = R - d_2((x_0, y_0), p) $
  y mostrar que $B((x_0, y_0), r) subset.eq E$.
]

#desafio[El primer cuadrante abierto es abierto (Ejercicio 6)][
  En $(RR^2, d_2)$, sea $E = {(x, y) in RR^2 : x > 0 and y > 0}$. Probar que $E$ es abierto.
]

#desafio[$inter.big_(n in NN) (-1/n, 1/n) = {0}$ no es abierto (Observación 4.19)][
  Sea $(M, d) = (RR, abs(dot.c))$ y sean $A_n = (-1/n, 1/n)$ para $n in NN$. Se tiene que $A = inter.big_(n in NN) A_n = {0}$. Probar que $A$ no es un conjunto abierto.
]

#desafio[Los intervalos abiertos son conjuntos abiertos (Ejercicio 4.20)][
  Sea $(M, d) = (RR, abs(dot.c))$ y sean $a < b in RR$. Mostrar que $A = (a, b)$ es un conjunto abierto.
]

#desafio[Clausura de la bola abierta (Ejercicio 4.25)][
  Sea $(M, d)$ un espacio métrico.

  #set enum(numbering: "a)")
  + Probar que $overline(B(x,r)) subset.eq B[x,r]$.
  + Mostrar con un contraejemplo que en general no vale la igualdad entre estos dos conjuntos.
]

#desafio[Supremo e ínfimo en la clausura (Ejercicio 4.26)][
  Sea $E subset.eq (RR, abs(dot.c))$ acotado. Probar que $op("sup")(E)$ e $op("ínf")(E)$ pertenecen a la clausura de $E$.
]

#desafio[Caracterización del punto de acumulación (Ejercicio 4.34)][
  Probar que $x$ es un punto de acumulación de $E$ si y sólo si para todo $r > 0$, $B(x, r) inter E$ tiene infinitos elementos.
]

#desafio[Unicidad del límite (Ejercicio 4.44)][
  Sea $(M, d)$ un espacio métrico y sea $(x_n)_(n in NN)$ una sucesión. Probar que si $x_n -> x$ y $x_n -> y$ entonces $x = y$. Es decir, el límite de una sucesión es único (recordar la proposición 2.8).
]

#desafio[Cerrados vía sucesiones (Corolario 4.47)][
  Sea $(M, d)$ un espacio métrico y $E subset.eq M$. Probar que $E$ es cerrado si y sólo si para toda sucesión $(x_n)_(n in NN) subset.eq E$ tal que $x_n -> x$ se tiene que $x in E$ (sugerencia: usar la Proposición 4.46).
]

#desafio[Toda sucesión convergente es acotada (Ejercicio 4.50)][
  Sea $(x_n)_(n in NN) subset.eq M$ una sucesión convergente. Probar que entonces es acotada (sugerencia: ver 2.12).
]

#desafio[Unicidad del límite fuera de $C([0,1])$ (Observación 4.53)][
  Sea $(f_n)_(n in NN)$ la sucesión de funciones del Ejemplo 4.52 (d) (`ejemplos/p3.typ`, pestaña 31), que es de Cauchy en $(C([0,1]), d_1)$ pero no converge en ese espacio. Si cambiamos el conjunto de las funciones continuas por, por ejemplo, el conjunto de _todas_ las funciones de $[0,1]$ en $RR$, la sucesión $f_n$ tiene límite, pero este límite *no es único*.
  #set enum(numbering: "a)")
  + Encontrar otra función $f$, distinta de la del Ejemplo 4.52 (d), tal que $f_n -> f$ en $d_1$.
  + Pensar por qué falla la unicidad del límite si hacemos este cambio.
]

#desafio[Elección del índice de la subsucesión (Teorema 4.54 c)][
  En la demostración del Teorema 4.54 c) (una sucesión de Cauchy con una subsucesión convergente es convergente), para acotar
  $ d(x_n, x) <= d(x_n, x_(n_k)) + d(x_(n_k), x) $
  necesitamos elegir un $n_k$ que cumpla dos condiciones: $n_k >= n_0$ (para poder acotar $d(x_n, x_(n_k))$ usando que $(x_n)$ es de Cauchy) y $n_k >= n_(k_0)$ (para poder acotar $d(x_(n_k), x)$ usando que $x_(n_k) -> x$). Pensar por qué podemos conseguir un $n_k$ que cumpla ambas condiciones.
]
