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


// --- Desafíos de la Práctica 4 ---

#align(center)[
  #text(14pt, weight: "bold")[Desafíos --- Práctica 4] \
  #v(2pt)
  #text(10pt)[Funciones continuas]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

Los desafíos están agrupados por *dependencia*, no por orden de transcripción: cada bloque
supone resueltos los de arriba. La última columna dice a qué ejercicios de `guias/p4.typ`
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

    [1], [Imagen y preimagen de conjuntos], [conceptual],
    [2], [Continuidad: versión $epsilon$--$delta$ y versión con bolas], [Teo. 5.7, Ej. 1],
    [3], [Continuidad y cambio de métrica], [Ej. 1],
    [4], [Puntos aislados en $(NN, abs(dot))$], [Ejemplo 5.5 c)],
    [5], [Continuidad vía preimágenes de cerrados], [Ej. 4, 5, 6],
    [6], [El espacio métrico $(M_2(RR), d_oo)$], [Ejemplo 5.11],
    [7], [Continuidad uniforme y sucesiones de Cauchy], [Ej. 14],
    [8], [Extensión de uniformemente continuas desde un denso], [Teo. 5.22, Ej. 7],
    [9], [Funciones Lipschitz], [Ej. 12, 13],
  )
]

#v(10pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Bloque 1 · Imagen y preimagen de conjuntos

#sublema(titulo: "Qué desbloquea")[
  Manipular imágenes y preimágenes (Definición 5.1) sin confundir inclusiones con igualdades. Es la base para trabajar con la caracterización de continuidad por preimágenes en la *Práctica 4*.
]

#desafio[Inclusiones entre imagen y preimagen (Ejercicio 5.3)][
  Dada $f : M -> N$ una función y conjuntos $A subset.eq M$ y $B subset.eq N$, probar que valen las inclusiones:

  #set enum(numbering: "a)")
  + $A subset.eq f^(-1)(f(A))$.
  + $f(f^(-1)(B)) subset.eq B$.

  Ver que en general no valen las igualdades.
]

== Bloque 2 · Continuidad: versión $epsilon$--$delta$ y versión con bolas

#sublema(titulo: "Qué desbloquea")[
  La Definición 5.4 se enuncia con distancias ($d(y, x) < delta ==> d'(f(y), f(x)) < epsilon$), pero las demostraciones (por ejemplo, el Teorema 5.7) usan la reescritura con bolas ($f(B(x, delta)) subset.eq B(f(x), epsilon)$). Este desafío justifica que se puede pasar de una a otra libremente.
]

#desafio[Equivalencia de las dos formulaciones de continuidad][
  Sean $(M, d)$ y $(N, d')$ espacios métricos, $f : M -> N$ una función, $x in M$, y $epsilon, delta > 0$. Probar que son equivalentes:

  #set enum(numbering: "a)")
  + Para todo $y in M$, si $d(y, x) < delta$ entonces $d'(f(y), f(x)) < epsilon$.
  + $f(B(x, delta)) subset.eq B(f(x), epsilon)$.

  Concluir que las dos formas de enunciar la Definición 5.4 ("para todo $epsilon > 0$ existe $delta > 0$ tal que a)" y "para todo $epsilon > 0$ existe $delta > 0$ tal que b)") definen lo mismo.
]

== Bloque 3 · Continuidad y cambio de métrica

#sublema(titulo: "Qué desbloquea")[
  Ver que la continuidad (Definición 5.4) no cambia al reemplazar una métrica por otra equivalente. Alimenta el *Ejercicio 1* de la Práctica 4, donde se decide continuidad en $RR^n$ con distintas métricas.
]

#desafio[Continuidad con $d_1$ y $d_oo$ en $RR^n$ (Ejercicio 5.6)][
  Sea $f : (RR^n, d_2) -> (RR, abs(dot))$ una función continua en $x in RR^n$. Probar que $f$ sigue siendo continua en $x$ si en vez de usar la distancia $d_2$ usamos las distancias $d_1$ o $d_oo$.
]

== Bloque 4 · Puntos aislados en $(NN, abs(dot))$

#sublema(titulo: "Qué desbloquea")[
  Justificar la afirmación del *Ejemplo 5.5 c)*: si todos los puntos de $(NN, abs(dot))$ son aislados, entonces toda función $f : (NN, abs(dot)) -> (M, d)$ es continua (por el Ejemplo 5.5 b). Es la versión de $NN$ como espacio métrico propio de lo que en la Práctica 3 se vio para $ZZ subset.eq RR$ ($ZZ' = emptyset$).
]

#desafio[Todos los puntos de $(NN, abs(dot))$ son aislados][
  Probar que en el espacio métrico $(NN, abs(dot))$ todo punto es aislado, es decir, que para cada $n in NN$ existe $r > 0$ tal que $B(n, r) = {n}$.
]

== Bloque 5 · Continuidad vía preimágenes de cerrados

#sublema(titulo: "Qué desbloquea")[
  Versión con cerrados del Teorema 5.9 (continuidad por preimágenes de abiertos). Permite probar que un conjunto definido por igualdades o desigualdades no estrictas es cerrado escribiéndolo como preimagen de un cerrado por una función continua. Alimenta los *Ejercicios 4, 5 y 6* de la Práctica 4.
]

#desafio[Continuidad por cerrados (Ejercicio 5.10)][
  Sea $f : (M, d) -> (N, d')$. Probar que $f$ es continua si y sólo si $f^(-1)(F)$ es cerrado para todo $F subset.eq N$ cerrado.
]

== Bloque 6 · El espacio métrico $(M_2(RR), d_oo)$

#sublema(titulo: "Qué desbloquea")[
  Verificar que las matrices de $2 times 2$ con la distancia infinito forman un espacio métrico, que es el escenario del *Ejemplo 5.11* (continuidad del determinante y $G l_2(RR)$ abierto).
]

#desafio[$(M_2(RR), d_oo)$ es un espacio métrico (Ejemplo 5.11)][
  Sea
  $ M_2(RR) = {mat(a, b; c, d) : a, b, c, d in RR}, $
  el conjunto de las matrices de $2 times 2$ con coeficientes reales. En este conjunto tomamos la distancia infinito
  $ d_oo (A, B) = max_(1 <= i, j <= 2) abs(a_(i j) - b_(i j)). $
  Ver que $(M_2(RR), d_oo)$ es un espacio métrico.
]

#desafio[Convergencia en $(M_2(RR), d_oo)$ es convergencia coordenada a coordenada (Ejemplo 5.11)][
  Sea $(A_n)_(n in NN)$ una sucesión en $(M_2(RR), d_oo)$ y sea $A in M_2(RR)$, con
  $ A_n = mat(a_n, b_n; c_n, d_n), quad A = mat(a, b; c, d). $
  Probar que $A_n -> A$ en $d_oo$ si y sólo si $a_n -> a$, $b_n -> b$, $c_n -> c$ y $d_n -> d$ en $RR$.
]

#desafio[$G l_2(RR)$ es abierto, usando sólo la definición (Ejemplo 5.11)][
  Sea
  $ G l_2(RR) = {A in M_2(RR) : A "es una matriz inversible"} subset.eq (M_2(RR), d_oo). $
  Probar que $G l_2(RR)$ es un conjunto abierto usando solo la definición: no es imposible, pero es mucho más difícil que usar el Teorema 5.9 con $G l_2(RR) = scripts(det)^(-1)(RR without {0})$.
]

== Bloque 7 · Continuidad uniforme y sucesiones de Cauchy

#sublema(titulo: "Qué desbloquea")[
  Ver que la continuidad uniforme preserva sucesiones de Cauchy (con la Definición 5.14 o la Proposición 5.18), y preguntarse si vale la recíproca. Es el *Ejercicio 14* de la Práctica 4.
]

#desafio[Uniformemente continua manda Cauchy en Cauchy (Ejercicio 5.19)][
  Sea $f : (M, d) -> (N, d')$ una función uniformemente continua. Probar que $(f(x_n))_(n in NN) subset.eq N$ es una sucesión de Cauchy para toda sucesión $(x_n)_(n in NN) subset.eq M$ de Cauchy.

  ¿Vale que si $(f(x_n))_(n in NN)$ es de Cauchy para toda $(x_n)_(n in NN)$ de Cauchy entonces $f$ es uniformemente continua?

  _Sugerencia: pensar qué pasa en el caso en que $M$ y $N$ sean completos. Por ejemplo, podría ser $M = N = (RR, abs(dot))$._
]

== Bloque 8 · Extensión de uniformemente continuas desde un denso

#sublema(titulo: "Qué desbloquea")[
  Leer con cuidado el cierre de la demostración del *Teorema 5.22* (extensión de $f : E -> N$ uniformemente continua a $tilde(f) : M -> N$, con $E$ denso y $N$ completo): qué desigualdad sale de cada elección de índice. Usa el Bloque 7 (Ejercicio 5.19) y la Proposición 5.18.
]

#desafio[¿Dónde se usa que $n >= n_0$ y $n >= n_1$? (Teorema 5.22)][
  En la demostración de que $tilde(f)$ es uniformemente continua, para cerrar el argumento se toma un $n$ que sea, a la vez, más grande que $n_0$ y $n_1$, y se obtiene
  $
    d'(tilde(f)(x), tilde(f)(y)) <= & underbrace(d'(tilde(f)(x), tilde(f)(x_n)), < epsilon \/ 3) + underbrace(d'(f(x_n), f(y_n)), < epsilon \/ 3) \
                                    & + underbrace(d'(tilde(f)(y_n), tilde(f)(y)), < epsilon \/ 3) < epsilon.
  $
  Pensá dónde usamos que $n$ es más grande que $n_0$ y $n_1$.
]

#desafio[Unicidad de la extensión (Ejercicio 5.23)][
  Probar que la extensión $tilde(f)$ del teorema anterior (Teorema 5.22) es única.
]

== Bloque 9 · Funciones Lipschitz

#sublema(titulo: "Qué desbloquea")[
  Ver que ser Lipschitz (Definición 5.24) es una forma cómoda de probar continuidad uniforme: alcanza con dar la constante $C$. Es lo que pide el *Ejercicio 12* de la Práctica 4 ("pruebe que son Lipschitz; deduzca que son uniformemente continuas").
]

#desafio[Lipschitz implica uniformemente continua (Ejercicio 5.25)][
  Sea $f : M -> N$ una función Lipschitz de constante $C$. Probar que $f$ es uniformemente continua.
]

#desafio[$sqrt(x)$ es uniformemente continua en $[0, +infinity)$ (Ejercicio 5.27)][
  En el ejemplo anterior (Ejemplo 5.26 b)) vimos que $sqrt(x)$ no es Lipschitz si la pensamos como función en $[0, +infinity)$. Probar que $sqrt(x)$ es uniformemente continua en $[0, +infinity)$.

  _Sugerencia: Usar que_
  $ abs(sqrt(x) - sqrt(y))^2 <= abs(sqrt(x) - sqrt(y)) dot abs(sqrt(x) + sqrt(y)). $
]
