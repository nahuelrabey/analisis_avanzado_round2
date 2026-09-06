---
name: galerazo
description: Guarda "galerazos" --- técnicas, truquitos y patrones reutilizables para resolver ejercicios --- en el archivo Typst `apuntes-typst/galerazos.typ`, en formato apuntesito (descriptivo, estilo manual), usando como disparador la pregunta que los originó. Se activa mediante el comando `/galerazo` o cuando el usuario comparte una conversación, una idea o un truco y pide "guardar este galerazo".
---

# Skill: Galerazo (`/galerazo`)

Un **galerazo** es la maniobra que uno saca de la galera: el paso que, visto de afuera, parece magia, y que en realidad responde a un patrón reconocible y reutilizable.

El destino es siempre [`apuntes-typst/galerazos.typ`](file:///home/nahuel/study/analisis-avanzado/apuntes-typst/galerazos.typ), archivo acumulativo que usa los marcos de [`utils.typ`](file:///home/nahuel/study/analisis-avanzado/apuntes-typst/utils.typ) (`#galerazo`, `#disparador`, `#observacion`, `#sublema`).

## Qué es y qué no es un galerazo

| Va a... | Cuando el contenido es... |
|---|---|
| `galerazos.typ` | una **técnica** independiente del enunciado: cómo se le ocurre a uno, qué señal la dispara, cómo reconstruirla |
| `ejemplos.typ` (`/ejemplo`) | un **ejercicio resuelto** concreto, con su enunciado |
| `apuntes.typ` (`/apunte`) | **teoría de la materia**: definición, teorema, proposición, lema |

Reglas de frontera:

- Un galerazo **no se cita como resultado** en una demostración: es andamiaje mental, no teoría. Puede *usar* resultados de `apuntes.typ`, y los cita por nombre.
- Si una `#estrategia` de `ejemplos.typ` se repite en tres o más ejercicios, es candidata a **ascender** a galerazo. En ese caso el ejemplo queda donde está y su `#estrategia` pasa a remitir al galerazo (`ver G-N en galerazos.typ`).
- Un galerazo puede nacer de una conversación, de una clase o de una pregunta suelta del usuario: **no requiere que exista un ejercicio asociado**.

## Procedimiento

### 1. Extraer el disparador

Todo galerazo abre con la **pregunta que lo hizo aparecer**, en `#disparador[...]`. Si el input es una conversación, la pregunta es literalmente la que hizo el usuario --- se transcribe con su voz, en primera persona, sin pulirla de más ("¿cómo se me puede ocurrir...?"). Si el input no trae una pregunta explícita, redactarla: *¿qué duda tendría alguien que se topa con este paso por primera vez?*

### 2. Convertir el input a formato apuntesito

Si el material viene de un chat, **no se transcribe el diálogo**. Se reescribe como apunte: sin "¡Buena pregunta!", sin "vamos a la intuición", sin segunda persona conversacional. Prosa descriptiva de manual, en la que el usuario pueda entrar por el índice y leer la entrada sola.

### 3. Estructura fija de una entrada

```typst
== Galerazo N · Título corto y visual

#disparador[
  La pregunta que lo originó, en la voz del usuario.
]

#galerazo[G-N][
  La idea en dos o tres frases. Es la parte que se relee antes de un parcial.
]

=== La señal
Qué hay en el enunciado que dispara el galerazo. Es la sección más importante:
la traducción "cuando veo X, tengo que pensar Y". Conviene cerrarla con un
#sublema(titulo: "Traducción")[...] con esa equivalencia en una línea.

=== Por qué funciona
La justificación, con las cuentas mínimas. Si hay un gráfico que lo hace obvio,
va acá (cetz / cetz-plot, como en `utils.typ`).

=== La familia entera        // opcional
Tabla de variantes del mismo truco con distinto disfraz.

=== Cómo inventarlo de cero
La receta en pasos numerados para reconstruirlo sin acordarse de la fórmula.

=== Dónde se usa
Ejercicios, guías y temas donde aparece. Referenciar `p{N}: Ej. K` y los tags
de `ejemplos.typ` cuando corresponda.
```

Las secciones `La familia entera` y `Por qué funciona` son opcionales según el galerazo; **`La señal` y `Cómo inventarlo de cero` no lo son**: son la razón de ser del archivo. Si de un input no se puede extraer la señal, avisarle al usuario en lugar de rellenar.

### 4. Numeración y tag

- La sección se numera secuencialmente: `== Galerazo N · ...`, con $N$ el siguiente disponible.
- La pestaña del marco lleva `G-N` (`#galerazo[G-3][...]`). Ese tag es la forma de citarlo desde `ejemplos.typ` o desde las guías.
- Los galerazos **no se renumeran nunca**: entradas nuevas van al final.

### 5. Actualizar la tabla-índice

El encabezado del archivo tiene una tabla de tres columnas (*\#* / *Galerazo* / *Cuándo se dispara*). Agregar una fila por cada galerazo nuevo. La columna *Cuándo se dispara* es un resumen de la sección `La señal`, en una línea.

### 6. Reglas de Typst (obligatorias)

- Valor absoluto: `abs(x)`, nunca `|x|`.
- Divisibilidad: `divides` / `divides.not`.
- Composición: `compose` ($g compose f$), nunca aplicación anidada ($g(f(x))$).
- Ecuaciones display que no entren en el margen: partirlas explícitamente con `\`.
- Colores del archivo: fucsia `#c026d3` (marco y acentos), `#a21caf` (títulos), `#86198f` (encabezado de tablas), `#fdf4ff` (fondo suave).
- Verificar que compile antes de dar por terminado:
  ```bash
  typst compile --root apuntes-typst apuntes-typst/galerazos.typ pdf/galerazos.pdf
  ```

### 7. Rigor

- **No inventar galerazos**: si el usuario aporta la idea, se ordena y se redacta; no se agregan variantes ni justificaciones que no se puedan verificar.
- Si se deduce algo por razonamiento propio (una asíntota, una inversa, una cota), **aclararlo** en el texto.
- Las variantes de una tabla de familia tienen que ser correctas: si una no se verificó, no entra.
