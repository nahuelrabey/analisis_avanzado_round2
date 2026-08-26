# Propuesta: Reordenar `desafios.typ` como cadena de insumos para `guias/p1.typ`

## Paso 1 — ¿Afecta a alguna SKILL?

**No.** No existe todavía ninguna skill en el proyecto (`~/.claude/skills/`, `~/.claude/commands/`
y `.claude/` no existen). Los comandos `/guia`, `/ejemplo` y `/desafio` se mencionan en
`p1.typ` y `ejemplos.typ` pero no están implementados.

**Consecuencia para el futuro:** si algún día se implementa `/desafio`, tendrá que decidir
**dónde inserta** un desafío nuevo. Con el archivo ordenado por dependencias, "apendear al
final" deja de ser correcto: el comando debería insertar en el bloque temático que
corresponda. Conviene que la skill lea los encabezados de bloque propuestos abajo.

## Diagnóstico

`desafios.typ` es hoy un archivo **acumulativo por orden de transcripción**: 34 entradas sin
agrupar, donde el Ejercicio 1 sobre $sup(a,b)$ convive con el 2.19 sobre sucesiones
monótonas. Para usarlo como escalera hacia `p1.typ` hay tres problemas concretos:

1. **Sin orden de dependencias.** "Desigualdad $2^n > n$" (línea 208) es herramienta del
   Ej. 4 (b)-(c), pero aparece después de los desafíos de álgebra de límites, que son del
   Ej. 9. Quien siga el archivo de arriba a abajo hace las cosas al revés.
2. **Un duplicado exacto.** El supremo de $A = {r in QQ : r^2 < 2}$ aparece dos veces:
   línea 64 ("en $RR$") y línea 296. Mismo enunciado, ninguno resuelto.
3. **Una redundancia.** "Ejercicio 6 - Ítem b" (línea 171) es literalmente el ítem (b) del
   "Ejercicio 2.14" (línea 314), que **ya está resuelto** ahí. El de la línea 171 está sin
   resolver, o sea que invita a rehacer trabajo ya hecho.

Descontando duplicado y redundancia quedan **32 desafíos distintos**.

## Solución propuesta

Reordenar en nueve bloques temáticos siguiendo la columna vertebral que ya fija la tabla de
`p1.typ:47-76`. **Sin cambiar el contenido de ningún desafío**: es sólo mover bloques y
agregar encabezados.

Marcas: ✔ = ya tiene `#solucion` en el archivo · → = a qué ejercicio de `p1.typ` alimenta.

### Bloque A — Vocabulario de supremo, ínfimo, máximo y mínimo
*No usa Arquímedes ni sucesiones. Es el piso de todo lo demás.* → **Ej. 3, 4 (a), 5**

1. Observación 1 — unicidad del supremo ✔
2. Ejercicio 1 — $op("sup")(a,b) = b$ ✔ → Ej. 4 (a)
3. Mínimo del intervalo $(a, b]$ → Ej. 4 (a)
4. Mínimo de una función cuadrática convexa ✔ → Ej. 4 (d)
5. Máximo de una función cuadrática cóncava ✔ *(espejo del anterior; van juntos)*
6. Unión de dos conjuntos acotados superiormente → Ej. 5
7. Unión arbitraria de conjuntos acotados *(el contraejemplo)*

> 6 y 7 son un par: uno verdadero y uno falso sobre la misma operación. Hacerlos seguidos
> y en ese orden es lo que fija el rol de la finitud.

### Bloque B — Principio de Arquímedes y sus consecuencias
→ **Ej. 1, 2, 4 (b)-(c)**

8. No acotación de pares ✔ *(primer uso de Arquímedes, el más simple)*
9. Consecuencia del Principio de Arquímedes ($2/n < x$)
10. Otra consecuencia ($0 < m/n < x$) *(generaliza el 9)*
11. Supremo de $C = {2 - 1/n : n in NN}$ ✔ *(Arquímedes para cerrar un supremo)*
12. Desigualdad $2^n > n$ → herramienta del Ej. 4 (b)-(c), donde $B = {1/2^n}$
13. Cotas y extremos de $A = {n/(n+1)}$ *(mismo molde que 11, ahora con $epsilon$)*

### Bloque C — Caracterización $epsilon$ y estructura del supremo
→ **Ej. 3, 5, 6**

14. Ejercicio 2 — $op("ínf")(C) = op("sup")(A)$, con $C$ el conjunto de cotas superiores
15. Equivalencia del Axioma de Completitud (deducirlo del Teorema 2) → **Ej. 6 (a)**: es el
    mismo truco de reflejar por $-1$
16. Supremo de la suma $A + B$ *(la técnica del $epsilon\/2$, que reaparece en unicidad del límite)*
17. Supremo de $A = {r in QQ : r^2 < 2}$ *(por qué $QQ$ no alcanza)*

### Bloque D — Parte entera
→ **Ej. 2 (a)**

18. Existencia de un número natural intermedio ✔ *(versión discreta, la fácil)*
19. Parte entera de un número real
20. Existencia de un entero en $(x, x + 1]$ *(consecuencia directa del 19)*

> ⚠ **Único conflicto de orden del archivo.** `p1.typ:265` indica que para probar que
> $op("sup")(A)$ es entero se usa "una sucesión de enteros que converge es finalmente
> constante" (Ejemplo C1-3), que es material de **sucesiones**. Por esa ruta, el 19 no
> puede hacerse acá. Hay dos salidas: (a) probarlo con la caracterización $epsilon$ del
> supremo, sin sucesiones, y el bloque queda en el Cap. 1; o (b) mover 19 y 20 después del
> Bloque F. **Recomendación: (a)**, para no partir el hilo de la densidad.

### Bloque E — Densidad
→ **Ej. 1 y Ej. 2 completos**

21. Desafío 5.3 ✔ → **Ej. 1 literal**
22. Desafío 5.4 → **Ej. 2 completo** (los cuatro ítems). Depende del 20.

### Bloque F — Límite por definición
→ **Ej. 7, 8**

23. Límite de $a_n = n/(n+1) = 1$ *(molde del Ej. 7; y cierra el 13, que es el mismo
    conjunto atacado con la otra herramienta)*
24. Ejemplo 3.1.7 — $(0,2,0,2,...)$ no converge a $0$ ✔ *(negación de convergencia →
    entrada al Ej. 15)*

### Bloque G — Álgebra de límites
→ **Ej. 9 (a), 10, 11**

25. Álgebra de límites, ítem b (suma) → **Ej. 9 (a) literal**
26. Ejercicio 2.14 (a)-(d) ✔ *(a, b, c resueltos; falta el (d))* — herramienta del cociente
27. Álgebra de límites, ítem e (orden al límite) → **Ej. 10 literal**

### Bloque H — Divergencia a $plus.minus oo$
→ **Ej. 9 (b)-(d), 12 (b), 14**

28. Ejercicio 3 — si $(a_n)$ diverge a $plus.minus oo$ entonces $(abs(a_n))$ diverge a $+oo$
29. Ejercicio 5 — ¿no acotada $=>$ diverge a $plus.minus oo$? (falso)
30. Ejercicio 2.17 — creciente y no acotada $=>$ $+oo$ → **Ej. 12 (b)** espejado
31. Ejercicio 4 — álgebra de límites en el infinito → **Ej. 9 (b), (c), (d)**

> **Este bloque es el hueco 1** documentado en `ejemplos.typ:618-627` y en
> `apuntes-agente/huecos-p1-divergencia-y-punto-fijo.md`. Los tres primeros son,
> textualmente, los Ejercicios 2.7, 2.13 y 2.17 de las notas de cátedra — los mismos que la
> búsqueda identificó como "enunciados que la cátedra deja sin resolver". Es decir: el
> material para tapar el hueco **ya estaba en `desafios.typ`**, sólo que disperso.
> El orden 28 → 29 → 30 → 31 es deliberado: 28 estrena el cuantificador $M$ en el caso más
> simple, 29 marca qué **no** se puede concluir, 30 es el puente con la monotonía, y 31 los
> necesita a los tres.

### Bloque I — Monótonas y supremo
→ **Ej. 13**

32. Ejercicio 2.19 — equivalencia del supremo con sucesión monótona creciente →
    **Ej. 13 literal**. Depende del 23 (límite), del 30 (monotonía) y del Bloque C.

## Cambios destructivos (requieren aprobación aparte)

El reordenamiento en sí no borra nada. Estas dos limpiezas sí, y **no las aplico salvo que
las autorices explícitamente**:

- **Eliminar el duplicado** de $op("sup")(A) = sqrt(2)$: conservar el de la línea 296
  ("Demostrar que $sqrt(2) = op("sup")(A)$") y borrar el de la línea 64, que dice lo mismo.
- **Eliminar "Ejercicio 6 - Ítem b"** (línea 171), ya cubierto y resuelto como ítem (b) del
  Ejercicio 2.14 (línea 314).

Si preferís no borrar nada, la alternativa es dejar ambos y agregar una nota cruzada.

## Qué NO cubre esta cadena

Aun completando los 32, quedan sin insumo en `desafios.typ`:

- **Ej. 14** (no acotada superiormente $=>$ existe subsucesión que diverge a $+oo$) y
  **Ej. 15, 16** (subsucesiones): no hay ningún desafío de subsucesiones en el archivo.
- **Ej. 11** (acotada por nula): lo más cercano es el Ejemplo C1-1.2 de `ejemplos.typ`.
- **El anexo de punto fijo**: sin material, tal como ya registraba la nota de
  `apuntes-agente/`.
