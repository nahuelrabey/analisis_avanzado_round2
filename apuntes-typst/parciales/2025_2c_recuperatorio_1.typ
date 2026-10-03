#import "../utils.typ": *

// Fuente: `parciales/recuperatorio_1_2c2025.jpg` (foto del enunciado).
// Sólo enunciados: la fuente no trae resolución.

#align(center)[
  #text(14pt, weight: "bold")[Análisis Avanzado - Segundo cuatrimestre 2025] \
  #v(2pt)
  #text(12pt, weight: "medium")[Recuperatorio del primer parcial - 04/12/25]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

*Ejercicio 1.* Calcular, si existen, el supremo, ínfimo, máximo y mínimo de
$ A = {1 / (n^2 - 8n + 18) : n in NN}. $

#line(length: 100%, stroke: 0.4pt)

*Ejercicio 2.* Calcular el cardinal del conjunto
$ C = {f : QQ -> NN : f(q) = 3 "para todo" q in QQ "salvo finitos"}. $

#line(length: 100%, stroke: 0.4pt)

*Ejercicio 3.*

#set enum(numbering: "a)")
+ Sea $(E, d)$ un espacio métrico y sean $A, B subset.eq E$ con $A$ abierto. Probar que si $A inter overline(B) != emptyset$, entonces $A inter B != emptyset$.

+ Supongamos que $(E, d) = (RR, abs(dot.c))$, $A, B subset.eq RR$ pero $A$ no necesariamente es abierto. ¿Sigue valiendo la afirmación del ítem a)?

#line(length: 100%, stroke: 0.4pt)

*Ejercicio 4.* Sea $delta : RR times RR -> RR$ la métrica discreta en $RR$ dada por
$ delta(x, y) = cases(1 & quad "si" x != y, 0 & quad "si" x = y). $
Sea $d : RR^2 times RR^2 -> RR$ la métrica definida como
$ d((x_1, y_1), (x_2, y_2)) = sqrt(abs(x_1 - x_2)^2 + delta(y_1, y_2)^2). $

+ Probar que en el espacio métrico $(RR^2, d)$ vale que $B((0, 0), 1/2) = (-1/2, 1/2) times {0}$.

+ Decidir si la sucesión $(1/n, 1/n)_(n in NN)$ converge a $(0, 0)$ con la métrica $d$.

#line(length: 100%, stroke: 0.4pt)

*Ejercicio 5.* Sean $(E, d)$ y $(E', d')$ espacios métricos y $f : E -> E'$ una función. Probar que $f$ es continua si y sólo si $f^(-1)(B^circle) subset.eq (f^(-1)(B))^circle$ para todo $B subset.eq E'$.

#v(8pt)
#line(length: 100%, stroke: 0.7pt)
#v(6pt)

#align(center)[
  #text(10pt, weight: "bold")[JUSTIFICAR TODAS LAS RESPUESTAS]
]
