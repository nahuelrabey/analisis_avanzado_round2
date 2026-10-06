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
`ejemplos/`, acá no interesa el enunciado concreto sino la *maniobra*; a diferencia de
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

  [G-3],
  [La firma $X -> Y$ es una afirmación, no una etiqueta],
  [Definí una función por una fórmula o por ramas y hay que ver que está bien definida],

  [G-4],
  [La segunda composición no se rehace],
  [Ya verifiqué una composición y la otra "sale igual"],

  [G-5],
  [El primer índice: capturar dónde aparece por primera vez],
  [Un conjunto se define restando todo lo anterior, y hay que ubicar un elemento en él],

  [G-6],
  [La inducción no cruza al límite],
  [Hay que probar algo de una unión infinita y tengo la propiedad en cada escalón finito],

  [G-7],
  [La diagonal vive adentro de todos los pares],
  [Hay un supremo de una operación término a término entre dos sucesiones],

  [G-8],
  [Compacto y continua: el supremo es un máximo],
  [Hay un sup o ínf de una función continua sobre $[a, b]$ y necesito que sea finito o que se alcance],

  [G-9],
  [Sándwich $NN arrow.hook S arrow.hook QQ$: todo intervalo tiene $aleph_0$ racionales],
  [Hay que ver que un subconjunto de $QQ$ (por ejemplo $(a, b) inter QQ$) tiene cardinal $aleph_0$],
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

#block(breakable: false, width: 100%)[#align(center)[
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
]]

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

#v(8pt)

== Galerazo 3 · La firma $X -> Y$ es una afirmación, no una etiqueta

#disparador[
  Cuando defino una función con una fórmula *veo* que anda --- lo veo desde el momento en que se
  me ocurre la idea --- pero no sé qué hay que escribir para justificarlo. Y ya van tres
  ejercicios seguidos en los que el único hueco que me queda es ése.
]

#galerazo[G-3][
  Escribir $f : X -> Y$ no es etiquetar la fórmula: es *afirmar* dos cosas que hay que probar
  --- que la fórmula esté definida en todo $X$, y que su valor caiga en $Y$ ---. La segunda
  mitad se verifica *una condición por vez*, leyendo cómo está descrito $Y$. Es la verificación
  más barata que existe y la que más errores atrapa: cuando la firma está mal, falla acá, antes
  de gastar media página en componer.
]

=== La señal

La señal no es una hipótesis del enunciado: es un *momento de la escritura*. Cada vez que uno
escribe una flecha seguida de una fórmula, o de una definición por ramas,

$ f : X -> Y, quad f(x) = dots $

acaba de contraer una deuda. Y nada de lo que venga después --- inyectividad, sobreyectividad,
inversas, composiciones --- significa nada hasta que esa deuda esté saldada: si $f(x)$ se sale
de $Y$, la expresión $g compose f$ ni siquiera tiene sentido, porque $g$ no sabe qué hacer con
lo que le llega.

#sublema(titulo: "Traducción")[
  *"Defino $f : X -> Y$ tal que $f(x) = dots$"* $==>$ *"tengo que probar que la fórmula tiene
  sentido para todo $x in X$, y que $f(x)$ cumple todas las condiciones que definen a $Y$"*.

  Cuántas cosas hay que verificar no lo decide la fórmula: lo decide *la descripción de $Y$*.
  Una condición en $Y$, una línea de verificación.
]

=== Por qué funciona: qué es exactamente lo que se debe

Son tres obligaciones, y ninguna es opcional:

+ *Que esté definida en todo $X$.* La fórmula tiene que tener sentido en cada punto: sin
  denominadores nulos, sin raíces de negativos. Si la definición es por ramas, además las ramas
  tienen que *cubrir* todo $X$.
+ *Que no sea ambigua.* Sólo aparece en las definiciones por ramas: dos ramas no pueden pisarse,
  o el mismo $x$ tendría dos valores. Se resuelve exhibiendo la disjunción.
+ *Que los valores caigan en $Y$.* Una verificación por cada condición que describe a $Y$.

La tercera es la que se saltea siempre, y es la más rentable de las tres: es mecánica, ocupa un
renglón por condición, y es la única que detecta un error de *tipo* --- una flecha mal escrita
--- que de otro modo recién se manifiesta media demostración después, disfrazado de cuenta que
no cierra.

#observacion[No confundirla con la sobreyectividad][
  La obligación es $"Im" f subset.eq Y$, no $"Im" f = Y$. Que la imagen *alcance* todo el
  codominio es otra propiedad, se prueba aparte y muchas veces sale gratis al exhibir la
  inversa. Confundirlas cuesta doble: se escribe de más y, peor, se deja sin hacer el chequeo
  barato --- que es el que hacía falta.
]

=== La familia entera: cómo se disfraza el codominio

El trabajo a hacer no cambia; lo que cambia es en cuántas condiciones se parte $Y$.

#table(
  columns: (1.1fr, 1.9fr),
  align: (left + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#86198f") } else if calc.even(y) { rgb("#fdf4ff") } else { white },
  stroke: 0.4pt + rgb("#e9d5ff"),
  inset: (x: 6pt, y: 4pt),

  [*$Y$ viene descrito como...*], [*...y entonces hay que verificar*],

  [Un conjunto numérico cerrado por operaciones ($QQ$)],
  [Que ninguna de las operaciones usadas se salga del conjunto],

  [Una condición de desigualdad ($abs(y) < 1$)],
  [La desigualdad, despejada para un $x$ genérico],

  [Una intersección de las dos ($(-1,1) inter QQ$)],
  [Las dos cosas, una línea cada una],

  [Una diferencia de conjuntos ($B - A$)],
  [Que el valor esté en $B$ *y además* que no esté en $A$],

  [Una pieza de una partición],
  [Que el valor caiga en esa pieza, no en otra],

  [Todo el conjunto de llegada sin condiciones ($QQ$ como codominio pleno)],
  [Nada extra: no hay tercera obligación],
)

=== Los dos ejercicios que lo destaparon

*Caso 1 --- una fórmula con dos condiciones en el codominio* (`p2: Ej. 1(d)`).

Se define $f : QQ -> (-1,1) inter QQ$ con $f(x) = x \/ (1 + abs(x))$ (Galerazo 1). El codominio
tiene dos condiciones, así que hay exactamente tres cosas que verificar, y las tres son de un
renglón. Dado $q in QQ$:

+ *Definida:* $1 + abs(q) >= 1 > 0$, nunca se anula.
+ *Racional:* $abs(q)$ es $q$ o $-q$, y los dos están en $QQ$; y $QQ$ es cerrado por suma y por
  cociente con denominador no nulo. Entonces $f(q) in QQ$.
+ *Módulo menor que 1:* como $1 + abs(q) > 0$, la desigualdad $abs(f(q)) < 1$ equivale a
  $abs(q) < 1 + abs(q)$, es decir a $0 < 1$.

Para la inversa $g : (-1,1) inter QQ -> QQ$, $g(x) = x \/ (1 - abs(x))$, la lista es más corta:
está definida porque $abs(x) < 1$ da $1 - abs(x) > 0$, y $g(x) in QQ$ por el mismo argumento de
cuerpo. No hay tercera obligación, porque el codominio es *todo* $QQ$ y no impone ninguna
condición. Esa asimetría entre las dos listas no es descuido: se lee de cómo está descrito cada
codominio.

#sublema(titulo: "Lo que el chequeo atrapa")[
  El primer intento de ese ejercicio fue $f(x) = abs(x) \/ (1 + abs(x))$. La tercera
  verificación lo mata en un renglón: $f(q) >= 0$ para todo $q$, así que la imagen queda dentro
  de $[0,1) inter QQ$ y ningún racional negativo tiene preimagen. Sin ese chequeo, el error
  recién apareció al final, cuando la composición dio $abs(x)$ en lugar de $x$ --- media página
  después.
]

*Caso 2 --- dos funciones por ramas entre conjuntos abstractos* (`p2: Ej. 3(b)`).

Con $A subset.eq B$, $C subset.eq B - A$ y $f : C -> A union C$ biyectiva, se definen

$ phi : B - A -> B, quad
  phi(x) = cases(f(x) & "si" x in C, x & "si" x in B - (A union C)) $

$ psi : B -> B - A, quad
  psi(x) = cases(f^(-1)(x) & "si" x in A union C, x & "si" x in B - (A union C)) $

Acá las tres obligaciones se ven separadas con toda claridad:

+ *Cubren el dominio:* son exactamente las dos uniones disjuntas del principio,
  $B - A = C union [B - (A union C)]$ y $B = (A union C) union [B - (A union C)]$.
+ *No se pisan:* por la disjunción de esas mismas uniones, ningún $x$ cae en dos ramas.
+ *Caen en el codominio:* para $phi$, $f(x) in A union C subset.eq B$ y
  $x in B - (A union C) subset.eq B$; para $psi$, $f^(-1)(x) in C subset.eq B - A$ y
  $x in B - (A union C) subset.eq B - A$.

#sublema(titulo: "Lo que el chequeo atrapa")[
  El primer intento de ese ejercicio tenía las dos flechas cruzadas: $phi : B -> B - A$ con la
  regla de arriba. Las obligaciones 1 y 3 lo detectan por separado y de inmediato --- las ramas
  sólo cubrían $B - A$, no $B$; y para $x in C$ el valor $f(x) in A union C$ no está contenido
  en $B - A$ ---. Sin ese chequeo, el error sobrevivió hasta las composiciones, donde se
  manifestó como identidades con el subíndice equivocado.
]

=== Cómo inventarlo de cero

+ *Escribir la flecha y subrayar el codominio.* La deuda nace ahí, no en la fórmula.
+ *Desarmar el codominio en su lista de condiciones.* $(-1,1) inter QQ$ son dos; $B - A$ es una
  pertenencia y una no-pertenencia; $QQ$ solo no es ninguna.
+ *Tomar un $x$ genérico del dominio y recorrer la lista*, un renglón por condición. Si la
  definición es por ramas, hacerlo rama por rama, y antes chequear que cubran y no se pisen.
+ *Si alguna condición no sale, no arreglar la cuenta: revisar la flecha.* En los dos casos de
  arriba lo que estaba mal era la firma, no el álgebra. Una verificación que se resiste suele
  estar diciendo que el codominio declarado no es el verdadero.

El atajo mental: *la flecha es una promesa, y las tres obligaciones son la factura*. Se paga al
escribirla, que es cuando sale barata.

=== Dónde se usa

- `p2: Ej. 1(d)` --- $f : QQ -> (-1,1) inter QQ$: racionalidad más desigualdad.
- `p2: Ej. 3(b)` --- $phi$ y $psi$ por ramas: cobertura, disjunción y pertenencia a la pieza.
- Toda definición por ramas, siempre: las tres obligaciones son el precio fijo del `cases`.
- Al componer (Galerazo 2, $phi compose f$): la firma es justamente lo que tiene que encajar
  --- el codominio de la primera contenido en el dominio de la segunda --- así que este chequeo
  es la condición de entrada para poder usar "composición de biyecciones" sin mentir.

#v(8pt)

== Galerazo 4 · La segunda composición no se rehace

#disparador[
  Ya verifiqué $f compose f^(-1) = id$. ¿No existe una forma más compacta de señalar que
  $f^(-1) compose f = id$ también, sin tener que hacer toda la cuenta de nuevo?
]

#galerazo[G-4][
  Verificada una de las dos composiciones, la otra *no se rehace*: o se la deduce de un lema
  --- inversa a un lado más una hipótesis mínima --- o se señala con precisión la simetría de
  la cuenta, diciendo qué se intercambia y qué se simplifica. Lo único que nunca alcanza es
  escribir *"análogamente"* a secas: eso no es un atajo, es un agujero.
]

=== La señal

Estás probando que $g$ es la inversa de $f$, ya hiciste una de las dos composiciones, y la
segunda *tiene la misma pinta*. La tentación es cerrarla con "la otra sale igual". El problema
es que "igual" no es una afirmación: no dice qué se conserva ni qué cambia, y el lector --- o
el corrector --- no tiene con qué verificarla.

#sublema(titulo: "Traducción")[
  *"Ya verifiqué un lado y el otro se ve igual"* $==>$ *"o cito el lema de inversa a un lado, o
  digo exactamente qué se intercambia en la cuenta y qué paso se vuelve innecesario"*.

  Las dos salidas son legítimas y cuestan dos renglones. La tercera, "análogamente" sin más,
  cuesta cero y no prueba nada.
]

=== Por qué funciona: el lema de la inversa a un lado

#sublema(titulo: "Lema (inversa a un lado + inyectividad)")[
  Sean $f : X -> Y$ y $g : Y -> X$ tales que $f compose g = id_Y$. Si además $f$ es inyectiva,
  entonces $g compose f = id_X$, y por lo tanto $g$ es la inversa de $f$.
]

*Demostración.* Sea $x in X$. Aplicando $f$ a $g(f(x))$ y usando la hipótesis en el punto
$f(x) in Y$,

$ f(g(f(x))) = (f compose g)(f(x)) = id_Y (f(x)) = f(x). $

Es decir, $f$ toma el mismo valor en $g(f(x))$ y en $x$. Como $f$ es inyectiva, esos dos puntos
son el mismo: $g(f(x)) = x$. Como $x$ era arbitrario, $g compose f = id_X$. $qed$

La hipótesis extra *no sobra*. Con $f compose g = id_Y$ sola, lo único que se deduce es que $f$
es sobreyectiva y $g$ inyectiva, y eso no basta:

#sublema(titulo: "Por qué hace falta la hipótesis extra")[
  Tomemos $X = Y = NN$, con $g(n) = n + 1$ y

  $ f(n) = cases(n - 1 & "si" n >= 2, 1 & "si" n = 1) $

  Entonces $(f compose g)(n) = f(n+1) = n$ para todo $n$, o sea $f compose g = id_NN$. Pero
  $(g compose f)(1) = g(1) = 2 != 1$, así que $g compose f != id_NN$. Coherente con el lema:
  esta $f$ no es inyectiva, porque $f(1) = f(2) = 1$.
]

=== La familia entera: las tres salidas

#table(
  columns: (1fr, 1.6fr),
  align: (left + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#86198f") } else if calc.even(y) { rgb("#fdf4ff") } else { white },
  stroke: 0.4pt + rgb("#e9d5ff"),
  inset: (x: 6pt, y: 4pt),

  [*Salida*], [*Qué hay que pagar*],

  [Lema con $f$ inyectiva],
  [Probar que $f$ es inyectiva. Conviene si eso sale más barato que la cuenta],

  [Dual con $g$ sobreyectiva],
  [Probar que $g$ es sobreyectiva. Mismo espíritu: $x = g(y)$ y entonces
   $g(f(x)) = g((f compose g)(y)) = g(y) = x$],

  [Simetría explícita de la cuenta],
  [Nombrar la sustitución que lleva una composición en la otra, y qué paso desaparece],

  [_"Análogamente"_ a secas],
  [Nada, y por eso no prueba nada],
)

=== La salida por simetría, en concreto

Con $f(x) = x \/ (1 + abs(x))$ y $f^(-1)(x) = x \/ (1 - abs(x))$ las dos cuentas son

$
  (f compose f^(-1))(x) &= x/(1 - abs(x)) dot ((1 - abs(x) + abs(x))/(1 - abs(x)))^(-1) \
  (f^(-1) compose f)(x) &= x/(1 + abs(x)) dot ((1 + abs(x) - abs(x))/(1 + abs(x)))^(-1)
$

o sea *la misma cuenta con $1 - abs(x)$ y $1 + abs(x)$ intercambiados*: en las dos el numerador
del paréntesis se cancela a $1$ y queda $x$. Y hay un detalle que conviene decir, porque es lo
que vuelve honesta la analogía: el único paso de la primera que pedía justificación era
$abs(1 - abs(x)) = 1 - abs(x)$, que necesitaba $abs(x) < 1$. Su análogo en la segunda es
$abs(1 + abs(x)) = 1 + abs(x)$, que vale sin ninguna hipótesis. La segunda cuenta no es
parecida a la primera: es *estrictamente más fácil*.

=== Cuándo no aplica

Si las dos composiciones se calculan sobre *particiones distintas del dominio*, no hay simetría
que señalar y hay que hacer las dos. Es el caso de las funciones definidas por ramas: en
`p2: Ej. 3 (b)`, $phi compose psi$ se parte según $B - (A union C)$ y $A union C$, mientras que
$psi compose phi$ se parte según $B - (A union C)$ y $C$. Son análisis de casos distintos, y
ahí "análogamente" tapa justamente lo que cambia. La salida por el lema, en cambio, sigue
disponible.

=== Cómo inventarlo de cero

+ *Escribir las dos composiciones una debajo de la otra*, sin resolverlas. La simetría --- o su
  ausencia --- se ve ahí, no en el resultado.
+ *Si son la misma cuenta con una sustitución*: nombrarla, y decir qué paso delicado desaparece
  en la segunda.
+ *Si no son simétricas*: buscar la hipótesis más barata entre inyectividad de $f$ y
  sobreyectividad de $g$, y cerrar con el lema.
+ *Nunca escribir "análogamente" sin completar con qué.* Si no se puede completar, es porque no
  era análogo.

=== Dónde se usa

- `p2: Ej. 1 (d)` --- $f(x) = x \/ (1 + abs(x))$: las dos composiciones son simétricas, sirve
  la salida corta.
- `p2: Ej. 3 (b)` --- $phi$ y $psi$ por ramas: no son simétricas, ver *Cuándo no aplica*.
- En general, cada vez que se exhibe una inversa explícita para probar una biyección, que es la
  forma canónica de resolver los ejercicios de cardinalidad de la práctica 2.

#sublema(titulo: "Pendiente --- buscar fuente")[
  El enunciado y la demostración del lema de arriba, el contraejemplo de $NN$ y la lectura por
  simetría *fueron reconstruidos en conversación*, no copiados de la bibliografía. El resultado
  es estándar (aparece en los capítulos de funciones bajo los nombres *inversa a izquierda* e
  *inversa a derecha*), pero acá no está verificado contra ninguna fuente.

  Antes de citarlo en una entrega: buscarlo en `apuntes-docentes/bibliografia` y en las notas de
  la materia, y en cuanto aparezca, reemplazar esta caja por la referencia exacta --- libro,
  capítulo y numeración --- y anotar si la cátedra lo enuncia con la hipótesis de inyectividad
  de $f$ o con la de sobreyectividad de $g$.
]

#v(8pt)

== Galerazo 5 · El primer índice: capturar dónde aparece por primera vez

#disparador[
  Tengo $x in union.big_(n <= m) A_n$, y los $B_n$ están definidos restando todo lo anterior
  --- $B_n = A_n - union.big_(k < n) B_k$ ---. ¿Cómo encuentro *cuál* $B_n$ contiene a $x$, si
  para saberlo necesito que $x$ no haya caído en ninguno de los $B_k$ previos?
]

#galerazo[G-5][
  Cuando un elemento aparece en varios conjuntos de una familia indexada por $NN$ y hay que
  ubicarlo en una construcción que *recorta lo ya visto*, tomá el *primer* índice donde
  aparece --- el mínimo, que existe por buena ordenación de $NN$ ---. La minimalidad te regala
  gratis lo que la construcción pide: que no haya aparecido antes.
]

=== La señal

La señal no es "hay un mínimo que tomar": es el *tipo de construcción* con el que estás
lidiando. Si tenés una familia $(C_n)_(n in NN)$ definida por

$ C_n = D_n - union.big_(k < n) C_k $

--- recortando en cada paso lo que ya apareció --- y necesitás decidir en qué $C_n$ vive un
elemento $x$ que sabés que está en algún $D_n$, la pregunta correcta nunca es "¿en cuál cae
$x$?" sino *"¿cuál es el primer $D_n$ en el que aparece $x$?"*. La respuesta a esa segunda
pregunta es, casi siempre, la respuesta a la primera.

#sublema(titulo: "Traducción")[
  *"Necesito ubicar $x$ en una construcción que resta lo anterior"* $==>$ *"tomo el mínimo
  índice donde $x$ aparece en la familia original, y esa minimalidad es la que hace andar la
  resta"*.
]

=== Por qué funciona

El mecanismo tiene dos pasos, y el segundo es el que se suele olvidar.

*Paso 1 --- conseguir el mínimo.* Si $x in union.big_(n <= m) D_n$, el conjunto de índices

$ S = {j <= m : x in D_j} $

es no vacío. Por buena ordenación de $NN$, $S$ tiene mínimo: llamalo $k$. Por definición de
mínimo, valen dos cosas a la vez --- $k in S$ (es decir $x in D_k$) *y* $j in.not S$ para todo
$j < k$ (es decir $x in.not D_j$ para todo $j < k$) ---. La segunda es la que realmente se
usa; la primera es sólo la entrada.

*Paso 2 --- trasladar la minimalidad a los $C$.* Acá es donde el galerazo hace el trabajo. Si
ya sabés que $C_j subset.eq D_j$ para todo $j$ (algo que suele probarse aparte, y casi
gratis: $C_j$ es $D_j$ menos algo), el contrarrecíproco te dice: $x in.not D_j ==> x in.not
C_j$. Aplicado a cada $j < k$: $x in.not C_j$ para todo $j < k$, es decir

$ x in.not union.big_(j < k) C_j. $

Y eso es *exactamente* lo que la definición $C_k = D_k - union.big_(j<k) C_j$ necesita junto
con $x in D_k$ para concluir $x in C_k$.

La minimalidad nunca se usa para nada más que esto: convertir "no apareció antes en los $D$"
en "no apareció antes en los $C$", vía la inclusión $C_j subset.eq D_j$.

=== Cuándo no hace falta

El mínimo no es la única salida, y a veces hay una más corta. Fijate el caso concreto: dado
*cualquier* $k <= m$ con $x in D_k$ (no necesariamente el mínimo), separá en dos casos según
$x in union.big_(j<k) C_j$ o no:

- si *no* está, la definición te da directo $x in C_k$;
- si *sí* está, entonces $x in C_i$ para algún $i < k <= m$, y con ese $i$ ya alcanza.

Esta dicotomía no necesita saber *cuál* $k$ elegiste, ni que sea mínimo: cualquiera sirve,
porque si no es el que atrapa a $x$, algún anterior ya lo hizo. Es más corta que el argumento
del mínimo --- no hace falta invocar buena ordenación --- pero es *menos informativa*: no te
dice en qué $C_n$ vive $x$, sólo que vive en alguno con índice $<= m$. El mínimo, en cambio,
identifica exactamente cuál. Si sólo te importa la pertenencia a la unión, andá por la
dicotomía; si te importa *cuál* $C_n$, el mínimo es insustituible.

=== Dónde se usa

- `p2: Ej. 5 (a)` --- la disjointificación $B_n = A_n - union.big_(k<n) B_k$: es el ejemplo que
  disparó este galerazo, y donde también aparece la salida corta de la sección anterior.
- *Proposición 3.13* de `apuntes.typ` (Subconjuntos de Conjuntos Numerables) usa la misma idea
  para enumerar $B$: define $g(1) = a_(j_1)$ con $j_1 = op("mín"){j : a_j in B}$, el primer
  elemento de $B$ que aparece listado en $A$, y sigue inductivamente descontando lo ya
  encontrado --- es el mismo patrón de "primer índice" aplicado a construir una enumeración en
  vez de a probar una pertenencia.
- Cualquier construcción de "unión contable de conjuntos, hecha disjunta" --- la técnica se
  llama *disjointificación* y reaparece fuera de esta materia, por ejemplo en teoría de la
  medida, con la misma estructura exacta.

#v(8pt)

== Galerazo 6 · La inducción no cruza al límite

#disparador[
  ¿Es posible usar inducción para hacer esta demostración? Me han comentado que tengo que
  tener cuidado con la inducción en uniones infinitas, porque hay cosas que no cierran o que
  rompen otras. No lo tengo muy claro.
]

#galerazo[G-6][
  La inducción concluye exactamente una cosa: $forall m in NN, P(m)$. La unión infinita
  $union.big_(n in NN) A_n$ *no es ninguno* de esos escalones $union.big_(n <= m) A_n$, y no
  hay paso $m = infinity$. La regla práctica: las propiedades de los *elementos* pasan al
  límite --- cada $x$ de la unión vive en algún escalón finito ---; las propiedades del
  *conjunto entero* no.
]

=== La señal

La señal es el *sujeto* de lo que hay que probar. Si el objetivo es una propiedad de un objeto
límite --- $union.big_(n in NN) A_n$, $inter.big_(n in NN) A_n$, una serie, un supremo --- y lo
que tenés a mano son afirmaciones sobre los escalones finitos, la inducción no es la
herramienta: te va a probar infinitas afirmaciones, ninguna de las cuales es la que querés.

La trampa es que la inducción *sale bien*. No hay error que detectar: el paso base cierra, el
paso inductivo cierra, y la conclusión es verdadera. Simplemente no es la conclusión pedida.

#sublema(titulo: "Traducción")[
  *"Tengo que probar algo del conjunto $union.big_(n in NN) A_n$ entero"* $==>$ *"la inducción
  me da a lo sumo un lema sobre $union.big_(n <= m) A_n$; el paso al límite necesita otro
  argumento"*.
]

=== Por qué falla

Tomá $A_n = {n}$ y la propiedad $P(m) =$ "$union.big_(n <= m) A_n$ es finito".

- *Paso base.* $union.big_(n <= 1) A_n = {1}$ es finito.
- *Paso inductivo.* Si $union.big_(n <= m) A_n$ es finito, agregarle el elemento $m+1$ lo deja
  finito.

La inducción es impecable y la conclusión, $forall m in NN$ el conjunto $union.big_(n <= m) A_n$
es finito, es verdadera. Y sin embargo

$ union.big_(n in NN) A_n = NN, $

que no es finito. No se rompió nada: la inducción probó otra cosa. El motivo es puramente
estructural ---

$ union.big_(n in NN) A_n eq.not union.big_(n <= m) A_n quad "para ningún" m in NN $

--- y $NN$ no tiene último elemento, así que no hay escalón desde el cual dar el salto.

=== El test que descarta la inducción

Poné las dos propiedades lado a lado, con esa misma familia $A_n = {n}$:

#v(4pt)

#table(
  columns: (1.1fr, 1.2fr, 1.2fr),
  align: (left + horizon, center + horizon, center + horizon),
  fill: (x, y) => if y == 0 { rgb("#86198f") } else if calc.even(y) { rgb("#fdf4ff") } else { white },
  stroke: 0.4pt + rgb("#e9d5ff"),
  inset: (x: 6pt, y: 4pt),

  [*Propiedad*], [*En cada escalón* $union.big_(n <= m) A_n$], [*En la unión* $union.big_(n in NN) A_n$],
  [Es finito], [vale], [*falla*],
  [Es contable], [vale], [vale],
)

#v(4pt)

La inducción ve *exactamente lo mismo* en las dos filas: en ambos casos todos los escalones
cumplen. Por lo tanto no puede distinguir la propiedad que sobrevive de la que se cae, y
cualquier demostración que sí lo haga tiene que usar algo que la inducción no provee.

De ahí sale el test de control: antes de confiar en una inducción sobre escalones, buscá una
propiedad *más fuerte* que también valga en todos los escalones. Si la encontrás y se cae en
el límite, tu inducción no puede estar probando el enunciado.

=== La familia entera: otros objetos límite

El mismo fenómeno, con otro disfraz. En los tres casos la propiedad vale en todos los escalones
y se cae al pasar al límite.

#v(4pt)

#table(
  columns: (0.9fr, 1fr, 1.6fr),
  align: (left + horizon, left + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#86198f") } else if calc.even(y) { rgb("#fdf4ff") } else { white },
  stroke: 0.4pt + rgb("#e9d5ff"),
  inset: (x: 6pt, y: 4pt),

  [*Objeto límite*], [*Los escalones*], [*La propiedad que se cae*],
  [$union.big_(n in NN) A_n$], [$union.big_(n <= m) A_n$],
  [_es finito_, con $A_n = {n}$: cada escalón es ${1, dots, m}$, la unión es $NN$],
  [$inter.big_(n in NN) A_n$], [$inter.big_(n <= m) A_n$],
  [_es no vacío_, con $A_n = {j in NN : j >= n}$: cada escalón es $A_m eq.not emptyset$, la
   intersección es $emptyset$ (ningún $j$ sobrevive a $n = j+1$)],
  [$sum_(n=1)^infinity a_n$], [$sum_(n=1)^m a_n$],
  [_es racional_, con $a_n = 1 \/ n!$: toda suma parcial es racional y el límite es $e - 1$,
   irracional (hecho estándar, fuera de esta materia)],
)

=== Qué sí cruza al límite

Los *elementos*. Por definición de unión,

$ x in union.big_(n in NN) A_n <==> exists k in NN "tal que" x in A_k, $

y ese $k$ es un natural concreto: todo elemento de la unión infinita vive en algún escalón
finito. Por eso el chequeo elemento a elemento sí alcanza el infinito, y por eso la doble
inclusión con un $x$ genérico es la técnica natural para estos objetos.

La asimetría es la clave de todo el galerazo: "ser finito" o "ser numerable" no son propiedades
de ningún $x$ en particular, así que ningún escalón las sostiene. Si tu enunciado se puede
reescribir como "para todo $x$ de la unión, ...", estás del lado bueno; si habla del conjunto
como un todo, no.

=== Cómo inventarlo de cero

+ *Identificá el sujeto.* ¿Lo que hay que probar es una propiedad de los elementos de
  $union.big_(n in NN) A_n$, o del conjunto entero?
+ *Si es de los elementos*, olvidate de la inducción: tomá $x$ genérico, usá $exists k in NN$
  con $x in A_k$ para bajar a un escalón finito, y trabajá ahí. Ese $k$ es finito y hace todo
  el trabajo.
+ *Si es del conjunto entero*, la inducción sólo te va a dar un lema sobre
  $union.big_(n <= m) A_n$. Útil como ingrediente, nunca como conclusión.
+ *Aplicá el test de control*: buscá una propiedad más fuerte que valga en todos los escalones.
  Si se cae en el límite, quedó demostrado que la inducción no puede cerrar el enunciado.
+ *Para el paso al límite*, lo que hay que exhibir es *un solo objeto* --- una función, una
  enumeración, una biyección --- definido para todos los $n$ *a la vez*, no una sucesión de
  construcciones escalón por escalón.

=== Dónde se usa

- `p2: Ej. 6 (a)` --- unión numerable de contables es contable: es el ejercicio que disparó este
  galerazo. La inducción sobre $union.big_(n <= m) A_n$ (con el Ejercicio 2 como paso inductivo)
  prueba el caso finito y no llega a la conclusión.
- `p2: Ej. 5 (b)` --- $A = union.big_(n in NN) B_n$: el caso contrario. El enunciado es sobre
  *elementos*, se resuelve por doble inclusión con un $x$ genérico, y el "$exists k in NN$" es
  exactamente el mecanismo del punto 2 de la receta.
- `p2: Ej. 2` --- $A union B$ contable: el caso finito puro. Es lo que la inducción extiende a
  uniones finitas, y sólo a ellas.
- `p2: Ej. 7 (b)` --- $\# (union.big_(n in NN) A_n) = c$: misma forma, mismo cuidado.

#v(8pt)

== Galerazo 7 · La diagonal vive adentro de todos los pares

#disparador[
  Ya vi que $op("sup")({a_n + b_n}_n) = op("sup")({a_n}_n) + op("sup")({b_n}_n)$ es falso.
  ¿Queda algo en pie? ¿Y cómo lo pruebo sin rehacer todo el argumento del $epsilon$?
]

#galerazo[G-7][
  Un conjunto armado combinando *sólo los pares con el mismo índice* es un subconjunto del
  armado con *todos* los pares. El supremo es monótono respecto de la inclusión, así que lo que
  se sabe del conjunto grande baja al chico como *desigualdad*:
  $op("sup")({a_n + b_n}_n) <= op("sup")({a_n}_n) + op("sup")({b_n}_n)$ vale siempre. La
  igualdad no: ésa se pierde al achicar el conjunto.
]

=== La señal

Aparece el supremo de un conjunto de la forma ${a_n + b_n : n in NN}$ --- una operación entre
dos sucesiones hecha *término a término* --- y al lado los supremos de cada sucesión por
separado. La tentación es tratarlo como un conjunto suma $A + B$. No lo es: si
$A = {a_n}_n$ y $B = {b_n}_n$, en $A + B$ se suman *todos* los pares $a_i + b_j$, mientras que
en ${a_n + b_n}_n$ sólo los que tienen $i = j$, es decir la diagonal.

#sublema(titulo: "Traducción")[
  *"Supremo de una operación término a término entre dos sucesiones"* $==>$ *"es la diagonal
  del conjunto de todos los pares: heredo la cota por inclusión, no la igualdad"*.
]

=== Por qué funciona

El enunciado preciso: si $(a_n)_(n in NN)$ y $(b_n)_(n in NN)$ son sucesiones de números reales
acotadas superiormente, entonces

$ op("sup")({a_n + b_n}_n) <= op("sup")({a_n}_n) + op("sup")({b_n}_n). $

#demostracion[de la desigualdad][
  Llamemos $A = {a_n}_n$, $B = {b_n}_n$ y $D = {a_n + b_n}_n$. Los tres son no vacíos, y $A$ y
  $B$ están acotados superiormente por hipótesis, así que existen $alpha = op("sup")(A)$ y
  $beta = op("sup")(B)$ (Axioma de Completitud).

  *Paso 1: $D subset.eq A + B$.* Sea $x in D$. Existe $n in NN$ con $x = a_n + b_n$. Como
  $a_n in A$ y $b_n in B$, $x$ es de la forma $a + b$ con $a in A$ y $b in B$, es decir
  $x in A + B$.

  *Paso 2: $A + B$ está acotado superiormente y $op("sup")(A + B) = alpha + beta$.* Es el
  Ej. 2 a) del primer recuperatorio 1C 2025, aplicado a $A$ y $B$ (no vacíos y acotados
  superiormente).

  *Paso 3: monotonía del supremo.* Como $D subset.eq A + B$ y $A + B$ está acotado
  superiormente, $D$ también lo está y $op("sup")(D) <= op("sup")(A + B)$
  (Práctica 1, Ej. 5 (a)).

  Encadenando los pasos 3 y 2,
  $ op("sup")({a_n + b_n}_n) = op("sup")(D) <= op("sup")(A + B) = alpha + beta
    = op("sup")({a_n}_n) + op("sup")({b_n}_n). quad qed $
]

Ningún paso usa $epsilon$: todo el trabajo analítico quedó encapsulado en el paso 2, que ya
estaba probado. El galerazo es el paso 1.

_Alternativa directa_ (sin pasar por $A + B$; no está en la resolución del parcial, es un
argumento agregado al redactar este galerazo): para todo $n$, $a_n <= alpha$ y $b_n <= beta$,
luego $a_n + b_n <= alpha + beta$. Entonces $alpha + beta$ es cota superior de $D$ y, como el
supremo es la menor de las cotas superiores, $op("sup")(D) <= alpha + beta$.

=== Por qué no hay igualdad

La inclusión $D subset.eq A + B$ puede ser estricta, y lo que queda afuera puede ser justo lo
que realiza el supremo. Con $a = (1, 0, 0, dots)$ y $b = (-1, 0, 0, dots)$:

- $a_n + b_n = 0$ para todo $n$, así que $D = {0}$ y $op("sup")(D) = 0$;
- $op("sup")(A) + op("sup")(B) = 1 + 0 = 1$, y ese valor lo realiza $a_1 + b_2$, un par con
  índices distintos: está en $A + B$ pero no en $D$.

=== Cómo inventarlo de cero

+ *Escribí los dos conjuntos como conjuntos de pares*: ¿quién se combina con quién? En uno,
  cualquier $a_i$ con cualquier $b_j$; en el otro, sólo $a_n$ con $b_n$.
+ *Chequeá la inclusión*: el de mismo índice está contenido en el de todos los pares.
+ *Aplicá la monotonía del supremo* (Práctica 1, Ej. 5 (a)): sale la desigualdad.
+ *Reemplazá el supremo del conjunto grande* por lo que ya se sabe de él.
+ *No intentes la otra desigualdad*: buscá un contraejemplo poniendo los máximos de las dos
  sucesiones en índices distintos.

=== Dónde se usa

- Primer recuperatorio 1C 2025, Ej. 2 b) (`parciales/2025_1c_recuperatorio_1.typ`) --- es el
  ejercicio que disparó este galerazo: la igualdad es falsa y esta desigualdad es lo que
  sobrevive.
- `p1: Ej. 5 (a)` --- la monotonía del supremo respecto de la inclusión, que es el motor del
  argumento.

#v(8pt)

== Galerazo 8 · Compacto y continua: el supremo es un máximo

#disparador[
  En el Ejemplo C3-7 dice que los dos supremos son finitos "por el teorema de Weierstrass".
  ¿Cómo se me puede ocurrir tirar de ese teorema? ¿Y qué tengo que chequear antes de usarlo?
]

#galerazo[G-8][
  Si hay que tratar con el supremo o el ínfimo de una función *continua* sobre un conjunto
  *compacto* (en $RR$: un intervalo cerrado y acotado $[a, b]$), el teorema de Weierstrass dice
  tres cosas a la vez: el supremo es *finito*, es un *máximo* (no hace falta pasar al límite),
  y hay un punto concreto $x_0$ donde se alcanza. Las dos hipótesis son necesarias: si falta la
  continuidad o la compacidad, el supremo puede valer $+infinity$ o quedar sin alcanzarse.
]

=== La señal

Aparece una expresión de la forma
$ op("sup")_(x in K) abs(f(x) - g(x)), quad norm(f)_infinity, quad op("ínf")_(x in K) f(x), quad
  op("diam")(K), quad d(x, K), $
y lo que falta es una de estas tres cosas: que sea *finita* (para que una fórmula como la de la
métrica de C3-7 tenga sentido), que se *alcance* (para escribirla como $f(x_0)$ y trabajar con
un punto) o que sea *positiva* (el ínfimo de una función positiva, ¿puede ser cero?).

#sublema(titulo: "Traducción")[
  *"Sup (o ínf) de una función continua sobre un compacto"* $==>$ *"es un máx (o mín): finito, y
  existe un punto que lo realiza"*. Lo primero que se mira es el *dominio*, no la función.
]

=== El enunciado

Versión para espacios métricos, que es el contexto de la Práctica 5: si $K$ es un espacio
métrico compacto y no vacío y $f : K -> RR$ es continua, existen $x_m, x_M in K$ tales que
$ f(x_m) <= f(x) <= f(x_M) quad "para todo " x in K. $
En particular $f$ es acotada y $op("sup")_K f = f(x_M) = op("máx")_K f$. Para $K = [a, b]$ es el
teorema de los libros de primer análisis: _Lebl, Teorema 3.3.2_ ("Minimum-maximum theorem"),
_Boman y Rogers, Teorema 7.4.2_ (EVT), _MIT 18.100A, Lecture 16, Teorema 4_. La versión para
espacios métricos compactos figura en ProofWiki (ver Fuentes).

*Ojo:* `apuntes.typ` todavía no transcribe ni compacidad ni este teorema; en el Ejemplo C3-7 se
lo cita por nombre. Lo que sí está disponible son los ejercicios de la Práctica 5 (ver más abajo).

=== Por qué funciona

La prueba de MIT 18.100A (Lecture 16) para $[a, b]$ tiene tres pasos, y cada hipótesis entra en
un lugar distinto:

+ *$f$ es acotada.* Si no, para cada $n$ hay $x_n in [a, b]$ con $abs(f(x_n)) >= n$. Por
  Bolzano--Weierstrass una subsucesión $x_(n_k)$ converge a algún $x in [a, b]$ (acá se usa que
  el intervalo es *cerrado y acotado*), y por continuidad $abs(f(x_(n_k))) -> abs(f(x))$, que
  es finito: absurdo con $abs(f(x_(n_k))) >= n_k -> infinity$.
+ *Hay una sucesión que se acerca al supremo.* Como $f$ es acotada, existe
  $L = op("sup") f([a, b])$, y por la Proposición de equivalencia del supremo existen
  $x_n in [a, b]$ con $f(x_n) -> L$.
+ *El supremo se alcanza.* Otra vez Bolzano--Weierstrass: $x_(n_k) -> d in [a, b]$, y por
  continuidad $f(d) = lim f(x_(n_k)) = L$.

La *compacidad* sirve para que el límite $d$ de la subsucesión *se quede en el dominio*; la
*continuidad* sirve para pasar el límite adentro de $f$.

=== Tres ejemplos pavotes

*Ejemplo 1 · Calcular los extremos de una cúbica en $[0, 3]$.* (_APEX Calculus_, Ejemplo 3.1.17.)
Hallar el máximo y el mínimo de $f(x) = 2x^3 + 3x^2 - 12x$ en $[0, 3]$.

Como $f$ es continua en el compacto $[0, 3]$, Weierstrass garantiza que ambos existen; recién
ahí tiene sentido buscarlos entre los *candidatos*: los extremos del intervalo y los puntos
críticos de adentro. Se tiene
$ f'(x) = 6x^2 + 6x - 12 = 6 (x + 2)(x - 1), $
así que el único punto crítico en $[0, 3]$ es $x = 1$ (el $x = -2$ queda afuera). Evaluando,
$ f(0) = 0, quad f(1) = -7, quad f(3) = 45. $
Entonces el máximo es $45$ (en $x = 3$) y el mínimo es $-7$ (en $x = 1$), valores que coinciden
con los del libro; la factorización de $f'$ y las evaluaciones se verificaron acá.

#block(breakable: false, width: 100%)[#align(center)[
  #cetz.canvas({
    plot.plot(
      size: (9, 4.2),
      x-min: -0.3, x-max: 3.3,
      y-min: -12, y-max: 52,
      x-tick-step: 1,
      y-tick-step: 10,
      x-label: $x$,
      y-label: $f(x)$,
      axis-style: "school-book",
      {
        plot.add(
          domain: (0, 3),
          samples: 120,
          x => 2 * x * x * x + 3 * x * x - 12 * x,
          style: (stroke: rgb("#c026d3") + 1.6pt),
        )
        plot.add(
          ((0, 0), (1, -7), (3, 45)),
          style: (stroke: none),
          mark: "o",
          mark-size: 0.16,
          mark-style: (fill: rgb("#a21caf"), stroke: rgb("#a21caf")),
        )
      },
    )
  })
]]

#align(center)[
  #text(9pt, style: "italic", fill: rgb("#64748b"))[
    Los tres candidatos $(0, 0)$, $(1, -7)$ y $(3, 45)$. Sin el teorema, comparar candidatos no
    probaría nada: podría no haber máximo.
  ]
]

*Ejemplo 2 · La norma uniforme es finita y es un máximo.* (_Wikipedia, "Uniform norm"_, sección
Definition; _APEX Calculus_, Ejemplo 3.1.26.) La norma uniforme se define como
$norm(f)_infinity = op("sup") {abs(f(s)) : s in S}$, y el artículo observa que si $f$ es continua
sobre un intervalo cerrado y acotado, o más en general sobre un compacto, entonces es acotada y
el supremo se alcanza por el teorema de valores extremos de Weierstrass, así que se lo puede
reemplazar por un máximo (traducción libre). Este es exactamente el uso del Ejemplo C3-7.

El pavote concreto: $f(x) = sqrt(1 - x^2)$ en $[-1, 1]$. El libro calcula que el máximo es $1$
(en $x = 0$) y el mínimo es $0$ (en $x = plus.minus 1$). Como $f >= 0$, vale $abs(f) = f$ y por
lo tanto $norm(f)_infinity = op("máx") f = 1$ (esta última conclusión sobre la norma es
deducción propia a partir de los valores del libro).

*Ejemplo 3 · Antes de usarlo, chequear las dos hipótesis.* Cada hipótesis tiene su contraejemplo
canónico, todos sacados de libros y apuntes abiertos:

#show table.cell.where(y: 0): set text(fill: white, weight: "bold", size: 8.5pt)

#table(
  columns: (1.15fr, 1.5fr, 2.1fr, 1.35fr),
  align: (left + horizon, left + horizon, left + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#86198f") } else if calc.even(y) { rgb("#fdf4ff") } else { white },
  stroke: 0.4pt + rgb("#e9d5ff"),
  inset: (x: 6pt, y: 6pt),

  [*Qué falla*], [*Función y dominio*], [*Qué pasa*], [*Fuente*],

  [Dominio no acotado],
  [$f(x) = x$ en $RR$],
  [Continua; no alcanza ni máximo ni mínimo.],
  [Lebl, Ej. 3.3.4],

  [Dominio no cerrado],
  [$f(x) = 1 / x$ en $(0, 1)$],
  [Continua; no alcanza ni máximo ni mínimo. Detalle propio: es no acotada superiormente
  ($op("sup") = +infinity$) y su ínfimo $1$ no se alcanza.],
  [Lebl, Ej. 3.3.5],

  [Dominio no cerrado],
  [$f(x) = 1 - x$ en $(0, 1]$],
  [Acotada, con $op("sup") = 1$ que *no se alcanza* (haría falta $x = 0$).],
  [Wikipedia, _Extreme value theorem_],

  [No es continua],
  [$f(0) = f(1) = 1 / 2$ y $f(x) = x$ en $(0, 1)$, sobre $[0, 1]$],
  [No alcanza ni máximo ni mínimo. Detalle propio: $op("sup") = 1$ y $op("ínf") = 0$, y los
  valores $f(0) = f(1) = 1 / 2$ no llegan a ninguno de los dos.],
  [MIT 18.100A, Lec. 16, Obs. 6],
)

Moraleja para C3-7: si el dominio fuera $(0, 1)$ en lugar de $[0, 1]$, la fórmula
$op("sup") abs(f(x) - g(x))$ podría valer $+infinity$ y $d$ ni siquiera estaría definida
(deducción propia, con el $f(x) = 1 / x$ de la tabla y $g = 0$).

=== Cómo inventarlo de cero

+ *Identificá el conjunto $K$ sobre el que se toma el sup o el ínf* y la función $f$ que se
  evalúa adentro.
+ *¿Es $f$ continua en todo $K$?* Si aparece una derivada, como en C3-7, la continuidad de $f'$
  tiene que estar en la hipótesis: ahí está en la definición de $X$.
+ *¿Es $K$ compacto?* En $RR$, mirá si es un $[a, b]$. En un espacio métrico cualquiera, "cerrado
  y acotado" no alcanza: la bola cerrada de $(C[0, 1], d_infinity)$ no es compacta (Práctica 5,
  Ej. 10).
+ *Si las dos respuestas son sí:* el sup es un máx, finito, y se escribe $f(x_0)$ para algún
  $x_0 in K$. Para *calcularlo* se compara entre los extremos y los puntos críticos (Ejemplo 1).
+ *Si alguna es no:* no se puede usar el teorema. Buscá una cota a mano o un contraejemplo
  parecido a los de la tabla.

=== Dónde se usa

- `ejemplos/p3: C3-7` --- la métrica $C^1$ en $[0, 1]$: los dos supremos son finitos por
  Weierstrass, con $f$ y $f'$ continuas en el compacto $[0, 1]$.
- `p5: Ej. 2` --- un compacto de $RR$ tiene máximo y mínimo: es el teorema aplicado a la
  función identidad sobre $K$ (deducción propia: la guía no dice cómo resolverlo).
- `p5: Ej. 8` --- la distancia de un punto a un compacto se realiza: es el teorema aplicado a
  $y |-> d(x, y)$ sobre $K$ (la continuidad de esa función está en la Práctica 4, Ej. 10).
- `p5: Ej. 10` --- el contraste: cerrado y acotado en $(C[0, 1], d_infinity)$ *no* es compacto,
  así que ahí el teorema no se puede invocar.
- `p5: Ej. 11` --- una función continua y positiva sobre un compacto tiene mínimo positivo:
  el mínimo se alcanza (Weierstrass) en algún $x_0$ y $f(x_0) > 0$.

=== Fuentes

Todas consultadas el 4 de octubre de 2026.

- Jiří Lebl, _Basic Analysis: Introduction to Real Analysis_, sección 3.3.1: Teorema 3.3.2 y
  Ejemplos 3.3.4 a 3.3.6.
  #link("https://jirka.org/ra/html/sec_minmaxint.html")[jirka.org/ra/html/sec_minmaxint.html]
- Gregory Hartman et al., _APEX Calculus_, 4ª ed., sección 3.1: Teorema 3.1.4 y Ejemplos 3.1.17
  y 3.1.26.
  #link("https://spot.pcc.edu/math/APEXCalculus/sec_extreme_values.html")[spot.pcc.edu/math/APEXCalculus]
- MIT 18.100A Real Analysis (otoño 2020), _Complete Lecture Notes_, Lecture 16: Teorema 4
  (Min-Max) y Observación 6.
  #link("https://ocw.mit.edu/courses/18-100a-real-analysis-fall-2020/mit18_100af20_lec16.pdf")[ocw.mit.edu (18.100A, lec16)]
- Eugene Boman y Robert Rogers, _Real Analysis_, sección 7.4: Teorema 7.4.2 (EVT).
  #link("https://math.libretexts.org/Bookshelves/Analysis/Real_Analysis_(Boman_and_Rogers)/07:_Intermediate_and_Extreme_Values/7.04:_The_Supremum_and_the_Extreme_Value_Theorem")[math.libretexts.org]
- Wikipedia, _Extreme value theorem_ (sección sobre funciones a las que no se aplica) y
  _Uniform norm_ (sección Definition).
  #link("https://en.wikipedia.org/wiki/Extreme_value_theorem")[en.wikipedia.org/wiki/Extreme_value_theorem],
  #link("https://en.wikipedia.org/wiki/Uniform_norm")[en.wikipedia.org/wiki/Uniform_norm]
- ProofWiki, _Extreme Value Theorem_ (versión para espacios métricos compactos).
  #link("https://proofwiki.org/wiki/Extreme_Value_Theorem")[proofwiki.org/wiki/Extreme_Value_Theorem]

#v(8pt)

== Galerazo 9 · Sándwich $NN arrow.hook S arrow.hook QQ$: todo intervalo tiene $aleph_0$ racionales

#disparador[
  En la resolución del Ej. 2 del primer parcial 2C 2024 aparece
  $aleph_0 = \#((1, 2) inter QQ)$ sin más. ¿Por qué vale? ¿Está demostrado en alguna de las
  prácticas que todo intervalo abierto tiene infinitos racionales y que todo subconjunto
  infinito de $QQ$ es numerable?
]

#galerazo[G-9][
  Para ver que un $S subset.eq QQ$ tiene cardinal $aleph_0$ no hace falta una biyección: se lo
  encierra entre dos inyecciones, $NN arrow.hook S arrow.hook QQ$. La de la derecha es la
  inclusión y sale gratis; la de la izquierda es una sucesión de elementos *distintos* de $S$,
  es decir, ver que $S$ es infinito. Como $\#QQ = aleph_0$, Cantor--Bernstein cierra. Para
  $S = (a, b) inter QQ$ la sucesión sale de la densidad de $QQ$.
]

=== La señal

Aparece el cardinal de un subconjunto de $QQ$ (o de $NN$, o de cualquier conjunto numerable):
$(a, b) inter QQ$, los racionales de un intervalo, un $B subset.eq NN$ infinito. La
tentación es buscar una biyección explícita con $NN$, que suele ser difícil de escribir. Pero
una de las dos desigualdades ya está hecha por la inclusión, y la otra sólo pide exhibir
infinitos elementos distintos.

#sublema(titulo: "Traducción")[
  *"Cardinal de un subconjunto de un numerable"* $==>$ *"¿es infinito? Si sí, es $aleph_0$:
  arriba la inclusión, abajo una sucesión inyectiva"*.
]

=== Por qué funciona

Todo lo que se usa está en `apuntes.typ` (Cap. 3) y en las prácticas.

*Cota superior: $\#S <= aleph_0$.* La inclusión $iota : S arrow.hook QQ$ es inyectiva, así que
$\#S <= \#QQ$ por la definición de $<=$ entre cardinales (Definición 3.8; está remarcado en la
Observación "Ideas Importantes y Minimalidad de $aleph_0$"). Y $\#QQ = aleph_0$ por la
Proposición "Numerabilidad de $QQ$".

*Cota inferior: $aleph_0 <= \#S$.* Hace falta una inyección $NN -> S$. Hay dos casos.

- *Extremos racionales.* Si $a, b in QQ$ con $a < b$, sirve
  $ phi(n) = a + (b - a) / (n + 1). $
  Está bien definida porque $QQ$ es cerrado por sumas, restas y cocientes con denominador no
  nulo, y porque $0 < (b - a) / (n + 1) < b - a$ deja a $phi(n)$ en $(a, b)$. Es inyectiva
  porque $n |-> 1 / (n + 1)$ lo es y $b - a != 0$. Con $a = 1$, $b = 2$ es la función
  $n |-> 1 + 1 / (n + 1)$ de las observaciones del parcial. _(Esta fórmula es un argumento
  propio, no figura en el apunte.)_
- *Extremos reales cualesquiera.* Si $a$ o $b$ es irracional, la fórmula anterior no da
  racionales y se usa la *Densidad de $QQ$* (Proposición 2 del apunte, que es el
  `p1: Ej. 2 (b)`): entre dos reales distintos hay un racional. Se aplica una y otra vez:
  $ q_1 in (a, b) inter QQ, quad q_(n + 1) in (a, q_n) inter QQ. $
  Por construcción $b > q_1 > q_2 > dots > a$, así que los $q_n$ están en $(a, b) inter QQ$
  y son todos distintos: $n |-> q_n$ es inyectiva. Es la misma construcción por recursión y
  densidad del Ejemplo C1-6 de `ejemplos/p1.typ` (allí con $q_(n + 1)$ en
  $(x, (x + q_n) / 2)$ para que además converja a $x$; acá alcanza con que decrezca).
  _(La adaptación al intervalo es razonamiento propio.)_

Otra forma de cerrar la cota inferior, una vez que se sabe que $S$ es infinito: por la
Proposición 3.14 todo conjunto infinito contiene un subconjunto numerable, así que
$aleph_0 <= \#S$ (lo dice la misma Observación "Ideas Importantes").

*Cierre.* Con $aleph_0 <= \#S <= aleph_0$, el Teorema de Cantor--Schröder--Bernstein (3.11) da
$\#S = aleph_0$. Equivalentemente: la Proposición 3.13 dice que un subconjunto no vacío de un
numerable es a lo sumo numerable (finito o numerable), y si además es infinito, por la
Definición 3.6 es numerable.

=== La familia entera

#show table.cell.where(y: 0): set text(fill: white, weight: "bold", size: 8.5pt)

#table(
  columns: (1.3fr, 1.1fr, 2.2fr),
  align: (left + horizon, left + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#86198f") } else if calc.even(y) { rgb("#fdf4ff") } else { white },
  stroke: 0.4pt + rgb("#e9d5ff"),
  inset: (x: 6pt, y: 5pt),

  [*Conjunto $S$*], [*Arriba*], [*Abajo: inyección $NN -> S$*],

  [$(a, b) inter QQ$, $a, b in QQ$],
  [$S subset.eq QQ$],
  [$n |-> a + (b - a) / (n + 1)$],

  [$(a, b) inter QQ$, $a, b in RR$],
  [$S subset.eq QQ$],
  [$n |-> q_n$, decreciente, construida por densidad],

  [$(-1, 1) inter QQ$ (`p2: Ej. 1 (d)`)],
  [$S subset.eq QQ$],
  [$n |-> 1 / (n + 1)$. En la guía se resolvió con la biyección $x / (1 + abs(x))$ de G-1; el
  sándwich evita verificar la inversa.],

  [$B subset.eq NN$ infinito],
  [$B subset.eq NN$],
  [$B$ es infinito; Proposición 3.14 (o 3.13 directamente).],
)

=== Cómo inventarlo de cero

+ *¿Dónde vive $S$?* Si está adentro de $QQ$, $NN$, $ZZ$ o cualquier numerable, la cota
  $\#S <= aleph_0$ es la inclusión. No hay nada que construir.
+ *¿Es infinito?* Buscá una sucesión de elementos distintos de $S$. Con un intervalo de
  extremos racionales, acercate a un extremo con $1 / (n + 1)$; con extremos reales, usá la
  densidad de $QQ$ una vez por paso.
+ *Cerrá con Cantor--Bernstein* (o con la Proposición 3.13 + la Definición 3.6).
+ *Si piden comparar dos conjuntos*, como en el parcial, no compares uno con otro: probá que
  los dos valen $aleph_0$ con un sándwich cada uno.

=== Dónde se usa

- Primer parcial 2C 2024, Ej. 2 (`parciales/2024_2c_parcial_1.typ`) --- es el ejercicio que
  disparó este galerazo: las cadenas
  $aleph_0 = \#((1, 2) inter QQ) <= \#Phi(B) <= \#QQ <= aleph_0$ y la análoga con $(2, 3)$ son
  dos sándwiches.
- `p2: Ej. 1 (d)` --- $\#((-1, 1) inter QQ)$; ver la fila de la tabla.
- `p1: Ej. 2 (b)` --- la densidad de $QQ$, que da la inyección abajo cuando los extremos no son
  racionales.
- `ejemplos/p1: C1-6` --- la construcción por recursión y densidad de racionales
  estrictamente decrecientes.
