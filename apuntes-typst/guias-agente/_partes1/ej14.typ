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
