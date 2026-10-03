#import "../utils.typ": *

// Fuente: `parciales/primer_parcial_2c2025.jpg` (foto del enunciado).
// Sólo enunciados: la fuente no trae resolución.

#align(center)[
  #text(14pt, weight: "bold")[Análisis Avanzado - Segundo cuatrimestre 2025] \
  #v(2pt)
  #text(12pt, weight: "medium")[Primer parcial - 16/10/25]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

*Ejercicio 1.* Calcular, si existen, el supremo y el ínfimo de
$ A = {m / (m + n) : m in NN, n in NN}. $

#line(length: 100%, stroke: 0.4pt)

*Ejercicio 2.* Calcular el cardinal de
$ A = {(a_n)_(n in NN) subset.eq QQ : exists k in NN "tal que" a_(n+k) = (a_k)^n space forall n in NN}. $

#line(length: 100%, stroke: 0.4pt)

*Ejercicio 3.* Sea $(E, d)$ un espacio métrico. Probar que dados $x, y in E$ con $x != y$ existen dos abiertos $U, V$ tales que $x in U$, $y in V$ y $overline(U) inter overline(V) = emptyset$.

#line(length: 100%, stroke: 0.4pt)

*Ejercicio 4.* Sea $(E, d)$ un espacio métrico. Recordemos que para $A, B subset.eq E$ no vacíos se define
$ tilde(d)(A, B) = op("ínf"){d(a, b) : a in A, b in B}. $
Sea $(M_n)_(n in NN) subset.eq E$ una familia de conjuntos no vacíos.

#set enum(numbering: "a)")
+ Probar que
  $ union.big_(n in NN) overline(M_n) subset.eq overline(union.big_(n in NN) M_n). $

+ Supongamos que existe $epsilon > 0$ tal que $tilde(d)(M_n, M_m) > epsilon$ para todo $n != m$. Probar que
  $ overline(union.big_(n in NN) M_n) = union.big_(n in NN) overline(M_n). $

#line(length: 100%, stroke: 0.4pt)

*Ejercicio 5.* Sea $C([0, 1]) = {f : [0, 1] -> RR : f "es continua"}$ visto como espacio métrico con la métrica $d_oo$. Definimos una métrica en $C([0, 1]) times [0, 1]$ mediante
$ d((f, x), (g, y)) := op("máx"){d_oo (f, g), abs(x - y)}. $
Sea $F : C([0, 1]) times [0, 1] -> RR$ la función definida como $F(f, x) = f(x)$. Probar que $F$ es continua.

#v(8pt)
#line(length: 100%, stroke: 0.7pt)
#v(6pt)

#align(center)[
  #text(10pt, weight: "bold")[JUSTIFICAR TODAS LAS RESPUESTAS]
]
