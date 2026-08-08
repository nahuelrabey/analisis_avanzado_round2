#import "utils.typ": *

#align(center)[
  #text(14pt, weight: "bold")[Análisis Avanzado - Primer cuatrimestre 2025] \
  #v(2pt)
  #text(12pt, weight: "medium")[Primer parcial - 08/05/2025]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#set enum(numbering: "1.")

+ Sea $A$ el conjunto de sucesiones $(a_n)_(n in NN)$ de números enteros que cumplen
  $ a_(n+1) - a_n in {1, 2} quad "para todo " n in NN. $
  Halle el cardinal de $A$.

+ Sea $A subset.eq RR$ no vacío y acotado. Decida si las siguientes igualdades son verdaderas o falsas, demostrándolas en caso de que sean verdaderas o mostrando un contraejemplo en caso de que sean falsas:
  #set enum(numbering: "a.")
  + $op("ínf")(A) = op("ínf")(overline(A))$.
  + $op("ínf")(A) = op("ínf")(A^circle)$.

+ Sea $(E, d)$ un espacio métrico y sea $U subset.eq E$ un subconjunto. Pruebe que $U$ es abierto si y solo si para todo $T subset.eq E$ vale $U inter overline(T) subset.eq overline(U inter T)$.

+ Consideremos el conjunto
  $ X = \{(a_n)_(n in NN) subset.eq RR | "existe " n_0 in NN "tal que " a_n = 0 "para todo " n >= n_0\}. $
  Dados $a = (a_n)_(n in NN), b = (b_n)_(n in NN) in X$, definimos la distancia
  $ d_oo (a, b) = op("sup")\{|a_n - b_n| : n in NN\}. $
  Con esta distancia $(X, d_oo)$ es un espacio métrico.
  #set enum(numbering: "a.")
  + Sea $A = \{(a_n)_(n in NN) subset.eq RR | a_n = 0 "para todo " n >= 4\} subset.eq X$. Calcule $A^circle$ y $overline(A)$.
  + Pruebe que $(X, d_oo)$ no es completo. \
    _*Sugerencia:* considere $a = (a_n)_(n in NN)$ dada por $a_n = 1/n$._

#v(12pt)
#line(length: 100%, stroke: 0.7pt)
#v(6pt)

#align(center)[
  #text(9pt, style: "italic")[
    Complete esta hoja con sus datos y entréguela con el resto del examen. \
    *Justifique todas sus respuestas y escriba con claridad.*
  ]
]
