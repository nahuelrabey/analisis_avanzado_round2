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
  #v(10pt)
  #text(size: 13pt, weight: "bold", fill: rgb("#0c4a6e"))[#it.body]
  #v(2pt)
  #line(length: 100%, stroke: 0.8pt + rgb("#7dd3fc"))
]

// Práctica pre-parcial: los lemas, teoremas y proposiciones que se usan para resolver los
// ejercicios de los primeros parciales de `parciales/`, organizados por tipo de ejercicio y, dentro
// de cada tipo, en el orden del guion de resolución. Escrito por el agente a pedido del usuario; la
// trazabilidad de cada ficha sale de las resoluciones de `parciales/*.typ`, de `lean/Parciales/` y
// de las guías resueltas en `guias-agente/`.

// Ficha: un resultado con su fuente, dónde se usó y su nombre en Lean. El color del borde es el
// nivel: azul = está en `apuntes.typ` (citable tal cual); verde = es un ejercicio de guía (citable
// si se sabe demostrar); naranja = "propio", no está en ninguno de los dos y hay que demostrarlo en
// el examen.
#let ficha(id: "", titulo: "", nivel: "apunte", fuente: [], usado: [], lean: [], cuerpo) = {
  let (color, etiqueta, fondo) = if nivel == "apunte" {
    (rgb("#2563eb"), "apunte", rgb("#eff6ff"))
  } else if nivel == "guia" {
    (rgb("#15803d"), "guía", rgb("#f0fdf4"))
  } else {
    (rgb("#ea580c"), "propio: demostrar en el examen", rgb("#fff7ed"))
  }
  block(
    fill: fondo,
    stroke: (left: 3.5pt + color, rest: 0.4pt + color.lighten(60%)),
    inset: (x: 12pt, y: 9pt),
    radius: (right: 4pt),
    width: 100%,
    breakable: true,
  )[
    #text(weight: "bold", fill: color)[#id · #titulo]
    #h(1fr)
    #box(fill: color, inset: (x: 5pt, y: 2pt), radius: 3pt)[#text(size: 8pt, weight: "bold", fill: white)[#etiqueta]]
    #v(1pt)
    #text(size: 8.5pt, fill: rgb("#475569"))[*Fuente:* #fuente #h(0.6em)·#h(0.6em) *Usado en:* #usado #h(0.6em)·#h(0.6em) *Lean:* #lean]
    #v(4pt)
    #cuerpo
  ]
}

#align(center)[
  #text(14pt, weight: "bold")[Análisis Avanzado 2026] \
  #v(2pt)
  #text(12pt, weight: "medium")[Práctica pre-parcial: lo que se usa en los primeros parciales]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#progreso[
  *Qué es.* Los lemas, teoremas y proposiciones que se usaron para resolver los ejercicios de los
  seis primeros parciales transcriptos en `parciales/` (1C 2024, 2C 2024, 1C 2025 y su
  recuperatorio, 2C 2025 y su recuperatorio), organizados *por tipo de ejercicio* y, dentro de cada
  tipo, *en el orden en que se usan al resolver*. No es un resumen del apunte: es la lista de lo que
  hay que tener a mano en el examen, con la trazabilidad de cada resultado.

  *Cubre, por ahora:* (1) *Cardinalidad*, que aparece en los seis parciales; (2) *Supremos e
  ínfimos*, los ejercicios que se resuelven sólo con la Guía 1 y, a lo sumo, clausura e interior
  en $RR$ de la Guía 3. Faltan los otros dos tipos (topología general en espacios métricos y
  métricas concretas).

  *Cómo leer una ficha.* Cada resultado es una ficha con su enunciado, *cómo se usa* en el guion,
  la *fuente*, en qué *parcial y ejercicio* se usó y su nombre en `lean/Comun/`. El color dice qué
  hay que hacer con él en el examen: #box(fill: rgb("#2563eb"), inset: (x: 4pt, y: 1pt), radius: 3pt)[#text(size: 8pt, fill: white, weight: "bold")[apunte]] se cita
  por nombre; #box(fill: rgb("#15803d"), inset: (x: 4pt, y: 1pt), radius: 3pt)[#text(size: 8pt, fill: white, weight: "bold")[guía]] es un ejercicio de guía, se cita si se sabe
  demostrar (la ficha trae la idea); #box(fill: rgb("#ea580c"), inset: (x: 4pt, y: 1pt), radius: 3pt)[#text(size: 8pt, fill: white, weight: "bold")[propio]] no está en ninguno de
  los dos y algún parcial lo probó en el lugar: la ficha trae la demostración completa, porque hay
  que escribirla.

  *Fuentes.* Cajas de `apuntes.typ` (por nombre y número), ejercicios de `guias/p1.typ` y
  `guias/p2.typ` (resueltos en `guias-agente/`), las resoluciones de `parciales/*.typ` y su
  verificación en `lean/Parciales/`. Nada de este archivo se tomó de fuera del repositorio.
]

#v(6pt)

== Cardinalidad

En los seis primeros parciales hay exactamente un ejercicio de cardinal, y las respuestas
posibles fueron siempre dos: $aleph_0$ (el conjunto es numerable) o $frak(c)$ (el conjunto es
coordinable con $RR$). La resolución tiene siempre la misma forma: una cota superior, una cota
inferior y un cierre. Esta sección junta los enunciados, el guion, las fichas con cada resultado
que hace falta citar o reprobar, un banco de codificaciones y un índice cruzado.

_Convención._ El apunte no fija un símbolo para el cardinal de $RR$: la Práctica 2 (Ej. 7) dice
"sea $c$ el cardinal de $RR$" y los parciales escriben $frak(c)$ o $bold(c)$. Acá $frak(c)$, y
"$\#A = frak(c)$" significa exactamente $A tilde.op RR$ (Definición 3.5). Las referencias
"Práctica 2, Ej. N" siguen la numeración de `guias/p2.typ` y de `guias-agente/guia_2_resuelta_agente.typ`
(ver la nota al final de la sección: algunos parciales citan la guía con los números corridos
en uno).

=== Qué pide el parcial

#enunciado[1C 2024 · Ej. 1][
  Calcular el cardinal de:
  #set enum(numbering: "(a)")
  + El conjunto de polinomios de una variable con coeficientes racionales, $QQ[x]$.
  + El conjunto $cal(A)$ de los números reales algebraicos, definido por
    $ cal(A) := {alpha in RR : exists p in QQ[x] without {0}, space p(alpha) = 0}. $
    Sugerencia: Use el ítem (a).
]
*Veredicto:* $aleph_0$ en (a) y en (b). *Fichas:* C20 (o la codificación con primos del banco),
C14, C13, C12, C8 (cota superior de (a)); C30, C13 (cota superior de (b)); copia de $NN$ con los
polinomios constantes y con $QQ subset.eq cal(A)$; cierre C7. Resolución oficial.

#enunciado[2C 2024 · Ej. 2][
  Calcular el cardinal del conjunto ${B subset.eq QQ : \#B = \#(QQ without B)}$.
]
*Veredicto:* $frak(c)$. *Fichas:* C3, C15, C8, C16 (cota superior: inclusión en $cal(P)(QQ)$);
C22, C23 (cota inferior: $B |-> B union ((1,2) inter QQ)$ desde $cal(P)(NN)$); cierre C5.
Resolución oficial. Es la versión en $QQ$ del Ej. 13 de la Práctica 2 (ficha C18).

#enunciado[1C 2025 · Ej. 1][
  Sea $A$ el conjunto de sucesiones $(a_n)_(n in NN)$ de números enteros que cumplen
  $a_(n+1) - a_n in {1, 2}$ para todo $n in NN$. Halle el cardinal de $A$.
]
*Veredicto:* $frak(c)$. *Fichas:* C26 (la biyección $A tilde.op ZZ times {1,2}^NN$), C16 y C9
(cota inferior), C25, C24, C19, C11, C15 (cota superior); cierre C5. Resolución propuesta.

#enunciado[Recu 1C 2025 · Ej. 1][
  Sea $A$ el conjunto de sucesiones $(a_n)_(n in NN)$ de números enteros que cumplen
  $a_n divides a_(n+1)$ para todo $n in NN$. Halle el cardinal de $A$.
]
*Veredicto:* $frak(c)$. *Fichas:* C3 y C24 (cota superior: $A subset.eq ZZ^NN$); C27, C16, C9
(cota inferior: $b |-> (2^(s_n))_n$); cierre C5. Resolución propuesta y resolución de un
alumno (R$+$).

#enunciado[2C 2025 · Ej. 2][
  Calcular el cardinal de
  $A = {(a_n)_(n in NN) subset.eq QQ : exists k in NN "tal que" a_(n+k) = (a_k)^n space forall n in NN}$.
]
*Veredicto:* $aleph_0$. *Fichas:* C28 (determinada por los primeros $k$ términos), C8, C14, C11,
C4, C13 (cota superior); copia de $QQ$ con $(q, q, q^2, dots)$; cierre C7 (o C5). Plantilla: C21.
Resolución propuesta.

#enunciado[Recu 2C 2025 · Ej. 2][
  Calcular el cardinal de $C = {f : QQ -> NN : f(q) = 3 "para todo" q in QQ "salvo finitos"}$.
]
*Veredicto:* $aleph_0$. *Fichas:* C29 (gráfico reducido finito), C8, C11, C17, C3 (cota
superior); copia de $NN$ con $f_k$; cierre C7 (o C5). Plantilla: C21. Resolución propuesta.

=== El guion

Los tres pasos, en el orden en que conviene escribirlos en el examen.

+ *Cota superior.* Meter el conjunto $A$ en algo de cardinal conocido, de dos maneras:
  - _inclusión_: $A subset.eq T$ con $\#T$ conocido (la inclusión es inyectiva, ficha C3):
    $A subset.eq ZZ^NN$ (Recu 1C 2025), $cal(A) subset.eq cal(P)(QQ)$ (2C 2024);
  - _codificación inyectiva_: una función inyectiva $A -> T$ que lea "los datos que determinan a
    cada elemento": polinomio $|->$ coeficientes, sucesión $|->$ gráfico, sucesión $|->$ (primer
    término, pasos), función $|->$ gráfico finito, sucesión $|->$ cabeza finita (banco de trucos).
  El $T$ de llegada es siempre uno de estos: $NN$, $NN times NN$, $union.big_k QQ^k$,
  $cal(P)_f (NN)$ (dan $aleph_0$); $cal(P)(NN)$, ${0,1}^NN$, $ZZ^NN$, $RR times RR$ (dan $frak(c)$).
+ *Cota inferior.* Una copia de $NN$ adentro de $A$ (para $aleph_0$) o una copia de
  ${0,1}^NN$ o de $cal(P)(NN)$ (para $frak(c)$). La copia de $NN$ son casi siempre "las
  constantes" (banco de trucos); la de ${0,1}^NN$ hay que diseñarla: cada bit es una decisión
  libre que la condición del conjunto permite tomar infinitas veces (paso $1$ o $2$; multiplicar
  o no por $2$; poner $2n$ o $2n - 1$).
+ *Cierre.* Dos formas:
  - _Cantor--Schröder--Bernstein_ (C5): $\#T_1 <= \#A <= \#T_2$ con $\#T_1 = \#T_2$, luego
    $\#A = \#T_1$. Sirve para los dos veredictos.
  - _"contable e infinito $=>$ numerable"_ (C7, Definición 3.6): si $A arrow.hook NN$, $A$ es
    contable (C6); si además contiene una copia de $NN$, es infinito; luego numerable. Sólo para
    $aleph_0$, y es lo que usan 1C 2024, 2C 2025 y Recu 2C 2025.

*Árbol de decisión para adivinar el veredicto antes de empezar.*

- ¿Cada elemento queda determinado por *finitos* datos tomados de un conjunto contable
  (finitas coordenadas en $QQ$ o $ZZ$, un conjunto finito, un polinomio)? $=>$ $aleph_0$.
  Ejemplos: $QQ[x]$; sucesiones periódicas o eventualmente constantes; $a_(n+k) = a_k^n$ (fijada
  por $a_1, dots, a_k$); funciones $QQ -> NN$ casi constantes (fijadas por su gráfico finito);
  los algebraicos (unión numerable de conjuntos finitos de raíces); subconjuntos *finitos* de un
  numerable.
- ¿Hay *infinitas elecciones libres* con al menos dos opciones cada una, independientes entre
  sí? $=>$ $frak(c)$. Ejemplos: sucesiones con $a_(n+1) - a_n in {1,2}$ (una elección binaria
  por paso); $a_n divides a_(n+1)$ (multiplicar o no por $2$ en cada paso); subconjuntos
  *arbitrarios* de $QQ$ o de $NN$ con alguna condición de "mitad y mitad" (una elección por
  cada par ${2n-1, 2n}$); cualquier cosa que contenga a $ZZ^NN$ o a $cal(P)(NN)$.
- Si la condición parece infinita pero fuerza que a partir de un momento no haya elección
  (converge en $ZZ$ $=>$ eventualmente constante; periódica $=>$ repite un bloque), vuelve al
  primer caso: $aleph_0$.
- Chequeo rápido: $aleph_0 < frak(c)$ (C9), así que las dos respuestas son incompatibles. Si la
  cota superior salió $aleph_0$ y se encuentra una copia de ${0,1}^NN$, uno de los dos pasos
  está mal.

=== Fichas

Las fichas van en el orden del guion: primero lo que se cita del apunte (nivel "apunte"),
después los ejercicios de la Práctica 2 que los parciales usan como herramientas (nivel "guía":
se cita el ejercicio, se da la idea), y por último lo que algún parcial tuvo que probar en el
lugar (nivel "propio": demostración completa, porque en el examen hay que escribirla).

==== Nivel apunte

#ficha(
  id: "C1", titulo: "Conjuntos coordinables y relación de equivalencia", nivel: "apunte",
  fuente: [Definición 3.1 y Proposición 3.2 de `apuntes.typ`],
  usado: [los seis parciales],
  lean: [`Comun.Coordinables`, `Comun.coordinables_trans`, `Comun.coordinables_symm`],
)[
  *Enunciado.* $X tilde.op Y$ si existe una biyección $f : X -> Y$. La relación $tilde.op$ es
  reflexiva (identidad), simétrica (la inversa de una biyección es biyección) y transitiva
  (composición de biyecciones).

  *Cómo se usa.* "$\#A = \#B$" quiere decir $A tilde.op B$. La transitividad es lo que permite
  encadenar: $cal(P)(NN times ZZ) tilde.op cal(P)(NN) tilde.op {0,1}^NN tilde.op [0,1) tilde.op RR$
  (1C 2025, Recu 1C 2025), $QQ^k tilde.op NN^k tilde.op NN$ (2C 2025). La simetría permite usar
  una biyección "al revés" (de $QQ tilde.op NN$ se saca $QQ arrow.hook NN$). También: si
  $f : A -> B$ es inyectiva, entonces $A tilde.op f(A)$ (es biyectiva sobre su imagen), que es
  como se pasa de "inyección en $NN$" a "coordinable con un subconjunto de $NN$".
]

#ficha(
  id: "C2", titulo: [Cardinal; finito, infinito, numerable, contable; $aleph_0$ y $frak(c)$],
  nivel: "apunte",
  fuente: [Definiciones 3.5 y 3.6, Observación 3.7 de `apuntes.typ`; Práctica 2, Ej. 7 (nombre $c$)],
  usado: [los seis parciales],
  lean: [`Comun.Finito`, `Comun.Infinito`, `Comun.Numerable`, `Comun.Contable`, `Comun.CardC`;
    puentes `Comun.numerable_iff_mk_eq_aleph0`, `Comun.cardC_iff_mk_eq_continuum`],
)[
  *Enunciado.* $\#X$ es la clase de los conjuntos coordinables con $X$. Un conjunto $A$ es
  *finito* si $A tilde.op {1, dots, n}$ para algún $n in NN$ (y entonces $\#A = n$); *infinito*
  si no es finito; *numerable* si $NN tilde.op A$ (y entonces $\#A = aleph_0$); *contable* (a lo
  sumo numerable) si es finito o numerable. Si $A$ es numerable se puede listar
  $A = {a_1, a_2, dots}$ con todos los $a_n$ distintos (Observación 3.7). $frak(c) := \#RR$.

  *Cómo se usa.* El veredicto del parcial es $\#A = aleph_0$ o $\#A = frak(c)$, y hay que
  terminar diciendo exactamente $A tilde.op NN$ o $A tilde.op RR$ (o $\#A <= \#NN$ y $\#NN <= \#A$
  más C5). Para $aleph_0$ casi nunca se da la biyección: se prueba "contable e infinito" (C7).
  Dos detalles de la definición que aparecen en las resoluciones: $NN = {1, 2, 3, dots}$ (las
  sucesiones empiezan en $a_1$), y la lectura literal deja afuera a $nothing$ como conjunto
  contable (consulta docente en `guias/p2.typ`); en los parciales esto no interviene porque todos
  los conjuntos son infinitos.
]

#ficha(
  id: "C3", titulo: "Orden entre cardinales: inyecciones e inclusiones", nivel: "apunte",
  fuente: [Definición 3.8, Observación 3.10 y la Observación que sigue a la Proposición 3.14 de `apuntes.typ`],
  usado: [los seis parciales],
  lean: [`Comun.CardLe`, `Comun.cardLe_of_subset`, `Comun.cardLe_trans`, `Comun.cardLe_congr`],
)[
  *Enunciado.* $\#A <= \#B$ si existe una inyección $A -> B$; $\#A < \#B$ si además
  $\#A != \#B$. La relación es reflexiva y transitiva (composición de inyectivas) y no depende de
  los representantes: si $\#A <= \#B$, $A tilde.op X$ y $B tilde.op Y$, entonces $\#X <= \#Y$
  (la inyección es $g compose f compose h^(-1)$). Si $A subset.eq B$ entonces $\#A <= \#B$,
  porque la inclusión es inyectiva.

  *Cómo se usa.* Cada paso del guion es una inyección, y la Observación 3.10 es lo que permite
  reemplazar el conjunto de llegada por uno coordinable: "$\#cal(A) <= \#cal(P)(QQ) = \#cal(P)(NN) = frak(c)$"
  (2C 2024), "$\#A <= \#ZZ^NN = frak(c)$" (Recu 1C 2025). La antisimetría es C5.
]

#ficha(
  id: "C4", titulo: [$<=$ vía sobreyecciones], nivel: "apunte",
  fuente: [Proposición 3.9 de `apuntes.typ`],
  usado: [2C 2025 Ej. 2],
  lean: [`Comun.cardLe_of_surj`, `Comun.exists_surj_of_cardLe`],
)[
  *Enunciado.* Si $A != nothing$, entonces $\#A <= \#B$ si y sólo si existe una sobreyección
  $g : B -> A$. (La vuelta elige una preimagen para cada $a$: axioma de elección.)

  *Cómo se usa.* "La imagen de un conjunto contable es contable": si $phi : X -> Y$ y $X$ es
  contable, entonces $phi : X -> phi(X)$ es sobreyectiva, luego $\#phi(X) <= \#X <= aleph_0$ y
  $phi(X)$ es contable por C6. Así se ve en 2C 2025 que cada $phi_k (QQ^k)$ es contable sin
  preocuparse por si $phi_k$ es inyectiva.
]

#ficha(
  id: "C5", titulo: "Cantor--Schröder--Bernstein", nivel: "apunte",
  fuente: [Teorema 3.11 de `apuntes.typ`],
  usado: [2C 2024 Ej. 2 · 1C 2025 Ej. 1 · Recu 1C 2025 Ej. 1 · 2C 2025 Ej. 2 · Recu 2C 2025 Ej. 2],
  lean: [`Comun.teorema_CSB`],
)[
  *Enunciado.* Si existen inyecciones $f : A -> B$ y $g : B -> A$, existe una biyección
  $A -> B$. Es decir: $\#A <= \#B$ y $\#B <= \#A$ implican $\#A = \#B$.

  *Cómo se usa.* Cierra el guion cuando las dos cotas son inyecciones: de
  $frak(c) = \#{0,1}^NN <= \#A <= \#ZZ^NN = frak(c)$ sale $\#A = frak(c)$ (Recu 1C 2025); de
  $aleph_0 = \#NN <= \#C <= aleph_0$ sale $\#C = aleph_0$ (Recu 2C 2025). También está adentro de
  casi todas las fichas de nivel guía ($NN times NN tilde.op NN$, $[0,1) tilde.op {0,1}^NN$,
  $RR times RR tilde.op RR$). Nunca hace falta construir la biyección.
]

#ficha(
  id: "C6", titulo: "Subconjuntos de numerables son contables", nivel: "apunte",
  fuente: [Proposición 3.13 de `apuntes.typ`],
  usado: [1C 2024 Ej. 1 · 2C 2024 Ej. 2 · 2C 2025 Ej. 2 · Recu 2C 2025 Ej. 2],
  lean: [`Comun.contable_of_cardLe_numerable` (forma "inyección"), `Comun.contable_subtype_nat`],
)[
  *Enunciado.* Si $A$ es numerable y $nothing != B subset.eq A$, entonces $B$ es contable
  (finito o numerable). La prueba enumera $A$ y recorre la lista quedándose con los elementos de
  $B$.

  *Cómo se usa.* En la forma "inyección": si $f : X -> NN$ es inyectiva entonces
  $X tilde.op f(X) subset.eq NN$ (C1) y $f(X)$ es contable, luego $X$ es contable. Esto convierte
  toda cota superior "$X arrow.hook NN$" en "$X$ es contable", que es la mitad del cierre C7. En
  2C 2024 se usa con $A = QQ$: todo subconjunto de $QQ$ tiene cardinal $<= aleph_0$.
]

#ficha(
  id: "C7", titulo: [Infinito contiene un numerable; contable e infinito $=>$ numerable],
  nivel: "apunte",
  fuente: [Proposición 3.14 y Definición 3.6 de `apuntes.typ`],
  usado: [1C 2024 Ej. 1 · 2C 2025 Ej. 2 · Recu 2C 2025 Ej. 2],
  lean: [`Comun.cardLe_nat_of_infinito`, `Comun.numerable_iff_contable_infinito`,
    `Comun.infinito_of_cardLe_nat`; en los parciales, Mathlib `Cardinal.mk_eq_aleph0`],
)[
  *Enunciado.* Si $A$ es infinito, existe $B subset.eq A$ numerable; en particular
  $aleph_0 <= \#A$. Consecuencia (por la Definición 3.6, contable $=$ finito o numerable): un
  conjunto contable que no es finito es numerable. Recíproca útil: si $NN arrow.hook A$ entonces
  $A$ es infinito (si fuera finito habría una inyección ${1, dots, n+1} -> {1, dots, n}$,
  principio del palomar; la guía lo toma como hecho de base).

  *Cómo se usa.* Es el cierre estándar para $aleph_0$: (i) $A arrow.hook NN$ da contable (C6);
  (ii) una copia de $NN$ adentro de $A$ (constantes) da infinito; (iii) contable y no finito
  $=>$ $\#A = aleph_0$. Así terminan 1C 2024 ("$QQ[x]$ es contable y $\#QQ[x] >= \#NN$, así que
  es numerable"), 2C 2025 y Recu 2C 2025. Alternativa equivalente: $aleph_0 <= \#A <= aleph_0$ y C5.
]

#ficha(
  id: "C8", titulo: [Numerabilidad de $QQ$], nivel: "apunte",
  fuente: [Proposición "Numerabilidad de $QQ$" de `apuntes.typ`],
  usado: [1C 2024 Ej. 1 · 2C 2024 Ej. 2 · 2C 2025 Ej. 2 · Recu 2C 2025 Ej. 2],
  lean: [`Comun.numerable_rat`, `Comun.cardLe_rat_nat`, `Comun.cardLe_nat_rat`],
)[
  *Enunciado.* $NN tilde.op QQ$, es decir $\#QQ = aleph_0$.

  *Cómo se usa.* Da a la vez una inyección $QQ arrow.hook NN$ (para codificar coeficientes o
  coordenadas racionales con naturales: 1C 2024, 2C 2025, Recu 2C 2025) y una
  $NN arrow.hook QQ$ (para que $QQ$ y sus intervalos sean infinitos: 2C 2024). Con C11 y C15 se
  obtienen $QQ times NN tilde.op NN$, $QQ^k tilde.op NN$ y $cal(P)(QQ) tilde.op cal(P)(NN)$.
]

#ficha(
  id: "C9", titulo: [$RR$ no es numerable; $RR tilde.op$ cualquier intervalo; $aleph_0 < frak(c)$],
  nivel: "apunte",
  fuente: [Teorema 3.19 y Observación 3.21 de `apuntes.typ`],
  usado: [1C 2025 Ej. 1 · Recu 1C 2025 Ej. 1 (y 2C 2024 a través de C16)],
  lean: [`Comun.no_numerable_real`, `Comun.cardC_Ico`, `Comun.cardC_Ioo`, `Comun.cardLt_nat_real`],
)[
  *Enunciado.* $RR$ no es numerable (diagonal de Cantor sobre $(0,1)$). $RR$ es coordinable con
  todo intervalo abierto, cerrado o semiabierto: en particular $[0,1) tilde.op RR$. Como
  $NN subset.eq RR$ y no hay biyección, $aleph_0 < frak(c)$.

  *Cómo se usa.* $[0,1) tilde.op RR$ es el último eslabón para pasar de ${0,1}^NN$ a $RR$:
  $\#{0,1}^NN = \#[0,1) = \#RR = frak(c)$ (C16). Y $aleph_0 < frak(c)$ es lo que hace que los
  dos veredictos sean distintos: un conjunto que contiene una copia de ${0,1}^NN$ no puede ser
  numerable.
]

==== Nivel guía

#ficha(
  id: "C10", titulo: [$ZZ tilde.op NN$], nivel: "guia",
  fuente: [Práctica 2, Ej. 1 (b), Sublema A (`guias-agente`)],
  usado: [1C 2025 Ej. 1 · Recu 1C 2025 Ej. 1 (dentro de $NN times ZZ tilde.op NN$)],
  lean: [`Comun.natEquivInt`, `Comun.int_coordinables_nat`, `Comun.cardLe_int_nat`],
)[
  *Enunciado.* $\#ZZ = aleph_0$.

  *Idea.* $g : NN -> ZZ$, $g(n) = n slash 2$ si $n$ es par y $g(n) = -(n-1) slash 2$ si $n$ es
  impar: los pares van a los enteros $>= 1$ y los impares a los $<= 0$. Inyectiva porque en cada
  rama es estrictamente monótona y las ramas caen en mitades disjuntas de $ZZ$; sobreyectiva
  porque $z >= 1$ viene de $2z$ y $z <= 0$ de $1 - 2z$.

  *Cómo se usa.* Da $ZZ arrow.hook NN$ y $NN arrow.hook ZZ$. En 1C 2025 aparece como
  "$\#ZZ = aleph_0 <= frak(c)$" (aunque ahí basta $ZZ subset.eq RR$), y en los dos lemas
  $\#ZZ^NN = frak(c)$ como $NN times ZZ tilde.op NN times NN tilde.op NN$ (C11).
]

#ficha(
  id: "C11", titulo: [$NN times NN tilde.op NN$ (y $ZZ times NN$, $QQ times NN$, $NN times ZZ$)], nivel: "guia",
  fuente: [Práctica 2, Ej. 1 (c), Sublema B (`guias-agente`); también Ej. 6 (a), Sublema 2],
  usado: [1C 2025 Ej. 1 · Recu 1C 2025 Ej. 1 · 2C 2025 Ej. 2 · Recu 2C 2025 Ej. 2],
  lean: [`Comun.natProdNat_numerable`, `Comun.pairEmb`, `Comun.pow_two_three_inj`, `Comun.cardLe_nat_prod_nat`],
)[
  *Enunciado.* $\#(NN times NN) = aleph_0$. Corolarios: $ZZ times NN tilde.op NN$ (Ej. 1 (c), con
  C10 en la primera coordenada), $NN times ZZ tilde.op NN$ (intercambiar coordenadas) y
  $QQ times NN tilde.op NN$ (con C8).

  *Idea.* $phi(n, m) = 2^n 3^m$ es inyectiva: si $2^a 3^b = 2^c 3^d$ con $a <= c$, cancelando
  $2^a$ queda $3^b = 2^(c-a) 3^d$; si $c > a$ el lado derecho es par y el izquierdo impar, luego
  $a = c$ y $3^b = 3^d$ da $b = d$ ($x |-> 3^x$ es estrictamente creciente). $psi(n) = (n, 1)$
  es inyectiva. Cantor--Schröder--Bernstein (C5).

  *Cómo se usa.* Comprime dos coordenadas contables en una. Es la pieza de C13 (unión
  numerable), de C14 (potencias finitas) y de los codominios $cal(P)(NN times ZZ)$ (C24) y
  $cal(P)_f (QQ times NN)$ (Recu 2C 2025). Los parciales 2C 2025 y Recu 2C 2025 lo citan como
  "Ejemplo 3.12", que no existe en `apuntes.typ`: la referencia correcta es esta ficha.
]

#ficha(
  id: "C12", titulo: "Unión de dos contables es contable", nivel: "guia",
  fuente: [Práctica 2, Ej. 2 (`guias-agente`)],
  usado: [1C 2024 Ej. 1 (a) ($QQ[x] = {0} union union.big_n QQ_n [x]$)],
  lean: [`Comun.union_contable`],
)[
  *Enunciado.* Si $A$ y $B$ son contables, $A union B$ es contable.

  *Idea.* Cadena de inyecciones $A union B arrow.hook A union.sq B arrow.hook NN union.sq NN arrow.hook NN$:
  cada $x$ va a su copia en $A$ si $x in A$ y a la de $B$ si no; "contable" da inyecciones
  $A arrow.hook NN$, $B arrow.hook NN$; la primera copia de $NN$ va a los pares y la segunda a
  los impares. Se cierra con C6.

  *Cómo se usa.* Para agregar un pedazo finito o contable que quedó afuera de una unión
  numerable: en 1C 2024 el polinomio $0$, que no tiene grado, se pone aparte y se junta al
  final. También es el caso $A_1 = A$, $A_n = B$ de C13.
]

#ficha(
  id: "C13", titulo: "Unión numerable de contables es contable", nivel: "guia",
  fuente: [Práctica 2, Ej. 6 (a) (`guias-agente`)],
  usado: [1C 2024 Ej. 1 (a) y (b) · 2C 2025 Ej. 2],
  lean: [`Comun.contable_iUnion`, `Comun.cardLe_iUnion_prod`, `Comun.idx`; en los parciales, Mathlib
    `Set.countable_iUnion`, `Set.Countable.biUnion`],
)[
  *Enunciado.* Si cada $A_n$ ($n in NN$) es contable, $union.big_(n in NN) A_n$ es contable. (Puede
  ser finito; si además es infinito, es numerable por C7.)

  *Idea.* Se eligen a la vez inyecciones $f_n : A_n -> NN$ (axioma de elección). Para $x$ en la
  unión, $n(x) = op("mín") {n : x in A_n}$ y $F(x) = (n(x), f_(n(x))(x)) in NN times NN$. Si
  $F(x) = F(y)$, las primeras coordenadas dan $n(x) = n(y) = n$ y las segundas $f_n (x) = f_n (y)$
  con $x, y in A_n$, luego $x = y$. Con C11, $union.big A_n arrow.hook NN$, y C6 cierra. Usar el
  índice *mínimo* es lo que hace inyectiva a $F$.

  *Cómo se usa.* Siempre que el conjunto se parte "por un parámetro natural": por grado
  ($QQ[x] = union.big_n QQ_n [x]$, 1C 2024 (a)), por polinomio ($cal(A) = union.big_p R_p$,
  1C 2024 (b), con el índice $p$ recorriendo el numerable $QQ[x] without {0}$), por testigo $k$
  ($A = union.big_k phi_k (QQ^k)$, 2C 2025). La hipótesis "cada pedazo es contable" se prueba
  con C4, C6 o C14.
]

#ficha(
  id: "C14", titulo: [Potencias finitas de un contable: $X^N$ y $union.big_N X^N$], nivel: "guia",
  fuente: [Práctica 2, Ej. 16, Lemas A y B; Ej. 6 (b), Sublemas 3 y 4 (`guias-agente`)],
  usado: [2C 2025 Ej. 2 ($QQ^k$) · 1C 2024 Ej. 1 (a) ($QQ_n [x]$, en la versión Lean)],
  lean: [`Comun.cardLe_sigma_nat`, `Comun.codTupla`, `Comun.par`, `Comun.finito_pow`],
)[
  *Enunciado.* Si $\#X <= aleph_0$ entonces $\#X^N <= aleph_0$ para todo $N in NN$, y también
  $\#(union.big_(N in NN) X^N) <= aleph_0$. Si $X$ es finito, cada $X^N$ es finito.

  *Idea.* Con $c : X arrow.hook NN$ y $pi(m, n) = 2^m (2n + 1)$ (inyectiva: cancelar $2^m$ y
  comparar paridad), por inducción $c_(N+1)(x_1, dots, x_(N+1)) = pi(c(x_1), c_N (x_2, dots, x_(N+1)))$
  es inyectiva; y $(N, "tupla") |-> pi(N, c_N ("tupla"))$ inyecta la unión en $NN$. Alternativa sin
  $pi$: $X^(N+1) tilde.op X times X^N$ (separar la primera coordenada) y C11 por inducción.

  *Cómo se usa.* "$QQ^k$ es numerable" (2C 2025: $QQ^k tilde.op NN^k tilde.op NN$) y "un
  polinomio de grado $n$ con coeficientes en $QQ$ es una $(n+1)$-upla" (1C 2024). La resolución
  oficial de 1C 2024 hace lo mismo con primos distintos $p_0, dots, p_n$ y una inyección
  $phi : QQ -> NN$: $sum_j a_j x^j |-> product_j p_j^(phi(a_j))$, inyectiva por la unicidad de la
  factorización (ver el banco).
]

#ficha(
  id: "C15", titulo: [$cal(P)(A) tilde.op {0,1}^A$ y $A tilde.op B => cal(P)(A) tilde.op cal(P)(B)$], nivel: "guia",
  fuente: [Práctica 2, Ej. 8 (a) y Ej. 9 (c) (`guias-agente`)],
  usado: [2C 2024 Ej. 2 ($cal(P)(QQ) tilde.op cal(P)(NN)$) · 1C 2025 Ej. 1 y Recu 1C 2025 Ej. 1 ($cal(P)(NN times ZZ) tilde.op cal(P)(NN)$)],
  lean: [`Comun.setEquivBool`, `Comun.coordinables_set_fun_bool`, `Comun.partesCongr`, `Comun.coordinables_set`],
)[
  *Enunciado.* (a) $S |-> chi_S$ (función característica) es una biyección
  $cal(P)(A) -> {0,1}^A$, con inversa $f |-> f^(-1)({1})$. (b) Si $f : A -> B$ es biyectiva,
  $S |-> f(S)$ es una biyección $cal(P)(A) -> cal(P)(B)$ con inversa $T |-> f^(-1)(T)$, porque
  $f^(-1)(f(S)) = S$ ($f$ inyectiva) y $f(f^(-1)(T)) = T$ ($f$ sobreyectiva).

  *Cómo se usa.* (a) identifica "subconjuntos de $NN$" con "sucesiones de ceros y unos", que es
  la forma cómoda de ${0,1}^NN$ para las copias. (b) permite cambiar el conjunto de base por un
  coordinable: $cal(P)(QQ) tilde.op cal(P)(NN)$ (C8), $cal(P)(NN times ZZ) tilde.op cal(P)(NN)$
  (C11). Los parciales 1C 2025 y Recu 1C 2025 citan (b) como "Ej. 8 (c)"; en `p2.typ` es el 9 (c).
]

#ficha(
  id: "C16", titulo: [$[0,1) tilde.op {0,1}^NN$ y $\#cal(P)(NN) = \#{0,1}^NN = frak(c)$], nivel: "guia",
  fuente: [Práctica 2, Ej. 10 (a) y (b) (`guias-agente`)],
  usado: [2C 2024 Ej. 2 · 1C 2025 Ej. 1 · Recu 1C 2025 Ej. 1],
  lean: [`Comun.cardC_set_nat`, `Comun.serie_injective`, `Comun.serieIcoEmb`, `Comun.cardLe_real_set_nat`],
)[
  *Enunciado.* $[0,1) tilde.op {0,1}^NN$; por lo tanto
  $cal(P)(NN) tilde.op {0,1}^NN tilde.op [0,1) tilde.op RR$ y $\#cal(P)(NN) = \#{0,1}^NN = frak(c)$.
  Además ${1,2}^NN tilde.op {0,1}^NN$ (sumar $1$ en cada término), así que también
  $\#{1,2}^NN = frak(c)$.

  *Idea.* Dos inyecciones y C5. $[0,1) -> {0,1}^NN$: $x |-> (floor(2^n x) op("mod") 2)_n$, los
  dígitos binarios calculados con la parte entera (así no hay que elegir un desarrollo); dos
  números con los mismos dígitos cumplen $abs(x - y) < 2^(-n)$ para todo $n$. ${0,1}^NN -> [0,1)$:
  $a |-> sum_(n >= 1) a_n slash 3^n$; en el primer índice $k$ donde $a$ y $b$ difieren, el término
  $1 slash 3^k$ es estrictamente mayor que toda la cola $sum_(n > k) 1 slash 3^n = 1 slash (2 dot 3^k)$,
  así que las sumas son distintas (base $3$ esquiva la no unicidad del desarrollo binario). (b)
  encadena con C15 (a) y la Observación 3.21.

  *Cómo se usa.* Es *la* cota inferior para $frak(c)$: basta inyectar ${0,1}^NN$ o $cal(P)(NN)$
  en el conjunto. Y es la cota superior de todo lo que vive en $cal(P)(QQ)$ (2C 2024) o en
  $cal(P)(NN times ZZ)$ (C24). Los parciales 1C 2025 y Recu 1C 2025 lo citan como "Ej. 9 (a)/(b)";
  en `p2.typ` es el 10.
]

#ficha(
  id: "C17", titulo: "Partes finitas de un numerable es numerable", nivel: "guia",
  fuente: [Práctica 2, Ej. 11 (`guias-agente`)],
  usado: [Recu 2C 2025 Ej. 2 (citado como "Ej. 10")],
  lean: [`Comun.partes_finitas_numerable`, `Comun.partes_finitas_contable`, `Comun.codigo_injective`;
    en el parcial, Mathlib `Set.countable_ofPred_finite_subset`],
)[
  *Enunciado.* Si $A$ es numerable, $cal(P)_f (A) = {B subset.eq A : B "finito"}$ es numerable.

  *Idea.* Enumerar $A = {a_1, a_2, dots}$ y codificar $B |-> sum_(a_k in B) 2^k in NN$: es
  inyectiva por la unicidad del desarrollo binario (si $S != T$ son finitos y $k$ es el máximo de
  la diferencia simétrica, la diferencia de las sumas es al menos $2^k - sum_(j < k) 2^j >= 2$).
  Con C6, $cal(P)_f (A)$ es contable; los conjuntos ${a_n}$ dan una copia de $NN$; C7.

  *Cómo se usa.* Codominio de la codificación "función $|->$ gráfico finito" (C29): una función
  $QQ -> NN$ que vale $3$ salvo en finitos puntos es un subconjunto finito de $QQ times NN$, y
  $QQ times NN$ es numerable (C8, C11).
]

#ficha(
  id: "C18", titulo: [Subconjuntos de $NN$ con complemento infinito: $\#{B subset.eq NN : \#B = \#(NN without B) = aleph_0} = frak(c)$], nivel: "guia",
  fuente: [Práctica 2, Ej. 13 (`guias-agente`)],
  usado: [ningún parcial lo cita; 2C 2024 Ej. 2 es su versión en $QQ$ (resuelta con la copia de C23)],
  lean: [`Guias.Guia2.Ej13.ej13`; `Comun.corte_injective`, `Comun.setRatEquivSetNat`],
)[
  *Enunciado.* $Omega = {B subset.eq NN : \#B = \#(NN without B) = aleph_0}$ tiene cardinal $frak(c)$.

  *Idea.* $Omega subset.eq cal(P)(NN)$ da $\#Omega <= frak(c)$ (C3, C16). Para la otra: a
  $a in {0,1}^NN$ se le asigna $Phi(a) = {2n : a_n = 1} union {2n - 1 : a_n = 0}$, que elige *un*
  elemento de cada par ${2n-1, 2n}$; $Phi(a)$ y su complemento tienen exactamente un elemento
  por par, luego son numerables, y $2n in Phi(a) <=> a_n = 1$ da la inyectividad. Con C16, C5.

  *Cómo se usa.* Es el modelo de "una elección binaria por bloque": el mismo diseño sirve para
  cualquier condición del tipo "mitad y mitad". En 2C 2024 se usó otra copia (agregar un intervalo
  racional fijo, C23), pero ésta también funciona cambiando $NN$ por una enumeración de $QQ$.
]

#ficha(
  id: "C19", titulo: [$RR times RR tilde.op RR$, $RR^k tilde.op RR$ y $\#(NN times RR) <= frak(c)$], nivel: "guia",
  fuente: [Práctica 2, Ej. 14 (b) y (c), Lemas 1 y 2; Ej. 7 (b), Sublema 2 (`guias-agente`)],
  usado: [1C 2025 Ej. 1 ($\#(ZZ times ZZ^NN) <= \#(RR times RR) = frak(c)$)],
  lean: [`Comun.cardC_real_prod`, `Comun.cardC_pi`, `Comun.intercalar`, `Comun.cardLe_nat_prod_real`],
)[
  *Enunciado.* $\#(RR times RR) = frak(c)$; $\#RR^k = frak(c)$ para todo $k in NN$;
  $\#(NN times RR) <= frak(c)$ (y por lo tanto una unión numerable de conjuntos de cardinal
  $frak(c)$ tiene cardinal $frak(c)$, Ej. 7 (b)).

  *Idea.* $x |-> (x, 0)$ da $frak(c) <= \#(RR times RR)$. Para la otra, los cortes
  $gamma(x) = {q in QQ : q < x}$ inyectan $RR$ en $cal(P)(QQ)$ (densidad de $QQ$), así que
  $RR times RR arrow.hook cal(P)(QQ) times cal(P)(QQ) tilde.op {0,1}^NN times {0,1}^NN tilde.op {0,1}^NN$,
  la última intercalando dos sucesiones en los lugares impares y pares; y $\#{0,1}^NN = frak(c)$
  (C16). $RR^k$ por inducción separando una coordenada. $NN times RR tilde.op NN times [0,1)$ y
  $(n, t) |-> n + t$ es inyectiva porque $n = floor(n + t)$.

  *Cómo se usa.* Para acotar productos por arriba: si $f : A arrow.hook RR$ y $g : B arrow.hook RR$,
  entonces $(a, b) |-> (f(a), g(b))$ inyecta $A times B$ en $RR times RR tilde.op RR$ (C25).
]

#ficha(
  id: "C20", titulo: [Polinomio $|->$ (grado, coeficientes)], nivel: "guia",
  fuente: [Práctica 2, Ej. 15 (`guias-agente`)],
  usado: [1C 2024 Ej. 1 (a) (es la codificación de la versión Lean; la oficial usa primos)],
  lean: [`Comun.coefs`, `Comun.coefs_injective`, `Comun.coefsEmb`; `Parcial1_1C2024.codif`],
)[
  *Enunciado.* Para un anillo $R$, $F(p) = (d, (a_0, dots, a_d))$, con $d$ el grado de $p$, es una
  inyección $R[x] arrow.hook union.big_(n >= 0) R^(n+1)$. En consecuencia $\#RR[x] = frak(c)$ (con
  C19 y Ej. 7 (b)) y $\#QQ[x] = aleph_0$ (con C14, C8 y la copia de los constantes).

  *Idea.* Si $F(p) = F(q)$, los dos polinomios tienen el mismo grado y los mismos coeficientes
  hasta ese grado; los de índice mayor son $0$ en ambos por definición de grado; un polinomio
  queda determinado por todos sus coeficientes. Los constantes $a |-> a$ dan la cota inferior.

  *Cómo se usa.* Cota superior de 1C 2024 (a): $QQ[x] arrow.hook union.big_n QQ^(n+1)$, contable
  por C14 (o: cada $QQ_n [x] tilde.op QQ^(n+1)$ es contable y se aplica C13 más C12 para el $0$).
]

#ficha(
  id: "C21", titulo: "Sucesiones determinadas por finitos datos: convergentes de enteros, periódicas", nivel: "guia",
  fuente: [Práctica 2, Ej. 16 (a) y (b), Lemas C y D (`guias-agente`)],
  usado: [ningún parcial lo cita; es la plantilla de 2C 2025 Ej. 2 (C28) y de Recu 2C 2025 Ej. 2 (C29)],
  lean: [`Guias.Guia2.Ej16.ej16a`, `ej16b`; `Comun.cardLe_sigma_nat`],
)[
  *Enunciado.* ${(a_n) subset.eq ZZ : (a_n) "converge"}$ y ${(a_n) subset.eq QQ : (a_n) "periódica"}$
  tienen cardinal $aleph_0$.

  *Idea.* Una sucesión convergente de enteros es eventualmente constante (con $epsilon = 1 slash 2$
  los términos lejanos están a distancia $< 1$, y dos enteros a distancia $< 1$ son iguales);
  una periódica repite su primer período. En los dos casos la sucesión queda fijada por una
  "cabeza" finita $(a_1, dots, a_N)$ con $N$ *mínimo* (buen orden), lo que da una inyección en
  $union.big_N ZZ^N$ o $union.big_N QQ^N$, contable por C14 (o C13). Las constantes son una copia
  de $NN$; C7.

  *Cómo se usa.* Es el patrón "determinada por finitos datos $=>$ $aleph_0$" del árbol de
  decisión. Tomar el índice mínimo es lo que hace inyectiva a la codificación (dos cabezas iguales
  de la misma longitud generan la misma sucesión).
]

==== Nivel propio

#ficha(
  id: "C22", titulo: "Un subconjunto infinito de un numerable es numerable", nivel: "propio",
  fuente: [probado en 2C 2024 Ej. 2 (resolución oficial y observación agregada); corolario de las Proposiciones 3.13 y 3.14],
  usado: [2C 2024 Ej. 2 ($\#Phi(B) = \#(QQ without Phi(B)) = aleph_0$) · 1C 2024 Ej. 1 (b) ($QQ[x] without {0}$ numerable)],
  lean: [`Parcial1_2C2024.mk_eq_aleph0_of_infinite_subset`; `Comun.numerable_iff_contable_infinito`,
    `Comun.numerable_of_infinito_subset_nat` (para $NN$)],
)[
  *Enunciado.* Sea $A$ numerable y $T subset.eq S subset.eq A$ con $T$ infinito. Entonces
  $\#S = aleph_0$. En particular todo subconjunto infinito de $QQ$ (o de $NN$, o de $ZZ$) es
  numerable.

  *Demostración.* Como $T$ es infinito, por la Proposición 3.14 contiene un subconjunto
  numerable, es decir hay una inyección $NN arrow.hook T$; compuesta con la inclusión
  $T arrow.hook S$ da $aleph_0 = \#NN <= \#S$ (Definición 3.8). Por otro lado la inclusión
  $S arrow.hook A$ y $A tilde.op NN$ dan $\#S <= \#A = aleph_0$ (Observación 3.10). Por el
  Teorema 3.11, $\#S = aleph_0$. (Alternativa sin CSB: $S subset.eq A$ es contable por la
  Proposición 3.13 y no es finito porque contiene al infinito $T$; luego es numerable por la
  Definición 3.6.) $qed$

  *Cómo se usa en 2C 2024.* Para $B subset.eq NN$ sea $Phi(B) = B union ((1,2) inter QQ)$. Hay que
  ver $Phi(B) in cal(A)$, o sea $\#Phi(B) = \#(QQ without Phi(B))$, y se prueba que *los dos valen*
  $aleph_0$ con dos cadenas independientes:
  $ (1,2) inter QQ subset.eq Phi(B) subset.eq QQ, quad quad (2,3) inter QQ subset.eq QQ without Phi(B) subset.eq QQ. $
  La segunda inclusión de la derecha vale porque un $q in (2,3)$ no está en $(1,2)$ y no está en
  $B subset.eq NN$ (el intervalo abierto $(2,3)$ no tiene naturales). Los intervalos racionales
  son infinitos (C23), así que el enunciado da $aleph_0$ en ambos lados.
]

#ficha(
  id: "C23", titulo: [Intervalos racionales: $(a, b) inter QQ$ es numerable; la copia $B |-> B union ((1,2) inter QQ)$], nivel: "propio",
  fuente: [2C 2024 Ej. 2, observaciones agregadas a la resolución oficial; el caso $(-1,1) inter QQ$ es Práctica 2, Ej. 1 (d)],
  usado: [2C 2024 Ej. 2],
  lean: [`Parcial1_2C2024.Φ_mem`, `Parcial1_2C2024.Φ_injective`; Mathlib `Set.Ioo_infinite`],
)[
  *Enunciado.* (i) Si $a < b$ son racionales, $\#((a,b) inter QQ) = aleph_0$. (ii) La función
  $Phi : cal(P)(NN) -> cal(P)(QQ)$, $Phi(B) = B union ((1,2) inter QQ)$, es inyectiva y toma valores
  en $cal(A) = {S subset.eq QQ : \#S = \#(QQ without S)}$. Por lo tanto $frak(c) = \#cal(P)(NN) <= \#cal(A)$.

  *Demostración.* (i) $(a,b) inter QQ subset.eq QQ$ da $\#((a,b) inter QQ) <= aleph_0$ (C3, C8). La
  función $iota : NN -> (a,b) inter QQ$, $iota(n) = a + (b - a) slash (n + 1)$, está bien definida
  ($0 < (b-a) slash (n+1) <= (b-a) slash 2 < b - a$, y es racional porque $a, b in QQ$) y es
  inyectiva ($n |-> (b-a) slash (n+1)$ es estrictamente decreciente). Luego
  $aleph_0 <= \#((a,b) inter QQ)$ y C5 cierra. (Para $a < b$ reales, primero se toman
  $a < a' < b' < b$ racionales por densidad y se usa $(a',b') inter QQ subset.eq (a,b) inter QQ$.)

  (ii) Que $Phi(B) in cal(A)$ es C22 con las dos cadenas de inclusiones. Inyectividad: como
  $(1,2)$ no contiene naturales, $Phi(B) inter NN = B$; entonces $Phi(B) = Phi(B')$ implica
  $B = Phi(B) inter NN = Phi(B') inter NN = B'$. Con $\#cal(P)(NN) = frak(c)$ (C16),
  $frak(c) <= \#cal(A)$ (Definición 3.8). $qed$

  *Cómo se usa.* Es la cota inferior de 2C 2024; con $cal(A) subset.eq cal(P)(QQ)$,
  $\#cal(P)(QQ) = \#cal(P)(NN) = frak(c)$ (C15, C8, C16) y C5 queda $\#cal(A) = frak(c)$. El
  diseño: "pegar un bloque infinito fijo que no toca a $NN$" garantiza las dos infinitudes y
  permite recuperar $B$ recortando con $NN$.
]

#ficha(
  id: "C24", titulo: [$\#(NN -> ZZ) = \#ZZ^NN = frak(c)$ (sucesión $|->$ gráfico)], nivel: "propio",
  fuente: [Lema probado en 1C 2025 Ej. 1 y en Recu 1C 2025 Ej. 1 (resoluciones propuestas)],
  usado: [1C 2025 Ej. 1 · Recu 1C 2025 Ej. 1],
  lean: [sin lema en `Comun`; en los parciales, Mathlib `Cardinal.aleph0_power_aleph0` (`Recu1_1C2025.ej1`) y
    `Cardinal.mk_set_le`],
)[
  *Enunciado.* El conjunto $ZZ^NN$ de las sucesiones de enteros tiene cardinal $frak(c)$. Lo
  mismo vale para $QQ^NN$ y $NN^NN$ (cambiar $ZZ$ por $QQ$ o $NN$ en la prueba; para $NN^NN$ la
  copia de abajo es ${1,2}^NN$).

  *Demostración.* _$frak(c) <= \#ZZ^NN$:_ ${0,1}^NN subset.eq ZZ^NN$ y $\#{0,1}^NN = frak(c)$ (C16).

  _$\#ZZ^NN <= frak(c)$:_ sea
  $ G : ZZ^NN -> cal(P)(NN times ZZ), quad G(a) = {(n, a_n) : n in NN}. $
  $G$ es inyectiva: si $G(a) = G(b)$ y $n in NN$, el par $(n, a_n)$ está en $G(a) = G(b)$, así que
  $(n, a_n) = (m, b_m)$ para algún $m$; la primera coordenada da $m = n$ y la segunda $a_n = b_n$.
  Como $n$ era arbitrario, $a = b$. El codominio: $NN times ZZ tilde.op NN$ (C11), luego
  $cal(P)(NN times ZZ) tilde.op cal(P)(NN)$ (C15) y $\#cal(P)(NN) = frak(c)$ (C16). Por la
  Observación 3.10, $\#ZZ^NN <= frak(c)$. Teorema 3.11. $qed$

  *Cómo se usa.* Es la cota superior universal para conjuntos de sucesiones enteras o
  racionales: $A subset.eq ZZ^NN$ da $\#A <= frak(c)$ de inmediato (Recu 1C 2025), y
  $ZZ times {1,2}^NN subset.eq ZZ times ZZ^NN$ (1C 2025, con C25).
]

#ficha(
  id: "C25", titulo: [Productos: $\#(A times B) <= frak(c)$ si $\#A, \#B <= frak(c)$; $\#(ZZ times {0,1}^NN) = frak(c)$], nivel: "propio",
  fuente: [1C 2025 Ej. 1 (resolución propuesta, cota superior e inferior)],
  usado: [1C 2025 Ej. 1],
  lean: [en el parcial, Mathlib `Cardinal.aleph0_mul_continuum` (`Parcial1_1C2025.ej1`); las piezas son `Comun.cardC_real_prod`],
)[
  *Enunciado.* Si hay inyecciones $A arrow.hook RR$ y $B arrow.hook RR$, entonces
  $\#(A times B) <= frak(c)$. Si además $frak(c) <= \#B$ y $A != nothing$, entonces
  $\#(A times B) = frak(c)$. En particular $\#(ZZ times {1,2}^NN) = \#(ZZ times {0,1}^NN) = frak(c)$.

  *Demostración.* Sean $f : A -> RR$ y $g : B -> RR$ inyectivas. La función
  $(a, b) |-> (f(a), g(b))$ es inyectiva $A times B -> RR times RR$: si $(f(a), g(b)) = (f(a'), g(b'))$
  entonces $f(a) = f(a')$ y $g(b) = g(b')$, luego $a = a'$ y $b = b'$. Como $RR times RR tilde.op RR$
  (C19), $\#(A times B) <= \#(RR times RR) = frak(c)$ (Observación 3.10). Para la cota inferior,
  fijado $a_0 in A$, $b |-> (a_0, b)$ es inyectiva $B -> A times B$, así que
  $frak(c) <= \#B <= \#(A times B)$. Teorema 3.11.

  Para $ZZ times {1,2}^NN$: $ZZ subset.eq RR$ (inclusión), ${1,2}^NN subset.eq ZZ^NN$ y
  $\#ZZ^NN = frak(c)$ (C24) dan la inyección en $RR$; y $(b_n)_n |-> (0, (b_n + 1)_n)$ es una
  inyección ${0,1}^NN -> ZZ times {1,2}^NN$ (se recupera $b_n$ restando $1$), con
  $\#{0,1}^NN = frak(c)$ (C16). $qed$

  *Cómo se usa.* Cierra 1C 2025 una vez que se tiene $A tilde.op ZZ times {1,2}^NN$ (C26). En
  general: "un dato contable más una sucesión binaria" da $frak(c)$.
]

#ficha(
  id: "C26", titulo: [Primer término + pasos: $A tilde.op ZZ times {1,2}^NN$], nivel: "propio",
  fuente: [1C 2025 Ej. 1 (resolución propuesta)],
  usado: [1C 2025 Ej. 1],
  lean: [`Parcial1_1C2025.equivA`, `reconstruir`, `pasos`, `reconstruir_pasos`, `pasos_reconstruir`],
)[
  *Enunciado.* Sea $A = {(a_n)_(n in NN) subset.eq ZZ : a_(n+1) - a_n in {1,2} space forall n}$. La
  función
  $ Phi : A -> ZZ times {1,2}^NN, quad Phi((a_n)_n) = (a_1, (a_(n+1) - a_n)_(n in NN)) $
  es biyectiva. Por lo tanto $\#A = \#(ZZ times {1,2}^NN) = frak(c)$ (C25).

  *Demostración.* _Bien definida:_ $a_1 in ZZ$ y cada diferencia está en ${1,2}$ por la
  condición que define a $A$.

  _Inyectiva:_ si $Phi((a_n)) = Phi((b_n))$ entonces $a_1 = b_1$ y $a_(n+1) - a_n = b_(n+1) - b_n$
  para todo $n$. Por inducción en $n$, $a_n = b_n$: el caso base es $a_1 = b_1$, y si $a_n = b_n$
  entonces $a_(n+1) = a_n + (a_(n+1) - a_n) = b_n + (b_(n+1) - b_n) = b_(n+1)$.

  _Sobreyectiva:_ dado $(z, (d_n)_n) in ZZ times {1,2}^NN$, se define recursivamente $a_1 = z$ y
  $a_(n+1) = a_n + d_n$. Cada $a_n$ es entero y $a_(n+1) - a_n = d_n in {1,2}$, así que
  $(a_n) in A$, y $Phi((a_n)) = (z, (d_n))$ por construcción. $qed$

  *Cómo se usa.* Es la forma precisa de "una sucesión es su punto de partida más la lista infinita
  de decisiones". Si el enunciado da pasos en un conjunto finito $D$ con $\#D >= 2$, la misma
  prueba da $A tilde.op ZZ times D^NN$ y el cardinal es $frak(c)$. La cota inferior sola (sin la
  biyección) ya alcanza: $b |-> (0, (b_n + 1)_n)$ y la sucesión reconstruida.
]

#ficha(
  id: "C27", titulo: [Exponentes crecientes: ${0,1}^NN arrow.hook {(a_n) subset.eq ZZ : a_n divides a_(n+1)}$], nivel: "propio",
  fuente: [Recu 1C 2025 Ej. 1 (resolución propuesta; variante del alumno con productos parciales)],
  usado: [Recu 1C 2025 Ej. 1],
  lean: [`Recu1_1C2025.codif`, `codif_mem`, `codif_injective`, `cuenta`],
)[
  *Enunciado.* Sea $A = {(a_n)_(n in NN) subset.eq ZZ : a_n divides a_(n+1) space forall n}$. Para
  $b in {0,1}^NN$ sean $s_1 = 0$, $s_(n+1) = s_n + b_n$ (la cantidad de unos entre
  $b_1, dots, b_(n-1)$) y $Phi(b) = (2^(s_n))_(n in NN)$. Entonces $Phi : {0,1}^NN -> A$ es inyectiva
  y $\#A = frak(c)$.

  *Demostración.* _$Phi(b) in A$:_ $2^(s_(n+1)) = 2^(s_n) dot 2^(b_n)$ y el factor
  $2^(b_n) in {1, 2}$ es un entero, así que $2^(s_n) divides 2^(s_(n+1))$ por definición de
  divisibilidad en $ZZ$ ($a divides c$ si $c = a k$ con $k in ZZ$; que $k$ sea entero no se puede
  omitir: $4 = 8 dot 2^(-1)$ y $8 divides.not 4$).

  _Inyectiva:_ si $Phi(b) = Phi(b')$, entonces $2^(s_n) = 2^(s'_n)$ para todo $n$ y, como
  $k |-> 2^k$ es estrictamente creciente en $NN_0$, $s_n = s'_n$. Luego
  $b_n = s_(n+1) - s_n = s'_(n+1) - s'_n = b'_n$ para todo $n$.

  _Cardinal:_ $frak(c) = \#{0,1}^NN <= \#A$ (C16) y $A subset.eq ZZ^NN$ da $\#A <= frak(c)$ (C24).
  Teorema 3.11. $qed$

  *Variante (alumno, con la corrección del docente).* $(k_n)_n |-> (product_(i <= n) k_i)_n$ de
  $(ZZ without {0})^NN$ en $A$ es inyectiva sin pasar por primos: de la imagen $(c_n)$ se recupera
  $k_1 = c_1$ y $k_n = c_n slash c_(n-1)$ (los $c_n$ no se anulan). Y $(ZZ without {0})^NN supset.eq {1,2}^NN$
  tiene cardinal $>= frak(c)$ (C16). El rodeo por sucesiones de primos es correcto pero innecesario.

  *Cómo se usa.* Modelo de "decidir en cada paso si se multiplica o no por un factor fijo": la
  condición de divisibilidad se mantiene porque los exponentes son no decrecientes, y los saltos
  recuperan los bits.
]

#ficha(
  id: "C28", titulo: [Determinada por los primeros $k$ términos: $A = union.big_k phi_k (QQ^k)$], nivel: "propio",
  fuente: [2C 2025 Ej. 2 (resolución propuesta)],
  usado: [2C 2025 Ej. 2],
  lean: [`Parcial1_2C2025.extiende`, `A2_subset`, `A2_countable`, `geom`, `A2_infinite`],
)[
  *Enunciado.* Sea $A = {(a_n) subset.eq QQ : exists k in NN, a_(n+k) = (a_k)^n space forall n in NN}$.
  Para cada $k$ sea $phi_k : QQ^k -> QQ^NN$,
  $ phi_k (q_1, dots, q_k) = (b_n)_n, quad b_n = cases(q_n & "si " n <= k, q_k^(n-k) & "si " n > k). $
  Entonces $A = union.big_(k in NN) phi_k (QQ^k)$, $A$ es contable y contiene una copia de $QQ$;
  luego $\#A = aleph_0$.

  *Demostración.* _$supset.eq$:_ $phi_k (q_1, dots, q_k)$ cumple la condición con testigo $k$:
  para $n in NN$, $b_(n+k) = q_k^(n+k-k) = q_k^n = (b_k)^n$. _$subset.eq$:_ si $(a_n) in A$ con
  testigo $k$, entonces $(a_n) = phi_k (a_1, dots, a_k)$: para $n <= k$ es la definición, y para
  $n > k$, escribiendo $n = (n-k) + k$ con $n - k in NN$, la condición da $a_n = (a_k)^(n-k)$.

  _Contable:_ $QQ^k$ es numerable (C8, C14: $QQ^k tilde.op NN^k tilde.op NN$), así que
  $phi_k (QQ^k)$, imagen sobreyectiva de un numerable, es contable (C4, C6). Unión numerable de
  contables (C13): $A$ es contable, $\#A <= aleph_0$.

  _Infinito:_ $psi : QQ -> A$, $psi(q) = (q, q, q^2, q^3, dots)$ ($a_1 = q$, $a_n = q^(n-1)$ para
  $n >= 2$) está en $A$ con testigo $k = 1$ ($a_(n+1) = q^n = (a_1)^n$) y es inyectiva porque
  $psi(q)_1 = q$. Luego $aleph_0 = \#QQ <= \#A$.

  Teorema 3.11 (o C7). $qed$

  *Cómo se usa.* Es C21 con otra regla de extensión: "la cola está determinada por la cabeza".
  Lo único que cambia respecto de las periódicas es la fórmula de $b_n$ para $n > k$.
]

#ficha(
  id: "C29", titulo: [Gráfico reducido finito: $C arrow.hook cal(P)_f (QQ times NN)$], nivel: "propio",
  fuente: [Recu 2C 2025 Ej. 2 (resolución propuesta)],
  usado: [Recu 2C 2025 Ej. 2],
  lean: [`Recu1_2C2025.grafico`, `grafico_finite`, `grafico_injective`, `C_countable`, `C_infinite`],
)[
  *Enunciado.* Sea $C = {f : QQ -> NN : f(q) = 3 "salvo finitos" q}$. La función
  $ G : C -> cal(P)_f (QQ times NN), quad G(f) = {(q, f(q)) : q in QQ, f(q) != 3} $
  es inyectiva, y $\#C = aleph_0$.

  *Demostración.* _Bien definida:_ $G(f)$ es la imagen del conjunto finito ${q : f(q) != 3}$ por
  $q |-> (q, f(q))$, luego finito.

  _Inyectiva:_ sean $G(f) = G(g)$ y $q in QQ$. Si $f(q) != 3$, entonces $(q, f(q)) in G(f) = G(g)$,
  así que existe $q'$ con $g(q') != 3$ y $(q', g(q')) = (q, f(q))$; comparando coordenadas,
  $q' = q$ y $g(q) = f(q)$. Simétricamente, si $g(q) != 3$ entonces $f(q) = g(q)$. Si
  $f(q) = 3 = g(q)$ coinciden. Luego $f = g$.

  _Codominio numerable:_ $QQ times NN tilde.op NN times NN tilde.op NN$ (C8, C11), así que
  $cal(P)_f (QQ times NN)$ es numerable (C17). Por la Definición 3.8, $\#C <= aleph_0$.

  _Infinito:_ para $k in NN$ sea $f_k (0) = k$ y $f_k (q) = 3$ si $q != 0$. Cada $f_k in C$ y
  $k |-> f_k$ es inyectiva ($f_k (0) = k$). Luego $aleph_0 <= \#C$.

  Teorema 3.11 (o C7). $qed$

  *Cómo se usa.* "Casi constante" $=$ "gráfico finito fuera del valor por defecto". El mismo
  argumento sirve para funciones $X -> Y$ con $X$, $Y$ contables que coinciden con una función
  fija salvo en finitos puntos.
]

#ficha(
  id: "C30", titulo: [Algebraicos: $cal(A) = union.big_(p != 0) R_p$ con $R_p$ finito, y $QQ subset.eq cal(A)$], nivel: "propio",
  fuente: [1C 2024 Ej. 1 (b) (resolución oficial); la finitud de raíces es un hecho de álgebra, no está en `apuntes.typ` ni en la guía],
  usado: [1C 2024 Ej. 1 (b)],
  lean: [`Parcial1_1C2024.R_finite` (Mathlib `Polynomial.finite_setOfPred_isRoot`), `𝒜_eq`, `rat_subset_𝒜`, `ej1b`],
)[
  *Enunciado.* Para $p in QQ[x] without {0}$ sea $R_p = {x in RR : p(x) = 0}$. Entonces $R_p$ es
  finito, $cal(A) = union.big_(p in QQ[x] without {0}) R_p$ y $QQ subset.eq cal(A)$. Por lo tanto
  $\#cal(A) = aleph_0$.

  *Demostración.* _$R_p$ finito:_ un polinomio no nulo de grado $d$ tiene a lo sumo $d$ raíces
  (hecho de base de álgebra; se cita). Atención: la hipótesis $p != 0$ es necesaria, $R_0 = RR$;
  la resolución oficial escribe "para cada $p in QQ[x]$" pero el enunciado excluye al $0$.

  _Igualdad:_ si $x in R_p$ para algún $p != 0$, entonces $p(x) = 0$ y $x in cal(A)$ por
  definición. Si $alpha in cal(A)$, existe $p in QQ[x] without {0}$ con $p(alpha) = 0$, o sea
  $alpha in R_p$.

  _Contable:_ $QQ[x] without {0}$ es numerable (es un subconjunto infinito del numerable $QQ[x]$,
  ítem (a), C22), así que $cal(A)$ es una unión numerable de conjuntos finitos, contable por C13.

  _Infinito:_ para $alpha in QQ$, $p(x) = x - alpha in QQ[x] without {0}$ y $p(alpha) = 0$, así
  que $alpha in cal(A)$; luego $QQ subset.eq cal(A)$ y $aleph_0 = \#QQ <= \#cal(A)$ (C8, C3).

  Contable e infinito $=>$ numerable (C7). $qed$

  *Cómo se usa.* Cada vez que un conjunto se describe como "las soluciones de alguna ecuación de
  una familia numerable, cada una con finitas soluciones": unión numerable de finitos.
]

=== Banco de trucos

*Codificaciones inyectivas (cota superior).* Cada una con su justificación de inyectividad y
dónde se usó.

#table(
  columns: (1.15fr, 1.6fr, 1.05fr),
  align: (left + horizon, left + horizon, left + horizon),
  inset: (x: 6pt, y: 5pt),
  stroke: 0.4pt + luma(170),
  table.header([*Codificación*], [*Por qué es inyectiva*], [*Dónde*]),
  [$(n, m) |-> 2^n 3^m$, $NN times NN -> NN$],
  [cancelar $2^a$ (con $a <= c$), comparar paridad, $3^x$ estrictamente creciente],
  [P2 Ej. 1 (c), 6 (a); C11, C13; `Comun.pairEmb`],
  [$(k, m) |-> 2^k (2m + 1)$, $NN_0 times NN_0 -> NN$],
  [cancelar $2^k$ (con $k <= k'$), comparar paridad, el impar fija $m$; es biyectiva sobre $NN$],
  [P2 Ej. 12 (b), 16; C14; `Comun.par`],
  [$sum_j a_j x^j |-> product_(j = 0)^n p_j^(phi(a_j))$ con $p_j$ primos distintos y $phi : QQ arrow.hook NN$],
  [unicidad de la factorización en primos, luego $phi$ inyectiva],
  [1C 2024 (a) oficial, para $QQ_n [x] -> NN$ (la fórmula del original tiene los índices corridos, marcada "sic")],
  [polinomio $|->$ (grado, $(a_0, dots, a_d)$)],
  [los coeficientes de índice $> d$ son $0$; un polinomio es su sucesión de coeficientes],
  [P2 Ej. 15; 1C 2024 (a) en Lean; C20],
  [tupla $|->$ anidar $pi$: $c_(N+1)(x_1, dots) = pi(c(x_1), c_N (x_2, dots))$; $(N, t) |-> pi(N, c_N (t))$],
  [inducción con la inyectividad de $pi$ y de $c$],
  [P2 Ej. 16 Lema B; C14; `Comun.codTupla`, `codSigma`],
  [unión numerable: $x |-> (n(x), f_(n(x))(x))$ con $n(x)$ el *mínimo* índice],
  [primera coordenada iguala los índices; $f_n$ inyectiva en $A_n$],
  [P2 Ej. 6 (a), 7 (b); C13, C19; `Comun.cardLe_iUnion_prod`],
  [sucesión $|->$ gráfico ${(n, a_n)}$, $ZZ^NN -> cal(P)(NN times ZZ)$],
  [$(n, a_n) in G(b)$ fuerza $a_n = b_n$],
  [1C 2025 y Recu 1C 2025 (lema); C24],
  [función $|->$ gráfico reducido ${(q, f(q)) : f(q) != 3}$, $C -> cal(P)_f (QQ times NN)$],
  [coordenada a coordenada, con el caso $f(q) = 3 = g(q)$ aparte],
  [Recu 2C 2025; C29],
  [sucesión $|->$ (primer término, pasos) $(a_1, (a_(n+1) - a_n)_n)$],
  [inducción: $a_(n+1) = a_n + $ paso],
  [1C 2025; C26],
  [sucesión $|->$ cabeza $(a_1, dots, a_N)$ con $N$ mínimo (eventualmente constante, periódica, "determinada por los primeros $k$")],
  [misma longitud $=>$ mismo $N$; la cola está determinada por la cabeza],
  [P2 Ej. 16; 2C 2025; C21, C28],
  [cortes $x |-> {q in QQ : q < x}$, $RR -> cal(P)(QQ)$],
  [densidad de $QQ$: hay un racional entre $x < y$],
  [P2 Ej. 13, 14; C18, C19; `Comun.corte`],
  [dígitos binarios $x |-> (floor(2^n x) op("mod") 2)_n$, $[0,1) -> {0,1}^NN$],
  [mismos dígitos $=>$ $abs(x - y) < 2^(-n)$ para todo $n$],
  [P2 Ej. 10 (a); C16],
  [función característica $S |-> chi_S$],
  [$chi_S$ determina $S = chi_S^(-1)({1})$; es biyectiva],
  [P2 Ej. 8 (a); C15; `Comun.setEquivBool`],
  [producto de inyecciones $(a, b) |-> (f(a), g(b))$],
  [coordenada a coordenada],
  [1C 2025; P2 Ej. 14; C25],
  [recortar: $Phi(B) inter NN = B$ para $Phi(B) = B union ((1,2) inter QQ)$],
  [el bloque agregado no toca a $NN$],
  [2C 2024; C23],
  [primer índice donde difieren: $k = op("mín") {n : a_n != b_n}$],
  [el término $k$-ésimo domina la cola ($1 slash 3^k > sum_(n > k) 1 slash 3^n$); o $2n in Phi(a) <=> a_n = 1$],
  [P2 Ej. 10 (a), 13; C16, C18],
)

*Copias (cota inferior).*

- De $NN$ (o de $QQ$), casi siempre "las constantes":
  $n |->$ polinomio constante $n$ (1C 2024 (a)); $alpha |-> alpha$ con $alpha in QQ subset.eq cal(A)$
  (1C 2024 (b)); $k |-> (k, k, k, dots)$ (P2 Ej. 16); $q |-> (q, q, q^2, q^3, dots)$ (2C 2025);
  $k |-> f_k$ con $f_k (0) = k$, $f_k = 3$ en el resto (Recu 2C 2025); $n |-> 1 + 1 slash (n+1) in (1,2) inter QQ$
  (2C 2024, C23); $n |-> {a_n}$ en $cal(P)_f (A)$ (P2 Ej. 11); $n |-> (n, 1)$ en $NN times NN$
  (P2 Ej. 1 (c)).
- De ${0,1}^NN$ o de $cal(P)(NN)$ (cardinal $frak(c)$, C16):
  $b |-> (0, (b_n + 1)_n) in ZZ times {1,2}^NN$ (1C 2025, C25); $b |-> (2^(s_n))_n$ con
  $s_n = b_1 + dots + b_(n-1)$ (Recu 1C 2025, C27); $(k_n) |-> (product_(i <= n) k_i)_n$ con
  $k_i in ZZ without {0}$ (alumno, Recu 1C 2025); $B |-> B union ((1,2) inter QQ)$ desde
  $cal(P)(NN)$ (2C 2024, C23); $a |-> {2n : a_n = 1} union {2n - 1 : a_n = 0}$ (P2 Ej. 13, C18);
  ${0,1}^NN subset.eq ZZ^NN$ (inclusión, C24); $x |-> (x, 0) in RR times RR$ y $a |-> a in RR[x]$
  (P2 Ej. 14, 15).
- Entre $frak(c)$ y $frak(c)$: $a |-> sum_(n >= 1) a_n slash 3^n$, ${0,1}^NN arrow.hook [0,1)$
  (P2 Ej. 10 (a)); $(n, t) |-> n + t$, $NN times [0,1) arrow.hook RR$ (P2 Ej. 7 (b)); intercalar
  $(a, b) |-> (a_1, b_1, a_2, b_2, dots)$, ${0,1}^NN times {0,1}^NN tilde.op {0,1}^NN$
  (P2 Ej. 14 (a)); $[0,1) tilde.op RR$ (Observación 3.21).

*Dos errores a evitar.* (1) En $a divides c$ el cociente tiene que ser entero: $2^(s_n) divides 2^(s_(n+1))$
porque $2^(b_n) in {1,2}$, no porque "$2^(s_(n+1)) slash 2^(s_n)$ exista" (C27). (2) En una unión
$union.big A_n$ hay que elegir el índice *mínimo* (o la disjuntización del Ej. 5) para que
$x |-> (n(x), dots)$ sea inyectiva (C13).

=== Índice cruzado

#table(
  columns: (1.05fr, 0.62fr, 1.1fr, 1.1fr, 0.75fr),
  align: (left + horizon, center + horizon, left + horizon, left + horizon, left + horizon),
  inset: (x: 6pt, y: 5pt),
  stroke: 0.4pt + luma(170),
  table.header([*Parcial*], [*Veredicto*], [*Apunte*], [*Guía*], [*Propio*]),
  [1C 2024 · Ej. 1 ($QQ[x]$, algebraicos)], [$aleph_0$],
  [C1, C2, C3, C6, C7, C8], [C12, C13, C14, C20], [C22, C30],
  [2C 2024 · Ej. 2 (${B subset.eq QQ : \#B = \#(QQ without B)}$)], [$frak(c)$],
  [C1, C2, C3, C5, C6, C8, C9], [C15, C16 (gemelo: C18)], [C22, C23],
  [1C 2025 · Ej. 1 ($a_(n+1) - a_n in {1,2}$)], [$frak(c)$],
  [C1, C2, C3, C5, C9], [C10, C11, C15, C16, C19], [C24, C25, C26],
  [Recu 1C 2025 · Ej. 1 ($a_n divides a_(n+1)$)], [$frak(c)$],
  [C1, C2, C3, C5, C9], [C10, C11, C15, C16], [C24, C27],
  [2C 2025 · Ej. 2 ($a_(n+k) = a_k^n$)], [$aleph_0$],
  [C1, C2, C3, C4, C5, C6, C7, C8], [C11, C13, C14 (plantilla: C21)], [C28],
  [Recu 2C 2025 · Ej. 2 ($f : QQ -> NN$ casi constante)], [$aleph_0$],
  [C1, C2, C3, C5, C6, C7, C8], [C11, C17 (plantilla: C21)], [C29],
)

*Nota sobre las citas de los parciales.* Al cruzar las resoluciones con `guias/p2.typ` y con
`lean/Comun/` aparecen cuatro desajustes, todos de referencia y no de contenido: (i) 2C 2025 y
Recu 2C 2025 citan "Ejemplo 3.12" para $NN times NN tilde.op NN$, que no existe en `apuntes.typ`
(es C11); (ii) 1C 2025 y Recu 1C 2025 citan "Ej. 9 (a)/(b)" y "Ej. 8 (c)", que en `p2.typ` son
el 10 (a)/(b) (C16) y el 9 (c) (C15); (iii) Recu 2C 2025 cita "Ej. 10" para las partes finitas,
que es el 11 (C17); (iv) en 1C 2024 (b) la finitud de $R_p$ necesita $p != 0$ y es un hecho de
álgebra que no está en el apunte ni en la guía (C30). En la resolución oficial de 1C 2024 (a),
"las uniones contables de conjuntos contables son contables" y "$QQ approx NN$" se usan sin
referencia: son C13 (más C12) y C8.

== Supremos e ínfimos (lo que se resuelve con la Guía 1 y un poco de la Guía 3)

Cinco de los seis primeros parciales traen un ejercicio de supremo o ínfimo (el 1C 2024 es el
único que no). Vienen en dos formas: *calcular* el supremo y el ínfimo de un conjunto concreto
(2C 2025, Recu 2C 2025) o *decidir si una igualdad es verdadera o falsa* (2C 2024, 1C 2025,
Recu 1C 2025, Recu 2C 2025 Ej.~3~(b)). Todo lo que hace falta está en las Definiciones 1 a 6, el
Axioma de Completitud, el Teorema 1 y las Proposiciones 1, 3, 4, 5 y 6 del Cap.~1 de `apuntes.typ`,
más los Ejercicios 1, 4, 5 y 6 de la Práctica 1; cuando aparece la clausura o el interior de un
subconjunto de $RR$ (1C 2025 Ej.~2, Recu 2C 2025 Ej.~3~(b)) se agregan las Definiciones 4.11 y
4.22 y lo que la Práctica 3, Ej.~3, calcula para intervalos.

=== Qué pide el parcial

#enunciado[2C 2024 · Ej. 1][
  Consideremos $A$ y $B$ conjuntos en $RR$ no vacíos y acotados. Probar que
  $op("ínf")(A) + op("ínf")(B) = op("ínf")(A + B)$. (Al pie: definimos el conjunto suma como
  $A + B = {a + b : a in A, b in B}$.)
]
#text(size: 9pt)[
  *Veredicto:* es una igualdad a probar (vale siempre; alcanza con que $A$ y $B$ estén acotados
  inferiormente). *Fichas:* S1 · S2 · S5 · S9 · S15.
]

#enunciado[1C 2025 · Ej. 2][
  Sea $A subset.eq RR$ no vacío y acotado. Decida si las siguientes igualdades son verdaderas o
  falsas, demostrándolas en caso de que sean verdaderas o mostrando un contraejemplo en caso de que
  sean falsas:
  #set enum(numbering: "a.")
  + $op("ínf")(A) = op("ínf")(overline(A))$.
  + $op("ínf")(A) = op("ínf")(A^compose)$.
]
#text(size: 9pt)[
  *Veredicto:* (a) *verdadera*; (b) *falsa*, con $A = {0} union [1, 2]$: $op("ínf")(A) = 0$ pero
  $A^compose = (1, 2)$ y $op("ínf")(A^compose) = 1$. *Fichas:* (a) S1 · S2 · S8 · S11 · S16;
  (b) S5 · S7 · S8 · S13.
]

#enunciado[Recu 1C 2025 · Ej. 2][
  Dados $A, B subset.eq RR$ no vacíos, se define el conjunto suma de $A$ y $B$ como
  $A + B = {a + b : a in A, b in B}$. Decida si las siguientes afirmaciones son verdaderas o falsas:
  #set enum(numbering: "a)")
  + Si $A, B subset.eq RR$ son acotados, entonces $op("sup")(A + B) = op("sup")(A) + op("sup")(B)$.
  + Si $(a_n)_(n in NN)$ y $(b_n)_(n in NN)$ son dos sucesiones acotadas de números reales, entonces
    $op("sup")({a_n + b_n}_(n in NN)) = op("sup")({a_n}_(n in NN)) + op("sup")({b_n}_(n in NN))$.
]
#text(size: 9pt)[
  *Veredicto:* (a) *verdadera*; (b) *falsa*, con $a = (1, 0, 0, dots)$ y $b = (-1, 0, 0, dots)$:
  $op("sup"){a_n + b_n} = 0 != 1 = 1 + 0$. *Fichas:* (a) S1 · S2 · S4 · S9 · S14; (b) S6 · S11
  (para la desigualdad $<=$ que sí vale).
]

#enunciado[2C 2025 · Ej. 1][
  Calcular, si existen, el supremo y el ínfimo de
  $ A = {m / (m + n) : m in NN, n in NN}. $
]
#text(size: 9pt)[
  *Veredicto:* $op("sup")(A) = 1$ e $op("ínf")(A) = 0$; ninguno se alcanza (no hay máximo ni
  mínimo) porque $0 < m\/(m+n) < 1$. *Fichas:* S1 · S2 · S3 · S4 · S5 (S10 como modelo).
]

#enunciado[Recu 2C 2025 · Ej. 1][
  Calcular, si existen, el supremo, ínfimo, máximo y mínimo de
  $ A = {1 / (n^2 - 8n + 18) : n in NN}. $
]
#text(size: 9pt)[
  *Veredicto:* $op("máx")(A) = op("sup")(A) = 1\/2$ (en $n = 4$), $op("ínf")(A) = 0$ y no hay
  mínimo. *Fichas:* S1 · S3 · S5 · S6 · S10.
]

#enunciado[Recu 2C 2025 · Ej. 3 (b)][
  #set enum(numbering: "a)")
  + Sea $(E, d)$ un espacio métrico y sean $A, B subset.eq E$ con $A$ abierto. Probar que si
    $A inter overline(B) != emptyset$, entonces $A inter B != emptyset$.
  + Supongamos que $(E, d) = (RR, abs(dot.c))$, $A, B subset.eq RR$ pero $A$ no necesariamente es
    abierto. ¿Sigue valiendo la afirmación del ítem a)?
]
#text(size: 9pt)[
  *Veredicto:* el ítem (a) es topología general (otro tipo de ejercicio); el (b) es *no*: con
  $A = {0}$ y $B = (0, 1)$ se tiene $overline(B) = [0, 1]$, así que $0 in A inter overline(B)$
  pero $A inter B = emptyset$. *Fichas:* S8 · S13.
]

=== El guion

*(a) Supremo o ínfimo de un conjunto concreto* (2C 2025 Ej.~1, Recu 2C 2025 Ej.~1; es el molde de
la Práctica 1, Ej.~4).

+ *No vacío.* Exhibir un elemento ($1\/2$ con $m = n = 1$; $a_4 = 1\/2$).
+ *Cota.* Una desigualdad válida para todo elemento ($0 < m\/(m+n) < 1$; $D_n = (n-4)^2 + 2 >= 2$,
  luego $0 < 1\/D_n <= 1\/2$). Con S1 y S2 ya existen $op("sup")$ e $op("ínf")$.
+ *¿La cota pertenece al conjunto?* Si sí, es máximo o mínimo por S6 / S7 y se terminó ese lado
  ($1\/2 = a_4 in A$). Si no, hay que *aproximarse con $epsilon$*: dado $epsilon > 0$, Arquímedes
  (S3) da un $n$ y una cuenta exhibe un elemento a menos de $epsilon$ de la cota; S4 / S5 cierran.
  Las cuentas típicas: $m\/(m+1) = 1 - 1\/(m+1) > 1 - epsilon$; $1\/(1+n) < 1\/n < epsilon$;
  $1\/D_n < epsilon$ porque $D_n > n - 4 > 1\/epsilon$.
+ *Máximo y mínimo.* Si el extremo se alcanzó, está en el paso anterior. Si no, "no hay": el
  máximo (mínimo) sería el supremo (ínfimo) por la Definición 3 (6), y éste no pertenece al
  conjunto ($1 in.not A$, $0 in.not A$ porque todos los elementos cumplen $0 < x < 1$).

*(b) Afirmación "verdadera o falsa"* (2C 2024, 1C 2025, Recu 1C 2025, Recu 2C 2025 Ej.~3~(b)).

- *Si es verdadera*, la igualdad $op("sup") X = c$ (o $op("ínf") X = c$) se prueba como dos
  desigualdades. Una sale de que $c$ es cota ($c$ es cota superior de $X$ y $op("sup") X$ es la
  *menor*, Definición 2); la otra, o bien de que $op("sup") X$ es cota de algo que tiene a $c$ como
  supremo (monotonía, S11), o bien de "$c < op("sup") X + epsilon$ para todo $epsilon > 0$" vía
  S4 / S5 con $epsilon\/2$ en cada conjunto, cerrada con la Práctica 1, Ej.~1 (S9). En Lean es
  `le_antisymm` con `le_csSup`/`csSup_le` y `le_of_forall_pos_lt_add`.
- *Si es falsa*, el contraejemplo es siempre un conjunto *de dos piezas* en el que la operación
  (interior, suma coordenada a coordenada, intersección) pierde una de las dos: ${0} union [1, 2]$,
  ${0}$ y $(0, 1)$, $(1, 0, 0, dots)$ y $(-1, 0, 0, dots)$. Después, la cuenta de cada supremo o
  ínfimo con S6 / S7 (el extremo pertenece) o con S13 (interior y clausura de intervalos). Ver el
  banco al final.

*Cómo decidir si es V o F.* Probar primero la desigualdad "fácil" (la que sale de cotas o de una
inclusión). Si la otra necesita que un punto aislado sobreviva a la operación, es falsa: el interior
borra los puntos aislados (${0} union [1, 2]$), la suma de sucesiones sólo junta pares con el mismo
índice, la intersección con un conjunto no abierto no ve la clausura.

=== Fichas

#text(weight: "bold", fill: rgb("#2563eb"))[Nivel apunte] --- se citan por nombre y número.

#ficha(
  id: "S1", titulo: "Cotas, supremo, ínfimo, máximo y mínimo", nivel: "apunte",
  fuente: [Definiciones 1 a 6 de `apuntes.typ`],
  usado: [todos los ejercicios de este tipo],
  lean: [`Comun.CotaSup`, `Comun.CotaInf`, `Comun.EsSup`, `Comun.EsInf`, `Comun.EsMax`, `Comun.EsMin`],
)[
  *Enunciado.* Sea $A subset.eq RR$ no vacío. $c$ es *cota superior* de $A$ si $a <= c$ para todo
  $a in A$; $A$ es *acotado superiormente* si tiene alguna (Def.~1). $s = op("sup")(A)$ si $s$ es
  cota superior y $s <= t$ para toda cota superior $t$: la *menor de las cotas superiores*
  (Def.~2). Si además $op("sup")(A) in A$, se llama *máximo*, $op("máx")(A)$ (Def.~3). Con las
  desigualdades al revés: *cota inferior*, *acotado inferiormente* (Def.~4), $op("ínf")(A)$ es la
  *mayor de las cotas inferiores* (Def.~5) y es *mínimo*, $op("mín")(A)$, si pertenece a $A$
  (Def.~6). El supremo, si existe, es único (dos menores cotas superiores son iguales).

  *Cómo se usa.* Es el primer paso de cualquier cuenta: una desigualdad válida para todo elemento
  *es* una cota. La cláusula "menor de las cotas superiores" es la que da $op("sup") X <= c$ en
  cuanto $c$ es cota superior de $X$ (2C 2024 Ej.~1, Recu 1C 2025 Ej.~2~(a), 1C 2025 Ej.~2~(a)).
  Y "no hay máximo" se prueba por la Def.~3: el máximo sería el supremo, que no está en el conjunto
  (2C 2025 Ej.~1, Recu 2C 2025 Ej.~1).
]

#ficha(
  id: "S2", titulo: "Existencia: Axioma de Completitud y Teorema 2", nivel: "apunte",
  fuente: [Axioma de Completitud y Teorema 2 (Completitud en términos de ínfimos) de `apuntes.typ`],
  usado: [2C 2025 Ej. 1 · 1C 2025 Ej. 2 (a) · Recu 1C 2025 Ej. 2 (a) · 2C 2024 Ej. 1],
  lean: [`Comun.axioma_completitud`, `Comun.completitud_inf`],
)[
  *Enunciado.* Todo subconjunto no vacío y acotado superiormente de $RR$ tiene supremo en $RR$
  (Axioma). Todo subconjunto no vacío y acotado inferiormente de $RR$ tiene ínfimo en $RR$
  (Teorema 2; se prueba aplicando el axioma a $-A$).

  *Cómo se usa.* Es la línea que autoriza a escribir "$alpha = op("sup")(A)$" después de haber
  probado "no vacío" y "acotado": sin ella, el símbolo no tiene sentido. En los "V o F" hay que
  verificar las hipótesis también para el conjunto nuevo ($A + B$, $overline(A)$, $A^compose$):
  por ejemplo $overline(A) != emptyset$ porque $A subset.eq overline(A)$, y $A^compose$ puede ser
  vacío (en Mathlib $op("ínf") emptyset = 0$ por convención, por eso `ej2b` pide
  $A^compose != emptyset$).
]

#ficha(
  id: "S3", titulo: "Principio de Arquímedes", nivel: "apunte",
  fuente: [Teorema 1 y Proposición 1 (Principio de Arquímedes 2) de `apuntes.typ`],
  usado: [2C 2025 Ej. 1 · Recu 2C 2025 Ej. 1],
  lean: [`Comun.arquimedes`, `Comun.arquimedes2`],
)[
  *Enunciado.* Si $x in RR$, existe $n in NN$ con $x <= n$ (Teorema 1). Si $y > 0$, existe
  $n in NN$ con $0 < 1\/n < y$ (Proposición 1).

  *Cómo se usa.* Es lo que produce el índice en el paso de aproximación por $epsilon$. Se elige
  la forma según la cuenta: para $1\/(1+n) < epsilon$ o $1\/m < epsilon$ se usa la Proposición 1
  (2C 2025 Ej.~1); cuando el denominador no es $n$ sino una expresión en $n$ se usa el Teorema 1
  con $x = 4 + 1\/epsilon$, de modo que $n - 4 > 1\/epsilon$ y $D_n = (n-4)^2 + 2 > n - 4 > 1\/epsilon$
  (Recu 2C 2025 Ej.~1). En Lean el $n$ sale de `exists_nat_gt`.
]

#ficha(
  id: "S4", titulo: "Equivalencia de supremo (ε)", nivel: "apunte",
  fuente: [Proposición 3 de `apuntes.typ`],
  usado: [2C 2025 Ej. 1 · Recu 1C 2025 Ej. 2 (a)],
  lean: [`Comun.equiv_sup`; en Mathlib `csSup_eq_of_forall_le_of_forall_lt_exists_gt`, `exists_lt_of_lt_csSup`],
)[
  *Enunciado.* Sea $A subset.eq RR$ no vacío y acotado superiormente. Entonces $s = op("sup")(A)$
  si y sólo si (a) $s$ es cota superior de $A$ y (b) para todo $epsilon > 0$ existe
  $a_epsilon in A$ con $s - epsilon < a_epsilon <= s$.

  *Cómo se usa.* En las dos direcciones. *Para probar* $op("sup")(A) = 1$: $1$ es cota y, dado
  $epsilon$, el elemento $m\/(m+1) = 1 - 1\/(m+1) > 1 - epsilon$ es el $a_epsilon$ (2C 2025 Ej.~1).
  *Para extraer* elementos de un supremo que ya existe: con $epsilon\/2$ en $A$ y en $B$ salen
  $a_epsilon$, $b_epsilon$ con $a_epsilon + b_epsilon > op("sup") A + op("sup") B - epsilon$, que es
  el corazón de $op("sup")(A + B)$ (Recu 1C 2025 Ej.~2~(a), ficha S14).
]

#ficha(
  id: "S5", titulo: "Equivalencia de ínfimo (ε)", nivel: "apunte",
  fuente: [Proposición 5 de `apuntes.typ` (es la Práctica 1, Ej. 3)],
  usado: [2C 2025 Ej. 1 · Recu 2C 2025 Ej. 1 · 1C 2025 Ej. 2 (b) · 2C 2024 Ej. 1],
  lean: [`Comun.equiv_inf`; en Mathlib `csInf_eq_of_forall_ge_of_forall_gt_exists_lt`, `exists_lt_of_csInf_lt`],
)[
  *Enunciado.* Sea $A subset.eq RR$ no vacío y acotado inferiormente. Entonces $i = op("ínf")(A)$
  si y sólo si (a) $i$ es cota inferior de $A$ y (b) para todo $epsilon > 0$ existe
  $a_epsilon in A$ con $a_epsilon < i + epsilon$.

  *Cómo se usa.* Espejo de S4. *Para probar* $op("ínf")(A) = 0$: $0$ es cota inferior y
  Arquímedes da $1\/(1+n) < epsilon$ (2C 2025) o $1\/D_n < epsilon$ (Recu 2C 2025); para
  $op("ínf")((1, 2)) = 1$ el $a_epsilon$ es $1 + op("mín"){epsilon, 1}\/2$ (1C 2025 Ej.~2~(b)).
  *Para extraer* $a$, $b$ con $a < op("ínf") A + epsilon\/2$, $b < op("ínf") B + epsilon\/2$ en
  $op("ínf")(A + B)$ (2C 2024 Ej.~1, ficha S15). Es la proposición más citada del tipo.
]

#ficha(
  id: "S6", titulo: "Caracterización de supremo y máximo", nivel: "apunte",
  fuente: [Proposición 4 de `apuntes.typ`],
  usado: [Recu 2C 2025 Ej. 1 · Recu 1C 2025 Ej. 2 (b)],
  lean: [`Comun.caract_sup_max`; en Mathlib `IsGreatest.csSup_eq`, `csSup_pair`, `csSup_singleton`],
)[
  *Enunciado.* Sea $A subset.eq RR$ no vacío y acotado superiormente. Si $t$ es cota superior de
  $A$ y $t in A$, entonces $t = op("sup")(A) = op("máx")(A)$.

  *Cómo se usa.* Ahorra el paso con $epsilon$ cuando la cota pertenece al conjunto: $1\/2 = a_4$
  es cota superior y está en $A$, así que $op("sup") = op("máx") = 1\/2$ (Recu 2C 2025 Ej.~1).
  En los contraejemplos es lo que calcula los supremos de conjuntos finitos:
  $op("sup"){1, 0} = 1$, $op("sup"){-1, 0} = 0$, $op("sup"){0} = 0$ (Recu 1C 2025 Ej.~2~(b)).
]

#ficha(
  id: "S7", titulo: "Caracterización de ínfimo y mínimo", nivel: "apunte",
  fuente: [Proposición 6 de `apuntes.typ`],
  usado: [1C 2025 Ej. 2 (b)],
  lean: [`Comun.caract_inf_min`; en Mathlib `csInf_insert`, `csInf_Icc`],
)[
  *Enunciado.* Sea $A subset.eq RR$ no vacío y acotado inferiormente. Si $t$ es cota inferior de
  $A$ y $t in A$, entonces $t = op("ínf")(A) = op("mín")(A)$.

  *Cómo se usa.* Da $op("ínf")({0} union [1, 2]) = 0$ en una línea ($0$ es cota inferior y
  pertenece), que es la mitad del contraejemplo de 1C 2025 Ej.~2~(b). Al revés, "no hay mínimo"
  es la Def.~6: el mínimo sería el ínfimo $0$, y $0 in.not A$ (Recu 2C 2025 Ej.~1, 2C 2025 Ej.~1).
]

#ficha(
  id: "S8", titulo: [Interior y clausura en $RR$: definiciones e inclusiones], nivel: "apunte",
  fuente: [Definiciones 4.11 y 4.22, Observaciones 4.12 y 4.23, Proposiciones 4.21 y 4.46 (a) de `apuntes.typ`],
  usado: [1C 2025 Ej. 2 · Recu 2C 2025 Ej. 3 (b)],
  lean: [`Comun.mem_interior_iff_ball`, `Comun.mem_closure_iff_ball`, `Comun.subset_closure_ball`, `Comun.mem_ball_iff`],
)[
  *Enunciado.* En un espacio métrico $(M, d)$ y para $E subset.eq M$: $x in E$ es *interior* si
  existe $r > 0$ con $B(x, r) subset.eq E$, y $E^compose$ es el conjunto de los puntos interiores
  (Def.~4.11); $x in M$ es *de adherencia* si $B(x, r) inter E != emptyset$ para todo $r > 0$, y
  $overline(E)$ es el conjunto de los puntos de adherencia (Def.~4.22). Siempre
  $ E^compose subset.eq E subset.eq overline(E) $
  (Obs.~4.12 y 4.23). Si $U subset.eq E$ es abierto, $U subset.eq E^compose$ (Prop.~4.21). Y
  $x in overline(E)$ si y sólo si existe $(x_n)_n subset.eq E$ con $x_n -> x$ (Prop.~4.46~(a)). En
  $(RR, abs(dot.c))$, $B(x, r) = (x - r, x + r)$.

  *Cómo se usa.* Las inclusiones son la mitad gratis de cada igualdad: $A subset.eq overline(A)$
  da $op("ínf") overline(A) <= op("ínf") A$ por monotonía (S11) y $overline(A) != emptyset$;
  $A^compose subset.eq A$ dice qué puntos hay que revisar para calcular el interior (los de $A$
  que no están en un intervalo abierto contenido en $A$). La Prop.~4.21 da
  $(1, 2) subset.eq ({0} union [1, 2])^compose$ porque $(1, 2) = B(3\/2, 1\/2)$ es abierto. La
  Prop.~4.46~(a) es la que pasa cotas inferiores de $A$ a $overline(A)$ (ficha S16). En
  Recu 2C 2025 Ej.~3~(b), $0 in overline((0, 1))$ porque toda bola $(-r, r)$ corta a $(0, 1)$.
]

#text(weight: "bold", fill: rgb("#15803d"))[Nivel guía] --- se citan como "Práctica $k$, Ej.~$m$"
si se sabe demostrar; la ficha trae la idea.

#ficha(
  id: "S9", titulo: [$x < y + epsilon$ para todo $epsilon > 0$ implica $x <= y$], nivel: "guia",
  fuente: [Práctica 1, Ej. 1 (`guias/p1.typ`; resuelto en `guias-agente/guia_1_resuelta_agente.typ`)],
  usado: [Recu 1C 2025 Ej. 2 (a) · 2C 2024 Ej. 1 ("como $epsilon$ era cualquiera")],
  lean: [`Guias.Guia1.Ej01.ej1a`, `ej1b`; en Mathlib `le_of_forall_pos_lt_add`],
)[
  *Enunciado.* Si $x < y + epsilon$ para todo $epsilon > 0$, entonces $x <= y$. Si
  $abs(x - y) < epsilon$ para todo $epsilon > 0$, entonces $x = y$.

  *Idea de la prueba.* Contrarrecíproco: si $x > y$, el único $epsilon$ que hace falta es
  $epsilon_0 = x - y > 0$, porque la hipótesis daría $x < y + (x - y) = x$. La segunda parte es la
  primera aplicada a $(x, y)$ y a $(y, x)$, usando $abs(x - y) < epsilon <=> -epsilon < x - y < epsilon$.

  *Cómo se usa.* Es la última línea de toda prueba por $epsilon$ de una desigualdad entre
  supremos: de "$alpha + beta < sigma + epsilon$ para todo $epsilon > 0$" se concluye
  $alpha + beta <= sigma$ (S14), y de "$op("ínf")(A + B) < op("ínf") A + op("ínf") B + epsilon$
  para todo $epsilon$" se concluye $<=$ (S15). Sin esta cita, el "como $epsilon$ era arbitrario"
  queda sin justificar.
]

#ficha(
  id: "S10", titulo: [$op("ínf"){1\/2^n : n in NN} = 0$: el molde de "ínfimo por Arquímedes"], nivel: "guia",
  fuente: [Práctica 1, Ej. 4 (b) y (c) (`guias-agente/guia_1_resuelta_agente.typ`)],
  usado: [modelo de 2C 2025 Ej. 1 (ínfimo) y Recu 2C 2025 Ej. 1 (ínfimo y "no hay mínimo")],
  lean: [`Guias.Guia1.Ej04.ej4b_inf`, `ej4b_max`, `ej4b_no_min`, `ej4c_min`; usa `Comun.arquimedes2` y `Comun.natCast_le_two_pow`],
)[
  *Enunciado.* Para $B = {1\/2^n : n in NN}$: $op("sup") B = op("máx") B = 1\/2$,
  $op("ínf") B = 0$ y no hay mínimo. Para $B union {0}$: además $op("ínf") = op("mín") = 0$.

  *Idea de la prueba.* $1\/2 in B$ y es cota superior ($2^n >= 2$), Proposición 4. $0$ es cota
  inferior ($1\/2^n > 0$); si $t > 0$ fuera cota inferior, Arquímedes (Prop.~1) da $n$ con
  $1\/n < t$, y $n <= 2^n$ (inducción) da $1\/2^n <= 1\/n < t$ con $1\/2^n in B$: absurdo. No hay
  mínimo porque el mínimo sería $0 in.not B$ (o directamente: $1\/2^(n+1) < 1\/2^n$).

  *Cómo se usa.* Es el esquema "$op("ínf"){1\/f(n)} = 0$ cuando $f(n) -> oo$", con una sola
  diferencia en los parciales: en lugar de refutar una cota $t > 0$ se escribe directamente la
  cláusula (b) de la Proposición 5 con $epsilon$. En 2C 2025 Ej.~1, $f(n) = 1 + n$ (fijando
  $m = 1$) y $1\/(1+n) < 1\/n < epsilon$; en Recu 2C 2025 Ej.~1, $f(n) = (n-4)^2 + 2 > n - 4$ y
  Arquímedes se aplica a $4 + 1\/epsilon$. El ítem (c) muestra que agregar el ínfimo al conjunto no
  cambia $op("sup")$ ni $op("ínf")$ pero convierte al ínfimo en mínimo.
]

#ficha(
  id: "S11", titulo: [Monotonía de sup e ínf: $A subset.eq B$], nivel: "guia",
  fuente: [Práctica 1, Ej. 5 (`guias-agente/guia_1_resuelta_agente.typ`)],
  usado: [1C 2025 Ej. 2 (a) ($A subset.eq overline(A)$) · Recu 1C 2025 Ej. 2 (b) (la desigualdad $<=$ que sí vale)],
  lean: [`Comun.acotadoSup_mono`, `Comun.esSup_mono`, `Comun.acotadoInf_mono`, `Comun.esInf_mono`; en Mathlib `csInf_le_csInf`],
)[
  *Enunciado.* Sean $emptyset != A subset.eq B subset.eq RR$. (a) Si $B$ está acotado
  superiormente, $A$ también y $op("sup") A <= op("sup") B$. (b) Si $B$ está acotado
  inferiormente, $A$ también e $op("ínf") B <= op("ínf") A$. (c) Si $A$ no está acotado, $B$
  tampoco.

  *Idea de la prueba.* Toda cota de $B$ es cota de $A$ (los elementos de $A$ están en $B$). En
  particular $op("sup") B$ es cota superior de $A$, y $op("sup") A$ es la *menor* de las cotas
  superiores de $A$ (Def.~2): $op("sup") A <= op("sup") B$. Para ínfimos, igual con la Def.~5.
  (c) es el contrarrecíproco de la primera mitad de (a) y (b).

  *Cómo se usa.* Da la desigualdad "gratis" en 1C 2025 Ej.~2~(a): como $A subset.eq overline(A)$,
  $op("ínf") overline(A) <= op("ínf") A$ (una cota inferior de $overline(A)$ lo es de $A$). Y
  explica por qué en Recu 1C 2025 Ej.~2~(b) vale siempre
  $op("sup"){a_n + b_n} <= op("sup"){a_n} + op("sup"){b_n}$: ${a_n + b_n}_n subset.eq {a_n}_n + {b_n}_n$
  y se aplica S14. Lo que falla es la igualdad.
]

#ficha(
  id: "S12", titulo: [$op("ínf")(-A) = -op("sup") A$ y $op("sup")(c A) = c op("sup") A$], nivel: "guia",
  fuente: [Práctica 1, Ej. 6 (`guias-agente/guia_1_resuelta_agente.typ`); la demostración del Teorema 2 es el ítem (a)],
  usado: [ningún parcial lo cita; es el puente sup $<->$ ínf (2C 2024 Ej. 1 es el espejo de Recu 1C 2025 Ej. 2 (a))],
  lean: [`Comun.esInf_neg`, `Comun.acotadoInf_neg_of_acotadoSup`, `Comun.esSup_smul`, `Comun.acotadoSup_smul`],
)[
  *Enunciado.* Sea $A subset.eq RR$ acotado superiormente. (a) $-A = {-a : a in A}$ está acotado
  inferiormente e $op("ínf")(-A) = -op("sup") A$. (b) Si $c > 0$, $c A = {c a : a in A}$ está
  acotado superiormente y $op("sup")(c A) = c op("sup") A$.

  *Idea de la prueba.* Multiplicar por $-1$ invierte las desigualdades: cada cota superior $s$ de
  $A$ es una cota inferior $-s$ de $-A$ y cada cota inferior $t$ de $-A$ es una cota superior
  $-t$ de $A$. Con $s = op("sup") A$ la menor cota superior (Def.~2), $-s$ es la mayor cota
  inferior de $-A$ (Def.~5). Para (b), multiplicar por $c > 0$ conserva las desigualdades y se
  vuelve dividiendo por $c$.

  *Cómo se usa.* Permite escribir sólo una de las dos versiones de un resultado y deducir la otra.
  Por ejemplo (deducción propia, no está en los parciales), de S14 sale S15:
  $-(A + B) = (-A) + (-B)$, así que
  $ op("ínf")(A + B) = -op("sup")((-A) + (-B)) = -(op("sup")(-A) + op("sup")(-B)) \
    = op("ínf") A + op("ínf") B. $
  En el examen conviene igual escribir la prueba directa (S15): es igual de corta.
]

#ficha(
  id: "S13", titulo: [Interior y clausura de intervalos y de un intervalo con un punto aislado], nivel: "guia",
  fuente: [Práctica 3, Ej. 3 (a), (b), (f), Lemas 1 y 3 de `guias-agente/guia_3_resuelta_agente.typ`; el cálculo de $({0} union [1, 2])^compose$ está en la resolución de 1C 2025 Ej. 2 (b)],
  usado: [1C 2025 Ej. 2 (b) · Recu 2C 2025 Ej. 3 (b)],
  lean: [`Comun.Ioo_sub_interiorCurso`, `Comun.interiorCurso_sub_Ioo`, `Comun.clausuraCurso_sub_Icc`, `Comun.exists_pto`, `Guias.Guia3.Ej03.b_clausura`, `f_interior`; en los parciales `Parcial1_1C2025.interior_B`, Mathlib `closure_Ioo`, `interior_Icc`],
)[
  *Enunciado.* En $(RR, abs(dot.c))$, con $a < b$:
  $(a, b)^compose = (a, b)$, $[a, b]^compose = (a, b)$, $overline((a, b)) = overline([a, b]) = [a, b]$.
  Si a un intervalo se le agrega un punto aislado, el interior no lo ve:
  $([0, 1) union {2})^compose = (0, 1)$ y, con la misma cuenta, $({0} union [1, 2])^compose = (1, 2)$.

  *Idea de la prueba.* *Lema 1:* si $(a, b) subset.eq S$, cada $x in (a, b)$ es interior con
  $r = op("mín"){x - a, b - x}$; si $S subset.eq [a, b]$, un punto interior $x$ tiene
  $x plus.minus r\/2 in [a, b]$, luego $x in (a, b)$, y un punto $x in.not [a, b]$ tiene una bola
  que no toca a $[a, b]$, luego $x in.not overline(S)$. *Lema 3:* todo $x in [a, b]$ tiene puntos
  de $(a, b)$ arbitrariamente cerca (correrse $t = op("mín"){r, b - a}\/4$ hacia el centro), así
  que $[a, b] subset.eq overline((a, b))$. *Punto aislado:* $0 in.not ({0} union [1, 2])^compose$
  porque $-r\/2 in B(0, r)$ y $-r\/2 in.not A$; los extremos $1$ y $2$ tampoco son interiores
  ($1 - op("mín"){r, 1}\/2 in (0, 1)$, $2 + r\/2 > 2$).

  *Cómo se usa.* Es la cuenta de los dos contraejemplos con topología: en 1C 2025 Ej.~2~(b),
  $A^compose = (1, 2)$ y luego $op("ínf")(1, 2) = 1$ por S5; en Recu 2C 2025 Ej.~3~(b),
  $overline((0, 1)) = [0, 1] in.rev 0$. En el examen alcanza con la frase "porque $(1, 2) = B(3\/2, 1\/2)$
  es abierto y $(1, 2) subset.eq A$ (Prop.~4.21), y $0$, $1$, $2$ no son interiores porque $dots$"
  con los tres puntos explícitos.
]

#text(weight: "bold", fill: rgb("#ea580c"))[Nivel propio] --- no está en el apunte ni en una guía:
en el examen hay que escribir la demostración.

#ficha(
  id: "S14", titulo: [$op("sup")(A + B) = op("sup") A + op("sup") B$], nivel: "propio",
  fuente: [resolución de Recu 1C 2025 Ej. 2 (a) (`parciales/2025_1c_recuperatorio_1.typ`)],
  usado: [Recu 1C 2025 Ej. 2 (a)],
  lean: [`Comun.sSup_sumSet`, `Comun.esSup_sumSet`],
)[
  *Enunciado.* Sean $A, B subset.eq RR$ no vacíos y acotados superiormente, y
  $A + B = {a + b : a in A, b in B}$. Entonces $A + B$ es no vacío, acotado superiormente, y
  $ op("sup")(A + B) = op("sup")(A) + op("sup")(B). $

  *Demostración.* Como $A$ y $B$ son no vacíos y acotados superiormente, existen
  $alpha = op("sup")(A)$ y $beta = op("sup")(B)$ (Axioma de Completitud). Fijemos $a_0 in A$ y
  $b_0 in B$; entonces $a_0 + b_0 in A + B$, así que $A + B != emptyset$.

  _$alpha + beta$ es cota superior de $A + B$._ Si $x in A + B$, existen $a in A$, $b in B$ con
  $x = a + b$; como $a <= alpha$ y $b <= beta$, resulta $x <= alpha + beta$. En particular $A + B$
  está acotado superiormente, existe $sigma = op("sup")(A + B)$ y, por ser la menor de las cotas
  superiores (Definición 2), $sigma <= alpha + beta$.

  _$alpha + beta <= sigma$._ Sea $epsilon > 0$. Por la Proposición 3 (equivalencia de supremo)
  aplicada a $A$ y a $B$ con $epsilon\/2$, existen $a_epsilon in A$ y $b_epsilon in B$ tales que
  $alpha - epsilon\/2 < a_epsilon$ y $beta - epsilon\/2 < b_epsilon$. Sumando,
  $ alpha + beta - epsilon < a_epsilon + b_epsilon <= sigma, $
  donde la última desigualdad vale porque $a_epsilon + b_epsilon in A + B$ y $sigma$ es cota
  superior de $A + B$. Así $alpha + beta < sigma + epsilon$ para todo $epsilon > 0$, y por la
  Práctica 1, Ej.~1, $alpha + beta <= sigma$.

  Por lo tanto $op("sup")(A + B) = op("sup")(A) + op("sup")(B)$. $qed$

  *Cómo se usa.* Tal cual en Recu 1C 2025 Ej.~2~(a). Para el ítem (b) del mismo ejercicio da la
  desigualdad que sí vale: ${a_n + b_n}_n subset.eq {a_n}_n + {b_n}_n$ y S11. En Lean:
  `le_antisymm (csSup_le …) (le_of_forall_pos_lt_add …)` con `exists_lt_of_lt_csSup`.
]

#ficha(
  id: "S15", titulo: [$op("ínf")(A + B) = op("ínf") A + op("ínf") B$], nivel: "propio",
  fuente: [resolución de la cátedra de 2C 2024 Ej. 1 (`parciales/2024_2c_parcial_1.typ`)],
  usado: [2C 2024 Ej. 1],
  lean: [`Comun.sInf_sumSet`, `Comun.esInf_sumSet`],
)[
  *Enunciado.* Sean $A, B subset.eq RR$ no vacíos y acotados inferiormente. Entonces $A + B$ es
  no vacío, acotado inferiormente, y
  $ op("ínf")(A + B) = op("ínf")(A) + op("ínf")(B). $

  *Demostración.* Por el Teorema 2 existen $i = op("ínf")(A)$ y $j = op("ínf")(B)$. Tomando
  $a_0 in A$, $b_0 in B$, $a_0 + b_0 in A + B != emptyset$.

  _$i + j$ es cota inferior de $A + B$._ Un elemento de $A + B$ se escribe $a + b$ con $a in A$,
  $b in B$; como $i <= a$ y $j <= b$, $i + j <= a + b$. Luego $A + B$ está acotado inferiormente,
  existe $k = op("ínf")(A + B)$ (Teorema 2) y, por ser la mayor de las cotas inferiores
  (Definición 5), $i + j <= k$.

  _$k <= i + j$._ Fijemos $epsilon > 0$. Por la Proposición 5 (equivalencia de ínfimo) aplicada a
  $A$ y a $B$ con $epsilon\/2$, existen $a in A$ y $b in B$ tales que $a < i + epsilon\/2$ y
  $b < j + epsilon\/2$. Como $a + b in A + B$ y $k$ es cota inferior de $A + B$,
  $ k <= a + b < i + j + epsilon. $
  Como $epsilon > 0$ era cualquiera, por la Práctica 1, Ej.~1, $k <= i + j$.

  Por lo tanto $op("ínf")(A) + op("ínf")(B) = op("ínf")(A + B)$. $qed$

  *Cómo se usa.* Tal cual en 2C 2024 Ej.~1 (la cátedra escribe las mismas dos desigualdades; la
  cita de la Práctica 1, Ej.~1, es el "como $epsilon$ era cualquiera" final). Sólo se usa que $A$ y
  $B$ estén acotados *inferiormente*, aunque el enunciado diga "acotados".
]

#ficha(
  id: "S16", titulo: [$op("ínf") A = op("ínf") overline(A)$], nivel: "propio",
  fuente: [resolución de 1C 2025 Ej. 2 (a) (`parciales/2025_1c_parcial_1.typ`)],
  usado: [1C 2025 Ej. 2 (a)],
  lean: [`Parcial1_1C2025.ej2a` (`lean/Parciales/`; usa `closure_minimal`, `isClosed_Ici`, `csInf_le_csInf`, `subset_closure`)],
)[
  *Enunciado.* Sea $A subset.eq RR$ no vacío y acotado inferiormente. Entonces $overline(A)$ es
  no vacío y acotado inferiormente, y $op("ínf")(A) = op("ínf")(overline(A))$.

  *Demostración.* Sea $i = op("ínf")(A)$, que existe por el Teorema 2.

  _$overline(A)$ es no vacío y acotado inferiormente._ No vacío porque $A subset.eq overline(A)$
  (Observación 4.23). Veamos que $i$ es cota inferior de $overline(A)$: sea $x in overline(A)$.
  Por la Proposición 4.46~(a), existe $(a_n)_n subset.eq A$ con $a_n -> x$. Como $i <= a_n$ para
  todo $n$, por la Práctica 1, Ej.~10 (los límites respetan $<=$) resulta $i <= x$.

  Entonces existe $j = op("ínf")(overline(A))$ (Teorema 2) y, como $i$ es una cota inferior de
  $overline(A)$ y $j$ es la *mayor* de ellas (Definición 5), $i <= j$.

  _$j <= i$._ Como $A subset.eq overline(A)$, toda cota inferior de $overline(A)$ lo es de $A$; en
  particular $j$ es cota inferior de $A$, y por ser $i$ la mayor de las cotas inferiores de $A$,
  $j <= i$ (es la Práctica 1, Ej.~5~(b), con $A subset.eq overline(A)$).

  Por lo tanto $op("ínf")(A) = op("ínf")(overline(A))$. $qed$

  *Variante sin sucesiones* (deducción propia; es lo que hace el Lean con $[i, oo)$ cerrado). Si
  $x in overline(A)$ y $x < i$, sea $r = i - x > 0$: la bola $B(x, r) = (2x - i, i)$ no contiene
  ningún $a in A$ porque todo $a >= i$, contra la Definición 4.22. Luego $i <= x$.

  *Cómo se usa.* Tal cual en 1C 2025 Ej.~2~(a). Contrastar con el ítem (b): con $A^compose$ la
  inclusión $A^compose subset.eq A$ da $op("ínf") A <= op("ínf") A^compose$ (S11), pero la otra
  desigualdad es falsa porque el interior pierde los puntos aislados. El mismo argumento con
  $-A$ y S12 da $op("sup") A = op("sup") overline(A)$.
]

=== Banco de trucos y contraejemplos

*Trucos de cuenta* (sup/ínf concreto).

- *Fijar una variable.* En ${m\/(m+n)}$, con $n = 1$ y $m -> oo$ se sube a $1$; con $m = 1$ y
  $n -> oo$ se baja a $0$. Escribir $m\/(m+1) = 1 - 1\/(m+1)$ convierte "cerca de $1$" en
  "$1\/(m+1) < epsilon$", que es Arquímedes (2C 2025 Ej.~1).
- *Completar cuadrados.* $n^2 - 8n + 18 = (n-4)^2 + 2 >= 2$, con igualdad sólo en $n = 4$: el
  máximo está a la vista y la cota $D_n > n - 4$ (porque $t^2 - t + 2 = (t - 1\/2)^2 + 7\/4 > 0$)
  hace que $1\/D_n < epsilon$ apenas $n > 4 + 1\/epsilon$ (Recu 2C 2025 Ej.~1).
- *Doble cota estricta $=>$ ni máximo ni mínimo.* Si todo elemento cumple $0 < x < 1$, entonces
  $0, 1 in.not A$, y por las Definiciones 3 y 6 no hay máximo ni mínimo (2C 2025 Ej.~1).

*Contraejemplos* (afirmaciones falsas). Cada uno es un conjunto de dos piezas; la cuenta es una
línea con S6 / S7 o S13.

#block[
  #set text(size: 9pt)
  #table(
    columns: (1.4fr, 1.6fr, 2.6fr),
    align: (left + top, left + top, left + top),
    fill: (x, y) => if y == 0 { rgb("#0c4a6e") } else if calc.even(y) { rgb("#f8fafc") } else { white },
    stroke: 0.4pt + rgb("#cbd5e1"),
    inset: (x: 6pt, y: 5pt),
    table.header(
      [#text(fill: white, weight: "bold")[Conjunto(s)]],
      [#text(fill: white, weight: "bold")[Refuta]],
      [#text(fill: white, weight: "bold")[La cuenta]],
    ),
    [$A = {0} union [1, 2]$],
    [$op("ínf") A = op("ínf") A^compose$ (1C 2025 Ej.~2~(b))],
    [$op("ínf") A = 0$ ($0$ es cota inferior y $0 in A$, Prop.~6); $A^compose = (1, 2)$ (S13);
     $op("ínf")(1, 2) = 1$ (Prop.~5 con $1 + op("mín"){epsilon, 1}\/2$). $0 != 1$.],
    [$A = {0}$, $B = (0, 1)$],
    [$A inter overline(B) != emptyset => A inter B != emptyset$ sin $A$ abierto (Recu 2C 2025 Ej.~3~(b))],
    [$overline(B) = [0, 1] in.rev 0$ (S13), así que $A inter overline(B) = {0} != emptyset$; pero
     $0 in.not (0, 1)$, así que $A inter B = emptyset$. ${0}$ no es abierto: $B(0, r) = (-r, r) subset.eq.not {0}$.],
    [$a = (1, 0, 0, dots)$, \ $b = (-1, 0, 0, dots)$],
    [$op("sup"){a_n + b_n} = op("sup"){a_n} + op("sup"){b_n}$ (Recu 1C 2025 Ej.~2~(b))],
    [${a_n} = {1, 0}$, $op("sup") = 1$; ${b_n} = {-1, 0}$, $op("sup") = 0$ (Prop.~4, el máximo
     pertenece); $a_n + b_n = 0$ para todo $n$, $op("sup"){0} = 0$. $0 != 1 + 0$. La suma sólo junta
     pares con el *mismo índice*; en $A + B$ se suman todos los pares.],
  )
]

*Lo que sí vale en cada caso falso* (para escribirlo como comentario): $op("ínf") A <= op("ínf") A^compose$
porque $A^compose subset.eq A$ (S11); $op("sup"){a_n + b_n} <= op("sup"){a_n} + op("sup"){b_n}$
porque ${a_n + b_n} subset.eq {a_n} + {b_n}$ (S11 + S14); y la implicación de Recu 2C 2025 Ej.~3
vale con $A$ abierto (ítem (a), topología general).

=== Índice cruzado

#block[
  #set text(size: 9pt)
  #table(
    columns: (1.5fr, 2.4fr, 1.6fr, 1.2fr, 0.9fr),
    align: (left + top, left + top, left + top, left + top, left + top),
    fill: (x, y) => if y == 0 { rgb("#0c4a6e") } else if calc.even(y) { rgb("#f8fafc") } else { white },
    stroke: 0.4pt + rgb("#cbd5e1"),
    inset: (x: 6pt, y: 5pt),
    table.header(
      [#text(fill: white, weight: "bold")[Parcial · Ej.]],
      [#text(fill: white, weight: "bold")[Veredicto]],
      [#text(fill: white, weight: "bold")[Apunte]],
      [#text(fill: white, weight: "bold")[Guía]],
      [#text(fill: white, weight: "bold")[Propio]],
    ),
    [2C 2024 · Ej.~1], [$op("ínf")(A + B) = op("ínf") A + op("ínf") B$: se prueba], [S1 S2 S5], [S9], [S15],
    [1C 2025 · Ej.~2~(a)], [$op("ínf") A = op("ínf") overline(A)$: V], [S1 S2 S8], [S11], [S16],
    [1C 2025 · Ej.~2~(b)], [$op("ínf") A = op("ínf") A^compose$: F, ${0} union [1, 2]$], [S5 S7 S8], [S13], [---],
    [Recu 1C 2025 · Ej.~2~(a)], [$op("sup")(A + B) = op("sup") A + op("sup") B$: V], [S1 S2 S4], [S9], [S14],
    [Recu 1C 2025 · Ej.~2~(b)], [sup de la suma de sucesiones: F, $(1, 0, dots)$, $(-1, 0, dots)$], [S6], [S11], [---],
    [2C 2025 · Ej.~1], [${m\/(m+n)}$: $op("sup") = 1$, $op("ínf") = 0$, no se alcanzan], [S1 S2 S3 S4 S5], [S10], [---],
    [Recu 2C 2025 · Ej.~1], [${1\/(n^2 - 8n + 18)}$: $op("máx") = 1\/2$, $op("ínf") = 0$, sin mínimo], [S1 S3 S5 S6], [S10], [---],
    [Recu 2C 2025 · Ej.~3~(b)], [$A inter overline(B) != emptyset => A inter B != emptyset$ sin $A$ abierto: F, ${0}$ y $(0, 1)$], [S8], [S13], [---],
  )
]

Las fichas más usadas son S1 (en los cinco parciales), S2 y S5 (en cuatro cada una); S12 no la cita ningún parcial
y está porque es el puente entre las dos versiones (sup e ínf) de S14 / S15. Lo único de nivel
propio son las tres igualdades S14, S15 y S16: conviene saber escribirlas de memoria, porque son
el ejercicio entero.

