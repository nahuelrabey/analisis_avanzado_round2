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

#show heading.where(level: 2): it => block(width: 100%)[
  #v(6pt)
  #text(size: 12pt, weight: "bold", fill: rgb("#4f46e5"))[#it.body]
  #v(2pt)
  #line(length: 100%, stroke: 0.7pt + rgb("#c7d2fe"))
]

#show heading.where(level: 3): it => block(width: 100%)[
  #v(4pt)
  #text(size: 10.5pt, weight: "bold", fill: rgb("#475569"))[#it.body]
]

// --- Ruta de trabajo: unión contable de contables ---

#align(center)[
  #text(14pt, weight: "bold")[Ruta --- Unión contable de conjuntos contables] \
  #v(2pt)
  #text(10pt, style: "italic", fill: rgb("#475569"))[
    Qué hay que saber antes de sentarse a demostrarlo, y por qué no está demostrado en ningún lado
  ]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

El resultado que se quiere probar es

$ A_n "contable para todo" n in NN quad ==> quad union.big_(n in NN) A_n "es contable". $

Se usa sin aclaración en buena parte de la Práctica 2 y en las clases de 2023, pero *no está
demostrado en ninguna fuente del curso*. Este archivo reúne el estatus bibliográfico del
enunciado y el inventario de lo que hace falta para escribir la demostración: no es la
demostración, es la ruta hacia ella.

== 0. Estatus del enunciado en las fuentes

#v(2pt)

#show table.cell.where(y: 0): set text(fill: white, weight: "bold", size: 8.5pt)

#table(
  columns: (1.15fr, 0.85fr, 1.6fr),
  align: (left + horizon, left + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#3730a3") } else if calc.even(y) { rgb("#f8fafc") } else { white },
  stroke: 0.4pt + rgb("#c7d2fe"),
  inset: (x: 6pt, y: 5pt),

  [*Fuente*], [*Ubicación*], [*Qué hay ahí*],

  [`notas_materia.pdf`, cap. 3],
  [---],
  [*No aparece.* El capítulo va 3.13, 3.14, después partes y Cantor (3.15--3.18), 3.19 ($RR$ no numerable) y termina en 3.22],

  [Abbott, _Understanding Analysis_],
  [Teorema 1.5.8 \ (pág. 29 impresa / 42 del PDF)],
  [Enunciado, *sin demostración*: (i) unión finita de contables es contable; (ii) unión de una familia $(A_n)_(n in NN)$ de contables es contable],

  [Abbott, _Understanding Analysis_],
  [Ejercicio 1.5.3 \ (pág. 30 / 43 del PDF)],
  [El esquema de la prueba: (a) el caso de dos conjuntos disjuntando; (b) por qué la inducción no pasa de (i) a (ii); (c) el arreglo bidimensional de $NN$],

  [Práctica 2],
  [Ej. 2],
  [$A union B$ contable: el caso de dos conjuntos],

  [Práctica 2],
  [Ej. 5],
  [El lema de disjuntización: dada $(A_n)_n$, construir $(B_n)_n$ disjuntos dos a dos con la misma unión],

  [Práctica 2],
  [Ej. 6 (a)],
  [El caso general: familia contable de conjuntos contables],
)

#v(6pt)

Es decir: el curso lo parte deliberadamente en tres ejercicios y nunca lo enuncia como
resultado. Después se usa como si fuera teoría en `ejemplos.typ` ($ZZ times ZZ$,
$(0,1) inter QQ$, $QQ + QQ$, sucesiones convergentes de enteros) y en
`clases_2023/apuntes_2.typ`.

== 1. Las cuatro piezas previas

Ninguna es difícil, pero la demostración se apoya en las cuatro: si falta una, la escritura
se traba.

#v(2pt)

#table(
  columns: (0.9fr, 0.75fr, 1.85fr),
  align: (left + horizon, left + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#3730a3") } else if calc.even(y) { rgb("#f8fafc") } else { white },
  stroke: 0.4pt + rgb("#c7d2fe"),
  inset: (x: 6pt, y: 5pt),

  [*Pieza*], [*Dónde está*], [*Para qué sirve acá*],

  [Observación 3.7],
  [`apuntes.typ`],
  [$A$ numerable $==>$ se lo puede *listar*, $A = {a_1, a_2, a_3, dots}$. Es lo que convierte la hipótesis abstracta en algo manipulable],

  [Ejemplo 3.12],
  [`ejemplos.typ`],
  [$NN times NN tilde.op NN$ (vía Cantor--Schröeder--Bernstein con $g(n,m) = 2^n 3^m$). Es el motor: comprime *dos* índices en uno],

  [Proposición 3.9],
  [`apuntes.typ`],
  [$\#A <= \#B$ si y sólo si existe una sobreyección $g : B -> A$ (con $A != nothing$)],

  [Proposición 3.13],
  [`apuntes.typ`],
  [Un conjunto de cardinal $<= aleph_0$ es a lo sumo numerable, es decir, contable],
)

== 2. La decisión estratégica: apuntar a _contable_, no a _numerable_

#estrategia[Qué se prueba exactamente][
  La tentación es buscar una biyección $NN -> union.big_(n in NN) A_n$, y *no la hay en
  general*: los $A_n$ pueden solaparse (pueden ser todos iguales) o ser finitos, con lo cual
  la unión puede terminar siendo finita. Lo que se prueba es la desigualdad de cardinales
  $ \#(union.big_(n in NN) A_n) <= aleph_0, $
  y de ahí, por la Proposición 3.13, la unión resulta contable.
]

Si en un ejercicio concreto hace falta la conclusión más fuerte --- que la unión es
*numerable* --- se agrega un renglón aparte: _"además la unión es infinita, luego es
numerable"_. Ese paso es independiente y no sale de la demostración general.

== 3. El obstáculo: la asignación natural no es inyectiva

La idea evidente es mandar $(n, k) |-> a_(n k)$, el $k$-ésimo elemento de $A_n$. Esa
asignación cubre toda la unión, pero *no es inyectiva*: si $x in A_1 inter A_2$, entonces $x$
tiene por lo menos dos índices distintos. Hay exactamente dos maneras de esquivarlo, y
conviene elegir cuál se usa *antes* de empezar a escribir.

=== Camino A: sobreyecciones (el más corto)

No se arregla nada. Se acepta que hay repeticiones y se usa la Proposición 3.9, que está
hecha justamente para tolerarlas: alcanza con exhibir una sobreyección desde un conjunto
contable. La cadena es

$ NN -->^"sob." NN times NN -->^"sob." union.big_(n in NN) A_n, $

donde la primera flecha sale del Ejemplo 3.12 y la segunda es $(n,k) |-> a_(n k)$. Componiendo
y aplicando 3.9 y 3.13 se termina. Son unos pocos renglones.

=== Camino B: disjuntización (el de Abbott)

Se reemplaza cada $A_n$ por
$ B_n = A_n backslash union.big_(j < n) A_j, $
que son disjuntos dos a dos y tienen la misma unión. Es literalmente el *Ejercicio 5 de la
Práctica 2* y es lo que sugiere Abbott en el 1.5.3 (a). Ahora la asignación sí es inyectiva,
pero hay que pagar dos verificaciones extra: que cada $B_n subset.eq A_n$ sigue siendo
contable (Proposición 3.13) y que la unión no cambió.

#sublema(titulo: "Traducción")[
  *"La función natural repite valores"* $==>$ *"no la arreglo: cambio biyección por
  sobreyección y uso la Proposición 3.9"*. Disjuntar es el plan B, y cuesta más.
]

== 4. Los casos borde

Son los renglones que se olvidan y que en una corrección se piden.

- *$A_n$ finito o vacío.* "Contable" incluye finito, así que lo que hay que pedir para cada
  $n$ es una función $f_n : NN -> A_n$ *sobreyectiva*, no biyectiva: si $A_n$ es finito y no
  vacío, se repite un elemento y listo. Si $A_n = nothing$, hay que decir explícitamente qué
  se hace (descartar esos índices).

- *Todos vacíos.* Entonces la unión es $nothing$ y la Proposición 3.9 no se puede aplicar,
  porque pide $A != nothing$. Se despacha en un renglón al principio, pero hay que
  escribirlo.

- *La elección de las enumeraciones.* La hipótesis dice que para cada $n$ *existe* una
  sobreyección $f_n : NN -> A_n$. Pero la demostración necesita una elección *simultánea* de
  todas ellas, y eso es el axioma de elección (en su versión numerable). Conviene aclararlo,
  igual que ya está aclarado en la vuelta de la Proposición 3.9.

#observacion[Cuándo no hace falta el axioma de elección][
  En los ejercicios concretos de la Práctica 2 --- $ZZ times ZZ$, $QQ_(>0)$, $QQ + QQ$ --- las
  enumeraciones de cada pedazo son *explícitas*: se las escribe con una fórmula. Ahí no hay
  ninguna elección que hacer y el argumento es constructivo. El axioma sólo aparece en el
  enunciado general, donde de los $A_n$ únicamente se sabe que son contables.
]

== 5. Por qué la inducción no alcanza

Es el ítem (b) del Ejercicio 1.5.3 de Abbott y es una pregunta de parcial clásica.

#observacion[El salto que la inducción no da][
  La inducción prueba que $union.big_(n <= m) A_n$ es contable *para todo $m in NN$*, es
  decir, para toda unión *finita*. Pero $union.big_(n in NN) A_n$ no es ninguna de esas
  uniones finitas: no es un caso particular de la conclusión, así que el principio de
  inducción no la alcanza.

  La analogía que lo vuelve obvio: toda suma parcial de una serie es una suma finita, y eso
  no dice nada sobre el límite.
]

De ahí que el caso infinito necesite el argumento de los *dos índices a la vez* ($NN times
NN$) y no un paso inductivo.

== 6. Hasta dónde llega el resultado

Dos observaciones que marcan qué hipótesis es esencial y cuál se puede aflojar.

=== La cantidad de conjuntos importa

$ RR = union.big_(x in RR) {x} $

es una unión de conjuntos finitos y no es numerable. Lo que falla no son los pedazos, sino
que el conjunto de índices no es contable. Esa es la hipótesis que hace todo el trabajo.

=== El análogo para $frak(c)$ es otro teorema

Que una unión numerable de conjuntos de cardinal $frak(c)$ tenga cardinal $frak(c)$ es el
*Ejercicio 7 (b) de la Práctica 2*. Se prueba de manera parecida, pero *no* se deduce de
este resultado.

=== El conjunto de índices se puede generalizar gratis

Si $I$ es contable y cada $A_i$ es contable, entonces $union.big_(i in I) A_i$ es contable: la
demostración es la misma, componiendo con una sobreyección $NN -> I$. Ésa es la forma en que
el resultado se usa realmente en la práctica, por ejemplo en

$ QQ + QQ = union.sq.big_(a in QQ) (a + QQ), quad "con" a + QQ tilde.op QQ. $

== 7. La escalera: qué hacer antes

=== Dos rehechos previos

No son ejercicios nuevos: son resultados que ya están demostrados y que conviene poder
reproducir *sin mirar*, porque son las dos piezas que la demostración usa en serio.

- *Ejemplo 3.12* --- $NN times NN tilde.op NN$ vía Cantor--Schröeder--Bernstein. Es el motor:
  si no lo tenés en los dedos, la demostración se corta a la mitad. Está resuelto en
  `ejemplos.typ` (Ejemplo 14).
- *Proposición 3.9* --- $\#A <= \#B$ si y sólo si hay una sobreyección $B -> A$. Es la
  herramienta del Camino A. Está demostrada en `apuntes.typ` y también figura como desafío en
  `desafios.typ` (Bloque 10, "Ejercicio 3.9").

=== La escalera de la Práctica 2

#v(2pt)

#table(
  columns: (0.3fr, 0.7fr, 2.1fr),
  align: (center + horizon, left + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#3730a3") } else if calc.even(y) { rgb("#f8fafc") } else { white },
  stroke: 0.4pt + rgb("#c7d2fe"),
  inset: (x: 6pt, y: 5pt),

  [*Paso*], [*Ejercicio*], [*Qué entrena*],

  [1], [Ej. 1],
  [Cardinales de $ZZ_(<= -3)$, $5 ZZ$, $ZZ times NN$, $(-1,1) inter QQ$. Soltura para escribir biyecciones y enumeraciones *explícitas*: es la materia prima de todo lo demás],

  [2], [*Ej. 2*],
  [$A union B$ contable: el caso $n = 2$. Acá aparece el solapamiento en su versión más chica, y se lo resuelve entrelazando (pares e impares) o disjuntando. *Si este no sale, el caso infinito no va a salir*],

  [3], [Ej. 4],
  [Cardinal de los irracionales. Primera aplicación real del paso 2: sale por el absurdo, combinando la unión finita con que $RR$ no es numerable],

  [4], [Ej. 5],
  [La disjuntización de una sucesión $(A_n)_n$. Es el lema del Camino B y, de paso, el ejercicio que obliga a manejar la notación de familias indexadas],

  [5], [*Ej. 6 (a)*], [El objetivo: la unión contable de contables],

  [6], [Ej. 6 (b)],
  [$S = union.big_(m in NN) A^m$ con $A$ finito: la primera aplicación del resultado recién probado, y la que le da sentido (hay más reales que palabras)],

  [7], [Ej. 12 (b)],
  [Escribir $NN$ como unión numerable de numerables disjuntos: el control en sentido inverso. Muestra que la unión puede no agrandar nada],
)

#v(4pt)

En Abbott, si querés el camino de él: el *Ejercicio 1.5.1* entrena el principio del mínimo
(que es lo que después te deja esquivar el axioma de elección) y el *Ejercicio 1.5.3* es el
esquema completo, con sus tres ítems.

=== Cuatro ejemplos para tener al lado

#table(
  columns: (0.55fr, 2.45fr),
  align: (left + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#3730a3") } else if calc.even(y) { rgb("#f8fafc") } else { white },
  stroke: 0.4pt + rgb("#c7d2fe"),
  inset: (x: 6pt, y: 5pt),

  [*Ejemplo*], [*Qué aporta*],

  [Ejemplo 13 \ (Ej. 3.3)],
  [$NN tilde.op$ pares, $NN tilde.op ZZ$, $NN tilde.op QQ^+$. La partición en pares e impares es el modelo de *entrelazar dos listas*, que resuelve el Ej. 2 sin necesidad de disjuntar. El recorrido en diagonal de la grilla de $QQ^+$ es, además, la versión visual del Camino A],

  [Ejemplo 14 \ (Ej. 3.12)],
  [$NN times NN tilde.op NN$. El motor, otra vez: acá está la codificación $2^n 3^m$ y el uso de CSB],

  [C2-4],
  [Los cinco cálculos de cardinal de la Clase 2. *Es el ejemplo que más se parece a lo que vas a escribir*: aplica la receta "unión contable de contables" cuatro veces y trae el sublema de que una suryección desde un contable alcanza, con la nota de cuándo el mínimo evita el axioma de elección],

  [C3-4],
  [La familia con condición local de contabilidad. Es el "para qué sirve": todo el ejercicio consiste en *reindexar* una unión sobre $RR$ (que no serviría de nada) por una sobre $QQ times QQ_(>0)$. Muestra en acción que la hipótesis que importa es la contabilidad del conjunto de índices],
)

== 8. Checklist para escribir la demostración

Siguiendo el Camino A, lo que hay que dejar verificado por escrito:

#set enum(numbering: "1.")
+ Descartar el caso $union.big_(n in NN) A_n = nothing$ (la Proposición 3.9 pide un conjunto no vacío).
+ Fijar, para cada $n$, una sobreyección $f_n : NN -> A_n$ --- señalando que ahí se usa el axioma de elección --- y descartar los índices con $A_n = nothing$.
+ Definir $F : NN times NN -> union.big_(n in NN) A_n$ como $F(n, k) = f_n (k)$, y verificar que está *bien definida* (todo par tiene imagen, una vez fijadas las $f_n$).
+ Verificar que $F$ es *sobreyectiva*: si $x in union.big_(n in NN) A_n$, existe $n$ con $x in A_n$ y, por ser $f_n$ sobreyectiva, existe $k$ con $f_n (k) = x$.
+ Traer del Ejemplo 3.12 una biyección (o basta una sobreyección) $h : NN -> NN times NN$ y considerar $F compose h$, que es sobreyectiva por ser composición de sobreyecciones.
+ Concluir con la Proposición 3.9 que $\#(union.big_(n in NN) A_n) <= aleph_0$, y con la Proposición 3.13 que la unión es contable.
+ Si el enunciado pedía *numerable*, agregar el argumento aparte de que la unión es infinita.

#v(6pt)

#desafio[Escribir la demostración completa][
  Redactar la proposición y su demostración siguiendo el checklist, y después rehacerla por
  el Camino B (disjuntización, Ejercicio 5 de la Práctica 2) para comparar cuánto cuesta cada
  una. Como corolario inmediato, deducir que $QQ$ es numerable escribiéndolo como
  $QQ = union.big_(n in NN) \{m / n : m in ZZ\}$.
]
