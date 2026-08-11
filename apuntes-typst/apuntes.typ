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

// --- Diccionario de Contadores Individuales por Cajita ---
#let contadores-repaso = (
  "Conjunto Acotado Superiormente": 1,
  "Supremo": 1,
  "Completitud": 1,
  "Principio de Arquímedes": 1,
  "Principio de Arquímedes 2": 1,
  "Densidad de ℚ": 1,
  "Densidad deℚ": 1,
  "Equivalencia de supremo": 0,
  "Máximo": 0,
  "Caracterización de Supremo y Máximo": 0,
  "Conjunto Acotado Inferiormente": 0,
  "Ínfimo": 0,
  "Completitud en términos de ínfimos": 0,
  "Equivalencia de Ínfimo": 0,
  "Mínimo": 0,
  "Caracterización de Ínfimo y Mínimo": 0,
  "Sucesiones": 0,
  "Convergencia de Sucesiones": 0,
  "Divergencia de Sucesiones": 0,
  "Unicidad del límite": 0,
  "Álgebra de límites": 0,
  "Sucesión Acotada": 0,
  "Toda sucesión convergente está acotada": 0,
  "Sucesión Monótona": 0,
  "Convergencia de sucesiones monótonas crecientes": 0,
)

// --- Página de Autoevaluación / Repaso Activo ---

#align(center)[
  #text(18pt, weight: "bold", fill: rgb("#1e293b"))[Registro de Autoevaluación] \
  #v(4pt)
  #text(10pt, fill: rgb("#64748b"), style: "italic")[Cantidad de veces completado correctamente sin mirar]
]
#v(1.5em)

#context {
  let frames-found = query(figure.where(kind: "frame")).filter(it => it.supplement != [Demostración])
  
  let extract-text(it) = {
    if type(it) == str { it }
    else if type(it) != content { "" }
    else if it.has("text") { it.text }
    else if it.has("children") { it.children.map(extract-text).join("") }
    else if it.has("body") { extract-text(it.body) }
    else { "" }
  }

  for item in frames-found {
    let supp = item.supplement
    let cap = item.caption.body
    let page-num = item.location().page()
    
    let children = cap.fields().at("children", default: ())
    let raw-title = children.filter(c => not (type(c) == content and c.has("value"))).map(extract-text).join("").trim()
    
    // Normalizar espacios intermedios para búsqueda limpia en diccionario
    let title-clean = raw-title.split().join(" ")
    let count = contadores-repaso.at(title-clean, default: 0)
    
    let is-done = count > 0
    let box-stroke = if is-done { 0.7pt + rgb("#2563eb") } else { 0.7pt + rgb("#94a3b8") }
    let box-fill = if is-done { rgb("#eff6ff") } else { none }
    let text-color = if is-done { rgb("#2563eb") } else { rgb("#94a3b8") }

    grid(
      columns: (auto, auto, 1fr, auto),
      gutter: 8pt,
      align: (left + horizon, left + horizon, bottom, right + horizon),
      [#box(width: 18pt, height: 13pt, stroke: box-stroke, radius: 3pt, fill: box-fill)[#align(center + horizon)[#text(8.5pt, fill: text-color, weight: "bold")[#count]]]],
      [*#supp:* #cap],
      box(width: 100%, repeat[.#h(3pt)]),
      [pág. #page-num]
    )
    v(6pt)
  }
}

#pagebreak()

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

  - *($=>$)* _(La estrategia sale por contradicción: ¿qué pasa si no existe $a_epsilon$?)_

    Supongamos que $s = op("sup")(A)$. Entonces $s$ es una cota superior de $A$ por definición de supremo. Veamos que cumple la condición b) de la Proposición: sea $epsilon > 0$. Queremos probar que existe $a_epsilon in A$ tal que $s - epsilon < a_epsilon$.

    Si no existe tal elemento, se debe cumplir que
    $ a <= s - epsilon "para todo elemento" a in A => s - epsilon "es cota superior de" A. $
    Pero $s - epsilon$ sería entonces una cota superior de $A$ más chica que $s$ que es el supremo de $A$. Esto es un absurdo.

  - *($arrow.l.double$)* _(La estrategia es que podemos construir $t < s$ para cualquier $epsilon > 0$, y como existe $a_epsilon in A$, podemos ver que $t < a_epsilon$ siempre, por lo que $t$ no puede ser cota superior.)_

    Supongamos ahora que $s$ es un elemento de $RR$ que cumple las dos condiciones de la Proposición y veamos que $s$ debe ser el supremo de $A$. Es decir, veamos que $s$ cumple la Definición 2. Sabemos que $s$ es cota superior, veamos que es la menor de las cotas superiores. Sea $t < s$. Entonces $s - t = epsilon > 0$.


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

#definicion[Negación de la Convergencia (No Convergencia / Divergencia)][9][
  Decimos que una sucesión real $(a_n)_(n in NN)$ *no converge* (es decir, no admite ningún límite en $RR$) si satisface la negación formal de la definición de convergencia para todo candidato a límite $L in RR$:

  $ (forall L in RR)(exists epsilon_0 > 0)(forall N in NN)(exists n >= N) => |a_n - L| >= epsilon_0 $

  En palabras: para todo candidato a límite $L in RR$, existe un umbral de error $epsilon_0 > 0$ tal que para cualquier elección de $N in NN$, existe un término $a_n$ con $n >= N$ cuya distancia a $L$ es mayor o igual a $epsilon_0$ ($|a_n - L| >= epsilon_0$).
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

#demostracion[Demostración del Álgebra de límites][
  Veamos los ítems por separado:

  - *Ítem a ($\lim_(n -> oo) (c · a_n) = c · a$ para todo $c in RR$):*
    Sea $c in RR$. Tenemos dos opciones: $c = 0$ o $c != 0$. Observemos que si $c = 0$, tanto $c · a_n = 0$ para todo $n in NN$ como $c · a = 0$, con lo cual la propiedad se cumple trivialmente.

    Supongamos ahora que $c != 0$ y tomemos $epsilon > 0$. Como $a_n -> a$, debe existir un $n_0 in NN$ tal que $|a_n - a| < epsilon / |c|$ para todo $n >= n_0$ (notemos que podemos dividir a $epsilon$ por $|c|$ porque $c != 0$ y que $epsilon / |c| > 0$). Tenemos que

    $ |c · a_n - c · a| = |c · (a_n - a)| = |c| |a_n - a| < |c| epsilon / |c| = epsilon $

    para todo $n >= n_0$.

  - *Ítem b ($\lim_(n -> oo) (a_n + b_n) = a + b$):*
    _Ejercicio de la guía (demostración a completar / ver archivo de desafíos)_.

  - *Ítem c ($\lim_(n -> oo) (a_n b_n) = a b$):*
    Sea $epsilon > 0$. Como $a_n$ es una sucesión convergente, sabemos que es acotada. Es decir, existe $M > 0$ tal que $|a_n| <= M$ para todo $n in NN$. Sea $n_1 in NN$ tal que $|b_n - b| < epsilon / (2M)$ para todo $n >= n_1$ (otra vez, acá es importante notar que $epsilon / (2M)$ es un número positivo y por lo tanto podemos aplicar la definición de límite). Como en el ítem 1, vamos a distinguir dos casos: $b = 0$ o $b != 0$.

    Si $b = 0$ entonces $a · b = 0$ y tenemos que

    $ |a_n b_n - a b| = |a_n b_n| = |a_n||b_n| <= M |b_n - b| < epsilon/2 < epsilon $

    para todo $n >= n_1$. Tomamos $n_0 = n_1$ y listo.

    Supongamos ahora que $b != 0$. Como $a_n -> a$, sabemos que existe $n_2 in NN$ tal que $|a_n - a| < epsilon / (2|b|)$ para todo $n >= n_2$. Entonces tenemos

    $ |a_n b_n - a b| &= |a_n b_n - a_n b + a_n b - a b| \
    &<= |a_n||b_n - b| + |b||a_n - a| \
    &<= M underbrace(|b_n - b|, < epsilon / (2M)) + |b| underbrace(|a_n - a|, < epsilon / (2|b|)) \
    &< epsilon/2 + epsilon/2 = epsilon. $

    Acá tenemos que pensar qué necesitamos para que se cumpla la cuenta que acabamos de hacer. Por un lado, $n$ debería ser más grande que $n_1$ para que se cumpla que podemos acotar $|b_n - b|$. Por el otro, necesitamos que $n$ sea más grande que $n_2$ para que podamos acotar el término $|a_n - a|$. Es decir que para que sean ciertas ambas cotas al mismo tiempo necesitamos que $n$ sea más grande $n_1$ y $n_2$ *al mismo tiempo*. Esto se puede plasmar en nuestra demostración eligiendo $n_0 = op("máx")(n_1, n_2)$ y entonces la cuenta de arriba vale para todo $n >= n_0$ que es lo que queríamos ver.

  - *Ítem d (Si $b != 0$, entonces $\lim_(n -> oo) (a_n / b_n) = a / b$):*
    _*Estrategia:* Escribimos el cociente como un producto $a_n / b_n = a_n · (1/b_n)$. Habiendo probado el ítem c (límite del producto), lo único que necesitamos demostrar es que $1/b_n -> 1/b$ (con $b != 0$)._

    Por el ejercicio 6, si $b_n -> b$ y $b != 0$ entonces existe una constante $c > 0$ (en el ejercicio mostramos que esa constante $c$ se puede elegir $c = |b|/2 > 0$) y $n_1 in NN$ tal que $|b_n| >= c$ para todo $n >= n_1$.

    Tomando por válido este resultado, fijemos un $epsilon > 0$. Sea $n_2 in NN$ tal que $|b_n - b| < epsilon · |b| · c$ para todo $n >= n_2$. Entonces

    $ |1/b_n - 1/b| = |b - b_n| / |b_n · b| <= |b_n - b| / (|b| · c) < epsilon $

    si $n >= n_0 = op("máx")(n_1, n_2)$ (donde $n_1$ es el que nos garantiza que $|b_n| >= c$ y $n_2$ es el que nos da la cota de $|b_n - b|$).
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


