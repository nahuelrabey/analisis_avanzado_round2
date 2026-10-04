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

// Resolución de la Práctica 3 escrita por el agente (Claude), NO por el autor de los apuntes.
// Vive en `guias-agente/` para distinguirla de las resoluciones de `guias/p3.typ`.
// Cada ejercicio está verificado en Lean 4 + Mathlib: ver `lean/Guias/Guia3/EjNN.lean`.

#align(center)[
  #text(14pt, weight: "bold")[Análisis Avanzado - Segundo cuatrimestre de 2025] \
  #v(2pt)
  #text(12pt, weight: "medium")[Práctica 3 --- resuelta por el agente]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#progreso[
  *Autoría:* este archivo lo escribió el agente (Claude). No es una resolución del autor de los
  apuntes: la de él está en `guias/p3.typ`. Se guarda en otra carpeta para poder distinguirlas.

  *Qué se supone verdadero:* todo lo escrito en `apuntes.typ` (definiciones, proposiciones y
  teoremas, citados por nombre y número) y los enunciados de las Prácticas 1 y 2. Los ejemplos de
  `ejemplos/p3.typ` se leyeron como inspiración; ninguno se usa como lema. Dentro de la propia
  Práctica 3, un ejercicio puede citar los anteriores ("Ej. 4 (b)"), nunca los posteriores.

  *Qué se usa sin cita:* sólo hechos de base del orden y la aritmética de $RR$, $ZZ$ y $NN$
  (la desigualdad triangular de $abs(dot.c)$, que una suma de términos $>= 0$ es nula sólo si cada
  uno lo es, que la raíz cuadrada es creciente, que un conjunto finito no vacío de reales tiene
  máximo, que no hay enteros estrictamente entre $n$ y $n + 1$). Todo lo que va más allá de eso
  se demuestra en el lugar y se marca "(deducción propia)".

  *Supuestos externos declarados:* hay exactamente dos. (1) En el Ej. 1 (e) el enunciado escribe
  $max_(0 <= t <= 1) abs(f(t) - g(t))$: que ese máximo exista es el teorema de Weierstrass
  (valores extremos), que *no* está en `apuntes.typ` ni en las guías 1-2; se lo toma como parte del
  enunciado y se señala cada paso que lo usa. (2) `apuntes.typ` no define "métricas equivalentes"
  (Ej. 12); se adopta y se explicita la definición de clase.

  *Verificación en Lean:* cada ejercicio tiene su contraparte en `lean/Guias/Guia3/EjNN.lean`
  (Lean 4 + Mathlib; `cd lean && lake build`). La caja _Observación_ del final de cada ejercicio dice
  qué teorema certifica qué ítem y en qué se aparta la formalización del texto. Los dibujos no se
  verifican con Lean; sí se verifica la descripción conjuntista de lo dibujado.
]

#v(10pt)

== Ejercicio 1

#let e1-ejes(xmax, ymax) = {
  import cetz.draw: *
  line((-xmax, 0), (xmax, 0), mark: (end: ">"), stroke: 0.6pt + luma(90))
  line((0, -ymax), (0, ymax), mark: (end: ">"), stroke: 0.6pt + luma(90))
}

#let e1-relleno = rgb("#bfdbfe")
#let e1-borde = 1.2pt + rgb("#2563eb")

#enunciado[Ejercicio 1][
  Pruebe que los siguientes son espacios métricos. Dibuje, en cada caso, una bola abierta.
  #set enum(numbering: "(a)")
  + $RR$ con $d(x, y) = abs(x - y)$.
  + $RR^n$ con $d_2(x, y) = (sum_(i=1)^n (x_i - y_i)^2)^(1/2)$.
  + $RR^n$ con $d_1(x, y) = sum_(i=1)^n abs(x_i - y_i)$.
  + $RR^n$ con $d_oo (x, y) = max_(1 <= i <= n) abs(x_i - y_i)$.
  + $C([0, 1])$ con $d_oo (f, g) = max_(0 <= t <= 1) abs(f(t) - g(t))$.
  + $E$ un conjunto no vacío, con la métrica $delta(x, y) = 0$ si $x = y$ y $delta(x, y) = 1$ si $x != y$.
]

#estrategia[Chequear los cuatro axiomas de la Definición 4.1 y describir la bola con la Definición 4.5][
  En cada ítem hay que probar, para todos $x, y, z$:
  (i) $d(x, y) >= 0$; (ii) $d(x, y) = 0 <=> x = y$; (iii) $d(x, y) = d(y, x)$;
  (iv) $d(x, z) <= d(x, y) + d(y, z)$ (Definición 4.1). La bola abierta es
  $B(x_0, r) = \{y : d(x_0, y) < r\}$ (Definición 4.5), y el dibujo sale de despejar esa
  desigualdad. Lo único con contenido es (iv) en $d_2$ (hace falta la desigualdad de
  Cauchy--Schwarz) y el hecho de que en (e) el "máx" existe.

  En (d) hace falta $n >= 1$ para que el máximo sobre $\{1, dots, n\}$ tenga sentido.
]

// ---------------------------------------------------------------- (a)
#enunciado[Ejercicio 1 (a)][$RR$ con $d(x, y) = abs(x - y)$.]

#resolucion[Propuesta: es métrica; la bola es el intervalo $(x_0 - r, x_0 + r)$][
  + *(i)* $abs(x - y) >= 0$ siempre.
  + *(ii)* $abs(x - y) = 0 <=> x - y = 0 <=> x = y$.
  + *(iii)* $abs(x - y) = abs(-(y - x)) = abs(y - x)$.
  + *(iv)* Por la desigualdad triangular del valor absoluto en $RR$,
    $ abs(x - z) = abs((x - y) + (y - z)) <= abs(x - y) + abs(y - z). $

  *Bola.* $B(x_0, r) = \{y : abs(x_0 - y) < r\} = \{y : x_0 - r < y < x_0 + r\} = (x_0 - r, x_0 + r)$.

  #block(breakable: false, width: 100%)[#align(center)[
    #cetz.canvas({
      import cetz.draw: *
      line((-3.2, 0), (3.4, 0), mark: (end: ">"), stroke: 0.6pt + luma(90))
      line((-1.6, 0), (1.6, 0), stroke: 2.4pt + rgb("#2563eb"))
      circle((-1.6, 0), radius: 0.09, fill: white, stroke: e1-borde)
      circle((1.6, 0), radius: 0.09, fill: white, stroke: e1-borde)
      circle((0, 0), radius: 0.06, fill: black)
      content((0, -0.45), text(size: 9pt)[$x_0$])
      content((-1.6, -0.45), text(size: 9pt)[$x_0 - r$])
      content((1.6, -0.45), text(size: 9pt)[$x_0 + r$])
      content((0, 0.45), text(size: 9pt, fill: rgb("#2563eb"))[$B(x_0, r)$])
    })
  ]]
]

// ---------------------------------------------------------------- (b)
#enunciado[Ejercicio 1 (b)][$RR^n$ con $d_2(x, y) = (sum_(i=1)^n (x_i - y_i)^2)^(1/2)$.]

#estrategia[La triangular es Minkowski, que sale de Cauchy--Schwarz][
  Con $a_i = x_i - y_i$ y $b_i = y_i - z_i$ se tiene $x_i - z_i = a_i + b_i$, y desarrollando
  $sum (a_i + b_i)^2 = sum a_i^2 + 2 sum a_i b_i + sum b_i^2$. Si se acota el término cruzado
  por el producto de las normas (Cauchy--Schwarz), queda el cuadrado de una suma. Cauchy--Schwarz
  se prueba a mano con una suma de cuadrados no negativa.
]

#sublema(titulo: "Lema auxiliar: desigualdad de Cauchy-Schwarz en ℝⁿ (deducción propia)")[
  Para $a, b in RR^n$, con $A = (sum a_i^2)^(1/2)$ y $B = (sum b_i^2)^(1/2)$,
  $ sum_(i=1)^n a_i b_i <= A B. $
  *Prueba.* Si $A = 0$, todos los $a_i^2$ son sumandos $>= 0$ de una suma nula, luego $a_i = 0$ para
  todo $i$ y ambos miembros valen $0$. Lo mismo si $B = 0$. Si $A, B > 0$, se mira la suma de
  cuadrados
  $ 0 <= sum_(i=1)^n (B a_i - A b_i)^2 = B^2 sum a_i^2 - 2 A B sum a_i b_i + A^2 sum b_i^2 = 2 A^2 B^2 - 2 A B sum a_i b_i, $
  y como $A B > 0$, dividiendo por $2 A B$ queda $sum a_i b_i <= A B$. $qed$
]

#resolucion[Propuesta: es métrica; la bola es el disco abierto][
  + *(i)* Es una raíz cuadrada (de una suma de cuadrados), luego $d_2(x, y) >= 0$.
  + *(ii)* $d_2(x, y) = 0 <=> sum (x_i - y_i)^2 = 0$. Como cada sumando es $>= 0$, la suma es nula si
    y sólo si cada $(x_i - y_i)^2 = 0$, es decir $x_i = y_i$ para todo $i$, es decir $x = y$.
  + *(iii)* $(x_i - y_i)^2 = (y_i - x_i)^2$ para cada $i$.
  + *(iv)* Sean $a_i = x_i - y_i$ y $b_i = y_i - z_i$, de modo que $a_i + b_i = x_i - z_i$,
    $A = d_2(x, y)$ y $B = d_2(y, z)$. Por el desarrollo del cuadrado y el Lema (Cauchy--Schwarz),
    $ sum_(i=1)^n (x_i - z_i)^2 &= sum a_i^2 + 2 sum a_i b_i + sum b_i^2 \
      &<= A^2 + 2 A B + B^2 = (A + B)^2. $
    Como $A + B >= 0$ y la raíz cuadrada es creciente, $d_2(x, z) <= A + B = d_2(x, y) + d_2(y, z)$.

  *Bola.* Para $r > 0$, $d_2(c, x) < r <=> sum (x_i - c_i)^2 < r^2$ (elevar al cuadrado es
  equivalente entre números $>= 0$). Luego
  $ B_2(c, r) = \{x in RR^n : sum_(i=1)^n (x_i - c_i)^2 < r^2\}, $
  que en $RR^2$ es el *disco abierto* de centro $c$ y radio $r$ (sin la circunferencia).

  #block(breakable: false, width: 100%)[#align(center)[
    #cetz.canvas({
      import cetz.draw: *
      circle((0, 0), radius: 1.5, fill: e1-relleno, stroke: (paint: rgb("#2563eb"), thickness: 1.2pt, dash: "dashed"))
      e1-ejes(2.4, 2.1)
      circle((0, 0), radius: 0.06, fill: black)
      content((0.25, -0.2), text(size: 9pt)[$c$])
      content((2.5, -0.3), text(size: 9pt)[$x_1$])
      content((0.3, 2.2), text(size: 9pt)[$x_2$])
      content((0.2, 0.75), text(size: 9pt, fill: rgb("#1d4ed8"))[$r$])
      line((0, 0), (1.06, 1.06), stroke: 0.6pt)
      content((-1.9, 1.5), text(size: 9pt, fill: rgb("#2563eb"))[$B_2(c, r)$])
    })
  ]]
]

// ---------------------------------------------------------------- (c)
#enunciado[Ejercicio 1 (c)][$RR^n$ con $d_1(x, y) = sum_(i=1)^n abs(x_i - y_i)$.]

#resolucion[Propuesta: es métrica; la bola en $RR^2$ es un rombo abierto][
  + *(i)* Suma de términos $abs(x_i - y_i) >= 0$.
  + *(ii)* La suma de números $>= 0$ es $0$ si y sólo si cada uno es $0$: $d_1(x, y) = 0 <=> abs(x_i - y_i) = 0$ para todo $i$ $<=> x = y$.
  + *(iii)* $abs(x_i - y_i) = abs(y_i - x_i)$ en cada sumando.
  + *(iv)* Para cada $i$, $abs(x_i - z_i) <= abs(x_i - y_i) + abs(y_i - z_i)$ (triangular en $RR$). Sumando en $i$,
    $ d_1(x, z) = sum abs(x_i - z_i) <= sum abs(x_i - y_i) + sum abs(y_i - z_i) = d_1(x, y) + d_1(y, z). $

  *Bola.* En $RR^2$ con centro $0$ y radio $r$:
  $B_1(0, r) = \{(x_1, x_2) : abs(x_1) + abs(x_2) < r\}$. En cada cuadrante es un semiplano
  acotado por una recta ($plus.minus x_1 plus.minus x_2 = r$): es el *rombo abierto* de vértices
  $(plus.minus r, 0)$, $(0, plus.minus r)$.

  #block(breakable: false, width: 100%)[#align(center)[
    #cetz.canvas({
      import cetz.draw: *
      line((1.5, 0), (0, 1.5), (-1.5, 0), (0, -1.5), close: true, fill: e1-relleno,
        stroke: (paint: rgb("#2563eb"), thickness: 1.2pt, dash: "dashed"))
      e1-ejes(2.4, 2.1)
      circle((0, 0), radius: 0.06, fill: black)
      content((2.5, -0.3), text(size: 9pt)[$x_1$])
      content((0.3, 2.2), text(size: 9pt)[$x_2$])
      content((1.5, -0.3), text(size: 9pt)[$r$])
      content((-0.45, 1.5), text(size: 9pt)[$r$])
      content((1.9, 1.3), text(size: 9pt, fill: rgb("#2563eb"))[$B_1(0, r)$])
    })
  ]]
]

// ---------------------------------------------------------------- (d)
#enunciado[Ejercicio 1 (d)][$RR^n$ con $d_oo (x, y) = max_(1 <= i <= n) abs(x_i - y_i)$.]

#resolucion[Propuesta: es métrica; la bola en $RR^2$ es un cuadrado abierto][
  El máximo existe porque es el máximo de un conjunto finito no vacío ($n >= 1$) de reales.
  + *(i)* Es el máximo de números $>= 0$.
  + *(ii)* Si $d_oo (x, y) = 0$, cada $0 <= abs(x_i - y_i) <= d_oo (x, y) = 0$, luego $x_i = y_i$ para todo $i$. Recíprocamente, si $x = y$ todos los términos son $0$ y su máximo también.
  + *(iii)* $abs(x_i - y_i) = abs(y_i - x_i)$ para cada $i$, así que los dos máximos son el máximo de los mismos números.
  + *(iv)* Para cada $i$,
    $ abs(x_i - z_i) <= abs(x_i - y_i) + abs(y_i - z_i) <= d_oo (x, y) + d_oo (y, z), $
    y la cota de la derecha no depende de $i$. Entonces también la acota el máximo del miembro izquierdo: $d_oo (x, z) <= d_oo (x, y) + d_oo (y, z)$.

  *Bola.* Un máximo es $< r$ si y sólo si todos los números lo son:
  $ B_oo (c, r) = \{x : abs(x_i - c_i) < r " para todo " i\} = (c_1 - r, c_1 + r) times dots.c times (c_n - r, c_n + r). $
  En $RR^2$ es el *cuadrado abierto* de lado $2r$ con lados paralelos a los ejes.

  #block(breakable: false, width: 100%)[#align(center)[
    #cetz.canvas({
      import cetz.draw: *
      rect((-1.5, -1.5), (1.5, 1.5), fill: e1-relleno,
        stroke: (paint: rgb("#2563eb"), thickness: 1.2pt, dash: "dashed"))
      e1-ejes(2.4, 2.1)
      circle((0, 0), radius: 0.06, fill: black)
      content((2.5, -0.3), text(size: 9pt)[$x_1$])
      content((0.3, 2.2), text(size: 9pt)[$x_2$])
      content((1.5, -0.3), text(size: 9pt)[$r$])
      content((-0.3, 1.5), text(size: 9pt)[$r$])
      content((1.9, 1.8), text(size: 9pt, fill: rgb("#2563eb"))[$B_oo (0, r)$])
    })
  ]]
]

// ---------------------------------------------------------------- (e)
#enunciado[Ejercicio 1 (e)][$C([0, 1])$ con $d_oo (f, g) = max_(0 <= t <= 1) abs(f(t) - g(t))$.]

#estrategia[Primero que el "máx" exista (Weierstrass); después los axiomas punto a punto][
  Si $f, g$ son continuas, $t |-> abs(f(t) - g(t))$ es continua en el compacto $[0, 1]$, y por el
  teorema de Weierstrass (valores extremos) alcanza su máximo: es el mismo teorema que usa la guía
  al escribir "máx" en vez de "sup" (el apunte define $d_oo$ con $op("sup")$ y por Weierstrass ambos
  coinciden). *Supuesto externo:* Weierstrass no está en `apuntes.typ` ni en las guías 1-2; acá se
  lo toma como presupuesto del enunciado (que escribe "máx"), y se marca con "(W)" cada paso que
  depende de él. Los axiomas se prueban para cada $t$ y se toma máximo.
]

#resolucion[Propuesta: es métrica; la bola es una banda de semiancho $r$ alrededor de $f$][
  *Buena definición (W).* Para $f, g in C([0, 1])$ existe $t_0 in [0, 1]$ con
  $abs(f(t) - g(t)) <= abs(f(t_0) - g(t_0)) = d_oo (f, g)$ para todo $t$ (Weierstrass).
  En particular $abs(f(t) - g(t)) <= d_oo (f, g)$ para todo $t in [0, 1]$.

  + *(i)* $d_oo (f, g) = abs(f(t_0) - g(t_0)) >= 0$.
  + *(ii)* Si $f = g$, el máximo de la función nula es $0$. Si $d_oo (f, g) = 0$, entonces
    $0 <= abs(f(t) - g(t)) <= 0$ para todo $t$, es decir $f(t) = g(t)$ para todo $t$: $f = g$.
  + *(iii)* $abs(f(t) - g(t)) = abs(g(t) - f(t))$ para todo $t$: es la misma función, con el mismo máximo.
  + *(iv)* Para $f, g, h$ y cada $t in [0, 1]$,
    $ abs(f(t) - h(t)) <= abs(f(t) - g(t)) + abs(g(t) - h(t)) <= d_oo (f, g) + d_oo (g, h). $
    En particular en $t = t_0$, el punto donde se alcanza $d_oo (f, h)$: $d_oo (f, h) <= d_oo (f, g) + d_oo (g, h)$.

  *Bola.* Afirmamos que $g in B_oo (f, r) <=> abs(f(t) - g(t)) < r$ para todo $t in [0, 1]$.
  ($==>$) $abs(f(t) - g(t)) <= d_oo (f, g) < r$. ($arrow.l.double$) (W) Si $t_0$ es el punto donde se
  alcanza el máximo, $d_oo (f, g) = abs(f(t_0) - g(t_0)) < r$. (Acá se usa que el supremo *es* un
  máximo: con un supremo, "todos $< r$" no alcanzaría para "supremo $< r$".) Luego
  $ B_oo (f, r) = \{g in C([0, 1]) : f(t) - r < g(t) < f(t) + r " para todo " t in [0, 1]\}: $
  las funciones continuas cuyo gráfico queda estrictamente adentro de la *banda* de semiancho $r$
  alrededor del gráfico de $f$.

  #block(breakable: false, width: 100%)[#align(center)[
    #cetz.canvas({
      import cetz.draw: *
      let n = 40
      let fx(i) = i / n * 5.4
      let ff(i) = 2.0 + 0.7 * calc.sin(i / n * 5.0)
      let gg(i) = 2.0 + 0.7 * calc.sin(i / n * 5.0) + 0.3 * calc.sin(i / n * 14.0)
      let up = range(0, n + 1).map(i => (fx(i), ff(i) + 0.8))
      let lo = range(0, n + 1).map(i => (fx(i), ff(i) - 0.8))
      line(..up, ..lo.rev(), close: true, fill: e1-relleno, stroke: none)
      line(..up, stroke: (paint: rgb("#2563eb"), thickness: 1pt, dash: "dashed"))
      line(..lo, stroke: (paint: rgb("#2563eb"), thickness: 1pt, dash: "dashed"))
      line(..range(0, n + 1).map(i => (fx(i), ff(i))), stroke: 1.4pt + rgb("#dc2626"))
      line(..range(0, n + 1).map(i => (fx(i), gg(i))), stroke: 1pt + rgb("#15803d"))
      line((0, 0), (6, 0), mark: (end: ">"), stroke: 0.6pt + luma(90))
      line((0, 0), (0, 4.1), mark: (end: ">"), stroke: 0.6pt + luma(90))
      content((0, -0.3), text(size: 9pt)[$0$])
      content((5.4, -0.3), text(size: 9pt)[$1$])
      content((6.2, -0.3), text(size: 9pt)[$t$])
      content((5.75, ff(40) + 0.2), text(size: 9pt, fill: rgb("#dc2626"))[$f$])
      content((5.95, ff(40) + 0.85), text(size: 9pt, fill: rgb("#2563eb"))[$f + r$])
      content((5.95, ff(40) - 0.85), text(size: 9pt, fill: rgb("#2563eb"))[$f - r$])
      content((2.0, 3.9), text(size: 9pt, fill: rgb("#15803d"))[$g in B_oo (f, r)$])
    })
  ]]
]

// ---------------------------------------------------------------- (f)
#enunciado[Ejercicio 1 (f)][
  $E$ un conjunto no vacío, con la métrica $delta(x, y) = 0$ si $x = y$ y $delta(x, y) = 1$ si $x != y$.
]

#resolucion[Propuesta: es métrica; $B(x, r) = \{x\}$ si $r <= 1$ y $B(x, r) = E$ si $r > 1$][
  + *(i)* $delta$ sólo toma los valores $0$ y $1$.
  + *(ii)* Por definición $delta(x, y) = 0$ si y sólo si $x = y$.
  + *(iii)* Si $x = y$, ambos valores son $0$. Si $x != y$ entonces $y != x$ y ambos valen $1$.
  + *(iv)* Sean $x, y, z in E$. Si $x = z$, $delta(x, z) = 0 <= delta(x, y) + delta(y, z)$ porque los
    sumandos son $>= 0$. Si $x != z$, $delta(x, z) = 1$, y $y$ no puede ser igual a $x$ y a $z$ a la
    vez (sería $x = z$); luego $delta(x, y) = 1$ o $delta(y, z) = 1$, y el otro sumando es $>= 0$, así
    que $delta(x, y) + delta(y, z) >= 1 = delta(x, z)$.

  *Bola.* Sea $r > 0$.
  - Si $r <= 1$: $y = x$ está en $B(x, r)$ porque $delta(x, x) = 0 < r$; y si $y != x$, $delta(x, y) = 1 >= r$, así que $y in.not B(x, r)$. Luego $B(x, r) = \{x\}$: *un solo punto*.
  - Si $r > 1$: para todo $y$, $delta(x, y) <= 1 < r$, luego $B(x, r) = E$: *todo el espacio*.

  #block(breakable: false, width: 100%)[#align(center)[
    #cetz.canvas({
      import cetz.draw: *
      // r <= 1
      circle((0, 0), radius: (2.0, 1.2), stroke: 0.8pt + luma(120))
      content((-1.5, 0.95), text(size: 9pt)[$E$])
      circle((0.1, -0.1), radius: 0.09, fill: rgb("#2563eb"), stroke: rgb("#2563eb"))
      content((0.1, -0.5), text(size: 9pt, fill: rgb("#2563eb"))[$x$])
      for p in ((-1.0, 0.2), (0.9, 0.5), (1.1, -0.5), (-0.6, -0.6)) {
        circle(p, radius: 0.05, fill: luma(120), stroke: none)
      }
      content((0, -1.7), text(size: 9pt)[$B(x, r) = \{x\}$ si $0 < r <= 1$])
      // r > 1
      circle((5.5, 0), radius: (2.0, 1.2), fill: e1-relleno, stroke: e1-borde)
      content((4.0, 0.95), text(size: 9pt)[$E$])
      circle((5.6, -0.1), radius: 0.09, fill: rgb("#2563eb"), stroke: rgb("#2563eb"))
      content((5.6, -0.5), text(size: 9pt, fill: rgb("#2563eb"))[$x$])
      for p in ((4.5, 0.2), (6.4, 0.5), (6.6, -0.5), (4.9, -0.6)) {
        circle(p, radius: 0.05, fill: luma(60), stroke: none)
      }
      content((5.5, -1.7), text(size: 9pt)[$B(x, r) = E$ si $r > 1$])
    })
  ]]
]

#observacion[Verificado en Lean: `Guias.Guia3.Ej01`][
  Cada ítem prueba `EsMetrica d` (la Definición 4.1 de `Guias/Common.lean`, con los cuatro campos
  `nonneg`, `eq_zero_iff`, `symm`, `triangle`) sobre la función explícita: `ej1a` ($abs(x - y)$ en
  $RR$), `ej1b` ($d_2$), `ej1c` ($d_1$), `ej1d` ($d_oo$), `ej1e` ($d_oo$ en $C([0, 1])$) y `ej1f`
  ($delta$). Para $d_2$, `cauchy_schwarz` es el Lema de arriba (misma prueba: casos $A = 0$,
  $B = 0$, y la suma de cuadrados $sum (B a_i - A b_i)^2$), y la triangular sigue el desarrollo del
  texto; no se usa la instancia de Mathlib de $RR^n$ euclídeo.

  Las bolas dibujadas se verifican con `bola` de `Common.lean`: `bola_dA` ($(x - r, x + r)$),
  `bola_d2` y `bola_d2_R2` (el disco $x_0^2 + x_1^2 < 1$), `bola_d1_R2` (el rombo
  $abs(x_0) + abs(x_1) < 1$), `bola_dinf` y `bola_dinf_R2` (el cuadrado), `bola_dC` (la banda) y
  `bola_delta_le` / `bola_delta_gt` ($\{x\}$ y $E$).

  Desvíos de la formalización: $RR^n$ es `Fin n → ℝ` y el máximo de $d_oo$ es `Finset.sup'` (pide
  `[NeZero n]`, es decir $n >= 1$, igual que el texto). $C([0, 1])$ es `C(unitInterval, ℝ)` y $d_oo$
  se escribe con `⨆`; `exists_max` es el Weierstrass del texto (`IsCompact.exists_isMaxOn`, la
  única entrada de compacidad del archivo: la acotación `bdd_absdiff` se deduce de ese máximo),
  `dC_eq_max` prueba que el supremo se alcanza y `bola_dC` lo usa exactamente en el paso (W).
  Los axiomas (i) y (iv) se cierran con propiedades del supremo (`Real.iSup_nonneg`, `ciSup_le`)
  en lugar de evaluar en $t_0$; es equivalente. La métrica $delta$ se formaliza para cualquier $E$ con
  igualdad decidible (la hipótesis "no vacío" no se necesita). Las bolas $B_2$ y $B_oo$ se
  formalizan con el centro $c$ genérico (y radio $r>0$ para $B_2$) y en $RR^2$ con centro $0$ y radio $1$.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 2

#enunciado[Ejercicio 2][
  Decida cuáles de las siguientes funciones definidas en $RR times RR$ son métricas en $RR$:
  #set enum(numbering: "(a)")
  + $d(x, y) = (x - y)^2$
  + $d(x, y) = sqrt(abs(x - y))$
  + $d(x, y) = abs(x^2 - y^2)$
]

#estrategia[Cada función se contrasta con los cuatro axiomas de la Definición 4.1][
  Para refutar basta un contraejemplo a un solo axioma; para probar hay que chequear los cuatro.
  En (a) la que falla es la desigualdad triangular (tres puntos equiespaciados); en (c) falla la
  separación (dos puntos opuestos que tienen el mismo cuadrado); (b) es una métrica porque la raíz
  cuadrada "achica" las sumas: $sqrt(a + b) <= sqrt(a) + sqrt(b)$.
]

#resolucion[Propuesta (a): $(x - y)^2$ NO es métrica][
  Falla (iv), la desigualdad triangular. Con $x = 0$, $y = 1$, $z = 2$:
  $ d(0, 2) = (0 - 2)^2 = 4 quad > quad 2 = 1 + 1 = (0 - 1)^2 + (1 - 2)^2 = d(0, 1) + d(1, 2). $
  Como el axioma (iv) de la Definición 4.1 pide $d(x, z) <= d(x, y) + d(y, z)$ para todos $x, y, z$,
  $d$ no es una métrica. (Los otros tres axiomas sí valen, pero no importa.)
]

#resolucion[Propuesta (b): $sqrt(abs(x - y))$ SÍ es métrica][
  + *(i)* Una raíz cuadrada es $>= 0$.
  + *(ii)* $sqrt(abs(x - y)) = 0 <=> abs(x - y) = 0 <=> x = y$.
  + *(iii)* $abs(x - y) = abs(y - x)$, luego las raíces coinciden.
  + *(iv)* Primero, una desigualdad auxiliar: para $a, b >= 0$,
    $ sqrt(a + b) <= sqrt(a) + sqrt(b). quad (star) $
    Ambos miembros son $>= 0$, así que basta comparar cuadrados:
    $ (sqrt(a) + sqrt(b))^2 = a + 2 sqrt(a) sqrt(b) + b >= a + b = (sqrt(a + b))^2, $
    pues $sqrt(a) sqrt(b) >= 0$. Ahora, por la desigualdad triangular de $RR$ y porque la raíz es creciente,
    $ sqrt(abs(x - z)) <= sqrt(abs(x - y) + abs(y - z)) <= sqrt(abs(x - y)) + sqrt(abs(y - z)), $
    donde la última desigualdad es $(star)$ con $a = abs(x - y)$ y $b = abs(y - z)$.
]

#resolucion[Propuesta (c): $abs(x^2 - y^2)$ NO es métrica][
  Falla (ii), la separación. Con $x = 1$ e $y = -1$:
  $ d(1, -1) = abs(1^2 - (-1)^2) = abs(1 - 1) = 0, quad "pero" quad 1 != -1. $
  El axioma (ii) exige $d(x, y) = 0 => x = y$, que acá no se cumple. (Intuitivamente, $d$ no
  distingue $x$ de $-x$.)
]

#observacion[Verificado en Lean: `Guias.Guia3.Ej02`][
  `ej2a : ¬ EsMetrica dA` se prueba con el contraejemplo explícito `dA_contraejemplo`
  ($d(0, 2) = 4 > 2$ es la negación de `triangle 0 1 2`). `ej2c : ¬ EsMetrica dC` usa
  `dC_contraejemplo` ($d(1, -1) = 0$ y $1 != -1$) contra `eq_zero_iff`. `ej2b : EsMetrica dB`
  prueba los cuatro axiomas, con `sqrt_add_le` como el paso $(star)$ (se eleva al cuadrado, igual
  que en el texto) y `abs_add_le` para la triangular de $RR$. La formalización no se aparta del texto.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 3

#enunciado[Ejercicio 3][
  Halle interior y clausura de cada uno de los siguientes subconjuntos de $RR$. Determine cuáles son abiertos o cerrados.
  #set enum(numbering: "(a)")
  + $[0, 1]$
  + $(0, 1)$
  + $QQ$
  + $QQ inter [0, 1]$
  + $ZZ$
  + $[0, 1) union \{2\}$
  + $\{1/n : n in NN\}$
  + $\{1/n : n in NN\} union \{0\}$
]

#estrategia[Bolas de $RR$ son intervalos: cuatro lemas bastan para los ocho conjuntos][
  En $RR$ con $d(x, y) = abs(x - y)$ se tiene $B(x, r) = (x - r, x + r)$. Con eso, "punto interior"
  (Def. 4.11) significa que un intervalo centrado en $x$ cabe en el conjunto, y "punto de
  adherencia" (Def. 4.22) que todo intervalo centrado en $x$ corta al conjunto. Cuatro lemas
  (intervalos adentro, intervalos afuera, racionales e irracionales por todos lados, puntos de
  $(a, b)$ cerca de cualquier $x in [a, b]$) resuelven (a)--(f); los conjuntos (g) y (h) se
  resuelven con Arquímedes y el _espaciado_ entre los $1\/n$ y $1\/(n+1)$.
  Siempre: $S^compose subset.eq S subset.eq overline(S)$ (Obs. 4.12 y 4.23), y $S$ es abierto
  si $S = S^compose$ (Def. 4.14), cerrado si $S = overline(S)$ (Def. 4.27).
]

#sublema(titulo: [Lema 1 (intervalos)])[
  Sean $S subset.eq RR$ y $a < b$.

  + Si $(a, b) subset.eq S$, entonces $(a, b) subset.eq S^compose$.
  + Si $S subset.eq [a, b]$, entonces $S^compose subset.eq (a, b)$ y $overline(S) subset.eq [a, b]$.

  _Prueba._ (1) Sea $x in (a, b)$ y $r = op("mín")\{x - a, b - x\} > 0$. Si $abs(y - x) < r$,
  entonces $y > x - r >= a$ e $y < x + r <= b$, es decir $B(x, r) subset.eq (a, b) subset.eq S$:
  $x$ es interior (Def. 4.11).

  (2) Sea $x in S^compose$ y $r > 0$ con $B(x, r) subset.eq S subset.eq [a, b]$. Los puntos
  $x plus.minus r\/2$ están en $B(x, r)$, luego en $[a, b]$: $a <= x - r\/2 < x$ y
  $x < x + r\/2 <= b$. Así $x in (a, b)$. Para la clausura, sea $x in.not [a, b]$. Si $x < a$,
  tomamos $r = a - x > 0$: $B(x, r) = (2x - a, a)$ no corta a $[a, b]$, luego tampoco a $S$, y
  $x in.not overline(S)$. Si $x > b$, $r = x - b$ funciona igual ($B(x, r) = (b, 2x - b)$).
]

#sublema(titulo: [Lema 2 (racionales e irracionales)])[
  Sean $x in RR$ y $r > 0$.

  + $B(x, r)$ contiene un racional (Densidad de $QQ$, Proposición 2) y un irracional
    (Práctica 1, Ej. 2 (d)).
  + Si $S subset.eq QQ$, entonces $S^compose = emptyset$.

  _Prueba._ (1) es aplicar esos resultados al intervalo $(x - r, x + r)$. (2) Si existiera
  $x in S^compose$, habría $r > 0$ con $B(x, r) subset.eq S subset.eq QQ$; pero por (1) $B(x, r)$
  tiene un irracional: absurdo.
]

#sublema(titulo: [Lema 3 (puntos de $(a, b)$ cerca de $x in [a, b]$)])[
  Sean $a < b$, $x in [a, b]$ y $r > 0$. Existe $y in (a, b)$ con $y != x$ y $abs(y - x) < r$. Más aún, se lo puede elegir racional.

  _Prueba._ Sea $t = op("mín")\{r, b - a\}\/4 > 0$. Si $x <= (a + b)\/2$, tomamos $y = x + t$:
  $y > x >= a$ e $y <= (a + b)\/2 + (b - a)\/4 < b$. Si $x > (a + b)\/2$, tomamos $y = x - t$:
  $y < x <= b$ e $y > (a + b)\/2 - (b - a)\/4 > a$. En ambos casos $y != x$ y
  $abs(y - x) = t < r$. Para el racional: por Densidad de $QQ$ hay $q in QQ$ estrictamente entre
  $x$ e $y$; entonces $q != x$, $abs(q - x) < abs(y - x) < r$ y, como $x in [a, b]$ e $y in (a, b)$,
  $q in (a, b)$.
]

#sublema(titulo: [Lema 4 ($\{1\/n\} union \{0\}$ es cerrado)])[
  Notamos $T = \{1\/n : n in NN\}$ y $U = T union \{0\}$. Si $x in.not U$, existe $r > 0$ con $B(x, r) inter U = emptyset$. En consecuencia
  $overline(U) = U$ y $overline(T) = U$.

  _Prueba._ Todo elemento de $U$ está en $[0, 1]$. Sea $x in.not U$ (en particular $x != 0$).
  - Si $x < 0$: $r = -x$ da $B(x, r) = (2x, 0)$, que no corta a $[0, oo)$.
  - Si $x > 1$: $r = x - 1$ da $B(x, r) = (1, 2x - 1)$, que no corta a $(-oo, 1]$.
  - Si $0 < x <= 1$: sea $u = 1\/x >= 1$. Primero, $u in.not ZZ$: si fuera $u = k in ZZ$, de $u >= 1$
    saldría $k in NN$ y $x = 1\/k in T$, contra la hipótesis. Por la Práctica 1, Ej. 2 (a), aplicada
    a $u - 1 < u + 1$ (su diferencia es $2 > 1$), existe $m in ZZ$ con $u - 1 < m < u + 1$. Como
    $u in.not ZZ$, $m != u$: si $m < u$ tomamos $n = m$, y si $m > u$ tomamos $n = m - 1$; en ambos
    casos $n in ZZ$ y $n < u < n + 1$. Además $n >= 1$: de $n + 1 > u >= 1$ sale $n > 0$, y $n$ es
    entero. Así $n in NN$ y $n < 1\/x < n + 1$, es decir
    $ 1/(n+1) < x < 1/n. $
    Sea $r = op("mín")\{1\/n - x, thick x - 1\/(n+1)\} > 0$; notar que $r < x$. Si $1\/m in B(x, r)$,
    entonces $1\/(n+1) = x - (x - 1\/(n+1)) <= x - r < 1\/m < x + r <= 1\/n$, de donde $m < n + 1$ y
    $m > n$, imposible para $m in NN$. Y $0 in.not B(x, r)$ porque $x - r > 0$. Luego
    $B(x, r) inter U = emptyset$.

  Esto dice que ningún $x in.not U$ es de adherencia de $U$: $overline(U) subset.eq U$, y con
  Obs. 4.23, $overline(U) = U$. Para $T$: $T subset.eq U$ da $overline(T) subset.eq overline(U) = U$
  (la clausura es monótona: si $B(x, r) inter T != emptyset$ entonces $B(x, r) inter U != emptyset$);
  recíprocamente $T subset.eq overline(T)$, y $0 in overline(T)$ porque dado $r > 0$ Arquímedes
  (Proposición 1) da $n in NN$ con $0 < 1\/n < r$, es decir $1\/n in B(0, r) inter T$. Entonces
  $overline(T) = U$.
]

#resolucion[Propuesta (a): $[0, 1]^compose = (0, 1)$, $overline([0, 1]) = [0, 1]$; cerrado, no abierto][
  Por el Lema 1 (2) con $S = [0, 1]$: $S^compose subset.eq (0, 1)$ y $overline(S) subset.eq [0, 1]$.
  Como $(0, 1) subset.eq S$, el Lema 1 (1) da $(0, 1) subset.eq S^compose$, y por la Obs. 4.23
  $S subset.eq overline(S)$. Entonces $S^compose = (0, 1)$ y $overline(S) = [0, 1]$.

  Es cerrado porque $overline(S) = S$ (Def. 4.27). No es abierto: $0 in S$ pero $0 in.not S^compose$,
  así que $S^compose != S$ (Def. 4.14). $qed$
]

#resolucion[Propuesta (b): $(0, 1)^compose = (0, 1)$, $overline((0, 1)) = [0, 1]$; abierto, no cerrado][
  Sea $S = (0, 1)$. Por el Lema 1 (1), $(0, 1) subset.eq S^compose$, y $S^compose subset.eq S$
  (Obs. 4.12): $S^compose = S$, es decir, $S$ es abierto (Def. 4.14).

  Por el Lema 1 (2), $overline(S) subset.eq [0, 1]$. Recíprocamente, si $x in [0, 1]$ y $r > 0$,
  el Lema 3 da $y in (0, 1) inter B(x, r)$, o sea $B(x, r) inter S != emptyset$: $x in overline(S)$.
  Así $overline(S) = [0, 1]$.

  No es cerrado: $0 in overline(S)$ pero $0 in.not S$, luego $overline(S) != S$. $qed$
]

#resolucion[Propuesta (c): $QQ^compose = emptyset$, $overline(QQ) = RR$; ni abierto ni cerrado][
  Por el Lema 2 (2) con $S = QQ$, $QQ^compose = emptyset$. Para la clausura, sean $x in RR$ y
  $r > 0$: por el Lema 2 (1), $B(x, r)$ contiene un racional, así que $B(x, r) inter QQ != emptyset$
  y $x in overline(QQ)$. Luego $overline(QQ) = RR$ (esto es la Obs. 4.32).

  No es abierto: $0 in QQ$ pero $0 in.not QQ^compose = emptyset$. No es cerrado: un irracional
  (por ejemplo, uno de $(0, 1)$, Práctica 1, Ej. 2 (d)) está en $overline(QQ) = RR$ pero no en $QQ$. $qed$
]

#resolucion[Propuesta (d): $(QQ inter [0, 1])^compose = emptyset$, $overline(QQ inter [0, 1]) = [0, 1]$; ni abierto ni cerrado][
  Sea $S = QQ inter [0, 1]$. Como $S subset.eq QQ$, el Lema 2 (2) da $S^compose = emptyset$.
  Como $S subset.eq [0, 1]$, el Lema 1 (2) da $overline(S) subset.eq [0, 1]$. Recíprocamente, para
  $x in [0, 1]$ y $r > 0$, el Lema 3 (versión racional) da $q in QQ inter (0, 1) inter B(x, r)$,
  así que $B(x, r) inter S != emptyset$. Luego $overline(S) = [0, 1]$.

  No es abierto: $0 in S$ y $0 in.not S^compose = emptyset$. No es cerrado: un irracional
  $z in (0, 1)$ (Práctica 1, Ej. 2 (d)) cumple $z in overline(S)$ y $z in.not S$. $qed$
]

#resolucion[Propuesta (e): $ZZ^compose = emptyset$, $overline(ZZ) = ZZ$; cerrado, no abierto][
  Como $ZZ subset.eq QQ$, el Lema 2 (2) da $ZZ^compose = emptyset$, y $ZZ$ no es abierto porque
  $0 in ZZ$ pero $0 in.not ZZ^compose$.

  Veamos que $overline(ZZ) subset.eq ZZ$ (la otra inclusión es la Obs. 4.23). Sea $x in.not ZZ$.
  Por la Práctica 1, Ej. 2 (a), aplicada a $x - 1 < x + 1$ (diferencia $2 > 1$), hay $m in ZZ$ con
  $x - 1 < m < x + 1$; como $x in.not ZZ$, $m != x$, y tomando $n = m$ si $m < x$ o $n = m - 1$ si
  $m > x$ queda $n in ZZ$ con $n < x < n + 1$.
  Sea $r = op("mín")\{x - n, thick n + 1 - x\} > 0$. Si $m in ZZ$ estuviera en $B(x, r)$, tendríamos
  $m > x - r >= n$ y $m < x + r <= n + 1$, o sea $n < m < n + 1$ con $m in ZZ$: absurdo.
  Entonces $B(x, r) inter ZZ = emptyset$ y $x in.not overline(ZZ)$.

  Luego $overline(ZZ) = ZZ$: $ZZ$ es cerrado (Def. 4.27). $qed$
]

#resolucion[Propuesta (f): $([0, 1) union \{2\})^compose = (0, 1)$, clausura $[0, 1] union \{2\}$; ni abierto ni cerrado][
  Sea $S = [0, 1) union \{2\}$.

  *Interior.* $(0, 1) subset.eq S$, así que $(0, 1) subset.eq S^compose$ (Lema 1 (1)). Recíprocamente,
  sea $x in S^compose$ con $B(x, r) subset.eq S$.
  - Si $x = 2$: el punto $2 + r\/2$ está en $B(2, r)$, pero ni es $2$ ni es menor que $1$:
    no está en $S$. Absurdo.
  - Si $x in [0, 1)$: el punto $x - r\/2$ está en $B(x, r) subset.eq S$ y es menor que $1$, luego
    no es $2$; así que $x - r\/2 in [0, 1)$, es decir $x - r\/2 >= 0$ y $x > 0$. Entonces $x in (0, 1)$.

  *Clausura.* $overline(S) supset.eq S$ (Obs. 4.23). Si $x in [0, 1]$ y $r > 0$, el Lema 3 da
  $y in (0, 1) inter B(x, r) subset.eq S$: $x in overline(S)$. Así $[0, 1] union \{2\} subset.eq overline(S)$.
  Recíprocamente, sea $x in.not [0, 1] union \{2\}$; hay tres casos y en cada uno una bola que no corta a $S$
  (todo elemento de $S$ es $< 1$ o es $2$):
  - $x < 0$: $r = -x$; $B(x, r) = (2x, 0)$ está a la izquierda de $S subset.eq [0, oo)$.
  - $1 < x < 2$: $r = op("mín")\{x - 1, thick 2 - x\}$; $B(x, r) subset.eq (1, 2)$ no contiene
    puntos menores que $1$ ni al $2$.
  - $x > 2$: $r = x - 2$; $B(x, r) = (2, 2x - 2)$ no contiene puntos menores que $1$ ni al $2$.

  Luego $overline(S) = [0, 1] union \{2\}$.

  *Ni abierto ni cerrado.* $0 in S$ pero $0 in.not S^compose = (0, 1)$: no es abierto. $1 in overline(S)$ pero
  $1 in.not S$: no es cerrado. $qed$
]

#resolucion[Propuesta (g): $T^compose = emptyset$, $overline(T) = T union \{0\}$; ni abierto ni cerrado][
  Sea $T = \{1\/n : n in NN\} subset.eq QQ$. Por el Lema 2 (2), $T^compose = emptyset$; como
  $1 = 1\/1 in T$, $T$ no es abierto. Por el Lema 4, $overline(T) = T union \{0\}$. Como $0 in overline(T)$
  pero $0 in.not T$ (todo $1\/n$ es positivo), $T$ no es cerrado. $qed$
]

#resolucion[Propuesta (h): $U^compose = emptyset$, $overline(U) = U$; cerrado, no abierto][
  Sea $U = \{1\/n : n in NN\} union \{0\} subset.eq QQ$. Por el Lema 2 (2), $U^compose = emptyset$, y
  $0 in U$ implica que $U$ no es abierto. Por el Lema 4, $overline(U) = U$: $U$ es cerrado
  (Def. 4.27). $qed$
]

#v(4pt)
#align(center)[
  #table(
    columns: (auto, auto, auto, auto, auto),
    align: (left, center, center, center, center),
    inset: 5pt,
    [*Conjunto $S$*], [*$S^compose$*], [*$overline(S)$*], [*¿abierto?*], [*¿cerrado?*],
    [$[0, 1]$], [$(0, 1)$], [$[0, 1]$], [no], [sí],
    [$(0, 1)$], [$(0, 1)$], [$[0, 1]$], [sí], [no],
    [$QQ$], [$emptyset$], [$RR$], [no], [no],
    [$QQ inter [0, 1]$], [$emptyset$], [$[0, 1]$], [no], [no],
    [$ZZ$], [$emptyset$], [$ZZ$], [no], [sí],
    [$[0, 1) union \{2\}$], [$(0, 1)$], [$[0, 1] union \{2\}$], [no], [no],
    [$\{1\/n : n in NN\}$], [$emptyset$], [$\{1\/n : n in NN\} union \{0\}$], [no], [no],
    [$\{1\/n : n in NN\} union \{0\}$], [$emptyset$], [$\{1\/n : n in NN\} union \{0\}$], [no], [sí],
  )
]

#observacion[Verificado en Lean: `Guias.Guia3.Ej03`][
  Cada conjunto es `Ca`, ..., `Ch`; las nociones del curso están definidas con bolas
  (`interiorCurso`, `clausuraCurso`, `AbiertoCurso`, `CerradoCurso`, Def. 4.11, 4.22, 4.14, 4.27).
  Los veredictos son, para cada letra `x`, `x_interior`, `x_clausura`, `x_abierto` o `x_no_abierto`,
  `x_cerrado` o `x_no_cerrado`. Los Lemas 1--4 son `interiorCurso_sub_Ioo`/`Ioo_sub_interiorCurso`/
  `clausuraCurso_sub_Icc`, `interiorCurso_vacio_of_racional`, `exists_pto`/`exists_rat_pto` y
  `lejos_Ch`/`clausura_Ch_sub`. `interior_eq_interiorCurso` y `closure_eq_clausuraCurso`
  (por `Metric.mem_nhds_iff` y `Metric.mem_closure_iff`) permiten releer todo con `interior`,
  `closure`, `IsOpen` e `IsClosed` de Mathlib (`a_mathlib`, ..., `h_mathlib`). No se usó ningún
  lema de Mathlib que calcule interiores o clausuras. Diferencias con el texto: el entero $n$ con
  $n < x < n + 1$ (que el texto obtiene de la Práctica 1, Ej. 2 (a)) en Lean es la parte entera
  `Int.floor`/`Nat.floor` de Mathlib; la densidad de irracionales (Práctica 1, Ej. 2 (d)) es
  `exists_irrational_btwn`; y `ℕ` empieza en $1$ (se escribe `1 ≤ n`).
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 4

Sea $(E, d)$ un espacio métrico, $x in E$ y $r > 0$. Usamos las nociones del curso por bolas:
interior (Definición 4.11), abierto (Definición 4.14), clausura (Definición 4.22) y cerrado
(Definición 4.27). Escribimos $B(x, r) = \{y in E : d(x, y) < r\}$ y
$overline(B)(x, r) = \{y in E : d(x, y) <= r\}$.

#enunciado[Ejercicio 4 (a)][
  Pruebe que $\{x\}$ es un conjunto cerrado.
]
#estrategia[Un punto distinto de $x$ está a distancia positiva][
  Por la Definición 4.27 hay que ver $overline(\{x\}) = \{x\}$. La inclusión $supset.eq$ es la
  Observación 4.23 (a). Para $subset.eq$, un punto $y != x$ está a distancia $r = d(y, x) > 0$ de
  $x$, y la bola $B(y, r)$ ya no contiene a $x$: entonces $y$ no es de adherencia.
]
#resolucion[Propuesta: $\{x\}$ es cerrado][
  Por la Observación 4.23 (a), $\{x\} subset.eq overline(\{x\})$. Veamos la otra inclusión por el
  contrarrecíproco. Sea $y in E$ con $y != x$. Por la Definición 4.1 (ii), $r = d(y, x) > 0$.
  Afirmamos que $B(y, r) inter \{x\} = nothing$: la única posibilidad es $x in B(y, r)$, es decir
  $d(y, x) < r = d(y, x)$, que es absurdo. Luego existe un radio $r > 0$ con
  $B(y, r) inter \{x\} = nothing$, o sea $y in.not overline(\{x\})$. Así,
  $overline(\{x\}) subset.eq \{x\}$ y $overline(\{x\}) = \{x\}$. $qed$
]

#enunciado[Ejercicio 4 (b)][
  Pruebe que $B(x, r)$ es un conjunto abierto.
]
#estrategia[Achicar el radio lo que ya se alejó el punto][
  Para $y in B(x, r)$ sobra una "holgura" $r - d(y, x) > 0$, y la bola de ese radio centrada en
  $y$ cabe en $B(x, r)$ por la desigualdad triangular.
]
#resolucion[Propuesta: $B(x, r)$ es abierta][
  Sea $y in B(x, r)$ y $s = r - d(y, x) > 0$. Veamos que $B(y, s) subset.eq B(x, r)$. Si
  $z in B(y, s)$, por la desigualdad triangular (Definición 4.1 (iv))
  $ d(z, x) <= d(z, y) + d(y, x) < s + d(y, x) = r, $
  es decir $z in B(x, r)$. Todo $y in B(x, r)$ es entonces punto interior (Definición 4.11):
  $B(x, r) subset.eq B(x, r)^compose$ y, como siempre vale $B(x, r)^compose subset.eq B(x, r)$
  (Observación 4.12), $B(x, r) = B(x, r)^compose$: es abierta (Definición 4.14). $qed$
]

#enunciado[Ejercicio 4 (c)][
  Pruebe que si $r > r' > 0$ entonces $overline(B(x, r')) subset.eq B(x, r)$.
]
#estrategia[Usar la holgura $r - r'$ como radio de adherencia][
  Si $y$ es de adherencia de $B(x, r')$, la bola $B(y, r - r')$ toca a $B(x, r')$ en un punto
  $z$, y la triangular acota $d(y, x)$ por $(r - r') + r' = r$.
]
#resolucion[Propuesta: $overline(B(x, r')) subset.eq B(x, r)$][
  Sea $y in overline(B(x, r'))$. Como $r - r' > 0$, la Definición 4.22 da un
  $z in B(y, r - r') inter B(x, r')$. Entonces $d(y, z) < r - r'$ y $d(z, x) < r'$, y por la
  desigualdad triangular
  $ d(y, x) <= d(y, z) + d(z, x) < (r - r') + r' = r. $
  Luego $y in B(x, r)$. (El argumento sólo usa $r' < r$.) $qed$
]

#enunciado[Ejercicio 4 (d)][
  Pruebe que $overline(B)(x, r) = \{y in E : d(x, y) <= r\}$ es un conjunto cerrado.
]
#estrategia[El complemento es abierto (Teorema 4.29)][
  Si $y$ cumple $d(y, x) > r$, la bola centrada en $y$ de radio $d(y, x) - r$ no llega a
  $overline(B)(x, r)$. Por el Teorema 4.29, el complemento abierto equivale a ser cerrado.
]
#resolucion[Propuesta: $overline(B)(x, r)$ es cerrada][
  Sea $y in E backslash overline(B)(x, r)$, es decir $d(y, x) > r$, y sea $s = d(y, x) - r > 0$.
  Veamos que $B(y, s) subset.eq E backslash overline(B)(x, r)$. Si $z in B(y, s)$, entonces
  $d(y, z) < s$ y, por la triangular, $d(y, x) <= d(y, z) + d(z, x)$, de donde
  $ d(z, x) >= d(y, x) - d(y, z) > d(y, x) - s = r. $
  Luego $z in.not overline(B)(x, r)$. Así $E backslash overline(B)(x, r)$ es abierto (Definición
  4.14, como en (b)) y, por el Teorema 4.29, $overline(B)(x, r)$ es cerrado. $qed$
]

#enunciado[Ejercicio 4 (e)][
  Deduzca que $overline(B(x, r)) subset.eq overline(B)(x, r)$.
]
#estrategia[Clausura monótona y bola cerrada cerrada][
  $B(x, r) subset.eq overline(B)(x, r)$, la clausura respeta inclusiones y la clausura de un
  cerrado es él mismo.
]
#resolucion[Propuesta: $overline(B(x, r)) subset.eq overline(B)(x, r)$][
  Si $A subset.eq C$ entonces $overline(A) subset.eq overline(C)$: un punto de adherencia de $A$ lo
  es de $C$, porque $B(y, s) inter A != nothing$ implica $B(y, s) inter C != nothing$
  (Definición 4.22). Como $B(x, r) subset.eq overline(B)(x, r)$ (si $d(x, y) < r$ entonces
  $d(x, y) <= r$), resulta
  $ overline(B(x, r)) subset.eq overline(overline(B)(x, r)) = overline(B)(x, r), $
  donde la igualdad es la Definición 4.27 aplicada al cerrado de (d). $qed$
]

#enunciado[Ejercicio 4 (f)][
  Dé un ejemplo en que $overline(B(x, r))$ sea un subconjunto propio de $overline(B)(x, r)$.
]
#estrategia[Métrica discreta con $r = 1$][
  En un conjunto con al menos dos puntos y la métrica discreta, $B(x, 1) = \{x\}$ pero
  $overline(B)(x, 1)$ es todo el espacio.
]
#resolucion[Propuesta: $E$ con la métrica discreta, $r = 1$][
  Sea $E$ un conjunto con al menos dos puntos y $delta$ la métrica discreta
  ($delta(y, z) = 0$ si $y = z$ y $1$ si no). Fijemos $x in E$ y $r = 1$.
  - $B(x, 1) = \{y : delta(x, y) < 1\} = \{x\}$, porque $y != x$ da $delta(x, y) = 1$. Por (a),
    $overline(B(x, 1)) = overline(\{x\}) = \{x\}$.
  - $overline(B)(x, 1) = \{y : delta(x, y) <= 1\} = E$, pues $delta$ nunca supera $1$.
  Como $E$ tiene otro punto $y != x$, tenemos $y in overline(B)(x, 1)$ pero
  $y in.not overline(B(x, 1))$. Entonces $overline(B(x, 1)) subset.neq overline(B)(x, 1)$. $qed$
]

#enunciado[Ejercicio 4 (g)][
  Pruebe que $\{y in E : 2 < d(y, x) < 3\}$ es un conjunto abierto.
]
#estrategia[Una bola abierta menos una bola cerrada][
  El conjunto es $B(x, 3) inter (E backslash overline(B)(x, 2))$: intersección de dos abiertos,
  por (b) y por (d) con el Teorema 4.29.
]
#resolucion[Propuesta: es la intersección $B(x, 3) inter (E backslash overline(B)(x, 2))$][
  Por simetría de $d$, $d(y, x) = d(x, y)$. Entonces
  $ \{y : 2 < d(y, x) < 3\} = \{y : d(x, y) < 3\} inter \{y : d(x, y) > 2\}
    = B(x, 3) inter (E backslash overline(B)(x, 2)). $
  $B(x, 3)$ es abierta por (b). $overline(B)(x, 2)$ es cerrada por (d), así que su complemento es
  abierto (Teorema 4.29). La intersección de dos abiertos es abierta (Teorema 4.18). $qed$
]

#observacion[Verificado en Lean: `Guias.Guia3.Ej04`][
  Los ítems son `ej4a` a `ej4g` (con `ej4f_bool` como caso concreto de (f)), sobre
  `{E : Type*} [MetricSpace E]` y con los objetos de Mathlib `closure`, `Metric.ball`,
  `Metric.closedBall`, `IsOpen`, `IsClosed`. No se usan los lemas de Mathlib que son los ítems:
  las herramientas del curso son los lemas puente de `Guias/Common.lean` (`mem_closure_iff_ball`
  es la Definición 4.22, `closure_mono_ball` la monotonía de la clausura) y, en el archivo,
  `isClosed_iff_isOpen_compl_ball` (el Teorema 4.29)
  y `isOpen_inter_ball` el Teorema 4.18 para dos abiertos, con $r = op("mín")\{r_1, r_2\}$). Desvíos:
  (i) "abierto" es `IsOpen`, leído con `Metric.isOpen_iff` como "todo punto tiene una bola
  adentro" ($A subset.eq A^compose$, que con la Observación 4.12 es la Definición 4.14); "cerrado"
  es `IsClosed`, y se pasa a la Definición 4.27 ($overline(F) = F$) con
  `closure_eq_iff_isClosed`; en (e) se usa `IsClosed.closure_eq` sólo para esa igualdad;
  (ii) `ej4b` y `ej4c` valen sin la hipótesis $r > 0$ (o $r' > 0$), que el argumento no usa, y
  `ej4d` vale para todo $r$; (iii) para (f) se define localmente `Disc X` (un sinónimo de $X$ con
  la métrica discreta y su instancia `MetricSpace`) y `ej4f` vale para todo `X` con
  `[Nontrivial X]`: afirma `closure (ball x 1) ⊂ closedBall x 1`, inclusión estricta; (iv) en (g)
  el conjunto se escribe `{y | 2 < dist y x ∧ dist y x < 3}` y se prueba la igualdad con
  `ball x 3 ∩ (closedBall x 2)ᶜ` como en el texto.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 5

Sea $E$ un espacio métrico y $A subset.eq E$. Escribimos $B(x, r) = \{y in E : d(x, y) < r\}$.

#enunciado[Ejercicio 5 (a)][
  Pruebe que $E backslash A^compose = overline(E backslash A)$.
]
#estrategia[Negar la definición de punto interior][
  $x in.not A^compose$ dice que ninguna bola alrededor de $x$ cabe en $A$, es decir que toda bola
  contiene algún punto fuera de $A$. Eso es exactamente ser de adherencia de $E backslash A$.
]
#resolucion[Propuesta: $E backslash A^compose = overline(E backslash A)$][
  Para $x in E$ encadenamos equivalencias.
  - Por la Definición 4.11, $x in.not A^compose$ si y sólo si para todo $r > 0$ es falso que
    $B(x, r) subset.eq A$.
  - Para un $r > 0$ dado, "$B(x, r) subset.eq A$ es falso" significa que existe $z in B(x, r)$
    con $z in.not A$, es decir $B(x, r) inter (E backslash A) != nothing$.
  - Por la Definición 4.22, "para todo $r > 0$, $B(x, r) inter (E backslash A) != nothing$" es
    $x in overline(E backslash A)$.
  Luego $x in E backslash A^compose <=> x in overline(E backslash A)$. $qed$
]

#enunciado[Ejercicio 5 (b)][
  Pruebe que $E backslash overline(A) = (E backslash A)^compose$.
]
#estrategia[Negar la definición de punto de adherencia][
  $x in.not overline(A)$ dice que alguna bola alrededor de $x$ no toca a $A$, es decir, que
  cabe en $E backslash A$. Eso es ser punto interior de $E backslash A$.
]
#resolucion[Propuesta: $E backslash overline(A) = (E backslash A)^compose$][
  - Por la Definición 4.22, $x in.not overline(A)$ si y sólo si existe $r > 0$ con
    $B(x, r) inter A = nothing$.
  - $B(x, r) inter A = nothing$ equivale a que ningún punto de $B(x, r)$ esté en $A$, o sea
    $B(x, r) subset.eq E backslash A$.
  - Por la Definición 4.11, "existe $r > 0$ con $B(x, r) subset.eq E backslash A$" es
    $x in (E backslash A)^compose$.
  Luego $x in E backslash overline(A) <=> x in (E backslash A)^compose$. $qed$
]

#enunciado[Ejercicio 5 (pregunta final)][
  ¿Son ciertas las igualdades $overline(A) = overline(A^compose)$ y
  $A^compose = (overline(A))^compose$?
]
#estrategia[Contraejemplo: los racionales en $RR$][
  $QQ$ es denso y "sin interior": $overline(QQ) = RR$ y $QQ^compose = emptyset$ (Observación
  4.32). Con $A = QQ$ las dos igualdades se rompen.
]
#resolucion[Propuesta: ambas son falsas en general][
  Tomemos $E = RR$ con $d(x, y) = abs(x - y)$ y $A = QQ$. Recordemos por qué (Observación 4.32).
  - $overline(QQ) = RR$: dado $x in RR$ y $r > 0$, por la densidad de $QQ$ (Proposición 2, Densidad
    de $QQ$) hay un racional en $(x - r, x + r) = B(x, r)$, así que $B(x, r) inter QQ != nothing$.
  - $QQ^compose = emptyset$: dado $x in RR$ y $r > 0$, el intervalo $(x, x + r) subset.eq B(x, r)$
    contiene un irracional (Práctica 1, Ej. 2 (d), con $x < x + r$), luego
    $B(x, r) subset.eq.not QQ$ para todo $r > 0$ y ningún $x$ es interior.
  Además $emptyset$ no tiene puntos de adherencia (toda bola corta a $emptyset$ en el vacío), y
  todo punto de $RR$ es interior de $RR$ (toda bola está contenida en $RR$). Entonces:
  - $overline(A) = overline(QQ) = RR$ pero $overline(A^compose) = overline(emptyset) = emptyset$:
    la primera igualdad *es falsa*.
  - $A^compose = QQ^compose = emptyset$ pero $(overline(A))^compose = RR^compose = RR$: la
    segunda igualdad *es falsa*.

  Lo que sí vale en general son las inclusiones
  $ overline(A^compose) subset.eq overline(A) quad "y" quad A^compose subset.eq (overline(A))^compose. $
  En efecto, $A^compose subset.eq A subset.eq overline(A)$ (Observación 4.23 (b)); la clausura
  respeta inclusiones (si $B(x, s) inter C != nothing$ y $C subset.eq D$ entonces
  $B(x, s) inter D != nothing$), lo que da la primera; y si $B(x, r) subset.eq A^compose subset.eq A$
  entonces $B(x, r) subset.eq overline(A)$, lo que da la segunda (deducción propia). $qed$
]

#observacion[Verificado en Lean: `Guias.Guia3.Ej05`][
  `ej5a : (interior A)ᶜ = closure Aᶜ` y `ej5b : (closure A)ᶜ = interior Aᶜ`, probados con
  `mem_interior_iff_ball` (Definición 4.11) y `mem_closure_iff_ball` (Definición 4.22), los lemas
  puente de `Guias/Common.lean` (probados desde `Metric.mem_nhds_iff` y `Metric.mem_closure_iff`);
  el complemento $E backslash A$
  es `Aᶜ`. Para la pregunta final, `Q` es `Set.range ((↑) : ℚ → ℝ)`, con `closure_Q`
  ($overline(QQ) = RR$, vía `exists_rat_btwn`), `interior_Q` ($QQ^compose = emptyset$, vía
  `exists_irrational_btwn`), `closure_empty_ball` e `interior_univ_ball`. Los veredictos son
  `closure_ne_closure_interior` e `interior_ne_interior_closure`, reunidos en `ej5_final`
  ($not forall A, overline(A) = overline(A^compose)$ y $not forall A, A^compose = (overline(A))^compose$,
  en $RR$). Las inclusiones que sí valen son `closure_interior_subset` e
  `interior_subset_interior_closure`. Desvío: la densidad de racionales e irracionales se toma de
  Mathlib en lugar de la Proposición 2 del apunte y de la Práctica 1, Ej. 2 (d).
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 6

Sea $E$ un espacio métrico y sean $A, B subset.eq E$. Escribimos $B(x, r) = \{y in E : d(x, y) < r\}$
(la bola; no confundir con el conjunto $B$).

#enunciado[Ejercicio 6 (a)][
  Pruebe que $(A inter B)^compose = A^compose inter B^compose$.
]
#estrategia[Achicar al mínimo de dos radios][
  $subset.eq$: una bola dentro de $A inter B$ está dentro de $A$ y de $B$. $supset.eq$: si hay una
  bola dentro de $A$ y otra dentro de $B$, la más chica de las dos entra en ambos.
]
#resolucion[Propuesta: $(A inter B)^compose = A^compose inter B^compose$][
  *($subset.eq$)* Sea $x in (A inter B)^compose$. Por la Definición 4.11 existe $r > 0$ con
  $B(x, r) subset.eq A inter B$, luego $B(x, r) subset.eq A$ y $B(x, r) subset.eq B$, es decir
  $x in A^compose$ y $x in B^compose$.

  *($supset.eq$)* Sea $x in A^compose inter B^compose$. Existen $r_1, r_2 > 0$ con
  $B(x, r_1) subset.eq A$ y $B(x, r_2) subset.eq B$. Sea $r = op("mín")\{r_1, r_2\} > 0$.
  Como $r <= r_i$, $B(x, r) subset.eq B(x, r_i)$ ($d(x, y) < r <= r_i$), de donde
  $B(x, r) subset.eq A$ y $B(x, r) subset.eq B$, es decir $B(x, r) subset.eq A inter B$.
  Luego $x in (A inter B)^compose$. $qed$
]

#enunciado[Ejercicio 6 (b)][
  Pruebe que $A^compose union B^compose subset.eq (A union B)^compose$.
]
#estrategia[La misma bola sirve][
  Un punto interior de $A$ (o de $B$) tiene una bola dentro de $A$ (o de $B$), que también está
  dentro de $A union B$.
]
#resolucion[Propuesta: $A^compose union B^compose subset.eq (A union B)^compose$][
  Sea $x in A^compose union B^compose$. Si $x in A^compose$, existe $r > 0$ con
  $B(x, r) subset.eq A subset.eq A union B$, así que $x in (A union B)^compose$. Si
  $x in B^compose$, existe $r > 0$ con $B(x, r) subset.eq B subset.eq A union B$ y se concluye
  igual. $qed$
]

#enunciado[Ejercicio 6 (c)][
  Pruebe que $overline(A union B) = overline(A) union overline(B)$.
]
#estrategia[$supset.eq$ por monotonía y $subset.eq$ por el contrarrecíproco][
  Si $x$ no es de adherencia ni de $A$ ni de $B$, hay una bola que no toca a $A$ y otra que no toca
  a $B$; la más chica no toca a $A union B$.
]
#resolucion[Propuesta: $overline(A union B) = overline(A) union overline(B)$][
  *($supset.eq$)* Si $x in overline(A)$, para todo $r > 0$ vale $B(x, r) inter A != nothing$,
  y como $A subset.eq A union B$ también $B(x, r) inter (A union B) != nothing$: $x in overline(A union B)$
  (Definición 4.22). Idem con $B$.

  *($subset.eq$)* Sea $x in.not overline(A) union overline(B)$. Por la Definición 4.22 existen
  $r_1, r_2 > 0$ con $B(x, r_1) inter A = nothing$ y $B(x, r_2) inter B = nothing$. Sea
  $r = op("mín")\{r_1, r_2\} > 0$. Como $B(x, r) subset.eq B(x, r_1)$ y $B(x, r) subset.eq B(x, r_2)$,
  $ B(x, r) inter (A union B) = (B(x, r) inter A) union (B(x, r) inter B) = nothing. $
  Luego $x in.not overline(A union B)$. Por contrarrecíproco, $overline(A union B) subset.eq overline(A) union overline(B)$. $qed$
]

#enunciado[Ejercicio 6 (d)][
  Pruebe que $overline(A inter B) subset.eq overline(A) inter overline(B)$.
]
#estrategia[Monotonía de la clausura][
  $A inter B$ está contenido en $A$ y en $B$, y un punto de adherencia de un conjunto lo es de
  cualquier conjunto que lo contenga.
]
#resolucion[Propuesta: $overline(A inter B) subset.eq overline(A) inter overline(B)$][
  Sea $x in overline(A inter B)$ y $r > 0$. Por la Definición 4.22, $B(x, r) inter (A inter B) != nothing$.
  Como $A inter B subset.eq A$ y $A inter B subset.eq B$, resulta $B(x, r) inter A != nothing$ y
  $B(x, r) inter B != nothing$. Como $r$ era arbitrario, $x in overline(A)$ y $x in overline(B)$. $qed$
]

#enunciado[Ejercicio 6 (ejemplos)][
  Encuentre ejemplos en que no valga la igualdad en (b) y (d).
]
#estrategia[Dos intervalos que se tocan en un punto][
  Para (b), dos cerrados que se pegan en $1$ (el $1$ es interior de la unión pero no de cada uno).
  Para (d), dos abiertos que se tocan en $1$ (disjuntos, pero $1$ está en ambas clausuras).
]
#resolucion[Propuesta: (b) $A = [0, 1]$, $B = [1, 2]$; (d) $A = (0, 1)$, $B = (1, 2)$ en $RR$][
  Trabajamos en $RR$ con $d(x, y) = abs(x - y)$, donde $B(x, r) = (x - r, x + r)$.

  *Ejemplo para (b).* Sean $A = [0, 1]$ y $B = [1, 2]$, así que $A union B = [0, 2]$.
  - $1 in (A union B)^compose$: $B(1, 1) = (0, 2) subset.eq [0, 2]$.
  - $1 in.not A^compose$: para todo $r > 0$, el punto $1 + r/2$ está en $B(1, r)$ y no en $A$ (es
    mayor que $1$). Luego $B(1, r) subset.eq.not A$ para todo $r > 0$.
  - $1 in.not B^compose$: para todo $r > 0$, el punto $1 - r/2$ está en $B(1, r)$ y no en $B$ (es
    menor que $1$).
  Entonces $1 in (A union B)^compose$ pero $1 in.not A^compose union B^compose$: la inclusión de (b)
  es estricta.

  *Ejemplo para (d).* Sean $A = (0, 1)$ y $B = (1, 2)$.
  - $A inter B = emptyset$ (un punto con $x < 1$ y $x > 1$ no existe), y $overline(emptyset) = emptyset$:
    ninguna bola corta al vacío (Definición 4.22).
  - $1 in overline(A)$: dado $r > 0$ sea $m = op("mín")\{r, 1\}$ y $y = 1 - m/2$. Como
    $0 < m/2 <= 1/2$, vale $0 < y < 1$, o sea $y in A$; y $abs(y - 1) = m/2 < r$, o sea
    $y in B(1, r)$. Luego $B(1, r) inter A != nothing$.
  - $1 in overline(B)$: con el mismo $m$ y $y = 1 + m/2$ vale $1 < y < 2$ y
    $abs(y - 1) = m/2 < r$.
  Así $1 in overline(A) inter overline(B)$ pero $overline(A inter B) = emptyset$: la inclusión de (d)
  es estricta. $qed$
]

#observacion[Verificado en Lean: `Guias.Guia3.Ej06`][
  `ej6a`, `ej6b`, `ej6c`, `ej6d` son los cuatro ítems, para `{E : Type*} [MetricSpace E]` y con
  `interior`, `closure` de Mathlib; se prueban con `mem_interior_iff_ball` (Definición 4.11),
  `mem_closure_iff_ball` y `notMem_closure_iff_ball` (Definición 4.22 y su negación), los lemas
  puente de `Guias/Common.lean`. El paso "$r = op("mín")\{r_1, r_2\}$"
  es `ball_subset_ball (min_le_left _ _)`. No se usan `interior_inter`, `closure_union` ni
  `closure_inter_subset`. Los ejemplos son `ej6b_ejemplo`
  (`interior (Icc 0 1) ∪ interior (Icc 1 2) ≠ interior (Icc 0 1 ∪ Icc 1 2)`) y `ej6d_ejemplo`
  (`closure (Ioo 0 1 ∩ Ioo 1 2) ≠ closure (Ioo 0 1) ∩ closure (Ioo 1 2)`); se calculan con las
  bolas, con los mismos puntos $1 plus.minus r/2$ y $1 plus.minus m/2$ del texto, y no con
  `interior_Icc`. Como (b) y (d) valen siempre (`ej6b`, `ej6d`), las desigualdades `≠` de los
  ejemplos son exactamente la inclusión estricta, enunciada con `⊂` en `ej6b_ejemplo_ssubset` y
  `ej6d_ejemplo_ssubset`.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 7

#enunciado[Ejercicio 7 (a)][
  Sean $E$ un espacio métrico y $A, B subset.eq E$ subconjuntos acotados de $E$. Pruebe que si
  $A subset.eq B$ entonces $op("diam")(A) <= op("diam")(B)$.
]
#estrategia[Más elementos, supremo más grande][
  Si $A subset.eq B$, toda distancia $d(x, y)$ con $x, y in A$ es también una distancia entre
  puntos de $B$. Así, $op("diam")(B)$ es una cota superior de las distancias de $A$, y el
  supremo es la _menor_ cota superior.
]
#resolucion[Propuesta: $op("diam")(A) <= op("diam")(B)$][
  Escribimos $S(A) = \{d(x, y) : x, y in A\}$, de modo que $op("diam")(A) = op("sup") S(A)$
  (Definición 4.9). Suponemos $A != nothing$: la Definición 4.9 pide un supremo, y el supremo se
  definió (Definición 2) para conjuntos no vacíos. Entonces $S(A) != nothing$ (contiene a
  $d(x, x) = 0$ para cualquier $x in A$) y está acotado superiormente, porque $A$ es acotado
  (Definición 4.8: existe $C > 0$ con $d(x, y) <= C$ para todo $x, y in A$). Por completitud
  (Definición 2 y axioma de completitud) existe $op("diam")(A)$; lo mismo vale para $B$.

  Sean $x, y in A$. Como $A subset.eq B$, también $x, y in B$, y entonces
  $ d(x, y) <= op("sup") S(B) = op("diam")(B), $
  porque el supremo es cota superior de $S(B)$. Esto vale para todo par $x, y in A$: es decir,
  $op("diam")(B)$ es una cota superior de $S(A)$. Como $op("diam")(A)$ es la _menor_ cota superior de
  $S(A)$ (Definición 2), concluimos $op("diam")(A) <= op("diam")(B)$. $qed$
]

#enunciado[Ejercicio 7 (b)][
  Sean $E$ un espacio métrico y $A subset.eq E$ un subconjunto acotado de $E$. Pruebe que
  $op("diam")(A) = op("diam")(overline(A))$.
]
#estrategia[Los puntos de $overline(A)$ se aproximan por puntos de $A$][
  La desigualdad $<=$ sale de (a), pues $A subset.eq overline(A)$. Para la otra, dados
  $x, y in overline(A)$ y $epsilon > 0$ se eligen $a, b in A$ muy cerca de $x$ e $y$, y la
  desigualdad triangular da $d(x, y) < op("diam")(A) + epsilon$. Como $epsilon$ es arbitrario,
  $d(x, y) <= op("diam")(A)$.
]
#resolucion[Propuesta: $op("diam")(A) = op("diam")(overline(A))$][
  Suponemos $A != nothing$ (igual que en (a)) y llamamos $D = op("diam")(A)$.

  *Paso clave: si $x, y in overline(A)$ entonces $d(x, y) <= D$.* Sea $epsilon > 0$. Como
  $x in overline(A)$, aplicando la Definición 4.22 con radio $epsilon\/3$ vale
  $B(x, epsilon\/3) inter A != nothing$: existe $a in A$ con $d(x, a) < epsilon\/3$. Análogamente
  existe $b in A$ con $d(y, b) < epsilon\/3$. Como $a, b in A$ y $D$ es cota superior de $S(A)$,
  $d(a, b) <= D$. Por la desigualdad triangular (Definición 4.1 (iv)) aplicada dos veces,
  $ d(x, y) <= d(x, a) + d(a, b) + d(b, y) < epsilon/3 + D + epsilon/3 < D + epsilon. $
  Si fuera $d(x, y) > D$, tomando $epsilon = d(x, y) - D > 0$ se obtendría
  $d(x, y) < D + epsilon = d(x, y)$, absurdo. Luego $d(x, y) <= D$.

  *$overline(A)$ es acotado y $op("diam")(overline(A)) <= D$.* Sea $C > 0$ la constante de $A$ (Definición 4.8)
  y $C' = op("máx")(C, D) > 0$. Por el paso clave, $d(x, y) <= D <= C'$ para todo $x, y in overline(A)$:
  $overline(A)$ es acotado. Además $overline(A) != nothing$ (contiene a $A$) y $D$ es cota superior de
  $S(overline(A))$ por el paso clave, así que, por ser el supremo la menor cota superior (Definición 2),
  $op("diam")(overline(A)) <= D$.

  *La otra desigualdad.* Por la Observación 4.23 (a), $A subset.eq overline(A)$, y ambos son acotados,
  así que (a) da $D = op("diam")(A) <= op("diam")(overline(A))$.

  Juntando las dos desigualdades, $op("diam")(A) = op("diam")(overline(A))$. $qed$
]

#observacion[Verificado en Lean: `Guias.Guia3.Ej07`][
  `diam A` es `sSup` del conjunto `distancias A` $= \{d(x, y) : x, y in A\}$ y `Acotado A` es la
  Definición 4.8 (no se usa `Metric.diam`). `diam_mono` certifica (a) y `diam_closure` certifica (b)
  (acotación de $overline(A)$ y la igualdad); el paso clave del texto es
  `dist_le_diam_of_mem_closure`, que usa `Metric.mem_closure_iff` (Definición 4.22) y `dist_triangle`
  con $epsilon\/3$ y `le_of_forall_pos_le_add` para el "si es menor que $D + epsilon$ para todo
  $epsilon$ entonces es $<= D$". Como en el texto, se pide $A != nothing$ (en Lean `sSup ∅ = 0`
  por convención, pero el curso no define el supremo del vacío).
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 8

#enunciado[Ejercicio 8][
  Halle frontera y puntos de acumulación de cada uno de los subconjuntos de $RR$ del Ejercicio 3:
  #set enum(numbering: "(a)")
  + $[0, 1]$
  + $(0, 1)$
  + $QQ$
  + $QQ inter [0, 1]$
  + $ZZ$
  + $[0, 1) union \{2\}$
  + $\{1/n : n in NN\}$
  + $\{1/n : n in NN\} union \{0\}$
]

#estrategia[Con interior y clausura del Ejercicio 3, la frontera sale por resta; el derivado, a mano][
  Un punto de frontera (Def. 4.38) es uno de adherencia que no es interior: $partial S = overline(S) backslash S^compose$
  (Sublema abajo), y interior y clausura de los ocho conjuntos están calculados en el Ejercicio 3. Para el
  conjunto derivado $S'$ (Def. 4.33) se usa $S' subset.eq overline(S)$ para acotar por arriba y, para cada
  punto de $overline(S)$, se decide si hay puntos de $S$ distintos de él arbitrariamente cerca:
  los Lemas 2 y 3 del Ejercicio 3 los producen en intervalos y racionales; en $ZZ$ y en $\{1\/n\}$ no los
  hay (los puntos están _aislados_), y el único acumulador de $\{1\/n\}$ es $0$ (Arquímedes).
]

#sublema(titulo: [Sublema (frontera, interior y clausura)])[
  Sea $S subset.eq RR$. Entonces $partial S = overline(S) backslash S^compose$.

  _Prueba._ Por la Def. 4.38, $x in partial S$ si y sólo si para todo $r > 0$ vale
  $B(x, r) inter S != emptyset$ y $B(x, r) inter S^c != emptyset$. La primera condición, para todo
  $r$, es $x in overline(S)$ (Def. 4.22). La segunda, para todo $r$, dice que ninguna bola centrada
  en $x$ está contenida en $S$; como $B(x, r) subset.eq S$ ya implica $x in S$ (pues $x in B(x, r)$),
  esto es exactamente $x in.not S^compose$ (Def. 4.11). (Este resultado también es el Ejercicio 9 (a);
  se lo prueba acá para que el Ejercicio 8 no dependa de uno posterior.)
]

#sublema(titulo: [Sublema (derivado y clausura)])[
  Sean $S subset.eq F subset.eq RR$. Entonces $S' subset.eq overline(S)$ y $S' subset.eq F'$.

  _Prueba._ Si $x in S'$ y $r > 0$, hay $y in B(x, r) inter S$ con $y != x$: en particular
  $B(x, r) inter S != emptyset$, o sea $x in overline(S)$ (también se ve en la Prop. 4.36). Además
  ese mismo $y$ está en $B(x, r) inter F$ y es distinto de $x$, así que $x in F'$.
]

#sublema(titulo: [Sublema (espaciado de los $1\/n$)])[
  Sean $n, m in NN$ con $m != n$. Entonces
  $ abs(1/m - 1/n) >= 1/(n(n+1)) = 1/n - 1/(n+1). $

  _Prueba._ La igualdad es $1\/n - 1\/(n+1) = ((n+1) - n)\/(n(n+1))$. Si $m >= n + 1$, entonces
  $1\/m <= 1\/(n+1) < 1\/n$ y
  $abs(1\/m - 1\/n) = 1\/n - 1\/m >= 1\/n - 1\/(n+1)$. Si $m <= n - 1$, entonces
  $ abs(1/m - 1/n) = 1/m - 1/n = (n - m)/(m n) >= 1/(m n) >= 1/(n(n+1)), $
  porque $n - m >= 1$ y $m n <= n^2 < n(n+1)$.
]

#resolucion[Propuesta (a): $[0, 1]' = [0, 1]$, $partial [0, 1] = \{0, 1\}$][
  Sea $S = [0, 1]$. *Derivado.* $S' subset.eq overline(S) = [0, 1]$ (Sublema y Ej. 3 (a)). Recíprocamente,
  si $x in [0, 1]$ y $r > 0$, el Lema 3 del Ej. 3 da $y in (0, 1) subset.eq S$ con $y != x$ e
  $y in B(x, r)$: $x in S'$. Luego $S' = [0, 1]$.

  *Frontera.* Por el Sublema y el Ej. 3 (a), $partial S = overline(S) backslash S^compose = [0, 1] backslash (0, 1) = \{0, 1\}$. $qed$
]

#resolucion[Propuesta (b): $(0, 1)' = [0, 1]$, $partial (0, 1) = \{0, 1\}$][
  Sea $S = (0, 1)$. *Derivado.* $S' subset.eq overline(S) = [0, 1]$ (Ej. 3 (b)). Recíprocamente, si
  $x in [0, 1]$ y $r > 0$, el Lema 3 del Ej. 3 da $y in (0, 1) = S$, $y != x$, $y in B(x, r)$. Luego $S' = [0, 1]$
  (en particular $0, 1 in S'$ aunque no están en $S$).

  *Frontera.* $partial S = overline(S) backslash S^compose = [0, 1] backslash (0, 1) = \{0, 1\}$ (Ej. 3 (b)). $qed$
]

#resolucion[Propuesta (c): $QQ' = RR$, $partial QQ = RR$][
  Sea $x in RR$ y $r > 0$. Por Densidad de $QQ$ (Proposición 2) existe $q in QQ$ con $x < q < x + r$; entonces
  $q in B(x, r) inter QQ$ y $q != x$, o sea $x in QQ'$. Luego $QQ' = RR$.

  *Frontera.* Por el Ej. 3 (c), $overline(QQ) = RR$ y $QQ^compose = emptyset$, así que
  $partial QQ = RR backslash emptyset = RR$. $qed$
]

#resolucion[Propuesta (d): $(QQ inter [0, 1])' = [0, 1]$, $partial (QQ inter [0, 1]) = [0, 1]$][
  Sea $S = QQ inter [0, 1]$. *Derivado.* $S' subset.eq overline(S) = [0, 1]$ (Ej. 3 (d)). Recíprocamente, si
  $x in [0, 1]$ y $r > 0$, el Lema 3 del Ej. 3 (versión racional) da $q in QQ inter (0, 1) subset.eq S$ con
  $q != x$ y $q in B(x, r)$. Luego $S' = [0, 1]$.

  *Frontera.* Por el Ej. 3 (d), $overline(S) = [0, 1]$ y $S^compose = emptyset$, luego $partial S = [0, 1]$. $qed$
]

#resolucion[Propuesta (e): $ZZ' = emptyset$, $partial ZZ = ZZ$][
  *Derivado.* Supongamos $x in ZZ'$. Por el Sublema, $x in overline(ZZ) = ZZ$ (Ej. 3 (e)), digamos $x = n$.
  Tomando $r = 1\/2$, existe $m in ZZ$, $m != n$, con $abs(m - n) < 1\/2$. Pero $m - n$ es un entero no nulo,
  así que $abs(m - n) >= 1$: absurdo. Por lo tanto $ZZ' = emptyset$ (ningún entero es de acumulación:
  todos son puntos _aislados_).

  *Frontera.* Por el Ej. 3 (e), $overline(ZZ) = ZZ$ y $ZZ^compose = emptyset$, luego $partial ZZ = ZZ$. $qed$
]

#resolucion[Propuesta (f): $([0, 1) union \{2\})' = [0, 1]$, $partial([0, 1) union \{2\}) = \{0, 1, 2\}$][
  Sea $S = [0, 1) union \{2\}$. *Derivado.* Por el Sublema y el Ej. 3 (f), $S' subset.eq overline(S) = [0, 1] union \{2\}$.
  El punto $2$ no es de acumulación: con $r = 1\/2$, los puntos de $B(2, 1\/2) = (3\/2, 5\/2)$ que están en $S$
  son sólo $2$ (los de $[0, 1)$ son menores que $1$), así que no hay $y in B(2, 1\/2) inter S$ con $y != 2$.
  Entonces $S' subset.eq [0, 1]$. Recíprocamente, si $x in [0, 1]$ y $r > 0$, el Lema 3 del Ej. 3 da
  $y in (0, 1) subset.eq S$, $y != x$, $y in B(x, r)$. Luego $S' = [0, 1]$. (El $2$ está en $S$ pero no
  en $S'$; y $1 in S'$ aunque $1 in.not S$.)

  *Frontera.* Por el Ej. 3 (f), $overline(S) = [0, 1] union \{2\}$ y $S^compose = (0, 1)$, así que
  $partial S = ([0, 1] union \{2\}) backslash (0, 1) = \{0, 1\} union \{2\} = \{0, 1, 2\}$. $qed$
]

#resolucion[Propuesta (g) y (h): $T' = U' = \{0\}$, $partial T = partial U = U$][
  Sean $T = \{1\/n : n in NN\}$ y $U = T union \{0\}$.

  *$U' subset.eq \{0\}$.* Sea $x in U'$. Por el Sublema y el Ej. 3 (h), $x in overline(U) = U$. Supongamos
  $x = 1\/n$ con $n in NN$ y sea $r = 1\/(n(n+1)) > 0$. Existe $y in B(x, r) inter U$ con $y != x$, o sea
  $abs(y - 1\/n) < r$. Hay dos posibilidades:
  - $y = 1\/m$ con $m in NN$: como $y != x$, $m != n$, y el Sublema del espaciado da
    $abs(y - 1\/n) >= 1\/(n(n+1)) = r$: contradicción.
  - $y = 0$: $abs(y - 1\/n) = 1\/n >= 1\/(n(n+1)) = r$ porque $n + 1 >= 1$: contradicción.

  Entonces $x in.not T$, y como $x in U = T union \{0\}$, resulta $x = 0$.

  *$0 in T'$.* Sea $r > 0$. Por Arquímedes (Proposición 1) hay $n in NN$ con $0 < 1\/n < r$. Entonces
  $1\/n in B(0, r) inter T$ y $1\/n != 0$. Luego $0 in T'$.

  *Conclusión del derivado.* Como $T subset.eq U$, el Sublema da $T' subset.eq U' subset.eq \{0\}$, y
  $0 in T'$: $T' = \{0\}$. También $\{0\} = T' subset.eq U'$, con lo cual $U' = \{0\}$.
  (Todos los $1\/n$ son puntos aislados, y $0$ es el único límite.)

  *Frontera.* Por el Ej. 3 (g), $overline(T) = U$ y $T^compose = emptyset$, luego $partial T = U backslash emptyset = U$.
  Por el Ej. 3 (h), $overline(U) = U$ y $U^compose = emptyset$, luego $partial U = U$. $qed$
]

#v(4pt)
#align(center)[
  #table(
    columns: (auto, auto, auto),
    align: (left, center, center),
    inset: 5pt,
    [*Conjunto $S$*], [*Puntos de acumulación $S'$*], [*Frontera $partial S$*],
    [$[0, 1]$], [$[0, 1]$], [$\{0, 1\}$],
    [$(0, 1)$], [$[0, 1]$], [$\{0, 1\}$],
    [$QQ$], [$RR$], [$RR$],
    [$QQ inter [0, 1]$], [$[0, 1]$], [$[0, 1]$],
    [$ZZ$], [$emptyset$], [$ZZ$],
    [$[0, 1) union \{2\}$], [$[0, 1]$], [$\{0, 1, 2\}$],
    [$\{1\/n : n in NN\}$], [$\{0\}$], [$\{1\/n : n in NN\} union \{0\}$],
    [$\{1\/n : n in NN\} union \{0\}$], [$\{0\}$], [$\{1\/n : n in NN\} union \{0\}$],
  )
]

#observacion[Verificado en Lean: `Guias.Guia3.Ej08`][
  `acumulacion`/`derivadoCurso` (Def. 4.33) y `fronteraCurso` (Def. 4.38) están definidos con bolas,
  y para cada conjunto `Ca`, ..., `Ch` hay un teorema `x_derivado` y uno `x_frontera` (los de (g) y (h)
  comparten `h_derivado_sub`, `zero_mem_derivado_Cg`, `Cg_sub_Ch`). El Sublema de la frontera es
  `fronteraCurso_eq`; los de derivado, `derivadoCurso_sub_clausura` y `derivadoCurso_mono`; el del
  espaciado, `aislado`. Igual que el texto, `Ej08.lean` toma del Ejercicio 3 (importa
  `Guias.Guia3.Ej03`) las definiciones por bolas, los Lemas 1--4 y los interiores y clausuras
  de los ocho conjuntos, en vez de volver a probarlos. `frontier_eq_fronteraCurso` conecta con
  `frontier` de Mathlib (`a_frontier_mathlib`, ..., `h_frontier_mathlib`); el conjunto derivado
  no se conecta con `derivedSet` de Mathlib (no hace falta para el ejercicio).
  Diferencias con el texto: en `aislado` la cota se prueba despejando denominadores
  (`div_le_div_iff₀` y `nlinarith`) en vez de comparar con $1\/n - 1\/(n+1)$, y `ℕ` empieza en $1$
  (se escribe `1 ≤ n`).
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 9

#enunciado[Ejercicio 9 (a)][
  Sea $E$ un espacio métrico y sea $A subset.eq E$. Pruebe que
  $partial A = overline(A) backslash A^compose$, y concluya que $partial A$ es cerrado.
]
#estrategia[Leer la frontera como dos clausuras][
  Las dos condiciones de la Definición 4.38 ("toda bola corta a $A$" y "toda bola corta a
  $E backslash A$") son exactamente pertenecer a $overline(A)$ y a $overline(E backslash A)$
  (Definición 4.22). Por el Ej. 5 (a), $overline(E backslash A) = E backslash A^compose$. La
  cerradura sale de que $partial A$ es intersección de dos cerrados.
]
#resolucion[Propuesta: $partial A = overline(A) backslash A^compose$ y $partial A$ es cerrado][
  *Paso 1: $partial A = overline(A) inter overline(E backslash A)$.* Por la Definición 4.38,
  $x in partial A$ si y sólo si para todo $r > 0$ se cumplen a la vez $B(x, r) inter A != nothing$ y
  $B(x, r) inter (E backslash A) != nothing$. Por la Definición 4.22, la primera condición (para todo
  $r > 0$) dice $x in overline(A)$ y la segunda dice $x in overline(E backslash A)$. Luego
  $ partial A = overline(A) inter overline(E backslash A). $

  *Paso 2: la igualdad.* Por el Ej. 5 (a), $overline(E backslash A) = E backslash A^compose$.
  Reemplazando en el Paso 1,
  $ partial A = overline(A) inter (E backslash A^compose) = overline(A) backslash A^compose. $

  *Paso 3: $partial A$ es cerrado.* Necesitamos dos hechos auxiliares.

  - _$A^compose$ es abierto._ Sea $x in A^compose$: existe $r > 0$ con $B(x, r) subset.eq A$. Si
    $y in B(x, r)$, sea $rho = r - d(x, y) > 0$. Por la desigualdad triangular,
    $B(y, rho) subset.eq B(x, r)$: si $d(y, z) < rho$ entonces $d(x, z) <= d(x, y) + d(y, z) < d(x, y) + rho = r$.
    Así $B(y, rho) subset.eq B(x, r) subset.eq A$ y $y in A^compose$. Luego $B(x, r) subset.eq A^compose$,
    es decir, todo punto de $A^compose$ es interior a $A^compose$: $A^compose$ es abierto
    (Definición 4.14).
  - _$overline(A)$ es cerrado._ Por el Ej. 5 (b), $E backslash overline(A) = (E backslash A)^compose$, que es
    abierto por lo anterior aplicado a $E backslash A$. Por el Teorema 4.29, $overline(A)$ es cerrado.

  Ahora $E backslash A^compose$ es cerrado por el Teorema 4.29 (su complemento $A^compose$ es abierto), y
  $partial A = overline(A) inter (E backslash A^compose)$ es intersección de dos cerrados, luego es
  cerrado por el Teorema 4.31 (a). $qed$
]

#enunciado[Ejercicio 9 (b)][
  Sea $E$ un espacio métrico y sea $A subset.eq E$. Pruebe que
  $partial A = overline(A) inter overline(E backslash A)$, y concluir que $partial A = partial(E backslash A)$.
]
#estrategia[Aplicar la fórmula a $A$ y a $E backslash A$][
  La primera igualdad es el Paso 1 de (a). Para la segunda, se aplica la misma fórmula al conjunto
  $E backslash A$, observando que $E backslash (E backslash A) = A$, y se usa que la intersección es
  conmutativa.
]
#resolucion[Propuesta: $partial A = overline(A) inter overline(E backslash A) = partial(E backslash A)$][
  La primera igualdad es exactamente el Paso 1 de (a), que sale directamente de las
  Definiciones 4.38 y 4.22. (Alternativamente: por (a) y el Ej. 5 (a),
  $partial A = overline(A) backslash A^compose = overline(A) inter (E backslash A^compose) = overline(A) inter overline(E backslash A)$.)

  Como la fórmula vale para _cualquier_ subconjunto de $E$, aplicada a $E backslash A$ da
  $ partial(E backslash A) = overline(E backslash A) inter overline(E backslash (E backslash A)) = overline(E backslash A) inter overline(A), $
  pues $E backslash (E backslash A) = A$. Por conmutatividad de $inter$, el lado derecho es
  $overline(A) inter overline(E backslash A) = partial A$. Luego $partial A = partial(E backslash A)$. $qed$
]

#observacion[Verificado en Lean: `Guias.Guia3.Ej09`][
  `fronteraCurso A` es la Definición 4.38 (por bolas); `interior` y `closure` son los de Mathlib, siempre
  manejados con `mem_interior_iff_ball` (Definición 4.11) y `mem_closure_iff_ball` (Definición 4.22),
  los lemas puente de `Guias/Common.lean`. `frontera_eq_inter` es el Paso 1; `compl_interior_eq` reprueba localmente
  el Ej. 5 (a), `compl_closure_eq` el Ej. 5 (b), `frontera_eq_sdiff` es la igualdad de (a),
  `frontera_isClosed` la cerradura, y `frontera_eq_inter_closure_compl` y `frontera_compl` son (b).
  El Paso 3 se sigue tal cual: `isOpen_interior_bolas` ($A^compose$ es abierto, con el radio
  $r - d(y, x)$) e `isClosed_closure_bolas` ($overline(A)$ es cerrado, vía el Ej. 5 (b) y
  `isOpen_compl_iff`, que es el Teorema 4.29); la intersección de dos cerrados es `IsClosed.inter`
  (Teorema 4.31 (a)). No se usan `isClosed_closure` ni `isOpen_interior` de Mathlib. "Cerrado" es
  `IsClosed`; `closure_frontera_eq` lo reescribe como $overline(partial A) = partial A$ (Def. 4.27).
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 10

#enunciado[Ejercicio 10][
  Sea $(E, d)$ un espacio métrico. Dados $A subset.eq E$ no vacío y $x in E$, se define la _distancia de $x$ a $A$_ como
  $ d(x, A) = op("ínf")\{d(x, a) : a in A\}. $
  Pruebe que para todos $x, y in E$ y $r > 0$ valen los cinco ítems siguientes.
]

#resolucion[Preliminares: $d(x, A)$ está bien definido][
  Sea $S_x = \{d(x, a) : a in A\}$. Es no vacío porque $A != nothing$, y está acotado inferiormente por $0$
  porque $d(x, a) >= 0$ (Definición 4.1 (i)). Por el Teorema 2 (completitud en términos de ínfimos) existe
  $d(x, A) = op("ínf")(S_x)$, y $d(x, A) >= 0$ porque $0$ es cota inferior y el ínfimo es la mayor de ellas.
  Usaremos dos propiedades de la Definición 5:
  - (cota inferior) $d(x, A) <= d(x, a)$ para todo $a in A$;
  - (la mayor) si $c <= d(x, a)$ para todo $a in A$, entonces $c <= d(x, A)$.
]

#enunciado[Ejercicio 10 (a)][
  $abs(d(x, A) - d(y, A)) <= d(x, y)$ para todo $x, y in E$.
]
#estrategia[El ínfimo se mueve a lo sumo $d(x, y)$][
  Para cada $a in A$, la desigualdad triangular da $d(x, A) <= d(x, a) <= d(x, y) + d(y, a)$. Restando
  $d(x, y)$, el número $d(x, A) - d(x, y)$ es cota inferior de $\{d(y, a) : a in A\}$, así que es
  $<= d(y, A)$. Se intercambian los roles de $x$ e $y$.
]
#resolucion[Propuesta: vale $abs(d(x, A) - d(y, A)) <= d(x, y)$][
  Sea $a in A$. Por ser $d(x, A)$ cota inferior de $S_x$ y por la desigualdad triangular (Definición 4.1 (iv)),
  $ d(x, A) <= d(x, a) <= d(x, y) + d(y, a), quad "es decir" quad d(x, A) - d(x, y) <= d(y, a). $
  Esto vale para todo $a in A$, así que $d(x, A) - d(x, y)$ es una cota inferior de $S_y$ y, como
  $d(y, A)$ es la mayor cota inferior, $d(x, A) - d(x, y) <= d(y, A)$. Es decir,
  $ d(x, A) - d(y, A) <= d(x, y). $
  Intercambiando $x$ e $y$ (y usando $d(y, x) = d(x, y)$, Definición 4.1 (iii)) se obtiene
  $d(y, A) - d(x, A) <= d(x, y)$. Ambas desigualdades dicen $abs(d(x, A) - d(y, A)) <= d(x, y)$. $qed$
]

#enunciado[Ejercicio 10 (b)][ Si $x in A$ entonces $d(x, A) = 0$. ]
#estrategia[El $0$ es cota inferior y pertenece al conjunto][
  Si $x in A$, entonces $d(x, x) = 0 in S_x$. Como $0$ es cota inferior de $S_x$, la Proposición 6 dice que
  es el ínfimo.
]
#resolucion[Propuesta: $x in A => d(x, A) = 0$][
  Sea $x in A$. Entonces $0 = d(x, x) in S_x$ (Definición 4.1 (ii)), y $0$ es cota inferior de $S_x$ porque
  las distancias son no negativas. Por la Proposición 6 (caracterización de ínfimo y mínimo),
  $d(x, A) = op("ínf")(S_x) = op("mín")(S_x) = 0$. $qed$
]

#enunciado[Ejercicio 10 (c)][ $d(x, A) = 0 <=> x in overline(A)$. ]
#estrategia[Ínfimo $0$ equivale a distancias arbitrariamente chicas][
  La Proposición 5 dice que $op("ínf")(S_x) = 0$ si y sólo si para todo $epsilon > 0$ hay un elemento de
  $S_x$ menor que $epsilon$, es decir, un $a in A$ con $d(x, a) < epsilon$: esto es exactamente
  $B(x, epsilon) inter A != nothing$ para todo $epsilon$ (Definición 4.22).
]
#resolucion[Propuesta: $d(x, A) = 0 <=> x in overline(A)$][
  *($arrow.r.double$)* Supongamos $d(x, A) = 0$ y sea $epsilon > 0$. Como $0 = op("ínf")(S_x)$, la Proposición 5
  (b) da $a in A$ con $d(x, a) < 0 + epsilon = epsilon$, o sea $a in B(x, epsilon) inter A$. Como $epsilon > 0$
  era arbitrario, $x in overline(A)$ por la Definición 4.22.

  *($arrow.l.double$)* Supongamos $x in overline(A)$ y sea $epsilon > 0$. Por la Definición 4.22,
  $B(x, epsilon) inter A != nothing$: hay $a in A$ con $d(x, a) < epsilon$. Entonces
  $0 <= d(x, A) <= d(x, a) < epsilon$. Si fuera $d(x, A) > 0$, tomando $epsilon = d(x, A)$ se tendría
  $d(x, A) < d(x, A)$, absurdo. Luego $d(x, A) = 0$. $qed$
]

#enunciado[Ejercicio 10 (d)][ $B_A (r) = \{x in E : d(x, A) < r\}$ es abierto. ]
#estrategia[Una bola alrededor de cada punto, con (a)][
  Si $d(x, A) < r$, sobra un margen $rho = r - d(x, A) > 0$. Por (a), mover $x$ menos de $rho$ mueve
  $d(dot.c, A)$ menos de $rho$, y no se llega a $r$.
]
#resolucion[Propuesta: $B_A (r)$ es abierto][
  Sea $x in B_A (r)$, o sea $d(x, A) < r$, y sea $rho = r - d(x, A) > 0$. Veamos que
  $B(x, rho) subset.eq B_A (r)$. Si $y in B(x, rho)$, por (a)
  $ d(y, A) <= d(x, A) + d(x, y) < d(x, A) + rho = r, $
  o sea $y in B_A (r)$. Entonces todo punto de $B_A (r)$ es interior (Definición 4.11), y
  $B_A (r) = (B_A (r))^compose$ es abierto (Definición 4.14). $qed$
]

#enunciado[Ejercicio 10 (e)][ $overline(B)_A (r) = \{x in E : d(x, A) <= r\}$ es cerrado. ]
#estrategia[El complemento es abierto, otra vez por (a)][
  Por el Teorema 4.29, basta ver que $\{x : d(x, A) > r\}$ es abierto. Si $d(x, A) > r$, el margen es
  $rho = d(x, A) - r$, y por (a) los puntos de $B(x, rho)$ siguen teniendo $d(dot.c, A) > r$.
]
#resolucion[Propuesta: $overline(B)_A (r)$ es cerrado][
  El complemento de $overline(B)_A (r)$ es $U = \{x in E : d(x, A) > r\}$. Sea $x in U$ y
  $rho = d(x, A) - r > 0$. Si $y in B(x, rho)$, por (a)
  $ d(y, A) >= d(x, A) - d(x, y) > d(x, A) - rho = r, $
  así que $y in U$ y $B(x, rho) subset.eq U$. Luego todo punto de $U$ es interior: $U$ es abierto
  (Definición 4.14). Por el Teorema 4.29, $overline(B)_A (r) = E backslash U$ es cerrado. $qed$
]

#observacion[Verificado en Lean: `Guias.Guia3.Ej10`][
  `distA x A` es `sInf` del conjunto `distancias x A` $= \{d(x, a) : a in A\}$ (no se usa
  `Metric.infDist`). `distA_le` y `le_distA` son las dos propiedades de la Definición 5 (cota
  inferior y la mayor de ellas), con las hipótesis de no vacío y acotado inferiormente de
  `csInf_le`/`le_csInf` (preliminares). Ítems: (a) `abs_distA_sub_le` (vía `distA_le_add`, el
  argumento del texto), (b) `distA_eq_zero_of_mem`, (c) `distA_eq_zero_iff` (con
  `Metric.mem_closure_iff`), (d) `isOpen_bolaA` y (e) `isClosed_bolaCerradaA`, ambos con
  `Metric.isOpen_iff` y el radio $rho$ del texto. Desvío: (d) y (e) se prueban para todo `r : ℝ`
  (no sólo $r > 0$), que es más general: ni el texto ni Lean usan la hipótesis $r > 0$.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 11

#enunciado[Ejercicio 11][
  Sea $(E, d)$ un espacio métrico y $cal(X) = \{A subset.eq E : A != nothing\}$. Se define
  $hat(d) : cal(X) times cal(X) -> RR$ como
  $ hat(d)(A, B) = op("ínf")\{d(a, b) : a in A, b in B\}. $
  Determine si las afirmaciones (a)-(d) de abajo son verdaderas o falsas para $A, B, C in cal(X)$, y concluya que $hat(d)$ no es una distancia.
]

#resolucion[Preliminares: $hat(d)$ está bien definida][
  Sea $S(A, B) = \{d(a, b) : a in A, b in B\}$. Es no vacío (porque $A, B != nothing$) y está acotado
  inferiormente por $0$ (Definición 4.1 (i)), así que por el Teorema 2 existe
  $hat(d)(A, B) = op("ínf") S(A, B) >= 0$. Por la Definición 5: (cota inferior)
  $hat(d)(A, B) <= d(a, b)$ para todo $a in A$, $b in B$; (la mayor) si $c <= d(a, b)$ para todo
  $a in A$, $b in B$, entonces $c <= hat(d)(A, B)$. Además:

  #sublema(titulo: [Criterio para $hat(d)(A, B) = 0$])[
    Si para todo $epsilon > 0$ existen $a in A$, $b in B$ con $d(a, b) < epsilon$, entonces
    $hat(d)(A, B) = 0$. En efecto, $0 <= hat(d)(A, B) <= d(a, b) < epsilon$ para todo $epsilon > 0$; si
    fuera $hat(d)(A, B) > 0$, con $epsilon = hat(d)(A, B)$ se tendría $hat(d)(A, B) < hat(d)(A, B)$, absurdo.
  ]
]

#enunciado[Ejercicio 11 (a)][ $hat(d)(A, B) = hat(d)(overline(A), B)$. ]
#estrategia[Los puntos de $overline(A)$ se aproximan por puntos de $A$][
  $A subset.eq overline(A)$ da una desigualdad (ínfimo sobre más pares es menor). Para la otra,
  un punto $x in overline(A)$ está tan cerca como se quiera de algún $a in A$, y la desigualdad
  triangular muestra que $hat(d)(A, B)$ no supera a $d(x, b)$.
]
#resolucion[Propuesta: VERDADERA][
  Notamos que $overline(A) != nothing$ (contiene a $A$), así que $hat(d)(overline(A), B)$ está definida.

  *($hat(d)(overline(A), B) <= hat(d)(A, B)$)* Sea $a in A$, $b in B$. Por la Observación 4.23 (a),
  $a in overline(A)$, así que $hat(d)(overline(A), B) <= d(a, b)$ (cota inferior de $S(overline(A), B)$).
  Entonces $hat(d)(overline(A), B)$ es cota inferior de $S(A, B)$ y, por ser $hat(d)(A, B)$ la mayor,
  $hat(d)(overline(A), B) <= hat(d)(A, B)$.

  *($hat(d)(A, B) <= hat(d)(overline(A), B)$)* Sean $x in overline(A)$, $b in B$ y $epsilon > 0$. Por la
  Definición 4.22 existe $a in A$ con $d(x, a) < epsilon$. Entonces
  $ hat(d)(A, B) <= d(a, b) <= d(a, x) + d(x, b) < epsilon + d(x, b). $
  Como $epsilon > 0$ es arbitrario, $hat(d)(A, B) <= d(x, b)$ (si fuera $hat(d)(A, B) > d(x, b)$, tomar
  $epsilon = hat(d)(A, B) - d(x, b)$ da un absurdo). Esto vale para todo $x in overline(A)$ y $b in B$: luego
  $hat(d)(A, B)$ es cota inferior de $S(overline(A), B)$ y $hat(d)(A, B) <= hat(d)(overline(A), B)$. $qed$
]

#enunciado[Ejercicio 11 (b)][ $hat(d)(A, B) = 0 <=> A inter B != nothing$. ]
#estrategia[Una implicación vale, la otra no][
  Si $A$ y $B$ comparten un punto, la distancia entre ese punto y sí mismo es $0$. Pero distancia cero
  sólo pide puntos _arbitrariamente cercanos_: los intervalos abiertos $(0, 1)$ y $(1, 2)$ de $RR$
  no comparten puntos y se acercan a $1$ por ambos lados.
]
#resolucion[Propuesta: FALSA ($arrow.l.double$ vale, $arrow.r.double$ no)][
  *($arrow.l.double$) vale en todo espacio métrico.* Si $x in A inter B$, entonces
  $0 <= hat(d)(A, B) <= d(x, x) = 0$ (Definición 4.1 (ii)), luego $hat(d)(A, B) = 0$.

  *($arrow.r.double$) falla.* Sea $E = RR$, $A = (0, 1)$ y $B = (1, 2)$ (no vacíos).
  - $A inter B = nothing$: un $x$ en ambos cumpliría $x < 1$ y $x > 1$.
  - $hat(d)(A, B) = 0$: sea $epsilon > 0$ y $t = op("mín")(epsilon\/4, 1\/2)$, de modo que
    $0 < t <= 1\/2$ y $t <= epsilon\/4$. Entonces $1 - t in (0, 1) = A$ y $1 + t in (1, 2) = B$, y
    $d(1 - t, 1 + t) = abs((1 - t) - (1 + t)) = 2t <= epsilon\/2 < epsilon$. Por el criterio de los
    preliminares, $hat(d)(A, B) = 0$.

  Entonces $hat(d)(A, B) = 0$ pero $A inter B = nothing$: la afirmación (b) es falsa. $qed$
]

#enunciado[Ejercicio 11 (c)][ $hat(d)(A, B) = 0 <=> overline(A) inter overline(B) != nothing$. ]
#estrategia[Cerrados disjuntos pueden estar a distancia cero][
  Si $x in overline(A) inter overline(B)$, hay puntos de $A$ y de $B$ a menos de $epsilon\/2$ de $x$,
  luego a menos de $epsilon$ entre sí. La recíproca falla si los conjuntos "se alejan hacia el
  infinito" acercándose cada vez más: $A = \{n : n >= 2\}$ y $B = \{n + 1\/n : n >= 2\}$ son cerrados,
  disjuntos, y $d(n, n + 1\/n) = 1\/n -> 0$.
]
#resolucion[Propuesta: FALSA ($arrow.l.double$ vale, $arrow.r.double$ no)][
  *($arrow.l.double$) vale en todo espacio métrico.* Sea $x in overline(A) inter overline(B)$ y
  $epsilon > 0$. Por la Definición 4.22 existen $a in A$ con $d(x, a) < epsilon\/2$ y $b in B$ con
  $d(x, b) < epsilon\/2$. Entonces $d(a, b) <= d(a, x) + d(x, b) < epsilon$, y el criterio de los
  preliminares da $hat(d)(A, B) = 0$.

  *($arrow.r.double$) falla.* Sea $E = RR$, con
  $ A = \{n : n in NN, n >= 2\}, quad B = \{n + 1/n : n in NN, n >= 2\}. $

  #sublema(titulo: [Conjuntos separados son cerrados])[
    Si $S subset.eq RR$ cumple que $d(s, s') >= 1\/2$ para todo $s != s'$ en $S$, entonces $overline(S) = S$.
    En efecto, sea $x in overline(S)$ y supongamos $x in.not S$. Hay $s in S$ con $d(x, s) < 1\/4$ (Definición 4.22),
    y $x != s$. Sea $epsilon = op("mín")(d(x, s), 1\/4) > 0$ y $s' in S$ con $d(x, s') < epsilon$. Entonces
    $d(s, s') <= d(s, x) + d(x, s') < 1\/4 + 1\/4 = 1\/2$, luego $s' = s$ por la hipótesis; pero
    $d(x, s') < epsilon <= d(x, s)$ contradice $s' = s$. Como $S subset.eq overline(S)$ (Observación 4.23 (a)),
    $overline(S) = S$.
  ]

  - _$A$ y $B$ son cerrados._ Para $A$: si $m < n$ son naturales, $abs(n - m) >= 1 >= 1\/2$. Para $B$:
    si $2 <= m < n$, entonces $n - m >= 1$ y $0 < 1\/n$, $1\/m <= 1\/2$, luego
    $ (n + 1/n) - (m + 1/m) = (n - m) + 1/n - 1/m > 1 - 1/2 = 1/2. $
    Por el sublema, $overline(A) = A$ y $overline(B) = B$.
  - _$A inter B = nothing$._ Si $n = m + 1\/m$ con $n, m in NN$, $m >= 2$, entonces $n - m = 1\/m in (0, 1\/2]$.
    Pero $n - m$ es entero: si $n <= m$ es $<= 0$, y si $n >= m + 1$ es $>= 1$. Absurdo.
    Luego $overline(A) inter overline(B) = A inter B = nothing$.
  - _$hat(d)(A, B) = 0$._ Sea $epsilon > 0$. Por el Principio de Arquímedes 2 (Proposición 1) existe
    $N in NN$ con $0 < 1\/N < epsilon$; sea $n = op("máx")(N, 2)$. Entonces $n in A$, $n + 1\/n in B$ y
    $d(n, n + 1\/n) = 1\/n <= 1\/N < epsilon$. Por el criterio de los preliminares, $hat(d)(A, B) = 0$.

  Entonces $hat(d)(A, B) = 0$ pero $overline(A) inter overline(B) = nothing$: (c) es falsa. $qed$
]

#enunciado[Ejercicio 11 (d)][ $hat(d)(A, B) <= hat(d)(A, C) + hat(d)(C, B)$. ]
#estrategia[Un $C$ que toque a ambos][
  Si $C$ contiene un punto de $A$ y uno de $B$, los dos sumandos del lado derecho son $0$, mientras
  que $A$ y $B$ pueden estar lejos.
]
#resolucion[Propuesta: FALSA][
  Sea $E = RR$, $A = \{0\}$, $B = \{2\}$ y $C = \{0, 2\}$.
  - $S(A, B) = \{d(0, 2)\} = \{2\}$, y un conjunto de un solo elemento tiene ínfimo igual a ese
    elemento (Proposición 6): $hat(d)(A, B) = 2$.
  - $0 in A inter C$, así que por (b) ($arrow.l.double$) $hat(d)(A, C) = 0$.
  - $2 in C inter B$, así que por (b) ($arrow.l.double$) $hat(d)(C, B) = 0$.

  La desigualdad pedida diría $2 <= 0 + 0$, que es falsa. $qed$
]

#enunciado[Ejercicio 11 (conclusión)][ Concluya que $hat(d)$ no es una distancia. ]
#resolucion[Propuesta: $hat(d)$ no es una distancia en $cal(X)$][
  Una distancia en $cal(X)$ (Definición 4.1) debe cumplir: (i) $hat(d) >= 0$, (ii) $hat(d)(A, B) = 0 <=> A = B$,
  (iii) simetría y (iv) desigualdad triangular. Para $E = RR$:
  - (iv) falla por (d): $hat(d)(A, B) = 2 > 0 = hat(d)(A, C) + hat(d)(C, B)$ con $A = \{0\}$, $B = \{2\}$, $C = \{0, 2\}$.
  - (ii) falla por (b): $A = (0, 1)$ y $B = (1, 2)$ cumplen $A != B$ pero $hat(d)(A, B) = 0$.

  (Las propiedades (i) y (iii) sí valen: $hat(d) >= 0$ por los preliminares, y $S(A, B) = S(B, A)$ por la simetría de $d$.)
  Entonces $hat(d)$ no es una distancia. Basta con que _una_ de las dos propiedades falle. $qed$
]

#observacion[Verificado en Lean: `Guias.Guia3.Ej11`][
  `dhat A B` es `sInf` del conjunto `distancias A B`. Las partes ciertas y las mitades ciertas se
  prueban para un espacio métrico `E` arbitrario: (a) `dhat_closure_left`, (b $arrow.l.double$)
  `dhat_eq_zero_of_inter`, (c $arrow.l.double$) `dhat_eq_zero_of_closure_inter` (ambas vía el criterio
  `dhat_eq_zero_of_approx`). Los contraejemplos son en `ℝ`: `ej11b_conjuntos` y `ej11b_contraejemplo` para
  (b); para (c), `closure_subset_of_sep` (el sublema), `A11_sep`, `B11_sep`, `A11_closure`, `B11_closure`,
  `A11_inter_B11`, `A11_B11_dhat` y `ej11c_contraejemplo`; para (d), `ej11d_valores` y
  `ej11d_contraejemplo`. Las refutaciones están formalizadas como `¬ (∀ A B, ... → ...)`. La
  conclusión es `no_es_metrica : ¬ EsMetrica dhatX` (con `EsMetrica` de `Guias.Common`, la Definición 4.1,
  sobre $cal(X) =$ subconjuntos no vacíos de `ℝ`), con `no_separa` y `no_triangular`, y
  `no_es_metrica_general`, la misma conclusión para cualquier `E` con al menos dos puntos
  (`[Nontrivial E]`): la separación falla con $A = \{p\}$, $C = \{p, q\}$, $p != q$, por (b)
  ($arrow.l.double$). Esa hipótesis es necesaria: si `E` tiene un solo punto, $cal(X)$ tiene un solo
  elemento y $hat(d)$ sí es una métrica. El criterio de los preliminares ("si para todo $epsilon$ hay
  pares a distancia $< epsilon$ entonces $hat(d) = 0$") es `dhat_eq_zero_of_approx`.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 12

#enunciado[Ejercicio 12][
  Considere en $RR^n$ las distancias $d_1$, $d_2$ y $d_oo$.
  #set enum(numbering: "(a)")
  + Pruebe que estas tres distancias son equivalentes; más aún, pruebe que
    $ d_oo (x, y) <= d_2(x, y) <= d_1(x, y) <= n d_oo (x, y). $
  + Denotemos por $B_1(x, r)$, $B_2(x, r)$ y $B_oo (x, r)$ a la bola de centro $x$ y radio $r$ para cada una de las distancias, respectivamente. Deduzca de (a) que
    $ B_1(x, r) subset.eq B_2(x, r) subset.eq B_oo (x, r) subset.eq B_1(x, n r). $
    Compare estas contenciones con los dibujos hechos en el Ejercicio 1.
]

#sublema(titulo: "Definición adoptada: métricas equivalentes")[
  `apuntes.typ` no define "métricas equivalentes"; en esta resolución se adopta la definición de
  clase. Dos métricas $d, d'$ en un conjunto $E$ son *equivalentes* si definen los mismos abiertos,
  y eso se chequea con bolas: para todo $x in E$ y todo $r > 0$,
  $ exists s > 0 : B_(d')(x, s) subset.eq B_d (x, r) quad "y" quad exists s' > 0 : B_d (x, s') subset.eq B_(d')(x, r), $
  es decir, toda bola de una contiene una bola de la otra con el mismo centro.

  *Equivalen a "mismos abiertos".* Por la Definición 4.14, $A$ es abierto si $A = A^compose$, es decir
  (Definición 4.11) si todo $x in A$ tiene un $r > 0$ con $B(x, r) subset.eq A$. Si $A$ es abierto
  para $d$ y $x in A$, hay $r$ con $B_d (x, r) subset.eq A$ y entonces hay $s$ con
  $B_(d')(x, s) subset.eq B_d (x, r) subset.eq A$: $A$ es abierto para $d'$. La recíproca es simétrica
  (se usa la otra inclusión).

  *Criterio uniforme.* Si existe $C > 0$ con $d <= d' <= C d$, entonces $d$ y $d'$ son equivalentes:
  dados $x$ y $r > 0$, $B_(d')(x, r) subset.eq B_d (x, r)$ porque $d(x, y) <= d'(x, y) < r$; y
  $B_d (x, r/C) subset.eq B_(d')(x, r)$ porque $d'(x, y) <= C d(x, y) < C (r/C) = r$.
]

#estrategia[Comparar término a término, y encadenar][
  Cada desigualdad sale de una observación elemental: un sumando de una suma de términos $>= 0$ no
  supera la suma; cada término es a lo sumo el máximo; y $(sum abs(a_i))^2 >= sum a_i^2$ porque
  $abs(a_i) <= sum_j abs(a_j)$. De la cadena sale la equivalencia con el criterio uniforme, y las
  inclusiones de bolas de (b) son la misma cadena escrita con "$< r$".
]

#resolucion[Propuesta (a): $d_oo <= d_2 <= d_1 <= n d_oo$, y las tres distancias son equivalentes][
  Fijemos $x, y in RR^n$ y escribamos $a_i = x_i - y_i$. Las tres desigualdades:

  + *$d_oo <= d_2$.* Para cada $i$, $abs(a_i)^2 = a_i^2 <= sum_j a_j^2$ (un sumando de una suma de
    términos $>= 0$). Como la raíz cuadrada es creciente, $abs(a_i) = sqrt(a_i^2) <= sqrt(sum_j a_j^2) = d_2(x, y)$.
    Esto vale para todo $i$, así que también vale para el máximo: $d_oo (x, y) <= d_2(x, y)$.

  + *$d_2 <= d_1$.* Para cada $i$, $abs(a_i) <= sum_j abs(a_j) = d_1(x, y)$ (un sumando de una suma de
    términos $>= 0$). Entonces
    $ sum_i a_i^2 = sum_i abs(a_i) abs(a_i) <= sum_i d_1(x, y) abs(a_i) = d_1(x, y) sum_i abs(a_i) = d_1(x, y)^2. $
    Tomando raíz cuadrada (creciente, y $d_1 >= 0$): $d_2(x, y) <= d_1(x, y)$.

  + *$d_1 <= n d_oo$.* Cada uno de los $n$ sumandos cumple $abs(a_i) <= d_oo (x, y)$, así que
    $d_1(x, y) = sum_(i=1)^n abs(a_i) <= n d_oo (x, y)$.

  *Equivalencia.* Encadenando, para cada par de distancias hay una desigualdad "$d <= d' <= C d$" con
  $C = n$ (en las tres se usa $n >= 1$, y $C > 0$):
  - $d_oo <= d_2 <= n d_oo$, pues $d_2 <= d_1 <= n d_oo$.
  - $d_2 <= d_1 <= n d_2$, pues $d_1 <= n d_oo <= n d_2$ (por $d_oo <= d_2$).
  - $d_oo <= d_1 <= n d_oo$, pues $d_oo <= d_2 <= d_1$.

  Por el criterio uniforme, $d_oo$, $d_2$ y $d_1$ son equivalentes de a pares: definen los mismos
  abiertos en $RR^n$. $qed$
]

#resolucion[Propuesta (b): $B_1(x, r) subset.eq B_2(x, r) subset.eq B_oo (x, r) subset.eq B_1(x, n r)$][
  Sea $r > 0$ y $x in RR^n$.
  - Si $y in B_1(x, r)$: $d_2(x, y) <= d_1(x, y) < r$, luego $y in B_2(x, r)$.
  - Si $y in B_2(x, r)$: $d_oo (x, y) <= d_2(x, y) < r$, luego $y in B_oo (x, r)$.
  - Si $y in B_oo (x, r)$: $d_1(x, y) <= n d_oo (x, y) < n r$ (se usa $n > 0$), luego $y in B_1(x, n r)$.

  *Comparación con el Ejercicio 1.* En $RR^2$ y centro $0$ con $r = 1$ son las tres figuras que se
  dibujaron: el rombo abierto $B_1(0, 1)$ (Ej. 1 (c)) está dentro del disco abierto $B_2(0, 1)$
  (Ej. 1 (b)), que a su vez está dentro del cuadrado abierto $B_oo (0, 1)$ (Ej. 1 (d)): el rombo
  tiene los vértices $(plus.minus 1, 0), (0, plus.minus 1)$ sobre la circunferencia y sobre los
  lados del cuadrado, y el disco toca el cuadrado en los mismos cuatro puntos. Además el cuadrado
  entra en el rombo agrandado $B_1(0, 2)$, de vértices $(plus.minus 2, 0), (0, plus.minus 2)$: los
  vértices $(plus.minus 1, plus.minus 1)$ del cuadrado (que no pertenecen a la bola abierta) caen
  justo sobre sus lados, $abs(1) + abs(1) = 2$.

  #block(breakable: false, width: 100%)[#align(center)[
    #cetz.canvas({
      import cetz.draw: *
      let k = 1.4
      line((-3.0, 0), (3.1, 0), mark: (end: ">"), stroke: 0.5pt + luma(110))
      line((0, -3.0), (0, 3.1), mark: (end: ">"), stroke: 0.5pt + luma(110))
      line((2 * k, 0), (0, 2 * k), (-2 * k, 0), (0, -2 * k), close: true, fill: rgb("#fef3c7"),
        stroke: (paint: rgb("#d97706"), thickness: 1pt, dash: "dashed"))
      rect((-k, -k), (k, k), fill: rgb("#dcfce7"),
        stroke: (paint: rgb("#15803d"), thickness: 1pt, dash: "dashed"))
      circle((0, 0), radius: k, fill: rgb("#bfdbfe"),
        stroke: (paint: rgb("#2563eb"), thickness: 1pt, dash: "dashed"))
      line((k, 0), (0, k), (-k, 0), (0, -k), close: true, fill: rgb("#fbcfe8"),
        stroke: (paint: rgb("#be185d"), thickness: 1pt, dash: "dashed"))
      circle((0, 0), radius: 0.05, fill: black)
      content((4.6, 1.5), anchor: "west", text(size: 9pt, fill: rgb("#d97706"))[$B_1(0, 2)$ (amarillo)])
      content((4.6, 0.5), anchor: "west", text(size: 9pt, fill: rgb("#15803d"))[$B_oo (0, 1)$ (verde)])
      content((4.6, -0.5), anchor: "west", text(size: 9pt, fill: rgb("#2563eb"))[$B_2(0, 1)$ (azul)])
      content((4.6, -1.5), anchor: "west", text(size: 9pt, fill: rgb("#be185d"))[$B_1(0, 1)$ (rosa)])
    })
  ]]
]

#observacion[Verificado en Lean: `Guias.Guia3.Ej12`][
  `d1`, `d2`, `dinf` son las tres distancias sobre `Fin n → ℝ` (con `[NeZero n]`, $n >= 1$, como en
  el Ej. 1 (d); $d_oo$ es `Finset.sup'`). Las desigualdades de (a) son `dinf_le_d2`, `d2_le_d1`
  (con la misma cuenta $sum a_i^2 <= d_1 sum abs(a_i)$) y `d1_le_n_dinf`, resumidas en `cadena`.
  `Equivalentes` formaliza la definición de clase (cada bola de una contiene una bola concéntrica
  de la otra); `abiertos_iff` prueba que entonces los abiertos coinciden (con `EsAbierto`: cada
  punto tiene una bola adentro), `equivalentes_of_le` es el criterio uniforme, y
  `equivalentes_dinf_d2`, `equivalentes_d2_d1`, `equivalentes_dinf_d1` son las tres equivalencias de
  (a). Las inclusiones de (b) son `bola_inclusiones` (con `bola` de `Common.lean`, para todo $r$).
  La formalización no se aparta del texto.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 13

#enunciado[Ejercicio 13 (a)][
  Sea $(E, d)$ un espacio métrico y sean $(x_n)_(n in NN)$, $(y_n)_(n in NN)$ sucesiones en $E$.
  Si $lim_(n -> oo) x_n = x$ y $lim_(n -> oo) y_n = y$, pruebe que
  $lim_(n -> oo) d(x_n, y_n) = d(x, y)$.
]
#estrategia[Una desigualdad triangular en cada sentido y el truco de $epsilon/2$][
  Acotamos $abs(d(x_n, y_n) - d(x, y))$ por $d(x_n, x) + d(y_n, y)$ usando dos veces la desigualdad
  triangular. Cada sumando se hace menor que $epsilon/2$ para $n$ grande, porque $x_n -> x$ e
  $y_n -> y$ (Definición 4.42).
]
#resolucion[Propuesta: vale, por la cota $abs(d(x_n, y_n) - d(x, y)) <= d(x_n, x) + d(y_n, y)$][
  *Cota clave.* Para cualesquiera $a, b, a', b' in E$ vale
  $ abs(d(a, b) - d(a', b')) <= d(a, a') + d(b, b'). $
  En efecto, por la desigualdad triangular (Definición 4.1 (iv)) y la simetría,
  $ d(a, b) <= d(a, a') + d(a', b') + d(b', b) quad ==> quad d(a, b) - d(a', b') <= d(a, a') + d(b, b'), $
  y, intercambiando los roles de $(a, b)$ y $(a', b')$,
  $ d(a', b') <= d(a', a) + d(a, b) + d(b, b') quad ==> quad d(a', b') - d(a, b) <= d(a, a') + d(b, b'). $
  Ambas cotas juntas dan la desigualdad con valor absoluto.

  *Convergencia.* Sea $epsilon > 0$. Como $x_n -> x$, existe $n_1$ tal que $d(x_n, x) < epsilon/2$
  para todo $n >= n_1$; como $y_n -> y$, existe $n_2$ tal que $d(y_n, y) < epsilon/2$ para todo
  $n >= n_2$. Sea $n_0 = max{n_1, n_2}$. Para $n >= n_0$, aplicando la cota clave con
  $(a, b, a', b') = (x_n, y_n, x, y)$:
  $ abs(d(x_n, y_n) - d(x, y)) <= d(x_n, x) + d(y_n, y) < epsilon/2 + epsilon/2 = epsilon. $
  Esto es la definición de convergencia en $RR$ (Definición 4.42 con $M = RR$), es decir,
  $d(x_n, y_n) -> d(x, y)$. $qed$
]

#enunciado[Ejercicio 13 (b)][
  Si $(x_n)_(n in NN)$, $(y_n)_(n in NN)$ son dos sucesiones de Cauchy en $E$, pruebe que la
  sucesión de números reales $(d(x_n, y_n))_(n in NN)$ es convergente.
]
#estrategia[Probar que es de Cauchy en $RR$ y usar que $RR$ es completo][
  La misma cota clave del ítem (a) muestra que $abs(d(x_n, y_n) - d(x_m, y_m))$ es chico cuando
  $n, m$ son grandes. Una sucesión de Cauchy de reales converge por el Teorema 4.57.
]
#resolucion[Propuesta: converge, porque $(d(x_n, y_n))$ es de Cauchy en $RR$][
  Sea $epsilon > 0$. Por ser $(x_n)$ de Cauchy (Definición 4.51) existe $n_1$ tal que
  $d(x_n, x_m) < epsilon/2$ para todo $n, m >= n_1$; por ser $(y_n)$ de Cauchy existe $n_2$ tal que
  $d(y_n, y_m) < epsilon/2$ para todo $n, m >= n_2$. Sea $n_0 = max{n_1, n_2}$ y sean $n, m >= n_0$.
  Por la cota clave del ítem (a), con $(a, b, a', b') = (x_n, y_n, x_m, y_m)$,
  $ abs(d(x_n, y_n) - d(x_m, y_m)) <= d(x_n, x_m) + d(y_n, y_m) < epsilon/2 + epsilon/2 = epsilon. $
  Luego $(d(x_n, y_n))_(n in NN)$ es una sucesión de Cauchy en $(RR, abs(dot))$. Como $RR$ es
  completo (Teorema 4.57), tiene límite: la sucesión $(d(x_n, y_n))_(n in NN)$ converge. $qed$
]

#observacion[Verificado en Lean: `Guias.Guia3.Ej13`][
  `abs_dist_sub_dist_le` es la cota clave. `ej13a` certifica (a) y `ej13b` certifica (b). Las
  hipótesis y conclusiones se enuncian con `Filter.Tendsto` y `CauchySeq` de Mathlib, pero las
  pruebas pasan a $epsilon$-$N$ con `Metric.tendsto_atTop` y `Metric.cauchySeq_iff` (que son las
  Definiciones 4.42 y 4.51) y repiten el argumento de $epsilon/2$ de arriba. No se usa
  `Filter.Tendsto.dist`. El último paso de `ej13b` es `cauchySeq_tendsto_of_complete` aplicado
  a la sucesión de *reales* $d(x_n, y_n)$, es decir, la completitud de $RR$ (Teorema 4.57).
  Las sucesiones empiezan en $0$ en Lean y en $1$ en el curso; no cambia nada del argumento.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 14

#enunciado[Ejercicio 14][
  Pruebe que $(RR^n, d_1)$, $(RR^n, d_2)$ y $(RR^n, d_infinity)$ son completos.
]
#estrategia[Completitud de $d_infinity$ por coordenadas, y las otras dos por equivalencia][
  Para $d_infinity$ seguimos el Corolario 4.58: una sucesión de Cauchy lo es coordenada a
  coordenada, cada coordenada converge por la completitud de $RR$ y el máximo de las diferencias se
  controla tomando el mayor de los $n$ índices. Para $d_1$ y $d_2$ usamos las desigualdades
  $d_infinity <= d <= n d_infinity$ del Ej. 12 (a): con ellas, Cauchy y convergencia significan lo
  mismo que para $d_infinity$.
]
#resolucion[Propuesta: los tres son completos][
  Trabajamos con $n >= 1$ y con
  $d_1(x, y) = sum_(i=1)^n abs(x_i - y_i)$, $d_2(x, y) = sqrt(sum_(i=1)^n (x_i - y_i)^2)$ y
  $d_infinity (x, y) = max_(1 <= i <= n) abs(x_i - y_i)$. Una sucesión es $(v_k)_(k in NN) subset.eq RR^n$ con
  $v_k = (x_1^k, dots, x_n^k)$.

  *Caso $d_infinity$ (Corolario 4.58).* Sea $(v_k)$ de Cauchy para $d_infinity$ (Definición 4.51).

  + *Cada coordenada es de Cauchy en $RR$.* Fijado $i$ y $epsilon > 0$, existe $k_0$ tal que
    $d_infinity (v_k, v_j) < epsilon$ para $k, j >= k_0$. Como
    $abs(x_i^k - x_i^j) <= max_(1 <= l <= n) abs(x_l^k - x_l^j) = d_infinity (v_k, v_j)$,
    se tiene $abs(x_i^k - x_i^j) < epsilon$ para $k, j >= k_0$: la sucesión $(x_i^k)_(k in NN)$ es de
    Cauchy en $RR$.
  + *Cada coordenada converge.* Por el Teorema 4.57, para cada $i$ existe $x_i in RR$ con
    $x_i^k -> x_i$. Sea $v = (x_1, dots, x_n)$.
  + *$v_k -> v$ para $d_infinity$.* Sea $epsilon > 0$. Para cada $i$ existe $k_i$ tal que
    $abs(x_i^k - x_i) < epsilon/2$ si $k >= k_i$. Sea $k_0 = max{k_1, dots, k_n}$ (máximo de un
    conjunto finito). Para $k >= k_0$ vale $abs(x_i^k - x_i) < epsilon/2$ para todo $i$ a la vez, de
    modo que
    $ d_infinity (v_k, v) = max_(1 <= i <= n) abs(x_i^k - x_i) <= epsilon/2 < epsilon. $
    (Usamos $epsilon/2$ en lugar de $epsilon$ sólo para no discutir si el máximo es estricto.)
  Luego toda sucesión de Cauchy de $(RR^n, d_infinity)$ converge: es completo (Definición 4.55).

  *Casos $d_1$ y $d_2$.* Sea $d in {d_1, d_2}$. Por el Ej. 12 (a),
  $ d_infinity (x, y) <= d(x, y) <= n d_infinity (x, y) quad "para todo " x, y in RR^n. $
  Sea $(v_k)$ de Cauchy para $d$.

  + *Es de Cauchy para $d_infinity$.* Dado $epsilon > 0$ hay $k_0$ con $d(v_k, v_j) < epsilon$ si
    $k, j >= k_0$. Como $d_infinity (v_k, v_j) <= d(v_k, v_j) < epsilon$, la sucesión es $d_infinity$-Cauchy.
  + *Converge para $d_infinity$.* Por el caso anterior existe $v in RR^n$ con
    $d_infinity (v_k, v) -> 0$ (Observación 4.43).
  + *Converge para $d$.* Dado $epsilon > 0$, existe $k_0$ tal que $d_infinity (v_k, v) < epsilon/n$ si
    $k >= k_0$. Entonces
    $ d(v_k, v) <= n d_infinity (v_k, v) < n dot epsilon/n = epsilon quad "para " k >= k_0. $
  Así, $(RR^n, d)$ es completo. Esto prueba el enunciado para $d_1$ y para $d_2$. $qed$
]

#observacion[Verificado en Lean: `Guias.Guia3.Ej14`][
  `ej14` afirma `EsCompleto d1 ∧ EsCompleto d2 ∧ EsCompleto dinf`. Las distancias son las
  funciones explícitas `d1`, `d2`, `dinf` del Ej. 12 (`Ej14.lean` importa `Guias.Guia3.Ej12`, así
  que son los mismos objetos de los Ej. 1 (d) y 12; `[NeZero n]`, es decir $n >= 1$) y `EsCompleto`
  es la Definición 4.55 escrita con $epsilon$-$N$; no hay instancias de `MetricSpace` y no se usa
  que Mathlib ya tenga `CompleteSpace` para `EuclideanSpace`/`PiLp`. `completo_dinf` sigue el
  Corolario 4.58 (usando `cauchySeq_tendsto_of_complete` sobre las coordenadas, que es el
  Teorema 4.57, y `choose` para fijar los límites `l i`). Las desigualdades
  $d_infinity <= d_2 <= d_1 <= n d_infinity$ son las del Ej. 12 (a) (`Ej12.dinf_le_d2`,
  `Ej12.d2_le_d1`, `Ej12.d1_le_n_dinf`), citadas igual que en el texto. `completo_of_equiv` es
  el argumento de los casos $d_1$ y $d_2$; `completo_d1` y `completo_d2` lo aplican. La sucesión
  empieza en $0$ en Lean y en $1$ en el curso.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 15

#enunciado[Ejercicio 15][
  Sea $(E, d)$ un espacio métrico completo y $A subset.eq E$ un subconjunto de $E$. Pruebe que si
  $A$ es cerrado entonces el espacio métrico $(A, d)$ es completo.
]
#estrategia[Una Cauchy en $A$ es Cauchy en $E$; converge en $E$ y el límite cae en $A$][
  Tomamos una sucesión de Cauchy en $A$ y la miramos en $E$, donde converge por completitud. Como
  $A$ es cerrado, el límite pertenece a $A$ (Corolario 4.47), de modo que la sucesión converge
  también dentro de $A$.
]
#resolucion[Propuesta: $(A, d)$ es completo][
  Aquí $(A, d)$ denota $A$ con la métrica restringida $d|_(A times A)$: para $a, b in A$ la
  distancia es la misma $d(a, b)$ que en $E$. Para probar que es completo (Definición 4.55) hay que
  ver que toda sucesión de Cauchy en $A$ tiene límite en $A$.

  Sea $(a_n)_(n in NN) subset.eq A$ una sucesión de Cauchy en $(A, d)$.

  + *Es de Cauchy en $E$.* Dado $epsilon > 0$ existe $n_0$ tal que $d(a_n, a_m) < epsilon$ para
    $n, m >= n_0$. Como la distancia en $A$ es la de $E$, esa misma desigualdad dice que
    $(a_n)$ es de Cauchy en $(E, d)$ (Definición 4.51).
  + *Converge en $E$.* Como $E$ es completo, existe $l in E$ con $a_n -> l$ en $E$.
  + *El límite está en $A$.* Tenemos $(a_n)_(n in NN) subset.eq A$ y $a_n -> l$. Como $A$ es
    cerrado, el Corolario 4.47 da $l in A$.
  + *Converge en $A$.* Como $l in A$, la distancia $d(a_n, l)$ se puede medir dentro de $A$ y es el
    mismo número que en $E$. Dado $epsilon > 0$, el paso 2 da $n_0$ con $d(a_n, l) < epsilon$ para
    $n >= n_0$, que es la convergencia $a_n -> l$ en $(A, d)$ (Definición 4.42).

  Toda sucesión de Cauchy de $(A, d)$ converge a un punto de $A$: $(A, d)$ es completo. $qed$
]

#observacion[Verificado en Lean: `Guias.Guia3.Ej15`][
  `ej15` enuncia `CompleteSpace A` para el subtipo `↥A` con la métrica de Mathlib, que es
  exactamente la restringida (`Subtype.dist_eq`: $d(a, b)$ en $A$ es $d(a, b)$ en $E$). La prueba
  sigue los cuatro pasos de arriba: reduce `CompleteSpace` a "toda Cauchy converge"
  (`Metric.complete_of_cauchySeq_tendsto`), usa `cauchySeq_tendsto_of_complete` en $E$ (hipótesis
  de completitud), `IsClosed.mem_of_tendsto` para el Corolario 4.47 y `Metric.tendsto_atTop`
  más `Subtype.dist_eq` para la convergencia dentro de $A$.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 16

#enunciado[Ejercicio 16 (teorema de la intersección de Cantor)][
  Sea $E$ un espacio métrico completo. Sea $(A_n)_(n in NN)$ una sucesión de subconjuntos
  cerrados, acotados y no vacíos de $E$ tales que
  - $A_(n+1) subset.eq A_n$ para todo $n >= 1$.
  - $lim_(n -> oo) op("diam")(A_n) = 0$.

  Pruebe que existe un único elemento $x in inter_(n in NN) A_n$.
]
#estrategia[Elegir un punto en cada $A_n$, ver que es de Cauchy y que el límite está en todos][
  Los $A_n$ se achican en diámetro, así que cualquier elección $x_n in A_n$ es de Cauchy. Por
  completitud converge a un $x$, y como cada $A_n$ es cerrado y contiene a la cola de la sucesión,
  $x$ está en todos. La unicidad sale de que dos puntos de la intersección están a distancia
  menor o igual que $op("diam")(A_n)$ para todo $n$.
]
#resolucion[Propuesta: existe un único $x in inter_(n in NN) A_n$][
  *Preliminar.* Como $A_(n+1) subset.eq A_n$ para todo $n$, por inducción $A_m subset.eq A_n$
  siempre que $n <= m$. Como cada $A_n$ es acotado, $op("diam")(A_n)$ está definido (Definición 4.9)
  y vale $d(a, b) <= op("diam")(A_n)$ para todo $a, b in A_n$, por ser el diámetro el supremo de
  esas distancias.

  *Existencia.*
  + *Elección.* Cada $A_n$ es no vacío: elegimos $x_n in A_n$ para cada $n in NN$.
  + *$(x_n)$ es de Cauchy.* Sea $epsilon > 0$. Como $op("diam")(A_n) -> 0$ y los diámetros son
    no negativos, existe $n_0$ con $op("diam")(A_(n_0)) < epsilon$. Sean $n, m >= n_0$. Por el
    preliminar, $x_n, x_m in A_(n_0)$, luego
    $ d(x_n, x_m) <= op("diam")(A_(n_0)) < epsilon. $
    Esto es la Definición 4.51.
  + *Converge.* Como $E$ es completo (Definición 4.55), existe $x in E$ con $x_n -> x$.
  + *$x in A_k$ para todo $k$.* Fijemos $k in NN$. Los términos $x_m$ con $m >= k$ pertenecen a
    $A_m subset.eq A_k$. Entonces $(x_m)_(m >= k) subset.eq A_k$ es una sucesión en $A_k$ que
    converge a $x$ (una cola de una sucesión convergente converge al mismo límite). Como $A_k$ es
    cerrado, el Corolario 4.47 da $x in A_k$. Por lo tanto $x in inter_(n in NN) A_n$.

  *Unicidad.* Sean $y, z in inter_(n in NN) A_n$. Para todo $n$, $y, z in A_n$, así que
  $ 0 <= d(y, z) <= op("diam")(A_n). $
  Como $op("diam")(A_n) -> 0$, pasando al límite en $n$ queda $d(y, z) <= 0$, es decir,
  $d(y, z) = 0$ y entonces $y = z$ por la Definición 4.1 (ii). $qed$
]

#observacion[Verificado en Lean: `Guias.Guia3.Ej16`][
  `ej16` concluye `∃! x, x ∈ ⋂ n, A n`. Las hipótesis son `IsClosed (A n)`,
  `Bornology.IsBounded (A n)`, `(A n).Nonempty`, `A (n+1) ⊆ A n` y
  `Tendsto (fun n => Metric.diam (A n)) atTop (nhds 0)`, con `[CompleteSpace E]`. La cota
  $d(a, b) <= op("diam")(A_n)$ es `Metric.dist_le_diam_of_mem` (que usa que $A_n$ es acotado; en
  Mathlib `Metric.diam` coincide con el supremo de la Definición 4.9 en conjuntos acotados). El
  lema auxiliar `sub_of_le` es el preliminar $A_m subset.eq A_n$. Los pasos de la prueba son los
  mismos: `choose` para la elección, `Metric.cauchySeq_iff`, `cauchySeq_tendsto_of_complete`
  (hipótesis de completitud de $E$), `IsClosed.mem_of_tendsto` para el Corolario 4.47 y
  `ge_of_tendsto'` para pasar al límite en la unicidad. La sucesión empieza en $0$ en Lean y en $1$
  en el curso.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)
