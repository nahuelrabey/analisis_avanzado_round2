# Propuesta: `apuntes-typst/practica_pre_parcial.typ`

**Qué es.** Un archivo nuevo en `apuntes-typst/` con los lemas, teoremas y proposiciones que se
usan para resolver los ejercicios de los primeros parciales transcriptos en `apuntes-typst/parciales/`,
organizado **por tipo de ejercicio del parcial** (no por capítulo del apunte) y, dentro de cada tipo,
**en el orden del guion de resolución**. Primera versión: dos tipos, en este orden de prioridad:

1. **Cardinalidad** (aparece en los 6 parciales).
2. **Supremos e ínfimos**: los ejercicios que se resuelven sólo con la Guía 1 y, a lo sumo, un poco de
   la Guía 3 (clausura e interior en ℝ): 2C 2024 Ej. 1, 1C 2025 Ej. 2, Recu 1C 2025 Ej. 2,
   2C 2025 Ej. 1, Recu 2C 2025 Ej. 1 y 3 (b).

Los otros dos tipos (topología general, métrica concreta) quedan para más adelante.

**¿Afecta a alguna skill?** No: no cambia `/guia`, `/ejemplo`, `/apunte` ni `/galerazo`. Si el archivo
se consolida, podría agregarse una skill `/pre-parcial` para mantenerlo; no forma parte de esta propuesta.

## Estructura de cada tipo de ejercicio

1. *Qué pide el parcial*: los enunciados de ese tipo copiados de `parciales/*.typ`, con el veredicto y
   la lista de fichas que usa cada uno.
2. *El guion*: los 3 a 5 pasos que aparecen siempre (p. ej. cardinal: cota superior por inclusión o
   codificación inyectiva → cota inferior por copia de ℕ o de `{0,1}^ℕ` → cierre por CSB o "contable
   e infinito"), con un árbol de decisión corto.
3. *Fichas*, en el orden del guion. Tres niveles, distinguidos por color:
   - **apunte** (azul): resultado de `apuntes.typ`, citable tal cual; sólo enunciado y cómo se usa.
   - **guía** (verde): ejercicio de una guía usado como lema; enunciado, idea de la prueba en 3 líneas,
     referencia al ejercicio (y a `guias-agente/` si está resuelto ahí).
   - **propio** (naranja): hecho que no está en el apunte ni en una guía y se probó en el lugar en algún
     parcial; enunciado y demostración completa, porque en el examen hay que escribirla.
4. *Banco de trucos y contraejemplos* del tipo (codificaciones estándar, copias de ℕ, los conjuntos
   que refutan las afirmaciones "V o F").
5. *Índice cruzado* parcial × ficha.

## Formato de ficha (definido en el propio archivo, sin tocar `utils.typ`)

```typst
#ficha(
  id: "C3", titulo: "Cantor--Schröder--Bernstein", nivel: "apunte",
  fuente: [Teorema 3.11 de `apuntes.typ`],
  usado: [2C 2024 Ej. 2 · Recu 1C 2025 Ej. 1 · 1C 2025 Ej. 1],
  lean: [`Comun.teorema_CSB`],
)[
  *Enunciado.* Si $\#A <= \#B$ y $\#B <= \#A$ entonces $A tilde.op B$.

  *Cómo se usa.* Cierra el paso 3 del guion cuando las dos cotas son inyecciones.
]
```

El campo `lean` apunta al nombre en `lean/Comun/` (o en `lean/Parciales/`) para que ficha y librería
se correspondan uno a uno.

## Fuentes (sin inventar)

Para cada ficha, la trazabilidad sale de cruzar: las resoluciones de `parciales/*.typ` (citan las cajas
de `apuntes.typ`), los `lean/Parciales/*.lean` (nombran exactamente qué lemas de `Comun` y de Mathlib
usan) y las guías resueltas en `guias-agente/`. Un resultado es nivel "propio" sólo si no está en
`apuntes.typ` ni es un ejercicio de guía.

## Implementación

Un PR: este archivo de propuesta se elimina al implementar (regla de `CLAUDE.md`).
