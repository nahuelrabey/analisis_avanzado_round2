#import "@preview/frame-it:2.0.0": *
#import "utils.typ": *

#let (definicion, teorema, proposicion, lema, corolario, ejemplo, axioma, demostracion) = frames(
  definicion: ("Definición", rgb("#2563eb")),
  teorema: ("Teorema", rgb("#7c3aed")),
  proposicion: ("Proposición", rgb("#4f46e5")),
  lema: ("Lema", rgb("#0d9488")),
  corolario: ("Corolario", rgb("#d97706")),
  ejemplo: ("Ejemplo", rgb("#059669")),
  axioma: ("Axioma", rgb("#dc2626")),
  demostracion: ("Demostración", rgb("#475569")),
)

#show figure.where(kind: "frame"): set figure(numbering: none)

#show grid.cell: it => {
  if it.fill != none {
    set text(fill: white, weight: "bold")
    it
  } else {
    it
  }
}

#show: frame-style(styles.boxy)

// --- Apuntes Matemáticos ---

#definicion[Conjunto Acotado][1][
  Un conjunto $A subset.eq RR$ ($A != nothing$) se dice *acotado superiormente* si existe un $c in RR$ tal que $a <= c$ para todo $a in A$. Al número $c$ se le denomina *cota superior* de $A$.
]

#definicion[Supremo][2][
  Sea $A subset.eq RR$ un conjunto acotado superiormente y no vacío. Un número $s in RR$ se dice *supremo* de $A$ si:

  #set enum(numbering: "a)")
  + $s$ es una cota superior de $A$ ($x <= s, forall x in A$).
  + Si $t$ es cualquier otra cota superior de $A => s <= t$.

  Es decir, el supremo es la *menor de las cotas superiores*. La notación que vamos a usar para el supremo del conjunto $A$ es $op("sup")(A)$.
]

#axioma[Completitud][
  Todo subconjunto no vacío y acotado superiormente de $RR$ tiene supremo en $RR$.
]

#teorema[Principio de Arquímedes][1][
  Si $x in RR$ entonces existe un número $n in NN$ tal que $x <= n$. Es decir, dado un número real cualquiera, siempre existe un número natural más grande.
]

#demostracion[
  Sea $x in RR$. Supongamos que no existe un número natural más grande que $x$, es decir, que todos los números naturales $n <= x$. Esto nos dice que $NN$ está acotado superiormente (por $x$). Por el axioma de completitud, como $NN$ es un conjunto no vacío, sabemos que debe tener supremo. Sea $s = op("sup")(NN)$. Como $s$ es supremo, si tomamos $t = s - 1 < s$, sabemos que $t$ no puede ser cota superior de $NN$ (si lo fuera, $s$ no sería la menor de las cotas superiores). Esto nos dice que debe existir un número natural más grande que $s - 1$, es decir que tenemos que existe un número $n in NN$ tal que $s - 1 < n <= s$. Pero entonces, sumando $1$ en esta inecuación tenemos que $s < n + 1$, con $n + 1 in NN$. Esto es absurdo.
]

#proposicion[Principio de Arquímedes 2][1][
  Si $y in RR$, $y > 0$ entonces existe un $n in NN$ tal que $0 < 1/n < y$.
]

#demostracion[
  Como $y > 0$, sabemos que existe $y^(-1) in RR$. Por el Principio de Arquímedes, tenemos que existe $n in NN$ tal que $n > y^(-1)$. Pero esta desigualdad es equivalente a $1/n < y$, y además, $1/n > 0$. Esto es lo que queríamos probar.
]

#proposicion[Densidad de $QQ$][2][
  Sean $x, y in RR$, con $x < y$. Entonces existe $q in QQ$ tal que $x < q < y$.
]

#demostracion[
  Como $x < y$, tenemos que $y - x > 0$. Por la Proposición 1, sabemos que existe $n in NN$ tal que $y - x > 1/n > 0$. Multiplicando la desigualdad por $n$ (que es positivo), tenemos

  $ n(y - x) > 1 => n y - n x > 1. $

  Pero entonces tiene que existir un número entero $m$ entre $n y$ y $n x$ (¿por qué? Probarlo como ejercicio). Volviendo a dividir por $n$ nos queda

  $ n x < m < n y => x < m/n < y. $

  Tomando $q = m/n$ tenemos lo que queríamos probar.
]

#proposicion[Equivalencia de supremo][3][
  Sea $A subset.eq RR$, $A != nothing$ y acotado superiormente. Entonces $s = op("sup")(A)$ si y sólo si se cumple:

  #set enum(numbering: "a)")
  + $s$ es cota superior, y
  + para todo $epsilon > 0$, existe un elemento $a_epsilon in A$ tal que $s - epsilon < a_epsilon <= s$.

  Un esquema geométrico sería el siguiente, donde entendemos que $epsilon$ es lo que nos corremos hacia la izquierda del supremo:

  #align(center)[
    #box(width: 70%, [
      #align(center)[$ overbrace(#h(60pt), epsilon) $]
      #v(-6pt)
      #line(length: 100%, stroke: 0.8pt)
      #v(-12pt)
      #grid(
        columns: (1fr, 1fr, 1fr),
        align: center,
        [$s - epsilon$],
        [$bullet \ a_epsilon$],
        [$s$]
      )
    ])
  ]
]

#demostracion[
  Vamos a probar la doble implicación.

  - *($=>$)* Supongamos que $s = op("sup")(A)$. Entonces $s$ es una cota superior de $A$ por definición de supremo. Veamos que cumple la condición b) de la Proposición: sea $epsilon > 0$. Queremos probar que existe $a_epsilon in A$ tal que $s - epsilon < a_epsilon$.

    _(La estrategia sale por contradicción: ¿qué pasa si no existe $a_epsilon$?)_

    Si no existe tal elemento, se debe cumplir que
    $ a <= s - epsilon "para todo elemento" a in A => s - epsilon "es cota superior de" A. $
    Pero $s - epsilon$ sería entonces una cota superior de $A$ más chica que $s$ que es el supremo de $A$. Esto es un absurdo.

  - *(<=)* Supongamos ahora que $s$ es un elemento de $RR$ que cumple las dos condiciones de la Proposición y veamos que $s$ debe ser el supremo de $A$. Es decir, veamos que $s$ cumple la Definición 2. Sabemos que $s$ es cota superior, veamos que es la menor de las cotas superiores. Sea $t < s$. Entonces $s - t = epsilon > 0$.

    _(La estrategia es que podemos construir $t < s$ para cualquier $epsilon > 0$, y como existe $a_epsilon in A$, podemos ver que $t < a_epsilon$ siempre, por lo que $t$ no puede ser cota superior.)_

    Por b), sabemos que debe existir $a_epsilon in A$ tal que $s - epsilon < a_epsilon$. Reemplazando,
    $ s - epsilon = s - (s - t) = t < a_epsilon. $
    Esto nos dice que $t$ no puede ser cota superior de $A$. Es decir, que *toda cota superior de $A$ debe ser mayor o igual a $s$*, que es lo que queríamos probar.
]

#definicion[Máximo][3][
  Si $op("sup")(A) in A$, entonces $op("sup")(A)$ se denomina *máximo* de $A$. En ese caso, notamos $op("máx")(A)$ en lugar de $op("sup")(A)$.
]

#proposicion[Caracterización de Supremo y Máximo][4][
  Sea $A subset.eq RR$ un conjunto acotado superiormente y no vacío. Si $t$ es una cota superior y $t in A$ entonces $t = op("sup")(A)$ (y también es el máximo).
]

#demostracion[
  Por el Axioma de Completitud sabemos que existe $s = op("sup")(A)$. Queremos probar que $s = t$.

  _(Estrategia: como $t$ es cota superior y $s = op("sup")(A)$, por definición de supremo se tiene $t >= s$. Por otro lado, como $t in A$ y $s$ es cota superior, se tiene $t <= s$. Al cumplirse $t >= s$ y $t <= s$, se concluye $t = s$.)_

  Como $t$ es cota superior de $A$ y $s = op("sup")(A)$, se debe cumplir que $t >= s$. Por otro lado, como $t in A$ tenemos que $t <= s$, dado que, en particular, $s$ es cota superior de $A$. Podemos concluir entonces que $t = s$.
]

#definicion[Conjunto Acotado Inferiormente][4][
  Sea $A subset.eq RR$ un conjunto no vacío. Decimos que $A$ es *acotado inferiormente* si existe $c in RR$ tal que $c <= a$ para todo $a in A$. En este caso, decimos que $c$ es una *cota inferior* de $A$.
]

#definicion[Ínfimo][5][
  Sea $A subset.eq RR$ no vacío y acotado inferiormente. Un número $i in RR$ es el *ínfimo* de $A$ si:

  #set enum(numbering: "a)")
  + $i$ es una cota inferior de $A$;
  + si $t$ es una cota inferior de $A => t <= i$ (es la mayor de las cotas inferiores).

  La notación que usamos para el ínfimo de $A$ es $op("ínf")(A)$.
]

#teorema[Completitud en términos de ínfimos][2][
  Sea $A subset.eq RR$ acotado inferiormente y no vacío. Entonces existe $i = op("ínf")(A) in RR$.
]

#demostracion[
  Sea $A subset.eq RR$ acotado inferiormente y no vacío y consideremos el conjunto
  $ -A = {-a : a in A}. $

  Afirmamos que $-A$ es acotado superiormente: sea $c$ una cota inferior de $A$. Tenemos que $c <= a$ para todo $a in A$ y multiplicando por $-1$ nos queda $-c >= -a$ para todo $a in A$. Pero esto es lo mismo que decir que $-c$ es una cota superior de $-A$. Por axioma de completitud, sabemos que existe $s = op("sup")(-A)$. Veamos que $-s = op("ínf")(A)$:

  - $-s <= a <=> s >= -a$ para todo $a in A$ y esto se cumple.
  - Sea $c$ cota inferior de $A$. Como vimos antes, $-c$ es cota superior de $-A$ y por lo tanto $-c >= s => c <= -s$.
]

#proposicion[Equivalencia de Ínfimo][5][
  Sea $A subset.eq RR$, $A != nothing$ y acotado inferiormente. Entonces $i = op("ínf")(A)$ si y sólo si se cumple:

  #set enum(numbering: "a)")
  + $i$ es cota inferior de $A$, y
  + para todo $epsilon > 0$, existe un elemento $a_epsilon in A$ tal que $a_epsilon < i + epsilon$.
]

#definicion[Mínimo][6][
  Si $op("ínf")(A) in A$, entonces $op("ínf")(A)$ se denomina *mínimo* de $A$. En ese caso, notamos $op("mín")(A)$ en lugar de $op("ínf")(A)$.
]

#proposicion[Caracterización de Ínfimo y Mínimo][6][
  Sea $A subset.eq RR$ un conjunto acotado inferiormente y no vacío. Si $t$ es una cota inferior y $t in A$ entonces $t = op("ínf")(A) = op("mín")(A)$.
]

#definicion[Sucesiones][6][
  Una *sucesión* es una función $a : NN -> RR$, es decir, una asignación que a cada número natural le asigna un único número real. La notación usual es $a_n = a(n) in RR$ para el elemento que $a$ le asigna a $n$ y para referirnos a la sucesión entera, usamos $a = (a_n)_(n in NN)$.
]

#definicion[Convergencia de Sucesiones][7][
  Sea $(a_n)_(n in NN)$ una sucesión y $ell in RR$. Decimos que $(a_n)_(n in NN)$ converge a $ell$ si para todo $epsilon > 0$ existe $n_0 in NN$ tal que si $n >= n_0$, $|a_n - ell| < epsilon$. Notamos $lim_(n -> oo) a_n = ell$ o $a_n -> ell$.

  #v(4pt)
  #align(center)[
    #cetz.canvas({
      import cetz.draw: *
      
      // Línea real principal
      line((0, 0), (7, 0), stroke: 1.2pt)
      
      // Marcas (ticks)
      line((2, -0.25), (2, 0.25), stroke: 1pt)
      line((3.5, -0.25), (3.5, 0.25), stroke: 1pt)
      line((5, -0.25), (5, 0.25), stroke: 1pt)
      
      // Etiquetas inferiores
      content((2, -0.65), [$ell - epsilon$])
      content((3.5, -0.65), [$ell$])
      content((5, -0.65), [$ell + epsilon$])
      
      // Punto azul a_n
      circle((4.1, 0), radius: 0.09, fill: rgb("#2563eb"), stroke: rgb("#2563eb"))
      
      // Flecha curva y término a_n
      content((4.0, 1.05), [$a_n$])
      bezier((4.1, 0.25), (5.8, 0.85), (5.0, 1.05), mark: (start: ">", fill: black))
    })
  ]
]

#definicion[Divergencia de Sucesiones][8][
  Decimos que una sucesión $(a_n)_(n in NN)$ *diverge a $+oo$* si para todo $M > 0$ existe $n_0 in NN$ tal que para todo $n >= n_0$ se tiene $a_n > M$. Notamos $lim_(n -> oo) a_n = +oo$ o $a_n -> +oo$.

  Similarmente, decimos que $(a_n)_(n in NN)$ *diverge a $-oo$* si para todo $M > 0$ existe $n_0 in NN$ tal que para todo $n >= n_0$ se tiene $a_n < -M$. Notamos $lim_(n -> oo) a_n = -oo$ o $a_n -> -oo$.

  Decimos que $(a_n)_(n in NN)$ *diverge* si no converge o diverge a $plus.minus oo$.
]

#proposicion[Unicidad del límite][5][
  Sea $(a_n)_(n in NN)$ una sucesión de términos reales. Supongamos que $a_n -> ell_1$ y $a_n -> ell_2$ al mismo tiempo, con $ell_1, ell_2 in RR$. Entonces $ell_1 = ell_2$.

  Es decir, el límite de una sucesión es único.
]

#demostracion[
  Sabemos que dado $epsilon > 0$ existe $n_1 in NN$ tal que $|a_n - ell_1| < epsilon/2$ para todo $n >= n_1$ y a la vez existe $n_2 in NN$ tal que $|a_n - ell_2| < epsilon/2$ para todo $n >= n_2$. Entonces si elegimos $a_n$ con $n >= n_1$ y $n >= n_2$:

  $ |ell_1 - ell_2| = |ell_1 - a_n + a_n - ell_2| <= |ell_1 - a_n| + |a_n - ell_2| < epsilon/2 + epsilon/2 = epsilon. $

  Como $epsilon$ es arbitrario, por ejercicio de la guía 1, sabemos que $ell_1 = ell_2$.
]

