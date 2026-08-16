# Propuesta de Arquitectura: Memoria del Agente para Bibliografía y PDFs (`memoria_agente/`)

## 1. Contexto y Racionalidad

Actualmente, los archivos Typst en `apuntes-typst/` constituyen texto plano estructurado de lectura directa. Sin embargo, los materiales de soporte en PDF como libros de texto (*Understanding Analysis* de Abbott), notas docentes (`notas_materia.pdf`, `clases_salva.pdf`) y filminas de clases (`notas_docentes_2023/`) son archivos binarios pesados.

Para evitar que el agente tenga que releer, parsear o procesar a ciegas estos PDFs extensos consume gran cantidad de tokens de contexto, se propone crear el directorio `memoria_agente/`. Este actuará como un **mapa de referencias e índice temático de acceso ultrarrápido**, permitiendo localizar en segundos el libro, capítulo, sección y número de página exacto de cualquier definición, teorema o ejemplo resuelto.

---

## 2. Estructura del Directorio `memoria_agente/`

```text
memoria_agente/
├── INDEX.md                                   # Índice general y guía de uso para los agentes
├── 00_indice_abbott_understanding_analysis.md # Mapeo por capítulo, sección, página y teoremas de Abbott
├── 01_indice_notas_materia.md                 # Mapeo por capítulo y sección de notas_materia.pdf
├── 02_indice_clases_y_notas_docentes.md       # Mapeo temático por filmina/página de clases_salva.pdf y notas_docentes_2023/
└── 03_mapa_ejemplos_y_demostraciones_pdf.md   # Catálogo cruzado de demostraciones y ejemplos resueltos en la bibliografía
```

---

## 3. Impacto en las SKILLS y Flujo de Trabajo

### Evaluación de impacto en SKILLS:
- **`apunte` / `ejemplo` / `guia` / `desafio`**:
  - Al procesar consignas que hagan referencia a la bibliografía o filminas docentes, la agent-skill consultará primero `memoria_agente/` para ubicar el material de fuente exacto (página/sección) sin necesidad de escanear PDFs enteros.
  - Al completar la transcripción de un nuevo tema relevante derivado de los PDFs, se registrará opcionalmente el mapeo en `memoria_agente/`.

---

## 4. Plan de Implementación Paso a Paso

1. **Creación de `memoria_agente/INDEX.md`**:
   Documentar las reglas de consulta, formato de entradas e índice general de los archivos de memoria.

2. **Indexado de `understanding_analysis.pdf` (Abbott)**:
   Generar `00_indice_abbott_understanding_analysis.md` mapeando la estructura de capítulos (Real Numbers, Sequences, Continuity, etc.) con sus teoremas principales y números de página del PDF.

3. **Indexado de `notas_materia.pdf` y `clases_salva.pdf`**:
   Generar `01_indice_notas_materia.md` y `02_indice_clases_y_notas_docentes.md` con las referencias a filminas y hojas de lectura de la cátedra.

4. **Publicación y Vinculación en `CLAUDE.md`**:
   Referenciar brevemente `memoria_agente/` en `CLAUDE.md` para que cualquier agente reconozca este recurso al iniciar sesión.
