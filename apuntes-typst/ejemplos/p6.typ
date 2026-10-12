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

// --- Ejemplos de la Práctica 6 ---

#align(center)[
  #text(14pt, weight: "bold")[Ejemplos resueltos --- Práctica 6] \
  #v(2pt)
  #text(10pt, style: "italic", fill: rgb("#475569"))[
    Espacios normados y operadores lineales
  ]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

Los ejemplos están agrupados por *técnica*, no por orden de transcripción, y los bloques siguen el orden en que la guía los necesita. Cada bloque abre con la nota de qué ejercicios de `guias/p6.typ` desbloquea.

La pestaña dice de dónde viene cada ejemplo: un *número* es el ejemplo de `notas_materia.pdf` (con su numeración por capítulo entre paréntesis en el título) y *`C{clase}-{ejemplo}`* es un ejercicio resuelto en clase, transcrito en `clases/` (un archivo por tema; la tabla clase $arrow$ archivo está en la skill `ejemplo`) --- `C9-4` es el Ejercicio 4 de `clases/punto_fijo.typ`, la clase del 11/11/2025. Los Ejercicios 1 a 3 de esa misma clase (punto fijo en compactos, $f(inter.big A_n) = inter.big f(A_n)$, $cal(C)(RR, [0, 1])$ no separable) viven en `ejemplos/p5.typ`.

#v(6pt)

#show table.cell.where(y: 0): set text(fill: white, weight: "bold", size: 8.5pt)

#table(
  columns: (0.35fr, 2.4fr, 1.1fr),
  align: (center + horizon, left + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#065f46") } else if calc.even(y) { rgb("#f8fafc") } else { white },
  stroke: 0.4pt + rgb("#cbd5e1"),
  inset: (x: 6pt, y: 4pt),

  [*\#*], [*Bloque*], [*Desbloquea*],
  [1], [Completitud en normados: reducir a la esfera unitaria], [p6: Ej. 5 (a); conceptual para Ej. 2, 6 (a), 7],
  [2], [Continuidad de operadores lineales por reescalado], [p6: Ej. 8 (usa (c) $<==>$ (f)), 12; conceptual para Ej. 9, 10, 11, 13 (b)],
)

#v(4pt)

#text(size: 9pt, fill: rgb("#64748b"))[
  La numeración de ejercicios es la de la *guía 2025* (`guias/p6.typ`).
]

#v(8pt)

== Bloque 1 · Completitud en normados: reducir a la esfera unitaria

#sublema(titulo: "Qué desbloquea")[
  En un espacio normado la completitud se puede chequear *sólo sobre la esfera unitaria* $S = {x : norm(x) = 1}$: si toda sucesión de Cauchy de vectores de norma $1$ converge, el espacio es de Banach. La maniobra es *normalizar*, $y_n = x_n \/ norm(x_n)$, y para que eso tenga sentido hay que probar antes que las normas de una sucesión de Cauchy se mantienen lejos de cero (salvo que $x_n -> 0$, caso trivial). En el camino aparece la desigualdad $abs(norm(x_n) - norm(x_m)) <= norm(x_n - x_m)$, que es la que se usa en el *Ejercicio 2* para hablar de bolas y en todo cálculo con normas.

  Este bloque prepara el *Ejercicio 5 (a)* (decidir si $(RR_n [t], norm(dot.c)_infinity)$ y $(RR_n [t], norm(dot.c)_1)$ son de Banach: alcanza con mirar sucesiones de Cauchy de polinomios de norma $1$) y da el lenguaje para el *Ejercicio 6 (a)* y el *Ejercicio 7*, donde las sucesiones interesantes viven en la esfera o en la bola cerrada de $ell^infinity$. La ida usa que un cerrado de un completo es completo (Ejercicio 15 de la Práctica 3).
]

#ejemplo[Banach si y sólo si la esfera unitaria es completa (Clase 9 · Ejercicio 4)][C9-4][
  Sea $(E, norm(dot.c))$ un espacio normado. Sea
  $ S = {x in E : norm(x) = 1}. $
  Probar que $E$ es un espacio de Banach si y sólo si toda sucesión de Cauchy $(x_n)_(n >= 1) subset.eq S$ converge.
]

#estrategia[Normalizar una sucesión de Cauchy que no tiende a cero][
  La ida es gratis: $S$ es cerrado en un completo. Para la vuelta, dada $(x_n)_n$ de Cauchy en $E$, queremos empujarla a $S$ dividiendo por la norma, $y_n = x_n \/ norm(x_n)$. Para eso hace falta que $norm(x_n)$ no se acerque a $0$ (si $x_n -> 0$ no hay nada que probar), y que $(y_n)_n$ siga siendo de Cauchy: ambas cosas salen de que $(norm(x_n))_n$ es de Cauchy en $RR$, luego converge a un $L > 0$. Una vez que $y_n -> y in S$, se recupera $x_n -> L y$.
]

#resolucion[
  La implicación $=>)$ es porque $S$ es cerrado, y por el ejercicio 15 de la práctica 3, es completo. Para la vuelta, sea $(x_n)_n subset.eq E$ de Cauchy. Si $x_n -> 0$, no hay nada que probar. Supongamos que $x_n arrow.r.not 0$. Tenemos que $(norm(x_n))_n$ es de Cauchy, porque
  $ norm(x_n) <= norm(x_n - x_m) + norm(x_m), $
  entonces
  $ norm(x_n) - norm(x_m) <= norm(x_n - x_m), $
  y por simetría,
  $ norm(x_m) - norm(x_n) <= norm(x_n - x_m). $
  Entonces
  $ abs(norm(x_n) - norm(x_m)) <= norm(x_n - x_m), $
  y el segundo término se puede hacer menor a $epsilon$ para todo $n, m$ suficientemente grandes, porque $(x_n)_n$ es de Cauchy. Por lo tanto $(norm(x_n))_n$ converge, porque $RR$ es completo, digamos $norm(x_n) -> L$. Además, $L != 0$; caso contrario, $norm(x_n) -> 0$ equivale a decir que $x_n -> 0$. Como $norm(x_n) >= 0$, $L > 0$. Entonces existen $n_0 in NN$ y $delta > 0$ tales que $norm(x_n) >= delta$ para todo $n >= n_0$. Por lo tanto, podemos _normalizar_ $(x_n)_n$. Para todo $n >= n_0$ definimos $y_n = x_n / norm(x_n)$. Se tiene que
  $
  norm(y_n - y_m) &= norm(x_n / norm(x_n) - x_m / norm(x_m)) = norm((norm(x_m) x_n - x_m norm(x_n)) / (norm(x_n) norm(x_m))) \
  &<= 1 / (norm(x_n) norm(x_m)) [norm(norm(x_m) x_n - L x_n) + norm(L x_n - L x_m) \
  & quad quad + norm(L x_m - x_m norm(x_n))] \
  &<= 1 / (norm(x_n) norm(x_m)) [abs(norm(x_m) - L) norm(x_n) + norm(x_n - x_m) L \
  & quad quad + abs(L - norm(x_n)) norm(x_m)].
  $
  Como $norm(x_n) -> L != 0$, el lado derecho tiende a $0$. Por lo tanto $(y_n)_(n >= n_0)$ es de Cauchy. Como $S$ es completo, $y_n -> y$ con $y in S$. Pero entonces $y_n = x_n / norm(x_n) -> y$ implica que $x_n$ converge a $L y$, ya que para todo $n >= n_0$,
  $
  norm(x_n - L y) &<= norm(x_n - x_n / norm(x_n) L) + norm(x_n / norm(x_n) L - L y) \
  &= abs(1 - L / norm(x_n)) norm(x_n) + norm(x_n / norm(x_n) - y) L \
  &= abs((norm(x_n) - L) / norm(x_n)) norm(x_n) + norm(y_n - y) L,
  $
  y el lado derecho tiende a $0$. Concluimos que $(x_n)_n$ es convergente.

  _Nota_: el manuscrito escribe los factores escalares $abs(1 - L \/ norm(x_n))$ y $abs((norm(x_n) - L) \/ norm(x_n))$ con barras dobles; son valores absolutos en $RR$. "Como $S$ es completo" es la hipótesis de la vuelta: toda sucesión de Cauchy en $S$ converge (y el límite está en $S$ porque $S$ es cerrado).
]

#sublema(titulo: "Para qué sirve")[
  Dos cosas quedan para reutilizar. La primera es la desigualdad $abs(norm(x) - norm(y)) <= norm(x - y)$: dice que la norma es $1$-lipschitz, así que $x_n -> x$ implica $norm(x_n) -> norm(x)$, y en particular las sucesiones de Cauchy tienen normas de Cauchy. La segunda es el reescalado: en un normado, cualquier sucesión que no tienda a $0$ se puede *proyectar* sobre la esfera dividiendo por la norma, y la estimación de $norm(y_n - y_m)$ muestra cómo controlar el error de ese cociente con $norm(x_n - x_m)$ y $abs(norm(x_n) - norm(x_m))$. Es la misma cuenta que se necesita cuando una propiedad (compacidad de la bola, densidad, completitud) se prueba primero para vectores unitarios y después se extiende a todo el espacio.
]

== Bloque 2 · Continuidad de operadores lineales por reescalado

#sublema(titulo: "Qué desbloquea")[
  Para un operador lineal $T : E -> F$ la continuidad es una propiedad *global* que se decide en el $0$: el *Ejercicio 8* de la guía prueba que son equivalentes ser continuo en $0$, continuo en algún punto, continuo, uniformemente continuo, acotado, y mandar acotados en acotados. El ejemplo de este bloque agrega un criterio por sucesiones, muy cómodo para refutar continuidad: $T$ es continua si y sólo si $x_n -> 0$ fuerza que $(T(x_n))_n$ sea acotada. La resolución de clase *usa* el Ejercicio 8 (en la forma "manda acotados en acotados $<==>$ continua"), así que conviene tener ese ejercicio hecho antes de leerla.

  La técnica central es un *reescalado* $y_k = x_(n_k) \/ (sqrt(n_k) norm(x_(n_k)))$: se divide por la norma para ganar control del tamaño y por $sqrt(n_k)$ para que la sucesión tienda a $0$ sin que $T$ deje de explotar. Es exactamente lo que pide el *Ejercicio 12* (mostrar que la derivación $delta p = p'$ no es continua en $(RR[t], norm(dot.c)_infinity)$: basta exhibir $p_n -> 0$ con $norm(p'_n)_infinity$ no acotada) y lo que está detrás de los *Ejercicios 9, 10, 11 y 13 (b)*, donde acotar $norm(T x)$ por una constante por $norm(x)$ es lo mismo que probar la continuidad.
]

#ejemplo[Continuidad de una lineal vía sucesiones nulas (Clase 9 · Ejercicio 5)][C9-5][
  Sean $E, F$ espacios normados. Sea $T : E -> F$ una transformación lineal. Probar que $T$ es continua si y sólo si para toda sucesión $(x_n)_(n >= 1)$ en $E$ que tiende a $0$, $(T(x_n))_n$ es acotada.
]

#estrategia[Fabricar una sucesión nula donde $T$ explote][
  La ida es inmediata: continuidad en $0$ más linealidad dan $T(x_n) -> 0$, y las convergentes son acotadas. Para la vuelta, pasamos por el Ejercicio 8: alcanza con ver que $T$ manda acotados en acotados. Si un acotado $A$ tiene $T(A)$ no acotado, elegimos $x_n in A$ con $norm(T(x_n)) >= n$; el problema es que $(x_n)_n$ no tiene por qué tender a $0$. Si no lo hace, una subsucesión queda lejos de $0$ y la reescalamos: dividir por $norm(x_(n_k))$ la normaliza y dividir además por $sqrt(n_k)$ la hace tender a $0$, mientras que $norm(T(y_k))$ crece como $sqrt(n_k)$. El caso $x_n -> 0$ lo cubre directamente la hipótesis.
]

#resolucion[
  La implicación $=>)$ es consecuencia directa de la continuidad, pues $T(x_n) -> T(0) = 0$. Para la implicación $arrow.l.double)$, alcanza con ver que para todo $A subset.eq E$ acotado, $T(A)$ es acotado, porque por el ejercicio 8 de la práctica 6, esto equivale a que $T$ sea continua. Si _existiera $A subset.eq E$ acotado con $T(A)$ no acotado_, entonces para todo $n in NN$, existe $x_n in A$ tal que $norm(T(x_n)) >= n$. Por lo tanto $(T(x_n))_n$ no está acotada. Esto no finaliza la prueba, porque $x_n$ no tiene por qué tender a $0$. Si $x_n arrow.r.not 0$, existen $(x_(n_k))_k$ y $delta > 0$ tales que $norm(x_(n_k)) > delta$ para todo $k in NN$. Entonces, para todo $k in NN$, sea $y_k = x_(n_k) / (sqrt(n_k) norm(x_(n_k)))$. Tenemos que $norm(y_k) = 1 / sqrt(n_k) -> 0$, y
  $
  norm(T(y_k)) = norm(T(x_(n_k)) / (sqrt(n_k) norm(x_(n_k)))) >= n_k / (sqrt(n_k) norm(x_(n_k))) = sqrt(n_k) / norm(x_(n_k)).
  $
  Como $A$ está acotado, $A subset.eq B(0, R)$ para algún $R > 0$. Entonces $norm(x_n) <= R$, por lo tanto
  $ norm(T(y_k)) >= sqrt(n_k) / R, $
  y concluimos que $(T(y_k))_k$ no está acotada, con $y_k -> 0$.

  _Nota_: el caso $x_n -> 0$ queda cubierto por la hipótesis: entonces $(T(x_n))_n$ debería ser acotada, y no lo es. Por eso la resolución sólo trata el caso $x_n arrow.r.not 0$.
]

#sublema(titulo: "Para qué sirve")[
  El criterio se usa casi siempre en negativo: para probar que un operador lineal *no* es continuo basta una sucesión $x_n -> 0$ con $norm(T(x_n))$ no acotada. El reescalado del ejemplo muestra cómo construirla a partir de cualquier familia acotada donde $T$ explote. Notar que la cota $norm(x_(n_k)) > delta$ no se usa en la cuenta final (la cota que importa es la superior, $norm(x_n) <= R$); lo que garantiza es que la división por $norm(x_(n_k))$ tenga sentido.
]
