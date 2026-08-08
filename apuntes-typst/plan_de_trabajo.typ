#import "utils.typ": *

#set page(
  paper: "a4",
  margin: (x: 1.8cm, y: 1.5cm),
  header: align(right)[
    #text(size: 8.5pt, fill: rgb("#64748b"))[Plan de Estudio y Prácticas -- Análisis Avanzado]
  ],
  footer: [
    #align(center)[#text(size: 8.5pt, fill: rgb("#94a3b8"))[Página #context counter(page).display()]]
  ]
)

#set text(
  font: "Liberation Sans",
  size: 9.5pt,
  lang: "es"
)

// Componentes estéticos
#let badge(texto, bg: rgb("#dbeafe"), fg: rgb("#1e40af")) = box(
  fill: bg,
  inset: (x: 5pt, y: 2pt),
  radius: 3.5pt,
  baseline: 0%,
  text(weight: "bold", size: 8pt, fill: fg)[#texto]
)

// Colores de cada uno de los 6 pasos del método
#let c-teoria = rgb("#2563eb")   // 1. Leer teoría y apuntar
#let c-demo   = rgb("#4f46e5")   // 2. Rehacer demostraciones
#let c-ejem   = rgb("#059669")   // 3. Rehacer ejemplos
#let c-desaf  = rgb("#d97706")   // 4. Desafíos
#let c-prac   = rgb("#7c3aed")   // 5. Prácticas
#let c-parc   = rgb("#dc2626")   // 6. Parciales

#let paso(n, texto) = {
  let cl = (c-teoria, c-demo, c-ejem, c-desaf, c-prac, c-parc).at(n - 1)
  let etiqueta = if texto == "" { [Paso #n] } else { [#n. #texto] }
  badge(etiqueta, bg: cl.lighten(86%), fg: cl.darken(15%))
}

#let bloque-card(titulo, tag-dias, color-borde: rgb("#2563eb"), cuerpo) = block(
  breakable: false,
  fill: rgb("#f8fafc"),
  stroke: (left: 4pt + color-borde, rest: 0.5pt + rgb("#cbd5e1")),
  inset: (x: 12pt, y: 7.5pt),
  radius: (right: 5pt),
  width: 100%
)[
  #grid(
    columns: (1fr, auto),
    align: (left, right),
    text(weight: "bold", size: 10.5pt, fill: color-borde)[#titulo],
    badge(tag-dias, bg: color-borde.lighten(85%), fg: color-borde.darken(20%))
  )
  #v(2.5pt)
  #cuerpo
]

// Header Principal
#align(center)[
  #block(
    fill: rgb("#eff6ff"),
    stroke: 0.8pt + rgb("#bfdbfe"),
    inset: (x: 16pt, y: 8pt),
    radius: 6pt,
    width: 100%
  )[
    #text(size: 14.5pt, weight: "bold", fill: rgb("#1e3a8a"))[Plan de Estudio y Cronograma de Prácticas] \
    #v(2pt)
    #text(size: 9.5pt, fill: rgb("#334155"))[Análisis Avanzado -- Plan de 90 Días sobre un método de 6 pasos] \
    #v(1pt)
    #text(size: 8pt, fill: rgb("#64748b"))[Teoría: `notas_materia.pdf`, Caps. 1--7 (77 pág.) · Prácticas: `guias/p1`--`p7` (245 ítems) · Exámenes: `parcial_1.typ`, `parcial_2.typ`]
  ]
]

#v(2pt)

== El método: 6 pasos, todos con días asignados

#v(1pt)

Cada capítulo se recorre con el mismo ciclo. Los pasos 1--4 trabajan sobre la teoría; el paso 5 sobre la guía correspondiente; el paso 6 cierra cada mitad de la materia.

#v(2pt)

#show table.cell.where(y: 0): set text(fill: white, weight: "bold", size: 8.5pt)

#table(
  columns: (0.5fr, 2.3fr, 1.5fr, 1.4fr, 0.7fr, 0.7fr),
  align: (center + horizon, left + horizon, left + horizon, center + horizon, center + horizon, center + horizon),
  fill: (x, y) => if y == 0 { rgb("#1e3a8a") } else if calc.even(y) { rgb("#f8fafc") } else { white },
  stroke: 0.4pt + rgb("#cbd5e1"),
  inset: (x: 5pt, y: 3.5pt),

  [*\#*], [*Paso*], [*Archivo de trabajo*], [*Volumen total*], [*Horas*], [*Días*],
  [1], [Leer teoría y redactar apuntes], [`apuntes.typ`], [77 páginas], [116], [26],
  [2], [Re-leer y rehacer las demostraciones solo], [`apuntes.typ`], [51 resultados], [38], [9],
  [3], [Rehacer los ejemplos], [`ejemplos.typ`], [50 ejemplos], [25], [6],
  [4], [Completar los desafíos], [`desafios.typ`], [29 ejercicios], [29], [6],
  [5], [Resolver las prácticas], [`guias/p1`--`p7`], [245 ítems], [142], [32],
  [6], [Rendir los parciales], [`parcial_1/2.typ`], [2 simulacros], [12], [3],
  [--], [Repaso integrador pre-parcial], [--], [2 bloques], [18], [4],
  table.cell(colspan: 4, align: right)[*Total*], [*380*], [*86*],
)

#v(2pt)

#sublema(titulo: "Presupuesto de horas")[
  A 4,5 h/día durante 90 días hay *405 horas* disponibles. El plan consume *380*, dejando ~25 h (unos 5--6 días) de colchón para imprevistos. No hay margen para más: el cronograma cierra, pero está ajustado.

  *La palanca sensible es el paso 5.* Está estimado a 35 min por ítem promediando ejercicios cortos (calcular una clausura) con demostraciones largas (Teorema de Cantor, p3 ej. 16). Si tu ritmo real resulta ser 50 min/ítem, son +60 h y el plan deja de cerrar. #box(fill: rgb("#fef3c7"), inset: (x: 4pt, y: 2pt), radius: 3pt)[*Medí tu ritmo real con p1 (Días 12--15) y recalibrá ahí*], mientras todavía queda margen para recortar.
]

#v(3pt)

== Resumen por capítulo

#v(1pt)

La columna *dem/pág* es la densidad de demostraciones del capítulo, y es la que gobierna el ritmo: los días no se reparten por cantidad de páginas sino por cuánto hay que demostrar en ellas.

#v(2pt)

#table(
  columns: (1.55fr, 0.5fr, 0.45fr, 0.5fr, 0.5fr, 0.6fr, 0.85fr, 0.6fr, 0.55fr, 0.5fr),
  align: (left + horizon, center + horizon, center + horizon, center + horizon, center + horizon, center + horizon, center + horizon, center + horizon, center + horizon, center + horizon),
  fill: (x, y) => if y == 0 { rgb("#1e3a8a") } else if calc.even(y) { rgb("#f8fafc") } else { white },
  stroke: 0.4pt + rgb("#cbd5e1"),
  inset: (x: 4pt, y: 3.5pt),

  [*Capítulo*], [*Págs*], [*Dem*], [*Ejem*], [*Desaf*], [*dem/pág*], [*Guía*], [*Días 1--4*], [*Días 5*], [*Total*],
  [1. Supremos], [8], [6], [6], [2], [0,75], [--], [5], [--], [5],
  [2. Sucesiones], [8], [6], [6], [6], [0,75], [p1 (31)], [6], [4], [10],
  [3. Cardinalidad], [8], [6], [4], [2], [0,75], [p2 (41)], [5], [5], [10],
  [4. Espacios Métricos], [24], [13], [16], [7], [0,54], [p3 (52)], [14], [7], [21],
  table.cell(colspan: 7, fill: rgb("#fee2e2"))[#text(fill: rgb("#991b1b"), weight: "bold")[Primer Parcial -- Caps. 1 a 4 (2 días de repaso + 2 de examen)]], table.cell(fill: rgb("#fee2e2"))[#text(fill: rgb("#991b1b"))[2]], table.cell(fill: rgb("#fee2e2"))[#text(fill: rgb("#991b1b"))[2]], table.cell(fill: rgb("#fee2e2"))[#text(fill: rgb("#991b1b"), weight: "bold")[4]],
  [5. Funciones continuas], [12], [5], [9], [9], [0,42], [p4 (43)], [8], [6], [14],
  [6. Compacidad], [12], [13], [6], [1], [*1,08*], [p5+p6 (55)], [8], [7], [15],
  [7. Sucesiones de funciones], [5], [4], [4], [2], [0,80], [p7 (23)], [4], [3], [7],
  table.cell(colspan: 7, fill: rgb("#fee2e2"))[#text(fill: rgb("#991b1b"), weight: "bold")[Segundo Parcial -- Caps. 5 a 7 (2 días de repaso + 2 de examen)]], table.cell(fill: rgb("#fee2e2"))[#text(fill: rgb("#991b1b"))[2]], table.cell(fill: rgb("#fee2e2"))[#text(fill: rgb("#991b1b"))[2]], table.cell(fill: rgb("#fee2e2"))[#text(fill: rgb("#991b1b"), weight: "bold")[4]],
  [*Total*], [*77*], [*51*], [*50*], [*29*], [--], [*245*], [*54*], [*36*], [*90*],
)

#v(2pt)

#sublema(titulo: "Por qué el ritmo cambia respecto del plan anterior")[
  El cronograma previo aceleraba justo donde el material se endurece: daba 0,94 pág/día a Supremos y 1,71 pág/día a Compacidad. Pero *Cap. 6 es el capítulo más denso del apunte* --- 13 demostraciones en 12 páginas, incluyendo Heine-Borel y el punto fijo de Banach --- mientras que Cap. 4 tiene esas mismas 13 demostraciones repartidas en 24 páginas.

  La corrección: Caps. 1--4 pasan de 46 a 30 días de teoría (estaban sobrepresupuestados), Caps. 6--7 suben de 10 a 12, y las 16 jornadas liberadas van a las guías, que pasan de 24 a 32 días.
]

#pagebreak()

== Cronograma detallado por bloques

#v(2pt)

#bloque-card("Bloque 1: Supremos y Sucesiones", "Días 1 al 15", color-borde: c-teoria)[
  - *Días 1 -- 5: Cap. 1 Supremos (págs. 5--12)* --- ciclo completo de 4 pasos
    - #paso(1, "Teoría") _Días 1--3:_ Axiomas de cuerpo y orden, conjuntos acotados, propiedad del supremo, Principio de Arquímedes, ínfimo y densidad de $QQ$. Transcribir con `/apunte`.
    - #paso(2, "Demostraciones") _Día 4:_ Rehacer las 6 demostraciones del capítulo sin mirar el apunte.
    - #paso(3, "Ejemplos") + #paso(4, "Desafíos") _Día 5:_ 6 ejemplos y 2 desafíos.
  - *Días 6 -- 11: Cap. 2 Sucesiones (págs. 13--20)* --- ciclo completo
    - #paso(1, "Teoría") _Días 6--8:_ Límite de sucesiones, álgebra de límites, subsucesiones, Bolzano-Weierstrass.
    - #paso(2, "Demostraciones") _Día 9:_ Las 6 demostraciones del capítulo.
    - #paso(3, "Ejemplos") _Día 10:_ 6 ejemplos.
    - #paso(4, "Desafíos") _Día 11:_ 6 desafíos --- es el capítulo con más carga de este paso en la primera mitad.
  - *Días 12 -- 15: #badge("Práctica 1 -- 31 ítems", bg: c-prac.lighten(86%), fg: c-prac.darken(15%))* #paso(5, "")
    - Supremo, ínfimo, Arquímedes, densidad de irracionales, límites por definición, subsucesiones.
    - #text(fill: rgb("#92400e"))[*Nota:* los ejercicios 1 y 2 de p1 ya están en `desafios.typ` como Desafíos 5.3 y 5.4. Aprovechalos: parte del paso 4 adelanta el paso 5.]
    - #text(fill: rgb("#92400e"))[*Punto de recalibración:* al terminar, medí cuántas horas te llevaron realmente los 31 ítems y ajustá el resto del cronograma.]
]

#v(4pt)

#bloque-card("Bloque 2: Cardinalidad", "Días 16 al 25", color-borde: rgb("#0891b2"))[
  - *Días 16 -- 20: Cap. 3 Cardinalidad (págs. 21--28)* --- ciclo completo
    - #paso(1, "Teoría") _Días 16--18:_ Equipotencia, conjuntos finitos, numerables, orden entre cardinales, Cantor-Bernstein.
    - #paso(2, "Demostraciones") _Día 19:_ Las 6 demostraciones del capítulo.
    - #paso(3, "Ejemplos") + #paso(4, "Desafíos") _Día 20:_ 4 ejemplos y 2 desafíos.
  - *Días 21 -- 25: #badge("Práctica 2 -- 41 ítems", bg: c-prac.lighten(86%), fg: c-prac.darken(15%))* #paso(5, "")
    - Cálculo explícito de cardinales, uniones numerables, cardinal de los irracionales, $cal(P)_f(A)$, cardinal de $RR[X]$.
]

#v(4pt)

#bloque-card("Bloque 3: Espacios Métricos y Primer Parcial", "Días 26 al 50", color-borde: rgb("#0d9488"))[
  Es el bloque más largo de la materia: 24 páginas y la guía más pesada (52 ítems).
  - *Días 26 -- 39: Cap. 4 Espacios Métricos (págs. 29--52)* --- ciclo completo
    - #paso(1, "Teoría") _Días 26--33:_ Métrica y métricas equivalentes en $RR^n$ ($d_1, d_2, d_infinity$); bolas y abiertos; adherencia y cerrados; derivado y frontera; sucesiones; completitud.
    - #paso(2, "Demostraciones") _Días 34--36:_ Las 13 demostraciones del capítulo, repartidas en tres jornadas.
    - #paso(3, "Ejemplos") _Días 37--38:_ 16 ejemplos --- el capítulo con más ejemplos del apunte.
    - #paso(4, "Desafíos") _Día 39:_ 7 desafíos.
  - *Días 40 -- 46: #badge("Práctica 3 -- 52 ítems", bg: rgb("#ccfbf1"), fg: rgb("#115e59"))* #paso(5, "")
    - Verificar métricas y dibujar bolas; interior/clausura/frontera; $d(x,A)$; equivalencia de $d_1, d_2, d_infinity$; completitud de $RR^n$; Teorema de la intersección de Cantor (ej. 16, reservale una jornada entera).
  - *Días 47 -- 48: Repaso integrador Caps. 1--4*
    - Releer los resúmenes de estrategia y rehacer un ejercicio al azar de cada guía sin mirar la resolución.
  - *Días 49 -- 50: #badge("Primer Parcial (parcial_1.typ)", bg: rgb("#fee2e2"), fg: rgb("#991b1b"))* #paso(6, "")
    - _Día 49:_ resolverlo cronometrado, en condiciones de examen. _Día 50:_ corregirlo y rehacer lo que salió mal.
    - _Temas que pone a prueba:_ cardinal de un conjunto de sucesiones (Ej. 1); $op("ínf")(A)$ frente a clausura e interior (Ej. 2); caracterización de abiertos vía $U inter overline(T) subset.eq overline(U inter T)$ (Ej. 3); el espacio $(X, d_infinity)$ de sucesiones finalmente nulas y su no completitud (Ej. 4).
]

#v(4pt)

#bloque-card("Bloque 4: Funciones Continuas", "Días 51 al 64", color-borde: rgb("#7c3aed"))[
  - *Días 51 -- 58: Cap. 5 Funciones continuas (págs. 53--64)* --- ciclo completo
    - #paso(1, "Teoría") _Días 51--54:_ Continuidad entre métricos, preservación de abiertos y cerrados, continuidad uniforme, homeomorfismos e isometrías.
    - #paso(2, "Demostraciones") _Día 55:_ Las 5 demostraciones del capítulo (es el de menor densidad: 0,42 dem/pág).
    - #paso(3, "Ejemplos") _Día 56:_ 9 ejemplos.
    - #paso(4, "Desafíos") _Días 57--58:_ 9 desafíos --- el capítulo con más ejercicios internos de todo el apunte.
  - *Días 59 -- 64: #badge("Práctica 4 -- 43 ítems", bg: c-prac.lighten(86%), fg: c-prac.darken(15%))* #paso(5, "")
    - Continuidad puntual y uniforme, funciones Lipschitz, isometrías, densidad bajo funciones continuas suryectivas, los funcionales $cal(E), cal(I)$ sobre $C([0,1])$.
]

#v(4pt)

#bloque-card("Bloque 5: Compacidad, Punto Fijo y Normas", "Días 65 al 79", color-borde: rgb("#c026d3"))[
  #text(fill: rgb("#86198f"))[*El capítulo más denso de la materia:* 13 demostraciones en 12 páginas. El plan anterior le daba 7 días; ahora tiene 8 solo para los pasos 1--4, más 7 para las dos guías.]
  - *Días 65 -- 72: Cap. 6 Compacidad (págs. 65--76)* --- ciclo completo
    - #paso(1, "Teoría") _Días 65--68:_ Compacidad por cubrimientos, compacidad secuencial, Heine-Borel en $RR^n$, y §6.1 Teorema del punto fijo de Banach.
    - #paso(2, "Demostraciones") _Días 69--71:_ Las 13 demostraciones, repartidas en tres jornadas. Es el paso 2 más pesado del cronograma.
    - #paso(3, "Ejemplos") + #paso(4, "Desafíos") _Día 72:_ 6 ejemplos y 1 desafío.
  - *Días 73 -- 75: #badge("Práctica 5 -- 22 ítems", bg: c-prac.lighten(86%), fg: c-prac.darken(15%))* #paso(5, "")
    - Compacidad por definición, cubrimientos, máximos y mínimos sobre compactos, contracciones, $overline(B(f_0,1))$ no compacta en $C[0,1]$.
  - *Días 76 -- 79: #badge("Práctica 6 -- 33 ítems", bg: c-prac.lighten(86%), fg: c-prac.darken(15%))* #paso(5, "")
    - Normas en $RR^n$, espacios normados, $ell^infinity$ y $ell^2$, operadores lineales continuos y sus normas.
]

#v(4pt)

#bloque-card("Bloque 6: Sucesiones de Funciones y Segundo Parcial", "Días 80 al 90", color-borde: c-parc)[
  - *Días 80 -- 83: Cap. 7 Sucesiones de funciones (págs. 77--81)* --- ciclo completo
    - #paso(1, "Teoría") _Días 80--81:_ Convergencia puntual vs. uniforme (Defs. 42--43), Teorema 22, sucesiones uniformemente de Cauchy (Def. 44, Teorema 23), y las *Proposiciones 23 y 24*: intercambio de límite con integral de Riemann sobre $[a,b]$ y con derivada en $C^1([a,b])$.
    - #paso(2, "Demostraciones") _Día 82:_ Las 4 demostraciones del capítulo.
    - #paso(3, "Ejemplos") + #paso(4, "Desafíos") _Día 83:_ 4 ejemplos y 2 desafíos.
  - *Días 84 -- 86: #badge("Práctica 7 -- 23 ítems", bg: c-prac.lighten(86%), fg: c-prac.darken(15%))* #paso(5, "")
    - Convergencia puntual y uniforme, el espacio $B(X)$ de funciones acotadas, preservación de continuidad uniforme, derivación de límites uniformes.
  - *Días 87 -- 88: Repaso integrador Caps. 5--7*
  - *Días 89 -- 90: #badge("Segundo Parcial (parcial_2.typ)", bg: rgb("#fee2e2"), fg: rgb("#991b1b"))* #paso(6, "")
    - _Ejercicios vigentes:_ Ej. 1 ($f^n$ contracción $=>$ punto fijo único de $f$, Cap. 6) y Ej. 2 (la serie $c(x) = sum (-1)^n x^(2n)\/(2n)!$ está bien definida, es dos veces derivable y $c'' + c = 0$ --- convergencia uniforme y derivación término a término, Cap. 7).
    - _Ejercicio 5 (optativo, Picard):_ también vigente. Escribe $integral_0^t f(y(s)) d mu(s)$, pero para $f compose y$ continua eso es integral de Riemann; lo que realmente necesita es el punto fijo de Banach sobre $C([-epsilon,epsilon], RR^d)$.
    - #text(fill: rgb("#991b1b"))[*Advertencia:* los Ej. 3 y 4 son de teoría de la medida (ver contingencia abajo). Si ese tema no entra, quedan fuera de programa --- y como la consigna dice "se aprueba con dos de los primeros cuatro", *este parcial deja de ser un simulacro representativo*. Usalo como práctica de los Ej. 1, 2 y 5, no como examen cronometrado.]
]

#v(4pt)

== Contingencia: Medida e Integración

#v(1pt)

#block(
  fill: rgb("#fffbeb"),
  stroke: (left: 4pt + rgb("#d97706"), rest: 0.5pt + rgb("#fcd34d")),
  inset: (x: 12pt, y: 8pt),
  radius: (right: 5pt),
  width: 100%
)[
  *Este cronograma asume que Medida e Integración no entra*, y esa decisión es la que hace que los 90 días cierren. La evidencia disponible la respalda:

  #v(2pt)
  #table(
    columns: (1.5fr, 1.2fr, 2.6fr),
    align: (left + horizon, center + horizon, left + horizon),
    fill: (x, y) => if y == 0 { rgb("#92400e") } else if calc.even(y) { rgb("#fffbeb") } else { white },
    stroke: 0.4pt + rgb("#fcd34d"),
    inset: (x: 5pt, y: 3.5pt),
    [*Documento*], [*Fecha*], [*¿Trae Medida?*],
    [`notas_materia.pdf`], [1er cuat. 2026], [*No* --- 7 capítulos, termina en "Sucesiones de funciones", pág. 77],
    [`guias/p1`--`p9.typ`], [2do cuat. 2025], [Sí, en p8 y p9],
    [`parcial_2.typ`], [30/11/2024], [Sí, en Ej. 3 y 4],
  )
  #v(3pt)

  El documento más nuevo y más oficial ya no la incluye. Las guías p8 y p9 y el parcial son de cuatrimestres anteriores.

  *Integración no se puede separar de Medida.* La integral de Lebesgue se define en tres etapas y la medida aparece en la primera: para $phi = sum_(i=1)^n a_i chi_(A_i)$ con los $A_i$ medibles, $integral phi d mu := sum_(i=1)^n a_i mu(A_i)$. Sin $mu$ no hay definición de $integral f d mu$. Y 7 de los 13 ejercicios de primer nivel de p9 nombran objetos de teoría de la medida en el enunciado mismo (función simple, $sigma$-álgebra, función medible, $A in cal(M)$, medida finita). *Si p8 no entra, p9 tampoco puede entrar.*

  Lo que sí queda, y ya está en el cronograma: el intercambio de límite e integral de *Riemann* (Cap. 7, Prop. 23), que no usa medida en absoluto.

  #v(3pt)
  *Verificación pendiente:* confirmar con la cátedra si publica p8 y p9 este cuatrimestre. Hasta entonces las guías se conservan en `guias/` sin borrar.

  #v(3pt)
  *Si resulta que sí entra:* el plan de 90 días no cierra --- son 54 ítems más ($approx$ 32 h) y un tema sin fuente teórica en el repositorio, lo que da $approx$ 420 h contra las 405 disponibles. En ese caso hay que, en este orden: (1) conseguir una fuente de teoría de la medida y sumarla a `apuntes-docentes/`; (2) recortar alcance en las guías ya cubiertas, resolviendo un subconjunto representativo de p2 y p4 en lugar de la guía completa; (3) reasignar los 4 días de repaso integrador.
]

#v(4pt)

#sublema(titulo: "Notas de método")[
  - *Los pasos 2 a 4 no son repaso, son producción.* Rehacer una demostración sin mirar el apunte es lo que convierte la lectura en conocimiento propio, y por eso tienen 21 días asignados (9 + 6 + 6) en lugar de quedar implícitos dentro de la lectura.
  - *Los pasos 3 y 4 dependen de que `ejemplos.typ` y `desafios.typ` estén cargados.* Transcribí con `/ejemplo` y `/desafio` durante el paso 1 de cada capítulo, no después: cuando llegue el día del paso 3 el material tiene que estar listo.
  - *Escribir de atrás para adelante, pensar de adelante para atrás.* La intuición viene primero; la redacción formal reconstruye el puente. Al cerrar cada guía, resumí la estrategia de cada ejercicio en una o dos líneas --- eso es lo que se relee antes del parcial, no la resolución completa.
  - *Las fechas de parcial de los Días 49--50 y 89--90 son marcadores.* Alinealas con las fechas reales de la cursada y desplazá los bloques vecinos; los días de repaso integrador que las preceden son el amortiguador natural para ese ajuste.
  - *Conflictos entre métodos de resolución:* anotarlos durante el paso 5 y llevarlos juntos a la clase de consulta, en lugar de resolverlos sobre la marcha.
]

#pagebreak()

== Observación: inventario de `notas_materia.pdf`

#v(1pt)

Conteo crudo de resultados numerados por capítulo, extraído del PDF. Es la base sobre la que se calcularon todos los presupuestos de días de este plan.

#v(2pt)

#table(
  columns: (2fr, 0.7fr, 0.7fr, 0.7fr, 0.7fr, 0.7fr, 0.7fr),
  align: (left + horizon, center + horizon, center + horizon, center + horizon, center + horizon, center + horizon, center + horizon),
  fill: (x, y) => if y == 0 { rgb("#334155") } else if calc.even(y) { rgb("#f8fafc") } else { white },
  stroke: 0.4pt + rgb("#cbd5e1"),
  inset: (x: 5pt, y: 3.5pt),

  [*Capítulo*], [*Págs*], [*Dem*], [*Ejem*], [*Ejer*], [*Def*], [*Obs*],
  [1. Supremos], [8], [6], [6], [2], [5], [2],
  [2. Sucesiones], [8], [6], [6], [6], [6], [0],
  [3. Cardinalidad], [8], [6], [4], [2], [5], [5],
  [4. Espacios Métricos], [24], [13], [16], [7], [14], [8],
  [5. Funciones continuas], [12], [5], [9], [9], [7], [5],
  [6. Compacidad], [12], [13], [6], [1], [4], [4],
  [7. Sucesiones de funciones], [5], [4], [4], [2], [4], [2],
  [*Suma por capítulos*], [*77*], [*53*], [*51*], [*29*], [*45*], [*26*],
  [*Total sin repetidos*], [*77*], [*51*], [*50*], [*29*], [*45*], [*26*],
)

#v(2pt)

#sublema(titulo: "Cómo leer este inventario")[
  - *Dem* agrupa Teoremas, Proposiciones y Corolarios --- los 51 resultados con demostración que alimentan el paso 2. Desglosados: 23 teoremas, 24 proposiciones, 4 corolarios.
  - *Ejer* son los ejercicios que las notas dejan planteados dentro del texto teórico. Son la fuente del paso 4 y lo que se acumula en `desafios.typ`.
  - *Def* y *Obs* no tienen días propios: se absorben dentro del paso 1, al transcribir con `/apunte`.
  - *Las dos filas de total difieren en Dem (53 vs 51) y Ejem (51 vs 50).* La suma por capítulos cuenta dos veces los resultados que cruzan el corte de página entre capítulos; la fila _sin repetidos_ es el conteo global deduplicado y es la que se usó para presupuestar. Def, Ejer y Obs coinciden en ambas filas.
  - *Densidad de demostraciones:* Cap. 6 encabeza con 1,08 dem/pág, seguido de Cap. 7 (0,80) y Caps. 1--3 (0,75). Cap. 5 es el más liviano (0,42) pero compensa con 9 ejercicios internos, el máximo del apunte.
]
