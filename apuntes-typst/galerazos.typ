#import "@preview/frame-it:2.0.0": *
#import "@preview/cetz:0.4.0"
#import "@preview/cetz-plot:0.1.2": plot
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

#show heading.where(level: 2): it => block(width: 100%)[
  #v(6pt)
  #text(size: 12pt, weight: "bold", fill: rgb("#a21caf"))[#it.body]
  #v(2pt)
  #line(length: 100%, stroke: 0.7pt + rgb("#f5d0fe"))
]

#show heading.where(level: 3): it => block(width: 100%)[
  #v(4pt)
  #text(size: 10.5pt, weight: "bold", fill: rgb("#475569"))[#it.body]
]


// --- Archivo Acumulativo de Galerazos ---

#align(center)[
  #text(14pt, weight: "bold")[Galerazos --- Análisis Avanzado] \
  #v(2pt)
  #text(10pt, style: "italic", fill: rgb("#475569"))[
    Truquitos, técnicas y patrones reutilizables: no *qué* hay que probar, sino *cómo se le ocurre a uno*
  ]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

Un *galerazo* es una idea que uno saca de la galera: el paso que, visto de afuera, parece magia,
y que en realidad responde a un patrón que se puede reconocer y reutilizar. A diferencia de
`ejemplos.typ`, acá no interesa el enunciado concreto sino la *maniobra*; a diferencia de
`apuntes.typ`, un galerazo no es teoría de la materia y no se cita como resultado.

Cada entrada arranca por el *disparador*: la pregunta que la hizo aparecer. Después viene la
idea en dos frases, la *señal* que permite reconocer cuándo se aplica, por qué funciona, las
variantes de la misma familia y cómo reconstruirla de cero si uno se la olvidó.

#v(6pt)

#show table.cell.where(y: 0): set text(fill: white, weight: "bold", size: 8.5pt)

#table(
  columns: (0.35fr, 2.4fr, 1.5fr),
  align: (center + horizon, left + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#86198f") } else if calc.even(y) { rgb("#fdf4ff") } else { white },
  stroke: 0.4pt + rgb("#e9d5ff"),
  inset: (x: 6pt, y: 4pt),

  [*\#*], [*Galerazo*], [*Cuándo se dispara*],
  [G-1],
  [Aplastar $RR$ dentro de un intervalo acotado],
  [Hay que exhibir una biyección entre algo no acotado y algo acotado],

  [G-2],
  [Mudar un intervalo a otro con una afín],
  [Ya tengo una biyección hacia un intervalo, pero me piden otro],
)

#v(8pt)

== Galerazo 1 · Aplastar $RR$ dentro de un intervalo acotado

#disparador[
  Ya sé que $f(x) = x / (1 + abs(x))$ es una biyección de $RR$ en $(-1, 1)$, pero...
  ¿cómo se me puede *ocurrir* a mí esa función? ¿Qué pista me dice "che, esta función
  va de $RR$ en $(-1,1)$"?
]

#galerazo[G-1][
  Para meter toda la recta dentro de un intervalo acotado alcanza con *dividir por algo que
  crezca al mismo ritmo que $x$*: el cociente se autorregula, vale $approx x$ cerca del origen
  y se frena contra una asíntota horizontal en los extremos. Cualquier función estrictamente
  creciente con dos asíntotas horizontales, una en $a$ y otra en $b$, es una biyección
  $RR -> (a,b)$.
]

=== La señal

La pista no está en la fórmula sino en el *tipo* de la función que se pide. Si aparece

$ f: RR -> (a, b) quad "con" (a,b) "acotado", $

lo que se está pidiendo es *aplastar* una recta infinita adentro de un segmento. Y aplastar
algo infinito en algo finito, sin romper la inyectividad, sólo se puede hacer de una manera:
que la función siga creciendo siempre, pero cada vez menos, acercándose a un techo que nunca
toca. Eso es exactamente una asíntota horizontal.

De ahí sale la traducción mental que conviene automatizar:

#sublema(titulo: "Traducción")[
  *"Biyección de $RR$ a un intervalo acotado"* $==>$ *"función con forma de S: estrictamente
  monótona, con asíntota horizontal en cada extremo"*.

  Los bordes $a$ y $b$ quedan afuera del codominio justamente porque son asíntotas: se
  aproximan, no se alcanzan. Por eso el intervalo es *abierto*.
]

=== Por qué funciona: mirar las asíntotas

Con $f(x) = x / (1 + abs(x))$ el comportamiento se lee sin hacer ninguna cuenta:

- Si $x -> +infinity$, entonces $f(x) = x / (1 + x) -> 1$, y nunca llega a $1$ porque el $+1$
  del denominador siempre "sobra" un poquito.
- Si $x -> -infinity$, entonces $f(x) = x / (1 - x) -> -1$, por el mismo motivo.
- Si $x approx 0$, el denominador es $approx 1$ y queda $f(x) approx x$: cerca del origen se
  comporta como la identidad.

Esa combinación --- identidad cerca del cero, asíntotas en los extremos --- es toda la
construcción. El denominador *domina* y achata la función contra $plus.minus 1$.

#align(center)[
  #cetz.canvas({
    plot.plot(
      size: (9, 4.2),
      x-min: -6, x-max: 6,
      y-min: -1.45, y-max: 1.45,
      x-tick-step: 2,
      y-tick-step: 1,
      x-label: $x$,
      y-label: $f(x)$,
      axis-style: "school-book",
      {
        plot.add(
          ((-6, 1), (6, 1)),
          style: (stroke: (paint: rgb("#94a3b8"), dash: "dashed", thickness: 0.7pt)),
        )
        plot.add(
          ((-6, -1), (6, -1)),
          style: (stroke: (paint: rgb("#94a3b8"), dash: "dashed", thickness: 0.7pt)),
        )
        plot.add(
          domain: (-6, 6),
          samples: 200,
          x => x / (1 + calc.abs(x)),
          style: (stroke: rgb("#c026d3") + 1.6pt),
        )
      },
    )
  })
]

La monotonía se chequea en un renglón. Para $x >= 0$,

$ f(x) = x / (1 + x) = 1 - 1 / (1 + x), $

que es estrictamente creciente porque $1 / (1+x)$ es estrictamente decreciente; y como $f$ es
*impar* ($f(-x) = -f(x)$), lo mismo vale en todo $RR$. Estrictamente creciente $==>$ inyectiva;
las asíntotas en $plus.minus 1$ más la continuidad (Bolzano) dan la sobreyectividad sobre
$(-1,1)$.

=== La familia entera

Todas estas funciones son el mismo galerazo con distinto disfraz --- misma forma de S, planas
en los extremos, con pendiente positiva en el medio, sin tocar nunca las asíntotas:

#show table.cell.where(y: 0): set text(fill: white, weight: "bold", size: 8.5pt)

#table(
  columns: (1.5fr, 0.9fr, 1.2fr),
  align: (left + horizon, center + horizon, center + horizon),
  fill: (x, y) => if y == 0 { rgb("#86198f") } else if calc.even(y) { rgb("#fdf4ff") } else { white },
  stroke: 0.4pt + rgb("#e9d5ff"),
  inset: (x: 8pt, y: 9pt),

  [*Función*], [*Asíntotas*], [*Biyección*],
  [$display(x / (1 + abs(x)))$], [$plus.minus 1$], [$RR -> (-1, 1)$],
  [$display(x / sqrt(1 + x^2))$], [$plus.minus 1$], [$RR -> (-1, 1)$],
  [$display(tanh(x) = (e^x - e^(-x)) / (e^x + e^(-x)))$], [$plus.minus 1$], [$RR -> (-1, 1)$],
  [$display(2 / pi arctan(x))$], [$plus.minus 1$], [$RR -> (-1, 1)$],
  [$display(1 / (1 + e^(-x)))$ (sigmoide)], [$0$ y $1$], [$RR -> (0, 1)$],
)

#observacion[
  Para llegar a un intervalo cualquiera $(a,b)$ no hace falta una función nueva: se compone con
  una afín que lleve $(-1,1)$ en $(a,b)$, y componer biyecciones da una biyección. Así que este
  galerazo se reduce siempre al caso modelo $RR -> (-1,1)$; la mudanza de intervalo es el
  *Galerazo 2*.
]

=== Por qué en cardinalidad se usa justo $x / (1 + abs(x))$

Porque es *puramente algebraica*: no aparecen $e^x$ ni $arctan$, y entonces la inversa también
sale con álgebra de secundaria. Despejando en $y = x / (1 + abs(x))$, con $x >= 0$ (donde
$y >= 0$ y $abs(y) = y$):

$ y (1 + x) = x ==> y = x (1 - y) ==> x = y / (1 - y), $

y por imparidad, en general

$ f^(-1)(y) = y / (1 - abs(y)), quad y in (-1, 1). $

Exhibir la inversa explícita es, de hecho, la forma más corta de terminar el ejercicio: no hace
falta invocar monotonía, continuidad ni Bolzano, alcanza con verificar
$f^(-1) compose f = id$ y $f compose f^(-1) = id$. Con $tanh$ o $arctan$ la inversa existe
igual, pero hay que arrastrar logaritmos o funciones trascendentes.

=== Cómo inventarla de cero

Si uno no se la acuerda, se reconstruye en tres pasos:

+ *Quiero que cerca de $0$ se parezca a $x$*, para que sea inyectiva ahí y pase por el origen:
  el numerador va a ser $x$.
+ *Quiero que para $x$ grande el valor se acerque a una cota fija sin superarla*: hay que
  dividir por algo.
+ *Elijo el denominador más simple que valga $approx 1$ cerca del $0$ y que crezca al mismo
  ritmo que $abs(x)$ para $x$ grande.* Ahí aparecen solos $1 + abs(x)$ o $sqrt(1 + x^2)$.

El galerazo no es la fórmula: es el patrón *"cociente que se autorregula"* más la elección del
denominador más barato que cumpla las dos condiciones.

=== Dónde se usa

- Coordinabilidad: probar que $abs(RR) = abs((-1,1)) = abs((a,b))$ para todo intervalo abierto
  no vacío, y de ahí que todo intervalo abierto tenga el cardinal del continuo.
- Cualquier ejercicio que pida una biyección explícita entre un conjunto no acotado y uno
  acotado, donde el argumento de Cantor--Bernstein sería un martillo demasiado grande.

#v(8pt)

== Galerazo 2 · Mudar un intervalo a otro con una afín

#disparador[
  Ok, pero quiero un ejemplo concreto: supongamos que busco una biyección $RR -> (-3, 7)$.
  ¿Tengo que empezar de cero?
]

#galerazo[G-2][
  No: la biyección nueva no se construye, se *recicla*. Se agarra una que ya se tiene ---
  típicamente $f: RR -> (-1,1)$, el Galerazo 1 --- y se la compone con una *afín*
  $phi(t) = m t + c$ que mande el intervalo viejo en el nuevo. Toda afín con pendiente
  $m != 0$ es biyectiva, y componer biyecciones da una biyección: la verificación sale gratis.
]

=== La señal

La señal es tener *el intervalo equivocado*: ya hay en la mochila una biyección hacia
$(-1,1)$ (o hacia $(0,1)$), y el ejercicio pide $(-3,7)$, o $(a,b)$, o comparar dos intervalos
entre sí. En cuanto los dos conjuntos son intervalos abiertos acotados, la diferencia entre
ellos es *sólo de escala y posición* --- y eso es exactamente lo que arregla una afín.

#sublema(titulo: "Traducción")[
  *"Me piden un intervalo distinto del que tengo"* $==>$ *"componer con la afín que lleva los
  extremos viejos en los extremos nuevos"*. Nunca se rehace la parte difícil.
]

=== Por qué funciona

Una afín $phi(t) = m t + c$ con $m != 0$ es biyectiva de $RR$ en $RR$, con inversa explícita
$phi^(-1)(y) = (y - c) \/ m$; restringida a un intervalo, es una biyección sobre su imagen, que
es de nuevo un intervalo (es continua y estrictamente monótona: creciente si $m > 0$,
decreciente si $m < 0$). Y la composición de dos biyecciones es una biyección.

Por eso la verificación no cuesta nada: no hay que volver a probar inyectividad ni
sobreyectividad de la parte complicada, alcanza con exhibir la afín y decir *composición de
biyecciones*.

=== El caso concreto: $RR -> (-3, 7)$

*Paso 1 --- hallar la afín $(-1,1) -> (-3,7)$.* Hay que mandar $-1 |-> -3$ y $1 |-> 7$, así que
$phi(t) = m t + c$ tiene que cumplir

$ phi(-1) = -m + c = -3, quad phi(1) = m + c = 7. $

Sumando las dos ecuaciones, $2c = 4$, o sea $c = 2$; restándolas, $2m = 10$, o sea $m = 5$.
Queda

$ phi(t) = 5 t + 2. $

*Chequeo:* $phi(-1) = -5 + 2 = -3$, $phi(1) = 5 + 2 = 7$, y $phi(0) = 2$, que es el punto medio
de $(-3,7)$ --- como tiene que ser, porque $0$ es el punto medio de $(-1,1)$.

*Paso 2 --- componer con la de siempre.*

$ g = phi compose f : RR -> (-3, 7), quad g(x) = 5 dot x / (1 + abs(x)) + 2. $

*Paso 3 --- verificar (gratis).* $f: RR -> (-1,1)$ es biyectiva (Galerazo 1) y
$phi: (-1,1) -> (-3,7)$ es biyectiva por ser afín con pendiente $5 != 0$. Entonces
$g = phi compose f$ es biyectiva. Si se quiere la inversa explícita, también se compone:

$ g^(-1) = f^(-1) compose phi^(-1), quad
  g^(-1)(y) = ((y - 2) \/ 5) / (1 - abs((y - 2) \/ 5)), quad y in (-3, 7). $

=== La fórmula general

Para cualquier $(a,b)$ acotado no hace falta rehacer el sistema: la afín que lleva $(-1,1)$ en
$(a,b)$ manda el $0$ al punto medio y estira por el semiancho,

$ g(x) = underbrace((a + b) / 2, "punto medio") + underbrace((b - a) / 2, "semiancho") dot f(x), $

con $f(x) = x \/ (1 + abs(x))$, o $tanh$, o $(2 \/ pi) arctan$ --- la que se prefiera. Con
$a = -3$ y $b = 7$: punto medio $2$, semiancho $5$, exactamente lo de arriba.

Si el punto de partida es $(0,1)$ en lugar de $(-1,1)$, la afín es todavía más simple:
$phi(t) = a + (b - a) t$.

=== Cómo inventarlo de cero

+ *Identificar qué biyección ya tengo* y hacia qué intervalo llega. Esa es la parte que no se
  toca.
+ *Plantear $phi(t) = m t + c$ y pedirle que mande extremo viejo en extremo nuevo.* Son dos
  ecuaciones con dos incógnitas: siempre tiene solución única, y $m != 0$ porque los extremos
  nuevos son distintos entre sí.
+ *Componer y declarar la victoria*: composición de biyecciones. No rehacer inyectividad ni
  sobreyectividad.

El atajo mental, para no plantear el sistema cada vez: *el centro va al centro y el ancho se
multiplica*. Los dos coeficientes son el punto medio y el semiancho del intervalo destino.

=== Dónde se usa

- Probar que todo intervalo abierto acotado $(a,b)$ es coordinable con $(0,1)$ --- con
  $g(x) = (x + 1) \/ 2$ como caso particular de $(-1,1) -> (0,1)$ --- y, encadenando con el
  Galerazo 1, que $abs((a,b)) = abs(RR)$.
- Comparar dos intervalos cualesquiera entre sí sin pasar por $RR$: la afín va directo de uno al
  otro.
- Cualquier ejercicio donde ya se resolvió un caso modelo y el enunciado pide una variante
  desplazada o reescalada.
