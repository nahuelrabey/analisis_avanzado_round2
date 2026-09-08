---
name: modo-web
description: Fija cómo se renderiza la matemática en las respuestas del chat cuando el usuario está leyendo en Claude web en vez de la terminal: ecuaciones en LaTeX con $$...$$ aisladas en su propio párrafo, y símbolos sueltos de la prosa en unicode. Es un modo pegajoso que dura toda la conversación. No modifica ningún archivo: los .typ del repo siguen siendo Typst siempre. Se activa mediante el comando `/modo-web` o cuando el usuario dice "modo web", "estoy en la web", "pasámelo a LaTeX", "no se ve bien la notación".
---

# Skill: Modo Web (`/modo-web`)

El usuario está leyendo la respuesta en **Claude web**, no en la terminal. Ahí la notación
Typst inline que usan las demás skills de chat se ve como código crudo. Esta skill fija el
formato que sí renderiza.

## Regla de oro: no se escribe nada

`/modo-web` **no crea ni modifica archivos**. Es una regla de presentación del chat, igual
que [`/corregir`](../corregir/SKILL.md), y comparte su excepción a
[`.agent/rules/skill_commands_authorization.md`](../../rules/skill_commands_authorization.md):
invocarla no autoriza a escribir nada.

**Lo que va a los archivos no cambia nunca.** `apuntes-typst/` es Typst, con `abs(...)`,
`divides` / `divides.not` y `compose`, con modo web activo o sin él. El modo termina en el
borde del chat.

## El modo es pegajoso

Una vez activado, rige **todas las respuestas siguientes** de la conversación, las de otras
skills incluidas. Se desactiva sólo si el usuario lo pide ("modo terminal", "volvé a Typst",
"salí del modo web"). No se pregunta en cada respuesta si sigue vigente, y no se anuncia que
está activo: se nota en el resultado.

---

## Qué renderiza y qué no

Medido en Claude web, no supuesto:

| Forma | Resultado |
|---|---|
| `$$...$$` **solo en su propio párrafo** | ✓ renderiza |
| `$$...$$` intercalado en una oración | ✗ sale literal: `$$\varphi$$` |
| `$...$` en cualquier posición | ✗ no confiable |
| `\(...\)` , `\[...\]` | ✗ salen literales |
| Typst inline (`$abs(a_n) < epsilon$`) | ✗ sale como código |
| Unicode en la prosa (φ, ∪, ε) | ✓ siempre |

De ahí salen las dos únicas reglas que hay que recordar:

### 1. Las ecuaciones van solas en su párrafo

Línea en blanco antes, línea en blanco después, `$$` abriendo y cerrando:

```markdown
Primero, las dos piezas de la regla unen

$$C \cup [B - (A \cup C)] = B - A,$$

así que no decís nada sobre x ∈ A.
```

La oración se **parte alrededor** de la ecuación: se escribe la mitad de arriba, se suelta
el bloque, y la mitad de abajo lo retoma. La ecuación es un renglón de la frase, no un
adorno colgado al final.

Un bloque `$$` **no va adentro** de un ítem de lista ni de una celda de tabla: ahí queda
literal o rompe la lista. Si el ítem necesita una fórmula, o se la escribe en unicode, o se
saca el ítem de la lista y se lo convierte en párrafo.

### 2. Todo lo que quede dentro de una oración va en unicode

Nombres de funciones, conjuntos, pertenencias, cuantificadores sueltos: unicode directo,
sin delimitadores.

> ✓ "φ aplica f únicamente sobre C. Sobre A no hay nada que componer."
> ✗ "$$\varphi$$ aplica $$f$$ únicamente sobre $$C$$."

Si la expresión no sobrevive al unicode sin ensuciarse --- fracciones, `cases`, sumatorias
con límites, integrales, matrices, subíndices de más de un carácter --- **no se la fuerza**:
se reescribe la oración para sacarla afuera y se la manda a bloque.

---

## Tabla de unicode de la materia

| Familia | Símbolos |
|---|---|
| Conjuntos | ∈ ∉ ⊆ ⊂ ⊄ ⊈ ∪ ∩ ∖ ∅ × ℘ |
| Números | ℕ ℤ ℚ ℝ ℂ ∞ |
| Lógica | ∀ ∃ ∄ ¬ ∧ ∨ ⇒ ⟸ ⟺ ∴ |
| Relaciones | ≤ ≥ ≠ ≈ ∼ ≅ ≡ ≺ ≼ |
| Flechas | → ↦ ↑ ↓ ⇢ |
| Operadores | ∘ ± ∓ √ ∑ ∏ ∫ ∂ ∇ |
| Divisibilidad | ∣ ∤ |
| Griegas | α β γ δ ε ζ η θ λ μ ν π ρ σ τ φ ψ ω Γ Δ Θ Λ Σ Φ Ω |
| Subíndices | ₀ ₁ ₂ ₃ ₄ ₅ ₆ ₇ ₈ ₉ ₙ ₖ ₘ ₐ ᵢ ⱼ |
| Superíndices | ⁰ ¹ ² ³ ⁴ ⁵ ⁶ ⁷ ⁸ ⁹ ⁿ ⁻ |

Detalles que se notan: el menos es **−** (U+2212), no el guión `-`; `aₙ`, `xₖ`, `Aⁿ` se
escriben con esos caracteres, no con `a_n`; `id` y `sup`, `inf`, `lim`, `máx`, `mín` van en
texto plano dentro de la prosa.

## Correspondencia con las reglas del proyecto

Las reglas de notación de `CLAUDE.md` están enunciadas sobre Typst. Su traducción al chat:

| Regla del proyecto (Typst) | En modo web, dentro de `$$` | En la prosa |
|---|---|---|
| valor absoluto con `abs(...)` | `\lvert a_n \rvert` | \|aₙ\| |
| `divides` / `divides.not` | `\mid` / `\nmid` | ∣ / ∤ |
| `compose`, nunca anidar | `g \circ f` | g ∘ f |
| displays partidos con `\\` | `\begin{aligned}...\end{aligned}` | --- |

Lo de siempre se mantiene: composición como g ∘ f y no como g(f(x)); si hace falta evaluar,
primero se nombra la composición y después se la evalúa.

## Ecuaciones largas

Dentro de un bloque, para partir o alinear:

```markdown
$$\begin{aligned}
B - A &= C \cup (B - A - C) = C \cup [B - (A \cup C)] \\
B &= A \cup (B - A) = (A \cup C) \cup [B - (A \cup C)]
\end{aligned}$$
```

Para definiciones por casos, `cases` --- que además es la razón más común por la que una
fórmula tiene que salir de la oración:

```markdown
$$\varphi(x) = \begin{cases} f(x) & x \in C \\ x & x \in B - (A \cup C)\end{cases}$$
```

## Lo que no cambia

- Las referencias a archivos siguen en backticks con línea: `apuntes-typst/guias/p2.typ:50`.
- Los veredictos, la clasificación ✗ / ⚠ / ○ y el formato de `/corregir` quedan igual: modo
  web cambia **cómo se escribe la matemática**, no la estructura de la respuesta.
- Nada de preámbulos ni de avisos del tipo "te lo paso en LaTeX": se entrega y listo.
