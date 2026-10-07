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

// Resolución de la Práctica 1 escrita por el agente (Claude), NO por el autor de los apuntes.
// Vive en `guias-agente/` para distinguirla de las resoluciones de `guias/p1.typ`.
// Cada ejercicio está verificado en Lean 4 + Mathlib: ver `lean/Guias/Guia1/EjNN.lean`.

#align(center)[
  #text(14pt, weight: "bold")[Análisis Avanzado 2026] \
  #v(2pt)
  #text(12pt, weight: "medium")[Práctica 1 --- resuelta por el agente]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#progreso[
  *Autoría:* este archivo lo escribió el agente (Claude). No es una resolución del autor de los
  apuntes: la de él está en `guias/p1.typ`. Se guarda en otra carpeta para poder distinguirlas.

  *Qué se supone verdadero:* todo lo escrito en `apuntes.typ`, capítulos 1 y 2 (definiciones,
  proposiciones, teoremas y el Axioma de Completitud, citados por nombre y número). Como ésta es
  la primera práctica, no hay prácticas anteriores que citar; dentro de la Práctica 1, un
  ejercicio puede citar los anteriores ("Ej. 2 (a)"), nunca los posteriores. Los ejemplos de
  `ejemplos/p1.typ` se leyeron como inspiración; ninguno se usa como lema.

  *Circularidad evitada:* cuando el ejercicio _es_ un resultado de `apuntes.typ` (o `apuntes.typ`
  lo deja como "ejercicio de la guía"), no se cita ese resultado: se demuestra desde las
  definiciones. Pasa en el Ej. 1 (lo usa la Unicidad del límite), el Ej. 2 (b) (Proposición 2),
  el Ej. 3 (Proposición 5, Equivalencia de Ínfimo), el Ej. 6 (a) (la demostración del Teorema 2),
  el Ej. 9 (a) (Álgebra de límites, ítem b), el Ej. 10 (Álgebra de límites, ítem e) y el
  Ej. 12 (a) (espejo de la Proposición 8). La caja _Observación_ de cada uno lo dice.

  *Qué se usa sin cita:* el álgebra y el orden de $RR$ como cuerpo ordenado, las propiedades
  elementales del valor absoluto (desigualdad triangular, $abs(a b) = abs(a) abs(b)$,
  $abs(x) < epsilon <=> -epsilon < x < epsilon$), que $NN subset.eq ZZ subset.eq QQ subset.eq RR$,
  inducción, el buen orden de $NN$ (y, por traslación, el de los subconjuntos de $ZZ$ acotados
  inferiormente), que no hay enteros entre $n$ y $n + 1$, el máximo de finitos números y
  $abs(op("sen") x) <= 1$. Lo que va más allá (la parte entera, $n <= 2^n$, $sqrt(2) in.not QQ$)
  se demuestra en el lugar como sublema "(deducción propia)".

  *Supuestos externos declarados:* (1) en el Ej. 2 (c) se usan la existencia de $sqrt(2)$ (el real
  positivo cuyo cuadrado es $2$) y que toda fracción tiene una forma reducida; (2) en el Ej. 7 (b),
  $abs(op("sen") x) <= 1$; (3) en el Ej. 12 se lee "decreciente" como $x_(n+1) <= x_n$ para _todo_
  $n$ (la Definición 10 admite también "a partir de un $n_0$", pero con esa lectura el ítem (a)
  sería falso tal como está escrito; se da el ejemplo).

  *Verificación en Lean:* cada ejercicio tiene su contraparte en `lean/Guias/Guia1/EjNN.lean`
  (Lean 4 + Mathlib; `cd lean && lake build`). Las definiciones del curso (cota, supremo, ínfimo,
  máximo, mínimo, convergencia, divergencia a $plus.minus oo$, sucesión acotada, monótona,
  subsucesión) y los resultados de `apuntes.typ` que se toman como verdaderos están en
  `lean/Guias/Guia1/Defs.lean`; cada archivo importa ése (y, a lo sumo, un ejercicio anterior).
  En Lean las sucesiones empiezan en $n = 0$ (en el curso, en $n = 1$); ningún argumento depende
  de eso. Las demostraciones de límites se hacen desplegando la definición $epsilon$-$n_0$, sin
  pasar por la noción de límite de Mathlib. La caja _Observación_ del final de cada ejercicio dice
  qué teorema certifica qué ítem y en qué se aparta la formalización del texto.
]

#v(10pt)

== Ejercicio 1

#enunciado[Ejercicio 1][
  Probar que si $x < y + epsilon$ para todo $epsilon > 0$, entonces $x <= y$. Deducir que si $abs(x - y) < epsilon$ para todo $epsilon > 0$, entonces $x = y$.
]

#estrategia[Contrarrecíproco con $epsilon = x - y$, y después dos veces lo mismo][
  Para la primera parte suponemos $x > y$ y usamos la hipótesis con el único $epsilon$ que la rompe: $epsilon = x - y > 0$ da $x < y + (x - y) = x$. Para la segunda, $abs(x - y) < epsilon$ equivale a $-epsilon < x - y < epsilon$, que son las dos desigualdades $x < y + epsilon$ e $y < x + epsilon$; la primera parte aplicada a cada una da $x <= y$ e $y <= x$. No hace falta nada de sucesiones: todo sale del orden de $RR$.
]

// ---------------------------------------------------------------- primera parte
#enunciado[Ejercicio 1 (primera parte)][Si $x < y + epsilon$ para todo $epsilon > 0$, entonces $x <= y$.]

#resolucion[Propuesta: por el contrarrecíproco, con $epsilon_0 = x - y$][
  Sean $x, y in RR$ tales que $x < y + epsilon$ para todo $epsilon > 0$. Supongamos, por el absurdo, que $x > y$ (por tricotomía del orden de $RR$, es la única alternativa a $x <= y$). Entonces $epsilon_0 = x - y > 0$, y la hipótesis con $epsilon = epsilon_0$ dice
  $ x < y + epsilon_0 = y + (x - y) = x, $
  es decir $x < x$, que contradice la irreflexividad del orden. Luego $x <= y$.
]

// ---------------------------------------------------------------- segunda parte
#enunciado[Ejercicio 1 (segunda parte)][Si $abs(x - y) < epsilon$ para todo $epsilon > 0$, entonces $x = y$.]

#resolucion[Propuesta: la primera parte aplicada dos veces][
  Sean $x, y in RR$ tales que $abs(x - y) < epsilon$ para todo $epsilon > 0$. Fijemos $epsilon > 0$. Por la propiedad elemental del valor absoluto (hecho de base)
  $ abs(x - y) < epsilon <=> -epsilon < x - y < epsilon, $
  obtenemos las dos desigualdades
  $ x < y + epsilon quad "y" quad y < x + epsilon. $
  Como esto vale para todo $epsilon > 0$, la primera parte aplicada al par $(x, y)$ da $x <= y$, y aplicada al par $(y, x)$ da $y <= x$. Por antisimetría del orden, $x = y$.
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej01`][
  `ej1a {x y : ℝ} (h : ∀ ε > 0, x < y + ε) : x ≤ y` certifica la primera parte y `ej1b {x y : ℝ} (h : ∀ ε > 0, |x - y| < ε) : x = y` la segunda. La primera es el contrarrecíproco con `ε = x - y` (`by_contra` + `linarith`); la segunda aplica `ej1a` dos veces, con las dos mitades de `abs_lt` (`|x - y| < ε ↔ -ε < x - y ∧ x - y < ε`, el hecho de base sobre el valor absoluto) y cierra con `le_antisymm`. No se usa la Unicidad del límite (`unicidad_limite`, cuya demostración en `apuntes.typ` pasa por este ejercicio) ni ningún otro resultado de `Defs.lean`: la formalización sigue el texto sin desvíos.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 2

#enunciado[Ejercicio 2][
  #set enum(numbering: "(a)")
  + Sean $x, y in RR$ tales que $y - x > 1$. Probar que existe un entero entre $x$ e $y$.
  + Sean $x, y in RR$ tales que $x < y$. Probar que existe un racional entre $x$ e $y$.
  + Sean $x, y in QQ$ tales que $x < y$. Probar que existe un irracional entre $x$ e $y$.
  + Sean $x, y in RR$ tales que $x < y$. Probar que existe un irracional entre $x$ e $y$.
]

#estrategia[Construir el entero con Arquímedes y buen orden; el resto es encadenar][
  Los cuatro ítems se apoyan uno en el otro. Para (a) el entero es $m = op("mín") {k in ZZ : x < k}$: el conjunto es no vacío y acotado inferiormente por el Teorema 1 (Principio de Arquímedes), tiene mínimo por el buen orden, y la minimalidad da $m - 1 <= x$, con lo que $x < m <= x + 1 < y$. Para (b) se repite la demostración de la Proposición 2: con la Proposición 1 se separa $n x$ de $n y$ en más de $1$, (a) encaja un entero $m$ y $q = m / n$. Para (c) hace falta un irracional concreto, $sqrt(2)$ (paridad), y que sumar un racional o multiplicar por un racional no nulo no lo vuelve racional: $z = x + ((y - x)/2) sqrt(2)$ sirve porque $0 < sqrt(2)/2 < 1$. Para (d) se toman dos racionales entre $x$ e $y$ con (b) y un irracional entre ellos con (c).
]

// ---------------------------------------------------------------- (a)
#enunciado[Ejercicio 2 (a)][Sean $x, y in RR$ tales que $y - x > 1$. Probar que existe un entero entre $x$ e $y$.]

#resolucion[Propuesta: $m = op("mín") {k in ZZ : x < k}$ cumple $x < m < y$][
  Sean $x, y in RR$ con $y - x > 1$, es decir $x + 1 < y$. Consideremos el conjunto
  $ C = {k in ZZ : x < k}. $

  - *$C != nothing$.* Por el Teorema 1 (Principio de Arquímedes) aplicado a $x$, existe $n in NN$ con $x <= n$. Entonces $x < n + 1$ y $n + 1 in ZZ$, así que $n + 1 in C$.
  - *$C$ está acotado inferiormente.* Por el Teorema 1 aplicado a $-x$, existe $N in NN$ con $-x <= N$, es decir $-N <= x$. Si $k in C$ entonces $-N <= x < k$: el entero $-N$ es cota inferior de $C$.
  - *$C$ tiene mínimo.* Es un subconjunto no vacío de $ZZ$ acotado inferiormente, así que por el buen orden (hecho de base: trasladando por $N$, el conjunto ${k + N : k in C} subset.eq NN$ es no vacío y tiene primer elemento) existe $m = op("mín") C$.

  Veamos que $m$ es el entero buscado.

  - *$x < m$*, porque $m in C$.
  - *$m - 1 <= x$.* El entero $m - 1$ es menor que $m = op("mín") C$, así que $m - 1 in.not C$, o sea que no vale $x < m - 1$; por tricotomía, $m - 1 <= x$.

  Juntando todo,
  $ x < m <= x + 1 < y, $
  donde la última desigualdad es la hipótesis $y - x > 1$. Luego $m in ZZ$ y $x < m < y$.
]

// ---------------------------------------------------------------- (b)
#enunciado[Ejercicio 2 (b)][Sean $x, y in RR$ tales que $x < y$. Probar que existe un racional entre $x$ e $y$.]

#resolucion[Propuesta: $q = m / n$ con $n$ de la Proposición 1 y $m$ del ítem (a)][
  Sean $x, y in RR$ con $x < y$. Entonces $y - x > 0$, y por la Proposición 1 (Principio de Arquímedes 2) existe $n in NN$ tal que
  $ 0 < 1/n < y - x. $
  Multiplicando por $n > 0$ (no cambia el sentido de la desigualdad) queda
  $ 1 < n (y - x) = n y - n x. $
  Los números $n x$ y $n y$ son reales con $n y - n x > 1$, así que por el Ej. 2 (a) existe $m in ZZ$ con
  $ n x < m < n y. $
  Dividiendo por $n > 0$,
  $ x < m / n < y. $
  Como $m in ZZ$ y $n in NN$, $n != 0$, el número $q = m / n$ es racional y cumple $x < q < y$.
]

// ---------------------------------------------------------------- (c)
#sublema(titulo: "Sublema 1 (deducción propia): √2 no es racional")[
  Llamamos $sqrt(2)$ al real positivo cuyo cuadrado es $2$ (su existencia es un hecho de base; en Lean es `Real.sqrt 2`). Supongamos que $sqrt(2) in QQ$. Escribimos $sqrt(2) = a / b$ como fracción reducida, con $a in ZZ$, $b in NN$, $b >= 1$ y $op("mcd")(a, b) = 1$ (toda fracción tiene una forma reducida: hecho de base). Elevando al cuadrado y multiplicando por $b^2$,
  $ a^2 = 2 b^2. $

  - *$a$ es par.* Si $a$ fuera impar, $a = 2 k + 1$ con $k in ZZ$, tendríamos $a^2 = 4 k^2 + 4 k + 1 = 2 (2 k^2 + 2 k) + 1$, impar; pero $a^2 = 2 b^2$ es par. Luego $a = 2 k$ para algún $k in ZZ$.
  - *$b$ es par.* Reemplazando, $4 k^2 = 2 b^2$, es decir $b^2 = 2 k^2$ es par, y por el mismo argumento de paridad $b$ es par.

  Entonces $2 divides a$ y $2 divides b$, de modo que $2 divides op("mcd")(a, b) = 1$, absurdo. Por lo tanto $sqrt(2) in.not QQ$. $qed$
]

#sublema(titulo: "Sublema 2 (deducción propia): racional + irracional y racional no nulo · irracional")[
  Sea $t in RR$ con $t in.not QQ$ y sea $q in QQ$.

  - *$q + t in.not QQ$.* Si fuera $q + t = s in QQ$, entonces $t = s - q in QQ$ (la resta de racionales es racional), absurdo.
  - *Si $q != 0$, $q t in.not QQ$.* Si fuera $q t = s in QQ$, como $q != 0$ tendríamos $t = s / q in QQ$ (el cociente de racionales con denominador no nulo es racional), absurdo. $qed$
]

#enunciado[Ejercicio 2 (c)][Sean $x, y in QQ$ tales que $x < y$. Probar que existe un irracional entre $x$ e $y$.]

#resolucion[Propuesta: $z = x + ((y - x)/2) sqrt(2)$ es irracional y $x < z < y$][
  Sean $x, y in QQ$ con $x < y$ y sea
  $ z = x + (y - x)/2 dot sqrt(2). $

  *$z$ es irracional.* El número $(y - x)/2$ es racional y no nulo (porque $y - x > 0$). Por el Sublema 1, $sqrt(2) in.not QQ$; por el Sublema 2 (producto), $((y - x)/2) sqrt(2) in.not QQ$; y por el Sublema 2 (suma) con el racional $x$, $z in.not QQ$.

  *$0 < sqrt(2)/2 < 1$.* Por definición $sqrt(2) > 0$. Además $sqrt(2) < 2$: si fuera $sqrt(2) >= 2$, multiplicando por $sqrt(2) > 0$ tendríamos $2 = (sqrt(2))^2 >= 2 sqrt(2) >= 4$, absurdo. Dividiendo por $2$, $0 < sqrt(2)/2 < 1$.

  *$x < z < y$.* Como $y - x > 0$, multiplicando la desigualdad anterior por $y - x$ queda
  $ 0 < (y - x) dot sqrt(2)/2 < y - x, $
  y sumando $x$ en los tres miembros, $x < z < y$.
]

// ---------------------------------------------------------------- (d)
#enunciado[Ejercicio 2 (d)][Sean $x, y in RR$ tales que $x < y$. Probar que existe un irracional entre $x$ e $y$.]

#resolucion[Propuesta: dos racionales por (b) y un irracional entre ellos por (c)][
  Sean $x, y in RR$ con $x < y$. Por el Ej. 2 (b) existe $q_1 in QQ$ con $x < q_1 < y$. Como $q_1 < y$, otra vez por el Ej. 2 (b) existe $q_2 in QQ$ con $q_1 < q_2 < y$. Ahora $q_1, q_2 in QQ$ y $q_1 < q_2$, así que por el Ej. 2 (c) existe $z in.not QQ$ con $q_1 < z < q_2$. En total,
  $ x < q_1 < z < q_2 < y, $
  y $z$ es un irracional entre $x$ e $y$.
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej02`][
  Los cuatro ítems están en un solo archivo, encadenados como en el texto: `ej2a {x y : ℝ} (h : 1 < y - x) : ∃ m : ℤ, x < m ∧ m < y`, `ej2b {x y : ℝ} (h : x < y) : ∃ q : ℚ, x < q ∧ q < y`, `ej2c {x y : ℚ} (h : x < y) : ∃ z : ℝ, Irrational z ∧ x < z ∧ z < y` y `ej2d {x y : ℝ} (h : x < y) : ∃ z : ℝ, Irrational z ∧ x < z ∧ z < y`. `Irrational z` es sólo la definición de Mathlib `z ∉ Set.range ((↑) : ℚ → ℝ)`, "no es la imagen de ningún racional".

  - *(a)* usa `arquimedes` (Teorema 1) dos veces, para $-x$ y para $x + N$, y el buen orden vía `Nat.find` sobre el predicado trasladado $k |-> x < k - N$ con $k in NN$ (sin `Int.floor` ni `Int.ceil`): el mínimo $k_0$ da $m = k_0 - N$, y `Nat.find_min` es la minimalidad "$m - 1 in.not C$" (si $k_0 = 0$, $m - 1 = -N - 1 <= x$ directamente). Es exactamente la traslación por $N$ que el texto invoca para el buen orden de $ZZ$.
  - *(b)* usa `arquimedes2` (Proposición 1) y `ej2a`; las dos divisiones por $n$ son `lt_div_iff₀` y `div_lt_iff₀`. No se usa `densidad_Q` ni `exists_rat_btwn`.
  - *(c)*: `sqrt_two_irrational : Irrational (Real.sqrt 2)` es el Sublema 1, probado localmente por paridad con `r.num`, `r.den` y `Rat.reduced` (la forma reducida, hecho de base) y `Int.dvd_gcd`; el paso "$a^2$ par $=>$ $a$ par" es `Int.even_pow` (lema elemental de paridad de Mathlib, equivalente a "impar al cuadrado es impar"). `irrational_rat_add` e `irrational_rat_mul` son el Sublema 2. La existencia de $sqrt(2)$ es `Real.sqrt 2` con `Real.sq_sqrt`, y $sqrt(2) < 2$ sale con `nlinarith` de $(sqrt(2))^2 = 2$. No se usa `irrational_sqrt_two`, `Irrational.rat_add`, `Irrational.rat_mul` ni `exists_irrational_btwn`.
  - *(d)* es `ej2b` dos veces y `ej2c`, con la cadena $x < q_1 < z < q_2 < y$.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 3

#enunciado[Ejercicio 3][
  Sea $A subset.eq RR$ no vacío y acotado inferiormente. Probar la siguiente equivalencia:
  $ i = op("ínf") A <=> cases(
    i <= a "para todo " a in A,,
    "para todo " epsilon > 0 "existe " a in A "tal que " i <= a < i + epsilon.
  ) $
]

#estrategia[Las dos implicaciones por el absurdo, desde la Definición 5][
  La Definición 5 dice que $i = op("ínf") A$ es (a) cota inferior y (b) mayor o igual que toda cota inferior. La primera condición del enunciado es (a) tal cual, así que lo que se intercambia es (b) por la condición con $epsilon$. Para $=>$, si para algún $epsilon$ no hubiera $a in A$ con $a < i + epsilon$, entonces $i + epsilon$ sería una cota inferior mayor que $i$. Para $arrow.l.double$, si $t > i$ fuera cota inferior, el $epsilon = t - i$ produce un $a in A$ con $a < t$. Es la demostración de la Proposición 5 (Equivalencia de Ínfimo), rehecha acá porque este ejercicio _es_ esa proposición.
]

#resolucion[Propuesta: vale la equivalencia][
  Sea $A subset.eq RR$ no vacío y acotado inferiormente, y sea $i in RR$. Llamemos
  - (I): $i <= a$ para todo $a in A$ (es decir, $i$ es cota inferior de $A$, Definición 4);
  - (II): para todo $epsilon > 0$ existe $a in A$ tal que $i <= a < i + epsilon$.

  Por la Definición 5, $i = op("ínf") A$ significa: (a) $i$ es cota inferior de $A$, y (b) si $t$ es cota inferior de $A$ entonces $t <= i$.

  *($=>$)* Supongamos $i = op("ínf") A$. La condición (I) es exactamente (a). Para (II), fijemos $epsilon > 0$ y supongamos, por el absurdo, que no existe $a in A$ con $i <= a < i + epsilon$. Como por (a) todo $a in A$ cumple $i <= a$, lo que falla es la segunda desigualdad: para todo $a in A$ no vale $a < i + epsilon$, es decir (tricotomía) $a >= i + epsilon$. Entonces $i + epsilon$ es cota inferior de $A$, y por (b) $i + epsilon <= i$, o sea $epsilon <= 0$, contra $epsilon > 0$. Luego existe $a in A$ con $i <= a < i + epsilon$.

  *($arrow.l.double$)* Supongamos (I) y (II). Por (I), $i$ es cota inferior de $A$: vale (a). Para (b), sea $t$ una cota inferior de $A$ y supongamos, por el absurdo, que $t > i$. Entonces $epsilon = t - i > 0$ y por (II) existe $a in A$ tal que
  $ a < i + epsilon = i + (t - i) = t. $
  Pero $t$ es cota inferior de $A$, así que $t <= a$; junto con $a < t$ esto es absurdo. Luego $t <= i$ para toda cota inferior $t$, que es (b). Por la Definición 5, $i = op("ínf") A$.
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej03`][
  `ej3 {A : Set ℝ} (_hne : A.Nonempty) (_hb : AcotadoInf A) {i : ℝ} : EsInf A i ↔ CotaInf A i ∧ ∀ ε > 0, ∃ a ∈ A, i ≤ a ∧ a < i + ε`. `EsInf` es la Definición 5 (`CotaInf A i ∧ ∀ t, CotaInf A t → t ≤ i`) y la prueba la despliega tal cual: en $=>$, `by_contra` + `push Not` convierte "no hay $a$ con $i <= a < i + epsilon$" en "todo $a in A$ con $i <= a$ cumple $i + epsilon <= a$", que con la cota inferior $i$ da `CotaInf A (i + ε)` y `linarith` cierra con (b); en $arrow.l.double$ se toma `ε = t - i`. No se usa la Proposición 5 (`equiv_inf`), que es literalmente este ejercicio, ni `esInf_iff_isGLB`. Las hipótesis "$A != nothing$" y "acotado inferiormente" son las del enunciado (dan sentido a $op("ínf") A$) pero el argumento no las necesita: por eso en Lean van con guión bajo (`_hne`, `_hb`).
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 4

#enunciado[Ejercicio 4][
  Hallar, si existen, supremo, ínfimo, máximo y mínimo de los siguientes subconjuntos de $RR$, y
  probar que lo son:
  #set enum(numbering: "(a)")
  + $(a, b]$
  + $B = {1/2^n : n in NN}$
  + $B union {0}$
  + ${x^2 - x - 1 : x in RR}$
]

#estrategia[Exhibir la cota y descartar cualquier cota mejor][
  Para cada conjunto hay cuatro veredictos. Cuando el extremo *pertenece* al conjunto, alcanza con
  ver que es cota y aplicar la Proposición 4 (Caracterización de Supremo y Máximo) o la
  Proposición 6 (Caracterización de Ínfimo y Mínimo): es supremo/ínfimo y además máximo/mínimo.
  Cuando *no* pertenece, se prueba que es cota y que ninguna cota mejor existe (Definición 2 o 5),
  descartando la cota mejor con el *punto medio* (intervalos) o con el *Principio de Arquímedes*
  (conjuntos del tipo ${1/2^n}$); y la no existencia del máximo/mínimo se prueba mostrando que
  cualquier candidato $m$ del conjunto tiene otro elemento del conjunto más allá de él. Cuando el
  conjunto no está acotado superiormente (Arquímedes otra vez), no hay supremo ni máximo, porque
  la Definición 2 exige que el supremo sea una cota superior.
]

// ---------------------------------------------------------------- (a)
#enunciado[Ejercicio 4 (a)][
  $(a, b] = {x in RR : a < x <= b}$. Suponemos $a < b$ (si no, el conjunto es vacío y no hay nada
  que hallar).
]

#resolucion[Propuesta: $op("sup") = op("máx") = b$, $op("ínf") = a$, no hay mínimo][
  *Supremo y máximo.* $b$ es cota superior de $(a, b]$: si $x in (a, b]$ entonces $x <= b$
  (Definición 1). Además $b in (a, b]$ porque $a < b$ y $b <= b$. Por la Proposición 4
  (Caracterización de Supremo y Máximo), $b = op("sup")(a, b] = op("máx")(a, b]$.

  *Ínfimo.* Usamos la Definición 5. $a$ es cota inferior: si $x in (a, b]$ entonces $a < x$, en
  particular $a <= x$ (Definición 4). Sea $t$ una cota inferior de $(a, b]$ y veamos que $t <= a$.
  Supongamos que no, es decir, $a < t$. Como $b in (a, b]$ y $t$ es cota inferior, $t <= b$.
  Tomamos el punto medio $x = (a + t)/2$: de $a < t$ sale $a < x < t <= b$, así que
  $x in (a, b]$ y $x < t$, lo que contradice que $t$ sea cota inferior. Luego $t <= a$ y
  $a = op("ínf")(a, b]$.

  *Mínimo.* No existe. Si $m$ fuera el mínimo de $(a, b]$ (Definición 6), en particular
  $m in (a, b]$, así que $a < m <= b$, y $m$ sería cota inferior. Pero el punto medio
  $x = (a + m)/2$ cumple $a < x < m <= b$: está en $(a, b]$ y es menor que $m$, absurdo.
]

// ---------------------------------------------------------------- (b)
#enunciado[Ejercicio 4 (b)][
  $B = {1/2^n : n in NN} = {1/2, 1/4, 1/8, dots}$ (con $NN = {1, 2, 3, dots}$).
]

#sublema(titulo: "Sublema 1 (deducción propia): n ≤ 2ⁿ para todo n ∈ ℕ")[
  Por inducción en $n$. Para $n = 1$: $1 <= 2 = 2^1$. Si $k <= 2^k$, entonces
  $ k + 1 <= 2^k + 1 <= 2^k + 2^k = 2^(k + 1), $
  usando $1 <= 2^k$. (Vale también para $n = 0$: $0 <= 1$.) $qed$
]

#resolucion[Propuesta: $op("sup") = op("máx") = 1/2$, $op("ínf") = 0$, no hay mínimo][
  *Supremo y máximo.* $1/2 in B$ (es $n = 1$). Es cota superior: si $n >= 1$ entonces
  $2^n >= 2^1 = 2$, y como $2 > 0$ y $2^n > 0$, invirtiendo queda $1/2^n <= 1/2$. Por la
  Proposición 4, $1/2 = op("sup") B = op("máx") B$.

  *Ínfimo.* Usamos la Definición 5. $0$ es cota inferior porque $1/2^n > 0$ para todo $n$. Sea
  $t$ una cota inferior de $B$ y supongamos, por el absurdo, que $t > 0$. Por la Proposición 1
  (Principio de Arquímedes 2) existe $n in NN$ con $0 < 1/n < t$. Por el Sublema 1, $n <= 2^n$,
  y como $n > 0$, invirtiendo, $1/2^n <= 1/n$. Entonces
  $ 1/2^n <= 1/n < t, quad "con" 1/2^n in B, $
  y $t$ no es cota inferior: absurdo. Luego toda cota inferior cumple $t <= 0$ y $0 = op("ínf") B$.

  *Mínimo.* No existe. Si $m$ fuera el mínimo de $B$ (Definición 6), $m in B$, así que
  $m = 1/2^n$ para algún $n in NN$, y $m$ sería cota inferior de $B$. Pero $1/2^(n + 1) in B$ y
  $ 1/2^(n + 1) < 1/2^n = m, $
  porque $2^n < 2^(n + 1) = 2 dot 2^n$ (es $0 < 2^n$). Esto contradice que $m$ sea cota inferior.
]

// ---------------------------------------------------------------- (c)
#enunciado[Ejercicio 4 (c)][
  $B union {0}$, con $B$ el conjunto del ítem (b).
]

#resolucion[Propuesta: $op("sup") = op("máx") = 1/2$, $op("ínf") = op("mín") = 0$][
  *Supremo y máximo.* $1/2 in B subset.eq B union {0}$. Es cota superior de $B union {0}$: los
  elementos de $B$ cumplen $1/2^n <= 1/2$ (ítem (b)) y el elemento $0$ cumple $0 <= 1/2$. Por la
  Proposición 4, $1/2 = op("sup")(B union {0}) = op("máx")(B union {0})$.

  *Ínfimo y mínimo.* $0 in B union {0}$. Es cota inferior: los elementos de $B$ cumplen
  $0 < 1/2^n$ (ítem (b)) y $0 <= 0$. Por la Proposición 6 (Caracterización de Ínfimo y Mínimo),
  $0 = op("ínf")(B union {0}) = op("mín")(B union {0})$.

  Comparado con (b): agregar el ínfimo al conjunto no cambia el supremo ni el ínfimo, pero ahora
  el ínfimo pertenece al conjunto y por eso es mínimo.
]

// ---------------------------------------------------------------- (d)
#enunciado[Ejercicio 4 (d)][
  $C = {x^2 - x - 1 : x in RR}$.
]

#resolucion[Propuesta: $op("ínf") = op("mín") = -5/4$; sin supremo ni máximo (no acotado sup.)][
  *Ínfimo y mínimo.* Completando cuadrados, para todo $x in RR$,
  $ x^2 - x - 1 = (x - 1/2)^2 - 5/4 >= -5/4, $
  porque $(x - 1/2)^2 >= 0$. Así $-5/4$ es cota inferior de $C$. Además $-5/4 in C$: es el valor
  en $x = 1/2$, pues $(1/2)^2 - 1/2 - 1 = 1/4 - 1/2 - 1 = -5/4$. Por la Proposición 6,
  $-5/4 = op("ínf") C = op("mín") C$.

  *$C$ no está acotado superiormente.* Sea $c in RR$ cualquiera; veamos que no es cota superior.
  Por el Teorema 1 (Principio de Arquímedes) existe $n in NN$ con $abs(c) + 2 <= n$. Entonces
  $n >= 2$, así que $n - 1 >= 1$ y
  $ n^2 - n - 1 = n (n - 1) - 1 >= n - 1 >= abs(c) + 1 > c, $
  con $n^2 - n - 1 in C$ (es $x = n$). Luego ningún $c$ es cota superior (Definición 1).

  *Supremo y máximo.* No existen: por la Definición 2 el supremo es, en particular, una cota
  superior, y $C$ no tiene ninguna; y por la Definición 3 un máximo es un supremo que pertenece
  al conjunto.
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej04`][
  Los conjuntos son `Set.Ioc a b` (con la hipótesis `a < b`), `B = {x | ∃ n : ℕ, 0 < n ∧ x = 1 / 2 ^ n}`
  (el `0 < n` es porque en Lean $NN$ empieza en $0$ y en el curso en $1$), `B ∪ {0}` y
  `C = Set.range (fun x : ℝ => x ^ 2 - x - 1)`. Por ítem: (a) `ej4a_max : EsMax (Set.Ioc a b) b`
  (y `ej4a_sup`), `ej4a_inf : EsInf (Set.Ioc a b) a`, `ej4a_no_min : ¬ ∃ m, EsMin (Set.Ioc a b) m`;
  (b) `ej4b_max : EsMax B (1/2)`, `ej4b_inf : EsInf B 0`, `ej4b_no_min : ¬ ∃ m, EsMin B m`;
  (c) `ej4c_max : EsMax (B ∪ {0}) (1/2)`, `ej4c_min : EsMin (B ∪ {0}) 0`;
  (d) `ej4d_min : EsMin C (-5/4)`, `ej4d_no_acotadoSup : ¬ AcotadoSup C`,
  `ej4d_no_sup : ¬ ∃ s, EsSup C s`, `ej4d_no_max : ¬ ∃ m, EsMax C m`.
  Los casos "existe" usan `caract_sup_max` / `caract_inf_min` (Proposiciones 4 y 6) o la
  Definición 2 / 5 a mano; los casos "no existe" exhiben el mismo elemento que el texto (el punto
  medio, $1/2^(n+1)$, el natural $n >= abs(c) + 2$ de `arquimedes`). El Sublema 1 es
  `le_two_pow`, probado por inducción (no se usa `Nat.lt_two_pow_self`); en (b) el ínfimo usa
  `arquimedes2` (Proposición 1) y `one_div_le_one_div_of_le` (invertir una desigualdad entre
  positivos). No se usan `sSup`, `sInf`, `IsLUB` ni `IsGLB`. El único desvío es que en (d) la
  cuenta $n(n-1) - 1 >= n - 1 > c$ la cierra `nlinarith` a partir de $abs(c) + 2 <= n$ y
  $c <= abs(c)$.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 5

#enunciado[Ejercicio 5][
  Sean $A subset.eq B subset.eq RR$, con $A != nothing$. Probar las siguientes afirmaciones:
  #set enum(numbering: "(a)")
  + Si $B$ está acotado superiormente, entonces $A$ también lo está, y $op("sup") A <= op("sup") B$.
  + Si $B$ está acotado inferiormente, entonces $A$ también lo está, e $op("ínf") B <= op("ínf") A$.
  + Si $A$ no está acotado, entonces $B$ tampoco lo está.
]

#estrategia[Toda cota de $B$ es cota de $A$][
  Como $A subset.eq B$, cualquier cota (superior o inferior) de $B$ lo es también de $A$: eso da
  la acotación. Para comparar los extremos, el supremo de $B$ es una cota superior de $A$, y el
  supremo de $A$ es la *menor* de las cotas superiores de $A$ (Definición 2), así que
  $op("sup") A <= op("sup") B$; con ínfimos, igual pero al revés (Definición 5). El ítem (c) es el
  contrarrecíproco de "$B$ acotado $=>$ $A$ acotado", que sale de la primera mitad de (a) y (b).
]

// ---------------------------------------------------------------- (a)
#enunciado[Ejercicio 5 (a)][
  Si $B$ está acotado superiormente, entonces $A$ también lo está, y $op("sup") A <= op("sup") B$.
]

#resolucion[Propuesta: $A$ acotado superiormente y $op("sup") A <= op("sup") B$][
  *$A$ está acotado superiormente.* Por la Definición 1, hay $c in RR$ con $b <= c$ para todo
  $b in B$. Si $a in A$, entonces $a in B$ (porque $A subset.eq B$), así que $a <= c$. Luego $c$
  es cota superior de $A$ y $A$ está acotado superiormente.

  *Los supremos existen.* $A != nothing$ por hipótesis, y $B != nothing$ porque contiene a $A$.
  Ambos están acotados superiormente, así que por el Axioma de Completitud existen
  $s = op("sup") A$ y $t = op("sup") B$.

  *$s <= t$.* Por la Definición 2 (ítem a), $t$ es cota superior de $B$: $b <= t$ para todo
  $b in B$. Como todo $a in A$ está en $B$, también $a <= t$ para todo $a in A$: $t$ es cota
  superior de $A$. Y por la Definición 2 (ítem b) aplicada a $s = op("sup") A$, el supremo de $A$
  es menor o igual que cualquier cota superior de $A$; en particular $s <= t$.
]

// ---------------------------------------------------------------- (b)
#enunciado[Ejercicio 5 (b)][
  Si $B$ está acotado inferiormente, entonces $A$ también lo está, e $op("ínf") B <= op("ínf") A$.
]

#resolucion[Propuesta: $A$ acotado inferiormente e $op("ínf") B <= op("ínf") A$][
  Es el mismo argumento de (a) cambiando "cota superior" por "cota inferior", $<=$ por $>=$ en
  las cotas, la Definición 1 por la Definición 4, la Definición 2 por la Definición 5 y el Axioma
  de Completitud por el Teorema 2 (Completitud en términos de ínfimos). Escribimos los pasos.

  *$A$ está acotado inferiormente.* Por la Definición 4 hay $c in RR$ con $c <= b$ para todo
  $b in B$. Si $a in A$ entonces $a in B$, así que $c <= a$: $c$ es cota inferior de $A$.

  *Los ínfimos existen.* $A != nothing$ y $B supset.eq A$ también; ambos están acotados
  inferiormente, así que por el Teorema 2 existen $i = op("ínf") A$ y $j = op("ínf") B$.

  *$j <= i$.* Por la Definición 5 (ítem a), $j$ es cota inferior de $B$, y como $A subset.eq B$,
  $j <= a$ para todo $a in A$: $j$ es cota inferior de $A$. Por la Definición 5 (ítem b) aplicada
  a $i = op("ínf") A$, toda cota inferior de $A$ es menor o igual que $i$; en particular $j <= i$.
]

// ---------------------------------------------------------------- (c)
#enunciado[Ejercicio 5 (c)][
  Si $A$ no está acotado, entonces $B$ tampoco lo está.
]

#resolucion[Propuesta: $A$ no acotado $=>$ $B$ no acotado][
  "Acotado" quiere decir acotado superior *e* inferiormente (Definiciones 1 y 4). Probamos el
  contrarrecíproco: si $B$ está acotado, entonces $A$ está acotado.

  Supongamos $B$ acotado. Entonces $B$ está acotado superiormente, y por la primera parte de (a)
  $A$ está acotado superiormente; y $B$ está acotado inferiormente, y por la primera parte de (b)
  $A$ está acotado inferiormente. Luego $A$ está acotado.

  Por lo tanto, si $A$ no está acotado, $B$ no puede estar acotado (si lo estuviera, $A$ también).
  Notar que sólo se usaron cotas: no hace falta que existan supremos ni ínfimos.
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej05`][
  (a) `ej5a_acotado (hAB : A ⊆ B) (hB : AcotadoSup B) : AcotadoSup A` y
  `ej5a_sup (hAB : A ⊆ B) (hs : EsSup A s) (ht : EsSup B t) : s ≤ t`; `ej5a` las junta con la
  existencia de ambos supremos vía `axioma_completitud` (con `A.Nonempty` y `hne.mono hAB` para
  $B != nothing$). (b) `ej5b_acotado`, `ej5b_inf (hi : EsInf A i) (hj : EsInf B j) : j ≤ i`
  y `ej5b` (con `completitud_inf`, el Teorema 2). (c) `ej5c (hAB : A ⊆ B) : ¬ Acotado A → ¬ Acotado B`,
  que es exactamente el contrarrecíproco con `ej5a_acotado` y `ej5b_acotado` (`Acotado` es la
  conjunción `AcotadoSup ∧ AcotadoInf` de `Defs.lean`). Las desigualdades son una línea cada una:
  `hs.2 t (fun a ha => ht.1 a (hAB ha))` es literalmente "el sup de $B$ es cota superior de $A$,
  y el sup de $A$ es la menor". No se usan `csSup_le_csSup`, `BddAbove.mono` ni `sSup`/`sInf`.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 6

#enunciado[Ejercicio 6][
  Dados un conjunto de números reales $A$ y $c in RR$, denotamos $c A = {c a : a in A}$. Más
  aún, $-A$ denotará al conjunto $(-1) A$. Probar las siguientes afirmaciones:
  #set enum(numbering: "(a)")
  + Probar que si $A$ está acotado superiormente, entonces $-A$ está acotado inferiormente e
    $op("ínf")(-A) = -op("sup") A$.
  + Probar que si $c > 0$ y $A$ está acotado superiormente, entonces $c A$ está acotado
    superiormente y $op("sup")(c A) = c op("sup")(A)$.
]

#estrategia[Traducir cotas de un conjunto en cotas del otro][
  Multiplicar por $-1$ invierte las desigualdades y multiplicar por $c > 0$ las conserva. Eso
  convierte cada cota superior $s$ de $A$ en una cota inferior $-s$ de $-A$ (resp. una cota
  superior $c s$ de $c A$), y, al revés, cada cota inferior $t$ de $-A$ en una cota superior $-t$
  de $A$ (resp. cada cota superior $t$ de $c A$ en una cota superior $t / c$ de $A$). Con
  $s = op("sup") A$ la menor cota superior de $A$ (Definición 2) sale que $-s$ es la mayor cota
  inferior de $-A$ (Definición 5) y que $c s$ es la menor cota superior de $c A$. Todo se hace
  desde las Definiciones 1, 2, 4 y 5; no se cita la demostración del Teorema 2 (que es, de hecho,
  este ítem (a)); ni siquiera hace falta su enunciado.
]

// ---------------------------------------------------------------- (a)
#enunciado[Ejercicio 6 (a)][
  Si $A$ está acotado superiormente, entonces $-A$ está acotado inferiormente e
  $op("ínf")(-A) = -op("sup") A$.
]

#resolucion[Propuesta: $-A$ acotado inferiormente e $op("ínf")(-A) = -op("sup") A$][
  Recordemos que $-A = {-a : a in A}$: un elemento de $-A$ es un $y$ de la forma $y = -a$ con
  $a in A$. Suponemos (como en toda la práctica) $A != nothing$, con lo cual $-A != nothing$.

  *$-A$ está acotado inferiormente.* Sea $c$ una cota superior de $A$ (Definición 1): $a <= c$
  para todo $a in A$. Multiplicando por $-1$, $-c <= -a$ para todo $a in A$, es decir, $-c <= y$
  para todo $y in -A$. Luego $-c$ es cota inferior de $-A$ (Definición 4).

  *$-s$ es cota inferior de $-A$, donde $s = op("sup") A$.* El supremo existe por el Axioma de
  Completitud ($A != nothing$ y acotado superiormente). Como $s$ es cota superior de $A$
  (Definición 2, ítem a), el párrafo anterior con $c = s$ dice que $-s$ es cota inferior de $-A$.

  *$-s$ es la mayor cota inferior de $-A$.* Sea $t$ una cota inferior de $-A$: $t <= y$ para todo
  $y in -A$. Para cada $a in A$, $-a in -A$, así que $t <= -a$, y multiplicando por $-1$,
  $a <= -t$. Esto dice que $-t$ es cota superior de $A$. Por la Definición 2 (ítem b), el supremo
  es menor o igual que cualquier cota superior: $s <= -t$, es decir, $t <= -s$.

  Por la Definición 5, $-s = op("ínf")(-A)$, o sea $op("ínf")(-A) = -op("sup") A$.
]

// ---------------------------------------------------------------- (b)
#enunciado[Ejercicio 6 (b)][
  Si $c > 0$ y $A$ está acotado superiormente, entonces $c A$ está acotado superiormente y
  $op("sup")(c A) = c op("sup")(A)$.
]

#resolucion[Propuesta: $c A$ acotado superiormente y $op("sup")(c A) = c op("sup") A$][
  Es el argumento de (a) con tres cambios: se multiplica por $c > 0$ en lugar de por $-1$, lo que
  *conserva* las desigualdades en vez de invertirlas; por eso las cotas superiores de $A$ van a
  cotas *superiores* de $c A$ (y no inferiores), y el extremo que se obtiene es un supremo
  (Definición 2) y no un ínfimo (Definición 5); y para volver de $c A$ a $A$ se divide por $c$
  (que es $> 0$) en lugar de multiplicar por $-1$. Escribimos los pasos.

  Un elemento de $c A = {c a : a in A}$ es un $y$ de la forma $y = c a$ con $a in A$.

  *$c A$ está acotado superiormente.* Sea $d$ una cota superior de $A$: $a <= d$ para todo
  $a in A$. Como $c > 0$, multiplicar por $c$ conserva la desigualdad: $c a <= c d$ para todo
  $a in A$, es decir, $y <= c d$ para todo $y in c A$. Luego $c d$ es cota superior de $c A$
  (Definición 1).

  *$c s$ es cota superior de $c A$, donde $s = op("sup") A$* (existe por el Axioma de
  Completitud). Como $s$ es cota superior de $A$ (Definición 2, ítem a), el párrafo anterior con
  $d = s$ dice que $c s$ es cota superior de $c A$.

  *$c s$ es la menor cota superior de $c A$.* Sea $t$ una cota superior de $c A$: $y <= t$ para
  todo $y in c A$. Para cada $a in A$, $c a in c A$, así que $c a <= t$, y dividiendo por $c > 0$
  (que conserva la desigualdad), $a <= t / c$. Esto dice que $t / c$ es cota superior de $A$. Por
  la Definición 2 (ítem b), $s <= t / c$, y multiplicando por $c > 0$, $c s <= t$.

  Por la Definición 2, $c s = op("sup")(c A)$, o sea $op("sup")(c A) = c op("sup") A$.
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej06`][
  Los conjuntos se escriben como imágenes (`Set.image`): $-A$ es `(fun a => -a) '' A` y $c A$ es
  `(fun a => c * a) '' A`; un elemento de la imagen se destruye como `⟨a, ha, rfl⟩` ("un $a in A$
  y $y = f(a)$"), que es exactamente "un elemento de $-A$ es un $-a$ con $a in A$". (a)
  `cotaInf_neg (hs : CotaSup A s) : CotaInf (-A) (-s)` (el primer párrafo), `ej6a_acotado`,
  `ej6a_inf (hs : EsSup A s) : EsInf (-A) (-s)` (el tercer párrafo: de una cota inferior `t` se
  construye `CotaSup A (-t)` y se aplica `hs.2`), y `ej6a` las junta. (b) `cotaSup_smul`,
  `ej6b_acotado`, `ej6b_sup (hc : 0 < c) (hs : EsSup A s) : EsSup (c A) (c * s)` y `ej6b`; el paso
  "dividir por $c$" es `le_div_iff₀ hc` y "multiplicar por $c$" es `mul_le_mul_of_nonneg_left`.
  Lean no exige $A != nothing$: las Definiciones 2 y 5 se formalizan sin esa hipótesis, y el
  argumento no la usa. No se usan `Set.neg`, `IsLUB.neg`, `csSup_neg`, `Real.sSup_smul` ni
  `sSup`/`sInf`; tampoco `completitud_inf` (el Teorema 2).
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 7

#enunciado[Ejercicio 7][
  Probar, usando la definición de límite:
  #set enum(numbering: "(a)")
  + $lim_(n -> oo) (3 - 2n)/(n + 1) = -2$.
  + $lim_(n -> oo) (op("sen")(n))/n = 0$.
  + $lim_(n -> oo) (2^n - 3)/(2^n + 4) = 1$.
]

#estrategia[Calcular $abs(a_n - ell)$ exactamente, acotarla por $c/n$ y pedirle a Arquímedes el $n_0$][
  Los tres ítems siguen la Definición 7 al pie de la letra: se fija $epsilon > 0$, se calcula
  $abs(a_n - ell)$ con una cuenta exacta (en (a) da $5/(n + 1)$, en (c) da $7/(2^n + 4)$, en (b)
  es $abs(op("sen")(n))/n$) y se la acota por algo de la forma $c/n$. En (a) se despeja
  directamente $n + 1 > 5/epsilon$ y el Teorema 1 (Principio de Arquímedes) da el $n_0$; en (b)
  y (c) primero hay que acotar el numerador ($abs(op("sen")(n)) <= 1$) o el denominador
  ($2^n >= n$, un sublema por inducción), y después la Proposición 1 (Principio de Arquímedes 2)
  da un $n_0$ con $1/n_0 < epsilon/c$. En los tres casos la cuenta final es
  $abs(a_n - ell) <= c/n <= c/n_0 < epsilon$ para todo $n >= n_0$.
]

// ---------------------------------------------------------------- (a)
#enunciado[Ejercicio 7 (a)][
  $lim_(n -> oo) (3 - 2n)/(n + 1) = -2$.
]

#resolucion[Propuesta: $abs(a_n + 2) = 5/(n + 1)$ y el $n_0$ sale del Teorema 1][
  Sea $a_n = (3 - 2n)/(n + 1)$ y $ell = -2$. Primero la cuenta exacta: para todo $n in NN$
  (y de hecho para todo $n >= 0$, porque $n + 1 > 0$),
  $ a_n - (-2) = (3 - 2n)/(n + 1) + 2 = (3 - 2n + 2(n + 1))/(n + 1) = 5/(n + 1) > 0, $
  de modo que
  $ abs(a_n - (-2)) = 5/(n + 1). $

  Sea ahora $epsilon > 0$. Como $n + 1 > 0$ y $epsilon > 0$, multiplicando por el positivo
  $(n + 1)/epsilon$ se tiene la equivalencia
  $ 5/(n + 1) < epsilon <=> 5/epsilon < n + 1, $
  así que basta conseguir que $n + 1 > 5/epsilon$ a partir de algún $n_0$. Por el Teorema 1
  (Principio de Arquímedes) aplicado a $x = 5/epsilon in RR$, existe $n_0 in NN$ tal que
  $5/epsilon <= n_0$. Si $n >= n_0$, entonces
  $ n + 1 > n >= n_0 >= 5/epsilon, $
  luego $epsilon (n + 1) > 5$ y, dividiendo por $n + 1 > 0$,
  $ abs(a_n - (-2)) = 5/(n + 1) < epsilon quad "para todo " n >= n_0. $
  Esto es exactamente la Definición 7 con $ell = -2$: $lim_(n -> oo) a_n = -2$.
]

// ---------------------------------------------------------------- (b)
#enunciado[Ejercicio 7 (b)][
  $lim_(n -> oo) (op("sen")(n))/n = 0$.
]

#resolucion[Propuesta: $abs(a_n - 0) <= 1/n$ y el $n_0$ sale de la Proposición 1][
  Sea $a_n = (op("sen")(n))/n$ y $ell = 0$. Usamos el hecho de base $abs(op("sen")(x)) <= 1$ para
  todo $x in RR$ (no se puede despejar $n$ de $abs(op("sen")(n))/n < epsilon$: hay que acotar el
  numerador primero). Para todo $n in NN$ (es decir, $n >= 1$, de modo que $n > 0$ y
  $abs(n) = n$),
  $ abs(a_n - 0) = abs((op("sen")(n))/n) = abs(op("sen")(n))/n <= 1/n. $

  Sea $epsilon > 0$. Por la Proposición 1 (Principio de Arquímedes 2) aplicada a $y = epsilon$,
  existe $n_0 in NN$ tal que $0 < 1/n_0 < epsilon$. Si $n >= n_0$, como $0 < n_0 <= n$,
  tomar inversos invierte la desigualdad (hecho de base del orden de $RR$): $1/n <= 1/n_0$.
  Entonces
  $ abs(a_n - 0) <= 1/n <= 1/n_0 < epsilon quad "para todo " n >= n_0, $
  que es la Definición 7 con $ell = 0$: $lim_(n -> oo) (op("sen")(n))/n = 0$.
]

// ---------------------------------------------------------------- (c)
#enunciado[Ejercicio 7 (c)][
  $lim_(n -> oo) (2^n - 3)/(2^n + 4) = 1$.
]

#sublema(titulo: "Sublema: n ≤ 2ⁿ para todo n ∈ ℕ (deducción propia, por inducción)")[
  Para $n = 1$: $1 <= 2 = 2^1$ (y también vale para $n = 0$: $0 <= 1 = 2^0$, que es el caso
  base que usa Lean). Paso inductivo: si $n <= 2^n$, entonces, como $2^n >= 1$,
  $ n + 1 <= 2^n + 1 <= 2^n + 2^n = 2 dot 2^n = 2^(n + 1). $
  Por inducción, $n <= 2^n$ para todo $n in NN$. En particular, como $n > 0$, también
  $1/2^n <= 1/n$ (tomar inversos de positivos invierte la desigualdad). $qed$
]

#resolucion[Propuesta: $abs(a_n - 1) <= 7/n$ y el $n_0$ sale de la Proposición 1][
  Sea $a_n = (2^n - 3)/(2^n + 4)$ y $ell = 1$. La cuenta exacta, válida para todo $n$ porque
  $2^n + 4 > 0$:
  $ a_n - 1 = (2^n - 3)/(2^n + 4) - (2^n + 4)/(2^n + 4) = (2^n - 3 - 2^n - 4)/(2^n + 4) = (-7)/(2^n + 4), $
  de modo que
  $ abs(a_n - 1) = 7/(2^n + 4). $

  Ahora acotamos el denominador por abajo para que quede algo de la forma $c/n$: como
  $2^n + 4 > 2^n >= n > 0$ (la segunda desigualdad es el Sublema), tomando inversos
  $ abs(a_n - 1) = 7/(2^n + 4) < 7/2^n <= 7/n quad "para todo " n in NN. $

  Sea $epsilon > 0$. Como $epsilon/7 > 0$, la Proposición 1 (Principio de Arquímedes 2) aplicada
  a $y = epsilon/7$ da $n_0 in NN$ con $0 < 1/n_0 < epsilon/7$. Si $n >= n_0$, entonces
  $1/n <= 1/n_0$ (inversos de positivos) y
  $ abs(a_n - 1) <= 7/n = 7 dot 1/n <= 7 dot 1/n_0 < 7 dot epsilon/7 = epsilon
    quad "para todo " n >= n_0. $
  Por la Definición 7, $lim_(n -> oo) a_n = 1$.
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej07`][
  `ej7a : Converge (fun n : ℕ => (3 - 2 * (n : ℝ)) / (n + 1)) (-2)`,
  `ej7b : Converge (fun n : ℕ => Real.sin n / n) 0` y
  `ej7c : Converge (fun n : ℕ => ((2 : ℝ) ^ n - 3) / (2 ^ n + 4)) 1`, con `Converge` desplegada
  (`intro ε hε`, `obtain ⟨n₀, _⟩ := arquimedes (5 / ε)` en (a) y `arquimedes2` en (b) y (c),
  `refine ⟨n₀, fun n hn => ?_⟩`) y la misma cadena de desigualdades que arriba: la cuenta exacta
  de $a_n - ell$ es un `field_simp; ring`, y las cotas son `div_le_div_of_nonneg_right`,
  `div_le_div_of_nonneg_left`, `one_div_le_one_div_of_le` y `linarith`. El hecho de base
  $abs(op("sen")(x)) <= 1$ es `Real.abs_sin_le_one`; el Sublema $n <= 2^n$ se prueba localmente
  por inducción (`le_two_pow`, con `Nat.one_le_two_pow` para $1 <= 2^n$), no se usa
  `Nat.lt_two_pow_self`. No se pasa por `Tendsto`.

  Desvíos: en Lean los índices empiezan en $n = 0$. En (a) y (c) la cuenta vale igual
  ($n + 1 > 0$ y $2^n + 4 > 0$ también para $n = 0$). En (b), `Real.sin 0 / 0 = 0` por la
  convención `x / 0 = 0` de Lean, pero no hace falta tratarlo aparte: `arquimedes2` entrega
  `0 < 1 / n₀`, que fuerza $n_0 >= 1$ (`one_div_pos`), así que los $n >= n_0$ que se miran son
  todos $>= 1$, como en el curso.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 8

#enunciado[Ejercicio 8][
  Sean $(x_n)_(n in NN)$ y $(a_n)_(n in NN)$ sucesiones de números reales. Probar que si
  $abs(x_n - ell) <= a_n$ para todo $n in NN$ y $a_n ->_(n -> oo) 0$ entonces
  $x_n ->_(n -> oo) ell$.
]

#estrategia[El $n_0$ de $a_n -> 0$ sirve tal cual para $x_n -> ell$][
  Es el lema general detrás de los ítems (b) y (c) del Ejercicio 7: si la distancia
  $abs(x_n - ell)$ está dominada por algo que tiende a $0$, también tiende a $0$. Dado
  $epsilon > 0$, la Definición 7 para $a_n -> 0$ da un $n_0$ con $abs(a_n - 0) < epsilon$ a partir
  de $n_0$; y como $abs(x_n - ell) <= a_n <= abs(a_n) = abs(a_n - 0)$, el mismo $n_0$ funciona
  para $x_n$. No hace falta ninguna otra herramienta.
]

#resolucion[Propuesta: $abs(x_n - ell) <= a_n <= abs(a_n - 0) < epsilon$ desde el mismo $n_0$][
  Sea $epsilon > 0$. Como $a_n -> 0$, por la Definición 7 (con $ell = 0$) existe $n_0 in NN$ tal
  que
  $ abs(a_n - 0) < epsilon quad "para todo " n >= n_0. $
  Veamos que ese mismo $n_0$ sirve para $(x_n)_(n in NN)$ y $ell$. Sea $n >= n_0$. Por
  hipótesis $abs(x_n - ell) <= a_n$; además todo real es menor o igual que su valor absoluto
  (hecho de base), así que $a_n <= abs(a_n) = abs(a_n - 0)$. Encadenando,
  $ abs(x_n - ell) <= a_n <= abs(a_n - 0) < epsilon. $
  (De paso: $a_n >= abs(x_n - ell) >= 0$, así que en realidad $a_n = abs(a_n)$, pero no hace
  falta usarlo.) Como $epsilon > 0$ era arbitrario, la Definición 7 dice que
  $x_n ->_(n -> oo) ell$.
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej08`][
  `ej8 {x a : ℕ → ℝ} {l : ℝ} (h : ∀ n, |x n - l| ≤ a n) (ha : Converge a 0) : Converge x l`.
  La prueba despliega `Converge`: `intro ε hε`, `obtain ⟨n₀, hn₀⟩ := ha ε hε`, se devuelve el
  mismo `n₀` y se cierra con el `calc` de tres pasos `h n`, `le_abs_self (a n)` y `hn₀ n hn`
  (después de `rw [sub_zero]`). No se usa `squeeze_zero` ni `Tendsto`. Como las hipótesis valen
  para todo $n$ y el $n_0$ es el mismo, que en Lean los índices empiecen en $0$ no cambia nada.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 9

#enunciado[Ejercicio 9][
  Si $(x_n)_(n in NN)$ e $(y_n)_(n in NN)$ son sucesiones de números reales tales que
  $x_n ->_(n -> oo) ell_1$ e $y_n ->_(n -> oo) ell_2$, probar que
  $x_n + y_n ->_(n -> oo) ell_1 + ell_2$ para el caso en que:
  #set enum(numbering: "(a)")
  + $ell_1, ell_2 in RR$.
  + $ell_1 in RR$ y $ell_2 = oo$.
  + $ell_1 = +oo = ell_2$.
  + Pensar por qué no vale en el caso en que $ell_1 = +oo$ y $ell_2 = -oo$. Dar un contraejemplo
    para este caso.
]

#estrategia[Repartir el $epsilon$ (o el $M$) entre las dos sucesiones y tomar $n_0 = op("máx")(n_1, n_2)$][
  En los tres casos positivos la receta es la misma: cada hipótesis da un umbral ($n_1$ para
  $x_n$, $n_2$ para $y_n$) y a partir de $n_0 = op("máx")(n_1, n_2)$ valen las dos cotas a la
  vez. En (a) se reparte $epsilon/2 + epsilon/2$ y se usa la desigualdad triangular; en (c) se
  reparte $M/2 + M/2$. En (b) la sucesión convergente aporta una *cota inferior* $x_n > ell_1 - 1$
  (Definición 7 con $epsilon = 1$) y la divergente aporta el resto, $y_n > M + 1 - ell_1$
  (Definición 8, con un $M' > 0$ adecuado). En (d) ese esquema se rompe: $y_n -> -oo$ no da
  ninguna cota inferior de $y_n$, y los contraejemplos muestran que la suma puede hacer cualquier
  cosa. El ítem (a) es el ítem b de la Proposición 6 (Álgebra de límites), que `apuntes.typ`
  deja como ejercicio de la guía: acá se demuestra desde la Definición 7, sin citarlo.
]

// ---------------------------------------------------------------- (a)
#enunciado[Ejercicio 9 (a)][
  $ell_1, ell_2 in RR$: si $x_n -> ell_1$ e $y_n -> ell_2$, entonces $x_n + y_n -> ell_1 + ell_2$.
]

#resolucion[Propuesta: $epsilon/2 + epsilon/2$ con $n_0 = op("máx")(n_1, n_2)$][
  Sea $epsilon > 0$. Como $epsilon/2 > 0$, la Definición 7 para $x_n -> ell_1$ da $n_1 in NN$
  con $abs(x_n - ell_1) < epsilon/2$ para todo $n >= n_1$, y para $y_n -> ell_2$ da $n_2 in NN$
  con $abs(y_n - ell_2) < epsilon/2$ para todo $n >= n_2$. Sea $n_0 = op("máx")(n_1, n_2)$. Si
  $n >= n_0$, entonces $n >= n_1$ y $n >= n_2$, así que valen las dos cotas y, por la desigualdad
  triangular (hecho de base),
  $ abs((x_n + y_n) - (ell_1 + ell_2)) = abs((x_n - ell_1) + (y_n - ell_2))
    <= abs(x_n - ell_1) + abs(y_n - ell_2) < epsilon/2 + epsilon/2 = epsilon. $
  Como $epsilon > 0$ era arbitrario, la Definición 7 dice que $x_n + y_n -> ell_1 + ell_2$.
]

// ---------------------------------------------------------------- (b)
#enunciado[Ejercicio 9 (b)][
  $ell_1 in RR$ y $ell_2 = +oo$: si $x_n -> ell_1$ e $y_n -> +oo$, entonces $x_n + y_n -> +oo$.
]

#resolucion[Propuesta: $x_n > ell_1 - 1$ desde $n_1$ e $y_n > M + 1 - ell_1$ desde $n_2$][
  Sea $M > 0$. Hay que encontrar $n_0$ con $x_n + y_n > M$ para todo $n >= n_0$ (Definición 8).

  _Cota inferior de $x_n$._ Por la Definición 7 con $epsilon = 1$, existe $n_1 in NN$ tal que
  $abs(x_n - ell_1) < 1$ para todo $n >= n_1$; en particular $x_n - ell_1 > -1$, es decir
  $ x_n > ell_1 - 1 quad "para todo " n >= n_1. $

  _Cota inferior de $y_n$._ Queremos $y_n > M + 1 - ell_1$, pero la Definición 8 sólo se puede
  aplicar a un número *positivo*, y $M + 1 - ell_1$ podría ser $<= 0$ (si $ell_1 >= M + 1$). Por
  eso tomamos
  $ M' = op("máx")(M + 1 - ell_1, 1) >= 1 > 0. $
  Por la Definición 8 para $y_n -> +oo$ aplicada a $M'$, existe $n_2 in NN$ tal que
  $y_n > M' >= M + 1 - ell_1$ para todo $n >= n_2$.

  _Conclusión._ Sea $n_0 = op("máx")(n_1, n_2)$. Si $n >= n_0$ valen las dos cotas y, sumándolas,
  $ x_n + y_n > (ell_1 - 1) + (M + 1 - ell_1) = M. $
  Como $M > 0$ era arbitrario, $x_n + y_n -> +oo$ por la Definición 8.
]

// ---------------------------------------------------------------- (c)
#enunciado[Ejercicio 9 (c)][
  $ell_1 = +oo = ell_2$: si $x_n -> +oo$ e $y_n -> +oo$, entonces $x_n + y_n -> +oo$.
]

#resolucion[Propuesta: $M/2 + M/2$ con $n_0 = op("máx")(n_1, n_2)$][
  Sea $M > 0$. Como $M/2 > 0$, la Definición 8 para $x_n -> +oo$ da $n_1 in NN$ con
  $x_n > M/2$ para todo $n >= n_1$, y para $y_n -> +oo$ da $n_2 in NN$ con $y_n > M/2$ para todo
  $n >= n_2$. Sea $n_0 = op("máx")(n_1, n_2)$. Si $n >= n_0$ valen las dos cotas y
  $ x_n + y_n > M/2 + M/2 = M. $
  Como $M > 0$ era arbitrario, $x_n + y_n -> +oo$ por la Definición 8.
]

// ---------------------------------------------------------------- (d)
#enunciado[Ejercicio 9 (d)][
  Pensar por qué no vale en el caso en que $ell_1 = +oo$ y $ell_2 = -oo$. Dar un contraejemplo
  para este caso.
]

#sublema(titulo: "Sublema: n → +∞, 2n → +∞, −n → −∞ y −2n → −∞ (deducción propia)")[
  Sea $M > 0$. Por el Teorema 1 (Principio de Arquímedes) aplicado a $x = M + 1$, existe
  $n_0 in NN$ con $M + 1 <= n_0$. Si $n >= n_0$, entonces $n >= M + 1 > M$. De ahí, para todo
  $n >= n_0$:
  $ 2n >= n > M, quad -n < -M, quad -2n <= -n < -M $
  (la última usa $n >= 0$). Por la Definición 8, $n -> +oo$, $2n -> +oo$, $-n -> -oo$ y
  $-2n -> -oo$. $qed$
]

#resolucion[Propuesta: no hay conclusión posible; tres contraejemplos distintos][
  _Por qué falla el argumento._ En (b) y (c) la suma se controla porque *las dos* sucesiones
  aportan una cota inferior a partir de algún $n$: $x_n > "algo"$ e $y_n > "algo"$, y sumar cotas
  inferiores da una cota inferior de $x_n + y_n$. Si $y_n -> -oo$, la Definición 8 dice
  $y_n < -M'$ a partir de un $n_2$: es una cota *superior*, no inferior, y de hecho $y_n$ no está
  acotada inferiormente. Entonces las hipótesis $x_n > M$ e $y_n < -M'$ no dicen nada sobre el
  signo ni el tamaño de $x_n + y_n$: es una "indeterminación $oo - oo$", y lo que pase depende de
  cuán rápido crece cada una.

  _Contraejemplos._ En los tres pares, $x_n -> +oo$ e $y_n -> -oo$ por el Sublema, y sin embargo:

  + $x_n = n$, $y_n = -n$: $x_n + y_n = 0$ para todo $n$, y la sucesión constante $0$ converge a
    $0$ (Definición 7: $abs(0 - 0) = 0 < epsilon$ para todo $n$, con cualquier $n_0$).
  + $x_n = 2n$, $y_n = -n$: $x_n + y_n = n -> +oo$ (Sublema).
  + $x_n = n$, $y_n = -2n$: $x_n + y_n = -n -> -oo$ (Sublema).

  Estos tres comportamientos son incompatibles entre sí (por ejemplo, una sucesión que converge
  a $0$ cumple $abs(a_n) < 1$ a partir de un $n_0$, mientras que una que diverge a $+oo$ cumple
  $a_n > 1$ a partir de otro; las dos cosas no pueden pasar a la vez para $n$ grande), así que no
  hay ningún enunciado general de la forma "$x_n + y_n -> ell$" que valga con las hipótesis
  $ell_1 = +oo$, $ell_2 = -oo$: la primera pareja ya es el contraejemplo pedido.
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej09`][
  `ej9a (hx : Converge x l₁) (hy : Converge y l₂) : Converge (fun n => x n + y n) (l₁ + l₂)`,
  `ej9b (hx : Converge x l₁) (hy : DivergeMasInf y) : DivergeMasInf (fun n => x n + y n)`,
  `ej9c (hx : DivergeMasInf x) (hy : DivergeMasInf y) : DivergeMasInf (fun n => x n + y n)`, y
  para (d) tres teoremas de existencia, `ej9d_converge`, `ej9d_masInf` y `ej9d_menosInf`, de la
  forma `∃ x y : ℕ → ℝ, DivergeMasInf x ∧ DivergeMenosInf y ∧ P (fun n => x n + y n)` con
  `P` igual a `Converge · 0`, `DivergeMasInf` y `DivergeMenosInf` respectivamente, con los testigos
  $(n, -n)$, $(2n, -n)$ y $(n, -2n)$ del texto.

  Todo se hace desplegando `Converge` y `DivergeMasInf` / `DivergeMenosInf`: en (a) el mismo
  $n_0 = $ `max n₁ n₂`, `abs_add_le` para la triangular y `linarith`; en (b) `hx 1 one_pos`,
  `abs_lt` para pasar de $abs(x_n - ell_1) < 1$ a $x_n > ell_1 - 1$, y el mismo
  `M' = max (M + 1 - l₁) 1` con `le_max_right` para ver $M' > 0$; en (c) `M / 2`. El ítem (a)
  **no** usa `algebra_limites_add` (es el ítem b de la Proposición 6, excluido por circularidad)
  ni `Filter.Tendsto.add`. El Sublema es `exists_nat_gt_of_ge` (Teorema 1, `arquimedes (M + 1)`)
  y de él salen `divergeMasInf_id`, `divergeMasInf_two_mul`, `divergeMenosInf_neg_id` y
  `divergeMenosInf_neg_two_mul`; la suma de cada par se reescribe con `funext; ring`. No se pasa
  por `Tendsto` en ningún ítem.

  Desvío: en Lean los índices empiezan en $n = 0$. En (a)-(c) no interviene; en el Sublema la
  desigualdad $-2n <= -n$ usa $n >= 0$, que vale también para $n = 0$, y el $n_0$ que da
  `arquimedes (M + 1)` es el mismo.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 10

#enunciado[Ejercicio 10][
  Sean $(x_n)_(n in NN), (y_n)_(n in NN)$ sucesiones de números reales tales que
  $x_n ->_(n -> oo) ell_1$ e $y_n ->_(n -> oo) ell_2$. Probar que si $x_n <= y_n$ para todo $n$,
  entonces $ell_1 <= ell_2$.
]
#estrategia[Por el absurdo: separar los dos límites con $epsilon = (ell_1 - ell_2) / 2$][
  Si fuera $ell_1 > ell_2$, el punto medio $(ell_1 + ell_2) / 2$ separa a los dos límites: con
  $epsilon = (ell_1 - ell_2) / 2$, los $x_n$ terminan por encima de $ell_1 - epsilon$ y los $y_n$
  por debajo de $ell_2 + epsilon$, y esos dos números son el mismo. Entonces, para $n$ grande,
  $x_n > y_n$, contra la hipótesis. Todo sale de la Definición 7 aplicada dos veces y de tomar
  $n_0 = op("máx")(n_1, n_2)$ para que las dos cotas valgan a la vez.
]

#resolucion[Propuesta: $ell_1 <= ell_2$][
  Supongamos, por el absurdo, que $ell_1 > ell_2$. Entonces
  $ epsilon = (ell_1 - ell_2) / 2 > 0, quad "y además" quad ell_1 - epsilon = (ell_1 + ell_2) / 2 = ell_2 + epsilon. $

  Como $x_n -> ell_1$, por la Definición 7 (Convergencia de Sucesiones) con este $epsilon$ existe
  $n_1 in NN$ tal que $abs(x_n - ell_1) < epsilon$ para todo $n >= n_1$. Del mismo modo, como
  $y_n -> ell_2$, existe $n_2 in NN$ tal que $abs(y_n - ell_2) < epsilon$ para todo $n >= n_2$.

  Sea $n_0 = op("máx")(n_1, n_2)$. Para $n = n_0$ valen las dos desigualdades a la vez. De
  $abs(x_(n_0) - ell_1) < epsilon$ se deduce $-epsilon < x_(n_0) - ell_1$, es decir
  $ x_(n_0) > ell_1 - epsilon, $
  y de $abs(y_(n_0) - ell_2) < epsilon$ se deduce $y_(n_0) - ell_2 < epsilon$, es decir
  $ y_(n_0) < ell_2 + epsilon. $
  Juntando las dos con la igualdad $ell_1 - epsilon = ell_2 + epsilon$,
  $ y_(n_0) < ell_2 + epsilon = ell_1 - epsilon < x_(n_0), $
  o sea $x_(n_0) > y_(n_0)$. Pero por hipótesis $x_n <= y_n$ para todo $n$, en particular
  $x_(n_0) <= y_(n_0)$: absurdo. Luego $ell_1 <= ell_2$. $qed$
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej10`][
  `ej10 {x y : ℕ → ℝ} {l₁ l₂ : ℝ} (hx : Converge x l₁) (hy : Converge y l₂) (hxy : ∀ n, x n ≤ y n) : l₁ ≤ l₂`.
  La prueba es la de arriba, paso por paso: `by_contra` y `push Not` dan $ell_2 < ell_1$, se
  aplica `hx` y `hy` con $epsilon = (ell_1 - ell_2) / 2$, se evalúan en `max n₁ n₂` y
  `abs_sub_lt_iff` desarma los dos valores absolutos; `linarith` cierra con $x_(n_0) <= y_(n_0)$.

  Este ejercicio es el ítem e de la Proposición 6 (Álgebra de límites), así que *no* se cita esa
  proposición (ni `algebra_limites_le` en Lean): se demuestra desde la Definición 7. En Lean
  tampoco se usa `le_of_tendsto_of_tendsto` ni `Filter.Tendsto`. La hipótesis del ejercicio es
  "para todo $n$"; el mismo argumento vale si $x_n <= y_n$ sólo desde algún $n_0'$ (basta tomar
  $n_0 = op("máx")(n_1, n_2, n_0')$), que es como lo enuncia la Proposición 6.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 11

#enunciado[Ejercicio 11][
  Si $(x_n)_(n in NN)$ e $(y_n)_(n in NN)$ son sucesiones de números reales tales que
  $(x_n)_(n in NN)$ converge a $0$ e $(y_n)_(n in NN)$ está acotada, probar que
  $(x_n y_n)_(n in NN)$ converge a $0$.
]
#estrategia[Acotar $abs(x_n y_n) <= M abs(x_n)$ y pedirle a $abs(x_n)$ que sea menor que $epsilon / M$][
  La sucesión acotada aporta una constante $M > 0$ con $abs(y_n) <= M$ para todo $n$
  (Definición 9). Entonces $abs(x_n y_n) = abs(x_n) abs(y_n) <= M abs(x_n)$, y como $x_n -> 0$
  podemos hacer $abs(x_n)$ tan chico como queramos: lo pedimos menor que $epsilon / M$. Es la
  misma cuenta que el caso $b = 0$ de la demostración del ítem c de la Proposición 6, pero acá
  no hace falta la Proposición 7 porque la cota $M$ ya viene en la hipótesis.
]

#resolucion[Propuesta: $x_n y_n -> 0$][
  Como $(y_n)_(n in NN)$ está acotada, por la Definición 9 (Sucesión Acotada) existe $M > 0$ tal
  que $abs(y_n) <= M$ para todo $n in NN$.

  Sea $epsilon > 0$. Como $M > 0$, el número $epsilon / M$ es positivo, así que por la
  Definición 7 (Convergencia de Sucesiones) aplicada a $x_n -> 0$ con $epsilon / M$ existe
  $n_0 in NN$ tal que
  $ abs(x_n - 0) = abs(x_n) < epsilon / M quad "para todo" n >= n_0. $

  Con ese $n_0$, para todo $n >= n_0$ tenemos
  $ abs(x_n y_n - 0) = abs(x_n y_n) = abs(x_n) abs(y_n) <= abs(x_n) dot M < epsilon / M dot M = epsilon. $
  En el "$<=$" usamos $abs(y_n) <= M$ y que $abs(x_n) >= 0$ (multiplicar una desigualdad por un
  número no negativo la conserva); en el "$<$" usamos $abs(x_n) < epsilon / M$ y $M > 0$.
  Esto es exactamente la Definición 7 para $x_n y_n -> 0$. $qed$
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej11`][
  `ej11 {x y : ℕ → ℝ} (hx : Converge x 0) (hy : Acotada y) : Converge (fun n => x n * y n) 0`.
  Se destruye `hy` en `M`, `0 < M` y `|y n| ≤ M`; dado $epsilon$, se aplica `hx` con `ε / M`
  (`div_pos`) y el mismo $n_0$ sirve; la cuenta es un `calc` con `abs_mul`,
  `mul_le_mul_of_nonneg_left` y `lt_div_iff₀` (que traduce $abs(x_n) < epsilon / M$ en
  $abs(x_n) dot M < epsilon$). No se usa la Proposición 7 (`convergente_acotada`), ni el ítem c
  de la Proposición 6 (`algebra_limites_mul`), ni ningún lema `Tendsto`: sólo las Definiciones
  7 y 9. No hay desvíos respecto del texto.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 12

#enunciado[Ejercicio 12][
  Sea $(x_n)_(n in NN) subset.eq RR$ decreciente. Probar que:
  #set enum(numbering: "(a)")
  + Si $(x_n)_(n in NN)$ es acotada inferiormente, entonces tiene límite y
    $ lim_(n -> oo) x_n = op("ínf")\{x_n : n in NN\}. $
  + Si $(x_n)_(n in NN)$ es no acotada inferiormente, entonces $x_n ->_(n -> oo) -oo$.
]
#estrategia[El espejo de la Proposición 8, con ínfimos en lugar de supremos][
  Llamamos $X = {x_n : n in NN}$. En (a), el Teorema 2 garantiza que existe $i = op("ínf")(X)$,
  y la Proposición 5 (Equivalencia de Ínfimo) da, para cada $epsilon > 0$, un término
  $x_(n_0) < i + epsilon$. Como la sucesión es decreciente, todos los términos posteriores quedan
  encajados: $i <= x_n <= x_(n_0) < i + epsilon$ para $n >= n_0$. En (b) el cuantificador es el
  de la Definición 8: dado $M > 0$, el número $-M$ no puede ser cota inferior, así que algún
  $x_(n_0) < -M$ y, otra vez por decreciente, $x_n <= x_(n_0) < -M$ de ahí en adelante. Las dos
  veces hace falta "$x_n <= x_m$ si $n >= m$", que es el sublema de abajo.

  *Sobre la hipótesis "decreciente".* Tomamos la Definición 10 en su primera forma:
  $x_(n+1) <= x_n$ *para todo* $n in NN$ (así está también en `Defs.lean`). La Definición 10
  admite además "a partir de algún $n_0$", pero con esa lectura el ítem (a) es falso tal como está
  escrito: la sucesión $x_1 = -10$, $x_n = 1 / n$ para $n >= 2$ es decreciente a partir de
  $n_0 = 2$, está acotada inferiormente, converge a $0$, y sin embargo
  $op("ínf")\{x_n : n in NN\} = -10 != 0$. Con monotonía desde $n_0$ lo que vale es
  $lim x_n = op("ínf")\{x_n : n >= n_0\}$, y el ítem (b) sigue valiendo igual (el argumento
  sólo usa los índices $n >= n_0$).
]

#sublema(titulo: "Sublema (deducción propia): una decreciente lo es entre índices cualesquiera")[
  Si $(x_n)_(n in NN)$ es decreciente (es decir, $x_(k+1) <= x_k$ para todo $k$) y $m <= n$,
  entonces $x_n <= x_m$.

  *Prueba.* Fijado $m$, por inducción en $n >= m$. Si $n = m$ es $x_m <= x_m$. Si vale
  $x_n <= x_m$ para un $n >= m$, entonces $x_(n+1) <= x_n <= x_m$, donde la primera desigualdad es
  la Definición 10 en $k = n$. $qed$
]

// ---------------------------------------------------------------- (a)
#enunciado[Ejercicio 12 (a)][
  Si $(x_n)_(n in NN)$ es acotada inferiormente, entonces tiene límite y
  $lim_(n -> oo) x_n = op("ínf")\{x_n : n in NN\}$.
]
#resolucion[Propuesta: $x_n -> op("ínf")\{x_n : n in NN\}$][
  Sea $X = {x_n : n in NN} subset.eq RR$. Es no vacío ($x_1 in X$) y, por hipótesis, acotado
  inferiormente. Por el Teorema 2 (Completitud en términos de ínfimos) existe $i = op("ínf")(X)$.
  Veamos que $x_n -> i$ por la Definición 7.

  Sea $epsilon > 0$. Por la Proposición 5 (Equivalencia de Ínfimo), como $i = op("ínf")(X)$,
  existe un elemento de $X$ menor que $i + epsilon$; los elementos de $X$ son los términos de la
  sucesión, así que existe $n_0 in NN$ tal que
  $ x_(n_0) < i + epsilon. $

  Sea $n >= n_0$. Por un lado $i <= x_n$, porque $i$ es cota inferior de $X$ y $x_n in X$
  (Definición 5, ítem a). Por el otro, $x_n <= x_(n_0)$ por el Sublema (con $m = n_0$). Entonces
  $ 0 <= x_n - i <= x_(n_0) - i < epsilon, $
  y por lo tanto $abs(x_n - i) = x_n - i < epsilon$. Esto vale para todo $n >= n_0$, que es la
  Definición 7 de $x_n -> i$. Así, $(x_n)_(n in NN)$ tiene límite y
  $lim_(n -> oo) x_n = i = op("ínf")\{x_n : n in NN\}$. $qed$
]

// ---------------------------------------------------------------- (b)
#enunciado[Ejercicio 12 (b)][
  Si $(x_n)_(n in NN)$ es no acotada inferiormente, entonces $x_n ->_(n -> oo) -oo$.
]
#resolucion[Propuesta: $x_n -> -oo$][
  Usamos la Definición 8 (Divergencia de Sucesiones). Sea $M > 0$. Como
  $X = {x_n : n in NN}$ no está acotado inferiormente, ningún número real es cota inferior de $X$
  (Definición 4); en particular $-M$ no lo es. Negar "$-M <= x$ para todo $x in X$" da que existe
  $x in X$ con $x < -M$, es decir, existe $n_0 in NN$ tal que
  $ x_(n_0) < -M. $

  Sea $n >= n_0$. Por el Sublema, $x_n <= x_(n_0)$, y entonces
  $ x_n <= x_(n_0) < -M. $
  Encontramos, para cada $M > 0$, un $n_0$ tal que $x_n < -M$ para todo $n >= n_0$: es la
  Definición 8 de $x_n -> -oo$. $qed$
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej12`][
  Con `hd : Decreciente x` (`∀ n, x (n + 1) ≤ x n`):
  `ej12a (hd) (hb : AcotadoInf (Set.range x)) : ∃ i, EsInf (Set.range x) i ∧ Converge x i` y
  `ej12b (hd) (hb : ¬ AcotadoInf (Set.range x)) : DivergeMenosInf x`. El Sublema es
  `decreciente_le (hd) (h : m ≤ n) : x n ≤ x m`, por inducción sobre la prueba de `m ≤ n`.
  En (a) el ínfimo viene de `completitud_inf` (Teorema 2) y el término $x_(n_0)$ de
  `equiv_inf` (Proposición 5, legítima acá: el ejercicio circular con ella es el 3); `abs_lt` y
  `linarith` hacen la cuenta $i <= x_n <= x_(n_0) < i + epsilon$. En (b), `push Not` sobre
  "$-M$ no es cota inferior" produce el $x_(n_0) < -M$ y se cierra con el Sublema.
  No se usa la Proposición 8 (`monotona_creciente_converge`), que es el espejo de (a), ni
  `tendsto_atTop_ciInf`, ni ningún lema `Tendsto`. Los índices en Lean empiezan en $0$ (el
  conjunto $X$ es `Set.range x`, no vacío por `Set.range_nonempty`), lo que no cambia nada.
  El contraejemplo de la estrategia ($x_1 = -10$, $x_n = 1/n$) es sólo un comentario sobre la
  lectura de la Definición 10 y no está formalizado.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 13

#enunciado[Ejercicio 13][
  Sea $A subset.eq RR$ acotado superiormente y no vacío. Probar que si $A$ no tiene máximo
  entonces existe $(a_n)_(n in NN) subset.eq A$ estrictamente creciente tal que
  $a_n ->_(n -> oo) op("sup")(A)$.
]
#estrategia[Construir la sucesión por recursión con la Proposición 3][
  Sea $s = op("sup")(A)$ (existe por el Axioma de Completitud). Que $A$ no tenga máximo significa,
  por la Definición 3, que $s in.not A$: entonces todo $a in A$ cumple $a < s$ (es $a <= s$ y
  $a != s$), y queda lugar entre $a$ y $s$ para elegir un término más grande. La demostración de la
  Equivalencia del supremo 2 ya construye $a_n in A$ con $s - 1/n < a_n <= s$; lo nuevo es que
  además cada término supere al anterior. Para eso, al elegir $a_(n+1)$ con la Proposición 3
  usamos $epsilon_n = op("mín")(s - a_n, 1/(n+1)) > 0$: la primera cota fuerza $a_(n+1) > a_n$ y
  la segunda, $s - a_(n+1) < 1/(n+1)$. La convergencia sale después de $0 <= s - a_n < 1/n$ y
  el Principio de Arquímedes 2.
]

#resolucion[Propuesta: existe $(a_n)_(n in NN) subset.eq A$ estrictamente creciente con $a_n -> op("sup")(A)$][
  Como $A$ es no vacío y acotado superiormente, por el Axioma de Completitud existe
  $s = op("sup")(A)$. Que $A$ no tiene máximo quiere decir (Definición 3) que $s in.not A$.

  *Paso previo: todo $a in A$ cumple $a < s$.* Si $a in A$, entonces $a <= s$ porque $s$ es cota
  superior de $A$ (Definición 2, ítem a), y $a != s$ porque $a in A$ y $s in.not A$. Luego $a < s$.

  *Construcción recursiva.* Elegimos los términos uno a uno.

  - _Primer término._ Por la Proposición 3 (Equivalencia de supremo) con $epsilon = 1$, existe
    $a_1 in A$ tal que $s - 1 < a_1 <= s$.
  - _Paso recursivo._ Supongamos elegido $a_n in A$. Por el paso previo, $s - a_n > 0$, así que
    $ epsilon_n = op("mín")(s - a_n, 1/(n+1)) > 0. $
    Por la Proposición 3 con $epsilon = epsilon_n$, existe $a_(n+1) in A$ tal que
    $s - epsilon_n < a_(n+1) <= s$. Este $a_(n+1)$ cumple dos cosas:
    $ a_(n+1) > s - epsilon_n >= s - (s - a_n) = a_n quad "y" quad s - a_(n+1) < epsilon_n <= 1/(n+1), $
    usando $epsilon_n <= s - a_n$ en la primera y $epsilon_n <= 1/(n+1)$ en la segunda.

  Esto define $(a_n)_(n in NN) subset.eq A$ (por inducción: $a_1$ está definido, y si $a_n$ lo
  está, también $a_(n+1)$).

  *(i) Es estrictamente creciente.* Por el paso recursivo, $a_n < a_(n+1)$ para todo $n in NN$.

  *(ii) $s - 1/n < a_n <= s$ para todo $n in NN$.* La cota $a_n <= s$ vale porque $a_n in A$ y
  $s$ es cota superior. La otra, por inducción en $n$: para $n = 1$ es $s - 1 < a_1$, que es como
  elegimos $a_1$; y si $n >= 1$, la elección de $a_(n+1)$ da directamente $s - a_(n+1) < 1/(n+1)$,
  o sea $s - 1/(n+1) < a_(n+1)$.

  *(iii) $a_n -> s$.* Sea $epsilon > 0$. Por la Proposición 1 (Principio de Arquímedes 2) existe
  $n_0 in NN$ tal que $0 < 1/n_0 < epsilon$. Si $n >= n_0$, entonces $1/n <= 1/n_0$ (las dos son
  positivas y $n >= n_0$), y por (ii)
  $ 0 <= s - a_n < 1/n <= 1/n_0 < epsilon. $
  Por lo tanto $abs(a_n - s) = s - a_n < epsilon$ para todo $n >= n_0$: es la Definición 7 de
  $a_n -> s = op("sup")(A)$. $qed$
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej13`][
  `ej13 {A : Set ℝ} (_hne : A.Nonempty) (_hb : AcotadoSup A) {s : ℝ} (hs : EsSup A s) (hmax : s ∉ A) : ∃ a : ℕ → ℝ, (∀ n, a n ∈ A) ∧ StrictMono a ∧ Converge a s`.
  Las hipótesis `_hne` y `_hb` son las del enunciado (hacen falta para que $s$ exista, Axioma de
  Completitud); una vez dado `hs`, la prueba no vuelve a usarlas, y por eso llevan el guion bajo.

  El paso recursivo es el lema `paso (hs) (hmax) (a) (ha : a ∈ A) (n : ℕ) : ∃ b ∈ A, a < b ∧ s - 1 / (n + 1) < b ∧ b ≤ s`,
  que aplica `equiv_sup` (Proposición 3) con $epsilon = op("mín")(s - a, 1/(n+1))$, y el "paso
  previo" ($a < s$) es `lt_of_le_of_ne` con `hmax`. Es el único punto donde la formalización se
  aparta del texto: en el papel decimos "elegimos $a_(n+1)$"; en Lean hay que *elegir
  explícitamente*, y eso se hace con `choose f hfA hf₁ hf₂ hf₃ using paso hs hmax`
  (`Classical.choose` sobre el lema), que produce una función de elección `f a ha n`, y después
  la sucesión se define por recursión con `Nat.rec` sobre el subtipo `{a // a ∈ A}` (así cada
  término lleva consigo la prueba de que está en $A$, que es lo que el paso siguiente necesita).
  Con eso, `StrictMono` sale de `strictMono_nat_of_lt_succ` y la cota $s - 1/(n+1) < a_n$ por
  inducción (`induction n`). La convergencia es la de (iii): `arquimedes2` da $n_0$ con
  $0 < 1/n_0 < epsilon$ y `one_div_le_one_div_of_le` da $1/(n+1) <= 1/n_0$.

  Los índices en Lean empiezan en $0$: $a_0$ es el $a_1$ del texto (elegido con $epsilon = 1$) y
  la cota queda $s - 1/(n+1) < a_n$; como $n + 1 >= n_0$ cuando $n >= n_0$, la cuenta final es la
  misma. No se usa la Equivalencia del supremo 2 (`equiv_sup2`), ni `IsLUB.exists_seq_*`, ni
  ningún lema `Tendsto`.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 14

#enunciado[Ejercicio 14][
  Sea $(x_n)_(n in NN) subset.eq RR$ una sucesión no acotada superiormente. Probar que existe una
  subsucesión $(x_(n_k))_(k in NN)$ que diverge a $+oo$.
]

#estrategia[Elegir índices con $x_(n_k) > k$][
  "No acotada superiormente" dice que ningún $K$ es cota superior: siempre hay algún término por
  encima de $K$. Lo que hace falta para armar una subsucesión es un poco más: que ese término se
  pueda elegir *más allá de cualquier índice* $N$ (si no, podríamos estar eligiendo siempre el
  mismo). Eso sale de que los primeros $N$ términos son finitos y tienen máximo. Con ese sublema
  se eligen recursivamente $n_1 < n_2 < dots$ con $x_(n_k) > k$, y $x_(n_k) > k$ diverge a $+oo$
  por el Principio de Arquímedes.
]

#sublema(titulo: "Sublema 1: términos grandes con índice tan grande como se quiera (deducción propia)")[
  Si $(x_n)_(n in NN)$ no está acotada superiormente, entonces para todo $K in RR$ y todo
  $N in NN$ existe $n > N$ con $x_n > K$.

  _Demostración._ Supongamos que no: existen $K in RR$ y $N in NN$ tales que $x_n <= K$ para
  todo $n > N$. Sea
  $ c = op("máx"){x_1, x_2, dots, x_N, K}, $
  que existe porque es el máximo de finitos números. Dado $n in NN$, si $n <= N$ entonces
  $x_n <= c$ porque $x_n$ es uno de los números de la lista; si $n > N$ entonces $x_n <= K <= c$.
  Así $x_n <= c$ para todo $n$, es decir $c$ es cota superior de ${x_n : n in NN}$ (Definición 1),
  y $(x_n)_(n in NN)$ estaría acotada superiormente, contra la hipótesis. $qed$
]

#resolucion[Propuesta: la subsucesión con $x_(n_k) > k$ diverge a $+oo$][
  *Construcción de los índices.* Por el Sublema 1 con $K = 1$ y $N = 1$ existe $n_1 > 1$ con
  $x_(n_1) > 1$. Supongamos elegidos $n_1 < n_2 < dots < n_k$ con $x_(n_j) > j$ para
  $j = 1, dots, k$. Aplicando el Sublema 1 con $K = k + 1$ y $N = n_k$ existe $n_(k+1) > n_k$ con
  $x_(n_(k+1)) > k + 1$. Esto define recursivamente una sucesión de índices
  $n_1 < n_2 < n_3 < dots$ (estrictamente creciente), de modo que $(x_(n_k))_(k in NN)$ es una
  subsucesión de $(x_n)_(n in NN)$ (Definición de subsucesión), y por construcción
  $ x_(n_k) > k quad "para todo" k in NN. $

  *Divergencia a $+oo$.* Sea $M > 0$. Por el Teorema 1 (Principio de Arquímedes) existe
  $k_0 in NN$ con $M <= k_0$. Si $k >= k_0$, entonces
  $ x_(n_k) > k >= k_0 >= M, $
  o sea $x_(n_k) > M$ para todo $k >= k_0$. Como $M > 0$ era arbitrario, $x_(n_k) -> +oo$
  (Definición 8).
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej14`][
  `ej14 {x : ℕ → ℝ} (h : ¬ AcotadoSup (Set.range x)) : ∃ φ : ℕ → ℕ, StrictMono φ ∧ DivergeMasInf (x ∘ φ)`.
  El hecho de base "finitos números tienen máximo" es `exists_bound_finite` (inducción en $N$,
  con `max`); el Sublema 1 es `exists_gt_of_not_acotadoSup` (por el absurdo, con la cota
  `max c K`). La recursión es `exists_strictMono_of_step`: de "para todo $k$ y todo $N$ hay
  $n > N$ con $P(k, n)$" se fabrica $phi$ con `Nat.rec` y `Classical.choose` (tactic `choose`),
  estrictamente creciente por `strictMono_nat_of_lt_succ`, con $P(k, phi(k))$ para todo $k$; acá
  $P(k, n)$ es $k < x_n$. Como en Lean los índices empiezan en $0$, se elige $phi(0)$ con
  $x_(phi(0)) > 0$ y $phi(k+1) > phi(k)$ con $x_(phi(k+1)) > k + 1$: es la misma construcción,
  corrida en uno. La divergencia usa `arquimedes` con $M$ y `linarith`. No se usa `Tendsto` ni
  `Filter.extraction_of_*`.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 15

#enunciado[Ejercicio 15][
  Sean $(x_n)_(n in NN) subset.eq RR$ y $ell in RR$. Probar que si toda subsucesión
  $(x_(n_k))_(k in NN)$ tiene una (sub)subsucesión $(x_(n_(k_j)))_(j in NN)$ que converge a
  $ell$, entonces la sucesión $(x_n)_(n in NN)$ converge a $ell$.
]

#estrategia[Por el absurdo: fabricar una subsucesión que se queda lejos de $ell$][
  Si $x_n arrow.not ell$, la Definición 9 da un $epsilon_0 > 0$ y términos a distancia $>= epsilon_0$
  de $ell$ con índices tan grandes como se quiera. Con ellos se arma recursivamente una
  subsucesión "mala", cuyos términos distan *todos* al menos $epsilon_0$ de $ell$. Ninguna
  sub-subsucesión suya puede converger a $ell$ (con $epsilon = epsilon_0$ en la Definición 7 se
  llega a $epsilon_0 < epsilon_0$), lo que contradice la hipótesis.
]

#sublema(titulo: "Sublema 1: la subsucesión mala (deducción propia)")[
  Si $(x_n)_(n in NN)$ no converge a $ell$, existen $epsilon_0 > 0$ y una subsucesión
  $(x_(n_k))_(k in NN)$ tales que $abs(x_(n_k) - ell) >= epsilon_0$ para todo $k in NN$.

  _Demostración._ Por la Definición 9 (Negación de la convergencia), que $x_n arrow.not ell$
  significa que existe $epsilon_0 > 0$ tal que para todo $N in NN$ existe $n >= N$ con
  $abs(x_n - ell) >= epsilon_0$. Fijado ese $epsilon_0$, elegimos los índices recursivamente:
  - con $N = 1$ existe $n_1 >= 1$ con $abs(x_(n_1) - ell) >= epsilon_0$;
  - elegidos $n_1 < dots < n_k$ con $abs(x_(n_j) - ell) >= epsilon_0$ para $j = 1, dots, k$,
    tomamos $N = n_k + 1$ y obtenemos $n_(k+1) >= n_k + 1 > n_k$ con
    $abs(x_(n_(k+1)) - ell) >= epsilon_0$.
  Los índices son estrictamente crecientes, así que $(x_(n_k))_(k in NN)$ es una subsucesión
  (Definición de subsucesión), y por construcción $abs(x_(n_k) - ell) >= epsilon_0$ para todo
  $k$. $qed$
]

#resolucion[Propuesta: $x_n -> ell$][
  Supongamos, por el absurdo, que $(x_n)_(n in NN)$ no converge a $ell$. Por el Sublema 1 hay
  $epsilon_0 > 0$ y una subsucesión $(x_(n_k))_(k in NN)$ con
  $ abs(x_(n_k) - ell) >= epsilon_0 quad "para todo" k in NN. $
  Por hipótesis, esta subsucesión tiene a su vez una subsucesión $(x_(n_(k_j)))_(j in NN)$ (con
  $k_1 < k_2 < dots$) que converge a $ell$. Aplicamos la Definición 7 con $epsilon = epsilon_0 > 0$:
  existe $j_0 in NN$ tal que $abs(x_(n_(k_j)) - ell) < epsilon_0$ para todo $j >= j_0$. En
  particular, para $j = j_0$,
  $ epsilon_0 <= abs(x_(n_(k_(j_0))) - ell) < epsilon_0, $
  donde la primera desigualdad es la del Sublema 1 con $k = k_(j_0)$. Esto es absurdo. Luego
  $(x_n)_(n in NN)$ converge a $ell$.
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej15`][
  `ej15 {x : ℕ → ℝ} {l : ℝ} (h : ∀ φ : ℕ → ℕ, StrictMono φ → ∃ ψ : ℕ → ℕ, StrictMono ψ ∧ Converge (x ∘ φ ∘ ψ) l) : Converge x l`.
  El Sublema 1 es `exists_subseq_far_of_not_converge`: `push Not` sobre `¬ Converge x l` da
  exactamente la Definición 9 (`∃ ε₀ > 0, ∀ N, ∃ n ≥ N, ε₀ ≤ |x n - l|`), y la recursión es
  `exists_strictMono_of_step` (la misma que en `Ej14.lean`, con `Nat.rec`, `choose` y
  `strictMono_nat_of_lt_succ`), aplicada con $N = n_k + 1$ para que el índice nuevo sea
  estrictamente mayor. La prueba principal es por `by_contra`, toma la sub-subsucesión $psi$ que
  da la hipótesis, evalúa la Definición 7 en $epsilon = epsilon_0$ y en el índice $j_0$ obtenido,
  y cierra con `absurd`. No se usa `tendsto_of_subseq_tendsto` ni `Tendsto`.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 16

#enunciado[Ejercicio 16][
  Sea $(x_n)_(n in NN) subset.eq RR$. Probar:
  #set enum(numbering: "(a)")
  + Si $(x_(2k))_(k in NN)$ y $(x_(2k-1))_(k in NN)$ son convergentes, y sus límites coinciden,
    entonces $(x_n)_(n in NN)$ es convergente.
  + Si $(x_(2k))_(k in NN)$, $(x_(2k-1))_(k in NN)$ y $(x_(3k))_(k in NN)$ son convergentes,
    entonces $(x_n)_(n in NN)$ es convergente.
]

#estrategia[Partir $NN$ en pares e impares; en (b), usar los múltiplos de 6 como puente][
  (a) Todo $n$ es par o impar, así que, dado $epsilon$, basta que $n$ supere a la vez los dos
  umbrales que dan las dos subsucesiones: $n_0 = op("máx")(2 k_1, 2 k_2 - 1)$. (b) Los límites de
  las tres subsucesiones tienen que coincidir, porque $(x_(6k))_k$ es subsucesión *tanto* de los
  pares como de los múltiplos de $3$, y $(x_(6k-3))_k$ lo es de los impares y de los múltiplos de
  $3$: Convergencia de subsucesiones más Unicidad del límite igualan los tres límites, y se termina
  con (a).
]

// ---------------------------------------------------------------- (a)
#enunciado[Ejercicio 16 (a)][
  Si $(x_(2k))_(k in NN)$ y $(x_(2k-1))_(k in NN)$ son convergentes, y sus límites coinciden,
  entonces $(x_n)_(n in NN)$ es convergente.
]

#resolucion[Propuesta: $x_n -> ell$, el límite común][
  Sea $ell in RR$ el límite común: $x_(2k) -> ell$ y $x_(2k-1) -> ell$. Veamos que $x_n -> ell$
  por la Definición 7. Sea $epsilon > 0$.
  - Como $x_(2k) -> ell$, existe $k_1 in NN$ tal que $abs(x_(2k) - ell) < epsilon$ para todo
    $k >= k_1$.
  - Como $x_(2k-1) -> ell$, existe $k_2 in NN$ tal que $abs(x_(2k-1) - ell) < epsilon$ para todo
    $k >= k_2$.
  Tomamos $n_0 = op("máx")(2 k_1, 2 k_2 - 1)$ y sea $n >= n_0$. Todo natural es par o impar
  (hecho de base), así que hay dos casos.
  - *$n$ par:* $n = 2k$ con $k in NN$. Entonces $2k = n >= n_0 >= 2 k_1$, de donde $k >= k_1$, y
    por lo tanto $abs(x_n - ell) = abs(x_(2k) - ell) < epsilon$.
  - *$n$ impar:* $n = 2k - 1$ con $k in NN$. Entonces $2k - 1 = n >= n_0 >= 2 k_2 - 1$, de donde
    $k >= k_2$, y por lo tanto $abs(x_n - ell) = abs(x_(2k-1) - ell) < epsilon$.
  En ambos casos $abs(x_n - ell) < epsilon$ para todo $n >= n_0$, es decir $x_n -> ell$.
]

// ---------------------------------------------------------------- (b)
#enunciado[Ejercicio 16 (b)][
  Si $(x_(2k))_(k in NN)$, $(x_(2k-1))_(k in NN)$ y $(x_(3k))_(k in NN)$ son convergentes,
  entonces $(x_n)_(n in NN)$ es convergente.
]

#resolucion[Propuesta: los tres límites coinciden y se aplica (a)][
  Llamemos $ell_1, ell_2, ell_3 in RR$ a los límites: $x_(2k) -> ell_1$, $x_(2k-1) -> ell_2$ y
  $x_(3k) -> ell_3$. Escribimos $p_k = x_(2k)$, $q_k = x_(2k-1)$ y $t_k = x_(3k)$ para las tres
  sucesiones (de índice $k in NN$).

  *$ell_1 = ell_3$.* La sucesión $(x_(6k))_(k in NN)$ es una subsucesión de $(p_k)_(k in NN)$:
  $x_(6k) = x_(2 (3k)) = p_(3k)$, y $k |-> 3k$ es estrictamente creciente. Por Convergencia de
  subsucesiones, $x_(6k) -> ell_1$. También es una subsucesión de $(t_k)_(k in NN)$:
  $x_(6k) = x_(3 (2k)) = t_(2k)$, y $k |-> 2k$ es estrictamente creciente; luego $x_(6k) -> ell_3$.
  Por la Proposición 5 (Unicidad del límite), $ell_1 = ell_3$.

  *$ell_2 = ell_3$.* La sucesión $(x_(6k-3))_(k in NN)$ es una subsucesión de $(q_k)_(k in NN)$:
  $x_(6k-3) = x_(2 (3k-1) - 1) = q_(3k-1)$, y $k |-> 3k - 1$ es estrictamente creciente (y toma
  valores en $NN$ porque $3k - 1 >= 2$ para $k >= 1$). Por Convergencia de subsucesiones,
  $x_(6k-3) -> ell_2$. También es una subsucesión de $(t_k)_(k in NN)$:
  $x_(6k-3) = x_(3 (2k-1)) = t_(2k-1)$, con $k |-> 2k - 1$ estrictamente creciente; luego
  $x_(6k-3) -> ell_3$. Por la Proposición 5 (Unicidad del límite), $ell_2 = ell_3$.

  *Conclusión.* $(x_(2k))_(k in NN)$ y $(x_(2k-1))_(k in NN)$ convergen y sus límites coinciden
  ($ell_1 = ell_3 = ell_2$). Por el ítem (a), $(x_n)_(n in NN)$ converge (a $ell_3$).
]

#observacion[Verificado en Lean: `Guias.Guia1.Ej16`][
  `ej16a {x : ℕ → ℝ} {l : ℝ} (he : Converge (fun k => x (2 * k)) l) (ho : Converge (fun k => x (2 * k + 1)) l) : Converge x l`;
  `ej16b (h₁ : ∃ l₁, Converge (fun k => x (2 * k)) l₁) (h₂ : ∃ l₂, Converge (fun k => x (2 * k + 1)) l₂) (h₃ : ∃ l₃, Converge (fun k => x (3 * k)) l₃) : ∃ l, Converge x l`.
  Como en Lean los índices empiezan en $0$, los pares son `x (2 * k)` y los impares
  `x (2 * k + 1)` con $k >= 0$: son los mismos términos que $x_(2k)$ y $x_(2k-1)$ con $k >= 1$,
  salvo $x_0$, que en el curso no existe; del mismo modo $(x_(6k+3))_(k >= 0)$ reemplaza a
  $(x_(6k-3))_(k >= 1)$. En (a) el umbral es `max (2 * n₁) (2 * n₂ + 1)` y la partición es
  `Nat.even_or_odd`, con `omega` para despejar $k >= n_1$ o $k >= n_2$. En (b),
  `converge_of_subseq` es `convergencia_subsucesiones` más la identificación término a término
  ($b_k = a_(phi(k))$), aplicada con $phi(k) = 3k$, $2k$, $3k + 1$ y $2k + 1$ (sus `StrictMono`
  salen de `strictMono_nat_of_lt_succ` y `omega`); las igualdades de índices
  ($6k = 2 dot 3k$, etc.) se cierran con `congr 1; ring`, y los límites se igualan con
  `unicidad_limite`. No se usa `Tendsto`.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Anexo: Ejercicio 7 (edición 2025)

#sublema(titulo: "Por qué está acá")[
  La guía 2026 no incluye este ejercicio de punto fijo, que figuraba como *Ejercicio 7* en la
  edición 2025. Se resuelve igual porque sólo usa el Cap. 1 (supremo y cotas) y es el ejemplo más
  limpio de "sacar información del supremo sin tener una fórmula".
]

#enunciado[Ejercicio 7 (edición 2025)][
  Sea $f : [a, b] -> [a, b]$ creciente. Supongamos que $f(a) > a$. Sea
  $ x_0 = op("sup")({x in [a, b] : f(x) > x}). $
  Pruebe que $f(x_0) = x_0$.
]

#estrategia[Dos desigualdades, y el supremo se defiende solo][
  Llamamos $S = {x in [a, b] : f(x) > x}$. "Creciente" se lee en sentido amplio:
  $x <= y => f(x) <= f(y)$ (si fuera estricta, el argumento es el mismo). Primero vemos que
  $x_0$ existe y está en $[a, b]$. Después, $x_0 <= f(x_0)$: todo $x in S$ cumple $x < f(x)$, y
  como $x <= x_0$ y $f$ es creciente, $f(x) <= f(x_0)$; así $f(x_0)$ es cota superior de $S$ y
  el supremo es la menor (Definición 2). Y $f(x_0) <= x_0$: si fuera $x_0 < f(x_0)$, cualquier
  punto $m$ estrictamente entre ambos cumple $f(m) >= f(x_0) > m$, así que $m in S$ pero
  $m > x_0 = op("sup") S$, absurdo. No hacen falta ni la Proposición 3 ni continuidad.
]

#resolucion[Propuesta: $f(x_0) = x_0$][
  Sea $S = {x in [a, b] : f(x) > x}$.

  *Paso 0: $x_0$ existe y $a <= x_0 <= b$.* $S != nothing$ porque $a in S$: $a in [a, b]$ (es
  $a <= a <= b$) y $f(a) > a$ por hipótesis. $S$ está acotado superiormente por $b$: todo
  $x in S$ está en $[a, b]$, así que $x <= b$ (Definición 1). Por el Axioma de Completitud existe
  $x_0 = op("sup") S$. Como $a in S$ y $x_0$ es cota superior de $S$, $a <= x_0$; como $b$ es cota
  superior de $S$ y $x_0$ es la menor (Definición 2, ítem b), $x_0 <= b$. Luego $x_0 in [a, b]$ y
  tiene sentido evaluar $f(x_0)$; además $f(x_0) in [a, b]$ porque $f$ aplica $[a, b]$ en
  $[a, b]$.

  *Paso 1: $x_0 <= f(x_0)$.* Veamos que $f(x_0)$ es cota superior de $S$. Sea $x in S$. Entonces
  $x in [a, b]$ y $x < f(x)$. Como $x_0$ es cota superior de $S$, $x <= x_0$, y como $f$ es
  creciente en $[a, b]$ (con $x, x_0 in [a, b]$), $f(x) <= f(x_0)$. Juntando,
  $ x < f(x) <= f(x_0), $
  así que $x <= f(x_0)$ para todo $x in S$: $f(x_0)$ es cota superior de $S$. Por la Definición 2
  (ítem b), el supremo es menor o igual que toda cota superior: $x_0 <= f(x_0)$.

  *Paso 2: $f(x_0) <= x_0$.* Supongamos, por el absurdo, que $x_0 < f(x_0)$. Tomamos el punto
  medio
  $ m = (x_0 + f(x_0))/2, quad "que cumple" x_0 < m < f(x_0). $
  Entonces $m in [a, b]$: $a <= x_0 < m$ y $m < f(x_0) <= b$ (Paso 0). Como $f$ es creciente y
  $x_0 <= m$ (ambos en $[a, b]$), $f(x_0) <= f(m)$, y por lo tanto
  $ f(m) >= f(x_0) > m. $
  Es decir, $m in [a, b]$ y $f(m) > m$: $m in S$. Pero $x_0$ es cota superior de $S$, así que
  $m <= x_0$, lo que contradice $x_0 < m$. Luego $f(x_0) <= x_0$.

  De los Pasos 1 y 2, $f(x_0) = x_0$.
]

#observacion[Verificado en Lean: `Guias.Guia1.Anexo`][
  `anexo (hab : a ≤ b) (hf : Set.MapsTo f (Set.Icc a b) (Set.Icc a b))
  (hmono : ∀ x ∈ Set.Icc a b, ∀ y ∈ Set.Icc a b, x ≤ y → f x ≤ f y) (ha : a < f a)
  (hx₀ : EsSup (S f a b) x₀) : f x₀ = x₀`, con `S f a b = {x ∈ Set.Icc a b | x < f x}`.
  `f : ℝ → ℝ` es una función de todo $RR$ y la hipótesis `hf` dice que manda $[a, b]$ en
  $[a, b]$; "creciente" es `hmono`, sólo para puntos de $[a, b]$ y en sentido amplio. El supremo
  viene como hipótesis `EsSup` (Definición 2); su existencia es el Paso 0, `anexo_existe`, que
  aplica `axioma_completitud` con `a ∈ S` y `b` cota superior. La prueba sigue los Pasos 1 y 2
  tal cual: `h1 : x₀ ≤ f x₀` es `hx₀.2 (f x₀) _` con la cota superior construida por
  `le_trans hx.2.le (hmono x _ x₀ _ _)`, y `h2` toma `m := (x₀ + f x₀) / 2`, prueba `m ∈ S` y
  cierra con `hx₀.1 m hmS` y `linarith`. No se usa la Proposición 3 (`equiv_sup`), ni `sSup`,
  `IsLUB` ni ningún teorema de punto fijo de Mathlib. La hipótesis `a ≤ b` es necesaria para que
  $a in [a, b]$ (en el enunciado está implícita en "$f : [a, b] -> [a, b]$").
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

