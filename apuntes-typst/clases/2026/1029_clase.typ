// Clase práctica 2026 · 29/10/2026 (pizarrón, dictado por el usuario durante la clase).
// Sus ejemplos llevan el tag `29-10/{n}` en `ejemplos/` (n = orden en que se cargan).
// Lo anotado en el pizarrón es la única fuente: pasos agregados o corregidos van como notas al margen
// (#comentario[...], redefinido abajo), ancladas a la palabra o fórmula que corrigen o completan.

#import "../../utils.typ": *
#import "@preview/marginalia:0.3.1" as marginalia
#import "@preview/cetz:0.4.0"
#import "@preview/cetz-plot:0.1.2": plot

#set page(paper: "a4")
#set text(lang: "es")
#show: marginalia.setup.with(
  inner: (far: 15mm, width: 0mm, sep: 0mm),
  outer: (far: 10mm, width: 50mm, sep: 7mm),
)

// En este archivo los comentarios van al margen, en letra chica, con un número que los ancla al texto.
#let comentario(cuerpo) = marginalia.note(
  numbering: (..i) => text(fill: rgb("#2563eb"), weight: "bold", super(numbering("1", ..i))),
  text-style: (size: 8pt),
  par-style: (justify: false),
  cuerpo,
)

// Recuadro rojo para lo que el profesor marca como muy importante.
#let importante(cuerpo) = block(
  fill: rgb("#fef2f2"),
  stroke: 1.2pt + rgb("#dc2626"),
  inset: (x: 12pt, y: 10pt),
  radius: 4pt,
  width: 100%,
  breakable: false,
)[
  #text(weight: "bold", size: 9.5pt, fill: rgb("#b91c1c"))[Importante] \
  #v(2pt)
  #cuerpo
]

= Clase del 29/10/2026

== Teorema de punto fijo

_Ejemplo 1_ (`29-10/1`): Sea $f : RR -> RR$ dada por $f(x) = x^3 - 3x + 1$. Veamos que $f$ tiene una única raíz en $[0, 1 \/ 2]$.

_Observación_: para ver que hay una raíz no hace falta usar punto fijo. De hecho, podemos ver que tiene al menos una raíz#comentario[El pizarrón dice "al menos una raíz simple". El cambio de signo sólo da existencia: no dice que la raíz sea única ni que sea simple (multiplicidad $1$). La unicidad sale más abajo.], pues#comentario[Agregado: el paso que falta es el teorema de Bolzano (valores intermedios). Como $f$ es continua en $[0, 1 \/ 2]$ y cambia de signo entre los extremos, existe $c in (0, 1 \/ 2)$ con $f(c) = 0$.]
$ f(0) = 1 > 0 quad "y" quad f(1 \/ 2) = 1 / 8 - 3 / 2 + 1 = -3 / 8 < 0. $

Se puede resolver sólo usando el teorema de Bolzano: $f$ es continua y además es un polinomio de grado $3$.

Probamos que en un número muy negativo#comentario[Agregado: valores concretos para "muy negativo" y "muy positivo". Sirven $-2$ y $2$: $f(-2) = -8 + 6 + 1 = -1 < 0$ y $f(2) = 8 - 6 + 1 = 3 > 0$. Los tres tramos son $(-2, 0)$, $(0, 1 \/ 2)$ y $(1 \/ 2, 2)$, disjuntos, y sólo el del medio está en $[0, 1 \/ 2]$ (en los extremos $f$ no se anula).] la función es negativa, en $0$ es positiva, en $1 \/ 2$ es negativa#comentario[Corrección: el pizarrón dice que "en el intervalo es positiva". En $[0, 1 \/ 2]$ la función pasa de positiva ($f(0) = 1$) a negativa ($f(1 \/ 2) = -3 \/ 8$), y lo que importa es el patrón de signos $-, +, -, +$ de izquierda a derecha.] y en un número muy positivo es positiva. Por Bolzano, hay una raíz en cada uno de los tres tramos donde cambia el signo. Como $f$ es de grado $3$, tiene tres raíces como máximo: son exactamente esas, y en el intervalo $[0, 1 \/ 2]$ hay una sola raíz.

*Con punto fijo.* Reescribimos la ecuación:
$
  x^3 - 3x + 1 = 0 & <=> x^3 + 1 = 3x \
  & <=> 1 / 3 (x^3 + 1) = x.
$

Llamamos $g(x) = 1 / 3 (x^3 + 1)$#comentario[Corrección: el pizarrón vuelve a llamar $f$ a la función nueva; acá la llamamos $g$ para no confundirla con $f(x) = x^3 - 3x + 1$. Al final de la clase el profesor se dio cuenta de que había usado el mismo nombre para las dos.]. Las raíces de $f$ son los puntos fijos de $g$, así que buscamos un punto fijo de $g$ en $[0, 1 \/ 2]$.

Recordemos el teorema de punto fijo: funciones contractivas en un completo, o funciones continuas en un compacto#comentario[Corrección: "continuas en un compacto" no alcanza en general. La rotación de un ángulo $theta in (0, 2 pi)$ en la circunferencia $S^1$ es continua y manda el compacto $S^1$ en sí mismo, pero no tiene puntos fijos. Lo que sí vale es el caso de un intervalo: toda $g : [a, b] -> [a, b]$ continua tiene un punto fijo (Ejercicio 19 de la Práctica 5; sale de aplicar Bolzano a $g(x) - x$). Esta versión da existencia pero no unicidad. En un compacto general, la versión con unicidad pide $d(g(x), g(y)) < d(x, y)$ para $x != y$ (Ejemplo C8-1).]. La función tiene que mandar el dominio "adentro" de sí mismo#comentario[Agregado: quiere decir $g(X) subset.eq X$, es decir, $g : X -> X$. Un punto fijo $x = g(x)$ tiene que estar en $X$, y la prueba de Banach itera $x_(n + 1) = g(x_n)$, que necesita que cada $x_n$ siga en $X$. Acá hay que verificar $g([0, 1 \/ 2]) subset.eq [0, 1 \/ 2]$.].

Notemos que $[0, 1 \/ 2]$ es completo y compacto (cerrado y acotado en $RR$), por lo tanto podemos usar las dos versiones del punto fijo.

Veamos si $g([0, 1 \/ 2]) subset.eq [0, 1 \/ 2]$.

Podríamos buscar mínimos y máximos en $[0, 1 \/ 2]$ usando derivadas y Weierstrass, pero quizás no podemos derivar, o no es algo "trivial". Vamos con otro acercamiento: acotamos "a lo bestia".
$
  0 <= x <= 1 / 2 & <=> 0 <= x^3 <= 1 / 8 && "(" x |-> x^3 "es creciente)" \
  & <=> 1 <= x^3 + 1 <= 9 / 8 && "(sumamos " 1 ")" \
  & <=> 1 / 3 <= 1 / 3 (x^3 + 1) <= 3 / 8 && "(multiplicamos por " 1 \/ 3 ")".
$

Luego, vemos que
$ g([0, 1 \/ 2]) subset.eq [1 / 3, 3 / 8] subset.eq [0, 1 / 2]. $

El profesor comenta: la idea es encontrar la "intersección" entre ambas funciones#comentario[Agregado: "ambas funciones" son los dos lados de $1 / 3 (x^3 + 1) = x$, es decir $y = g(x)$ e $y = x$. Un punto fijo de $g$ es una abscisa donde se cortan el gráfico de $g$ y la diagonal $y = x$.]. Por la acotación bruta que vimos antes, $g$ vive en la franja#comentario[Agregado: es una franja horizontal. Para $x in [0, 1 \/ 2]$, el gráfico de $g$ queda entre las rectas $y = 1 \/ 3$ e $y = 3 \/ 8$. El gráfico de abajo no está en el pizarrón.] $[1 \/ 3, 3 \/ 8]$.

#figure(
  cetz.canvas({
    plot.plot(
      size: (7, 7),
      x-min: 0, x-max: 0.55,
      y-min: 0, y-max: 0.55,
      x-tick-step: none,
      y-tick-step: none,
      x-ticks: ((1 / 3, $1/3$), (3 / 8, $3/8$), (0.5, $1/2$)),
      y-ticks: ((1 / 3, $1/3$), (3 / 8, $3/8$), (0.5, $1/2$)),
      x-label: $x$,
      y-label: $y$,
      axis-style: "school-book",
      legend: "inner-north-west",
      {
        plot.add-fill-between(
          domain: (0, 0.5),
          x => 1 / 3,
          x => 3 / 8,
          style: (fill: rgb("#fde68a"), stroke: none),
          label: [franja $[1 \/ 3, 3 \/ 8]$],
        )
        plot.add(
          ((0, 0.5), (0.5, 0.5), (0.5, 0)),
          style: (stroke: (paint: rgb("#94a3b8"), dash: "dashed", thickness: 0.7pt)),
        )
        plot.add(
          domain: (0, 0.55),
          x => x,
          style: (stroke: rgb("#2563eb") + 1.2pt),
          label: $y = x$,
        )
        plot.add(
          domain: (0, 0.5),
          samples: 100,
          x => (x * x * x + 1) / 3,
          style: (stroke: rgb("#c026d3") + 1.6pt),
          label: $y = g(x)$,
        )
        plot.add(
          ((0.3473, 0.3473),),
          mark: "o",
          mark-size: 0.12,
          style: (stroke: none),
          mark-style: (fill: black, stroke: black),
        )
      },
    )
  }),
  caption: [Agregado: el gráfico de $g$ en $[0, 1 \/ 2]$ queda dentro de la franja horizontal $1 \/ 3 <= y <= 3 \/ 8$, y la diagonal $y = x$ la atraviesa. El punto fijo es el corte, $x^* approx 0.347$.],
)

Veamos si $g$ es contractiva:
$
  abs(g(x) - g(y)) & = abs(1 / 3 (x^3 + 1) - 1 / 3 (y^3 + 1)) \
  & = 1 / 3 abs(x^3 - y^3).
$

Notemos que $x^3 - y^3 = (x - y)(x^2 + x y + y^2)$. Por lo tanto,
$ abs(g(x) - g(y)) = 1 / 3 abs(x - y) abs(x^2 + x y + y^2). $

Como $x, y in [0, 1 \/ 2]$, los tres términos de $x^2 + x y + y^2$ son no negativos y cada uno es a lo sumo $1 \/ 4$:
$ x^2 <= 1 / 4, quad x y <= 1 / 2 dot 1 / 2 = 1 / 4, quad y^2 <= 1 / 4. $
Entonces $0 <= x^2 + x y + y^2 <= 3 \/ 4$, y
$
  abs(g(x) - g(y)) & <= 1 / 3 (1 / 4 + 1 / 4 + 1 / 4) abs(x - y) \
  & = 1 / 4 abs(x - y).
$
Como $1 \/ 4 < 1$, $g$ es contractiva.

Por teorema del punto fijo#comentario[Agregado: la continuidad no es una hipótesis aparte de Banach: una contractiva es Lipschitz y, por lo tanto, (uniformemente) continua. Lo que Banach pide es $g : X -> X$, $X$ completo y $g$ contractiva.] ($g : [0, 1 \/ 2] -> [0, 1 \/ 2]$ continua, $[0, 1 \/ 2]$ completo y $g$ contractiva en $[0, 1 \/ 2]$), existe un único punto fijo de $g$ en $[0, 1 \/ 2]$#comentario[Agregado: la conclusión para el problema original. Como los puntos fijos de $g$ son exactamente las raíces de $f(x) = x^3 - 3x + 1$, $f$ tiene una única raíz en $[0, 1 \/ 2]$.].

#importante[El profesor señala como un elemento muy importante entender a fondo el teorema de punto fijo, porque su demostración te muestra _cómo usar el teorema_.#comentario[Agregado: una lectura posible. La demostración de Banach es constructiva: desde cualquier $x_0 in [0, 1 \/ 2]$, la sucesión $x_(n + 1) = g(x_n)$ converge al punto fijo $x^*$, con $abs(x_n - x^*) <= alpha^n \/ (1 - alpha) dot abs(x_1 - x_0)$, donde $alpha = 1 \/ 4$ es la constante de contracción. Así, además de probar que la raíz existe y es única, la prueba da una forma de aproximarla con error controlado.]]

_Ejemplo 2_ (`29-10/2`): Sea $f : RR -> RR$ dada por $f(x) = ln(e^x + 1)$. Probar que $abs(f(x) - f(y)) < abs(x - y)$ para $x != y$#comentario[Corrección: la desigualdad estricta sólo puede valer para $x != y$ (si $x = y$ ambos lados son $0$).], pero $f$ no tiene puntos fijos.

Notemos que $RR$ es completo, es cerrado, pero _no es compacto_#comentario[Agregado: este es el contraste con el Ejemplo C8-1 (Bloque 6): ahí, en un compacto, "achicar distancias" ($d(f(x), f(y)) < d(x, y)$ para $x != y$) alcanza para tener un único punto fijo. Acá $RR$ es completo, pero sin compacidad esa hipótesis no alcanza; y tampoco es Banach, porque no hay una constante $alpha < 1$ uniforme. Ver también el Ejercicio 16 de la Práctica 5.].

_Propuesta de un alumno, que se explora_: probamos derivando, usando el teorema del valor medio:
$ abs(f(x) - f(y)) = abs(f'(c)) abs(x - y) $
para algún $c$ entre $x$ e $y$, con
$ f'(x) = e^x / (e^x + 1). $

Notemos que $f'(x) < 1$ para todo $x in RR$. Entonces, para $x != y$,
$ abs(f(x) - f(y)) = abs(f'(c)) abs(x - y) < abs(x - y). $

Pero#comentario[Agregado: lo que dice este "pero" es que no hay una constante $alpha < 1$ con $abs(f'(c)) <= alpha$ para todo $c$: el supremo de $f'$ es $1$. Así que $f$ achica distancias pero no es contractiva en el sentido de Banach, y el teorema no se puede aplicar.]
$ e^c / (e^c + 1) = 1 / (1 + e^(-c)) -> 1 quad "cuando" c -> +infinity. $

¿Hay punto fijo? Supongamos que $f(x) = x$. Entonces
$
  f(x) = x & <=> ln(e^x + 1) = x \
  & <=> e^(ln(e^x + 1)) = e^x \
  & <=> e^x + 1 = e^x \
  & <=> 1 = 0.
$

No hay punto fijo.

Notemos que si a esta función la encerramos en un cerrado, supongamos $[0, 1]$, no entra en el mismo intervalo. Es decir,#comentario[Agregado: la cuenta. $f(1) = ln(e + 1) approx 1.31 > 1$, así que $f(1) in.not [0, 1]$.]
$ f([0, 1]) subset.not [0, 1]. $

_Moraleja_: acotando el dominio podría encontrar un $c$, PERO sabemos que no hay ningún punto fijo. Entonces, ¿dónde falla? La imagen me va a caer siempre fuera del dominio acotado que elija.

¿Dónde se rompe? En $ln(e^x + 1)$: este "$+1$" me rompe todo#comentario[Agregado: por qué falla siempre. Como $e^x + 1 > e^x$ y $ln$ es creciente, $f(x) = ln(e^x + 1) > ln(e^x) = x$ para todo $x$: el gráfico de $f$ queda estrictamente arriba de la diagonal. En cualquier $[a, b]$, entonces, $f(b) > b$ y $f([a, b]) subset.not [a, b]$. Ese es el papel del "$+1$". Lo que acotar sí da es la constante: en $[a, b]$, $f' <= f'(b) < 1$ porque $f'$ es creciente. Así que $f$ es contractiva en $[a, b]$, pero no manda $[a, b]$ en sí mismo, y Banach no se puede aplicar.].

#figure(
  cetz.canvas({
    plot.plot(
      size: (8, 6),
      x-min: -3, x-max: 2.5,
      y-min: -0.5, y-max: 2.8,
      x-tick-step: 1,
      y-tick-step: 1,
      x-label: $x$,
      y-label: $y$,
      axis-style: "school-book",
      legend: "inner-north-west",
      {
        plot.add-fill-between(
          domain: (0, 1),
          x => 0,
          x => 1,
          style: (fill: rgb("#fde68a"), stroke: (paint: rgb("#d97706"), dash: "dashed", thickness: 0.7pt)),
          label: [caja $[0, 1] times [0, 1]$],
        )
        plot.add(
          domain: (-3, 2.5),
          x => x,
          style: (stroke: rgb("#2563eb") + 1.2pt),
          label: $y = x$,
        )
        plot.add(
          domain: (-3, 2.5),
          samples: 150,
          x => calc.ln(calc.exp(x) + 1),
          style: (stroke: rgb("#c026d3") + 1.6pt),
          label: $y = ln(e^x + 1)$,
        )
        plot.add(
          ((1, 1), (1, calc.ln(calc.e + 1))),
          style: (stroke: (paint: rgb("#dc2626"), dash: "dotted", thickness: 1pt)),
        )
        plot.add(
          ((1, calc.ln(calc.e + 1)),),
          mark: "o",
          mark-size: 0.12,
          style: (stroke: none),
          mark-style: (fill: rgb("#dc2626"), stroke: rgb("#dc2626")),
        )
      },
    )
  }),
  caption: [Agregado: el gráfico de $f$ queda siempre estrictamente arriba de la diagonal, así que nunca la corta (no hay punto fijo); se le pega cuando $x -> +infinity$, porque $f(x) - x = ln(1 + e^(-x)) -> 0$. En la caja $[0, 1] times [0, 1]$, el punto rojo $(1, f(1)) approx (1, 1.31)$ se escapa por arriba: $f([0, 1]) subset.not [0, 1]$. Lo mismo pasa con cualquier caja $[a, b] times [a, b]$, en el borde derecho.],
)
