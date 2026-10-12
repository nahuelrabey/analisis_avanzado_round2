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

// --- Ejemplos de la Práctica 3 ---

#align(center)[
  #text(14pt, weight: "bold")[Ejemplos resueltos --- Práctica 3] \
  #v(2pt)
  #text(10pt, style: "italic", fill: rgb("#475569"))[
    Espacios métricos: métricas, topología y sucesiones
  ]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

Los ejemplos están agrupados por *técnica*, no por orden de transcripción, y los bloques siguen el orden en que la guía los necesita. Cada bloque abre con la nota de qué ejercicios de `guias/p3.typ` desbloquea.

La pestaña dice de dónde viene cada ejemplo: un *número* es el ejemplo de `notas_materia.pdf` (con su numeración por capítulo entre paréntesis en el título), *`C{clase}-{ejemplo}`* es un ejercicio resuelto en clase, transcrito en `clases/` (un archivo por tema; la tabla clase $arrow$ archivo está en la skill `ejemplo`) --- `C1-4` es el Ejemplo 4 de `clases/sucesiones_supremos.typ` --- y *`A{sección}`* es un resultado o ejercicio de Abbott, _Understanding Analysis_ --- `A1.5.9` es el Ejercicio 1.5.9 del libro.

#v(6pt)

#show table.cell.where(y: 0): set text(fill: white, weight: "bold", size: 8.5pt)

#table(
  columns: (0.35fr, 2.4fr, 1.1fr),
  align: (center + horizon, left + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#065f46") } else if calc.even(y) { rgb("#f8fafc") } else { white },
  stroke: 0.4pt + rgb("#cbd5e1"),
  inset: (x: 6pt, y: 4pt),

  [*\#*], [*Bloque*], [*Desbloquea*],
  [1], [Métricas: verificar los axiomas], [p3: Ej. 1, 2; Ej. 7 y 12 (b) vía 15/09-8],
  [2], [Topología en espacios métricos: puntos interiores y abiertos], [p3: Ej. 3 (a), 4; Ej. 6 (a) en producto (17/09-1)],
  [3], [Clausura, cerrados, conjunto derivado y frontera], [p3: Ej. 3, 4 (a--b, d), 7; Ej. 10 (c) vía 17/09-4],
  [4], [Caracterizaciones y estabilidad de abiertos y cerrados], [p3: Ej. 9; conceptual para Ej. 5, 12],
  [5], [Sucesiones en espacios métricos], [p3: Ej. 13 (intro)],
  [6], [Completitud: probarla, heredarla y caracterizarla], [p3: Ej. 14, 15, 16 (modelo: 29/09-2); conceptual para Ej. 10, 12],
)

#v(4pt)

#text(size: 9pt, fill: rgb("#64748b"))[
  La numeración de ejercicios es la de la *guía 2026* (`apuntes-docentes/guias/p3.pdf`).
]

#v(8pt)

== Bloque 1 · Métricas: verificar los axiomas

#sublema(titulo: "Qué desbloquea")[
  El *Ejercicio 1* de la Práctica 3 pide probar que varios espacios son métricos, y el *Ejercicio 2* decidir cuáles de unas funciones dadas lo son. Los ejemplos de este bloque cubren el repertorio completo de maniobras: reducir la lista de axiomas a verificar, tratar una métrica definida por casos, trabajar con supremos de funciones, truncar una métrica existente, y verificar paso a paso la métrica discreta y la métrica del máximo ($d_oo$) en $RR^n$. Constituyen los modelos directos para los ítems (d), (e) y (f) del Ejercicio 1 y para el Ejercicio 11.

  De la clase del 15/09 se agregan, al final del bloque, dos maniobras más: transportar una métrica por una función inyectiva, $D_f (x,y) = d(f(x), f(y))$ (15/09-7, con el contraejemplo de que la sobreyectividad no alcanza; su ítem (ii) da una lectura directa del Ejercicio 2 (c), $abs(x^2 - y^2) = D_f$ con $f(x) = x^2$), y comparar bolas y diámetros de $d$ con los de la truncada $op("mín"){1, d}$ (15/09-8, que completa a C3-8 y prepara los Ejercicios 7 y 12 (b)). La clase del 29/09 cierra con el máximo de finitas métricas (29/09-4), cuya desigualdad triangular es la misma de $d_oo$, y con el contraejemplo de tres puntos para el mínimo: es el modelo de cómo *refutar* que algo es métrica en el Ejercicio 2.
]

#ejemplo[Dos axiomas alcanzan para tener una métrica (Clase 3 · Ejercicio 5)][C3-5][
  Sea $d : M times M -> RR$ una función tal que

  #set enum(numbering: "a)")
  + $d(x, y) = 0 <==> x = y$;
  + $d(x, z) <= d(x, y) + d(z, y)$ para todos $x, y, z in M$.

  Probar que $d$ es una métrica.
]

#estrategia[Sacarle la simetría y la positividad a la desigualdad triangular torcida][
  Notemos que (b) *no* es la desigualdad triangular usual: el último término es $d(z, y)$ y no $d(y, z)$. Esa asimetría es a propósito, y es lo que permite obtener la simetría gratis: especializando $y = x$ en (b) queda $d(x, y) <= d(x, x) + d(y, x) = d(y, x)$, y por el mismo argumento con los papeles cambiados sale la otra desigualdad. Una vez que hay simetría, (b) *es* la desigualdad triangular, y la positividad sale de aplicarla con $z = x$.
]

#resolucion[
  Sólo hay que verificar las dos propiedades que faltan:

  - *(c)* si $x != y$ entonces $d(x, y) > 0$;
  - *(d)* $d(x, y) = d(y, x)$.

  *(d) Simetría.* Usando (b) con $y$ reemplazado por $x$, y después (a) para $d(x,x) = 0$,
  $ d(x, y) <=^("b") d(x, x) + d(y, x) = d(y, x). $
  De manera completamente análoga, intercambiando los papeles de $x$ e $y$, se obtiene $d(y, x) <= d(x, y)$. Por lo tanto $d(x, y) = d(y, x)$.

  *(c) Positividad.* Aplicando (a) y luego (b) con $z = x$, y usando la simetría recién probada,
  $ 0 =^("a") d(x, x) <=^("b") d(x, y) + d(y, x) = 2 d(x, y), $
  con lo cual $d(x, y) >= 0$ para todos $x, y in M$. Si además $x != y$, por (a) sabemos que $d(x, y) != 0$, y en consecuencia $d(x, y) > 0$.

  Con la simetría, la propiedad (b) es exactamente la desigualdad triangular, así que $d$ es una métrica.
]

#sublema(titulo: "Para qué sirve")[
  La moraleja es práctica: para verificar que una función es métrica alcanza con chequear (a) y la desigualdad triangular en la forma torcida de (b). La simetría y la positividad se deducen. Conviene tenerlo a mano para los ítems del Ejercicio 1 de la Práctica 3.
]

#ejemplo[La métrica del peine en $RR^2$ (Clase 3 · Ejercicio 6)][C3-6][
  Probar que la función $d : RR^2 times RR^2 -> RR$ dada por
  $ d((x, y), (x', y')) = cases(
    abs(y - y') & "si" x = x',
    abs(x - x') + abs(y) + abs(y') & "si" x != x',
  ) $
  es una métrica en $RR^2$.
]

#estrategia[Métrica definida por casos: separar según cuántas abscisas coinciden][
  Para moverse entre dos puntos con abscisas distintas hay que "bajar al eje $x$", cruzar, y volver a subir: eso es lo que mide el segundo caso. Al verificar la desigualdad triangular con un tercer punto $(x'', y'')$, lo único que importa es cuáles de las tres abscisas $x, x', x''$ coinciden, así que la demostración se organiza en esos casos. La cota que hace funcionar todo es $abs(y - y'') <= abs(y) + abs(y'')$: pasar por el eje nunca es más barato que ir derecho.
]

#resolucion[
  Empecemos observando que $d((x, y), (x', y')) = d((x', y'), (x, y))$: los dos casos son simétricos en las dos entradas, y $abs(y - y') = abs(y' - y)$, $abs(x - x') = abs(x' - x)$.

  *(a) $d((x, y), (x', y')) = 0 <==> (x, y) = (x', y')$.*

  Si $(x, y) = (x', y')$, en particular $x = x'$, así que estamos en el primer caso y $d((x,y),(x',y')) = abs(y - y') = 0$.

  Recíprocamente, supongamos $d((x, y), (x', y')) = 0$. Si fuera $x != x'$, tendríamos
  $ d((x, y), (x', y')) = abs(x - x') + abs(y) + abs(y') >= abs(x - x') > 0, $
  absurdo. Entonces $x = x'$, y en tal caso $0 = d((x,y),(x',y')) = abs(y - y')$, de donde $y = y'$.

  *(b) Desigualdad triangular.* Queremos ver que
  $ d((x, y), (x', y')) <= d((x, y), (x'', y'')) + d((x'', y''), (x', y')). $

  - Si $x = x' = x''$, los tres términos caen en el primer caso y
    $ abs(y - y') <= abs(y - y'') + abs(y'' - y'), $
    que es la desigualdad triangular en $RR$.
  - Si $x = x' != x''$, el término de la izquierda cae en el primer caso y los dos de la derecha en el segundo:
    $ abs(y - y') &<= abs(y - y'') + abs(y'' - y') <= abs(y) + abs(y'') + abs(y'') + abs(y') \
      &<= abs(x - x'') + abs(y) + abs(y'') + abs(x'' - x') + abs(y'') + abs(y') \
      &= d((x, y), (x'', y'')) + d((x'', y''), (x', y')). $

  En los tres casos restantes es $x != x'$, así que el término de la izquierda cae en el segundo caso: $d((x,y),(x',y')) = abs(x - x') + abs(y) + abs(y')$. Lo que cambia es en qué caso caen los dos términos de la derecha, según $x''$ coincida con $x$, con $x'$ o con ninguno de los dos.

  - Si $x'' = x != x'$, el primer término de la derecha cae en el primer caso y el segundo en el segundo. Usando $abs(y) <= abs(y - y'') + abs(y'')$ (desigualdad triangular en $RR$),
    $ abs(x - x') + abs(y) + abs(y') &<= abs(x - x') + abs(y - y'') + abs(y'') + abs(y') \
      &= abs(y - y'') + (abs(x - x') + abs(y'') + abs(y')) \
      &= d((x, y), (x, y'')) + d((x, y''), (x', y')), $
    donde en la última igualdad se usó $x'' = x$ en los dos sumandos.
  - Si $x'' = x' != x$, es el caso anterior con los roles de $(x, y)$ y $(x', y')$ intercambiados: el primer término de la derecha cae en el segundo caso y el segundo en el primero. Usando ahora $abs(y') <= abs(y'') + abs(y'' - y')$,
    $ abs(x - x') + abs(y) + abs(y') &<= abs(x - x') + abs(y) + abs(y'') + abs(y'' - y') \
      &= (abs(x - x') + abs(y) + abs(y'')) + abs(y'' - y') \
      &= d((x, y), (x', y'')) + d((x', y''), (x', y')). $
  - Si $x'' != x$ y $x'' != x'$, los tres términos caen en el segundo caso. Como $abs(x - x') <= abs(x - x'') + abs(x'' - x')$ (desigualdad triangular en $RR$) y $2 abs(y'') >= 0$,
    $ abs(x - x') + abs(y) + abs(y') &<= abs(x - x'') + abs(x'' - x') + abs(y) + abs(y') + 2 abs(y'') \
      &= (abs(x - x'') + abs(y) + abs(y'')) + (abs(x'' - x') + abs(y'') + abs(y')) \
      &= d((x, y), (x'', y'')) + d((x'', y''), (x', y')). $

  Como $x$, $x'$, $x''$ son tres números reales, o bien coinciden los tres, o bien coinciden exactamente dos (y hay tres formas de elegir cuáles), o bien son todos distintos: los cinco casos de arriba cubren todas las posibilidades, y $d$ cumple la desigualdad triangular. Junto con (a) y la simetría, $d$ es una métrica en $RR^2$.
]

#observacion[Verificado en Lean: `lean/Ejemplos/Peine.lean`][
  `Peine.d` es la distancia del enunciado; `d_comm` es la simetría, `d_eq_zero_iff` es el ítem (a) y `d_triangle` es la desigualdad triangular con los mismos cinco casos, en el mismo orden y con las mismas cotas (`abs_sub_le` para las desigualdades triangulares en $RR$, `abs_sub` para $abs(y - y') <= abs(y) + abs(y')$). La instancia `MetricSpace Peine.Plano` empaqueta la conclusión: $(RR^2, d)$ es un espacio métrico.
]

#ejemplo[La métrica $C^1$ en $[0,1]$ (Clase 3 · Ejercicio 7)][C3-7][
  Sea $X = {f : [0,1] -> RR "continuas tales que" f' "es continua en" [0,1]}$ y definamos
  $
    d : X times X -> RR, quad d(f, g) &= norm(f - g)_infinity + norm(f' - g')_infinity \
    &= sup_(x in [0,1]) abs(f(x) - g(x)) + sup_(x in [0,1]) abs(f'(x) - g'(x)).
  $
  Probar que $d$ es una métrica.
]

#estrategia[Primero que la fórmula tenga sentido, después acotar puntualmente y tomar supremo][
  Antes de verificar los axiomas hay que asegurarse de que los dos supremos son finitos: eso lo da el teorema de Weierstrass, porque $f$ y $f'$ son continuas en un compacto.

  Para la desigualdad triangular, la maniobra es la de siempre con supremos: se acota *puntualmente* por una cota que ya no depende de $x$, y recién ahí se toma supremo del lado izquierdo. Se hace por separado para $f$ y para $f'$, y se suman las dos desigualdades.
]

#resolucion[
  Notemos primero que $d$ tiene sentido: por el teorema de Weierstrass, $f$ y $f'$ son continuas en el compacto $[0,1]$ y por lo tanto acotadas, así que los dos supremos son finitos. Notemos también que $d(f, g) = d(g, f)$, porque $abs(f(x) - g(x)) = abs(g(x) - f(x))$ para todo $x$ y lo mismo para las derivadas.

  *(a) $d(f, g) = 0 <==> f = g$.* Es claro que $d(f, f) = 0$. Recíprocamente, si $d(f, g) = 0$, como los dos sumandos son no negativos,
  $ 0 = d(f, g) >= sup_(x in [0,1]) abs(f(x) - g(x)) >= abs(f(x) - g(x)) quad "para todo" x in [0,1], $
  con lo cual $abs(f(x) - g(x)) = 0$, es decir $f(x) = g(x)$ para todo $x in [0,1]$, o sea $f = g$.

  *(b) Desigualdad triangular.* Sean $f, g, h in X$. Para cada $x in [0,1]$,
  $ abs(f(x) - g(x)) <= abs(f(x) - h(x)) + abs(h(x) - g(x)) <= sup_(x in [0,1]) abs(f(x) - h(x)) + sup_(x in [0,1]) abs(h(x) - g(x)). $
  El miembro derecho no depende de $x$, así que es una cota superior del conjunto de la izquierda y podemos tomar supremo:
  $ sup_(x in [0,1]) abs(f(x) - g(x)) <= sup_(x in [0,1]) abs(f(x) - h(x)) + sup_(x in [0,1]) abs(h(x) - g(x)). quad (1) $
  El mismo razonamiento aplicado a las derivadas da
  $ sup_(x in [0,1]) abs(f'(x) - g'(x)) <= sup_(x in [0,1]) abs(f'(x) - h'(x)) + sup_(x in [0,1]) abs(h'(x) - g'(x)). quad (2) $
  Sumando $(1)$ y $(2)$ y reagrupando,
  $ d(f, g) &= sup_(x in [0,1]) abs(f(x) - g(x)) + sup_(x in [0,1]) abs(f'(x) - g'(x)) \
    &<= sup_(x in [0,1]) abs(f(x) - h(x)) + sup_(x in [0,1]) abs(f'(x) - h'(x)) \
    &quad + sup_(x in [0,1]) abs(h(x) - g(x)) + sup_(x in [0,1]) abs(h'(x) - g'(x)) \
    &= d(f, h) + d(h, g). $

  Concluimos que $d$ es una métrica.
]

#ejemplo[Truncar una métrica: $d' = min{1, d}$ (Clase 3 · Ejercicio 8)][C3-8][
  Sea $d : X times X -> RR$ una métrica en $X$. Probar que $d'(x, y) := min{1, d(x, y)}$ es una métrica en $X$.
]

#estrategia[Separar según el lado izquierdo llegue o no a 1][
  La simetría y el axioma (a) son inmediatos. Lo único que hay trabajo es la desigualdad triangular
  $ min{1, d(x,y)} <= min{1, d(x,z)} + min{1, d(z,y)}, $
  y conviene partir según el miembro izquierdo valga $1$ (o sea $d(x,y) >= 1$) o valga $d(x,y)$.

  En el primer caso hay que probar que el miembro derecho llega a $1$; en el segundo, alcanza con ver que cada término truncado no perdió demasiado. En los dos, la observación clave es que $min{1, t} = t$ cuando $t <= 1$ y $min{1, t} = 1 >= t'$ para cualquier $t' <= 1$.
]

#resolucion[
  Notemos primero que $d'(x, y) = d'(y, x)$, porque $d$ es simétrica.

  *(a)* Si $x = y$, entonces $d'(x, x) = min{1, d(x, x)} = min{1, 0} = 0$, usando que $d(x,x) = 0$ por ser $d$ métrica. Recíprocamente, si $d'(x, y) = 0$ entonces $min{1, d(x,y)} = 0$, y como $1 != 0$ debe ser $d(x, y) = 0$, o sea $x = y$.

  *(b)* Queremos ver que
  $ min{1, d(x,y)} <= min{1, d(x,z)} + min{1, d(z,y)}. quad (star) $

  *Caso 1: $d(x, y) >= 1$.* El miembro izquierdo de $(star)$ vale $1$, así que hay que ver que el derecho es $>= 1$. Si alguno de $d(x,z)$, $d(z,y)$ es $>= 1$, el término correspondiente vale $1$ y listo. Si en cambio los dos son $< 1$, entonces $min{1, d(x,z)} = d(x,z)$ y $min{1, d(z,y)} = d(z,y)$, y por la desigualdad triangular de $d$,
  $ min{1, d(x,z)} + min{1, d(z,y)} = d(x,z) + d(z,y) >= d(x,y) >= 1. $

  *Caso 2: $d(x, y) <= 1$.* Ahora $(star)$ es
  $ d(x, y) <= min{1, d(x,z)} + min{1, d(z,y)}. quad (star star) $
  Si alguno de $d(x,z)$, $d(z,y)$ es $>= 1$, digamos $d(x,z) >= 1$, entonces
  $ d(x, y) <= 1 = min{1, d(x,z)} <= min{1, d(x,z)} + min{1, d(z,y)}. $
  Si en cambio $d(x,z) <= 1$ y $d(z,y) <= 1$, los dos mínimos son los propios valores y $(star star)$ se convierte en
  $ d(x, y) <= d(x, z) + d(z, y), $
  que es cierta por ser $d$ una métrica.

  En todos los casos vale $(star)$, así que $d'$ es una métrica.
]

#sublema(titulo: "Corrección al manuscrito")[
  En el Caso 1 el original razona: de $1 <= d(x,y) <= d(x,z) + d(z,y)$ se sigue que "alguna entre $d(x,z), d(z,y)$ es al menos $1$".

  Eso no se sigue: dos números pueden sumar $1$ o más sin que ninguno llegue a $1$ (por ejemplo $0,5 + 0,5$). La conclusión del caso igual vale, y el arreglo es una línea: si ninguno llega a $1$, entonces los dos mínimos son los propios valores y su suma es $d(x,z) + d(z,y) >= d(x,y) >= 1$. Es la versión que se transcribió arriba.
]

#ejemplo[La distancia discreta en cualquier conjunto (Ejemplo 4.2)][16][
  Sea $M$ un conjunto no vacío cualquiera. Se define la función $delta : M times M -> RR$ por
  $ delta(x, y) = cases(
    0 & "si" x = y,
    1 & "si" x != y.
  ) $
  Probar que $delta$ es una métrica en $M$.
]

#estrategia[Separar en casos según el lado izquierdo sea cero o uno][
  La no negatividad, la anulación si y sólo si $x = y$ y la simetría se deducen directamente de la definición por casos.

  Para la desigualdad triangular $delta(x, z) <= delta(x, y) + delta(y, z)$, si $x = z$ el lado izquierdo es $0$ y es trivial. Si $x != z$, el lado izquierdo vale $1$: basta notar que un elemento intermedio $y$ no puede ser simultáneamente igual a $x$ y a $z$, de modo que al menos uno de los términos de la derecha tiene que valer $1$.
]

#resolucion[
  Verifiquemos que $delta$ cumple los cuatro axiomas de métrica:

  #set enum(numbering: "(i)")
  + *No negatividad:* Como $delta(x, y) in {0, 1}$, se tiene $delta(x, y) >= 0$ para todos $x, y in M$.
  + *Separación:* Por definición, $delta(x, y) = 0$ si y sólo si $x = y$.
  + *Simetría:* Si $x = y$, $delta(x, y) = 0 = delta(y, x)$. Si $x != y$, entonces $y != x$, luego $delta(x, y) = 1 = delta(y, x)$. En cualquier caso, $delta(x, y) = delta(y, x)$ para todo $x, y in M$.
  + *Desigualdad triangular:* Sean $x, y, z in M$. Queremos ver que
    $ delta(x, z) <= delta(x, y) + delta(y, z). $
    - Si $x = z$, entonces $delta(x, z) = 0 <= delta(x, y) + delta(y, z)$ pues ambos sumandos son no negativos.
    - Si $x != z$, entonces $delta(x, z) = 1$. Dado $y in M$ cualquiera, no puede suceder que $y = x$ e $y = z$ al mismo tiempo (pues implicaría $x = z$). Por lo tanto, $y != x$ o $y != z$ (o ambos). Esto implica que $delta(x, y) = 1$ o $delta(y, z) = 1$. En consecuencia:
      $ delta(x, y) + delta(y, z) >= 1 = delta(x, z). $

  Concluimos que $delta$ es una métrica en $M$.
]

#ejemplo[La distancia del máximo en $RR^n$ (Ejemplo 4.2)][17][
  En $RR^n$, dados $x = (x_1, dots, x_n)$ e $y = (y_1, dots, y_n)$, se define
  $ d_oo (x, y) = max_(1 <= i <= n) abs(x_i - y_i). $
  Probar que $d_oo$ es una métrica en $RR^n$.
]

#estrategia[Acotar coordenada a coordenada por el máximo y trasladar la desigualdad al máximo][
  La no negatividad y la simetría provienen de las propiedades del valor absoluto en cada coordenada. La anulación requiere notar que si el máximo de cantidades no negativas es cero, cada una debe anularse por separado.

  Para la desigualdad triangular, se aplica la desigualdad triangular usual en $RR$ coordenada a coordenada, se reemplaza cada término de la derecha por el máximo global correspondiente, y al tener una cota independiente del índice $i$, se toma máximo del lado izquierdo.
]

#resolucion[
  Tomemos $x, y, z in RR^n$, con $x = (x_1, dots, x_n)$, $y = (y_1, dots, y_n)$ y $z = (z_1, dots, z_n)$.

  #set enum(numbering: "(i)")
  + *No negatividad:* Para cada $i = 1, dots, n$, se tiene $abs(x_i - y_i) >= 0$. Siendo el máximo de números no negativos,
    $ d_oo (x, y) = max_(1 <= i <= n) abs(x_i - y_i) >= 0. $
  + *Separación:* Supongamos que $d_oo (x, y) = 0$. Como $abs(x_i - y_i) >= 0$ para todo $i$ y su máximo es $0$, debe cumplirse $abs(x_i - y_i) = 0$ para cada $i = 1, dots, n$. Por lo tanto, $x_i = y_i$ para todo $i = 1, dots, n$, lo que equivale a $x = y$. Recíprocamente, si $x = y$, cada coordenada coincide y $abs(x_i - y_i) = 0$, con lo cual $d_oo (x, x) = 0$.
  + *Simetría:* Como $abs(x_i - y_i) = abs(y_i - x_i)$ para cada coordenada $i$,
    $ d_oo (x, y) = max_(1 <= i <= n) abs(x_i - y_i) = max_(1 <= i <= n) abs(y_i - x_i) = d_oo (y, x). $
  + *Desigualdad triangular:* Por la desigualdad triangular del valor absoluto en $RR$, para todo $i = 1, dots, n$ vale:
    $ abs(x_i - z_i) <= abs(x_i - y_i) + abs(y_i - z_i). $
    A su vez, para cada índice $i$:
    $ abs(x_i - y_i) <= max_(1 <= j <= n) abs(x_j - y_j) = d_oo (x, y), \
      abs(y_i - z_i) <= max_(1 <= j <= n) abs(y_j - z_j) = d_oo (y, z). $
    Sumando ambas desigualdades obtenemos:
    $ abs(x_i - z_i) &<= max_(1 <= j <= n) abs(x_j - y_j) + max_(1 <= j <= n) abs(y_j - z_j) \
      &= d_oo (x, y) + d_oo (y, z) quad "para todo" i = 1, dots, n. $
    Como esta cota superior no depende del índice $i$, vale en particular para el índice donde se alcanza el máximo del miembro izquierdo:
    $ d_oo (x, z) = max_(1 <= i <= n) abs(x_i - z_i) <= d_oo (x, y) + d_oo (y, z). $

  Queda demostrado que $d_oo$ es una métrica en $RR^n$.
]

#ejemplo[Bolas unitarias en $RR^2$ para $d_2, d_1$ y $d_oo$ (Ejemplo 4.6)][18][
  Determinar y describir la bola unitaria abierta centrada en el origen, $B((0, 0), 1)$, en el espacio $RR^2$ equipado con cada una de las métricas euclídea ($d_2$), taxista ($d_1$) y del máximo ($d_oo$).
]

#estrategia[Explicitar la inecuación que define cada bola a partir de la distancia][
  Se aplica directamente la definición de bola abierta $B(x_0, r) = {y in M : d(x_0, y) < r}$ tomando $x_0 = (0, 0)$ y $r = 1$:
  - Para $d_2$: $sqrt(x^2 + y^2) < 1 <=> x^2 + y^2 < 1$, que es el disco euclídeo sin el borde.
  - Para $d_1$: $abs(x) + abs(y) < 1$, cuyas cuatro rectas frontera son $plus.minus x plus.minus y = 1$, formando un rombo o cuadrado rotado.
  - Para $d_oo$: $max(abs(x), abs(y)) < 1 <=> abs(x) < 1 "y" abs(y) < 1$, que es un cuadrado de lado 2 alineado con los ejes.
]

#resolucion[
  #set enum(numbering: "1.")
  + *En $(RR^2, d_2)$:*
    $ B_(d_2)((0, 0), 1) &= {(x, y) in RR^2 : d_2((x, y), (0, 0)) < 1} \
      &= {(x, y) in RR^2 : sqrt(x^2 + y^2) < 1} = {(x, y) in RR^2 : x^2 + y^2 < 1}. $
    Geométricamente corresponde al interior del disco de radio $1$ centrado en el origen.

  + *En $(RR^2, d_1)$:*
    $ B_(d_1)((0, 0), 1) &= {(x, y) in RR^2 : d_1((x, y), (0, 0)) < 1} \
      &= {(x, y) in RR^2 : abs(x) + abs(y) < 1}. $
    Corresponde al interior del rombo de vértices $(1, 0), (0, 1), (-1, 0), (0, -1)$.

  + *En $(RR^2, d_oo)$:*
    $ B_(d_oo)((0, 0), 1) &= {(x, y) in RR^2 : d_oo ((x, y), (0, 0)) < 1} \
      &= {(x, y) in RR^2 : max(abs(x), abs(y)) < 1} = (-1, 1) times (-1, 1). $
    Corresponde al interior del cuadrado de lado $2$ con lados paralelos a los ejes coordenados.

  Observamos que $B_(d_1)((0, 0), 1) subset B_(d_2)((0, 0), 1) subset B_(d_oo)((0, 0), 1)$.
]

#ejemplo[Bola en $(C([a, b]), d_oo)$ como banda funcional (Ejemplo 4.7)][19][
  Sea $C([a, b])$ el espacio de funciones continuas equipado con la distancia del supremo $d_oo (f, g) = sup_(x in [a, b]) abs(f(x) - g(x))$. Describir geométricamente la bola abierta $B_(d_oo)(f, 1)$ centrada en una función $f in C([a, b])$ con radio $1$.
]

#estrategia[Traducir la cota global del supremo en una banda vertical punto a punto][
  La condición $sup_(x in [a, b]) abs(f(x) - g(x)) < 1$ exige que en cada punto $x in [a, b]$, el valor $g(x)$ diste estrictamente menos de $1$ de $f(x)$, es decir $f(x) - 1 < g(x) < f(x) + 1$. Geométricamente, el gráfico de $g$ debe quedar completamente contenido en el interior de la "banda" tubular de ancho vertical $2$ delimitada por $f - 1$ y $f + 1$.
]

#resolucion[
  Por definición de bola abierta:
  $ B_(d_oo)(f, 1) &= {g in C([a, b]) : d_oo (f, g) < 1} \
    &= {g in C([a, b]) : sup_(x in [a, b]) abs(f(x) - g(x)) < 1}. $

  Dado que $sup_(x in [a, b]) abs(f(x) - g(x)) < 1$, para todo $x in [a, b]$ se debe cumplir:
  $ abs(f(x) - g(x)) < 1 <==> -1 < g(x) - f(x) < 1 <==> f(x) - 1 < g(x) < f(x) + 1. $

  Por ende, una función $g in C([a, b])$ pertenece a $B_(d_oo)(f, 1)$ si y sólo si su gráfico está estrictamente contenido dentro de la banda vertical de semiancho $1$ alrededor de la curva $f(x)$. Si para algún punto $x_0 in [a, b]$ la curva de $g$ toca o cruza las curvas $f - 1$ o $f + 1$, entonces $abs(f(x_0) - g(x_0)) >= 1$ y por ende $g in.not B_(d_oo)(f, 1)$.

  #block(breakable: false, width: 100%)[#align(center)[
    #cetz.canvas({
      import cetz.draw: *
      let (xa, xb) = (0.8, 7.6)
      let n = 80
      let xs = range(n + 1).map(i => xa + (xb - xa) * i / n)
      let f(x) = 2.7 + 0.5 * calc.sin(0.9 * x)
      // g se queda adentro de la banda; h se escapa cerca de x0.
      let g(x) = f(x) + 0.6 * calc.sin(2.3 * x + 0.5)
      let x0 = 5.0
      let h(x) = f(x) - 0.35 + 2.1 * calc.exp(-calc.pow(x - x0, 2) / 0.5)
      let curva(fn) = xs.map(x => (x, fn(x)))

      let azul = rgb("#1e3a8a")
      let verde = rgb("#059669")
      let rojo = rgb("#dc2626")

      // Banda entre f - 1 y f + 1.
      line(
        ..curva(x => f(x) + 1), ..curva(x => f(x) - 1).rev(),
        close: true, fill: azul.lighten(88%), stroke: none,
      )
      line(..curva(x => f(x) + 1), stroke: (paint: azul, thickness: 0.7pt, dash: "dashed"))
      line(..curva(x => f(x) - 1), stroke: (paint: azul, thickness: 0.7pt, dash: "dashed"))
      line(..curva(f), stroke: 1.3pt + azul)
      line(..curva(g), stroke: 1pt + verde)
      line(..curva(h), stroke: 1pt + rojo)

      // Ejes.
      line((0, 0), (8.6, 0), mark: (end: ">"), stroke: 0.8pt)
      line((0.3, -0.3), (0.3, 5.2), mark: (end: ">"), stroke: 0.8pt)
      for (x, lbl) in ((xa, $a$), (xb, $b$)) {
        line((x, -0.1), (x, 0.1), stroke: 0.8pt)
        content((x, -0.35), text(size: 9pt, lbl))
        line((x, 0.1), (x, f(x) - 1), stroke: (paint: gray, thickness: 0.4pt, dash: "dotted"))
      }

      // El punto donde h se sale de la banda.
      line((x0, 0), (x0, h(x0)), stroke: (paint: rojo, thickness: 0.6pt, dash: "dotted"))
      line((x0, -0.1), (x0, 0.1), stroke: 0.8pt + rojo)
      content((x0, -0.35), text(size: 9pt, fill: rojo)[$x_0$])
      circle((x0, h(x0)), radius: 0.07, fill: rojo, stroke: none)
      circle((x0, f(x0)), radius: 0.06, fill: azul, stroke: none)

      // Etiquetas.
      content((xb + 0.55, f(xb) + 1), text(size: 9pt, fill: azul)[$f + 1$])
      content((xb + 0.3, f(xb)), text(size: 9pt, fill: azul)[$f$])
      content((xb + 0.55, f(xb) - 1), text(size: 9pt, fill: azul)[$f - 1$])
      content((3.2, g(3.2) + 0.28), text(size: 9pt, fill: verde)[$g$])
      content((x0 + 0.35, h(x0) + 0.25), text(size: 9pt, fill: rojo)[$h$])
    })

    #text(9pt)[
      #text(fill: rgb("#059669"))[$g in B_(d_oo)(f, 1)$]: su gráfico nunca sale de la banda. \
      #text(fill: rgb("#dc2626"))[$h in.not B_(d_oo)(f, 1)$]: en $x_0$ queda por encima de $f + 1$, así que
      $abs(f(x_0) - h(x_0)) >= 1$.
    ]
  ]]
]

#ejemplo[$d_oo$ y $d_1$ en $C([a,b])$ no son equivalentes (guía de la práctica)][guía-1][
  En $C([a,b])$ consideremos las dos métricas
  $ d_oo (f,g) = sup_(a<=x<=b) abs(f(x)-g(x)), quad d_1 (f,g) = integral_a^b abs(f(x)-g(x)) dif x. $
  (Por ejemplo, con $a=0$, $b=1$, $f(x)=x$ y $g(x)=0$: $d_(oo)(f,g)=1$ pero $d_1(f,g)=1/2$.) ¿Son estas dos métricas *equivalentes*, es decir, definen los mismos abiertos?
]

#estrategia[Comparar bolas: cada bola de una métrica, ¿contiene una bola de la otra?][
  Dos métricas son equivalentes si toda bola de una contiene una bola de la otra centrada en el mismo punto, y viceversa (esto sí pasa, por ejemplo, entre $d_2$ y $d_oo$ en $RR^n$). Acá hay que revisar las dos direcciones por separado:

  + ¿Existe, dada $B_(oo)(f,epsilon)$, un $delta>0$ tal que $B_1(f,delta) subset.eq B_(oo)(f,epsilon)$?
  + ¿Existe, dada $B_1(f,epsilon)$, un $delta>0$ tal que $B_(oo)(f,delta) subset.eq B_1(f,epsilon)$?
]

#resolucion[
  *(1) Falla.* Tomemos $f = 0$. Dado cualquier $delta > 0$, construimos $g in C([a,b])$ con $d_1(f,g) < delta$ pero $d_(oo)(f,g) >= epsilon$: una función "pico" triangular, de altura $2epsilon$ y base de ancho menor que $delta/epsilon$.

  El área bajo el pico (que es exactamente $integral_a^b abs(g)$) es
  $ "área" < (delta/epsilon) dot (2epsilon)/2 = delta, $

  #block(breakable: false, width: 100%)[#align(center)[
    #cetz.canvas({
      import cetz.draw: *
      let (xa, xb) = (0.8, 7.6)
      let e = 1.2 // epsilon
      let (c, w) = (4.6, 0.9) // centro y base del pico

      let azul = rgb("#1e3a8a")
      let rojo = rgb("#dc2626")

      // Banda B_oo(f, epsilon) alrededor de f = 0.
      rect((xa, -e), (xb, e), fill: azul.lighten(88%), stroke: none)
      line((xa, e), (xb, e), stroke: (paint: azul, thickness: 0.7pt, dash: "dashed"))
      line((xa, -e), (xb, -e), stroke: (paint: azul, thickness: 0.7pt, dash: "dashed"))

      // Ejes.
      line((0, 0), (8.6, 0), mark: (end: ">"), stroke: 0.8pt)
      line((0.3, -1.6), (0.3, 3.1), mark: (end: ">"), stroke: 0.8pt)
      for (x, lbl) in ((xa, $a$), (xb, $b$)) {
        line((x, -0.1), (x, 0.1), stroke: 0.8pt)
        content((x - 0.2, -0.3), text(size: 9pt, lbl))
      }
      for (y, lbl) in ((e, $epsilon$), (2 * e, $2 epsilon$), (-e, $-epsilon$)) {
        line((0.2, y), (0.4, y), stroke: 0.8pt)
        content((-0.15, y), text(size: 9pt, lbl))
      }

      // f = 0 y el pico g.
      line((c - w / 2, 0), (c, 2 * e), (c + w / 2, 0), close: true, fill: rojo.lighten(80%), stroke: none)
      line((xa, 0), (c - w / 2, 0), (c, 2 * e), (c + w / 2, 0), (xb, 0), stroke: 1.3pt + rojo)
      line((xa, 0), (xb, 0), stroke: (paint: azul, thickness: 1.3pt, dash: "dashed"))
      line((0.4, 2 * e), (c, 2 * e), stroke: (paint: gray, thickness: 0.4pt, dash: "dotted"))

      // Base del pico.
      line((c - w / 2, -0.3), (c + w / 2, -0.3), mark: (start: ">", end: ">"), stroke: 0.5pt)
      content((c, -0.65), text(size: 9pt)[$w < delta\/epsilon$])

      // Etiquetas.
      content((c + 0.45, 2 * e), text(size: 9pt, fill: rojo)[$g$])
      content((xb + 0.55, 0.25), text(size: 9pt, fill: azul)[$f = 0$])
      content((2.2, e + 0.28), text(size: 9pt, fill: azul)[$B_oo (f, epsilon)$])
      line((c + 1.0, 0.6), (c + 0.12, 0.6), mark: (end: ">"), stroke: 0.5pt + rojo)
      content((c + 1.9, 0.6), text(size: 9pt, fill: rojo)[área $= w epsilon < delta$])
    })

    #text(9pt)[
      #text(fill: rgb("#dc2626"))[$g in B_1(f, delta)$]: el área bajo el pico es $w epsilon < delta$. \
      #text(fill: rgb("#dc2626"))[$g in.not B_oo (f, epsilon)$]: la punta llega a $2 epsilon$ y se sale de la banda.
    ]
  ]]

  Así que $g in B_1(f,delta)$. Pero $sup abs(g) = 2epsilon >= epsilon$, así que $g in.not B_(oo)(f,epsilon)$. Como esto vale para *cualquier* $delta$, no existe ningún $delta$ que garantice $B_1(f,delta) subset.eq B_(oo)(f,epsilon)$: por más chica que sea la bola en $d_1$, siempre queda algún "pico" flaco y alto adentro que se escapa de la bola en $d_oo$.

  *(2) Vale.* Sea $epsilon > 0$ y tomemos $delta = epsilon/(b-a)$. Si $g in B_(oo)(f,delta)$, entonces para todo $x in [a,b]$:
  $ abs(f(x)-g(x)) <= sup_(t in [a,b]) abs(f(t)-g(t)) = d_(oo)(f,g). $
  El lado derecho no depende de $x$, así que integrando ambos lados en $[a,b]$:
  $ d_1(f,g) = integral_a^b abs(f(x)-g(x)) dif x <= integral_a^b d_(oo)(f,g) dif x = d_(oo)(f,g) dot (b-a) < delta dot (b-a) = epsilon. $
  Luego $g in B_1(f,epsilon)$, es decir $B_(oo)(f,delta) subset.eq B_1(f,epsilon)$.

  *Conclusión:* como la dirección (1) falla, $d_oo$ y $d_1$ *no* son equivalentes: hay bolas de $d_1$ que no contienen ninguna bola de $d_oo$. Sí vale que la topología de $d_oo$ es *más fina* que la de $d_1$ (toda bola de $d_oo$ contiene una bola de $d_1$, pero no al revés).
]

#ejemplo[Transportar una métrica por una función inyectiva: $D_f (x, y) = d(f(x), f(y))$ (Clase 15/09)][15/09-7][
  Sea $n in NN$, $f : RR^n -> RR^n$ una función inyectiva, y sea $d : RR^n times RR^n -> [0, +infinity)$ una métrica en $RR^n$. Definimos
  $ D_f (x, y) := d(f(x), f(y)) quad forall x, y in RR^n. $
  #set enum(numbering: "(i)")
  + Probar que $D_f$ es una métrica.
  + Probar que el resultado no vale si reemplazamos "inyectiva" por "sobreyectiva" en el enunciado.
]

#estrategia[Los axiomas de $D_f$ son los de $d$ leídos en $f(x), f(y)$; la inyectividad sólo hace falta para la separación][
  Positividad, simetría y desigualdad triangular se heredan de $d$ sin tocar $f$: basta escribir cada axioma de $d$ en los puntos $f(x), f(y), f(z)$. El único lugar donde entra la hipótesis es $D_f (x, y) = 0 => x = y$: $d$ sólo garantiza $f(x) = f(y)$, y es la inyectividad la que cierra. Por eso, si $f$ no es inyectiva, $D_f$ se anula en un par $x != y$ y no es métrica. Para (ii) alcanza entonces con fabricar una $f : RR^n -> RR^n$ sobreyectiva pero no inyectiva, y eso se consigue con una biyección $RR^n without {0} -> RR^n$ (existe porque son coordinables) extendida al $0$ con cualquier valor.
]

#resolucion[
  *(i)* Para ver que $D_f$ es una métrica, hay que probar lo siguiente:
  #set enum(numbering: "(1)")
  + $D_f (x, y) >= 0$ para todo $x, y in RR^n$.
  + $D_f (x, y) = 0$ si y sólo si $x = y$.
  + Para todos $x, y in RR^n$, se tiene que $D_f (x, y) = D_f (y, x)$.
  + Para todos $x, y, z in RR^n$, se tiene que $D_f (x, y) <= D_f (x, z) + D_f (y, z)$.

  (1) vale porque $d$ es una distancia, y por lo tanto es no negativa.

  (2) Si $x = y$, entonces $D_f (x, y) = d(f(x), f(x)) = 0$. Por otra parte, si $D_f (x, y) = 0$, entonces $f(x) = f(y)$ (porque $d$ es una métrica). Como $f$ es inyectiva, se sigue que $x = y$.

  (3) Sean $x, y in RR^n$. Como $d$ es una métrica, $D_f (x, y) = d(f(x), f(y)) = d(f(y), f(x)) = D_f (y, x)$.

  (4) Sean $x, y, z in RR^n$. Nuevamente, usando que $d$ es una distancia,
  $ D_f (x, y) = d(f(x), f(y)) <= d(f(x), f(z)) + d(f(z), f(y)) = D_f (x, z) + D_f (z, y). $

  *(ii)* Si $f$ no es inyectiva, entonces existen $x, y in RR^n$ tales que $x != y$ pero $f(x) = f(y)$. Esto implica que $D_f (x, y) = 0$, y por lo tanto $D_f$ no es una métrica. Luego, para probar que el resultado no vale para funciones sobreyectivas, es suficiente con probar que existe $f : RR^n -> RR^n$ sobreyectiva pero no inyectiva. Como $RR^n without {0}$ es coordinable con $RR^n$, existe $g : RR^n without {0} -> RR^n$ biyectiva. Fijamos cualquier $z in RR^n$ y definimos $f : RR^n -> RR^n$ como
  $ f(x) := cases(
    g(x) & " si " x != 0\,,
    z & " si " x = 0.
  ) $
  Como $g$ es sobreyectiva, existe $y in RR^n without {0}$ tal que $f(y) = g(y) = z = f(0)$, y entonces $f$ no es inyectiva. Por otra parte, como $g$ es sobreyectiva, también lo es $f$.
]

#sublema(titulo: "Observaciones de la clase, y la repetición del 29/09")[
  En (i) se puede reemplazar $RR^n$ por cualquier conjunto no vacío $X$; en (ii), por cualquier conjunto infinito (la clase deja como ejercicio ver qué pasa si $X$ es finito). Además, (ii) prueba la recíproca de (i): si $D_f$ es una métrica, entonces $f$ es inyectiva. La clase del 29/09 (`clases/2026/0929_repaso.typ`, Ejercicio 1, tag 29/09-1, optativo) repite el ítem (i) con la misma demostración para $f : A -> A$ inyectiva, con $A subset.eq X$ no vacío y $(X, d)$ un espacio métrico cualquiera, y lo usa para probar que $D(x, y) = abs(1\/x - 1\/y)$ es métrica en $(0, 1]$ (Ejemplo 29/09-2, Bloque 6).
]

#ejemplo[Bolas y diámetros para la métrica truncada $tilde(d) = op("mín"){1, d}$ (Clase 15/09)][15/09-8][
  Sea $(X, d)$ un espacio métrico y $tilde(d) : X times X -> [0, +infinity)$, $tilde(d) (x, y) := op("mín") {1, d(x, y)}$, que es una métrica (Ejemplo C3-8). Probar que
  #set enum(numbering: "(i)", start: 2)
  + Para todo $x in X$ y todo $r > 0$, $B_d (x, r) subset.eq B_(tilde(d)) (x, r)$.
  + Sea $0 < r <= 1$. Entonces $B_d (x, r) = B_(tilde(d)) (x, r)$.
  + Para todo $x in X$ y todo $r > 0$, se tiene que $B_(tilde(d)) (x, op("mín") {r, 1}) subset.eq B_d (x, r)$.
  + Sea $r > 1$. Supongamos que $X = RR$ y $d$ es el módulo. Calcular el diámetro de la bola abierta $B_(tilde(d)) (0, r)$ en el espacio métrico $(RR, tilde(d))$ y en el espacio métrico $(RR, d)$.
]

#estrategia[Por debajo de $1$, $tilde(d)$ y $d$ coinciden; por encima, $tilde(d)$ se queda clavada en $1$][
  Como $tilde(d) <= d$ siempre, toda $d$-bola entra en la $tilde(d)$-bola del mismo radio: eso es (ii). La igualdad (iii) vale para radios $r <= 1$ porque la condición $op("mín") {1, d(x, y)} < r <= 1$ obliga a que el mínimo sea $d(x, y)$; y (iv) es (iii) aplicada al radio $op("mín") {r, 1}$, seguida de que las bolas crecen con el radio. Para (v): en cuanto $r > 1$ la $tilde(d)$-bola ya es todo $RR$ (ninguna $tilde(d)$-distancia supera $1$), así que la pregunta es el diámetro de $RR$ medido con cada métrica, $infinity$ con el módulo y $1$ con $tilde(d)$. Moraleja: $d$ y $tilde(d)$ tienen las mismas bolas de radio $<= 1$, pero el diámetro de un conjunto (y su acotación) depende de la métrica.
]

#resolucion[
  Recordemos que $op("diam")_d (A) := sup_(x, y in A) d(x, y)$ es el diámetro de $A$ respecto de $d$, que es un real no negativo o $infinity$.

  *(ii)* Dados $x in X$, $r > 0$ e $y in B_d (x, r)$, se tiene que
  $ tilde(d) (x, y) = op("mín") {1, d(x, y)} <= d(x, y) < r, $
  así que $y in B_(tilde(d)) (x, r)$.

  *(iii)* Por (ii), ya tenemos una inclusión. Probemos la otra: sea $y in B_(tilde(d)) (x, r)$. Entonces
  $ op("mín") {1, d(x, y)} < r <= 1. $
  Se sigue que $op("mín") {1, d(x, y)} = d(x, y)$. Por lo tanto, $d(x, y) = tilde(d) (x, y) < r$, lo que implica que $y in B_d (x, r)$, y concluye la prueba de la inclusión que faltaba.

  *(iv)* Fijemos $x in X$ y $r > 0$. Como $0 < op("mín") {r, 1} <= 1$, aplicando (iii) obtenemos
  $ B_(tilde(d)) (x, op("mín") {r, 1}) = B_d (x, op("mín") {r, 1}) subset.eq B_d (x, r). $

  *(v)* Notemos que en este caso, para todo $x in RR$ se tiene que $tilde(d) (x, 0) <= 1 < r$. Por lo tanto $B_(tilde(d)) (0, r) = RR$. Entonces
  $ op("diam")_d (B_(tilde(d)) (0, r)) = op("diam")_d (RR) = sup_(x, y in RR) abs(x - y) = infinity. $
  Por otra parte,
  $ op("diam")_(tilde(d)) (B_(tilde(d)) (0, r)) = op("diam")_(tilde(d)) (RR) = sup_(x, y in RR) op("mín") {1, abs(x - y)} = 1. $

  _Nota_: en el apunte la primera igualdad de (v) tiene un paréntesis de más; lo que se calcula es $op("diam")_d (B_(tilde(d)) (0, r))$.
]

#sublema(titulo: "El ítem (i) y la prueba de la clase")[
  El ítem (i) del apunte (que $tilde(d)$ es métrica) es el Ejemplo C3-8 de este bloque y no se repite. La clase del 15/09 organiza la desigualdad triangular por el *lado derecho*: si alguno de $tilde(d) (x, z)$, $tilde(d) (z, y)$ vale $1$, entonces $tilde(d) (x, y) <= 1 <= tilde(d) (x, z) + tilde(d) (z, y)$; si no, los dos mínimos son los propios valores y $tilde(d) (x, y) <= d(x, y) <= d(x, z) + d(z, y)$. Es más corto que separar por el lado izquierdo como en C3-8, y esquiva el desliz que allí se corrige.
]

#ejemplo[El máximo de finitas métricas es una métrica; el mínimo, no (Clase 29/09)][29/09-4][
  Sea $X$ un conjunto, $n in NN$, y sean $D_1, dots, D_n$ métricas sobre $X$. Definimos $D : X times X -> RR_(>= 0)$ por medio de la fórmula
  $ D(x, y) := op("máx", limits: #true)_(1 <= j <= n) {D_j (x, y)}. $
  #set enum(numbering: "(i)")
  + Probar que $D$ es una métrica.
  + Si cambiamos el máximo por el mínimo en la definición de $D$, ¿sigue funcionando el argumento del punto anterior para probar que es una métrica? Ejercicio optativo (más difícil): determinar si, tomando el mínimo, $D$ es una métrica.
]

#estrategia[Para la triangular del máximo, fijar el índice donde se alcanza; para el mínimo, buscar un contraejemplo chico][
  Positividad, separación y simetría del máximo salen de que cada $D_j$ las tiene (para la separación alcanza con $D >= D_1$). La triangular es la misma maniobra que en $d_oo$ (Ejemplo 17): se elige el $k$ donde $D(x, y) = D_k (x, y)$, se usa la triangular de $D_k$ y después cada $D_k (dot.c, dot.c)$ se agranda al máximo. Con el mínimo ese paso se rompe: el mínimo de la izquierda no tiene por qué ser menor que la suma de dos mínimos tomados en índices posiblemente distintos. Pero "el argumento no funciona" no prueba nada: hay que exhibir $X$, $D_1$, $D_2$ y tres puntos donde la triangular falle. Con $X = {1, 2, 3}$ y $D_1 = abs(dot.c)$, se diseña $D_2$ para que mantenga $D_2 (1, 3) = 2$ y achique $D_2 (1, 2)$, agrandando $D_2 (2, 3)$ para que $D_2$ siga siendo métrica.
]

#resolucion[
  *(i)* Hay que ver: (1) $D >= 0$; (2) $D(x, y) = 0$ si y sólo si $x = y$; (3) $D(x, y) = D(y, x)$; (4) $D(x, y) <= D(x, z) + D(z, y)$.

  $D >= 0$ porque es el máximo de funciones no negativas. Por otra parte, $D >= D_1$; luego, si $D(x, y) = 0$, entonces $D_1 (x, y) = 0$, lo que implica $x = y$ porque $D_1$ es una métrica. Y si $x = y$, entonces $D_j (x, y) = 0$ para todo $1 <= j <= n$, así que $D(x, y) = 0$. Esto prueba (1) y (2). Para (3),
  $ D(x, y) = op("máx", limits: #true)_(1 <= j <= n) {D_j (x, y)} = op("máx", limits: #true)_(1 <= j <= n) {D_j (y, x)} = D(y, x), $
  usando para la segunda igualdad que las $D_j$ son métricas.

  Resta ver (4). Dados $x, y, z in X$, sea $1 <= k <= n$ tal que $D(x, y) = D_k (x, y)$ (es decir, dados $x$ e $y$, elegimos el $k$ donde se alcanza el máximo). Entonces
  $ D(x, y) = D_k (x, y) <= D_k (x, z) + D_k (z, y) <= D(x, z) + D(z, y). $

  _Nota_: la fuente escribe "$D >= d_1$"; se refiere a $D >= D_1$, la primera de las métricas $D_j$.

  *(ii)* Argumentos similares muestran que (1), (2) y (3) siguen valiendo para el mínimo (queda como ejercicio). Pero el argumento de (4) ya no funciona: no tenemos un máximo sino un mínimo, y no tendría en principio por qué ser menor que la suma de los mínimos. Esto, sin embargo, no alcanza para probar que $D$ no es métrica, porque no muestra que no haya otro argumento que sí funcione: hace falta un contraejemplo.

  Tomamos $n = 2$ y $X = {1, 2, 3}$. Sea $D_1 (x, y) = abs(x - y)$, la restricción a $X$ de la métrica usual de $RR$. Notemos que $D_1 (1, 3) = 2 = D_1 (1, 2) + D_1 (2, 3)$. Buscamos entonces que $D_2$ mantenga la distancia entre $1$ y $3$ pero reduzca una de las otras; al hacerlo hay que agrandar la restante para garantizar que $D_2$ siga siendo métrica. Por ejemplo,
  $ D_2 (1, 3) := 2, quad D_2 (1, 2) := 1/2, quad D_2 (2, 3) := 2. $
  $D_2$ es una métrica (queda como ejercicio de la clase demostrarlo; también, que con $D_2 (2, 3) = 1$ no lo sería: el menor valor admisible para $D_2 (2, 3)$ es $3\/2$ y el mayor es $5\/2$, y fuera de ese rango falla la desigualdad triangular).

  Tomando mínimo se tiene $D(1, 3) = 2$, $D(1, 2) = 1\/2$ y $D(2, 3) = 1$, y entonces
  $ D(1, 3) = 2 > 1/2 + 1 = D(1, 2) + D(2, 3), $
  así que no se cumple la desigualdad triangular y $D$ no es una métrica. Esto prueba que, si queremos obtener una métrica, no podemos reemplazar el máximo por el mínimo en la definición de $D$.
]

#v(10pt)

== Bloque 2 · Topología en espacios métricos: puntos interiores y abiertos

#sublema(titulo: "Qué desbloquea")[
  Desbloquea directamente el *Ejercicio 3 (a)* de la Práctica 3 (hallar el interior de $[0, 1]$) y el *Ejercicio 4* (probar que conjuntos son abiertos exhibiendo el radio de la bola contenida).

  La maniobra clave para un punto interior $x$ es elegir el radio como la distancia mínima al borde, $r = min(x - a, b - x)$, lo cual garantiza tanto que $r > 0$ como que la bola abierta $B(x, r)$ no se sale del conjunto.

  El último ejemplo del bloque, 17/09-1 (interior de un producto $A times B$ con la métrica suma), está cargado sólo con el enunciado y la observación de la clase sobre cómo *no* elegir el radio ($r = r_1 + r_2$ falla); es la versión en producto del Ejercicio 6 (a), $(A inter B)^circle = A^circle inter B^circle$, y descansa en la misma idea de elegir bien $r$.
]

#ejemplo[Interior del intervalo cerrado: $[0, 1]^circle = (0, 1)$ (Ejemplo 4.13)][20][
  Consideremos $(RR, abs(dot.c))$ y el conjunto $E = [0, 1]$. Probar que $E^circle = (0, 1)$.
]

#estrategia[Tomar el radio como la distancia más corta al borde del intervalo][
  Para que un punto $x in (0, 1)$ sea interior, debemos hallar un radio $r > 0$ tal que la bola abierta $B(x, r) = (x - r, x + r)$ quede totalmente contenida en $[0, 1]$. La distancia de $x$ al extremo izquierdo $0$ es $x$, y al extremo derecho $1$ es $1 - x$. Tomando $r = min(x, 1 - x) > 0$, la bola no puede rebasar ninguno de los dos bordes.
]

#resolucion[
  Sea $x in (0, 1)$. Para ver que $x in E^circle$, debemos hallar $r > 0$ tal que $B(x, r) subset.eq [0, 1]$. Como la métrica es la usual del módulo en $RR$:
  $ B(x, r) = {y in RR : d(x, y) < r} = {y in RR : abs(x - y) < r} = (x - r, x + r). $
  Debemos encontrar un radio $r > 0$ de modo que el intervalo centrado en $x$ se mantenga adentro de $(0, 1)$.

  #block(breakable: false, width: 100%)[#align(center)[
    #cetz.canvas({
      import cetz.draw: *
      line((-0.5, 0), (6.5, 0), mark: (end: ">"), stroke: 0.8pt)
      content((6.8, 0), text(size: 9pt)[$RR$])

      let x0 = 1.0
      let x1 = 5.5
      let xp = 2.8

      line((x0, 0), (x1, 0), stroke: 2.2pt + rgb("#1e3a8a"))

      line((x0, -0.15), (x0, 0.15), stroke: 1pt)
      content((x0, -0.35), text(size: 9pt)[$0$])
      line((x1, -0.15), (x1, 0.15), stroke: 1pt)
      content((x1, -0.35), text(size: 9pt)[$1$])

      circle((xp, 0), radius: 0.08, fill: black)
      content((xp, 0.35), text(size: 9.5pt, weight: "bold")[$x$])

      let y_b = -0.18
      line((x0, y_b), (xp, y_b), stroke: 0.7pt, mark: (start: "|", end: "|"))
      content(((x0 + xp)/2, y_b - 0.25), text(size: 8.5pt)[$x$])

      line((xp, y_b), (x1, y_b), stroke: 0.7pt, mark: (start: "|", end: "|"))
      content(((xp + x1)/2, y_b - 0.25), text(size: 8.5pt)[$1 - x$])
    })
  ]]

  Observamos que nos alcanza con tomar $r = min(x, 1 - x)$, es decir, la distancia más corta al borde del intervalo. Como $0 < x < 1$, sabemos que $r > 0$. Veamos que efectivamente este radio funciona: sea $y in (x - r, x + r)$, entonces:

  - *Cota inferior ($y >= 0$):* Como $r <= x$, tenemos que $-r >= -x$. Usando esto:
    $ y >= x - r >= x - x = 0. $
  - *Cota superior ($y <= 1$):* Como $r <= 1 - x$, tenemos:
    $ y <= x + r <= x + 1 - x = 1. $

  Por lo tanto, $(x - r, x + r) subset.eq [0, 1]$, lo que prueba que todo $x in (0, 1)$ es punto interior de $E$.

  Recíprocamente, los extremos $0$ y $1$ no son interiores pues para cualquier $r > 0$, $B(0, r) = (-r, r)$ contiene puntos negativos que no pertenecen a $E$, y análogamente $B(1, r)$ contiene puntos mayores a $1$. En conclusión, $E^circle = (0, 1)$.
]

#ejemplo[Interior de $QQ$ en $RR$ es vacío (Ejemplo 4.13 b)][20][
  En $(RR, abs(dot.c))$, consideremos $E = QQ$. Veamos que $E^circle = emptyset$.
]

#resolucion[
  Sea $q in E$. Para ver que $q in.not E^circle$, lo que tenemos que ver es que para cualquier radio $r > 0$, $B(q, r) inter E^c != nothing$. Como nuestra distancia es el módulo, tenemos como antes que $B(q, r) = (q - r, q + r)$.

  Pero sabemos que entre dos números reales (en este caso podríamos tomar $q$ y $q + r$) siempre debe haber un número irracional. Es decir, existe $x in RR backslash QQ$ tal que $q < x < q + r$ y por lo tanto $(q - r, q + r) inter E^c != nothing$, como queríamos ver.
]

#ejemplo[Diámetro de una bola (Ejemplo 4.10)][21][
  Para una bola $B(x_0, r)$, se cumple que $op("diam")(B(x_0, r)) <= 2r$. Veamos esto: lo que tenemos que hacer es ver que $d(x, y) <= 2r$ para cualesquiera $x, y in B(x_0, r)$.
]

#resolucion[
  Sean $x, y in B(x_0, r)$. Por la desigualdad triangular tenemos que
  $ d(x, y) <= d(x, x_0) + d(x_0, y) < r + r = 2r. $
  Como $d(x, y) < 2r$ para todo $x, y in B(x_0, r)$, podemos concluir que $op("diam")(B(x_0, r)) <= 2r$.

  En el caso de la distancia euclídea se puede probar que el diámetro de una bola es 2 veces su radio. Sin embargo, esto no es cierto en general. Veamos qué pasa con la distancia discreta. Sea $M$ cualquier conjunto con más de dos elementos y $delta$ la distancia discreta. Consideremos $r > 1$ y calculemos el diámetro de $B(x_0, r)$. Si $x != x_0$ cualquier elemento, tenemos por definición que $delta(x, x_0) = 1$, lo cual nos dice que
  $ op("diam")(B(x_0, r)) = 1 < 2r, quad "si" r > 1. $

  ¿Qué pasa si $0 < r < 1$?
]

#ejemplo[$M$ y $emptyset$ son abiertos (Ejemplo 4.15)][22][
  Sea $(M, d)$ un espacio métrico.
  #set enum(numbering: "a)")
  + $A = M$ es abierto: por definición, un punto interior $x$ es un punto tal que existe algún radio $r > 0$ con $B(x, r) subset.eq M$. Pero como $M$ es todo el espacio métrico, ninguna bola se puede salir de $M$ (porque $M$ es todo el universo), con lo cual todos los puntos $x in M$ son puntos interiores. Esto dice que $M$ es abierto.
  + $A = emptyset$ es abierto: como el interior de un conjunto siempre está contenido en el conjunto, tenemos que $emptyset^compose subset.eq emptyset$. Pero entonces $emptyset^compose$ no puede tener ningún elemento. Entonces $emptyset^compose = emptyset$.
]

#ejemplo[Bola unitaria en $RR^2$ es abierta (Ejemplo 4.16 a)][23][
  En $(RR^2, d_2)$, sea $A = B((0, 0), 1) = {(x, y) in RR^2 : x^2 + y^2 < 1}$. Veamos que $A$ es un conjunto abierto.
]

#estrategia[Tomar el radio como la distancia de $p$ al borde de la circunferencia][
  Dado $p in A$, hay que encontrar $r > 0$ tal que $B(p, r) subset.eq A$. Gráficamente, lo más grande que puede ser ese radio es cuando lo tomamos como la distancia de $p$ al borde del círculo de radio $1$.

  #block(breakable: false, width: 100%)[
    #align(center)[
      #cetz.canvas({
        import cetz.draw: *
        line((-1.8, 0), (2.3, 0), mark: (end: ">"), stroke: 0.8pt)
        content((2.5, 0), text(size: 8pt)[$x$])
        line((0, -1.8), (0, 2.3), mark: (end: ">"), stroke: 0.8pt)
        content((0, 2.45), text(size: 8pt)[$y$])

        circle((0, 0), radius: 1.5, fill: rgb("#ede9fe"), stroke: (dash: "dashed", paint: rgb("#2563eb"), thickness: 1pt))
        content((1.15, 1.15), text(size: 8.5pt, fill: rgb("#2563eb"))[$B((0,0), 1)$])

        line((-0.07, 1.5), (0.07, 1.5), stroke: 0.8pt)
        content((-0.2, 1.5), text(size: 7.5pt)[$1$])
        line((1.5, -0.07), (1.5, 0.07), stroke: 0.8pt)
        content((1.5, -0.25), text(size: 7.5pt)[$1$])

        let p = (0.35, 0.15)
        let rp = 0.55
        circle(p, radius: rp, fill: none, stroke: (dash: "dashed", paint: rgb("#dc2626"), thickness: 1pt))
        circle(p, radius: 0.03, fill: black)
        content((p.at(0) + 0.25, p.at(1) - 0.15), text(size: 8pt)[$p$])
        let ang = 130deg
        line(p, (p.at(0) + rp * calc.cos(ang), p.at(1) + rp * calc.sin(ang)), stroke: 0.6pt + rgb("#dc2626"))
        content((p.at(0) - 0.3, p.at(1) + 0.35), text(size: 7.5pt, fill: rgb("#dc2626"))[$r$])
        content((p.at(0) - 0.15, p.at(1) - rp - 0.2), text(size: 7.5pt, fill: rgb("#dc2626"))[$B(p, r)$])
      })
    ]
  ]
]

#resolucion[
  Sea $p = (x_0, y_0) in A$, es decir $x_0^2 + y_0^2 < 1$. Tomemos $r = 1 - sqrt(x_0^2 + y_0^2) > 0$ por hipótesis. Veamos que este radio funciona, es decir que $B(p, r) subset.eq B((0, 0), 1)$. Sea $(x, y) in B(p, r)$. Tenemos, por la desigualdad triangular, que
  $ sqrt(x^2 + y^2) = d_2((x, y), (0, 0)) <= d_2((x, y), (x_0, y_0)) + d_2((x_0, y_0), (0, 0)) < r + sqrt(x_0^2 + y_0^2) = 1. $
  Es decir, tenemos que $sqrt(x^2 + y^2) < 1$ como queríamos ver.
]

#ejemplo[Toda bola abierta es un conjunto abierto (Ejemplo 4.16 b)][23][
  En general, en $(M, d)$ cualquier espacio métrico, $A = B(x_0, r)$ es un conjunto abierto.
]

#resolucion[
  Si pensamos en el ejemplo anterior, nos damos cuenta de que en realidad no era tan importante el hecho de estar en $RR^2$ con $d_2$: la única propiedad que necesitamos fue usar la desigualdad triangular, que es común a todas las métricas.

  Veamos que $A$ es abierto: sea $x in A$ y tomemos $t = r - d(x, x_0) > 0$ por definición, y consideremos $B(x, t)$. Veamos que $B(x, t) subset.eq B(x_0, r)$. Sea $y in B(x, t)$. Tenemos que
  $ d(y, x_0) <= d(y, x) + d(x, x_0) < t + d(x, x_0) = r, $
  como queríamos ver.
]

#ejemplo[El conjunto de funciones inyectivas no es abierto ni cerrado (Clase 4 · Ejercicio 4)][C4-4][
  Sea $E = {f:[0,1] -> RR : f "acotada"}$ con la métrica $d_infinity$, y sea $A = {f in E : f "inyectiva"}$. ¿Es $A$ abierto? ¿Es cerrado?
]

#estrategia[Para "no abierto", chocar dos valores cercanos; para "no cerrado", aplastar $f$ hacia una constante][
  Alcanza con un contraejemplo en cada dirección: una función $tilde(f)$ no inyectiva pero $d_infinity$-cercana a una $f in A$ (para "no abierto"), y una sucesión en $A$ que converge a algo fuera de $A$ (para "no cerrado"). En ambos casos $f(x)=x$ es el punto de partida natural.
]

#resolucion[
  *$A$ no es abierto.* Sea $f(x)=x in A$. Dado $epsilon>0$, definimos
  $ tilde(f)(x) = cases(0 & "si" x in [0,epsilon/2], x & "si" x in.not [0,epsilon/2]). $
  Entonces $tilde(f)$ no es inyectiva ($tilde(f)(0)=tilde(f)(epsilon/4)=0$, por ejemplo), pero
  $ abs(f(x)-tilde(f)(x)) = cases(abs(x) = epsilon/2 < epsilon & "si" x in [0,epsilon/2], 0 & "si no"), $
  así que $d_infinity(f,tilde(f)) <= epsilon/2 < epsilon$, es decir $tilde(f) in B(f,epsilon)$. Como $tilde(f) in.not A$ para todo $epsilon$, $f in.not A^circle$, y por lo tanto $A$ no es abierto.

  *$A$ no es cerrado.* La sucesión $f_n(x)=x\/n$ está en $A$ (es inyectiva), pero $d_infinity(f_n,0) <= 1/n -> 0$, así que $f_n -> 0$ y la función nula no es inyectiva.
]

#ejemplo[Interior de un producto con la métrica suma: $(A times B)^circle = A^circle times B^circle$ (Clase 17/09)][17/09-1][
  Sean $(X, d_1)$ e $(Y, d_2)$ espacios métricos. En $X times Y$ consideremos la métrica
  $ d((x_1, y_1), (x_2, y_2)) = d_1 (x_1, x_2) + d_2 (y_1, y_2). $
  Sean $A subset.eq X$ y $B subset.eq Y$. Probar que $(A times B)^circle = A^circle times B^circle$. Deducir que, si $A$ y $B$ son abiertos, entonces $A times B$ es abierto en $X times Y$.
]

#estrategia[En la inclusión $supset.eq$ el radio no es $r_1 + r_2$: hay que elegirlo con cuidado][
  Si $(a, b) in A^circle times B^circle$, hay radios $r_1, r_2 > 0$ con $B_(d_1) (a, r_1) subset.eq A$ y $B_(d_2) (b, r_2) subset.eq B$, y hay que fabricar un único $r > 0$ con $B_d ((a, b), r) subset.eq A times B$. Una tentación frecuente es tomar $r = r_1 + r_2$, imitando la forma de la métrica. El siguiente ejemplo de la clase muestra que esa elección *no* funciona.

  Sea $X = Y = RR$ con $d_1 = d_2 = abs(dot.c)$, de modo que $d((x_1, y_1), (x_2, y_2)) = abs(x_1 - x_2) + abs(y_1 - y_2)$. Tomemos
  $ A = (-1, 1), quad B = (-2, 2), quad (a, b) = (0, 0), quad r_1 = 1, quad r_2 = 2. $
  Se cumple $B_(d_1) (0, 1) = (-1, 1) subset.eq A$ y $B_(d_2) (0, 2) = (-2, 2) subset.eq B$, así que $r_1$ y $r_2$ son radios admisibles en cada coordenada. Sin embargo, con $r_1 + r_2 = 3$ el punto $p = (3\/2, 0)$ cumple
  $ d(p, (0, 0)) = abs(3/2) + abs(0) = 3/2 < 3, $
  o sea $p in B_d ((0, 0), r_1 + r_2)$, pero $3\/2 in.not A = (-1, 1)$ y por lo tanto $p in.not A times B$. Es decir, $B_d ((0, 0), r_1 + r_2) subset.eq.not A times B$.

  (El apunte de la clase deja el ejercicio sin resolver; sólo trae esta observación.)
]

#v(10pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Bloque 3 · Clausura, cerrados, conjunto derivado y frontera

#sublema(titulo: "Qué desbloquea")[
  El resto del *Ejercicio 3* de la Práctica 3 (clausura, no sólo interior), el *Ejercicio 4
  (a), (b) y (d)* (bolas cerradas, complemento abierto/cerrado, y que $emptyset$ y el total
  sean cerrados) y el *Ejercicio 7* (frontera y puntos de acumulación de los conjuntos del
  Ejercicio 3).

  *El orden importa:* el primero (clausura de la bola abierta en $RR^2$) fija la técnica de la
  doble contención con la recta que une al centro; el segundo (bola cerrada es cerrada) la
  reusa con la desigualdad triangular "al revés". Los tres últimos son el mismo par de
  conjuntos ($(0,1) union {2}$) recorrido con las cuatro nociones --- interior, clausura,
  derivado y frontera --- y después generalizado a $ZZ$, $(0,1)$ y $QQ$.

  Al final del bloque, de la clase del 17/09, se agregan la *caracterización sucesional de la
  clausura* (17/09-4: $x in overline(A)$ si y sólo si $x$ es límite de una sucesión de $A$), que
  es la herramienta con la que se calculan las clausuras del Ejercicio 3 (g)--(h) y se prueba el
  Ejercicio 10 (c), y su aplicación completa a ${(1\/n, 1\/m)}$ en $RR^2$ con la métrica suma
  (17/09-5), hermano bidimensional del 15/09-6 y de C4-1: candidato, sucesiones explícitas para
  una inclusión y análisis de los índices para la otra.
]

#ejemplo[Clausura de la bola unitaria en $(RR^2, d_2)$ (Ejemplo 4.24)][24][
  Sea $(M, d) = (RR^2, d_2)$ y sea $E = B((0,0), 1) = {(x, y) in RR^2 : x^2 + y^2 < 1}$. Veamos que $overline(E) = B[(0,0), 1]$.
]

#estrategia[Doble contención por la recta que une al centro con el punto][
  Para ver que $B[(0,0),1] subset.eq overline(E)$, hay que probar que todo punto del borde $x^2+y^2=1$ es de adherencia. La idea es acercarse a ese punto *desde adentro* de $E$, siguiendo la recta que lo une con el origen: los puntos $(t x, t y)$ con $t$ cercano a $1$ (pero menor) están en $E$ y a la vez arbitrariamente cerca de $(x,y)$.
]

#resolucion[
  #block(breakable: false, width: 100%)[#align(center)[
    #cetz.canvas({
      import cetz.draw: *
      line((-1.8, 0), (1.8, 0), mark: (end: ">"), stroke: 0.8pt)
      content((1.95, 0), text(size: 8pt)[$x$])
      line((0, -1.8), (0, 1.8), mark: (end: ">"), stroke: 0.8pt)
      content((0, 1.95), text(size: 8pt)[$y$])

      line((-0.07, 1.2), (0.07, 1.2), stroke: 0.8pt)
      content((-0.2, 1.2), text(size: 7.5pt)[$1$])
      line((1.2, -0.07), (1.2, 0.07), stroke: 0.8pt)
      content((1.2, -0.25), text(size: 7.5pt)[$1$])

      circle((0, 0), radius: 1.2, fill: rgb("#eff6ff"), stroke: (dash: "dashed", paint: blue, thickness: 1.1pt))
      content((-0.9, -0.9), text(size: 9pt, fill: blue)[$E$])
      content((-0.25, -0.25), text(size: 7.5pt)[$0$])

      let xp = (0.85, 0.85)
      circle(xp, radius: 0.35, fill: rgb("#fecaca"), stroke: (dash: "dashed", paint: red, thickness: 1pt))
      circle(xp, radius: 0.03, fill: black)
      content((xp.at(0) - 0.05, xp.at(1) + 0.28), text(size: 7.5pt, fill: red)[$B(x,r)$])
      content((xp.at(0) + 0.08, xp.at(1) - 0.2), text(size: 7.5pt)[$x$])

      line((2.7, 0.55), (xp.at(0) + 0.32, xp.at(1) - 0.05), stroke: 0.6pt, mark: (end: ">"))
      content((2.7, 0.85), text(size: 7.5pt)[$B(x,r) inter E != nothing$])
      content((2.7, 0.35), text(size: 7pt)[(punto de adherencia)])
    })
  ]]

  Veamos que $overline(E) = {(x, y) in RR^2 : x^2 + y^2 <= 1} = B[(0,0), 1]$. Para esto, veamos la doble contención.

  Supongamos que $(x, y) in B[(0,0), 1]$. Si $x^2 + y^2 < 1$, tenemos que $(x, y) in E$ y por lo tanto pertenece a su clausura. Si $x^2 + y^2 = 1$ (es decir, $(x, y)$ está en el borde del círculo), lo que tenemos que probar es que para todo radio $r > 0$, $B((x,y), r) inter E != nothing$. Para encontrar un punto que pertenezca a la intersección de las bolas lo que podemos hacer es pensar en la recta que une al $(0,0)$ con $(x,y)$. Gráficamente, podemos ver que vamos a tener un elemento en esa recta que pertenece a la intersección. Analíticamente, esto lo podemos escribir de la siguiente manera: consideremos los elementos $(t x, t y)$, con $t in RR$. Para que un elemento de esta recta pertenezca a $E$, debemos tener
  $ (t x)^2 + (t y)^2 = t^2 (x^2 + y^2) = t^2 < 1, $
  es decir, nos alcanza con que $abs(t) < 1$. Para que este elemento además pertenezca a la bola $B((x,y), r)$, deberíamos tener
  $ d_2((t x, t y), (x, y)) = sqrt((t x - x)^2 + (t y - y)^2) = sqrt((t-1)^2 (x^2+y^2)) = abs(t - 1) < r. $
  Esto nos dice que si queremos que un elemento de la pinta $(t x, t y)$ pertenezca a la intersección lo que estamos buscando es un $t in RR$ que simultáneamente cumpla que $abs(t) < 1$ y $abs(1-t) < r$. Esto no es difícil de conseguir, podríamos por ejemplo fijar $t = 1 - r/2$, y este número cumple las dos condiciones que queríamos. Esto nos termina de probar que $B[(0,0), 1] subset.eq overline(E)$.

  Para ver la otra contención, es más fácil probar que si un elemento *no* pertenece a $B[(0,0), 1]$ entonces *no* puede pertenecer a la clausura de $E$. Lo dejamos como ejercicio.
]

#ejemplo[Las bolas cerradas son conjuntos cerrados (Ejemplo 4.28)][25][
  En $(M, d)$ cualquier espacio métrico, el conjunto $F = B[x, r] = {y in M : d(y, x) <= r}$ es un conjunto cerrado.
]

#estrategia[La mitad de la doble inclusión sale gratis][
  Para probar la igualdad $overline(F) = F$, la inclusión $F subset.eq overline(F)$ vale siempre (Observación 4.23), así que sólo hay que probar $overline(F) subset.eq F$. Usando el contrarrecíproco ($A subset.eq B <=> B^c subset.eq A^c$), alcanza con ver que si $y in.not F$ entonces $y in.not overline(F)$: hay que exhibir una bola alrededor de $y$ que no toque a $F$.
]

#resolucion[
  Dicho esto, lo que vamos a probar es que si $y in.not B[x, r]$ entonces $y in.not overline(B[x, r])$. Sea $y in.not B[x, r]$. Por definición, esto quiere decir que $d(y, x) > r$. Veamos que $y in.not overline(B[x, r])$, es decir, que existe un radio $t > 0$ tal que $B(y, t) inter B[x, r] = nothing$. Como $d(y, x) > r$, tomemos $t = d(y, x) - r > 0$ y veamos que $B(y, t) inter B[x, r] = nothing$.

  #block(breakable: false, width: 100%)[#align(center)[
    #cetz.canvas({
      import cetz.draw: *
      let xp = (0, 0)
      let yp = (1.9, 0)

      circle(xp, radius: 1.3, fill: rgb("#dbeafe"), stroke: (paint: blue, thickness: 1.2pt))
      circle(yp, radius: 0.6, fill: none, stroke: (dash: "dashed", paint: red, thickness: 1.1pt))
      circle(xp, radius: 0.03, fill: black)
      circle(yp, radius: 0.03, fill: black)

      content((xp.at(0) - 0.6, xp.at(1) + 1.4), text(size: 9pt, fill: blue)[$B[x,r]$])
      content((yp.at(0) + 0.4, yp.at(1) + 0.75), text(size: 9pt, fill: red)[$B(y,t)$])
      content((xp.at(0), xp.at(1) - 0.25), text(size: 8pt)[$x$])
      content((yp.at(0), yp.at(1) - 0.25), text(size: 8pt)[$y$])

      line(xp, (1.3, 0), stroke: (paint: blue, thickness: 2pt))
      content((0.65, 0.22), text(size: 8pt, fill: blue)[$r$])
      line((1.3, 0), yp, stroke: (paint: red, thickness: 2pt))
      content((1.6, 0.22), text(size: 8pt, fill: red)[$t$])

      line((0, -1.6), (1.9, -1.6), stroke: 0.6pt)
      line((0, -1.5), (0, -1.7), stroke: 0.6pt)
      line((1.9, -1.5), (1.9, -1.7), stroke: 0.6pt)
      content((0.95, -1.9), text(size: 8pt)[$d(y,x)$])

      content((0.95, -2.3), text(size: 8.5pt)[$B(y,t) inter B[x,r] = emptyset$])
    })
  ]]

  Hagamos una pequeña observación. Recordemos que la desigualdad triangular, que vale en cualquier espacio métrico, nos dice que
  $ d(x, y) <= d(x, z) + d(z, y), $
  para cualquiera tres puntos $x, y, z in M$. Muchas veces, como en esta demostración, nos sirve mirar a la desigualdad triangular "al revés": esta desigualdad también dice
  $ d(x, z) >= d(x, y) - d(z, y). $

  Ahora sigamos con el ejemplo. Recordemos que estábamos intentando probar que $B(y, t) inter B[x, r] = nothing$. Sea $z in B(y, t)$, y veamos que no puede pasar que $z in B[x, r]$, es decir, probemos que $d(z, x) > r$:
  $ d(z, x) >= d(x, y) - d(z, y) > d(x, y) - t = d(x, y) - (d(x, y) - r) = r, $
  que es lo que queríamos ver.
]

#ejemplo[$emptyset$ y $M$ son conjuntos cerrados (Ejemplo 4.30)][26][
  Sea $(M, d)$ un espacio métrico. Entonces $emptyset$ y $M$ son conjuntos cerrados.
]

#resolucion[
  Recordemos que ya vimos que $M$ y $emptyset$ son conjuntos abiertos (Ejemplo 22). Como un conjunto es cerrado si y sólo si su complemento es abierto, y $emptyset^c = M$, $M^c = emptyset$, vemos que ambos son también cerrados.
]

#ejemplo[Clausura, interior y conjunto derivado de $(0,1) union {2}$ (Ejemplo 4.35)][27][
  Sea $E = (0,1) union {2} subset.eq (RR, abs(dot.c))$. Hallar $E^compose$, $overline(E)$ y $E'$.
]

#resolucion[
  Tenemos:

  - $E^compose = (0,1)$.
  - $overline(E) = [0,1] union {2}$.
  - $E' = [0,1]$: cuando tomamos $B(2, 1/2) = (2 - 1/2, 2 + 1/2) = (3/2, 5/2)$, vemos que $B(2,1/2) inter E = {2}$, y por lo tanto $2 in overline(E)$ pero $2 in.not E'$.

  La clausura y el conjunto derivado no son iguales, como vemos en este ejemplo. Sin embargo, por definición sabemos que $E' subset.eq overline(E)$, dado que la condición que le pedimos a punto de acumulación es más fuerte que la que le pedimos a punto de adherencia.
]

#ejemplo[Frontera de $(0,1) union {2}$ (Ejemplo 4.39)][28][
  Sea $E = (0,1) union {2} subset.eq (RR, abs(dot.c))$. Entonces $partial E = {0, 1, 2}$.
]

#resolucion[
  #block(breakable: false, width: 100%)[#align(center)[
    #cetz.canvas({
      import cetz.draw: *
      line((-1.2, 0), (5.2, 0), mark: (end: ">"), stroke: 0.8pt)
      content((5.45, 0), text(size: 9pt)[$RR$])

      line((0, 0), (2, 0), stroke: (paint: blue, thickness: 2.5pt))
      content((1, 0.3), text(size: 8.5pt, fill: blue)[$E$])

      circle((0, 0), radius: 0.04, fill: red)
      circle((2, 0), radius: 0.04, fill: red)
      circle((4, 0), radius: 0.05, fill: blue)
      content((0, -0.3), text(size: 8pt)[$0$])
      content((2, -0.3), text(size: 8pt)[$1$])
      content((4, -0.3), text(size: 8pt)[$2$])

      content((-0.55, 0.3), text(size: 9pt, fill: red)[(])
      content((0.55, 0.3), text(size: 9pt, fill: red)[)])
      content((0, 0.65), text(size: 8pt, fill: red)[$B(0,r)$])

      content((1.45, 0.3), text(size: 9pt, fill: red)[(])
      content((2.55, 0.3), text(size: 9pt, fill: red)[)])
      content((2, 0.65), text(size: 8pt, fill: red)[$B(1,r)$])

      content((3.45, 0.3), text(size: 9pt, fill: red)[(])
      content((4.55, 0.3), text(size: 9pt, fill: red)[)])
      content((4, 0.65), text(size: 8pt, fill: red)[$B(2,r)$])
    })
  ]]

  Para ver esto, deberíamos probar que dado $r > 0$, las bolas $B(0,r)$, $B(1,r)$ y $B(2,r)$ intersecan tanto a $E$ como a $E^c$. Gráficamente, esto no es difícil de creer. Analíticamente, podríamos argumentar que, por ejemplo, $-r/2 in B(0,r) inter E^c$ y $r/2 in B(0,r) inter E$ (y podríamos hacer lo mismo con los otros puntos).

  Por otra parte, deberíamos ver que no hay otros puntos en la frontera. Acá tenemos dos casos: $x in E$ o $x in.not E$.

  Si $x in E$ pero $x != 2$, tenemos que $x in (0,1)$. Podemos construir una bola que se quede contenida en $E$ alrededor de $x$, tomando como $r = op("mín"){r, 1 - r}$, como hicimos en el Ejemplo 20. Esto nos indica que $x in.not partial E$, dado que no interseca a $E^c$.

  Si $x in.not E$, podríamos encontrar una bola que se quede contenida totalmente en $E^c$. Podríamos tomar $r = op("mín"){abs(x), abs(x-1), abs(x-2)} > 0$ (es decir, tomamos la menor distancia de $x$ a los puntos $0, 1, 2$) y nos sale que $B(x, r) subset.eq E^c$. Esto nos dice que $x in.not partial E$.
]

#ejemplo[Clausura, interior, derivado y frontera: tres ejemplos en $(RR, abs(dot.c))$ (Ejemplo 4.41)][29][
  #set enum(numbering: "a)")
  + Sea $E = ZZ subset.eq (RR, abs(dot.c))$. Como estamos en $(RR, abs(dot.c))$, sabemos que $B(x, r) = (x - r, x + r)$. Observemos que si $n in ZZ$, y $r$ es un radio con $0 < r < 1$, $B(n, r) inter ZZ = {n}$ y a su vez $B(n, r) inter ZZ^c != nothing$. Por otro lado, si $x in.not ZZ$, no es difícil ver que existe un radio $r > 0$ tal que $B(x, r) inter ZZ = emptyset$.

    #block(breakable: false, width: 100%)[#align(center)[
      #cetz.canvas({
        import cetz.draw: *
        let u = 2.2
        let verde = rgb("#15803d")
        line((-3.0, 0), (8.0, 0), mark: (end: ">"), stroke: 0.8pt)
        content((8.3, 0), text(size: 9pt)[$RR$])
        content((-2.6, 0.9), text(size: 10pt, fill: blue)[$E = ZZ$])

        for k in (-1, 0, 1, 2, 3) {
          circle((k * u, 0), radius: 0.05, fill: blue)
          content((k * u, -0.32), text(size: 8pt)[$#k$])
        }

        // Bola centrada en un entero: sólo contiene a n
        let n = 1 * u
        line((n - 0.5, 0), (n + 0.5, 0), stroke: (paint: red, thickness: 1.5pt))
        content((n - 0.5, 0.02), text(size: 10pt, fill: red)[(])
        content((n + 0.5, 0.02), text(size: 10pt, fill: red)[)])
        content((n, 0.5), text(size: 9pt, fill: red)[$B(n,r)$])
        content((0.2, 1.65), text(size: 8pt)[$B(n,r) inter ZZ = {n}$])
        content((0.2, 1.25), text(size: 8pt)[$B(n,r) inter ZZ^c != emptyset$])
        line((0.9, 1.0), (n - 0.25, 0.15), stroke: 0.5pt, mark: (end: ">"))

        // Bola centrada en un no entero: no toca a ZZ
        let xp = 2.5 * u
        line((xp - 0.45, 0), (xp + 0.45, 0), stroke: (paint: verde, thickness: 1.5pt))
        content((xp - 0.45, 0.02), text(size: 10pt, fill: verde)[(])
        content((xp + 0.45, 0.02), text(size: 10pt, fill: verde)[)])
        circle((xp, 0), radius: 0.04, fill: black)
        content((xp, 0.5), text(size: 9pt, fill: verde)[$B(x,r)$])
        content((xp, -0.32), text(size: 8pt)[$x$])
        line((xp + 1.0, -0.95), (xp + 0.3, -0.1), stroke: 0.5pt, mark: (end: ">"))
        content((xp + 1.2, -1.25), text(size: 8pt)[$x in.not ZZ: quad B(x,r) inter ZZ = emptyset$])
      })
    ]]

    Estas observaciones nos llevan a concluir lo siguiente:
    - $overline(ZZ) = ZZ$ (es un conjunto cerrado).
    - $ZZ^compose = emptyset$ (no es un conjunto abierto).
    - $ZZ' = emptyset$.
    - $partial ZZ = ZZ$.

  + Sea $E = (0, 1) subset.eq (RR, abs(dot.c))$. Tenemos
    - $overline((0,1)) = [0,1]$ (no es un conjunto cerrado).
    - $(0,1)^compose = (0,1)$ (es un conjunto abierto).
    - $(0,1)' = [0,1]$: si $x in [0,1]$, sabemos que $(x-r, x+r) inter (0,1)$ es un intervalo y por lo tanto contiene infinitos elementos para todo $r > 0$.
    - $partial (0,1) = {0, 1}$: los únicos puntos que cumplen que $(x-r,x+r)$ interseca tanto a $(0,1)$ como a $(0,1)^c$ para todo $r > 0$ son el $0$ y el $1$.

  + Sea $E = QQ subset.eq (RR, abs(dot.c))$. Tenemos
    - $overline(QQ) = RR$ (no es un conjunto cerrado).
    - $QQ^compose = emptyset$ (no es un conjunto abierto).
    - $QQ' = RR$: si $x in RR$ y $r > 0$, tenemos que el conjunto $(x-r,x+r) inter QQ$ contiene infinitos elementos.
    - $partial QQ = RR$: si $x in RR$ y $r > 0$, el intervalo $(x-r,x+r)$ interseca tanto a $QQ$ como a $QQ^c$ (cualquier intervalo abierto contiene números racionales e irracionales).
]

#ejemplo[$[a,b]$ es cerrado (Clase 15/09)][15/09-1][
  Sea $(RR, abs(dot.c))$ y $E = [a,b]$. Veamos que $E$ es cerrado.
]

#estrategia[Doble inclusión: una mitad es gratis][
  Un conjunto es cerrado si $overline(E) = E$. La inclusión $E subset.eq overline(E)$ vale siempre, para cualquier conjunto, así que sólo falta probar $overline(E) subset.eq E$.
]

#ejemplo[$[a,b)$ no es cerrado ni es abierto (Clase 15/09)][15/09-2][
  Sea $(RR, abs(dot.c))$ y $E = [a,b)$. Veamos que $E$ no es abierto y que tampoco es cerrado.
]

#resolucion[
  *$E$ no es abierto:* tenemos que $a in E$, pero $a in.not E^compose$. En efecto, para todo $r > 0$,
  $ B(a,r) inter E^c = (a-r,a+r) inter [a,b)^c != nothing, $
  ya que $a - r/2 in B(a,r) inter [a,b)^c$ (está a la izquierda de $a$, así que no pertenece a $E$).

  *$E$ no es cerrado:* tenemos que $b in overline(E)$, pero $b in.not E$. En efecto, para todo $r > 0$,
  $ B(b,r) inter E = (b-r,b+r) inter [a,b) != nothing, $
  ya que $b - r/2 in B(b,r) inter E$ (tomando $r$ suficientemente chico para que además $b - r/2 > a$).
]

#ejemplo[La bola cerrada es cerrada, vía $r arrow 0^+$ (Clase 15/09)][15/09-3][
  Sea $(RR^2, d_2)$ y $E = B[(0,0), 1] = {(x,y) in RR^2 : d_2((x,y),(0,0)) <= 1}$. Veamos que $E$ es cerrado.
]

#estrategia[Acotar la distancia al origen por $r + 1$ para todo $r > 0$, y después hacer $r arrow 0^+$][
  La inclusión $E subset.eq overline(E)$ vale siempre. Para la otra, si $(x,y) in overline(E)$, para todo $r > 0$ hay un punto de $E$ en $B((x,y),r)$, y la desigualdad triangular da una cota de $d_2((x,y),(0,0))$ que depende de $r$. Como esa cota vale para *todo* $r > 0$ y el lado izquierdo no depende de $r$, tomando $r arrow 0^+$ se concluye $d_2((x,y),(0,0)) <= 1$.
]

#resolucion[
  Como $E subset.eq overline(E)$ vale siempre, falta ver $overline(E) subset.eq E$. Sea $(x,y) in overline(E)$: por definición, para todo $r > 0$ existe $(tilde(x), tilde(y)) in B((x,y),r) inter E$, es decir
  $ d_2((tilde(x),tilde(y)),(x,y)) < r quad "y" quad d_2((tilde(x),tilde(y)),(0,0)) <= 1. $

  Por desigualdad triangular,
  $ d_2((x,y),(0,0)) <= d_2((x,y),(tilde(x),tilde(y))) + d_2((tilde(x),tilde(y)),(0,0)) < r + 1. $

  Como esto vale para todo $r > 0$, tomando $r -> 0^+$ concluimos que $d_2((x,y),(0,0)) <= 1$, es decir, $(x,y) in E$.
]

#ejemplo[Supremo e ínfimo de un conjunto acotado están en su clausura (Clase 15/09)][15/09-4][
  Sea $E subset.eq RR$ acotado, en $(RR, abs(dot.c))$. Veamos que $op("sup")(E), op("ínf")(E) in overline(E)$.
]

#estrategia[Todo entorno del supremo agarra algún punto de $E$, por ser la menor cota superior][
  Recordemos que $overline(E) = {x in RR : forall r > 0, B(x,r) inter E != nothing}$. Dado $r > 0$, hay que hallar un punto de $E$ en $B(op("sup")(E), r) = (op("sup")(E) - r, op("sup")(E) + r)$. Como $op("sup")(E) - r$ es menor que la *menor* cota superior de $E$, ya no puede ser cota superior, así que debe existir $e in E$ con $e > op("sup")(E) - r$; y automáticamente $e <= op("sup")(E) < op("sup")(E) + r$.
]

#resolucion[
  Sea $r > 0$. Como $op("sup")(E) - r < op("sup")(E)$ y $op("sup")(E)$ es la menor cota superior de $E$, el número $op("sup")(E) - r$ no puede ser cota superior de $E$. Por lo tanto existe $e in E$ tal que
  $ e in (op("sup")(E) - r, op("sup")(E)) subset.eq B(op("sup")(E), r), $
  es decir, $e in B(op("sup")(E), r) inter E$. Como $r > 0$ era arbitrario, $op("sup")(E) in overline(E)$.

  La demostración para $op("ínf")(E) in overline(E)$ es análoga.

  Dos ejemplos concretos de esta observación:
  - $E = {1/n : n in NN}$: tenemos $0 = op("ínf")(E) in overline(E)$, aunque $0 in.not E$.
  - $E = [a, b)$ (Ejemplo 15/09-2): tenemos $b in overline(E)$ porque $b = op("sup")(E)$, lo cual explica directamente por qué $b in overline(E) without E$.
]

#ejemplo[La esfera $S(x,r)$ es un conjunto cerrado (Clase 15/09)][15/09-5][
  Sea $(X, d)$ un espacio métrico. Dados $x in X$ y $r > 0$, definimos la esfera
  $ S(x,r) = {y in X : d(y,x) = r}. $
  Probar que $S(x,r)$ es cerrado.
]

#estrategia[Doble contradicción por tricotomía][
  Como $S(x,r) subset.eq overline(S(x,r))$ vale siempre, alcanza con ver $overline(S(x,r)) subset.eq S(x,r)$: si $y$ es punto de adherencia de $S(x,r)$, hay que ver que $d(y,x) = r$. La estrategia es descartar los otros dos casos de la tricotomía ($d(y,x) > r$ y $d(y,x) < r$) por separado, sacando en ambos un punto $z in S(x,r)$ suficientemente cerca de $y$ y usando la desigualdad triangular para llegar a un absurdo.
]

#resolucion[
  Sea $y in X$ un punto de adherencia de $S(x,r)$. Queremos ver que $d(y,x) = r$.

  *Caso $d(x,y) > r$:* sea $epsilon = d(y,x) - r > 0$. Como $y in overline(S(x,r))$, existe $z in B(y,epsilon) inter S(x,r)$. Entonces
  $ d(x,y) <= underbrace(d(x,z), =r) + underbrace(d(z,y), <epsilon) < r + epsilon = r + d(y,x) - r = d(y,x), $
  es decir $d(x,y) < d(y,x)$, lo cual es absurdo (por simetría, $d(x,y) = d(y,x)$).

  *Caso $d(y,x) < r$:* sea $epsilon = r - d(x,y) > 0$. Como $y in overline(S(x,r))$, existe $z in B(y,epsilon) inter S(x,r)$. Entonces
  $ r = d(x,z) <= d(x,y) + underbrace(d(y,z), <epsilon) < d(x,y) + epsilon = d(x,y) + r - d(x,y) = r, $
  es decir $r < r$, absurdo.

  Por tricotomía, descartados los otros dos casos, debe ser $d(y,x) = r$, es decir $y in S(x,r)$. Esto prueba que $overline(S(x,r)) subset.eq S(x,r)$ y, junto con la inclusión que vale siempre, $overline(S(x,r)) = S(x,r)$: $S(x,r)$ es cerrado.
]

#sublema(titulo: "Otra forma del primer caso (guía de la práctica)")[
  La versión de la guía evita el paso de simetría del primer caso: define directamente $epsilon = d(x,y) - r$ (en vez de $epsilon = d(y,x) - r$), con lo cual $r + epsilon = d(x,y)$ de entrada, y la cadena
  $ d(x,y) <= d(x,z) + d(z,y) < r + epsilon = d(x,y) $
  da la contradicción $d(x,y) < d(x,y)$ directamente, sin necesitar invocar $d(x,y) = d(y,x)$.
]

#ejemplo[Interior y clausura de $A = {m + 1/(n+1) : m, n in NN}$ (Clase 15/09)][15/09-6][
  Sea $A subset.eq RR$ definido como
  $ A = {m + 1/(n+1) : m, n in NN}. $
  Hallar $A^circle$ y $overline(A)$, en $(RR, d)$ con $d(x,y) = abs(x-y)$.
]

#estrategia[Racimos de puntos que se acumulan sobre cada natural, viniendo desde la derecha][
  Notemos que $A subset.eq RR_(>0)$ y $A subset.eq QQ$. Fijado $m in NN$, al variar $n in NN$ se obtiene la sucesión
  $ m + 1/2, quad m + 1/3, quad m + 1/4, quad dots, quad m + 1/(n+1) -> m, $
  que decrece estrictamente hacia $m$ sin alcanzarlo nunca. Es decir, $A$ es una unión de racimos de puntos que se acumulan sobre cada natural $m$, acercándose desde la derecha.

  #block(breakable: false, width: 100%)[#align(center)[
    #cetz.canvas({
      import cetz.draw: *
      line((-0.3, 0), (7.3, 0), mark: (end: ">"), stroke: 0.8pt)
      content((7.6, 0), text(size: 9pt)[$RR$])

      for pair in ((0.5, "1"), (2, "2"), (3.5, "3")) {
        circle((pair.at(0), 0), radius: 0.035, fill: black)
        content((pair.at(0), -0.3), text(size: 8pt)[#pair.at(1)])
      }
      content((4.5, -0.05), text(size: 9pt)[...])
      circle((5.5, 0), radius: 0.035, fill: black)
      content((5.5, -0.3), text(size: 8pt)[$m$])
      circle((7, 0), radius: 0.035, fill: black)
      content((7, -0.3), text(size: 8pt)[$m+1$])

      for xoff in (1.45, 1.15, 0.95, 0.8, 0.68, 0.6) {
        circle((5.5 + xoff, 0.12), radius: 0.025, fill: rgb("#dc2626"))
      }
      content((6.4, 0.4), text(size: 7.5pt, fill: rgb("#dc2626"))[$m + 1/(n+1)$])
    })
  ]]
]

#resolucion[
  *Interior: $A^circle = emptyset$.* Como $A subset.eq QQ$, tenemos $A^circle subset.eq QQ^circle$. Pero ya vimos que $QQ^circle = emptyset$ (Ejemplo 20 b), así que $A^circle subset.eq emptyset$, es decir $A^circle = emptyset$.

  *Clausura: $overline(A) = A union NN$.* Veamos primero que $A union NN subset.eq overline(A)$.

  - $A subset.eq overline(A)$ vale siempre.
  - $NN subset.eq overline(A)$: sea $m in NN$; veamos que $m$ es punto de adherencia de $A$. Sea $r > 0$; queremos ver que $B(m,r) inter A = (m-r, m+r) inter A != nothing$. Por arquimedianidad, existe $k in NN$ tal que $1/k < r$. Entonces
    $ m - r < m < m + 1/(k+1) < m + 1/k < m + r, $
    donde $m + 1/(k+1) < m + 1/k$ porque $k+1 > k$, y $m + 1/k < m+r$ porque $1/k < r$. El punto $m + 1/(k+1)$ pertenece a $A$ (tomando el índice $k$ en su definición), y por la cadena de desigualdades pertenece también a $(m-r, m+r)$. Luego $(m-r,m+r) inter A != nothing$, es decir, $m in overline(A)$.

  *(Queda pendiente, tal como se dejó en la clase, la otra inclusión $overline(A) subset.eq A union NN$.)*
]

#ejemplo[El conjunto derivado de la imagen de una sucesión convergente (guía de la práctica)][guía-2][
  Sea $(E,d)$ un espacio métrico y sea $(a_n)_(n in NN) subset.eq E$ tal que $a_n -> a$. Sea $A = {a_n : n in NN}$ (la imagen de la sucesión, sin el orden). Probar que $A' = {a}$ o $A' = emptyset$.
]

#estrategia[Si hay algún punto de acumulación, tiene que ser el límite][
  Recordemos que $A' = {x in E : forall r > 0, B(x,r) inter (A without {x}) != nothing}$. La idea es suponer que $A' != emptyset$, tomar $b in A'$ arbitrario, y ver que necesariamente $b = a$. Si $b != a$, la distancia $lambda = d(b,a) > 0$ da margen para construir un radio $r$ demasiado chico como para que $B(b,r)$ agarre algún término de la sucesión distinto de $b$: los términos con $n$ grande están todos cerca de $a$ (lejos de $b$), y de los finitos términos con $n$ chico se puede achicar $r$ para esquivarlos a todos.
]

#resolucion[
  Supongamos que $A' != emptyset$ y veamos que $A' = {a}$. Sea $b in A'$, y veamos que $b = a$.

  Supongamos, por el absurdo, que $b != a$, y sea $lambda = d(b,a) > 0$. Como $a_n -> a$, existe $n_0 in NN$ tal que
  $ d(a_n, a) < lambda/2 quad forall n >= n_0. $

  Tomemos
  $ r = min({d(b, a_n) : n < n_0, a_n != b} union {lambda/2}) > 0 $
  (el mínimo de un conjunto finito de números positivos, así que $r > 0$). Veamos que $B(b,r) inter (A without {b}) = emptyset$, lo cual contradice que $b in A'$:

  - Si $n < n_0$ y $a_n != b$, entonces $d(b, a_n) >= r$ por construcción de $r$, así que $a_n in.not B(b,r)$.
  - Si $n >= n_0$ y $a_n != b$: si además $a_n in B(b,r)$, es decir $d(a_n,b) < r <= lambda/2$, por desigualdad triangular
    $ lambda = d(a,b) <= d(a, a_n) + d(a_n, b) < lambda/2 + lambda/2 = lambda, $
    absurdo. Luego $a_n in.not B(b,r)$.

  En cualquier caso, ningún $a_n != b$ está en $B(b,r)$, es decir $B(b,r) inter (A without {b}) = emptyset$, lo cual contradice que $b$ sea punto de acumulación de $A$. Por lo tanto $b = a$, y concluimos que $A' subset.eq {a}$, es decir $A' = {a}$ o $A' = emptyset$.
]

#ejemplo[Interior, clausura, aislados, acumulación y frontera de $A = {1/n + 1/m : n,m in NN}$ (Clase 4 · Ejercicio 1)][C4-1][
  En $(RR, abs(dot.c))$, sea $A = {1/n + 1/m : n,m in NN}$. Determinar $A^circle$, $overline(A)$, los puntos aislados, $A'$ y $partial A$.
]

#estrategia[Ningún punto de $A$ tiene margen (está en $QQ$), pero sí está aislado de los demás puntos de $A$][
  Como $A subset.eq QQ$ y $QQ^circle = emptyset$ (Ejemplo 20 b), inmediatamente $A^circle = emptyset$. Para la clausura, hay que rastrear a dónde puede converger una sucesión $1/n_k+1/m_k$ cuando los índices $n_k,m_k$ no necesariamente divergen: si ambos quedan acotados, Bolzano-Weierstrass los vuelve eventualmente constantes y el límite cae en $A$; si alguno diverge, el límite es $0$ o $1/m$ para algún $m$ fijo. Por otro lado, dos elementos distintos de $A$ nunca están arbitrariamente cerca: la resta $1/n+1/m-1/n'-1/m'$ tiene numerador entero no nulo sobre denominador $n n' m m'$, así que está acotada lejos de $0$ --- eso hace que cada punto de $A$ sea aislado.
]

#resolucion[
  *Interior: $A^circle = emptyset$.* Como $A subset.eq QQ$, $A^circle subset.eq QQ^circle = emptyset$ (Ejemplo 20 b).

  *Clausura: $overline(A) = A union {0} union {1/n : n in NN}$.*

  $supset.eq)$ Siempre $A subset.eq overline(A)$. Además, $1/n+1/(n+1) -> 0$, así que $0 in overline(A)$; y fijado $n$, $1/n+1/m -> 1/n$ cuando $m -> +infinity$, así que $1/n in overline(A)$.

  $subset.eq)$ Sea $a in overline(A)$, con $a_k = 1/n_k + 1/m_k -> a$. Las sucesiones $(n_k)_k, (m_k)_k$ no tienen por qué divergir. Si ambas están acotadas, por Bolzano-Weierstrass (aplicado primero a una y, sobre la subsucesión resultante, a la otra) se extrae una subsucesión con $n_(k_j) = n$ y $m_(k_j) = m$ eventualmente constantes (al ser sucesiones de naturales, toda subsucesión convergente es eventualmente constante), y entonces $a = 1/n+1/m in A$. Si alguna de las dos no está acotada, digamos $(n_k)_k$ (el otro caso es análogo), por el Ejercicio 13 de la Práctica 1 existe una subsucesión $n_(k_j) -> +infinity$; si a su vez $(m_(k_j))_j$ está acotada, se extrae una subsucesión con $m$ eventualmente constante y $a_(k_(j_l)) -> 1/m$; si $(m_(k_j))_j$ tampoco está acotada, se extrae una subsucesión con $m_(k_(j_l)) -> +infinity$ y $a_(k_(j_l)) -> 0$. En cualquier caso, $a in A union {0} union {1/n : n in NN}$.

  *Puntos aislados: todos los de $A$.* Dados $a = 1/n+1/m != b = 1/n'+1/m'$ en $A$,
  $ abs(a-b) = abs((n'm m' + n m m' - n n' m' - n m n')/(n n' m m')) >= 1/(n n' m m'), $
  porque el numerador es un entero no nulo. Tomando $r < 1/(n n' m m')$, $B(a,r) inter A = {a}$.

  *Conjunto derivado: $A' = {0} union {1/n : n in NN}$*, ya que $overline(A) = A' union A$ y $A$ consta de puntos aislados ($A' inter A = emptyset$).

  *Frontera: $partial A = overline(A) without A^circle = {0} union {1/n : n in NN}$* (Ejercicio 9 de la Práctica 3).

  _Comparar con el Ejemplo 15/09-6_: mismo tipo de análisis para $A = {m+1/(n+1)}$, donde había quedado pendiente $overline(A) subset.eq A union NN$; el argumento de Bolzano-Weierstrass de acá se adapta a ese caso.
]

#ejemplo[Interior, clausura, aislados, acumulación y frontera de $A = {(x,y) in RR^2 : y > x}$ (Clase 4 · Ejercicio 2)][C4-2][
  En $(RR^2, d_2)$, sea $A = {(x,y) in RR^2 : y > x}$ (el semiplano estrictamente por encima de la recta $y=x$). Determinar $A^circle$, $overline(A)$, los puntos aislados, $A'$ y $partial A$.
]

#estrategia[Trabajar con $d_infinity$ (equivalente a $d_2$) y tomar el radio como la mitad de la distancia vertical a la diagonal][
  Para ver que $a=(a_1,a_2) in A$ es interior, conviene medir con $d_infinity$ en vez de $d_2$ (dan los mismos abiertos): la bola $B_infinity(a,r)$ es un cuadrado de lado $2r$ centrado en $a$, y tomando $r = 1/2(a_2-a_1)$ el cuadrado no llega a tocar la diagonal. Para la clausura, basta ver que toda sucesión en $A$ que converge tiene límite con $y>=x$ (pasando al límite en la desigualdad estricta), y que cualquier punto con $y>=x$ es límite de puntos de $A$ desplazando $y$ una cantidad $1/m -> 0$.
]

#resolucion[
  *Interior: $A^circle = A$.* Ya vale $A^circle subset.eq A$. Sea $a=(a_1,a_2) in A$, es decir $a_2>a_1$. Con $d_infinity(a,(x,y)) = sup{abs(a_1-x),abs(a_2-y)}$, tomamos $r=1/2(a_2-a_1)>0$. Si $(x,y) in B_infinity(a,r)$, es decir $abs(x-a_1)<r$, $abs(y-a_2)<r$, entonces
  $ y-x = (y-a_2)+(a_2-a_1)+(a_1-x) > (a_2-a_1)-2r = (a_2-a_1)-(a_2-a_1) = 0, $
  así que $y>x$, es decir $(x,y) in A$. Luego $B_infinity(a,r) subset.eq A$, y como $d_2$ y $d_infinity$ son equivalentes, también hay una $d_2$-bola contenida en $A$.

  *Clausura: $overline(A) = {(x,y) : y>=x}$.*

  $subset.eq)$ Si $(x_m,y_m) in A$ para todo $m$ y $(x_m,y_m) -> (x,y)$, entonces $x_m -> x$, $y_m -> y$ (acotando cada coordenada por $d_infinity$), y como $y_m>x_m$ para todo $m$, pasando al límite $y >= x$.

  $supset.eq)$ Dado $(x,y)$ con $y=x$ (el caso $y>x$ ya está en $A$), la sucesión $(x,x+1/m) in A$ converge a $(x,x)$.

  *Puntos aislados: ninguno.* Se sigue de que $A' = overline(A)$ (ver abajo): todo punto de $A$ es límite de otros puntos de $A$ distintos de él.

  *Conjunto derivado: $A' = overline(A) = {(x,y):y>=x}$.* Como $A' subset.eq overline(A)$, alcanza ver $overline(A) subset.eq A'$: dado $(x,y)$ con $y>=x$, la sucesión $(x,y+1/m) in A$ (pues $y+1/m>=x+1/m>x$) converge a $(x,y)$ y es distinta de $(x,y)$ para todo $m$.

  *Frontera: $partial A = overline(A) without A^circle = {(x,y):y=x}$* (Ejercicio 9 de la Práctica 3).

  _Nota_: para $A^circle$ también se puede probar que $RR^2 without A = {(x,y):y<=x}$ es cerrado, razonando igual que en el cálculo de $overline(A)$.
]

#ejemplo[Clausura de la unión de rectas por el origen con pendiente entera (Clase 4 · Ejercicio 3)][C4-3][
  En $(RR^2,d_2)$, sea $A = {(x,y) in RR^2 : y=m x " para algún " m in ZZ} = union_(m in ZZ) {(x,y):y=m x}$ (unión infinita de rectas por el origen, todas cerradas). Calcular $overline(A)$.
]

#estrategia[Las rectas se "acumulan" sobre el eje $y$ cuando la pendiente crece][
  Si una sucesión de puntos de $A$ converge con abscisas $x_n$ que no tienden a $0$, la pendiente $m_n=y_n\/x_n$ converge a un número real y, al ser entera, debe ser eventualmente constante --- entonces el límite cae en la misma recta. Pero si $x_n -> 0$, la pendiente puede "escaparse" a $plus.minus infinity$ y el límite es cualquier punto del eje $y$: por eso aparece todo el eje $y$ en la clausura, no sólo el origen.
]

#resolucion[
  Veamos que $overline(A) = A union {(0,y):y != 0}$ (excluyendo $(0,0)$, que ya está en $A$).

  $subset.eq)$ Sea $(x_n,y_n) in A$ con $(x_n,y_n) -> (x,y)$, y $m_n in ZZ$ con $y_n=m_n x_n$.

  Si $x_n -> x != 0$: existe $n_0$ tal que $x_n != 0$ para $n>=n_0$, así que $m_n = y_n\/x_n -> y\/x$ por álgebra de límites; como $(m_n)$ es una sucesión de *enteros* convergente, es eventualmente constante $=m_0$, y entonces $y = lim m_0 x_n = m_0 x$, es decir $(x,y) in A$.

  Si $x_n -> 0$: entonces $(x,y)=(0,y) in A union {(0,y):y!=0}$.

  $supset.eq)$ Dado $(0,y)$ con $y!=0$, la sucesión $(y\/m, y) in A$ (pues $y = m dot (y\/m)$) converge a $(0,y)$.
]

#ejemplo[Caracterización sucesional de la clausura (Clase 17/09)][17/09-4][
  Sea $(X, d)$ un espacio métrico y sea $A subset.eq X$. Probar que
  $ x in overline(A) quad <==> quad "existe una sucesión" (x_n)_(n in NN) subset.eq A "tal que" x_n -> x. $
]

#estrategia[La ida elige un punto de $A$ en cada bola $B(x, 1\/n)$; la vuelta usa un solo término de la sucesión][
  Es la versión "clausura" del Ejemplo C4-5 (caracterización sucesional de los abiertos). Para $=>$, la definición de adherencia da $B(x, 1\/n) inter A != emptyset$ para cada $n$, y elegir un $x_n$ en cada una fabrica la sucesión; $d(x_n, x) < 1\/n$ la hace converger por sándwich. Para $arrow.l.double$ no hace falta toda la sucesión: dado $epsilon > 0$, *un* término $x_(n_0)$ con $d(x_(n_0), x) < epsilon$ ya está en $B(x, epsilon) inter A$.
]

#resolucion[
  $arrow.l.double)$ Supongamos que existe $(x_n)_(n in NN) subset.eq A$ con $x_n -> x$. Por definición de convergencia de una sucesión en un espacio métrico, dado $epsilon > 0$ existe $n_0 in NN$ tal que $d(x_(n_0), x) < epsilon$, o sea $x_(n_0) in B(x, epsilon)$. Como además $x_(n_0) in A$, se tiene $B(x, epsilon) inter A != emptyset$. Como $epsilon > 0$ era arbitrario, $x in overline(A)$.

  $=>)$ Supongamos $x in overline(A)$. Para cada $n in NN$, tomando $epsilon = 1\/n$ obtenemos $B(x, 1\/n) inter A != emptyset$, de modo que podemos elegir
  $ x_n in B(x, 1\/n) inter A. $
  Por construcción $(x_n)_(n in NN) subset.eq A$ y
  $ 0 <= d(x_n, x) < 1/n -->_(n -> infinity) 0, $
  así que, por el criterio del sándwich, $d(x_n, x) -> 0$, es decir $x_n -> x$.
]

#ejemplo[Clausura de ${(1\/n, 1\/m)}$ en $RR^2$ con la métrica suma (Clase 17/09)][17/09-5][
  Sea $(RR^2, d)$ con $d((x_1, y_1), (x_2, y_2)) = abs(x_1 - x_2) + abs(y_1 - y_2)$, y consideremos el conjunto
  $ A = {(1/n, 1/m) : n, m in NN} subset.eq RR^2. $
  Calcular la clausura $overline(A)$.
]

#estrategia[Sólo con el Ejemplo 17/09-4: candidato, sucesiones explícitas para $supset.eq$ y análisis de índices para $subset.eq$][
  Un punto está en la clausura si y sólo si es límite de una sucesión de puntos de $A$. Entonces: se propone el candidato $C = A union {(1\/n, 0)} union {(0, 1\/m)} union {(0, 0)}$, se verifica $C subset.eq overline(A)$ exhibiendo sucesiones explícitas, y $overline(A) subset.eq C$ analizando qué límites puede tener una sucesión genérica $(1\/n_k, 1\/m_k)$ de $A$. La herramienta que lo hace manejable es que en esta métrica *convergencia = convergencia coordenada a coordenada*, y para cada coordenada la sucesión de índices $(n_k)$ o bien no está acotada (y una subsucesión manda la coordenada a $0$) o bien toma finitos valores (y una subsucesión constante la clava en $1\/n$). Comparar con el Ejemplo C4-1, donde el mismo análisis se hace con Bolzano-Weierstrass.
]

#resolucion[
  Llamemos
  $ C = A union {(1/n, 0) : n in NN} union {(0, 1/m) : m in NN} union {(0, 0)}. $

  _Herramienta_: en $(RR^2, d)$ vale
  $ abs(x_k - x) <= d((x_k, y_k), (x, y)) = abs(x_k - x) + abs(y_k - y), \
    abs(y_k - y) <= d((x_k, y_k), (x, y)), $
  de donde $(x_k, y_k) -> (x, y)$ si y sólo si $x_k -> x$ e $y_k -> y$. Es decir: _convergencia en $d$ = convergencia coordenada a coordenada_.

  *Afirmamos que $overline(A) = C$.*

  $(supset.eq)$ Por el Ejemplo 17/09-4, alcanza con exhibir, para cada punto de $C$, una sucesión contenida en $A$ que converja a él.
  - Si $p in A$, tomamos la sucesión constante $x_k = p$. Luego $A subset.eq overline(A)$.
  - Fijado $n in NN$, la sucesión $(1/n, 1/k)_(k in NN) subset.eq A$ cumple $(1/n, 1/k) -> (1/n, 0)$, porque $d((1/n, 1/k), (1/n, 0)) = 0 + 1/k -> 0$.
  - Simétricamente, fijado $m in NN$, la sucesión $(1/k, 1/m)_(k in NN) subset.eq A$ converge a $(0, 1/m)$, ya que la distancia vale $1/k -> 0$.
  - La sucesión diagonal $(1/k, 1/k)_(k in NN) subset.eq A$ converge a $(0, 0)$, pues $d((1/k, 1/k), (0, 0)) = 2/k -> 0$.
  Por lo tanto $C subset.eq overline(A)$.

  $(subset.eq)$ Sea $(x, y) in overline(A)$. Por el Ejemplo 17/09-4 existe una sucesión contenida en $A$ que converge a $(x, y)$; escribámosla como
  $ (1/n_k, 1/m_k) -->_(k -> infinity) (x, y), quad n_k, m_k in NN. $
  Por la herramienta, esto equivale a $1/n_k -> x$ y $1/m_k -> y$. Veamos que necesariamente $x in {0} union {1/n : n in NN}$, distinguiendo dos casos según la sucesión de índices $(n_k)_(k in NN) subset.eq NN$:
  - $(n_k)$ _no está acotada_. Entonces hay una subsucesión $n_(k_j) -> infinity$, luego $1/n_(k_j) -> 0$. Como toda subsucesión de una sucesión convergente converge al mismo límite, $x = 0$.
  - $(n_k)$ _está acotada_. Entonces $(n_k)$ toma finitos valores, así que algún valor $n in NN$ se repite infinitas veces: hay una subsucesión constante $n_(k_j) = n$, es decir $1/n_(k_j) = 1/n$ para todo $j$. Pasando al límite, $x = 1/n$.
  El mismo argumento aplicado a $(m_k)$ da $y in {0} union {1/m : m in NN}$. Combinando ambas coordenadas, las cuatro posibilidades son
  $ (x, y) = (1/n, 1/m) in A, quad (x, y) = (1/n, 0), quad (x, y) = (0, 1/m), quad (x, y) = (0, 0), $
  y en todos los casos $(x, y) in C$. Por lo tanto $overline(A) subset.eq C$.

  En resumen,
  $ overline(A) &= A union {(1/n, 0)}_(n in NN) union {(0, 1/m)}_(m in NN) union {(0, 0)} \
    &= ({0} union {1/n}_(n in NN)) times ({0} union {1/m}_(m in NN)). $
]

#v(10pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Bloque 4 · Caracterizaciones y estabilidad de abiertos y cerrados

#sublema(titulo: "Qué desbloquea")[
  Estos ejemplos no calculan interior o clausura de un conjunto concreto, sino que prueban *hechos generales* sobre cómo se comportan los abiertos y cerrados: bajo la suma de conjuntos $A+B$, mediante sucesiones, y en dos caracterizaciones de "ser abierto" y "ser frontera de un abierto" que no involucran bolas directamente. Son las herramientas que hacen falta cuando el conjunto en cuestión no tiene una fórmula sencilla para su bola, y conviene tenerlas separadas de los ejemplos "de cálculo" de los Bloques 9 y 10.
]

#ejemplo[Estabilidad de abierto/cerrado/denso bajo $A+B$ (Clase 4 · Ejercicio 4 bis)][C4-4b][
  Sean $A,B subset.eq RR^m$ y $A+B = {a+b : a in A, b in B}$.
  #set enum(numbering: "a)")
  + Si $A$ es abierto, $A+B$ es abierto.
  + Si $A$ es cerrado y $B={b}$, $A+B$ es cerrado.
  + Si $A$ es denso ($overline(A)=RR^m$) y $B=B(0,epsilon)$ con $epsilon>0$, $A+B=RR^m$.
]

#estrategia[Trasladar la bola o la sucesión restando el punto fijo de $B$][
  En los tres ítems la maniobra es la misma: "cancelar" el sumando de $B$ para volver al problema en $A$. En (a), la bola de $A$ alrededor de $a$ se traslada para armar la bola de $A+B$ alrededor de $x=a+b$. En (b), a una sucesión convergente en $A+B$ se le resta $b$ para obtener una sucesión convergente en $A$, y se usa que $A$ es cerrado. En (c), la densidad de $A$ da un punto de $A$ a distancia menor que $epsilon$ de cualquier $x$, y esa diferencia es exactamente el elemento de $B(0,epsilon)$ que hace falta.
]

#resolucion[
  *a)* Sea $x=a+b in A+B$. Como $A$ es abierto, existe $r>0$ con $B(a,r) subset.eq A$. Si $y in B(x,r)$, entonces
  $ d(x,y) = norm(a+b-y) = norm(a-(y-b)) < r, $
  así que $y-b in B(a,r) subset.eq A$, y por lo tanto $y=(y-b)+b in A+B$. Luego $B(x,r) subset.eq A+B$.

  *b)* Basta ver $overline(A+B) subset.eq A+B$. Si $x_m=a_m+b -> x$ con $(a_m)_m subset.eq A$, entonces $norm(a_m-(x-b)) = norm(x_m-x) -> 0$, es decir $a_m -> x-b$. Como $A$ es cerrado, $x-b in A$, y $x=(x-b)+b in A+B$.

  *c)* Sea $x in RR^m$. Como $A$ es denso, existe $y in A$ con $norm(x-y)<epsilon$, es decir $x-y in B(0,epsilon)$. Entonces $x=y+(x-y) in A+B$.
]

#ejemplo[Caracterización sucesional de los abiertos (Clase 4 · Ejercicio 5)][C4-5][
  Sea $(E,d)$ un espacio métrico. Probar que $A subset.eq E$ es abierto si y sólo si para toda $(x_n)_n subset.eq A$ con $x_n -> a in A$, existe $n_0 in NN$ tal que $x_n in A$ para todo $n>=n_0$.
]

#estrategia[La vuelta es la contrarrecíproca: "no abierto" da una sucesión que se cuela desde afuera][
  La ida es directa: la bola alrededor de $a$ que atestigua que $A$ es abierto contiene la cola de la sucesión. La vuelta conviene probarla por el contrarrecíproco: si $A$ no es abierto, hay un punto $a in A$ tal que *ninguna* bola $B(a,1\/n)$ está contenida en $A$, así que se puede elegir $x_n in B(a,1\/n) without A$ para cada $n$; esta sucesión converge a $a$ pero *ningún* término está en $A$, violando la propiedad.
]

#resolucion[
  $=>)$ Sea $(x_n)_n subset.eq A$ con $x_n -> a in A$. Como $A$ es abierto, existe $r>0$ con $B(a,r) subset.eq A$. Tomando $epsilon=r$ en la definición de límite, existe $n_0$ tal que $d(x_n,a)<r$ para $n>=n_0$, es decir $x_n in B(a,r) subset.eq A$.

  $arrow.l.double)$ Supongamos que $A$ no es abierto: existe $a in A$ tal que para todo $r>0$, $B(a,r) subset.eq.not A$. Entonces, para cada $n in NN$, existe $x_n in B(a,1\/n) without A$, y $d(x_n,a)<1\/n -> 0$, así que $x_n -> a$. Pero $x_n in.not A$ para *todo* $n$, así que no existe ningún $n_0$ con $x_n in A$ para $n>=n_0$: contradice la hipótesis.
]

#ejemplo[$U$ abierto si y sólo si $U inter overline(T) subset.eq overline(U inter T)$ para todo $T$ (Clase 4 · Ejercicio 6)][C4-6][
  Sea $(E,d)$ un espacio métrico y $U subset.eq E$. Probar que $U$ es abierto si y sólo si para todo $T subset.eq E$, $U inter overline(T) subset.eq overline(U inter T)$.
]

#estrategia[La vuelta sale de particularizar $T = E without U$][
  La ida usa que $V inter U$ es abierto siempre que $V$ lo sea, para trasladar un entorno de un punto de $overline(T)$ a un entorno dentro de $U$. La vuelta es la parte más económica: alcanza con aplicar la hipótesis a $T=E without U$, donde el lado derecho se anula, y de ahí se deduce directamente que $E without U$ es cerrado.
]

#resolucion[
  $=>)$ Sea $T subset.eq E$ y $x in U inter overline(T)$. Veamos $x in overline(U inter T)$: sea $V$ abierto con $x in V$. Como $x in U$, $x in V inter U$, que es abierto; como $x in overline(T)$, $(V inter U) inter T != emptyset$, que es lo que había que ver.

  $arrow.l.double)$ Tomemos $T=E without U$. La hipótesis da $U inter overline(E without U) subset.eq overline(U inter (E without U)) = overline(emptyset) = emptyset$, es decir $overline(E without U) inter U = emptyset$. Entonces
  $ overline(E without U) = (overline(E without U) inter U) union (overline(E without U) inter (E without U)) = overline(E without U) inter (E without U) subset.eq E without U, $
  así que $E without U$ es cerrado (la otra inclusión vale siempre), es decir $U$ es abierto.
]

#ejemplo[$F$ es frontera de un abierto si y sólo si es cerrado con interior vacío (Clase 4 · Ejercicio 7)][C4-7][
  Sea $(E,d)$ un espacio métrico. Probar que $F subset.eq E$ es la frontera de un abierto si y sólo si $F$ es cerrado y $F^circle=emptyset$.
]

#estrategia[La vuelta se construye tomando $U = E without F$][
  La ida usa que $partial U = overline(U) inter overline(E without U)$ (Ejercicio 9 de la Práctica 3) es intersección de cerrados, y que ningún punto de $U$ puede estar en $partial U$ (tiene una bola adentro de $U$) para descartar puntos interiores de $F$. La vuelta es constructiva: el candidato natural a abierto es el complemento de $F$, y hay que verificar que su frontera es exactamente $F$, usando que $F$ es cerrado con interior vacío en cada paso.
]

#resolucion[
  $=>)$ Si $F=partial U$ con $U$ abierto, $F=overline(U) inter overline(E without U)$ es intersección de cerrados, luego cerrado. Si $x in U$, hay $r>0$ con $B(x,r) subset.eq U$, así que $B(x,r) inter (E without U) = emptyset$ y $x in.not F$. Para ver $F^circle=emptyset$: sea $x in F$; dado $r>0$, $B(x,r) inter U != emptyset$, y como $x in.not U$, hay $y!=x$ con $y in B(x,r) inter U$; pero $y in U$ implica $y in.not F$, así que ninguna bola alrededor de $x$ queda contenida en $F$.

  $arrow.l.double)$ Sea $U=E without F$; veamos $partial U = F$. Por un lado,
  $ partial U = overline(U) inter overline(E without U) = overline(E without F) inter overline(F) = overline(E without F) inter F subset.eq F $
  (usando $overline(F)=F$). Por otro, si $x in F$, como $F^circle=emptyset$, para todo $r>0$ vale $B(x,r) inter (E without F) != emptyset$, es decir $x in overline(E without F)$; junto con $x in F subset.eq overline(F)$, se sigue $x in partial U$.
]

#ejemplo[Métricas equivalentes vía sucesiones (Clase 4 · Ejercicio 8)][C4-8][
  Sea $E != emptyset$. Probar que dos métricas $d,d'$ en $E$ son equivalentes (dan los mismos abiertos) si y sólo si toda sucesión converge para $d$ exactamente cuando converge para $d'$ (al mismo límite).
]

#estrategia[Traducir una bola de una métrica a un radio suficientemente chico en la otra][
  Usamos la caracterización de equivalencia por bolas: para todo $x$ y todo $r>0$ existen $r',r''>0$ con $B_d(x,r') subset.eq B_(d')(x,r)$ y $B_(d')(x,r'') subset.eq B_d(x,r)$. Con eso, convertir "converge para $d$" en "converge para $d'$" es sólo enhebrar la definición de límite a través de esa bola intermedia.
]

#resolucion[
  Supongamos $x_n -> x$ respecto de $d$. Dado $epsilon>0$, por equivalencia existe $r'>0$ con $B_d(x,r') subset.eq B_(d')(x,epsilon)$. Como $x_n -> x$ para $d$, existe $tilde(n) in NN$ tal que $d(x_n,x)<r'$ para $n>=tilde(n)$, es decir $(x_n)_(n>=tilde(n)) subset.eq B_d(x,r') subset.eq B_(d')(x,epsilon)$. Tomando $n_0>=tilde(n)$, $d'(x_n,x)<epsilon$ para todo $n>=n_0$, es decir $x_n -> x$ respecto de $d'$.

  El argumento recíproco (que la convergencia para $d'$ implica la convergencia para $d$) es análogo, intercambiando los roles de $d$ y $d'$.
]

#v(10pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Bloque 5 · Sucesiones en espacios métricos

#sublema(titulo: "Qué desbloquea")[
  La definición de convergencia en un espacio métrico (Definición 4.42) es la de $RR$ con $abs(x_n - x)$ cambiado por $d(x_n, x)$. Lo que cambia de un espacio a otro es *qué significa* $d(x_n, x) < epsilon$ en concreto. Estos ejemplos lo traducen en dos métricas conocidas: en la discreta, convergencia quiere decir eventualmente constante; con $d_oo$, quiere decir convergencia uniforme. El Ejemplo 31 hace lo mismo con la Definición 4.51 (sucesión de Cauchy) y muestra que ser de Cauchy no alcanza para converger: el límite puede no estar en el espacio ($(0,1]$, $(C([0,1]), d_1)$). Es el punto de partida del *Ejercicio 13* de la Práctica 3.
]

#ejemplo[Sucesiones convergentes en la métrica discreta y en $(C([a,b]), d_oo)$ (Ejemplo 4.45)][30][
  #set enum(numbering: "a)")
  + Consideremos $(M, delta)$, con $delta$ la métrica discreta. ¿Cómo son las sucesiones convergentes en este espacio?
  + Consideremos $(C([a,b]), d_oo)$. ¿Qué significa que $f_n -> f$ en este espacio?
]

#resolucion[
  #set enum(numbering: "a)")
  + Supongamos que $x_n -> x$. Por definición, tenemos que para todo $epsilon > 0$, debería ser que $delta(x_n, x) < epsilon$ para todo $n$ a partir de cierto $n_0$. Pero si $0 < epsilon < 1$, $delta(x_n, x) < epsilon$ si y sólo si $delta(x_n, x) = 0$ (puesto que $delta$ toma sólo dos valores, $0$ y $1$). Pero $delta(x_n, x) = 0$ sólo cuando $x_n = x$.

    Es decir, que las únicas sucesiones convergentes en $(M, delta)$ son aquéllas que a partir de cierto punto valen siempre lo mismo (es decir, las *eventualmente constantes*).

  + Recordemos que $d_oo (f_n, f) = sup_(x in [a,b]) abs(f_n (x) - f(x))$. Tenemos que $f_n -> f$ en este espacio si para todo $epsilon > 0$ existe un $n_0 in NN$ tal que si $n >= n_0$ se tiene que
    $ abs(f_n (x) - f(x)) < epsilon quad bold("para todo") x in [a, b]. $

    #block(breakable: false, width: 100%)[#align(center)[
      #cetz.canvas({
        import cetz.draw: *

        line((-0.5, 0), (5.3, 0), mark: (end: ">"), stroke: 0.6pt)
        line((0, -0.5), (0, 4.4), mark: (end: ">"), stroke: 0.6pt)
        content((5.55, 0), text(size: 10pt)[$x$])
        content((0, 4.65), text(size: 10pt)[$y$])

        let f(t) = 2.0 + 0.3 * calc.sin(t * 1.9 + 0.3) + 0.12 * t
        let fn(t) = f(t) + 0.35 * calc.sin(1.9 * (t - 1) - 1.2)
        let eps = 0.75
        let xs = range(0, 41).map(i => 1 + i * 3.5 / 40)

        let upper = xs.map(t => (t, f(t) + eps))
        let lower = xs.map(t => (t, f(t) - eps)).rev()
        line(..upper, ..lower, close: true, fill: rgb("#e0e7ff"), stroke: none)
        line(..upper, stroke: (dash: "dashed", paint: gray, thickness: 0.7pt))
        line(..lower, stroke: (dash: "dashed", paint: gray, thickness: 0.7pt))

        line(..xs.map(t => (t, f(t))), stroke: (paint: blue, thickness: 2pt))
        line(..xs.map(t => (t, fn(t))), stroke: (paint: red, thickness: 1pt))

        content((4.95, f(4.5) + eps), text(size: 9pt)[$f + epsilon$])
        content((4.8, f(4.5) + 0.05), text(size: 9pt, fill: blue)[$f$])
        content((4.8, fn(4.5) - 0.05), text(size: 9pt, fill: red)[$f_n$])
        content((4.95, f(4.5) - eps), text(size: 9pt)[$f - epsilon$])

        for pair in ((1, $a$), (4.5, $b$)) {
          line((pair.at(0), -0.08), (pair.at(0), 0.08), stroke: 0.8pt)
          content((pair.at(0), -0.35), text(size: 10pt)[#pair.at(1)])
        }
      })
    ]]

    Esto es lo que vamos a llamar *convergencia uniforme* de las funciones $f_n$ y es una de las nociones de convergencia en espacio de funciones que vamos a explorar más adelante.
]

#ejemplo[Sucesiones de Cauchy que no convergen (Ejemplo 4.52)][31][
  #set enum(numbering: "a)")
  + Sea $(x_n)_(n in NN) = (1/n) subset.eq (RR, abs(dot))$. Probar que $(x_n)_(n in NN)$ es de Cauchy.

  + Sea $(x_n)_(n in NN) = (1/n) subset.eq ((0, 1], abs(dot))$. ¿Es de Cauchy? ¿Converge en este espacio métrico?

  + Sea $(M, delta)$ un espacio métrico con la métrica discreta. ¿Cómo son las sucesiones de Cauchy en este espacio?

  + Consideremos en $(C([0, 1]), d_1)$ la sucesión de funciones $f_n$ definidas de la siguiente forma:
    $
      f_n (x) = cases(
        0\, & "si " 0 <= x <= 1/2 - 1/n\,,
        "segmento que une los puntos " (1/2 - 1/n, 0) " y " (1/2, 1)\, & "si " 1/2 - 1/n <= x <= 1/2\,,
        1\, & "si " 1/2 <= x <= 1.
      )
    $
    Para que esta sucesión tenga sentido la definimos con $n >= 3$ (para completar la sucesión, podemos tomar los primeros dos términos de la sucesión como $f_1 = f_2 = 0$).

    #block(breakable: false, width: 100%)[#align(center)[
      #cetz.canvas({
        import cetz.draw: *
        let (sx, sy) = (6, 3)
        let p(x, y) = (x * sx, y * sy)

        line(p(-0.08, 0), p(1.15, 0), mark: (end: ">"), stroke: 0.6pt)
        line(p(0, -0.1), p(0, 1.2), mark: (end: ">"), stroke: 0.6pt)
        content(p(1.19, 0), $x$)
        content(p(0, 1.27), $y$)
        content(p(-0.06, -0.07), $0$)
        content(p(-0.06, 1), $1$)
        content(p(0.5, -0.1), $1/2$)
        content(p(1, -0.08), $1$)
        line(p(0, 1), p(0.5, 1), stroke: (paint: gray, dash: "dashed", thickness: 0.5pt))
        line(p(0.5, 0), p(0.5, 1), stroke: (paint: gray, dash: "dashed", thickness: 0.5pt))

        for (n, col) in ((4, blue), (10, red), (25, rgb("#15803d"))) {
          let a = 0.5 - 1 / n
          line(p(0, 0), p(a, 0), p(0.5, 1), p(1, 1), stroke: 1pt + col)
        }
        content(p(0.28, 0.3), text(fill: blue)[$f_4$])
        content(p(0.56, 0.45), text(fill: red)[$f_(10)$])
        content(p(0.56, 0.72), text(fill: rgb("#15803d"))[$f_(25)$])
        line(p(0.2, 0.1), p(0.4, 0.1), mark: (end: ">"), stroke: 0.6pt)
        content(p(0.3, 0.15), text(size: 8pt)[$n -> oo$])
        circle(p(0.5, 1), radius: 0.06, fill: black)
        content(p(0.5, -0.24), text(size: 9pt)[Sucesión $(f_n)$ en $(C([0, 1]), d_1)$])
      })
    ]]

    ¿Es $(f_n)$ de Cauchy? ¿Converge en $(C([0, 1]), d_1)$?
]

#resolucion[
  #set enum(numbering: "a)")
  + Sea $epsilon > 0$. Queremos encontrar un $n_0$ tal que si $n, m >= n_0$ se tiene que $abs(1/n - 1/m) < epsilon$. Si $n, m >= n_0$ tenemos
    $ abs(1/n - 1/m) <= 1/n + 1/m <= 1/n_0 + 1/n_0 = 2/n_0 < epsilon $
    si elegimos $n_0 > 2/epsilon$.

    Más adelante vamos a ver que toda sucesión convergente es de Cauchy, con lo cual vamos a poder decir que esta sucesión es de Cauchy porque converge en $RR$. Sin embargo, notemos que la definición de sucesión de Cauchy no depende de la existencia del $0$ en este espacio métrico.

  + Por la cuenta que hicimos en (a), vemos que esta sucesión sigue siendo de Cauchy. Sin embargo, esta sucesión no converge en el espacio métrico que estamos considerando: $0 in.not (0, 1]$.

  + Supongamos que $(x_n)_(n in NN)$ es de Cauchy. Entonces para $0 < epsilon < 1$, deberíamos tener un $n_0$ tal que $delta(x_n, x_m) < epsilon$ para todo $n, m >= n_0$. Pero como la métrica sólo toma los valores $0$ y $1$, vemos que tiene que ser $delta(x_n, x_m) = 0$. Es decir, que las sucesiones de Cauchy son las eventualmente constantes. Observemos que, por el Ejemplo 4.45, tenemos que en este espacio las sucesiones de Cauchy y las convergentes sí son las mismas.

  + Veamos que esta sucesión es de Cauchy. Para esto, tenemos que entender cómo son las distancias entre dos términos de la sucesión. Sean $f_n$ y $f_m$ dos elementos de la sucesión, y supongamos que $m > n$. Recordemos que la distancia 1 entre funciones representa el área atrapada entre las dos funciones. Gráficamente tendremos algo así:

    #block(breakable: false, width: 100%)[#align(center)[
      #cetz.canvas({
        import cetz.draw: *
        let (sx, sy) = (6, 3)
        let p(x, y) = (x * sx, y * sy)
        let (an, am) = (0.5 - 1 / 4, 0.5 - 1 / 10)

        line(p(an, 0), p(0.5, 1), p(am, 0), close: true, fill: rgb("#fde6cf"), stroke: none)
        line(p(-0.08, 0), p(1.15, 0), mark: (end: ">"), stroke: 0.6pt)
        line(p(0, -0.1), p(0, 1.2), mark: (end: ">"), stroke: 0.6pt)
        content(p(1.19, 0), $x$)
        content(p(0, 1.27), $y$)
        content(p(-0.06, -0.07), $0$)
        content(p(-0.06, 1), $1$)
        line(p(0, 1), p(0.5, 1), stroke: (paint: gray, dash: "dashed", thickness: 0.5pt))
        line(p(0.5, 0), p(0.5, 1), stroke: (paint: gray, dash: "dashed", thickness: 0.5pt))

        line(p(0, 0), p(an, 0), p(0.5, 1), p(1, 1), stroke: 1pt + blue)
        line(p(0, 0), p(am, 0), p(0.5, 1), p(1, 1), stroke: 1pt + red)
        content(p(0.2, 0.5), text(fill: blue)[$f_n$])
        content(p(0.56, 0.62), text(fill: red)[$f_m$])
        content(p(an, -0.1), text(size: 8pt)[$1/2 - 1/n$])
        content(p(am + 0.01, -0.22), text(size: 8pt)[$1/2 - 1/m$])
        content(p(0.52, -0.1), text(size: 8pt)[$1/2$])
        line(p(0.62, 0.42), p(0.4, 0.3), mark: (end: ">"), stroke: 0.5pt)
        content(p(0.62, 0.42), anchor: "west", text(size: 8.5pt)[Distancia $d_1 (f_n, f_m)$])
      })
    ]]

    El cálculo de esta área no es tan difícil de realizar dado que lo que tenemos es un triángulo de base $(1/2 - 1/m) - (1/2 - 1/n) = 1/n - 1/m$ y altura $1$, entonces el área es $A = 1/2 (1/n - 1/m) dot 1$. Como vimos antes, si $n_0$ es lo suficientemente grande, podemos lograr que dado $epsilon > 0$,
    $ d_1 (f_n, f_m) <= 1/2 abs(1/n - 1/m) < epsilon, quad "para todo " n, m >= n_0. $

    Sin embargo, esta sucesión tampoco converge en el espacio métrico que estamos considerando. El límite de esta sucesión es la función
    $
      f(x) = cases(
        0\, & "si " 0 <= x <= 1/2\,,
        1\, & "si " 1/2 < x <= 1\,,
      )
    $
    que no es una función continua.

    Probemos que efectivamente las funciones $f_n$ convergen a $f$ en la distancia 1. Para esto, analicemos cómo es la distancia de $f_n$ a $f$.

    #block(breakable: false, width: 100%)[#align(center)[
      #cetz.canvas({
        import cetz.draw: *
        let (sx, sy) = (6, 3)
        let p(x, y) = (x * sx, y * sy)
        let an = 0.5 - 1 / 4

        line(p(an, 0), p(0.5, 1), p(0.5, 0), close: true, fill: rgb("#ccfbd1"), stroke: none)
        line(p(-0.08, 0), p(1.15, 0), mark: (end: ">"), stroke: 0.6pt)
        line(p(0, -0.1), p(0, 1.2), mark: (end: ">"), stroke: 0.6pt)
        content(p(1.19, 0), $x$)
        content(p(0, 1.27), $y$)
        content(p(-0.06, -0.07), $0$)
        content(p(-0.06, 1), $1$)
        line(p(0, 1), p(0.5, 1), stroke: (paint: gray, dash: "dashed", thickness: 0.5pt))
        line(p(0.5, 0), p(0.5, 1), stroke: (paint: gray, dash: "dashed", thickness: 0.5pt))

        line(p(0, 0), p(0.5, 0), stroke: 2pt + black)
        line(p(0.5, 1), p(1, 1), stroke: 2pt + black)
        line(p(an, 0), p(0.5, 1), stroke: 1pt + blue)
        circle(p(0.5, 0), radius: 0.06, fill: black)
        circle(p(0.5, 1), radius: 0.06, fill: white, stroke: 0.8pt)
        content(p(0.28, 0.55), text(fill: blue)[$f_n$])
        content(p(0.95, 0.88), $f$)
        content(p(an, -0.1), text(size: 8pt)[$1/2 - 1/n$])
        content(p(0.5, -0.1), text(size: 8pt)[$1/2$])
        line(p(0.62, 0.42), p(0.44, 0.3), mark: (end: ">"), stroke: 0.5pt)
        content(p(0.62, 0.42), anchor: "west", text(size: 8.5pt)[Distancia $d_1 (f_n, f)$])
      })
    ]]

    Como vimos antes, la distancia $d_1 (f_n, f)$ la podemos calcular como el área del triángulo que se forma entre los gráficos de estas dos funciones. Dado $epsilon > 0$, podemos encontrar un $n_0$ tal que
    $ d_1 (f_n, f) = 1/2 dot 1/n < epsilon, quad "para todo " n >= n_0. $
]

#ejemplo[Espacios completos y no completos (Ejemplo 4.56)][32][
  #set enum(numbering: "a)")
  + $(QQ, abs(dot))$ no es completo. Por ejemplo, podríamos tomar $x_n = 3","14159 dots$ los primeros $n$ dígitos del número $pi$. Tenemos que $(x_n) subset.eq QQ$, y $x_n -> pi$. Como la sucesión es convergente en $RR$, sabemos que debe ser de Cauchy (Teorema 4.54 b). Sin embargo, su límite no pertenece a $QQ$, lo cual nos dice que $QQ$ no puede ser completo.

  + Sea $(M, delta)$ un conjunto con la métrica discreta. Como vimos en los ejemplos anteriores (Ejemplos 30 y 31), las sucesiones de Cauchy son las eventualmente constantes y estas son convergentes. Esto nos dice que el espacio sí es completo.
]

#v(10pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Bloque 6 · Completitud: probarla, heredarla y caracterizarla

#sublema(titulo: "Qué desbloquea")[
  Un espacio es completo (Definición 4.55) si toda sucesión de Cauchy converge *adentro* del espacio. Los seis ejemplos de la clase del 01/10 cubren las tres maniobras que piden los *Ejercicios 14, 15 y 16* de la Práctica 3: (i) probar completitud "a mano", coordenada a coordenada, controlando que el límite candidato quede en el espacio y que la convergencia sea en la métrica del espacio y no sólo coordenada a coordenada (C5-1, que es el Corolario 4.58 con infinitas coordenadas); (ii) heredar la completitud a un subconjunto cerrado y usarla para decidir si conjuntos concretos son completos (C5-2, C5-6); (iii) caracterizarla sin bolas, por sucesiones, en una métrica rara (C5-3) o a través del encaje de cerrados, que es el recíproco del Ejercicio 16 (C5-5). C5-4 es una aplicación de $d(x, F)$ (Ejercicio 10) que se usa de paso.

  El Ejemplo 29/09-2, al final del bloque, va acá y no en el Bloque 5 porque, aunque sus ítems (i)--(ii) son de métricas y de sucesiones, la técnica que carga es la de (iii)--(iv): transportar la condición de Cauchy de una métrica a otra que la domina ($D >= d$) para pedirle prestado el límite a $RR$, y después verificar que ese límite queda *dentro* del espacio. Es el esqueleto del Ejercicio 14 (completitud de $(RR^n, d_1)$, $(RR^n, d_2)$ y $(RR^n, d_oo)$ a través de las desigualdades del Ejercicio 12) y, frente al Ejercicio 15, muestra que dos métricas con las mismas sucesiones convergentes pueden diferir en completitud.
]

#ejemplo[Las sucesiones acotadas con $d_oo$ forman un espacio completo (Clase 5 · Ejercicio 1)][C5-1][
  Probar que $X = {a in RR^NN : a "es acotada"}$ es completo con $d_oo (a, b) = sup_(k in NN) abs(a_k - b_k)$.
]

#estrategia[Límite coordenada a coordenada, y después dos cosas más: que es acotado y que la convergencia es uniforme en $k$][
  Una sucesión $(a_n)_n subset.eq X$ es una "matriz infinita" $a_n = (a_(n 1), a_(n 2), dots)$. Que sea de Cauchy para $d_oo$ obliga a cada columna $(a_(n k))_n$ a ser de Cauchy en $RR$, así que tiene límite $tilde(a)_k$. El candidato es $tilde(a) = (tilde(a)_k)_k$, y quedan dos cosas: que $tilde(a)$ es acotada (porque una Cauchy está dentro de una bola, y esa cota se hereda al límite) y que $d_oo (a_n, tilde(a)) -> 0$. Lo segundo es el punto delicado: la convergencia de cada columna da un $n$ "grande" que depende de $k$, y hay infinitas columnas. Se esquiva con la condición de Cauchy: se fija un $n_0$ *uniforme* y se pasa al límite en $m$ dentro de $abs(a_(n_0 k) - a_(m k)) < epsilon'$.
]

#resolucion[
  Sea $(a_n)_n subset.eq X$ de Cauchy: para todo $epsilon > 0$ existe $n_0$ tal que $d_oo (a_n, a_m) < epsilon$ si $n, m >= n_0$. Entonces, para cada $i$ y $n, m >= n_0$,
  $ abs(a_(n i) - a_(m i)) <= sup_(k in NN) abs(a_(n k) - a_(m k)) = d_oo (a_n, a_m) < epsilon, quad (*) $
  así que $(a_(n i))_n$ es de Cauchy en $RR$ y, como $RR$ es completo, existe $tilde(a)_i = lim_n a_(n i)$. Sea $tilde(a) = (tilde(a)_k)_k$.

  *$tilde(a) in X$.* Primero, una Cauchy está en una bola: existe $n_0$ con $d(a_n, a_m) < 1$ para $n, m >= n_0$, y entonces $d(a_1, a_n) <= d(a_1, a_(n_0)) + d(a_(n_0), a_n) < d(a_1, a_(n_0)) + 1$ para $n >= n_0$; agrandando con los finitos $n < n_0$, hay $M > 0$ con $(a_n)_n subset.eq B(a_1, M)$. Entonces, para todo $n$ y $k$,
  $ abs(a_(n k)) <= abs(a_(n k) - a_(1 k)) + abs(a_(1 k)) <= M + sup_(k in NN) abs(a_(1 k)) =: tilde(M), $
  donde el último supremo es finito porque $a_1 in X$. Como $a_(n k) -> tilde(a)_k$, por álgebra de límites $abs(tilde(a)_k) <= tilde(M)$ para todo $k$: $tilde(a)$ es acotada.

  *$a_n -> tilde(a)$ en $d_oo$.* Dado $epsilon' > 0$, sea $n_0$ el de $(*)$. Para $n >= n_0$,
  $ d_oo (a_n, tilde(a)) <= underbrace(d_oo (a_n, a_(n_0)), (1)) + underbrace(d_oo (a_(n_0), tilde(a)), (2)). $
  $(1) < epsilon'$ por $(*)$. Para $(2)$: por $(*)$, $abs(a_(n_0 k) - a_(m k)) < epsilon'$ para todo $k$ y todo $m >= n_0$; haciendo $m -> +oo$ con $k$ fijo, $abs(a_(n_0 k) - tilde(a)_k) <= epsilon'$ para todo $k$, y tomando supremo en $k$, $(2) <= epsilon'$. Luego $d_oo (a_n, tilde(a)) < 2 epsilon'$ para todo $n >= n_0$; con $epsilon' = epsilon \/ 2$ queda $d_oo (a_n, tilde(a)) < epsilon$.
]

#ejemplo[Completo si y sólo si cerrado, y dos conjuntos de $RR^2$ (Clase 5 · Ejercicio 2)][C5-2][
  Sea $(E, d)$ un espacio métrico completo.
  #set enum(numbering: "a)")
  + Probar que $A subset.eq E$ es completo si y sólo si $A$ es cerrado.
  + En $E = (RR^2, d_2)$, decidir si $A = {(x, y) : exists n in NN "con" y = x^n}$ y $B = {(x, y) : x^2 + y^2 = 1}$ son completos.
]

#estrategia[Un punto de la clausura es límite de una sucesión de $A$, que es de Cauchy; y para los ejemplos, mirar sólo si son cerrados][
  La vuelta de (a) es el Ejercicio 15 de la Práctica 3. Para la ida, si $a in overline(A)$ hay $(a_n)_n subset.eq A$ con $a_n -> a$; convergente implica Cauchy, y la completitud de $A$ obliga al límite a estar en $A$. Con (a), en un espacio completo "completo" es lo mismo que "cerrado": para $A$ basta exhibir un punto de $overline(A) without A$ (la sucesión $(1\/2, 1\/2^n)$ se cae al eje $x$), y para $B$ basta pasar al límite en la ecuación $x_n^2 + y_n^2 = 1$.
]

#resolucion[
  *a)* $arrow.l.double)$ Ejercicio 15 de la Práctica 3. $=>)$ Sea $a in overline(A)$ y $(a_n)_n subset.eq A$ con $a_n -> a$. Entonces $(a_n)_n$ es de Cauchy en $E$, y por lo tanto también en $A$ (la distancia es la misma). Como $A$ es completo, converge en $A$; por unicidad del límite, $a in A$. Luego $overline(A) = A$.

  *b)* $A$ es la unión de los gráficos de $y = x^n$, $n in NN$, que pasan todos por $(0,0)$ y $(1,1)$ y en $(0,1)$ se aplastan contra el eje $x$. Tomemos $(x_n, y_n) = (1\/2, 1\/2^n) in A$: converge a $(1\/2, 0) in overline(A)$, pero $(1\/2, 0) in.not A$ porque $0 != (1\/2)^n$ para todo $n$. Así que $A$ no es cerrado y, por (a), *no es completo*.

  Para $B$, veamos $overline(B) subset.eq B$: si $(x_n, y_n) in B$ y $(x_n, y_n) -> (x, y)$, entonces $x_n -> x$, $y_n -> y$ y, por álgebra de límites, $x^2 + y^2 = lim (x_n^2 + y_n^2) = 1$, es decir $(x, y) in B$. Luego $B$ es cerrado y, como $(RR^2, d_2)$ es completo, *$B$ es completo*.
]

#ejemplo[La métrica $d(x, y) = abs(x) + abs(y)$ para $x != y$: es métrica, es completa, no es equivalente a la usual (Clase 5 · Ejercicio 3)][C5-3][
  Sea $d : RR times RR -> RR$ dada por $d(x, y) = 0$ si $x = y$ y $d(x, y) = abs(x) + abs(y)$ si $x != y$.
  #set enum(numbering: "a)")
  + Probar que $d$ es una métrica en $RR$.
  + Probar que $(RR, d)$ es completo.
  + ¿Es $d$ equivalente a la métrica usual de $RR$?
]

#estrategia[En esta métrica, dos puntos distintos "pasan por el $0$"; una Cauchy o se va a $0$ o se vuelve constante][
  Para la triangular sólo hay que repasar los casos según qué puntos coinciden: cuando los tres son distintos queda $abs(x) + abs(y) <= abs(x) + 2 abs(z) + abs(y)$. Para la completitud, la clave es que $d(a_n, a_m) < epsilon$ con $a_n != a_m$ fuerza $abs(a_n) < epsilon$: si la sucesión toma infinitos valores, una subsucesión de términos distintos tiende a $0$ y arrastra a toda la Cauchy; si toma finitos valores, alguno se repite infinitas veces y la Cauchy se vuelve eventualmente constante. Para (c), lejos del $0$ los puntos están aislados: $B(1, 1) = {1}$.
]

#resolucion[
  *a)* $d >= 0$, y $d(x, y) = 0$ si y sólo si $x = y$ (pues $abs(x) + abs(y) = 0$ sólo si $x = y = 0$); la simetría es evidente. Triangular: sean $x, y, z$. Si $x = y$ es $0 <= d(x, z) + d(z, y)$. Si $x != y$ y $z = x$ (o $z = y$) es $d(x, y) <= 0 + d(x, y)$. Si son distintos dos a dos, $d(x, y) = abs(x) + abs(y) <= abs(x) + abs(z) + abs(z) + abs(y) = d(x, z) + d(z, y)$.

  *b)* Sea $(a_n)_n$ de Cauchy: dado $epsilon > 0$ hay $n_0$ con $d(a_n, a_m) < epsilon$ para $n, m >= n_0$; en particular, si además $a_n != a_m$, $abs(a_n) + abs(a_m) < epsilon$.
  - Si ${a_n : n in NN}$ es infinito, hay una subsucesión $(a_(n_k))_k$ de términos distintos dos a dos, que sigue siendo de Cauchy; para $k, k' >= k_0$ vale $abs(a_(n_k)) + abs(a_(n_(k'))) < epsilon$, luego $abs(a_(n_k)) < epsilon$ para $k >= k_0$, es decir $a_(n_k) -> 0$ (en $d$, pues $d(a_(n_k), 0) = abs(a_(n_k))$). Una Cauchy con una subsucesión convergente converge (Teorema 4.54 c): $a_n -> 0$.
  - Si ${a_n : n in NN}$ es finito, digamos ${a_(n_1), dots, a_(n_k)}$, entonces $NN = union.big_(i=1)^k {n : a_n = a_(n_i)}$, y alguno de esos conjuntos es infinito: hay una subsucesión constante igual a $a_(n_i)$, que converge, y de nuevo por el Teorema 4.54 c, $a_n -> a_(n_i)$.
  En cualquier caso $(a_n)_n$ converge: $(RR, d)$ es completo.

  *c)* No. Por (b), las únicas sucesiones convergentes tienden a $0$ o son eventualmente constantes, así que lejos del $0$ el espacio es "discreto": si $x != 1$, $d(x, 1) = abs(x) + 1 > 1$, luego $B_d (1, 1) = {1}$ es abierto en $(RR, d)$ pero no en $(RR, abs(dot.c))$. Las métricas no definen los mismos abiertos.
]

#ejemplo[Un cerrado es intersección numerable de los abiertos ${d(x, F) < 1\/n}$ (Clase 5 · Ejercicio 4)][C5-4][
  Sea $(E, d)$ un espacio métrico y $F subset.eq E$ cerrado. Probar que
  $ F = inter.big_(n in NN) {x in E : d(x, F) < 1/n}. $
]

#estrategia[La inclusión difícil fabrica una sucesión de $F$ que converge a $x$][
  Si $x in F$, $d(x, F) = 0$ y está en todos los conjuntos. Recíprocamente, $d(x, F) < 1\/n$ para todo $n$ da, por definición de ínfimo, puntos $y_n in F$ con $d(x, y_n) < 1\/n$; entonces $y_n -> x$ y, como $F$ es cerrado, $x in F$ (Corolario 4.47). Cada ${d(x, F) < 1\/n}$ es abierto por el Ejercicio 10 (d).
]

#resolucion[
  $subset.eq)$ Si $x in F$, $d(x, F) = inf{d(x, y) : y in F} = 0$ porque $d(x, x) = 0$, así que $x$ está en todos los conjuntos.

  $supset.eq)$ Sea $x$ con $d(x, F) < 1\/n$ para todo $n$. Como $d(x, F)$ es un ínfimo, para cada $n$ existe $y_n in F$ con $d(x, y_n) < 1\/n$. Entonces $y_n -> x$, y como $(y_n)_n subset.eq F$ y $F$ es cerrado, $x in F$.
]

#ejemplo[Si todo encaje de cerrados acotados con diámetro $-> 0$ tiene intersección no vacía, el espacio es completo (Clase 5 · Ejercicio 5)][C5-5][
  Sea $(E, d)$ un espacio métrico tal que para *toda* sucesión $(A_n)_n$ de subconjuntos cerrados, acotados y no vacíos con $A_(n+1) subset.eq A_n$ y $lim_n op("diam")(A_n) = 0$ se tiene $inter.big_n A_n != emptyset$. Probar que $E$ es completo.
]

#estrategia[Encajar las clausuras de las colas de la sucesión de Cauchy][
  Es el recíproco del Ejercicio 16. Dada una Cauchy $(a_n)_n$, la condición de Cauchy con $epsilon = 1\/k$ da índices $n_1 <= n_2 <= dots$ tales que la cola ${a_n : n >= n_k}$ tiene diámetro $<= 1\/k$. Sus clausuras $A_k$ son cerradas, no vacías, encajadas, y conservan el diámetro (Ejercicio 7 de la Práctica 3), así que la hipótesis da un $a in inter A_k$. Que $a_n -> a$ sale por el absurdo: una subsucesión que se mantenga a distancia $>= epsilon$ de $a$ no cabe en un $A_k$ de diámetro $< epsilon \/ 2$ que contiene a $a$.
]

#resolucion[
  Sea $(a_n)_n$ de Cauchy. Elegimos inductivamente $n_1 <= n_2 <= dots$ con $d(a_n, a_m) < 1\/k$ para $n, m >= n_k$, y definimos $A_k = overline({a_n : n >= n_k})$. Entonces, para todo $k$: $A_k$ es cerrado y no vacío; $op("diam") {a_n : n >= n_k} <= 1\/k$ y, por el Ejercicio 7 de la Práctica 3, $op("diam")(A_k) <= 1\/k$ (en particular $A_k$ es acotado); y $A_(k+1) subset.eq A_k$ porque ${a_n : n >= n_(k+1)} subset.eq {a_n : n >= n_k}$ y la clausura es monótona. Así $op("diam")(A_k) -> 0$ y, por hipótesis, existe $a in inter.big_k A_k$.

  Veamos que $a_n -> a$. Si no, hay $epsilon > 0$ y una subsucesión con $d(a_(n_j), a) >= epsilon$ para todo $j$. Tomemos $k$ con $2\/k < epsilon$. Como $a in A_k = overline({a_n : n >= n_k})$, hay $m >= n_k$ con $d(a, a_m) < 1\/k$; y como $n_j -> +oo$, hay $j_0$ con $n_(j_0) >= n_k$, de modo que $a_(n_(j_0)), a_m in A_k$. Entonces
  $ epsilon <= d(a_(n_(j_0)), a) <= d(a_(n_(j_0)), a_m) + d(a_m, a) < op("diam")(A_k) + 1/k <= 2/k < epsilon, $
  absurdo. Luego $a_n -> a$ y $E$ es completo.
]

#ejemplo[Completo si y sólo si toda bola cerrada es completa (Clase 5 · Ejercicio 6)][C5-6][
  Probar que $(E, d)$ es completo si y sólo si toda bola cerrada $overline(B)(x, r) = {y : d(x, y) <= r}$ es completa.
]

#estrategia[Una Cauchy es acotada, así que vive en una bola cerrada][
  La ida es el Ejercicio 15 de la Práctica 3 (las bolas cerradas son cerradas, Ejercicio 4 (d)). Para la vuelta, la condición de Cauchy con $epsilon = 1$ encierra a toda la sucesión en una bola cerrada centrada en $a_1$ (Teorema 4.54 a); por hipótesis esa bola es completa, así que la sucesión converge ahí, y por lo tanto en $E$.
]

#resolucion[
  $=>)$ Por el Ejercicio 15 de la Práctica 3, ya que $overline(B)(x, r)$ es cerrada (Ejercicio 4 (d)).

  $arrow.l.double)$ Sea $(a_n)_n subset.eq E$ de Cauchy. Es acotada (Teorema 4.54 a): existe $M > 0$ con $(a_n)_n subset.eq overline(B)(a_1, M)$. Por hipótesis $overline(B)(a_1, M)$ es completo, así que $(a_n)_n$ converge a un punto de $overline(B)(a_1, M)$, y como la distancia es la misma, converge en $(E, d)$.
]

#ejemplo[$(0, 1]$ con $abs(x - y)$ no es completo, pero con $abs(1\/x - 1\/y)$ sí (Clase 29/09)][29/09-2][
  Sea $X = (0, 1] subset.eq RR$. Definimos en $X times X$ las siguientes funciones con valores en $RR_(>= 0)$:
  $ d(x, y) := abs(x - y), quad D(x, y) := abs(1/x - 1/y) $
  ($d$ es simplemente la restricción a $X$ de la métrica inducida por el módulo). Probar que:
  #set enum(numbering: "(i)")
  + $D$ es una métrica.
  + La convergencia en $(X, d)$ es la misma que en $(X, D)$. En otras palabras, si $(a_n)_(n in NN) subset.eq X$ es una sucesión y $a in X$, entonces $a_n -> a$ en $(X, d)$ si y sólo si $a_n -> a$ en $(X, D)$.
  + $(X, d)$ no es un espacio métrico completo.
  + $(X, D)$ es un espacio métrico completo.
]

#estrategia[$D >= d$ transporta las Cauchy de $D$ a las de $RR$; lo que $D$ agrega es que el límite no puede ser $0$][
  (i) es gratis: $D = D_f$ con $f(x) = 1\/x$ inyectiva (Ejemplo 15/09-7). En (ii) la vuelta sale de la desigualdad $D(x, y) = abs(x - y)\/(x y) >= abs(x - y) = d(x, y)$; la ida necesita controlar el denominador $a a_n$ lejos de $0$, y para eso se usa la propia convergencia: desde un $n_0$ en adelante, $a_n > a\/2$. (iii) es la sucesión $1\/n$, de Cauchy en $RR$ y por lo tanto en $(X, d)$, cuyo único límite posible es $0 in.not X$. Para (iv), una Cauchy de $(X, D)$ es Cauchy para el módulo (por $D >= d$), así que tiene un límite $x in [0, 1]$ en $RR$; el punto es descartar $x = 0$, y eso lo hace la condición de Cauchy en $D$ con $epsilon = 1$: $abs(1\/x_n - 1\/x_(n_0)) <= 1$ da una cota inferior positiva $x_n >= x_(n_0)\/(1 + x_(n_0))$. Después, (ii) convierte la convergencia en $d$ en convergencia en $D$.
]

#resolucion[
  *(i)* La función $f(x) := 1\/x$ es inyectiva de $(0, +infinity)$ en $(0, +infinity)$. Luego, por el Ejemplo 15/09-7 (en la versión del 29/09, para $f : A -> A$ con $A = (0, +infinity)$), si definimos $tilde(D) : (0, +infinity) times (0, +infinity) -> RR_(>= 0)$ como $tilde(D) (x, y) := abs(1/x - 1/y)$, entonces $tilde(D)$ es una métrica. Restringiendo esta métrica a $(0, 1] times (0, 1]$ obtenemos la $D$ del enunciado, y por lo tanto $D$ es una métrica sobre $(0, 1]$. Queda como ejercicio de la clase dar una solución alternativa, probando "a mano" que $D$ es una métrica.

  _Nota_: la fuente dice "métrica sobre $[0, 1)$"; es un desliz, el conjunto es $X = (0, 1]$.

  *(ii)* Supongamos primero que $a_n -> a$ en $(X, d)$, es decir $abs(a_n - a) -> 0$. Queremos ver que $abs(1\/a_n - 1\/a) -> 0$. Tomando denominador común $a a_n$,
  $ abs(1/a_n - 1/a) = abs(a_n - a)/(a a_n). quad (1) $
  Ya sabemos que el numerador tiende a cero. Para ver que el cociente lo hace, hay que asegurarse de que el denominador esté alejado de cero. Usamos la convergencia: existe $n_0$ tal que si $n >= n_0$, entonces $abs(a - a_n) < a\/2$. Por lo tanto, si $n >= n_0$, $a - a_n <= abs(a - a_n) < a\/2$, lo que implica $a_n > a\/2$. Luego,
  $ abs(a_n - a)/(a a_n) = 1/a_n dot.c 1/a dot.c abs(a_n - a) <= 2/a dot.c 1/a dot.c abs(a_n - a) = 2/a^2 abs(a_n - a), $
  lo que combinado con (1) da
  $ D(a, a_n) = abs(1/a_n - 1/a) <= 2/a^2 abs(a_n - a) quad forall n >= n_0. quad (2) $
  Ya sacamos el $a_n$ del denominador, y ahora sí podemos usar directamente que el numerador tiende a cero: fijado $epsilon > 0$, existe $n_1 in NN$ tal que $abs(a_n - a) < (a^2 epsilon)\/2$ para todo $n >= n_1$. De esto y (2),
  $ D(a, a_n) <= 2/a^2 abs(a_n - a) < epsilon quad forall n >= op("máx") {n_0, n_1}. $
  Hemos probado que $a_n -> a$ en $(X, D)$. $quad (3)$

  La vuelta es más fácil. Para todo $x, y in X$,
  $ D(x, y) = abs(1/x - 1/y) = abs(x - y)/(x y) >= abs(x - y) = d(x, y). quad (4) $
  Luego, dado $epsilon > 0$, si $a_n -> a$ en $(X, D)$ podemos tomar $n_0$ tal que $D(a_n, a) < epsilon$ para $n >= n_0$, y entonces por (4) resulta $d(a_n, a) < epsilon$. Esto completa (ii).

  *(iii)* Tenemos que encontrar una sucesión de Cauchy que no sea convergente. Proponemos $x_n := 1\/n$. Como toda sucesión convergente es de Cauchy (en cualquier espacio métrico) y $x_n -> 0$ en $(RR, abs(dot.c))$, $(x_n)$ es de Cauchy en $RR$: dado $epsilon > 0$, existe $n_0$ tal que $abs(x_n - x_m) < epsilon$ si $n, m >= n_0$. Pero esto es lo mismo que ser de Cauchy en $(X, d)$, por definición de $d$. Veamos que no converge, por el absurdo: supongamos que existe $x in X$ con $x_n -> x$ en $(X, d)$, es decir $abs(x_n - x) -> 0$. Como también $abs(x_n) -> 0$,
  $ 0 <= x = abs(x - x_n + x_n) <= abs(x - x_n) + abs(x_n) -->_(n -> infinity) 0. $
  Se sigue que $x = 0$, lo que es absurdo porque $x in (0, 1]$.

  *(iv)* Sea $(x_n)_(n in NN)$ una sucesión de Cauchy en $(X, D)$. También es de Cauchy en $RR$ con el módulo: dado $epsilon > 0$, tomemos $n_0$ tal que $D(x_n, x_m) < epsilon$ si $n, m >= n_0$; por (4), también $abs(x_n - x_m) < epsilon$. Como $(RR, abs(dot.c))$ es completo, existe $x in RR$ tal que
  $ abs(x - x_n) -->_(n -> infinity) 0. quad (5) $
  Como $0 <= x_n <= 1$ para todo $n$, tomando límite $0 <= x <= 1$. Para completar la demostración de que $(x_n)$ converge en $(X, D)$ tenemos que probar dos cosas: (a) $x in X$; (b) $x_n -> x$ en $(X, D)$.

  Veamos (a), por el absurdo. Si $x in.not X$, como $x in [0, 1]$ y $X = (0, 1]$, es $x = 0$, es decir $x_n -> 0$ en $(RR, abs(dot.c))$. Ahora bien, $(x_n)$ es de Cauchy en $(X, D)$, así que en particular existe $n_0 in NN$ tal que $D(x_n, x_m) <= 1$ si $n, m >= n_0$. Tomando $m = n_0$,
  $ abs(1/x_n - 1/x_(n_0)) <= 1 quad forall n >= n_0. $
  Esto implica que, para todo $n >= n_0$,
  $ 1/x_n = abs(1/x_n - 1/x_(n_0) + 1/x_(n_0)) <= abs(1/x_n - 1/x_(n_0)) + 1/x_(n_0) = (1 + x_(n_0))/x_(n_0) $
  (podemos sacar el módulo porque son números positivos). Se deduce que
  $ x_(n_0)/(1 + x_(n_0)) <= x_n quad forall n >= n_0, $
  lo que es absurdo porque $x_n -> 0$.

  Ahora (b): como $x in X$ y la convergencia en $(X, d)$ es la misma que en $(X, D)$ (por (ii)), alcanza con ver que $x_n -> x$ en $(X, d)$. Pero esto es exactamente (5).

  _Nota_: la fuente nombra a la sucesión de (iv) $(a_n)$ al presentarla y después la llama $(x_n)$; acá se usa $(x_n)$ desde el principio.
]

#sublema(titulo: "Para qué sirve")[
  $d$ y $D$ tienen las *mismas sucesiones convergentes* en $(0, 1]$ (ítem (ii)) y, por el Ejemplo C4-8, definen los mismos abiertos; sin embargo una es completa y la otra no. La completitud no es una propiedad de los abiertos sino de la métrica: no se puede decidir mirando sólo qué sucesiones convergen, hay que mirar cuáles son de Cauchy. (Esta lectura es nuestra; la clase no la explicita.)
]
