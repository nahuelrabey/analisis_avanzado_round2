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
