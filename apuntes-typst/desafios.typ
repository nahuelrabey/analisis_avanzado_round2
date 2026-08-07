#import "@preview/frame-it:2.0.0": *
#import "utils.typ": *

#let (desafio, solucion) = frames(
  desafio: ("Desafío", rgb("#d97706")),
  solucion: ("Solución", rgb("#475569")),
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

// --- Archivo Acumulativo de Desafíos ---

#desafio[Observación 1][
  El supremo de un conjunto, si existe, es único. (Demostración: ejercicio).
]
#solucion[
  Sean $s_1$ y $s_2$ dos supremos del conjunto $A subset.eq RR$.
  - Como $s_1$ es supremo y $s_2$ es cota superior de $A$, por definición de supremo se tiene $s_1 <= s_2$.
  - Análogamente, como $s_2$ es supremo y $s_1$ es cota superior de $A$, se tiene $s_2 <= s_1$.
  
  Por la propiedad antisimétrica del orden en $RR$, concluimos que $s_1 = s_2$.
]

#desafio[Ejercicio 1][
  Sean $a, b in RR$, con $a < b$. Sea $A = (a, b)$. Probar que $b = op("sup")(A)$.
]
#solucion[
  Sea $A = (a, b)$ con $a < b$.
  + *Cota superior:* Para todo $x in (a, b)$, se cumple $x < b <= b$. Luego $b$ es cota superior de $A$.
  + *Menor cota superior:* Sea $t$ una cota superior de $A$. Supongamos que $t < b$.
    - Si $t <= a$, el punto medio $x = (a + b)/2 in A$ cumple $x > a >= t$, contradicción.
    - Si $a < t < b$, elegimos $x = (t + b)/2 in A$, pero $x > t$, contradiciendo que $t$ sea cota superior.
    
    Por lo tanto, $t >= b$, demostrando que $b = op("sup")(A)$.
]

#desafio[Supremo de $C = {2 - 1/n : n in NN}$][
  Sea $C = {2 - 1/n : n in NN} = {2 - 1, 2 - 1/2, 2 - 1/3, ...}$. Claramente $2$ es una cota superior de $C$. Demostrar mediante el Principio de Arquímedes que $2 = op("sup")(C)$.
]
#solucion[
  + *Cota superior:* Como $n >= 1 > 0 => 1/n > 0$, tenemos $2 - 1/n < 2$ para todo $n in NN$. Luego $2$ es cota superior de $C$.
  + *Menor cota superior:* Supongamos que existe una cota superior $t < 2$. Sea $epsilon = 2 - t > 0$. Por el Principio de Arquímedes, existe $n_0 in NN$ tal que $1/n_0 < 2 - t => 2 - 1/n_0 > t$. Pero $x_0 = 2 - 1/n_0 in C$, contradicción.
  
  Concluimos que $2 = op("sup")(C)$.
]

#desafio[No acotación de pares $A = {n in NN : n "es par"}$][
  Sea $A = {n in NN : n "es par"}$. Probar formalmente que $A$ no está acotado superiormente.
]
#solucion[
  Sea $M in RR$ arbitrario. Por el Principio de Arquímedes, existe $k in NN$ tal que $k > M$.
  - Si $k$ es par $=> k in A$ y $k > M$.
  - Si $k$ es impar $=> k + 1 in A$ y $k + 1 > k > M$.
  
  En ambos casos hallamos un elemento de $A$ strictly mayor que $M$. Por lo tanto, $A$ no está acotado superiormente.
]

#desafio[Supremo de $A = {r in QQ : r^2 < 2}$ en $RR$][
  Sea $A = {r in QQ : r^2 < 2}$. Probar que el supremo (en $RR$) de este conjunto es $s = sqrt(2)$.
]
