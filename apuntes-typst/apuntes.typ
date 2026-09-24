#import "@preview/frame-it:2.0.0": *
#import "utils.typ": *
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
//
//
// // --- Diccionario de Contadores Individuales por Cajita ---
// #let contadores-repaso = (
//   "Conjunto Acotado Superiormente": 1,
//   "Supremo": 1,
//   "Completitud": 1,
//   "Principio de Arquímedes": 1,
//   "Principio de Arquímedes 2": 1,
//   "Densidad de ℚ": 1,
//   "Densidad deℚ": 1,
//   "Equivalencia de supremo": 0,
//   "Máximo": 0,
//   "Caracterización de Supremo y Máximo": 0,
//   "Conjunto Acotado Inferiormente": 0,
//   "Ínfimo": 0,
//   "Completitud en términos de ínfimos": 0,
//   "Equivalencia de Ínfimo": 0,
//   "Mínimo": 0,
//   "Caracterización de Ínfimo y Mínimo": 0,
//   "Sucesiones": 0,
//   "Convergencia de Sucesiones": 0,
//   "Divergencia de Sucesiones": 0,
//   "Unicidad del límite": 0,
//   "Álgebra de límites": 0,
//   "Sucesión Acotada": 0,
//   "Toda sucesión convergente está acotada": 0,
//   "Sucesión Monótona": 0,
//   "Convergencia de sucesiones monótonas crecientes": 0,
// )
//
// // --- Página de Autoevaluación / Repaso Activo ---
//
// #align(center)[
//   #text(18pt, weight: "bold", fill: rgb("#1e293b"))[Registro de Autoevaluación] \
//   #v(4pt)
//   #text(10pt, fill: rgb("#64748b"), style: "italic")[Cantidad de veces completado correctamente sin mirar]
// ]
// #v(1.5em)
//
// #context {
//   let frames-found = query(figure.where(kind: "frame")).filter(it => it.supplement != [demo] and it.supplement != [estrategia] and it.supplement != [Demostración] and it.supplement != [Estrategia] and it.caption != none)
//   
//   let extract-text(it) = {
//     if type(it) == str { it }
//     else if type(it) != content { "" }
//     else if it.has("text") { it.text }
//     else if it.has("children") { it.children.map(extract-text).join("") }
//     else if it.has("body") { extract-text(it.body) }
//     else { "" }
//   }
//
//   for item in frames-found {
//     let supp = item.supplement
//     let cap = item.caption.body
//     let page-num = item.location().page()
//     
//     let children = cap.fields().at("children", default: ())
//     let raw-title = children.filter(c => not (type(c) == content and c.has("value"))).map(extract-text).join("").trim()
//     
//     // Normalizar espacios intermedios para búsqueda limpia en diccionario
//     let title-clean = raw-title.split().join(" ")
//     let count = contadores-repaso.at(title-clean, default: 0)
//     
//     let is-done = count > 0
//     let box-stroke = if is-done { 0.7pt + rgb("#2563eb") } else { 0.7pt + rgb("#94a3b8") }
//     let box-fill = if is-done { rgb("#eff6ff") } else { none }
//     let text-color = if is-done { rgb("#2563eb") } else { rgb("#94a3b8") }
//
//     grid(
//       columns: (auto, auto, 1fr, auto),
//       gutter: 8pt,
//       align: (left + horizon, left + horizon, bottom, right + horizon),
//       [#box(width: 18pt, height: 13pt, stroke: box-stroke, radius: 3pt, fill: box-fill)[#align(center + horizon)[#text(8.5pt, fill: text-color, weight: "bold")[#count]]]],
//       [*#supp:* #cap],
//       box(width: 100%, repeat[.#h(3pt)]),
//       [pág. #page-num]
//     )
//     v(6pt)
//   }
// }
//
// #pagebreak()

// --- Apuntes Matemáticos ---

#definicion[Conjunto Acotado Superiormente][1][
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
    #cetz.canvas({
      import cetz.draw: *

      // Línea principal del eje real
      line((0, 0), (7, 0), stroke: 1.2pt + rgb("#334155"))

      // Guías verticales punteadas entre s - epsilon y a_epsilon
      line((1.5, 0), (1.5, 0.7), stroke: (dash: "dashed", paint: rgb("#94a3b8"), thickness: 0.8pt))
      line((4.0, 0), (4.0, 0.7), stroke: (dash: "dashed", paint: rgb("#94a3b8"), thickness: 0.8pt))

      // Marcas verticales (ticks) en s - epsilon y s
      line((1.5, -0.2), (1.5, 0.2), stroke: 1.5pt + rgb("#1e293b"))
      line((5.5, -0.2), (5.5, 0.2), stroke: 1.5pt + rgb("#1e293b"))

      // Punto a_epsilon exactamente centrado SOBRE la línea real
      circle((4.0, 0), radius: 0.10, fill: rgb("#2563eb"), stroke: 1pt + rgb("#1d4ed8"))

      // Etiquetas inferiores
      content((1.5, -0.55), text(size: 11pt, weight: "medium")[$s - epsilon$])
      content((4.0, -0.55), text(size: 11pt, weight: "bold", fill: rgb("#2563eb"))[$a_epsilon$])
      content((5.5, -0.55), text(size: 11pt, weight: "medium")[$s$])

      // Cota de distancia epsilon desde s - epsilon hasta a_epsilon
      line((1.5, 0.65), (4.0, 0.65), stroke: 1pt + rgb("#475569"), mark: (start: "|", end: "|"))
      content((2.75, 1.0), text(size: 12pt, weight: "bold", fill: rgb("#0f172a"))[$epsilon$])
    })
  ]
]

Vamos a probar la doble implicación. Antes de avanzar vamos a llamar

- def 1 : $forall t " cota superioor " => s <= t$
- def 2 : $forall epsilon > 0 =>  exists a_epsilon in A : s-epsilon < a_epsilon < s$

#estrategia[Por contradicción][
  La estrategia sale por contradicción: ¿qué pasa si no existe $a_epsilon$?
]
#demostracion[def 1 $=>$ def 2][
  Sean $s = op("sup")(A)$ y $epsilon > 0$. Supongamos que no existe $a_epsilon in A$ tal que $s - epsilon < a_epsilon$. Por lo tanto, debe cumplirse que

$ forall a in A: a < s - epsilon => s - epsilon "es cota superior de" A $

Pero $s - epsilon$ sería entonces una cota superior de $A$ más chica que $s$ que es el supremo de $A$. Esto es absurdo, por lo tanto debe existir $a_epsilon in A: s-epsilon < a_epsilon < s$.

]
#estrategia[Contrarrecíproco][
  - Contrarrecíproco: $ t "cota superior " <=> forall a in A: a <= t $ es equivalente a decir que $ exists a in A: t < a <=> t "no es cota superior" $.
  - Construyo $t > s$, encuentro $epsilon$, veo que $t < a_epsilon$ y por lo tanto no es cota superior. Uso contrarrecíproco y fin.
]
#demostracion[def 2 $=>$ def 1][
  Sabemos que $s$ es cota superior, veamos que es la menor de las cotas superiores. Sea $t < s$, podemos construir $epsilon = s - t > 0$.

  Por _def 2_, sabemos que debe existir $a_epsilon in A$ tal que $s - epsilon < a_epsilon$. Reemplazando,
  $ s - epsilon = s - (s - t) = t < a_epsilon. $
  Esto nos dice que $t$ no puede ser cota superior de $A$. Es decir, que *toda cota superior de $A$ debe ser mayor o igual a $s$*, que es lo que queríamos probar.
]

#definicion[Máximo][3][
  Si $op("sup")(A) in A$, entonces $op("sup")(A)$ se denomina *máximo* de $A$. En ese caso, notamos $op("máx")(A)$ en lugar de $op("sup")(A)$.
]

#proposicion[Caracterización de Supremo y Máximo][4][
  Sea $A subset.eq RR$ un conjunto acotado superiormente y no vacío. Si $t$ es una cota superior y $t in A$ entonces $t = op("sup")(A)$ (y también es el máximo).
]

#estrategia[
  Intentá encontrar que $t<=s and t>=s$
]

#demostracion[
  Por el Axioma de Completitud sabemos que existe $s = op("sup")(A)$. Queremos probar que $s = t$.

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

Vamos a probar la doble implicación. Antes de avanzar vamos a llamar:

- def 1 : $forall c in RR: c "es cota inferior" => i >= c$
- def 2 : $forall epsilon > 0 => exists a_epsilon in A: i < a_epsilon < i + epsilon$

#estrategia[Por contradicción][
  La estrategia sale por contradicción: ¿qué pasa si no existe $a_epsilon$?
]
#demostracion[def 1 $=>$ def 2][
  Sea $i = op("ínf")(A)$ y $epsilon > 0$. Supongamos que no existe $a_epsilon in A$ tal que $i < a_epsilon < i + epsilon$. Es decir, que para todo $a in A$ se cumple $a >= i + epsilon$. Por lo tanto, $i + epsilon$ es una cota inferior de $A$ mayor que $i$, lo cual es absurdo porque $i = op("ínf")(A)$ (es la mayor de las cotas inferiores). En consecuencia, debe existir $a_epsilon in A$ tal que $i < a_epsilon < i + epsilon$.
]

#estrategia[Contrarrecíproco][
  - Tomo $t > i$ y defino $epsilon = t - i > 0$.
  - Uso def 2 para encontrar $a_epsilon < i + epsilon = t$, lo que demuestra que $t$ no puede ser cota inferior.
]
#demostracion[def 2 $=>$ def 1][
  Sea $i$ tal que cumple def 2. Tomemos $t > i$, es decir que $t - i > 0$. Llamemos $epsilon = t - i > 0$. Por def 2 sabemos que existe $a_epsilon in A$ tal que $i < a_epsilon < i + epsilon$. Reemplazando $epsilon$, tenemos:
  $ a_epsilon < i + (t - i) = t. $
  Es decir, $t$ no puede ser cota inferior de $A$. Por lo tanto, toda cota inferior $c$ de $A$ debe cumplir $c <= i$, lo que demuestra def 1.
]

#definicion[Mínimo][6][
  Si $op("ínf")(A) in A$, entonces $op("ínf")(A)$ se denomina *mínimo* de $A$. En ese caso, notamos $op("mín")(A)$ en lugar de $op("ínf")(A)$.
]

#proposicion[Caracterización de Ínfimo y Mínimo][6][
  Sea $A subset.eq RR$ un conjunto acotado inferiormente y no vacío. Si $t$ es una cota inferior y $t in A$ entonces $t = op("ínf")(A) = op("mín")(A)$.
]

#estrategia[Idea de la demostración][
  Como $t$ es cota inferior e $i = op("ínf")(A)$, por definición de ínfimo se tiene $t <= i$. Por otro lado, como $t in A$ e $i$ es cota inferior, se tiene $t >= i$. Al cumplirse $t <= i$ y $t >= i$, se concluye $t = i$.
]
#demostracion[
  Dado que $A$ está acotado inferiormente y no es un conjunto vacío, por completitud en términos de ínfimos existe $i = op("ínf")(A)$.

  Como $t$ es cota inferior e $i = op("ínf")(A)$, sabemos que $t <= i$ (pues el ínfimo es la mayor de las cotas inferiores). Por otro lado, como $t in A$ e $i$ es cota inferior de $A$, se tiene $t >= i$.

  Solo pueden cumplirse ambas desigualdades ($t <= i$ y $t >= i$) si $t = i$. Por lo tanto $t = op("ínf")(A)$, y como $t in A$, también resulta $t = op("mín")(A)$.
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

#estrategia[Acotar la distancia $abs(ell_1 - ell_2) < epsilon$][
  La estrategia consiste en buscar $abs(ell_1 - ell_2) < epsilon$ para todo $epsilon > 0$. Para lograrlo, sumamos y restamos $a_n$, aplicamos desigualdad triangular para obtener $abs(ell_1 - a_n) + abs(a_n - ell_2)$, y acotamos cada parte por $epsilon/2$ eligiendo $n >= op("máx")(n_1, n_2)$.
]


#demostracion[
  Sabemos que dado $epsilon > 0$ existe $n_1 in NN$ tal que $abs(a_n - ell_1) < epsilon/2$ para todo $n >= n_1$ y a la vez existe $n_2 in NN$ tal que $abs(a_n - ell_2) < epsilon/2$ para todo $n >= n_2$. Entonces si elegimos $a_n$ con $n >= n_1$ y $n >= n_2$:

  $ abs(ell_1 - ell_2) = abs(ell_1 - a_n + a_n - ell_2) <= abs(ell_1 - a_n) + abs(a_n - ell_2) < epsilon/2 + epsilon/2 = epsilon. $

  Como $epsilon$ es arbitrario, por ejercicio de la guía 1, sabemos que $ell_1 = ell_2$.
]


#definicion[Negación de la Convergencia (No Convergencia / Divergencia)][9][
  Decimos que una sucesión real $(a_n)_(n in NN)$ *no converge* (es decir, no admite ningún límite en $RR$) si satisface la negación formal de la definición de convergencia para todo candidato a límite $L in RR$:

  $ (forall L in RR)(exists epsilon_0 > 0)(forall N in NN)(exists n >= N) => abs(a_n - L) >= epsilon_0 $

  En palabras: para todo candidato a límite $L in RR$, existe un umbral de error $epsilon_0 > 0$ tal que para cualquier elección de $N in NN$, existe un término $a_n$ con $n >= N$ cuya distancia a $L$ es mayor o igual a $epsilon_0$ ($abs(a_n - L) >= epsilon_0$).
]

#proposicion[Álgebra de límites][6][
  Sean $(a_n)_(n in NN)$ y $(b_n)_(n in NN)$ sucesiones reales tales que $lim_(n -> oo) a_n = a$, $lim_(n -> oo) b_n = b$, con $a, b in RR$. Entonces:

  #set enum(numbering: "a)")
  + $lim_(n -> oo) (c · a_n) = c · a$ para todo $c in RR$.
  + $lim_(n -> oo) (a_n + b_n) = a + b$.
  + $lim_(n -> oo) (a_n b_n) = a b$.
  + Si $b != 0$, entonces $lim_(n -> oo) (a_n / b_n) = a / b$.
  + Si $a_n <= b_n$ para todo $n >= n_0$ entonces $a <= b$.
]

#demostracion[Álgebra de límites: Ítem a ($lim_(n -> oo) c · a_n = c · a$)][
  Sea $c in RR$. Tenemos dos opciones: $c = 0$ o $c != 0$. Observemos que si $c = 0$, tanto $c · a_n = 0$ para todo $n in NN$ como $c · a = 0$, con lo cual la propiedad se cumple trivialmente.

  Supongamos ahora que $c != 0$ y tomemos $epsilon > 0$. Como $a_n -> a$, debe existir un $n_0 in NN$ tal que $abs(a_n - a) < epsilon / abs(c)$ para todo $n >= n_0$ (notemos que podemos dividir a $epsilon$ por $abs(c)$ porque $c != 0$ y que $epsilon / abs(c) > 0$). Tenemos que

  $ abs(c · a_n - c · a) = abs(c · (a_n - a)) = abs(c) abs(a_n - a) < abs(c) · epsilon / abs(c) = epsilon $

  para todo $n >= n_0$.
]

#demostracion[Álgebra de límites: Ítem b ($lim_(n -> oo) (a_n + b_n) = a + b$)][
  _Ejercicio de la guía (demostración a completar / ver archivo de desafíos)_.
]

#estrategia[Estrategia para el producto de límites][
  1. *Fijar $epsilon > 0$* al comienzo de la demostración para poder construir las cotas relativas a $epsilon$.
  2. Como $(a_n)$ converge, utilizar que es *acotada*: existe $M > 0$ tal que $|a_n| <= M$ para todo $n in NN$.
  3. Acotar $|b_n - b| < epsilon / (2M)$ a partir de un $n_1 in NN$.
  4. Para el caso $b != 0$, acotar $|a_n - a| < epsilon / (2 |b|)$ a partir de un $n_2 in NN$.
  5. Elegir $n_0 = op("máx")(n_1, n_2)$ para asegurar que ambas cotas valgan en simultáneo y concluir $|a_n b_n - a b| < epsilon$.
]
#demostracion[Álgebra de límites: Ítem c ($lim_(n -> oo) a_n b_n = a b$)][
  Sea $epsilon > 0$. Como $a_n$ es una sucesión convergente, sabemos que es acotada. Es decir, existe $M > 0$ tal que $abs(a_n) <= M$ para todo $n in NN$. Sea $n_1 in NN$ tal que $abs(b_n - b) < epsilon / (2M)$ para todo $n >= n_1$ (otra vez, acá es importante notar que $epsilon / (2M)$ es un número positivo y por lo tanto podemos aplicar la definición de límite). Como en el ítem 1, vamos a distinguir dos casos: $b = 0$ o $b != 0$.

  Si $b = 0$ entonces $a · b = 0$ y tenemos que

  $ abs(a_n b_n - a b) = abs(a_n b_n) = abs(a_n) abs(b_n) <= M abs(b_n - b) < epsilon/2 < epsilon $

  para todo $n >= n_1$. Tomamos $n_0 = n_1$ y listo.

  Supongamos ahora que $b != 0$. Como $a_n -> a$, sabemos que existe $n_2 in NN$ tal que $abs(a_n - a) < epsilon / (2 abs(b))$ para todo $n >= n_2$. Entonces tenemos

  $ abs(a_n b_n - a b) &= abs(a_n b_n - a_n b + a_n b - a b) \
  &<= abs(a_n) abs(b_n - b) + abs(b) abs(a_n - a) \
  &<= M underbrace(abs(b_n - b), < epsilon / (2M)) + abs(b) underbrace(abs(a_n - a), < epsilon / (2 abs(b))) \
  &< epsilon/2 + epsilon/2 = epsilon. $

  Acá tenemos que pensar qué necesitamos para que se cumpla la cuenta que acabamos de hacer. Por un lado, $n$ debería ser más grande que $n_1$ para que se cumpla que podemos acotar $abs(b_n - b)$. Por el otro, necesitamos que $n$ sea más grande que $n_2$ para que podamos acotar el término $abs(a_n - a)$. Es decir que para que sean ciertas ambas cotas al mismo tiempo necesitamos que $n$ sea más grande $n_1$ y $n_2$ *al mismo tiempo*. Esto se puede plasmar en nuestra demostración eligiendo $n_0 = op("máx")(n_1, n_2)$ y entonces la cuenta de arriba vale para todo $n >= n_0$ que es lo que queríamos ver.
]

#estrategia[Cociente como producto][
  Escribimos el cociente como un producto $a_n / b_n = a_n · (1/b_n)$. Habiendo probado el ítem c (límite del producto), lo único que necesitamos demostrar es que $1/b_n -> 1/b$ (con $b != 0$).
]
#demostracion[Álgebra de límites: Ítem d ($lim_(n -> oo) a_n / b_n = a / b$)][
  Por el ejercicio 6, si $b_n -> b$ y $b != 0$ entonces existe una constante $c > 0$ (en el ejercicio mostramos que esa constante $c$ se puede elegir $c = abs(b)/2 > 0$) y $n_1 in NN$ tal que $abs(b_n) >= c$ para todo $n >= n_1$.

  Tomando por válido este resultado, fijemos un $epsilon > 0$. Sea $n_2 in NN$ tal que $abs(b_n - b) < epsilon · abs(b) · c$ para todo $n >= n_2$. Entonces

  $ abs(1/b_n - 1/b) = abs(b - b_n) / abs(b_n · b) <= abs(b_n - b) / (c · abs(b)) < epsilon $

  si $n >= n_0 = op("máx")(n_1, n_2)$ (donde $n_1$ es el que nos garantiza que $abs(b_n) >= c$ y $n_2$ es el que nos da la cota de $abs(b_n - b)$).
]



#definicion[Sucesión Acotada][9][
  Una sucesión $(a_n)_(n in NN)$ está *acotada* si el conjunto $\{a_n : n in NN\} subset.eq RR$ está acotado.

  Es decir, si existe $M > 0$ tal que $|a_n| <= M$ para todo $n in NN$.
]

#proposicion[Toda sucesión convergente está acotada][7][
  Si $lim_(n -> oo) a_n = ell in RR$, entonces $(a_n)_(n in NN)$ está acotada.
]

#demostracion[
  Sea $epsilon = 1$. Entonces existe $n_0 in NN$ tal que si $n >= n_0$ se tiene $|a_n - ell| < 1$. Tenemos que

  $ |a_n| = |a_n - ell + ell| <= |a_n - ell| + |ell| < 1 + |ell|, quad "para todo" n >= n_0. $

  Con lo cual, a partir de $n_0$, el valor absoluto de los términos de la sucesión está acotado por $1 + |ell|$. Solo resta ver qué le sucede a los términos anteriores. Es decir a $|a_1|, |a_2|, ..., |a_(n_0)|$, pero estos son finitos. Con lo cual, si elegimos $M = op("máx")\{|a_1|, |a_2|, ..., |a_(n_0)|, 1 + |ell|\}$, tenemos que $|a_n| <= M$ para todo $n in NN$.
]

#definicion[Sucesión Monótona][10][
  Una sucesión $(a_n)_(n in NN)$ es *monótona creciente* (análogamente *decreciente*) si $a_n <= a_(n+1)$ (análogamente $a_n >= a_(n+1)$) para todo $n$ o a partir de algún $n_0$ en adelante.
]

#proposicion[Convergencia de sucesiones monótonas crecientes][8][
  Sea $(a_n)_(n in NN)$ una sucesión monótona creciente y acotada, entonces converge.

  Más aún, se tiene que
  $ lim_(n -> oo) a_n = op("sup")\{a_n : n in NN\}. $
]

#demostracion[
  Como $(a_n)_(n in NN)$ es acotada, sabemos que existe $s = op("sup")\{a_n : n in NN\}$. Sea $epsilon > 0$. Por equivalencia del supremo, existe $a_(n_0)$ tal que $s - epsilon < a_(n_0) <= s$. Esto nos dice que

  $ |s - a_(n_0)| = s - a_(n_0) < epsilon. $

  Además, como $(a_n)_(n in NN)$ es monótona creciente, tenemos que para todo $n >= n_0$, $a_n >= a_(n_0)$. Finalmente,

  $ |s - a_n| = s - a_n <= s - a_(n_0) < epsilon, $

  que es lo que queríamos probar.
]

#proposicion[Equivalencia del supremo 2][
  Sea $A subset.eq RR$ no vacío y acotado superiormente. Entonces $s = op("sup")(A)$ si y sólo si:

  #set enum(numbering: "a)")
  + $s$ es cota superior de $A$, y
  + existe una sucesión $(a_n)_(n in NN) subset.eq A$ tal que $lim_(n -> oo) a_n = s$.
]

#demostracion[
  - *($=>$)* Sea $s = op("sup")(A)$. Por definición de supremo, se cumple a). Para ver que también se cumple b), vamos a construir una sucesión $(a_n)_(n in NN)$ que cumpla lo que queremos ver. Empezamos tomando $epsilon = 1$. Por la equivalencia que ya probamos, sabemos que tiene que existir un elemento de $A$ que sea más grande que $s - 1$, es decir que existe un elemento $a_1 in A$ tal que $s - 1 < a_1 <= s$. Para elegir $a_2$ vamos a repetir este razonamiento pero achicando el $epsilon$, ahora tomamos $epsilon = 1/2$. Otra vez por la equivalencia, sabemos que existe $a_2 in A$ tal que $s - 1/2 < a_2 <= s$. En general, para elegir $a_n$ vamos a tomar $epsilon = 1/n > 0$ y vamos a elegir $a_n in A$ tal que $s - 1/n < a_n <= s$.

    Veamos que esta sucesión cumple que $a_n -> s$. Sea $epsilon > 0$ (acá este $epsilon$ es un número arbitrario, no es de los que veníamos eligiendo antes). Por el principio de Arquímedes sabemos que debe existir un número natural $n_0$ tal que $epsilon > 1/n_0 > 0$. Además, como $1/n$ es una sucesión decreciente, sabemos que $1/n <= 1/n_0$ para todo $n >= n_0$. Con todo esto tenemos que si $n >= n_0$,

    $ abs(s - a_n) = s - a_n < 1/n <= 1/n_0 < epsilon, $

    lo que prueba que $a_n -> s$.

  - *($<=.bar$)* Sea $s$ que cumple a) y b) y veamos que es el supremo de $A$. Como $s$ cumple a) ya sabemos que es cota superior. Veamos que también cumple la condición 2 de la primera equivalencia de supremo. Sea $epsilon > 0$. Como $a_n -> s$, sabemos que debe existir un $n_0$ tal que $abs(s - a_n) < epsilon$ para todo $n >= n_0$. En particular, usando que $s$ es cota superior, tenemos

    $ abs(s - a_(n_0)) = s - a_(n_0) < epsilon => s - epsilon < a_(n_0) $

    y $a_(n_0) in A$. Es decir, encontramos un elemento de $A$ que es más grande que $s - epsilon$, que es lo que queríamos probar.
]

#definicion[Subsucesión][
  Una subsucesión de $(a_n)_(n in NN)$ es una sucesión de la forma $(a_(n_k))$ donde $n_k$ es estrictamente creciente, es decir, tenemos que $n_1 < n_2 < n_3 < ...$.
]

#proposicion[Convergencia de subsucesiones][
  Si $lim_(n -> oo) a_n = ell$, entonces toda subsucesión también converge a $ell$.
]

#demostracion[
  Sea $(a_(n_k))_(k in NN)$ una subsucesión de $(a_n)_(n in NN)$. Para probar que $a_(n_k) -> ell$, empezamos tomando $epsilon > 0$ y queremos encontrar $k_0$ tal que $abs(a_(n_k) - ell) < epsilon$ para todo $k >= k_0$.

  Sabemos que para este $epsilon$, como $a_n -> ell$ debe existir $n_0 in NN$ tal que

  $ abs(a_n - ell) < epsilon quad "para todo" n >= n_0. $

  Estamos tentados a elegir el mismo índice para la subsucesión. Sin embargo, no sabemos que $n_0$ sea uno de los índices elegidos dentro de nuestra subsucesión (por ejemplo, en el ejemplo que vimos antes donde la subsucesión era elegir todos los índices pares, podría ser que este $n_0$ sea un índice impar y por lo tanto no lo podríamos elegir). Pero lo que sí sabemos es que los índices elegidos por la subsucesión son infinitos y crecientes, por lo tanto, tiene que existir un índice $n_(k_0) > n_0$. Es decir, que hay un índice elegido por la subsucesión que sea más grande que $n_0$ (ojo, acá es fácil confundirse con la notación. Estamos hablando de los índices, no de los elementos de la sucesión).

  Elegido este $n_(k_0)$, lo que sabemos es que $n_k > n_(k_0)$ para todo $k > k_0$ y por lo tanto, $n_k > n_0$. Pero entonces

  $ abs(a_(n_k) - ell) < epsilon quad "para todo" k >= k_0, $

  que es lo que queríamos probar.
]

#definicion[Serie][
  Sea $(a_n)_(n in NN)$, llamamos *serie de $a_n$* (o sucesión de sumas parciales) a
  $ S_n = sum_(k=1)^n a_k. $
]

#definicion[Límite y Convergencia de Series][
  Sea $(a_n)_(n in NN) subset.eq RR$. Decimos que la serie $sum_(k=1)^oo a_k$ *converge* si existe $lim_(n -> oo) S_n$.

  En ese caso,
  $ sum_(k=1)^oo a_k = lim_(n -> oo) S_n. $
]

#proposicion[Condición necesaria de convergencia][
  Si $sum_(k=1)^oo a_k$ converge, entonces $a_n -> 0$.
]

#demostracion[
  Sabemos que $lim_(n -> oo) S_n = ell in RR$ y $ell = sum_(k=1)^oo a_k$.

  El $n$-ésimo término de la sucesión se puede escribir en función de las sumas parciales:
  $ a_n = S_n - S_(n-1). $

  Luego $lim_(n -> oo) (S_n - S_(n-1)) = 0$, entonces (demostrar esto queda como ejercicio) $lim_(n -> oo) a_n = 0$.
]

#proposicion[Álgebra de Series][
  #set enum(numbering: "a)")
  + Si $sum_(k=1)^oo a_k$ converge y $c in RR$, entonces $sum_(k=1)^oo (c a_k) = c sum_(k=1)^oo a_k$ y también converge.
  + Si $sum_(k=1)^oo a_k$ y $sum_(k=1)^oo b_k$ convergen, entonces $sum_(k=1)^oo (a_k + b_k) = sum_(k=1)^oo a_k + sum_(k=1)^oo b_k$ y también converge.
]

#proposicion[Convergencia de series de términos no negativos][
  Sea $a_n >= 0$ para todo $n in NN$, con $sum_(k=1)^oo a_k$ de forma tal que $(S_n)_(n >= 1)$ es una sucesión acotada, entonces $sum_(k=1)^oo a_k$ converge.
]

#demostracion[
  Notemos que $S_(n+1) = S_n + a_(n+1) >= S_n$, pues $a_n >= 0$ para todo $n in NN$. Por lo tanto, $(S_n)_(n >= 1)$ es monótona creciente. Como, además, está acotada, sabemos que es convergente.
]

#teorema[Criterio de Comparación][
  Sean $(a_n)_(n in NN), (b_n)_(n in NN) subset.eq RR$ tales que $0 <= a_n <= b_n$ para todo $n in NN$, vale lo siguiente:

  #set enum(numbering: "a)")
  + Si $sum_(k=1)^oo b_k$ converge, entonces $sum_(k=1)^oo a_k$ converge.
  + Si $sum_(k=1)^oo a_k$ diverge, entonces $sum_(k=1)^oo b_k$ diverge.
]

#definicion[Conjuntos Coordinables][3.1][
  Sean $X, Y$ dos conjuntos. Decimos que son *coordinables* si existe una función biyectiva $f : X -> Y$. Cuando esto ocurre, escribimos $X tilde.op Y$.
]

#proposicion[Relación de equivalencia][3.2][
  La relación $tilde.op$ es una relación de equivalencia.
]

#demostracion[
  Veamos que $tilde.op$ cumple las condiciones de relación de equivalencia:

  - *Reflexiva:* $X tilde.op X$ porque la identidad $op("id") : X -> X$ es biyectiva.
  - *Simétrica:* Si $X tilde.op Y$ entonces existe una función $f : X -> Y$ biyectiva. Pero si $f$ es biyectiva entonces su inversa $f^(-1) : Y -> X$ también lo es, lo que nos dice que $Y tilde.op X$.
  - *Transitiva:* Si $X tilde.op Y$ y $Y tilde.op Z$ entonces existen funciones $f : X -> Y$ y $g : Y -> Z$ biyectivas. Pero entonces $g compose f : X -> Z$ también lo es, lo que nos dice que $X tilde.op Z$.
]

#definicion[Cardinal de un Conjunto][3.5][
  El cardinal de un conjunto $X$ se define como la clase de equivalencia de los conjuntos coordinables con $X$:

  $ \#X = op("card")(X) := {Y : X tilde.op Y}. $
]

#definicion[Conjunto Finito, Infinito, Numerable y Contable][3.6][
  Un conjunto $A$ es:

  - *finito* si existe $n in NN$ y una biyección $f : {1, 2, ..., n} -> A$. En este caso, $\#A = n$.
  - *infinito* si no es finito. En otras palabras, $A$ no es coordinable con ningún conjunto finito.
  - *numerable* si existe una biyección $f : NN -> A$. En este caso se tiene que $\#A = aleph_0$.
  - *a lo sumo numerable* o *contable* si es finito o numerable.
]

#observacion[Enumeración de un Conjunto Numerable][3.7][
  Notemos que si $A$ es un conjunto numerable, entonces podemos hacer una lista de sus elementos. Es decir, si $f : {1, 2, ..., n} -> A$ es biyectiva y llamamos $a_n = f(n)$ entonces podemos describir a $A$ como la sucesión $A = (a_n)_(n in NN)$. En particular, esta sucesión tiene todos elementos distintos.
]

#definicion[Comparación y Orden entre Cardinales][3.8][
  Dados dos conjuntos $A$ y $B$, decimos que $\#A <= \#B$ si existe una función inyectiva $f : A -> B$.

  Además, decimos que $\#A < \#B$ si $\#A <= \#B$ pero $\#A != \#B$ (existe una función inyectiva de $A$ en $B$ pero no existe ninguna función biyectiva entre los conjuntos).
]

#proposicion[Caracterización de $<=$ vía sobreyecciones][3.9][
  Sean $A$ y $B$ conjuntos, con $A != nothing$. Entonces $\#A <= \#B$ si y sólo si existe una función sobreyectiva $g : B -> A$.
]

#observacion[Por qué pedimos $A != nothing$][
  La hipótesis $A != nothing$ no es un detalle técnico: sin ella el enunciado es falso. Tomemos $A = nothing$ y $B = {1}$. La función vacía $nothing -> B$ es (vacuamente) inyectiva, con lo cual $\#A <= \#B$. Sin embargo, no existe *ninguna* función $g : B -> nothing$ (habría que asignarle a $1$ un elemento de un conjunto sin elementos) y por lo tanto tampoco una sobreyectiva.

  En la demostración vamos a ver que la hipótesis se usa en un único lugar: para poder fijar un elemento $a' in A$ con el cual definir $g$ afuera de la imagen de $f$.
]

#estrategia[Ida: dar vuelta $f$ donde se pueda][
  Tenemos $f : A -> B$ inyectiva y queremos construir $g : B -> A$ sobreyectiva. La idea es *invertir $f$*: si $b$ está en la imagen de $f$, hay un único $a$ con $f(a) = b$ (acá se usa la inyectividad) y definimos $g(b) = a$. Los $b$ que sobran, los que no están en la imagen, los mandamos todos a un mismo $a' in A$ fijado de antemano (acá se usa $A != nothing$). La sobreyectividad sale sola, porque $g(f(a)) = a$.
]
#demostracion[$arrow.r.double$) Si $\#A <= \#B$ entonces existe $g : B -> A$ sobreyectiva][
  Como $\#A <= \#B$, existe $f : A -> B$ inyectiva. Fijemos además un elemento cualquiera $a' in A$, que existe porque $A != nothing$. Llamemos $f(A) = {f(a) : a in A} subset.eq B$ a la imagen de $f$ y definamos $g : B -> A$ separando en dos casos según $b$ esté o no en $f(A)$:

  #set enum(numbering: "a)")
  + Si $b in f(A)$, existe $a in A$ tal que $f(a) = b$; definimos $g(b) = a$.
  + Si $b in.not f(A)$, definimos $g(b) = a'$.

  *$g$ está bien definida.* Los dos casos son excluyentes y cubren todo $B$, así que a cada $b in B$ le estamos asignando algún valor. Falta ver que ese valor es único en el primer caso: si $b in f(A)$ y hubiera dos elementos $a, tilde(a) in A$ con $f(a) = b = f(tilde(a))$, por ser $f$ inyectiva tendríamos $a = tilde(a)$. Es decir, el $a$ del primer caso es único y $g(b)$ no depende de ninguna elección. Notemos que *éste es el único lugar de la ida donde usamos que $f$ es inyectiva*.

  *$g$ es sobreyectiva.* Sea $a in A$ y tomemos $b = f(a) in B$. Como $b in f(A)$, estamos en el primer caso de la definición y, por la unicidad que acabamos de probar, $g(b) = a$. Es decir, todo elemento de $A$ tiene una preimagen por $g$.
]

#estrategia[Vuelta: elegir una preimagen para cada elemento][
  Ahora tenemos $g : B -> A$ sobreyectiva y queremos $f : A -> B$ inyectiva. Para cada $a in A$ el conjunto de preimágenes $g^(-1)({a})$ es no vacío (eso *es* la sobreyectividad), así que podemos elegir un $b_a$ adentro y definir $f(a) = b_a$. Con esa definición $g compose f = op("id")_A$, y una función que admite inversa a izquierda tiene que ser inyectiva.
]
#demostracion[$arrow.l.double$) Si existe $g : B -> A$ sobreyectiva entonces $\#A <= \#B$][
  Como $g$ es sobreyectiva, para cada $a in A$ el conjunto $g^(-1)({a}) = {b in B : g(b) = a}$ es no vacío. Elegimos entonces, para cada $a in A$, un elemento $b_a in g^(-1)({a})$ y definimos

  $ f : A -> B, quad f(a) = b_a. $

  Vale la pena notar que esta elección simultánea de un $b_a$ para cada uno de los (posiblemente infinitos) $a in A$ es una aplicación del axioma de elección.

  Por construcción, $g(f(a)) = g(b_a) = a$ para todo $a in A$, es decir, $g compose f = op("id")_A$.

  Veamos que $f$ es inyectiva. Sean $a_1, a_2 in A$ tales que $f(a_1) = f(a_2)$. Aplicando $g$ a ambos miembros,

  $ a_1 = g(f(a_1)) = g(f(a_2)) = a_2. $

  Por lo tanto $f : A -> B$ es inyectiva y, por la Definición 3.8, $\#A <= \#B$.
]

#observacion[Buena Definición y Propiedades del Orden entre Cardinales][3.10][
  Tenemos que ver que $<=$ está bien definida, es decir que la relación no depende de los representantes elegidos (recordemos que la definición de cardinal involucra una clase de equivalencia). Es decir, tenemos que ver que si $\#A <= \#B$ y $A tilde.op X$, $B tilde.op Y$ entonces $\#X <= \#Y$. Como $\#A <= \#B$ sabemos que existe $f : A -> B$ inyectiva y como $A tilde.op X$ y $B tilde.op Y$ deben existir funciones $h : A -> X$ y $g : B -> Y$ biyectivas. Como la composición de funciones inyectivas resulta inyectiva, tenemos que $g compose f compose h^(-1) : X -> Y$ es también inyectiva, lo que nos dice que $\#X <= \#Y$.

  #block(breakable: false)[
    #align(center)[
      #cetz.canvas({
        import cetz.draw: *

        content((0, 2), [$A$], name: "A")
        content((3.5, 2), [$B$], name: "B")
        content((0, 0), [$X$], name: "X")
        content((3.5, 0), [$Y$], name: "Y")

        line("A", "B", mark: (end: ">"), stroke: 0.8pt)
        content((1.75, 2.35), text(size: 9pt)[$f$ (iny.)])

        line("A", "X", mark: (end: ">"), stroke: 0.8pt)
        content((-0.7, 1), text(size: 9pt)[$h$ (biy.)])

        line("B", "Y", mark: (end: ">"), stroke: 0.8pt)
        content((4.2, 1), text(size: 9pt)[$g$ (biy.)])

        line("X", "Y", mark: (end: ">"), stroke: (dash: "dashed", paint: rgb("#dc2626"), thickness: 0.9pt))
        content((1.75, -0.35), text(size: 9.5pt, fill: rgb("#dc2626"))[$g compose f compose h^(-1)$])
      })
    ]
  ]

  Nos gustaría ver también que $<=$ define una relación de orden entre los cardinales. Tenemos que:

  - *es reflexiva:* $\#A <= \#A$ vía $op("id") : A -> A$.
  - *es transitiva:* si $\#A <= \#B$ y $\#B <= \#C$ entonces tenemos funciones $f : A -> B$ y $g : B -> C$ inyectivas. Sabemos que la composición $g compose f : A -> C$ también es inyectiva, lo que nos dice que $\#A <= \#C$.

  Sin embargo, la *antisimetría* de la relación no es tan inmediata de probar y es el contenido del siguiente resultado.
]

#teorema[Cantor-Schröeder-Bernstein][3.11][
  Si existen funciones inyectivas $f : A -> B$ y $g : B -> A$, entonces existe una función biyectiva $h : A -> B$. Es decir, si $\#A <= \#B$ y $\#B <= \#A$ entonces $\#A = \#B$.
]

#proposicion[Subconjuntos de Conjuntos Numerables][3.13][
  Sea $A$ numerable. Si $nothing != B subset.eq A$, entonces $B$ es a lo sumo numerable.
]

#demostracion[
  Enumeramos a $A$ como en la Observación 3.7: $A = {a_1, a_2, a_3, dots}$. Tenemos dos opciones para $B$: es finito o es infinito. Si es finito, por definición es a lo sumo numerable. Nos queda ver que si es infinito entonces tiene que ser numerable. Para numerarlo, vamos a construir una función $g : NN -> B$ que mire la posición relativa de un elemento de $B$ en la lista enumerada de elementos de $A$. Es decir, definimos $g(1) = a_(j_1)$ donde $j_1 = op("mín"){j : a_j in B}$ (el primer elemento de $B$ que aparece listado en $A$). Como $B$ es infinito, $B != {a_(j_1)}$ y podemos definir $B_2 = B backslash {a_(j_1)}$. Definimos $g(2) = a_(j_2)$ donde $j_2 = op("mín"){j : a_j in B_2}$ (el segundo elemento de $B$ que aparece listado en $A$). Inductivamente construimos a la función $g$. Por construcción, $g$ es inyectiva. Además es sobreyectiva: si $b$ es algún elemento de $B$, tenemos que $b = a_n$ para algún $n in NN$ (pues $A$ es numerable). Pero esto nos dice que con nuestra función $g$ en a lo sumo $n$ pasos tenemos que haber llegado a $b$.
]

#proposicion[Todo Conjunto Infinito Contiene un Subconjunto Numerable][3.14][
  Si $A$ es infinito, entonces existe un subconjunto $B subset A$ tal que $B$ es numerable.
]

#demostracion[
  Sea $a_1 in A$ cualquiera. Como $A$ es infinito, sabemos que $A backslash {a_1}$ es no vacío (si lo fuera, estaríamos diciendo que $A = {a_1}$ y por lo tanto finito). Podemos elegir $a_2 in A backslash {a_1}$, es decir, podemos elegir un elemento de $A$ distinto de $a_1$. Este proceso lo podemos repetir, dado que ahora observamos que $A backslash {a_1, a_2} != nothing$. Inductivamente podemos construir una sucesión $(a_n)_(n in NN)$ de elementos distintos y tomando $B = {a_n : n in NN}$ tenemos lo que buscamos.
]

#observacion[Ideas Importantes y Minimalidad de $aleph_0$][
  De los resultados anteriores enfatizamos dos ideas importantes:

  - Los subconjuntos de conjuntos numerables son a lo sumo numerables (Proposición 3.13).
  - Todo conjunto infinito contiene un conjunto numerable (Proposición 3.14).

  Notemos que si $A$ y $B$ son conjuntos tales que $A subset.eq B$, tenemos que $\#A <= \#B$ ya que la inclusión $iota : A arrow.hook B$ es inyectiva. Por lo tanto, gracias a la Proposición 3.14, podemos concluir que si $A$ es un conjunto infinito, entonces $aleph_0 <= \#A$.

  Lo que podríamos preguntarnos es si existe algún conjunto infinito cuyo cardinal sea estrictamente mayor que $aleph_0$. La respuesta es que sí y eso es lo que vemos a continuación.
]

#proposicion[Numerabilidad de $QQ$][
  El conjunto de los números racionales es numerable. Es decir, $NN tilde.op QQ$ y por lo tanto
  $\#QQ = aleph_0$.
]

#teorema[No numerabilidad de $RR$][3.19][
  El conjunto de los números reales $RR$ no es numerable.
]

#demostracion[
  Supongamos que sí es numerable, es decir que existe $f : NN -> (0, 1)$ biyectiva. Esto quiere decir que con los números entre $0$ y $1$ podemos formar una lista ordenada $(x_n)_(n in NN)$. Tenemos que podemos escribir a estos números

  $
    x_1 &= 0, x_(11) x_(12) x_(13) x_(14) dots \
    x_2 &= 0, x_(21) x_(22) x_(23) x_(24) dots \
        & dots.v \
    x_n &= 0, x_(n 1) x_(n 2) x_(n 3) x_(n 4) dots \
        & dots.v
  $

  donde cada uno de los números $x_(n m) in {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}$, es decir, $(x_(n m))_m$ son los dígitos de $x_n$ en su desarrollo decimal. Sea $y in (0, 1)$ el número

  $ y = 0, y_1 y_2 y_3 dots quad "donde" y_i = cases(2 & "si" x_(i i) != 2, 3 & "si" x_(i i) = 2) $

  Vemos que $y$ es un número entre $0$ y $1$ que no pertenece a la lista anterior, dado que $y_n != x_(n n)$ por definición (lo cual nos dice que $y != x_n$ para todo $n in NN$). Esto contradice que la función $f$ que teníamos al principio sea biyectiva.
]

#observacion[Coordinabilidad de $RR$ con Intervalos][3.21][
  De hecho, podemos probar que $RR$ es coordinable con cualquier intervalo. Usando funciones parecidas a la del ejemplo anterior podemos probar que $RR tilde.op (a, b)$ donde $(a, b)$ es cualquier intervalo abierto (hacerlo como ejercicio). Pero además podemos ver que $RR$ es también coordinable con cualquier intervalo cerrado o semiabierto: si por ejemplo queremos ver que $RR tilde.op [a, b]$, podemos pensar que $RR tilde.op (a, b)$ y $(a, b) tilde.op [a, b]$ dado que $(a, b) = [a, b] backslash {a, b}$ y el ejercicio 3 de la guía nos dice que entonces $[a, b] tilde.op (a, b)$.
]

#definicion[Métrica y Espacio Métrico][4.1][
  Una métrica en un conjunto $M$ es una función $d : M times M -> RR$ que cumple las siguientes propiedades para todo $x, y, z in M$:

  #set enum(numbering: "(i)")
  + $d(x, y) >= 0$ para todo $x, y in M$.
  + $d(x, y) = 0$ si y sólo si $x = y$.
  + $d(x, y) = d(y, x)$ para todo $x, y in M$ (Simetría).
  + $d(x, z) <= d(x, y) + d(y, z)$ para todo $x, y, z in M$ (Desigualdad triangular).

  El par $(M, d)$ se denomina *espacio métrico*.
]

#definicion[Distancias en $RR^n$][][
  Sean $x = (x_1, dots, x_n)$ e $y = (y_1, dots, y_n)$ elementos de $RR^n$. Se definen las siguientes métricas:

  #set enum(numbering: "1.")
  + *Distancia euclídea ($d_2$):*
    $ d_2(x, y) = sqrt(sum_(i=1)^n (x_i - y_i)^2). $

  + *Distancia taxista ($d_1$):*
    $ d_1(x, y) = sum_(i=1)^n abs(x_i - y_i). $

  + *Distancia del máximo ($d_oo$):*
    $ d_oo (x, y) = max_(1 <= i <= n) abs(x_i - y_i). $

  #align(center)[
    #grid(
      columns: (1fr, 1fr, 1fr),
      gutter: 12pt,
      align: center + horizon,
      [
        #cetz.canvas({
          import cetz.draw: *
          line((0, 0), (2.8, 0), mark: (end: ">"), stroke: 0.8pt)
          content((3.0, 0), text(size: 8.5pt)[$x_1$])
          line((0, 0), (0, 2.5), mark: (end: ">"), stroke: 0.8pt)
          content((0, 2.7), text(size: 8.5pt)[$x_2$])

          let p1 = (0.6, 0.6)
          let p2 = (2.0, 1.8)
          circle(p1, radius: 0.07, fill: black)
          content((0.45, 0.45), text(size: 8.5pt)[$x$])
          circle(p2, radius: 0.07, fill: black)
          content((2.15, 1.95), text(size: 8.5pt)[$y$])

          line(p1, p2, stroke: 1.2pt + blue)
          content((1.2, 1.35), text(size: 8pt, fill: blue)[$d_2$])
          content((1.4, -0.4), text(size: 9pt)[Euclídea])
        })
      ],
      [
        #cetz.canvas({
          import cetz.draw: *
          line((0, 0), (2.8, 0), mark: (end: ">"), stroke: 0.8pt)
          content((3.0, 0), text(size: 8.5pt)[$x_1$])
          line((0, 0), (0, 2.5), mark: (end: ">"), stroke: 0.8pt)
          content((0, 2.7), text(size: 8.5pt)[$x_2$])

          let p1 = (0.6, 0.6)
          let p2 = (2.0, 1.8)
          let corner = (0.6, 1.8)
          circle(p1, radius: 0.07, fill: black)
          content((0.45, 0.45), text(size: 8.5pt)[$x_0$])
          circle(p2, radius: 0.07, fill: black)
          content((2.15, 1.95), text(size: 8.5pt)[$y$])

          line(p1, corner, stroke: 1.2pt + red)
          line(corner, p2, stroke: 1.2pt + red)
          content((0.2, 1.2), text(size: 7.5pt, fill: red)[$Delta x_2$])
          content((1.3, 2.05), text(size: 7.5pt, fill: red)[$Delta x_1$])
          content((1.4, -0.4), text(size: 9pt)[Taxista ($d_1$)])
        })
      ],
      [
        #cetz.canvas({
          import cetz.draw: *
          line((0, 0), (2.8, 0), mark: (end: ">"), stroke: 0.8pt)
          content((3.0, 0), text(size: 8.5pt)[$x_1$])
          line((0, 0), (0, 2.5), mark: (end: ">"), stroke: 0.8pt)
          content((0, 2.7), text(size: 8.5pt)[$x_2$])

          let p1 = (0.6, 0.8)
          let p2 = (2.1, 1.6)
          let corner = (2.1, 0.8)
          circle(p1, radius: 0.07, fill: black)
          content((0.45, 0.65), text(size: 8.5pt)[$x$])
          circle(p2, radius: 0.07, fill: black)
          content((2.2, 1.8), text(size: 8.5pt)[$y$])

          line(p1, corner, stroke: (dash: "dashed", paint: gray, thickness: 1pt))
          line(corner, p2, stroke: (dash: "dashed", paint: gray, thickness: 1pt))
          content((1.35, 0.55), text(size: 7.5pt)[$Delta x_1$ (máx)])
          content((2.45, 1.2), text(size: 7.5pt)[$Delta x_2$])
          content((1.4, -0.4), text(size: 9pt)[Máximo ($d_oo$)])
        })
      ]
    )
  ]
  #v(6pt)
]

#definicion[Distancias en espacios de funciones][][
  Un ejemplo importante que vamos a estudiar es el espacio de funciones continuas. Este se define como
  $ C([a, b]) = {f : [a, b] -> RR "funciones continuas"}. $

  Así como $RR^n$, este conjunto también admite más de una métrica. Vamos a destacar dos de ellas:

  #set enum(numbering: "1.")
  + *Distancia infinito:* Esta distancia se define de manera análoga a la distancia infinito en $RR^n$, y mide la diferencia más grande entre dos funciones $f$ y $g$:
    $ d_oo (f, g) = sup_(x in [a, b]) abs(f(x) - g(x)). $

    #block(breakable: false)[
    #align(center)[
    #cetz.canvas({
      import cetz.draw: *

      // f y g son bezier cúbicas simétricas respecto de x0 = (a_x + b_x)/2:
      // control points espejados garantizan que el extremo de cada curva
      // (el pico de f, el valle de g) caiga exactamente en x = x0.
      let a_x = 1.2
      let b_x = 5.4
      let x0 = (a_x + b_x) / 2
      let half = 1.3

      let f_end = 1.6
      let f_ctrl = 3.9
      let g_end = 0.7
      let g_ctrl = 0.05

      // Bezier cúbica evaluada en t = 0.5: (P0 + 3P1 + 3P2 + P3) / 8
      let y_f = (f_end + 3 * f_ctrl + 3 * f_ctrl + f_end) / 8
      let y_g = (g_end + 3 * g_ctrl + 3 * g_ctrl + g_end) / 8

      line((-0.5, 0), (6.5, 0), mark: (end: ">"), stroke: 0.8pt)
      content((6.7, 0), text(size: 9pt)[$x$])
      line((0, -0.4), (0, 3.5), mark: (end: ">"), stroke: 0.8pt)
      content((0, 3.7), text(size: 9pt)[$y$])

      line((a_x, -0.1), (a_x, 0.1), stroke: 1pt)
      content((a_x, -0.35), text(size: 9pt)[$a$])
      line((b_x, -0.1), (b_x, 0.1), stroke: 1pt)
      content((b_x, -0.35), text(size: 9pt)[$b$])

      bezier((a_x, f_end), (b_x, f_end), (x0 - half, f_ctrl), (x0 + half, f_ctrl), stroke: 1.2pt + blue)
      content((b_x + 0.2, f_end), text(fill: blue, size: 10pt)[$f$])

      bezier((a_x, g_end), (b_x, g_end), (x0 - half, g_ctrl), (x0 + half, g_ctrl), stroke: 1.2pt + red)
      content((b_x + 0.2, g_end), text(fill: red, size: 10pt)[$g$])

      line((x0, 0), (x0, y_g), stroke: (dash: "dashed", paint: gray, thickness: 0.8pt))
      content((x0, -0.35), text(size: 8.5pt)[$x_0$])
      line((x0, y_g), (x0, y_f), mark: (start: ">", end: ">"), stroke: 1pt + black)
      content((x0 + 0.9, (y_f + y_g)/2), text(size: 9pt)[$d_oo (f, g)$])
    })
    ]
    ]

  + *Distancia 1:* Otra manera de pensar qué tan cerca está una función de otra es medir el área entre los gráficos de las funciones. Esta es la definición de la distancia uno:
    $ d_1(f, g) = integral_a^b abs(f(x) - g(x)) dif x. $

    #block(breakable: false)[
    #align(center)[
    #cetz.canvas({
      import cetz.draw: *
      line((-0.5, 0), (6.5, 0), mark: (end: ">"), stroke: 0.8pt)
      content((6.7, 0), text(size: 9pt)[$x$])
      line((0, -0.4), (0, 3.5), mark: (end: ">"), stroke: 0.8pt)
      content((0, 3.7), text(size: 9pt)[$y$])

      line((1.2, -0.1), (1.2, 0.1), stroke: 1pt)
      content((1.2, -0.35), text(size: 9pt)[$a$])
      line((5.4, -0.1), (5.4, 0.1), stroke: 1pt)
      content((5.4, -0.35), text(size: 9pt)[$b$])

      merge-path(fill: rgb("#e0e7ff"), stroke: none, {
        line((1.2, 0.4), (1.2, 2.0))
        bezier((1.2, 2.0), (5.4, 2.8), (2.0, 2.6), (3.8, 1.9))
        line((5.4, 2.8), (5.4, 0.9))
        bezier((5.4, 0.9), (1.2, 0.4), (3.8, 0.5), (2.5, 0.8))
      })

      bezier((1.2, 2.0), (5.4, 2.8), (2.0, 2.6), (3.8, 1.9), stroke: 1.2pt + blue)
      content((5.6, 2.8), text(fill: blue, size: 10pt)[$f$])

      bezier((1.2, 0.4), (5.4, 0.9), (2.5, 0.8), (3.8, 0.5), stroke: 1.2pt + red)
      content((5.6, 0.9), text(fill: red, size: 10pt)[$g$])

      line((1.2, 0.4), (1.2, 2.0), stroke: 0.5pt + rgb("#6366f1"))
      line((5.4, 0.9), (5.4, 2.8), stroke: 0.5pt + rgb("#6366f1"))

      content((3.3, 1.4), text(size: 9.5pt)[$#"Área" = d_1(f, g)$])
    })
    ]
    ]
]

#observacion[Comparación entre $d_1$ y $d_oo$ en $C([0, 1])$][4.4][
  La distancia uno y la distancia infinito en el espacio de funciones continuas miden "muy distinto". Consideremos el siguiente ejemplo: pensemos en el conjunto
  $ C([0, 1]) = {f : [0, 1] -> RR "funciones continuas"} $
  y dentro de este conjunto tomemos a las funciones $f(x) = 0$ (la función constantemente cero) y $g_epsilon$ la función continua que vale $0$ en todo el intervalo $[0, 1/2 - epsilon) union (1/2 + epsilon, 1]$, $1$ en $x = 1/2$ y es lineal en el intervalo $[1/2 - epsilon, 1/2 + epsilon]$. Es decir, la función $g_epsilon$ es la función que se ve como en el siguiente diagrama:

  #block(breakable: false)[
  #align(center)[
    #cetz.canvas({
      import cetz.draw: *
      line((-0.5, 0), (6.5, 0), mark: (end: ">"), stroke: 0.8pt)
      content((6.7, 0), text(size: 9pt)[$x$])
      line((0, -0.4), (0, 3.2), mark: (end: ">"), stroke: 0.8pt)
      content((0, 3.4), text(size: 9pt)[$y$])

      let x_mid = 3.0
      let eps = 0.8
      let y_top = 2.4

      line((-0.1, y_top), (0.1, y_top), stroke: 1pt)
      content((-0.3, y_top), text(size: 9pt)[$1$])
      line((0, y_top), (x_mid, y_top), stroke: (dash: "dashed", paint: gray, thickness: 0.8pt))

      line((0, -0.1), (0, 0.1), stroke: 1pt)
      content((-0.2, -0.3), text(size: 9pt)[$0$])
      line((5.5, -0.1), (5.5, 0.1), stroke: 1pt)
      content((5.5, -0.3), text(size: 9pt)[$1$])

      line((x_mid - eps, -0.1), (x_mid - eps, 0.1), stroke: 0.8pt)
      content((x_mid - eps, -0.35), text(size: 8pt)[$1/2 - epsilon$])
      line((x_mid, -0.1), (x_mid, 0.1), stroke: 0.8pt)
      content((x_mid, -0.35), text(size: 8.5pt)[$1/2$])
      line((x_mid + eps, -0.1), (x_mid + eps, 0.1), stroke: 0.8pt)
      content((x_mid + eps, -0.35), text(size: 8pt)[$1/2 + epsilon$])

      line((x_mid, 0), (x_mid, y_top), stroke: (dash: "dashed", paint: gray, thickness: 0.8pt))

      merge-path(fill: rgb("#e0e7ff"), stroke: none, {
        line((x_mid - eps, 0), (x_mid, y_top))
        line((x_mid, y_top), (x_mid + eps, 0))
        line((x_mid + eps, 0), (x_mid - eps, 0))
      })

      line((0, 0), (x_mid - eps, 0), stroke: 1.4pt + blue)
      line((x_mid - eps, 0), (x_mid, y_top), stroke: 1.4pt + blue)
      line((x_mid, y_top), (x_mid + eps, 0), stroke: 1.4pt + blue)
      line((x_mid + eps, 0), (5.5, 0), stroke: 1.4pt + blue)

      content((x_mid + 0.5, y_top + 0.25), text(fill: blue, size: 9.5pt)[$g_epsilon (x)$])
      line((4.2, 1.4), (x_mid + 0.1, 0.7), mark: (end: ">"), stroke: 0.8pt)
      content((4.8, 1.5), text(size: 9pt)[$#"Área" = epsilon$])
    })
  ]
  ]

  Por un lado, observamos que la distancia infinito $d_oo (f, g_epsilon) = 1$, independientemente de qué tan chico tomemos al parámetro $epsilon$ (puesto que por diseño, la función $g_epsilon$ siempre va a tomar el valor $1$ en $x = 1/2$). Sin embargo, cuando calculamos la distancia uno entre estas dos funciones, tenemos que el área bajo la curva de $g_epsilon$ se puede pensar como el área del triángulo de base $2 epsilon$ y altura $1$: $d_1(f, g_epsilon) = epsilon$. Es decir, si tomamos el parámetro $epsilon$ cada vez más chico, nos queda que las funciones en distancia uno están cada vez más cerca, mientras que si medimos su distancia en la distancia infinito nos queda constantemente $1$.
]

#definicion[Bolas y Esfera][4.5][
  Sea $(M, d)$ un espacio métrico, $x_0 in M$ y $r > 0$. Definimos:

  - *Bola abierta:* $B(x_0, r) = {y in M : d(x_0, y) < r}$.
  - *Bola cerrada:* $B[x_0, r] = {y in M : d(x_0, y) <= r}$.
  - *Esfera:* $S(x_0, r) = {y in M : d(x_0, y) = r}$.
]

#definicion[Conjunto Acotado][4.8][
  #block(breakable: false)[
  Sea $(M, d)$ un espacio métrico. Un conjunto $E subset.eq M$ es *acotado* si existe $C > 0$ tal que $d(x, y) <= C$ para todo $x, y in E$. Equivalentemente, si existe $x_0 in M$ y $R > 0$ tal que $E subset.eq B(x_0, R)$.

  #align(center)[
    #cetz.canvas({
      import cetz.draw: *
      line((-2.2, 0), (2.2, 0), mark: (end: ">"), stroke: 0.8pt)
      content((2.35, 0), text(size: 8pt)[$x$])
      line((0, -2.0), (0, 2.0), mark: (end: ">"), stroke: 0.8pt)
      content((0, 2.15), text(size: 8pt)[$y$])

      let c = (0.2, 0.1)
      circle(c, radius: 1.5, fill: none, stroke: (dash: "dashed", paint: gray, thickness: 1pt))
      circle(c, radius: 0.04, fill: black)
      content((c.at(0), c.at(1) - 0.25), text(size: 8pt)[$x_0$])

      let ang = 40deg
      line(c, (c.at(0) + 1.5 * calc.cos(ang), c.at(1) + 1.5 * calc.sin(ang)), stroke: 0.7pt)
      content((1.15, 0.85), text(size: 8pt)[$R$])

      hobby((-0.5, 0.6), (-0.1, 1.0), (0.5, 0.85), (0.75, 0.35), (0.55, -0.25), (0.0, -0.45), (-0.55, -0.2), (-0.75, 0.2), close: true, fill: rgb("#ede9fe"), stroke: 1.1pt + rgb("#7c3aed"))
      content((0.1, 0.25), text(size: 9pt, fill: rgb("#7c3aed"))[$E$])

      content((c.at(0), 1.85), text(size: 8.5pt, fill: gray)[$B(x_0, R)$])
    })
  ]
  #align(center)[
    #text(size: 8.5pt, style: "italic", fill: rgb("#64748b"))[
      (Esquema ilustrativo de un conjunto acotado $E$ cualquiera --- invención propia, no está en la fuente.)
    ]
  ]
  ]
]

#definicion[Diámetro][4.9][
  Si $E$ es acotado, su *diámetro* se define como:
  $ op("diam")(E) = sup {d(x, y) : x, y in E}. $
]

#definicion[Punto Interior][4.11][
  #block(breakable: false)[
  Sea $(M, d)$ un espacio métrico, $E subset.eq M$ y $x in E$. Decimos que $x$ es un *punto interior* de $E$ si existe un radio $r > 0$ tal que $B(x, r) subset.eq E$. Es decir, que $x$ es un punto interior si podemos encontrar una bolita abierta centrada en $x$ que se quede completamente contenida dentro del conjunto.

  En este gráfico podemos ver que $x$ es un punto interior de $E$, mientras que $y$ no lo es ya que cualquier bolita centrada en $y$ interseca al complemento de $E$.

  #align(center)[
    #cetz.canvas({
      import cetz.draw: *

      let blob = ((-1.6, 0.2), (-1.1, 1.1), (-0.1, 1.3), (1.0, 1.0), (1.5, 0.2), (1.3, -0.7), (0.2, -1.1), (-0.9, -0.9), (-1.7, -0.3))
      hobby(..blob, close: true, fill: rgb("#f1f5f9"), stroke: 1pt + black)
      content((0.6, 1.0), text(size: 10pt)[$E$])

      let xp = (-0.3, 0.1)
      let rx = 0.5
      circle(xp, radius: rx, fill: none, stroke: (dash: "dashed", paint: blue, thickness: 1pt))
      circle(xp, radius: 0.035, fill: black)
      content((xp.at(0), xp.at(1) + 0.22), text(size: 9pt)[$x$])
      let ang = 55deg
      line(xp, (xp.at(0) + rx * calc.cos(ang), xp.at(1) + rx * calc.sin(ang)), stroke: 0.6pt + blue)
      content((xp.at(0) + 0.35, xp.at(1) + 0.4), text(size: 8pt, fill: blue)[$r$])
      content((xp.at(0), xp.at(1) - rx - 0.2), text(size: 8.5pt, fill: blue)[$B(x, r) subset.eq E$])

      let yp = (1.5, 0.2)
      circle(yp, radius: 0.42, fill: none, stroke: (dash: "dashed", paint: red, thickness: 1pt))
      circle(yp, radius: 0.035, fill: black)
      content((yp.at(0) + 0.2, yp.at(1) + 0.12), text(size: 9pt)[$y$])
      content((yp.at(0) + 0.05, yp.at(1) - 0.55), text(size: 8pt, fill: red)[*no* es interior])
    })
  ]

  El *interior* de $E$ está formado por todos los puntos interiores de $E$ y lo notamos $E^compose$. Es decir,
  $ E^compose = {x in E : x "es punto interior de" E}. $
  ]
]

#observacion[$E^compose subset.eq E$, inclusión posiblemente estricta][4.12][
  Por definición, sabemos que $E^compose subset.eq E$ pero la inclusión puede ser estricta.
]

#definicion[Conjunto Abierto][4.14][
  Sea $(M, d)$ un espacio métrico. Decimos que $A subset.eq M$ es *abierto* si $A = A^compose$.
]

#teorema[Unión arbitraria de abiertos es abierta][4.17][
  Sea $(M, d)$ un espacio métrico. Sea $(A_i)_(i in I)$ una familia de conjuntos abiertos (acá podríamos tomar una cantidad arbitraria, finita o infinita, numerable o no, de conjuntos). Entonces $A = union.big_(i in I) A_i$ es abierto.
]
#demostracion[
  Sea $x in A$. Para ver que $A$ es abierto, nos alcanza con encontrar un radio $r > 0$ tal que $B(x, r) subset.eq A$. Como $x in A$, existe un índice $i in I$ tal que $x in A_i$. Como $A_i$ es abierto, sabemos que tiene que existir un $r > 0$ tal que $B(x, r) subset.eq A_i$. Pero como $A_i subset.eq A$, tenemos que $B(x, r) subset.eq A$.
]

#teorema[Intersección finita de abiertos es abierta][4.18][
  Sea $(M, d)$ un espacio métrico. Sean $A_1, dots, A_n$ conjuntos abiertos. Entonces $A = inter.big_(i=1)^n A_i$ es abierto.
]
#demostracion[
  Sea $x in A$. Para ver que $A$ es abierto, debemos encontrar un radio $r > 0$ tal que $B(x, r) subset.eq A$. Como $A = inter.big_(i=1)^n A_i$, sabemos que para todo $i = 1, dots, n$, $x in A_i$. Como $A_i$ es abierto, existe un radio $r_i > 0$ tal que $B(x, r_i) subset.eq A_i$. Como queremos que la bola esté contenida en la intersección de los conjuntos, queremos encontrar la bolita alrededor de $x$ más chica entre $B(x, r_1), dots, B(x, r_n)$. Tomemos $r = op("mín"){r_1, r_2, dots, r_n}$. Como tenemos una cantidad finita de radios, sabemos que $r > 0$ (porque es uno de los radios que ya teníamos). Observemos que, para cada $i = 1, dots, n$,
  $ B(x, r) = {y in M : d(x, y) < r} subset.eq {y in M : d(x, y) < r_i} = B(x, r_i) subset.eq A_i. $
  Esto nos dice que $B(x, r) subset.eq A_i$ para todo $i = 1, dots, n$, lo cual nos dice que $B(x, r) subset.eq inter.big_(i=1)^n A_i = A$.
]

#observacion[El teorema anterior no vale para infinitos abiertos][4.19][
  El teorema anterior no vale si tomamos infinitos conjuntos abiertos $A_i$. Consideremos el siguiente ejemplo: sea $(M, d) = (RR, abs(dot.c))$ y sean $A_n = (-1/n, 1/n)$. Al ser $A_n = B(0, 1/n)$, sabemos que $A_n$ es abierto para cada $n in NN$ porque probamos que las bolas abiertas son conjuntos abiertos en cualquier espacio métrico. Sin embargo,
  $ A = inter.big_(n in NN) (-1/n, 1/n) = {0}. $
  Queda como ejercicio probar que este conjunto no es abierto.
]

#proposicion[El interior es el abierto más grande contenido en $E$][4.21][
  Sea $(M, d)$ un espacio métrico y sea $E subset.eq M$ un subconjunto. Sea $A subset.eq E$ un conjunto abierto. Entonces $A subset.eq E^compose$. Es decir, el interior es el conjunto abierto más grande contenido dentro de $E$.
]
#demostracion[
  Sea $x in A$. Como $A$ es abierto, existe un $r > 0$ tal que $B(x, r) subset.eq A subset.eq E$. Esto nos dice que $B(x, r) subset.eq E$, lo cual es la definición de punto interior. Esto nos dice que $x in E^compose$, que es lo que queríamos ver.
]

#definicion[Punto de Adherencia y Clausura][4.22][
  #block(breakable: false)[
  Sea $(M, d)$ un espacio métrico, $E subset.eq M$ un subconjunto. Un punto $x in M$ se dice *de adherencia* de $E$ si para todo radio $r > 0$ se tiene que $B(x, r) inter E != nothing$.

  #align(center)[
    #cetz.canvas({
      import cetz.draw: *

      let blob = ((-2.1, 0.3), (-1.4, 1.4), (-0.1, 1.7), (1.3, 1.3), (2.0, 0.3), (1.7, -0.9), (0.3, -1.4), (-1.2, -1.2), (-2.2, -0.4))
      hobby(..blob, close: true, fill: rgb("#f1f5f9"), stroke: (dash: "dashed", paint: black, thickness: 1pt))
      content((1.0, 1.55), text(size: 10pt)[$E$])

      let zp = (-0.8, 0.1)
      circle(zp, radius: 0.42, fill: none, stroke: (dash: "dashed", paint: red, thickness: 1pt))
      circle(zp, radius: 0.03, fill: black)
      content((zp.at(0), zp.at(1) - 0.62), text(size: 9pt)[$z$])

      let xp = (1.85, -0.35)
      circle(xp, radius: 0.55, fill: rgb("#fecaca"), stroke: (dash: "dashed", paint: red, thickness: 1pt))
      circle(xp, radius: 0.03, fill: black)
      content((xp.at(0) - 0.9, xp.at(1) + 0.45), text(size: 9pt, fill: red)[$B(x, r)$])
      content((xp.at(0), xp.at(1) - 0.8), text(size: 9pt)[$x$])

      line((-3.0, 1.0), (zp.at(0) - 0.45, zp.at(1) + 0.3), stroke: 0.6pt, mark: (end: ">"))
      content((-3.0, 1.25), text(size: 8.5pt)[$B(z, r) inter E != nothing$])

      line((3.1, 0.75), (xp.at(0) + 0.4, xp.at(1) + 0.4), stroke: 0.6pt, mark: (end: ">"))
      content((3.2, 1.0), text(size: 8.5pt)[$B(x, r) inter E != nothing$])
    })
  ]

  Al conjunto de todos los puntos de adherencia de $E$ lo llamamos la *clausura* de $E$ y lo denotamos $overline(E)$. Es decir,
  $ overline(E) = {x in M : "para todo " r > 0, B(x, r) inter E != nothing}. $
  ]
]

#observacion[][4.23][
  #set enum(numbering: "a)")
  + Todos los puntos de $E$ son puntos de adherencia. Dado $x in E$, tenemos que $B(x, r) inter E$ contiene, al menos, al punto $x$: esto nos dice que es punto de adherencia. Es decir, $E subset.eq overline(E)$.
  + Con lo que acabamos de observar y teniendo en cuenta la Observación 4.12, tenemos que
    $ E^compose subset.eq E subset.eq overline(E). $
]

#definicion[Conjunto Cerrado][4.27][
  Sea $(M, d)$ un espacio métrico y sea $F subset.eq M$. Decimos que $F$ es *cerrado* si $overline(F) = F$.
]

#teorema[Cerrados vía complemento abierto][4.29][
  $F$ es un conjunto cerrado si y sólo si $F^c$ es un conjunto abierto.
]
#demostracion[
  *($arrow.r.double$)* Veamos que $F^c$ es un conjunto abierto. Sea $x in F^c$. Queremos ver que existe un radio $r > 0$ tal que $B(x, r) subset.eq F^c$. Si esto no pasa, tendríamos entonces que $B(x, r) subset.eq.not F^c$ para todo $r > 0$. Esto nos dice que $B(x, r) inter F != nothing$ para todo $r > 0$. Pero esto es lo mismo que decir que $x in overline(F)$ y $overline(F) = F$ por hipótesis ($F$ es cerrado). Esto es absurdo.

  *($arrow.l.double$)* Supongamos que $F^c$ es abierto y veamos que $F = overline(F)$. Recordemos que nos alcanza con ver que $overline(F) subset.eq F$. Sea $x in overline(F)$. Si $x in.not F$, como $F^c$ es un conjunto abierto, tiene que existir un $r > 0$ tal que $B(x, r) subset.eq F^c$. Es decir, $B(x, r) inter F = nothing$ y esto es absurdo, dado que $x in overline(F)$.
]

#teorema[Intersección arbitraria y unión finita de cerrados][4.31][
  Sea $(M, d)$ un espacio métrico. Entonces:

  #set enum(numbering: "a)")
  + Si ${F_i}_(i in I)$ es una familia de conjuntos cerrados, entonces $F = inter.big_(i in I) F_i$ es cerrado.
  + Si ${F_i}_(i=1)^n$ son conjuntos cerrados, entonces $F = union.big_(i=1)^n F_i$ es cerrado.
]
#demostracion[
  Para probar ambos enunciados sólo tenemos que observar que
  $ (inter.big_(i in I) F_i)^c = union.big_(i in I) F_i^c, quad (union.big_(i=1)^n F_i)^c = inter.big_(i=1)^n F_i^c. $
  Por los teoremas 4.17 y 4.18, tenemos lo que queríamos probar.
]

#observacion[$QQ$ no es ni abierto ni cerrado en $RR$][4.32][
  Muchas veces pensamos que cerrado es lo contrario de abierto. Y tiene sentido, porque tenemos cierta dualidad entre los conceptos: un conjunto es abierto si y sólo si su complemento es cerrado o un conjunto es cerrado si y sólo si su complemento es abierto. Pero esto no quiere decir que sólo existan estas dos opciones: que un conjunto *no sea abierto no significa que sea cerrado* necesariamente.

  Hay muchos ejemplos de conjuntos que no son ni cerrados ni abiertos (pensá a ver si se te ocurre alguno). Uno de esos ejemplos es el conjunto de los números racionales $QQ subset.eq (RR, abs(dot.c))$.

  - $overline(QQ) = RR$: Si $x in RR$, $B(x, r) = (x - r, x + r)$. Como sabemos que cualquier intervalo abierto contiene números racionales, sabemos que $(x-r, x+r) inter QQ != nothing$ y por lo tanto $x in overline(QQ)$. Esto nos dice que $QQ$ no es cerrado.
  - $QQ^compose = emptyset$: sea $x in QQ$. Como $B(x, r) = (x - r, x + r)$ contiene números irracionales, tenemos que $B(x, r) inter QQ^c != nothing$ para todo $r > 0$. Esto nos dice que $B(x, r) subset.eq.not QQ$ para ningún $r > 0$, con lo cual $x in.not QQ^compose$. En particular, esto nos dice que $QQ$ tampoco es abierto.
]

#definicion[Punto de Acumulación y Conjunto Derivado][4.33][
  Sea $(M, d)$ un espacio métrico, $E subset.eq M$. Decimos que $x$ es un *punto de acumulación* de $E$ si para todo radio $r > 0$ tenemos que existe un $y in B(x, r) inter E$ con $y != x$.

  Definimos el *conjunto derivado* de $E$ como
  $ E' = {x in M : x "es punto de acumulación"}. $
]

#proposicion[Clausura como unión con el conjunto derivado][4.36][
  Sea $(M, d)$ un espacio métrico, $E subset.eq M$. Entonces $overline(E) = E union E'$.
]
#demostracion[
  Como sabemos que $E' subset.eq overline(E)$ y también $E subset.eq overline(E)$, nos alcanza con probar la otra inclusión.

  Sea $x in overline(E)$ y supongamos que $x in.not E$. Como $x$ es punto de adherencia, sabemos que para todo $r > 0$, $B(x, r) inter E != nothing$. Pero como $x in.not E$, tenemos que $x in.not B(x, r) inter E$. Como este conjunto es no vacío, tenemos que existe $y in B(x, r) inter E$ con $y != x$, es decir, $x in E'$.
]

#corolario[Cerrados vía puntos de acumulación][4.37][
  $E$ es un conjunto cerrado si y sólo si todos los puntos de acumulación de $E$ pertenecen a $E$, es decir, $E' subset.eq E$.
]
#demostracion[
  Recordemos que $E$ es cerrado si $overline(E) = E$. Tenemos que
  $ overline(E) = E union E' = E <=> E' subset.eq E, $
  como queríamos ver.
]

#definicion[Punto de Frontera y Frontera de un Conjunto][4.38][
  #block(breakable: false)[
  Sea $(M, d)$ un espacio métrico, $E subset.eq M$. Decimos que $x$ es un *punto de frontera* de $E$ si para todo $r > 0$, $B(x, r) inter E != nothing$ y $B(x, r) inter E^c != nothing$.

  Al conjunto de los puntos de frontera lo llamamos la *frontera* de $E$ y lo notamos
  $ partial E = {x in M : x "es punto de frontera de" E}. $

  #align(center)[
    #cetz.canvas({
      import cetz.draw: *

      let blob = ((-2.1, 0.3), (-1.4, 1.4), (-0.1, 1.7), (1.3, 1.3), (2.0, 0.3), (1.7, -0.9), (0.3, -1.4), (-1.2, -1.2), (-2.2, -0.4))
      hobby(..blob, close: true, fill: rgb("#e2e8f0"), stroke: (paint: black, thickness: 1pt))
      content((-1.1, 0), text(size: 10pt)[$E$])
      content((1.75, 1.55), text(size: 9pt)[$E^c$])

      let xp = (1.55, 0.25)
      circle(xp, radius: 0.55, fill: rgb("#dbeafe"), stroke: (dash: "dashed", paint: red, thickness: 1pt))
      circle(xp, radius: 0.03, fill: black)
      content((xp.at(0) - 0.15, xp.at(1) + 0.75), text(size: 9pt, fill: red)[$B(x, r)$])
      content((xp.at(0) + 0.45, xp.at(1) - 0.05), text(size: 8.5pt)[$x in partial E$])

      line((3.1, 0.9), (xp.at(0) + 0.35, xp.at(1) + 0.35), stroke: 0.6pt, mark: (end: ">"))
      content((3.35, 1.15), text(size: 8pt)[Intersección con $E^c$])
      content((3.35, 0.9), text(size: 8pt)[$(B(x,r) inter E^c != nothing)$])

      line((0.2, -1.9), (xp.at(0) - 0.35, xp.at(1) - 0.35), stroke: 0.6pt, mark: (end: ">"))
      content((0.35, -2.15), text(size: 8pt)[Intersección con $E$])
      content((0.35, -2.4), text(size: 8pt)[$(B(x,r) inter E != nothing)$])
    })
  ]
  ]
]

#proposicion[Clausura como unión con la frontera][4.40][
  Sea $(M, d)$ un espacio métrico y $E subset.eq M$. Entonces $overline(E) = E union partial E$.
]
#demostracion[
  Al igual que en la proposición anterior, no es difícil ver que $partial E subset.eq overline(E)$, dado que a los puntos de frontera les estamos pidiendo que pertenezcan a la clausura y *algo más*. Además, claramente $E subset.eq overline(E)$, con lo cual nos sale que $partial E union E subset.eq overline(E)$. Veamos la otra contención.

  Sea $x in overline(E)$. Si $x in.not E$, entonces sabemos que para todo $r > 0$, tenemos que por un lado $B(x, r) inter E != nothing$ (porque $x in overline(E)$) y por otro lado $B(x, r) inter E^c != nothing$ (porque $x in.not E$). Pero esto nos dice que $x in partial E$ por definición.
]

#definicion[Sucesión y Convergencia][4.42][
  Sea $(M, d)$ un espacio métrico. Una *sucesión* en $(M, d)$ es una función $f: NN -> M$. Usamos la notación $x_n = f(n)$ para referirnos al $n$-ésimo término de la sucesión y $(x_n)_(n in NN)$ para referirnos a la sucesión entera. Al igual que con sucesiones de números reales, podemos pensar a una sucesión como una lista ordenada, donde en vez de poner números en nuestra lista, ahora ponemos objetos de nuestro espacio métrico.

  Decimos que $(x_n)_(n in NN)$ *converge* a $x in M$ (y usamos la notación $x_n -> x$ o $lim_(n -> oo) x_n = x$) si para todo $epsilon > 0$ existe un $n_0 in NN$ tal que
  $ d(x_n, x) < epsilon, quad "para todo " n >= n_0. $
]

#observacion[][4.43][
  Si tenemos una sucesión $(x_n)_(n in NN) subset.eq M$ y $x in M$, entonces podemos formar la sucesión de las distancias de $x_n$ a $x$, $d(x_n, x) in RR_(>= 0)$. Por definición de convergencia en $RR$, tenemos que
  $ x_n -> x quad ("en " M) quad <=> quad d(x_n, x) -> 0 quad ("en " RR). $
]

#proposicion[Clausura y conjunto derivado vía sucesiones][4.46][
  Sea $(M, d)$ un espacio métrico, y sean $E subset.eq M$ y $x in M$. Entonces
  #set enum(numbering: "a)")
  + $x in overline(E)$ si y sólo si existe una sucesión $(x_n)_(n in NN) subset.eq E$ tal que $x_n -> x$.
  + $x in E'$ si y sólo si existe una sucesión $(x_n)_(n in NN) subset.eq E$ tal que $x_n != x$ para todo $n in NN$ y además $x_n -> x$. Más aún, esta sucesión se puede elegir de forma tal que sus términos sean todos distintos entre sí (y distintos de $x$).
]
#demostracion[
  Veamos las dos afirmaciones. Como ambas involucran una doble implicación, en ambas vamos a hacer las dos implicaciones por separado.

  #set enum(numbering: "a)")
  + $(arrow.double.r)$ Supongamos que $x in overline(E)$ y veamos que podemos construir una sucesión $(x_n)_(n in NN) subset.eq E$ tal que $x_n -> x$. Como $x in overline(E)$, sabemos que para todo $r > 0$, $B(x, r) inter E != nothing$. Si tomamos $r = 1/n > 0$, sabemos que tiene que existir un $x_n in B(x, 1\/n) inter E$. Veamos que esta sucesión cumple lo que queremos: por un lado, $x_n in E$ (porque está en la intersección) y por el otro, como $x_n in B(x, 1\/n)$, tenemos
    $ d(x_n, x) < 1/n -> 0. $
    Como además la distancia es siempre no negativa, esto nos dice que $d(x_n, x) -> 0$ y como observamos antes, esto es lo mismo que $x_n -> x$.

    $(arrow.double.l)$ Supongamos que existe $(x_n)_(n in NN) subset.eq E$ tal que $x_n -> x$. Veamos que $x in overline(E)$. Para esto, tomemos un $r > 0$ y veamos que $B(x, r) inter E != nothing$. Como sabemos que $x_n -> x$, para $r > 0$ debe existir un $n_0 in NN$ tal que $d(x_n, x) < r$ para todo $n >= n_0$. Pero esto es lo mismo que decir que $x_n in B(x, r)$ para todo $n >= n_0$. Por otro lado, también sabemos que $(x_n)_(n in NN) subset.eq E$, con lo cual $x_n in B(x, r) inter E$ para todo $n >= n_0$. En particular, $B(x, r) inter E != nothing$.

  + $(arrow.double.r)$ Supongamos que $x in E'$ y construyamos la sucesión $(x_n)_(n in NN)$ de la siguiente manera: comenzamos tomando $r = 1$ y elegimos $x_1 in B(x, 1) inter E$, con $x_1 != x$ (que existe por hipótesis). Para elegir $x_2$ que sea distinto de $x_1$ y de $x$, vamos a tomar ahora $r = min(1\/2, d(x_1, x)) > 0$ puesto que $x_1 != x$. Elegimos entonces $x_2 in B(x, r) inter E$ con $x_2 != x$. Además, vemos que
    $ d(x_2, x) < r <= d(x_1, x), $
    lo que nos dice que $x_2 != x_1$ (si fueran iguales, tendrían la misma distancia a $x$). Sucesivamente vamos a ir eligiendo $x_n in B(x, r) inter E$ con $x_n != x$ y $r = min(1\/n, d(x_(n-1), x)) > 0$. En particular, por como construimos los $x_n$, tenemos que
    $ d(x_n, x) < d(x_(n-1), x) < dots.c < d(x_2, x) < d(x_1, x), $
    lo cual nos dice que los $x_n$ son todos distintos entre sí como queríamos. Por construcción, la sucesión $(x_n)_(n in NN) subset.eq E$.

    Además, tenemos que
    $ d(x_n, x) < r <= 1/n -> 0, $
    y como vimos antes, esto nos dice que $x_n -> x$.

    $(arrow.double.l)$ Sea $(x_n)_(n in NN) subset.eq E$ tal que $x_n != x$ para todo $n$ y $x_n -> x$. Veamos que $x in E'$. Para esto, tomemos $r > 0$ un radio arbitrario. Como $x_n -> x$, existe un $n_0$ tal que si $n >= n_0$, tenemos que $d(x_n, x) < r$. Como antes, esto nos dice que $x_n in B(x, r) inter E$ para todo $n >= n_0$ y además $x_n != x$. Esto nos dice que $x in E'$.

    De hecho, si usamos que los $x_n$ son todos distintos entre sí, lo que nos sale es que no sólo podemos encontrar un elemento distinto de $x$ en $B(x, r) inter E$, sino que podemos encontrar _infinitos elementos_ en $B(x, r) inter E$, como mencionamos anteriormente.
]

#corolario[Cerrados vía sucesiones][4.47][
  Sea $(M, d)$ un espacio métrico, $E subset.eq M$. Entonces $E$ es cerrado si y sólo si para toda sucesión $(x_n)_(n in NN) subset.eq E$ tal que $x_n -> x$ se tiene que $x in E$.
]

La demostración se deduce directamente del resultado anterior y la dejamos de ejercicio (ver `desafios/p3.typ`).

#observacion[][4.48][
  El corolario nos dice que en un conjunto cerrado, toda sucesión convergente lo hace dentro de $E$. Lo que *no dice* el corolario es que toda sucesión sea convergente.
]

#definicion[Sucesión acotada][4.49][
  Sea $(x_n)_(n in NN) subset.eq M$ una sucesión dentro de $M$. Decimos que $(x_n)_(n in NN)$ es _acotada_ si el conjunto
  $ A = {x_n : n in NN} subset.eq M $
  es un conjunto acotado.
]

#definicion[Sucesión de Cauchy][4.51][
  Sea $(x_n)_(n in NN) subset.eq M$ una sucesión. Decimos que $(x_n)_(n in NN)$ es una sucesión _de Cauchy_ si para todo $epsilon > 0$ existe un $n_0 in NN$ tal que
  $ d(x_n, x_m) < epsilon, quad "para todo " n, m >= n_0. $
]


#teorema[Sucesiones de Cauchy, acotadas y convergentes][4.54][
  Sea $(M, d)$ un espacio métrico y $(x_n)_(n in NN) subset.eq M$ una sucesión.
  #set enum(numbering: "a)")
  + Si $(x_n)_(n in NN)$ es de Cauchy, entonces es acotada.
  + Si $(x_n)_(n in NN)$ es convergente, entonces es de Cauchy.
  + Si $(x_n)_(n in NN)$ es de Cauchy y tiene una subsucesión convergente, entonces $(x_n)$ es convergente.
]
#demostracion[
  #set enum(numbering: "a)")
  + Sea $(x_n)_(n in NN)$ una sucesión de Cauchy. Para ver que es acotada, tenemos que encontrar una constante $C$ tal que para todo $n, m in NN$, $d(x_n, x_m) <= C$. Como la sucesión es de Cauchy, tenemos que para $epsilon = 1$, tenemos un $n_0$ tal que si $n, m >= n_0$, $d(x_n, x_m) < 1$. Observemos que el conjunto
    $ {d(x_n, x_m) : 1 <= n, m <= n_0} $
    es un conjunto finito, y por lo tanto, tiene máximo. Sea $k$ ese máximo y tomemos $C = k + 1$. Veamos que esta constante nos sirve para lo que queremos. Sean $n, m$ dos índices cualesquiera.

    Sabemos que si $n, m >= n_0$, entonces $d(x_n, x_m) < 1 <= C$.

    Si $n, m <= n_0$, por como elegimos la constante $C$, nos sale que $d(x_n, x_m) <= k <= C$.

    Para terminar de probar todos los casos, veamos qué pasa si $n <= n_0 <= m$. En este caso, tenemos que
    $ d(x_n, x_m) <= underbrace(d(x_n, x_(n_0)), <= k) + underbrace(d(x_(n_0), x_m), < 1) <= k + 1 = C, $
    como queríamos probar.

  + Sea $(x_n)_(n in NN)$ y $x in M$ tal que $x_n -> x$. Para ver que esta sucesión es de Cauchy, tomemos $epsilon > 0$. Como $x_n -> x$, sabemos que existe un $n_0$ tal que si $n >= n_0$, $d(x_n, x) < epsilon/2$. Ahora si $n, m >= n_0$,
    $ d(x_n, x_m) <= d(x_n, x) + d(x, x_m) < epsilon/2 + epsilon/2 = epsilon, $
    lo que nos dice que la sucesión es de Cauchy.

  + Sea $(x_n)_(n in NN)$ de Cauchy y sea $(x_(n_k))_(k in NN)$ una subsucesión tal que $x_(n_k) -> x$ cuando $k -> oo$, con $x in M$. Veamos que la sucesión entera converge a $x$. Para esto, tomemos $epsilon > 0$. Como $(x_n)$ es de Cauchy, sabemos que existe un $n_0$ tal que $d(x_n, x_m) < epsilon/2$ para todo $n, m >= n_0$. Como $x_(n_k) -> x$, sabemos que existe un $k_0$ tal que $d(x_(n_k), x) < epsilon/2$ para todo $k >= k_0$. Tenemos
    $ d(x_n, x) <= underbrace(d(x_n, x_(n_k)), < epsilon\/2) + underbrace(d(x_(n_k), x), epsilon\/2) < epsilon, $
    si $n >= n_0$.

    ¿Cómo elegimos el $n_k$ en esta cuenta? Por un lado, necesitamos que $n_k >= n_0$ (para que podamos acotar $d(x_n, x_(n_k))$) y por otro lado necesitamos que $n_k >= n_(k_0)$ (para poder acotar $d(x_(n_k), x)$). Pensá por qué podemos conseguir un $n_k$ que cumpla ambas condiciones.
]
