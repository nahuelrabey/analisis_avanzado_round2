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

#show heading.where(level: 2): it => block(width: 100%)[
  #v(6pt)
  #text(size: 12pt, weight: "bold", fill: rgb("#059669"))[#it.body]
  #v(2pt)
  #line(length: 100%, stroke: 0.7pt + rgb("#a7f3d0"))
]

// --- Ejemplos de la Práctica 6 ---

#align(center)[
  #text(14pt, weight: "bold")[Ejemplos resueltos --- Práctica 6] \
  #v(2pt)
  #text(10pt, style: "italic", fill: rgb("#475569"))[
    Espacios normados y operadores lineales
  ]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

Los ejemplos están agrupados por *técnica*, no por orden de transcripción, y los bloques siguen el orden en que la guía los necesita. Cada bloque abre con la nota de qué ejercicios de `guias/p6.typ` desbloquea.

La pestaña dice de dónde viene cada ejemplo: un *número* es el ejemplo de `notas_materia.pdf` (con su numeración por capítulo entre paréntesis en el título), *`C{clase}-{ejemplo}`* es un ejercicio resuelto en clase, transcrito en `clases/` (un archivo por tema; la tabla clase $arrow$ archivo está en la skill `ejemplo`) --- `C8-4` es el Ejercicio 4 de `clases/punto_fijo.typ` --- y *`A{sección}`* es un resultado o ejercicio de Abbott, _Understanding Analysis_.

#v(6pt)

#show table.cell.where(y: 0): set text(fill: white, weight: "bold", size: 8.5pt)

#table(
  columns: (0.35fr, 2.4fr, 1.1fr),
  align: (center + horizon, left + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#065f46") } else if calc.even(y) { rgb("#f8fafc") } else { white },
  stroke: 0.4pt + rgb("#cbd5e1"),
  inset: (x: 6pt, y: 4pt),

  [*\#*], [*Bloque*], [*Desbloquea*],
  [1], [Completitud en espacios normados], [p6: Ej. 6, 7 (conceptual)],
  [2], [Operadores lineales: continuidad y acotación], [p6: Ej. 8, 9, 12],
)

#v(4pt)

#text(size: 9pt, fill: rgb("#64748b"))[
  La numeración de ejercicios es la de `guias/p6.typ` (Práctica 6, edición 2026).
]

#v(8pt)

== Bloque 1 · Completitud en espacios normados

#sublema(titulo: "Qué desbloquea")[
  En un espacio normado, la completitud se puede chequear sobre la esfera unitaria $S = {x : norm(x) = 1}$: si toda sucesión de Cauchy de $S$ converge, el espacio es de Banach. La técnica es *normalizar* una sucesión de Cauchy que no tiende a $0$ y controlar el error con la desigualdad $abs(norm(x_n) - norm(x_m)) <= norm(x_n - x_m)$. Sirve como modelo para el *Ejercicio 6* (completitud de $ell^oo$) y el *Ejercicio 7* de la Práctica 6, y repasa el Ejercicio 15 de la Práctica 3 (cerrado de completo es completo).
]

#ejemplo[$E$ es de Banach si y sólo si toda sucesión de Cauchy en la esfera unitaria converge (Clase 8 · Ejercicio 4)][C8-4][
  Sea $(E, norm(dot.c))$ un espacio normado. Sea
$
S = {x in E : norm(x) = 1}.
$
Probar que $E$ es un espacio de Banach si y sólo si toda sucesión de Cauchy $(x_n)_(n >= 1) subset.eq S$ converge.
]

#resolucion[
La implicación $=>)$ es porque $S$ es cerrado, y por el Ejercicio 15 de la Práctica 3, es completo. Para la vuelta, sea $(x_n)_n subset.eq E$ de Cauchy. Si $x_n -> 0$, no hay nada que probar. Supongamos que $x_n arrow.r.not 0$. Tenemos que $(norm(x_n))_n$ es de Cauchy, porque
$
norm(x_n) <= norm(x_n - x_m) + norm(x_m),
$
entonces
$
norm(x_n) - norm(x_m) <= norm(x_n - x_m),
$
y por simetría,
$
norm(x_m) - norm(x_n) <= norm(x_n - x_m).
$
Entonces
$
abs(norm(x_n) - norm(x_m)) <= norm(x_n - x_m),
$
y el segundo término se puede hacer menor a $epsilon > 0$ para todo $n, m$ suficientemente grande, porque $(x_n)_n$ es de Cauchy. Por lo tanto $(norm(x_n))_n$ converge, porque $RR$ es completo; digamos $norm(x_n) -> L$. Además, $L != 0$; caso contrario, $norm(x_n) -> 0$ equivale a decir que $x_n -> 0$. Como $norm(x_n) >= 0$, $L > 0$. Entonces existen $n_0 in NN$ y $delta > 0$ tales que $norm(x_n) >= delta$ para todo $n >= n_0$. Por lo tanto, podemos _normalizar_ $(x_n)_n$. Para todo $n >= n_0$ definimos $y_n = x_n \/ norm(x_n)$. Se tiene que
$
norm(y_n - y_m) &= norm(x_n / norm(x_n) - x_m / norm(x_m)) = norm((norm(x_m) dot.c x_n - x_m dot.c norm(x_n)) / (norm(x_n) dot.c norm(x_m))) \
&<= 1 / (norm(x_n) dot.c norm(x_m)) [ norm(norm(x_m) dot.c x_n - L dot.c x_n) + norm(L x_n - L x_m) + norm(L x_m - x_m dot.c norm(x_n)) ] \
&<= 1 / (norm(x_n) dot.c norm(x_m)) [ abs(norm(x_m) - L) dot.c norm(x_n) + norm(x_n - x_m) dot.c L + abs(L - norm(x_n)) dot.c norm(x_m) ].
$
Como $norm(x_n) -> L != 0$, el lado derecho tiende a $0$. Por lo tanto $(y_n)_(n >= n_0)$ es de Cauchy. Como $S$ es completo, $y_n -> y$ con $y in S$. Pero entonces $y_n = x_n \/ norm(x_n) -> y$ implica que $x_n$ converge a $L dot.c y$, ya que para todo $n >= n_0$,
$
norm(x_n - L dot.c y) &<= norm(x_n - x_n / norm(x_n) dot.c L) + norm(x_n / norm(x_n) dot.c L - L dot.c y) \
&= abs(1 - L / norm(x_n)) dot.c norm(x_n) + norm(x_n / norm(x_n) - y) dot.c L \
&= abs((norm(x_n) - L) / norm(x_n)) dot.c norm(x_n) + norm(y_n - y) dot.c L,
$
y el lado derecho tiende a $0$. Concluimos que $(x_n)_n$ es convergente. #align(right)[$square$]
]

_Nota_: "el lado derecho tiende a $0$" en la cota de $norm(y_n - y_m)$ quiere decir: dado $epsilon > 0$, los tres sumandos del corchete son $< epsilon$ para $n, m$ grandes (por $norm(x_n) -> L$ y la condición de Cauchy), y el factor $1 \/ (norm(x_n) norm(x_m)) <= 1 \/ delta^2$ está acotado. "Como $S$ es completo" es la hipótesis: toda Cauchy en $S$ converge, y el límite queda en $S$ porque $S$ es cerrado.

== Bloque 2 · Operadores lineales: continuidad y acotación

#sublema(titulo: "Qué desbloquea")[
  Para un operador lineal, continuidad equivale a mandar acotados en acotados (*Ejercicio 8* de la Práctica 6). Este ejemplo agrega otra caracterización por sucesiones nulas, con el truco de reescalar $x_n$ por $sqrt(n) norm(x_n)$ para fabricar una sucesión que tiende a $0$ con imágenes no acotadas. Es la herramienta para refutar continuidad en el *Ejercicio 12* (el operador derivada) y complementa las fórmulas del *Ejercicio 9*.
]

#ejemplo[$T$ lineal es continua si y sólo si manda sucesiones nulas en sucesiones acotadas (Clase 8 · Ejercicio 5)][C8-5][
  Sean $E, F$ espacios normados. Sea $T : E -> F$ una transformación lineal. Probar que $T$ es continua si y sólo si para toda sucesión $(x_n)_(n >= 1)$ en $E$ que tiende a $0$, $(T(x_n))_n$ es acotada.
]

#resolucion[
La implicación $=>)$ es consecuencia directa de la continuidad, pues $T(x_n) -> T(0) = 0$. Para la implicación $arrow.l.double)$, alcanza con ver que para todo $A subset.eq E$ acotado, $T(A)$ es acotado, porque por el Ejercicio 8 de la Práctica 6 esto equivale a que $T$ sea continua. Si _existiera $A subset.eq E$ acotado con $T(A)$ no acotado_, entonces para todo $n in NN$ existe $x_n in A$ tal que $norm(T(x_n)) >= n$. Por lo tanto $(T(x_n))_n$ no está acotada. Esto no finaliza la prueba, porque $x_n$ no tiene por qué tender a $0$. Si $x_n arrow.r.not 0$, existen $(x_(n_k))_k$ y $delta > 0$ tales que $norm(x_(n_k)) > delta$ para todo $k in NN$. Entonces, para todo $k in NN$, sea
$
y_k = x_(n_k) / (sqrt(n_k) norm(x_(n_k))).
$
Tenemos que $norm(y_k) = 1 \/ sqrt(n_k) -> 0$, y
$
norm(T(y_k)) = norm(T(x_(n_k)) / (sqrt(n_k) norm(x_(n_k)))) >= n_k / (sqrt(n_k) norm(x_(n_k))) = sqrt(n_k) / norm(x_(n_k)).
$
Como $A$ está acotado, $A subset.eq B(0, R)$ para algún $R > 0$. Entonces $norm(x_n) <= R$, por lo tanto
$
norm(T(y_k)) >= sqrt(n_k) / R,
$
y concluimos que $(T(y_k))_k$ no está acotada, con $y_k -> 0$. #align(right)[$square$]
]

_Nota_: el caso $x_n -> 0$ no se trata en el manuscrito: en ese caso $(T(x_n))_n$ ya contradice la hipótesis directamente. De hecho, la subsucesión y el $delta$ no se usan en la cota final (que sólo necesita $norm(x_(n_k)) <= R$); alcanza con $x_n != 0$, que vale porque $norm(T(x_n)) >= n > 0$ y $T(0) = 0$, para definir $y_n = x_n \/ (sqrt(n) norm(x_n))$ con toda la sucesión.
