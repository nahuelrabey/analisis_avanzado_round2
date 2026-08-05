#import "@preview/frame-it:1.0.0": *
#import "utils.typ": *

#let (ejemplo, solucion) = frames(
  ejemplo: ("Ejemplo", green),
  solucion: ("Solución", gray),
)

#show: frame-style(styles.boxy)

// --- Archivo Acumulativo de Ejemplos ---

#ejemplo[Supremo de $B = (0, 1)$][
  _Nota/Estrategia:_ La estrategia es suponer que no es el supremo, por lo tanto hay un $t$ menor a él que es cota superior, y deberíamos ver una contradicción estudiando el punto medio entre $t$ y $1$.

  Sea $B = (0, 1)$. Tenemos que $\operatorname{sup}(B) = 1$ ya que:

  - $s = 1$ es cota superior.
  - Supongamos que $t$ es una cota superior de $B$ y veamos que $t \ge 1$. Supongamos que no, es decir, $t < 1$. Pero entonces puedo tomar $x = (t+1)/2$ (el punto medio entre $t$ y $1$) y nos sale que $t < x < 1$. Pero entonces tenemos que por un lado $x \in B$ (porque es menor a 1) y por el otro es mayor a $t$ (que era una cota superior!). Esto es absurdo.
]

#ejemplo[Supremo de $C = \{2 - 1/n : n \in \mathbb{N}\}$][
  Sea $C = \{2 - 1/n : n \in \mathbb{N}\} = \{2 - 1, 2 - 1/2, 2 - 1/3, \dots\}$. Claramente $2$ es una cota superior de $C$. Mediante el Principio de Arquímedes que vamos a ver más adelante, se puede demostrar que $2 = \operatorname{sup}(C)$.
]

#ejemplo[Supremo de $D = \{x \in \mathbb{R} : 1/x^2 > 1/4\}$][
  Sea $D = \{x \in \mathbb{R} : 1/x^2 > 1/4\}$. Resolviendo la inecuación:

  $ 1/x^2 > 1/4 \iff 4 > x^2 \land x \neq 0 \iff 2 > |x| \land x \neq 0 $

  Esto nos da el conjunto $D = (-2, 0) \cup (0, 2)$, cuyo supremo es $\operatorname{sup}(D) = 2$.
]
