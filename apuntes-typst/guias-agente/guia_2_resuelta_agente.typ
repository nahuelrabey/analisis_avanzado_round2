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

// Resolución de la Práctica 2 escrita por el agente (Claude), NO por el autor de los apuntes.
// Vive en `guias-agente/` para distinguirla de las resoluciones de `guias/p2.typ`.
// Cada ejercicio está verificado en Lean 4 + Mathlib: ver `lean/Guias/Guia2/EjNN.lean`.

#align(center)[
  #text(14pt, weight: "bold")[Análisis Avanzado - Segundo cuatrimestre de 2025] \
  #v(2pt)
  #text(12pt, weight: "medium")[Práctica 2 --- resuelta por el agente]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#progreso[
  *Autoría:* este archivo lo escribió el agente (Claude). No es una resolución del autor de los
  apuntes: la de él está en `guias/p2.typ`. Se guarda en otra carpeta para poder distinguirlas.

  *Qué se supone verdadero:* todo lo escrito en `apuntes.typ` (definiciones, proposiciones,
  teoremas y observaciones, citados por nombre y número; para cardinales, la sección 3: Def. 3.1,
  3.5, 3.6, 3.8, Prop. 3.2, 3.9, 3.13, 3.14, Numerabilidad de $QQ$, Teo. 3.11 y 3.19, Obs. 3.7,
  3.10 y 3.21) y los enunciados de la Práctica 1. Los ejemplos de `ejemplos/p2.typ` se leyeron
  como inspiración; ninguno se usa como lema. Dentro de la propia Práctica 2, un ejercicio puede
  citar los anteriores ("Ej. 6 (a)"), nunca los posteriores.

  *Qué se usa sin cita:* hechos de base del orden y la aritmética de $RR$, $ZZ$ y $NN$ (paridad,
  divisibilidad por $2$ y $3$, inducción, buen orden de $NN$, que no hay enteros entre $n$ y
  $n + 1$) y manipulación elemental de funciones y conjuntos (composición de inyectivas,
  restricción, inversa de una biyección, pegar funciones en dominios disjuntos). Lo que va más
  allá --- $NN times NN tilde.op NN$, $ZZ tilde.op NN$, la unión contable de contables, $\# cal(P)(NN) = c$,
  $RR times RR tilde.op RR$ --- se demuestra en el lugar (son ejercicios de esta práctica o
  sublemas marcados "(deducción propia)").

  *Supuestos externos declarados:* (1) en el Ej. 17 (b) se usa la definición estándar
  ($epsilon$-$delta$) de continuidad en un punto, que `apuntes.typ` no da; (2) en el Ej. 12 (a) se
  usa que hay infinitos primos, hecho de base de aritmética.

  *Verificación en Lean:* cada ejercicio tiene su contraparte en `lean/Guias/Guia2/EjNN.lean`
  (Lean 4 + Mathlib; `cd lean && lake build`). Las definiciones del curso (coordinables, $<=$ entre
  cardinales, finito, numerable, contable, $\# A = c$) y los resultados de `apuntes.typ` que se toman
  como verdaderos están en `lean/Guias/Guia2/Defs.lean`; cada archivo sólo importa ése. La caja
  _Observación_ del final de cada ejercicio dice qué teorema certifica qué ítem y en qué se aparta
  la formalización del texto.
]

#v(10pt)

== Ejercicio 1

#enunciado[Ejercicio 1][
  Halle el cardinal de los siguientes conjuntos:
  #set enum(numbering: "(a)")
  + $ZZ_(<= -3)$
  + $5 ZZ$
  + $ZZ times NN$
  + $(-1, 1) inter QQ$
]

#estrategia[Los cuatro son numerables: biyecciones explícitas o Cantor--Schröder--Bernstein][
  Por la Definición 3.6, $\#A = aleph_0$ si existe una biyección $NN -> A$ (acá
  $NN = {1, 2, 3, dots}$). En (a) la biyección se escribe directamente. En (b) y (c) hacen falta
  dos hechos que *no* están en `apuntes.typ` y se prueban como sublemas: $ZZ tilde.op NN$
  (pares a los positivos, impares a los no positivos) y $NN times NN tilde.op NN$ (la inyección
  $(n, m) |-> 2^n 3^m$ más el Teorema 3.11). En (d) se encajonan dos inyecciones,
  $NN -> (-1, 1) inter QQ -> QQ$, y se cierra con el Teorema 3.11 y la numerabilidad de $QQ$.
]

// ---------------------------------------------------------------- (a)
#enunciado[Ejercicio 1 (a)][$ZZ_(<= -3) = {z in ZZ : z <= -3}$.]

#resolucion[Propuesta: $\#ZZ_(<= -3) = aleph_0$][
  Sea $f : NN -> ZZ_(<= -3)$, $f(n) = -2 - n$. Está bien definida: si $n >= 1$ entonces
  $-2 - n <= -3$.

  - *Inyectiva:* si $-2 - n = -2 - m$ entonces $n = m$.
  - *Sobreyectiva:* dado $z <= -3$, el natural $n = -2 - z >= 1$ cumple $f(n) = -2 - (-2 - z) = z$.

  Luego $f$ es una biyección $NN -> ZZ_(<= -3)$ y, por la Definición 3.6, $\#ZZ_(<= -3) = aleph_0$.
]

// ---------------------------------------------------------------- (b)
#enunciado[Ejercicio 1 (b)][$5 ZZ = {5 k : k in ZZ}$.]

#sublema(titulo: "Sublema A: ℤ ∼ ℕ (deducción propia, no está en apuntes.typ)")[
  Sea $g : NN -> ZZ$ definida por
  $ g(n) = cases(n slash 2 & "si" n "es par", -(n - 1) slash 2 & "si" n "es impar.") $
  Los pares van a los enteros positivos ($n = 2k |-> k >= 1$) y los impares a los no positivos
  ($n = 2k + 1 |-> -k <= 0$, con $k >= 0$).

  - *Inyectiva.* Sean $g(n) = g(m)$. Si $n$ y $m$ son ambos pares, $n slash 2 = m slash 2$ y
    $n = m$; si son ambos impares, $(n - 1) slash 2 = (m - 1) slash 2$ y $n = m$. Si tienen
    distinta paridad, uno de los dos valores es $>= 1$ y el otro es $<= 0$, así que no pueden ser
    iguales.
  - *Sobreyectiva.* Si $z >= 1$, $n = 2 z$ es par y $g(n) = z$. Si $z <= 0$, $n = 1 - 2 z >= 1$ es
    impar y $g(n) = -(1 - 2 z - 1) slash 2 = z$.

  Por lo tanto $g$ es biyectiva y $NN tilde.op ZZ$ (Definición 3.1). $qed$
]

#resolucion[Propuesta: $\#5 ZZ = aleph_0$][
  La función $h : ZZ -> 5 ZZ$, $h(k) = 5 k$, es biyectiva: es inyectiva porque $5 k = 5 k'$ implica
  $k = k'$, y es sobreyectiva porque todo elemento de $5 ZZ$ es de la forma $5 k$ por definición.
  Entonces $ZZ tilde.op 5 ZZ$ y, por el Sublema A, $NN tilde.op ZZ$. Como $tilde.op$ es transitiva
  (Proposición 3.2), $NN tilde.op 5 ZZ$: explícitamente, $h compose g : NN -> 5 ZZ$ es biyectiva.
  Por la Definición 3.6, $\#5 ZZ = aleph_0$.
]

// ---------------------------------------------------------------- (c)
#enunciado[Ejercicio 1 (c)][$ZZ times NN$.]

#sublema(titulo: "Sublema B: ℕ × ℕ ∼ ℕ (deducción propia, no está en apuntes.typ)")[
  *B.1 (inyectividad de $2^a 3^b$).* Si $a, b, c, d >= 0$ son enteros y $2^a 3^b = 2^c 3^d$,
  entonces $a = c$ y $b = d$.

  _Prueba, por inducción en $a$ (para todo $c$)._ Si $a = 0$: si fuera $c >= 1$, el lado
  izquierdo $3^b$ es impar y el derecho $2^c 3^d$ es par, absurdo; luego $c = 0$ y queda
  $3^b = 3^d$, de donde $b = d$ porque $x |-> 3^x$ es estrictamente creciente. Si $a >= 1$: si
  fuera $c = 0$, ahora el izquierdo es par y el derecho impar, absurdo; luego $c >= 1$ y,
  cancelando un factor $2$, $2^(a - 1) 3^b = 2^(c - 1) 3^d$. Por hipótesis inductiva
  $a - 1 = c - 1$ y $b = d$. $qed$

  *B.2.* Sean $phi : NN times NN -> NN$, $phi(n, m) = 2^n 3^m$, y $psi : NN -> NN times NN$,
  $psi(n) = (n, 1)$. Por B.1, $phi$ es inyectiva; $psi$ es inyectiva porque $(n, 1) = (m, 1)$
  implica $n = m$. Entonces $\#(NN times NN) <= \#NN$ y $\#NN <= \#(NN times NN)$ (Definición 3.8),
  y por el Teorema 3.11 (Cantor--Schröder--Bernstein) $NN times NN tilde.op NN$. $qed$
]

#resolucion[Propuesta: $\#(ZZ times NN) = aleph_0$][
  Con la biyección $g : NN -> ZZ$ del Sublema A, definimos $G : NN times NN -> ZZ times NN$,
  $G(n, m) = (g(n), m)$. Es biyectiva, con inversa $(z, m) |-> (g^(-1)(z), m)$: en efecto
  $G(g^(-1)(z), m) = (z, m)$ y $(g^(-1)(g(n)), m) = (n, m)$. Luego $NN times NN tilde.op ZZ times NN$
  y, por el Sublema B, $NN tilde.op NN times NN$. Por la transitividad de $tilde.op$
  (Proposición 3.2), $NN tilde.op ZZ times NN$, es decir $\#(ZZ times NN) = aleph_0$
  (Definición 3.6).
]

// ---------------------------------------------------------------- (d)
#enunciado[Ejercicio 1 (d)][$(-1, 1) inter QQ$.]

#resolucion[Propuesta: $\#((-1, 1) inter QQ) = aleph_0$][
  Llamemos $I = (-1, 1) inter QQ$. Probamos las dos desigualdades y usamos el Teorema 3.11.

  *$aleph_0 <= \#I$.* Sea $iota : NN -> I$, $iota(n) = 1 slash (n + 1)$. Para $n >= 1$ es
  $0 < 1 slash (n + 1) <= 1 slash 2 < 1$, así que $iota(n) in (-1, 1)$, y es racional; luego
  $iota(n) in I$. Es inyectiva: $1 slash (n + 1) = 1 slash (m + 1)$ implica $n + 1 = m + 1$. Por la
  Definición 3.8, $\#NN <= \#I$. (En particular $I$ es infinito.)

  *$\#I <= aleph_0$.* La inclusión $I arrow.hook QQ$ es inyectiva, así que $\#I <= \#QQ$. Por la
  Proposición "Numerabilidad de $QQ$", $QQ tilde.op NN$, y como $<=$ no depende del representante
  (Observación 3.10), $\#I <= \#NN$: concretamente, si $beta : QQ -> NN$ es una biyección, la
  composición de la inclusión con $beta$ es una inyección $I -> NN$.

  Por el Teorema 3.11, $I tilde.op NN$, o sea $\#I = aleph_0$. (Alternativamente: $I != nothing$ y
  $I subset.eq QQ$ numerable, así que $I$ es contable por la Proposición 3.13; como es infinito, es
  numerable por la Definición 3.6.)
]

#observacion[Verificado en Lean: `Guias.Guia2.Ej01`][
  `ej1a : Numerable Zle3` (con `Zle3 = {z : ℤ | z ≤ -3}`), `ej1b : Numerable cincoZ` (con
  `cincoZ = {z : ℤ | 5 ∣ z}`, que es $5 ZZ$), `ej1c : Numerable (ℤ × ℕ)` y
  `ej1d : Numerable I` (con `I = Set.Ioo (-1 : ℚ) 1`, es decir $(-1, 1) inter QQ$ como
  subconjunto de $QQ$). Los sublemas son `natEquivInt : ℕ ≃ ℤ` (la $g$ del Sublema A) y
  `natProdNat_numerable` (Sublema B: `pow_two_three_inj` es B.1, con la misma inducción en $a$ y
  el mismo argumento de paridad vía `Nat.even_pow` y `Odd.pow`; luego `teorema_CSB` con
  `pairEmb` y `diagEmb`). No se usan `Equiv.intEquivNat`, `Nat.pairEquiv` ni instancias
  `Denumerable`/`Countable`.

  Desvíos: en Lean $NN$ empieza en $0$, así que las fórmulas se corren en uno: (a) es
  $n |-> -3 - n$, el Sublema A es $2 k |-> k$, $2 k + 1 |-> -(k + 1)$, $psi(n) = (n, 0)$ y
  $iota(n) = 1 slash (n + 2)$. En (b) la inversa de $k |-> 5 k$ se escribe con la división entera
  `z / 5`. En (d), la segunda desigualdad usa `Function.Embedding.subtype` (la inclusión) y
  `numerable_rat` de `Defs.lean`.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 2

#enunciado[Ejercicio 2][Sea $A$ y $B$ conjuntos contables. Pruebe que $A union B$ es contable.]

#estrategia[Inyectar $A union B$ en $NN$ y aplicar la Proposición 3.13][
  Armamos una cadena de inyecciones
  $ A union B arrow.hook A union.sq B arrow.hook NN union.sq NN arrow.hook NN, $
  donde $X union.sq Y = ({1} times X) union ({2} times Y)$ es la unión disjunta
  "etiquetada". La primera flecha manda cada $x$ a su copia en $A$ si $x in A$ y a su copia en $B$
  si no; la segunda usa que "contable" da una inyección en $NN$; la tercera manda la primera copia
  de $NN$ a los pares y la segunda a los impares. Una inyección $A union B -> NN$ identifica a
  $A union B$ con un subconjunto de $NN$, que es contable por la Proposición 3.13.
]

#sublema(titulo: "Sublema 1: si A es contable, entonces #A ≤ #ℕ")[
  Por la Definición 3.6 hay dos casos. Si $A$ es finito, hay una biyección
  $f : {1, dots, n} -> A$; su inversa $f^(-1) : A -> {1, dots, n} subset.eq NN$ es inyectiva (vista
  en $NN$). Si $A$ es numerable, hay una biyección $f : NN -> A$ y $f^(-1) : A -> NN$ es
  inyectiva. En ambos casos $\#A <= \#NN$ (Definición 3.8). $qed$

  _Convención sobre $nothing$._ Si se admite $nothing$ como finito ($n = 0$, la biyección vacía,
  como hace `Defs.lean` con `Fin 0`), el argumento vale igual: la función vacía $nothing -> NN$ es
  inyectiva. Si se lee la Definición 3.6 al pie de la letra ($n >= 1$), $nothing$ no es contable y
  el caso no aparece.
]

#sublema(titulo: "Sublema 2: una inyección ℕ ⊔ ℕ → ℕ (pares e impares)")[
  Sea $sigma : NN union.sq NN -> NN$, $sigma(1, n) = 2 n$ y $sigma(2, n) = 2 n - 1$
  (para $n >= 1$, $2 n >= 2$ es par y $2 n - 1 >= 1$ es impar). Es inyectiva: si
  $sigma(i, n) = sigma(j, m)$ con $i = j$, entonces $2 n = 2 m$ o $2 n - 1 = 2 m - 1$ y $n = m$;
  si $i != j$, uno de los dos valores es par y el otro impar, así que no pueden coincidir. $qed$
]

#sublema(titulo: "Sublema 3: una inyección A ∪ B → A ⊔ B")[
  Sea $rho : A union B -> A union.sq B$ definida por $rho(x) = (1, x)$ si $x in A$ y
  $rho(x) = (2, x)$ si $x in.not A$ (en ese caso $x in B$, porque $x in A union B$). Si
  $rho(x) = rho(y)$, las etiquetas coinciden y las segundas coordenadas también, así que $x = y$:
  $rho$ es inyectiva. $qed$
]

#resolucion[Propuesta: $A union B$ es contable][
  Por el Sublema 1 hay inyecciones $f_A : A -> NN$ y $f_B : B -> NN$. Definimos
  $F : A union.sq B -> NN union.sq NN$ por $F(1, a) = (1, f_A (a))$ y
  $F(2, b) = (2, f_B (b))$. Es inyectiva: si $F(i, x) = F(j, y)$ entonces $i = j$, y en la primera
  (resp. segunda) copia $f_A (x) = f_A (y)$ (resp. $f_B (x) = f_B (y)$) da $x = y$.

  Con $rho$ (Sublema 3) y $sigma$ (Sublema 2), la composición
  $ Phi = sigma compose F compose rho : A union B -> NN $
  es inyectiva (composición de inyectivas). Sea $S = Phi(A union B) subset.eq NN$ su imagen;
  $Phi$ es una biyección $A union B -> S$, así que $A union B tilde.op S$.

  Si $S = nothing$, entonces $A union B = nothing$ es finito (con la convención del Sublema 1;
  bajo la lectura literal de la Definición 3.6 este caso no ocurre, porque $A != nothing$). Si
  $S != nothing$, como $S subset.eq NN$ y $NN$ es numerable, la Proposición 3.13 dice que $S$ es
  contable: finito o numerable. Si $S tilde.op {1, dots, n}$, componiendo biyecciones
  $A union B tilde.op S tilde.op {1, dots, n}$ (Proposición 3.2) y $A union B$ es finito; si
  $S tilde.op NN$, del mismo modo $A union B tilde.op NN$ y es numerable. En cualquier caso
  $A union B$ es contable (Definición 3.6).
]

#observacion[Verificado en Lean: `Guias.Guia2.Ej02`][
  `ej2 {X} (A B : Set X) (hA : Contable A) (hB : Contable B) : Contable ↥(A ∪ B)`. Los sublemas
  son `cardLe_nat_of_contable` (Sublema 1; el caso finito usa `Fin.valEmbedding`, la inclusión
  ${0, dots, n - 1} subset.eq NN$), `sumNatEmb : ℕ ⊕ ℕ ↪ ℕ` (Sublema 2, con `inl n ↦ 2n`,
  `inr n ↦ 2n + 1` porque $NN$ empieza en $0$) y `unionEmb A B : ↥(A ∪ B) ↪ ↥A ⊕ ↥B` (Sublema 3,
  con un `if` clásico sobre $x in A$). La cadena es `(unionEmb A B).trans (sumMap fA fB)` seguida
  de `sumNatEmb`, y el cierre es `contable_of_cardLe_numerable numerable_nat` (la Proposición 3.13
  en la forma "inyección en un numerable", que en `Defs.lean` ya incluye el caso vacío). No se usa
  `Set.Countable.union` ni ninguna instancia `Countable`. El único desvío es que en Lean $nothing$
  es finito (`Fin 0`), así que no hay caso aparte para $S = nothing$.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 3

#enunciado[Ejercicio 3][
  Sean $A subset.eq B$ conjuntos tales que $A$ es contable y $B backslash A$ es infinito.
  #set enum(numbering: "(a)")
  + Pruebe que existe $C subset.eq B backslash A$ tal que $C tilde.op C union A$.
  + Deduzca que $B backslash A tilde.op B$.
]

#estrategia[Sacar un numerable de $B backslash A$, absorber a $A$ ahí y pegar con la identidad][
  Como $B backslash A$ es infinito, la Proposición 3.14 da un $C subset.eq B backslash A$
  numerable. El conjunto $C union A$ es contable (Ej. 2) e infinito (contiene a $C$), así que es
  numerable, y entonces $C tilde.op NN tilde.op C union A$. Para (b), $B backslash A$ se parte en
  $C$ y $(B backslash A) backslash C$, y $B$ se parte en $C union A$ y el mismo
  $(B backslash A) backslash C$: la biyección de (a) en la primera parte y la identidad en la
  segunda se pegan en una biyección $B backslash A -> B$.
]

// ---------------------------------------------------------------- (a)
#enunciado[Ejercicio 3 (a)][Pruebe que existe $C subset.eq B backslash A$ tal que $C tilde.op C union A$.]

#resolucion[Propuesta: sirve cualquier $C subset.eq B backslash A$ numerable][
  Como $B backslash A$ es infinito, por la Proposición 3.14 existe $C subset.eq B backslash A$
  numerable, es decir, $NN tilde.op C$. Veamos que $C union A$ también es numerable.

  - *$C union A$ es contable.* $C$ es numerable, luego contable, y $A$ es contable por hipótesis.
    Por el Ej. 2, $C union A$ es contable.
  - *$C union A$ es infinito.* Contiene a $C$, y $C$ es infinito: si $C$ fuera finito habría una
    biyección ${1, dots, n} -> C$ y, componiendo con $C -> NN$ biyectiva, una biyección
    ${1, dots, n} -> NN$, que no existe (hecho de base: no hay inyección de ${1, dots, n + 1}$ en
    ${1, dots, n}$). Y un conjunto que contiene a un infinito es infinito (hecho de base: un
    subconjunto de un conjunto finito es finito).

  Por la Definición 3.6, un conjunto contable que no es finito es numerable: $NN tilde.op C union A$.
  Entonces $C tilde.op NN$ (simetría, Proposición 3.2) y $NN tilde.op C union A$, y por
  transitividad (Proposición 3.2) $C tilde.op C union A$.

  Notemos que la hipótesis $A subset.eq B$ no se usó en este ítem.
]

// ---------------------------------------------------------------- (b)
#enunciado[Ejercicio 3 (b)][Deduzca que $B backslash A tilde.op B$.]

#resolucion[Propuesta: pegar la biyección de (a) con la identidad en $(B backslash A) backslash C$][
  Sea $C subset.eq B backslash A$ el conjunto de (a) y $h : C -> C union A$ una biyección. Como
  $A subset.eq B$ y $C subset.eq B backslash A subset.eq B$, tenemos $C union A subset.eq B$.
  Definimos $H : B backslash A -> B$ por
  $ H(x) = cases(h(x) & "si" x in C, x & "si" x in (B backslash A) backslash C.) $
  Los dos casos son excluyentes y cubren $B backslash A$, y los valores caen en $B$.

  *$H$ es inyectiva.* Sean $x != y$ en $B backslash A$. Si ambos están en $C$, $h(x) != h(y)$
  porque $h$ es inyectiva. Si ninguno está en $C$, $H(x) = x != y = H(y)$. Si $x in C$ e
  $y in.not C$: $H(x) = h(x) in C union A$, mientras que $H(y) = y$ cumple $y in.not C$ (por
  caso) e $y in.not A$ (porque $y in B backslash A$), o sea $y in.not C union A$; luego
  $H(x) != H(y)$.

  *$H$ es sobreyectiva.* Sea $y in B$. Si $y in C union A$, como $h$ es sobreyectiva hay $x in C$
  con $h(x) = y$, y $H(x) = h(x) = y$. Si $y in.not C union A$, entonces $y in.not A$, luego
  $y in B backslash A$, y $y in.not C$, así que $H(y) = y$.

  Por lo tanto $H$ es una biyección y $B backslash A tilde.op B$ (Definición 3.1).
]

#observacion[Verificado en Lean: `Guias.Guia2.Ej03`][
  `ej3a {X} {A B : Set X} (hA : Contable A) (hBA : Infinito ↥(B \ A)) : ∃ C : Set X, C ⊆ B \ A ∧ Coordinables C ↥(C ∪ A)`
  y `ej3b (hAB : A ⊆ B) (hA : Contable A) (hBA : Infinito ↥(B \ A)) : Coordinables ↥(B \ A) ↥B`.
  En (a) el $C$ es `Set.range` de la inyección $NN -> B backslash A$ que da
  `cardLe_nat_of_infinito` (Proposición 3.14), numerable por `Equiv.ofInjective`; "contable e
  infinito $=>$ numerable" es `numerable_iff_contable_infinito` de `Defs.lean`. El Ej. 2 se
  reprueba localmente (`union_contable`, mismo código que `Ej02.lean`), porque los archivos son
  independientes. El hecho de base "$C union A$ contiene al infinito $C$" es `infinito_union_left`,
  probado con `Set.Infinite.mono` de Mathlib (y `numerable_iff` para que $C$ sea infinito).

  En (b), el pegado se formaliza con las descomposiciones disjuntas
  $B backslash A = C union ((B backslash A) backslash C)$ y
  $B = (C union A) union ((B backslash A) backslash C)$ (`pegar`): `Set.equivOfEq` reescribe los
  conjuntos, `Equiv.Set.union` los convierte en sumas `⊕`, y `Equiv.sumCongr e (Equiv.refl _)`
  es "$h$ en $C$, identidad en el resto"; la inyectividad y sobreyectividad de $H$ del texto son
  exactamente la disjunción y la cobertura que esas igualdades exigen. `ej3a` no pide
  $A subset.eq B$ (el texto tampoco lo usa); `ej3b` sí.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 4

#enunciado[Ejercicio 4][Halle el cardinal del conjunto de los números irracionales.]

#estrategia[Es el Ej. 3 (b) con $A = QQ subset.eq B = RR$][
  Los irracionales son $RR backslash QQ$. Para aplicar el Ej. 3 (b) hace falta que $QQ$ sea contable
  (Proposición "Numerabilidad de $QQ$") y que $RR backslash QQ$ sea infinito; esto último sale por
  el absurdo: si fuera finito, $RR = QQ union (RR backslash QQ)$ sería contable (Ej. 2), contra el
  Teorema 3.19. La conclusión $RR backslash QQ tilde.op RR$ da el cardinal $c$.
]

#resolucion[Propuesta: $\#(RR backslash QQ) = c$][
  Tomamos $B = RR$ y $A = QQ subset.eq RR$, con lo cual $B backslash A = RR backslash QQ$ es el
  conjunto de los irracionales. Verificamos las hipótesis del Ej. 3.

  - *$A = QQ$ es contable.* Por la Proposición "Numerabilidad de $QQ$", $\#QQ = aleph_0$, y
    numerable implica contable (Definición 3.6).
  - *$B backslash A = RR backslash QQ$ es infinito.* Supongamos que fuera finito. Entonces
    $RR = QQ union (RR backslash QQ)$ es unión de dos conjuntos contables y, por el Ej. 2, $RR$ es
    contable: finito o numerable. No es numerable por el Teorema 3.19. Tampoco es finito: contiene a
    $NN$, que es infinito, y un subconjunto de un conjunto finito es finito (hechos de base, los
    mismos del Ej. 3 (a)). Absurdo. Luego $RR backslash QQ$ es infinito.

  Por el Ej. 3 (b), $RR backslash QQ tilde.op RR$. Por la Definición 3.5, dos conjuntos
  coordinables tienen el mismo cardinal, y $\#RR = c$; por lo tanto $\#(RR backslash QQ) = c$.
  (Como las dos desigualdades: $\#(RR backslash QQ) <= \#RR$ por la inclusión y
  $\#RR <= \#(RR backslash QQ)$ por la inversa de la biyección; el Teorema 3.11 no hace falta
  porque ya tenemos la biyección.)
]

#observacion[Verificado en Lean: `Guias.Guia2.Ej04`][
  Tres enunciados equivalentes: `ej4 : CardC ↥(Set.univ \ Qr)` con
  `Qr = Set.range ((↑) : ℚ → ℝ)` (la copia de $QQ$ dentro de $RR$: es el $B backslash A$ del
  Ej. 3 con $B = $ `Set.univ`), `ej4_compl : CardC ↥(Set.range ((↑) : ℚ → ℝ))ᶜ` (vía
  `Set.compl_eq_univ_sdiff`) y `ej4_irracionales : CardC ↥{x : ℝ | Irrational x}`. Se eligió
  esta última como la versión "oficial" de "los irracionales" porque `Irrational` es la noción de
  Mathlib, y es exactamente la misma afirmación: `Irrational x` está *definido* como
  `x ∉ Set.range ((↑) : ℚ → ℝ)`, así que `{x | Irrational x}` y `(Set.range (↑))ᶜ` son el mismo
  conjunto por definición (`ej4_irracionales := ej4_compl` tipa sin reescribir nada).

  La prueba sigue el texto: `Qr_numerable` es $NN tilde.op QQ tilde.op$ `Qr` (`numerable_rat` y
  `Equiv.ofInjective` con `Rat.cast_injective`); `irracionales_infinito` es el absurdo con
  `union_contable` (el Ej. 2, reprobado localmente) y `no_contable_real`; `diff_coordinables` es
  el Ej. 3 (b), también reprobado localmente (mismo código que `Ej03.lean`); y `Equiv.Set.univ`
  pasa de `↥Set.univ` a `ℝ`. Único desvío: "$RR$ no es finito" no se prueba vía $NN subset.eq RR$,
  porque `no_contable_real` de `Defs.lean` ya enuncia el Teorema 3.19 en la forma "$RR$ no es
  contable", que descarta de una vez los dos casos.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 5

Sea $(A_n)_(n in NN)$ una sucesión de conjuntos y sea $A = union.big_(n in NN) A_n$.

#enunciado[Ejercicio 5 (a)][
  Encuentre una sucesión $(B_n)_(n in NN)$ de conjuntos disjuntos dos a dos tales que:
  - $B_n subset.eq A_n$ para todo $n in NN$, y
  - $union.big_(n <= m) B_n = union.big_(n <= m) A_n$ para todo $m in NN$.
]

#estrategia[Quitarle a cada $A_n$ lo que ya apareció antes][
  Si a $A_n$ le sacamos todo lo que está en algún $A_k$ con $k < n$, lo que queda ($B_n$) no puede
  tocar a ningún $B_k$ anterior, porque $B_k subset.eq A_k$. Y no se pierde nada: cada $x$ de la
  unión aparece por primera vez en algún $A_k$ (el menor índice, que existe por el buen orden de
  $NN$), y ahí sobrevive en $B_k$.
]

#resolucion[Propuesta: $B_n = A_n backslash union.big_(k < n) A_k$ (en particular $B_1 = A_1$)][
  Definimos, para cada $n in NN$,
  $ B_n = A_n backslash union.big_(k < n) A_k = {x in A_n : x in.not A_k "para todo" k < n}. $
  Para $n = 1$ la unión es vacía y $B_1 = A_1$. Verificamos las tres propiedades.

  *$B_n subset.eq A_n$.* Es inmediato de la definición de diferencia de conjuntos.

  *Disjuntos dos a dos.* Sean $m != n$; por simetría podemos suponer $m < n$. Si $x in B_m$,
  entonces $x in A_m$ (porque $B_m subset.eq A_m$). Pero $m < n$, así que $A_m subset.eq
  union.big_(k < n) A_k$, que es exactamente lo que se le quitó a $A_n$ para formar $B_n$: luego
  $x in.not B_n$. Esto prueba $B_m inter B_n = nothing$.

  *$union.big_(n <= m) B_n = union.big_(n <= m) A_n$ para todo $m$.* La inclusión $subset.eq$
  sale de $B_n subset.eq A_n$ término a término. Para $supset.eq$, sea $x in union.big_(n <= m)
  A_n$, digamos $x in A_n$ con $n <= m$. El conjunto ${k in NN : x in A_k}$ es no vacío (contiene
  a $n$), así que por el buen orden de $NN$ tiene un mínimo $k_0$, y $k_0 <= n <= m$. Por
  definición de mínimo, $x in A_(k_0)$ y $x in.not A_k$ para todo $k < k_0$; es decir,
  $x in A_(k_0) backslash union.big_(k < k_0) A_k = B_(k_0)$. Como $k_0 <= m$,
  $x in union.big_(n <= m) B_n$. $qed$
]

#observacion[Cada punto de $A$ vive en exactamente un $B_n$][
  La demostración muestra algo un poco más preciso, que se va a usar en el Ej. 6 (a): para
  $x in A$, el único $n$ con $x in B_n$ es
  $ n(x) = op("mín") {k in NN : x in A_k}, $
  el *primer* índice en el que aparece $x$. (Es único porque los $B_n$ son disjuntos; es ése
  porque lo acabamos de ver.)
]

#enunciado[Ejercicio 5 (b)][
  Pruebe que para toda sucesión $(B_n)_(n in NN)$ como arriba se tiene que
  $A = union.big_(n in NN) B_n$.
]

#estrategia[Una inclusión es trivial y la otra pasa por las uniones finitas][
  $B_n subset.eq A_n subset.eq A$ da $supset.eq$. Para $subset.eq$: un $x in A$ está en algún
  $A_n$, luego en la unión finita $union.big_(k <= n) A_k$, que por hipótesis coincide con
  $union.big_(k <= n) B_k$. Nótese que *no* hace falta que los $B_n$ sean disjuntos: alcanzan las
  otras dos propiedades.
]

#resolucion[Propuesta: $A = union.big_(n in NN) B_n$ para toda sucesión con esas dos propiedades][
  Sea $(B_n)_(n in NN)$ una sucesión cualquiera con $B_n subset.eq A_n$ para todo $n$ y
  $union.big_(n <= m) B_n = union.big_(n <= m) A_n$ para todo $m in NN$.

  *$supset.eq$.* Si $x in union.big_(n in NN) B_n$, existe $n$ con $x in B_n subset.eq A_n
  subset.eq A$.

  *$subset.eq$.* Si $x in A$, existe $n in NN$ con $x in A_n$. En particular
  $ x in union.big_(k <= n) A_k = union.big_(k <= n) B_k, $
  usando la segunda hipótesis con $m = n$. Luego existe $k <= n$ con $x in B_k$, y entonces
  $x in union.big_(k in NN) B_k$. $qed$

  En particular, la sucesión construida en (a) cumple $union.big_(n in NN) B_n = A$: toda
  sucesión de conjuntos se puede reemplazar por una de conjuntos disjuntos dos a dos, contenidos
  en los originales y con la misma unión.
]

#observacion[Verificado en Lean: `Guias.Guia2.Ej05`][
  La sucesión es `B A n := A n \ ⋃ k < n, A k`. El ítem (a) es `ej5a`, conjunción de
  `B_pairwise_disjoint` (`Pairwise fun m n => Disjoint (B A m) (B A n)`), `B_subset`
  (`B A n ⊆ A n`) y `B_union_le` (`⋃ n ≤ m, B A n = ⋃ n ≤ m, A n` para todo `m`); el índice
  mínimo es `Nat.find` y su propiedad clave es `mem_B_find`. El ítem (b) es
  `ej5b (A B : ℕ → Set X) (hsub : ∀ n, B n ⊆ A n) (hfin : ∀ m, ⋃ n ≤ m, B n = ⋃ n ≤ m, A n) :
  ⋃ n, A n = ⋃ n, B n`, para *toda* sucesión `B` (no usa la disjunción), e `iUnion_B` lo aplica a
  la de (a). Desvío: en Lean `ℕ` empieza en `0`, así que el papel de $B_1 = A_1$ lo cumple
  `B A 0 = A 0`; nada más cambia.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 6

#enunciado[Ejercicio 6 (a)][
  Sea ${A_n}_(n in NN)$ una familia de conjuntos contables. Pruebe que $union.big_(n in NN) A_n$
  es contable.
]

#estrategia[Dos índices por punto: en qué $A_n$ aparece por primera vez y en qué lugar de $A_n$][
  Cada $A_n$ contable se inyecta en $NN$ mediante una $f_n$. A un $x$ de la unión le asignamos el
  par $(n(x), f_(n(x))(x)) in NN times NN$, donde $n(x)$ es el único índice con $x in B_(n(x))$
  para la disjuntización $(B_n)_n$ del Ej. 5 (concretamente, el menor $n$ con $x in A_n$). Usar
  el índice *único* es lo que hace inyectiva a la asignación: si fuéramos a parar a cualquier
  $A_n$ que contenga a $x$, un punto que esté en dos $A_n$ distintos recibiría dos pares. Después
  hace falta comprimir $NN times NN$ en $NN$, y eso lo hace $(n, m) |-> 2^n 3^m$.
]

#sublema(titulo: "Sublema 1: un conjunto contable se inyecta en ℕ")[
  Si $C$ es contable, existe $f : C -> NN$ inyectiva. *Prueba.* Si $C$ es numerable hay una
  biyección $g : NN -> C$ (Definición 3.6) y $f = g^(-1)$ sirve. Si $C$ es finito hay una
  biyección $g : {1, ..., k} -> C$ y tomamos $f = iota compose g^(-1)$, con
  $iota : {1, ..., k} arrow.hook NN$ la inclusión: es inyectiva por ser composición de
  inyectivas. $qed$
]

#sublema(titulo: "Sublema 2: ℕ × ℕ se inyecta en ℕ (deducción propia)")[
  La función $h : NN times NN -> NN$, $h(n, m) = 2^n 3^m$, es inyectiva. *Prueba.* Supongamos
  $2^a 3^b = 2^c 3^d$; por simetría podemos suponer $a <= c$ y escribir $c = a + k$ con
  $k >= 0$. Cancelando $2^a$ (es no nulo) queda $3^b = 2^k 3^d$. Si fuera $k >= 1$, el miembro
  derecho sería par y el izquierdo impar (una potencia de $3$ no es divisible por $2$), absurdo.
  Luego $k = 0$, es decir $a = c$, y $3^b = 3^d$, de donde $b = d$ porque $m |-> 3^m$ es
  estrictamente creciente. $qed$
]

#resolucion[Propuesta: $union.big_(n in NN) A_n$ es contable][
  Llamemos $A = union.big_(n in NN) A_n$.

  *Paso 1: las inyecciones $f_n$.* Por el Sublema 1, para cada $n in NN$ *existe* una inyección
  $f_n : A_n -> NN$. Fijamos una para cada $n$ *simultáneamente*: igual que en la vuelta de la
  Proposición 3.9, esta elección de infinitas funciones a la vez es una aplicación del axioma de
  elección (y es inevitable acá, porque de los $A_n$ sólo sabemos que son contables).

  *Paso 2: el índice $n(x)$.* Sea $(B_n)_(n in NN)$ la sucesión del Ej. 5 (a):
  $B_n = A_n backslash union.big_(k < n) A_k$. Los $B_n$ son disjuntos dos a dos, $B_n subset.eq
  A_n$, y por el Ej. 5 (b) $A = union.big_(n in NN) B_n$. Entonces cada $x in A$ pertenece a
  *exactamente un* $B_n$; llamamos $n(x)$ a ese índice (es el menor $n$ con $x in A_n$, por la
  observación del Ej. 5). Como $B_(n(x)) subset.eq A_(n(x))$, tiene sentido evaluar
  $f_(n(x))(x)$.

  *Paso 3: la inyección en $NN times NN$.* Definimos
  $ F : A -> NN times NN, quad F(x) = (n(x), f_(n(x))(x)). $
  Veamos que $F$ es inyectiva. Si $F(x) = F(y)$, al comparar las primeras coordenadas tenemos
  $n(x) = n(y) =: n$, y al comparar las segundas, $f_n (x) = f_n (y)$ con $x, y in B_n
  subset.eq A_n$. Como $f_n$ es inyectiva en $A_n$, $x = y$.

  *Paso 4: a $NN$.* Con $h$ del Sublema 2, $h compose F : A -> NN$ es inyectiva (composición de
  inyectivas). Por la Definición 3.8, $\#A <= \#NN = aleph_0$.

  *Paso 5: contable.* Si $A = nothing$, es finito (convenimos, como en Lean, que $nothing$ es
  finito con $n = 0$; bajo la lectura literal de la Definición 3.6 este caso no ocurre, porque
  cada $A_n$ contable es no vacío). Si $A != nothing$, sea $g = h compose F$ y $g(A) subset.eq NN$ su
  imagen: $g : A -> g(A)$ es una biyección (es inyectiva y sobre su imagen), así que
  $A tilde.op g(A)$, y $g(A)$ es un subconjunto no vacío del numerable $NN$, luego contable por la
  Proposición 3.13. Ser finito o numerable se transporta por biyecciones (Definición 3.6 y
  Proposición 3.2, transitividad), de modo que $A$ es contable. $qed$
]

#observacion[Qué pasa si se quiere "numerable"][
  La unión puede ser finita (por ejemplo, todos los $A_n$ iguales a un mismo conjunto finito),
  así que lo que se prueba es $\#A <= aleph_0$, y "contable" es lo más que se puede decir en
  general. Si además $A$ es infinito, por la Definición 3.6 (contable y no finito) es numerable:
  así se usa en (b).
]

#enunciado[Ejercicio 6 (b)][
  Sea $A$ un conjunto finito y no vacío y $S = union.big_(m in NN) A^m$. Pruebe que
  $\#S = aleph_0$. _Deduzca que, dado un alfabeto (esto es, un conjunto de símbolos) finito, hay
  más números reales que palabras (esto es, sucesiones finitas de símbolos) definibles con ese
  alfabeto para nombrarlos._
]

#estrategia[Unión numerable de finitos, pero infinita][
  $A^m$ es el conjunto de las $m$-uplas $(a_1, ..., a_m)$ de elementos de $A$, es decir, las
  palabras de longitud $m$; $S$ son las palabras de longitud $>= 1$. Cada $A^m$ es finito
  (inducción), así que por (a) $S$ es contable. Y es infinito porque las palabras
  $a, a a, a a a, ...$ son todas distintas. Contable e infinito es numerable. Para la deducción:
  $aleph_0 < c$ porque $RR$ no es numerable.
]

#sublema(titulo: "Sublema 3: el producto de dos conjuntos finitos es finito (deducción propia)")[
  Si $\#P = p$ y $\#Q = q$ (con $p, q >= 1$) entonces $P times Q$ es finito, con
  $\#(P times Q) = p q$. *Prueba.* Componiendo con las biyecciones ${1, ..., p} -> P$ y
  ${1, ..., q} -> Q$ en cada coordenada, basta ver que ${1, ..., p} times {1, ..., q}
  tilde.op {1, ..., p q}$. La función $(i, j) |-> (i - 1) q + j$ toma valores entre $1$ y
  $(p - 1) q + q = p q$, y es biyectiva por el algoritmo de la división: cada $r in {1, ..., p q}$
  se escribe de manera única como $r - 1 = (i - 1) q + (j - 1)$ con $0 <= j - 1 < q$ (cociente
  $i - 1 in {0, ..., p - 1}$ y resto $j - 1$). $qed$
]

#sublema(titulo: "Sublema 4: Aᵐ es finito para todo m ≥ 1 (deducción propia)")[
  Por inducción en $m$. Para $m = 1$, $A^1 tilde.op A$ (la $1$-upla $(a)$ se identifica con $a$),
  y $A$ es finito por hipótesis. Si $A^m$ es finito, la función
  $ A^(m + 1) -> A times A^m, quad (a_1, a_2, ..., a_(m + 1)) |-> (a_1, (a_2, ..., a_(m + 1))) $
  es una biyección (separar la primera coordenada; su inversa es volver a pegarla), y
  $A times A^m$ es finito por el Sublema 3. Luego $A^(m + 1)$ es finito. $qed$
]

#resolucion[Propuesta: $\#S = aleph_0$][
  *$S$ es contable.* Por el Sublema 4, cada $A^m$ ($m in NN$) es finito y en particular contable.
  Entonces $S = union.big_(m in NN) A^m$ es una unión de una familia $(A^m)_(m in NN)$ de conjuntos
  contables, y por el ítem (a) es contable.

  *$S$ es infinito.* Como $A != nothing$, fijamos $a in A$ y definimos
  $ phi : NN -> S, quad phi(m) = (a, a, ..., a) in A^m quad (m "coordenadas"). $
  Es inyectiva: dos uplas de longitudes distintas son distintas. Si $S$ fuera finito, existiría
  una biyección $psi : {1, ..., k} -> S$ y $psi^(-1) compose phi : NN -> {1, ..., k}$ sería
  inyectiva; restringida a ${1, ..., k + 1}$ daría una inyección ${1, ..., k + 1} -> {1, ..., k}$,
  que no existe (principio del palomar; lo tomamos como hecho de base sobre conjuntos finitos).
  Luego $S$ es infinito.

  *Conclusión.* $S$ es contable y no finito; por la Definición 3.6 (contable $=$ finito o
  numerable), $S$ es numerable: $\#S = aleph_0$. $qed$
]

#resolucion[Propuesta (deducción): hay más reales que palabras, $\#S = aleph_0 < c$][
  Sea $A$ el alfabeto, finito y no vacío. Una palabra es una sucesión finita de símbolos, o sea
  un elemento de $A^m$ para algún $m >= 1$: el conjunto de palabras es exactamente $S$ (si se
  quisiera admitir la palabra vacía, se le agrega un punto y sigue siendo numerable, por el
  Ej. 2 aplicado a $S$ y ${nothing}$). Acabamos de ver que $\#S = aleph_0$. Comparemos con
  $c = \#RR$:

  - *$\#S <= c$.* Hay una biyección $NN -> S$ (numerable), y la inclusión $NN arrow.hook RR$ es
    inyectiva; componiendo la inversa de la primera con la segunda tenemos $S arrow.hook RR$
    inyectiva, es decir $\#S <= \#RR$ (Definición 3.8).
  - *$\#S != c$.* Si existiera una biyección $S -> RR$, componiéndola con la biyección $NN -> S$
    tendríamos $NN tilde.op RR$ (Proposición 3.2, transitividad), es decir, $RR$ sería numerable,
    contra el Teorema 3.19.

  Por la Definición 3.8, $\#S < c$: hay estrictamente más números reales que palabras. En
  particular, cualquier asignación "palabra $|->$ número real que nombra" deja reales sin nombre:
  su imagen tiene cardinal $<= \#S = aleph_0 < c$, así que no es sobreyectiva (si lo fuera, por la
  Proposición 3.9 con $RR != nothing$ tendríamos $c = \#RR <= \#S$, y con CSB, Teorema 3.11,
  $\#S = c$, absurdo). $qed$
]

#observacion[Verificado en Lean: `Guias.Guia2.Ej06`][
  *(a)* `ej6a (A : ℕ → Set X) (h : ∀ n, Contable (A n)) : Contable ↥(⋃ n, A n)`, sin
  `Set.countable_iUnion` ni instancias `Countable`. Los pasos son `embedding_nat_of_contable`
  (Sublema 1), `pow23_injective` y `cardLe_nat_prod_nat` (Sublema 2, con `Nat.Prime.dvd_of_dvd_pow`
  para la paridad y `Nat.pow_right_injective` para $3^b = 3^d$), el índice `idx` (`Nat.find`, el
  menor $n$ con $x in A_n$), la función `F` y `F_injective` (Paso 3), `cardLe_iUnion_nat_prod`
  (Paso 1, con `Classical.choice` para elegir las $f_n$ a la vez) y el cierre con
  `contable_of_cardLe_numerable numerable_nat` (Proposición 3.13). Desvío: en Lean el índice se
  toma directamente como el mínimo en lugar de pasar por los $B_n$ del Ej. 5 (es lo mismo: $x in
  B_n$ si y sólo si $n$ es ese mínimo); los `.lean` son independientes y no importan `Ej05`.

  *(b)* $A^m$ se modela como `Fin m → A` y $S$ como el sigma-tipo `S A := Σ m : ℕ, (Fin (m+1) → A)`:
  las tuplas de longitud $m + 1$ con $m in NN$ desde $0$, o sea las de longitud $>= 1$, cada una
  recordando su longitud (modela $union.big_(m in NN) A^m$ con $NN = {1, 2, ...}$). Los sublemas
  son `finito_prod` (Sublema 3, con la biyección `finProdFinEquiv : Fin p × Fin q ≃ Fin (p*q)` de
  Mathlib en lugar de escribir $(i, j) |-> (i-1) q + j$ a mano) y `finito_pow` (Sublema 4, por
  inducción con `Fin.consEquiv`, que es separar la primera coordenada, y `Equiv.funUnique` para
  $A^1 tilde.op A$). Para aplicar (a), `T m ⊆ S` son las palabras de longitud $m + 1$ vistas
  dentro de `S` (`T_equiv : T m ≃ (Fin (m+1) → A)`, `iUnion_T : ⋃ m, T m = univ`), y
  `contable_S` usa `ej6a` sobre esa familia. `nat_embedding_S` es $phi$, `infinito_S` usa
  `Infinite.of_injective` (el palomar) y `ej6b [Nonempty A] (hA : Finito A) : Numerable (S A)`
  cierra por la Definición 3.6 (`Or.resolve_left`). La deducción es
  `ej6b_deduccion : CardLt (S A) ℝ`, con `cardLt_nat_real` de `Defs.lean` ($aleph_0 < c$). La
  frase sobre los "nombres" no se formaliza por separado: es `CardLt` leído con la
  Proposición 3.9.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 7

Sea $c$ el cardinal de $RR$. En este ejercicio escribimos $X union.sq Y$ para la *unión
disjunta* de dos conjuntos, es decir, el conjunto de las copias etiquetadas
$X union.sq Y = (X times {1}) union (Y times {2})$; si $X tilde.op X'$ e $Y tilde.op Y'$ entonces
$X union.sq Y tilde.op X' union.sq Y'$ (se aplica cada biyección en su copia; es inyectiva y
sobreyectiva porque las etiquetas separan las copias).

#enunciado[Ejercicio 7 (a)][
  Si $\#A = c$ y $\#B = c$, entonces $\#(A union B) = c$.
]

#estrategia[Una desigualdad es la inclusión y la otra es "dos copias de $RR$ caben en $RR$"][
  $c <= \#(A union B)$ sale de $A subset.eq A union B$. Para $\#(A union B) <= c$ se inyecta
  $A union B$ en la unión disjunta $A union.sq B$ (mandando cada $x$ a la copia de $A$ si
  $x in A$ y a la de $B$ si no), y $A union.sq B tilde.op RR union.sq RR tilde.op [0, 1)
  union.sq [1, 2) tilde.op [0, 2) tilde.op RR$ por la Observación 3.21. Se termina con
  Cantor--Schröder--Bernstein.
]

#sublema(titulo: "Sublema 1: ℝ ⊔ ℝ ∼ ℝ (deducción propia)")[
  Por la Observación 3.21, $RR tilde.op [0, 1)$ y $RR tilde.op [1, 2)$, de modo que
  $RR union.sq RR tilde.op [0, 1) union.sq [1, 2)$. La función
  $ [0, 1) union.sq [1, 2) -> [0, 2), quad (t, 1) |-> t, quad (t, 2) |-> t $
  (pegar la identidad de cada intervalo) está bien definida porque $[0, 1) union [1, 2) =
  [0, 2)$; es sobreyectiva por la misma igualdad, e inyectiva porque los dos intervalos son
  disjuntos: si $(t, i)$ y $(s, j)$ tienen la misma imagen entonces $t = s$, y ese valor está en
  uno solo de los dos intervalos, con lo cual $i = j$. Finalmente $[0, 2) tilde.op RR$, otra vez
  por la Observación 3.21. Encadenando con la transitividad de $tilde.op$ (Proposición 3.2),
  $RR union.sq RR tilde.op RR$. $qed$
]

#resolucion[Propuesta: $\#(A union B) = c$][
  *$c <= \#(A union B)$.* La inclusión $A arrow.hook A union B$ es inyectiva, así que
  $\#A <= \#(A union B)$, y $\#A = c$: como $<=$ no depende del representante (Observación 3.10),
  $c <= \#(A union B)$. Concretamente: componer una biyección $RR -> A$ con la inclusión da una
  inyección $RR -> A union B$.

  *$\#(A union B) <= c$.* Definimos
  $ F : A union B -> A union.sq B, quad F(x) = cases((x, 1) & "si" x in A, (x, 2) & "si" x in.not A) $
  que está bien definida porque si $x in A union B$ y $x in.not A$, entonces $x in B$. Es
  inyectiva: si $F(x) = F(y)$, las etiquetas coinciden y también las primeras coordenadas, que
  son $x$ e $y$. Luego $\#(A union B) <= \#(A union.sq B)$.

  Ahora, las hipótesis dan biyecciones $A -> RR$ y $B -> RR$, luego $A union.sq B tilde.op RR
  union.sq RR$, y por el Sublema 1 $RR union.sq RR tilde.op RR$. Por la Observación 3.10,
  $\#(A union B) <= \#(A union.sq B) = \#RR = c$.

  *Conclusión.* Tenemos $\#(A union B) <= c$ y $c <= \#(A union B)$; por el Teorema 3.11
  (Cantor--Schröder--Bernstein), $\#(A union B) = c$. $qed$
]

#enunciado[Ejercicio 7 (b)][
  Si $\#A_n = c$ para todo $n in NN$, entonces $\#(union.big_(n in NN) A_n) = c$.
]

#estrategia[El mismo truco del Ej. 6 (a), con $RR$ en lugar de $NN$ como segunda coordenada][
  Eligiendo biyecciones $e_n : A_n -> RR$ y el primer índice $n(x)$ en el que aparece $x$, la
  asignación $x |-> (n(x), e_(n(x))(x))$ inyecta la unión en $NN times RR$. Después hay que ver que
  $NN times RR$ cabe en $RR$: se cambia $RR$ por $[0, 1)$ y se usa $(n, t) |-> n + t$, que es
  inyectiva porque $n$ es la parte entera de $n + t$. La otra desigualdad es $A_1 subset.eq
  union.big A_n$, y se cierra con CSB.
]

#sublema(titulo: "Sublema 2: #(ℕ × ℝ) ≤ c (deducción propia)")[
  Por la Observación 3.21 hay una biyección $RR -> [0, 1)$, que aplicada en la segunda
  coordenada da $NN times RR tilde.op NN times [0, 1)$. Sea
  $ h : NN times [0, 1) -> RR, quad h(n, t) = n + t. $
  Es inyectiva: si $n + t = m + s$ con $t, s in [0, 1)$, entonces $n - m = s - t$. El miembro
  izquierdo es un entero y el derecho cumple $-1 < s - t < 1$; el único entero estrictamente
  entre $-1$ y $1$ es $0$ (hecho de base: no hay enteros entre $0$ y $1$, ni entre $-1$ y $0$).
  Luego $n = m$ y, por lo tanto, $t = s$. Equivalentemente, $n$ es la parte entera de $n + t$
  (Práctica 1, Ej. 2 (a), visto como que $[n, n + 1)$ contiene un único entero). Componiendo,
  $\#(NN times RR) <= \#RR = c$ (Observación 3.10). $qed$
]

#resolucion[Propuesta: $\#(union.big_(n in NN) A_n) = c$][
  Llamemos $A = union.big_(n in NN) A_n$.

  *$c <= \#A$.* $A_1 subset.eq A$, así que la inclusión $A_1 arrow.hook A$ es inyectiva y
  $c = \#A_1 <= \#A$ (Observación 3.10; concretamente, una biyección $RR -> A_1$ seguida de la
  inclusión es una inyección $RR -> A$).

  *$\#A <= c$.* Para cada $n$ existe una biyección $e_n : A_n -> RR$; las fijamos todas a la vez
  (axioma de elección, como en la Proposición 3.9 y en el Ej. 6 (a)). Para $x in A$ sea
  $n(x) = op("mín") {n in NN : x in A_n}$, que existe por el buen orden de $NN$ porque el conjunto
  es no vacío. Definimos
  $ G : A -> NN times RR, quad G(x) = (n(x), e_(n(x))(x)). $
  Es inyectiva: si $G(x) = G(y)$, las primeras coordenadas dan $n(x) = n(y) =: n$ y las segundas
  $e_n (x) = e_n (y)$ con $x, y in A_n$; como $e_n$ es inyectiva, $x = y$. Luego
  $\#A <= \#(NN times RR) <= c$, por el Sublema 2 y la transitividad de $<=$ (Observación 3.10).

  *Conclusión.* Por el Teorema 3.11 (Cantor--Schröder--Bernstein), $\#A = c$. $qed$
]

#observacion[Verificado en Lean: `Guias.Guia2.Ej07`][
  *(a)* `ej7a {A B : Set X} (hA : CardC A) (hB : CardC B) : CardC ↥(A ∪ B)`, por `teorema_CSB` con
  `cardLe_union_real` ($\#(A union B) <= c$) y `cardLe_real_union` ($c <= \#(A union B)$, vía
  `cardLe_of_subset`). La unión disjunta $X union.sq Y$ es el tipo suma `X ⊕ Y`; la inyección $F$
  es `cardLe_union_sum` (un `if h : x ∈ A then Sum.inl ⟨x, h⟩ else Sum.inr ⟨x, _⟩`) y el
  Sublema 1 es `coordinables_real_sum_real`, que encadena `Equiv.sumCongr` con `cardC_Ico`
  (Observación 3.21), `Equiv.Set.union` ($[0,1) union.sq [1,2) tilde.op [0,1) union [1,2)$, el
  "pegado"; necesita `Set.Ico_disjoint_Ico_same`) y `Set.Ico_union_Ico_eq_Ico`
  ($[0,1) union [1,2) = [0,2)$).

  *(b)* `ej7b (A : ℕ → Set X) (h : ∀ n, CardC (A n)) : CardC ↥(⋃ n, A n)`, por `teorema_CSB` con
  `cardLe_iUnion_real` y `cardLe_real_iUnion` (con `A 0`, porque `ℕ` empieza en `0`). El índice
  mínimo es `idx` (`Nat.find`), la función $G$ es `G` con `G_injective`, las $e_n$ se eligen con
  `Classical.choice`, y el Sublema 2 es `cardLe_nat_prod_real` con `add_injective`, donde la parte
  entera se maneja con `Int.floor_eq_iff` ($floor.l n + t floor.r = n$) en lugar del argumento
  "el único entero entre $-1$ y $1$ es $0$".
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 8

Sea $A$ un conjunto. Escribimos ${0, 1}^A$ para el conjunto de todas las funciones $A -> {0, 1}$.

#enunciado[Ejercicio 8 (a)][
  Pruebe que $cal(P)(A) tilde.op {0, 1}^A$.
]
#estrategia[La función característica][
  Un subconjunto $S subset.eq A$ queda determinado por la función que vale $1$ en $S$ y $0$ fuera
  de $S$ (su función característica $chi_S$). Recíprocamente, una función $f : A -> {0, 1}$
  determina el conjunto $f^(-1)({1})$ donde vale $1$. Las dos asignaciones son inversas una de la
  otra, y por la Definición 3.1 eso es la coordinabilidad.
]
#resolucion[Propuesta: $S |-> chi_S$ es una biyección $cal(P)(A) -> {0, 1}^A$][
  Definimos
  $ Phi : cal(P)(A) -> {0, 1}^A, quad Phi(S) = chi_S, quad "donde" chi_S (a) = cases(1 & "si" a in S, 0 & "si" a in.not S), $
  $ Psi : {0, 1}^A -> cal(P)(A), quad Psi(f) = f^(-1)({1}) = { a in A : f(a) = 1 }. $

  *Están bien definidas.* Para cada $S subset.eq A$ y cada $a in A$ vale exactamente una de
  $a in S$, $a in.not S$, así que $chi_S$ es una función $A -> {0, 1}$. Para cada $f$, $Psi(f)$
  es un subconjunto de $A$, es decir un elemento de $cal(P)(A)$.

  *$Psi compose Phi = id_(cal(P)(A))$.* Sea $S subset.eq A$. Por definición de $chi_S$,
  $chi_S (a) = 1$ si y sólo si $a in S$. Luego
  $ Psi(Phi(S)) = { a in A : chi_S (a) = 1 } = { a in A : a in S } = S. $

  *$Phi compose Psi = id_({0, 1}^A)$.* Sea $f : A -> {0, 1}$ y llamemos $T = Psi(f)$. Hay que
  ver que $chi_T = f$, es decir que $chi_T (a) = f(a)$ para todo $a in A$. Como $f(a) in {0, 1}$,
  hay dos casos:
  - si $f(a) = 1$, entonces $a in T$ por definición de $T$, luego $chi_T (a) = 1 = f(a)$;
  - si $f(a) = 0$, entonces $a in.not T$ (porque $f(a) != 1$), luego $chi_T (a) = 0 = f(a)$.

  Entonces $Phi$ tiene inversa $Psi$, con lo cual es biyectiva, y por la Definición 3.1
  $cal(P)(A) tilde.op {0, 1}^A$. $qed$
]

#enunciado[Ejercicio 8 (b)][
  Concluya que si $\#A = n$ entonces $\#cal(P)(A) = 2^n$.
]
#estrategia[Inducción en $n$ para ${0, 1}^({1, ..., n})$][
  Por (a), y como $tilde.op$ es transitiva (Proposición 3.2), basta ver que
  ${0, 1}^({1, ..., n}) tilde.op {1, ..., 2^n}$ y que ${0, 1}^A tilde.op {0, 1}^({1, ..., n})$.
  Lo primero sale por inducción: una función en ${1, ..., n + 1}$ es "una función en
  ${1, ..., n}$ más el valor en $n + 1$", así que ${0, 1}^({1, ..., n + 1})$ es coordinable con
  ${0, 1}^({1, ..., n}) times {0, 1}$, y un producto $X times {0, 1}$ tiene el doble de elementos
  que $X$. Lo segundo es componer con la biyección $A tilde.op {1, ..., n}$.
]

#sublema(titulo: "Lema 1 (deducción propia): si X ∼ {1, …, m} entonces X × {0, 1} ∼ {1, …, 2m}")[
  Sea $g : X -> {1, ..., m}$ biyectiva. Definimos
  $ h : X times {0, 1} -> {1, ..., 2m}, quad h(x, 0) = g(x), quad h(x, 1) = m + g(x). $
  *Bien definida:* $1 <= g(x) <= m <= 2m$ y $m + 1 <= m + g(x) <= 2m$.

  *Inyectiva:* supongamos $h(x, i) = h(x', i')$. Si $i = i' = 0$ queda $g(x) = g(x')$, y si
  $i = i' = 1$ queda $m + g(x) = m + g(x')$, o sea $g(x) = g(x')$; en ambos casos $x = x'$ porque
  $g$ es inyectiva. Si $i = 0$ e $i' = 1$ tendríamos $g(x) = m + g(x') >= m + 1 > m >= g(x)$,
  absurdo; el caso $i = 1$, $i' = 0$ es el mismo intercambiando $(x, i)$ con $(x', i')$.

  *Sobreyectiva:* sea $j in {1, ..., 2m}$. Si $j <= m$, como $g$ es sobreyectiva existe $x$ con
  $g(x) = j$ y entonces $h(x, 0) = j$. Si $j > m$, entonces $1 <= j - m <= m$, existe $x$ con
  $g(x) = j - m$ y $h(x, 1) = m + (j - m) = j$. $qed$
]

#sublema(titulo: "Lema 2 (deducción propia): {0, 1}^{1, …, n+1} ∼ {0, 1}^{1, …, n} × {0, 1}")[
  Definimos $R(f) = (f|_({1, ..., n}), f(n + 1))$, que a cada $f : {1, ..., n + 1} -> {0, 1}$ le
  asigna su restricción a ${1, ..., n}$ y su valor en $n + 1$, y en sentido contrario
  $ E(g, b) : {1, ..., n + 1} -> {0, 1}, quad E(g, b)(k) = cases(g(k) & "si" k <= n, b & "si" k = n + 1). $
  Para cada $f$, la función $E(R(f))$ vale $f(k)$ en $k <= n$ y $f(n + 1)$ en $n + 1$, es decir
  $E(R(f)) = f$. Para cada $(g, b)$, la restricción de $E(g, b)$ a ${1, ..., n}$ es $g$ y su
  valor en $n + 1$ es $b$, es decir $R(E(g, b)) = (g, b)$. Luego $R$ es biyectiva. $qed$
]

#resolucion[Propuesta: $\#cal(P)(A) = 2^n$][
  *Paso 1: ${0, 1}^({1, ..., n}) tilde.op {1, ..., 2^n}$ para todo $n in NN$* (inducción en $n$).

  _Caso base $n = 1$._ ${0, 1}^({1})$ tiene exactamente dos elementos, las funciones $f_0$ y
  $f_1$ con $f_0 (1) = 0$ y $f_1 (1) = 1$; la asignación $f_0 |-> 1$, $f_1 |-> 2$ es una
  biyección con ${1, 2} = {1, ..., 2^1}$. (Si uno admite $n = 0$ con ${1, ..., 0} = emptyset$,
  también vale: ${0, 1}^emptyset$ tiene un único elemento, la función vacía, y
  ${1, ..., 2^0} = {1}$.)

  _Paso inductivo._ Supongamos ${0, 1}^({1, ..., n}) tilde.op {1, ..., 2^n}$. Por el Lema 2,
  el Lema 1 (con $X = {0, 1}^({1, ..., n})$ y $m = 2^n$) y la transitividad de $tilde.op$
  (Proposición 3.2),
  $ {0, 1}^({1, ..., n + 1}) tilde.op {0, 1}^({1, ..., n}) times {0, 1} tilde.op {1, ..., 2 dot 2^n} = {1, ..., 2^(n + 1)}. $

  *Paso 2: ${0, 1}^A tilde.op {0, 1}^({1, ..., n})$* (deducción propia). Como $\#A = n$, por la
  Definición 3.6 hay una biyección $sigma : {1, ..., n} -> A$. La asignación
  $ f |-> f compose sigma, quad {0, 1}^A -> {0, 1}^({1, ..., n}) $
  es biyectiva, con inversa $g |-> g compose sigma^(-1)$: en efecto
  $(f compose sigma) compose sigma^(-1) = f compose (sigma compose sigma^(-1)) = f$ y
  $(g compose sigma^(-1)) compose sigma = g$.

  *Conclusión.* Encadenando con (a) y la transitividad (Proposición 3.2),
  $ cal(P)(A) tilde.op {0, 1}^A tilde.op {0, 1}^({1, ..., n}) tilde.op {1, ..., 2^n}, $
  y por la Definición 3.6 esto dice exactamente que $\#cal(P)(A) = 2^n$. $qed$
]

#observacion[Verificado en Lean: `Guias.Guia2.Ej08`][
  $cal(P)(A)$ es `Set A`, ${0, 1}$ es `Bool` y ${1, ..., n}$ es `Fin n` (que empieza en $0$, lo
  que no cambia nada). (a) es `ej8a : Coordinables (Set A) (A → Bool)`, con la biyección
  construida a mano en `equivCaracteristica` (`caracteristica S a = decide (a ∈ S)` y
  `soporte f = {a | f a = true}`). (b) es `ej8b : CardEq A n → CardEq (Set A) (2 ^ n)`, que
  encadena `equivCaracteristica`, `Equiv.arrowCongr σ (Equiv.refl Bool)` (el Paso 2) y
  `funBool_equiv_fin n : Nonempty ((Fin n → Bool) ≃ Fin (2 ^ n))`, probado por inducción en
  `n` desde `n = 0` (`Fin 0 → Bool` tiene un único elemento). El Lema 2 es `partirUltimo`
  (`Fin.snocEquiv`) y el Lema 1 es `doble`, que en lugar de la fórmula $h(x, i)$ pasa por
  `Equiv.boolProdEquivSum` (${0, 1} times X tilde.op X union.sq X$), `Equiv.sumCongr g g` y
  `finSumFinEquiv` (${1, ..., m} union.sq {1, ..., m} tilde.op {1, ..., 2m}$, que es la misma
  cuenta "$g(x)$ o $m + g(x)$"). No se usan `Fintype.card_fun`, `Fintype.card_set` ni
  `Equiv.Set.powerset`.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 9

Sean $A$ y $B$ conjuntos. Recordemos que $S in cal(P)(A)$ significa $S subset.eq A$.

#enunciado[Ejercicio 9 (a)][
  Pruebe que $cal(P)(A) inter cal(P)(B) = cal(P)(A inter B)$.
]
#estrategia[Traducir la pertenencia a inclusiones][
  $S$ está en el miembro izquierdo si $S subset.eq A$ y $S subset.eq B$; está en el derecho si
  $S subset.eq A inter B$. Las dos cosas dicen lo mismo elemento a elemento.
]
#resolucion[Propuesta: $cal(P)(A) inter cal(P)(B) = cal(P)(A inter B)$][
  Probamos las dos inclusiones.

  ($subset.eq$) Sea $S in cal(P)(A) inter cal(P)(B)$, es decir $S subset.eq A$ y $S subset.eq B$.
  Dado $s in S$, se tiene $s in A$ y $s in B$, o sea $s in A inter B$. Luego $S subset.eq A inter B$,
  es decir $S in cal(P)(A inter B)$.

  ($supset.eq$) Sea $S in cal(P)(A inter B)$, es decir $S subset.eq A inter B$. Dado $s in S$,
  $s in A inter B$, con lo cual $s in A$ y $s in B$. Luego $S subset.eq A$ y $S subset.eq B$, es
  decir $S in cal(P)(A) inter cal(P)(B)$. $qed$
]

#enunciado[Ejercicio 9 (b)][
  Pruebe que $cal(P)(A) union cal(P)(B) subset.eq cal(P)(A union B)$.
]
#estrategia[Ambos conjuntos están dentro de la unión][
  Si $S subset.eq A$ o $S subset.eq B$, en cualquiera de los dos casos $S subset.eq A union B$
  porque $A subset.eq A union B$ y $B subset.eq A union B$.
]
#resolucion[Propuesta: $cal(P)(A) union cal(P)(B) subset.eq cal(P)(A union B)$, y la inclusión es estricta en general][
  Sea $S in cal(P)(A) union cal(P)(B)$. Entonces $S subset.eq A$ o $S subset.eq B$.
  - Si $S subset.eq A$: dado $s in S$, $s in A$ y por lo tanto $s in A union B$.
  - Si $S subset.eq B$: dado $s in S$, $s in B$ y por lo tanto $s in A union B$.
  En ambos casos $S subset.eq A union B$, es decir $S in cal(P)(A union B)$.

  La otra inclusión es falsa en general: con $A = {1}$ y $B = {2}$ el conjunto $S = {1, 2}$
  cumple $S subset.eq A union B$, pero $S subset.eq.not A$ (porque $2 in S$ y $2 in.not A$) y
  $S subset.eq.not B$ (porque $1 in S$ y $1 in.not B$), así que
  $S in cal(P)(A union B) backslash (cal(P)(A) union cal(P)(B))$. $qed$
]

#enunciado[Ejercicio 9 (c)][
  Pruebe que $A tilde.op B => cal(P)(A) tilde.op cal(P)(B)$.
]
#estrategia[Transportar subconjuntos por la biyección][
  Si $f : A -> B$ es biyectiva, a cada $S subset.eq A$ le asignamos su imagen $f(S) subset.eq B$,
  y a cada $T subset.eq B$ su preimagen $f^(-1)(T) subset.eq A$. Que estas dos asignaciones sean
  inversas es exactamente $f^(-1)(f(S)) = S$ ($f$ inyectiva) y $f(f^(-1)(T)) = T$
  ($f$ sobreyectiva), los ítems (e) y (f) del "Recuerde" de esta Práctica.
]
#resolucion[Propuesta: $S |-> f(S)$ es una biyección $cal(P)(A) -> cal(P)(B)$][
  Como $A tilde.op B$, por la Definición 3.1 existe $f : A -> B$ biyectiva. Definimos
  $ F : cal(P)(A) -> cal(P)(B), quad F(S) = f(S) = { f(s) : s in S }, $
  $ G : cal(P)(B) -> cal(P)(A), quad G(T) = f^(-1)(T) = { a in A : f(a) in T }. $
  Están bien definidas porque $f(S) subset.eq B$ y $f^(-1)(T) subset.eq A$ por definición.

  *$G compose F = id$.* Sea $S subset.eq A$; veamos $f^(-1)(f(S)) = S$ ("Recuerde" (e), que
  reprobamos). Si $a in S$ entonces $f(a) in f(S)$, luego $a in f^(-1)(f(S))$. Recíprocamente, si
  $a in f^(-1)(f(S))$ entonces $f(a) in f(S)$, o sea $f(a) = f(s)$ para algún $s in S$; como $f$ es
  inyectiva, $a = s in S$.

  *$F compose G = id$.* Sea $T subset.eq B$; veamos $f(f^(-1)(T)) = T$ ("Recuerde" (f), que
  reprobamos). Si $b in f(f^(-1)(T))$ entonces $b = f(a)$ con $f(a) in T$, luego $b in T$.
  Recíprocamente, si $b in T$, como $f$ es sobreyectiva existe $a in A$ con $f(a) = b$; entonces
  $f(a) in T$, o sea $a in f^(-1)(T)$, y $b = f(a) in f(f^(-1)(T))$.

  Luego $F$ es biyectiva (tiene inversa $G$) y, por la Definición 3.1,
  $cal(P)(A) tilde.op cal(P)(B)$. $qed$
]

#observacion[Verificado en Lean: `Guias.Guia2.Ej09`][
  En (a) y (b), $A$ y $B$ son subconjuntos `A B : Set X` de un conjunto ambiente y $cal(P)(A)$
  es `𝒫 A = Set.powerset A`; `ej9a : 𝒫 A ∩ 𝒫 B = 𝒫 (A ∩ B)` y
  `ej9b : 𝒫 A ∪ 𝒫 B ⊆ 𝒫 (A ∪ B)` se prueban elemento a elemento con `Set.ext` y
  `Set.mem_powerset_iff` (no se usa `Set.powerset_inter`). El contraejemplo de (b) es
  `ej9b_estricta`, con $A = {0}$, $B = {1}$ y $S = {0, 1}$ en $NN$. En (c), $A$ y $B$ son
  conjuntos abstractos (tipos) y $cal(P)(A)$ es `Set A`: `partesCongr (f : A ≃ B) : Set A ≃ Set B`
  es la biyección `S ↦ f '' S` con inversa `T ↦ f ⁻¹' T`, cuyas dos identidades son
  `Set.preimage_image_eq _ f.injective` y `Set.image_preimage_eq _ f.surjective` (los ítems (e)
  y (f) del "Recuerde", tomados de Mathlib en lugar de reprobarlos); `ej9c` es el enunciado
  `Coordinables A B → Coordinables (Set A) (Set B)`.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 10

Escribimos ${0, 1}^NN$ para el conjunto de las sucesiones $a = (a_n)_(n in NN)$ con
$a_n in {0, 1}$, y $floor(t)$ para la parte entera de $t in RR$: el único entero $m$ con
$m <= t < m + 1$ (existe por Arquímedes y el buen orden, hecho de base).

#enunciado[Ejercicio 10 (a)][
  Pruebe que $[0, 1) tilde.op {0, 1}^NN$. \
  _Sugerencia:_ considere el desarrollo binario de los números del intervalo $[0, 1)$. ¡Ojo!,
  dicho desarrollo no es único.
]
#estrategia[Cantor--Schröder--Bernstein con dos inyecciones][
  Por el Teorema 3.11 basta dar una inyección en cada sentido.
  - $[0, 1) -> {0, 1}^NN$: a cada $x$ le asignamos sus dígitos binarios
    $d_n (x) = floor(2^n x) mod 2$. Definirlos con la parte entera evita elegir "un" desarrollo
    (la sugerencia advierte que $0,0111..._2 = 0,1000..._2$): la fórmula fija uno. Si dos números
    tienen los mismos dígitos, sus partes enteras $floor(2^n x)$ y $floor(2^n y)$ coinciden para
    todo $n$ (inducción), luego $abs(x - y) < 2^(-n)$ para todo $n$ y $x = y$.
  - ${0, 1}^NN -> [0, 1)$: $a |-> sum_(n = 1)^oo a_n / 3^n$. Usar base $3$ con dígitos $0$ y $1$
    es lo que esquiva la no unicidad: el término $1 / 3^k$ es *estrictamente* mayor que toda la
    cola $sum_(n > k) 1 / 3^n = 1 / (2 dot 3^k)$, así que dos sucesiones distintas dan sumas
    distintas (en base $2$ las dos cantidades son iguales, y ahí nace la no unicidad).
]

#sublema(titulo: "Sublema A (deducción propia): recurrencia de las partes enteras")[
  Para $x >= 0$ y $n >= 1$, sea $m_n (x) = floor(2^n x) in NN_0$ y $d_n (x) = m_n (x) mod 2 in {0, 1}$
  (con $m_0 (x) = floor(x)$). Entonces
  $ m_n (x) = 2 m_(n - 1) (x) + d_n (x) quad "para todo" n >= 1. $

  *Prueba.* Sea $m = m_n (x)$ y escribamos $m = 2q + r$ con $q in NN_0$ y $r = d_n (x) in {0, 1}$
  (división por $2$). De $m <= 2^n x < m + 1$, dividiendo por $2$,
  $ q + r / 2 <= 2^(n - 1) x < q + (r + 1) / 2 <= q + 1, $
  y como $r / 2 >= 0$ queda $q <= 2^(n - 1) x < q + 1$. Por la unicidad de la parte entera,
  $q = floor(2^(n - 1) x) = m_(n - 1) (x)$, y por lo tanto $m_n (x) = 2 m_(n - 1) (x) + d_n (x)$. $qed$
]

#sublema(titulo: "Sublema B (deducción propia): los dígitos determinan al número")[
  Sean $x, y in [0, 1)$ con $d_n (x) = d_n (y)$ para todo $n >= 1$. Entonces $x = y$.

  *Prueba.* _(i) $m_n (x) = m_n (y)$ para todo $n >= 0$_, por inducción en $n$. Para $n = 0$,
  $0 <= x < 1$ da $floor(x) = 0 = floor(y)$. Si $m_(n - 1) (x) = m_(n - 1) (y)$, por el Sublema A
  $m_n (x) = 2 m_(n - 1) (x) + d_n (x) = 2 m_(n - 1) (y) + d_n (y) = m_n (y)$.

  _(ii) $abs(x - y) < 1 / 2^n$ para todo $n$._ Llamando $m = m_n (x) = m_n (y)$ tenemos
  $m <= 2^n x < m + 1$ y $m <= 2^n y < m + 1$, de donde $-1 < 2^n x - 2^n y < 1$, es decir
  $2^n abs(x - y) < 1$.

  _(iii) $x = y$._ Si no, $epsilon = abs(x - y) > 0$ y por el Principio de Arquímedes 2
  (Proposición 1) existe $n in NN$ con $1 / n < epsilon$. Como $n < 2^n$ (inducción en $n$, hecho
  de base), $1 / 2^n < 1 / n < epsilon$, lo que contradice (ii). $qed$
]

#sublema(titulo: "Sublema C (deducción propia): la serie Σ aₙ / 3ⁿ y sus colas")[
  Para $a in {0, 1}^NN$ la serie $sum_(n = 1)^oo a_n / 3^n$ converge y
  $0 <= sum_(n = 1)^oo a_n / 3^n <= 1 / 2$. Además, para todo $k >= 0$,
  $sum_(n = k + 1)^oo 1 / 3^n$ converge y vale $1 / (2 dot 3^k)$.

  *Prueba.* La suma geométrica finita (inducción en $N$, hecho de base) da
  $ sum_(n = k + 1)^(k + N) 1 / 3^n = 1 / 3^k dot sum_(j = 1)^N 1 / 3^j = 1 / 3^k dot (1 - 3^(-N)) / 2 . $
  Estas sumas parciales son crecientes y acotadas por $1 / (2 dot 3^k)$, así que la serie
  converge (Proposición "Convergencia de series de términos no negativos") y su suma es el
  supremo de las parciales (Proposición "Convergencia de sucesiones monótonas crecientes"), que
  es $1 / (2 dot 3^k)$ porque $3^(-N) -> 0$ (de nuevo $N < 3^N$ y Arquímedes). Para la serie de
  $a$: $0 <= a_n / 3^n <= 1 / 3^n$ y el caso $k = 0$ dan, por el Criterio de Comparación, que
  converge; sus sumas parciales están entre $0$ y $sum_(n = 1)^N 1 / 3^n <= 1 / 2$, y el límite
  conserva las desigualdades no estrictas. $qed$
]

#resolucion[Propuesta: $[0, 1) tilde.op {0, 1}^NN$][
  *Inyección $Phi : [0, 1) -> {0, 1}^NN$.* Definimos $Phi(x) = (d_n (x))_(n in NN)$, con
  $d_n (x) = floor(2^n x) mod 2 in {0, 1}$ como en el Sublema A. Si $Phi(x) = Phi(y)$, entonces
  $d_n (x) = d_n (y)$ para todo $n$ y el Sublema B da $x = y$. Luego $Phi$ es inyectiva y
  $\#[0, 1) <= \#{0, 1}^NN$ (Definición 3.8).

  *Inyección $Psi : {0, 1}^NN -> [0, 1)$.* Definimos
  $ Psi(a) = sum_(n = 1)^oo a_n / 3^n, $
  que por el Sublema C es un número de $[0, 1 / 2] subset.eq [0, 1)$. Veamos que es inyectiva. Sean
  $a != b$ y sea $k = op("mín") { n in NN : a_n != b_n }$ (buen orden de $NN$). Intercambiando
  los nombres de $a$ y $b$ si hace falta, podemos suponer $a_k = 1$ y $b_k = 0$. Para $N > k$, como
  $a_n = b_n$ si $n < k$ y $a_n - b_n >= -1$ si $n > k$,
  $ sum_(n = 1)^N (a_n - b_n) / 3^n
    = 1 / 3^k + sum_(n = k + 1)^N (a_n - b_n) / 3^n
    >= 1 / 3^k - sum_(n = k + 1)^N 1 / 3^n
    >= 1 / 3^k - 1 / (2 dot 3^k)
    = 1 / (2 dot 3^k), $
  usando en el último paso la cota de las sumas parciales del Sublema C. Haciendo $N -> oo$,
  por el Álgebra de Series el miembro izquierdo tiende a $Psi(a) - Psi(b)$ y, como el límite
  conserva las desigualdades no estrictas,
  $ Psi(a) - Psi(b) >= 1 / (2 dot 3^k) > 0, $
  así que $Psi(a) != Psi(b)$. Luego $Psi$ es inyectiva y $\#{0, 1}^NN <= \#[0, 1)$.

  *Conclusión.* Por el Teorema 3.11 (Cantor--Schröder--Bernstein), $[0, 1) tilde.op {0, 1}^NN$. $qed$

  *Sobre la sugerencia.* La no unicidad del desarrollo binario no molesta en ningún lado: $Phi$
  no "elige" un desarrollo, lo calcula con una fórmula (y sólo necesitamos que sea inyectiva, no
  sobreyectiva: de eso se encarga el Teorema 3.11); y $Psi$ trabaja en base $3$, donde la
  desigualdad estricta $1 / 3^k > sum_(n > k) 1 / 3^n$ impide que dos sucesiones distintas den la
  misma suma.
]

#enunciado[Ejercicio 10 (b)][
  Concluya que $\#cal(P)(NN) = c$.
]
#estrategia[Encadenar tres coordinabilidades][
  $cal(P)(NN) tilde.op {0, 1}^NN$ por el Ej. 8 (a), ${0, 1}^NN tilde.op [0, 1)$ por (a) y
  $[0, 1) tilde.op RR$ por la Observación 3.21.
]
#resolucion[Propuesta: $\#cal(P)(NN) = c$][
  Por el Ej. 8 (a) con $A = NN$, $cal(P)(NN) tilde.op {0, 1}^NN$. Por (a) y la simetría de
  $tilde.op$ (Proposición 3.2), ${0, 1}^NN tilde.op [0, 1)$. Por la Observación 3.21, $RR$ es
  coordinable con cualquier intervalo semiabierto, en particular $[0, 1) tilde.op RR$. Por la
  transitividad (Proposición 3.2),
  $ cal(P)(NN) tilde.op {0, 1}^NN tilde.op [0, 1) tilde.op RR, $
  es decir $\#cal(P)(NN) = \#RR = c$ (Definición 3.5). $qed$
]

#observacion[Verificado en Lean: `Guias.Guia2.Ej10`][
  ${0, 1}^NN$ es `ℕ → Bool`, $[0, 1)$ es `Set.Ico (0:ℝ) 1`, $cal(P)(NN)$ es `Set ℕ`, y los índices
  empiezan en $0$: el dígito `digito x n = decide (⌊2^(n+1) x⌋₊ % 2 = 1)` es el $d_(n + 1)$ del
  texto y el término `termino a n` es $a_(n + 1) / 3^(n + 1)$. (a) es
  `ej10a : Coordinables (Set.Ico 0 1) (ℕ → Bool)`, cerrado con `teorema_CSB` a partir de
  `codigo_injective` y `decodigo_injective`. El Sublema A es `floor_succ` (vía
  `Nat.floor_div_ofNat`, $floor(t / 2) = floor(t) div 2$, y `Nat.div_add_mod`); el Sublema B son
  `floor_eq_of_digitos_eq` (inducción), `abs_sub_lt_of_floor_eq` y `eq_of_forall_abs_sub_lt`
  (Arquímedes como `exists_nat_one_div_lt` más `Nat.lt_two_pow_self`). Para la serie se usan
  `HasSum`/`tsum`: `hasSum_geom_shift` es la geométrica desplazada (de
  `hasSum_geometric_of_lt_one`), `summable_termino` la comparación (`Summable.of_nonneg_of_le`),
  `suma_mem` la cota $0 <= Psi(a) <= 1 / 2$ (`hasSum_le`). En `suma_injective` el primer índice
  distinto es `Nat.find`, y en vez de pasar por sumas parciales se trabaja con la serie entera:
  `hasSum_nat_add_iff` separa la cola a partir de $k + 1$ y `hasSum_le` la compara con la
  geométrica desplazada, obteniendo $abs(a_k - b_k) / 3^(k + 1) <= (1 / 2) dot 1 / 3^(k + 1)$,
  contradicción. (b) es `ej10b : CardC (Set ℕ)`: el Ej. 8 (a) se reprueba localmente como
  `partesEquivFun`, y se encadena con `ej10a` y `cardC_Ico` (Observación 3.21). No se usan
  `Cardinal.mk_real`, `Cardinal.mk_set` ni `Cardinal.continuum`.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 11

#enunciado[Ejercicio 11][
  Pruebe que si $A$ es numerable entonces $cal(P)_f (A) = { B subset.eq A : B "es finito" }$ es
  numerable.
]
#estrategia[Codificar cada conjunto finito con un natural, y ver que hay infinitos][
  Numerable es "contable e infinito" (Definición 3.6). Para lo primero, enumeramos
  $A = {a_1, a_2, a_3, ...}$ y a cada $B$ finito le asignamos el natural
  $sum_(a_k in B) 2^k$: por la unicidad del desarrollo binario esta asignación es inyectiva,
  así que $\#cal(P)_f (A) <= aleph_0$ y la Proposición 3.13 da que es contable. Para lo segundo,
  los conjuntos de un solo elemento ${a_n}$ ya son infinitos.
]

#sublema(titulo: "Lema (deducción propia): unicidad del desarrollo binario")[
  Si $S, T subset.eq NN$ son finitos y $sum_(k in S) 2^k = sum_(k in T) 2^k$, entonces $S = T$.

  *Prueba.* Supongamos $S != T$. Entonces la diferencia simétrica
  $S triangle T = (S backslash T) union (T backslash S)$ es finita y no vacía; sea $k$ su máximo.
  Intercambiando los nombres de $S$ y $T$ si hace falta, podemos suponer $k in S backslash T$.
  Como $k$ es el máximo de $S triangle T$, los elementos mayores que $k$ de $S$ y de $T$ son los
  mismos: ${ j in S : j > k } = { j in T : j > k }$. Separando cada suma en los términos
  $j > k$, $j = k$ y $j < k$ y cancelando los primeros,
  $ sum_(j in S) 2^j - sum_(j in T) 2^j
    = 2^k + sum_(j in S, j < k) 2^j - sum_(j in T, j < k) 2^j
    >= 2^k - sum_(j in T, j < k) 2^j
    >= 2^k - sum_(j = 1)^(k - 1) 2^j. $
  Por la fórmula de la suma geométrica finita (inducción en $k$, hecho de base),
  $sum_(j = 1)^(k - 1) 2^j = 2^k - 2 < 2^k$, así que la diferencia es $>= 2 > 0$ y las sumas no
  pueden ser iguales. Absurdo. $qed$
]

#resolucion[Propuesta: $cal(P)_f (A)$ es numerable][
  Como $A$ es numerable, por la Definición 3.6 hay una biyección $e : NN -> A$; escribimos
  $a_n = e(n)$, de modo que $A = {a_1, a_2, a_3, ...}$ con los $a_n$ distintos (Observación 3.7).

  *Paso 1: $cal(P)_f (A)$ es contable.* Definimos
  $ c : cal(P)_f (A) -> NN, quad c(B) = 1 + sum_(a in B) 2^(e^(-1)(a)) = 1 + sum_(k in e^(-1)(B)) 2^k. $
  La suma es finita porque $B$ lo es, y el $1$ sólo sirve para que $c(emptyset) = 1 in NN$.
  Veamos que $c$ es inyectiva. Si $c(B) = c(B')$, entonces los conjuntos finitos
  $S = e^(-1)(B)$ y $T = e^(-1)(B')$ de naturales cumplen $sum_(k in S) 2^k = sum_(k in T) 2^k$, y
  por el Lema $S = T$. Aplicando $e$ (biyectiva, así que $e(e^(-1)(B)) = B$),
  $B = e(S) = e(T) = B'$.

  Entonces $c$ es una biyección entre $cal(P)_f (A)$ y su imagen $c(cal(P)_f (A)) subset.eq NN$,
  que es no vacía (contiene a $c(emptyset)$). Por la Proposición 3.13 la imagen es a lo sumo
  numerable, y como $cal(P)_f (A) tilde.op c(cal(P)_f (A))$ (Definición 3.1), $cal(P)_f (A)$ es a
  lo sumo numerable (la coordinabilidad preserva ser finito o numerable: se componen las
  biyecciones, Proposición 3.2).

  *Paso 2: $cal(P)_f (A)$ es infinito.* La función $s : NN -> cal(P)_f (A)$, $s(n) = {a_n}$, está
  bien definida (un conjunto de un elemento es finito) y es inyectiva: si ${a_n} = {a_m}$
  entonces $a_n = a_m$ y, como $e$ es inyectiva, $n = m$. Si $cal(P)_f (A)$ fuera finito, con
  $\#cal(P)_f (A) = m$ y una biyección $g : cal(P)_f (A) -> {1, ..., m}$, entonces
  $g compose s : NN -> {1, ..., m}$ sería inyectiva, y su restricción a ${1, ..., m + 1}$ sería
  una inyección ${1, ..., m + 1} -> {1, ..., m}$, lo cual es imposible (principio del palomar,
  hecho de base sobre conjuntos finitos). Luego $cal(P)_f (A)$ es infinito.

  *Conclusión.* Por la Definición 3.6, "contable" es "finito o numerable"; como $cal(P)_f (A)$ es
  contable y no es finito, es numerable. $qed$
]

#observacion[Verificado en Lean: `Guias.Guia2.Ej11`][
  $cal(P)_f (A)$ es el subtipo `{B : Set A // B.Finite}` y el enunciado es
  `ej11 : Numerable A → Numerable {B : Set A // B.Finite}`, obtenido de
  `ej11_contable` y `ej11_infinito` vía `numerable_iff_contable_infinito` (Definición 3.6). La
  codificación es `codificar e B = codigo (B.2.toFinset.map e.symm)` con
  `codigo S = ∑ k ∈ S, 2 ^ k` (como `ℕ` de Lean empieza en $0$, no hace falta el $+ 1$). El Lema
  de unicidad del desarrollo binario es `codigo_injective`, probado de otra manera que en el
  texto: `testBit_codigo` dice que el $i$-ésimo dígito binario de `codigo S` (`Nat.testBit`) es
  $1$ exactamente cuando $i in S$ (inducción sobre `S` agregando el máximo, con
  `Finset.induction_on_max`, `Nat.testBit_two_pow_mul_add` y la cota `codigo_lt`, que es la
  misma suma geométrica $sum_(i < k) 2^i < 2^k$), y `Nat.eq_of_testBit_eq` ("un natural queda
  determinado por sus dígitos binarios") cierra. La contabilidad usa `contable_of_cardLe_numerable`
  (Proposición 3.13 con una inyección en lugar de una inclusión). Para la infinitud, el principio
  del palomar del texto se reemplaza por `Infinite.of_injective` aplicado a `unitario e n = {e n}`.
  No se usa `Set.countable_setOf_finite_subset` ni ninguna instancia `Countable`/`Encodable`.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 12

#enunciado[Ejercicio 12 (a)][
  Pruebe que el conjunto de números primos es numerable.
]

#estrategia[Subconjunto infinito de $NN$][
  Un subconjunto de $NN$ es contable (Proposición 3.13). Si además es infinito, no puede ser
  finito, así que por la Definición 3.6 es numerable. Lo único con contenido es que hay infinitos
  primos, que es un hecho de base de aritmética (Euclides) y se recuerda en una línea.
]

#resolucion[Propuesta: $\#P = aleph_0$][
  Sea $P = {p in NN : p "es primo"} subset.eq NN$. Como $2 in P$, $P != nothing$, y $NN$ es
  numerable (la identidad es una biyección $NN -> NN$). Por la Proposición 3.13, $P$ es contable,
  es decir finito o numerable.

  *$P$ es infinito.* Es un hecho de base de aritmética que para todo $N in NN$ existe un primo
  $p > N$ (Euclides: $N! + 1 >= 2$ tiene algún divisor primo $p$; si fuera $p <= N$, entonces
  $p divides N!$ y por lo tanto $p divides (N! + 1) - N! = 1$, absurdo). Si $P$ fuera finito,
  $P = {p_1, dots, p_n}$ tendría un máximo $N = op("máx") P$ y no habría primos mayores que $N$,
  contradiciendo lo anterior. Luego $P$ no es finito.

  Como $P$ es contable y no es finito, es numerable: $\#P = aleph_0$.
]

#enunciado[Ejercicio 12 (b)][
  Escriba a $NN$ como unión numerable de conjuntos numerables disjuntos dos a dos.
]

#estrategia[Clasificar cada $n$ por la potencia de $2$ que lo divide][
  Todo $n in NN$ se escribe de una única manera como $n = 2^j dot.c i$ con $j >= 0$ e $i$ impar.
  El conjunto $A_k$ de los $n$ con $j = k - 1$ (es decir, $A_1$ = impares, $A_2 = 2 dot.c$ impares,
  $A_3 = 4 dot.c$ impares, ...) es numerable porque está en biyección con los impares, los $A_k$ son
  disjuntos por la unicidad y cubren $NN$ por la existencia. El índice $k$ recorre $NN$, así que la
  unión es numerable.
]

#sublema(titulo: "Lema auxiliar: escritura única n = 2^j · i con i impar (deducción propia)")[
  Para todo $n in NN$ existen únicos $j in NN_0 = {0, 1, 2, dots}$ e $i in NN$ impar tales que
  $n = 2^j dot.c i$.

  *Existencia* (inducción fuerte en $n$). Si $n$ es impar, $n = 2^0 dot.c n$. Si $n$ es par,
  $n = 2 n'$ con $1 <= n' < n$; por hipótesis inductiva $n' = 2^j dot.c i$ con $i$ impar, y
  entonces $n = 2^(j + 1) dot.c i$.

  *Unicidad.* Supongamos $2^j dot.c i = 2^(j') dot.c i'$ con $i, i'$ impares. Si fuera $j < j'$,
  cancelando $2^j$ (que es $> 0$) queda $i = 2^(j' - j) dot.c i' = 2 dot.c (2^(j' - j - 1) i')$,
  que es par, contra $i$ impar. Por simetría tampoco $j > j'$. Luego $j = j'$, y cancelando $2^j$
  queda $i = i'$. $qed$
]

#resolucion[Propuesta: $NN = union.big_(k in NN) A_k$ con $A_k = {2^(k - 1) (2m - 1) : m in NN}$][
  Para cada $k in NN$ definimos
  $ A_k = {2^(k - 1) (2m - 1) : m in NN} subset.eq NN, $
  el conjunto de los naturales que son $2^(k - 1)$ por un impar.

  *Cada $A_k$ es numerable.* La función $f_k : NN -> A_k$, $f_k (m) = 2^(k - 1) (2m - 1)$ es
  sobreyectiva por la propia definición de $A_k$, e inyectiva: si
  $2^(k - 1) (2m - 1) = 2^(k - 1) (2m' - 1)$, cancelando $2^(k - 1) > 0$ queda $2m - 1 = 2m' - 1$ y
  $m = m'$. Luego $f_k$ es una biyección y $\#A_k = aleph_0$ (Definición 3.6).

  *Son disjuntos dos a dos.* Si $n in A_k inter A_l$, entonces
  $n = 2^(k - 1) (2m - 1) = 2^(l - 1) (2m' - 1)$ con $2m - 1$ y $2m' - 1$ impares; por la unicidad
  del Lema, $k - 1 = l - 1$, es decir $k = l$. Luego $A_k inter A_l = nothing$ si $k != l$.

  *Cubren $NN$.* Dado $n in NN$, por la existencia del Lema $n = 2^j dot.c i$ con $i$ impar, es
  decir $i = 2m - 1$ para algún $m in NN$. Entonces $n = 2^((j + 1) - 1) (2m - 1) in A_(j + 1)$.
  Como además cada $A_k subset.eq NN$, se tiene $NN = union.big_(k in NN) A_k$.

  La familia está indexada por $k in NN$, que es numerable, así que $NN$ es unión numerable de
  conjuntos numerables disjuntos dos a dos.
]

#observacion[Verificado en Lean: `Guias.Guia2.Ej12`][
  `ej12a : Numerable Primos`, con `Primos = {p | Nat.Prime p}`. La infinitud de los primos es
  `infinito_primos`, deducida del hecho de base `Nat.exists_infinite_primes` (para todo $N$ hay un
  primo $p >= N$), declarado como tal: un subconjunto finito de $NN$ está acotado
  (`Set.Finite.bddAbove`), y eso contradice el primo $p >= N + 1$. El resto es
  `numerable_iff_contable_infinito` + `contable_of_cardLe_numerable` (Prop. 3.13 y 3.14).

  `ej12b : ∃ A : ℕ → Set ℕ, (∀ k, Numerable (A k)) ∧ (∀ k l, k ≠ l → Disjoint (A k) (A l)) ∧ ⋃ k, A k = Set.univ`.
  Como en Lean $NN$ empieza en $0$, se usa $A_k = {n : n + 1 = 2^k (2m + 1) "para algún" m}$ con
  $k = 0, 1, 2, dots$, que es la familia del texto corrida en una unidad (y reindexada desde $0$).
  El Lema es `descomposicion` (inducción fuerte, `Nat.strong_induction_on` + `Nat.even_or_odd`)
  y `unicidad` (cancelar $2^k$ con `Nat.eq_of_mul_eq_mul_left` y paridad por `omega`); no se usa
  `Nat.exists_eq_two_pow_mul_odd` de Mathlib. `numerable_A` es la biyección
  $m |-> 2^k (2m + 1) - 1$ (`Equiv.ofBijective`).
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 13

#enunciado[Ejercicio 13][
  Calcule el cardinal del conjunto $Omega = {B subset.eq NN : \#B = \#(NN backslash B) = aleph_0}$.
]

#estrategia[Encajar $Omega$ entre $cal(P)(NN)$ y una copia de ${0, 1}^NN$][
  Por un lado $Omega subset.eq cal(P)(NN)$ y $\#cal(P)(NN) = c$ (Ej. 10 (b)), lo que da
  $\#Omega <= c$. Por el otro, hay que meter $RR$ en $Omega$: $RR$ se inyecta en $cal(P)(QQ)$ por
  cortes ($x |-> {q in QQ : q < x}$), $cal(P)(QQ) tilde.op cal(P)(NN) tilde.op {0, 1}^NN$ (Ej. 9 (c),
  Ej. 8 (a)), y una sucesión $a in {0, 1}^NN$ elige, de cada par ${2n - 1, 2n}$, un elemento según
  $a_n$: el conjunto elegido y su complemento tienen un elemento de cada par, así que son infinitos.
  Se cierra con Cantor--Schröder--Bernstein.
]

#sublema(titulo: "Lema auxiliar 1: cortes, una inyección ℝ → 𝒫(ℚ) (deducción propia)")[
  La función $gamma : RR -> cal(P)(QQ)$, $gamma(x) = {q in QQ : q < x}$ es inyectiva.

  *Prueba.* Sean $x != y$; sin pérdida de generalidad $x < y$ (el otro caso es el mismo con los
  roles de $x$ e $y$ intercambiados). Por la densidad de $QQ$ (Proposición 2) existe $q in QQ$
  con $x < q < y$. Entonces $q in gamma(y)$ pero $q in.not gamma(x)$ (porque $q > x$), así que
  $gamma(x) != gamma(y)$. $qed$
]

#sublema(titulo: "Lema auxiliar 2: una inyección {0,1}^ℕ → Ω (deducción propia)")[
  Para $a = (a_n)_(n in NN) in {0, 1}^NN$ definimos
  $ Phi(a) = {2n : n in NN, a_n = 1} union {2n - 1 : n in NN, a_n = 0} subset.eq NN. $
  Entonces $Phi(a) in Omega$ para todo $a$, y $Phi : {0, 1}^NN -> Omega$ es inyectiva.

  *Prueba.* Los pares $P_n = {2n - 1, 2n}$, $n in NN$, son disjuntos dos a dos y cubren $NN$
  (todo natural es $2n$ o $2n - 1$ para un único $n$). Por construcción, $Phi(a)$ contiene
  *exactamente un* elemento de cada $P_n$: $2n$ si $a_n = 1$ y $2n - 1$ si $a_n = 0$. Luego la
  función $NN -> Phi(a)$ que a $n$ le asigna ese elemento es una biyección (sobreyectiva porque
  todo elemento de $Phi(a)$ está en algún $P_n$ y es el elegido allí; inyectiva porque los $P_n$
  son disjuntos). Así $\#Phi(a) = aleph_0$. Del mismo modo $NN backslash Phi(a)$ contiene
  exactamente el *otro* elemento de cada $P_n$ ($2n - 1$ si $a_n = 1$, $2n$ si $a_n = 0$), y la
  misma cuenta da $\#(NN backslash Phi(a)) = aleph_0$. Por lo tanto $Phi(a) in Omega$.

  *Inyectividad.* Por construcción, $2n in Phi(a) <==> a_n = 1$. Si $Phi(a) = Phi(b)$, entonces
  para todo $n$: $a_n = 1 <==> 2n in Phi(a) <==> 2n in Phi(b) <==> b_n = 1$, y como los valores
  posibles son sólo $0$ y $1$, $a_n = b_n$ para todo $n$, es decir $a = b$. $qed$
]

#resolucion[Propuesta: $\#Omega = c$][
  *$\#Omega <= c$.* La inclusión $Omega arrow.hook cal(P)(NN)$ es inyectiva, así que
  $\#Omega <= \#cal(P)(NN)$ (Definición 3.8). Por el Ej. 10 (b), $\#cal(P)(NN) = c$, es decir
  $cal(P)(NN) tilde.op RR$; por la buena definición de $<=$ (Observación 3.10) resulta
  $\#Omega <= \#RR = c$.

  *$c <= \#Omega$.* Componemos las siguientes funciones inyectivas:
  $ RR arrow.hook^(gamma) cal(P)(QQ) arrow.r^(tilde.op) cal(P)(NN) arrow.r^(tilde.op) {0, 1}^NN arrow.hook^(Phi) Omega. $
  La primera es el Lema 1. La segunda es una biyección: $QQ tilde.op NN$ (Proposición
  "Numerabilidad de $QQ$") y entonces $cal(P)(QQ) tilde.op cal(P)(NN)$ por el Ej. 9 (c). La
  tercera es la biyección del Ej. 8 (a), $cal(P)(NN) tilde.op {0, 1}^NN$. La cuarta es el Lema 2.
  La composición de inyectivas es inyectiva, así que $\#RR <= \#Omega$, es decir $c <= \#Omega$.

  *Conclusión.* Por el Teorema 3.11 (Cantor--Schröder--Bernstein), $\#Omega = \#RR = c$.
]

#observacion[Verificado en Lean: `Guias.Guia2.Ej13`][
  `ej13 : CardC Omega`, con `Omega : Set (Set ℕ) := {B | Numerable B ∧ Numerable ↥(Bᶜ)}`
  ($cal(P)(NN)$ es `Set ℕ`). La prueba es `teorema_CSB cardLe_Omega_real cardLe_real_Omega`.

  Como los archivos son independientes, lo que el texto cita se reprueba localmente:
  - $\#cal(P)(NN) <= c$ (parte del Ej. 10 (b)): `setEquivBool : Set ℕ ≃ (ℕ → Bool)` (Ej. 8 (a),
    función característica) seguido de `serieEmb : (ℕ → Bool) ↪ ℝ`, la serie
    $a |-> sum_(n >= 0) a_n \/ 3^(n + 1)$ (`tsum`). Su inyectividad (`serie_injective`) toma el
    primer índice $N$ donde $a_N != b_N$ (`Nat.find`) y usa que la cola
    $sum_(n > N) 1 \/ 3^(n + 1) = (1 \/ 3)^(N + 1) \/ 2$ es menor que el término $1 \/ 3^(N + 1)$
    (`tsum_tail_le`, con `tsum_geometric_of_lt_one`, `Summable.sum_add_tsum_nat_add`,
    `Summable.tsum_eq_zero_add`, `Summable.tsum_le_tsum`). Esto no está en el texto, que cita el
    Ej. 10 (b).
  - $cal(P)(QQ) tilde.op cal(P)(NN)$ (Ej. 9 (c)): `setRatEquivSetNat`, vía
    $cal(P)(QQ) tilde.op {0, 1}^QQ tilde.op {0, 1}^NN tilde.op cal(P)(NN)$ con `Equiv.arrowCongr`
    y la biyección `numerable_rat`.
  - Lema 1 es `corte_injective` (con `exists_rat_btwn`, la Prop. 2); Lema 2 es `Phi_mem` y
    `Phi_injective`. Como en Lean $NN$ empieza en $0$, los pares son ${2n, 2n + 1}$ y
    $Phi(a) = {m : a_(m \/ 2) = 1 <==> m "par"}$; que $Phi(a)$ y su complemento son numerables
    se prueba con `numerable_iff_contable_infinito` y una inyección $NN -> Phi(a)$
    (`Infinite.of_injective`), que es la biyección del texto restringida a una dirección.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 14

#enunciado[Ejercicio 14 (a)][
  Calcule el cardinal de $cal(P)(NN) times cal(P)(NN)$.
]

#estrategia[Intercalar dos sucesiones de ceros y unos][
  $cal(P)(NN) tilde.op {0, 1}^NN$ (Ej. 8 (a)), así que basta ver que
  ${0, 1}^NN times {0, 1}^NN tilde.op {0, 1}^NN$: dos sucesiones $a, b$ se funden en una sola
  poniendo $a$ en los lugares impares y $b$ en los pares, y el proceso se deshace leyendo las
  posiciones impares y las pares. Después $\#cal(P)(NN) = c$ (Ej. 10 (b)).
]

#sublema(titulo: "Lema auxiliar 1: {0,1}^ℕ × {0,1}^ℕ ∼ {0,1}^ℕ (deducción propia)")[
  Sea $Psi : {0, 1}^NN times {0, 1}^NN -> {0, 1}^NN$ dada por $Psi(a, b) = c$ con
  $ c_(2n - 1) = a_n, quad c_(2n) = b_n quad (n in NN). $
  Está bien definida porque todo $m in NN$ es $2n - 1$ o $2n$ para un único $n$. Sea
  $Theta : {0, 1}^NN -> {0, 1}^NN times {0, 1}^NN$, $Theta(c) = ((c_(2n - 1))_(n in NN), (c_(2n))_(n in NN))$.
  Entonces $Theta compose Psi = op("id")$: la primera componente de $Theta(Psi(a, b))$ es
  $(c_(2n - 1))_n = (a_n)_n = a$ y la segunda es $(c_(2n))_n = b$. Y $Psi compose Theta = op("id")$:
  si $(a, b) = Theta(c)$, entonces $Psi(a, b)$ vale $a_n = c_(2n - 1)$ en el lugar $2n - 1$ y
  $b_n = c_(2n)$ en el lugar $2n$, o sea, coincide con $c$ en todo lugar. Luego $Psi$ es una
  biyección (tiene inversa $Theta$). $qed$
]

#resolucion[Propuesta: $\#(cal(P)(NN) times cal(P)(NN)) = c$][
  Por el Ej. 8 (a) hay una biyección $chi : cal(P)(NN) -> {0, 1}^NN$. Entonces
  $(A, B) |-> (chi(A), chi(B))$ es una biyección $cal(P)(NN) times cal(P)(NN) -> {0, 1}^NN times {0, 1}^NN$
  (su inversa es $(a, b) |-> (chi^(-1)(a), chi^(-1)(b))$). Componiendo con el Lema 1 y con
  $chi^(-1)$,
  $ cal(P)(NN) times cal(P)(NN) tilde.op {0, 1}^NN times {0, 1}^NN tilde.op {0, 1}^NN tilde.op cal(P)(NN), $
  y por transitividad (Proposición 3.2) $cal(P)(NN) times cal(P)(NN) tilde.op cal(P)(NN)$. Como
  $\#cal(P)(NN) = c$ (Ej. 10 (b)), es decir $cal(P)(NN) tilde.op RR$, de nuevo por transitividad
  $cal(P)(NN) times cal(P)(NN) tilde.op RR$: $\#(cal(P)(NN) times cal(P)(NN)) = c$.
]

#enunciado[Ejercicio 14 (b)][
  Calcule el cardinal de $[0, 1) times [0, 1)$.
]

#estrategia[Reducir a $RR times RR tilde.op RR$][
  $[0, 1) tilde.op RR$ (Observación 3.21), así que $[0, 1) times [0, 1) tilde.op RR times RR$. Para
  $RR times RR$: $x |-> (x, 0)$ da $c <= \#(RR times RR)$, y para la otra desigualdad se inyecta
  $RR times RR$ en $cal(P)(QQ) times cal(P)(QQ)$ con los cortes del Ej. 13, que tiene cardinal $c$
  por (a). Cantor--Schröder--Bernstein.
]

#sublema(titulo: "Lema auxiliar 2: ℝ × ℝ ∼ ℝ (deducción propia)")[
  *$c <= \#(RR times RR)$.* La función $RR -> RR times RR$, $x |-> (x, 0)$ es inyectiva: si
  $(x, 0) = (y, 0)$ entonces $x = y$.

  *$\#(RR times RR) <= c$.* Sea $gamma : RR -> cal(P)(QQ)$, $gamma(x) = {q in QQ : q < x}$, que es
  inyectiva por el Lema 1 del Ej. 13. Entonces $(x, y) |-> (gamma(x), gamma(y))$ es una inyección
  $RR times RR -> cal(P)(QQ) times cal(P)(QQ)$: si $(gamma(x), gamma(y)) = (gamma(x'), gamma(y'))$,
  entonces $gamma(x) = gamma(x')$ y $gamma(y) = gamma(y')$, luego $x = x'$ e $y = y'$. Además
  $cal(P)(QQ) tilde.op cal(P)(NN)$ (Ej. 9 (c), porque $QQ tilde.op NN$ por la Proposición
  "Numerabilidad de $QQ$"), de donde $cal(P)(QQ) times cal(P)(QQ) tilde.op cal(P)(NN) times cal(P)(NN)$
  (biyección componente a componente, como en (a)), y $cal(P)(NN) times cal(P)(NN) tilde.op RR$
  por el ítem (a). Componiendo la inyección con estas biyecciones queda una inyección
  $RR times RR -> RR$, es decir $\#(RR times RR) <= c$.

  Por el Teorema 3.11 (Cantor--Schröder--Bernstein), $RR times RR tilde.op RR$. $qed$
]

#resolucion[Propuesta: $\#([0, 1) times [0, 1)) = c$][
  Por la Observación 3.21 existe una biyección $h : [0, 1) -> RR$. Entonces
  $(x, y) |-> (h(x), h(y))$ es una biyección $[0, 1) times [0, 1) -> RR times RR$ (inversa
  $(u, v) |-> (h^(-1)(u), h^(-1)(v))$), es decir $[0, 1) times [0, 1) tilde.op RR times RR$. Por el
  Lema 2, $RR times RR tilde.op RR$, y por transitividad (Proposición 3.2)
  $[0, 1) times [0, 1) tilde.op RR$: $\#([0, 1) times [0, 1)) = c$.
]

#enunciado[Ejercicio 14 (c)][
  Calcule el cardinal de $RR^k$ para cada $k in NN$.
]

#estrategia[Inducción en $k$ con el Lema 2][
  $RR^1 = RR$. Separando la última coordenada, $RR^(k + 1) tilde.op RR^k times RR$; por hipótesis
  inductiva $RR^k tilde.op RR$, así que $RR^(k + 1) tilde.op RR times RR tilde.op RR$.
]

#resolucion[Propuesta: $\#RR^k = c$ para todo $k in NN$][
  Por inducción en $k >= 1$.

  *Caso $k = 1$.* $RR^1 = RR$, y $\#RR = c$ por definición de $c$.

  *Paso inductivo.* Supongamos $RR^k tilde.op RR$ y sea $e : RR^k -> RR$ una biyección. La función
  $ RR^(k + 1) -> RR^k times RR, quad (x_1, dots, x_k, x_(k + 1)) |-> ((x_1, dots, x_k), x_(k + 1)) $
  es una biyección (su inversa pega la tupla y la última coordenada). Luego
  $(x, t) |-> (e(x), t)$ es una biyección $RR^k times RR -> RR times RR$ (inversa
  $(u, t) |-> (e^(-1)(u), t)$), y $RR times RR tilde.op RR$ por el Lema 2. Encadenando con la
  Proposición 3.2,
  $ RR^(k + 1) tilde.op RR^k times RR tilde.op RR times RR tilde.op RR, $
  es decir $\#RR^(k + 1) = c$. Esto completa la inducción.
]

#observacion[Verificado en Lean: `Guias.Guia2.Ej14`][
  `ej14a : CardC (Set ℕ × Set ℕ)`, `ej14b : CardC (Set.Ico (0:ℝ) 1 × Set.Ico (0:ℝ) 1)` y
  `ej14c (k : ℕ) (hk : 1 ≤ k) : CardC (Fin k → ℝ)` ($cal(P)(NN)$ es `Set ℕ`, ${0, 1}$ es `Bool`,
  $RR^k$ es `Fin k → ℝ`).

  El Lema 1 es `intercalar : (ℕ → Bool) × (ℕ → Bool) ≃ (ℕ → Bool)` con exactamente $Psi$ y
  $Theta$ (en Lean $NN$ empieza en $0$: $a$ va a los lugares pares $2n$ y $b$ a los impares
  $2n + 1$; las cuentas con `/ 2` y `% 2` las cierra `omega`). El Lema 2 es `cardC_real_prod`
  (`teorema_CSB` de `cardLe_real_prod_real` y `cardLe_real_real_prod`). En (c), `cardC_pi` hace la
  inducción con `Fin.consEquiv`, que separa la *primera* coordenada en lugar de la última (es la
  misma idea; sólo cambia qué coordenada se aparta), y `Equiv.funUnique` para $RR^1 tilde.op RR$.

  Lo que el texto cita de ejercicios anteriores se reprueba localmente: Ej. 8 (a) es
  `setEquivBool` (función característica); Ej. 9 (c) para $QQ tilde.op NN$ es `setRatEquivSetNat`
  (vía `Equiv.arrowCongr`); los cortes del Ej. 13 son `corte_injective` (`exists_rat_btwn`);
  y $\#cal(P)(NN) = c$ (Ej. 10 (b)) es `cardC_set_nat`, cuya mitad $\#cal(P)(NN) <= c$ se prueba
  con la serie $a |-> sum a_n \/ 3^(n + 1)$ (`serieEmb`, con `tsum_geometric_of_lt_one`,
  `Summable.sum_add_tsum_nat_add`, `Summable.tsum_eq_zero_add`, `Summable.tsum_le_tsum`), que no
  aparece en el texto. $[0, 1) tilde.op RR$ es `cardC_Ico` (Obs. 3.21, de `Defs.lean`).
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 15

#enunciado[Ejercicio 15][
  Calcule el cardinal de $RR[X]$, esto es, el conjunto formado por todos los polinomios con
  coeficientes reales.
]

#estrategia[Un polinomio es una tupla finita de coeficientes][
  Los polinomios constantes dan $c <= \#RR[X]$. Para la otra desigualdad, un polinomio de grado
  $n$ queda determinado por sus $n + 1$ coeficientes, así que $RR[X]$ se inyecta en la unión
  disjunta de los $RR^(n + 1)$, $n >= 0$: una unión numerable de conjuntos de cardinal $c$
  (Ej. 14 (c)), que tiene cardinal $c$ por el Ej. 7 (b). Cantor--Schröder--Bernstein.
]

#resolucion[Propuesta: $\#RR[X] = c$][
  *$c <= \#RR[X]$.* La función $RR -> RR[X]$, $a |-> a$ (el polinomio constante $a$) es
  inyectiva: dos constantes son el mismo polinomio sólo si tienen el mismo coeficiente. Luego
  $\#RR <= \#RR[X]$ (Definición 3.8).

  *$\#RR[X] <= c$.* Para $n in NN$ sea $S_n = {n} times RR^n$, y sea $S = union.big_(n in NN) S_n$
  (una unión disjunta de copias de los $RR^n$). Definimos $F : RR[X] -> S$ así: si
  $p = a_0 + a_1 X + dots + a_d X^d$ tiene grado $d$ (con la convención de que el polinomio nulo
  tiene grado $d = 0$ y coeficiente $a_0 = 0$), ponemos
  $ F(p) = (d + 1, (a_0, a_1, dots, a_d)) in S_(d + 1). $

  *$F$ es inyectiva.* Si $F(p) = F(q)$, entonces $p$ y $q$ tienen el mismo grado $d$ (primera
  componente) y los mismos coeficientes $a_0, dots, a_d$ (segunda componente). Los coeficientes de
  índice mayor que $d$ son $0$ en ambos (por definición de grado). Como un polinomio queda
  determinado por la sucesión de todos sus coeficientes, $p = q$.

  *$\#S = c$.* Para cada $n in NN$, $S_n = {n} times RR^n tilde.op RR^n$ (vía $(n, x) |-> x$), y
  $\#RR^n = c$ por el Ej. 14 (c); luego $\#S_n = c$ para todo $n$ (Proposición 3.2). Por el
  Ej. 7 (b), la unión numerable $S = union.big_(n in NN) S_n$ tiene $\#S = c$, es decir
  $S tilde.op RR$.

  Componiendo $F$ con una biyección $S -> RR$ queda una inyección $RR[X] -> RR$:
  $\#RR[X] <= c$.

  *Conclusión.* Por el Teorema 3.11 (Cantor--Schröder--Bernstein), $\#RR[X] = c$.
]

#observacion[Verificado en Lean: `Guias.Guia2.Ej15`][
  `ej15 : CardC (Polynomial ℝ)`, por `teorema_CSB cardLe_poly_real cardLe_real_poly`.
  La inyección de los constantes es `Polynomial.C` con `Polynomial.C_injective`.

  La unión disjunta $S$ se formaliza como el tipo suma `Σ n : ℕ, (Fin (n + 1) → ℝ)` (índice
  $n$ = grado, desde $0$), y $F$ es `coefs p = ⟨p.natDegree, fun i => p.coeff i⟩`
  (`Polynomial.natDegree 0 = 0`, como la convención del texto). `coefs_injective` sigue el texto:
  mismo grado y mismos coeficientes hasta el grado (`heq_apply` desarma la igualdad heterogénea de
  tuplas de la misma longitud), ceros más allá del grado (`Polynomial.coeff_eq_zero_of_natDegree_lt`)
  y `Polynomial.ext`.

  Lo citado de ejercicios anteriores se reprueba localmente: $\#RR^(n + 1) = c$ (Ej. 14 (c)) es
  `cardC_pi`, con toda su cadena ($RR times RR tilde.op RR$ vía cortes, $cal(P)(QQ) tilde.op cal(P)(NN)$,
  intercalado y la serie $a |-> sum a_n \/ 3^(n + 1)$, igual que en `Ej14.lean`); y el Ej. 7 (b)
  se reemplaza por `cardLe_nat_prod_real : CardLe (ℕ × ℝ) ℝ`: se escribe $RR tilde.op [0, 1)$
  (`cardC_Ico`, Obs. 3.21) y $(n, x) |-> n + x$ es inyectiva en $NN times [0, 1)$ porque
  $n = floor(n + x)$ recupera $n$ (`Int.floor_natCast_add`, `Int.floor_eq_zero_iff`). El pasaje
  de `Σ n, ℝ^(n+1)` a `ℕ × ℝ` usa en cada $n$ una biyección $RR^(n + 1) tilde.op RR$
  (`Function.Embedding.sigmaMap`, `Equiv.sigmaEquivProd`). No se usa ningún lema de Mathlib
  sobre el cardinal de `Polynomial`.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 16

#enunciado[Ejercicio 16 (a)][
  Calcule el cardinal de ${(a_n)_(n in NN) subset.eq ZZ : (a_n)_(n in NN) "converge"}$.
]

#estrategia[Una sucesión convergente de enteros es eventualmente constante][
  Con $epsilon = 1/2$ en la Definición 7, a partir de un $n_0$ todos los términos están a distancia
  menor que $1$ entre sí, y dos enteros a distancia menor que $1$ son iguales. Así la sucesión queda
  determinada por un dato finito: su "cabeza" $(a_1, dots, a_N)$ hasta el primer índice $N$ desde el
  cual es constante. Eso da una inyección del conjunto en $union.big_(N in NN) ZZ^N$, que es contable
  por el Ej. 6 (a). Las sucesiones constantes lo hacen infinito, y contable e infinito es numerable.
]

#sublema(titulo: [Lema A ($\#ZZ <= aleph_0$ y $\#(NN times NN) <= aleph_0$; deducción propia)])[
  *(i)* La función $c : ZZ -> NN_0 = NN union {0}$ dada por $c(z) = 2z$ si $z >= 0$ y
  $c(z) = -2z - 1$ si $z < 0$ es inyectiva: los $z >= 0$ van a pares y los $z < 0$ a impares, así
  que $c(z) = c(z')$ obliga a que $z, z'$ tengan el mismo signo, y en cada rama $c$ es
  estrictamente monótona. Como $NN_0 tilde.op NN$ ($k |-> k + 1$), queda $\#ZZ <= \#NN = aleph_0$.
  (También sale del Ej. 1 (c): $ZZ arrow.hook ZZ times NN$ vía $z |-> (z, 1)$ y
  $\#(ZZ times NN) = aleph_0$.)

  *(ii)* La función $pi : NN_0 times NN_0 -> NN$, $pi(m, n) = 2^m (2n + 1)$, es inyectiva.
  Supongamos $2^m (2n + 1) = 2^(m') (2n' + 1)$ y, sin pérdida de generalidad, $m <= m'$.
  Cancelando $2^m$ queda $2n + 1 = 2^(m' - m) (2n' + 1)$. Si fuera $m' > m$ el lado derecho sería
  par y el izquierdo impar, absurdo; luego $m = m'$, y entonces $2n + 1 = 2n' + 1$ da $n = n'$.
  Por lo tanto $\#(NN times NN) <= \#(NN_0 times NN_0) <= aleph_0$.
]

#sublema(titulo: [Lema B (potencias finitas de un conjunto contable; deducción propia)])[
  Sea $X$ un conjunto con $\#X <= aleph_0$, es decir, con una inyección $c : X -> NN$. Entonces
  $\#X^N <= aleph_0$ para todo $N in NN$, donde $X^N$ es el conjunto de las $N$-uplas
  $(x_1, dots, x_N)$ de elementos de $X$.

  Por inducción en $N$. Para $N = 1$, $X^1 = X$ y la inyección es $c$. Si $c_N : X^N -> NN$ es
  inyectiva, definimos
  $ c_(N + 1)(x_1, dots, x_(N + 1)) = pi(c(x_1), c_N (x_2, dots, x_(N + 1))), $
  con $pi$ el del Lema A (ii). Es inyectiva: si dos uplas tienen la misma imagen, por la
  inyectividad de $pi$ coinciden $c(x_1) = c(x'_1)$ y $c_N (x_2, dots) = c_N (x'_2, dots)$; por
  la de $c$ y la de $c_N$ (hipótesis inductiva) coinciden $x_1 = x'_1$ y las colas, es decir, las
  uplas. Así $\#X^(N + 1) <= aleph_0$.
]

#sublema(titulo: [Lema C (convergente de enteros $=>$ eventualmente constante; deducción propia)])[
  Sea $(a_n)_(n in NN) subset.eq ZZ$ convergente a $ell in RR$ (Definición 7). Entonces existe
  $N in NN$ tal que $a_n = a_N$ para todo $n >= N$.

  Tomamos $epsilon = 1/2$ en la Definición 7: hay $n_0$ con $abs(a_n - ell) < 1/2$ para todo
  $n >= n_0$. Si $n >= n_0$, por la desigualdad triangular,
  $ abs(a_n - a_(n_0)) <= abs(a_n - ell) + abs(ell - a_(n_0)) < 1/2 + 1/2 = 1. $
  Pero $a_n - a_(n_0)$ es un entero, y el único entero $k$ con $abs(k) < 1$ es $k = 0$ (no hay
  enteros estrictamente entre $-1$ y $1$ distintos de $0$). Luego $a_n = a_(n_0)$ para todo
  $n >= n_0$, y sirve $N = n_0$.

  La recíproca es inmediata: si $a_n = a_N$ para $n >= N$, entonces $a_n -> a_N$ (dado $epsilon > 0$
  sirve $n_0 = N$, porque $abs(a_n - a_N) = 0 < epsilon$).
]

#resolucion[Propuesta (a): el cardinal es $aleph_0$][
  Llamemos $S = {(a_n)_(n in NN) subset.eq ZZ : (a_n)_(n in NN) "converge"}$ y
  $U = union.big_(N in NN) ZZ^N$, el conjunto de las uplas finitas (no vacías) de enteros.

  *$\#S <= aleph_0$.* Para $a in S$, por el Lema C el conjunto
  ${N in NN : a_n = a_N "para todo" n >= N}$ es no vacío; sea $N(a)$ su mínimo (buen orden de
  $NN$). Definimos
  $ f : S -> U, quad f(a) = (a_1, dots, a_(N(a))) in ZZ^(N(a)). $
  Es inyectiva: si $f(a) = f(b)$, las uplas viven en el mismo $ZZ^N$ (uplas de longitudes
  distintas son distintas), así que $N(a) = N(b) = N$ y $a_n = b_n$ para $1 <= n <= N$. Para
  $n > N$, por la elección de $N$, $a_n = a_N = b_N = b_n$. Luego $a = b$.

  $U$ es contable: cada $ZZ^N$ cumple $\#ZZ^N <= aleph_0$ por los Lemas A (i) y B, y es infinito
  (contiene las uplas $(k, dots, k)$, $k in NN$), así que es numerable (una inyección
  $ZZ^N -> NN$ lo hace coordinable con un subconjunto no vacío de $NN$, contable por la
  Proposición 3.13, y contable e infinito es numerable por la Definición 3.6). Entonces
  $U = union.big_(N in NN) ZZ^N$ es contable por el *Ej. 6 (a)*. Además $U$ es infinito (contiene
  a $ZZ^1 tilde.op ZZ$), luego numerable.

  Como $f$ es inyectiva, $S tilde.op f(S) subset.eq U$ con $f(S) != nothing$, y la Proposición
  3.13 dice que $f(S)$ es contable; por la Proposición 3.2, $S$ también lo es, es decir,
  $\#S <= aleph_0$.

  *$\#S >= aleph_0$.* Las sucesiones constantes $k, k, k, dots$ ($k in NN$) convergen (Lema C,
  recíproca), y $k |-> (k)_(n in NN)$ es una inyección $NN -> S$ (dos constantes distintas
  difieren en el primer término). Luego $aleph_0 = \#NN <= \#S$ (Definición 3.8). En particular
  $S$ es infinito: si fuera finito, componiendo tendríamos una inyección $NN -> {1, dots, n}$ para
  algún $n$, imposible (restringida a ${1, dots, n + 1}$ sería una inyección de un conjunto de
  $n + 1$ elementos en uno de $n$: principio del palomar, hecho de base).

  *Conclusión.* $S$ es contable e infinito, luego numerable (Definición 3.6): $\#S = aleph_0$.
  (Alternativamente, de $\#S <= aleph_0$ y $aleph_0 <= \#S$ sale $S tilde.op NN$ por el Teorema
  3.11.)
]

#enunciado[Ejercicio 16 (b)][
  Calcule el cardinal de ${(a_n)_(n in NN) subset.eq QQ : (a_n)_(n in NN) "es periódica"}$.
]

#estrategia[Una sucesión periódica queda determinada por un período completo][
  Decimos que $(a_n)$ es *periódica* si existe $p in NN$ ($p >= 1$) con $a_(n + p) = a_n$ para
  todo $n$. Entonces $(a_1, dots, a_p) in QQ^p$ determina toda la sucesión, lo que da una
  inyección en $union.big_(p in NN) QQ^p$, contable por el Lema B (con $\#QQ = aleph_0$) y el
  Ej. 6 (a). Las constantes son periódicas de período $1$, así que el conjunto es infinito.
]

#sublema(titulo: [Lema D (una sucesión periódica está determinada por un período; deducción propia)])[
  Sean $(a_n)$ y $(b_n)$ dos sucesiones con el mismo período $p >= 1$ (es decir, $a_(n + p) = a_n$
  y $b_(n + p) = b_n$ para todo $n$) tales que $a_i = b_i$ para $1 <= i <= p$. Entonces $a = b$.

  Primero, por inducción en $k >= 0$, $a_(r + k p) = a_r$ para todo $r$: el caso $k = 0$ es
  trivial y $a_(r + (k + 1) p) = a_((r + k p) + p) = a_(r + k p) = a_r$. Lo mismo para $b$. Dado
  $n in NN$, dividimos por $p$: $n = r + k p$ con $k >= 0$ y $1 <= r <= p$ (si el resto usual es
  $0$ tomamos $r = p$ y bajamos $k$ en uno). Entonces $a_n = a_r = b_r = b_n$.
]

#resolucion[Propuesta (b): el cardinal es $aleph_0$][
  Llamemos $P = {(a_n)_(n in NN) subset.eq QQ : (a_n)_(n in NN) "es periódica"}$ y
  $V = union.big_(p in NN) QQ^p$.

  *$\#P <= aleph_0$.* Para $a in P$ sea $p(a)$ el menor período de $a$ (el conjunto de períodos es
  un subconjunto no vacío de $NN$; buen orden). Definimos
  $ g : P -> V, quad g(a) = (a_1, dots, a_(p(a))) in QQ^(p(a)). $
  Es inyectiva: si $g(a) = g(b)$, las uplas tienen la misma longitud, así que $p(a) = p(b) = p$,
  y $a_i = b_i$ para $1 <= i <= p$; el Lema D da $a = b$.

  $V$ es contable: por la Proposición "Numerabilidad de $QQ$" hay una biyección $NN -> QQ$, cuya
  inversa es una inyección $QQ -> NN$, así que $\#QQ <= aleph_0$ y el Lema B da $\#QQ^p <= aleph_0$
  para todo $p$; cada $QQ^p$ es infinito (contiene las uplas $(k, dots, k)$, $k in NN$), luego
  numerable como en (a), y el *Ej. 6 (a)* dice que $V$ es contable (e infinito, por contener a
  $QQ^1$, luego numerable). Como en (a), $P tilde.op g(P) subset.eq V$ con $g(P) != nothing$, y la
  Proposición 3.13 da $P$ contable.

  *$\#P >= aleph_0$.* Cada constante $k, k, k, dots$ ($k in NN$) es periódica de período $1$, y
  $k |-> (k)_(n in NN)$ es una inyección $NN -> P$. Como en (a), $aleph_0 <= \#P$ y $P$ es
  infinito.

  *Conclusión.* $P$ es contable e infinito, luego numerable (Definición 3.6): $\#P = aleph_0$.
]

#observacion[Verificado en Lean: `Guias.Guia2.Ej16`][
  `ej16a : Numerable Conv` y `ej16b : Numerable Per`, con `Conv = {a : ℕ → ℤ | Converge a}` y
  `Per = {a : ℕ → ℚ | Periodica a}`. `Converge` es la Definición 7 escrita a mano ($epsilon$-$n_0$,
  con los enteros vistos en $RR$); `converge_iff_tendsto` certifica que coincide con `Tendsto` de
  Mathlib. `Periodica a` es `∃ p, 1 ≤ p ∧ ∀ n, a (n + p) = a n`.

  Desvíos respecto del texto: (1) las sucesiones empiezan en $0$ (`ℕ → ℤ`), así que la cabeza es
  $(a_0, dots, a_N)$ y $union.big_N ZZ^(N + 1)$ se modela como el tipo `Σ N, (Fin (N+1) → ℤ)`;
  en (b) se guarda $p - 1$ y $(a_0, dots, a_(p - 1))$. (2) En lugar de citar el Ej. 6 (a), Lean
  construye la inyección $union.big_N X^(N + 1) -> NN$ directamente, componiendo las
  codificaciones explícitas de los Lemas A y B (`par`, `codZ`, `codTupla`, `codSigma`), que es lo
  que hace al Ej. 6 (a) innecesario en este caso (uplas de longitud $N + 1$ van a
  `par N (codTupla N ...)`). (3) El índice $N(a)$ y el período $p(a)$ mínimos se toman con
  `Nat.find` (buen orden) y decidibilidad clásica. (4) El Lema C es
  `eventualmenteConstante_of_converge`; el Lema D es `periodica_ext`. (5) "Infinito" se obtiene de
  la inyección $NN -> S$ con `Infinite.of_injective` (el principio del palomar del texto) y la
  conclusión con `numerable_iff_contable_infinito` y `contable_of_cardLe_numerable` (Proposición
  3.13). No se usa ningún lema de Mathlib sobre contabilidad de productos, uniones o
  sucesiones.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

== Ejercicio 17

#enunciado[Ejercicio 17 (a)][
  Sea $I$ un conjunto (de índices). Supongamos que existe una familia de intervalos
  ${A_i}_(i in I)$ indexada por $I$ tal que $\#A_i > 1$ para todo $i in I$ y
  $A_i inter A_j = nothing$ si $i != j$. Pruebe que $I$ es contable.
]

#estrategia[Un racional en cada intervalo][
  Cada $A_i$ tiene dos puntos distintos; entre ellos hay un racional (densidad de $QQ$,
  Proposición 2), que está en $A_i$ porque $A_i$ es un intervalo. Como los $A_i$ son disjuntos,
  racionales elegidos en intervalos distintos son distintos: $i |-> q_i$ es una inyección
  $I -> QQ$, así que $\#I <= \#QQ = aleph_0$ e $I$ es contable (Proposición 3.13).
]

#sublema(titulo: [Convenciones: "intervalo" y "$\#A > 1$"])[
  Un subconjunto $A subset.eq RR$ es un *intervalo* si es convexo: si $u, v in A$ y
  $u <= w <= v$, entonces $w in A$. (Los intervalos abiertos, cerrados y semiabiertos, acotados o
  no, cumplen esto; es la única propiedad que se usa.)

  $\#A > 1$ significa, por la Definición 3.8, $\#{1} < \#A$: hay una inyección ${1} -> A$
  (o sea $A != nothing$) pero no una biyección. Esto equivale a que $A$ tenga dos puntos distintos
  (deducción propia): si $A = {u}$ fuera un solo punto, $1 |-> u$ sería una biyección ${1} -> A$;
  y recíprocamente, si $u != v$ están en $A$, cualquier función ${1} -> A$ toma un solo valor y no
  es sobreyectiva, mientras que $1 |-> u$ es inyectiva.
]

#resolucion[Propuesta (a): $I$ es contable][
  Si $I = nothing$ no hay nada que probar ($I$ es finito con $\#I = 0$, la convención de
  `Defs.lean`; ver la Consulta Docente de `guias/p2.typ`). Supongamos $I != nothing$.

  *Un racional en cada $A_i$.* Fijemos $i in I$. Como $\#A_i > 1$, hay $u, v in A_i$ con $u != v$;
  intercambiando nombres, $u < v$. Por la densidad de $QQ$ (Proposición 2) existe $q in QQ$ con
  $u < q < v$, y como $A_i$ es un intervalo, $q in A_i$. Elegimos para cada $i$ uno de esos
  racionales y lo llamamos $q_i$ (esto usa una elección por cada $i in I$; en Lean la hace
  `choose`). Queda definida
  $ phi : I -> QQ, quad phi(i) = q_i, quad "con" q_i in A_i "para todo" i. $

  *$phi$ es inyectiva.* Si $phi(i) = phi(j)$, el racional $q_i = q_j$ pertenece a $A_i$ y a
  $A_j$, así que $A_i inter A_j != nothing$. Por hipótesis eso obliga a $i = j$.

  *Conclusión.* $phi$ inyectiva dice $\#I <= \#QQ$ (Definición 3.8), e $I tilde.op phi(I)$ con
  $nothing != phi(I) subset.eq QQ$. Como $QQ$ es numerable (Proposición "Numerabilidad de $QQ$"),
  la Proposición 3.13 dice que $phi(I)$ es contable, y entonces $I$ también lo es (es coordinable
  con $phi(I)$ y "finito" y "numerable" se transportan por biyecciones, Proposición 3.2).
]

#enunciado[Ejercicio 17 (b)][
  Sea $f : RR -> RR$ una función monótona. Pruebe que el conjunto de sus discontinuidades es
  contable.
]

#estrategia[A cada discontinuidad le corresponde un "salto": un intervalo abierto no vacío][
  Para $f$ creciente y $x in RR$, los límites laterales existen como supremo e ínfimo:
  $L(x) = op("sup"){f(y) : y < x}$ y $R(x) = op("ínf"){f(y) : y > x}$. Se prueba
  $L(x) <= f(x) <= R(x)$, que $f$ es continua en $x$ exactamente cuando $L(x) = R(x)$, y que si
  $x < y$ entonces $R(x) <= L(y)$. Así, a cada discontinuidad $x$ le asignamos el intervalo
  $(L(x), R(x))$, no vacío, y intervalos de discontinuidades distintas son disjuntos: el ítem (a)
  da que las discontinuidades son contables. Si $f$ es decreciente, $-f$ es creciente y tiene las
  mismas discontinuidades.
]

#sublema(titulo: [Definición estándar de continuidad (no está en `apuntes.typ`)])[
  $f : RR -> RR$ es *continua en $x$* si para todo $epsilon > 0$ existe $delta > 0$ tal que
  $abs(y - x) < delta => abs(f(y) - f(x)) < epsilon$. Una *discontinuidad* de $f$ es un punto en
  el que $f$ no es continua. Decimos que $f$ es *creciente* si $y <= z => f(y) <= f(z)$,
  *decreciente* si $y <= z => f(y) >= f(z)$, y *monótona* si es creciente o decreciente.
]

#sublema(titulo: [Lema E (límites laterales de una función creciente; deducción propia)])[
  Sea $f : RR -> RR$ creciente y $x in RR$. Definimos
  $ L(x) = op("sup"){f(y) : y < x}, quad R(x) = op("ínf"){f(y) : y > x}. $
  Están bien definidos: ${f(y) : y < x}$ es no vacío (contiene a $f(x - 1)$) y acotado
  superiormente por $f(x)$ (si $y < x$ entonces $f(y) <= f(x)$), luego tiene supremo por el Axioma
  de Completitud (Definición 2); ${f(y) : y > x}$ es no vacío (contiene a $f(x + 1)$) y acotado
  inferiormente por $f(x)$, luego tiene ínfimo por el Teorema 2. Valen:

  + *$L(x) <= f(x) <= R(x)$.* $f(x)$ es cota superior del primer conjunto y el supremo es la
    menor de las cotas superiores (Definición 2); $f(x)$ es cota inferior del segundo y el ínfimo
    es la mayor de las cotas inferiores (Definición 5).

  + *Si $y < x$ entonces $f(y) <= L(x)$; si $x < y$ entonces $R(x) <= f(y)$.* Porque $L(x)$ es
    cota superior de ${f(y) : y < x}$ y $R(x)$ es cota inferior de ${f(y) : y > x}$.

  + *Si $x < y$ entonces $R(x) <= L(y)$.* Sea $z = (x + y)/2$, de modo que $x < z < y$. Por el
    punto anterior, $R(x) <= f(z)$ (pues $z > x$) y $f(z) <= L(y)$ (pues $z < y$).

  + *$f$ es continua en $x$ si y sólo si $L(x) = R(x)$.*

    ($==>$) Sea $epsilon > 0$ y $delta > 0$ el de la continuidad en $x$. El punto $y = x - delta/2$
    cumple $abs(y - x) < delta$, así que $f(y) > f(x) - epsilon$; como $y < x$, el punto 2 da
    $L(x) >= f(y) > f(x) - epsilon$. Análogamente, con $y = x + delta/2 > x$,
    $R(x) <= f(y) < f(x) + epsilon$. Como $epsilon > 0$ es arbitrario, $L(x) >= f(x)$ y
    $R(x) <= f(x)$; junto con el punto 1, $L(x) = f(x) = R(x)$.

    ($<==$) Supongamos $L(x) = R(x)$; por el punto 1, $L(x) = f(x) = R(x)$. Sea $epsilon > 0$. Por
    la caracterización del supremo (Proposición 3) existe $y_1 < x$ con $f(y_1) > L(x) - epsilon$,
    y por la del ínfimo (Proposición 5) existe $y_2 > x$ con $f(y_2) < R(x) + epsilon$. Tomamos
    $delta = op("mín"){x - y_1, y_2 - x} > 0$. Si $abs(y - x) < delta$, entonces
    $y_1 < y < y_2$, y como $f$ es creciente,
    $ f(x) - epsilon = L(x) - epsilon < f(y_1) <= f(y) <= f(y_2) < R(x) + epsilon = f(x) + epsilon, $
    es decir $abs(f(y) - f(x)) < epsilon$. Luego $f$ es continua en $x$.
]

#resolucion[Propuesta (b): las discontinuidades de una función monótona son contables][
  *Caso $f$ creciente.* Sea $D = {x in RR : f "no es continua en" x}$. Para cada $x in D$ definimos
  el intervalo abierto
  $ A_x = (L(x), R(x)) = {w in RR : L(x) < w < R(x)}, $
  con $L, R$ como en el Lema E. Verificamos las hipótesis del ítem (a) para la familia
  ${A_x}_(x in D)$:

  - *Cada $A_x$ es un intervalo* (convexo): si $L(x) < u <= w <= v < R(x)$ entonces
    $L(x) < w < R(x)$.
  - *$\#A_x > 1$.* Como $x in D$, el punto 4 del Lema E dice $L(x) != R(x)$, y el punto 1 da
    $L(x) <= R(x)$; luego $L(x) < R(x)$ y los dos puntos
    $ (3L(x) + R(x))/4 < (L(x) + 3R(x))/4 $
    están ambos en $A_x$ y son distintos.
  - *Disjuntos.* Sean $x, y in D$ con $x != y$; intercambiando nombres, $x < y$. Si hubiera
    $w in A_x inter A_y$, tendríamos $w < R(x)$ y $L(y) < w$, así que $L(y) < R(x)$, contra el
    punto 3 del Lema E ($R(x) <= L(y)$). Luego $A_x inter A_y = nothing$.

  Por el ítem (a) con $I = D$, el conjunto $D$ es contable.

  *Caso $f$ decreciente.* La función $g = -f$ es creciente ($y <= z => f(y) >= f(z) => -f(y) <=
  -f(z)$) y tiene exactamente las mismas discontinuidades que $f$: $abs(g(y) - g(x)) =
  abs(f(y) - f(x))$, así que la definición $epsilon$-$delta$ de continuidad en $x$ es la misma
  para ambas. Por el caso anterior aplicado a $g$, el conjunto de discontinuidades de $f$ es
  contable.
]

#observacion[Verificado en Lean: `Guias.Guia2.Ej17`][
  `ej17a {I} (A : I → Set ℝ) (hint : ∀ i, EsIntervalo (A i)) (hcard : ∀ i, CardLt (Fin 1) (A i))
  (hdisj : ∀ i j, i ≠ j → A i ∩ A j = ∅) : Contable I`, donde `EsIntervalo` es la convexidad
  escrita a mano y `CardLt (Fin 1) (A i)` es $\#A_i > 1$ con la Definición 3.8;
  `cardLt_fin_one_iff` prueba la equivalencia con "dos puntos distintos" del sublema de
  convenciones. La prueba sigue el texto: `exists_rat_btwn` (Proposición 2), `choose` para los
  $q_i$, inyectividad por disjunción y `contable_of_cardLe_numerable numerable_rat` (Proposición
  3.13). El caso $I = nothing$ no se separa porque `Contable` de `Defs.lean` ya lo cubre
  (`Fin 0`).

  `ej17b (hf : Monotone f ∨ Antitone f) : Contable {x : ℝ // ¬ ContinuousAt f x}`, vía
  `ej17b_mono` (creciente) y `ej17b_anti` (decreciente, reducido al anterior con `Antitone.neg` y
  `ContinuousAt.neg` para trasladar las discontinuidades, y `Equiv.subtypeEquivRight` para
  identificar los dos conjuntos). `ContinuousAt` es la continuidad de Mathlib; se la pasa a
  $epsilon$-$delta$ con `Metric.continuousAt_iff` y `Real.dist_eq`, que es la definición estándar
  del sublema. El Lema E es `L_le`, `le_R`, `le_L_of_lt`, `R_le_of_lt`, `R_le_L` y
  `continuousAt_iff_L_eq_R` (ambas direcciones, como en el texto), con `L f x = sSup (f '' Iio x)`
  y `R f x = sInf (f '' Ioi x)`; los supremos e ínfimos se manejan con `csSup_le`, `le_csSup`,
  `csInf_le`, `le_csInf`, `exists_lt_of_lt_csSup` y `exists_lt_of_csInf_lt` (Definiciones 2 y 5,
  Proposiciones 3 y 5). No se usan `Monotone.countable_not_continuousAt` ni
  `Set.countable_setOf_nonempty_of_disjoint`; (b) se cierra aplicando `ej17a` a los intervalos
  `Ioo (L f x) (R f x)`.
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

