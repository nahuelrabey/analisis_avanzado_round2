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
