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
