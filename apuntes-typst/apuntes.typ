#import "@preview/frame-it:1.0.0": *
#import "utils.typ": *

#let (definicion, teorema, lema, corolario, ejemplo, axioma, demostracion) = frames(
  definicion: ("Definición", blue),
  teorema: ("Teorema", purple),
  lema: ("Lema", teal),
  corolario: ("Corolario", orange),
  ejemplo: ("Ejemplo", green),
  axioma: ("Axioma", red),
  demostracion: ("Demostración", gray),
)

#show: frame-style(styles.boxy)

// --- Apuntes Matemáticos ---

#definicion[Conjunto Acotado][1][
  Un conjunto $A \subseteq \mathbb{R}$ ($A \neq \emptyset$) se dice *acotado superiormente* si existe un $c \in \mathbb{R}$ tal que $a \le c$ para todo $a \in A$. Al número $c$ se le denomina *cota superior* de $A$.
]

#definicion[Supremo][2][
  Sea $A \subseteq \mathbb{R}$ un conjunto acotado superiormente y no vacío. Un número $s \in \mathbb{R}$ se dice *supremo* de $A$ si:

  #set enum(numbering: "a)")
  + $s$ es una cota superior de $A$ ($x \le s, \forall x \in A$).
  + Si $t$ es cualquier otra cota superior de $A \implies s \le t$.

  Es decir, el supremo es la *menor de las cotas superiores*. La notación que vamos a usar para el supremo del conjunto $A$ es $\operatorname{sup}(A)$.
]

#axioma[Completitud][
  Todo subconjunto no vacío y acotado superiormente de $\mathbb{R}$ tiene supremo en $\mathbb{R}$.
]

#teorema[Principio de Arquímedes][1][
  Si $x \in \mathbb{R}$ entonces existe un número $n \in \mathbb{N}$ tal que $x \le n$. Es decir, dado un número real cualquiera, siempre existe un número natural más grande.
]

#demostracion[
  Sea $x \in \mathbb{R}$. Supongamos que no existe un número natural más grande que $x$, es decir, que todos los números naturales $n \le x$. Esto nos dice que $\mathbb{N}$ está acotado superiormente (por $x$). Por el axioma de completitud, como $\mathbb{N}$ es un conjunto no vacío, sabemos que debe tener supremo. Sea $s = \operatorname{sup}(\mathbb{N})$. Como $s$ es supremo, si tomamos $t = s - 1 < s$, sabemos que $t$ no puede ser cota superior de $\mathbb{N}$ (si lo fuera, $s$ no sería la menor de las cotas superiores). Esto nos dice que debe existir un número natural más grande que $s - 1$, es decir que tenemos que existe un número $n \in \mathbb{N}$ tal que $s - 1 < n \le s$. Pero entonces, sumando $1$ en esta inecuación tenemos que $s < n + 1$, con $n + 1 \in \mathbb{N}$. Esto es absurdo.
]
