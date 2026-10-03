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

// Fuente: `parciales/primer_parcial_1c2025.jpg` y `parciales/Enunciado_1C_2025.jpg` (dos fotos del mismo enunciado).
// Resolución de los ejercicios 2 y 3 (no del 1 ni del 4) en avanzadito:
// https://www.avanzadito.online/analisis-avanzado/parciales/2-1C2025/an-lisis-avanzado-1p-1c2025
// Resoluciones propuestas de los cuatro ejercicios al final de este archivo; cada una está
// verificada formalmente en `lean/Parciales/Parcial1_1C2025.lean` (Lean 4 + Mathlib).

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

#pagebreak()

= Resoluciones propuestas

#progreso[
  *Qué hay acá:* una resolución completa de cada uno de los cuatro ejercicios, escrita como
  para entregar en el examen. Las herramientas permitidas son las cajas de `apuntes.typ`
  (citadas por nombre y número) y los enunciados de las guías (citados como "Práctica $k$, Ej. $m$").

  *Verificación en Lean:* cada resolución tiene su contraparte formal en
  `lean/Parciales/Parcial1_1C2025.lean`, compilada con Lean 4 + Mathlib
  (`cd lean && lake build`). Al final de cada ejercicio, una caja _Observación_ dice qué
  teorema de ese archivo certifica el resultado y en qué difiere la formalización de la
  escritura a mano. Ninguna demostración usa `sorry`; los únicos axiomas que aparecen son los
  estándar de Lean (`propext`, `Classical.choice`, `Quot.sound`).

  *Convención de índices:* en el curso las sucesiones arrancan en $n = 1$; en Lean arrancan en
  $0$. La traducción es $a_n "(curso)" = a(n-1) "(Lean)"$ y ningún argumento depende de ella.
]

#v(8pt)

== Ejercicio 1

#enunciado[Ejercicio 1][
  Sea $A$ el conjunto de sucesiones $(a_n)_(n in NN)$ de números enteros que cumplen
  $a_(n+1) - a_n in {1, 2}$ para todo $n in NN$. Halle el cardinal de $A$.
]

#estrategia[Una sucesión de $A$ es su primer término más una lista infinita de decisiones][
  Conocer $(a_n)_n in A$ es lo mismo que conocer $a_1 in ZZ$ y, para cada $n$, cuál de los dos
  pasos posibles se dio: $a_(n+1) - a_n = 1$ o $a_(n+1) - a_n = 2$. Eso sugiere la biyección
  $A tilde.op ZZ times {1, 2}^NN$, y ${1,2}^NN tilde.op {0,1}^NN$ tiene cardinal $frak(c)$
  (Práctica 2, Ej. 9 (a)). Es el mismo esquema del Ejemplo C3-3 de `ejemplos/p2.typ`, con
  un término inicial libre en vez de fijo.
]

#resolucion[Propuesta][
  Vamos a probar que $\#A = frak(c) = \#RR$.

  *La codificación.* Definimos
  $ Phi : A -> ZZ times {1, 2}^NN, quad Phi((a_n)_n) = (a_1, (a_(n+1) - a_n)_(n in NN)). $
  Está bien definida: $a_1 in ZZ$ y, por la condición que define a $A$, cada diferencia
  $a_(n+1) - a_n$ está en ${1, 2}$.

  *$Phi$ es inyectiva.* Sean $(a_n)_n, (b_n)_n in A$ con $Phi((a_n)_n) = Phi((b_n)_n)$. Entonces
  $a_1 = b_1$ y $a_(n+1) - a_n = b_(n+1) - b_n$ para todo $n$. Por inducción en $n$ resulta
  $a_n = b_n$ para todo $n$: el caso base es $a_1 = b_1$, y si $a_n = b_n$ entonces
  $ a_(n+1) = a_n + (a_(n+1) - a_n) = b_n + (b_(n+1) - b_n) = b_(n+1). $
  Luego $(a_n)_n = (b_n)_n$.

  *$Phi$ es sobreyectiva.* Dado $(z, (d_n)_n) in ZZ times {1,2}^NN$, definimos recursivamente
  $a_1 = z$ y $a_(n+1) = a_n + d_n$. Cada $a_n$ es entero (suma de enteros) y
  $a_(n+1) - a_n = d_n in {1, 2}$, así que $(a_n)_n in A$; y por construcción
  $Phi((a_n)_n) = (a_1, (a_(n+1) - a_n)_n) = (z, (d_n)_n)$.

  Por lo tanto $A tilde.op ZZ times {1, 2}^NN$ (Definición 3.1) y $\#A = \#(ZZ times {1,2}^NN)$.

  *Cota inferior: $frak(c) <= \#A$.* La función ${0,1}^NN -> ZZ times {1,2}^NN$,
  $(b_n)_n |-> (0, (b_n + 1)_n)$, es inyectiva (de $(b_n + 1)_n$ se recupera $(b_n)_n$ restando
  $1$). Como ${0,1}^NN tilde.op [0, 1)$ (Práctica 2, Ej. 9 (a)) y $[0,1) tilde.op RR$
  (Observación 3.21), tenemos $\#{0,1}^NN = frak(c)$ y entonces
  $frak(c) <= \#(ZZ times {1,2}^NN) = \#A$ (Definición 3.8 y Observación 3.10).

  *Cota superior: $\#A <= frak(c)$.* Como ${1,2} subset.eq ZZ$, la inclusión
  $ZZ times {1,2}^NN arrow.hook ZZ times ZZ^NN$ es inyectiva. Además $\#(ZZ^NN) = frak(c)$
  (Lema de abajo) y $\#ZZ = aleph_0 <= frak(c)$, así que
  $ \#(ZZ times ZZ^NN) <= \#(RR times RR) = \#RR^2 = frak(c) $
  (si $f : ZZ -> RR$ y $g : ZZ^NN -> RR$ son inyectivas, $(z, a) |-> (f(z), g(a))$ es inyectiva;
  $\#RR^2 = frak(c)$ es la Práctica 2, Ej. 14 (c)). Luego $\#A <= frak(c)$.

  Por el Teorema 3.11 (Cantor--Schröeder--Bernstein), $\#A = frak(c)$. $qed$
]

#sublema(titulo: [Lema: $\#(ZZ^NN) = frak(c)$])[
  *$frak(c) <= \#ZZ^NN$:* ${0,1}^NN subset.eq ZZ^NN$ y $\#{0,1}^NN = frak(c)$ (como arriba).

  *$\#ZZ^NN <= frak(c)$:* la función $ZZ^NN -> cal(P)(NN times ZZ)$ que manda una sucesión a su
  gráfico, $(a_n)_n |-> {(n, a_n) : n in NN}$, es inyectiva (si dos sucesiones tienen el mismo
  gráfico, para cada $n$ el único par con primera coordenada $n$ coincide, así que
  $a_n = b_n$). Como $NN times ZZ tilde.op NN$ (Práctica 2, Ej. 1 (c)), vale
  $cal(P)(NN times ZZ) tilde.op cal(P)(NN)$ (Práctica 2, Ej. 8 (c)) y $\#cal(P)(NN) = frak(c)$
  (Práctica 2, Ej. 9 (b)). Luego $\#ZZ^NN <= frak(c)$, y por Cantor--Schröeder--Bernstein,
  $\#ZZ^NN = frak(c)$.
]

#observacion[Verificado en Lean: `Parcial1_1C2025.ej1`][
  `equivA : A ≃ ℤ × (ℕ → Bool)` es exactamente la biyección $Phi$ (con `true` = paso de
  longitud $2$); `reconstruir_pasos` y `pasos_reconstruir` son las dos composiciones. El
  teorema `ej1 : #A = 𝔠` termina con aritmética de cardinales de Mathlib
  ($aleph_0 dot 2^(aleph_0) = frak(c)$) en lugar de las dos inyecciones de arriba; `ej1'`
  reescribe la conclusión como $\#A = \#RR$.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 2

#enunciado[Ejercicio 2 (a)][
  Sea $A subset.eq RR$ no vacío y acotado. ¿Es cierto que $op("ínf")(A) = op("ínf")(overline(A))$?
]

#estrategia[Las cotas inferiores de $A$ pasan a la clausura][
  El ínfimo de $A$ es cota inferior de $overline(A)$ (una sucesión de $A$ que converge no
  puede bajar del ínfimo en el límite), así que $op("ínf") A <= op("ínf") overline(A)$. La otra
  desigualdad es gratis porque $A subset.eq overline(A)$.
]

#resolucion[Propuesta: es *verdadera*][
  Sea $i = op("ínf")(A)$, que existe por el Teorema 2 (completitud en términos de ínfimos).

  *$overline(A)$ es no vacío y acotado inferiormente.* No vacío porque $A subset.eq overline(A)$
  (Observación 4.23). Veamos que $i$ es cota inferior de $overline(A)$: sea $x in overline(A)$.
  Por la Proposición 4.46 (a), existe $(a_n)_n subset.eq A$ con $a_n -> x$. Como $i <= a_n$ para
  todo $n$, por la Práctica 1, Ej. 10 (los límites respetan $<=$) resulta $i <= x$.

  Entonces existe $j = op("ínf")(overline(A))$ (Teorema 2) y, como $i$ es una cota inferior de
  $overline(A)$ y $j$ es la *mayor* de ellas (Definición 5), $i <= j$.

  *$j <= i$.* Como $A subset.eq overline(A)$, toda cota inferior de $overline(A)$ lo es de $A$; en
  particular $j$ es cota inferior de $A$, y por ser $i$ la mayor de las cotas inferiores de $A$,
  $j <= i$. (Es la Práctica 1, Ej. 5 (b) con $A subset.eq overline(A)$.)

  Por lo tanto $op("ínf")(A) = op("ínf")(overline(A))$. $qed$
]

#enunciado[Ejercicio 2 (b)][
  Sea $A subset.eq RR$ no vacío y acotado. ¿Es cierto que $op("ínf")(A) = op("ínf")(A^compose)$?
]

#estrategia[Un punto aislado abajo no sobrevive al interior][
  El interior tira los puntos que no tienen una bola alrededor dentro de $A$. Si el ínfimo se
  alcanza en un punto aislado, el interior lo pierde y el ínfimo sube.
]

#resolucion[Propuesta: es *falsa*][
  Tomemos $A = {0} union [1, 2]$, que es no vacío y acotado (está contenido en $[0, 2]$).

  *$op("ínf")(A) = 0$.* El $0$ es cota inferior de $A$ (todo elemento de $A$ es $0$ o está en
  $[1,2]$) y $0 in A$, así que por la Proposición 6 (caracterización de ínfimo y mínimo)
  $op("ínf")(A) = 0$.

  *$A^compose = (1, 2)$.* Por un lado, $(1,2) = B(3/2, 1/2)$ es abierto (es una bola) y
  $(1,2) subset.eq A$, así que $(1,2) subset.eq A^compose$ por la Proposición 4.21. Por otro lado,
  $A^compose subset.eq A$ (Observación 4.12), y de los puntos de $A$ que no están en $(1,2)$
  ninguno es interior:
  - $0$: para todo $r > 0$, $-r/2 in B(0, r)$ y $-r/2 in.not A$.
  - $1$: para todo $r > 0$, el punto $1 - min(r, 1)/2$ está en $B(1, r)$ y en $(0, 1)$, que es
    disjunto de $A$.
  - $2$: para todo $r > 0$, $2 + r/2 in B(2, r)$ y $2 + r/2 in.not A$.
  Luego $A^compose = (1, 2)$.

  *$op("ínf")(A^compose) = 1$.* El $1$ es cota inferior de $(1,2)$, y para todo $epsilon > 0$ el
  punto $1 + min(epsilon, 1)/2 in (1,2)$ cumple $1 + min(epsilon,1)/2 < 1 + epsilon$; por la
  Proposición 5 (equivalencia de ínfimo), $op("ínf")((1,2)) = 1$.

  En conclusión, $op("ínf")(A) = 0 != 1 = op("ínf")(A^compose)$: la igualdad es falsa. $qed$
]

#observacion[Verificado en Lean: `Parcial1_1C2025.ej2a` y `ej2b`][
  `ej2a` prueba `sInf A = sInf (closure A)` para `A` no vacío y acotado inferiormente (la cota
  superior del enunciado no se usa). En Lean, "$op("ínf") A$ es cota inferior de
  $overline(A)$" sale de que $[op("ínf") A, oo)$ es cerrado y contiene a $A$
  (`closure_minimal`), en lugar de pasar por sucesiones. `ej2b` exhibe el conjunto
  `B = {0} ∪ Icc 1 2` con `interior_B : interior B = Ioo 1 2`, `sInf_B : sInf B = 0` y
  `sInf_interior_B : sInf (interior B) = 1`, y pide además que el interior sea no vacío para
  que los dos ínfimos existan de verdad (en Mathlib $op("ínf") emptyset = 0$ por convención,
  así que un contraejemplo con $A^compose = emptyset$ no serviría).
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 3

#enunciado[Ejercicio 3][
  Sea $(E, d)$ un espacio métrico y $U subset.eq E$. Pruebe que $U$ es abierto si y sólo si para
  todo $T subset.eq E$ vale $U inter overline(T) subset.eq overline(U inter T)$.
]

#estrategia[Ida: achicar la bola. Vuelta: particularizar en $T = E without U$][
  En la ida, un punto de $U inter overline(T)$ tiene una bola dentro de $U$ y toda bola suya toca
  a $T$; intersecando los dos radios, toda bola toca a $U inter T$. En la vuelta se elige
  $T = E without U$: el lado derecho es $overline(emptyset) = emptyset$, así que ningún punto de
  $U$ es adherente a $E without U$, que es decir que toda bola suya queda dentro de $U$.
  (Es el Ejemplo C4-6 de `ejemplos/p3.typ`, escrito con bolas.)
]

#resolucion[Propuesta][
  *($=>$)* Supongamos $U$ abierto y sea $T subset.eq E$. Sea $x in U inter overline(T)$ y sea
  $r > 0$; queremos ver que $B(x, r) inter (U inter T) != emptyset$ (Definición 4.22). Como $U$ es
  abierto y $x in U$, existe $s > 0$ con $B(x, s) subset.eq U$ (Definiciones 4.11 y 4.14). Sea
  $rho = min{r, s} > 0$. Como $x in overline(T)$, existe $y in B(x, rho) inter T$. Entonces
  $d(x, y) < rho <= s$, así que $y in B(x, s) subset.eq U$; y $d(x,y) < rho <= r$, así que
  $y in B(x, r)$. Luego $y in B(x, r) inter (U inter T)$, que es lo que queríamos. Como $r$ era
  arbitrario, $x in overline(U inter T)$.

  *($arrow.l.double$)* Supongamos que $U inter overline(T) subset.eq overline(U inter T)$ para todo
  $T subset.eq E$, y veamos que todo $x in U$ es interior. Sea $x in U$ y supongamos, por el
  absurdo, que ninguna bola centrada en $x$ está contenida en $U$: para todo $r > 0$,
  $B(x, r) subset.eq.not U$, es decir, $B(x, r) inter (E without U) != emptyset$. Eso dice
  exactamente que $x in overline(E without U)$. Aplicando la hipótesis con $T = E without U$,
  $ x in U inter overline(E without U) subset.eq overline(U inter (E without U)) = overline(emptyset) = emptyset, $
  donde $overline(emptyset) = emptyset$ porque ningún punto cumple
  $B(x, r) inter emptyset != emptyset$. Absurdo. Luego existe $r > 0$ con $B(x, r) subset.eq U$,
  es decir $x in U^compose$. Como $x in U$ era arbitrario, $U subset.eq U^compose$; junto con
  $U^compose subset.eq U$ (Observación 4.12), $U = U^compose$, y $U$ es abierto
  (Definición 4.14). $qed$
]

#observacion[Verificado en Lean: `Parcial1_1C2025.ej3`][
  Enunciado idéntico, para `[MetricSpace E]` (la prueba vale en cualquier espacio topológico).
  La ida es el lema de Mathlib `IsOpen.inter_closure`; la vuelta particulariza en `T = Uᶜ`,
  usa `closure_compl : closure Uᶜ = (interior U)ᶜ` y concluye `U ⊆ interior U`, que es
  `interior_eq_iff_isOpen`.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 4

#enunciado[Ejercicio 4 (a)][
  En $X = {(a_n)_n subset.eq RR : exists n_0, a_n = 0 " para todo " n >= n_0}$ con
  $d_oo (a, b) = sup{abs(a_n - b_n) : n in NN}$, sea
  $A = {(a_n)_n in X : a_n = 0 " para todo " n >= 4}$. Calcule $A^compose$ y $overline(A)$.
]

#sublema(titulo: [Lo único que se usa de $d_oo$])[
  Para $a, b in X$ y cada $n in NN$ vale $abs(a_n - b_n) <= d_oo (a, b)$ (un elemento es menor
  o igual que el supremo del conjunto). En particular, si $a^((k)) -> a$ en $(X, d_oo)$ entonces
  $a^((k))_n -> a_n$ en $RR$ para cada $n$ fijo (Práctica 1, Ej. 8: $abs(a^((k))_n - a_n)$ está
  acotado por $d_oo (a^((k)), a) -> 0$).
]

#estrategia[Perturbar la cuarta coordenada; pasar al límite coordenada a coordenada][
  Dado $a in A$ y una bola $B(a, r)$, la sucesión que coincide con $a$ salvo en la cuarta
  coordenada, donde vale $r/2$, está en la bola, está en $X$ y no está en $A$: ninguna bola
  entra en $A$. Para la clausura, una sucesión de elementos de $A$ que converge en $d_oo$ converge
  coordenada a coordenada, y las coordenadas $n >= 4$ son todas $0$, así que el límite también
  las tiene nulas.
]

#resolucion[Propuesta: $A^compose = emptyset$ y $overline(A) = A$][
  *$A^compose = emptyset$.* Como $A^compose subset.eq A$ (Observación 4.12), alcanza con ver que
  ningún $a in A$ es interior. Sea $a = (a_n)_n in A$ y $r > 0$. Definimos $b = (b_n)_n$ por
  $b_4 = r/2$ y $b_n = a_n$ para $n != 4$.
  - $b in X$: si $n_0$ es tal que $a_n = 0$ para $n >= n_0$, entonces $b_n = 0$ para
    $n >= max{n_0, 5}$.
  - $b in B(a, r)$: $abs(a_n - b_n)$ vale $abs(a_4 - r/2) = r/2$ si $n = 4$ (pues $a_4 = 0$ por
    ser $a in A$) y $0$ si no, así que $d_oo (a, b) = sup{0, r/2} = r/2 < r$.
  - $b in.not A$: $b_4 = r/2 != 0$.
  Luego $B(a, r) subset.eq.not A$ para todo $r > 0$, es decir $a in.not A^compose$
  (Definición 4.11). Por lo tanto $A^compose = emptyset$.

  *$overline(A) = A$.* Siempre $A subset.eq overline(A)$ (Observación 4.23). Sea $x in overline(A)$.
  Por la Proposición 4.46 (a) existe una sucesión $(a^((k)))_(k in NN) subset.eq A$ con
  $a^((k)) -> x$ en $(X, d_oo)$. Fijemos $n >= 4$. Por el detalle técnico de arriba,
  $a^((k))_n -> x_n$ en $RR$; pero $a^((k))_n = 0$ para todo $k$ (porque $a^((k)) in A$), así que
  la sucesión constante $0$ converge a $x_n$, y por unicidad del límite (Proposición 5 del
  Cap. 2) $x_n = 0$. Como esto vale para todo $n >= 4$, $x in A$. Luego
  $overline(A) subset.eq A$ y, por lo tanto, $overline(A) = A$: $A$ es cerrado
  (Definición 4.27). $qed$
]

#enunciado[Ejercicio 4 (b)][
  Pruebe que $(X, d_oo)$ no es completo.
]

#estrategia[Truncar $(1/n)_n$][
  La sucesión $(1/n)_n$ no está en $X$, pero sus truncadas $a^((N)) = (1, 1/2, dots, 1/N, 0, 0, dots)$
  sí. Dos truncadas difieren sólo en coordenadas $n > min{N, M}$, donde valen a lo sumo
  $1/(min{N,M}+1)$: son de Cauchy. Si convergieran en $X$, convergerían coordenada a
  coordenada a $(1/n)_n$, que no es eventualmente nula.
]

#resolucion[Propuesta][
  Para cada $N in NN$ sea $a^((N)) in X$ dada por $a^((N))_n = 1/n$ si $n <= N$ y $a^((N))_n = 0$
  si $n > N$ (es eventualmente nula, con $n_0 = N + 1$).

  *$(a^((N)))_N$ es de Cauchy.* Sean $N < M$ (si $N = M$ la distancia es $0$). Las coordenadas
  de $a^((N))$ y $a^((M))$ coinciden para $n <= N$ y para $n > M$; para $N < n <= M$ difieren en
  $abs(0 - 1/n) = 1/n <= 1/(N+1)$. Luego
  $ d_oo (a^((N)), a^((M))) = sup{1/n : N < n <= M} = 1/(N+1) < 1/N. $
  Dado $epsilon > 0$, por el Principio de Arquímedes (Proposición 1 del Cap. 1) existe
  $n_0 in NN$ con $1/n_0 < epsilon$; si $N, M >= n_0$, entonces
  $d_oo (a^((N)), a^((M))) < 1/min{N, M} <= 1/n_0 < epsilon$. Así, $(a^((N)))_N$ es de Cauchy
  (Definición 4.51).

  *No converge en $X$.* Supongamos que existe $b in X$ con $a^((N)) -> b$ en $(X, d_oo)$.
  Fijemos $n in NN$. Por el detalle técnico de (a), $a^((N))_n -> b_n$ en $RR$. Pero
  $a^((N))_n = 1/n$ para todo $N >= n$, así que la sucesión $(a^((N))_n)_N$ es eventualmente
  constante igual a $1/n$ y converge a $1/n$; por unicidad del límite, $b_n = 1/n$. Esto vale
  para todo $n in NN$, con lo cual $b = (1/n)_n$. Sin embargo, $b in X$ significa que existe
  $n_0$ con $b_n = 0$ para $n >= n_0$, y en particular $1/n_0 = b_(n_0) = 0$: absurdo.

  Encontramos una sucesión de Cauchy en $X$ que no converge en $X$, de modo que $(X, d_oo)$ no es
  completo. $qed$
]

#observacion[Verificado en Lean: `Parcial1_1C2025.ej4a_interior`, `ej4a_closure` y `ej4b`][
  `X` se modela como el subconjunto de `ℕ →ᵇ ℝ` (funciones acotadas $NN -> RR$, que en Mathlib
  llevan exactamente la métrica del supremo) de las sucesiones eventualmente nulas, con la
  métrica inducida; `A4` es el $A$ del enunciado, escrito `∀ n ≥ 3` por el corrimiento de
  índice. `ej4a_interior : interior A4 = ∅` construye la perturbación `a + (ε/2) • e₃`;
  `ej4a_closure : closure A4 = A4` sale de `ej4a_isClosed`, que escribe a `A4` como intersección
  de las preimágenes de ${0}$ por las evaluaciones (continuas) en las coordenadas $n >= 3$.
  `aN_cauchySeq` es la cuenta de Cauchy con la cota $1/(N+1)$, y `ej4b : ¬ CompleteSpace X`
  obtiene el límite `b`, pasa a la coordenada $n_0$ y llega a $0 = 1/(n_0 + 1)$.
]
