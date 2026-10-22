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

// --- Ejemplos alternativos de la Práctica 4 (fuentes abiertas) ---

#align(center)[
  #text(14pt, weight: "bold")[Ejemplos alternativos --- Práctica 4] \
  #v(2pt)
  #text(10pt, style: "italic", fill: rgb("#475569"))[
    Funciones continuas: ejemplos y ejercicios resueltos de apuntes universitarios de acceso abierto
  ]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

Este archivo complementa a `ejemplos/p4.typ` (que tiene los ejemplos de `notas_materia.pdf` y de las clases) con material de *otras universidades*. Está organizado igual: bloques por técnica, en el orden en que los necesita `guias/p4.typ`, y cada bloque abre con la nota de qué ejercicios desbloquea. Al final hay un índice por ejercicio de la práctica.

La pestaña *`O{fuente}-{k}`* dice de qué documento viene cada ítem (tabla de abajo); la referencia precisa (sección, número y página del PDF) está al pie de cada uno. Las *definiciones* y *proposiciones* llevan el tag sólo en el comentario del código fuente.

#sublema(titulo: "Fidelidad")[
  Las resoluciones son *las de la fuente*, traducidas y pasadas a la notación del curso. Si la fuente sólo da el enunciado o una indicación, el ítem no tiene `Resolución`. Los errores de la fuente se transcriben igual y se señalan con una _Nota_. Lo que agregó quien transcribió está marcado como "del transcriptor", "deducción propia" o "razonamiento nuestro". El comentario `// ----` de cada ítem cita los resultados del capítulo 5 de `apuntes.typ` que usa (hasta la Observación 5.34) y, con "falta: ...", los que el apunte todavía no tiene: composición, álgebra de continuas, $d(x, A)$, Urysohn, pegado, compacidad.
]

#v(6pt)

#show table.cell.where(y: 0): set text(fill: white, weight: "bold", size: 8.5pt)

#text(size: 8.5pt)[
#table(
  columns: (0.4fr, 2.6fr, 1.6fr),
  align: (center + horizon, left + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#065f46") } else if calc.even(y) { rgb("#f8fafc") } else { white },
  stroke: 0.4pt + rgb("#cbd5e1"),
  inset: (x: 5pt, y: 3pt),

  [*Tag*], [*Fuente*], [*Acceso*],
  [O2], [J. A. Guccione y J. J. Guccione, _Espacios Métricos_, apunte de Cálculo Avanzado, FCEN-UBA, abril de 2017. #link("https://cms.dm.uba.ar/academico/materias/2docuat2018/calculo_avanzado/2017/apunte.pdf")[Enlace]], [Permite la copia sin fines de lucro, sin modificar el texto, respetando la autoría y manteniendo la nota de copyright.],
  [O3], [A. Daniilidis, _Espacios Métricos_, apuntes de MA3801 (Parte I), DIM, Universidad de Chile, 2016. #link("https://www.dim.uchile.cl/~arisd/Espacios%20Metricos%20(U3).pdf")[Enlace]], [Página personal del docente; sin licencia explícita.],
  [O4], [P. Gajardo Adaro, _Análisis I_, Universidad Técnica Federico Santa María (Chile), marzo de 2021. #link("https://matematica.usm.cl/wp-content/uploads/2018/09/analisis1_utfsm_202103.pdf")[Enlace]], [Copyright del autor; sin licencia explícita.],
  [O5], [E. Maximenko, _Funciones uniformemente continuas_, presentación, ESFM-IPN (México), 2022. #link("https://esfm.egormaximenko.com/analysis/uniformly_continuous_functions_presentation_es.pdf")[Enlace]], [Página personal del docente; sin licencia explícita.],
  [O6], [J. Lebl, _Basic Analysis I: Introduction to Real Analysis_, versión 6.3, 2026. #link("https://www.jirka.org/ra/realanal.pdf")[Enlace]], [Doble licencia CC BY-NC-SA 4.0 y CC BY-SA 4.0.],
  [O7], [J. Tyson, _MATH 424 Honors Real Analysis, lecture notes: functions_, University of Illinois Urbana-Champaign, 2026. #link("http://publish.illinois.edu/jeremy-tyson/files/2026/05/functions.pdf")[Enlace]], [Página del docente; sin licencia explícita.],
  [O8], [P. Dote, _18.S097 Introduction to Metric Spaces_, Lecture 5, MIT, IAP 2022. #link("https://web.mit.edu/paigeb/www/18.S097/Lect_5.pdf")[Enlace]], [Página personal; sin licencia explícita.],
  [O9], [MIT OpenCourseWare, _18.100C Real Analysis_, Fall 2012, soluciones del Problem Set 6. #link("https://ocw.mit.edu/courses/18-100c-real-analysis-fall-2012/resources/mit18_100cf12_prob_set_6/")[Enlace]], [CC BY-NC-SA 4.0 (licencia del sitio OCW).],
  [O10], [P. Karageorgis, _MA2223 Metric spaces_, capítulo 1 y soluciones del tutorial 1, Trinity College Dublin. #link("https://www.maths.tcd.ie/~pete/ma2223/")[Enlace]], [Página del docente; sin licencia explícita.],
  [O11], [D. Herrera Carrasco, F. Macías Romero y L. A. Guerrero Méndez, _La magia de los espacios métricos_, FCFM-BUAP (México), 1.ª ed. 2025. #link("https://www.fcfm.buap.mx/assets/docs/publicaciones/La_magia_de_los_espacios_metricos.pdf")[Enlace]], [Derechos reservados de la BUAP; PDF publicado por la editorial universitaria.],
  [O12], [R. G. Wilson, _Notas de Análisis_, UAM-Iztapalapa (México), 2005. #link("http://mat.izt.uam.mx/mat/documentos/notas%20de%20clase/NotasdeAnalisis.pdf")[Enlace]], [Web del departamento; sin licencia explícita.],
  [O14], [R. Payá Albert, _Análisis Matemático I_, Universidad de Granada, cursos 2024-25 y 2014-15 (apuntes y ejercicios resueltos). #link("https://www.ugr.es/~rpaya/docencia.htm")[Enlace]], [Página personal del docente; sin licencia explícita.],
  [O15], [T. W. Körner, _Metric and Topological Spaces_, Part IB, DPMMS, Universidad de Cambridge, 2021. #link("https://www.dpmms.cam.ac.uk/~twk10/Top.pdf")[Enlace]], [Página del autor; sin licencia explícita.],
  [O16], [S. Chavan, _MTH304 Topology: notes and problems_, IIT Kanpur. #link("https://home.iitk.ac.in/~chavan/topology_mth304.pdf")[Enlace]], [Página del docente; sin licencia explícita.],
  [O17], [N. Addington, _A Course in Metric Spaces and Point-Set Topology_, Math 431, Universidad de Oregon, 2026. #link("https://pages.uoregon.edu/adding/courses/431/431notes.pdf")[Enlace]], [Página del docente; sin licencia explícita.],
)
]

#v(8pt)

#table(
  columns: (0.35fr, 2.4fr, 1.1fr),
  align: (center + horizon, left + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#065f46") } else if calc.even(y) { rgb("#f8fafc") } else { white },
  stroke: 0.4pt + rgb("#cbd5e1"),
  inset: (x: 6pt, y: 4pt),

  [*\#*], [*Bloque*], [*Desbloquea*],
  [1], [Herramientas: composición, álgebra de continuas, restricción y pegado], [p4: Ej. 1, 4, 5, 11 (teoría que falta)],
  [2], [Decidir continuidad en $RR^2$: sucesiones, cotas y polares], [p4: Ej. 1 (a), (b)],
  [3], [La continuidad depende de las métricas: discreta, identidad, funciones abiertas y cerradas], [p4: Ej. 1 (c), (d), 6],
  [4], [Funciones definidas distinto en $QQ$ y en $RR without QQ$], [p4: Ej. 2],
  [5], [Conjuntos definidos por igualdades y desigualdades: preimágenes], [p4: Ej. 3, 4, 5],
  [6], [Densidad y continuidad], [p4: Ej. 7, 8],
  [7], [Funciones sobre $C([0, 1])$: $d_1$ contra $d_infinity$], [p4: Ej. 9],
  [8], [Distancia a un punto y a un conjunto; lema de Urysohn], [p4: Ej. 10, 11, 16],
  [9], [Lipschitz y continuidad uniforme: definiciones y criterios], [p4: Ej. 12, 13, 15],
  [10], [Ejemplos y contraejemplos de continuidad uniforme], [p4: Ej. 13, 15],
  [11], [Continuidad uniforme, sucesiones de Cauchy y extensión], [p4: Ej. 14, 7],
  [12], [Anticipo de la Práctica 5: continua en un compacto es uniformemente continua], [p4: Ej. 13, 15 (contexto)],
  [13], [Listas de ejercicios sin resolver para practicar], [p4: Ej. 3–5, 8, 11, 13–16],
)

#v(8pt)

== Bloque 1 · Herramientas: composición, álgebra de continuas, restricción y pegado

#sublema(titulo: "Qué desbloquea")[
  La Práctica 4 usa sin decirlo que composiciones, sumas, productos y cocientes de funciones continuas son continuos, y que una función definida a trozos es continua si los trozos pegan bien. `apuntes.typ` todavía no lo enuncia como teorema, aunque ya lo usa: el Ejemplo 5.30 a) dice que $x \/ (1 + abs(x))$ es continua "por ser cociente de continuas", y el Ejercicio 5.32 (la composición de homeomorfismos, Definición 5.29, es un homeomorfismo) necesita la composición. Este bloque trae las demostraciones de las fuentes: composición por $epsilon$--$delta$, por preimágenes y por sucesiones, restricción, pegado sobre dos cerrados y el contraejemplo del pegado sobre infinitos cerrados. Es la teoría que hace falta para escribir con rigor el *Ejercicio 1*, el *Ejercicio 5* y el cociente de Urysohn del *Ejercicio 11*.
]

// ---- O15-1  |  p4: Ej. 1 (herramienta), 5  |  teoría: Def. 5.4, Teo. 5.9; falta: composición de continuas enunciada como teorema (el Ejercicio 5.32, composición de homeomorfismos, la necesita)  |  nivel: baja (teoría que falta en apuntes.typ)
#proposicion[Ley de composición, con dos demostraciones (Körner, Lema 3.3 y Teorema 3.3 "new proof")][
  Si $(X, d)$, $(Y, rho)$ y $(Z, sigma)$ son espacios métricos y $g : X -> Y$, $f : Y -> Z$ son continuas, entonces $f compose g$ también lo es.
]

#demostracion[
  *Primera demostración ($epsilon$--$delta$, pág. 60).* Sea $epsilon > 0$ y $x in X$, y llamemos $h = f compose g$ e $y_0 = g(x)$. Como $f$ es continua, podemos encontrar $delta_1 > 0$ (que depende de $epsilon$ y de $y_0$) con
  $ sigma(f(y_0), f(y)) < epsilon quad "siempre que" quad rho(y_0, y) < delta_1 . $
  Como $g$ es continua, podemos encontrar $delta_2 > 0$ tal que
  $ rho(y_0, g(t)) < delta_1 quad "siempre que" quad d(x, t) < delta_2 . $
  Tomando $y = g(t)$ en la primera desigualdad, tenemos entonces $sigma(h(x), h(t)) < epsilon$ siempre que $d(x, t) < delta_2$, como se quería.

  *Segunda demostración (por preimágenes de abiertos, pág. 10).* Si $U$ es abierto en $Z$, por continuidad $f^(-1)(U)$ es abierto en $Y$ y, de nuevo por continuidad, $(f compose g)^(-1)(U) = g^(-1)(f^(-1)(U))$ es abierto en $X$. Luego $f compose g$ es continua.

  _Nota_: la segunda demostración usa el Teo. 5.9 del apunte. Körner comenta que "esto confirma que las ideas de este capítulo van por buen camino".

  _Fuente_: T. W. Körner, _Metric and Topological Spaces_ (DPMMS, Univ. of Cambridge, 2021), Lemma 3.3 (pág. 7, demostración pág. 60) y Theorem 3.3 "New proof" (pág. 10). #link("https://www.dpmms.cam.ac.uk/~twk10/Top.pdf")[URL]. Acceso: página personal del autor; sin licencia explícita.
]

// ---- O2-1  |  p4: Ej. 2, 7 (a)  |  teoría: Teo. 5.7; falta: composición y restricción de continuas como teorema  |  nivel: baja (teoría)
#proposicion[Composición y restricción de funciones continuas (Guccione, Prop. 3.9)][
  Sean $X$, $Y$, $Z$ espacios métricos, $A subset.eq X$ y $B subset.eq Y$.
  + Si $f : X -> Y$ es continua en $A$ (es decir, en cada punto de $A$) y $g : Y -> Z$ es continua en $f(A)$, entonces $g compose f$ es continua en $A$.
  + Si $f : X -> Y$ es continua en $A$ y $f(A) subset.eq B$, entonces la función $f|_A^(|B) : A -> B$, obtenida restringiendo el dominio de $f$ a $A$ y el codominio de $f$ a $B$, es continua.
]

#demostracion[
  1) Como $f$ es continua en $A$ y $g$ es continua en $f(A)$, si $(x_n)_(n in NN)$ tiende a $a in A$, entonces $(f(x_n))_(n in NN)$ tiende a $f(a)$ y $((g compose f)(x_n))_(n in NN)$ tiende a $(g compose f)(a)$.

  2) Primero notemos que $f|_A$ es continua porque es la composición de $f$ con la inclusión canónica $i_A : A -> X$, y ambas funciones son continuas. Pero entonces, por la Observación 1.104 de la fuente (una sucesión de puntos de un subespacio $Y subset.eq X$ converge en $Y$ a un punto de $Y$ si y sólo si converge en $X$ a ese punto), dada una sucesión arbitraria $(a_n)_(n in NN)$ de puntos de $A$ que tiende a un punto $a in A$, la sucesión $(f(a_n))_(n in NN)$ formada por sus imágenes tiende a $f(a)$ en $B$ y, por lo tanto, la función $f|_A^(|B)$ es continua.

  _Nota_: la fuente usa la caracterización por sucesiones de la continuidad en un punto (su Proposición 3.4, items 1 y 4), que es el Teorema 5.7 de `apuntes.typ`. Que $i_A$ es continua es su Ejemplo 3.2 (sale de que $d(i_A (x), i_A (x')) = d(x, x')$).
]

#ejemplo[La restricción puede ser continua sin que la función lo sea: $chi_QQ$ (Guccione, Nota 3.10)][O2-1][
  El item 2 de la proposición anterior dice que si una función definida sobre $X$ es continua en un subconjunto $A$ de $X$, entonces su restricción a $A$ es continua. La recíproca no vale. Por ejemplo, la función $chi_QQ : RR -> RR$ definida por
  $ chi_QQ (x) := cases(1 &"si " x in QQ, 0 &"en caso contrario") $
  es continua restringida a $QQ$ y a $RR without QQ$, pero no es continua en ningún punto de $QQ$ ni de $RR without QQ$.

  _Nota_: la fuente sólo enuncia el ejemplo, sin demostración. Compárese con el Ej. 2 de la Práctica 4: allí $f(x) = x$ sobre $QQ$ y $0$ sobre $RR without QQ$ tiene restricciones continuas a $QQ$ y a $RR without QQ$ y, sin embargo, sólo es continua en $0$.

  _Fuente_: J. A. Guccione y J. J. Guccione, _Espacios Métricos_ (Depto. de Matemática, FCEN-UBA, 2017), Proposición 3.9 y Nota 3.10, pág. 66 del PDF (57 del apunte). #link("https://cms.dm.uba.ar/academico/materias/2docuat2018/calculo_avanzado/2017/apunte.pdf")[URL]. Acceso: publicado en la web de la materia; nota de copyright en la portada que permite la copia sin fines de lucro, sin modificar el texto y respetando la autoría.
]

// ---- O2-2  |  p4: Ej. 1 (a) (b), 5, 6, 9  |  teoría: Teo. 5.7 / Def. 5.4; falta: álgebra de funciones continuas a valores reales  |  nivel: baja (teoría)
#ejemplo[Suma, producto, cociente e inversión son continuas; funciones racionales (Guccione, Ejercicio 3.14 y Nota 3.15)][O2-2][
  Sea $k := RR$ o $CC$ (con la métrica usual, y $k times k$ con $d_infinity$). Pruebe que las funciones
  $ +: k times k &-> k, & (x, y) &|-> x + y, \
    m : k times k &-> k, & (x, y) &|-> x y, \
    op("inv") : k without {0} &-> k without {0}, quad & x &|-> x^(-1) $
  son continuas. Concluya que la suma, el producto y el cociente de funciones continuas $f : X -> k$ y $g : X -> k$ son funciones continuas (por supuesto, el dominio del cociente de $f$ por $g$ es $X without g^(-1)(0)$).

  _Nota 3.15 de la fuente_: como la función identidad $op("id") : k -> k$ y las funciones constantes $c_a : k -> k$ ($a in k$) son continuas, una consecuencia directa del ejercicio anterior es que las funciones racionales $P/Q : A -> k$, donde $P$ y $Q$ son polinomios con coeficientes en $k$ y $A = k without Q^(-1)(0)$, son continuas.

  _Nota_: la fuente deja el ejercicio sin resolución. La conclusión sobre $f + g$, $f g$ y $f \/ g$ sale de la Proposición 3.9 (O2-1): por ejemplo $f + g = + compose (f, g)$, y $(f, g) : X -> k times k$ es continua porque lo son sus coordenadas (Proposición 3.11 de la fuente, que es el ejemplo C6-1 de `ejemplos/p4.typ`). Esta es la pieza que falta en `apuntes.typ` para justificar en una línea que $x^2 + y^2$ y $(x^2 y) \/ ((1 \/ 2) x^2 + (x - 1)^2 y^2)$ son continuas fuera de los puntos problemáticos (Ej. 1 de la Práctica 4), y que $h = d(x, A) \/ (d(x, A) + d(x, B))$ es continua (Ej. 11).

  _Fuente_: J. A. Guccione y J. J. Guccione, _Espacios Métricos_ (FCEN-UBA, 2017), Ejercicio 3.14 y Nota 3.15, pág. 67 del PDF (58 del apunte). #link("https://cms.dm.uba.ar/academico/materias/2docuat2018/calculo_avanzado/2017/apunte.pdf")[URL]. Acceso: web de la materia; copia permitida sin fines de lucro (ver portada).
]

// ---- O14-4  |  p4: Ej. 1, 5 (y herramienta para O14-1..3)  |  teoría: Def. 5.4, Teo. 5.9, Ej. 5.10; falta: continuidad en un punto y restricción ("carácter local")  |  nivel: baja (teoría que falta en apuntes.typ)
#proposicion[Continuidad y restricciones: carácter local de la continuidad (Payá, Apuntes 03, §3.1--3.2)][
  Sean $E, F$ espacios métricos, $f : E -> F$ una función y $A subset.eq E$ no vacío, con la distancia inducida. Para $x in A$ se tiene:
  + Si $f$ es continua en $x$, entonces $f|_A$ es continua en $x$.
  + Si $f|_A$ es continua en $x$ y $A$ es entorno de $x$ en $E$ (es decir, $A$ contiene una bola $B(x, r)$), entonces $f$ es continua en $x$.

  En consecuencia: si $A$ es un abierto no vacío de $E$, $f$ es continua en todo punto de $A$ si, y sólo si, $f|_A$ es continua. Y si $E = U union V$ con $U, V$ abiertos, $f$ es continua si, y sólo si, $f|_U$ y $f|_V$ son continuas.
]

#demostracion[
  La fuente escribe la continuidad en $x$ como: "para todo entorno $V$ de $f(x)$, $f^(-1)(V)$ es entorno de $x$" (equivalente a la Def. 5.4 con bolas).

  (i) Si $V$ es entorno de $f(x)$, sabemos que $f^(-1)(V)$ es entorno de $x$ en $E$, de donde $(f|_A)^(-1)(V) = f^(-1)(V) inter A$ es entorno de $x$ en el espacio métrico $A$.

  (ii) Si $V$ es entorno de $f(x)$, ahora $(f|_A)^(-1)(V) = f^(-1)(V) inter A$ es entorno de $x$ en $A$, luego $f^(-1)(V) inter A supset.eq U inter A$ donde $U$ es un abierto de $E$ con $x in U$. Como $A$ es entorno de $x$ en $E$, $U inter A$ es entorno de $x$ en $E$, luego también lo es $f^(-1)(V)$, pues $U inter A subset.eq f^(-1)(V)$.

  Para la consecuencia: si $A$ es abierto, para cada $x in A$ el conjunto $A$ es entorno de $x$, y de ser $f|_A$ continua en $x$ se deduce que $f$ es continua en $x$. El caso $E = U union V$ es inmediato.

  _Nota_: la fuente destaca que, con $F = RR$ y $f$ continua, ${x in E : f(x) > 0} = f^(-1)((0, +oo))$ y ${x in E : f(x) < 0}$ son abiertos y ${x in E : 0 <= f(x) <= 1} = f^(-1)([0, 1])$ es cerrado (pág. 4 del PDF): exactamente el mecanismo del Ej. 5 de la Práctica 4. La fuente también prueba (§3.4, pág. 6) que la composición de continuas es continua: "para $W$ entorno de $f(phi(z))$, $f^(-1)(W)$ es entorno de $phi(z)$ y $phi^(-1)(f^(-1)(W)) = (f compose phi)^(-1)(W)$ es entorno de $z$".

  _Fuente_: R. Payá Albert, _Análisis Matemático I_ (UGR, 2024-25), Tema 3 "Continuidad y límite funcional", §3.1 y §3.2, págs. 3--4 del PDF (págs. 29--30 impresas). #link("https://www.ugr.es/~rpaya/documentos/AnalisisI/2024_25/Apuntes_03.pdf")[URL]. Acceso: web del docente en la UGR; sin licencia explícita.
]

// ---- O2-3  |  p4: Ej. 1 (b), 5  |  teoría: Ej. 5.10 (preimagen de cerrados), Teo. 4.31 (unión finita de cerrados)  |  nivel: alta
#proposicion[Pegado de funciones continuas sobre dos cerrados (Guccione, Prop. 3.16)][
  Consideremos una función $f : X -> Y$. Supongamos que $X$ es unión $X = C_1 union C_2$ de dos subconjuntos cerrados. Si $f|_(C_1)$ y $f|_(C_2)$ son continuas, entonces $f$ es continua.
]

#demostracion[
  Para cada subconjunto cerrado $C$ de $Y$,
  $ f^(-1)(C) = f|_(C_1)^(-1)(C inter C_1) union f|_(C_2)^(-1)(C inter C_2) $
  es cerrado porque es unión de dos cerrados.

  _Nota_: la fuente usa que $f$ es continua si y sólo si la preimagen de todo cerrado es cerrada (su Teorema 3.6, item 3; Ejercicio 5.10 de `apuntes.typ`). Los conjuntos $f|_(C_i)^(-1)(C inter C_i)$ son cerrados en el subespacio $C_i$, y como $C_i$ es cerrado en $X$, también son cerrados en $X$.
]

#ejemplo[Una función definida a trozos en $RR^2$ es continua (Guccione, Ejercicio 3.17)][O2-3][
  Pruebe que la función $f : RR^2 -> RR$ definida por
  $ f(x, y) := cases(x^2 - 2 x y + y^2 + 2 &"si " x >= y, ((x - y)^3 - 3 (x - y)^2 + 2 x^2 + 2 y^2 + 2) / (x^2 + y^2 + 1) &"si " x <= y) $
  es continua.
]

#estrategia[Idea][
  La fuente no resuelve el ejercicio, pero lo ubica inmediatamente después de la Proposición 3.16: los semiplanos $C_1 = {(x, y) : x >= y}$ y $C_2 = {(x, y) : x <= y}$ son cerrados, cubren $RR^2$, y sobre cada uno $f$ coincide con una función racional (continua por la Nota 3.15, O2-2). Lo único que hay que controlar es que ambas fórmulas coincidan sobre la recta $x = y$, para que $f$ esté bien definida: allí la primera vale $2$ y la segunda vale $(2 x^2 + 2 y^2 + 2) \/ (x^2 + y^2 + 1) = 2$.

  _Fuente_: J. A. Guccione y J. J. Guccione, _Espacios Métricos_ (FCEN-UBA, 2017), Proposición 3.16 y Ejercicio 3.17, pág. 67 del PDF (58 del apunte). #link("https://cms.dm.uba.ar/academico/materias/2docuat2018/calculo_avanzado/2017/apunte.pdf")[URL]. Acceso: web de la materia; copia permitida sin fines de lucro (ver portada).
]

// ---- O16-5  |  p4: Ej. 1 (herramienta), 13 (pegado en [eps, +oo))  |  teoría: Def. 5.4; falta: continuidad y restricción (carácter local), lema del pegado  |  nivel: baja (teoría que falta en apuntes.typ)
#ejemplo[Problema de la restricción: continua en cada $[1 slash n, 1]$ y en ${0}$ pero no en $[0, 1]$; sí vale con abiertos (Chavan, Ejemplo 8.18 y Corolario 8.19)][O16-5][
  Si $f : X -> Y$ es continua y $A subset.eq X$, la restricción $f|_A$ es continua (Corolario 8.16). Recíprocamente: si $X = union.big_alpha A_alpha$ y cada $f|_(A_alpha)$ es continua, ¿es $f$ continua? La respuesta es *no*, aun si cada $A_alpha$ es cerrado:

  *(Ejemplo 8.18)* Sea $X = [0, 1]$, $A_0 = {0}$ y $A_n = [1 slash n, 1]$. La función $f : [0, 1] -> RR$ dada por $f(0) = 1$, $f(x) = 1 slash x$ ($0 < x <= 1$) es discontinua en $0$. Sin embargo, $f|_(A_n)$ es continua para todo $n >= 0$.

  *(Corolario 8.19)* La respuesta es *sí* si cada $A_alpha$ es abierto: si $X = union.big_alpha A_alpha$ con $A_alpha$ abiertos y cada $f|_(A_alpha)$ es continua, entonces $f$ es continua.
]

#resolucion[
  (Corolario 8.19) Usamos que $f$ es continua si, y sólo si, para cada $x in X$ y cada entorno $V_x$ de $f(x)$ hay un entorno $U_x$ de $x$ con $f(U_x) subset.eq V_x$ (Proposición 8.12 de la fuente). Sea $x in X$ y $V_x$ un entorno de $f(x)$. Entonces $x in A_alpha$ para algún $alpha$. Como $f|_(A_alpha)$ es continua, existe un entorno $U_(x, alpha)$ de $x$ tal que $f(U_(x, alpha) inter A_alpha) subset.eq V_x$, y $U_x = U_(x, alpha) inter A_alpha$ es el entorno de $x$ buscado (es entorno porque $A_alpha$ es abierto).

  _Nota_: la fuente escribe "sea $V_x$ un entorno de $x$" y "$f : X -> A$"; son erratas por "entorno de $f(x)$" y "$f : X -> Y$". El Ejemplo 8.18 no lleva demostración (es inmediato: $f(1 slash n) = n$ no converge a $f(0) = 1$). Es el mismo resultado que O14-4 (ii). Compárese con el "pegado" de continuidad uniforme en $[0, a] union [a, +oo)$ de los ejemplos de clase: ahí los trozos son cerrados y hace falta el argumento del punto de corte.

  _Fuente_: S. Chavan, _MTH304 Topology: notes and problems_ (IIT Kanpur), Example 8.18 y Corollary 8.19, pág. 14. #link("https://home.iitk.ac.in/~chavan/topology_mth304.pdf")[URL]. Acceso: página del docente en IIT Kanpur; sin licencia explícita.
]

// ---- O16-6  |  p4: Ej. 4 (max de continuas), 13 (pegado)  |  teoría: Ej. 5.10 (preimagen de cerrados), cerrados en subespacios; falta: lema del pegado  |  nivel: baja (teoría que falta en apuntes.typ)
#proposicion[Lema del pegado con finitos cerrados, y $max{f, g}$ es continua (Chavan, Prop. 8.20, Cor. 8.21 y Ejemplo 8.22)][
  *(Lema del pegado)* Sea $X = A union B$ con $A$ y $B$ cerrados en $X$, y sean $f : A -> Y$ y $g : B -> Y$ continuas. Si $f$ y $g$ coinciden en $A inter B$, la función $h : X -> Y$ definida por $h(x) = f(x)$ si $x in A$ y $h(x) = g(x)$ si $x in B$ es continua.

  *(Ejemplo 8.22)* Si $f, g : X -> RR$ son continuas, entonces $m_(f, g)(x) = max{f(x), g(x)}$ es continua.
]

#demostracion[
  La fuente prueba el lema para una familia localmente finita de cerrados (Prop. 8.20); el caso de dos cerrados es el Cor. 8.21. Sea $x in X$ y $U_x$ un entorno de $x$ que corta sólo a finitos de los cerrados, digamos $A_(alpha_1), dots, A_(alpha_k)$. Basta ver que $g = f|_(U_x)$ es continua. Nótese que $U_x = union.big_(i = 1)^k B_i$ con $B_i = A_(alpha_i) inter U_x$ cerrado en la topología de subespacio de $U_x$, y cada $g|_(B_i)$ es continua. Por la caracterización por preimágenes de cerrados, basta ver que $g^(-1)(C)$ es cerrado para todo cerrado $C subset.eq Y$. Pero $g^(-1)(C) = union.big_(i = 1)^k (g|_(B_i))^(-1)(C)$, donde $(g|_(B_i))^(-1)(C)$ es cerrado en $B_i$ y por tanto en $U_x$ (unión finita de cerrados).

  (Ejemplo 8.22) Consideremos $A_1 = {x in X : f(x) <= g(x)}$ y $A_2 = {x in X : g(x) <= f(x)}$, y notemos que $m_(f, g)|_(A_1) = g|_(A_1)$ y $m_(f, g)|_(A_2) = f|_(A_2)$ son continuas. Además $A_1$ y $A_2$ son cerrados (Ej. 8.14, O16-4). Como $f$ y $g$ coinciden en $A_1 inter A_2$, la conclusión sigue del lema del pegado.

  _Nota_: en el caso de dos cerrados, "cerrado en $B_i$ luego cerrado en $U_x$" usa que un cerrado de un subespacio cerrado es cerrado en el total; la fuente lo da por sabido. Con el lema del pegado, el Ej. 13 ("$1 slash x$ es uniformemente continua en $[epsilon, +oo)$") *no* se reduce a este resultado, porque la continuidad uniforme no es local (ver O14-7, nota).

  _Fuente_: S. Chavan, _MTH304 Topology: notes and problems_ (IIT Kanpur), Proposition 8.20, Corollary 8.21 (Pasting Lemma) y Example 8.22, pág. 15. #link("https://home.iitk.ac.in/~chavan/topology_mth304.pdf")[URL]. Acceso: página del docente en IIT Kanpur; sin licencia explícita.
]


== Bloque 2 · Decidir continuidad en $RR^2$: sucesiones, cotas y polares

#sublema(titulo: "Qué desbloquea")[
  Modelos para el *Ejercicio 1 (a), (b)*: decidir la continuidad de un cociente en el origen. Para ver que *no* es continua alcanza una sucesión, una recta o una curva por la que el límite da otra cosa (Teo. 5.7). Para ver que *sí* lo es, se acota $abs(f(x, y))$ por algo que tiende a cero, muchas veces pasando a coordenadas polares.
]

// ---- O6-3  |  p4: Ej. 1 (a), (b)  |  teoría: Teo. 5.7, convergencia coordenada a coordenada en RR^2 (C6-1)  |  nivel: alta
#ejemplo[Los polinomios en dos variables son continuos; cuidado con los límites por separado (Lebl, Ej. 7.5.3 y Ejerc. 7.5.2)][O6-3][
  #set enum(numbering: "a)")
  + Sea $f : RR^2 -> RR$ un polinomio, es decir,
    $
      f(x, y) &= sum_(j=0)^d sum_(k=0)^(d-j) a_(j k) x^j y^k \
              &= a_(0 0) + a_(1 0) x + a_(0 1) y + a_(2 0) x^2 + a_(1 1) x y + a_(0 2) y^2 + dots.c + a_(0 d) y^d,
    $
    para algún $d in NN$ (el grado) y $a_(j k) in RR$. Entonces $f$ es continua.
  + (Ejercicio 7.5.2) Sea $f : RR^2 -> RR$ con $f(0, 0) = 0$ y $f(x, y) = (x y) / (x^2 + y^2)$ si $(x, y) != (0, 0)$. Probar que para cada $x$ fijo la función $y |-> f(x, y)$ es continua, que para cada $y$ fijo la función $x |-> f(x, y)$ es continua, pero que $f$ no es continua.
]

#resolucion[
  *a)* Sea $((x_n, y_n))_(n in NN)$ una sucesión en $RR^2$ que converge a $(x, y) in RR^2$. Ya probamos que esto significa $lim_(n -> infinity) x_n = x$ y $lim_(n -> infinity) y_n = y$. Por la Proposición 2.2.5 de la fuente (álgebra de límites de sucesiones en $RR$),
  $
    lim_(n -> infinity) f(x_n, y_n) = lim_(n -> infinity) sum_(j=0)^d sum_(k=0)^(d-j) a_(j k) x_n^j y_n^k = sum_(j=0)^d sum_(k=0)^(d-j) a_(j k) x^j y^k = f(x, y).
  $
  Luego $f$ es continua en $(x, y)$ y, como $(x, y)$ era arbitrario, $f$ es continua en todas partes. Análogamente, un polinomio en $n$ variables es continuo. #align(right)[$square$]

  *b)* La fuente sólo enuncia el ejercicio y lo usa como advertencia: "hay que tener cuidado al tomar límites por separado".

  _Nota_: a) resuelve p4 Ej. 1 (a) ($x^2 + y^2$ es un polinomio) usando sólo el Teo. 5.7 y que converger en $(RR^2, d_2)$ es converger coordenada a coordenada (C6-1). b) es el modelo de p4 Ej. 1 (b): continuidad en cada variable por separado no implica continuidad.

  _Fuente_: J. Lebl, _Basic Analysis I_, v6.3, Ejemplo 7.5.3 (pág. 288 del PDF) y Ejercicio 7.5.2 (pág. 293 del PDF). #link("https://www.jirka.org/ra/realanal.pdf")[URL]. Acceso: CC BY-NC-SA 4.0 / CC BY-SA 4.0.
]

// ---- O15-2  |  p4: Ej. 1 (a)  |  teoría: Def. 5.4 en R^2 con d_2; falta: composición de continuas  |  nivel: alta
#ejemplo[$(f, g) : RR^2 -> RR^2$ es continua si $f$ y $g$ lo son; continuidad de $x y$ y de $f(x) g(y)$ (Körner, Ej. 3.4)][O15-2][
  Sean $RR$ y $RR^2$ con su métrica usual (euclídea).
  + Si $f : RR -> RR$ y $g : RR -> RR$ son continuas, probar que $(f, g) : RR^2 -> RR^2$, $(x, y) |-> (f(x), g(y))$, es continua.
  + Probar que $M : RR^2 -> RR$, $M(x, y) = x y$, es continua.
  + Usar la ley de composición para probar que $m : RR^2 -> RR$, $m(x, y) = f(x) g(y)$, es continua.
]

#resolucion[
  (i) Sea $(x, y) in RR^2$. Dado $epsilon > 0$, podemos encontrar $delta_1 > 0$ con $abs(f(x) - f(s)) < epsilon slash 2$ siempre que $abs(x - s) < delta_1$, y $delta_2 > 0$ con $abs(g(y) - g(t)) < epsilon slash 2$ siempre que $abs(y - t) < delta_2$. Si ponemos $delta = min(delta_1, delta_2)$, entonces $norm((x, y) - (s, t))_2 < delta$ implica
  $ abs(x - s) < delta <= delta_1 quad "y" quad abs(y - t) < delta <= delta_2, $
  de modo que $abs(f(x) - f(s)) < epsilon slash 2$ y $abs(g(y) - g(t)) < epsilon slash 2$, de donde
  $
    norm((f(x), g(y)) - (f(s), g(t)))_2 & <= norm((f(x), 0) - (f(s), 0))_2 + norm((0, g(y)) - (0, g(t)))_2 \
                                       & = abs(f(x) - f(s)) + abs(g(y) - g(t)) < epsilon,
  $
  como se quería.

  _Nota_: la fuente sólo resuelve (i); (ii) y (iii) quedan como ejercicio ($m = M compose (f, g)$). Körner observa que "el ejercicio puede parecer perverso, pero en la práctica probamos que las funciones son continuas viéndolas como composiciones de funciones más simples, no con la definición", y remite al Ej. 15.3 (pág. 37--38), que pide probar así que $(x, y) |-> x + y$, $(x, y) |-> x y$ y
  $ f(x, y) = sin(frac(x y, x^2 + y^2 + 1)) $
  son continuas (sin solución en el texto; sugerencia: "¿puede probar que $(x, y) |-> x^2 + y^2$ es continua?"). Esto último es el Ej. 1 (a) de la Práctica 4.

  _Fuente_: T. W. Körner, _Metric and Topological Spaces_ (DPMMS, Cambridge, 2021), Exercise 3.4, págs. 7--8, solución págs. 60--61; Exercise 15.3, págs. 37--38. #link("https://www.dpmms.cam.ac.uk/~twk10/Top.pdf")[URL]. Acceso: página personal del autor; sin licencia explícita.
]

// ---- O17-5  |  p4: Ej. 1 (b)  |  teoría: Teo. 5.7  |  nivel: alta
#ejemplo[Continua en cada variable por separado pero no continua: $x y slash (x^2 + y^2)$ (Addington, Ejemplo 9.6)][O17-5][
  Si $f : X times Y -> Z$ es continua, entonces es continua en cada variable por separado: para cada $c in X$, $y |-> f(c, y)$ es continua, y análogamente $x |-> f(x, c')$ (Ej. 9.4 de la fuente). El recíproco es falso. Sea $f : RR^2 -> RR$ dada por
  $ f(x, y) = cases(display(frac(x y, x^2 + y^2)) &"si " (x, y) != (0, 0), 0 &"si " (x, y) = (0, 0)). $
  Probar que $f(x, c')$ es continua para todo $c' in RR$, pero $f$ no es continua como función de dos variables.
]

#resolucion[
  Vemos que $f(x, c')$ es continua para todo $c' in RR$: por ejemplo $f(x, 1) = frac(x, x^2 + 1)$, y $f(x, 0) = 0$ es ciertamente continua. Pero $f$ no es continua como función de dos variables: encontramos que
  $ f(x, x) = cases(display(frac(x^2, x^2 + x^2)) = 1 slash 2 &"si " x != 0, 0 &"si " x = 0), $
  así que vemos que $f$ no es continua aplicándola a la sucesión $(1, 1), (1 slash 2, 1 slash 2), (1 slash 3, 1 slash 3), dots in RR^2$ (que converge a $(0, 0)$ mientras $f$ vale constantemente $1 slash 2$ y $f(0, 0) = 0$). Mirando el gráfico se ve el problema en el origen.

  _Nota_: es la función $f$ de O14-1, resuelta ahora con el Teo. 5.7 del apunte (una sola sucesión) en vez de con límites direccionales. El Ej. 9.5 de la fuente (pág. 69) pide además un abierto $V subset.eq RR$ con $f^(-1)(V)$ no abierto en $RR^2$, notando que su intersección con cada recta ${c} times RR$ o $RR times {c'}$ sí es abierta en la recta (indicación: pasar a polares y usar $sin(2 theta)$). El Ej. 1 (b) de la Práctica 4 se ataca igual: restringir a curvas $y = lambda x$ o $x = 1$ que lleven al origen.

  _Fuente_: N. Addington, _A Course in Metric Spaces and Point-Set Topology_ (Math 431, Univ. of Oregon), Example 9.6, págs. 67--68; Exercises 9.4 y 9.5, págs. 68--69. #link("https://pages.uoregon.edu/adding/courses/431/431notes.pdf")[URL]. Acceso: página del docente en la Univ. of Oregon; sin licencia explícita.
]

// ---- O14-1  |  p4: Ej. 1 (b)  |  teoría: Teo. 5.7, Teo. 5.9; falta: carácter local de la continuidad, álgebra de funciones continuas, límite funcional y regla de cambio de variable  |  nivel: alta
#ejemplo[Tres campos escalares en el origen: límites direccionales, acotación y cambio de variable (Payá, Resueltos P1, Ej. 1)][O14-1][
  Estudiar la continuidad de los campos escalares definidos por
  $
    f(x, y) = frac(x y, x^2 + y^2), quad
    g(x, y) = frac(x^2 y, x^2 + y^4), quad
    h(x, y) = frac(x y^2, x^2 + y^4)
  $
  para todo $(x, y) in RR^2 without {(0, 0)}$, con $f(0, 0) = g(0, 0) = h(0, 0) = 0$.
]

#resolucion[
  Estudiamos en paralelo las tres funciones, pues así se van presentando todas las situaciones posibles.

  *1.1. Continuidad salvo en el origen.* El conjunto ${(0, 0)}$, con un solo punto, es cerrado, luego $U = RR^2 without {(0, 0)}$ es abierto. Las restricciones de $f, g, h$ a $U$ son funciones racionales, luego son continuas. Por el carácter local de la continuidad, las tres funciones son continuas en todo punto de $U$. Sólo queda estudiar su comportamiento en el origen.

  *1.2. Límites parciales en el origen.* Para cualesquiera $x, y in RR$ se tiene claramente
  $ f(x, 0) = g(x, 0) = h(x, 0) = 0 quad "y" quad f(0, y) = g(0, y) = h(0, y) = 0, $
  de donde $lim_(x -> 0) f(x, 0) = lim_(y -> 0) f(0, y) = 0$, y lo mismo ocurre con $g$ y $h$. Por tanto, $0$ es el único posible límite en el origen de las tres funciones.

  *1.3.a. Límites direccionales en coordenadas cartesianas.* Para $lambda in RR$ y $x in RR without {0}$ se tiene
  $ lim_(x -> 0) f(x, lambda x) = lim_(x -> 0) frac(lambda x^2, (1 + lambda^2) x^2) = frac(lambda, 1 + lambda^2), $
  luego existen todos los límites direccionales de $f$ en el origen, pero no coinciden: para $lambda = 1$ el límite direccional es $1 slash 2$, pero es $0$ para $lambda = 0$. Por tanto, $f$ no tiene límite en el origen. El estudio de $f$ está concluido: es continua en todo punto de $RR^2 without {(0, 0)}$ y no tiene límite, luego no es continua, en el origen.

  Para $g$ y $h$, con $lambda in RR$ y $x in RR without {0}$,
  $ g(x, lambda x) = frac(lambda x, 1 + lambda^4 x^2) quad "y" quad h(x, lambda x) = frac(lambda^2 x, 1 + lambda^4 x^2), $
  de donde $lim_(x -> 0) g(x, lambda x) = lim_(x -> 0) h(x, lambda x) = 0$ para todo $lambda in RR$: los límites direccionales no dan nueva información.

  *1.3.b. Límites radiales en coordenadas polares.* Llegaríamos a lo mismo con otra notación. Para $rho > 0$ y $theta in RR$,
  $ f(rho cos theta, rho sin theta) = frac(rho^2 cos theta sin theta, rho^2), quad "luego" quad lim_(rho -> 0) f(rho cos theta, rho sin theta) = cos theta sin theta. $
  Existen todos los límites radiales de $f$ en el origen, pero no coinciden (para $theta = 0$ vale $0$ y para $theta = pi slash 4$ vale $1 slash 2$): $f$ no tiene límite en el origen. En cuanto a $g$ y $h$,
  $
    g(rho cos theta, rho sin theta) = frac(rho cos^2 theta sin theta, cos^2 theta + rho^2 sin^4 theta)
    quad "y" quad
    h(rho cos theta, rho sin theta) = frac(rho cos theta sin^2 theta, cos^2 theta + rho^2 sin^4 theta),
  $
  y ambos tienden a $0$ cuando $rho -> 0$, para todo $theta$: existen todos los límites radiales de $g$ y $h$ y coinciden.

  *1.4. Una acotación.* Para $(x, y) != (0, 0)$ se tiene claramente
  $ abs(g(x, y)) = frac(x^2 abs(y), x^2 + y^4) <= abs(y), $
  de donde $lim_((x, y) -> (0, 0)) g(x, y) = 0$. Por tanto $g$ es continua en todo punto de $RR^2$. Nótese que el estudio de los límites radiales y direccionales de $g$ no era necesario: la acotación da directamente la existencia del límite. Una acotación similar se podría haber adivinado, de forma más mecánica, a partir del cálculo en polares: para todo $rho > 0$ y $theta in RR$,
  $
    abs(g(rho cos theta, rho sin theta)) = frac(rho abs(sin theta) cos^2 theta, cos^2 theta + rho^2 sin^4 theta)
    <= rho frac(cos^2 theta, cos^2 theta + rho^2 sin^4 theta) <= rho .
  $
  Es decir, tomando $k(rho) = rho$ se tiene $abs(g(rho cos theta, rho sin theta)) <= k(rho)$ para todo $theta$ y todo $rho > 0$, con $lim_(rho -> 0) k(rho) = 0$, de donde el límite de $g$ en el origen es $0$. Un intento de acotación análogo para $h$ no daría resultado.

  *1.5. Un último cambio de variable.* En la definición de $h$ el exponente de $y$, tanto en el numerador como en el denominador, es el doble que el de $x$. Ello sugiere igualarlos mediante $x = y^2$, es decir, el cambio de variable $(x, y) = (t^2, t)$ con $t in RR$, teniendo en cuenta que $(x, y) -> (0, 0)$ cuando $t -> 0$ y $(x, y) != (0, 0)$ para $t != 0$. Puesto que
  $ lim_(t -> 0) h(t^2, t) = lim_(t -> 0) frac(t^4, 2 t^4) = 1 slash 2, $
  la regla de cambio de variable dice que $1 slash 2$ es el único posible límite de $h$ en el origen. Pero sabíamos desde el principio que dicho límite sólo podía ser $0$, así que $h$ no tiene límite, luego no es continua, en el origen. (Esta conclusión se podía obtener conociendo un solo límite parcial de $h$, sin estudiar los direccionales.)

  *En resumen:* $g$ es continua en todo $RR^2$, mientras que $f$ y $h$ son continuas en $RR^2 without {(0, 0)}$ pero no en el origen.

  _Nota_: la fuente escribe en 1.4 "$g(rho cos theta, rho sin theta) <= rho$" sin valor absoluto en el primer miembro; se agregó $abs(dot)$ porque el argumento acota el módulo. Con la "regla de cambio de variable" la fuente se refiere a su resultado de la sección 3.4 de Apuntes_03 (ver O14-4): si $phi(t) -> alpha$ con $phi(t) != alpha$ y $f$ tiene límite $L$ en $alpha$, entonces $f compose phi$ tiene límite $L$. El vocabulario de "límites parciales, direccionales y radiales" es el de esa fuente; en el apunte se puede reemplazar todo por la caracterización por sucesiones (Teo. 5.7): tomar $(x_n, y_n) = (1 slash n, lambda slash n)$ o $(1 slash n^2, 1 slash n)$.

  _Fuente_: R. Payá Albert, _Análisis Matemático I_ (Univ. de Granada, curso 2024-25), "Práctica 1. Continuidad. Ejercicios resueltos", Ejercicio 1, págs. 1--3 del PDF. #link("https://www.ugr.es/~rpaya/documentos/AnalisisI/2024_25/Resueltos_P1.pdf")[URL]. Acceso: publicado por el docente en su web de la UGR; sin licencia explícita.
]

// ---- O14-2  |  p4: Ej. 1 (b)  |  teoría: Teo. 5.7, Teo. 5.9 (cerrado como preimagen de {0}); falta: carácter local, álgebra de continuas, cambio de variable  |  nivel: alta
#ejemplo[Continua exactamente fuera de la recta $x + y = 0$ (Payá, Resueltos P1, Ej. 2)][O14-2][
  Estudiar la continuidad de $f : RR^2 -> RR$ dada por
  $ f(x, y) = cases(display(frac((x^2 + y^2) sin(x + y), (x + y)^2)) &"si " x + y != 0, 0 &"si " x + y = 0). $
]

#resolucion[
  *2.a.* Tomando $U = RR^2 without A$, donde $A = {(x, y) in RR^2 : x + y = 0}$, comprobamos que $f$ es continua en $U$. El conjunto $A$ es cerrado como imagen inversa de ${0}$ por una función polinómica, que es continua, luego $U$ es abierto. La restricción de $f$ a $U$ es el producto de una función racional por $(x, y) |-> sin(x + y)$, composición de una polinómica con el seno; por tanto $f|_U$ es continua, como producto de dos continuas. Por el carácter local de la continuidad, $f$ es continua en todo punto de $U$.

  *2.b.* Sea $(a, -a) in A$ con $a != 0$. Para $x in RR without {a}$ se tiene
  $ f(x, -a) = frac(x^2 + a^2, x - a) dot frac(sin(x - a), x - a). $
  Sea $(x_n)_(n in NN)$ una sucesión de puntos de $RR without {a}$ con $x_n -> a$. De $lim_(t -> 0) frac(sin t, t) = 1$ deducimos que $lim_(n -> oo) frac(sin(x_n - a), x_n - a) = 1$. Por otra parte $x_n^2 + a^2 -> 2 a^2 != 0$, luego la sucesión $(x_n^2 + a^2) slash (x_n - a)$ diverge, y deducimos que $f(x_n, -a)$ también diverge. Por tanto no existe el primer límite parcial de $f$ en $(a, -a)$: $f$ no tiene límite, luego no es continua, en ningún punto de $A$ distinto del origen.

  *2.c.* Para el origen, el razonamiento anterior sugiere que, si $(x, y)$ se acerca al origen de forma que $x + y$ tienda a cero más rápido que $x^2 + y^2$, podemos conseguir que $f(x, y)$ sea tan grande como queramos. Hacemos el cambio de variable $(x, y) = phi(t) = (t, -t + t^3)$ con $t in RR$: $(x, y) -> (0, 0)$ cuando $t -> 0$, y $(x, y) != (0, 0)$ para $t != 0$. Además, para $t != 0$ tenemos $x + y = t^3 != 0$, con lo cual
  $ (f compose phi)(t) = f(t, -t + t^3) = frac(2 - 2 t^2 + t^4, t) dot frac(sin t^3, t^3). $
  Como $lim_(t -> 0) sin(t^3) slash t^3 = 1$, vemos que $f compose phi$ diverge en $0$. La regla de cambio de variable nos dice que $f$ no tiene límite, luego no es continua, en el origen.

  *En resumen:* $f$ es continua en $(a, b) in RR^2$ si, y sólo si, $a + b != 0$.

  _Fuente_: R. Payá Albert, _Análisis Matemático I_ (UGR, 2024-25), "Práctica 1. Continuidad. Ejercicios resueltos", Ejercicio 2, págs. 3--4 del PDF. #link("https://www.ugr.es/~rpaya/documentos/AnalisisI/2024_25/Resueltos_P1.pdf")[URL]. Acceso: web del docente en la UGR; sin licencia explícita.
]

// ---- O14-3  |  p4: Ej. 1 (b)  |  teoría: Teo. 5.7; falta: carácter local, álgebra de continuas, límite de un producto  |  nivel: alta
#ejemplo[Continuidad en el origen con una función auxiliar y una acotación (Payá, Resueltos P1, Ej. 3)][O14-3][
  Estudiar la continuidad del campo escalar $f : RR^2 -> RR$ definido por
  $ f(x, y) = cases(display(frac(y log(1 + x^2), x^2 + y^2)) &"si " (x, y) != (0, 0), 0 &"si " x = y = 0). $
]

#resolucion[
  *3.a.* La restricción de $f$ a $U = RR^2 without {(0, 0)}$ es el producto de una función racional por $(x, y) |-> log(1 + x^2)$, composición de una polinómica con valores en $(0, +oo)$ con el logaritmo, continuo en $(0, +oo)$. Luego $f|_U$ es continua y, como $U$ es abierto, el carácter local de la continuidad dice que $f$ es continua en todo punto de $U$.

  *3.b.* Para el origen, recordamos que $lim_(x -> 0) frac(log(1 + x^2), x^2) = 1$, luego la función $phi : RR -> RR$ definida por
  $ phi(x) = frac(log(1 + x^2), x^2) quad (x != 0), quad phi(0) = 1 $
  es continua en el origen. Por definición de $phi$ se tiene $log(1 + x^2) = x^2 phi(x)$ para todo $x != 0$, igualdad obvia también para $x = 0$. Esto permite escribir
  $ f(x, y) = frac(y x^2, x^2 + y^2) dot phi(x) quad forall (x, y) in RR^2 without {(0, 0)}, #h(2em) (1) $
  y ya sabemos que
  $ lim_((x, y) -> (0, 0)) phi(x) = phi(0) = 1. #h(2em) (2) $
  Por otra parte, claramente
  $ abs(frac(x^2 y, x^2 + y^2)) <= abs(y) quad forall (x, y) in RR^2 without {(0, 0)}, $
  de donde
  $ lim_((x, y) -> (0, 0)) frac(x^2 y, x^2 + y^2) = 0. #h(2em) (3) $
  En vista de (1), (2) y (3), $lim_((x, y) -> (0, 0)) f(x, y) = 0 = f(0, 0)$, luego $f$ es continua en el origen.

  *En resumen:* $f$ es continua en todo punto de $RR^2$.

  _Fuente_: R. Payá Albert, _Análisis Matemático I_ (UGR, 2024-25), "Práctica 1. Continuidad. Ejercicios resueltos", Ejercicio 3, págs. 4--5 del PDF. #link("https://www.ugr.es/~rpaya/documentos/AnalisisI/2024_25/Resueltos_P1.pdf")[URL]. Acceso: web del docente en la UGR; sin licencia explícita.
]


== Bloque 3 · La continuidad depende de las métricas: discreta, identidad, funciones abiertas y cerradas

#sublema(titulo: "Qué desbloquea")[
  Qué cambia al cambiar la métrica. Desde un espacio discreto toda función es continua, y hacia un discreto casi ninguna lo es (*Ejercicio 1 (c), (d)*). Y la otra cara de la Obs. 5.12: continua no implica abierta ni cerrada, y abierta no implica continua (*Ejercicio 6*).
]

// ---- O10-1  |  p4: Ej. 1 (c)  |  teoría: Def. 5.4, métrica discreta, Obs. "la continuidad depende de las métricas"; Ejemplo 5.17 (desde un discreto toda función es incluso uniformemente continua)  |  nivel: alta
#ejemplo[Toda función que sale de un espacio con la métrica discreta es continua (Karageorgis, T3--2)][O10-1][
  Sean $X, Y$ espacios métricos y supongamos que la métrica de $X$ es la discreta. Probar que toda función $f : X -> Y$ es continua.
]

#resolucion[
  Para ver que $f$ es continua en $x$, sea $epsilon > 0$ y tomemos $delta = 1$. Entonces
  $ d_X (x, y) < delta ==> x = y ==> d_Y (f(x), f(y)) = d_Y (f(x), f(x)) = 0 < epsilon. $
  #align(right)[$square$]

  _Nota_: el apunte ya tiene el caso $op("id") : (RR, delta) -> (RR, abs(dot))$ en la observación posterior a la Def. 5.4 (con $delta = 1 \/ 2$); esto es la versión general, que resuelve p4 Ej. 1 (c) y muestra que la respuesta no depende de la métrica de llegada. Para p4 Ej. 1 (d) sirve el contraejemplo de esa observación. La fuente también resuelve (T3--3, pág. 4) que toda función constante es continua, con $delta$ arbitrario.

  _Fuente_: P. Karageorgis, _MA2223 -- Tutorial solutions, Part 1. Metric spaces_ (Trinity College Dublin), T3--2, pág. 4 del PDF. #link("https://www.maths.tcd.ie/~pete/ma2223/tut_sol1.pdf")[URL]. Acceso: publicado en la web del docente en la School of Mathematics del TCD; sin licencia explícita. El enunciado "toda función $f : X -> Y$ es continua si $d_X$ es discreta" está también en _Chapter 1. Metric spaces_, diapositiva 10/20 (#link("https://www.maths.tcd.ie/~pete/ma2223/chapter1.pdf")[URL]).
]

// ---- O15-3  |  p4: Ej. 1 (c)(d), 6  |  teoría: métrica discreta, Teo. 5.9, Obs. 5.12, Def. 5.29 y Ejemplo 5.30 b) (homeomorfismo)  |  nivel: alta
#ejemplo[Identidad entre la métrica discreta y la usual: continua pero no abierta, abierta pero no continua (Körner, Ej. 3.10)][O15-3][
  Sea $X = RR$ con la métrica discreta $d$ y $Y = RR$ con la métrica usual $rho$.
  + Si $f : X -> Y$ es $f(x) = x$, entonces $f$ es continua pero existen abiertos $U$ de $X$ tales que $f(U)$ no es abierto.
  + Si $g : Y -> X$ es $g(y) = y$, entonces $g$ no es continua pero $g(V)$ es abierto en $X$ para todo abierto $V$ de $Y$.
]

#resolucion[
  Como todo subconjunto de $X$ es abierto, $f^(-1)(V) = g(V)$ es abierto para todo $V subset.eq Y$ y, en particular, para todo abierto $V$. Luego $f$ es continua (y $g$ manda abiertos en abiertos).

  Observamos que $U = {0}$ es abierto en $X$ y $g^(-1)(U) = f(U) = U = {0}$ no es abierto en $Y$. Luego $g$ no es continua (y $f$ no manda abiertos en abiertos).

  _Nota_: el apunte ya observa que $op("id") : (RR^2, delta) -> (RR^2, d_2)$ es continua y la inversa no; lo nuevo acá es el contraste "continua $arrow.r.double.not$ abierta" y "abierta $arrow.r.double.not$ continua" (Körner: "el teorema de preimágenes no funciona en la dirección opuesta"), que es el Ej. 6 de la Práctica 4 en versión discreta. Körner lo refuerza con el Ej. 15.4 (pág. 38): $sin$ es continua con $U = RR$ abierto y $sin(U) = [-1, 1]$ no abierto.

  _Nota del transcriptor_: el par $f$, $g = f^(-1)$ es el del Ejemplo 5.30 b) del curso (en `ejemplos/p4.typ`): $f$ es continua y biyectiva pero no es un homeomorfismo (Definición 5.29). Las dos mitades de este ítem son la misma afirmación vista de dos lados: para una biyección vale $f(U) = (f^(-1))^(-1)(U)$, así que $f$ es abierta si y sólo si $f^(-1)$ es continua.

  _Fuente_: T. W. Körner, _Metric and Topological Spaces_ (DPMMS, Cambridge, 2021), Example 3.10, pág. 10, demostración págs. 63--64. #link("https://www.dpmms.cam.ac.uk/~twk10/Top.pdf")[URL]. Acceso: página personal del autor; sin licencia explícita.
]

// ---- O2-4  |  p4: Ej. 1 (c) (d), 6  |  teoría: Def. 5.4 (observación: identidad con la discreta), Teo. 5.9, Ej. 5.10, Def. 5.29 y Ejemplo 5.30 b) (homeomorfismo), bolas de $X times Y$ con $d_infinity$  |  nivel: alta
#ejemplo[Las proyecciones son abiertas pero no cerradas; continua y biyectiva no implica homeomorfismo (Guccione, Obs. 3.27 y Ejemplos 3.29)][O2-4][
  Una función $f : X -> Z$ es _abierta_ si $f(U)$ es abierto para todo abierto $U$ de $X$, y es _cerrada_ si $f(C)$ es cerrado para todo cerrado $C$ de $X$ (Definición 3.28 de la fuente).

  + (Observación 3.27) Una función $f : X -> Y$ puede ser continua y biyectiva sin que su inversa sea continua. Un ejemplo es la función identidad $op("id") : (RR, delta) -> (RR, d)$, donde $delta$ es la métrica discreta y el codominio se considera con la métrica usual.
  + (Ejemplos 3.29) Para cada par $X$, $Y$ de espacios métricos, las proyecciones canónicas $p_X : X times Y -> X$ y $p_Y : X times Y -> Y$ (con $d_infinity$ en el producto) son funciones abiertas, pero en general no son cerradas.
]

#resolucion[
  Para el item 1: $op("id") : (RR, delta) -> (RR, d)$ es continua porque en la métrica discreta todo conjunto es abierto, así que la preimagen de cualquier abierto es abierta; su inversa $op("id") : (RR, d) -> (RR, delta)$ no es continua, porque la preimagen del abierto ${0}$ de $(RR, delta)$ es ${0}$, que no es abierto en $(RR, d)$. (Este es el mismo par de funciones del Ej. 1 (c) y (d) de la Práctica 4; la fuente sólo enuncia la observación.)

  Para el item 2: las proyecciones son abiertas porque
  $ p_X (B^(X times Y)((x, y), r)) = p_X (B^X (x, r) times B^Y (y, r)) = B^X (x, r) $
  y
  $ p_Y (B^(X times Y)((x, y), r)) = p_Y (B^X (x, r) times B^Y (y, r)) = B^Y (y, r) $
  para todo $r > 0$ y cada $(x, y) in X times Y$. En general estas funciones no son cerradas. Por ejemplo, el conjunto
  $ {(x, y) in RR^2 : x > 0 "e" y = 1 / x} $
  es un subconjunto cerrado de $RR^2$ cuya proyección a la primera coordenada es el conjunto $(0, infinity)$, que no es cerrado. Otro ejemplo de una función abierta que en general no es cerrada es la inclusión canónica $i_Y : Y -> X$ de un subconjunto abierto $Y$ de $X$ en $X$. En cambio, si $Y$ es cerrado, entonces $i_Y$ es una función cerrada, que en general no es abierta.

  _Nota_: que $p_X (B^X (x, r) times B^Y (y, r)) = B^X (x, r)$ usa que en $X times Y$ con $d_infinity$ las bolas son productos de bolas (Ejemplo 1.25 de la fuente; en el curso, ejemplo C6-1). Para ver que la imagen de un abierto $U$ es abierta basta con esto: si $(x, y) in U$, alguna bola $B((x, y), r) subset.eq U$ y entonces $B(x, r) = p_X (B((x, y), r)) subset.eq p_X (U)$. La fuente también deja como Ejercicio 3.30 (sin resolución) encontrar funciones $f_1, dots, f_8$ entre espacios métricos que realicen las ocho combinaciones posibles de "continua / abierta / cerrada" (por ejemplo, $f_2$ continua pero ni abierta ni cerrada; $f_5$ continua y abierta pero no cerrada; $f_7$ abierta y cerrada pero no continua). Es un buen complemento del Ej. 6 de la Práctica 4 y de la Obs. 5.12 de `apuntes.typ`.

  _Nota del transcriptor_: el ítem 1 es el Ejemplo 5.30 b) del curso (en `ejemplos/p4.typ`): $op("id") : (RR, delta) -> (RR, abs(dot))$ es continua y biyectiva pero no es un homeomorfismo (Definición 5.29), porque su inversa no es continua. Allí se prueba con la sucesión $x + 1\/n$ y el Teorema 5.7; acá, con la preimagen del abierto ${0}$ y el Teorema 5.9.

  _Fuente_: J. A. Guccione y J. J. Guccione, _Espacios Métricos_ (FCEN-UBA, 2017), Observación 3.27, Definición 3.28, Ejemplos 3.29 y Ejercicio 3.30, págs. 68–69 del PDF (59–60 del apunte). #link("https://cms.dm.uba.ar/academico/materias/2docuat2018/calculo_avanzado/2017/apunte.pdf")[URL]. Acceso: web de la materia; copia permitida sin fines de lucro (ver portada).
]

// ---- O11-2  |  p4: Ej. 6  |  teoría: Obs. 5.12, abiertos relativos  |  nivel: alta
#ejemplo[$abs(x)$ en $[-1, 1]$ manda un abierto a un no abierto (BUAP, Ej. 5.13)][O11-2][
  Sea $f : [-1, 1] -> RR$ definida por $f(x) = d_RR (x, 0) = abs(x)$. Mostrar que $f$ es continua pero que manda un abierto de $[-1, 1]$ en un conjunto que no es abierto de $RR$.
]

#resolucion[
  Por el Lema 5.8 de la fuente (no transcripto; la misma cuenta está en O7-1, con $a = 0$), $f$ es continua en $[-1, 1]$. Notemos que $(-1, 1)$ es abierto de $[-1, 1]$ y que $f((-1, 1)) = [0, 1)$. Como $[0, 1)$ no es abierto de $RR$, éste es un ejemplo de que una función continua no envía abiertos en abiertos.

  _Nota_: el apunte (Obs. 5.12) usa $x^2 : RR -> RR$ y $e^x$ para la misma moraleja; acá el ejemplo es distinto porque el dominio es el subespacio $[-1, 1]$ y el abierto $(-1, 1)$ lo es _en el subespacio_. De hecho $(-1, 1)$ también es abierto de $RR$, así que el ejemplo funciona igual mirando $f$ como la restricción de $abs(dot)$.

  _Fuente_: D. Herrera Carrasco, F. Macías Romero y L. A. Guerrero Méndez, _La magia de los espacios métricos_ (FCFM, BUAP, 2025), Ejemplo 5.13, pág. 124 del libro (133 del PDF). #link("https://www.fcfm.buap.mx/assets/docs/publicaciones/La_magia_de_los_espacios_metricos.pdf")[URL]. Acceso: "DR © Benemérita Universidad Autónoma de Puebla", ISBN 978-607-2637-10-8; sin licencia Creative Commons explícita.
]

// ---- O7-3  |  p4: Ej. 6  |  teoría: Def. 5.1, Teo. 5.9, Obs. 5.12  |  nivel: alta
#ejemplo[Preimágenes de intervalos por $x^2$ son abiertas, pero la imagen de $(-1, 1)$ no lo es (Tyson, Ej. 3.20 y comentario al Teo. 3.21)][O7-3][
  Sea $g : RR -> RR$, $g(x) = x^2$. Calcular $g^(-1)(V)$ para distintos intervalos abiertos $V = (a, b)$, y comparar con la imagen $g((-1, 1))$.
]

#resolucion[
  Si $V = (a, b)$ con $a > 0$, entonces
  $ g^(-1)(V) = {x in RR : x^2 in (a, b)} = (-sqrt(b), -sqrt(a)) union (sqrt(a), sqrt(b)). $
  Análogamente, si $V = (0, b)$, entonces $g^(-1)(V) = (-sqrt(b), 0) union (0, sqrt(b))$. Si $V = (a, b)$ con $a < 0 < b$, entonces $g^(-1)(V) = (-sqrt(b), sqrt(b))$. Finalmente, si $V = (a, b)$ con $b <= 0$, entonces $g^(-1)(V) = emptyset$.

  Todas las preimágenes calculadas son abiertas en $RR$. De hecho, como todo abierto de $RR$ es unión de intervalos abiertos, este cálculo muestra que la preimagen de todo abierto es abierta, en acuerdo con el Teorema 3.21 de la fuente (Teo. 5.9 del apunte) y con la continuidad de $x^2$. "Por otro lado, $g((-1, 1)) = {x^2 : -1 < x < 1} = [0, 1)$ no es un conjunto abierto en $RR$. Por eso es importante que en el Teorema 3.21 se consideren preimágenes y no imágenes." #align(right)[$square$]

  _Nota_: resuelve la primera mitad de p4 Ej. 6 con el abierto concreto $(-1, 1)$, y de paso ilustra la Obs. 5.12. La fuente deja la verificación de las igualdades como Ejercicio 3.E.

  _Fuente_: J. Tyson, _MATH 424 Lecture notes: Functions_ (UIUC, 2026), Ejemplo 3.20 y comentario posterior al Teorema 3.21, pág. 4 del PDF. #link("http://publish.illinois.edu/jeremy-tyson/files/2026/05/functions.pdf")[URL]. Acceso: publicado en la web del docente; sin licencia explícita.
]

// ---- O17-4  |  p4: Ej. 1 (uso del Teo. 5.9 para probar discontinuidad), 6  |  teoría: Teo. 5.9  |  nivel: alta
#ejemplo[Discontinuidad vista en una preimagen: $f(x) = x^2$ salvo $f(0) = 1$ (Addington, Ejemplo 6.7)][O17-4][
  Sea $f : RR -> RR$ definida por $f(x) = x^2$ si $x != 0$ y $f(0) = 1$. No es continua con la métrica usual, así que debería existir un abierto $V subset.eq RR$ tal que $f^(-1)(V)$ no es abierto. Encontrarlo.
]

#resolucion[
  Tras algunos intentos, podemos dar con $V = (1 slash 2, 3 slash 2)$. Para entender la preimagen visualmente, tomamos la franja horizontal $1 slash 2 < y < 3 slash 2$ y la intersecamos con el gráfico: quedan dos arcos y un punto aislado. Proyectándolos sobre el eje $x$ quedan dos intervalos abiertos y un punto aislado:
  $ f^(-1)(V) = (-sqrt(3 slash 2), -sqrt(1 slash 2)) union {0} union (sqrt(1 slash 2), sqrt(3 slash 2)), $
  que no es abierto: el problema está en $x = 0$, que es exactamente el punto donde $f$ deja de ser continua.

  _Nota_: la fuente escribe el tercer intervalo como "$(sqrt(3 slash 2), sqrt(1 slash 2))$" (extremos invertidos); es una errata. A continuación (pág. 50) la fuente recuerda, como el apunte en Obs. 5.12, que continua no implica abierta ($f(x) = x^2$ manda $(-1, 2)$ en $[0, 4)$, Ejemplo 6.2 (c)) ni cerrada (la proyección $(x, y) |-> x$ manda la hipérbola cerrada en una semirrecta abierta $(x, +oo)$, Ejemplo 6.4 (a)); y el Ej. 6.8 (pág. 52) pide ejemplos de: continua no abierta, abierta no continua, ambas, ninguna (sin solución). El Ej. 6.5 (pág. 51) es el mismo juego con $f(x) = x$ para $x <= 0$, $x + 1$ para $x > 0$.

  _Fuente_: N. Addington, _A Course in Metric Spaces and Point-Set Topology_ (Math 431, Univ. of Oregon), Example 6.7, pág. 49; Exercises 6.5 y 6.8, págs. 51--52. #link("https://pages.uoregon.edu/adding/courses/431/431notes.pdf")[URL]. Acceso: página del docente en la Univ. of Oregon; sin licencia explícita.
]


== Bloque 4 · Funciones definidas distinto en $QQ$ y en $RR without QQ$

#sublema(titulo: "Qué desbloquea")[
  Funciones que valen una cosa en los racionales y otra en los irracionales. La densidad de $QQ$ y de $RR without QQ$ da las sucesiones para negar continuidad, y una cota del tipo $abs(f(x)) <= abs(x)$ da la continuidad en el único punto bueno (*Ejercicio 2*).
]

// ---- O6-2  |  p4: Ej. 2  |  teoría: Teo. 5.7, densidad de QQ y de RR without QQ (Prop. 2, Def. 5.20, Ejemplo 5.21)  |  nivel: alta
#ejemplo[La función de Dirichlet es discontinua en todo punto (Lebl, Ej. 3.2.11)][O6-2][
  Sea $f : RR -> RR$ la función
  $ f(x) = cases(1 &"si " x in QQ, 0 &"si " x in.not QQ). $
  Entonces $f$ es discontinua en todo $c in RR$.
]

#resolucion[
  Si $c in QQ$, tomamos una sucesión $(x_n)_(n in NN)$ de números irracionales tal que $lim_(n -> infinity) x_n = c$ (¿por qué podemos?). Entonces $f(x_n) = 0$, luego $lim_(n -> infinity) f(x_n) = 0$, pero $f(c) = 1$. Si $c$ es irracional, tomamos una sucesión $(x_n)_(n in NN)$ de números racionales que converge a $c$ (¿por qué podemos?). Entonces $lim_(n -> infinity) f(x_n) = 1$, pero $f(c) = 0$. #align(right)[$square$]

  _Nota_: la fuente escribe que las sucesiones se toman "en $(0, 1)$", lo cual sólo tiene sentido si $c in [0, 1]$; es un resto de una versión anterior del ejemplo (el siguiente, Ej. 3.2.12, sí está definido en $(0, 1)$). Lo correcto es tomar las sucesiones en $RR$, como arriba. El argumento usa la caracterización por sucesiones (Prop. 3.2.2 (iii) de la fuente, Teo. 5.7 del apunte) y la densidad de $QQ$ y de $RR without QQ$. Es el mismo esquema de dos sucesiones que pide p4 Ej. 2.

  _Fuente_: J. Lebl, _Basic Analysis I_, v6.3, Ejemplo 3.2.11, pág. 126 del PDF. #link("https://www.jirka.org/ra/realanal.pdf")[URL]. Acceso: CC BY-NC-SA 4.0 / CC BY-SA 4.0.
]

// ---- O16-3  |  p4: Ej. 2  |  teoría: Def. 5.4 (con bolas/entornos), densidad de Q y de R \ Q (Def. 5.20, Ejemplo 5.21)  |  nivel: alta
#ejemplo[$f(x) = x$ en $QQ$ y $f(x) = -x$ fuera de $QQ$: continua sólo en $0$ (Chavan, Ejemplo 8.13)][O16-3][
  Sea $f : RR -> RR$ dada por $f(x) = x$ si $x in QQ$ y $f(x) = -x$ si $x in RR without QQ$. Probar que $f$ es continua únicamente en $0$.
]

#resolucion[
  La fuente usa la definición: $f$ es continua en $x$ si para cada entorno $V_x$ de $f(x)$ existe un entorno $U_x$ de $x$ con $f(U_x) subset.eq V_x$.

  Primero, todo entorno $V_0$ de $f(0) = 0$ contiene un intervalo $(-epsilon, epsilon)$ para algún $epsilon > 0$. Entonces $U_0 = (-epsilon, epsilon)$ satisface $f(U_0) subset.eq (-epsilon, epsilon) subset.eq V_0$. Luego $f$ es continua en $0$.

  Si $x > 0$, para $V_x = (x slash 2, 3 x slash 2) subset.eq (0, +oo)$ no hay ningún entorno $U_x$ de $x$ con $f(U_x) subset.eq V_x$, puesto que $f(U_x)$ siempre contiene números negativos. Análogamente se ve que $f$ no es continua en $x < 0$.

  _Nota_: "siempre contiene negativos" porque todo entorno de $x > 0$ contiene irracionales $y > 0$, y $f(y) = -y < 0$. El Ej. 2 de la Práctica 4 ($f = x$ en $QQ$, $0$ fuera) se hace igual: la única diferencia es que en $x != 0$ el entorno $V_x$ debe excluir al $0$ y a $x$ simultáneamente, p. ej. $V_x = (x slash 2, 3 x slash 2)$ sirve también.

  _Fuente_: S. Chavan, _MTH304 Topology: notes and problems_ (IIT Kanpur), Example 8.13, págs. 13--14. #link("https://home.iitk.ac.in/~chavan/topology_mth304.pdf")[URL]. Acceso: página del docente en IIT Kanpur; sin licencia explícita.
]

// ---- O7-6  |  p4: Ej. 2  |  teoría: Def. 5.4, Teo. 5.7, Def. 5.20 (denso), Ejemplo 5.21  |  nivel: alta
#ejemplo[$x^2$ en los racionales y $0$ en los irracionales: continua sólo en $0$ (Tyson, Ejerc. 3.10)][O7-6][
  Sea $f : RR -> RR$ la función
  $ f(x) = cases(x^2 &"si " x in QQ, 0 &"si " x in.not QQ). $
  #set enum(numbering: "a)")
  + Probar, usando la definición $epsilon$--$delta$, que $f$ es continua en $x_0 = 0$.
  + Probar que $f$ no es continua en ningún punto $x_0 != 0$.

  _Nota_: la fuente sólo enuncia el ejercicio. Es p4 Ej. 2 con $x^2$ en lugar de $x$; el esquema de dos sucesiones de O6-2 resuelve b). La fuente propone también (Ejerc. 3.5 (d), pág. 18) la función de Thomae, continua exactamente en los irracionales, que Lebl resuelve en su Ejemplo 3.2.12 (págs. 126--127).

  _Fuente_: J. Tyson, _MATH 424 Lecture notes: Functions_ (UIUC, 2026), Ejercicio 3.10, pág. 18 del PDF. #link("http://publish.illinois.edu/jeremy-tyson/files/2026/05/functions.pdf")[URL]. Acceso: publicado en la web del docente; sin licencia explícita.
]


== Bloque 5 · Conjuntos definidos por igualdades y desigualdades: preimágenes

#sublema(titulo: "Qué desbloquea")[
  Para ver que un conjunto definido por igualdades o desigualdades es abierto o cerrado, se lo escribe como preimagen de un abierto o de un cerrado de $RR$ por una función continua (Teo. 5.9 y Ej. 5.10). Es la técnica de los *Ejercicios 3, 4 y 5*.
]

// ---- O6-4  |  p4: Ej. 3, 4, 5  |  teoría: Teo. 5.9, Ej. 5.10  |  nivel: alta
#ejemplo[Conjunto de ceros, ${f >= 0}$ y ${f > 0}$ de una función continua (Lebl, Ej. 7.5.9)][O6-4][
  Sea $f : X -> Y$ continua. Si $E subset.eq Y$ es cerrado, entonces $f^(-1)(E)$ es cerrado. En particular, si $f : X -> RR$ es continua, el conjunto de ceros $f^(-1)({0}) = {x in X : f(x) = 0}$ es cerrado, el conjunto $f^(-1)([0, infinity)) = {x in X : f(x) >= 0}$ es cerrado y el conjunto $f^(-1)((0, infinity)) = {x in X : f(x) > 0}$ es abierto.
]

#resolucion[
  El Teorema 7.5.8 de la fuente ($f$ es continua si y sólo si $f^(-1)(U)$ es abierto para todo $U subset.eq Y$ abierto; es el Teorema 5.9 del apunte) nos dice que, si $E subset.eq Y$ es cerrado, entonces
  $ f^(-1)(E) = X without f^(-1)(E^c) $
  también es cerrado, porque $E^c$ es abierto y la preimagen de un abierto es abierta. Por lo tanto, si $f : X -> RR$ es continua, el conjunto de ceros $f^(-1)({0})$ es cerrado. "Acabamos de probar el resultado más básico de la geometría algebraica, el estudio de los conjuntos de ceros de polinomios: el conjunto de ceros de un polinomio es cerrado." Del mismo modo, $[0, infinity)$ es cerrado en $RR$, así que ${x in X : f(x) >= 0}$ es cerrado; y $(0, infinity)$ es abierto, así que ${x in X : f(x) > 0}$ es abierto. #align(right)[$square$]

  _Nota_: el apunte ya tiene esta caracterización como Ejercicio 5.10; lo nuevo es el uso directo para p4 Ej. 5 (conjuntos de nivel, franjas, semiespacios) y para p4 Ej. 3 (${f > 0}$ abierto contiene una bola alrededor de cada punto). Para p4 Ej. 4, ${f = g}$ es el conjunto de ceros de $f - g$ cuando $E' = RR$; para $E'$ general hace falta otro argumento.

  _Fuente_: J. Lebl, _Basic Analysis I_, v6.3, Ejemplo 7.5.9, pág. 291 del PDF. #link("https://www.jirka.org/ra/realanal.pdf")[URL]. Acceso: CC BY-NC-SA 4.0 / CC BY-SA 4.0.
]

// ---- O10-2  |  p4: Ej. 5  |  teoría: Teo. 5.9, Def. 5.1  |  nivel: alta
#ejemplo[${x : abs(f(x)) < r}$ es abierto, como preimagen de $(-r, r)$ (Karageorgis, T3--1)][O10-2][
  Sean $(X, d)$ un espacio métrico y $f : X -> RR$ continua. Probar que $A = {x in X : abs(f(x)) < r}$ es abierto en $X$ para todo $r > 0$.
]

#resolucion[
  El conjunto dado se puede expresar como
  $ A = {x in X : -r < f(x) < r} = f^(-1)((-r, r)). $
  Como $(-r, r)$ es abierto en $RR$, su preimagen es abierta en $X$ por continuidad (Teorema 1.7 de la fuente: $f$ es continua si y sólo si $f^(-1)(U)$ es abierto en $X$ para todo $U$ abierto en $Y$; Teo. 5.9 del apunte). #align(right)[$square$]

  _Nota_: es el molde de p4 Ej. 5 para una franja $-1 <= dot <= 3$ (preimagen de un cerrado) o un semiespacio $3 < x_1 - x_2$ (preimagen de $(3, +infinity)$ por $(x_1, x_2) |-> x_1 - x_2$, continua por O6-3). La fuente trae también (T2--2 y T2--3, pág. 3) una bola disfrazada, ${(x, y) : x^2 + y^2 < 2 y} = B((0, 1), 1)$, y un conjunto ${x : x^3 + 2x^2 - 3x <= 0}$ cerrado, resuelto factorizando el polinomio y mirando el complemento (no vía preimágenes).

  _Fuente_: P. Karageorgis, _MA2223 -- Tutorial solutions, Part 1_ (TCD), T3--1, pág. 4 del PDF. #link("https://www.maths.tcd.ie/~pete/ma2223/tut_sol1.pdf")[URL]. Acceso: publicado en la web del docente; sin licencia explícita.
]

// ---- O4-5  |  p4: Ej. 4, 5  |  teoría: Def. 5.4, Teo. 5.9, Ej. 5.10; falta: álgebra de funciones continuas a valores reales  |  nivel: alta
#ejemplo[Combinaciones lineales de continuas; conjuntos ${f - g >= alpha}$ cerrados y ${f + g < beta}$ abiertos (Gajardo, Ej. resuelto E3)][O4-5][
  Considere un espacio métrico $(X, d)$ y dos funciones continuas $f, g : X -> RR$.
  #set enum(numbering: "a)")
  + Pruebe que para todo $lambda in RR$ se tiene que la función $h : X -> RR$, definida por $h(x) = f(x) + lambda g(x)$, $x in X$, es continua.
  + Para $alpha, beta in RR$ considere los siguientes subconjuntos de $X$:
    $
    A := {x in X : f(x) - g(x) >= alpha} quad "y" quad B := {x in X : f(x) + g(x) < beta}.
    $
    Demuestre que $A$ es cerrado y $B$ es abierto.
  + Para los mismos conjuntos $A$ y $B$ definidos en el punto anterior, pruebe que
    $
    {x in X : f(x) - g(x) > alpha} subset.eq A^circle.small quad "y" quad overline(B) subset.eq {x in X : f(x) + g(x) <= beta}.
    $
]

#resolucion[
  *a)* Si $lambda = 0$ el resultado es directo, pues la función $h = f + lambda g = f$ es continua de acuerdo al enunciado. Supongamos entonces $lambda != 0$. Sea $x in X$ y $epsilon > 0$. Como $f$ y $g$ son continuas en $x$, se tendrá que existen $delta_1, delta_2 > 0$ tales que
  $
  d(x, y) < delta_1 & => abs(f(x) - f(y)) < epsilon / 2, \
  d(x, y) < delta_2 & => abs(g(x) - g(y)) < epsilon / (2 abs(lambda)).
  $
  Por lo tanto, definiendo $delta := min{delta_1, delta_2}$ se tendrá
  $
  d(x, y) < delta => abs(f(x) + lambda g(x) - f(y) - lambda g(y)) <= abs(f(x) - f(y)) + abs(lambda) abs(g(x) - g(y)) < epsilon,
  $
  concluyendo así que $f + lambda g$ es continua en $x$.

  *b)* Para $alpha, beta in RR$ se observa que los conjuntos $A$ y $B$ se pueden escribir de la siguiente forma:
  $
  A = (f - g)^(-1)((alpha, +infinity)), quad B = (f + g)^(-1)((-infinity, beta)). #h(2em) (3.4)
  $
  Por otro lado, por la parte anterior se tiene que las funciones $f - g$ y $f + g$ son continuas. Por lo tanto, como $[alpha, +infinity)$ es un conjunto cerrado de $RR$ y $(-infinity, beta)$ es abierto, deducimos que $A$ es cerrado y $B$ es abierto en $X$, en virtud de las expresiones indicadas en (3.4) (preimágenes de un conjunto cerrado y de un conjunto abierto a través de funciones continuas; Ej. 5.10 y Teo. 5.9 de `apuntes.typ`).

  _Nota_: la fórmula (3.4) de la fuente dice $(alpha, +infinity)$ para $A$, pero $A$ se define con "$>=$" y dos renglones después la propia fuente usa que $[alpha, +infinity)$ es cerrado: es una errata, debe leerse $A = (f - g)^(-1)([alpha, +infinity))$. Se transcribe tal cual.

  *c)* Como $A^* := {x in X : f(x) - g(x) > alpha} = (f - g)^(-1)((alpha, +infinity))$, $f - g$ es una función continua y $(alpha, +infinity)$ es un conjunto abierto en $RR$, se tiene que $A^*$ es abierto que además está contenido en $A$. Por lo tanto $A^* subset.eq A^circle.small$ pues $A^circle.small$ es el conjunto abierto más grande contenido en $A$ (la fuente cita su Ejercicio 1.11).

  Similarmente, observamos que $B^* := {x in X : f(x) + g(x) <= beta} = (f + g)^(-1)((-infinity, beta])$ es un conjunto cerrado, por ser $f + g$ una función continua y $(-infinity, beta]$ un conjunto cerrado en $RR$. Como $B subset.eq B^*$ se deduce $overline(B) subset.eq B^*$ (la clausura es el menor cerrado que contiene a $B$). #align(right)[$square$]

  _Nota_: a) es la pieza "álgebra de funciones continuas a valores reales" que `apuntes.typ` no tiene; con ella, el Ej. 4 de la práctica ($\{f != g\}$ abierto) sale para $E' = RR$ escribiendo ${f != g} = (f - g)^(-1)(RR without {0})$, y el Ej. 5 es exactamente b).

  _Fuente_: P. Gajardo Adaro, _Análisis I_ (UTFSM, versión marzo 2021), Ejercicios resueltos de la Parte 1, (E3), págs. 56--57 del PDF. #link("https://matematica.usm.cl/wp-content/uploads/2018/09/analisis1_utfsm_202103.pdf")[URL]. Acceso: web del departamento, sin licencia explícita.
]

// ---- O16-4  |  p4: Ej. 4, 5  |  teoría: Teo. 5.9, preimágenes de semirrectas  |  nivel: alta (enunciado con indicación)
#ejemplo[${f > g}$ es abierto (Chavan, Ej. 8.14)][O16-4][
  Sea $X$ un espacio topológico (en particular, métrico) y $f, g : X -> RR$ continuas. Probar que $U = {x in X : f(x) > g(x)}$ es abierto en $X$.
]

#estrategia[Indicación de la fuente][
  Sea $x_0 in U$. Para cualquier $y in (g(x_0), f(x_0))$, el conjunto $g^(-1)((-oo, y)) inter f^(-1)((y, +oo))$ es un entorno de $x_0$ contenido en $U$.

  _Nota_: la fuente enuncia el resultado para $Y$ con la topología del orden; en ese caso agrega: "si $(g(x_0), f(x_0)) = nothing$, entonces $g^(-1)((-oo, f(x_0))) inter f^(-1)((g(x_0), +oo))$ es un entorno de $x_0$ contenido en $U$", caso que no ocurre en $RR$. Como consecuencia (Ejemplo 8.22, pág. 15), $A_1 = {f <= g}$ y $A_2 = {g <= f}$ son cerrados, lo que da el Ej. 4 de la Práctica 4: ${f = g} = A_1 inter A_2$ es cerrado y ${f != g} = {f > g} union {g > f}$ es abierto (para $f, g$ a valores reales; el caso general del Ej. 4 se hace con O14-12 (iv)). Alternativa sin indicación: $U = (f - g)^(-1)((0, +oo))$ si se dispone del álgebra de funciones continuas.

  _Fuente_: S. Chavan, _MTH304 Topology: notes and problems_ (IIT Kanpur), Exercise 8.14, pág. 14. #link("https://home.iitk.ac.in/~chavan/topology_mth304.pdf")[URL]. Acceso: página del docente en IIT Kanpur; sin licencia explícita.
]

// ---- O11-3  |  p4: Ej. 4  |  teoría: Def. 5.4, Ej. 5.10 (preimagen de cerrado)  |  nivel: alta
#ejemplo[$\{f = g\}$ es cerrado, vía $h(x) = d'(f(x), g(x))$ (BUAP, Lema 5.21)][O11-3][
  Sean $(X, d)$ y $(Y, d')$ espacios métricos, $A subset.eq X$ y $f, g : A -> Y$ funciones continuas en $A$. El conjunto
  $ B = {x in A : f(x) = g(x)} $
  es cerrado de $A$.
]

#resolucion[
  Sea $h : A -> RR$ definida para cada $x in A$ por $h(x) = d'(f(x), g(x))$. Veamos que $h$ es una función continua en $A$. Para esto, sean $epsilon > 0$ y $a in A$. Como $f$ y $g$ son continuas en $a$, existe $delta > 0$ tal que si $d(x, a) < delta$, entonces $d'(f(x), f(a)) < epsilon / 2$ y $d'(g(x), g(a)) < epsilon / 2$. Luego, si $d(x, a) < delta$, entonces
  $
    abs(h(x) - h(a)) & = abs(d'(f(x), g(x)) - d'(f(a), g(a))) \
                     & <= d'(f(x), g(a)) + d'(g(x), g(a)) \
                     & < epsilon / 2 + epsilon / 2 = epsilon,
  $
  por lo que $lim_(x -> a) h(x) = h(a)$. Por el ítem 2 del Teorema 5.3 de la fuente, $h$ es continua en cada $a in A$, concluyéndose así que $h$ es continua en $A$.

  Ahora, como ${0}$ es cerrado de $RR$ y $h$ es continua en $A$, por el ítem 3 del Teorema 5.11 de la fuente (la preimagen de un cerrado por una función continua es cerrada; es el Ej. 5.10 del apunte), tenemos que $h^(-1)({0})$ es cerrado de $A$, es decir
  $ h^(-1)({0}) = {x in A : d'(f(x), g(x)) = 0} = {x in A : f(x) = g(x)} $
  es cerrado de $A$.

  _Nota_: la segunda línea de la cadena está mal escrita en la fuente (dice $d'(f(x), g(a))$, que no está controlado por la hipótesis); lo correcto, y lo que el argumento usa, es
  $ abs(d'(f(x), g(x)) - d'(f(a), g(a))) <= d'(f(x), f(a)) + d'(g(x), g(a)), $
  que sale de aplicar dos veces la desigualdad triangular: $d'(f(x), g(x)) <= d'(f(x), f(a)) + d'(f(a), g(a)) + d'(g(a), g(x))$ y simétricamente. Con esa corrección la cota $< epsilon$ es la que afirma la fuente. Además $delta$ se toma como el mínimo de los dos $delta$ que dan $f$ y $g$ (la fuente lo da por sobreentendido). El complemento $A without B = {f != g}$ es entonces abierto, que es la otra mitad del Ej. 4.

  _Fuente_: D. Herrera Carrasco, F. Macías Romero y L. A. Guerrero Méndez, _La magia de los espacios métricos_ (FCFM, BUAP, 2025), Lema 5.21, págs. 125--126 del libro (134--135 del PDF). #link("https://www.fcfm.buap.mx/assets/docs/publicaciones/La_magia_de_los_espacios_metricos.pdf")[URL]. Acceso: "DR © Benemérita Universidad Autónoma de Puebla", ISBN 978-607-2637-10-8; sin licencia Creative Commons explícita.
]

// ---- O9-2  |  p4: Ej. 4, 5  |  teoría: Ej. 5.10, Teo. 5.13, Def. 4.27  |  nivel: alta
#ejemplo[El conjunto de ceros de una continua es cerrado, por preimágenes y por clausuras (MIT 18.100C, PS6 Prob. 4)][O9-2][
  Sea $f : X -> RR$ continua. Probar que $Z(f) = {x in X : f(x) = 0}$ es cerrado en $X$.
]

#resolucion[
  El conjunto de un punto ${0} subset.eq RR$ es cerrado; de hecho, por el Teorema 2.20 de Rudin, los subconjuntos finitos de cualquier espacio métrico son cerrados. Por el Teorema 4.8 de Rudin (una función es continua si y sólo si la preimagen de todo cerrado es cerrada; Ej. 5.10 del apunte), $Z(f) = f^(-1)({0}) subset.eq X$ es cerrado.

  "Si no se lo cree", esencialmente la misma prueba usando el problema anterior (O9-1): sea $E = Z(f)$ y notemos que $f(E) = {0}$. Entonces
  $ f(overline(E)) subset.eq overline(f(E)) = overline({0}) = {0}, $
  es decir, $overline(E) subset.eq f^(-1)({0}) = E$, o sea, $E$ es cerrado. #align(right)[$square$]

  _Nota_: la segunda prueba es la que usa el Teo. 5.13 del apunte, y es la plantilla para p4 Ej. 4 con $E' = RR$ (aplicar a $f - g$) y para p4 Ej. 5 (conjuntos de nivel). Compárese con O6-4, que sólo usa preimágenes.

  _Fuente_: MIT OpenCourseWare, _18.100C Real Analysis, Fall 2012, Problem Set 6 Solutions_, Problema 4, págs. 3--4 del PDF. #link("https://ocw.mit.edu/courses/18-100c-real-analysis-fall-2012/resources/mit18_100cf12_prob_set_6/")[URL]. Acceso: Términos de uso de OCW (CC BY-NC-SA 4.0 según el sitio); sin licencia impresa en el documento.
]


== Bloque 6 · Densidad y continuidad

#sublema(titulo: "Qué desbloquea")[
  Dos usos de la densidad: dos funciones continuas que coinciden en un denso coinciden en todo (*Ejercicio 7*), y la imagen continua y suryectiva de un denso es densa (*Ejercicio 8*). Incluye las caracterizaciones de "denso" por abiertos y por bolas, y otra demostración del Teo. 5.13, que es la herramienta del Ejercicio 8.
]

// ---- O3-1  |  p4: Ej. 7, 8  |  teoría: Def. 4.22 (clausura), Prop. 4.46, Def. 5.20 (denso); falta: caracterización de denso por abiertos  |  nivel: alta
#proposicion[Un conjunto denso "encuentra" todos los abiertos no vacíos (Daniilidis, Prop. 2.2.45)][
  Sea $(X, d)$ un espacio métrico y $D subset.eq X$. Entonces
  $ D "es denso en" X quad <==> quad D inter U != emptyset "para todo abierto" U != emptyset. $
  (Recordar: $D$ es denso en $X$ si $overline(D) = X$, Def. 2.2.44 de la fuente.)
]

#demostracion[
  $(==>)$ Sea $D subset.eq X$ denso, sea $U != emptyset$ abierto y $x in U$. Entonces $U$ es un abierto que contiene a $x$ y $x in overline(D)$. Se concluye porque $x in overline(D)$ si y sólo si todo abierto que contiene a $x$ corta a $D$ (la fuente cita su Proposición 2.2.17, que es la caracterización de la clausura por entornos; en `apuntes.typ` es la Def. 4.22 de punto de adherencia, con bolas).

  $(<==)$ Sea $U$ abierto no vacío. Si $D inter U = emptyset$ entonces $D subset.eq X without U$, y como $X without U$ es cerrado, $overline(D) subset.eq X without U subset.eq.not X$, es decir $overline(D) != X$, lo que es una contradicción.

  _Fuente_: A. Daniilidis, _Espacios Métricos_ (MA3801, DIM, U. de Chile, 2016), Proposición 2.2.45, pág. 83 del PDF. #link("https://www.dim.uchile.cl/~arisd/Espacios%20Metricos%20(U3).pdf")[URL]. Acceso: publicado en la web del docente; sin licencia explícita.
]

#observacion[Denso $<==>$ el complemento tiene interior vacío (Daniilidis, Obs. 2.2.46)][
  Un conjunto $D subset.eq X$ es denso si y sólo si su complemento $X without D$ tiene interior vacío. En $RR$ tanto $QQ$ como su complemento $RR without QQ$ son densos (y tienen interior vacío). Si un espacio métrico $X$ posee un conjunto denso con complemento denso, entonces $X$ no puede tener puntos aislados. En el otro extremo, el único conjunto denso en un espacio métrico discreto es todo el espacio.

  _Nota_: la fuente no demuestra esta observación; la primera equivalencia sale de la Proposición 2.2.45 (un abierto no vacío contenido en $X without D$ no cortaría a $D$). Sirve para el Ej. 7 (b) de la práctica: $QQ inter [0, 1]$ es denso en $[0, 1]$.

  _Fuente_: Daniilidis, Observación 2.2.46, pág. 84 del PDF. #link("https://www.dim.uchile.cl/~arisd/Espacios%20Metricos%20(U3).pdf")[URL].
]

// ---- O4-10  |  p4: Ej. 7, 8  |  teoría: Def. 5.20 (denso: $overline(D) = X$), abiertos y bolas; falta: caracterización de denso por bolas  |  nivel: media
#ejemplo[Caracterización de los densos por cubrimientos con bolas (Gajardo, Ej. resuelto E5 a)][O4-10][
  Considere un espacio métrico $(X, d)$. Pruebe que un conjunto $D subset.eq X$ es denso, si y solamente si, para todo $r > 0$ se tiene que
  $
  X subset.eq union.big_(y in D) B(y, r). #h(2em) (3.5)
  $
]

#resolucion[
  Supongamos que $D subset.eq X$ es denso. Entonces, para todo $r > 0$ y $x in X$, se tendrá $B(x, r) inter D != nothing$ (la fuente cita su Lema 2.1: $D$ es denso si y sólo si $D inter theta != nothing$ para todo abierto $theta != nothing$). Tomando $y in B(x, r) inter D$ se tiene $x in B(y, r)$, probando así la inclusión (3.5).

  Supongamos ahora que para todo $r > 0$ se tiene la inclusión (3.5) y consideremos un abierto $theta != nothing$. Para $x in theta$ se tendrá que existe $r^* > 0$ tal que $B(x, r^*) subset.eq theta$. Por otro lado, como se tiene (3.5) para $r = r^*$, existirá $y in D$ tal que $x in B(y, r^*)$. Esto implica que $y in B(x, r^*) subset.eq theta$. Por lo tanto $theta inter D != nothing$, probando así que $D$ es denso. #align(right)[$square$]

  _Nota_: la fuente define denso como $overline(D) = X$ y prueba el Lema 2.1 (denso $<==>$ corta a todo abierto no vacío) en la pág. 31. La parte b) del mismo ejercicio (compacto $=>$ separable) no se transcribe: usa compacidad.

  _Fuente_: P. Gajardo Adaro, _Análisis I_ (UTFSM, versión marzo 2021), Ejercicios resueltos de la Parte 1, (E5) a), pág. 60 del PDF. #link("https://matematica.usm.cl/wp-content/uploads/2018/09/analisis1_utfsm_202103.pdf")[URL]. Acceso: web del departamento, sin licencia explícita.
]

// ---- O11-4  |  p4: Ej. 7 (a)  |  teoría: clausura (cerrado ⟺ A = cl A), Lema anterior  |  nivel: alta
#ejemplo[Dos continuas que coinciden en $A$ coinciden en $overline(A)$ (BUAP, Lema 5.22)][O11-4][
  Sean $X$ e $Y$ espacios métricos y $A subset.eq X$. Si $f, g : overline(A) -> Y$ son funciones continuas en $overline(A)$ y $f|_A = g|_A$, entonces para cada $x in overline(A)$ se cumple que $f(x) = g(x)$.
]

#resolucion[
  Sea $B = {x in overline(A) : f(x) = g(x)}$. Por el Lema 5.21 de la fuente (ítem O11-3), el conjunto $B$ es cerrado de $overline(A)$. Notemos que $A subset.eq B subset.eq overline(A)$. Luego,
  $ overline(A) subset.eq overline(B) = B subset.eq overline(A). $
  Así, $overline(A) = B$ y por lo tanto, para cada $x in overline(A)$, se tiene que $f(x) = g(x)$.

  _Nota_: el Ej. 7 (a) de la práctica es el caso $overline(A) = X$ ($A$ denso): dos continuas $f, g : X -> Y$ que coinciden en un denso son iguales. La igualdad $overline(B) = B$ usa que $B$ es cerrado en el subespacio $overline(A)$, que a su vez es cerrado de $X$, así que $B$ es cerrado de $X$.

  _Fuente_: D. Herrera Carrasco, F. Macías Romero y L. A. Guerrero Méndez, _La magia de los espacios métricos_ (FCFM, BUAP, 2025), Lema 5.22, pág. 126 del libro (135 del PDF). #link("https://www.fcfm.buap.mx/assets/docs/publicaciones/La_magia_de_los_espacios_metricos.pdf")[URL]. Acceso: "DR © Benemérita Universidad Autónoma de Puebla", ISBN 978-607-2637-10-8; sin licencia Creative Commons explícita.
]

// ---- O15-4  |  p4: Ej. 7 (a)(b)  |  teoría: Teo. 5.9, Def. 5.20 (denso; que todo abierto no vacío corta a un denso sale de la definición), Teo. 5.7  |  nivel: alta
#ejemplo[Coincidir en un denso implica coincidir; una continua en $[0, 1] inter QQ$ sin extensión continua a $[0, 1]$ (Körner, Ej. 6.8)][O15-4][
  + Sea $X$ un espacio topológico (en particular, métrico) y $(Y, d)$ un espacio métrico. Si $f, g : X -> Y$ son continuas y $f(x) = g(x)$ para todo $x in A$, donde $A$ es denso en $X$, probar que $f(x) = g(x)$ para todo $x in X$.
  + Sea $[0, 1]$ con la métrica euclídea y $A = [0, 1] inter QQ$ con la métrica heredada. Exhibir, con demostración, una función continua $f : A -> RR$ tal que no existe ninguna función continua $tilde(f) : [0, 1] -> RR$ con $tilde(f)(x) = f(x)$ para todo $x in A$.
]

#resolucion[
  (i) Supongamos que $f(b) != g(b)$ para algún $b in X$. Podemos encontrar abiertos $U$ y $V$ (de $Y$) con $f(b) in U$, $g(b) in V$ y $U inter V = nothing$. Ahora $f^(-1)(U)$ es abierto, igual que $g^(-1)(V)$, así que $b in f^(-1)(U) inter g^(-1)(V)$, que es abierto. Como $A$ es denso, podemos encontrar $a in A$ con $a in f^(-1)(U) inter g^(-1)(V)$. Entonces $f(a) in U$ y $g(a) in V$, pero $f(a) = g(a)$, luego $f(a) in U inter V$, contradiciendo $U inter V = nothing$. El resultado sigue por contradicción.

  (ii) Observamos que $x in A ==> x^2 != 1 slash 2$. Para $x in A$ definimos
  $ f(x) = cases(0 &"si " x^2 < 1 slash 2, 1 &"en otro caso"). $
  Si $y in A$ y $y^2 < 1 slash 2$, podemos encontrar $delta > 0$ tal que $abs(y - x) < delta ==> x^2 < 1 slash 2 ==> f(x) = f(y)$. Análogamente, si $y in A$ y $y^2 > 1 slash 2$ podemos encontrar $delta > 0$ con $abs(y - x) < delta ==> x^2 > 1 slash 2 ==> f(x) = f(y)$. Luego $f$ es continua.

  Supongamos que $tilde(f) : [0, 1] -> RR$ cumple $tilde(f)(x) = f(x)$ para todo $x in A$. Elegimos $p_n, q_n in A$ con $p_n^2 > 1 slash 2 > q_n^2$ y $abs(p_n - 2^(-1 slash 2)) -> 0$, $abs(q_n - 2^(-1 slash 2)) -> 0$. Entonces
  $ abs(tilde(f)(p_n) - tilde(f)(2^(-1 slash 2))) + abs(tilde(f)(q_n) - tilde(f)(2^(-1 slash 2))) >= abs(f(p_n) - f(q_n)) = 1, $
  luego $tilde(f)$ no puede ser continua.

  _Nota_: en (i) la fuente usa que en un espacio métrico dos puntos distintos tienen bolas disjuntas (propiedad de Hausdorff; en el apunte: tomar $r = d(f(b), g(b)) slash 2$). La demostración es distinta de la del Ej. 7 (a) por sucesiones (O14-10, unicidad) y vale para $X$ topológico. En (ii), en la sección de soluciones la fuente escribe el enunciado con "$x in [0, 1]$" y la última desigualdad con $f$ en lugar de $tilde(f)$; son erratas (el enunciado original, pág. 16, dice "$x in A$"). Este ejemplo muestra que en el Ej. 7 (b) la restricción $C([0, 1]) -> {QQ inter [0, 1] -> RR}$ es inyectiva pero *no* suryectiva sobre las continuas en $QQ inter [0, 1]$, y que en O14-10 la hipótesis "uniformemente continua" no se puede quitar.

  _Fuente_: T. W. Körner, _Metric and Topological Spaces_ (DPMMS, Cambridge, 2021), Exercise 6.8, pág. 16 (enunciado), solución págs. 68--69. #link("https://www.dpmms.cam.ac.uk/~twk10/Top.pdf")[URL]. Acceso: página personal del autor; sin licencia explícita.
]

// ---- O3-2  |  p4: Ej. 7  |  teoría: Teo. 5.7, Prop. 4.46, Def. 5.20 (denso)  |  nivel: media
#ejemplo[La continuidad se decide sobre un denso más un punto (Daniilidis, Lema 2.5.16)][O3-2][
  Sean $(X, d)$, $(Y, d')$ espacios métricos, $D subset.eq X$ denso y $f : X -> Y$. Son equivalentes:
  #set enum(numbering: "(i)")
  + la función $f : X -> Y$ es continua;
  + para todo $x in X$ la restricción $f|_(D union {x})$ es continua.
]

#estrategia[Idea][
  Para $(<==)$: dada $x_n -> x$, aproximar cada $x_n$ por puntos de $D$ y armar una *sucesión diagonal* $(y_k)_(k in NN) subset.eq D$ con $d(y_k, x_k) < 1 \/ k$ y $d'(f(y_k), f(x_k)) < 1 \/ k$; como $y_k -> x$ y $f|_(D union {x})$ es continua, $f(y_k) -> f(x)$, y la desigualdad triangular arrastra a $f(x_k)$.
]

#resolucion[
  La implicación (i) $==>$ (ii) es obvia.

  (ii) $==>$ (i). Sea $(x_n)_(n in NN) subset.eq X$ una sucesión convergente hacia un punto $x in X$. Dado que $D$ es denso en $X$, para cada $n in NN$ podemos acercarnos al elemento $x_n$ por una sucesión $(u^((n))_m)_(m in NN) subset.eq D$ (la fuente escribe $u(n)_m$), es decir
  $ (forall n in NN) (exists (u^((n))_m)_(m in NN) subset.eq D) : quad u^((n))_m -->_(m -> infinity) x_n. $
  Como $f|_(D union {x_n})$ es continua, se tiene que $d'(f(u^((n))_m), f(x_n)) -->_(m -> infinity) 0$ para todo $n in NN$.

  Para $epsilon_1 = 1$ existe $m_1 in NN$ tal que $d(u^((1))_(m_1), x_1) < 1$ y $d'(f(u^((1))_(m_1)), f(x_1)) < 1$. Luego, para $epsilon_2 := 1 \/ 2$, existe $m_2 > m_1$ tal que
  $ d(u^((2))_(m_2), x_2) < 1 \/ 2 quad "y" quad d'(f(u^((2))_(m_2)), f(x_2)) < 1 \/ 2. $
  Tomando sucesivamente $epsilon_n := 1 \/ n$ y usando inducción, se construye una sucesión $(u^((n))_(m_n))_(n in NN) subset.eq D$ tal que
  $ d(u^((n))_(m_n), x_n) < 1 / n quad "y" quad d'(f(u^((n))_(m_n)), f(x_n)) < 1 / n. $
  Considerando la sucesión diagonal $y_k = u^((k))_(m_k)$ se tiene entonces que
  $ d(y_k, x_k) < 1 / k quad "y" quad d'(f(y_k), f(x_k)) < 1 / k. $
  Por lo tanto $(y_k)_(k in NN) -> x$ (pues $d(y_k, x) <= d(y_k, x_k) + d(x_k, x) -> 0$), y como $(y_k)_(k in NN) subset.eq D$ y $f|_(D union {x})$ es continua, $d'(f(y_k), f(x)) -> 0$. Se obtiene entonces que
  $ d'(f(x_k), f(x)) <= underbrace(d'(f(x_k), f(y_k)), < 1 \/ k) + underbrace(d'(f(y_k), f(x)), -> 0), $
  de donde se concluye que $f(x_k) -> f(x)$, es decir, la función $f$ es continua (Teorema 5.7 del apunte). #align(right)[$square$]

  _Nota_: la fuente escribe "$\{y_k\} -> x$ luego $rho(f(y_k), f(x_k)) -> 0$" en la penúltima línea; por el contexto, lo que se usa es $rho(f(y_k), f(x)) -> 0$ (continuidad de $f|_(D union {x})$ en $x$), que es como se transcribió. Para el Ej. 7 (a) de la práctica el camino es más corto (dos continuas que coinciden en un denso coinciden), pero este lema dice algo más fuerte: la continuidad de $f$ en todo $X$ está determinada por su comportamiento sobre $D union {x}$.

  _Fuente_: Daniilidis, Lema 2.5.16 (Conjuntos densos vs continuidad), págs. 127--128 del PDF. #link("https://www.dim.uchile.cl/~arisd/Espacios%20Metricos%20(U3).pdf")[URL]. Acceso: web del docente; sin licencia explícita.
]

// ---- O2-5  |  p4: Ej. 8  |  teoría: Teo. 5.13 ($f(overline(E)) subset.eq overline(f(E))$), Def. 5.20 (denso)  |  nivel: alta
#ejemplo[Imagen continua y sobreyectiva de un espacio separable (Guccione, Prop. 5.11)][O2-5][
  Recordemos (Definición 5.1 de la fuente) que $A subset.eq X$ es _denso_ si $overline(A) = X$, y que $X$ es _separable_ si tiene un subconjunto contable (finito o numerable) y denso. Si $X$ es separable y $f : X -> Y$ es continua y sobreyectiva, entonces $Y$ es separable.
]

#resolucion[
  Tomemos un subconjunto numerable denso $S$ de $X$. Por el Teorema 3.6 de la fuente, dado que $f$ es continua,
  $ Y = f(X) = f(overline(S)) subset.eq overline(f(S)). $
  Como $f(S)$ es contable, esto prueba que $Y$ es separable.

  _Nota_: el Teorema 3.6 (item 4) de la fuente es exactamente el Teorema 5.13 de `apuntes.typ`: $f$ continua $==>$ $f(overline(E)) subset.eq overline(f(E))$. El argumento, quitando la palabra "contable", es la resolución del Ej. 8 de la Práctica 4: si $D$ es denso y $f$ es continua y sobreyectiva, entonces $Y = f(overline(D)) subset.eq overline(f(D))$, o sea $f(D)$ es denso en $Y$.

  _Fuente_: J. A. Guccione y J. J. Guccione, _Espacios Métricos_ (FCEN-UBA, 2017), Definición 5.1 y Proposición 5.11, págs. 94 y 96 del PDF (85 y 87 del apunte). #link("https://cms.dm.uba.ar/academico/materias/2docuat2018/calculo_avanzado/2017/apunte.pdf")[URL]. Acceso: web de la materia; copia permitida sin fines de lucro (ver portada).
]

// ---- O9-1  |  p4: Ej. 8  |  teoría: Teo. 5.13 (otra demostración), Def. 4.22, Def. 5.20 (denso)  |  nivel: alta
#ejemplo[$f(overline(E)) subset.eq overline(f(E))$ por $epsilon$--$delta$, y la inclusión puede ser estricta (MIT 18.100C, PS6 Prob. 3)][O9-1][
  Sea $f : X -> Y$ continua y $E subset.eq X$. Probar que $f(overline(E)) subset.eq overline(f(E))$, y mostrar con un ejemplo que la inclusión puede ser propia.
]

#resolucion[
  Sea $x in overline(E)$. Entonces $f(x) in overline(f(E))$ si y sólo si, para todo $epsilon > 0$, $B(f(x), epsilon) inter f(E) != emptyset$.

  Sea $epsilon > 0$. Como $f$ es continua en $x$, existe $delta > 0$ tal que para todo $y in X$, $d(x, y) < delta ==> d(f(x), f(y)) < epsilon$. Pero $x in overline(E)$, así que todo entorno de $x$ corta a $E$: existe $y in E$ con $d(x, y) < delta$. Entonces $d(f(x), f(y)) < epsilon$, luego $f(y) in B(f(x), epsilon) inter f(E) != emptyset$, y listo.

  Para ver que la inclusión puede ser propia, sean $X = QQ$, $Y = RR$, $f : X -> Y$ la inclusión $iota : QQ arrow.hook RR$, y $E = X = QQ$. Todo conjunto es cerrado como subconjunto de sí mismo, así que $overline(E) = E$. Pero $f(E) = QQ subset.eq RR$ es denso, luego $overline(f(E)) = RR$. Entonces $overline(f(E)) without f(overline(E)) = RR without QQ$, y la inclusión es ciertamente propia. #align(right)[$square$]

  _Nota_: el apunte prueba la misma inclusión en el Teo. 5.13 ($==>$) vía sucesiones (Prop. 4.46 + Teo. 5.7); ésta es la demostración directa por $epsilon$--$delta$ y la definición de adherencia (Def. 4.22), más instructiva para p4 Ej. 8: si $D$ es denso y $f$ suryectiva, $Y = f(X) = f(overline(D)) subset.eq overline(f(D))$. La fuente escribe $N_epsilon (f(x))$ por $B(f(x), epsilon)$. Es también el Ejercicio 7.5.3 de Lebl (pág. 294).

  _Fuente_: MIT OpenCourseWare, _18.100C Real Analysis, Fall 2012, Problem Set 6 Solutions_ (autor según los metadatos del PDF: D. Jackson-Hanen), Problema 3, pág. 3 del PDF. #link("https://ocw.mit.edu/courses/18-100c-real-analysis-fall-2012/resources/mit18_100cf12_prob_set_6/")[URL]. Acceso: el PDF remite a los Términos de uso de OCW (#link("http://ocw.mit.edu/terms")[ocw.mit.edu/terms]); el sitio OCW declara licencia CC BY-NC-SA 4.0. No hay licencia impresa en el cuerpo del documento.
]

// ---- O4-6  |  p4: Ej. 7, 8 (manejo de clausuras e imágenes)  |  teoría: Teo. 5.13 (otra demostración), Def. 5.4, Prop. 4.46  |  nivel: alta
#ejemplo[Si $f(overline(A)) subset.eq overline(f(A))$ para todo $A$, entonces $f$ es continua: prueba por sucesiones (Gajardo, Ej. resuelto E7 b)][O4-6][
  Sean $(X, d)$ e $(Y, d')$ dos espacios métricos y $f : X -> Y$ una función. Si para todo conjunto $A subset.eq X$ se tiene que $f(overline(A)) subset.eq overline(f(A))$, demuestre que $f$ es continua.
]

#resolucion[
  Supongamos existe $x in X$ donde $f$ no es continua. Es decir, existirá $epsilon > 0$ tal que para todo $k in NN$ existe $x_k in B(x, 1\/k)$ que satisface $d'(f(x), f(x_k)) >= epsilon$. Deducimos que $x_k -> x$. Definamos el conjunto $A = {x_k : k in NN}$. Como $x in overline(A)$ se tiene que $f(x) in f(overline(A))$ y, por la hipótesis, entonces $f(x) in overline(f(A))$. Esto implicará que $B(f(x), epsilon) inter f(A) != nothing$. Como $f(A) = {f(x_k) : k in NN}$ existirá $k in NN$ tal que $f(x_k) in B(f(x), epsilon)$, pero esto contradice la desigualdad $d'(f(x), f(x_k)) >= epsilon$, por lo tanto la función $f$ debe ser continua. #align(right)[$square$]

  _Nota_: es la implicación $(<==)$ del Teo. 5.13 de `apuntes.typ`, pero con una demostración _distinta_: el apunte la reduce a "preimagen de cerrado es cerrada" (Ej. 5.10); acá se niega la continuidad en un punto, se fabrica la sucesión $x_k -> x$ con $d'(f(x), f(x_k)) >= epsilon$ y se aplica la hipótesis al conjunto $A$ formado por sus términos. Que $x in overline(A)$ es la Prop. 4.46 a).

  _Fuente_: P. Gajardo Adaro, _Análisis I_ (UTFSM, versión marzo 2021), Ejercicios resueltos de la Parte 1, (E7) b), pág. 61 del PDF. #link("https://matematica.usm.cl/wp-content/uploads/2018/09/analisis1_utfsm_202103.pdf")[URL]. Acceso: web del departamento, sin licencia explícita.
]


== Bloque 7 · Funciones sobre $C([0, 1])$: $d_1$ contra $d_infinity$

#sublema(titulo: "Qué desbloquea")[
  Funciones y conjuntos en $C([0, 1])$ con $d_1$ y con $d_infinity$. La integral es continua con las dos métricas y la evaluación en un punto sólo con $d_infinity$, porque $d_1 <= d_infinity$ pero no al revés (*Ejercicio 9*). También hay operadores Lipschitz sobre $C([a, b])$ y la caracterización de las funciones lineales continuas, que contesta el *Ejercicio 9 (c)*.
]

// ---- O17-1  |  p4: Ej. 9 (a)(b)  |  teoría: métricas d_1, d_infinity en C([0,1]), Def. 5.4, Teo. 5.7  |  nivel: alta
#ejemplo[En $C([0, 1])$: una sucesión que converge en $d_1$ y no en $d_infinity$; $integral_0^1$ es continua para ambas y $f |-> f(0)$ sólo para $d_infinity$ (Addington, Ejemplo 1.8)][O17-1][
  Sea $C([0, 1])$ con $d_1 (f, g) = integral_0^1 abs(f(x) - g(x)) dif x$ y $d_infinity (f, g) = sup_(x in [0, 1]) abs(f(x) - g(x))$.
  + Dar una sucesión de $C([0, 1])$ que converja en $d_1$ pero no en $d_infinity$.
  + Probar que $Phi : C([0, 1]) -> RR$, $Phi(f) = integral_0^1 f(x) dif x$, es continua tanto con $d_infinity$ como con $d_1$.
  + Probar que $Psi : C([0, 1]) -> RR$, $Psi(f) = f(0)$, es continua con $d_infinity$ pero no con $d_1$.
]

#resolucion[
  (a) Para $n = 1, 2, 3, dots$ sea $f_n : [0, 1] -> RR$ la función lineal a trozos que va de $f_n (0) = 0$ a $f_n (1 slash n) = 1$ y vale $f_n (x) = 1$ en $[1 slash n, 1]$. Afirmo que $f_n$ converge a la función constante $g(x) = 1$ en $d_1$ pero no en $d_infinity$. Por un lado, $d_1 (f_n, g) = integral_0^1 abs(f_n - g)$ es el área del triángulo de vértices $(0, 0)$, $(0, 1)$, $(1 slash n, 1)$, es decir $1 slash (2 n)$, que tiende a $0$; luego $f_n -> g$ en $d_1$. Por otro lado, $d_infinity (f_n, g) = sup abs(f_n - g) = 1$ para todo $n$, que no tiende a $0$; luego $f_n$ no converge a $g$ en $d_infinity$. (Lo mismo pasa con $f_n (x) = x^n$ y $g = 0$.)

  (b) Primero, $Phi$ es continua con $d_infinity$ en $C([0, 1])$ (y la métrica usual en $RR$). Desempacando las definiciones, hay que ver que para toda $f in C([0, 1])$ y todo $epsilon > 0$ existe $delta > 0$ tal que para toda $g$ con $d_infinity (f, g) < delta$ se tiene $abs(Phi(f) - Phi(g)) < epsilon$. Sean $f$ y $epsilon > 0$ dados, y tomemos $delta = epsilon$. Si $d_infinity (f, g) < delta$, entonces para todo $x in [0, 1]$ vale $abs(f(x) - g(x)) < delta$, así que
  $
    abs(Phi(f) - Phi(g)) & = abs(integral_0^1 f(x) dif x - integral_0^1 g(x) dif x) = abs(integral_0^1 (f(x) - g(x)) dif x) \
                         & <= integral_0^1 abs(f(x) - g(x)) dif x < integral_0^1 delta dif x = delta = epsilon,
  $
  que es lo que queríamos. Segundo, $Phi$ también es continua con $d_1$: dados $f$ y $epsilon > 0$, tomamos $delta = epsilon$; si $d_1 (f, g) < delta$,
  $ abs(Phi(f) - Phi(g)) <= integral_0^1 abs(f(x) - g(x)) dif x = d_1 (f, g) < delta = epsilon . $

  (c) $Psi$ es continua con $d_infinity$: dados $f$ y $epsilon > 0$, tomamos $delta = epsilon$; si $d_infinity (f, g) < delta$, entonces $abs(f(x) - g(x)) < delta$ para todo $x$, luego $abs(Psi(f) - Psi(g)) = abs(f(0) - g(0)) < delta = epsilon$. En cambio, $Psi$ no es continua con $d_1$: tomemos la sucesión $(f_n)$ de (a), que converge en $d_1$ a la constante $g = 1$. Si $Psi$ fuese continua con $d_1$, la sucesión $Psi(f_1), Psi(f_2), dots$ convergería a $Psi(g)$ (Ej. 1.11 de la fuente: continua manda sucesiones convergentes en convergentes, Teo. 5.7 del apunte), pero $Psi(f_n) = 0$ para todo $n$ mientras que $Psi(g) = 1$.

  _Nota_: la fuente agrega como Ej. 1.5 (pág. 11, sin solución): "probar que lo contrario no puede pasar: toda sucesión que converge en $d_infinity$ converge en $d_1$". Es exactamente el Ej. 9 (a)(b) de la Práctica 4 con $cal(I) = Phi$, $cal(E) = Psi$; las cuentas muestran además que $Phi$ y $Psi$ son Lipschitz con constante $1$ (Ej. 12).

  _Fuente_: N. Addington, _A Course in Metric Spaces and Point-Set Topology_ (Math 431, Univ. of Oregon), Example 1.8 (a)(b)(c), págs. 7--9; Exercise 1.5, pág. 11. #link("https://pages.uoregon.edu/adding/courses/431/431notes.pdf")[URL]. Acceso: página del docente en la Univ. of Oregon; sin licencia explícita.
]

// ---- O16-1  |  p4: Ej. 9 (a)(b)(c) (relación entre d_1 y d_infinity en C([0,1]))  |  teoría: métricas d_1, d_infinity en C([a,b]), abiertos, bolas  |  nivel: alta (enunciado con indicación)
#ejemplo[La bola unidad de $(C[0, 1], d_infinity)$ no es abierta en $d_1$, pero la de $d_1$ sí es abierta en $d_infinity$ (Chavan, Ej. 1.8 y 1.9)][O16-1][
  Sea $C[0, 1]$ con $d_infinity (f, g) = norm(f - g)_infinity$ y $d_1 (f, g) = integral_0^1 abs(f(t) - g(t)) dif t$.
  + (Ej. 1.8) Probar que la bola abierta unidad de $(C[0, 1], d_infinity)$ no puede ser abierta en $(C[0, 1], d_1)$.
  + (Ej. 1.9) Probar que la bola abierta unidad de $(C[0, 1], d_1)$ es abierta en $(C[0, 1], d_infinity)$.
]

#estrategia[Indicación de la fuente][
  Para (i): construir una función con máximo igual a $1 + r$ en $0$ y área cubierta menor que $r$. (Es decir: la función nula está en la bola $d_infinity$-unidad, pero toda bola $B_(d_1)(0, r)$ contiene una función con $d_infinity$ mayor que $1$.) Para (ii) la fuente no da indicación; se usa $d_1 (f, g) <= d_infinity (f, g)$ (observación del transcriptor).

  _Nota_: (ii) dice que todo abierto de $d_1$ es abierto de $d_infinity$, y (i) que el recíproco falla; por el Teo. 5.9 esto es lo que está detrás del Ej. 9: toda $cal(F)$ continua para $d_1$ es continua para $d_infinity$, y no al revés.

  _Fuente_: S. Chavan, _MTH304 Topology: notes and problems_ (IIT Kanpur), Exercises 1.8 y 1.9, pág. 2. #link("https://home.iitk.ac.in/~chavan/topology_mth304.pdf")[URL]. Acceso: página del docente en IIT Kanpur; sin licencia explícita.
]

// ---- O16-2  |  p4: Ej. 9 (a), 5  |  teoría: Teo. 5.7, Teo. 5.9, Ej. 5.10; métrica d_infinity en C([0,1])  |  nivel: alta
#ejemplo[El funcional de evaluación $E_(t_0)(f) = f(t_0)$ es continuo para $d_infinity$, y ${f : f(t_0) != 0}$ es abierto (Chavan, Ej. 8.5 y Ejemplo 8.6)][O16-2][
  (Ej. 8.5) Sean $X_1, X_2$ espacios topológicos, $x_0 in X_2$ y $X_2$ de Hausdorff (p. ej. métrico). Probar que para toda $f : X_1 -> X_2$ continua, $C = {x in X_1 : f(x) = x_0}$ es cerrado en $X_1$.

  (Ejemplo 8.6) Consideremos $C[0, 1]$ con la métrica del supremo. Fijado $t_0 in [0, 1]$, el funcional de evaluación $E_(t_0) : C[0, 1] -> RR$, $E_(t_0)(f) = f(t_0)$, es continuo, y ${f in C[0, 1] : f(t_0) != 0}$ es abierto en $C[0, 1]$.
]

#resolucion[
  (Ej. 8.5) Indicación de la fuente: $f^(-1)(X_2 without {x_0}) = X_1 without C$ (y ${x_0}$ es cerrado en un espacio de Hausdorff).

  (Ejemplo 8.6) Como $abs(f(t_0) - g(t_0)) <= d_infinity (f, g)$, la convergencia en la métrica del supremo implica la convergencia puntual. Se sigue que $E_(t_0)$ es continuo. Ahora ${f in C[0, 1] : f(t_0) != 0}$ es el complemento del núcleo de $E_(t_0)$ y, por el ejercicio anterior, es abierto en $C[0, 1]$.

  _Nota_: la fuente trabaja con $C[0, 1]$ a valores en $CC$; se transcribió con $RR$. "La convergencia en $d_infinity$ implica la puntual, luego $E_(t_0)$ es continuo" es el Teo. 5.7: si $f_n -> f$ en $d_infinity$, entonces $f_n (t_0) -> f(t_0)$. La desigualdad $abs(f(t_0) - g(t_0)) <= d_infinity (f, g)$ dice además que $E_(t_0)$ es Lipschitz con constante $1$ (Ej. 12). El Ej. 9 (a) de la Práctica 4 es el caso $t_0 = 0$.

  _Fuente_: S. Chavan, _MTH304 Topology: notes and problems_ (IIT Kanpur), Exercise 8.5 y Example 8.6, págs. 12--13. #link("https://home.iitk.ac.in/~chavan/topology_mth304.pdf")[URL]. Acceso: página del docente en IIT Kanpur; sin licencia explícita.
]

// ---- O17-3  |  p4: Ej. 5, 9  |  teoría: Ej. 5.10 (preimagen de cerrados), intersección de cerrados, métricas en C([0,1])  |  nivel: alta
#ejemplo[Las funciones que se anulan en $S subset.eq [0, 1]$ forman un cerrado de $(C([0, 1]), d_infinity)$, pero no de $d_1$ (Addington, Ejemplo 3.4, Ej. 3.4 y Ejemplo 6.9)][O17-3][
  Sea $X = C([0, 1])$ con la métrica del supremo y fijemos $S subset.eq [0, 1]$. Probar que el conjunto $A$ de las funciones que se anulan en $S$ (es decir, $f(x) = 0$ para todo $x in S$) es cerrado en $d_infinity$. Mostrar que no tiene por qué ser cerrado en $d_1$.
]

#resolucion[
  *(Ejemplo 6.9, "solución sin manos".)* En el Ejemplo 1.8 (c) (O17-1) vimos que $Psi : C([0, 1]) -> RR$, $Psi(f) = f(0)$, es continua en la métrica del supremo. Ahora observamos que $Psi^(-1)({0})$ es el conjunto de funciones que se anulan en $x = 0$ y, como ${0}$ es cerrado en $RR$ y $Psi$ es continua, es un cerrado de $C([0, 1])$ (Proposición 6.8 de la fuente: $f$ continua si y sólo si la preimagen de todo cerrado es cerrada). El mismo argumento funciona para el conjunto de funciones que se anulan en cualquier otro punto $x$. Luego el conjunto de funciones que se anulan en todo punto de $S$ es una intersección de cerrados, y por tanto es cerrado.

  *(Ejemplo 3.4, no cerrado en $d_1$.)* En el Ejemplo 1.8 (a) vimos una sucesión $(f_n)$ de funciones que se anulan todas en $0$ y que converge en $d_1$ a una función $g$ que no se anula en $0$. Así vemos que las nociones de abierto y cerrado, interior, clausura y frontera dependen de la métrica.

  _Nota_: la indicación original del Ej. 3.4 (pág. 22) ofrece otro camino: "directamente de las definiciones, o con la Prop. 2.10 (clausura por sucesiones) y la Prop. 1.10 (continuidad por sucesiones) junto con el Ejemplo 1.8 (c)", que es el Teo. 5.7 + clausura secuencial del apunte. Con $S = {0}$, el ejemplo responde "cerrado en $d_infinity$, no cerrado en $d_1$" para ${f : cal(E)(f) = 0}$, el conjunto de nivel del Ej. 9.

  _Fuente_: N. Addington, _A Course in Metric Spaces and Point-Set Topology_ (Math 431, Univ. of Oregon), Example 3.4 (pág. 20), Exercise 3.4 (pág. 22) y Example 6.9 (pág. 50). #link("https://pages.uoregon.edu/adding/courses/431/431notes.pdf")[URL]. Acceso: página del docente en la Univ. of Oregon; sin licencia explícita.
]

// ---- O6-6  |  p4: Ej. 9 (b), (c)  |  teoría: Def. 5.4, métrica d_infinity en C([a,b])  |  nivel: alta
#ejemplo[El operador derivada es continuo con $d_(C^1)$ y no con $d_infinity$ (Lebl, Ejerc. 7.5.12)][O6-6][
  Sea $C([a, b])$ el conjunto de las funciones continuas en $[a, b]$ y $C^1([a, b])$ el de las funciones con derivada continua en $[a, b]$. Definimos
  $ d_C (f, g) := norm(f - g)_infinity quad "y" quad d_(C^1)(f, g) := norm(f - g)_infinity + norm(f' - g')_infinity, $
  donde $norm(dot)_infinity$ es la norma del supremo en $[a, b]$ (así $d_C$ es la $d_infinity$ del apunte). Tanto $(C([a, b]), d_C)$ como $(C^1([a, b]), d_(C^1))$ son espacios métricos.
  #set enum(numbering: "a)")
  + Probar que el operador derivada $D : (C^1([a, b]), d_(C^1)) -> (C([a, b]), d_C)$, $D(f) := f'$, es continuo.
  + Probar que si en $C^1([a, b])$ se usa en cambio la métrica $d_C$, el operador derivada ya no es continuo.

  _Nota_: es el fenómeno de p4 Ej. 9: la misma aplicación es continua o no según la métrica del dominio. Aquí la métrica "fina" $d_(C^1)$ controla a $f'$ y la "gruesa" $d_C$ no.

  _Fuente_: J. Lebl, _Basic Analysis I_, v6.3, Ejercicio 7.5.12, pág. 295 del PDF. #link("https://www.jirka.org/ra/realanal.pdf")[URL]. Acceso: CC BY-NC-SA 4.0 / CC BY-SA 4.0.
]

#estrategia[Indicación de la fuente][
  Para b): considerar $sin(n x)$.
]

// ---- O14-11  |  p4: Ej. 9 (a)(b)(c), 12  |  teoría: Def. 5.4, Def. 5.14 (continuidad uniforme), Def. 5.24 (Lipschitz), métricas en C([0,1]); falta: aplicaciones lineales  |  nivel: baja (las aplicaciones lineales no están en apuntes.typ)
#proposicion[Aplicación lineal continua $<==>$ acotada $<==>$ Lipschitz (Payá, Apuntes 05, §5.6)][
  Sean $X, Y$ espacios normados y $T : X -> Y$ lineal. Son equivalentes:
  + $T$ es continua;
  + existe $M >= 0$ tal que $norm(T(x)) <= M norm(x)$ para todo $x in X$.

  Además, si $T$ es continua en un solo punto (p. ej. en $0$), es continua en todo $X$; y si $T$ es continua, es lipschitziana, luego uniformemente continua.
]

#demostracion[
  (i) $==>$ (ii). Teniendo en cuenta que $T(0) = 0$, la continuidad de $T$ en $0$ nos dice que existe $delta > 0$ tal que $z in X$, $norm(z) < delta ==> norm(T(z)) < 1$. Dado $x in X without {0}$, tomando $z = frac(delta x, 2 norm(x))$ tenemos $norm(z) = delta slash 2 < delta$, luego
  $ norm(T(x)) = frac(2 norm(x), delta) norm(T(z)) <= frac(2, delta) norm(x) . $
  Como la desigualdad es obvia para $x = 0$, hemos probado (ii) con $M = 2 slash delta$.

  (ii) $==>$ (i). Para cualesquiera $u, v in X$, de (ii) deducimos
  $ norm(T(u) - T(v)) = norm(T(u - v)) <= M norm(u - v), $
  lo que prueba que $T$ es lipschitziana, luego continua.

  Para probar (i) $==>$ (ii) sólo se usó la continuidad en el origen; usando una traslación, si $T$ es continua en un punto cualquiera, lo es en el origen y por tanto en todo $X$. Dicho de otro modo: si $T$ no es continua, no es continua en ningún punto.

  _Nota_ (del transcriptor): $cal(E)(f) = f(0)$ e $cal(I)(f) = integral_0^1 f$ son lineales en $C([0, 1])$. Con esta proposición, el Ej. 9 (a)(b) se reduce a buscar $M$: $abs(f(0)) <= d_infinity (f, 0)$, $abs(integral_0^1 f) <= d_1 (f, 0) <= d_infinity (f, 0)$, y $cal(E)$ no es acotada para $d_1$ (ver O17-1). Para (c): si $cal(F)$ es lineal y continua para $d_1$, como $d_1 (f, g) <= d_infinity (f, g)$, es continua para $d_infinity$; así que una $cal(F)$ continua para $d_1$ y no para $d_infinity$ no puede ser lineal.

  _Fuente_: R. Payá Albert, _Análisis Matemático I_ (UGR, 2024-25), Tema 5, §5.6 "Continuidad de aplicaciones lineales", págs. 7--8 del PDF (57--58 impresas). #link("https://www.ugr.es/~rpaya/documentos/AnalisisI/2024_25/Apuntes_05.pdf")[URL]. Acceso: web del docente en la UGR; sin licencia explícita.
]

// ---- O8-1  |  p4: Ej. 9 (a), 12  |  teoría: d_infinity en C([a,b]), Def. 5.24 (Lipschitz); falta: contracción  |  nivel: media
#ejemplo[Un operador integral en $(C([a, b]), d_infinity)$ es Lipschitz (Dote, Ej. 13)][O8-1][
  Sean $lambda in RR$, $g in C([a, b])$ y $k in C([a, b] times [a, b])$. Consideramos el operador $T : C([a, b]) -> C([a, b])$,
  $ T(f)(x) = g(x) + lambda integral_a^b k(x, y) f(y) dif y. $
  ¿Para qué $lambda$ es $T$ una contracción (es decir, $k$-Lipschitz con $k < 1$) respecto de $d_infinity$?
]

#resolucion[
  Por la Proposición 5 de la fuente (si $k$ es continua en el rectángulo compacto, entonces $y |-> integral_a^b k(x, y) dif x$ es continua), $T(f)$ es continua. Como $k$ es continua en un compacto, es acotada: existe $c$ tal que $abs(k(x, y)) <= c$ para todos $x, y in [a, b]$. Entonces
  $
    d_infinity (T(f_1), T(f_2)) &= sup_(x in [a, b]) abs(T(f_1)(x) - T(f_2)(x)) \
      &= abs(lambda) sup_(x in [a, b]) abs(integral_a^b k(x, y) (f_1 (y) - f_2 (y)) dif y) \
      &<= abs(lambda) sup_(x in [a, b]) integral_a^b abs(k(x, y)) abs(f_1 (y) - f_2 (y)) dif y \
      &<= abs(lambda) sup_(x in [a, b]) abs(f_1 (x) - f_2 (x)) dot sup_(x in [a, b]) integral_a^b abs(k(x, y)) dif y \
      &<= c abs(lambda) (b - a) d_infinity (f_1, f_2).
  $
  Por lo tanto, si $abs(lambda) < 1 / (c (b - a))$, $T$ es una contracción en un espacio métrico completo, y por el teorema del punto fijo de Banach existe una única $f in C([a, b])$ con $T(f) = f$. #align(right)[$square$]

  _Nota_: para p4 Ej. 9 lo que importa es la cadena de desigualdades: $T$ es Lipschitz con constante $c abs(lambda) (b - a)$ respecto de $d_infinity$ para *cualquier* $lambda$, y en particular continua. Lebl (Ejerc. 7.5.9, pág. 294) pide exactamente esto, sin $g$ ni $lambda$, como ejercicio. La fuente escribe "$sup_x abs(f_1 (x) - f_2 (x))$" al sacar el factor de la integral en $y$; es el mismo supremo, $d_infinity (f_1, f_2)$. La Proposición 5 de la fuente es la Prop. 7.5.12 de Lebl (continuidad de integrales con parámetro), que usa continuidad uniforme en compactos.

  _Fuente_: P. Dote, _18.S097 Introduction to Metric Spaces_, Lecture 5 (MIT, IAP 2022), Ejemplo 13, págs. 6--7 del PDF. #link("https://web.mit.edu/paigeb/www/18.S097/Lect_5.pdf")[URL]. Acceso: publicado en la web personal de la docente en MIT; sin licencia explícita en el documento.
]

// ---- O7-7  |  p4: Ej. 9 (a), 10, 11, 12  |  teoría: Def. 5.4, Ej. 5.10, d_infinity en C(X), Def. 5.24 (Lipschitz)  |  nivel: media
#ejemplo[Tres enunciados: mínimo de dos distancias, esferas cerradas, evaluación $1$-Lipschitz (Tyson, Ejerc. 3.9, 3.14 y 3.46)][O7-7][
  #set enum(numbering: "a)")
  + (Ejercicio 3.9) Sea $(X, d)$ un espacio métrico, $a, b in X$ con $a != b$, y $h : X -> RR$, $h(x) = min{d(x, a), d(x, b)}$. Probar que $h$ es continua en todo $x_0 in X$.
  + (Ejercicio 3.14) Sea $(X, d)$ un espacio métrico, $x_0 in X$ y $r > 0$. Probar que ${x in X : d(x, x_0) = r}$ es cerrado en $X$.
  + (Ejercicio 3.46) Sea $(X, d)$ un espacio métrico compacto y $C(X)$ el espacio de las funciones continuas $X -> RR$ con la métrica $d_infinity (f, g) = max{abs(f(x) - g(x)) : x in X}$. Fijado $x_0 in X$, definimos $F : C(X) -> RR$ por $F(g) := g(x_0)$. Probar que $F$ es Lipschitz con constante $L = 1$.

  _Nota_: la fuente no da indicaciones. b) es la parte "esferas" de p4 Ej. 10 (con O7-1 y Ej. 5.10 sale como preimagen de ${r}$). c) es p4 Ej. 9 (a) para $cal(E)(f) = f(0)$, reforzado a Lipschitz; con $X = [0, 1]$ el máximo existe porque $f - g$ es continua en un compacto. a) es una variante de $d(x, A)$ con $A = {a, b}$ (p4 Ej. 11).

  _Fuente_: J. Tyson, _MATH 424 Lecture notes: Functions_ (UIUC, 2026), Ejercicios 3.9 y 3.14 (pág. 18 del PDF) y 3.46 (pág. 22 del PDF). #link("http://publish.illinois.edu/jeremy-tyson/files/2026/05/functions.pdf")[URL]. Acceso: publicado en la web del docente; sin licencia explícita.
]


== Bloque 8 · Distancia a un punto y a un conjunto; lema de Urysohn

#sublema(titulo: "Qué desbloquea")[
  $d(dot, x_0)$ y $d(dot, A)$ son 1-Lipschitz, $d(x, A) = 0$ si y sólo si $x in overline(A)$, y el cociente $d(x, A) \/ (d(x, A) + d(x, B))$ separa cerrados disjuntos: son los *Ejercicios 10 y 11* completos. Al final, cerrados disjuntos a distancia cero y cuándo la distancia es positiva (contexto del *Ejercicio 16*).
]

// ---- O7-1  |  p4: Ej. 10, 12  |  teoría: Def. 5.4, desigualdad triangular (Def. 4.1), Def. 5.24 (Lipschitz)  |  nivel: alta
#ejemplo[$d_a (x) = d(x, a)$ es continua, y de hecho $1$-Lipschitz (Tyson, Ej. 3.5)][O7-1][
  Sea $(X, d)$ un espacio métrico y fijemos $a in X$. Definimos $d_a : X -> RR$ por $d_a (x) := d(x, a)$. Entonces $d_a$ es continua en todo $x_0 in X$.
]

#resolucion[
  Fijamos $x_0$ y $epsilon > 0$, y elegimos $delta = epsilon$. Si $d(x, x_0) < delta = epsilon$, entonces
  $ abs(d_a (x) - d_a (x_0)) = abs(d(x, a) - d(x_0, a)) <= d(x, x_0) < delta = epsilon, $
  donde usamos la desigualdad triangular. #align(right)[$square$]

  "Así, para todo espacio métrico $(X, d)$ tenemos garantizada una provisión abundante de funciones continuas a valores reales: las funciones $d_a : X -> RR$ para cada $a in X$. Más aún, estas funciones satisfacen una forma fuerte de continuidad": la desigualdad $abs(d_a (x) - d_a (y)) <= d(x, y)$ dice que las $d_a$ son $1$-Lipschitz (Def. 3.6 de la fuente).

  _Nota_: es p4 Ej. 10 y la mitad de p4 Ej. 12. La desigualdad $abs(d(x, a) - d(x_0, a)) <= d(x, x_0)$ es la "desigualdad triangular invertida"; la fuente no la deriva, sólo dice "usamos la desigualdad triangular".

  _Fuente_: J. Tyson, _MATH 424 Honors Real Analysis, Lecture notes: Functions between metric spaces_ (Univ. of Illinois Urbana-Champaign, primavera 2026), Ejemplo 3.5 y Def. 3.6, pág. 2 del PDF. #link("http://publish.illinois.edu/jeremy-tyson/files/2026/05/functions.pdf")[URL]. Acceso: publicado en la web del docente; sin licencia explícita en el documento.
]

// ---- O10-3  |  p4: Ej. 10  |  teoría: Def. 4.5, Def. 4.14, desigualdad triangular  |  nivel: alta
#ejemplo[${y : d(x, y) > r}$ es abierto (complemento de la bola cerrada), a mano (Karageorgis, T2--1)][O10-3][
  Sea $(X, d)$ un espacio métrico. Dados $x in X$ y $r > 0$, probar que $A = {y in X : d(x, y) > r}$ es abierto en $X$.
]

#resolucion[
  Sea $y in A$ y notemos que $epsilon = d(x, y) - r$ es positivo. Afirmamos que $B(y, epsilon)$ está contenida en $A$. En efecto,
  $
    z in B(y, epsilon) &==> d(z, y) < epsilon \
                       &==> d(z, y) + r < epsilon + r = d(x, y) <= d(x, z) + d(z, y) \
                       &==> r < d(x, z) \
                       &==> z in A.
  $
  Esto muestra que $B(y, epsilon) subset.eq A$, y por lo tanto $A$ es abierto. #align(right)[$square$]

  _Nota_: $A$ es el complemento de la bola cerrada ${y : d(x, y) <= r}$, así que esto prueba que las bolas cerradas son cerradas, como pide p4 Ej. 10, pero *sin* pasar por la continuidad de $d(dot, x)$: es la prueba directa que el ejercicio pide "rehacer" con O7-1 y Ej. 5.10 ($A = d_x^(-1)((r, +infinity))$).

  _Fuente_: P. Karageorgis, _MA2223 -- Tutorial solutions, Part 1_ (TCD), T2--1, pág. 3 del PDF. #link("https://www.maths.tcd.ie/~pete/ma2223/tut_sol1.pdf")[URL]. Acceso: publicado en la web del docente; sin licencia explícita.
]

// ---- O2-7  |  p4: Ej. 10, 12  |  teoría: Def. 4.1 (desigualdad triangular), Def. 4.51, Def. 5.24 (Lipschitz)  |  nivel: alta
#proposicion[La distancia de dos puntos a un tercero (Guccione, Prop. 1.2, items 2 y 3)][
  Para cada espacio métrico $X$:
  + $abs(d(x, u) - d(y, u)) <= d(x, y)$ para todo $x, y, u in X$.
  + $abs(d(x, u) - d(y, v)) <= d(x, y) + d(u, v)$ para todo $x, y, u, v in X$.
]

#demostracion[
  1) Basta observar que, debido a la desigualdad triangular y la simetría de la distancia,
  $ d(x, u) - d(y, u) <= d(x, y) quad "y" quad d(y, u) - d(x, u) <= d(y, x) = d(x, y). $

  2) Esto vale porque
  $ abs(d(x, u) - d(y, v)) &= abs(d(x, u) - d(y, u) + d(y, u) - d(y, v)) \
    &<= abs(d(x, u) - d(y, u)) + abs(d(y, u) - d(y, v)) \
    &= abs(d(x, u) - d(y, u)) + abs(d(u, y) - d(v, y)) \
    &<= d(x, y) + d(u, v), $
  debido a que $abs(a + b) <= abs(a) + abs(b)$ para todo $a, b in RR$, a la simetría de la distancia y al item 1.
]

#ejemplo[La función distancia $d : X times X -> RR_(>= 0)$ es Lipschitz (Guccione, Ejemplo 3.55 y Nota 3.56)][O2-7][
  Recordemos (Definición 3.50 de la fuente) que $f : X -> Y$ es _de Lipschitz_ si existe una constante $K >= 0$ tal que $d(f(x), f(x')) <= K d(x, x')$ para todo $x, x' in X$; el mínimo $K$ que satisface esta condición es la _constante de Lipschitz_ de $f$, y $f$ es una _función corta_ (o no expansiva) si su constante de Lipschitz es menor o igual que $1$.

  Para todo espacio métrico $X$, la función distancia $d : X times X -> RR_(>= 0)$ es una función de Lipschitz, donde $X times X$ se considera con la métrica $d_infinity ((x, x'), (y, y')) = max(d(x, y), d(x', y'))$.
]

#resolucion[
  Por las propiedades triangular y simétrica de $d$ y el item 2 de la Proposición 1.2,
  $ abs(d(x, x') - d(y, y')) &<= abs(d(x, x') - d(x, y')) + abs(d(x, y') - d(y, y')) \
    &<= d(x, y) + d(x', y') \
    &<= 2 max(d(x, y), d(x', y')) \
    &= 2 d_infinity ((x, x'), (y, y')) $
  para todo $x, x', y, y' in X$.

  _Nota 3.56 de la fuente_: la cuenta anterior muestra que $2$ es una cota superior de la constante de Lipschitz de $d$. Para $RR$ esta constante es $2$, como puede comprobarse tomando $x = 0$, $x' = 2$ e $y = y' = 1$. Por supuesto, el hecho de que la máxima constante de Lipschitz para las funciones distancia sea $2$ se debe a que estamos considerando a $X times X$ provisto de la distancia $d_infinity$. Si lo consideramos provisto con la distancia $d_1$, entonces $d$ es una función corta, porque (nota [2] del capítulo)
  $ abs(d(x, x') - d(y, y')) &<= abs(d(x, x') - d(x, y')) + abs(d(x, y') - d(y, y')) \
    &<= d(x, y) + d(x', y') = d_1 ((x, x'), (y, y')). $

  _Nota_: en el PDF la primera desigualdad aparece escrita con la notación de norma $norm(d(x, x') - d(y, y'))$ en lugar de valor absoluto; es un detalle tipográfico de la fuente, los valores son reales. Fijando $y' = x'$ se obtiene $abs(d(x, x') - d(y, x')) <= d(x, y)$: la función $x |-> d(x, x_0)$ es corta, que es la parte "$d(dot, x_0)$ es Lipschitz" del Ej. 12 de la Práctica 4 (y, en particular, es continua, Ej. 10).

  _Fuente_: J. A. Guccione y J. J. Guccione, _Espacios Métricos_ (FCEN-UBA, 2017), Proposición 1.2 (pág. 11 del PDF, 2 del apunte), Definición 3.50, Ejemplo 3.55 y Nota 3.56 (pág. 73 del PDF, 64 del apunte), nota [2] del Capítulo 3 (pág. 80 del PDF, 71 del apunte). #link("https://cms.dm.uba.ar/academico/materias/2docuat2018/calculo_avanzado/2017/apunte.pdf")[URL]. Acceso: web de la materia; copia permitida sin fines de lucro (ver portada).
]

// ---- O2-8  |  p4: Ej. 11, 12  |  teoría: Def. 4.22 (clausura), ínfimo (Def. 5), Def. 5.14, Def. 5.24 (Lipschitz), Obs. 5.28; falta: $d(x, A)$  |  nivel: alta
#definicion[Distancia de un punto a un conjunto (Guccione, Def. 1.39)][
  La distancia de un punto $x$ de un espacio métrico $X$ a un subconjunto $A$ de $X$ es, por definición, el elemento
  $ d(x, A) := inf_(y in A) d(x, y) $
  de $[0, infinity]$ (con $d(x, nothing) = infinity$).
]

#proposicion[$d(dot, A)$ es $1$-Lipschitz, y $d(x, A) = 0$ caracteriza la clausura (Guccione, Prop. 1.52 y Prop. 2.61)][
  + $abs(d(x, A) - d(y, A)) <= d(x, y)$ para todo $x, y in X$ y todo subconjunto no vacío $A$ de $X$.
  + Para todo $A subset.eq X$ y cada $x in X$: $x in overline(A)$ si y sólo si $B(x, r) inter A != nothing$ para todo $r > 0$, si y sólo si $d(x, A) = 0$.
]

#demostracion[
  1) Por la definición de $d(x, A)$ y la propiedad triangular de $d$, sabemos que
  $ d(x, A) <= d(x, z) <= d(x, y) + d(y, z) quad "para todo" z in A. $
  Así que $d(x, A) - d(x, y)$ es una cota inferior de ${d(y, z) : z in A}$. Por lo tanto
  $ d(x, A) - d(x, y) <= inf{d(y, z) : z in A} = d(y, A) $
  o, lo que es equivalente,
  $ d(x, A) - d(y, A) <= d(x, y). $
  Por simetría, $d(y, A) - d(x, A) <= d(x, y)$ y, en consecuencia, $abs(d(x, A) - d(y, A)) <= d(x, y)$, como queremos.

  2) La fuente dice que la equivalencia entre "$B(x, r) inter A != nothing$ para todo $r > 0$" y "$d(x, A) = 0$" es evidente, y en la nota [5] del capítulo la justifica así: $B(x, r) inter A != nothing$ para todo $r > 0$ si y sólo si $x$ tiene puntos de $A$ arbitrariamente cerca o, equivalentemente, si y sólo si $d(x, A) = inf_(y in A) d(x, y) = 0$. La equivalencia con $x in overline(A)$ es la definición de clausura (Def. 4.22 de `apuntes.typ`).
]

#ejemplo[$x |-> d(x, A)$ es una función corta; toda función de Lipschitz es uniformemente continua (Guccione, Ejemplo 3.57 y Prop. 3.51)][O2-8][
  + Para cada subconjunto $A$ de $X$, la función $f : X -> RR$ definida por $f(x) := d(x, A)$ es una función corta (de Lipschitz con constante $<= 1$).
  + Toda función de Lipschitz es uniformemente continua.
]

#resolucion[
  1. Es una función corta porque
  $ abs(d(x, A) - d(y, A)) <= d(x, y) quad "para todo" x, y in X, $
  por la Proposición 1.52.

  2. Supongamos que $f : X -> Y$ es de Lipschitz con constante de Lipschitz $K$. Entonces dado $epsilon > 0$, basta tomar $delta := epsilon / K$ para conseguir que
  $ d(f(x), f(x')) <= K d(x, x') < K delta = epsilon quad "para todo" x, x' in X "con" d(x, x') < delta. $
  Esto prueba que $f$ es uniformemente continua, como afirmamos.

  _Nota_: la fuente supone implícitamente $K > 0$ en $delta := epsilon \/ K$ (si $K = 0$ la función es constante y cualquier $delta$ sirve). Los items 1 y 2 juntos son el Ej. 12 de la Práctica 4 para $d(dot, A)$; con el item 2 de la proposición anterior sale el Ej. 11 (b): si $A$ es cerrado, $overline(A) = A$, así que $d(x, A) = 0$ si y sólo si $x in A$, es decir $d(x, A) > 0$ para todo $x in.not A$. La fuente usa también $x |-> d(x, A)$ para probar que $A^circle.small = {x : d(x, X without A) > 0}$ (nota [1] del Capítulo 2, pág. 62 del PDF).

  _Fuente_: J. A. Guccione y J. J. Guccione, _Espacios Métricos_ (FCEN-UBA, 2017), Definición 1.39 (pág. 28 del PDF), Proposición 1.52 (pág. 30 del PDF, 21 del apunte), Proposición 2.61 y nota [5] del Capítulo 2 (págs. 57 y 62 del PDF), Proposición 3.51 (pág. 73 del PDF) y Ejemplo 3.57 (pág. 74 del PDF, 65 del apunte). #link("https://cms.dm.uba.ar/academico/materias/2docuat2018/calculo_avanzado/2017/apunte.pdf")[URL]. Acceso: web de la materia; copia permitida sin fines de lucro (ver portada).
]

// ---- O4-4  |  p4: Ej. 10, 11  |  teoría: Teo. 5.9, Ej. 5.10 (preimágenes), O2-8; falta: $d(x, A)$  |  nivel: alta
#ejemplo[Entornos de un conjunto $B(A, r) = {d(dot, A) < r}$; todo cerrado es intersección numerable de abiertos (Gajardo, Ej. resuelto E6 a)][O4-4][
  Sea $(X, d)$ un espacio métrico y $A subset.eq X$. Dado $r > 0$, considere $B(A, r) := {x in X : d(x, A) < r}$.
  #set enum(numbering: "1)")
  + Pruebe que
    $
    B(A, r) = union.big_(y in A) B(y, r).
    $
  + Demuestre que si $A$ es cerrado, entonces $A = inter.big_(k in NN) B(A, 1\/k)$, y concluya que todo conjunto cerrado es una intersección numerable de conjuntos abiertos.
]

#resolucion[
  *1)* De O2-8 se tiene que la función $d(dot, A) : X -> RR$ es continua. En consecuencia, los conjuntos $B(A, r) = d(dot, A)^(-1)((-infinity, r))$ son abiertos (preimagen de un abierto de $RR$; Teo. 5.9 de `apuntes.typ`). Sea ahora $x in B(A, r)$. Se tiene entonces que $d(x, A) < r$, por lo que existirá $y in A$ tal que $d(x, y) < r$, lo que nos permite concluir que $x in union.big_(y in A) B(y, r)$. Por otro lado, si $x in union.big_(y in A) B(y, r)$, existirá $y in A$ tal que $d(x, A) <= d(x, y) < r$, concluyendo que $x in B(A, r)$.

  *2)* Observar que para todo conjunto $A$ y $r > 0$, se tiene que $A subset.eq B(A, r)$, por lo tanto
  $
  A subset.eq inter.big_(k in NN) B(A, 1\/k).
  $
  Si $x in inter.big_(k in NN) B(A, 1\/k)$, entonces $d(x, A) < 1\/k$ para todo $k in NN$, por lo tanto $d(x, A) = 0$. Esto implica que $x in overline(A)$ (O2-8), pero si $A$ es cerrado, entonces $x in A$, probando así la igualdad deseada. Como cada $B(A, 1\/k)$ es abierto por 1), todo cerrado es intersección numerable de abiertos. #align(right)[$square$]

  _Nota_: con $A = {x_0}$ se recupera $B(A, r) = B(x_0, r)$ y la prueba de que las bolas abiertas son abiertas vía la continuidad de $d(dot, x_0)$ (Ej. 10 de la práctica). El resultado 2) es el lado "$G_delta$" de los cerrados; la fuente lo usa después en el teorema de Baire.

  _Fuente_: P. Gajardo Adaro, _Análisis I_ (UTFSM, versión marzo 2021), Ejercicios resueltos de la Parte 1, (E6) a), págs. 60--61 del PDF. #link("https://matematica.usm.cl/wp-content/uploads/2018/09/analisis1_utfsm_202103.pdf")[URL]. Acceso: web del departamento, sin licencia explícita.
]

// ---- O2-9  |  p4: Ej. 11 (c) (d)  |  teoría: Teo. 5.9, Def. 4.27; falta: $d(x, A)$ (O2-8), álgebra de continuas (O2-2), Urysohn  |  nivel: alta
#ejemplo[Lema de Urysohn para espacios métricos y separación de cerrados disjuntos (Guccione, Teo. 3.19 y Corolarios 3.20–3.22)][O2-9][
  Decimos que una función continua $f : X -> [0, 1]$ _separa_ dos subconjuntos disjuntos $A$ y $B$ de $X$ si $f$ vale cero sobre $A$ y uno sobre $B$ (Definición 3.18). El siguiente resultado muestra que para cada par de cerrados disjuntos hay una función continua que los separa.

  *Teorema 3.19.* Supongamos que $C$ y $D$ son subconjuntos cerrados y no vacíos de un espacio métrico $X$ tales que $C inter D = nothing$. Entonces la función $zeta_(C, D) : X -> [0, 1]$, dada por
  $ zeta_(C, D)(x) := d(x, C) / (d(x, C) + d(x, D)), $
  está bien definida, es continua, se anula sobre $C$ y vale $1$ sobre $D$.

  *Corolario 3.20.* Fijados un cerrado $C$ y un abierto $U$ de $X$ con $C subset.eq U$, existe una función continua $f : X -> [0, 1]$ tal que $f|_C = 1$ y $f|_(X without U) = 0$.

  *Corolario 3.21.* Fijados un punto $x in X$ y un entorno abierto $U$ de $x$, existe una función continua $f : X -> [0, 1]$ tal que $f(x) = 1$ y $f|_(X without U) = 0$.

  *Corolario 3.22.* Fijados subconjuntos cerrados y no vacíos $C$ y $D$ de un espacio métrico $X$ tales que $C inter D = nothing$, existen abiertos disjuntos $U$ y $V$ de $X$ tales que $C subset.eq U$ y $D subset.eq V$.
]

#resolucion[
  _Teorema 3.19._ Por la Proposición 2.61 (item 2 de la proposición de O2-8), como $C$ y $D$ son cerrados disjuntos,
  $ d(x, C) + d(x, D) > 0 quad "para todo" x in X. $
  Además, es claro que $0 <= zeta_(C, D)(x) <= 1$ para todo $x$. Por lo tanto, la función $zeta_(C, D)$ está bien definida. Para probar que es continua es suficiente notar que es cociente de funciones reales que lo son. Por último, es claro que $zeta_(C, D)$ vale cero sobre $C$ y uno sobre $D$.

  _Corolario 3.20._ Aplíquese el Teorema 3.19 con $D = X without U$.

  _Corolario 3.21._ Esto es una consecuencia inmediata del corolario anterior, porque los puntos son cerrados.

  _Corolario 3.22._ Se puede tomar $U := zeta_(C, D)^(-1)((-infinity, 1 / 2))$ y $V := zeta_(C, D)^(-1)((1 / 2, infinity))$, donde $zeta_(C, D)$ es la función introducida en el Teorema 3.19.

  _Nota_: (i) En el enunciado del Corolario 3.20 la fuente escribe "$f|_D = 1$", pero el conjunto que debe valer $1$ es $C$ (no hay ningún $D$ en el enunciado); es una errata, y aquí se transcribió como $f|_C = 1$. Además, al aplicar el Teorema 3.19 con $D = X without U$, la función $zeta_(C, D)$ vale $0$ sobre $C$ y $1$ sobre $X without U$, así que para obtener $f|_C = 1$ y $f|_(X without U) = 0$ hay que tomar $f = 1 - zeta_(C, D)$ (o $zeta_(D, C)$); la fuente no lo aclara. También hace falta $X without U != nothing$ para que el teorema se aplique tal cual; si $U = X$, basta $f equiv 1$. (ii) "Cociente de funciones reales continuas es continua" es el Ejercicio 3.14 de la fuente (O2-2); que $d(dot, C)$ y $d(dot, D)$ son continuas es el Ejemplo 3.57 (O2-8). (iii) En el Corolario 3.22, $U$ y $V$ son abiertos por ser preimágenes de abiertos por una función continua (Teo. 5.9 de `apuntes.typ`), son disjuntos porque las semirrectas lo son, y $C subset.eq U$, $D subset.eq V$ porque $zeta_(C, D)$ vale $0$ en $C$ y $1$ en $D$. Esto es el Ej. 11 (c) y (d) de la Práctica 4.

  _Fuente_: J. A. Guccione y J. J. Guccione, _Espacios Métricos_ (FCEN-UBA, 2017), Definición 3.18, Teorema 3.19 y Corolarios 3.20–3.22, pág. 68 del PDF (59 del apunte). #link("https://cms.dm.uba.ar/academico/materias/2docuat2018/calculo_avanzado/2017/apunte.pdf")[URL]. Acceso: web de la materia; copia permitida sin fines de lucro (ver portada).
]

// ---- O12-3  |  p4: Ej. 11  |  teoría: Teo. 5.9 (preimagen de abierto); falta: d(x, A), álgebra de continuas (f − g continua)  |  nivel: alta
#ejemplo[Separar cerrados disjuntos con $d_E - d_F$ (Wilson, Cor. 2.2.5)][O12-3][
  Si $(X, d)$ es un espacio métrico y $E, F$ son subconjuntos cerrados y disjuntos de $X$, entonces existen subconjuntos abiertos y disjuntos $U$ y $V$ tales que $E subset.eq U$ y $F subset.eq V$.
]

#resolucion[
  Consideremos las funciones $d_E$ y $d_F$; por el Lema 2.2.4 (misma demostración en O2-8), ambas funciones son uniformemente continuas y, por el Teorema 1.0.26 (está en O2-8), $d_E (x) = 0$ si y sólo si $x in overline(E) = E$, y $d_F (x) = 0$ si y sólo si $x in overline(F) = F$. Definimos
  $ U = {z in X : d_E (z) - d_F (z) < 0} quad "y" quad V = {z in X : d_E (z) - d_F (z) > 0}. $
  Obviamente $U$ y $V$ son conjuntos disjuntos, y si $x in E$ entonces $x in.not F$ y por lo tanto $d_E (x) = 0$ y $d_F (x) > 0$; esto implica que $d_E (x) - d_F (x) < 0$, o sea $x in U$. En forma semejante, si $x in F$ entonces $x in.not E$ y por lo tanto $d_F (x) = 0$ y $d_E (x) > 0$; esto implica que $d_E (x) - d_F (x) > 0$, o sea $x in V$. Por lo tanto $E subset.eq U$ y $F subset.eq V$. Finalmente, el Teorema 2.1.5 de la fuente (si $f, g : X -> RR$ son continuas en $a$, entonces $f plus.minus g$ es continua en $a$; la fuente lo deja como tarea) implica que la función $d_E - d_F : (X, d) -> (RR, abs(dot))$ es continua, y la caracterización de continuidad por preimágenes de abiertos (Teo. 5.9 del apunte) implica que
  $ U = (d_E - d_F)^(-1) ((-oo, 0)) quad "y" quad V = (d_E - d_F)^(-1) ((0, oo)) $
  son conjuntos abiertos.

  _Nota_: las citas internas de la fuente están desfasadas: dice "Teorema 1.18" donde corresponde el Teorema 1.0.26 (está en O2-8) y "Teorema 1.26" donde corresponde el Corolario 2.1.4 de las mismas notas ($f$ continua $<==>$ $f^(-1)(V)$ abierto para todo $V$ abierto, que es el Teo. 5.9 del apunte); arriba se citan los correctos. La fuente asume tácitamente $E, F != emptyset$. Es una alternativa al lema de Urysohn del Ej. 11: en vez de $h = d_A / (d_A + d_B)$ usa el signo de $d_A - d_B$, con lo que no hace falta el cociente ni el álgebra de continuas más allá de la resta.

  _Fuente_: R. G. Wilson, _Notas de Análisis_ (Depto. de Matemáticas, UAM-Iztapalapa, 2005), Corolario 2.2.5, pág. 20 del PDF. #link("http://mat.izt.uam.mx/mat/documentos/notas%20de%20clase/NotasdeAnalisis.pdf")[URL]. Acceso: notas de clase publicadas en la web del Departamento de Matemáticas de la UAM-Iztapalapa; sin licencia explícita.
]

// ---- O2-10  |  p4: Ej. 11, 16  |  teoría: ínfimo, Def. 4.22 (clausura); falta: $d(x, A)$ y $d(A, B)$  |  nivel: media
#ejemplo[Distancias concretas entre conjuntos; cerrados disjuntos a distancia cero (Guccione, Ejemplos 1.43–1.45)][O2-10][
  La distancia entre dos subconjuntos $A$ y $B$ de $X$ es $d(A, B) := inf_(a in A, b in B) d(a, b)$ (Definición 1.40), y $d(x, A) = d({x}, A)$.
  + En $RR$, provisto de la métrica usual,
    $ d(0, [1, 2]) = d(0, (1, 2]) = 1 quad "y" quad d((0, 1], (1, 2)) = d(QQ, RR without QQ) = d(0, (0, 1]) = 0. $
    El último ejemplo muestra que la distancia de un punto a un conjunto puede ser cero sin que el punto pertenezca al conjunto.
  + En $(RR^2, d_2)$,
    $ d(RR times {0}, {(x, y) in RR^2 : y = x^2 + 1}) &= 1, \
      d(RR times {0}, {(x, y) in RR^2 : y > x^2 + 1}) &= 1 $
    y
    $ d({(x, 1 / x) : x in (0, infinity)}, {(x, -1 / x) : x in (0, infinity)}) = 0. $
  + En un espacio métrico discreto $X$, para cada par de subconjuntos no vacíos $A$ y $B$ de $X$,
    $ d(A, B) = cases(0 &"si " A inter B != nothing, 1 &"si " A inter B = nothing). $

  _Nota_: la fuente sólo enuncia los valores, sin cuentas. El tercer ejemplo del item 2 da dos cerrados disjuntos de $RR^2$ (las dos ramas de hipérbola) con $d(A, B) = 0$: por eso en el lema de Urysohn (O2-9) la hipótesis correcta es $C inter D = nothing$ y no $d(C, D) > 0$, y por eso en el Ej. 16 de la Práctica 4 la condición $d(A, B) = 0$ no obliga a que $overline(A) inter overline(B) != nothing$.

  _Fuente_: J. A. Guccione y J. J. Guccione, _Espacios Métricos_ (FCEN-UBA, 2017), Definición 1.40 y Ejemplos 1.43, 1.44 y 1.45, págs. 28–29 del PDF (19–20 del apunte). #link("https://cms.dm.uba.ar/academico/materias/2docuat2018/calculo_avanzado/2017/apunte.pdf")[URL]. Acceso: web de la materia; copia permitida sin fines de lucro (ver portada).
]

// ---- O4-3  |  p4: Ej. 11, 16  |  teoría: Prop. 4.46, O2-8; falta: $d(x, A)$, compacidad, continua en compacto alcanza mínimo  |  nivel: media
#ejemplo[$A$ compacto y $B$ cerrado: $A inter B = nothing <==> d(A, B) > 0$ (Gajardo, Ej. resuelto E4 b)][O4-3][
  Para dos conjuntos no vacíos $A, B subset.eq X$ se define
  $
  d(A, B) := inf {d(a, b) : a in A, b in B} = inf_(b in B) d(b, A) = inf_(a in A) d(a, B),
  $
  donde $d(dot, A)$ y $d(dot, B)$ son las funciones distancia a los conjuntos $A$ y $B$ respectivamente. Si $A$ es compacto y $B$ es cerrado, demuestre que $A inter B = nothing$ si y sólo si $d(A, B) > 0$.
]

#resolucion[
  Si $A inter B != nothing$, mostremos que $d(A, B) = 0$.

  _Alternativa 1_: Sea $overline(x) in A inter B$. Entonces $d(overline(x), A) = 0$, pues $A$ es un conjunto cerrado (O2-8) y, por lo tanto,
  $
  0 <= d(A, B) = inf_(b in B) d(b, A) <= d(overline(x), A) = 0.
  $

  _Alternativa 2_: Sea $overline(x) in A inter B$. Entonces $inf {d(a, b) : a in A, b in B} <= d(overline(x), overline(x))$, luego $0 <= d(A, B) <= 0$, por lo tanto $d(A, B) = 0$.

  Supongamos ahora $d(A, B) = 0$ y mostremos $A inter B != nothing$.

  _Alternativa 1_: Por definición del ínfimo, para cada $k in NN$ existen $a_k in A$ y $b_k in B$ tales que
  $
  0 <= d(a_k, b_k) <= d(A, B) + 1 / k = 1 / k.
  $
  Como $A$ es un conjunto compacto, existe $overline(a) in A$ y una subsucesión $(a_(k_j))_(j in NN)$ tal que $a_(k_j) -> overline(a)$. Se tendrá además que $b_(k_j) -> overline(a)$ pues
  $
  d(b_(k_j), overline(a)) <= d(b_(k_j), a_(k_j)) + d(a_(k_j), overline(a)) <= 1 / k_j + d(a_(k_j), overline(a)) -> 0.
  $
  Como $A$ y $B$ son conjuntos cerrados, y recordando que $a_(k_j) in A$ y $b_(k_j) in B$, se tendrá entonces $lim_(j -> +infinity) a_(k_j) = overline(a) in A$ y $lim_(j -> +infinity) b_(k_j) = overline(a) in B$, concluyendo $overline(a) in A inter B$ y, por lo tanto, $A inter B != nothing$.

  _Alternativa 2_: Sabemos que $d(dot, B) : X -> RR$ es una función continua (O2-8) y como $A$ es compacto, entonces $d(dot, B)$ alcanza un mínimo en $A$ (la fuente cita su Corolario 3.1.4: una función continua sobre un compacto alcanza mínimo y máximo). Sea $a_0 in A$ tal que
  $
  d(a_0, B) = inf_(a in A) d(a, B).
  $
  Tenemos que $B$ es cerrado y $d(a_0, B) = 0$, por lo tanto $a_0 in B$ (O2-8), luego $A inter B != nothing$. #align(right)[$square$]

  _Nota_: la fuente usa que un compacto es cerrado y que toda sucesión en un compacto tiene subsucesión convergente (su definición de compacidad es por recubrimientos; la equivalencia secuencial es su Teorema 2.3.2). Nada de esto está en `apuntes.typ` todavía. La relación con el Ej. 16 de la práctica: allí $d(A, B) = 0$ _no_ exige $A inter B != nothing$ (por ejemplo $A = NN$, $B = {n + 1\/n : n >= 2}$, ambos cerrados, disjuntos, con $d(A, B) = 0$); este ejercicio muestra que con $A$ compacto sí.

  _Fuente_: P. Gajardo Adaro, _Análisis I_ (UTFSM, versión marzo 2021), Ejercicios resueltos de la Parte 1, (E4) b), págs. 57--58 del PDF. #link("https://matematica.usm.cl/wp-content/uploads/2018/09/analisis1_utfsm_202103.pdf")[URL]. Acceso: web del departamento, sin licencia explícita.
]

// ---- O14-12  |  p4: Ej. 4, 11, 12  |  teoría: Teo. 5.9, Ej. 5.10, clausura, Def. 5.14, Def. 5.24 (Lipschitz); falta: d(x, A), composición de uniformemente continuas  |  nivel: alta (enunciados sin resolución en la fuente)
#ejemplo[Ejercicios propuestos sobre $d(x, A)$, la diagonal y ${f = g}$ (Payá, Apuntes 02, 03 y 05, ejercicios)][O14-12][
  Sea $E$ un espacio métrico con distancia $d$ y $A subset.eq E$ no vacío; se define $d(x, A) = inf {d(x, a) : a in A}$.
  + (Apuntes 02, Ej. 2.12.4) Probar que $overline(A) = {x in E : d(x, A) = 0}$.
  + (Apuntes 03, Ej. 3.9.4) Probar la continuidad de $f : E -> RR$, $f(x) = d(x, A)$.
  + (Apuntes 05, Ej. 5.8.6) Probar que $f(x) = d(x, A)$ es no expansiva: $abs(d(x, A) - d(y, A)) <= d(x, y)$.
  + (Apuntes 03, Ej. 3.9.5) En el espacio producto $E times E$, probar que para todo $r >= 0$ el conjunto ${(x, y) in E times E : d(x, y) < r}$ es abierto y ${(x, y) : d(x, y) <= r}$ es cerrado. En particular, la diagonal $Delta(E) = {(x, x) : x in E}$ es cerrada. Deducir que, si $F$ es otro espacio métrico y $f, g : E -> F$ son continuas, entonces ${x in E : f(x) = g(x)}$ es un subconjunto cerrado de $E$.
  + (Apuntes 03, Ej. 3.9.6) Si $f : E -> F$ es continua, su gráfica $op("Gr") f = {(x, f(x)) : x in E}$ es cerrada en $E times F$.
  + (Apuntes 05, Ej. 5.8.4) ¿Qué se puede afirmar sobre la composición de dos funciones uniformemente continuas?
]

#estrategia[Indicaciones][
  La fuente no resuelve estos ejercicios. Para (iv): ${(x, y) : d(x, y) < r} = d^(-1)((-oo, r))$ y ${(x, y) : d(x, y) <= r} = d^(-1)((-oo, r])$, con $d : E times E -> RR$ continua (O2-7); luego ${f = g} = (f, g)^(-1)(Delta(F))$, donde $(f, g) : E -> F times F$ es continua por serlo sus componentes (Apuntes 03, §3.6, pág. 8). Para (v): $op("Gr") f = (op("id"), f)^(-1)(Delta(F))$. (Indicaciones del transcriptor, coherentes con lo que la fuente desarrolla en §3.5--3.6.)

  _Fuente_: R. Payá Albert, _Análisis Matemático I_ (UGR, 2024-25): Tema 2, §2.12 Ejercicio 4, pág. 14 del PDF (26 impresa); Tema 3, §3.9 Ejercicios 4, 5 y 6, pág. 12 del PDF (38 impresa); Tema 5, §5.8 Ejercicios 4 y 6, pág. 10 del PDF (60 impresa). #link("https://www.ugr.es/~rpaya/documentos/AnalisisI/2024_25/Apuntes_02.pdf")[URL 02], #link("https://www.ugr.es/~rpaya/documentos/AnalisisI/2024_25/Apuntes_03.pdf")[URL 03], #link("https://www.ugr.es/~rpaya/documentos/AnalisisI/2024_25/Apuntes_05.pdf")[URL 05]. Acceso: web del docente en la UGR; sin licencia explícita.
]


== Bloque 9 · Lipschitz y continuidad uniforme: definiciones y criterios

#sublema(titulo: "Qué desbloquea")[
  `apuntes.typ` ya tiene la teoría de este bloque: continuidad uniforme (Definición 5.14), su negación (Observación 5.16) y la caracterización por pares de sucesiones (Proposición 5.18), función Lipschitz (Definición 5.24) y la cadena Lipschitz $==>$ uniformemente continua $==>$ continua sin vueltas (Observación 5.28; la primera implicación es el Ejercicio 5.25). Por eso O6-1, O3-8 y O14-6 son una *segunda lectura*: las mismas definiciones y la misma caracterización contadas por otra fuente. Lo nuevo es el módulo de continuidad (O5-1 a O5-4), que da otro criterio para los *Ejercicios 13 y 15*, y que la continuidad uniforme depende de la métrica y no sólo de los abiertos: la identidad de O14-8 es un homeomorfismo (Definición 5.29) que no es uniformemente continuo. Entrena los *Ejercicios 12, 13 y 15*.
]

// ---- O6-1  |  p4: Ej. 12, 13, 14, 15, 16  |  teoría: Def. 5.14 (continuidad uniforme), Def. 5.24 (Lipschitz), Obs. 5.28 (Lipschitz ⇒ uniformemente continua ⇒ continua; la primera implicación es el Ejercicio 5.25)  |  nivel: teoría (ya está en apuntes.typ: segunda lectura)
#definicion[Continuidad uniforme y funciones Lipschitz en espacios métricos (Lebl, Def. 7.5.10 y Ej. 7.5.13)][
  Sean $(X, d_X)$ e $(Y, d_Y)$ espacios métricos. Una función $f : X -> Y$ es *uniformemente continua* si para todo $epsilon > 0$ existe $delta > 0$ tal que, siempre que $p, q in X$ y $d_X (p, q) < delta$, vale $d_Y (f(p), f(q)) < epsilon$.

  Una función $f : X -> Y$ es *Lipschitz* (o *$K$-Lipschitz*) si existe $K in RR$ tal que
  $ d_Y (f(p), f(q)) <= K d_X (p, q) quad "para todo" p, q in X. $

  Una función uniformemente continua es continua: la única diferencia con la Definición 5.4 es que el $delta$ ya no puede depender del punto, sólo de $epsilon$. La fuente insiste en que ahora *el dominio importa*: una función que no es uniformemente continua en un conjunto grande puede serlo al restringirla a uno más chico (ver O6-10, O6-11 y O7-2).
]

#proposicion[Lipschitz implica uniformemente continua (Lebl, Prop. 3.4.8)][
  Toda función Lipschitz es uniformemente continua.
]

#demostracion[
  La fuente lo prueba para $f : S -> RR$ con $S subset.eq RR$, y en el Ejemplo 7.5.13 observa que en espacios métricos es lo mismo: "tomar $delta = epsilon \/ K$ (suponiendo $K > 0$)". Sea $f : S -> RR$ y sea $K$ una constante tal que $abs(f(x) - f(y)) <= K abs(x - y)$ para todos $x, y in S$. Sea $epsilon > 0$. Tomamos $delta := epsilon \/ K$. Para todos $x, y in S$ con $abs(x - y) < delta$,
  $ abs(f(x) - f(y)) <= K abs(x - y) < K delta = K epsilon / K = epsilon. $
  Por lo tanto $f$ es uniformemente continua. #align(right)[$square$]

  _Nota_: en la Prop. 3.4.8 la fuente divide por $K$ sin aclarar $K > 0$; el caso $K <= 0$ lo cubre explícitamente la fuente O8 (pág. 1): "si $K <= 0$, basta tomar $delta = 1$ y usar que $d_Y (f(p), f(q)) >= 0$" (observación nuestra: con $K <= 0$ la desigualdad fuerza $f$ constante).

  _Fuente_: J. Lebl, _Basic Analysis I: Introduction to Real Analysis_, vol. I, versión 6.3 (15 de mayo de 2026), Def. 7.5.10 y Ej. 7.5.13 (págs. 291--292 del PDF), Prop. 3.4.8 (pág. 141 del PDF). #link("https://www.jirka.org/ra/realanal.pdf")[URL]. Acceso: licencia doble CC BY-NC-SA 4.0 / CC BY-SA 4.0, declarada en la pág. 2 del PDF.
]

// ---- O3-8  |  p4: Ej. 13, 14, 15  |  teoría: Def. 4.51 (Cauchy), Def. 5.14, Obs. 5.16 (negación), Prop. 5.18 (la misma caracterización por sucesiones)  |  nivel: media (segunda lectura de la Prop. 5.18)
#definicion[Continuidad uniforme (Daniilidis, Def. 2.5.1)][
  Sean $(X, d)$, $(Y, d')$ dos espacios métricos. Una función $f : X -> Y$ se dice _uniformemente continua_ si
  $ (forall epsilon > 0)(exists delta > 0)(forall x_1, x_2 in X) quad d(x_1, x_2) < delta ==> d'(f(x_1), f(x_2)) < epsilon. $
]

#observacion[Uniformemente continua $==>$ continua, y manda Cauchy en Cauchy (Daniilidis, Obs. 2.5.2 (ii))][
  Cada función uniformemente continua es continua: en la definición anterior la elección de $delta > 0$ sólo depende de $epsilon > 0$, mientras que en la definición de continuidad también depende del punto de referencia. En términos de sucesiones, una función continua envía sucesiones convergentes a sucesiones convergentes, mientras que una función uniformemente continua, además de hacer eso, también envía sucesiones de Cauchy a sucesiones de Cauchy. Esta diferencia sólo se puede apreciar en el caso de espacios métricos no completos (es decir, en espacios donde las sucesiones de Cauchy no son las mismas que las sucesiones convergentes).

  _Nota_: la fuente sólo enuncia que "envía Cauchy en Cauchy" (es el *Ej. 14* de la práctica); no lo demuestra. Ver O3-9 para un ejemplo de función continua (no uniformemente continua) que no lo hace.

  _Fuente_: Daniilidis, Definición 2.5.1 (pág. 117 del PDF) y Observación 2.5.2 (ii) (pág. 118 del PDF). #link("https://www.dim.uchile.cl/~arisd/Espacios%20Metricos%20(U3).pdf")[URL].
]

#ejemplo[Caracterización de la continuidad uniforme por pares de sucesiones (Daniilidis, Prop. 2.5.3)][O3-8][
  Sea $f : X -> Y$ una función entre los espacios métricos $(X, d)$ e $(Y, d')$. Son equivalentes:
  #set enum(numbering: "(i)")
  + $f$ es uniformemente continua;
  + para todo par de sucesiones $(x_n)_(n in NN), (y_n)_(n in NN) subset.eq X$ tales que $d(x_n, y_n) -->_(n -> infinity) 0$ se tiene que $d'(f(x_n), f(y_n)) -->_(n -> infinity) 0$.
]

#resolucion[
  Supongamos primero que $f$ es uniformemente continua y tomamos dos sucesiones $(x_n)_(n in NN)$, $(y_n)_(n in NN)$ en $X$ tales que $d(x_n, y_n) -> 0$. Queremos establecer que $d'(f(x_n), f(y_n)) -> 0$. Para eso, fijamos $epsilon > 0$ y tomamos $delta > 0$ dado por la definición de continuidad uniforme. Por la convergencia de la sucesión real $t_n := d(x_n, y_n)$ a $0 in RR$, existe $n_0 in NN$ tal que para todo $n >= n_0$ se tiene que $d(x_n, y_n) < delta$. Eso en particular garantiza que $d'(f(x_n), f(y_n)) < epsilon$.

  Supongamos ahora que $f$ no es uniformemente continua. En este caso, existe $epsilon_0 > 0$ tal que para todo $n in NN$ existen $x_n, y_n$ en $X$ tales que $d(x_n, y_n) < 1 \/ n$ y $d'(f(x_n), f(y_n)) >= epsilon_0$. Se forman así dos sucesiones $(x_n)_(n in NN)$ e $(y_n)_(n in NN)$ que contradicen directamente (ii). #align(right)[$square$]

  _Nota_: la fuente aplica esta proposición a $f(x) = x^2$ en $RR$ con $x_n = n$, $y_n = n + 1 \/ n$: $abs(x_n - y_n) = 1 \/ n -> 0$ mientras que $abs(f(x_n) - f(y_n)) >= 2$. Es exactamente el argumento de C6-5 b), así que no se repite. Lo que aporta este ítem es la *equivalencia* (la vuelta (ii) $==>$ (i)), que es la justificación formal de la "vía negativa" usada en C6-5, C6-6 y en los Ej. 13 y 15 de la práctica.

  _Fuente_: Daniilidis, Proposición 2.5.3 (Caracterización de la continuidad uniforme) y ejemplo siguiente, págs. 118--119 del PDF. #link("https://www.dim.uchile.cl/~arisd/Espacios%20Metricos%20(U3).pdf")[URL]. Acceso: web del docente; sin licencia explícita.
]

// ---- O14-6  |  p4: Ej. 13, 15, 16  |  teoría: sucesiones en espacios métricos, Def. 5.14, Obs. 5.16, Prop. 5.18 (la misma caracterización)  |  nivel: media (segunda lectura de la Prop. 5.18, con contraejemplos)
#proposicion[Caracterización por sucesiones de la continuidad uniforme (Payá, Apuntes 05, §5.3)][
  Sean $E, F$ espacios métricos y $f : E -> F$. Decimos que $f$ es _uniformemente continua_ cuando
  $ forall epsilon > 0 quad exists delta > 0 : quad x, y in E, d(x, y) < delta ==> d(f(x), f(y)) < epsilon . $
  Si $f$ es uniformemente continua y $(x_n)_(n in NN)$, $(y_n)_(n in NN)$ son sucesiones de puntos de $E$ con $d(x_n, y_n) -> 0$, entonces $d(f(x_n), f(y_n)) -> 0$. El recíproco también es cierto; más aún: si $f$ *no* es uniformemente continua, existen dos sucesiones $(x_n)_(n in NN)$, $(y_n)_(n in NN)$ en $E$ y un $epsilon > 0$ tales que $d(x_n, y_n) < 1 slash n$ para todo $n$, pero $d(f(x_n), f(y_n)) >= epsilon$ para todo $n$.
]

#demostracion[
  Dado $epsilon > 0$, sea $delta > 0$ dado por la continuidad uniforme de $f$. Existe $m in NN$ tal que, para todo $n >= m$, se tiene $d(x_n, y_n) < delta$, luego $d(f(x_n), f(y_n)) < epsilon$.

  Recíprocamente, si $f$ no es uniformemente continua, existe $epsilon > 0$ tal que, para cada $delta > 0$, podemos encontrar $x, y in E$ con $d(x, y) < delta$ pero $d(f(x), f(y)) >= epsilon$. Para cada $n in NN$ tomamos $delta = 1 slash n$ y encontramos $x_n, y_n in E$ con $d(x_n, y_n) < 1 slash n$ y $d(f(x_n), f(y_n)) >= epsilon$. En particular $d(x_n, y_n) -> 0$ pero $d(f(x_n), f(y_n))$ no converge a cero.

  _Nota_: éste es el criterio práctico para los Ej. 13 y 15: para $1 slash x$ en $(0, +oo)$ tomar $x_n = 1 slash n$, $y_n = 1 slash (n + 1)$; para $sin(1 slash x)$ en $(0, 1)$, $x_n = 1 slash (2 n pi)$, $y_n = 1 slash (2 n pi + pi slash 2)$ (elección del transcriptor, no de la fuente).

  _Fuente_: R. Payá Albert, _Análisis Matemático I_ (UGR, 2024-25), Tema 5, §5.3 "Funciones uniformemente continuas", pág. 4 del PDF (54 impresa). Idéntico en la versión 2014-15, Lección 11, §11.1, pág. 2 del PDF. #link("https://www.ugr.es/~rpaya/documentos/AnalisisI/2024_25/Apuntes_05.pdf")[URL]. Acceso: web del docente en la UGR; sin licencia explícita.
]

// ---- O5-1  |  p4: Ej. 12, 13, 15 (herramienta)  |  teoría: Def. 5.14, sup/inf; falta: módulo de continuidad  |  nivel: media
#definicion[Continuidad uniforme y medidor (módulo) de continuidad uniforme $omega_f$ (Maximenko)][
  Sean $(X, d)$ e $(Y, d')$ espacios métricos y $f : X -> Y$. Se dice que $f$ es *uniformemente continua* si
  $
  forall epsilon > 0 quad exists delta > 0 quad forall a in X quad forall b in X quad (d(a, b) < delta ==> d'(f(a), f(b)) < epsilon).
  $
  Se escribe $C_u (X, Y) := {f in Y^X : f "es uniformemente continua"}$.

  Para $f : X -> Y$ se define $omega_f : (0, +infinity) -> [0, +infinity]$,
  $
  omega_f (eta) := sup {d'(f(a), f(b)) : a, b in X, d(a, b) <= eta}.
  $
  Muchos autores utilizan el término "módulo de continuidad uniforme".

  _Nota_: el supremo puede valer $+infinity$ (por eso el codominio es $[0, +infinity]$). La presentación compara las fórmulas cuantificadas de "continua en cada punto" ($forall a, forall epsilon, exists delta, forall b$) y "uniformemente continua" ($forall epsilon, exists delta, forall a, forall b$) y deja como ejercicio, sin resolver, mostrar que $C_u (X, Y) subset.eq C(X, Y)$.

  _Fuente_: E. Maximenko, _Funciones uniformemente continuas_ (ESFM-IPN, 2022), diapositivas en págs. 6, 11 y 12 del PDF. #link("https://esfm.egormaximenko.com/analysis/uniformly_continuous_functions_presentation_es.pdf")[URL]. Acceso: web personal del docente, sin licencia explícita.
]

#proposicion[Cota superior para $d'(f(a), f(b))$ en términos de $omega_f$ (Maximenko)][O5-1][
  Sea $f : X -> Y$ y sean $a, b in X$. Entonces
  $
  d'(f(a), f(b)) <= omega_f (d(a, b)).
  $
]

#demostracion[
  Sea $eta = d(a, b)$. Entonces $(a, b) in {(s, t) in X^2 : d(s, t) <= eta}$. Por eso
  $
  d'(f(a), f(b)) in underbrace({d'(f(s), f(t)) : s, t in X, d(s, t) <= eta}, G).
  $
  Finalmente, recordamos que $omega_f (eta) = sup(G)$. #align(right)[$square$]

  _Nota_: la fuente supone implícitamente $eta = d(a, b) > 0$ para que $omega_f (eta)$ esté definido ($omega_f$ se definió en $(0, +infinity)$); si $a = b$ la desigualdad es trivial. No se dice en las diapositivas.

  _Fuente_: E. Maximenko, _Funciones uniformemente continuas_ (ESFM-IPN, 2022), diapositivas en págs. 16--19 del PDF. #link("https://esfm.egormaximenko.com/analysis/uniformly_continuous_functions_presentation_es.pdf")[URL]. Acceso: web personal del docente, sin licencia explícita.
]

// ---- O5-2  |  p4: Ej. 13, 15 (herramienta)  |  falta: módulo de continuidad; usa monotonía del sup  |  nivel: baja
#proposicion[$omega_f$ es creciente (Maximenko)][O5-2][
  Sea $f : X -> Y$ y sean $eta_1, eta_2 > 0$ tales que $eta_1 < eta_2$. Entonces $omega_f (eta_1) <= omega_f (eta_2)$.
]

#demostracion[
  Si $d(a, b) <= eta_1$, entonces $d(a, b) <= eta_2$. Por eso
  $
  underbrace({d'(f(a), f(b)) : a, b in X, d(a, b) <= eta_1}, G) subset.eq underbrace({d'(f(a), f(b)) : a, b in X, d(a, b) <= eta_1}, H).
  $
  Luego $omega_f (eta_1) = sup(G) <= sup(H) = omega_f (eta_2)$. #align(right)[$square$]

  _Nota_: errata de la fuente (pág. 22): el conjunto $H$ está escrito con "$d(a, b) <= eta_1$", pero para que $sup(H) = omega_f (eta_2)$ debe ser "$d(a, b) <= eta_2$". Se transcribe tal cual.

  _Fuente_: E. Maximenko, _Funciones uniformemente continuas_ (ESFM-IPN, 2022), diapositivas en págs. 20--23 del PDF. #link("https://esfm.egormaximenko.com/analysis/uniformly_continuous_functions_presentation_es.pdf")[URL]. Acceso: web personal del docente, sin licencia explícita.
]

// ---- O5-3  |  p4: Ej. 13, 15  |  teoría: Def. 5.14; falta: módulo de continuidad  |  nivel: media (sólo (a)⇒(b) demostrada)
#proposicion[Criterio de continuidad uniforme vía $omega_f$ (Maximenko)][O5-3][
  Sea $f : X -> Y$. Entonces las siguientes condiciones son equivalentes:
  #set enum(numbering: "(a)")
  + $f$ es uniformemente continua;
  + para cada $epsilon > 0$ existe $eta > 0$ tal que $omega_f (eta) <= epsilon$;
  + $lim_(delta -> 0) omega_f (delta) = 0$;
  + $inf_(delta > 0) omega_f (delta) = 0$.

  La condición (b) involucra solamente 2 cuantificadores y muestra la utilidad de $omega_f$.
]

#demostracion[
  *(a) $=>$ (b).* Supongamos que $f in C_u (X, Y)$. Dado $epsilon > 0$, encontramos $delta > 0$ tal que
  $
  forall a, b in X quad (d(a, b) < delta ==> d'(f(a), f(b)) < epsilon).
  $
  Pongamos $eta := delta \/ 2$. Notamos que si $a, b in X$ y $d(a, b) <= eta$, entonces $d(a, b) < delta$ y por eso $d'(f(a), f(b)) < epsilon$. Luego $omega_f (eta) <= epsilon$.

  *Ejercicio.* Completar la demostración (las implicaciones restantes quedan como ejercicio en la fuente).

  _Nota_: sólo (a)$=>$(b) está demostrada en las diapositivas; no se agrega el resto. Para (b)$=>$(a) alcanza O5-1 (si $d(a, b) < eta$ entonces $d'(f(a), f(b)) <= omega_f (d(a, b)) <= omega_f (eta) <= epsilon$ usando O5-2), pero eso no está escrito en la fuente.

  _Fuente_: E. Maximenko, _Funciones uniformemente continuas_ (ESFM-IPN, 2022), diapositivas en págs. 24--31 del PDF. #link("https://esfm.egormaximenko.com/analysis/uniformly_continuous_functions_presentation_es.pdf")[URL]. Acceso: web personal del docente, sin licencia explícita.
]

// ---- O5-4  |  p4: Ej. 13, 15  |  teoría: Def. 5.14, Obs. 5.16; falta: módulo de continuidad  |  nivel: media (sólo enunciado + indicación)
#ejemplo[Calcular $omega_f$ para $x^2$ en $[-5, 5]$, $x^2$ en $RR$ y $1\/x$ en $(0, +infinity)$ (Maximenko, ejercicios)][O5-4][
  #set enum(numbering: "1)")
  + Sea $f : [-5, 5] -> RR$, $f(x) := x^2$. Calcular $omega_f$ y determinar si $f$ es uniformemente continua.
  + Sea $f : RR -> RR$, $f(x) = x^2$. Calcular $omega_f$ y determinar si $f$ es uniformemente continua.
  + Sea $f : (0, +infinity) -> RR$, $f(x) = 1 \/ x$. Calcular $omega_f$ y determinar si $f$ es uniformemente continua.
]

#estrategia[Idea (la única indicación de la fuente)][
  Los tres ejercicios siguen inmediatamente al criterio O5-3: la consigna es calcular explícitamente $omega_f (eta) = sup {abs(f(a) - f(b)) : abs(a - b) <= eta}$ y decidir con (b) o (d) del criterio ($f$ es uniformemente continua si y sólo si $inf_(delta > 0) omega_f (delta) = 0$). La presentación no da las respuestas.

  _Nota_: sin resolución en la fuente; se transcribe sólo el enunciado. Compárese con C6-5 ($x^2$ no uniformemente continua en $(0, +infinity)$, por sucesiones) y con el Ej. 13 de la práctica ($1\/x$ en $(0, +infinity)$).

  _Fuente_: E. Maximenko, _Funciones uniformemente continuas_ (ESFM-IPN, 2022), diapositivas en págs. 32--34 del PDF. #link("https://esfm.egormaximenko.com/analysis/uniformly_continuous_functions_presentation_es.pdf")[URL]. Acceso: web personal del docente, sin licencia explícita.
]

// ---- O2-14  |  p4: Ej. 1 (c), 15  |  teoría: Def. 4.8 / 4.9 (acotado, diámetro), métrica discreta, Def. 5.14, Def. 5.24 (Lipschitz), Ejemplo 5.17  |  nivel: media
#ejemplo[Lipschitz manda acotados en acotados; uniformemente continua no: la identidad desde la métrica discreta (Guccione, Prop. 3.62 y Obs. 3.63)][O2-14][
  + (Proposición 3.62) Consideremos una función de Lipschitz $f : X -> Y$. La imagen por $f$ de cada conjunto acotado $A$ de $X$ es un conjunto acotado de $Y$.
  + (Observación 3.63) Para que valga el resultado anterior no basta que $f$ sea uniformemente continua.
]

#resolucion[
  1. Denotemos con $K$ a la constante de Lipschitz de $f$. Como
  $ d(f(x), f(x')) <= K d(x, x') quad "para todo" x, x' in X, $
  si $A$ tiene diámetro $M$, entonces $f(A)$ tiene diámetro menor o igual que $K M$.

  2. Por ejemplo, si $X$ es un espacio métrico no acotado, entonces la función identidad $op("id") : X_delta -> X$, donde $X_delta$ es el conjunto subyacente de $X$ dotado con la métrica discreta, es uniformemente continua y aplica su dominio (que es un conjunto acotado) sobre su codominio (que no lo es). Es más, cuando $X$ es $NN$ (con la distancia usual), $f$ es un isomorfismo uniforme (biyectiva, uniformemente continua y con inversa uniformemente continua).

  _Nota_: $op("id") : X_delta -> X$ es uniformemente continua porque, dado $epsilon > 0$, con $delta = 1$ la condición $delta(x, x') < 1$ fuerza $x = x'$. Es la misma función del Ej. 1 (c) de la Práctica 4 ($op("id") : (RR^2, delta) -> (RR^2, d_2)$), vista ahora con la lupa de la continuidad uniforme. Para $X = NN$, la inversa $op("id") : NN -> NN_delta$ también es uniformemente continua: si $abs(n - m) < 1$ entonces $n = m$. Esto da un ejemplo de función uniformemente continua y no acotada (como pide el Ej. 15), aunque con dominio $X_delta$ en lugar de $RR$.

  _Fuente_: J. A. Guccione y J. J. Guccione, _Espacios Métricos_ (FCEN-UBA, 2017), Proposición 3.62 y Observación 3.63, págs. 74–75 del PDF (65–66 del apunte). #link("https://cms.dm.uba.ar/academico/materias/2docuat2018/calculo_avanzado/2017/apunte.pdf")[URL]. Acceso: web de la materia; copia permitida sin fines de lucro (ver portada).
]

// ---- O11-5  |  p4: Ej. 1 (c), 12, 15  |  teoría: Def. 5.14, Def. 5.24, Obs. 5.28 (el recíproco falla), Ejemplo 5.17 (desde un discreto)  |  nivel: media
#definicion[Continuidad uniforme y condición de Lipschitz (BUAP, Defs. 5.35 y 5.37)][
  Sean $(X, d)$ y $(Y, d')$ espacios métricos, $A subset.eq X$ y $f : A -> Y$ una función.
  + $f$ es *uniformemente continua* en $A$ si para cada $epsilon > 0$ existe $delta > 0$ tal que para cualesquiera $x, y in A$, si $d(x, y) < delta$, entonces $d'(f(x), f(y)) < epsilon$.
  + $f$ *satisface la condición de Lipschitz* en $A$ si existe $k > 0$ tal que para cualesquiera $x, y in A$ se cumple que $d'(f(x), f(y)) <= k d(x, y)$.

  _Fuente_: D. Herrera Carrasco, F. Macías Romero y L. A. Guerrero Méndez, _La magia de los espacios métricos_ (FCFM, BUAP, 2025), Definiciones 5.35 y 5.37, pág. 134 del libro (143 del PDF). #link("https://www.fcfm.buap.mx/assets/docs/publicaciones/La_magia_de_los_espacios_metricos.pdf")[URL]. Acceso: "DR © Benemérita Universidad Autónoma de Puebla", ISBN 978-607-2637-10-8; sin licencia Creative Commons explícita.
]

#ejemplo[Desde un espacio discreto todo es uniformemente continuo, y uniformemente continua $arrow.r.double.not$ Lipschitz (BUAP, Lema 5.36 y Obs. 5.38)][O11-5][
  + Si $X$ es un espacio métrico discreto (con la métrica $D(x, y) = 1$ si $x != y$, $D(x, y) = 0$ si $x = y$) y $f : X -> Y$ es una función cualquiera, entonces $f$ es uniformemente continua.
  + Si $f$ satisface la condición de Lipschitz, entonces $f$ es uniformemente continua. La afirmación recíproca es falsa: la función $g : (RR, D) -> (RR, abs(dot))$ definida por $g(x) = x$, donde $D$ es la métrica discreta, es uniformemente continua pero no satisface la condición de Lipschitz.
]

#resolucion[
  *Ítem 1.* Sean $epsilon > 0$ y $d'$ la métrica de $Y$. Para $delta < 1$ y $x, y in X$, si $D(x, y) < delta < 1$, entonces $D(x, y) = 0$, lo cual implica que $x = y$, es decir, $d'(f(x), f(y)) = 0 < epsilon$.

  *Ítem 2.* Si $f$ es Lipschitz con constante $k$, dado $epsilon > 0$ basta elegir $delta = epsilon / k$. Para el contraejemplo: por el ítem 1, $g$ es uniformemente continua. Supongamos que satisface la condición de Lipschitz, es decir, que existe $k > 0$ tal que para todo $x, y in RR$ se cumple que $abs(g(x) - g(y)) <= k D(x, y)$. En particular, para $x > k$ e $y = 0$,
  $ abs(g(x) - g(y)) = abs(x) <= k D(x, 0) = k < x, $
  lo cual significa que $x < x$, una contradicción.

  _Nota_: la fuente escribe la condición de Lipschitz supuesta con "$<$" ($abs(g(x) - g(y)) < k D(x, y)$) aunque la Definición 5.37 la define con "$<=$"; el argumento funciona igual con $<=$, como está transcripto arriba. La fuente también agrega: "es claro que si una función $f$ es uniformemente continua, entonces $f$ es continua; sin embargo, el recíproco no es cierto, dar un ejemplo" (los ejemplos C6 del repositorio, $x^2$ en $RR$, sirven). Para el Ej. 1 (c) de la práctica: el ítem 1 dice que $op("id") : (RR^2, D) -> (RR^2, d_2)$ no sólo es continua sino uniformemente continua.

  _Fuente_: D. Herrera Carrasco, F. Macías Romero y L. A. Guerrero Méndez, _La magia de los espacios métricos_ (FCFM, BUAP, 2025), Lema 5.36 (ítem 3) y Observación 5.38, págs. 134--135 del libro (143--144 del PDF). #link("https://www.fcfm.buap.mx/assets/docs/publicaciones/La_magia_de_los_espacios_metricos.pdf")[URL]. Acceso: "DR © Benemérita Universidad Autónoma de Puebla", ISBN 978-607-2637-10-8; sin licencia Creative Commons explícita.
]

// ---- O14-8  |  p4: Ej. 1 (c)(d) (variante), 15  |  teoría: Obs. "la continuidad depende de las métricas", Def. 5.14, Def. 5.29 (la identidad es homeomorfismo sin ser uniformemente continua); falta: métricas equivalentes  |  nivel: media
#ejemplo[La continuidad uniforme no es una propiedad topológica: la identidad y $rho(x, y) = abs(e^x - e^y)$ (Payá, Apuntes 05, §5.3)][O14-8][
  En $RR$ consideramos la distancia usual y la distancia $rho(x, y) = abs(e^x - e^y)$, que es equivalente a la usual (tiene los mismos abiertos). Sea $E = (RR, abs(dot))$ y $F = (RR, rho)$. Probar que la identidad $f : E -> F$ no es uniformemente continua, aunque sí lo es si en $F$ se usa la distancia usual, o si en $E$ y $F$ se usa $rho$.
]

#resolucion[
  Si $f$ fuese uniformemente continua tendríamos que
  $ forall epsilon > 0 quad exists delta > 0 : quad x, y in RR, abs(x - y) < delta ==> abs(e^x - e^y) < epsilon . $
  Esto sería tanto como decir que la función exponencial es uniformemente continua, vista como función de $RR$ con la distancia usual en sí mismo, cosa que sabemos que es falsa. Sin embargo, es obvio que si en $F$ cambiamos su distancia por la usual de $RR$ tendremos la continuidad uniforme de $f$. Lo mismo ocurre si tanto en $E$ como en $F$ usamos la distancia $rho$ (la distancia de $f(x)$ a $f(y)$ coincide con la de $x$ a $y$). Tenemos así ejemplos en los que una función uniformemente continua deja de serlo cuando sustituimos la distancia del espacio de partida, o del de llegada, por otra equivalente.

  _Nota_: que $e^x$ no es uniformemente continua en $RR$ se da por sabido; con O14-6, tomar $x_n = n$, $y_n = n + 1 slash n$: $e^(n + 1 slash n) - e^n = e^n (e^(1 slash n) - 1) >= e^n slash n -> oo$ (verificación del transcriptor). La fuente agrega que, en espacios *normados*, la continuidad uniforme sí se conserva al cambiar las normas por otras equivalentes (versión 2014-15, pág. 4: si $lambda norm(u - v)_1 <= norm(u - v)_2$ y $norm(f(u) - f(v))_2 <= rho norm(f(u) - f(v))_1$, dado $epsilon$ se toma $delta$ para $epsilon slash rho$ y sirve $delta lambda$). Esto es lo que hace que en el Ej. 1 de la Práctica 4 dé lo mismo usar $d_1$, $d_2$ o $d_infinity$.

  _Fuente_: R. Payá Albert, _Análisis Matemático I_ (UGR, 2024-25), Tema 5, §5.3, pág. 5 del PDF (55 impresa); versión 2014-15, §11.3, pág. 4 del PDF (66 impresa). #link("https://www.ugr.es/~rpaya/documentos/AnalisisI/2024_25/Apuntes_05.pdf")[URL]. Acceso: web del docente en la UGR; sin licencia explícita.
]


== Bloque 10 · Ejemplos y contraejemplos de continuidad uniforme

#sublema(titulo: "Qué desbloquea")[
  Catálogo para los *Ejercicios 13 y 15*: $1\/x$, $x^2$, $sqrt(x)$ (uniformemente continua sin ser Lipschitz), polinomios y funciones periódicas.
]

// ---- O2-11  |  p4: Ej. 13, 15  |  teoría: Def. 5.4, Def. 5.14, Obs. 5.16 (negación de la continuidad uniforme)  |  nivel: alta
#definicion[Función uniformemente continua (Guccione, Def. 3.33)][
  Decimos que una función $f : X -> Y$ es _uniformemente continua_ si para todo $epsilon > 0$ existe $delta > 0$ tal que para todo $x, x' in X$,
  $ d(x, x') < delta ==> d(f(x), f(x')) < epsilon. $
  Decimos que $f$ es uniformemente continua sobre un subconjunto $A$ de $X$ si su restricción a $A$ es uniformemente continua. La diferencia con la definición de continuidad es que en ésta $delta$ puede variar con el punto del dominio en el que se está evaluando la continuidad, no exigiéndose que haya uno que sirva para todos, mientras que en la continuidad uniforme esto se pide explícitamente. En particular (Observación 3.34) toda función uniformemente continua es continua.
]

#ejemplo[$1 \/ x$ es continua pero no uniformemente continua en $(0, +infinity)$ (Guccione, Obs. 3.35)][O2-11][
  Hay funciones que son continuas y no son uniformemente continuas. Una es la función $f : RR_(> 0) -> RR$ definida por $f(x) := 1 / x$.
]

#resolucion[
  Es continua porque es cociente de dos funciones continuas (ver el Ejercicio 3.14, O2-2). Pero no es uniformemente continua porque para todo $delta in (0, 1)$,
  $ abs(f(delta) - f(delta \/ 2)) = abs(1 / delta - 1 / (delta \/ 2)) = (delta \/ 2) / (delta^2 \/ 2) = 1 / delta > 1. $

  _Nota_: el argumento es la negación directa de la definición con $epsilon = 1$: para cada $delta in (0, 1)$ los puntos $x = delta$ y $x' = delta \/ 2$ cumplen $abs(x - x') = delta \/ 2 < delta$ y sin embargo $abs(f(x) - f(x')) > 1$. Es la primera mitad del Ej. 13 de la Práctica 4; la fuente no trata la restricción a $[epsilon, +infinity)$ (donde $f$ es Lipschitz con constante $1 \/ epsilon^2$) ni $sin(1 \/ x)$.

  _Fuente_: J. A. Guccione y J. J. Guccione, _Espacios Métricos_ (FCEN-UBA, 2017), Definición 3.33, Observaciones 3.34 y 3.35, pág. 70 del PDF (61 del apunte). #link("https://cms.dm.uba.ar/academico/materias/2docuat2018/calculo_avanzado/2017/apunte.pdf")[URL]. Acceso: web de la materia; copia permitida sin fines de lucro (ver portada).
]

// ---- O6-10  |  p4: Ej. 13  |  teoría: Def. 5.14, Obs. 5.16, Def. 5.24 (Lipschitz)  |  nivel: media
#ejemplo[$1 \/ x$ no es uniformemente continua en $(0, 1)$; es Lipschitz en $(c, infinity)$ pero no en $(0, infinity)$ (Lebl, Ej. 3.4.3 y Ejerc. 3.4.3--3.4.4)][O6-10][
  #set enum(numbering: "a)")
  + (Ejemplo 3.4.3) La función $f : (0, 1) -> RR$, $f(x) := 1 \/ x$, no es uniformemente continua.
  + (Ejercicio 3.4.3) Probar que $f : (c, infinity) -> RR$, $f(x) := 1 \/ x$, con $c > 0$, es Lipschitz.
  + (Ejercicio 3.4.4) Probar que $f : (0, infinity) -> RR$, $f(x) := 1 \/ x$, no es Lipschitz.
]

#resolucion[
  *a)* Dado $epsilon > 0$, la desigualdad $epsilon > abs(1 \/ x - 1 \/ y)$ vale si y sólo si
  $ epsilon > abs(1 / x - 1 / y) = abs(y - x) / abs(x y) = abs(y - x) / (x y), $
  o sea, si y sólo si $abs(x - y) < x y epsilon$. Supongamos $epsilon < 1$. Queremos ver si algún $delta > 0$ chico funciona. Si $x in (0, 1)$ e $y = x + delta \/ 2 in (0, 1)$, entonces $abs(x - y) = delta \/ 2 < delta$. Reemplazando $y$ en la desigualdad anterior obtenemos
  $ delta / 2 < x (x + delta / 2) epsilon < x. $
  Si se cumpliera la definición de continuidad uniforme, la desigualdad $delta \/ 2 < x$ valdría para todo $x > 0$ chico. Pero eso implica $delta <= 0$. Por lo tanto ningún $delta > 0$ sirve para todos los puntos. #align(right)[$square$]

  *b)* y *c)* La fuente sólo los enuncia.

  _Nota_: p4 Ej. 13 pide el dominio $(0, +infinity)$; por el Ejercicio 3.4.1 de la fuente (la restricción de una uniformemente continua es uniformemente continua) basta con a). La fuente resume los dos ejemplos de esta sección así: "si $f$ está definida en un intervalo que no es cerrado o no es acotado, $f$ puede ser continua sin ser uniformemente continua". b) y c) son la versión Lipschitz de "sí en $[epsilon, +infinity)$, no en $(0, +infinity)$".

  _Fuente_: J. Lebl, _Basic Analysis I_, v6.3, Ejemplo 3.4.3 (pág. 138 del PDF) y Ejercicios 3.4.3 y 3.4.4 (pág. 143 del PDF). #link("https://www.jirka.org/ra/realanal.pdf")[URL]. Acceso: CC BY-NC-SA 4.0 / CC BY-SA 4.0.
]

// ---- O7-2  |  p4: Ej. 12, 13, 15  |  teoría: Def. 5.14, Prop. 5.18 (par de sucesiones), Def. 5.24, Obs. 5.28 ($x^2$)  |  nivel: media
#ejemplo[$x^2$ no es uniformemente continua en $RR$ pero es $2M$-Lipschitz en $[-M, M]$ (Tyson, Ej. 3.34)][O7-2][
  La función $f : RR -> RR$, $f(x) = x^2$, no es uniformemente continua. En cambio, su restricción a cualquier intervalo cerrado y acotado $[-M, M]$ es Lipschitz, y por lo tanto uniformemente continua.
]

#resolucion[
  Sea $epsilon = 1$. Vamos a ver que para todo $delta > 0$ falla la conclusión de la definición de continuidad uniforme. Basta verificarlo para una sucesión $(delta_m)_(m in NN)$ con $delta_m -> 0$; tomamos $delta_m = 1 \/ m$. Elegimos $a_m = m$ y $b_m = m + 1 / (2m)$. Entonces $abs(a_m - b_m) = 1 / (2m) < delta_m$, pero
  $ abs(f(a_m) - f(b_m)) = abs(m^2 - (m + 1 / (2m))^2) = 1 + 1 / (4 m^2) > 1 = epsilon. $
  Luego $f$ no es uniformemente continua como función en todo $RR$.

  Por otro lado, la restricción de $f(x) = x^2$ a $[-M, M]$ es uniformemente continua: basta ver que es Lipschitz. Para $a, b in [-M, M]$,
  $ abs(f(a) - f(b)) = abs(a^2 - b^2) <= abs(a - b) abs(a + b) <= 2M abs(a - b). $
  Así $f|_([-M, M])$ es $2M$-Lipschitz, y por lo tanto uniformemente continua. #align(right)[$square$]

  _Nota_: la primera parte repite el argumento de C6-5 b) (allí con $x_n = n$, $y_n = n + 1 \/ n$ en $(0, +infinity)$); lo nuevo es la segunda parte, que da la constante de Lipschitz explícita en $[-M, M]$ y muestra la dependencia del dominio. Lebl (Ej. 3.4.2, pág. 138) hace lo mismo en $[0, 1]$ con constante $2$.

  _Fuente_: J. Tyson, _MATH 424 Lecture notes: Functions_ (UIUC, 2026), Ejemplo 3.34, pág. 7 del PDF. #link("http://publish.illinois.edu/jeremy-tyson/files/2026/05/functions.pdf")[URL]. Acceso: publicado en la web del docente; sin licencia explícita.
]

// ---- O2-12  |  p4: Ej. 12, 13, 15  |  teoría: Def. 5.14, Def. 5.24, Obs. 5.28 ($sqrt(x)$), Ejemplo 5.26, Ejercicio 5.27; falta: pegado de continuidad uniforme (generaliza C6-7 y C6-8), Heine (Cap. 7 de la fuente)  |  nivel: media
#proposicion[Pegado de continuidad uniforme sobre $A_1 union A_2$ (Guccione, Prop. 3.43 y Cor. 3.45)][
  Consideremos una función $f : X -> Y$, y escribamos $X$ como unión $X = A_1 union A_2$ de dos subconjuntos. Supongamos que existe $gamma > 0$ con la siguiente propiedad: para cada par $a, a'$ de elementos de $X$ tales que
  $ a in A_1 without A_2, quad a' in A_2 without A_1 quad "y" quad d(a, a') < gamma, $
  existe $a'' in A_1 inter A_2$ con $max(d(a, a''), d(a', a'')) <= d(a, a')$. Si $f|_(A_1)$ y $f|_(A_2)$ son uniformemente continuas, entonces $f$ es uniformemente continua.

  _Corolario 3.45._ Si $d(A_1 without A_2, A_2 without A_1) > 0$ y $f|_(A_1)$ y $f|_(A_2)$ son uniformemente continuas, entonces $f$ es uniformemente continua.
]

#demostracion[
  Por hipótesis, dado $epsilon > 0$, existe $delta > 0$ tal que si $a, a' in A_1$ o $a, a' in A_2$, entonces $d(f(a), f(a')) < epsilon \/ 2 < epsilon$. Es evidente que podemos tomar $delta < gamma$. Si lo hacemos, entonces
  $ d(f(a), f(a')) <= d(f(a), f(a'')) + d(f(a''), f(a')) < 2 epsilon / 2 = epsilon, $
  donde $a''$ es como en el enunciado, para cada $a in A_1$ y $a' in A_2$ (con $d(a, a') < delta$).

  _Corolario 3.45._ Si tomamos $gamma = d(A_1 without A_2, A_2 without A_1) > 0$, entonces las hipótesis de la proposición se satisfacen trivialmente, porque no hay ningún $a_1 in A_1$ y $a_2 in A_2$ a distancia menor que $gamma$.

  _Nota_: el Corolario 3.45 es el ejemplo C6-8 de `ejemplos/p4.typ` (con la hipótesis sobre $A_1 without A_2$ y $A_2 without A_1$ en vez de sobre $A$ y $B$), y C6-7 es el caso $A_1 = [0, a]$, $A_2 = [a, +infinity)$ de la proposición con $a'' = a$: si $x <= a <= y$ entonces $max(abs(x - a), abs(y - a)) <= abs(x - y)$. La demostración de la fuente es la misma idea que la de clase, escrita de una vez para los dos casos. En la frase "existe $delta > 0$ tal que si $a, a' in A_1$ o $a, a' in A_2$" se sobreentiende "y $d(a, a') < delta$", y en la última línea que $d(a, a'') <= d(a, a') < delta$ y $d(a', a'') < delta$, con $a, a'' in A_1$ y $a', a'' in A_2$.
]

#ejemplo[$sqrt(x)$ es uniformemente continua en $[0, +infinity)$ pero no es de Lipschitz en $[0, 1]$ (Guccione, Ejemplos 3.37 y 3.44, Obs. 3.52)][O2-12][
  + (Ejemplo 3.37) La función $f : [0, 1] -> RR$, dada por $f(x) := sqrt(x)$, es uniformemente continua.
  + (Ejemplo 3.44) La función $f : [0, +infinity) -> RR$, dada por $f(x) := sqrt(x)$, es uniformemente continua.
  + (Observación 3.52) Hay funciones uniformemente continuas que no son funciones de Lipschitz. Una es la función $f : [0, 1] -> RR$ dada por $f(x) := sqrt(x)$.
]

#resolucion[
  1. En los cursos de cálculo en una variable se prueba que esta función es continua (la fuente agrega en nota al pie: "más adelante deduciremos esto del hecho de que la función $x |-> x^2$ es continua"), y en el Capítulo 7 de la fuente se ve que toda función continua cuyo dominio es un intervalo cerrado de $RR$ es uniformemente continua (Corolario 7.38: si $f : X -> Y$ es continua y $X$ es compacto, entonces $f$ es uniformemente continua).

  2. En el Ejemplo 3.37 vimos que $f$ es uniformemente continua sobre $[0, 1]$, y usando la desigualdad
  $ abs(sqrt(a) - sqrt(b)) = abs((a - b) / (sqrt(a) + sqrt(b))) <= 1 / 2 abs(a - b), $
  válida para todo $a, b >= 1$, se comprueba fácilmente que $f$ es uniformemente continua sobre $[1, +infinity)$. Como las hipótesis de la Proposición 3.43 se satisfacen (con $A_1 = [0, 1]$, $A_2 = [1, +infinity)$; $gamma$ puede tomarse cualquier número real positivo), $f$ es uniformemente continua, como afirmamos.

  3. No es de Lipschitz, porque
  $ abs(sqrt(a) - sqrt(b)) = 1 / (sqrt(a) + sqrt(b)) abs(a - b), $
  y $1 \/ (sqrt(a) + sqrt(b))$ toma valores arbitrariamente grandes en el intervalo $[0, 1]$.

  _Nota_: (i) En el Ejemplo 3.44 la fuente escribe "$f : [0, 1] -> RR$" y "sobre $[1, infinity]$"; por el contexto (se pega $[0, 1]$ con $[1, +infinity)$) el dominio es $[0, +infinity)$ y el segundo intervalo es $[1, +infinity)$; aquí se transcribió corregido. (ii) El item 1 depende del teorema de Heine (continua sobre compacto $==>$ uniformemente continua), que `apuntes.typ` no tiene todavía; una prueba directa con la definición sale de $abs(sqrt(a) - sqrt(b)) <= sqrt(abs(a - b))$, que la fuente no usa. En `apuntes.typ` es el Ejercicio 5.27 (desafío). (iii) El item 2 es la variante "$sqrt(x)$ uniformemente continua y no Lipschitz" pedida para el Ej. 12–13, y además da un ejemplo de función no acotada y uniformemente continua en $[0, +infinity)$ (Ej. 15). (iv) En el item 3 la desigualdad falla si $a = b = 0$ (división por cero); hay que leerla para $(a, b) != (0, 0)$, y con $b = 0$ queda $abs(sqrt(a) - 0) = (1 \/ sqrt(a)) abs(a - 0)$, que es la obstrucción: ninguna constante $K$ cumple $sqrt(a) <= K a$ para $a -> 0^+$.

  _Fuente_: J. A. Guccione y J. J. Guccione, _Espacios Métricos_ (FCEN-UBA, 2017), Ejemplo 3.37 (pág. 70 del PDF, 61 del apunte), Proposición 3.43, Ejemplo 3.44 y Corolario 3.45 (pág. 72 del PDF, 63 del apunte), Observación 3.52 (pág. 73 del PDF, 64 del apunte), Corolario 7.38 (pág. 118 del PDF, 109 del apunte). #link("https://cms.dm.uba.ar/academico/materias/2docuat2018/calculo_avanzado/2017/apunte.pdf")[URL]. Acceso: web de la materia; copia permitida sin fines de lucro (ver portada).
]

// ---- O6-11  |  p4: Ej. 12, 15  |  teoría: Def. 5.14, Def. 5.24, Obs. 5.28 ($sqrt(x)$), Ejemplo 5.26; usa O6-7 y el pegado C6-7  |  nivel: media
#ejemplo[$sqrt(x)$ es Lipschitz en $[1, infinity)$, no es Lipschitz en $[0, infinity)$, pero es uniformemente continua y no acotada en $[0, infinity)$ (Lebl, Ej. 3.4.10 y comentario)][O6-11][
  #set enum(numbering: "a)")
  + La función $f : [1, infinity) -> RR$, $f(x) := sqrt(x)$, es Lipschitz.
  + La función $g : [0, infinity) -> RR$, $g(x) := sqrt(x)$, no es Lipschitz.
  + Sin embargo, $g$ es uniformemente continua en $[0, infinity)$.
]

#resolucion[
  *a)* Tenemos
  $ abs(sqrt(x) - sqrt(y)) = abs((x - y) / (sqrt(x) + sqrt(y))) = abs(x - y) / (sqrt(x) + sqrt(y)). $
  Como $x >= 1$ e $y >= 1$, vemos que $1 / (sqrt(x) + sqrt(y)) <= 1 / 2$. Por lo tanto
  $ abs(sqrt(x) - sqrt(y)) = abs((x - y) / (sqrt(x) + sqrt(y))) <= 1 / 2 abs(x - y). $

  *b)* Supongamos que existe $K$ tal que para todos $x, y in [0, infinity)$,
  $ abs(sqrt(x) - sqrt(y)) <= K abs(x - y). $
  Debe ser $K > 0$: $K < 0$ es imposible y $K = 0$ significaría que $g$ es constante. Poniendo $y = 0$ obtenemos $sqrt(x) <= K x$. Para $x > 0$ queda $1 \/ K <= sqrt(x)$, o sea $1 \/ K^2 <= x$. Esto no puede valer para todo $x > 0$. Luego no existe tal $K$ y $g$ no es Lipschitz. (La fuente lo ilustra con las secantes por $(0, 0)$ y $(x, sqrt(x))$, cada vez más verticales al acercarse a $x = 0$.)

  *c)* "El último ejemplo, $g$, es una función uniformemente continua que no es Lipschitz. Para ver que $sqrt(x)$ es uniformemente continua en $[0, infinity)$, notar que es uniformemente continua restringida a $[0, 1]$ por el Teorema 3.4.4 (O6-7). También es Lipschitz (y por lo tanto uniformemente continua) restringida a $[1, infinity)$. No es difícil (ejercicio) mostrar que esto implica que $sqrt(x)$ es uniformemente continua en $[0, infinity)$."

  _Nota_: el "ejercicio" del paso c) es exactamente el pegado de C6-7 (continuidad uniforme en $[0, a]$ y en $[a, +infinity)$ implica continuidad uniforme en $[0, +infinity)$). Además $sqrt(x)$ es *no acotada y uniformemente continua* en $[0, +infinity)$: es un ejemplo para la segunda parte de p4 Ej. 15. La fuente O10 (Teo. 1.8, pág. 12) enuncia la misma dicotomía: "$x^2$ es Lipschitz en $[0, 1]$; $sqrt(x)$ no es Lipschitz en $[0, 1]$".

  _Fuente_: J. Lebl, _Basic Analysis I_, v6.3, Ejemplo 3.4.10 y comentario posterior, págs. 142--143 del PDF. #link("https://www.jirka.org/ra/realanal.pdf")[URL]. Acceso: CC BY-NC-SA 4.0 / CC BY-SA 4.0.
]

// ---- O6-12  |  p4: Ej. 7, 12, 15  |  teoría: Def. 5.14, Def. 5.24 (Lipschitz), Teo. 5.22 (extensión desde un denso, para b)), Ejemplo 5.21  |  nivel: media
#ejemplo[Tres enunciados: polinomios no Lipschitz, extensión desde $QQ$, periódicas (Lebl, Ejerc. 3.4.6, 3.4.9 y 3.4.15)][O6-12][
  #set enum(numbering: "a)")
  + (Ejercicio 3.4.6, difícil) Sea $f : RR -> RR$ un polinomio de grado $d >= 2$. Probar que $f$ no es Lipschitz.
  + (Ejercicio 3.4.9, difícil) Sea $f : QQ -> RR$ uniformemente continua. Probar que existe una función uniformemente continua $tilde(f) : RR -> RR$ tal que $f(x) = tilde(f)(x)$ para todo $x in QQ$.
  + (Ejercicio 3.4.15) Sea $f : RR -> RR$ continua y periódica de período $P > 0$, es decir, $f(x + P) = f(x)$ para todo $x in RR$. Probar que $f$ es uniformemente continua.

  _Nota_: la fuente no da indicaciones. b) es la versión en $RR$ de la Prop. 3.68 de la fuente O7 (la misma extensión, en espacios métricos, está resuelta en O2-6) y complementa p4 Ej. 7 (unicidad de la extensión desde un denso) con la existencia. c) da una familia de funciones *acotadas, continuas y uniformemente continuas*, a contrastar con p4 Ej. 15 (acotada, continua, no uniformemente continua).

  _Fuente_: J. Lebl, _Basic Analysis I_, v6.3, Ejercicios 3.4.6, 3.4.9 (pág. 143 del PDF) y 3.4.15 (pág. 144 del PDF). #link("https://www.jirka.org/ra/realanal.pdf")[URL]. Acceso: CC BY-NC-SA 4.0 / CC BY-SA 4.0.
]

#estrategia[Indicación para b), vía el Teorema 5.22 (del transcriptor)][
  La fuente no da indicaciones; esta es del transcriptor. b) es un caso particular del Teorema 5.22 de `apuntes.typ` con $M = RR$, $E = QQ$ y $N = RR$. Hay que chequear las tres hipótesis: $QQ$ es denso en $RR$ (Definición 5.20 y Ejemplo 5.21), $RR$ es completo (Teorema 4.57) y $f$ es uniformemente continua por hipótesis. El teorema da $tilde(f) : RR -> RR$ uniformemente continua con $tilde(f)|_QQ = f$, y el Ejercicio 5.23 dice que es la única.
]


== Bloque 11 · Continuidad uniforme, sucesiones de Cauchy y extensión

#sublema(titulo: "Qué desbloquea")[
  Que una función uniformemente continua (Definición 5.14) manda sucesiones de Cauchy en sucesiones de Cauchy es el Ejercicio 5.19 de `apuntes.typ` y el *Ejercicio 14* de la práctica; O6-8, O4-7 y O14-9 lo demuestran. La continuidad sola no alcanza: en O2-13 y O3-9 el contraejemplo es incluso un homeomorfismo (Definición 5.29). La consecuencia es el Teorema 5.22: una función uniformemente continua sobre un denso (Definición 5.20) a valores en un completo se extiende a la clausura, y la extensión es única (Ejercicio 5.23). O2-6 y O14-10 son otra lectura de ese teorema, y O2-6 agrega que si la función es una isometría (Definición 5.33) la extensión también lo es, en la línea de la Observación 5.34. O6-9 es la versión en intervalos, con la vuelta, y O3-12 muestra que $sin(1\/x)$ no se extiende: otra forma de ver el *Ejercicio 13 (b)*.
]

// ---- O6-8  |  p4: Ej. 14  |  teoría: Def. 4.51 (Cauchy), Def. 5.14; es el Ejercicio 5.19  |  nivel: media
#ejemplo[Uniformemente continua manda Cauchy en Cauchy; continua sola no alcanza (Lebl, Lema 3.4.5 y Ejerc. 3.4.10)][O6-8][
  #set enum(numbering: "a)")
  + (Lema 3.4.5) Sean $S subset.eq RR$ y $f : S -> RR$ uniformemente continua. Si $(x_n)_(n in NN)$ es una sucesión de Cauchy en $S$, entonces $(f(x_n))_(n in NN)$ es de Cauchy.
  + (Ejercicio 3.4.10) (i) Hallar una $f : (0, 1) -> RR$ continua y una sucesión $(x_n)_(n in NN)$ en $(0, 1)$ de Cauchy tal que $(f(x_n))_(n in NN)$ no sea de Cauchy. (ii) Probar que si $f : RR -> RR$ es continua y $(x_n)_(n in NN)$ es de Cauchy, entonces $(f(x_n))_(n in NN)$ es de Cauchy.
]

#resolucion[
  *a)* Sea $epsilon > 0$. Existe $delta > 0$ tal que $abs(f(x) - f(y)) < epsilon$ siempre que $x, y in S$ y $abs(x - y) < delta$. Tomamos $M in NN$ tal que para todos $n, k >= M$ vale $abs(x_n - x_k) < delta$. Entonces, para todos $n, k >= M$, tenemos $abs(f(x_n) - f(x_k)) < epsilon$. #align(right)[$square$]

  *b)* La fuente sólo enuncia el ejercicio. Una resolución de (i), con $f(x) = 1 \/ x$ y $x_n = 1 \/ n$, está en O2-13.

  _Nota_: la demostración de a) no usa nada particular de $RR$: cambiando $abs(x - y)$ por $d(x, y)$ y $abs(f(x) - f(y))$ por $d'(f(x), f(y))$ es, palabra por palabra, p4 Ej. 14. La fuente presenta el lema como "la clave" de la extensión continua (O6-9): "la novedad es que, para una sucesión de Cauchy, el límite puede no estar en el dominio de la función". El ítem b)(ii) muestra que en $RR$ (completo) la continuidad sola basta; b)(i), que en $(0, 1)$ no.

  _Fuente_: J. Lebl, _Basic Analysis I_, v6.3, Lema 3.4.5 (págs. 139--140 del PDF) y Ejercicio 3.4.10 (pág. 143 del PDF). #link("https://www.jirka.org/ra/realanal.pdf")[URL]. Acceso: CC BY-NC-SA 4.0 / CC BY-SA 4.0.
]

// ---- O2-13  |  p4: Ej. 14  |  teoría: Def. 4.51 (Cauchy), Def. 5.14, Def. 5.29 ($1\/x$ es homeomorfismo y no preserva Cauchy); Ejercicio 5.19  |  nivel: alta
#ejemplo[Continua no preserva Cauchy (ni siquiera un homeomorfismo); uniformemente continua sí (Guccione, Obs. 6.5)][O2-13][
  Una función continua puede transformar una sucesión de Cauchy en una que no lo es, aun si es un homeomorfismo. Pero si $f : X -> Y$ es uniformemente continua y $(x_n)_(n in NN)$ es una sucesión de Cauchy de puntos de $X$, entonces $(f(x_n))_(n in NN)$ también lo es.
]

#resolucion[
  Para lo primero: la función $op("inv") : (0, +infinity) -> (0, +infinity)$, definida por $op("inv")(x) := 1 / x$, aplica la sucesión $(1 \/ n)_(n in NN)$, que es de Cauchy, en la sucesión identidad $(n)_(n in NN)$, que no lo es.

  Para lo segundo: dado $epsilon > 0$, existe $delta > 0$ tal que $d(f(x), f(x')) < epsilon$ siempre que $d(x, x') < delta$. Para este $delta$ existe $n_0 in NN$ tal que $d(x_l, x_m) < delta$ para todo $l, m >= n_0$. Pero entonces $d(f(x_l), f(x_m)) < epsilon$ para todo $l, m >= n_0$. En particular, la de ser de Cauchy es una propiedad uniforme que no es topológica.

  _Nota_: es exactamente el Ej. 14 de la Práctica 4, con el contraejemplo que muestra que la hipótesis "uniformemente" no se puede bajar a "continua". Que $op("inv")$ es un homeomorfismo de $(0, +infinity)$ en sí mismo: es continua (cociente de continuas, O2-2), biyectiva, y es su propia inversa. La frase final de la fuente usa su vocabulario de "propiedades uniformes/topológicas" (Definiciones 3.25 y 3.48): ser de Cauchy se preserva por isomorfismos uniformes pero no por homeomorfismos.

  _Fuente_: J. A. Guccione y J. J. Guccione, _Espacios Métricos_ (FCEN-UBA, 2017), Observación 6.5, pág. 101 del PDF (92 del apunte). #link("https://cms.dm.uba.ar/academico/materias/2docuat2018/calculo_avanzado/2017/apunte.pdf")[URL]. Acceso: web de la materia; copia permitida sin fines de lucro (ver portada).
]

// ---- O4-7  |  p4: Ej. 14  |  teoría: Def. 4.51 (Cauchy), Def. 4.55 (completo), Teo. 5.7, Def. 5.14; Ejercicio 5.19  |  nivel: media
#ejemplo[Uniformemente continua con inversa continua transporta la completitud; contiene "u.c. manda Cauchy en Cauchy" (Gajardo, Ej. resuelto E7 a)][O4-7][
  Sean $(X, d)$ e $(Y, d')$ dos espacios métricos y $f : X -> Y$ una función. Si $(Y, d')$ es completo y $f : X -> Y$ es uniformemente continua, biyectiva y su inversa es continua, pruebe que $(X, d)$ es también completo.
]

#resolucion[
  Sea $(x_k)_(k in NN) subset.eq X$ una sucesión de Cauchy y $epsilon > 0$. Por la uniforme continuidad de $f$, sabemos que existe $delta > 0$ tal que
  $
  d(x, y) < delta => d'(f(x), f(y)) < epsilon.
  $
  Por otro lado, existirá $k_0 in NN$ tal que $d(x_k, x_(k')) < delta$ para todo $k, k' >= k_0$. Por lo tanto, $d'(f(x_k), f(x_(k'))) < epsilon$ para todo $k, k' >= k_0$, probando así que $(f(x_k))_(k in NN) subset.eq Y$ es una sucesión de Cauchy. Dado que $Y$ es completo, existirá $z in Y$ tal que $f(x_k) -> z$. Como $x_k = f^(-1)(f(x_k))$ y $f^(-1)$ es continua, se tiene que $x_k -> f^(-1)(z)$ (Teo. 5.7), por lo tanto la sucesión $(x_k)_(k in NN)$ es convergente, permitiendo concluir la completitud de $X$. #align(right)[$square$]

  _Nota_: el primer párrafo es, palabra por palabra, el Ej. 14 de la práctica (uniformemente continua $=>$ manda sucesiones de Cauchy en sucesiones de Cauchy); el resto muestra para qué sirve. Maximenko (fuente O5, diapositivas 35--36) deja la misma proposición como ejercicio.

  _Fuente_: P. Gajardo Adaro, _Análisis I_ (UTFSM, versión marzo 2021), Ejercicios resueltos de la Parte 1, (E7) a), pág. 61 del PDF. #link("https://matematica.usm.cl/wp-content/uploads/2018/09/analisis1_utfsm_202103.pdf")[URL]. Acceso: web del departamento, sin licencia explícita.
]

// ---- O14-9  |  p4: Ej. 13, 14  |  teoría: sucesiones de Cauchy (Cap. 4), Def. 5.14, Obs. 5.16; Ejercicio 5.19  |  nivel: media
#ejemplo[Uniformemente continua manda Cauchy en Cauchy; $log$ no es uniformemente continua en $(0, +oo)$ (Payá, Uniforme 2014-15, §11.3)][O14-9][
  Sean $E$ y $F$ espacios métricos y $f : E -> F$ uniformemente continua. Si $(x_n)_(n in NN)$ es una sucesión de Cauchy de puntos de $E$, entonces $(f(x_n))_(n in NN)$ es una sucesión de Cauchy en $F$. Deducir que $log : (0, +oo) -> RR$ no es uniformemente continua.
]

#resolucion[
  Dado $epsilon > 0$, sea $delta > 0$ dado por la continuidad uniforme de $f$. Entonces existe $m in NN$ tal que para $p, q >= m$ se tiene $d(x_p, x_q) < delta$, de donde $d(f(x_p), f(x_q)) < epsilon$.

  La observación carece de interés cuando $E$ es completo, pues entonces la sucesión de Cauchy $(x_n)_(n in NN)$ es convergente y la continuidad de $f$ basta para que $(f(x_n))_(n in NN)$ sea convergente. Cuando $E$ no es completo, sirve para probar fácilmente que una función *no* es uniformemente continua: la función $log : (0, +oo) -> RR$ no es uniformemente continua, pues $(1 slash n)_(n in NN)$ es una sucesión de Cauchy de puntos de $(0, +oo)$ pero $(log(1 slash n))_(n in NN) = (-log n)_(n in NN)$ no es de Cauchy.

  _Nota_: la fuente escribe en la demostración "$d(x_p, y_q) < delta$, de donde $d(f(x_p), f(y_q)) < epsilon$"; es una errata por $x_q$ (no hay ninguna sucesión $(y_n)$). El mismo criterio resuelve el Ej. 13 ($1 slash x$ con $x_n = 1 slash n$, Cauchy en $(0, +oo)$, imagen $n$ no acotada) y es el Ej. 14 de la Práctica 4.

  _Fuente_: R. Payá Albert, _Análisis Matemático I_ (UGR, curso 2014-15), Lección 11 "Continuidad uniforme", §11.3 "Extensión de funciones uniformemente continuas", pág. 3 del PDF (65 impresa). #link("https://www.ugr.es/~rpaya/documentos/AnalisisI/2014-15/Uniforme.pdf")[URL]. Acceso: web del docente en la UGR; sin licencia explícita.
]

// ---- O3-9  |  p4: Ej. 14  |  teoría: Def. 4.51 (Cauchy), Cor. 4.47 (cerrados vía sucesiones), Teo. 5.7, Def. 5.14, Def. 5.29 (homeomorfismo)  |  nivel: media
#ejemplo[Un homeomorfismo cuya inversa no manda Cauchy en Cauchy: $RR$ y la circunferencia pinchada (Daniilidis, Ej. 2.5.5)][O3-9][
  Sea $S$ la circunferencia unitaria de $RR^2$ centrada en el punto $(0, 1)$, es decir,
  $ S = {(x, y) in RR^2 : x^2 + (y - 1)^2 = 1}, $
  y consideramos el espacio métrico $Y = S without {(0, 2)}$ con la métrica $d$ inducida por (cualquier norma de) $RR^2$. Mostrar que $(Y, d)$ es homeomorfo a $(RR, abs(dot))$ (es decir, existe $f : RR -> Y$ biyectiva con $f$ y $f^(-1)$ continuas) pero que $f^(-1)$ no respeta las sucesiones de Cauchy; en particular, $f^(-1) : Y -> RR$ es continua pero no uniformemente continua.
]

#resolucion[
  Dicho espacio $Y$ no es completo (ya que $Y$ no es cerrado en $RR^2$: le falta el punto $(0, 2)$, que es límite de puntos de $Y$; la fuente cita su Proposición 2.4.3, "un subconjunto de un completo es completo si y sólo si es cerrado"). Sin embargo, $(Y, d)$ es homeomorfo a $(RR, abs(dot))$, que es completo. En efecto, definimos la función $f : RR -> S without {(0, 2)}$ tal que para todo $t in RR$ entrega la intersección entre $S without {(0, 2)}$ y la recta que pasa por $(t, 0)$ y $(0, 2)$ (proyección estereográfica). La fórmula explícita que define la función es
  $ f(t) = ((4t) / (4 + t^2), thick 2 - 8 / (4 + t^2)). $
  Es fácil convencerse (mirando el dibujo) de que $f$ es biyectiva y de que tanto $f$ como $f^(-1)$ son funciones continuas. Por otra parte, $f^(-1)$ no respeta las sucesiones de Cauchy: en efecto, la sucesión $x_n = n$, $n in NN$, de $RR$ es la imagen por $f^(-1)$ de la sucesión $y_n = f(x_n)$, que es de Cauchy en $Y$ (ya que es convergente en $S = overline(Y)$: $f(n) -> (0, 2)$), mientras que $(x_n)_(n in NN)$ no es de Cauchy en $RR$. En particular, $f$ no es un homeomorfismo uniforme (es decir, $f$ y $f^(-1)$ no son ambas uniformemente continuas). #align(right)[$square$]

  _Nota_: la fuente deja la biyectividad y la continuidad de $f$ y $f^(-1)$ al dibujo; la continuidad de $f$ sale de que sus coordenadas son cocientes de polinomios con denominador no nulo (O2-2), y $f^(-1)(x, y) = 2x \/ (2 - y)$ (deducción propia: de la fórmula, $4 + t^2 = 8 \/ (2 - y)$ y $t = x (4 + t^2) \/ 4$). Lo que entrena el ítem es la *contrarrecíproca del Ej. 14*: como $f^(-1)$ es continua pero manda la sucesión de Cauchy $(f(n))_(n in NN)$ en la sucesión $(n)_(n in NN)$, que no es de Cauchy, $f^(-1)$ no puede ser uniformemente continua.

  _Fuente_: Daniilidis, Ejemplo 2.5.5 (Homeomorfismo vs completitud) y Definición 2.5.4, págs. 119--120 del PDF. #link("https://www.dim.uchile.cl/~arisd/Espacios%20Metricos%20(U3).pdf")[URL]. Acceso: web del docente; sin licencia explícita.
]

// ---- O3-10  |  p4: Ej. 12, 14  |  teoría: Def. 4.51 (Cauchy), Teo. 4.57 (R completo), Def. 5.24 (Lipschitz)  |  nivel: media
#ejemplo[La función $x |-> lim_n d(z_n, x)$, con $(z_n)_n$ de Cauchy, es $1$-Lipschitz (Daniilidis, Lema 2.4.33)][O3-10][
  Sea $(z_n)_(n in NN)$ una sucesión de Cauchy en un espacio métrico $(X, d)$. Entonces:
  #set enum(numbering: "(i)")
  + para todo $x in X$ la sucesión $t_n := d(z_n, x)$, $n in NN$, es de Cauchy (convergente) en $RR$;
  + la función $phi : X -> RR$ definida por
    $ phi(x) := lim_(n -> infinity) d(z_n, x) $
    es Lipschitz continua.
]

#resolucion[
  (i) Sea $epsilon > 0$. Entonces existe $n_0 in NN$ tal que para todo $n, m > n_0$ se tiene que $d(z_n, z_m) < epsilon$. Sea $x in X$ arbitrario. Por la desigualdad triangular se tiene que
  $ d(z_n, x) <= d(z_n, z_m) + d(z_m, x), $
  por lo tanto, intercambiando $z_n$ y $z_m$, se obtiene eventualmente que
  $ abs(t_n - t_m) <= d(z_n, z_m) < epsilon, $
  es decir, $(t_n)_(n in NN)$ es de Cauchy.

  (ii) La función $phi$ está bien definida (ya que las sucesiones de Cauchy en $RR$ son convergentes). Sean $x, y in X$. Utilizando nuevamente la desigualdad triangular se tiene que $d(z_n, x) <= d(z_n, y) + d(y, x)$. Tomando el límite cuando $n -> infinity$ (y observando que $x, y$ se pueden intercambiar) se obtiene que $phi$ es Lipschitz continua con constante $L = 1$. #align(right)[$square$]

  _Nota_: es la misma cuenta que prueba que $d(dot, x_0)$ es $1$-Lipschitz (Ej. 12), pero con un "punto ideal" $(z_n)_n$ en lugar de $x_0$; si $z_n -> z$, entonces $phi = d(dot, z)$. La parte (i) es, además, una instancia del Ej. 14 (la función $1$-Lipschitz $d(dot, x)$ manda la Cauchy $(z_n)_n$ en la Cauchy $(t_n)_n$).

  _Fuente_: Daniilidis, Lema 2.4.33, pág. 116 del PDF. #link("https://www.dim.uchile.cl/~arisd/Espacios%20Metricos%20(U3).pdf")[URL]. Acceso: web del docente; sin licencia explícita.
]

// ---- O2-6  |  p4: Ej. 4, 7 (a), 14  |  teoría: Teo. 5.7, Prop. 4.46, Def. 4.51, Def. 4.55, Def. 5.14, Def. 5.20, Teo. 5.22 (la misma extensión; la unicidad es el Ejercicio 5.23), Def. 5.33 y Obs. 5.34 (caso isometría)  |  nivel: alta (segunda lectura del Teo. 5.22)
#ejemplo[Extensión de funciones definidas sobre un denso: unicidad y existencia (Guccione, Teo. 6.28)][O2-6][
  Supongamos que $A subset.eq X$ es un conjunto denso y $f : A -> Y$ es una función continua. Los siguientes hechos valen:
  + Si $g : X -> Y$ y $h : X -> Y$ son funciones continuas que extienden a $f$, entonces $g = h$.
  + Si $f$ es uniformemente continua e $Y$ es completo, entonces existe una función uniformemente continua $g : X -> Y$ que extiende a $f$. Además, si $f$ es una isometría, entonces $g$ también lo es.
]

#resolucion[
  1. Denotemos con $C$ a ${x in X : g(x) = h(x)}$. Debemos probar que $C = X$. Para ello, como $A subset.eq C$ y $overline(A) = X$, basta comprobar que $C$ es cerrado, pero esto es una consecuencia inmediata de que si $(x_n)_(n in NN)$ es una sucesión de puntos de $C$ y $x = lim_(n -> infinity) x_n$, entonces
  $ g(x) = lim_(n -> infinity) g(x_n) = lim_(n -> infinity) h(x_n) = h(x). $

  2. Fijemos un punto $x in X$ y tomemos una sucesión $(x_n)_(n in NN)$ de puntos de $A$ que tiende a $x$. Como $f$ es uniformemente continua, la sucesión $(f(x_n))_(n in NN)$ es de Cauchy y, por lo tanto, dado que $Y$ es completo, convergente. Definimos $g(x) = y$, donde $y = lim_(n -> infinity) f(x_n)$. Debemos probar que esta definición no depende de la sucesión elegida. Supongamos que empezando con otra sucesión $(x'_n)_(n in NN)$ de puntos de $A$ que tiende a $x$, obtenemos $y' = lim_(n -> infinity) f(x'_n)$. Entonces la sucesión $f(x_1), f(x'_1), f(x_2), f(x'_2), dots$ es convergente y tiene subsucesiones que convergen a $y$ e $y'$. En consecuencia, $y = y'$.

  Para concluir la demostración debemos probar que $g$ extiende a $f$, es uniformemente continua y es una isometría si $f$ lo es. Si $x in A$, entonces tomando $x_n = x$ para todo $n$, vemos que
  $ g(x) = lim_(n -> infinity) f(x_n) = f(x), $
  lo que muestra que $g$ extiende a $f$. Además, como $f$ es uniformemente continua, para todo $epsilon > 0$ existe $delta > 0$ tal que
  $ d(f(x), f(x')) < epsilon quad "si" x, x' in A "y" d(x, x') < delta. $
  Tomemos $x, x' in X$ tales que $d(x, x') < delta$ y elijamos sucesiones $(x_n)_(n in NN)$ y $(x'_n)_(n in NN)$ de puntos de $A$ tales que $x = lim_(n -> infinity) x_n$ y $x' = lim_(n -> infinity) x'_n$. Entonces $lim_(n -> infinity) d(x_n, x'_n) = d(x, x') < delta$, por lo que
  $ d(g(x), g(x')) = lim_(n -> infinity) d(f(x_n), f(x'_n)) <= epsilon. $
  (La fuente termina aquí la prueba de la continuidad uniforme; el caso de la isometría es análogo, reemplazando la desigualdad por la igualdad $d(f(x_n), f(x'_n)) = d(x_n, x'_n)$.)

  _Nota_: en el paso 2 la fuente usa, sin citarlo, que una función uniformemente continua manda sucesiones de Cauchy en sucesiones de Cauchy (su Observación 6.5, transcripta en O2-13), que la sucesión intercalada $f(x_1), f(x'_1), dots$ es de Cauchy por el mismo motivo (porque $x_1, x'_1, x_2, x'_2, dots$ tiende a $x$), y que $d$ es continua en $X times X$ (su Ejemplo 3.55, transcripto en O2-7). El punto 1 es exactamente el Ej. 7 (a) de la Práctica 4 y usa que ${g = h}$ es cerrado, que es el Ej. 4. El Ej. 7 (b) (inyectividad de $C([0, 1]) -> {QQ inter [0, 1] -> RR}$) es el caso $A = QQ inter [0, 1]$, $X = [0, 1]$.

  _Fuente_: J. A. Guccione y J. J. Guccione, _Espacios Métricos_ (FCEN-UBA, 2017), Teorema 6.28, págs. 105–106 del PDF (96–97 del apunte). #link("https://cms.dm.uba.ar/academico/materias/2docuat2018/calculo_avanzado/2017/apunte.pdf")[URL]. Acceso: web de la materia; copia permitida sin fines de lucro (ver portada).
]

// ---- O6-9  |  p4: Ej. 13, 14, 15  |  teoría: Def. 4.51, Teo. 4.57 (RR completo), Teo. 5.7, Def. 5.14, Teo. 5.22 (la ida, en intervalos); la vuelta usa O6-7  |  nivel: media
#proposicion[Uniformemente continua en $(a, b)$ $<==>$ se extiende con continuidad a $[a, b]$ (Lebl, Prop. 3.4.6)][
  Una función $f : (a, b) -> RR$ es uniformemente continua si y sólo si los límites
  $ L_a := lim_(x -> a) f(x) quad "y" quad L_b := lim_(x -> b) f(x) $
  existen y la función $tilde(f) : [a, b] -> RR$ definida por
  $ tilde(f)(x) := cases(f(x) &"si " x in (a, b), L_a &"si " x = a, L_b &"si " x = b) $
  es continua.
]

#demostracion[
  Una dirección es rápida. Si $tilde(f)$ es continua, entonces es uniformemente continua por el Teorema 3.4.4 (O6-7). Como $f$ es la restricción de $tilde(f)$ a $(a, b)$, $f$ también es uniformemente continua (ejercicio: la restricción de una uniformemente continua es uniformemente continua, Ejercicio 3.4.1 de la fuente).

  Supongamos ahora que $f$ es uniformemente continua. Primero hay que ver que los límites $L_a$ y $L_b$ existen. Concentrémonos en $L_a$. Tomamos $(x_n)_(n in NN)$ en $(a, b)$ con $lim_(n -> infinity) x_n = a$. La sucesión $(x_n)_(n in NN)$ es de Cauchy, así que por el Lema 3.4.5 (O6-8) la sucesión $(f(x_n))_(n in NN)$ es de Cauchy y por lo tanto convergente. Sea $L_1 := lim_(n -> infinity) f(x_n)$. Tomamos otra sucesión $(y_n)_(n in NN)$ en $(a, b)$ con $lim_(n -> infinity) y_n = a$. Por el mismo razonamiento obtenemos $L_2 := lim_(n -> infinity) f(y_n)$. Si mostramos que $L_1 = L_2$, entonces el límite $L_a = lim_(x -> a) f(x)$ existe. Sea $epsilon > 0$. Tomamos $delta > 0$ tal que $abs(x - y) < delta$ implica $abs(f(x) - f(y)) < epsilon \/ 3$. Tomamos $M in NN$ tal que para $n >= M$ valen $abs(a - x_n) < delta \/ 2$, $abs(a - y_n) < delta \/ 2$, $abs(f(x_n) - L_1) < epsilon \/ 3$ y $abs(f(y_n) - L_2) < epsilon \/ 3$. Entonces, para $n >= M$,
  $ abs(x_n - y_n) = abs(x_n - a + a - y_n) <= abs(x_n - a) + abs(a - y_n) < delta / 2 + delta / 2 = delta. $
  Luego
  $
    abs(L_1 - L_2) &= abs(L_1 - f(x_n) + f(x_n) - f(y_n) + f(y_n) - L_2) \
                   &<= abs(L_1 - f(x_n)) + abs(f(x_n) - f(y_n)) + abs(f(y_n) - L_2) \
                   &<= epsilon / 3 + epsilon / 3 + epsilon / 3 = epsilon.
  $
  Por lo tanto $L_1 = L_2$, y $L_a$ existe. Que $L_b$ existe queda como ejercicio (Ejercicio 3.4.2 de la fuente).

  Si $L_a = lim_(x -> a) f(x)$ existe, entonces $lim_(x -> a) tilde(f)(x)$ existe y vale $L_a$ (Prop. 3.1.15 de la fuente: el límite de una función en un punto no cambia al agregar el punto al dominio). Lo mismo para $L_b$. Luego $tilde(f)$ es continua en $a$ y en $b$. Y como $f$ es continua en cada $c in (a, b)$, también $tilde(f)$ es continua en cada $c in (a, b)$ (Prop. 3.1.15 otra vez). #align(right)[$square$]

  La fuente agrega una aplicación típica: si $f : (-1, 0) union (0, 1) -> RR$ es uniformemente continua, entonces $lim_(x -> 0) f(x)$ existe y la función tiene una singularidad evitable, es decir, se extiende a una función continua en $(-1, 1)$.

  _Nota_: este criterio decide de un golpe varios casos de p4 Ej. 13 y 15: $1 \/ x$ y $sin(1 \/ x)$ no tienen límite en $0^+$, así que no son uniformemente continuas en $(0, 1)$; y una continua en $(a, b)$ con límites finitos en los extremos sí lo es. La ida es un caso del Teorema 5.22 de `apuntes.typ`, con $E = (a, b)$ denso en $[a, b]$ y $RR$ completo; la vuelta todavía no está en el apunte.

  _Fuente_: J. Lebl, _Basic Analysis I_, v6.3, Proposición 3.4.6, págs. 140--141 del PDF. #link("https://www.jirka.org/ra/realanal.pdf")[URL]. Acceso: CC BY-NC-SA 4.0 / CC BY-SA 4.0.
]

// ---- O14-10  |  p4: Ej. 7, 14 (extensión por densidad)  |  teoría: clausura por sucesiones, Cauchy, completitud (Cap. 4), Teo. 5.7, Def. 5.14, Teo. 5.22 (la misma extensión), Ejercicio 5.23 (unicidad)  |  nivel: media (segunda lectura del Teo. 5.22)
#proposicion[Extensión de una función uniformemente continua a la clausura (Payá, Uniforme 2014-15, §11.3)][
  Sean $E$ y $F$ espacios métricos, $A subset.eq E$ no vacío y $g : A -> F$. Supongamos que $F$ es completo y que $g$ es uniformemente continua. Entonces existe una única función continua $f : overline(A) -> F$ que extiende a $g$ ($f(a) = g(a)$ para todo $a in A$). De hecho, $f$ es uniformemente continua.
]

#demostracion[
  *Definición de $f$.* Para $x in overline(A)$ existe una sucesión $(a_n)_(n in NN)$ de puntos de $A$ con $a_n -> x$; por ser $g$ uniformemente continua, $(g(a_n))_(n in NN)$ es de Cauchy en $F$ (O14-9), y como $F$ es completo, converge. Su límite sólo depende de $x$ y no de la sucesión: si $(b_n)_(n in NN)$ es otra sucesión de $A$ con $b_n -> x$, entonces $d(a_n, b_n) -> 0$ y, por la continuidad uniforme de $g$, $d(g(a_n), g(b_n)) -> 0$, lo que implica que $(g(a_n))$ y $(g(b_n))$ convergen al mismo límite. Escribimos pues $f(x) = lim_(n -> oo) g(a_n)$, con $(a_n)$ cualquier sucesión de $A$ que converja a $x$. Es claro que $f$ extiende a $g$: para $a in A$ tomamos $a_n = a$ para todo $n$.

  *$f$ es uniformemente continua.* Fijado $epsilon > 0$, la continuidad uniforme de $g$ da $delta > 0$ tal que $a, b in A$, $d(a, b) < delta ==> d(g(a), g(b)) < epsilon slash 2$. Para $x, y in overline(A)$ con $d(x, y) < delta slash 3$, sean $(a_n)$, $(b_n)$ sucesiones de $A$ con $a_n -> x$, $b_n -> y$. Existe $m$ tal que, para $n >= m$, $d(a_n, x) < delta slash 3$ y $d(b_n, y) < delta slash 3$. Entonces, para $n >= m$,
  $ d(a_n, b_n) <= d(a_n, x) + d(x, y) + d(y, b_n) < delta, quad "luego" quad d(g(a_n), g(b_n)) < epsilon slash 2 . $
  Como $g(a_n) -> f(x)$ y $g(b_n) -> f(y)$, se tiene $d(g(a_n), g(b_n)) -> d(f(x), f(y))$, y concluimos $d(f(x), f(y)) <= epsilon slash 2 < epsilon$.

  *Unicidad.* Sea $phi : overline(A) -> F$ otra función continua que extienda a $g$. Fijado $x in overline(A)$ tomamos $a_n in A$ con $a_n -> x$; por ser $phi$ extensión continua de $g$, $g(a_n) = phi(a_n) -> phi(x)$, pero por definición $g(a_n) -> f(x)$, luego $phi(x) = f(x)$.

  _Nota_: la fuente combina esto con Heine: si $A subset.eq RR^N$ es acotado y $g : A -> RR$ continua, $g$ se extiende con continuidad a $overline(A)$ si y sólo si $g$ es uniformemente continua (necesidad: $overline(A)$ compacto, la extensión es uniformemente continua y $g$ es su restricción). Esto explica el Ej. 13: $1 slash x$ y $sin(1 slash x)$ no se extienden a $x = 0$. La unicidad usa sólo continuidad y densidad: es el Ej. 7 (a) de la Práctica 4 con la demostración por sucesiones. Que $d(g(a_n), g(b_n)) -> d(f(x), f(y))$ es la continuidad de $d$ (O2-7).

  _Fuente_: R. Payá Albert, _Análisis Matemático I_ (UGR, 2014-15), Lección 11, §11.3, págs. 3--4 del PDF (65--66 impresas). #link("https://www.ugr.es/~rpaya/documentos/AnalisisI/2014-15/Uniforme.pdf")[URL]. Acceso: web del docente en la UGR; sin licencia explícita.
]

// ---- O3-12  |  p4: Ej. 13, 14  |  teoría: Def. 4.51, Def. 4.55 (completo), Teo. 5.7, Def. 5.14, Teo. 5.22 (extensión a la clausura)  |  nivel: baja
#proposicion[Extensión continua a un $G_delta$ entre $A$ y $overline(A)$ (Daniilidis, Cor. 2.5.17, sólo enunciado)][
  Sea $(X, d)$ un espacio métrico y sea $(Y, d')$ un espacio métrico *completo*. Sea $A subset.eq X$ y $f : A -> Y$ continua. Entonces existe un conjunto $G subset.eq X$, que es $G_delta$ (intersección numerable de abiertos), tal que $A subset.eq G subset.eq overline(A)$ y existe $phi : G -> Y$ extensión continua de $f$, es decir $phi|_A = f$. Además, dicha extensión se define de forma única. Concretamente,
  $ G = inter.big_(n = 1)^infinity G_n, quad G_n = {x in overline(A) : "existe" delta_x > 0 "con" thick op("diam")_(d') (f(B(x, delta_x) inter A)) < 1 / n}. $
]

#estrategia[Idea de la fuente (demostración completa en págs. 128--129 del PDF)][
  Si $x in G$ y $(x_n)_n, (y_n)_n subset.eq A$ convergen a $x$, el diámetro pequeño de $f(B(x, delta_x) inter A)$ obliga a que $(f(x_n))_n$, $(f(y_n))_n$ sean de Cauchy con el mismo límite (acá se usa que $Y$ es completo); eso define $phi(x)$ y hace continua a $phi|_(A union {x})$. Se concluye por el Lema 2.5.16 (O3-2) con $A$ denso en $G$.
]

#ejemplo[Uniformemente continua $==>$ se extiende a la clausura; $sin(1 \/ t)$ no se extiende (Daniilidis, Obs. 2.5.18 y Ej. 2.5.19)][O3-12][
  #set enum(numbering: "a)")
  + Con la notación del Corolario 2.5.17, supongamos que $f : A -> Y$ es uniformemente continua (e $Y$ completo). Probar que $G = overline(A)$, es decir, $f$ admite una extensión continua a toda la clausura $overline(A)$.
  + Sea $A = (0, 1]$, $X = Y = RR$ y $f(t) = sin(1 \/ t)$, $t in A$. Entonces $G = A subset.eq.not overline(A)$, es decir, $f$ no admite ninguna extensión continua a $overline(A) = [0, 1]$.
]

#resolucion[
  *a)* Tomando $epsilon = 1 \/ (2n)$ en la definición de continuidad uniforme deducimos
  $ exists delta > 0, thick forall x_1, x_2 in A : quad d(x_1, x_2) < delta ==> d'(f(x_1), f(x_2)) < 1 / (2n). $
  Si $x in overline(A)$, tomando $delta_x := delta \/ 2$ obtenemos $op("diam")_(d') (f(B(x, delta_x) inter A)) < 1 \/ n$ (dos puntos de $B(x, delta \/ 2) inter A$ distan menos de $delta$), por lo tanto $x in G_n$ para cada $n in NN$. Así $G_n = overline(A)$ para todo $n$, es decir $G = overline(A)$, y la extensión $phi$ del Corolario 2.5.17 es continua en todo $overline(A)$. #align(right)[$square$]

  *b)* La fuente sólo enuncia el ejemplo ("Entonces $G = A subset.eq.not overline(A)$"), sin desarrollarlo. La fuente agrega: "si $f$ no es uniformemente continua, entonces $G$ puede ser subconjunto estricto de $overline(A)$".

  _Nota 1_: en el PDF la Obs. 2.5.18 dice "$G_n = overline(A)$, es decir $G = A$" y termina con "$f$ es continua en $overline(A)$"; por el contexto debe leerse $G = overline(A)$ y "la extensión $phi$ es continua en $overline(A)$", que es como se transcribió. _Nota 2_: b) es el *Ej. 13* de la práctica leído al revés: $sin(1 \/ t)$ es continua y acotada en $(0, 1]$ pero, como $0 in overline(A)$ y $sin(1 \/ t)$ no tiene límite en $0$ (tomar $t_n = 1 \/ (n pi)$ y $s_n = 1 \/ (pi \/ 2 + 2 n pi)$, razonamiento propio), no hay extensión continua a $[0, 1]$; por a), $sin(1 \/ t)$ *no es uniformemente continua* en $(0, 1]$. Con $1 \/ t$ en $(0, 1]$ el mismo argumento funciona (no es acotada cerca de $0$, así que no se extiende).

  _Fuente_: Daniilidis, Corolario 2.5.17 (Extensión continua), Observación 2.5.18 (Extensión continua en $overline(A)$) y Ejemplo 2.5.19 (Inexistencia de extensión continua), págs. 128--130 del PDF. #link("https://www.dim.uchile.cl/~arisd/Espacios%20Metricos%20(U3).pdf")[URL]. Acceso: web del docente; sin licencia explícita.
]


== Bloque 12 · Anticipo de la Práctica 5: continua en un compacto es uniformemente continua

#sublema(titulo: "Qué desbloquea")[
  El teorema de Heine explica por qué los contraejemplos de los *Ejercicios 13 y 15* viven en dominios no acotados o no cerrados. Usa compacidad, que es tema de la Práctica 5.
]

// ---- O6-7  |  p4: Ej. 13, 15  |  teoría: Def. 5.14, Teo. 5.7; usa Bolzano–Weierstrass en RR, que apuntes.typ no enuncia; falta: compacidad  |  nivel: teoría
#proposicion[Continua en $[a, b]$ implica uniformemente continua (Lebl, Teo. 3.4.4)][
  Sea $f : [a, b] -> RR$ una función continua. Entonces $f$ es uniformemente continua.
]

#demostracion[
  Probamos el contrarrecíproco. Supongamos que $f$ no es uniformemente continua; vamos a probar que hay algún $c in [a, b]$ donde $f$ no es continua. Neguemos la definición de continuidad uniforme: existe $epsilon > 0$ tal que para todo $delta > 0$ existen puntos $x, y in [a, b]$ con $abs(x - y) < delta$ y $abs(f(x) - f(y)) >= epsilon$.

  Para ese $epsilon > 0$ encontramos sucesiones $(x_n)_(n in NN)$ e $(y_n)_(n in NN)$ tales que $abs(x_n - y_n) < 1 \/ n$ y $abs(f(x_n) - f(y_n)) >= epsilon$. Por Bolzano--Weierstrass existe una subsucesión convergente $(x_(n_k))_(k in NN)$. Sea $c := lim_(k -> infinity) x_(n_k)$. Como $a <= x_(n_k) <= b$ para todo $k$, tenemos $a <= c <= b$. Estimamos
  $
    abs(y_(n_k) - c) = abs(y_(n_k) - x_(n_k) + x_(n_k) - c) <= abs(y_(n_k) - x_(n_k)) + abs(x_(n_k) - c) < 1 / n_k + abs(x_(n_k) - c).
  $
  Como $1 \/ n_k$ y $abs(x_(n_k) - c)$ tienden a cero cuando $k -> infinity$, la sucesión $(y_(n_k))_(k in NN)$ converge y su límite es $c$. Ahora mostramos que $f$ no es continua en $c$. Estimamos
  $
    abs(f(x_(n_k)) - f(c)) &= abs(f(x_(n_k)) - f(y_(n_k)) + f(y_(n_k)) - f(c)) \
                           &>= abs(f(x_(n_k)) - f(y_(n_k))) - abs(f(y_(n_k)) - f(c)) \
                           &>= epsilon - abs(f(y_(n_k)) - f(c)).
  $
  En otras palabras,
  $ abs(f(x_(n_k)) - f(c)) + abs(f(y_(n_k)) - f(c)) >= epsilon. $
  Al menos una de las sucesiones $(f(x_(n_k)))_(k in NN)$ o $(f(y_(n_k)))_(k in NN)$ no puede converger a $f(c)$: si no, el lado izquierdo tendería a cero mientras el derecho es positivo. Luego $f$ no es continua en $c$. #align(right)[$square$]

  La fuente remarca qué es lo esencial: Bolzano--Weierstrass se puede aplicar porque $[a, b]$ es acotado, y el límite de la subsucesión queda en $[a, b]$ porque el intervalo es cerrado.

  _Nota_: es la versión en $RR$ del teorema "continua en un compacto $==>$ uniformemente continua" (Teo. 7.5.11 de la fuente, demostrado con el lema del cubrimiento de Lebesgue; la fuente O7 lo prueba con un subcubrimiento finito). Para la Práctica 4 alcanza esta versión: explica por qué $x^2$ y $sqrt(x)$ son uniformemente continuas en $[0, 1]$ (O6-11) aunque no sean Lipschitz o no sean uniformemente continuas en dominios más grandes.

  _Fuente_: J. Lebl, _Basic Analysis I_, v6.3, Teorema 3.4.4, pág. 139 del PDF. #link("https://www.jirka.org/ra/realanal.pdf")[URL]. Acceso: CC BY-NC-SA 4.0 / CC BY-SA 4.0.
]

// ---- O14-7  |  p4: Ej. 13 (restricción a [eps, +oo) no cubre), 15  |  teoría: Def. 5.14, Prop. 5.18 (misma técnica); falta: compacidad (toda sucesión tiene una parcial convergente)  |  nivel: baja (teoría que falta en apuntes.typ)
#proposicion[Teorema de Heine: continua sobre un compacto implica uniformemente continua (Payá, Apuntes 05, §5.3)][
  Sean $E$ y $F$ espacios métricos y $f : E -> F$ continua. Si $E$ es compacto (toda sucesión de puntos de $E$ admite una sucesión parcial convergente en $E$), entonces $f$ es uniformemente continua.
]

#demostracion[
  Por reducción al absurdo, suponemos que $f$ no es uniformemente continua. Por la proposición anterior (O14-6) existen sucesiones $(x_n)_(n in NN)$, $(y_n)_(n in NN)$ de puntos de $E$ y un $epsilon > 0$ tales que, para todo $n in NN$,
  $ d(x_n, y_n) < 1 slash n quad "y" quad d(f(x_n), f(y_n)) >= epsilon . $
  Por ser $E$ compacto, tenemos una sucesión parcial $(x_(sigma(n)))_(n in NN)$ que converge a un punto $x in E$. Puesto que $d(x_(sigma(n)), y_(sigma(n))) -> 0$, deducimos que también $y_(sigma(n)) -> x$. Como $f$ es continua, $f(x_(sigma(n))) -> f(x)$ y $f(y_(sigma(n))) -> f(x)$, luego $d(f(x_(sigma(n))), f(y_(sigma(n)))) -> 0$, lo cual es una contradicción, ya que $d(f(x_(sigma(n))), f(y_(sigma(n)))) >= epsilon$ para todo $n$.

  _Nota_: la fuente observa a continuación que la continuidad uniforme *no es local*: si $f : RR -> RR$ es continua, cada $x$ tiene un entorno $U$ con $f|_U$ uniformemente continua (por Heine), pero eso no implica que $f$ sea uniformemente continua (p. ej. $x^2$).

  _Fuente_: R. Payá Albert, _Análisis Matemático I_ (UGR, 2024-25), Tema 5, §5.3, "Teorema de Heine", pág. 4 del PDF (54 impresa); también versión 2014-15, §11.2, pág. 2. #link("https://www.ugr.es/~rpaya/documentos/AnalisisI/2024_25/Apuntes_05.pdf")[URL]. Acceso: web del docente en la UGR; sin licencia explícita.
]


== Bloque 13 · Listas de ejercicios sin resolver para practicar

#sublema(titulo: "Qué desbloquea")[
  Enunciados que la fuente deja sin resolver, con la indicación de qué pieza de los bloques anteriores los resuelve. Sirven para practicar después de leer el resto.
]

// ---- O11-8  |  p4: Ej. 3, 4, 5, 8, 11  |  teoría: Teo. 5.9, Ej. 5.10, Def. 5.20 (denso); falta: d(x, A), Urysohn  |  nivel: alta
#ejemplo[Ejercicios propuestos de continuidad, sin resolución (BUAP, §5.6)][O11-8][
  En todos los casos $X$ e $Y$ son espacios métricos. La fuente sólo da los enunciados.
  + *(Ej. 4)* Sean $A subset.eq X$ y $f : A -> RR$ continua en $A$. Demostrar que si $a in A$ y $c in RR$ con $f(a) < c$, entonces existe una vecindad $V$ de $a$ tal que para cada $x in A inter V$ se cumple que $f(x) < c$.
  + *(Ej. 7)* Sean $A subset.eq X$ y $f : A -> Y$ continua en $A$. Probar que para cualquier $b in Y$, el conjunto $B = {x in A : f(x) = b}$ es cerrado del subespacio $A$.
  + *(Ej. 8)* Sea $f : RR -> RR$ continua. Demostrar que el conjunto de las raíces de la ecuación $f(x) = 0$ es cerrado de $RR$.
  + *(Ej. 10)* Sea $f : X -> RR$. Demostrar que $f$ es continua en $X$ si y sólo si, para todo $alpha in RR$, los conjuntos $A_alpha = {x in X : f(x) < alpha}$ y $B_alpha = {x in X : f(x) > alpha}$ son abiertos de $X$.
  + *(Ej. 11)* Probar que si $A$ y $B$ son conjuntos no vacíos, disjuntos y cerrados de $X$, entonces existen conjuntos $U$ y $V$ disjuntos y abiertos de $X$ tales que $A subset.eq U$ y $B subset.eq V$.
  + *(Ej. 13)* Sea $f : X -> Y$ continua y suryectiva. Demostrar que si $S$ es denso en $X$, entonces $f(S)$ es denso en $Y$.
  + *(Ej. 24)* Sean $A, B$ conjuntos disjuntos y cerrados de $X$. Demostrar que existe una función continua $f : X -> [0, 1]$ tal que $f(x) = 0$ para todo $x in A$ y $f(x) = 1$ para todo $x in B$.
]

#estrategia[Qué pieza de la fuente resuelve cada uno][
  Ej. 4 es el Ej. 3 de la práctica con $c = 0$ y signo cambiado (aplicar a $-f$); sale de la definición $epsilon$--$delta$ con $epsilon = c - f(a)$. Ej. 7 y 8 son preimágenes del cerrado ${b}$ (Ej. 5.10 del apunte), y el Ej. 7 es el Lema 5.21 (ítem O11-3) con $g$ constante. Ej. 10 es la caracterización por preimágenes de abiertos (Teo. 5.9 del apunte) usando que los intervalos $(-oo, alpha)$ y $(alpha, +oo)$ generan los abiertos de $RR$. Ej. 11 y 24 son el Ej. 11 de la práctica (Urysohn): la fuente tiene las herramientas en los Lemas 5.8--5.9 (acá, O7-1 y O2-8), y Wilson lo resuelve con $d_A - d_B$ (ítem O12-3). Ej. 13 es el Ej. 8 de la práctica; con el Teo. 5.13 del apunte, $Y = f(X) = f(overline(S)) subset.eq overline(f(S))$.

  _Fuente_: D. Herrera Carrasco, F. Macías Romero y L. A. Guerrero Méndez, _La magia de los espacios métricos_ (FCFM, BUAP, 2025), §5.6, Ejercicios 4, 7, 8, 10, 11, 13 y 24, págs. 138--141 del libro (147--150 del PDF). #link("https://www.fcfm.buap.mx/assets/docs/publicaciones/La_magia_de_los_espacios_metricos.pdf")[URL]. Acceso: "DR © Benemérita Universidad Autónoma de Puebla", ISBN 978-607-2637-10-8; sin licencia Creative Commons explícita.
]

// ---- O11-9  |  p4: Ej. 13, 14, 15, 16  |  teoría: Def. 5.14, Prop. 5.18, Teo. 5.22, Def. 5.24  |  nivel: media
#ejemplo[Ejercicios propuestos de continuidad uniforme, sin resolución (BUAP, §5.6)][O11-9][
  En todos los casos $X$ e $Y$ son espacios métricos. La fuente sólo da los enunciados.
  + *(Ej. 9)* Si $X$ es completo, $f : X -> Y$ es continua en $X$ y $(x_n)_(n in NN)$ es de Cauchy en $X$, entonces $(f(x_n))_(n in NN)$ es de Cauchy en $Y$.
  + *(Ej. 26)* Una $f : RR -> RR$ es _periódica_ de período $p$ si $f(x + p) = f(x)$ para todo $x in RR$. Demostrar que toda función periódica y continua en $RR$ es uniformemente continua en $RR$.
  + *(Ej. 40)* Demostrar que $f : X -> Y$ es uniformemente continua en $X$ si y sólo si para todo par de subconjuntos no vacíos $A, B$ de $X$, $d(A, B) = 0$ implica $d'(f(A), f(B)) = 0$.
  + *(Ej. 41)* Sea $f : (0, 1) -> RR$ dada por $f(x) = 1 / x$. Demostrar que $f$ es continua, pero no uniformemente continua en $(0, 1)$, y que su rango no es precompacto.
  + *(Ej. 42)* Sea $A subset.eq RR$ acotado. Probar que si $f : RR -> RR$ es uniformemente continua, entonces $f(A)$ es acotado. Dar un ejemplo donde la imagen continua de un conjunto acotado no sea acotada.
  + *(Ej. 44)* Sean $f, g : A subset.eq X -> RR$ uniformemente continuas en $A$. Demostrar que $f + g$ y $f g$ son uniformemente continuas en $A$.
  + *(Ej. 45)* Probar que si $f : (a, b) -> RR$ es uniformemente continua en $(a, b)$, entonces existen los límites de $f$ en $a$ y en $b$.
  + *(Ej. 50)* Sea $(X, d)$ un espacio métrico. Demostrar que la métrica $d$ es uniformemente continua (como función $X times X -> RR$).
]

#estrategia[Observaciones][
  Ej. 9 contrasta con el Teo. 5.43 (misma demostración en O6-8): sin completitud hace falta continuidad uniforme. Ej. 40: la implicación "$arrow.r.double$" es exactamente el Ej. 16 de la práctica; la recíproca es la parte no trivial (negar continuidad uniforme da sucesiones $x_n, y_n$ con $d(x_n, y_n) -> 0$ y $d'(f(x_n), f(y_n)) >= epsilon$; tomar $A = {x_n}$, $B = {y_n}$). Ej. 41 es el Ej. 13 de la práctica. Ej. 26 da una familia de ejemplos para el Ej. 15 (acotada, continua y uniformemente continua: $sin x$) y se prueba con Heine en $[0, 2p]$ (ver O6-7 y O14-7). Ej. 45 es la versión en $RR$ del Lema 5.47 (ver O2-6 y O14-10).

  _Nota_: el Ej. 44 tal como está enunciado es *falso* para el producto: $f(x) = g(x) = x$ son uniformemente continuas en $RR$ y $f g = x^2$ no lo es (ejemplo C6 del repositorio). Hace falta pedir $f$ y $g$ acotadas (o $A$ acotado), que es la versión que ya está en `ejemplos/p4.typ`. La suma sí es uniformemente continua sin hipótesis extra.

  _Fuente_: D. Herrera Carrasco, F. Macías Romero y L. A. Guerrero Méndez, _La magia de los espacios métricos_ (FCFM, BUAP, 2025), §5.6, Ejercicios 9, 26, 40, 41, 42, 44, 45 y 50, págs. 139--145 del libro (148--154 del PDF). #link("https://www.fcfm.buap.mx/assets/docs/publicaciones/La_magia_de_los_espacios_metricos.pdf")[URL]. Acceso: "DR © Benemérita Universidad Autónoma de Puebla", ISBN 978-607-2637-10-8; sin licencia Creative Commons explícita.
]


== Índice por ejercicio de la Práctica 4

Qué ítems de este archivo trabajan cada ejercicio de `guias/p4.typ` (según la línea de comentario de cada ítem; incluye los que dan contexto o teoría).

#text(size: 8.5pt)[
#table(
  columns: (0.35fr, 3fr),
  align: (center + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#065f46") } else if calc.even(y) { rgb("#f8fafc") } else { white },
  stroke: 0.4pt + rgb("#cbd5e1"),
  inset: (x: 6pt, y: 4pt),

  [*Ej.*], [*Ítems*],
  [1], [O15-1, O2-2, O14-4, O2-3, O16-5, O6-3, O15-2, O17-5, O14-1, O14-2, O14-3, O10-1, O15-3, O2-4, O17-4, O2-14, O11-5, O14-8],
  [2], [O2-1, O6-2, O16-3, O7-6],
  [3], [O6-4, O11-8],
  [4], [O16-6, O6-4, O4-5, O16-4, O11-3, O9-2, O14-12, O2-6, O11-8],
  [5], [O15-1, O2-2, O14-4, O2-3, O6-4, O10-2, O4-5, O16-4, O9-2, O16-2, O17-3, O11-8],
  [6], [O2-2, O15-3, O2-4, O11-2, O7-3, O17-4],
  [7], [O2-1, O3-1, O4-10, O11-4, O15-4, O3-2, O4-6, O6-12, O2-6, O14-10],
  [8], [O3-1, O4-10, O2-5, O9-1, O4-6, O11-8],
  [9], [O2-2, O17-1, O16-1, O16-2, O17-3, O6-6, O14-11, O8-1, O7-7],
  [10], [O7-7, O7-1, O10-3, O2-7, O4-4],
  [11], [O7-7, O2-8, O4-4, O2-9, O12-3, O2-10, O4-3, O14-12, O11-8],
  [12], [O14-11, O8-1, O7-7, O7-1, O2-7, O2-8, O14-12, O6-1, O5-1, O11-5, O7-2, O2-12, O6-11, O6-12, O3-10],
  [13], [O16-5, O16-6, O6-1, O3-8, O14-6, O5-1, O5-2, O5-3, O5-4, O2-11, O6-10, O7-2, O2-12, O14-9, O6-9, O3-12, O6-7, O14-7, O11-9],
  [14], [O6-1, O3-8, O6-8, O2-13, O4-7, O14-9, O3-9, O3-10, O2-6, O6-9, O14-10, O3-12, O11-9],
  [15], [O6-1, O3-8, O14-6, O5-1, O5-2, O5-3, O5-4, O2-14, O11-5, O14-8, O2-11, O7-2, O2-12, O6-11, O6-12, O6-9, O6-7, O14-7, O11-9],
  [16], [O2-10, O4-3, O6-1, O14-6, O11-9],
)
]

#v(6pt)
#align(center)[#text(9pt, style: "italic", fill: rgb("#64748b"))[(Práctica 4, edición 2026)]]
