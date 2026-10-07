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
