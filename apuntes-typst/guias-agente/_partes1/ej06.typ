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
