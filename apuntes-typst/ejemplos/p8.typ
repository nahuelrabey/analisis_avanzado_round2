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

// --- Ejemplos de la Práctica 8 ---

#align(center)[
  #text(14pt, weight: "bold")[Ejemplos resueltos --- Práctica 8] \
  #v(2pt)
  #text(10pt, style: "italic", fill: rgb("#475569"))[
    Medida de Lebesgue: $sigma$-álgebras, nulos y medibles
  ]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

Los ejemplos están agrupados por *técnica*, no por orden de transcripción, y los bloques siguen el orden en que la guía los necesita. Cada bloque abre con la nota de qué ejercicios de `guias/p8.typ` desbloquea.

La pestaña dice de dónde viene cada ejemplo: un *número* es el ejemplo de `notas_materia.pdf` (con su numeración por capítulo entre paréntesis en el título), *`C{clase}-{ejemplo}`* es un ejercicio resuelto en clase, transcrito en `clases/` (un archivo por tema; la tabla clase $arrow$ archivo está en la skill `ejemplo`) --- `C10-3` es el Ejercicio 3 de `clases/conjuntos_medibles.typ` --- y *`A{sección}`* es un resultado o ejercicio de Abbott, _Understanding Analysis_ --- `A1.5.9` es el Ejercicio 1.5.9 del libro.

#v(6pt)

#show table.cell.where(y: 0): set text(fill: white, weight: "bold", size: 8.5pt)

#table(
  columns: (0.35fr, 2.4fr, 1.1fr),
  align: (center + horizon, left + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#065f46") } else if calc.even(y) { rgb("#f8fafc") } else { white },
  stroke: 0.4pt + rgb("#cbd5e1"),
  inset: (x: 6pt, y: 4pt),

  [*\#*], [*Bloque*], [*Desbloquea*],
  [1], [$sigma$-álgebras: verificar los tres axiomas], [p8: Ej. 1 (C10-1 es su gemelo con "nulo" en lugar de "contable"), 2],
  [2], [Generar $sigma$-álgebras: abiertos, cerrados e intervalos], [p8: Ej. 5; conceptual para Ej. 4, 11, 12],
  [3], [Calcular medidas: nulos, uniones y encajes], [p8: Ej. 3, 6, 8, 13; conceptual para Ej. 7],
  [4], [Medida y topología: medida $1$ en $[0, 1]$], [p8: Ej. 9 (lo usa), 10],
)

#v(4pt)

#text(size: 9pt, fill: rgb("#64748b"))[
  La numeración de ejercicios es la de la *guía 2025* (`guias/p8.typ`).
]

#v(8pt)

== Bloque 1 · $sigma$-álgebras: verificar los tres axiomas

#sublema(titulo: "Qué desbloquea")[
  El *Ejercicio 1* de la Práctica 8 pide probar que ${A subset.eq X : A "contable o" X without A "contable"}$ es $sigma$-álgebra, y el *Ejercicio 2* deduce de los axiomas las propiedades de uso cotidiano ($emptyset in cal(A)$, diferencias, intersecciones numerables). El ejemplo de este bloque (C10-1) es el *gemelo* del Ejercicio 1 con "nulo" en lugar de "contable": la estructura de la prueba es idéntica (los casos "algún $A_n$ chico" / "ningún $A_n$ chico"), y lo único que cambia es la propiedad de los conjuntos chicos que se usa --- acá, que un subconjunto de un nulo es nulo y que la unión numerable de nulos es nula (con el truco de $epsilon \/ 2^n$). Además, la clase verifica la clausura por _intersecciones_ numerables en lugar de uniones: que eso alcanza es exactamente el ítem (c) del Ejercicio 2.
]

#ejemplo[Nulos y conulos forman una $sigma$-álgebra (Clase 10 · Ejercicio 1)][C10-1][
  Sea $cal(A) = {A subset.eq [0, 1] : A "es nulo o" A^c "es nulo"}$. Probar que $cal(A)$ es $sigma$-álgebra.
]

#estrategia[Separar en casos según haya o no un conjunto nulo en la familia][
  Los dos primeros axiomas son inmediatos ($[0, 1]^c = emptyset$ es nulo, y la condición "$A$ nulo o $A^c$ nulo" es simétrica en $A$ y $A^c$). El trabajo está en la clausura por operaciones numerables. Dada $(A_n)_n subset.eq cal(A)$, o bien alguno de los $A_n$ es nulo --- y entonces la intersección, que está contenida en él, es nula --- o bien ninguno lo es, y entonces _todos_ los complementos son nulos y hay que ver que su unión numerable también: se cubre cada $A_n^c$ con intervalos de longitud total $< epsilon \/ 2^n$ y se suma la serie geométrica.
]

#resolucion[
  Verificamos que

  1. $[0, 1] in cal(A)$ porque $[0, 1]^c = emptyset$ es nulo, pues está contenido en $(0, 1/n)$ para todo $n$, que tiene longitud $1/n -> 0$.

  2. Si $A in cal(A)$ entonces $A$ es nulo o $A^c$ es nulo. Como $A = (A^c)^c$, esto significa que $A^c in cal(A)$.

  3. Si $(A_n)_n subset.eq cal(A)$ consideremos $inter.big_(n in NN) A_n$.

    - Si algún $A_(n_0)$ es nulo, $inter.big_(n in NN) A_n subset.eq A_(n_0)$, y entonces para todo $epsilon > 0$ existen ${U_n}_n$ intervalos abiertos tales que
      $
      A_(n_0) subset.eq union.big_(n in NN) U_n quad "y" quad sum_(n = 1)^(+infinity) op("length")(U_n) < epsilon.
      $
      Pero entonces $inter.big_(n in NN) A_n subset.eq union.big_(n = 1)^(+infinity) U_n$, de donde inferimos que $inter.big_(n in NN) A_n$ es nulo, y por lo tanto está en $cal(A)$.

    - Si ningún $A_n$ es nulo, como son elementos de $cal(A)$, resulta que para todo $n$, $A_n^c$ es nulo. Consideremos
      $
      (inter.big_(n in NN) A_n)^c = union.big_(n in NN) A_n^c.
      $
      Sea $epsilon > 0$. Dado $n$, como $A_n^c$ es nulo, existe una familia de abiertos ${U_(n, m)}_(m in NN)$ tal que
      $
      A_n^c subset.eq union.big_(m in NN) U_(n, m) quad "y" quad sum_(m in NN) op("length")(U_(n, m)) < epsilon / 2^n.
      $
      Sea ${U_(n, m)}_((n, m) in NN^2)$; es una colección _contable_ de intervalos abiertos tal que
      $
      union.big_(n in NN) A_n^c &subset.eq union.big_(n in NN) union.big_(m in NN) U_(n, m) = union.big_((n, m) in NN^2) U_(n, m); \
      sum_((n, m) in NN^2) op("length")(U_(n, m)) &= underbrace(sum_(n = 1)^(+infinity) sum_(m = 1)^(+infinity) op("length")(U_(n, m)), "todos los términos son no negativos") \
      &< sum_(n = 1)^(+infinity) epsilon / 2^n = epsilon.
      $
      Concluimos que $union.big_(n in NN) A_n^c$ es nulo, es decir, $inter.big_(n in NN) A_n in cal(A)$.

  _Nota_: el manuscrito verifica la clausura por intersecciones numerables en lugar de por uniones numerables; como $cal(A)$ es cerrada por complementos (ítem 2) y $union.big_n A_n = (inter.big_n A_n^c)^c$, ambas condiciones son equivalentes.
]

#sublema(titulo: "Para qué sirve")[
  Para el Ejercicio 1 de la Práctica 8 se copia el esquema reemplazando "nulo" por "contable": un subconjunto de un contable es contable, y la unión numerable de contables es contable. El paso con $epsilon \/ 2^n$ es el que _no_ hace falta ahí, pero es el modelo de cómo se prueba que la unión numerable de nulos es nula, que aparece en el Ejercicio 3 (numerables son nulos) y en el Ejercicio 6.
]

== Bloque 2 · Generar $sigma$-álgebras: abiertos, cerrados e intervalos

#sublema(titulo: "Qué desbloquea")[
  El *Ejercicio 5* de la Práctica 8 pide ver que abiertos y cerrados son medibles, y los *Ejercicios 11 y 12* caracterizan a los medibles aproximándolos por cerrados desde adentro y por abiertos desde afuera. La herramienta común es saber _escribir_ un abierto como unión numerable de intervalos abiertos, y un cerrado como intersección numerable de abiertos (o un intervalo cerrado como intersección numerable de intervalos abiertos, y viceversa). Eso es exactamente lo que hace el Ejercicio 2 de la clase (C10-2) para probar que las $sigma$-álgebras generadas por los intervalos abiertos, los intervalos cerrados, los abiertos y los cerrados de $RR$ coinciden: cada inclusión se reduce a expresar _los generadores_ de una $sigma$-álgebra mediante operaciones numerables sobre los generadores de la otra. Los tres hechos generales que usa (cerrado $=$ intersección contable de abiertos, abierto $=$ unión contable de cerrados, abierto en separable $=$ unión contable de bolas) están recogidos en la nota del manuscrito, al final del ejemplo, y son los que se citan en los Ejercicios 4 y 11--12.

  La definición que se usa: dada una familia de subconjuntos de $RR$, la *$sigma$-álgebra generada* por ella es la _menor_ $sigma$-álgebra que la contiene (la intersección de todas las que la contienen). La prueba de una inclusión $cal(B)_i subset.eq cal(B)_j$ siempre tiene la misma forma: se ve que los generadores de $cal(B)_i$ están en $cal(B)_j$, y por minimalidad se concluye.
]

#ejemplo[Las cuatro $sigma$-álgebras de Borel coinciden (Clase 10 · Ejercicio 2)][C10-2][
  Definimos por $cal(B)$ a la _menor $sigma$-álgebra_ de subconjuntos de $RR$ que contiene todos los intervalos abiertos de $RR$. Sean

  #set enum(numbering: "a)")
  + $cal(B)_1$ la menor $sigma$-álgebra que contiene a los intervalos cerrados de $RR$.
  + $cal(B)_2$ la menor $sigma$-álgebra que contiene a los abiertos de $RR$.
  + $cal(B)_3$ la menor $sigma$-álgebra que contiene a los cerrados de $RR$.

  Probar que $cal(B)_1 = cal(B)_2 = cal(B)_3 = cal(B)$.
]

#estrategia[Reducir cada inclusión a los generadores][
  No sabemos qué forma tiene un elemento genérico de una $sigma$-álgebra generada, pero sí conocemos sus _generadores_. Para probar $cal(B)_1 subset.eq cal(B)$ alcanza con ver que cada intervalo cerrado está en $cal(B)$, porque $cal(B)_1$ es la menor $sigma$-álgebra que los contiene. Y un intervalo cerrado se obtiene de intervalos abiertos con una intersección numerable: $[a, b] = inter.big_n (a - 1\/n, b + 1\/n)$. El resto es repetir la idea con cada par de familias, y para abiertos y cerrados generales usar que un abierto de $RR$ es unión numerable de intervalos con centro y radio racionales, y que un cerrado $F$ es la intersección de los engordados $B(F, 1\/n)$.
]

#resolucion[
  #set enum(numbering: "a)")
  + Vemos cada inclusión por separado.

    - $cal(B)_1 subset.eq cal(B)$: notemos que _no es obvio_ qué forma tiene un $A in cal(B)_1$. Pero sí conocemos _los conjuntos generadores de $cal(B)_1$_. Sea $[a, b]$ un intervalo finito. Queremos ver que $[a, b] in cal(B)$. Se tiene que
      $
      [a, b] = inter.big_(n in NN) (a - 1/n, b + 1/n).
      $
      En efecto, si $x in [a, b]$, $a - 1/n < a <= x <= b < b + 1/n$ para todo $n$, por lo tanto $x in inter.big_(n in NN) (a - 1/n, b + 1/n)$. Recíprocamente, si $x in inter.big_(n in NN) (a - 1/n, b + 1/n)$, resulta que $a - 1/n < x < b + 1/n$ para todo $n$. Tomando límite, $a <= x <= b$. Entonces $[a, b] in cal(B)$ porque es intersección numerable de intervalos abiertos. Si consideramos intervalos de la forma $[a, +infinity)$, $(-infinity, b]$, podemos razonar igual, notando que
      $
      [a, +infinity) = inter.big_(n in NN) (a - 1/n, +infinity), quad (-infinity, b] = inter.big_(n in NN) (-infinity, b + 1/n).
      $
      Concluimos que todo intervalo cerrado de $RR$ es un elemento de $cal(B)$. Como $cal(B)_1$ es _la menor $sigma$-álgebra_ que contiene a los intervalos cerrados, tenemos que $cal(B)_1 subset.eq cal(B)$.

    - $cal(B) subset.eq cal(B)_1$: razonamos como en el caso anterior. Sean $(a, b)$, $(a, +infinity)$, $(-infinity, b)$. Tenemos que
      $
      (a, b) &= union.big_(n in NN) [a - 1/n, b + 1/n], \
      (a, +infinity) &= union.big_(n in NN) [a - 1/n, +infinity), quad (-infinity, b) = union.big_(n in NN) (-infinity, b + 1/n].
      $
      En cualquier caso, los intervalos son uniones numerables de intervalos cerrados, por lo tanto son elementos de $cal(B)_1$. Como $cal(B)$ es la menor $sigma$-álgebra que contiene a los intervalos abiertos, se sigue que $cal(B) subset.eq cal(B)_1$.

    _Nota_: los signos de las tres igualdades anteriores están al revés en el manuscrito ($union.big_n [a - 1/n, b + 1/n] = [a - 1, b + 1]$, que contiene estrictamente a $(a, b)$); las correctas son $(a, b) = union.big_n [a + 1/n, b - 1/n]$, $(a, +infinity) = union.big_n [a + 1/n, +infinity)$ y $(-infinity, b) = union.big_n (-infinity, b - 1/n]$ (los $[a + 1\/n, b - 1\/n]$ con $a + 1\/n > b - 1\/n$ son vacíos y no aportan), y el argumento sigue igual.

  + Vemos cada inclusión por separado.

    - $cal(B) subset.eq cal(B)_2$: esto es porque todo intervalo abierto es un conjunto abierto, y en consecuencia es un elemento de $cal(B)_2$. Como $cal(B)$ es la menor $sigma$-álgebra que contiene a los intervalos abiertos, $cal(B) subset.eq cal(B)_2$.

    - $cal(B)_2 subset.eq cal(B)$: sea $U subset.eq RR$ abierto. Afirmamos que
      $
      U = union.big_((q, r) in QQ times QQ_(> 0) \ q in U\, r "cumple que" B(q, r) subset.eq U) (q - r, q + r). quad (⊛)
      $
      - Notemos que como $QQ$ es denso en $RR$, $U inter QQ != emptyset$.
      - La contención $supset.eq$ es por definición. Para la otra contención, sea $x in U$. Como $U$ es abierto, existe $tilde(r) > 0$ tal que $(x - tilde(r), x + tilde(r)) subset.eq U$. Más aún, por arquimedianidad, podemos tomar $tilde(r) in QQ$. Sea $q in (x - tilde(r), x + tilde(r))$. Como el intervalo es abierto, existe $r > 0$ tal que $(q - r, q + r) subset.eq (x - tilde(r), x + tilde(r)) subset.eq U$. De nuevo, podemos tomar $r in QQ$. Concluimos que $x$ está en el conjunto del lado derecho de la igualdad de $(⊛)$. Por definición de $cal(B)_2$, se sigue que $cal(B)_2 subset.eq cal(B)$.

    _Nota_: en la contención $subset.eq$ el manuscrito no pide $q in QQ$ ni garantiza que $x in (q - r, q + r)$; se arregla eligiendo $q in QQ$ con $abs(x - q) < tilde(r) \/ 2$ y luego $r in QQ$ con $abs(x - q) < r < tilde(r) \/ 2$, de modo que $x in (q - r, q + r) subset.eq (x - tilde(r), x + tilde(r)) subset.eq U$; y $(⊛)$ es una unión _numerable_ de intervalos abiertos porque $QQ times QQ_(> 0)$ es numerable, que es lo que da $U in cal(B)$.

  + Vemos cada inclusión por separado.

    - $cal(B) subset.eq cal(B)_3$: se sigue de la misma idea de la inclusión $cal(B) subset.eq cal(B)_1$, porque todo intervalo abierto es unión numerable de intervalos cerrados.

    - $cal(B)_3 subset.eq cal(B)$: dado $F subset.eq RR$ cerrado, tenemos que
      $
      F attach(=, t: (⊛ ⊛)) inter.big_(n in NN) B(F, 1/n), quad B(F, 1/n) = {x in RR : d(x, F) < 1/n}.
      $
      Vimos que $B(F, 1/n)$ es abierto. Por el ítem b), $B(F, 1/n) in cal(B)$, y por lo tanto, si probamos $(⊛ ⊛)$ se sigue que $F in cal(B)$, y en consecuencia que $cal(B)_3 subset.eq cal(B)$. Veamos $(⊛ ⊛)$:
      - $F subset.eq inter.big_(n in NN) B(F, 1/n)$, porque para todo $x in F$, $d(x, F) = 0 < 1/n$ para todo $n$.
      - $inter.big_(n in NN) B(F, 1/n) subset.eq F$: dado $x in inter.big_(n in NN) B(F, 1/n)$, para todo $n$ se tiene que $d(x, F) < 1/n$. Por definición de $d(x, F)$, existe $x_n in F$ tal que
        $
        d(x, x_n) < d(x, F) + 1/n < 2/n.
        $
        Entonces $(x_n)_n subset.eq F$ converge a $x$, y como $F$ es cerrado, $x in F$.

    _Nota_: el manuscrito usa la misma etiqueta $(⊛)$ para la igualdad de b) y para la de c); acá la segunda se escribe $(⊛ ⊛)$ para distinguirlas.

  _Nota (del manuscrito)_: en la resolución usamos los siguientes hechos generales para espacios métricos $(X, d)$. (a) Dado $F subset.eq X$ _cerrado_, $F$ es intersección _contable_ de abiertos, y de hecho $F = inter.big_(n in NN) B(F, 1/n)$. (b) Dado $U subset.eq X$ _abierto_, $U$ es unión _contable_ de cerrados. (c) Si $X$ es _separable_, con denso $D subset.eq X$, entonces todo abierto $U subset.eq X$ es unión _contable_ de bolas abiertas de $X$.
]

#sublema(titulo: "Para qué sirve")[
  Para el Ejercicio 5 de la Práctica 8: un abierto de $RR$ es unión numerable de intervalos abiertos (la igualdad $(⊛)$), y $cal(M)$ es $sigma$-álgebra que contiene a los intervalos, luego contiene a los abiertos; los cerrados entran por complemento. Para el Ejercicio 4, $[a, b] = inter.big_n (a - 1\/n, b + 1\/n)$ y $[a, b) = inter.big_n (a - 1\/n, b)$ dan la medibilidad, y la continuidad de $mu$ (Bloque 3) la medida. Los hechos (a) y (b) de la nota del manuscrito son los que hacen que las descomposiciones de los Ejercicios 11 y 12 tengan sentido: si $A$ es cerrado o abierto, ya es de la forma pedida sin parte nula.
]

== Bloque 3 · Calcular medidas: nulos, uniones y encajes

#sublema(titulo: "Qué desbloquea")[
  Los *Ejercicios 3 y 6* de la Práctica 8 piden ver que los numerables (en particular $QQ$) son nulos y calcular la medida de los irracionales de $[0, 1]$; el *Ejercicio 8* es la fórmula $mu(A union B) + mu(A inter B) = mu(A) + mu(B)$, cuya prueba pasa por partir en uniones _disjuntas_; el *Ejercicio 13* usa la continuidad de la medida. Los dos ejemplos de este bloque juntan todas esas maniobras en cálculos concretos: en C10-3 se reescribe una unión numerable como unión disjunta de una parte creciente (cuya medida es el límite, por continuidad por abajo) y una parte contenida en $QQ$ (nula); en C10-4 se construye un conjunto como intersección decreciente $A = inter.big_n A_n$ de uniones finitas de intervalos, se calcula $mu(A_n) = (9\/10)^n$ por inducción quitando intervalos disjuntos, y se concluye por continuidad por arriba, que necesita $mu(A_1) < +infinity$ --- la misma hipótesis de finitud que cuida el Ejercicio 7.
]

#ejemplo[Medida de una unión de intervalos crecientes más racionales (Clase 10 · Ejercicio 3)][C10-3][
  Sea $A_n = (0, 1 - 1/n) union ([n + 1/4, n + 3/4] inter QQ)$. Calcular $mu(union.big_(n = 1)^(+infinity) A_n)$.
]

#estrategia[Separar la parte creciente de la parte numerable][
  Escribir los primeros $A_n$ ayuda a ver la estructura: los intervalos $(0, 1 - 1\/n)$ están encajados y crecen hacia $(0, 1)$, mientras que los pedazos racionales $[n + 1\/4, n + 3\/4] inter QQ$ viven lejos y son disjuntos entre sí y de los intervalos. Entonces la unión es una unión disjunta $B union.sq C$ con $B$ límite creciente de intervalos (medida $1$ por continuidad de $mu$) y $C subset.eq QQ$ (medida $0$ por ser contable).
]

#resolucion[
  Notemos que
  $
  A_1 &= (0, 0) union ([5/4, 7/4] inter QQ) = [5/4, 7/4] inter QQ, \
  A_2 &= (0, 1/2) union ([9/4, 11/4] inter QQ), \
  A_3 &= (0, 2/3) union ([13/4, 15/4] inter QQ), \
  &dots.v
  $
  El intervalo $(0, 1 - 1/n)$ de cada $A_n$ contiene al intervalo abierto de $A_(n - 1)$, $n >= 2$, mientras que los $[n + 1/4, n + 3/4] inter QQ$ son todos disjuntos entre sí, y de los $(0, 1 - 1/n)$. Podemos escribir (con $union.sq$ la unión disjunta):
  $
  union.big_(n in NN) A_n &= union.big_(n in NN) (0, 1 - 1/n) union ([n + 1/4, n + 3/4] inter QQ) \
  &= [union.big_(n in NN) (0, 1 - 1/n)] union.sq union.big_(n in NN) ([n + 1/4, n + 3/4] inter QQ) \
  &= underbrace([union.big_(n in NN) (0, 1 - 1/n)], = B) union.sq underbrace({[union.big_(n in NN) [n + 1/4, n + 3/4]] inter QQ}, = C).
  $
  Por la $sigma$-aditividad de la medida, $mu(union.big_(n in NN) A_n) = mu(B) + mu(C)$.

  - Como $mu((0, 1 - 1/n)) = 1 - 1/n -> 1$ y $(0, 1 - 1/n) subset.eq (0, 1 - 1/(n + 1))$ para todo $n in NN$,
    $
    mu(B) = lim_(n -> +infinity) mu((0, 1 - 1/n)) = 1.
    $

  - Como $C subset.eq QQ$, es contable, y por lo tanto $mu(C) = 0$.

  Concluimos que $mu(union.big_(n in NN) A_n) = 1$.
]

#ejemplo[Los números de $[0, 1]$ sin el dígito $4$ forman un nulo (Clase 10 · Ejercicio 4)][C10-4][
  Sea $A subset.eq [0, 1]$ que consiste de todos los números que no tienen al dígito $4$ en su expansión decimal. Probar que $A$ es medible y hallar su medida.
]

#estrategia[Aproximar por una sucesión decreciente de uniones finitas de intervalos][
  Prohibir el $4$ "dígito a dígito": $A_n$ es el conjunto de los $x$ que no tienen $4$ entre sus primeros $n$ dígitos. Cada $A_n$ es unión finita de intervalos (medible), los $A_n$ decrecen y $A = inter.big_n A_n$. Pasar de $A_n$ a $A_(n + 1)$ es quitar, dentro de cada uno de los $9^n$ intervalitos de $A_n$, el décimo que corresponde a que el dígito $n + 1$ sea $4$; así $mu(A_(n + 1)) = mu(A_n) (1 - 1\/10)$, de donde $mu(A_n) = (9\/10)^n -> 0$. La continuidad por arriba de $mu$ cierra el argumento.
]

#resolucion[
  Sea $A_1 = {x in [0, 1] : "el primer dígito de" x "no es" 4}$. Entonces $x = 0","a_1 dots$ con $a_1 != 4$. Por lo tanto, extraemos del $[0, 1]$ los $x$'s que comienzan con $0","4$ y terminan en $0","4 hat(9) = 0","5$. O sea, el intervalo $I_1 = [0.4, 0.5]$ y
  $
  A_1 = [0, 0.4) union (0.5, 1)
  $
  es medible. Tenemos que
  $
  mu(A_1) = mu(I - I_1) = mu(I) - mu(I_1) = 1 - 0.1 = 0.9 = 9/10.
  $

  _Nota_: los extremos son ambiguos por las expansiones decimales dobles ($0.5 = 0.4 hat(9)$, $1 = 0.hat(9)$) y el manuscrito no es del todo consistente con ellos (deja $0.5$ y $1$ afuera de $A_1$, y más abajo quita intervalos cerrados $[0.a_1 dots a_n 4, 0.a_1 dots a_n 5]$ cuyo extremo derecho no tiene $4$); son finitos puntos en cada paso, así que no afectan ni la medibilidad ni la medida.

  Consideremos $A_2 = {x in [0, 1] : "entre los primeros dos dígitos de" x "no está" 4}$. Notemos que $A_2 subset.eq A_1$. Lo que tendríamos que hacer es dividir cada uno de los intervalos $[0, 0.1]$, $[0.1, 0.2]$, $[0.3, 0.4]$, $(0.5, 0.6]$, ..., $[0.9, 1]$ en $10$ partes y extraer el intervalo correspondiente a que el segundo dígito sea $4$ (en el manuscrito hay un dibujo: la recta $[0, 1]$ marcada en décimos, con el subintervalo "segundo dígito $4$" pintado dentro de cada décimo salvo el $[0.4, 0.5]$, y un zoom del $[0, 0.1]$ dividido en centésimos con el $[0.04, 0.05]$ pintado). En $[0, 0.1]$ eliminamos el intervalo $[0.04, 0.05]$. Entonces
  $
  A_2 = A_1 - ([0.04, 0.05] union.sq [0.14, 0.15] union.sq [0.24, 0.25] union.sq [0.34, 0.35] union.sq [0.54, 0.55] union dots)
  $
  es medible, y
  $
  mu(A_2) = mu(A_1) - 0.01 dot.c 9 = 9/10 - 9/100 = 9/10 (1 - 1/10) = (9/10)^2.
  $
  Para cerrar el ejercicio, podríamos probar por inducción que los conjuntos
  $
  A_n := {x in [0, 1] : x "no tiene al" 4 "entre sus primeros" n "dígitos"}
  $
  cumplen que:

  I) $A_(n + 1) subset.eq A_n$ para todo $n in NN$.

  II) $A_n$ es unión finita de intervalos, por lo tanto es medible, y además $mu(A_n) = (9/10)^n$.

  En tal caso, $A = inter.big_n A_n$, por lo tanto es medible, y
  $
  mu(A) = lim_(n -> +infinity) mu(A_n) = lim_(n -> +infinity) (9/10)^n = 0.
  $
  Notemos que I) vale por definición de los conjuntos $A_n$. Veamos que II) se sigue por inducción. El caso base $n = 1$ ya lo vimos. Supongamos que $A_n$ cumple II). Los $x$'s que están en $A_n without A_(n + 1)$ son aquellos que _no tienen $4$'s en sus primeros $n$ dígitos, pero tienen un $4$ en su dígito $n + 1$_. Entonces, tienen la forma $0.a_1 a_2 dots a_n 4 dots$ con $(a_1, a_2, dots, a_n) in {0, 1, 2, 3, 5, 6, 7, 8, 9}^n = C^n$. Entonces
  $
  A_(n + 1) = A_n - union.sq.big_((a_1, dots, a_n) in C^n) [0.a_1 a_2 dots a_n 4, 0.a_1 a_2 dots a_n 5].
  $
  Esto prueba que $A_(n + 1)$ es unión finita de intervalos, y por lo tanto es medible. Además, como $[0.a_1 a_2 dots a_n 4, 0.a_1 a_2 dots a_n 5] subset.eq A_n$ para todo $(a_1, a_2, dots, a_n) in C^n$, se sigue que
  $
  mu(A_(n + 1)) &= mu(A_n) - mu(union.sq.big_((a_1, dots, a_n) in C^n) [0.a_1 a_2 dots a_n 4, 0.a_1 a_2 dots a_n 5]) \
  &= (9/10)^n - sum_((a_1, dots, a_n) in C^n) mu([0.a_1 dots a_n 4, 0.a_1 dots a_n 5]) \
  &= (9/10)^n - sum_((a_1, dots, a_n) in C^n) 10^(-(n + 1)) = (9/10)^n - 10^(-(n + 1)) dot.c 9^n \
  &= (9/10)^n - 9^n / 10^(n + 1) = (9/10)^n (1 - 1/10) = (9/10)^(n + 1).
  $
  Concluimos.

  _Nota_: el paso $mu(A) = lim_n mu(A_n)$ usa la continuidad de la medida por arriba para sucesiones decrecientes, que vale porque $mu(A_1) < +infinity$.
]

#sublema(titulo: "Para qué sirve")[
  Las dos direcciones de la continuidad de $mu$ aparecen acá en acción: por abajo (C10-3, $B = union.big arrow.t$) sin hipótesis extra, y por arriba (C10-4, $A = inter.big arrow.b$) con la hipótesis $mu(A_1) < +infinity$. Es el ingrediente del Ejercicio 13 y del cálculo de $mu([a, b))$ en el Ejercicio 4. La descomposición en uniones _disjuntas_ para poder sumar medidas es la maniobra del Ejercicio 8: $A union B = A union.sq (B without A)$ y $B = (A inter B) union.sq (B without A)$.
]

== Bloque 4 · Medida y topología: medida $1$ en $[0, 1]$

#sublema(titulo: "Qué desbloquea")[
  El *Ejercicio 9* de la Práctica 8 prueba que un medible de medida cero tiene interior vacío (un abierto no vacío contiene un intervalo de medida positiva), y el *Ejercicio 10* que un medible $A subset.eq [0, 1]$ con $mu(A) = 1$ es denso en $[0, 1]$. El ejemplo de este bloque (C10-5) es el puente entre los dos: toma $F subset.eq [0, 1]$ _cerrado_ con $mu(F) = 1$, observa que $[0, 1] without F$ es abierto (relativo) de medida $0$ y, citando el Ejercicio 9, concluye que es vacío. Para el Ejercicio 10 el mismo argumento, sin la hipótesis de cerrado, da que $A$ es denso: $[0, 1] without overline(A)$ es abierto relativo de medida $<= mu([0, 1] without A) = 0$.
]

#ejemplo[Un cerrado de $[0, 1]$ con medida $1$ es todo $[0, 1]$ (Clase 10 · Ejercicio 5)][C10-5][
  Sea $F subset.eq [0, 1]$ cerrado tal que $mu(F) = 1$. Probar que $F = [0, 1]$.
]

#estrategia[Mirar el complemento: abierto y nulo][
  Si $F$ es cerrado, $[0, 1] without F$ es abierto en $[0, 1]$ y tiene medida $1 - 1 = 0$. Pero un abierto no vacío de la recta contiene un intervalo, que tiene medida positiva; así que el complemento es vacío.
]

#resolucion[
  Tenemos que $[0, 1] without F$ es abierto, y
  $
  mu([0, 1] without F) = mu([0, 1]) - mu(F) = 1 - 1 = 0.
  $
  Por el ejercicio 9 de la práctica 7, $([0, 1] without F)^circle = emptyset$. Entonces $[0, 1] without F = ([0, 1] without F)^circle = emptyset$, y por lo tanto $F = [0, 1]$.

  _Nota_: el "ejercicio 9 de la práctica 7" de la clase es el *Ejercicio 9* de la guía 2025 (`guias/p8.typ`): medida cero implica interior vacío.

  _Nota_: $[0, 1] without F$ es abierto _relativo a $[0, 1]$_, no necesariamente abierto en $RR$ (por ejemplo si $0 in.not F$); se arregla así: si existiera $x in [0, 1] without F$, como $F^c$ es abierto en $RR$ habría $r > 0$ con $(x - r, x + r) subset.eq F^c$, y entonces $(x - r, x + r) inter [0, 1]$ es un intervalo no degenerado contenido en $[0, 1] without F$, de medida positiva, absurdo.
]

#sublema(titulo: "Para qué sirve")[
  Es la plantilla del Ejercicio 10: ahí $A$ no es cerrado, así que se aplica el argumento a $overline(A)$, que sí lo es y tiene medida $>= mu(A) = 1$; el resultado $overline(A) = [0, 1]$ es exactamente la densidad. La hipótesis de cerrado no se puede quitar en C10-5: los irracionales de $[0, 1]$ (Ejercicio 6) tienen medida $1$ y no son todo $[0, 1]$.
]
