#import "@preview/cetz:0.3.3"

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

