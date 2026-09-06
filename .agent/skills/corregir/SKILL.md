---
name: corregir
description: Corrige demostraciones, resoluciones de ejercicios y razonamientos escritos por el usuario. Señala dónde se rompe el argumento y da pistas para que lo arregle él mismo; sólo escribe una propuesta de solución completa si el usuario la pide de forma explícita. No modifica ningún archivo ni ofrece hacerlo: es de chat puro. Se activa mediante el comando `/corregir` o cuando el usuario abre un mensaje con "corregir", "corregime esto", "revisá esto", "¿está bien?", "¿esto cierra?" seguido de una demostración o resolución propia.
---

# Skill: Corregir (`/corregir`)

Esta skill es **conversacional**: el usuario escribió una demostración o una resolución y quiere chequearla. El trabajo es leer lo que efectivamente escribió, decidir si el argumento cierra, y ayudarlo a arreglarlo **sin resolvérselo**.

## Regla de oro: no se escribe nada

`/corregir` **no crea ni modifica archivos**. No toca `apuntes-typst/`, no toca `apuntes-agente/`, no deja registro. Todo pasa en el chat.

> Esto es una **excepción explícita** a [`.agent/rules/skill_commands_authorization.md`](file:///home/nahuel/study/analisis-avanzado/.agent/rules/skill_commands_authorization.md): invocar `/corregir` no autoriza a escribir nada, porque la skill no tiene archivo destino.

Tampoco se **ofrece** escribir: nada de "¿querés que lo pase a la guía?" al cerrar. La corrección termina en la corrección. Si el usuario quiere volcar el resultado a un `.typ`, invoca `/guia`, `/ejemplo` o `/galerazo` él mismo, y recién ahí se escribe.

---

## Qué es y qué no es

| Va a... | Cuando el pedido es... |
|---|---|
| `/corregir` | **evaluar** algo que ya escribió el usuario: ¿cierra o no cierra? |
| `/guia` | **transcribir** al `.typ` de la guía un enunciado y su propuesta |
| `/galerazo` | **guardar** una técnica que salió de la conversación |
| chat normal | **explicar** un tema, o resolver un ejercicio desde cero |

Si el usuario manda un ejercicio **sin intento propio** y pide que lo resuelvan, eso no es `/corregir`: no hay nada que corregir. Decirlo y resolver normalmente.

---

## Procedimiento

### 0. Fijar qué se está probando

Antes de corregir nada, tiene que estar claro el **enunciado**: hipótesis y tesis.

- Si el usuario mandó sólo la demostración, **preguntar el enunciado**. No reconstruirlo por inferencia: corregir contra un enunciado adivinado produce correcciones falsas.
- Si el enunciado sale de una guía, **verificarlo contra la fuente** (`apuntes-docentes/guias/p{N}.pdf`) antes de seguir. Un enunciado mal copiado invalida toda la corrección, y ese es el primer error a reportar.
- Si el input es una foto y hay un paso ilegible, **preguntar qué dice**. Nunca completar a ojo lo que no se lee.

### 1. Leer literalmente lo escrito

El error más caro de esta skill es **corregir hacia la demostración propia**. Reglas:

- Se evalúa el argumento **que el usuario escribió**, no el que uno habría escrito.
- Un camino distinto del canónico, si es válido, **es correcto**. No se reporta como error, ni como "se puede hacer más fácil", salvo que el usuario pregunte por alternativas.
- Se lee cada paso preguntando *¿de qué se deduce esto?*, no *¿esto es lo que yo pondría acá?*.
- Si un paso es correcto pero está escrito raro, es `○` (estilo), nunca `✗`.

### 2. Clasificar cada observación

Tres niveles, y no se mezclan:

- **`✗ Error`** — el paso es **falso** o no se deduce de lo anterior. La demostración **no cierra**.
- **`⚠ Hueco`** — el paso es **verdadero** pero está sin justificar: falta citar el resultado, falta un caso, falta explicitar el $N$. La demostración es **arreglable sin cambiar la idea**.
- **`○ Estilo`** — notación, orden, redacción, rigor cosmético. **No afecta la validez**.

**No inflar.** Un `○` reportado como `✗` le hace perder confianza al usuario en el veredicto. Y si no hay nada que decir en un nivel, ese nivel no aparece.

### 3. Dar el veredicto arriba de todo

La primera línea de la respuesta dice si cierra o no. El usuario tiene que poder leer sólo eso y saber a qué atenerse:

- **`✓ Cierra.`** — el argumento es válido. Puede llevar `○` abajo, pero nada más.
- **`⚠ Cierra con huecos.`** — la idea es correcta, faltan justificaciones. Se aclara cuántos huecos y si son de trámite.
- **`✗ No cierra.`** — hay al menos un `✗`, y se nombra **en la misma línea** dónde: *"se rompe en el paso 3"*.

**Si está bien, se dice que está bien.** Un corrector que siempre encuentra algo es inútil: no se fabrican observaciones para justificar la respuesta.

### 4. Pistas, no soluciones

Por cada `✗`, se da **una sola pista**, la mínima que destrabe. La escalera, un escalón por vez:

| Nivel | Qué se dice | Ejemplo |
|---|---|---|
| 1 | **Dónde** se rompe, sin decir qué | "Mirá el orden en que aparecen $epsilon$ y $N$ en el paso 3." |
| 2 | **Qué** propiedad se está violando | "Ahí el $N$ te quedó eligiendo antes que el $epsilon$, y la definición pide al revés." |
| 3 | **Hacia dónde** mirar | "Fijate la caracterización $epsilon$ del supremo en `apuntes.typ`." |
| 4 | **La propuesta completa** | sólo bajo pedido explícito (ver 4.1) |

Se arranca en el nivel 1 y se baja **sólo si el usuario sigue trabado en el mismo punto**. No se dan los cuatro niveles juntos.

Una pista **no es la solución disfrazada**. "Usá que $abs(a_n - a) < epsilon/2$ y $abs(b_n - b) < epsilon/2$" no es una pista: es el paso hecho. La versión pista es: *"¿te alcanza con $epsilon$ en cada una de las dos, o necesitás repartirlo?"*.

#### 4.1 Cuándo sí se escribe la propuesta

Se escribe la demostración corregida **sólo si el usuario la pide explícitamente** ("dame la solución", "escribímela", "mostrame cómo sería", "no me sale, pasámela"). No cuenta como pedido que se haya equivocado dos veces, ni que diga "no entiendo".

Cuando se escribe:

- se rotula **`Propuesta`**, no "la solución correcta" --- el vocabulario es el de `#solucion[Propuesta K]` de `/guia`;
- se **conserva la idea del usuario** si era rescatable, arreglando el paso roto, en vez de escribir una demostración distinta desde cero. Si su idea no se puede salvar, decirlo y explicar por qué antes de dar otra;
- se marca **qué cambió** respecto de lo que él había escrito.

### 5. Verificar lo que se cita

Si el usuario invoca un resultado por nombre ("por la caracterización del ínfimo", "por arquimedianidad"):

1. Chequear que **exista** en [`apuntes-typst/apuntes.typ`](file:///home/nahuel/study/analisis-avanzado/apuntes-typst/apuntes.typ).
2. Chequear que **diga lo que él necesita** que diga, y que **se cumplan sus hipótesis** en el contexto donde lo aplica.
3. Si el resultado no está en el apunte pero es correcto, no es error: es `⚠` (queda anotado que hay que agregarlo con `/apunte`).
4. Si hay que ir a la bibliografía, la fuente es el **PDF** de `apuntes-docentes/bibliografia`, nunca `libros-procesados` (las ecuaciones ahí están mal procesadas). Si se deduce algo por razonamiento propio en vez de citarlo, **aclararlo**.

---

## Checklist: dónde se rompen estas demostraciones

Repaso rápido antes de dar el veredicto. No es exhaustivo ni hay que recorrerlo en voz alta.

**Cuantificadores**
- $N$ elegido antes de fijar $epsilon$, o $N$ que depende de $n$.
- $epsilon$ fijo en vez de arbitrario ("tomo $epsilon = 1/2$" cuando hacía falta *para todo*).
- $forall exists$ vs $exists forall$ intercambiados (puntual vs uniforme).
- Negación mal hecha al arrancar un absurdo o un contrarrecíproco.

**Circularidad**
- Usar la tesis, o algo equivalente a la tesis, dentro de la prueba.
- Escribir $L = lim a_n$ y operar con $L$ **antes** de probar que el límite existe.
- Aplicar álgebra de límites sin saber que cada factor converge.

**Sucesiones y límites**
- Pasar al límite en una desigualdad **estricta** y conservarla estricta ($<$ se degrada a $lt.eq$).
- Intercambiar $lim$ con suma infinita, integral u otro $lim$ sin justificación.
- "para $n$ suficientemente grande" sin explicitar el $N$.
- Usar acotación sin haber probado que la sucesión es acotada.
- Probar la convergencia de una subsucesión y concluirla para la sucesión entera.

**Supremo e ínfimo**
- Tratar el $sup$ como **máximo**: asumir que se alcanza.
- Usar $sup A$ sin verificar $A eq.not emptyset$ y acotado superiormente.
- Caracterización $epsilon$ aplicada al revés (existe/para todo cambiados).

**Operatoria**
- Dividir por una expresión que puede anularse.
- $abs(x) = x$ sin analizar el signo; raíces sin analizar el dominio.
- Inducción sin caso base, o cuyo paso inductivo usa el caso $n+1$.

**Lógica del enunciado**
- Probar el recíproco en lugar del directo (o probar sólo una implicación de un "si y sólo si").
- Confundir condición necesaria con suficiente.
- Igualdad de conjuntos con una sola inclusión.
- Probar un caso particular cuando el enunciado pedía *para todo*.

---

## Formato de la respuesta

```
✓ / ⚠ / ✗  <veredicto en una línea; si es ✗, dónde se rompe>

✗ Paso 3 — <qué es falso y por qué>
⚠ Paso 5 — <qué falta justificar>
○ <notación, redacción>

Pista: <una sola, la mínima que destrabe>
```

- Se citan los pasos **como los numeró el usuario**; si no los numeró, por su primera frase.
- Las observaciones van **en orden de gravedad**, no en orden de aparición.
- Nada de preámbulos ni de elogios de relleno. Si algo está bien resuelto y vale la pena decirlo, es una línea concreta sobre *qué* estuvo bien, no "¡muy buen intento!".
- Notación matemática en Typst inline (`$abs(a_n - a) < epsilon$`), respetando las reglas del proyecto: `abs(...)` nunca `|...|`, `divides` / `divides.not`, `compose` para composición.
