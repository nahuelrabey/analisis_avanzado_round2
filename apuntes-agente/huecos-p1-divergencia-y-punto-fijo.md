# Huecos de la Práctica 1: fuentes externas

**Fecha:** 17 de agosto de 2026
**Estado:** nota de trabajo. Nada de esto está incorporado a `apuntes-typst/` todavía.
**Motivo:** `ejemplos.typ:618-627` declara dos técnicas sin ningún ejemplo trabajado en el
repositorio. Una búsqueda en `libros-procesados` confirmó que ni Abbott ni las notas de
cátedra los cubren. Esta nota junta lo que sí se encontró en internet.

> **Cómo usar esto:** las demostraciones de abajo están traducidas a la notación de la
> cátedra, pero **no son transcripciones literales de las fuentes**. Antes de pasarlas a
> `ejemplos.typ`, contrastá con el original (los enlaces están al final). Lo que es
> deducción propia está marcado como tal.

---

## Hueco 1 — Divergencia a $\pm\infty$ por definición

Afecta a los **Ej. 9 (b)–(d)**, **Ej. 12 (b)** y la segunda mitad del **Ej. 14**.

### La fuente

**Rafael Payá (Universidad de Granada), _Cálculo I_, Tema 7 "Divergencia de sucesiones"**,
págs. 57–62. Es la única fuente encontrada que hace las cuentas completas.

### Diferencias de notación con la cátedra

Hay que traducir antes de copiar:

| Payá | Cátedra (Def. 2.6, `notas_materia.pdf` p. 15) |
|---|---|
| $\forall K \in \mathbb{R}$ | $\forall M > 0$ |
| "mayorada" / "minorada" | "acotada superiormente" / "inferiormente" |
| $\{x_n\}$, sucesión parcial | $(a_n)_{n \in \mathbb{N}}$, subsucesión |

**Ojo con una postura de Payá que contradice a la cátedra:** él desaconseja explícitamente
escribir $\lim x_n = +\infty$ ("puede crear confusión y debe evitarse", pág. 58). La
Definición 2.6 de la cátedra la usa sin problema. No copiar ese comentario.

### Ej. 12 (b) — decreciente y no acotada inferiormente $\Rightarrow -\infty$

Payá lo tiene literal en la pág. 60, junto con el caso creciente.

**Caso creciente** (es el Ejercicio 2.17 de las notas, pág. 18, que la cátedra deja sin
resolver). Sea $(a_n)$ creciente y no acotada superiormente. Sea $M > 0$. Como no está
acotada superiormente, existe $n_0 \in \mathbb{N}$ tal que $a_{n_0} > M$. Como es
creciente, para todo $n \geq n_0$ vale $a_n \geq a_{n_0} > M$. Luego $a_n \to +\infty$.

> **La sutileza que hay que remarcar en el ejemplo:** la no acotación entrega *un solo*
> índice por encima de $M$. Es la monotonía la que propaga esa desigualdad a todos los
> términos siguientes, que es lo que la definición exige. Sin monotonía el argumento se
> cae (ver Ejercicio 2.13 de las notas: no acotada $\not\Rightarrow$ divergente).

**Caso decreciente (el Ej. 12 b).** Dos caminos:

1. *Directo.* Sea $M > 0$. Como $(a_n)$ no está acotada inferiormente, existe $n_0$ con
   $a_{n_0} < -M$. Como es decreciente, para todo $n \geq n_0$ vale
   $a_n \leq a_{n_0} < -M$. Luego $a_n \to -\infty$.
2. *Espejo* (el que usa Payá). $(-a_n)$ es creciente y no acotada superiormente, luego
   $-a_n \to +\infty$, y por lo tanto $a_n \to -\infty$. Requiere el lema
   $a_n \to -\infty \iff -a_n \to +\infty$, que sale en un renglón de la definición.

El camino 2 es el que conecta con el Ej. 6 (a) del anexo de supremos (mismo truco de
reflejar por $-1$), así que como ejemplo rinde más.

### Ej. 9 (b) — $\ell_1 \in \mathbb{R}$, $\ell_2 = +\infty$

Payá lo arma en dos pasos (pág. 60), y el lema es lo que importa:

**Lema.** Si $b_n \to +\infty$ y $(a_n)$ está acotada inferiormente, entonces
$a_n + b_n \to +\infty$.

*Demostración.* Existe $\alpha \in \mathbb{R}$ con $a_n \geq \alpha$ para todo $n$. Dado
$M > 0$, como $b_n \to +\infty$ existe $n_0$ tal que $b_n > M - \alpha$ para todo
$n \geq n_0$. Entonces $a_n + b_n > \alpha + (M - \alpha) = M$. $\blacksquare$

**Cierre del ítem.** Si $a_n \to \ell_1 \in \mathbb{R}$, entonces $(a_n)$ está acotada
(**Proposición 2.12**, ya está en `apuntes.typ`), en particular acotada inferiormente.
Se aplica el lema.

> Esto es lo que hace al ítem un buen ejemplo: reusa una proposición que el apunte ya
> tiene, en vez de volver a empezar de la definición.

### Ej. 9 (c) — $\ell_1 = \ell_2 = +\infty$

Mismo lema. Solo hay que justificar el paso que Payá da por sentado (pág. 61, dice
únicamente "pues $\{y_n\}$ está minorada"):

**Toda sucesión que diverge a $+\infty$ está acotada inferiormente.** Tomando $M = 1$ en
la definición, existe $n_0$ con $a_n > 1$ para todo $n \geq n_0$. Los términos previos
$a_1, \dots, a_{n_0 - 1}$ son finitos, así que
$\alpha = \min\{a_1, \dots, a_{n_0-1}, 1\}$ es cota inferior de toda la sucesión.

*(Deducción propia — Payá no la escribe. Es el mismo argumento de "los términos previos
son finitos" que usa la Proposición 2.12 del apunte, con mínimo en vez de máximo.)*

### Ej. 9 (d) — el contraejemplo de $[+\infty - \infty]$

El contraejemplo mínimo es $a_n = n$, $b_n = -n$, con $a_n + b_n = 0 \to 0$.

Pero Payá da algo mucho más fuerte (pág. 61): **toda** sucesión $(z_n)$ se escribe como
suma de una que diverge a $+\infty$ y otra que diverge a $-\infty$. Basta tomar

$$x_n = z_n + |z_n| + n, \qquad y_n = z_n - x_n = -|z_n| - n.$$

Como $z_n + |z_n| \geq 0$, resulta $x_n \geq n \to +\infty$; y $y_n \leq -n \to -\infty$;
y $x_n + y_n = z_n$ por construcción.

> No es un contraejemplo: es una fábrica de contraejemplos. Demuestra que **ningún**
> resultado general sobre $[\infty - \infty]$ puede existir, que es exactamente lo que el
> Ej. 9 (d) pide "pensar". Si se transcribe uno solo de los cuatro ítems, que sea este.

### Ej. 14 — lo que Payá NO cubre

El enunciado del Ej. 14 (si $(a_n)$ no está acotada superiormente, existe una subsucesión
que diverge a $+\infty$) **no está** en la fuente. Lo que sí hay, y sirve como técnica:

- *Toda subsucesión de una sucesión divergente es divergente* (págs. 58–59), demostrado.
  Es la dirección contraria a la que se necesita.
- En la caracterización vía Bolzano–Weierstrass (pág. 59) construye una aplicación
  $\sigma : \mathbb{N} \to A$ estrictamente creciente sobre un conjunto infinito de
  índices. **Ese es el paso constructivo del Ej. 14**, aunque aplicado a otro fin.

Sigue faltando el ejemplo directo. Es el único pedazo del hueco 1 que queda abierto.

---

## Hueco 2 — Punto fijo vía supremo (anexo, edición 2025)

### Qué es

El ejercicio del anexo es el caso $[a,b]$ del **teorema de punto fijo de
Knaster–Tarski**. Eso explica por qué no aparecía en ningún libro de análisis: el
resultado vive en teoría de órdenes, no en análisis real.

**Fuente:** Paul Delatte (USC), _Lecture 3: Tarski's fixed point theorem_, Teorema 1,
primer párrafo. El resto de la demostración (que los puntos fijos forman un retículo
completo) está fuera de alcance. Original de Tarski (1955), _Pacific J. Math._ 5(4),
285–309.

### La demostración de la fuente (en lenguaje de retículos)

Sea $H := \{x \in L : x \leq f(x)\}$ y $\bar{u} := \sup H$.

1. Para todo $x \in H$ vale $x \leq \bar{u}$, luego $x \leq f(x) \leq f(\bar{u})$. Es
   decir, $f(\bar{u})$ es cota superior de $H$, y por lo tanto $\bar{u} \leq f(\bar{u})$.
2. Como $f$ es creciente, $f(\bar{u}) \leq f(f(\bar{u}))$, o sea $f(\bar{u}) \in H$, y
   entonces $f(\bar{u}) \leq \sup H = \bar{u}$.
3. De 1 y 2, $f(\bar{u}) = \bar{u}$.

Cuatro líneas, y **solo usa monotonía y supremo**. Ninguna continuidad.

### Adaptación al enunciado del anexo

*(Esta parte es reelaboración propia, no está así en la fuente: el anexo usa el conjunto
con desigualdad **estricta**, y eso obliga a un paso extra que Tarski no necesita.)*

**Enunciado.** $f : [a,b] \to [a,b]$ creciente, $f(a) > a$,
$x_0 = \sup\{x \in [a,b] : f(x) > x\}$. Probar que $f(x_0) = x_0$.

**Preliminares.** Sea $H = \{x \in [a,b] : f(x) > x\}$.
- $H \neq \emptyset$: la hipótesis $f(a) > a$ dice justamente que $a \in H$. *(Para eso
  está esa hipótesis, y para nada más.)*
- $H$ está acotado superiormente por $b$.
- Por el **Axioma de Completitud** existe $x_0 = \sup H$, y $a \leq x_0 \leq b$.

**Paso 1: $x_0 \leq f(x_0)$.** Sea $x \in H$. Como $x \leq x_0$ y $f$ es creciente,
$f(x) \leq f(x_0)$. Pero $x < f(x)$, así que $x < f(x_0)$. Vale para todo $x \in H$,
luego $f(x_0)$ es cota superior de $H$. Como $x_0$ es la **menor** cota superior,
$x_0 \leq f(x_0)$.

**Paso 2: no puede ser $f(x_0) > x_0$.** Supongamos que sí. Como $x_0 < f(x_0)$, existe
$t \in \mathbb{R}$ con $x_0 < t < f(x_0)$, y además $t \in [a,b]$ porque está entre dos
puntos de $[a,b]$. Como $f$ es creciente y $t > x_0$, vale $f(t) \geq f(x_0) > t$, o sea
$t \in H$. Pero entonces $t \leq \sup H = x_0$, contradiciendo $t > x_0$.

**Conclusión.** De los pasos 1 y 2, $f(x_0) = x_0$. $\blacksquare$

> **Por qué el paso 2 no es el de Tarski.** Con el conjunto no estricto
> $\{x : x \leq f(x)\}$ alcanza con observar que $f(\bar u) \in H$. Con el estricto eso
> falla: de $f(x_0) > x_0$ solo se deduce $f(f(x_0)) \geq f(x_0)$, y hace falta el
> $\geq$ estricto. El arreglo es meter un punto intermedio $t$, y ahí entra la
> **densidad de $\mathbb{R}$** — herramienta del Ej. 2, que el ejercicio del anexo no
> hacía prever. Vale la pena señalarlo si se transcribe.

**Por qué el ejercicio es de Cap. 1**, como afirma `p1.typ:292`: lo único que se usa es
el Axioma de Completitud (para que exista $x_0$), la definición de supremo como menor
cota superior (Paso 1), y la densidad (Paso 2). Nada de sucesiones ni de continuidad.

---

## Fuentes descartadas (verificadas, no sirven)

Anotadas para no volver a buscarlas:

- **blog.nekomath.com**, "Sucesiones divergentes y sus propiedades" — tiene el teorema de
  creciente+no acotada con demostración de un renglón, pero sus "ejemplos" ($\{5n\}$,
  $\{7n^2+4n\}$) van **sin prueba**. Justo lo que falta es lo que no tiene.
- **cut-the-knot.org**, "Iterations on Monotone Functions" — no contiene el resultado de
  punto fijo. Habla de iteraciones sin ciclos y **asume** la existencia del punto fijo.
- **notas de cátedra, Cap. 6.1** (`notas_materia.pdf`, págs. 75–79) — es Banach para
  contracciones en espacios métricos completos, más la variante $f:[0,1]\to[0,1]$
  continua vía Bolzano. Exigen continuidad; el anexo solo tiene monotonía.
- **Abbott**, Ej. 4.5.7 (continua, TVI), Ej. 5.3.7 (derivable), pág. 139 (contracción).
  Misma razón.
- **Abbott, Cap. 2** — no define divergencia a $\pm\infty$ con cuantificador en el
  cuerpo del capítulo; solo la usa informalmente (serie armónica, pág. 70).

---

## Al transcribir a `ejemplos.typ`

- **Valor absoluto:** usar obligatoriamente `abs(...)`, nunca barras `|...|`. En esta
  nota aparece $|z_n|$ en notación matemática corriente; en Typst va `abs(z_n)`.
- **Bloques sugeridos** según `ejemplos.typ:618-627`: divergencia → bloque 6 o uno nuevo;
  punto fijo → bloque 1 o uno nuevo.
- Recordar que modificar `apuntes-typst/` requiere autorización expresa y una propuesta
  previa en `proposals/`.

## Enlaces

- Payá, _Divergencia de sucesiones_ (UGR):
  <https://www.ugr.es/~rpaya/documentos/CalculoI/2013-14/Divergentes.pdf>
- Delatte, _Tarski's fixed point theorem_ (USC):
  <https://pauldelatte.github.io/files/L3.pdf>
- nekomath, _Sucesiones divergentes_ (descartada):
  <https://blog.nekomath.com/calculo-diferencial-e-integral-i-sucesiones-divergentes-y-sus-propiedades/>
- cut-the-knot, _Iterations on Monotone Functions_ (descartada):
  <https://www.cut-the-knot.org/arithmetic/algebra/IterationsOnMonotoneFunctions.shtml>
