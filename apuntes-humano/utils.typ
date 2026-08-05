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
