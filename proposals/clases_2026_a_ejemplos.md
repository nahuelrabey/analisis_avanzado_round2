# Propuesta: transcribir las clases prácticas de 2026 y volcar sus ejercicios en `ejemplos/`

Pedido del usuario (12/10/2026): cinco PDF tipeados de las clases prácticas de este cuatrimestre
(27/08 soluciones, 01/09 cardinalidad parte 1, 15/09 espacios métricos primera parte, Clase 11 del 17/09
abiertos y cerrados, 29/09 repaso). Primero transcribirlas; después seleccionar ejercicios y ubicarlos en
`ejemplos/p{N}.typ`.

## Paso 1 — ¿Afecta a alguna SKILL?

**Sí, a `ejemplo`** (sección 5.1, tags). Hoy la skill sólo documenta dos orígenes de clase: `C{N}-k` para las
notas docentes 2025 (`clases/{tema}.typ`) y, de hecho pero sin documentar, `DD/MM-k` para clases de 2026
(`15/09-1..6` en `ejemplos/p3.typ`, cargadas de fotos del pizarrón). Hace falta:

1. Un lugar para las transcripciones de 2026: `apuntes-typst/clases/2026/{MMDD}_{tema}.typ`
   (subcarpeta para no mezclarlas con las de 2025; cabecera que declare fecha, fuente y tags).
2. Documentar en la skill el tag `DD/MM-k` ("Clase DD/MM" en el título) y la regla de no reusar números:
   los de la clase del 15/09 arrancan en `15/09-7` porque `15/09-1..6` ya existen.

## Paso 2 — Qué se hace

- `clases/2026/0827_subsucesiones_monotonas.typ` (tags `27/08-k`), `0901_cardinalidad_1.typ` (`01/09-k`),
  `0915_espacios_metricos_1.typ` (`15/09-7`, `15/09-8`), `0917_abiertos_cerrados.typ` (`17/09-k`),
  `0929_repaso.typ` (`29/09-k`). Mismo estilo que `clases/completitud.typ`; `_Nota_` para deslices.
- Volcado a `ejemplos/`: 27/08 → `p1.typ` (Bloque 6, subsucesiones monótonas / divergencia); 01/09 → `p2.typ`;
  15/09 y 29/09 (métricas) → `p3.typ` Bloque 1; 17/09 → `p3.typ` Bloques 2 y 3; 29/09 Ej. 3 (subconjuntos de
  `ℕ^ℕ`) → `p2.typ`. Actualizar tabla-mapa, "Huecos" y las tablas "Qué leer" de `guias/p1.typ` y `p2.typ`.
- Skill `ejemplo`: párrafo sobre `DD/MM-k` y la carpeta `clases/2026/`.

## Paso 3 — Al implementar, borrar este archivo.
