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
