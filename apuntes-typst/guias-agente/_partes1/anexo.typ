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
