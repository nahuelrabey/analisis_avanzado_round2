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
