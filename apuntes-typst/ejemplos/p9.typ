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

// --- Ejemplos de la Práctica 9 ---

#align(center)[
  #text(14pt, weight: "bold")[Ejemplos resueltos --- Práctica 9] \
  #v(2pt)
  #text(10pt, style: "italic", fill: rgb("#475569"))[
    Funciones medibles e integral de Lebesgue
  ]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

Los ejemplos están agrupados por *técnica*, no por orden de transcripción, y los bloques siguen el orden en que la guía los necesita. Cada bloque abre con la nota de qué ejercicios de `guias/p9.typ` desbloquea.

La pestaña dice de dónde viene cada ejemplo: un *número* es el ejemplo de `notas_materia.pdf` (con su numeración por capítulo entre paréntesis en el título), *`C{clase}-{ejemplo}`* es un ejercicio resuelto en clase, transcrito en `clases/` (un archivo por tema; la tabla clase $arrow$ archivo está en la skill `ejemplo`) --- `C11-3` es el Ejercicio 3 de `clases/funciones_medibles.typ` --- y *`A{sección}`* es un resultado o ejercicio de Abbott, _Understanding Analysis_ --- `A1.5.9` es el Ejercicio 1.5.9 del libro.

#v(6pt)

#show table.cell.where(y: 0): set text(fill: white, weight: "bold", size: 8.5pt)

#table(
  columns: (0.35fr, 2.4fr, 1.1fr),
  align: (center + horizon, left + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#065f46") } else if calc.even(y) { rgb("#f8fafc") } else { white },
  stroke: 0.4pt + rgb("#cbd5e1"),
  inset: (x: 6pt, y: 4pt),

  [*\#*], [*Bloque*], [*Desbloquea*],
  [1], [Medibilidad vía preimágenes de intervalos y composición], [p9: Ej. 2, 4, 6; Ej. 4 (c) es literal en C11-2; conceptual para Ej. 1, 5],
  [2], [Conjuntos definidos por límites: uniones e intersecciones numerables], [p9: Ej. 7, 8; Ej. 3 (b)],
  [3], [Acotar una función medible salvo un conjunto chico], [p9: Ej. 10; conceptual para Ej. 11, 13 (b)],
  [4], [Integral: característica $arrow$ simple $arrow$ convergencia monótona], [p9: Ej. 9 (mismo esquema con traslación), 13; Ej. 8],
)

#v(4pt)

#text(size: 9pt, fill: rgb("#64748b"))[
  La numeración de ejercicios es la de la *guía 2025* (`guias/p9.typ`).
]

#v(8pt)

== Bloque 1 · Medibilidad vía preimágenes de intervalos y composición

#sublema(titulo: "Qué desbloquea")[
  La clase del 18/11 arranca con el recordatorio que la guía pide demostrar en el *Ejercicio 2*: $f : E -> RR$ es medible si y sólo si vale cualquiera de las cuatro condiciones

  a) $f^(-1) ((a, +infinity)) = {x in E : f(x) > a}$ es medible para todo $a in RR$,

  b) $f^(-1) ([a, +infinity)) = {x in E : f(x) >= a}$ es medible para todo $a in RR$,

  c) $f^(-1) ((-infinity, a)) = {x in E : f(x) < a}$ es medible para todo $a in RR$,

  d) $f^(-1) ((-infinity, a]) = {x in E : f(x) <= a}$ es medible para todo $a in RR$.

  Con eso en la mano, C11-1 muestra la maniobra básica: la preimagen de cualquier intervalo es intersección de dos preimágenes de semirrectas, y las preimágenes respetan uniones e intersecciones. C11-2 la lleva un paso más lejos: si $g$ es continua, $g^(-1) ((-infinity, a))$ es un abierto de $RR$, o sea una unión numerable de intervalos abiertos, y por lo tanto $(g compose f)^(-1) ((-infinity, a))$ es unión numerable de medibles. Esa es exactamente la cuenta del *Ejercicio 6 (a)* (continua $=>$ medible, con $f = "id"$) y, con $g(x) = x^2$, $g(x) = alpha x$ o $g(x) = abs(x)$, resuelve de un saque el *Ejercicio 4 (b), (c)* y da la idea del *Ejercicio 1*. El *Ejercicio 5* (monótona $=>$ medible) es de la misma familia: la preimagen de una semirrecta por una monótona es un intervalo.
]

#ejemplo[La preimagen de todo intervalo por una medible es medible (Clase 11 · Ejercicio 1)][C11-1][
  Probar que si $f$ es medible, para todo intervalo $I$, $f^(-1) (I)$ es medible.
]

#estrategia[Todo intervalo es intersección de dos semirrectas][
  Las semirrectas ya están cubiertas por el recordatorio. Un intervalo acotado $(a, b)$ es $(a, +infinity) inter (-infinity, b)$, y la preimagen de una intersección es la intersección de las preimágenes; los otros tres tipos de intervalo se arman igual cambiando el tipo de semirrecta (abierta o cerrada) en cada extremo.
]

#resolucion[
  Sólo hay que verificar que $f^(-1) (I)$ es medible para intervalos acotados.

  - Si $I = (a, b) = (a, +infinity) inter (-infinity, b)$, entonces
    $ f^(-1) (I) = f^(-1) ((a, +infinity) inter (-infinity, b)) = f^(-1) ((a, +infinity)) inter f^(-1) ((-infinity, b)). $
    Como $f^(-1) ((a, +infinity))$ y $f^(-1) ((-infinity, b))$ son medibles, se sigue que $f^(-1) (I)$ es intersección de medibles, y en consecuencia es medible.

  - Si $I = [a, b], [a, b), (a, b]$, lo escribimos como intersección de intervalos no acotados como en el caso $(a, b)$: $[a, b] = [a, +infinity) inter (-infinity, b]$, $[a, b) = [a, +infinity) inter (-infinity, b)$ y $(a, b] = (a, +infinity) inter (-infinity, b]$.
]

#ejemplo[Continua compuesta con medible es medible (Clase 11 · Ejercicio 2)][C11-2][
  Sea $g : RR -> RR$ continua y $f : RR -> RR$ medible. Probar que $g compose f$ es medible.
]

#estrategia[Preimagen de preimagen, y un abierto de $RR$ es unión numerable de intervalos][
  La cuenta de conjuntos es $(g compose f)^(-1) (A) = f^(-1) (g^(-1) (A))$. Si $A = (-infinity, a)$, la continuidad de $g$ dice que $g^(-1) (A)$ es abierto, y todo abierto de $RR$ es unión numerable de intervalos abiertos (Práctica 8). Entonces $(g compose f)^(-1) (A)$ es unión numerable de conjuntos $f^(-1) (I_n)$, que son medibles por C11-1. Notar que la continuidad se usa *una sola vez*, para que $g^(-1) (A)$ sea abierto.
]

#resolucion[
  Primero notemos que $(g compose f)^(-1) (A) = f^(-1) (g^(-1) (A))$. En efecto, $x in (g compose f)^(-1) (A)$ si y sólo si $(g compose f)(x) in A$, es decir, si y sólo si la imagen por $g$ de $f(x)$ está en $A$. Pero esto equivale a su vez a que $f(x) in g^(-1) (A)$, y finalmente, esto último es equivalente a $x in f^(-1) (g^(-1) (A))$.

  Para ver que $g compose f$ es medible, notemos que dado $a in RR$,
  $ (g compose f)^(-1) ((-infinity, a)) = f^(-1) (g^(-1) ((-infinity, a))), $
  y como $g$ es _continua_, $g^(-1) ((-infinity, a))$ es abierto (preimágenes de abiertos por funciones continuas son abiertos). Por lo tanto $g^(-1) ((-infinity, a)) = union.big_(n in N) I_n$ con $I_n$ intervalo abierto y $N$ contable. Entonces
  $ (g compose f)^(-1) ((-infinity, a)) = f^(-1) (union.big_(n in N) I_n) = union.big_(n in N) f^(-1) (I_n). $
  Por el Ejercicio 1 (C11-1), $f^(-1) (I_n)$ es medible para todo $n in N$. Como $(g compose f)^(-1) ((-infinity, a))$ es unión contable de medibles, resulta medible. Esto prueba que $g compose f$ es medible.

  _Nota_: el manuscrito escribe en un lugar "para ver que $f compose g$ es medible"; se trata de $g compose f$, que es lo que se prueba.
]

#sublema(titulo: [Observación: con $g$ sólo medible puede fallar])[
  Si pedimos sólo que $g$ sea medible (y no continua), ¡puede pasar que $g compose f$ *no* sea medible! El paso que se rompe es el único que usó la continuidad: $g^(-1) ((-infinity, a))$ es medible, pero ya no es un abierto, y la preimagen por $f$ de un medible cualquiera no tiene por qué ser medible (sólo lo es la de borelianos). Para el *Ejercicio 4* de la guía esto no molesta: ahí las $g$ son $x |-> alpha x$, $x |-> x^2$, continuas.
]

== Bloque 2 · Conjuntos definidos por límites: uniones e intersecciones numerables

#sublema(titulo: "Qué desbloquea")[
  La maniobra de este bloque es traducir una condición con cuantificadores ("para todo $epsilon$ existe $n_0$ tal que para todo $n >= n_0$ ...") a una combinación numerable de conjuntos medibles: "$forall$" se vuelve $inter.big$, "$exists$" se vuelve $union.big$, y el "$forall epsilon > 0$" se discretiza con $epsilon = 1 \/ k$. C11-3 lo hace con la condición de Cauchy para probar que el conjunto de convergencia de una sucesión de medibles es medible; C11-4 lo hace con el límite del cociente incremental para ver que $f'$ es medible, reescribiendo "$f'(x) > a$" como "$exists k, exists n_0, forall n >= n_0 : F(x, 1 \/ n) > a + 1 \/ k$".

  Es el esqueleto del *Ejercicio 7* (${sup_n f_n > a} = union.big_n {f_n > a}$ y ${inf_n f_n >= a} = inter.big_n {f_n >= a}$) y, vía sumas parciales crecientes, del *Ejercicio 8* ($sum_n f_n = sup_N sum_(n <= N) f_n$). También del *Ejercicio 3 (b)*: ${f <= g}$ se describe con un "$forall q in QQ$" numerable. En ambos ejemplos de clase, el ingrediente previo es que $abs(f_n - f_m)$ y $n (f(x + 1 \/ n) - f(x))$ son medibles, que es el *Ejercicio 4* (Bloque 1).
]

#ejemplo[El conjunto donde una sucesión de medibles converge es medible (Clase 11 · Ejercicio 3)][C11-3][
  Sea $f_n : RR -> RR$ medible para cada $n in NN$. Definimos $A := {x in RR : f_n (x) "converge"}$. Probar que $A$ es medible.
]

#estrategia[Convergente $=$ Cauchy, y la condición de Cauchy es "$forall epsilon, exists n_0, forall n, m >= n_0$"][
  Describir $A$ por la *definición* de convergencia metería el límite $f(x)$, que no sabemos que sea medible. Con Cauchy sólo intervienen las $f_n$: $A = inter.big_k union.big_(n_0) inter.big_(n, m >= n_0) {abs(f_n - f_m) < 1 \/ k}$, y cada conjunto de adentro es de tipo c) del recordatorio para la medible $abs(f_n - f_m)$. Después es leer la fórmula de adentro hacia afuera: intersección numerable, unión numerable, intersección numerable.
]

#resolucion[
  Notemos que $f_n (x)$ converge si y sólo si $(f_n (x))_n$ es de Cauchy. Entonces
  $
    A &= {x in RR : forall epsilon > 0, exists n_0 forall n, m >= n_0, abs(f_n (x) - f_m (x)) < epsilon} \
    &= inter.big_(epsilon > 0) union.big_(n_0 in NN) inter.big_(n >= n_0, m >= n_0) {x in RR : abs(f_n (x) - f_m (x)) < epsilon} \
    &= inter.big_(k in NN) union.big_(n_0 in NN) inter.big_(n >= n_0, m >= n_0) {x in RR : abs(f_n (x) - f_m (x)) < 1/k},
  $
  donde en la última igualdad usamos que podemos cambiar "$forall epsilon > 0$" por "$forall k in NN$" si ponemos $abs(f_n (x) - f_m (x)) < 1 \/ k$. Como cada $f_n$ es medible, $abs(f_n - f_m)$ es medible. Por lo tanto, los conjuntos
  $ A_(n, m, k) = {x in RR : abs(f_n (x) - f_m (x)) < 1/k} $
  son del tipo c) del recordatorio, y por lo tanto son medibles. Concluimos que

  - $inter.big_(n >= n_0, m >= n_0) A_(n, m, k)$ es medible para todo $n_0, k$, por ser intersección numerable de medibles,

  - $union.big_(n_0 in NN) inter.big_(n >= n_0, m >= n_0) A_(n, m, k)$ es medible para todo $k$, por ser unión numerable de medibles,

  - $A = inter.big_(k in NN) union.big_(n_0 in NN) inter.big_(n >= n_0, m >= n_0) A_(n, m, k)$ es medible, por ser intersección numerable de medibles.
]

#ejemplo[La derivada de una función derivable es medible (Clase 11 · Ejercicio 4)][C11-4][
  Sea $f : [0, 1] -> RR$ tal que $f$ es derivable en $(0, 1)$. Probar que $f' : (0, 1) -> RR$ es medible.
]

#estrategia[Bajar el límite en $h -> 0$ a una sucesión $h = 1 \/ n$ y escribir "$f' > a$" con cuantificadores][
  $f'(x) = lim_n F(x, 1 \/ n)$ con $F(x, h) = (f(x + h) - f(x)) \/ h$, y cada $x |-> F(x, 1 \/ n)$ es medible (es un cociente de continuas, porque $f$ es continua por ser derivable). El truco está en reemplazar "$f'(x) > a$" por una condición con *margen*: $f'(x) > a$ si y sólo si existen $k$ y $n_0$ con $F(x, 1 \/ n) > a + 1 \/ k$ para todo $n >= n_0$. Sin el $1 \/ k$ la vuelta fallaría (el límite de cosas $> a$ sólo es $>= a$). Después, los cuantificadores dan $union.big_k union.big_(n_0) inter.big_(n >= n_0)$.
]

#resolucion[
  Recordemos que
  $ f'(x_0) = lim_(h -> 0) (f(x_0 + h) - f(x_0)) / h. $
  Sea $a > 0$. Consideramos
  $ (f')^(-1) ((a, +infinity)) = {x in (0, 1) : f'(x) > a}. $
  Sea $F(x, h) = (f(x + h) - f(x)) / h$. Como $lim_(h -> 0) F(x, h) = f'(x)$, se tiene que
  $ lim_(n -> +infinity) F(x, 1/n) = lim_(n -> +infinity) (f(x + 1/n) - f(x)) / (1/n) = f'(x). $
  Entonces, veamos que
  $
    f'(x) > a quad "si y sólo si" quad & "existen" k in NN, n_0 in NN "tales que" \
    & "para todo" n >= n_0, quad F(x, 1/n) > a + 1/k.
  $

  $=>)$ Por definición, dado $epsilon > 0$ existe $n_0 in NN$ tal que para todo $n >= n_0$, $abs(F(x, 1 \/ n) - f'(x)) < epsilon$. Entonces $F(x, 1 \/ n) > f'(x) - epsilon$. Como $f'(x) > a$, existe $k in NN$ tal que $f'(x) > a + 1 \/ k$. Por lo tanto $F(x, 1 \/ n) > a + 1 \/ k - epsilon$. Si elegimos $epsilon = 1 \/ (2k)$, queda $F(x, 1 \/ n) > a + 1 \/ (2k)$.

  $arrow.l.double)$ Tomar límite $n -> +infinity$. Queda $lim_(n -> +infinity) F(x, 1 \/ n) = f'(x) >= a + 1 \/ k > a$.

  Entonces:
  $
    {x in (0, 1) : f'(x) > a} &= {x in (0, 1) : exists k in NN space exists n_0 in NN space forall n >= n_0 space F(x, 1/n) > a + 1/k} \
    &= union.big_(k in NN) union.big_(n_0 in NN) inter.big_(n >= n_0) {x in (0, 1) : F(x, 1/n) > a + 1/k} \
    &= union.big_(k in NN) union.big_(n_0 in NN) inter.big_(n >= n_0) {x in (0, 1) : (f(x + 1/n) - f(x)) / (1/n) > a + 1/k}.
  $
  Fijado $n$, $(f(x + 1 \/ n) - f(x)) \/ (1 \/ n)$ es medible, por lo tanto los conjuntos
  $ A_(k, n_0, n) = {x in (0, 1) : (f(x + 1/n) - f(x)) / (1/n) > a + 1/k} $
  son medibles. Entonces:

  - $inter.big_(n >= n_0) A_(k, n_0, n)$ es medible porque es intersección numerable de medibles,

  - $union.big_(n_0 in NN) inter.big_(n >= n_0) A_(k, n_0, n)$ es medible porque es unión numerable de medibles,

  - $inter.big_(k in NN) union.big_(n_0 in NN) inter.big_(n >= n_0) A_(k, n_0, n)$ es medible porque es intersección numerable de medibles.

  _Nota (i)_: el manuscrito escribe "sea $a > 0$", pero hay que ver que ${f' > a}$ es medible para _todo_ $a in RR$; el argumento no usa que $a$ sea positivo.

  _Nota (ii)_: en el último ítem el manuscrito escribe $inter.big_(k in NN)$ e "intersección numerable", pero el "$exists k$" de la descripción de ${f' > a}$ da una _unión_ sobre $k$, como en las dos líneas de arriba: $union.big_(k in NN) union.big_(n_0 in NN) inter.big_(n >= n_0) A_(k, n_0, n)$ es medible por ser unión numerable de medibles.

  _Nota (iii)_: en $=>)$ se obtiene $F(x, 1 \/ n) > a + 1 \/ (2k)$, así que el natural que sirve en el enunciado del "si y sólo si" es $2k$.

  _Nota (iv)_: que $x |-> n (f(x + 1 \/ n) - f(x))$ sea medible usa que $f$ es continua en $(0, 1)$ (por ser derivable) y que la traslación $x |-> f(x + 1 \/ n)$ preserva medibilidad; ese cociente sólo está definido para $x < 1 - 1 \/ n$, pero para cada $x in (0, 1)$ lo está para todo $n$ grande, que es lo único que interviene en la intersección sobre $n >= n_0$.
]

== Bloque 3 · Acotar una función medible salvo un conjunto chico

#sublema(titulo: "Qué desbloquea")[
  Una función medible a valores reales puede no ser acotada, pero *casi* lo es: los conjuntos $A_n = {abs(f) > n}$ decrecen a $emptyset$ y, en un conjunto de medida finita, la continuidad de la medida para sucesiones decrecientes (Práctica 8) hace $mu (A_n) -> 0$. C11-5 es ese argumento en $[0, 1]$: fuera de un $A_(n_0)$ de medida $< epsilon$, $f$ está acotada por $n_0$.

  Para la guía: es la idea que convierte el *Ejercicio 10* (acotada en medida finita $=>$ integrable, $integral_E abs(f) <= M mu (E)$) en un primer paso hacia la integrabilidad de medibles no acotadas, y el mismo juego de conjuntos ${abs(f - g) > 1 \/ n}$ crecientes hacia ${f != g}$ es el que pide el *Ejercicio 11*. La continuidad de $mu$ para sucesiones monótonas reaparece en el *Ejercicio 13 (b)*.
]

#ejemplo[Una medible en $[0, 1]$ está acotada fuera de un conjunto de medida $< epsilon$ (Clase 11 · Ejercicio 5)][C11-5][
  Sea $f : [0, 1] -> RR$ medible. Probar que para todo $epsilon > 0$ existen $M >= 0$ y $A subset.eq [0, 1]$ medible tales que

  - $abs(f(x)) <= M$ para todo $x in [0, 1] without A$,

  - $mu (A) < epsilon$.
]

#estrategia[Los conjuntos ${abs(f) > n}$ decrecen al vacío, y la medida es continua][
  Lo que se busca es un $A supset.eq {abs(f) > M}$ con $mu (A) < epsilon$, así que el candidato natural es $A = A_n = {abs(f) > n}$ para algún $n$. Como $f$ toma valores reales, $inter.big_n A_n = emptyset$; los $A_n$ son medibles, decrecientes y viven en $[0, 1]$ (medida finita), así que $mu (A_n) -> mu (emptyset) = 0$. Basta tomar $n_0$ con $mu (A_(n_0)) < epsilon$ y $M = n_0$.
]

#resolucion[
  Notemos que buscamos $M, A$ tales que

  - $[0, 1] without A subset.eq {x in [0, 1] : abs(f(x)) <= M}$, o equivalentemente $A supset.eq {x in [0, 1] : abs(f(x)) > M}$,

  - $mu (A) < epsilon$.

  Sea $epsilon > 0$. Tenemos que
  $ inter.big_(n in NN) {x in [0, 1] : abs(f(x)) > n} = emptyset. $
  Además, para todo $n in NN$, si $A_n = {x in [0, 1] : abs(f(x)) > n}$,

  - $A_n$ es medible porque $f$ es medible,

  - $A_(n+1) subset.eq A_n$, porque si $x in A_(n+1)$, cumple que $abs(f(x)) > n + 1$, entonces $abs(f(x)) > n + 1 > n$, y por lo tanto $x in A_n$.

  Entonces $lim_(n -> +infinity) mu (A_n) = mu (inter.big_n A_n) = mu (emptyset) = 0$. Por lo tanto, existe $n_0$ tal que para todo $n >= n_0$, $mu (A_n) < epsilon$. Sea $A = A_(n_0)$ y $M = n_0$.

  - $A$ es medible.

  - $mu (A) < epsilon$.

  - $[0, 1] without A = {x in [0, 1] : abs(f(x)) <= n_0}$, o sea, $abs(f(x)) <= n_0$ para todo $x in [0, 1] without A$.

  Concluimos que $M$ y $A$ cumplen lo pedido.

  _Nota_: en el último ítem el manuscrito escribe "$abs(f(x)) <= n$"; es $n_0$, como dice a continuación.

  _Nota_: dos detalles que el manuscrito no explicita: la intersección $inter.big_n A_n$ es vacía porque $f$ toma valores reales (finitos), y el paso $lim mu (A_n) = mu (inter.big_n A_n)$ (continuidad de $mu$ para sucesiones decrecientes) requiere $mu (A_1) < infinity$, que vale porque $A_1 subset.eq [0, 1]$.
]

== Bloque 4 · Integral: característica $arrow$ simple $arrow$ convergencia monótona

#sublema(titulo: "Qué desbloquea")[
  Casi toda identidad de integrales de Lebesgue se prueba con la misma escalera de cuatro escalones: (I) para $f = chi_A$ la integral es una medida y la identidad es una propiedad de $mu$; (II) para $f$ simple, por linealidad; (III) para $f >= 0$ medible, aproximando por simples crecientes y pasando al límite con el teorema de convergencia monótona *de los dos lados*; (IV) para $f$ integrable, escribiendo $f = f_+ - f_-$. C11-6 recorre los cuatro escalones para el cambio de variable $x |-> t x$, donde el escalón (I) es $mu (1/t A) = 1/t mu (A)$ (Ejercicio 14 de la Práctica 8).

  Es, palabra por palabra, el esquema del *Ejercicio 9* (traslación $x |-> x + y$: el escalón (I) es $mu (A + y) = mu (A)$) y del *Ejercicio 13* (integral sobre uniones disjuntas o crecientes: el escalón (I) es la $sigma$-aditividad o la continuidad de $mu$, y el (III) es convergencia monótona aplicada a $f chi_(E_1 union dots union E_n)$). El *Ejercicio 8* es el escalón (III) solo, con las sumas parciales como sucesión creciente. En todos, el paso $f >= 0 arrow.r f$ integrable es el de C11-6: descomponer en $f_plus.minus$ y usar que ambas integrales son finitas.
]

#ejemplo[Cambio de escala en la integral: $integral_([0, 1 \/ t]) f(t x) dif mu = 1/t integral_([0, 1]) f dif mu$ (Clase 11 · Ejercicio 6)][C11-6][
  Sea $f : [0, 1] -> RR$ integrable. Probar que para todo $t > 0$, $f_t : [0, 1 \/ t] -> RR$, $f_t (x) = f(t x)$, es integrable, y además
  $ integral_([0, 1/t]) f(t x) dif mu (x) = 1/t integral_([0, 1]) f(x) dif mu (x). quad (*) $

  _Nota_: el manuscrito escribe el dominio de $f_t$ como $[0, t]$; por $(*)$ y por el resto de la resolución, $f_t (x) = f(t x)$ y su dominio es $[0, 1 \/ t]$ (que es donde $t x in [0, 1]$).
]

#estrategia[$chi_A (t x) = chi_(1/t A) (x)$, y después subir por la escalera][
  Toda la cuenta se apoya en una identidad de conjuntos: $t x in A$ si y sólo si $x in 1/t A$, así que $chi_A (t x) = chi_(1/t A) (x)$ y $mu (1/t A) = 1/t mu (A)$ (Práctica 8, Ej. 14). Eso da el caso $f = chi_A$; la linealidad da el caso simple; y si $s_n arrow.tr f$ son simples, entonces $s_n (t x) arrow.tr f(t x)$ también son simples, con lo cual la convergencia monótona permite pasar al límite en las dos integrales de $(*)$ a la vez. Para $f$ con signo, $f = f_+ - f_-$. De paso sale la medibilidad de $f_t$ (es límite de simples) y su integrabilidad (sus integrales de $f_plus.minus (t x)$ son finitas).
]

#resolucion[
  Supongamos primero que $f >= 0$. Entonces existe una sucesión $(s_n)_n$ de funciones simples $s_n : [0, 1] -> [0, +infinity)$ tales que

  1) $s_n (x) <= f(x)$ para todo $x in [0, 1]$ y todo $n in NN$,

  2) $0 <= s_n (x) <= s_(n+1) (x)$ para todo $x in [0, 1]$ y todo $n in NN$,

  3) $lim_(n -> +infinity) s_n (x) = f(x)$ para todo $x in [0, 1]$.

  Notemos que si
  $ s(x) = sum_(i = 1)^m a_i chi_(A_i) (x), quad "con" A_i inter A_j = emptyset "si" i != j, quad union.big_(i = 1)^m A_i = [0, 1], $
  entonces
  $ s(t x) = sum_(i = 1)^m a_i chi_(A_i) (t x) = sum_(i = 1)^m a_i chi_(1/t A_i) (x), $
  porque $t x in A_i$ si y sólo si $x in 1/t A_i$. Además, si $i != j$, $1/t A_i inter 1/t A_j = emptyset$, pues $x in 1/t A_i inter 1/t A_j$ si y sólo si $x = 1/t a = 1/t b$ con $a in A_i$, $b in A_j$, es decir $a = b in A_i inter A_j$. Además, $union.big_(i = 1)^m 1/t A_i = 1/t [0, 1] = [0, 1 \/ t]$. Sea $tilde(s)_(n, t) (x) := s_n (t x)$. Se tiene que $(tilde(s)_(n, t))_n$ es una sucesión de funciones simples, tal que

  1') $tilde(s)_(n, t) (x) <= f(t x)$ para todo $x in [0, 1 \/ t]$ y todo $n in NN$,

  2') $0 <= tilde(s)_(n, t) (x) <= tilde(s)_(n+1, t) (x)$ para todo $x in [0, 1 \/ t]$ y todo $n in NN$,

  3') $lim_(n -> +infinity) tilde(s)_(n, t) (x) = f(t x)$ para todo $x in [0, 1 \/ t]$.

  Como $tilde(f) (x) = f(t x)$ es límite de simples, resulta que $tilde(f)$ es medible. Para probar $(*)$, seguimos los siguientes pasos:

  *I)* Si $f = chi_A$, con $A subset.eq [0, 1]$ medible,
  $
    integral_([0, 1/t]) f(t x) dif mu (x) &= integral_([0, 1/t]) chi_A (t x) dif mu (x) = integral_([0, 1/t]) chi_(1/t A) (x) dif mu (x) \
    &= mu (1/t A) = 1/t mu (A) = 1/t integral_([0, 1]) f(x) dif mu (x),
  $
  donde $mu (1/t A) = 1/t mu (A)$ es el Ejercicio 14 de la Práctica 8.

  *II)* Si $f = sum_(i = 1)^m a_i chi_(A_i)$ es simple,
  $
    integral_([0, 1/t]) f(t x) dif mu (x) &= integral_([0, 1/t]) sum_(i = 1)^m a_i chi_(A_i) (t x) dif mu (x) \
    &= sum_(i = 1)^m a_i integral_([0, 1/t]) chi_(1/t A_i) (x) dif mu (x) \
    &= sum_(i = 1)^m a_i mu (1/t A_i) = sum_(i = 1)^m a_i 1/t mu (A_i) = 1/t sum_(i = 1)^m a_i mu (A_i) \
    &= 1/t integral_([0, 1]) f(x) dif mu (x),
  $
  donde otra vez usamos el Ejercicio 14 de la Práctica 8 para $mu (1/t A_i) = 1/t mu (A_i)$.

  *III)* Si $(s_n)_n$ es una sucesión de funciones simples cumpliendo 1), 2), 3), entonces $(tilde(s)_(n, t))_n$ es una sucesión de funciones cumpliendo 1'), 2'), 3'). Por el teorema de convergencia monótona,
  $
    integral_([0, 1/t]) f(t x) dif mu (x) &= integral_([0, 1/t]) lim_(n -> +infinity) tilde(s)_(n, t) (x) dif mu (x) \
    &= lim_(n -> +infinity) integral_([0, 1/t]) tilde(s)_(n, t) (x) dif mu (x) quad "(convergencia monótona)" \
    &= lim_(n -> +infinity) 1/t integral_([0, 1]) s_n (x) dif mu (x) quad "(por II)" \
    &= 1/t integral_([0, 1]) lim_(n -> +infinity) s_n (x) dif mu (x) quad "(convergencia monótona)" \
    &= 1/t integral_([0, 1]) f(x) dif mu (x).
  $

  Supongamos ahora que $f : [0, 1] -> RR$ es integrable. Podemos escribirla como $f = f_+ - f_-$, con $f_+, f_- : [0, 1] -> [0, +infinity)$ integrables. Entonces $f_+ (t x)$, $f_- (t x)$ son integrables en $[0, 1 \/ t]$, y por el caso $f >= 0$, como $f(t x) = f_+ (t x) - f_- (t x)$,
  $
    integral_([0, 1/t]) f(t x) dif mu (x) &= integral_([0, 1/t]) [f_+ (t x) - f_- (t x)] dif mu (x) \
    &= integral_([0, 1/t]) f_+ (t x) dif mu (x) - integral_([0, 1/t]) f_- (t x) dif mu (x) \
    &= 1/t integral_([0, 1]) f_+ (x) dif mu (x) - 1/t integral_([0, 1]) f_- (x) dif mu (x) \
    &= 1/t integral_([0, 1]) [f_+ (x) - f_- (x)] dif mu (x) = 1/t integral_([0, 1]) f(x) dif mu (x).
  $

  _Nota_: que $f_+ (t x)$ y $f_- (t x)$ sean integrables en $[0, 1 \/ t]$ sale del caso $f >= 0$ ya probado: sus integrales valen $1/t integral_([0, 1]) f_plus.minus dif mu < infinity$. Esto es lo que da la integrabilidad de $f_t$ pedida en el enunciado.
]
