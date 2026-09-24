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



// --- Desafíos de la Práctica 2 ---

#align(center)[
  #text(14pt, weight: "bold")[Desafíos --- Práctica 2] \
  #v(2pt)
  #text(10pt)[Cardinalidad]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

Los desafíos están agrupados por *dependencia*, no por orden de transcripción: cada bloque
supone resueltos los de arriba. La última columna dice a qué ejercicios de `guias/p2.typ`
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

    [1], [Cardinalidad], [Ej. 1, 2],
  )
]

#v(10pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Bloque 1 · Cardinalidad

#sublema(titulo: "Qué desbloquea")[
  Alimenta la *Práctica 2* (cardinalidad y conjuntos numerables / contables). En particular, combina biyecciones conocidas ($NN tilde.op ZZ$ y $NN tilde.op QQ^+$) para deducir la numerabilidad de $QQ$.
]

#desafio[Ejercicio 3.4 ($NN tilde.op QQ$)][
  Usar los ítems b) y c) del Ejemplo 3.3 para probar que $NN tilde.op QQ$.
]

#desafio[Ejercicio 3.9][
  Probar que $\#A <= \#B$ si y solo si existe una función sobreyectiva $g : B -> A$.
]

#desafio[Principio del Palomar (Pigeonhole Principle)][
  Si se distribuyen más de $k$ objetos en $k$ cajas, entonces alguna caja contiene al menos dos objetos.

  En forma equivalente: si $f : A -> B$ es una función entre conjuntos finitos y $\#A > \#B$, entonces $f$ no puede ser inyectiva. Por lo tanto existen $x, y in A$ con $x != y$ tales que $f(x) = f(y)$.
]
#solucion[
  *Demostración formal (por contradicción usando cardinalidad de conjuntos):*

  Sean $A$ y $B$ conjuntos finitos con $\#A > \#B$. Sea $\#B = k in NN_0$ y denotemos $B = {b_1, b_2, dots, b_k}$.

  Para cada $y in B$, consideremos su fibra o preimagen bajo $f$:
  $ A_y = f^(-1)({y}) = {x in A : f(x) = y} $

  Notemos que la familia $(A_y)_(y in B)$ constituye una partición del conjunto $A$:
  + Son conjuntos disjuntos dos a dos: si $y, y' in B$ con $y != y'$, entonces:
    $ A_y inter A_(y') = f^(-1)({y}) inter f^(-1)({y'}) = f^(-1)({y} inter {y'}) = f^(-1)(emptyset) = emptyset $
  + Su unión cubre la totalidad de $A$: para cualquier $x in A$, $f(x) in B$, luego $x in A_(f(x))$, de modo que:
    $ A = union.big_(y in B) A_y = union.big_(i=1)^k f^(-1)({b_i}) $

  Por la propiedad aditiva del cardinal para uniones finitas de conjuntos disjuntos dos a dos, la cantidad total de elementos de $A$ es:
  $ \#A = sum_(y in B) \#(f^(-1)({y})) = sum_(i=1)^k \#(f^(-1)({b_i})) $

  Supongamos por contradicción que $f$ es inyectiva.
  Por definición de inyectividad, dados $x_1, x_2 in A$, si $f(x_1) = f(x_2) = y$, necesariamente $x_1 = x_2$. En consecuencia, cada fibra $f^(-1)({y})$ puede contener a lo sumo un único elemento:
  $ \#(f^(-1)({y})) <= 1 quad forall y in B $

  Reemplazando en la suma del cardinal de $A$:
  $ \#A = sum_(i=1)^k \#(f^(-1)({b_i})) <= sum_(i=1)^k 1 = k = \#B $

  De esto se deduce que $\#A <= \#B$, lo cual entra en directa contradicción con la hipótesis de que $\#A > \#B$ (o $\#A > k$).

  Por lo tanto, la suposición inicial es falsa y concluimos que $f$ no puede ser inyectiva. Esto implica que existe al menos un elemento $y in B$ tal que $\#(f^(-1)({y})) >= 2$, es decir, existen $x, y' in A$ con $x != y'$ tales que $f(x) = f(y')$.
]

#desafio[No unicidad del desarrollo decimal en la no numerabilidad de $(0, 1)$ (Observación 3.22)][
  En la demostración de que el intervalo $(0, 1)$ no es numerable (Teorema 3.19), utilizamos el desarrollo decimal de los números reales para construir un $y in (0, 1)$ y probar que $y != x_n$ para todo $n in NN$.

  Sin embargo, el desarrollo decimal de un número real no siempre es único: por ejemplo,
  $ 0,1 = 0,0999999 dots $
  (y en general, cualquier número con desarrollo decimal finito admite una representación alternativa terminada en una cola infinita de nueves).

  *Desafío:* Explicar y justificar formalmente por qué esta falta de unicidad en los desarrollos decimales no invalida la demostración de la diagonalización de Cantor (es decir, por qué la elección de los dígitos $y_i in {2, 3}$ garantiza que $y != x_n$ para todo $n in NN$ a pesar de la no unicidad).
]
