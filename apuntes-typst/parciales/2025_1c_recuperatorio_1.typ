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

// Fuente: `parciales/1 RECU 2025.JPG` (enunciado) y
// `parciales/AnalisisAvanzado_1recu_01-07-25.pdf` (enunciado + resolución corregida de un alumno).
// El nombre del PDF dice 01-07-25, pero el examen y las hojas están fechados 08/07/2025.
// Después del enunciado: resoluciones propuestas de los cuatro ejercicios, cada una verificada
// formalmente en `lean/Parciales/Recu1_1C2025.lean` (Lean 4 + Mathlib). Al final, la resolución
// de un alumno corregida por la cátedra.

#align(center)[
  #text(14pt, weight: "bold")[Análisis Avanzado - Primer cuatrimestre 2025] \
  #v(2pt)
  #text(12pt, weight: "medium")[Primer recuperatorio - 08/07/2025]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#set enum(numbering: "1.")

+ Sea $A$ el conjunto de sucesiones $(a_n)_(n in NN)$ de números enteros que cumplen
  $ a_n divides a_(n+1) quad "para todo " n in NN. $
  Halle el cardinal de $A$.

+ Dados $A, B subset.eq RR$ no vacíos, se define el conjunto suma de $A$ y $B$ como
  $ A + B = \{a + b : a in A, b in B\}. $
  Decida si las siguientes afirmaciones son verdaderas o falsas:
  #set enum(numbering: "a)")
  + Si $A, B subset.eq RR$ son acotados, entonces $op("sup")(A + B) = op("sup")(A) + op("sup")(B)$.
  + Si $(a_n)_(n in NN)$ y $(b_n)_(n in NN)$ son dos sucesiones acotadas de números reales, entonces
    $op("sup")(\{a_n + b_n\}_(n in NN)) = op("sup")(\{a_n\}_(n in NN)) + op("sup")(\{b_n\}_(n in NN))$.

+ Sea $(E, d)$ un espacio métrico. Sea $X subset.eq E$ tal que $overline(X) = E$. Pruebe que para todo abierto $U subset.eq E$ se tiene $overline(X inter U) = overline(U)$.

+ Se define la función $d : RR^n times RR^n -> RR$ como
  $ d(x, y) = op("máx")\{4/3 d_oo (x, y), d_2 (x, y)\}, $
  donde $d_oo (x, y) = op("máx", limits: #true)_(1 <= i <= n) abs(x_i - y_i)$ y $d_2 (x, y) = (sum_(i=1)^n (x_i - y_i)^2)^(1\/2)$.
  #set enum(numbering: "a)")
  + Pruebe que $(RR^n, d)$ es un espacio métrico.
  + Dibuje aproximadamente $B((0, 0), 1)$ en $(RR^2, d)$.
  + Pruebe que $d$ es una métrica equivalente a $d_oo$ y a $d_2$ en $RR^n$. ¿Es $(RR^n, d)$ un espacio métrico completo?

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
  *Qué hay acá:* una resolución completa de cada ejercicio, escrita como para entregar, usando
  sólo las cajas de `apuntes.typ` (citadas por nombre y número) y los enunciados de las guías
  (citados como "Práctica $k$, Ej. $m$"). Más abajo, en la sección siguiente, está la
  resolución de un alumno corregida por la cátedra, que sirve de contraste.

  *Verificación en Lean:* cada resolución tiene su contraparte formal en
  `lean/Parciales/Recu1_1C2025.lean`, compilada con Lean 4 + Mathlib (`cd lean && lake build`).
  Al final de cada ejercicio, una caja _Observación_ dice qué teorema de ese archivo certifica
  el resultado y en qué difiere la formalización de la escritura a mano. Ninguna demostración
  usa `sorry`; los únicos axiomas son los estándar de Lean (`propext`, `Classical.choice`,
  `Quot.sound`).

  *Convención de índices:* en el curso las sucesiones arrancan en $n = 1$; en Lean arrancan en
  $0$. Ningún argumento depende de ella.
]

#v(8pt)

== Ejercicio 1

#enunciado[Ejercicio 1][
  Sea $A$ el conjunto de sucesiones $(a_n)_(n in NN)$ de números enteros que cumplen
  $a_n divides a_(n+1)$ para todo $n in NN$. Halle el cardinal de $A$.
]

#estrategia[Potencias de $2$ con exponente creciente][
  La cota $\#A <= frak(c)$ es gratis porque $A subset.eq ZZ^NN$. Para la otra hace falta meter
  ${0,1}^NN$ dentro de $A$: una sucesión de ceros y unos se codifica como $a_n = 2^(s_n)$, donde
  $s_n$ cuenta los unos que aparecieron antes del lugar $n$. Como $s_n <= s_(n+1)$, cada término
  divide al siguiente, y de los $s_n$ se recupera la sucesión original mirando los saltos.
  (El alumno de la sección siguiente usa productos parciales $product_(i <= n) k_i$ con
  $k_i != 0$; es la misma idea con base variable.)
]

#resolucion[Propuesta][
  Vamos a probar que $\#A = frak(c) = \#RR$.

  *Cota superior.* $A subset.eq ZZ^NN$, así que $\#A <= \#ZZ^NN = frak(c)$ (Lema de abajo).

  *Cota inferior.* Para $b = (b_n)_n in {0,1}^NN$ definimos $s_1 = 0$ y
  $s_(n+1) = s_n + b_n$, es decir $s_n = b_1 + dots.c + b_(n-1)$ (la cantidad de unos entre
  $b_1, dots, b_(n-1)$), y
  $ Phi : {0,1}^NN -> ZZ^NN, quad Phi(b) = (2^(s_n))_(n in NN). $

  _$Phi$ toma valores en $A$._ Para todo $n$, $2^(s_(n+1)) = 2^(s_n) dot 2^(b_n)$ con
  $2^(b_n) in {1, 2} subset.eq ZZ$, así que $2^(s_n) divides 2^(s_(n+1))$, es decir
  $Phi(b)_n divides Phi(b)_(n+1)$.

  _$Phi$ es inyectiva._ Sean $b, b' in {0,1}^NN$ con $Phi(b) = Phi(b')$ y llamemos $s_n, s'_n$ a
  los respectivos exponentes. Para cada $n$, $2^(s_n) = 2^(s'_n)$ y, como $k |-> 2^k$ es
  inyectiva en $NN_0$ (es estrictamente creciente), $s_n = s'_n$. Entonces
  $ b_n = s_(n+1) - s_n = s'_(n+1) - s'_n = b'_n quad "para todo " n, $
  es decir $b = b'$.

  Luego $frak(c) = \#{0,1}^NN <= \#A$ (Definición 3.8), donde $\#{0,1}^NN = frak(c)$ porque
  ${0,1}^NN tilde.op [0,1)$ (Práctica 2, Ej. 9 (a)) y $[0,1) tilde.op RR$ (Observación 3.21).

  *Conclusión.* $frak(c) <= \#A <= frak(c)$ y, por el Teorema 3.11
  (Cantor--Schröeder--Bernstein), $\#A = frak(c)$. $qed$
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

#observacion[Verificado en Lean: `Recu1_1C2025.ej1`][
  `cuenta b n` es $s_n$, `codif b n = 2 ^ cuenta b n` es $Phi(b)_n$; `codif_mem` y
  `codif_injective` son los dos párrafos de arriba (la inyectividad de $k |-> 2^k$ es
  `Nat.pow_right_injective`). `ej1 : #A = 𝔠` cierra con `Cardinal.mk_set_le` (la inclusión
  $A subset.eq ZZ^NN$), `Cardinal.mk_le_of_injective` y la aritmética
  $aleph_0^(aleph_0) = 2^(aleph_0) = frak(c)$ de Mathlib en lugar del Lema; `ej1'` lo
  reescribe como $\#A = \#RR$.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 2

#enunciado[Ejercicio 2 a)][
  Dados $A, B subset.eq RR$ no vacíos, sea $A + B = {a + b : a in A, b in B}$. Si $A$ y $B$ son
  acotados, ¿vale $op("sup")(A + B) = op("sup")(A) + op("sup")(B)$?
]

#estrategia[Cota superior por un lado, $epsilon/2 + epsilon/2$ por el otro][
  $op("sup") A + op("sup") B$ es cota superior de $A + B$, lo que da $<=$. Para $>=$ se usa la
  caracterización con $epsilon$ del supremo (Proposición 3): hay $a_epsilon$, $b_epsilon$ a menos
  de $epsilon/2$ de cada supremo, y su suma está en $A + B$.
]

#resolucion[Propuesta: es *verdadera*][
  Como $A$ y $B$ son no vacíos y acotados superiormente, existen $alpha = op("sup")(A)$ y
  $beta = op("sup")(B)$ (Axioma de Completitud). Fijemos $a_0 in A$ y $b_0 in B$; entonces
  $a_0 + b_0 in A + B$, así que $A + B != emptyset$.

  *$alpha + beta$ es cota superior de $A + B$.* Si $x in A + B$, existen $a in A$, $b in B$ con
  $x = a + b$; como $a <= alpha$ y $b <= beta$, resulta $x <= alpha + beta$. En particular
  $A + B$ está acotado superiormente, existe $sigma = op("sup")(A + B)$ y, por ser la menor de
  las cotas superiores (Definición 2), $sigma <= alpha + beta$.

  *$alpha + beta <= sigma$.* Sea $epsilon > 0$. Por la Proposición 3 (equivalencia de supremo)
  aplicada a $A$ y a $B$ con $epsilon/2$, existen $a_epsilon in A$ y $b_epsilon in B$ tales que
  $alpha - epsilon/2 < a_epsilon$ y $beta - epsilon/2 < b_epsilon$. Sumando,
  $ alpha + beta - epsilon < a_epsilon + b_epsilon <= sigma, $
  donde la última desigualdad vale porque $a_epsilon + b_epsilon in A + B$ y $sigma$ es cota
  superior de $A + B$. Así $alpha + beta < sigma + epsilon$ para todo $epsilon > 0$, y por la
  Práctica 1, Ej. 1, $alpha + beta <= sigma$.

  Por lo tanto $op("sup")(A + B) = op("sup")(A) + op("sup")(B)$. $qed$
]

#enunciado[Ejercicio 2 b)][
  Si $(a_n)_n$ y $(b_n)_n$ son sucesiones acotadas de números reales, ¿vale
  $op("sup")({a_n + b_n}_n) = op("sup")({a_n}_n) + op("sup")({b_n}_n)$?
]

#estrategia[El supremo de la suma de sucesiones se toma sobre la diagonal][
  En $A + B$ se suman *todos* los pares $(a, b)$; en ${a_n + b_n}_n$ sólo los pares con el mismo
  índice. Si los máximos de las dos sucesiones están en índices distintos, la suma nunca los
  junta.
]

#resolucion[Propuesta: es *falsa*][
  Sean $a_1 = 1$, $b_1 = -1$ y $a_n = b_n = 0$ para todo $n >= 2$. Ambas sucesiones son acotadas
  ($abs(a_n) <= 1$ y $abs(b_n) <= 1$ para todo $n$).

  - ${a_n}_n = {1, 0}$ y $op("sup")({1, 0}) = 1$ ($1$ es cota superior y pertenece al conjunto;
    Proposición 4).
  - ${b_n}_n = {-1, 0}$ y $op("sup")({-1, 0}) = 0$ (misma razón).
  - $a_n + b_n = 0$ para todo $n$, así que ${a_n + b_n}_n = {0}$ y
    $op("sup")({0}) = 0$.

  Entonces $op("sup")({a_n + b_n}_n) = 0 != 1 = op("sup")({a_n}_n) + op("sup")({b_n}_n)$. $qed$

  _Lo que sí vale siempre_ es $op("sup")({a_n + b_n}_n) <= op("sup")({a_n}_n) + op("sup")({b_n}_n)$,
  porque ${a_n + b_n}_n subset.eq {a_n}_n + {b_n}_n$ y se aplica el ítem a) junto con la
  Práctica 1, Ej. 5 (a).
]

#observacion[Verificado en Lean: `Recu1_1C2025.ej2a` y `ej2b`][
  `sumSet A B` es $A + B$ tal como lo define el enunciado. `ej2a` prueba
  `sSup (sumSet A B) = sSup A + sSup B` pidiendo sólo que $A$ y $B$ sean no vacíos y acotados
  *superiormente*; el paso "$alpha + beta < sigma + epsilon$ para todo $epsilon$" es
  `le_of_forall_pos_lt_add` y los $a_epsilon$, $b_epsilon$ salen de `exists_lt_of_lt_csSup`.
  `ej2b` exhibe `a2`, `b2` (las sucesiones de arriba), calcula `Set.range a2 = {1, 0}`,
  `Set.range b2 = {-1, 0}` y `fun n => a2 n + b2 n = fun _ => 0`, y concluye $0 != 1$ con
  `csSup_pair` y `csSup_singleton`.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 3

#enunciado[Ejercicio 3][
  Sea $(E, d)$ un espacio métrico y $X subset.eq E$ con $overline(X) = E$. Pruebe que para todo
  abierto $U subset.eq E$ se tiene $overline(X inter U) = overline(U)$.
]

#estrategia[Una bola dentro de otra bola, y la densidad en la chica][
  Si $x in overline(U)$, cada bola $B(x, r)$ tiene un punto $u in U$; como $U$ es abierto hay una
  bola $B(u, rho)$ dentro de $U$, y se la puede achicar para que además quede dentro de
  $B(x, r)$. La densidad de $X$ pone un punto de $X$ en $B(u, rho)$, que entonces está en
  $X inter U inter B(x, r)$. (El alumno de la sección siguiente hace lo mismo con una sucesión
  de sucesiones; con bolas se evita la elección de índices.)
]

#resolucion[Propuesta][
  *$overline(X inter U) subset.eq overline(U)$.* Sea $z in overline(X inter U)$ y $r > 0$. Existe
  $y in B(z, r) inter (X inter U)$; en particular $y in B(z, r) inter U$, así que
  $B(z, r) inter U != emptyset$. Como $r$ era arbitrario, $z in overline(U)$ (Definición 4.22).

  *$overline(U) subset.eq overline(X inter U)$.* Sea $x in overline(U)$ y $r > 0$. Como
  $x in overline(U)$, existe $u in B(x, r) inter U$. Como $U$ es abierto, existe $s > 0$ con
  $B(u, s) subset.eq U$ (Definiciones 4.11 y 4.14). Sea
  $ rho = min{s, r - d(x, u)} > 0 $
  (es positivo porque $d(x, u) < r$). Como $u in E = overline(X)$, existe
  $y in B(u, rho) inter X$. Entonces:
  - $y in U$, porque $d(u, y) < rho <= s$ y $B(u, s) subset.eq U$;
  - $y in B(x, r)$, porque $d(x, y) <= d(x, u) + d(u, y) < d(x, u) + (r - d(x, u)) = r$
    (desigualdad triangular, Definición 4.1);
  - $y in X$ por elección.
  Luego $y in B(x, r) inter (X inter U)$, y como $r$ era arbitrario, $x in overline(X inter U)$.

  Por doble inclusión, $overline(X inter U) = overline(U)$. $qed$
]

#observacion[Verificado en Lean: `Recu1_1C2025.ej3`][
  Enunciado idéntico, con la hipótesis de densidad escrita como `closure X = Set.univ`. La
  primera inclusión es `closure_mono`; para la segunda, Lean prueba `U ⊆ closure (X ∩ U)`
  con `IsOpen.inter_closure` (el mismo lema que el Ejercicio 3 del primer parcial) y cierra con
  `closure_minimal`, que es "la clausura es el cerrado más chico que contiene a $U$".
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 4

#enunciado[Ejercicio 4 a)][
  Sea $d(x, y) = op("máx"){4/3 d_oo (x, y), d_2 (x, y)}$ en $RR^n$. Pruebe que $(RR^n, d)$ es
  un espacio métrico.
]

#estrategia[El máximo de dos métricas (reescaladas) es métrica][
  Cada axioma se verifica "coordenada a coordenada" del máximo. Para la desigualdad triangular
  hay que acotar *cada una* de las dos expresiones $4/3 d_oo (x, z)$ y $d_2 (x, z)$ por
  $d(x, y) + d(y, z)$, usando que cada sumando $d(x, y)$ es un máximo y domina a la expresión
  correspondiente.
]

#resolucion[Propuesta][
  Sabemos que $d_oo$ y $d_2$ son métricas en $RR^n$ (Práctica 3, Ej. 1 (b) y (d)). Sean
  $x, y, z in RR^n$.

  #set enum(numbering: "(i)")
  + *No negatividad.* $d(x, y) >= d_2 (x, y) >= 0$.
  + *Separación.* Si $x = y$, $d(x, x) = op("máx"){0, 0} = 0$. Recíprocamente, si $d(x, y) = 0$
    entonces $0 <= d_2 (x, y) <= d(x, y) = 0$, luego $d_2 (x, y) = 0$ y $x = y$ por ser $d_2$
    una métrica.
  + *Simetría.* $d(x, y) = op("máx"){4/3 d_oo (x, y), d_2 (x, y)} = op("máx"){4/3 d_oo (y, x), d_2 (y, x)} = d(y, x)$,
    por la simetría de $d_oo$ y de $d_2$.
  + *Desigualdad triangular.* Usamos que $4/3 d_oo (p, q) <= d(p, q)$ y $d_2 (p, q) <= d(p, q)$
    para todo $p, q$ (cada expresión es menor o igual que el máximo). Entonces
    $ 4/3 d_oo (x, z) &<= 4/3 d_oo (x, y) + 4/3 d_oo (y, z) <= d(x, y) + d(y, z), \
      d_2 (x, z) &<= d_2 (x, y) + d_2 (y, z) <= d(x, y) + d(y, z), $
    por las desigualdades triangulares de $d_oo$ y de $d_2$. Como $d(x, z)$ es el máximo de las
    dos expresiones de la izquierda y ambas están acotadas por $d(x, y) + d(y, z)$,
    $d(x, z) <= d(x, y) + d(y, z)$.

  Por lo tanto $d$ es una métrica y $(RR^n, d)$ es un espacio métrico (Definición 4.1). $qed$
]

#enunciado[Ejercicio 4 b)][
  Dibuje aproximadamente $B((0, 0), 1)$ en $(RR^2, d)$.
]

#resolucion[Propuesta][
  Para $p = (x, y) in RR^2$,
  $ p in B_d ((0,0), 1) &<==> op("máx"){4/3 d_oo (p, 0), d_2 (p, 0)} < 1 \
    &<==> d_oo (p, 0) < 3/4 " y " d_2 (p, 0) < 1 \
    &<==> abs(x) < 3/4, " " abs(y) < 3/4 " y " x^2 + y^2 < 1. $
  Es decir, $B_d ((0,0), 1) = B_(d_oo)((0,0), 3/4) inter B_(d_2)((0,0), 1)$: el cuadrado
  abierto de lado $3/2$ centrado en el origen, intersecado con el disco abierto de radio $1$.
  Los vértices del cuadrado, $(plus.minus 3/4, plus.minus 3/4)$, quedan afuera porque
  $(3/4)^2 + (3/4)^2 = 9/8 > 1$; los puntos medios de los lados, como $(3/4, 0)$, están en el
  borde del cuadrado y adentro del disco. El dibujo es entonces un cuadrado con las cuatro
  esquinas recortadas por arcos de la circunferencia unidad: sobre el lado $x = 3/4$ la
  condición $x^2 + y^2 < 1$ deja $abs(y) < sqrt(7)/4 approx 0.66$.
]

#block(breakable: false, width: 100%)[
  #align(center)[
    #cetz.canvas(length: 2.2cm, {
      import cetz.draw: *
      let s = 0.75
      let h = calc.sqrt(7) / 4
      let t1 = calc.atan2(s, h)
      let t2 = calc.atan2(h, s)

      line((-1.35, 0), (1.35, 0), stroke: 0.6pt + luma(120), mark: (end: "stealth", fill: luma(120)))
      line((0, -1.35), (0, 1.35), stroke: 0.6pt + luma(120), mark: (end: "stealth", fill: luma(120)))

      circle((0, 0), radius: 1, stroke: (paint: rgb("#dc2626"), dash: "dashed", thickness: 0.8pt))
      rect((-s, -s), (s, s), stroke: (paint: rgb("#2563eb"), dash: "dashed", thickness: 0.8pt))

      merge-path(close: true, fill: rgb("#bfdbfe").transparentize(30%), stroke: 1.2pt + rgb("#1e3a8a"), {
        line((s, -h), (s, h))
        arc((s, h), start: t1, stop: t2, radius: 1)
        line((h, s), (-h, s))
        arc((-h, s), start: 180deg - t2, stop: 180deg - t1, radius: 1)
        line((-s, h), (-s, -h))
        arc((-s, -h), start: 180deg + t1, stop: 180deg + t2, radius: 1)
        line((-h, -s), (h, -s))
        arc((h, -s), start: 360deg - t2, stop: 360deg - t1, radius: 1)
      })

      line((s, -0.04), (s, 0.04), stroke: 0.6pt)
      content((s, -0.17), text(size: 8pt)[$3/4$])
      line((1, -0.04), (1, 0.04), stroke: 0.6pt)
      content((1.02, -0.17), text(size: 8pt)[$1$])
      content((1.05, 1.1), text(size: 8pt, fill: rgb("#dc2626"))[$B_(d_2)((0,0),1)$])
      content((-0.95, 0.95), text(size: 8pt, fill: rgb("#2563eb"))[$B_(d_oo)((0,0),3/4)$])
      content((0, -1.5), text(size: 9pt, fill: rgb("#1e3a8a"))[$B_d ((0,0), 1)$])
    })
  ]
]

#enunciado[Ejercicio 4 c)][
  Pruebe que $d$ es equivalente a $d_oo$ y a $d_2$ en $RR^n$. ¿Es $(RR^n, d)$ completo?
]

#estrategia[Encajar $d$ entre múltiplos de $d_2$ y de $d_oo$][
  Dos métricas con $c_1 d' <= d <= c_2 d'$ ($c_1, c_2 > 0$) tienen las mismas bolas "a menos de
  reescalar el radio", así que los mismos abiertos, las mismas sucesiones convergentes y las
  mismas sucesiones de Cauchy. Las desigualdades salen de la Práctica 3, Ej. 12 (a):
  $d_oo <= d_2 <= n d_oo$. Para la completitud, una sucesión de Cauchy para $d$ lo es para
  $d_oo$, converge ahí (Práctica 3, Ej. 14) y la convergencia vuelve a $d$.
]

#resolucion[Propuesta][
  *Las desigualdades.* Sean $x, y in RR^n$. Por definición de máximo, $d_2 (x, y) <= d(x, y)$. Por
  la Práctica 3, Ej. 12 (a), $d_oo (x, y) <= d_2 (x, y)$, así que
  $4/3 d_oo (x, y) <= 4/3 d_2 (x, y)$ y también $d_2 (x, y) <= 4/3 d_2 (x, y)$; como $d(x, y)$ es
  el máximo de dos cantidades acotadas por $4/3 d_2 (x,y)$,
  $ d_2 (x, y) <= d(x, y) <= 4/3 d_2 (x, y). $
  Usando además $d_oo <= d_2 <= n d_oo$ (Práctica 3, Ej. 12 (a)),
  $ d_oo (x, y) <= d_2 (x, y) <= d(x, y) <= 4/3 d_2 (x, y) <= (4 n)/3 d_oo (x, y). $

  *Equivalencia.* Sean $d'$ cualquiera de $d_2$ o $d_oo$ y $c >= 1$ tal que
  $d' <= d <= c d'$ (con $c = 4/3$ o $c = 4n/3$). Para $x in RR^n$ y $r > 0$:
  $ B_d (x, r) subset.eq B_(d') (x, r) quad "y" quad B_(d') (x, r/c) subset.eq B_d (x, r), $
  pues $d'(x, y) <= d(x, y) < r$ en el primer caso y $d(x, y) <= c d'(x,y) < r$ en el segundo.
  Entonces un conjunto $G$ es abierto para $d$ si y sólo si lo es para $d'$: si $G$ es
  $d$-abierto y $x in G$, hay $r > 0$ con $B_d (x, r) subset.eq G$, y entonces
  $B_(d')(x, r/c) subset.eq B_d (x, r) subset.eq G$; recíprocamente, si $G$ es $d'$-abierto y
  $B_(d')(x, r) subset.eq G$, entonces $B_d (x, r) subset.eq B_(d')(x, r) subset.eq G$. Luego $d$
  es equivalente a $d_2$ y a $d_oo$ (tienen los mismos abiertos; de hecho son uniformemente
  equivalentes).

  *Completitud.* Sea $(x_k)_k$ de Cauchy en $(RR^n, d)$. Como $d_oo <= d$, dado $epsilon > 0$ el
  $k_0$ que da $d(x_k, x_j) < epsilon$ para $k, j >= k_0$ también da
  $d_oo (x_k, x_j) < epsilon$: $(x_k)_k$ es de Cauchy en $(RR^n, d_oo)$. Por la Práctica 3,
  Ej. 14, $(RR^n, d_oo)$ es completo, así que existe $x in RR^n$ con $d_oo (x_k, x) -> 0$.
  Finalmente $0 <= d(x_k, x) <= (4n)/3 d_oo (x_k, x) -> 0$, y por la Práctica 1, Ej. 8,
  $d(x_k, x) -> 0$, es decir $x_k -> x$ en $(RR^n, d)$ (Observación 4.43). Toda sucesión de
  Cauchy converge: $(RR^n, d)$ es completo. $qed$
]

#observacion[Verificado en Lean: `Recu1_1C2025`, sección Ejercicio 4][
  En Mathlib, `Fin n → ℝ` lleva de fábrica la métrica $d_oo$ (`dist_pi_le_iff`,
  `dist_le_pi_dist`) y `EuclideanSpace ℝ (Fin n)` lleva $d_2$; `d2` transporta esta última y
  `d2_eq` comprueba que es $sqrt(sum (x_i - y_i)^2)$. `d` es la del enunciado.
  - *(a)* `d_nonneg`, `d_eq_zero_iff`, `d_comm`, `d_triangle` son los cuatro axiomas, y
    `instMetricSpaceRd` empaqueta a $(RR^n, d)$ como un `MetricSpace` sobre el sinónimo
    `Rd n`.
  - *(b)* `ball_eq` prueba que $B_d (0, 1) = {(x, y) : abs(x) < 3/4, abs(y) < 3/4, x^2 + y^2 < 1}$
    en $RR^2$; `vertice_notMem`, `punto_disco_notMem` y `punto_mem` certifican que
    $(3/4, 3/4) in.not B$, $(9/10, 0) in.not B$ y $(7/10, 7/10) in B$, que es lo que distingue
    al dibujo del cuadrado entero y del disco entero.
  - *(c)* `d2_le_d`, `d_le_d2`, `dist_le_d`, `d_le_dist` son las desigualdades
    $d_2 <= d <= 4/3 d_2$ y $d_oo <= d <= 4/3 sqrt(n) d_oo$ (Lean usa $sqrt(n)$, que es mejor
    que el $n$ de la guía; `d2_le_sqrt_mul_dist` lo prueba). `lipschitz_toRd` y
    `lipschitz_ofRd` dicen que la identidad es Lipschitz en los dos sentidos y
    `uniformEquivRd : (Fin n → ℝ) ≃ᵤ Rd n` es la equivalencia uniforme. La instancia
    `CompleteSpace (Rd n)` es el párrafo de completitud: Cauchy para $d$ $=>$ Cauchy para
    $d_oo$ $=>$ converge para $d_oo$ $=>$ converge para $d$.
]

#pagebreak()

= Resolución de un alumno (corregida)

#progreso[
  *Fuente:* `parciales/AnalisisAvanzado_1recu_01-07-25.pdf`, examen entregado en 4 hojas y corregido en rojo. \
  *Calificación:* 4 (aprobado). Por ejercicio: *1:* R$+$ · *2:* B · *3:* B · *4:* B. \
  *Orden de resolución del alumno:* 2, 3, 4 y por último 1 (dos intentos). Acá se transcriben en el orden del enunciado.
  Las marcas del corrector se indican como #text(fill: rgb("#dc2626"))[_(corrector: ...)_]. Se respeta la redacción original salvo por notación.
]

#v(8pt)

== Ejercicio 1 --- R$+$

#enunciado[Ejercicio 1][
  Hallar el cardinal de $A = \{(a_n)_(n in NN) subset.eq ZZ : a_n divides a_(n+1) " " forall n in NN\}$.
]

#resolucion[Primer intento (hoja 3)][
  Como $A subset.eq ZZ^NN$, $\#A <= \#ZZ^NN = frak(c)$. Quiero ver que $frak(c) <= \#A$.

  Defino $f : NN_0 times (ZZ without \{0\})^NN -> A$ donde, para $m in NN_0$ y $(a_n)_(n in NN) in (ZZ without \{0\})^NN$, tengo que $f(m, (a_n)_(n in NN)) = (b_n)_(n in NN)$ tal que, para todo $n in NN$,
  $ b_n = cases(
    display(product_(i=1)^n a_i) & "si " n < m " o " m = 0,
    0 & "si " n >= m " y " m > 0.
  ) $
  Así, con $m = 0$, $b_n = product_(i=1)^n a_i != 0$ para todo $n$ pues $a_i != 0$ para todo $i$. Pero con $m > 0$, $m = op("mín")\{n in NN : b_n = 0\}$ pues $b_n = 0$ para todo $n >= m$ y $b_n = product_(i=1)^n a_i != 0$ para todo $n < m$.

  *Voy a explicar mi pensamiento.* Sea $(a_n)_(n in NN) in A$. Luego $a_n divides a_(n+1)$ para todo $n$. Así, para cada $n in NN$ existe $k_n in ZZ$ tal que $a_(n+1) = k_n a_n$. Recursivamente, se obtiene que
  $ a_n = a_1 product_(i=1)^(n-1) k_i quad forall n in NN. $
  De allí salió la idea de la productoria. Por otro lado, si existe $n$ tal que $a_n = 0$, entonces, como $a_n divides a_(n+1)$, necesariamente $a_(n+1) = 0$. De esta forma, $a_n = 0$ para todo $n >= n_0$. En la función, el $m$ representa el $n_0$ más chico a partir del cual la sucesión de $A$ empieza a ser constantemente nula. Si nunca se anula, pongo $m = 0$ para facilitar todo.

  *Veo que $f$ está bien definida.* Sean $m in NN_0$ y $(a_n)_(n in NN) subset.eq ZZ without \{0\}$. Defino $(b_n)_(n in NN) := f(m, (a_n)_(n in NN))$.
  - Si $m = 0$, $b_n = product_(i=1)^n a_i$ para todo $n$. Por ello,
    $ b_(n+1) = product_(i=1)^(n+1) a_i = a_(n+1) (product_(i=1)^n a_i) = a_(n+1) b_n quad forall n in NN. $
    Como $a_(n+1) in ZZ$ para todo $n$, $b_n divides b_(n+1)$ para todo $n$. Luego $f(m, (a_n)_(n in NN)) = (b_n)_(n in NN) in A$.
  - Si $m > 0$, $b_n = 0$ para todo $n >= m$. Luego $b_(n+1) = 0 dot b_n$ para todo $n >= m - 1$. Por ello, $b_n divides b_(n+1)$ para todo $n >= m - 1$. Además, $b_n = product_(i=1)^n a_i$ para todo $n <= m - 1$. Entonces $b_(n+1) = product_(i=1)^(n+1) a_i = a_(n+1) (product_(i=1)^n a_i) = a_(n+1) b_n$ para todo $n < m - 1$. Por ello, como $a_(n+1) in ZZ$, $b_n divides b_(n+1)$ para todo $n < m - 1$. Finalmente, $b_n divides b_(n+1)$ para todo $n in NN$. Luego $f(m, (a_n)_(n in NN)) = (b_n)_(n in NN) in A$.

  Como $op("Im") f subset.eq A$, $f$ está bien definida. (Cada imagen es única por definición; como $a_i != 0$ para todo $i$, entonces $product_(i=1)^n a_i != 0$ para todo $n$, por lo que $b_n = 0 <==> (n >= m and m > 0)$ para todo $n$.)

  *Veo que $f$ es inyectiva.* Sean $p, q in NN_0$ y $(a_n)_(n in NN), (b_n)_(n in NN) subset.eq ZZ without \{0\}$ tales que
  $ (c_n)_(n in NN) := f(p, (a_n)_(n in NN)) = f(q, (b_n)_(n in NN)). $
  Como $a_n != 0 != b_n$ para todo $n$, si $c_n != 0$ para todo $n$, por definición de $f$, $p = 0$ y $q = 0$.

  Supongo que $c_n != 0$ para todo $n$. Así, $p = q = 0$. Veo que $(a_n) = (b_n)$ por inducción completa. _Caso base:_ $a_1 = c_1 = b_1$. _Paso inductivo:_ supongo que existe $n in NN$ tal que $a_i = b_i$ para todo $1 <= i <= n$. Quiero ver que $a_(n+1) = b_(n+1)$. Como $c_(n+1) = product_(i=1)^(n+1) a_i = product_(i=1)^(n+1) b_i$ y $a_i = b_i != 0$ para todo $1 <= i <= n$, entonces $a_(n+1) = b_(n+1)$. De esta forma, $a_n = b_n$ para todo $n$, es decir, $(a_n)_(n in NN) = (b_n)_(n in NN)$.

  Supongo que existe $n in NN$ tal que $c_n = 0$. Como expliqué antes, $c_m = 0$ para todo $m >= n$. Además, por cómo definí $f$, $p = op("mín")\{n in NN : c_n = 0\}$ y $q = op("mín")\{n in NN : c_n = 0\}$. Naturalmente, $p = q > 0$. Queda que $a_n = b_n$ para todo $n < p$. #text(fill: rgb("#991b1b"))[$slash.double$]

  _No tengo tiempo, pero hubiese quedado que_ $NN_0 times (ZZ without \{0\})^NN tilde NN times ZZ^NN tilde NN times RR tilde RR$, _con lo que_ $\#RR <= \#A <= \#RR$ _y, por el Teorema de Cantor--Bernstein,_ $\#A = \#RR$. _Voy a intentarlo de nuevo en la siguiente hoja._
]

#observacion[Por qué el primer intento se corta][
  La inyectividad falla cuando $p = q > 0$: dos sucesiones $(a_n)$, $(b_n)$ que coinciden sólo hasta $n < p$ tienen la misma imagen, porque $f$ descarta los $a_n$ con $n >= p$. El alumno lo detecta ("queda que $a_n = b_n$ para todo $n < p$") y abandona. La idea rescatable es la primera mitad: la parte $m = 0$ ya da una inyección $(ZZ without \{0\})^NN arrow.hook A$, que es todo lo que hace falta para $frak(c) <= \#A$.
]

#resolucion[Segundo intento (hoja 4)][
  Sea $(a_n)_(n in NN) in A$. Como $a_n divides a_(n+1)$ para todo $n in NN$, entonces para cada $n in NN$ existe $k_n in ZZ$ tal que $a_(n+1) = k_n a_n$. Siguiendo la recursión, $a_n = a_1 product_(i=1)^(n-1) k_i$. En particular, si existe $n_0 in NN$ tal que $a_(n_0) = 0$, entonces $a_(n_0 + 1) = k_(n_0) a_(n_0) = 0$. Por ello, valdría que $a_n = 0$ para todo $n >= n_0$. Sin embargo, si $a_n != 0$ para todo $n in NN$, entonces $a_n = a_1 product_(i=1)^(n-1) k_i != 0$ para todo $n$, lo que me dice que $k_i != 0$ para todo $i in NN$.

  #text(fill: rgb("#dc2626"))[_(Acá hay dos párrafos tachados con corrector líquido; el corrector los marcó en rojo.)_]

  Por lo anterior, con
  $ B &:= \{(product_(i=1)^n k_i)_(n in NN) : (k_n)_(n in NN) subset.eq ZZ without \{0\}\} quad "y" \
    C &:= \{(a_n)_(n in NN) : exists n_0 in NN " tal que " a_n = 0 " " forall n >= n_0 \
      & quad quad " y " exists k_1, dots, k_(n_0 - 1) in ZZ " tal que " a_n = product_(i=1)^n k_i " " forall n < n_0\}, $
  entonces $A = B union C$. Voy a esbozar la idea.
  $ C tilde union.big_(n_0 in NN) ZZ^(n_0) tilde NN, quad B tilde RR quad ==> quad B union C = A tilde RR. $
  ($ZZ^(n_0) tilde NN$ para todo $n_0 in NN$; $(ZZ without \{0\})^NN tilde RR$.)

  $PP = \{"primos en " NN\} tilde NN ==> PP^NN tilde RR$. Inyección $PP^NN arrow.hook B$:
  $ (p_n)_(n in NN) |-> (product_(i=1)^n p_i)_(n in NN). $
  Me gustaría que fueran todos distintos para que la función sea inyectiva: como $PP tilde NN$, existe $(p_n)_(n in NN) subset.eq PP$ con $p_n < p_m$ para todo $n < m$ (biyección $NN arrow.hook PP$). Entonces
  $ NN^NN arrow.hook PP^NN arrow.hook B, quad (x_n)_(n in NN) |-> (p_(x_n))_(n in NN) |-> (product_(i=1)^n p_(x_i))_(n in NN). $

  #text(fill: rgb("#dc2626"))[_(corrector: "No necesitás que sean primos ni distintos porque preservás el orden.")_]
]

#observacion[Lo que el corrector señala][
  La aplicación $(k_n)_(n in NN) |-> (product_(i=1)^n k_i)_(n in NN)$ de $(ZZ without \{0\})^NN$ en $B$ ya es inyectiva sin pasar por primos: de la imagen $(b_n)$ se recupera $k_1 = b_1$ y $k_n = b_n \/ b_(n-1)$ para $n >= 2$ (los $b_n$ no se anulan). Con eso, $\#B >= \#(ZZ without \{0\})^NN = frak(c)$ y, como $A subset.eq ZZ^NN$, $\#A = frak(c)$ por Cantor--Bernstein. El rodeo por $PP^NN$ es correcto pero innecesario; la nota R$+$ refleja que la idea está pero la escritura quedó incompleta.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 2 --- B

#enunciado[Ejercicio 2 a)][
  Dados $A, B subset.eq RR$ no vacíos y acotados, decidir si vale $op("sup")(A + B) = op("sup")(A) + op("sup")(B)$.
]

#resolucion[Alumno][
  Propongo que es verdadero. Lo demuestro.

  Sea $c in A + B$. Por definición, existen $a in A$, $b in B$ tales que $c = a + b$. Por definición (del supremo), $a <= op("sup")(A)$ y $b <= op("sup")(B)$. Luego, $c <= op("sup")(A) + op("sup")(B)$. Como $c in A + B$ es arbitrario, $op("sup")(A) + op("sup")(B)$ es cota superior de $A + B$. Por definición del supremo,
  $ op("sup")(A + B) <= op("sup")(A) + op("sup")(B). $

  Sea $epsilon > 0$ fijo. Por equivalencia del supremo, existen $a_epsilon in A$, $b_epsilon in B$ tales que $op("sup")(A) - epsilon/2 < a_epsilon$ y $op("sup")(B) - epsilon/2 < b_epsilon$. De esta forma,
  $ op("sup")(A) + op("sup")(B) - epsilon < a_epsilon + b_epsilon <= op("sup")(A + B). $
  Luego, $op("sup")(A) + op("sup")(B) < op("sup")(A + B) + epsilon$. Como $epsilon > 0$ es arbitrario, $op("sup")(A) + op("sup")(B) <= op("sup")(A + B)$.

  $therefore op("sup")(A + B) = op("sup")(A) + op("sup")(B)$. $qed$
]

#enunciado[Ejercicio 2 b)][
  Dadas $(a_n)_(n in NN), (b_n)_(n in NN) subset.eq RR$ acotadas, decidir si vale $op("sup")(\{a_n + b_n\}_(n in NN)) = op("sup")(\{a_n\}_(n in NN)) + op("sup")(\{b_n\}_(n in NN))$.
]

#resolucion[Alumno][
  Propongo que es falso. Doy un contraejemplo.

  Considero las sucesiones $(a_n)_(n in NN), (b_n)_(n in NN) subset.eq RR$ dadas por $a_n = b_n = 0$ para todo $n > 1$, $a_1 = 1$ y $b_1 = -1$. Claramente, ambas sucesiones son acotadas ($abs(a_n) <= 1$ y $abs(b_n) <= 1$ para todo $n in NN$). Además, $op("sup")(\{a_n\}_(n in NN)) = 1$ y $op("sup")(\{b_n\}_(n in NN)) = 0$. Sin embargo, $op("sup")(\{a_n + b_n\}_(n in NN)) = 0$ pues $a_n + b_n = 0$ para todo $n in NN$. Así,
  $ op("sup")(\{a_n + b_n\}_(n in NN)) = 0 != 1 = op("sup")(\{a_n\}_(n in NN)) + op("sup")(\{b_n\}_(n in NN)). $

  $therefore$ La afirmación es falsa. $qed$ #text(fill: rgb("#dc2626"))[_(corrector: "Bien!")_]
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 3 --- B

#enunciado[Ejercicio 3][
  Sean $(E, d)$ un espacio métrico y $X subset.eq E$ denso. Pruebe que para todo $U subset.eq E$ abierto se tiene que $overline(X inter U) = overline(U)$.
]

#resolucion[Alumno][
  Como $overline(X inter U) subset.eq^((ast)) overline(X) inter overline(U) = E inter overline(U) = overline(U)$, quiero ver que $overline(U) subset.eq overline(X inter U)$.

  Sea $x in overline(U)$. Luego, existe $(x_n)_(n in NN) subset.eq U$ tal que $x_n -->_(n -> oo) x$. Para cada $n in NN$, como $x_n in U subset.eq overline(X) = E$, existe $(y^n_m)_(m in NN) subset.eq X$ tal que $y^n_m -->_(m -> oo) x_n$. Como $x_n in U$ y $U$ es abierto, existe $m^n_1 in NN$ tal que $y^n_m in U$ para todo $m >= m^n_1$. Además, existe $m^n_2 in NN$ tal que $d(y^n_m, x_n) < 1/n$ para todo $m >= m^n_2$. Considero $m^n_0 := op("máx")\{m^n_1, m^n_2\}$. De esta forma, tengo la sucesión $(y^n_(m^n_0))_(n in NN)$. Por lo anterior, para todo $n in NN$, $y^n_(m^n_0) in U$ pues $m^n_0 >= m^n_1$, y también $y^n_(m^n_0) in X$ por definición. Así, $(y^n_(m^n_0))_(n in NN) subset.eq X inter U$.
  $ d(y^n_(m^n_0), x) <= d(y^n_(m^n_0), x_n) + d(x_n, x) < 1/n + d(x_n, x) -->_(n -> oo) 0. $
  Esto vale pues $x_n -->_(n -> oo) x <==> d(x_n, x) -->_(n -> oo) 0$. Por el Teorema del Sándwich, $d(y^n_(m^n_0), x) -->_(n -> oo) 0$. Así, $(y^n_(m^n_0))_(n in NN) subset.eq X inter U$ converge a $x$. Luego, $x in overline(X inter U)$.

  Finalmente, como $x$ era arbitrario, $overline(U) subset.eq overline(X inter U)$.

  $therefore overline(X inter U) = overline(U)$. $qed$

  $(ast)$ $z in overline(X inter U) <==> forall r > 0 " " exists y_r in X inter U " tal que " d(z, y_r) < r$
  $ &==> forall r > 0 " " exists y_r in X " tal que " d(z, y_r) < r quad "y" quad forall r > 0 " " exists y_r in U " tal que " d(z, y_r) < r \
    &<==> z in overline(X) " y " z in overline(U) <==> z in overline(X) inter overline(U). $
  $==> overline(X inter U) subset.eq overline(X) inter overline(U)$. #text(fill: rgb("#dc2626"))[_(corrector: "Bien!")_]
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 4 --- B

#enunciado[Ejercicio 4 a)][
  Se define la función $d : RR^n times RR^n -> RR$ como $d(x, y) = op("máx")\{4/3 d_oo (x, y), d_2 (x, y)\}$ para todo $x, y in RR^n$. Pruebe que $(RR^n, d)$ es un espacio métrico.
]

#resolucion[Alumno][
  Para ello, quiero ver que $d$ es una métrica en $RR^n$. Sean $x, y, z in RR^n$.

  $ d(x, y) = 0 &<==> 4/3 d_oo (x, y) = 0 " y " d_2 (x, y) = 0 \
    &<==> d_oo (x, y) = 0 " y " d_2 (x, y) = 0 <==> x = y $
  (pues $d(x, y) = op("máx")\{4/3 d_oo (x, y), d_2 (x, y)\}$ y tanto $4/3 d_oo (x, y)$ como $d_2 (x, y)$ son no negativos, al ser $d_oo$ y $d_2$ métricas en $RR^n$).

  De la misma forma, como $d_oo (x, y) >= 0$ y $d_2 (x, y) >= 0$ por ser $d_oo$ y $d_2$ métricas en $RR^n$, entonces $4/3 d_oo (x, y) >= 0$ y $d_2 (x, y) >= 0$, por lo que $d(x, y) = op("máx")\{4/3 d_oo (x, y), d_2 (x, y)\} >= 0$.

  Además, como $d_oo$ y $d_2$ son métricas en $RR^n$, son simétricas. Luego,
  $ d(x, y) = op("máx")\{4/3 d_oo (x, y), d_2 (x, y)\} = op("máx")\{4/3 d_oo (y, x), d_2 (y, x)\} = d(y, x). $

  Me falta la desigualdad triangular. Separo en casos.
  - $d(x, y) = 4/3 d_oo (x, y)$. Entonces
    $ d(x, z) + d(z, y) &= op("máx")\{4/3 d_oo (x, z), d_2 (x, z)\} + op("máx")\{4/3 d_oo (z, y), d_2 (z, y)\} \
      &>= 4/3 d_oo (x, z) + 4/3 d_oo (z, y) >= 4/3 d_oo (x, y) = d(x, y) $
    ($d_oo$ distancia).
  - $d(x, y) = d_2 (x, y)$. Entonces
    $ d(x, z) + d(z, y) &= op("máx")\{4/3 d_oo (x, z), d_2 (x, z)\} + op("máx")\{4/3 d_oo (z, y), d_2 (z, y)\} \
      &>= d_2 (x, z) + d_2 (z, y) >= d_2 (x, y) = d(x, y) $
    ($d_2$ distancia).

  $therefore d$ es una métrica en $RR^n$. $qed$ #text(fill: rgb("#dc2626"))[_(corrector: "Bien!")_]
]

#enunciado[Ejercicio 4 b)][
  Dibuje aproximadamente $B_d ((0, 0), 1)$ en $(RR^2, d)$.
]

#resolucion[Alumno][
  $ (x, y) in B_d ((0, 0), 1) &<==> d((0, 0), (x, y)) < 1 \
    &<==> op("máx")\{4/3 d_oo ((0, 0), (x, y)), d_2 ((0, 0), (x, y))\} < 1 \
    &<==> d_oo ((0, 0), (x, y)) < 3/4 " y " d_2 ((0, 0), (x, y)) < 1 \
    &<==> (x, y) in B_(d_oo) ((0, 0), 3/4) " y " (x, y) in B_(d_2) ((0, 0), 1) \
    &<==> (x, y) in B_(d_oo) ((0, 0), 3/4) inter B_(d_2) ((0, 0), 1). $

  El dibujo del alumno: el cuadrado $B_(d_oo)((0,0), 3/4)$ (lado $3/2$) intersecado con el disco $B_(d_2)((0,0), 1)$, es decir, un cuadrado con las esquinas recortadas por la circunferencia ("sin bordes"). #text(fill: rgb("#dc2626"))[_(corrector: "Bien!")_]

  #align(center)[
    #cetz.canvas(length: 2.2cm, {
      import cetz.draw: *
      let s = 0.75
      let h = calc.sqrt(7) / 4
      let t1 = calc.atan2(s, h)
      let t2 = calc.atan2(h, s)

      // ejes
      line((-1.35, 0), (1.35, 0), stroke: 0.6pt + luma(120), mark: (end: "stealth", fill: luma(120)))
      line((0, -1.35), (0, 1.35), stroke: 0.6pt + luma(120), mark: (end: "stealth", fill: luma(120)))

      // referencias: disco unidad y cuadrado de lado 3/2
      circle((0, 0), radius: 1, stroke: (paint: rgb("#dc2626"), dash: "dashed", thickness: 0.8pt))
      rect((-s, -s), (s, s), stroke: (paint: rgb("#2563eb"), dash: "dashed", thickness: 0.8pt))

      // la bola: cuadrado recortado por la circunferencia
      merge-path(close: true, fill: rgb("#bfdbfe").transparentize(30%), stroke: 1.2pt + rgb("#1e3a8a"), {
        line((s, -h), (s, h))
        arc((s, h), start: t1, stop: t2, radius: 1)
        line((h, s), (-h, s))
        arc((-h, s), start: 180deg - t2, stop: 180deg - t1, radius: 1)
        line((-s, h), (-s, -h))
        arc((-s, -h), start: 180deg + t1, stop: 180deg + t2, radius: 1)
        line((-h, -s), (h, -s))
        arc((h, -s), start: 360deg - t2, stop: 360deg - t1, radius: 1)
      })

      // marcas
      line((s, -0.04), (s, 0.04), stroke: 0.6pt)
      content((s, -0.17), text(size: 8pt)[$3/4$])
      line((1, -0.04), (1, 0.04), stroke: 0.6pt)
      content((1.02, -0.17), text(size: 8pt)[$1$])
      content((1.05, 1.1), text(size: 8pt, fill: rgb("#dc2626"))[$B_(d_2)((0,0),1)$])
      content((-0.95, 0.95), text(size: 8pt, fill: rgb("#2563eb"))[$B_(d_oo)((0,0),3/4)$])
      content((0, -1.5), text(size: 9pt, fill: rgb("#1e3a8a"))[$B_d ((0,0), 1)$])
    })
  ]
]

#observacion[Dónde recorta la circunferencia][
  Sobre el lado $x = 3/4$ del cuadrado, la condición $x^2 + y^2 < 1$ deja $abs(y) < sqrt(7)/4 approx 0.66$: cada lado pierde sólo sus extremos. Los vértices $(plus.minus 3/4, plus.minus 3/4)$ quedan afuera porque $d_2$ los pone a distancia $3 sqrt(2)/4 approx 1.06 > 1$. Si el factor fuera $1$ en vez de $4/3$, el cuadrado $B_(d_oo)((0,0),1)$ contendría al disco y la bola sería el disco entero.
]

#enunciado[Ejercicio 4 c)][
  Pruebe que $d tilde d_oo$ y $d tilde d_2$. ¿Es $(RR^n, d)$ completo?
]

#resolucion[Alumno][
  Sean $x, y in RR^n$. Por definición, $d_2 (x, y) <= op("máx")\{d_2 (x, y), 4/3 d_oo (x, y)\} = d(x, y)$. Como $d_2 (x, y) <= 4/3 d_2 (x, y)$ y $4/3 d_oo (x, y) <=^((ast)) 4/3 d_2 (x, y)$, entonces $d(x, y) = op("máx")\{4/3 d_oo (x, y), d_2 (x, y)\} <= 4/3 d_2 (x, y)$. De esta forma,
  $ d_2 (x, y) <= d(x, y) <= 4/3 d_2 (x, y). $
  Luego, $d$ es uniformemente equivalente a $d_2$. En particular, $d$ es equivalente a $d_2$.

  Además, también $d$ es uniformemente equivalente a $d_oo$ pues $d_oo$ es uniformemente equivalente a $d_2$:
  $ d_oo (x, y) <= d_2 (x, y) <= d(x, y) <= 4/3 d_2 (x, y) <=^((ast ast)) 4/3 sqrt(n) d_oo (x, y) quad forall x, y in RR^n. $

  Como $(RR^n, d_2)$ y $(RR^n, d_oo)$ son completos, entonces $(RR^n, d)$ es completo (por equivalencia uniforme). #text(fill: rgb("#dc2626"))[_(corrector: "Bien!")_]

  $(ast)$ Sean $x, y in RR^n$. Luego, $d_oo (x, y) = op("máx", limits: #true)_(1 <= i <= n) abs(x_i - y_i)$, de donde
  $ d_oo (x, y)^2 = op("máx", limits: #true)_(1 <= i <= n) abs(x_i - y_i)^2 <= sum_(i=1)^n abs(x_i - y_i)^2 = d_2 (x, y)^2 ==> d_oo (x, y) <= d_2 (x, y). $

  $(ast ast)$ Sean $x, y in RR^n$. Luego,
  $ d_2 (x, y)^2 = sum_(i=1)^n (x_i - y_i)^2 <= sum_(i=1)^n op("máx", limits: #true)_(1 <= j <= n) abs(x_j - y_j)^2 = n d_oo (x, y)^2 ==> d_2 (x, y) <= sqrt(n) d_oo (x, y). $
]
