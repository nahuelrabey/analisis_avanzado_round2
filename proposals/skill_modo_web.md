# Propuesta: Skill `modo-web` (renderizado de respuestas en chat)

## Diagnóstico

El usuario consume las respuestas del agente en **Claude web**, no en la terminal. El
renderizado de matemática ahí no coincide con lo que asumen las skills actuales:

| Forma | Resultado observado en la web |
|---|---|
| Typst inline (`$abs(a_n) < epsilon$`) | se ve el código crudo, no renderiza |
| `$...$` de LaTeX en medio de una oración | no renderiza |
| `$$...$$` en medio de una oración | **no renderiza**: aparece literal (`$$\varphi$$`) |
| `$$...$$` solo en su propio párrafo | renderiza correcto |

Es decir: el único delimitador confiable es `$$...$$` **aislado en su propio párrafo**.
Cualquier símbolo que vaya intercalado en la prosa tiene que ir en unicode.

Esto se detectó corrigiendo el ejercicio 2.b de la guía 2: la corrección salió ilegible
dos veces seguidas antes de dar con la combinación que funciona.

## Impacto en las SKILLS

1. **`/corregir`** — su sección "Formato de la respuesta" ordena escribir la notación en
   *Typst inline*. En la web eso es exactamente lo que no se ve. Hay conflicto directo y
   hay que anotar la excepción.
2. **Resto de las skills de escritura** (`/apunte`, `/guia`, `/ejemplo`, `/galerazo`,
   `/desafio`) — **no se tocan**: lo que va a los archivos `.typ` sigue siendo Typst, con
   `abs(...)`, `divides`, `compose` y todas las reglas de `CLAUDE.md`. El modo sólo afecta
   el texto que se muestra en el chat.
3. **`CLAUDE.md`** — no requiere cambios: sus reglas de notación están enunciadas sobre
   Typst, o sea sobre archivos, no sobre el chat.

## Propuesta

### A. Crear `.agent/skills/modo-web/SKILL.md`

Skill de chat puro (como `/corregir`: no escribe archivos) que se activa con `/modo-web` o
escribiendo "modo web", y que fija las reglas de renderizado:

- ecuaciones en `$$...$$` **solas en su párrafo**, con línea en blanco antes y después;
- nunca `$$...$$` ni `$...$` intercalado en una oración, nunca `\(...\)` ni `\[...\]`;
- símbolos sueltos dentro de la prosa: **unicode** (φ, ψ, ∪, ⊆, ∈, ∘, ε, ℝ, aₙ);
- si una expresión no se puede escribir en unicode sin ensuciarla (fracciones, `cases`,
  sumatorias con límites, matrices), se la saca de la oración y va a bloque;
- el modo es **pegajoso**: queda activo hasta que el usuario lo desactive;
- incluye tabla de unicode de uso frecuente en la materia.

### B. Anotar la excepción en `.agent/skills/corregir/SKILL.md`

Una línea en "Formato de la respuesta": con `/modo-web` activo, la notación del chat sigue
las reglas de esa skill (LaTeX + unicode) en lugar de Typst inline. Los archivos no cambian.

## Alcance explícito

El modo **no cambia ni un archivo del repo**. `apuntes-typst/` sigue siendo Typst siempre,
sin importar cómo se vea el chat.
