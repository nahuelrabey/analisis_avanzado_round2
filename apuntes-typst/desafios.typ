#import "@preview/frame-it:1.0.0": *
#import "utils.typ": *

#let (desafio, solucion) = frames(
  desafio: ("Desafío", orange),
  solucion: ("Solución", gray),
)

#show: frame-style(styles.boxy)

// --- Archivo Acumulativo de Desafíos ---

#desafio[Observación 1][
  El supremo de un conjunto, si existe, es único. (Demostración: ejercicio).
]

#desafio[Ejercicio 1][
  Sean $a, b \in \mathbb{R}$, con $a < b$. Sea $A = (a, b)$. Probar que $b = \operatorname{sup}(A)$.
]

#desafio[Supremo de $C = \{2 - 1/n : n \in \mathbb{N}\}$][
  Sea $C = \{2 - 1/n : n \in \mathbb{N}\} = \{2 - 1, 2 - 1/2, 2 - 1/3, \dots\}$. Claramente $2$ es una cota superior de $C$. Demostrar mediante el Principio de Arquímedes que $2 = \operatorname{sup}(C)$.
]

#desafio[No acotación de pares $A = \{n \in \mathbb{N} : n \text{ es par}\}$][
  Sea $A = \{n \in \mathbb{N} : n \text{ es par}\}$. Probar formalmente que $A$ no está acotado superiormente.
]
