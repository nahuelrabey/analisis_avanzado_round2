#import "@preview/frame-it:2.0.0": *
#import "utils.typ": *

#let (definicion, teorema, proposicion, lema, corolario, ejemplo, axioma, demostracion) = frames(
  definicion: ("Definición", blue),
  teorema: ("Teorema", purple),
  proposicion: ("Proposición", rgb("#8b5cf6")),
  lema: ("Lema", teal),
  corolario: ("Corolario", orange),
  ejemplo: ("Ejemplo", green),
  axioma: ("Axioma", red),
  demostracion: ("Demostración", gray),
)

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
