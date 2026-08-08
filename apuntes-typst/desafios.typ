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


#desafio[Equivalencia del Axioma de Completitud (Deducción desde el Teorema 2)][
  Suponiendo como cierto el Teorema 2 (todo conjunto $A subset.eq RR$ no vacío y acotado inferiormente tiene ínfimo en $RR$), deducir el Axioma de Completitud (todo conjunto acotado superiormente y no vacío de $RR$ tiene supremo en $RR$).
]

#desafio[Ejercicio 2 (Ínfimo del conjunto de cotas superiores)][
  Sea $A subset.eq RR$ no vacío y acotado superiormente. Sea $C = {"cotas superiores de " A}$. Probar que:

  #set enum(numbering: "1.")
  + $C != nothing$ y acotado inferiormente.
  + $op("ínf")(C) = op("sup")(A)$.
]

#desafio[Ejercicio 3 (Divergencia del valor absoluto)][
  Mostrar que si una sucesión $(a_n)_(n in NN)$ diverge a $plus.minus oo$ entonces la sucesión $(|a_n|)_(n in NN)$ diverge a $+oo$. Notar que no vale la vuelta.
]

#desafio[Desafío 5.3][
  Sean $x < y + epsilon$ para todo $epsilon > 0$, deducir que $x <= y$ y que si $|x - y| < epsilon$ para todo $epsilon > 0$ entonces $x = y$.
]
#solucion[
  *Demostración:*

  - *Parte 1 ($x <= y$):* Supongamos que $x > y$, de modo que $x - y > 0$. Sea $delta = x - y$, entonces tomando $delta / 2$ tenemos que $x > y + delta / 2$ pues:
    $ x - y = delta > delta / 2 $
    de modo que existe un $epsilon = delta / 2$ tal que $x lt.eq.not y + epsilon$, esto es el contrarrecíproco que se quería probar.

  - *Parte 2 ($|x - y| < epsilon => x = y$):* Sabiendo que si $x < y + epsilon$ es para todo $epsilon$ entonces $x <= y$, veamos que si $|x - y| < epsilon$ para todo $epsilon$ entonces son iguales.

    Supongamos que $x != y$. De modo que $x < y$ o $y < x$. Supongamos sin pérdida de generalidad que es $x < y$. Entonces, $y - x > 0$, sea $delta = y - x$ entonces tomando $delta / 2$ tenemos que:
    $ |x - y| = y - x > delta / 2 > 0 $

    Por absurdo, supongo que $x < y + epsilon$ para todo $epsilon$ y que $|x - y| < epsilon$ pero que $x != y$. Como por la primera parte $x < y + epsilon => x <= y$ y $x != y$ entonces $x < y$. Tomando $delta = y - x = |x - y|$ tenemos que $y - x = |x - y| > delta / 2$ absurdo, pues supusimos que $|x - y| < epsilon$ para todo $epsilon > 0$.
]

#desafio[Desafío 5.4][
  #set enum(numbering: "1.")
  + Sean $x, y in RR$, si $y - x > 1$, probar que existe un entero entre $x, y$.
  + Si ahora $x < y$, probar que existe un racional entre $x, y$.
  + Si ahora $x, y$ son racionales y $x < y$, probar que existe un irracional entre ellos.
  + Si $x, y$ son reales, probar que existe un irracional entre ellos.

  #v(4pt)
  - _*Estrategia (para el punto 3):* El truco es usar que un intervalo es convexo. La idea es: si tomo $x, y$ racionales en un intervalo, la línea que los une es $sigma(t) = (1 - t)x + t y = x + t(y - x)$. Aprovechando que $x, y$ son racionales, eligiendo un $t$ irracional (por ejemplo $pi/4$ o el que más te guste), se tiene que $x + t(y - x)$ es irracional._
  - _*Estrategia (para el punto 4):* Usar el punto 2 para encontrar números racionales entre los reales $x < y$, y luego aplicar el resultado del punto 3 a esos racionales para hallar el irracional buscado._
]




