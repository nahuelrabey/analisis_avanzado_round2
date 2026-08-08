#import "@preview/cetz:0.4.0"
#import "@preview/cetz-plot:0.1.2": plot

/// Dibuja una recta numérica sencilla con marcas y etiquetas ajustables.
/// Uso: #recta([$m'$], ([$m$], "arriba"), [$x$], [$m'+1$])
#let recta(..marcas, paso: 1.5) = cetz.canvas({
  import cetz.draw: *
  let cant = marcas.pos().len()
  line((0, 0), ((cant + 1) * paso, 0), stroke: 1pt)
  
  for (i, m) in marcas.pos().enumerate() {
    let x = (i + 1) * paso
    let (lbl, pos) = if type(m) == array { m } else { (m, "abajo") }
    let dir = if pos == "arriba" { 1 } else { -1 }
    
    line((x, -0.2 * dir), (x, 0.25 * dir), stroke: if pos == "arriba" { 1.5pt } else { 1pt })
    content((x, 0.5 * dir), lbl)
  }
})

/// Caja destacada para lemas auxiliares o justificaciones técnicas intermedias.
/// Uso: #sublema(titulo: "Lema auxiliar")[Texto...]
#let sublema(titulo: "Detalle técnico", cuerpo) = block(
  fill: rgb("#f8fafc"),
  stroke: (left: 3.5pt + rgb("#475569")),
  inset: (x: 12pt, y: 10pt),
  radius: (right: 4pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#334155"))[#titulo] \
  #v(2pt)
  #cuerpo
]

/// Grafica una sucesión de valores (y_1, y_2, ..., y_n) en el plano cartesiano (n vs y_n).
/// Uso: #grafico-plano((1, 0.5, 1/3, 0.25), ticks-y: ((1, $1$), (0.5, $1/2$)))
#let grafico-plano(valores, ticks-y: (), x-label: $n$, y-label: $a_n$, color: rgb("#0000ff")) = align(center)[
  #cetz.canvas({
    let max-y = calc.max(..valores, 1) * 1.15
    let min-y = calc.min(..valores, 0)
    let pts = valores.enumerate().map(((i, v)) => (i + 1, v))
    
    plot.plot(
      size: (9, 5.5),
      x-min: 0, x-max: valores.len() + 0.8,
      y-min: min-y, y-max: max-y,
      x-tick-step: 1,
      y-tick-step: if ticks-y.len() == 0 { auto } else { none },
      y-ticks: ticks-y,
      x-label: x-label,
      y-label: y-label,
      axis-style: "school-book",
      grid: "dashed",
      {
        plot.add(
          pts,
          style: (stroke: none),
          mark: "o",
          mark-size: 0.18,
          mark-style: (fill: color, stroke: color)
        )
      }
    )
  })
]

/// Grafica valores acumulados sobre la recta real (1D).
/// Uso: #grafico-recta((1, 0.5, 1/3, 0.25), etiquetas: ($a_1$, $a_2$, $a_3$, $a_4$))
#let grafico-recta(valores, etiquetas: (), origen: 0, color: rgb("#0000ff")) = align(center)[
  #cetz.canvas({
    import cetz.draw: *
    let width = 9
    let margin = 0.8
    let max-val = calc.max(..valores, 1)
    let scale-x(val) = (val / max-val) * (width - margin)

    // Eje horizontal
    line((-margin, 0), (width, 0), mark: (end: "stealth"), stroke: 1pt)

    // Origen
    line((scale-x(origen), -0.15), (scale-x(origen), 0.15), stroke: 1pt)
    content((scale-x(origen), -0.45), text(size: 11pt)[$#origen$])

    // Puntos
    for (i, v) in valores.enumerate() {
      let x = scale-x(v)
      circle((x, 0), radius: 0.08, fill: color, stroke: color)
      if i < etiquetas.len() {
        content((x, -0.45), text(size: 11pt)[#etiquetas.at(i)])
      }
    }
  })
]
