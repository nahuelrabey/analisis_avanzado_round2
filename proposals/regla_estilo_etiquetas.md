# Propuesta: Aplicación de la Regla de Estilo para Etiquetas en `guias/`

## Diagnóstico
En Typst, las reglas `#show` definidas en `utils.typ` no se propagan automáticamente a los archivos que hacen `#import "../utils.typ": *`. Por esta razón, en `apuntes.typ`, `desafios.typ` y `ejemplos.typ` se incluyó explícitamente el siguiente bloque al inicio de cada archivo:

```typst
#show grid.cell: it => {
  if it.fill != none {
    set text(fill: white, weight: "bold", style: "italic")
    it
  } else {
    it
  }
}
```

En las guías de trabajos prácticos (`apuntes-typst/guias/p1.typ` a `p9.typ`), únicamente figuraba `#show: frame-style(styles.boxy)` sin la regla `#show grid.cell`, provocando que el texto de las etiquetas (`#duda`, `#enunciado`, `#solucion`, etc.) se renderizara con la fuente por defecto (negra) sobre el fondo de color de la pestaña, afectando la legibilidad.

---

## Solución Propuesta

### Opción A (Recomendada): Agregar la regla `#show grid.cell` en los archivos de las guías
Agregar al inicio de los archivos de guías (por ejemplo `apuntes-typst/guias/p1.typ`):

```typst
#import "../utils.typ": *
#show figure.where(kind: "frame"): set figure(numbering: none)
#show figure.where(kind: "frame"): set block(breakable: true)
#show: frame-style(styles.boxy)

#show grid.cell: it => {
  if it.fill != none {
    set text(fill: white, weight: "bold", style: "italic")
    it
  } else {
    it
  }
}
```

Esto asegurará que todas las etiquetas en `p1.typ` (y en las demás guías) tengan texto blanco en negrita sobre el fondo oscuro del encabezado del marco, manteniendo una perfecta consistencia estética con `apuntes.typ`, `desafios.typ` y `ejemplos.typ`.
