#import "@preview/frame-it:2.0.0": *
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

#show heading.where(level: 2): it => block(width: 100%)[
  #v(6pt)
  #text(size: 12pt, weight: "bold", fill: rgb("#059669"))[#it.body]
  #v(2pt)
  #line(length: 100%, stroke: 0.7pt + rgb("#a7f3d0"))
]

// --- Ejemplos de la Práctica 2 ---

#align(center)[
  #text(14pt, weight: "bold")[Ejemplos resueltos --- Práctica 2] \
  #v(2pt)
  #text(10pt, style: "italic", fill: rgb("#475569"))[
    Cardinalidad: biyecciones, numerabilidad y cálculo de cardinales
  ]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

Los ejemplos están agrupados por *técnica*, no por orden de transcripción, y los bloques siguen el orden en que la guía los necesita. Cada bloque abre con la nota de qué ejercicios de `guias/p2.typ` desbloquea.

La pestaña dice de dónde viene cada ejemplo: un *número* es el ejemplo de `notas_materia.pdf` (con su numeración por capítulo entre paréntesis en el título), *`C{clase}-{ejemplo}`* es un ejercicio resuelto en clase --- `C1-4` es el Ejemplo 4 de `clases_2023/apuntes_1.typ` --- y *`A{sección}`* es un resultado o ejercicio de Abbott, _Understanding Analysis_ --- `A1.5.9` es el Ejercicio 1.5.9 del libro.

#v(6pt)

#show table.cell.where(y: 0): set text(fill: white, weight: "bold", size: 8.5pt)

#table(
  columns: (0.35fr, 2.4fr, 1.1fr),
  align: (center + horizon, left + horizon, left + horizon),
  fill: (x, y) => if y == 0 { rgb("#065f46") } else if calc.even(y) { rgb("#f8fafc") } else { white },
  stroke: 0.4pt + rgb("#cbd5e1"),
  inset: (x: 6pt, y: 4pt),

  [*\#*], [*Bloque*], [*Desbloquea*],
  [1], [Cardinalidad], [p2: Ej. 1, 4, 8, 9 (c), 14, 16, 17 (a)],
)

#v(4pt)

#text(size: 9pt, fill: rgb("#64748b"))[
  La numeración de ejercicios es la de la *guía 2026* (`apuntes-docentes/guias/p2.pdf`).
]

#v(8pt)

== Bloque 1 · Cardinalidad

#sublema(titulo: "Qué desbloquea")[
  El *Ejercicio 1* de la Práctica 2 (cardinalidad de subconjuntos de $ZZ$, múltiplos y productos) requiere construir biyecciones o inyecciones explícitas. La partición de $NN$ en pares e impares para coordinar con $ZZ$ es el modelo fundamental para entrelazar conjuntos o cubrir signos opuestos. El uso del Teorema de Cantor-Schröeder-Bernstein y la codificación con factores primos ($2^n 3^m$) desbloquea el producto cartesiano de conjuntos numerables. Por último, transportar una función con las biyecciones dadas ($h |-> g compose h compose f^(-1)$) es la herramienta detrás de los *Ejercicios 8* y *9 (c)*, donde hay que coordinar conjuntos de funciones y partes de un conjunto.
]

#ejemplo[Coordinabilidad de $NN$ con los pares, con $ZZ$ y con $QQ^+$ (Ejemplo 3.3)][13][
  #set enum(numbering: "a)")
  + $NN tilde.op {"números naturales pares"}$. Son coordinables mediante la función $f(n) = 2n$, que es biyectiva.
  + $NN tilde.op ZZ$: podemos tomar la función
    $ f(n) = cases(
      n/2 &"si" n "es par",
      -((n - 1)/2) &"si" n "es impar".
    ) $
  + $NN tilde.op QQ^+ = {q in QQ : q > 0}$: para ver esto, vamos a hacer el siguiente procedimiento.

    Pensemos que armamos una grilla infinita donde ubicamos a la fracción $m/n$ en la columna $m$ y fila $n$. Nuestra biyección $f : NN -> QQ^+$ va a recorrer la grilla como en el gráfico que hicimos más abajo, teniendo en cuenta que debemos "saltarnos" a los repetidos: las fracciones $1/1$ y $2/2$ representan el mismo número, y queremos que nuestra $f$ sea inyectiva.

    Nos quedaría:
    $ f(1) = 1, quad f(2) = 2, quad f(3) = 1/2, quad f(4) = 1/3, quad f(5) = 3, quad dots $

    #v(4pt)
    #block(breakable: false, width: 100%)[#align(center)[
      #cetz.canvas({
        import cetz.draw: *

        let spacing = 1.4
        let rows = 5
        let cols = 5

        // Título Numeradores arriba
        content(((cols + 1) * spacing / 2, 1.4), text(12pt, weight: "bold")[Numeradores ($m$)])

        // Etiquetas de columnas m
        for m in range(1, cols + 1) {
          content((m * spacing, 0.65), text(11pt)[$m = #m$])
        }

        // Título Denominadores a la izquierda
        content((-1.8, - (rows - 1) * spacing / 2), angle: 90deg, text(12pt, weight: "bold")[Denominadores ($n$)])

        // Etiquetas de filas n
        for n in range(1, rows + 1) {
          let y = - (n - 1) * spacing
          content((-0.4, y), text(11pt)[$n = #n$])
        }

        // Dibujar puntos y etiquetas de fracciones
        for n in range(1, rows + 1) {
          for m in range(1, cols + 1) {
            let x = m * spacing
            let y = - (n - 1) * spacing
            circle((x, y), radius: 0.08, fill: black, stroke: black)
            
            if m <= 4 and n <= 4 {
              content((x, y + 0.28), text(8pt, fill: rgb("#64748b"))[$#m/#n$])
            }
          }
        }

        // Cruces rojas en los repetidos
        let repetidos = ((2, 2), (4, 2), (3, 3), (2, 4))
        for (m, n) in repetidos {
          let x = m * spacing
          let y = - (n - 1) * spacing
          line((x - 0.2, y - 0.2), (x + 0.2, y + 0.2), stroke: 1.5pt + rgb("#dc2626"))
          line((x - 0.2, y + 0.2), (x + 0.2, y - 0.2), stroke: 1.5pt + rgb("#dc2626"))
        }

        // Trayectoria azul
        let pt(m, n) = (m * spacing, - (n - 1) * spacing)

        line(
          pt(1, 1),
          pt(2, 1),
          pt(1, 2),
          pt(1, 3),
          pt(3, 1),
          pt(4, 1),
          pt(1, 4),
          pt(1, 5),
          pt(5, 1),
          stroke: 1.3pt + rgb("#2563eb"),
          mark: (end: "stealth")
        )
      })
    ]]
]

#estrategia[
  Informalmente, notemos que esta función le asigna a cada número natural par su mitad y con esto estaríamos "cubriendo" los enteros positivos. Por otro lado, "cubrimos" los enteros negativos y el cero con los naturales impares asignándole a cada uno, $-$ la mitad de su par anterior.
]

#resolucion[
  Formalmente tenemos que probar que $f$ resulta biyectiva:

  - *Inyectiva:* supongamos que $n != m$. Si $n$ es par y $m$ es impar, entonces $f(n) != f(m)$ porque uno es positivo y el otro negativo. Si ambos son pares, es fácil ver que $f(n) != f(m)$ porque $n/2 != m/2$. Si ambos son impares podemos hacer un razonamiento parecido.
  - *Sobreyectiva:* sea $a in ZZ$. Si $a > 0$, entonces $a = f(2a)$, dado que $2a$ es un número natural par. Si $a <= 0$, entonces $a = f(-2a + 1)$, dado que $-2a + 1$ es un número natural impar.
]

#ejemplo[$QQ$ es numerable partiéndolo en bloques finitos (Abbott, Teorema 1.5.6 (i))][A1.5.6a][
  Probar que $QQ$ es numerable, sin construir ninguna fórmula explícita: agrupando los racionales en pedazos finitos y listándolos uno tras otro.
]

#estrategia[Cuando la fórmula es incómoda, se lista por bloques][
  El Ejemplo 3.3 (c) recorre la grilla de $QQ^+$ en diagonal salteando repetidos, y ahí la biyección existe pero escribirla es un engorro. La alternativa es partir $QQ$ en *bloques finitos*: si cada bloque tiene finitos elementos y hay una cantidad numerable de bloques, la lista se arma concatenándolos, y todo elemento cae en una posición finita.

  La señal es tener un *parámetro natural* que ordene el conjunto en capas finitas. Para una fracción irreducible $p\/q$ el parámetro natural es $p + q$.
]

#resolucion[
  Definimos $A_1 = {0}$ y, para cada $n >= 2$,
  $ A_n = {plus.minus p/q : p, q in NN "coprimos con" p + q = n}. $

  Los primeros bloques son
  $ A_1 = {0}, quad A_2 = {1/1, -1/1}, quad A_3 = {1/2, -1/2, 2/1, -2/1}, \
    A_4 = {1/3, -1/3, 3/1, -3/1}, quad A_5 = {1/4, -1/4, 2/3, -2/3, 3/2, -3/2, 4/1, -4/1}. $

  Notemos que en $A_4$ no aparece $2/2$, porque no está escrito en forma irreducible (ya apareció como $1/1$ en $A_2$).

  Las dos observaciones que hacen funcionar todo son:

  #set enum(numbering: "a)")
  + *Cada $A_n$ es finito.* Hay a lo sumo $n - 1$ pares $(p, q) in NN times NN$ con $p + q = n$, y cada uno aporta a lo sumo dos elementos.
  + *Cada racional aparece en exactamente un bloque.* Escrito en forma irreducible como $plus.minus p\/q$, el número cae en $A_(p+q)$ y en ningún otro: los $A_n$ son disjuntos dos a dos.

  La correspondencia con $NN$ se obtiene listando consecutivamente los elementos de $A_1$, después los de $A_2$, después los de $A_3$, y así siguiendo. Es *sobreyectiva*: por ejemplo $22\/7 in A_29$, y como $A_1 union dots union A_28$ es finito, $22\/7$ aparece en un lugar finito de la lista; el mismo razonamiento vale para cualquier $p\/q$. Es *inyectiva* porque los bloques son disjuntos y dentro de cada bloque no repetimos elementos.
]

#sublema(titulo: "Qué técnica es ésta")[
  Es *unión numerable de conjuntos finitos*, el caso más manso del resultado que se trabaja en `ruta_union_contables.typ`. Vale la pena notar que Abbott no escribe la fórmula de la biyección y aclara que intentarlo no es un buen uso del tiempo: lo que hay que ver es que cada elemento ocupa una posición finita en la lista.

  La misma maniobra resuelve varios ítems de la Práctica 2: en el Ejemplo C2-4 (b) aparece como $(0,1) inter QQ = union.sq_(m in NN) {m\/n : 0 < m < n}$, con cada pedazo finito.
]

#ejemplo[Numerabilidad de $NN times NN$ vía Cantor-Schröeder-Bernstein (Ejemplo 3.12)][14][
  Usemos el Teorema de Cantor-Schröeder-Bernstein para ver que $NN times NN$ es numerable.
]

#resolucion[
  - Sea $f : NN -> NN times NN$ la función $f(n) = (n, 1)$. La función $f$ es inyectiva, lo que nos dice que $\#NN <= \#(NN times NN)$.

  - Sea $g : NN times NN -> NN$ la función $g(n, m) = 2^n 3^m$. La función $g$ es inyectiva (por descomposición única en factores primos), con lo cual $\#(NN times NN) <= \#NN$.
]

#ejemplo[Coordinabilidad de $RR$ con $(0, 1)$ (Ejemplo 3.20)][15][
  Veamos que $RR tilde.op (0, 1)$.
]

#resolucion[
  Para esto, vemos primero que $RR tilde.op (-1, 1)$ vía la función
  $ f : RR -> (-1, 1), quad f(x) = x / (1 + abs(x)), $
  que resulta biyectiva. Esto lo podemos ver, por ejemplo, comprobando que $f^(-1)(x) = x / (1 - abs(x))$.

  Por otro lado, podemos probar también que $(-1, 1) tilde.op (0, 1)$, vía la función
  $ g : (-1, 1) -> (0, 1), quad g(x) = (x + 1) / 2, $
  que también resulta biyectiva.

  Por transitividad de la relación de equivalencia concluimos que $RR tilde.op (0, 1)$.
]

#ejemplo[$RR$ no es numerable, sin usar desarrollos decimales (Abbott, Teorema 1.5.6 (ii))][A1.5.6b][
  Probar que $RR$ no es numerable atrapando al número que falta con una sucesión de intervalos cerrados encajados, en lugar de fabricarlo dígito a dígito.
]

#estrategia[La misma contradicción, pero con intervalos en vez de dígitos][
  La demostración del Teorema 3.19 supone que existe una lista $(x_n)_(n in NN)$ de todos los reales y construye un $y$ que no está en ella, eligiendo cada dígito de $y$ distinto del correspondiente de $x_n$. El precio es que hay que discutir la no unicidad del desarrollo decimal (Observación 3.22, que en `desafios/p2.typ` figura como desafío).

  La versión de Abbott produce el mismo $y$ *sin escribirlo*: en vez de controlar sus dígitos, se lo encierra en una sucesión de intervalos cerrados encajados, cada uno de los cuales deja afuera un término más de la lista. El número que la propiedad de intervalos encajados entrega no puede estar en la lista, y no hubo que representarlo de ninguna manera particular.
]

#resolucion[
  Supongamos que $RR$ es numerable, es decir que podemos escribir
  $ RR = {x_1, x_2, x_3, dots}. $

  Construimos inductivamente intervalos cerrados y acotados $I_1 supset.eq I_2 supset.eq I_3 supset.eq dots$ tales que $x_n in.not I_n$ para todo $n$:

  - Tomamos $I_1$ cualquier intervalo cerrado con $x_1 in.not I_1$ (por ejemplo $I_1 = [x_1 + 1, x_1 + 2]$).
  - Dado $I_n = [a, b]$ con $a < b$, consideramos los dos intervalos cerrados *disjuntos*
    $ [a, a + (b - a)/3] quad "y" quad [b - (b - a)/3, b]. $
    Como son disjuntos, $x_(n+1)$ puede pertenecer a lo sumo a uno de los dos; elegimos como $I_(n+1)$ al otro. Así se cumplen $I_(n+1) subset.eq I_n$ y $x_(n+1) in.not I_(n+1)$.

  Por la propiedad de los intervalos encajados existe $x in inter.big_(n in NN) I_n$. Pero si $x$ estuviera en la lista, sería $x = x_(n_0)$ para algún $n_0 in NN$, y por construcción $x_(n_0) in.not I_(n_0)$, mientras que $x in inter.big_(n in NN) I_n subset.eq I_(n_0)$. Absurdo.

  Por lo tanto $x$ es un número real que no aparece en la lista, lo que contradice que la lista fuera todo $RR$. Concluimos que $RR$ no es numerable.
]

#sublema(titulo: "La propiedad de intervalos encajados no está en el apunte del curso")[
  Abbott la usa como resultado previo (su Teorema 1.4.1), pero en `notas_materia.pdf` no aparece, así que conviene tenerla probada:

  *Enunciado.* Si $I_n = [a_n, b_n]$ son intervalos cerrados y acotados con $I_(n+1) subset.eq I_n$ para todo $n$, entonces $inter.big_(n in NN) I_n != nothing$.

  *Demostración.* Del encaje se sigue que $a_n <= b_m$ para *todo* par $n, m$: si $n <= m$ vale $a_n <= a_m <= b_m$, y si $n > m$ vale $a_n <= b_n <= b_m$. Entonces el conjunto $A = {a_n : n in NN}$ es no vacío y está acotado superiormente (por cualquier $b_m$), así que por el axioma de completitud existe $x = op("sup")(A)$. Como $x$ es cota superior, $a_n <= x$ para todo $n$; y como cada $b_m$ es cota superior de $A$ y $x$ es la menor de ellas, $x <= b_m$ para todo $m$. Luego $x in [a_n, b_n]$ para todo $n$. #h(1fr) $qed$

  Las dos hipótesis se usan: *cerrados* para que el supremo pertenezca al intervalo, y *acotados* para poder tomar supremo. Con $I_n = (0, 1/n)$ la intersección es vacía.
]

#ejemplo[Cinco cálculos de cardinal: $ZZ times ZZ$, $(0,1) inter QQ$, $pi QQ$, $QQ + QQ$ y las sucesiones enteras convergentes (Clase 2 · Ejemplo 4)][C2-4][
  Calcular el cardinal de los siguientes conjuntos:

  #set enum(numbering: "a)")
  + $ZZ times ZZ$.
  + $(0, 1) inter QQ$.
  + ${pi q : q in QQ}$.
  + $QQ + QQ = {a + b : a in QQ, b in QQ}$.
  + ${(a_n)_(n in NN) subset.eq ZZ : (a_n)_(n in NN) "es convergente"}$.
]

#estrategia[Tres recetas que se repiten][
  Los cinco ítems salen con alguna de estas tres, y casi todos admiten más de un camino:

  #set enum(numbering: "1.")
  + *Componer biyecciones conocidas.* Teniendo $ZZ tilde.op NN$ y $NN times NN tilde.op NN$, cualquier construcción armada sobre $ZZ$ se transporta.
  + *Escribir el conjunto como unión contable de contables.* Es la receta más flexible: partirlo en pedazos indexados por algo contable y ver que cada pedazo es contable.
  + *Encajar entre conjuntos conocidos.* Una inyección hacia un contable ya da contable; si además el conjunto es infinito, es numerable.

  El ítem (d) agrega una cuarta, que es la *Proposición 3.9* de `apuntes.typ`: para probar que $A$ es contable alcanza con exhibir una *suryección* desde un conjunto contable.
]

#resolucion[
  *(a) $ZZ times ZZ$ es numerable.* La función

  $ f : ZZ -> NN, quad f(n) = cases(
    2n & "si" n >= 0,
    2(-n) - 1 & "si" n < 0,
  ) $

  es biyectiva. Entonces $F : ZZ times ZZ -> NN times NN$, $F(n, m) = (f(n), f(m))$, también lo es:

  - *inyectiva:* $F(n, m) = F(n', m')$ equivale a $f(n) = f(n')$ y $f(m) = f(m')$; como $f$ es inyectiva, $n = n'$ y $m = m'$;
  - *suryectiva:* dado $(y_1, y_2) in NN times NN$, como $f$ es suryectiva existen $n, m in ZZ$ con $f(n) = y_1$ y $f(m) = y_2$, y entonces $F(n, m) = (y_1, y_2)$.

  Finalmente, $NN times NN -> NN$ dada por $(n, m) |-> 2^n (2m - 1)$ es biyectiva, porque todo natural se escribe de forma única como una potencia de $2$ por un impar (Teorema Fundamental de la Aritmética). Componiendo, $ZZ times ZZ tilde.op NN$, luego $ZZ times ZZ$ es numerable.

  _Otra resolución:_ podemos escribir $ZZ times ZZ = union.sq_(n in ZZ) A_n$ con $A_n = {n} times ZZ$. Como $A_n tilde.op ZZ$ para cada $n$, resulta que $ZZ times ZZ$ es unión contable de numerables y por lo tanto es numerable.

  *(b) $(0, 1) inter QQ$ es numerable.*

  _Paso 1: $QQ_(>0)$ es numerable._ La función $QQ_(>0) -> NN times NN$ que a $x = a/b$ con $(a, b) = 1$ le asigna $(a, b)$ es inyectiva (cada racional positivo tiene una única representación como fracción irreducible), y $NN times NN$ es numerable por la parte (a). Así que $QQ_(>0)$ es coordinable con un subconjunto de un numerable, es decir, es contable; siendo infinito, es numerable.

  _Paso 2: biyección auxiliar $(0, +oo) -> (0, 1)$._ Consideramos $f : (0, +oo) -> (0, 1)$, $f(x) = x/(x+1)$.

  - *bien definida:* $0 < x < x + 1$, con lo cual $0 < x/(x+1) < 1$;
  - *inyectiva:* $x/(x+1) = y/(y+1) <=> x(y+1) = (x+1)y <=> x y + x = x y + y <=> x = y$;
  - *suryectiva:* dado $y in (0, 1)$, de $x/(x+1) = y$ se despeja $x - y x = y$, o sea $x = y/(1-y) > 0$.

  Luego $f$ es biyectiva, con inversa $f^(-1)(y) = y/(1-y)$.

  _Paso 3: restricción de $f$ a $QQ_(>0)$._ Idea general a recordar: *si $f : A -> B$ es biyección y $A_0 subset.eq A$ es tal que $f(A_0) = B_0$ exactamente, entonces $f|_(A_0) : A_0 -> B_0$ también es biyección.*

  Acá se aplica con $A_0 = QQ_(>0)$ y $B_0 = (0, 1) inter QQ$. Hay que verificar que $f(QQ_(>0)) = (0, 1) inter QQ$:

  - si $x in QQ_(>0)$, entonces $f(x) = x/(x+1)$ es cociente de racionales, y ya sabemos que $f(x) in (0, 1)$; luego $f(x) in (0, 1) inter QQ$;
  - si $y in (0, 1) inter QQ$, entonces $x = f^(-1)(y) = y/(1-y)$ es cociente de racionales, y como $y in (0, 1)$ sabemos que $x in (0, +oo)$; luego $x in QQ_(>0)$ y $f(x) = y$.

  Por lo tanto $f$ manda $QQ_(>0)$ biyectivamente sobre $(0, 1) inter QQ$, es decir,
  $ QQ_(>0) tilde.op (0, 1) inter QQ. $

  Como $QQ_(>0)$ es numerable (Paso 1) y la numerabilidad se preserva por biyecciones, $(0, 1) inter QQ$ es numerable.

  _Otras formas:_ la inclusión $(0,1) inter QQ arrow.hook QQ$ es inyectiva, así que el conjunto es contable; como contiene a ${1/n : n in NN, n >= 2}$, es infinito, y por lo tanto numerable. También sirve escribirlo como $union.sq_(m in NN) A_m$ con $A_m = {m/n : 0 < m < n}$, que es unión contable de conjuntos finitos.

  *(c) ${pi q : q in QQ}$ es numerable.* La función $QQ -> {pi q : q in QQ}$, $q |-> pi q$, es biyectiva.

  *(d) $QQ + QQ$ es numerable.* Como $QQ + QQ subset.eq QQ$, es contable; y como es infinito, es numerable.

  _Otra forma, con suryecciones:_ la función $QQ times QQ -> QQ + QQ$, $(a, b) |-> a + b$, es suryectiva ($a$ es la imagen de $(a, 0)$). Alcanza entonces con el siguiente lema, que es la Proposición 3.9 de `apuntes.typ` leída en el caso contable.

  #sublema(titulo: "Lema: una suryección desde un contable alcanza")[
    Si $f : NN -> A$ es suryectiva, entonces $A$ es contable.

    _Demostración:_ dado $a in A$ existe $n_a in NN$ con $f(n_a) = a$; definimos $tilde(f) : A -> NN$, $a |-> n_a$, que es inyectiva.

    _Nota:_ acá el "elegir" $n_a$ se puede hacer sin axioma de elección tomando $n_a = op("mín"){n in NN : f(n) = a}$, por el principio de buena ordenación. En general, si $f : B -> A$ es suryectiva existe $tilde(f) : A -> B$ inyectiva, pero elegir una preimagen para cada $a$ sí requiere el axioma de elección.
  ]

  Como $QQ tilde.op NN$, componiendo obtenemos una suryección $NN -> QQ + QQ$, y por el lema $QQ + QQ$ es contable.

  _Una manera más:_ $QQ + QQ = union.sq_(a in QQ) (a + QQ)$, y $a + QQ tilde.op QQ$ vía $q |-> a + q$. Es unión contable de contables.

  *(e) ${(a_n)_n subset.eq ZZ : (a_n)_n "es convergente"}$ es numerable.* Por el Ejemplo C1-3, una sucesión convergente de enteros es finalmente constante: existe $n_0 in NN$ tal que $a_n = a_(n_0)$ para todo $n >= n_0$. Entonces

  $ {(a_n)_n subset.eq ZZ : (a_n)_n "converge"} = union.sq_((a, k) in ZZ times NN) A_(a,k), \
    "donde" quad A_(a,k) = {(a_n)_n subset.eq ZZ : a_n = a "para todo" n >= k}. $

  Cada $A_(a,k)$ es contable, porque la función $A_(a,k) -> ZZ^(k-1)$, $(a_n)_n |-> (a_1, a_2, dots, a_(k-1))$, es biyectiva y $ZZ^(k-1)$ es numerable. Como $ZZ times NN$ es contable, el conjunto es unión contable de contables y por lo tanto contable; siendo infinito, es numerable.
]

#sublema(titulo: "Sobre la observación del manuscrito en (a)")[
  Después del ítem (a) el manuscrito anota una observación sobre particiones de $NN$: dado $N in NN$ vale $NN = union.sq_(i=1)^N B_i$ con $B_i = {k N + i : k in NN_0}$ y $1 <= i <= N$, y también hay particiones infinitas, por ejemplo indexadas por primos,

  $ B_2 = {n in NN : 2 divides n}, quad B_3 = {n in NN : 2 divides.not n "y" 3 divides n}, \
    B_p = {n in NN : q divides.not n "para todo primo" q < p "pero" p divides n}. $

  El paso final del manuscrito, que quería armar la biyección $ZZ times ZZ = union.sq_m A_m -> union.sq_(p in P) B_p = NN$, queda incompleto en el original (aparece una familia $h_(g(m))$ que nunca se define), así que no se transcribe: para (a) ya alcanza con cualquiera de las dos resoluciones de arriba.
]

#ejemplo[Un conjunto de reales positivos con todas sus sumas finitas acotadas es contable (Abbott, Ejercicio 1.5.8)][A1.5.8][
  Sea $B$ un conjunto de números reales positivos tal que la suma de los elementos de cualquier subconjunto finito de $B$ es siempre menor o igual a $2$. Probar que $B$ es finito o numerable.
]

#estrategia[Partir por tamaño][
  No hay ninguna biyección a la vista ni ninguna estructura que copiar: lo único que se sabe de $B$ es una cota sobre sus sumas finitas. La idea es que *no puede haber muchos elementos grandes*, porque unos pocos ya se comerían el presupuesto de $2$.

  Eso sugiere cortar $B$ en capas según el tamaño: $B_n = {x in B : x > 1/n}$. Cada capa tiene que ser finita por la cota, y las capas cubren todo $B$ porque ningún elemento de $B$ es $0$ y vale el Principio de Arquímedes. De nuevo, unión numerable de finitos.
]

#resolucion[
  Para cada $n in NN$ definimos
  $ B_n = {x in B : x > 1/n}. $

  *Cada $B_n$ es finito.* Supongamos que $B_n$ tuviera al menos $2n + 1$ elementos y tomemos $2n + 1$ de ellos, digamos $x_1, dots, x_(2n+1)$. Como cada uno es mayor que $1\/n$,
  $ sum_(i=1)^(2n+1) x_i > (2n+1) · 1/n = 2 + 1/n > 2, $
  y encontramos un subconjunto finito de $B$ cuya suma supera $2$, contra la hipótesis. Luego $B_n$ tiene a lo sumo $2n$ elementos.

  *Las capas cubren $B$.* Sea $x in B$. Como $x > 0$, por el Principio de Arquímedes (Proposición 1 de `apuntes.typ`) existe $n in NN$ con $1\/n < x$, es decir $x in B_n$. Por lo tanto
  $ B = union.big_(n in NN) B_n. $

  Así, $B$ es una unión numerable de conjuntos finitos y en consecuencia es contable: finito o numerable.
]

#sublema(titulo: "La misma forma en la Práctica 2")[
  El Ejercicio 12 (a) de la Práctica 2 --- una familia de intervalos disjuntos dos a dos, cada uno con más de un punto, tiene que estar indexada por un conjunto contable --- tiene exactamente esta estructura: no hay biyección para construir, hay que *cortar en capas contables* y usar que un conjunto no puede tener demasiados elementos "grandes" (allá, intervalos que contienen un racional distinto cada uno). El Ejemplo C3-4 es la versión con entornos.
]

#ejemplo[Los números algebraicos son numerables (Abbott, Ejercicio 1.5.9)][A1.5.9][
  Un número $x in RR$ se dice *algebraico* si existen enteros $a_0, a_1, dots, a_n in ZZ$, no todos nulos, tales que
  $ a_n x^n + a_(n-1) x^(n-1) + dots + a_1 x + a_0 = 0, $
  es decir, si es raíz de un polinomio no nulo con coeficientes enteros. Los reales que no son algebraicos se llaman *trascendentes*.

  #set enum(numbering: "a)")
  + Probar que $sqrt(2)$, $root(3, 2)$ y $sqrt(2) + sqrt(3)$ son algebraicos.
  + Fijado $n in NN$, sea $A_n$ el conjunto de los números algebraicos que son raíces de polinomios de grado $n$ con coeficientes enteros. Probar que $A_n$ es contable.
  + Concluir que el conjunto de todos los números algebraicos es numerable. ¿Qué se deduce sobre los trascendentes?
]

#estrategia[Dos uniones encadenadas][
  Es el ejemplo que junta todas las herramientas del bloque, y conviene ver el esqueleto antes de las cuentas:

  #set enum(numbering: "1.")
  + Un polinomio de grado $n$ *es* su lista de coeficientes: los polinomios de grado $n$ con coeficientes enteros se identifican con un subconjunto de $ZZ^(n+1)$, que es numerable por ser producto finito de numerables.
  + Cada polinomio no nulo aporta *finitas* raíces (a lo sumo $n$).
  + Entonces $A_n$ es una unión, indexada por un numerable, de conjuntos finitos.
  + Y el conjunto de todos los algebraicos es $union.big_(n in NN) A_n$: otra vez unión numerable, ahora de contables.
]

#resolucion[
  *(a)* $sqrt(2)$ es raíz de $x^2 - 2$ y $root(3, 2)$ es raíz de $x^3 - 2$. Para $x = sqrt(2) + sqrt(3)$ elevamos al cuadrado dos veces:
  $ x^2 = 5 + 2 sqrt(6) quad ==> quad x^2 - 5 = 2 sqrt(6) quad ==> quad (x^2 - 5)^2 = 24, $
  de donde $x^4 - 10 x^2 + 25 = 24$, es decir que $sqrt(2) + sqrt(3)$ es raíz de $x^4 - 10 x^2 + 1$.

  *(b)* Llamemos $P_n$ al conjunto de los polinomios de grado $n$ con coeficientes enteros. La función que a $p(x) = a_n x^n + dots + a_0$ le asigna la tupla $(a_0, a_1, dots, a_n)$ es inyectiva de $P_n$ en $ZZ^(n+1)$, y $ZZ^(n+1)$ es numerable (producto finito de conjuntos numerables, iterando el Ejemplo 3.12). Por la Proposición 3.13, $P_n$ es contable.

  Para cada $p in P_n$, el conjunto $R_p$ de sus raíces reales es finito: tiene a lo sumo $n$ elementos, porque $p$ no es el polinomio nulo. Entonces
  $ A_n = union.big_(p in P_n) R_p $
  es una unión indexada por un conjunto contable de conjuntos finitos, y por lo tanto $A_n$ es contable.

  *(c)* El conjunto de todos los números algebraicos es
  $ A = union.big_(n in NN) A_n, $
  unión numerable de contables, así que $A$ es contable. Además $A$ es infinito, porque contiene a $QQ$: todo racional $p\/q$ es raíz de $q x - p$. Luego $A$ es numerable.

  Sea $T = RR backslash A$ el conjunto de los trascendentes. Si $T$ fuera contable, entonces $RR = A union T$ sería unión de dos contables y por lo tanto contable, contradiciendo el Teorema 3.19. Concluimos que $T$ no es contable: *existen números trascendentes* y, de hecho, son "casi todos" los reales.
]

#sublema(titulo: "Por qué este ejemplo vale la pena")[
  Es el mismo movimiento que el cardinal de los irracionales (Ejercicio 4 de la Práctica 2), pero con un conjunto que no se puede describir de manera explícita: la existencia de números trascendentes se demuestra *contando*, sin exhibir ninguno. Exhibir uno concreto ($e$, $pi$) es muchísimo más difícil que probar que hay una cantidad no numerable.

  Para la Práctica 2 la parte reutilizable es la identificación *polinomio $<-->$ tupla de coeficientes*, que es la que resuelve el Ejercicio 13 (cardinal de $RR[X]$): con coeficientes reales en lugar de enteros, la misma identificación da $RR[X] tilde.op union.big_(n in NN) RR^(n+1)$.
]

#ejemplo[Transportar funciones: si $A tilde.op X$ y $B tilde.op Y$ entonces $B^A tilde.op Y^X$][Prop][
  Sean $A, B, X, Y$ conjuntos no vacíos, y notemos $B^A = {h : h "es una función" A -> B}$ al conjunto de todas las funciones de $A$ en $B$.

  Probar que si $A tilde.op X$ y $B tilde.op Y$, entonces $B^A tilde.op Y^X$.
]

#estrategia[Entrar y salir con las biyecciones que ya tenemos][
  Un elemento de $B^A$ es una función $h : A -> B$, y lo que queremos es fabricar con ella una función $X -> Y$. Las biyecciones $f : A -> X$ y $g : B -> Y$ son justamente los adaptadores que faltan: entramos por $f^(-1)$, atravesamos con $h$ y salimos por $g$,

  $ X ->^(f^(-1)) A ->^(h) B ->^(g) Y, $

  o sea $phi(h) = g compose h compose f^(-1)$. Recorriendo el camino al revés aparece sola la candidata a inversa, $psi(k) = g^(-1) compose k compose f$.

  Para probar que $phi$ es biyectiva conviene exhibir su inversa antes que verificar inyectividad y sobreyectividad por separado. *Pero ojo:* exhibir una inversa obliga a chequear las *dos* composiciones, $psi compose phi = op("id")_(B^A)$ y $phi compose psi = op("id")_(Y^X)$. Con una sola alcanza para la inyectividad de $phi$, no para su biyectividad.
]

#resolucion[
  Como $A tilde.op X$ y $B tilde.op Y$, existen biyecciones $f : A -> X$ y $g : B -> Y$; por ser biyectivas, existen también sus inversas $f^(-1) : X -> A$ y $g^(-1) : Y -> B$.

  *Las candidatas.* Definimos

  $ phi : B^A -> Y^X, quad phi(h) = g compose h compose f^(-1), $
  $ psi : Y^X -> B^A, quad psi(k) = g^(-1) compose k compose f. $

  Las dos están bien definidas: si $h : A -> B$, la composición $g compose h compose f^(-1)$ recorre $X -> A -> B -> Y$ y por lo tanto es una función de $X$ en $Y$, es decir $phi(h) in Y^X$. Simétricamente, si $k : X -> Y$, entonces $g^(-1) compose k compose f$ recorre $A -> X -> Y -> B$ y $psi(k) in B^A$.

  *Primera composición: $psi compose phi = op("id")_(B^A)$.* Sea $h in B^A$. Usando la asociatividad de la composición para reagrupar,

  $ psi(phi(h)) &= psi(g compose h compose f^(-1)) \
    &= g^(-1) compose (g compose h compose f^(-1)) compose f \
    &= (g^(-1) compose g) compose h compose (f^(-1) compose f) \
    &= op("id")_B compose h compose op("id")_A \
    &= h. $

  Como esto vale para todo $h in B^A$, tenemos $psi compose phi = op("id")_(B^A)$.

  *Segunda composición: $phi compose psi = op("id")_(Y^X)$.* Sea $k in Y^X$. De la misma manera,

  $ phi(psi(k)) &= phi(g^(-1) compose k compose f) \
    &= g compose (g^(-1) compose k compose f) compose f^(-1) \
    &= (g compose g^(-1)) compose k compose (f compose f^(-1)) \
    &= op("id")_Y compose k compose op("id")_X \
    &= k, $

  y por lo tanto $phi compose psi = op("id")_(Y^X)$.

  Esta segunda cuenta *no* es la primera escrita al revés: acá las identidades que se arman son $g compose g^(-1) = op("id")_Y$ y $f compose f^(-1) = op("id")_X$, mientras que en la primera eran $g^(-1) compose g = op("id")_B$ y $f^(-1) compose f = op("id")_A$. Son composiciones distintas, y por eso hace falta hacer las dos: una sola de ellas prueba que $phi$ es inyectiva, pero no que sea sobreyectiva.

  Habiendo verificado ambas, $psi = phi^(-1)$ y $phi : B^A -> Y^X$ resulta biyectiva. Es decir, $B^A tilde.op Y^X$.
]

#sublema(titulo: "Dónde se usa")[
  Encadenado con el *Ejercicio 8 (a)* de la Práctica 2 ($cal(P)(A) tilde.op {0, 1}^A$), este ejemplo da el *Ejercicio 9 (c)* casi gratis. Si $A tilde.op B$, entonces

  $ cal(P)(A) tilde.op {0, 1}^A tilde.op {0, 1}^B tilde.op cal(P)(B), $

  donde el paso del medio es exactamente este resultado, aplicado con la biyección dada $A -> B$ y con $op("id")_({0, 1})$ del otro lado.
]

#ejemplo[Pegar funciones sobre dominios disjuntos: $C^A times C^B tilde.op C^(A union B)$][Prop][
  Sean $A, B, C$ conjuntos no vacíos tales que $A inter B = nothing$. Probar que
  $ C^A times C^B tilde.op C^(A union B). $
]

#estrategia[Un par de funciones es lo mismo que una función partida en dos][
  Darse una función $h : A union B -> C$, cuando $A$ y $B$ son disjuntos, es exactamente lo mismo que decir por separado qué hace sobre $A$ y qué hace sobre $B$. Esa frase *es* la biyección: en un sentido *pegamos* el par $(f, g)$ en una sola función, y en el otro *restringimos* $h$ a cada pedazo.

  El punto delicado no es ninguna de las dos verificaciones, sino que el pegado sea realmente una función: si hubiera algún $x in A inter B$ con $f(x) != g(x)$, la fórmula le asignaría dos valores distintos a un mismo punto. *Ahí, y sólo ahí, se usa la hipótesis $A inter B = nothing$*: ni la inyectividad ni la sobreyectividad la necesitan.
]

#resolucion[Vía inyectividad y sobreyectividad][
  Un elemento de $C^A times C^B$ es un par $(f, g)$ con $f : A -> C$ y $g : B -> C$. Dado un par así, definimos $phi_(f,g) : A union B -> C$ por

  $ phi_(f,g)(x) = cases(
    f(x) & "si" x in A,
    g(x) & "si" x in B,
  ) $

  y con eso definimos $phi : C^A times C^B -> C^(A union B)$ como $phi(f, g) = phi_(f,g)$.

  *$phi$ está bien definida.* Sea $x in A union B$. Por definición de unión, $x in A$ o $x in B$, así que los dos casos cubren todo el dominio. Y como $A inter B = nothing$, no puede pasar que $x$ esté en los dos a la vez: los casos son excluyentes. Por lo tanto a cada $x in A union B$ le corresponde un único valor, $phi_(f,g)$ es una función de $A union B$ en $C$ y $phi(f, g) in C^(A union B)$. Notemos que *éste es el único lugar del ejercicio donde se usa la hipótesis de disjunción*.

  *$phi$ es inyectiva.* Sean $(f, g)$ y $(tilde(f), tilde(g))$ en $C^A times C^B$ tales que $phi(f, g) = phi(tilde(f), tilde(g))$. Que dos funciones sean iguales significa que coinciden en cada punto del dominio, es decir

  $ phi_(f,g)(x) = phi_(tilde(f), tilde(g))(x) quad "para todo" x in A union B. $

  Tomemos primero $x in A$. Por la definición de ambas funciones, $f(x) = phi_(f,g)(x) = phi_(tilde(f), tilde(g))(x) = tilde(f)(x)$. Como esto vale para *todo* $x in A$, y $f$ y $tilde(f)$ tienen el mismo dominio y el mismo codominio, resulta $f = tilde(f)$. Tomando ahora $x in B$ se obtiene de la misma forma $g = tilde(g)$. Luego $(f, g) = (tilde(f), tilde(g))$ y $phi$ es inyectiva.

  *$phi$ es sobreyectiva.* Sea $h in C^(A union B)$, es decir, $h : A union B -> C$. Como $A subset.eq A union B$ y $B subset.eq A union B$, podemos restringir $h$ a cada pedazo y definir

  $ f = h|_A : A -> C, quad g = h|_B : B -> C, $

  o sea $f(x) = h(x)$ para todo $x in A$ y $g(x) = h(x)$ para todo $x in B$. Estas dos funciones existen sin necesidad de ninguna hipótesis: restringir una función a un subconjunto de su dominio siempre da una función. Tenemos entonces $(f, g) in C^A times C^B$.

  Falta ver que ese par es efectivamente una preimagen de $h$, o sea que $phi(f, g) = h$. Las dos son funciones de $A union B$ en $C$, así que alcanza con compararlas punto a punto. Sea $x in A union B$:

  - si $x in A$, entonces $phi_(f,g)(x) = f(x) = h(x)$;
  - si $x in B$, entonces $phi_(f,g)(x) = g(x) = h(x)$.

  En cualquier caso $phi_(f,g)(x) = h(x)$, con lo cual $phi(f, g) = h$ y $phi$ es sobreyectiva.

  Siendo $phi$ inyectiva y sobreyectiva, es biyectiva, y por lo tanto $C^A times C^B tilde.op C^(A union B)$.
]

#resolucion[Alternativa: construyendo $phi^(-1)$ explícitamente][
  El argumento de sobreyectividad de arriba, en el fondo, ya construye la inversa: dado $h$, el par que se exhibe es siempre el mismo, $(h|_A, h|_B)$. Vale la pena escribirlo directamente, con el mismo esquema del ejemplo anterior ($B^A tilde.op Y^X$): exhibir la candidata y verificar las *dos* composiciones.

  Definimos

  $ psi : C^(A union B) -> C^A times C^B, quad psi(h) = (h|_A, h|_B). $

  *$psi$ está bien definida* (y sin usar ninguna hipótesis sobre $A$ y $B$): las restricciones de $h$ a los subconjuntos $A$ y $B$ de su dominio son funciones $A -> C$ y $B -> C$, así que $psi(h) in C^A times C^B$.

  *$psi compose phi = op("id")_(C^A times C^B)$.* Sea $(f, g) in C^A times C^B$ y llamemos $h = phi(f, g) = phi_(f,g)$. Por la definición de $phi_(f,g)$ tenemos $h(x) = f(x)$ para todo $x in A$, es decir $h|_A = f$; y $h(x) = g(x)$ para todo $x in B$, es decir $h|_B = g$. Entonces

  $ psi(phi(f, g)) = psi(h) = (h|_A, h|_B) = (f, g). $

  *$phi compose psi = op("id")_(C^(A union B))$.* Sea $h in C^(A union B)$ y llamemos $f = h|_A$ y $g = h|_B$, de modo que $psi(h) = (f, g)$. Las funciones $phi(f, g)$ y $h$ van ambas de $A union B$ en $C$, así que las comparamos punto a punto: si $x in A$ entonces $phi_(f,g)(x) = f(x) = h(x)$, y si $x in B$ entonces $phi_(f,g)(x) = g(x) = h(x)$. Como $A union B$ no tiene otros elementos,

  $ phi(psi(h)) = phi(f, g) = h. $

  Verificadas las dos composiciones, $phi$ es biyectiva con $phi^(-1) = psi$.

  Observemos que la hipótesis $A inter B = nothing$ no reaparece en ningún paso de esta segunda resolución: se gastó entera en que $phi$ estuviera bien definida. La construcción de $psi$ y las dos verificaciones valen para $A$ y $B$ cualesquiera --- lo que falla sin disjunción es el punto de partida.
]

#ejemplo[Ley exponencial y el cardinal de $NN^NN$ y sus subconjuntos (Clase 3 · Ejercicio 2)][C3-2][
  Hallar el cardinal de:

  #set enum(numbering: "a)")
  + $NN^NN$.
  + $A = {(a_n)_n in NN^NN : a_n != a_m "si" n != m}$ (las sucesiones inyectivas).
  + $A = {(a_n)_n in NN^NN : a_n divides a_(n+1) "para todo" n in NN}$.
]

#estrategia[Contar con exponentes, y después justificar][
  Si tratamos a los cardinales como si fueran números, el ítem (a) se "adivina" en una línea:

  $ \#NN^NN = aleph_0^(aleph_0) <= (2^(aleph_0))^(aleph_0) = 2^(aleph_0 times aleph_0) = 2^(aleph_0). $

  Esto *no es un argumento formal*, pero dice exactamente qué hay que probar: el paso $(2^(aleph_0))^(aleph_0) = 2^(aleph_0 times aleph_0)$ es la *ley exponencial* $(A^B)^C tilde.op A^(B times C)$, y el resto son coordinabilidades que ya conocemos. Los ítems (b) y (c) son subconjuntos de $NN^NN$: para ellos la inyección hacia $RR$ sale gratis de (a), y lo que hay que construir es la inyección de vuelta.
]

#sublema(titulo: "Lema auxiliar: la ley exponencial")[
  Para conjuntos $A$, $B$, $C$ cualesquiera vale $(A^B)^C tilde.op A^(B times C)$.

  Un elemento de $(A^B)^C$ es una función $f : C -> A^B$, y uno de $A^(B times C)$ es una función $g : B times C -> A$. Definimos

  $ Phi : (A^B)^C -> A^(B times C), quad Phi(f)(b, c) := (f(c))(b), $

  donde usamos que $f(c) in A^B$, o sea que $f(c)$ es a su vez una función. Definimos también

  $ Psi : A^(B times C) -> (A^B)^C, quad [Psi(g)(c)](b) := g(b, c). $

  Las dos están bien definidas, y

  $ Phi(Psi(g))(b, c) &= [Psi(g)(c)](b) = g(b, c), quad & "es decir" Phi compose Psi = op("id")_(A^(B times C)), \
    [Psi(Phi(f))(c)](b) &= Phi(f)(b, c) = (f(c))(b), quad & "es decir" Psi compose Phi = op("id")_((A^B)^C). $

  Concluimos que $(A^B)^C tilde.op A^(B times C)$. Es el mismo esquema de los dos ejemplos anteriores: exhibir la inversa y verificar las dos composiciones.
]

#resolucion[
  *(a) $NN^NN tilde.op RR$.* Una inyección en un sentido es fácil: $f : {0,1}^NN -> NN^NN$, $f((a_n)_n) = (a_n)_n$, es inyectiva, y como ${0,1}^NN tilde.op RR$, tenemos $RR -> NN^NN$ inyectiva.

  Para la otra, la inclusión da una inyección $NN^NN -> RR^NN$, y ahora encadenamos:

  $ RR^NN tilde.op ({0,1}^NN)^NN tilde.op {0,1}^(NN times NN) tilde.op cal(P)(NN times NN) tilde.op cal(P)(NN), $

  donde el primer paso usa $RR tilde.op {0,1}^NN$, el segundo es la *ley exponencial*, el tercero es el Ejercicio 8 (a) de la Práctica 2 y el último usa $NN times NN tilde.op NN$ (Ejemplo 14). Como $cal(P)(NN) tilde.op RR$, resulta $RR^NN tilde.op RR$ y por lo tanto existe $p : NN^NN -> RR$ inyectiva. Por el Teorema de Cantor-Schröeder-Bernstein, $NN^NN tilde.op RR$.

  *(b) Las sucesiones inyectivas.* Por (a) tenemos $f : A -> RR$ inyectiva. Para la vuelta construimos

  $ g : {B subset.eq NN : \#B = aleph_0} -> A $

  que a cada subconjunto infinito de $NN$ le asigna su *enumeración creciente*, definida inductivamente:

  $ g(B)_1 := op("mín")(B), quad g(B)_(k+1) := op("mín")(B without {g(B)_i : i <= k}), $

  todos bien definidos por el principio de buena ordenación y porque $B$, al ser infinito, nunca se agota. Por construcción $g(B)_1 < g(B)_2 < dots$, así que $g(B)$ es una sucesión inyectiva y $g$ está bien definida.

  $g$ es inyectiva: si $B != tilde(B)$, sea $m$ el mínimo elemento en el que difieren, digamos $m in B without tilde(B)$. Como $B$ y $tilde(B)$ coinciden por debajo de $m$, sus enumeraciones crecientes coinciden en los primeros $j$ lugares, donde $j = \#{x in B : x < m}$, y en el lugar $j + 1$ vale $g(B)_(j+1) = m$ mientras que $g(tilde(B))_(j+1) > m$. Luego $g(B) != g(tilde(B))$.

  Falta ver que ${B subset.eq NN : \#B = aleph_0} tilde.op RR$. Por el Ejercicio 11 de la Práctica 2, ${B subset.eq NN : B "finito"}$ es numerable; como

  $ cal(P)(NN) = {B subset.eq NN : B "finito"} union.sq {B subset.eq NN : \#B = aleph_0} $

  y $cal(P)(NN) tilde.op RR$, por el Ejercicio 3 (a) de la Práctica 2 el segundo pedazo tiene cardinal $frak(c)$. Existe entonces $g : RR -> A$ inyectiva y, por Cantor-Schröeder-Bernstein, $A tilde.op RR$.

  *(c) Las cadenas de divisibilidad.* Por (a), existe $f : A -> RR$ inyectiva. Para la vuelta, notemos que si $a_n divides a_(n+1)$ entonces $a_(n+1) = k_n a_n$ para algún $k_n in NN$, y por lo tanto la sucesión queda determinada por $a_1$ y por $(k_n)_n$:

  $ a_1, quad a_2 = k_1 a_1, quad a_3 = k_2 k_1 a_1, quad dots, quad a_(n+1) = k_n dots.h.c k_1 a_1. $

  Definimos entonces $g : NN times NN^NN -> A$ por

  $ (g(a, (k_n)_n))_m := a dot product_(i=1)^(m-1) k_i, quad "con la convención" product_(i=1)^0 k_i = 1. $

  Está bien definida, porque $a_(m+1) = a product_(i=1)^m k_i = (a product_(i=1)^(m-1) k_i) k_m = a_m k_m$, o sea $a_m divides a_(m+1)$.

  Es inyectiva: si $(a_m)_m = g(a, (k_n)_n)$ y $(b_m)_m = g(tilde(a), (tilde(k)_n)_n)$ cumplen $a_m = b_m$ para todo $m$, entonces $a = a_1 = b_1 = tilde(a)$; y dado $n in NN$, de $a_n k_n = a_(n+1) = b_(n+1) = b_n tilde(k)_n$ con $a_n = b_n != 0$ se concluye $k_n = tilde(k)_n$.

  Por último, $NN times NN^NN tilde.op NN times RR$ por (a), y $NN times RR tilde.op RR$: en efecto, $NN times RR = union.sq_(m in NN) {m} times RR$ con ${m} times RR tilde.op RR$, o sea que es unión contable de conjuntos de cardinal $frak(c)$ y por lo tanto tiene cardinal $frak(c)$ (Ejercicio 7 (b) de la Práctica 2). Existe entonces $g : RR -> A$ inyectiva y, por Cantor-Schröeder-Bernstein, $A tilde.op RR$.

  _Observación:_ la función $g : NN times NN^NN -> A$ del ítem (c) es, de hecho, biyectiva.
]

#sublema(titulo: "Corrección al manuscrito en (b)")[
  El original prueba la inyectividad de $g$ así: "supongamos $B != tilde(B)$; sea $k = op("mín"){k in NN : k in B without tilde(B)}$; por definición $g(B)_k != g(tilde(B))_k$".

  El paso usa a $k$ a la vez como *elemento* de $B$ y como *índice* de la sucesión, y eso no cierra: el elemento $m$ donde los conjuntos empiezan a diferir no tiene por qué ocupar el lugar $m$ de la enumeración. La conclusión igual vale, y arreglarlo es contar cuántos elementos de $B$ hay por debajo de $m$ para saber en qué lugar aparece; es la versión que se transcribió arriba.
]

#ejemplo[Cardinal de un subconjunto de $RR^3$ definido por condiciones (Clase 3 · Ejercicio 1)][C3-1][
  Hallar el cardinal de
  $ X = {(x, y, z) in RR^3 : x in QQ, med y in RR without QQ, med z in NN "es par"}. $
]

#estrategia[Sándwich: una inyección para cada lado][
  Cuando el conjunto está "encajado" entre dos conjuntos de cardinal conocido, no hace falta construir ninguna biyección: se exhibe una inyección en cada sentido y se invoca Cantor-Schröeder-Bernstein. Para la inyección que sale de $X$ alcanza con la inclusión en $RR^3$; para la que entra, basta con encontrar *una sola* copia grande adentro de $X$, fijando todas las coordenadas menos una.
]

#resolucion[
  Como $X subset.eq RR^3$, la inclusión da una función inyectiva $X -> RR^3$. Y como $RR^3 tilde.op RR$ (Ejercicio 14 (c) de la Práctica 2), componiendo obtenemos $f : X -> RR$ inyectiva, es decir $\#X <= \#RR$.

  Por otro lado, la función

  $ g : RR without QQ -> X, quad g(y) = (0, y, 2) $

  es inyectiva (si $g(y) = g(y')$, comparando la segunda coordenada, $y = y'$), y está bien definida porque $0 in QQ$, $y in RR without QQ$ y $2 in NN$ es par. Como $RR tilde.op RR without QQ$ (el cardinal de los irracionales es $frak(c)$, Ejercicio 4 de la Práctica 2), componiendo obtenemos $g : RR -> X$ inyectiva, o sea $\#RR <= \#X$.

  Por el Teorema de Cantor-Schröeder-Bernstein existe $F : X -> RR$ biyectiva, y concluimos que $\#X = \#RR = frak(c)$.
]

#ejemplo[Cardinal de las sucesiones enteras que se mueven de a un paso (Clase 3 · Ejercicio 3)][C3-3][
  Hallar el cardinal de
  $ A = {(a_n)_n subset.eq ZZ : abs(a_(n+1) - a_n) = 1 "para todo" n in NN}. $
]

#estrategia[Cuando en cada paso hay dos opciones, aparece ${0,1}^NN$][
  Si $a_1 = 1$, entonces $a_2 in {0, 2}$; para cada uno de esos hay de nuevo dos posibilidades, y así siguiendo. El esquema es un árbol binario:

  #align(center)[
    $ a_1 = 1 -> cases(
      a_2 = 2 -> cases(a_3 = 3 -> dots.v, a_3 = 1 -> dots.v),
      a_2 = 0 -> cases(a_3 = 1 -> dots.v, a_3 = -1 -> dots.v),
    ) $
  ]

  En cada paso hay exactamente *dos posibilidades*, $a_(n+1) = a_n + 1$ o $a_(n+1) = a_n - 1$. Elegir un elemento de $A$ con $a_1$ fijo es entonces lo mismo que elegir una sucesión de decisiones binarias: eso es lo que sugiere codificar con ${0,1}^NN$.
]

#resolucion[
  Definimos $f : {0,1}^NN -> A$ mandando $(b_k)_k$ a la sucesión $a_n := f((b_k)_k)_n$ dada por

  $ cases(
    a_1 = 1,
    a_(n+1) = a_n + 1 & "si" b_n = 1,
    a_(n+1) = a_n - 1 & "si" b_n = 0,
  ) $

  o, de manera más compacta, $a_1 = 1$ y $a_(n+1) = a_n + (-1)^(b_n + 1)$ para todo $n in NN$.

  Por ejemplo, si $b_1 = 1, b_2 = 0, b_3 = 0, b_4 = 1, b_5 = 0, b_6 = 0, b_7 = 1, dots$, queda

  $ a_1 = 1, med a_2 = 2, med a_3 = 1, med a_4 = 0, med a_5 = 1, med a_6 = 0, med a_7 = -1, med a_8 = 0, dots $

  - *$f$ está bien definida:* $abs(a_(n+1) - a_n) = abs((-1)^(b_n + 1)) = 1$, así que $f((b_k)_k) in A$.
  - *$f$ es inyectiva:* sean $a_n := f((b_k)_k)_n$ y $tilde(a)_n := f((c_k)_k)_n$ con $a_n = tilde(a)_n$ para todo $n in NN$. Entonces
    $ a_n + (-1)^(b_n + 1) = a_(n+1) = tilde(a)_(n+1) = tilde(a)_n + (-1)^(c_n + 1) quad "para todo" n in NN, $
    y como $a_n = tilde(a)_n$ resulta $(-1)^(b_n) = (-1)^(c_n)$. Siendo $b_n, c_n in {0, 1}$, se sigue $b_n = c_n$ para todo $n$.

  Por otra parte, $A subset.eq ZZ^NN$, y como $ZZ tilde.op NN$ vale $ZZ^NN tilde.op NN^NN tilde.op {0,1}^NN$ (esta última por el ítem (a) del Ejercicio C3-2). Existe entonces $g : A -> {0,1}^NN$ inyectiva.

  Por el Teorema de Cantor-Schröeder-Bernstein, $A tilde.op {0,1}^NN tilde.op RR$.

  _Nota:_ el manuscrito original dice $A subset.eq NN^NN$, pero $A$ contiene sucesiones con el cero y con enteros negativos (mirá el ejemplo de arriba, con $a_4 = 0$ y $a_7 = -1$), así que en rigor $A subset.eq ZZ^NN$; se agregó el paso $ZZ tilde.op NN$ para completar el argumento.
]

#ejemplo[Una familia con condición local de contabilidad es contable (Clase 3 · Ejercicio 4)][C3-4][
  Sea $cal(F)$ una familia de subconjuntos no vacíos de $RR$ tal que para cada $x in RR$ existe $epsilon_x > 0$ con
  $ \#{F in cal(F) : F inter (x - epsilon_x, x + epsilon_x) != nothing} <= aleph_0. $
  Probar que $cal(F)$ es contable.
]

#estrategia[Pasar de un índice no contable a uno contable][
  La hipótesis da un entorno bueno alrededor de *cada* real, y los reales no son contables: si armamos la unión indexada por $RR$ no ganamos nada, porque unión no contable de contables no tiene por qué ser contable. Hay que reindexar por algo contable.

  Lo natural es usar intervalos *con centro y radio racionales*: hay una cantidad contable de ellos, y por densidad de $QQ$ todo entorno $(x - epsilon_x, x + epsilon_x)$ contiene uno de ellos que además contiene a $x$. Cada intervalo racional que entra adentro de un entorno bueno hereda la contabilidad, y ahí sí la unión es contable de contables.
]

#resolucion[
  Llamemos, para $q in QQ$ y $r in QQ_(>0)$,
  $ cal(F)_(q,r) = {F in cal(F) : F inter (q - r, q + r) != nothing}, $
  y sea
  $ P = {(q, r) in QQ times QQ_(>0) : cal(F)_(q,r) "es contable"}. $

  Como $QQ times QQ_(>0)$ es contable (es un subconjunto de $QQ times QQ$, numerable por ser producto de numerables), $P$ es contable. Afirmamos que
  $ cal(F) = union_((q,r) in P) cal(F)_(q,r). $

  La contención $supset.eq$ es clara, porque cada $cal(F)_(q,r)$ es un subconjunto de $cal(F)$.

  Para la otra, sea $F in cal(F)$. Como $F != nothing$, podemos tomar $x in F$, y la hipótesis nos da $epsilon_x > 0$ tal que ${G in cal(F) : G inter (x - epsilon_x, x + epsilon_x) != nothing}$ es contable. Por densidad de $QQ$ elegimos $q in QQ$ con $abs(x - q) < epsilon_x / 2$, y de nuevo por densidad un racional $r$ con
  $ abs(x - q) < r < epsilon_x / 2. $

  Con esa elección:

  - $x in (q - r, q + r)$, porque $abs(x - q) < r$;
  - $(q - r, q + r) subset.eq (x - epsilon_x, x + epsilon_x)$, porque si $abs(y - q) < r$ entonces
    $ abs(y - x) <= abs(y - q) + abs(q - x) < r + epsilon_x / 2 < epsilon_x / 2 + epsilon_x / 2 = epsilon_x. $

  De la segunda propiedad se sigue que $cal(F)_(q,r) subset.eq {G in cal(F) : G inter (x - epsilon_x, x + epsilon_x) != nothing}$, que es contable; luego $cal(F)_(q,r)$ es contable y $(q, r) in P$. De la primera, $x in F inter (q - r, q + r)$, así que $F in cal(F)_(q,r)$.

  Concluimos que $cal(F) subset.eq union_((q,r) in P) cal(F)_(q,r)$ y por lo tanto vale la igualdad. Siendo $P$ contable y cada $cal(F)_(q,r)$ con $(q,r) in P$ contable, $cal(F)$ es unión contable de contables y por lo tanto es contable.
]

#sublema(titulo: "Corrección al manuscrito")[
  El original indexa directamente por $QQ$: aplica la hipótesis en cada $q in QQ$ para obtener $epsilon_q > 0$, define $cal(F)_q = {F : F inter (q - epsilon_q, q + epsilon_q) != nothing}$ y, para cubrir un $F$ con $x in F$ irracional, pide un $q in QQ$ con $abs(x - q) < epsilon_q$.

  Ese último paso no se puede conseguir. El $epsilon_q$ viene dado por la hipótesis *en $q$*, no lo elegimos nosotros, y nada impide que los $epsilon_q$ de todos los racionales cercanos a $x$ sean mucho más chicos que la distancia de $x$ a ellos; la densidad de $QQ$ da racionales arbitrariamente cerca de $x$, pero no controla el radio que cada uno trae puesto.

  La reparación es no dejar que el radio venga impuesto: se lo elige uno, racional, adentro del entorno bueno de $x$. Eso es lo que hace la resolución de arriba, y es *razonamiento agregado*, no transcripción del manuscrito.
]

#ejemplo[Cardinal de las sucesiones binarias que valen $1$ finitas veces (Avanzada · Práctica)][guía-3][
  Sea $A subset.eq {0,1}^NN$ el conjunto de las sucesiones de ceros y unos que toman el valor $1$ sólo finitas veces (es decir, son eventualmente $0$). ¿Qué cardinal tiene $A$?
]

#estrategia[Partir por la cantidad de unos, y para cada cantidad fija anotar sus posiciones][
  Como cada sucesión de $A$ tiene finitos unos, tiene sentido agrupar $A$ según *cuántos* unos tiene cada una. Fijada esa cantidad $k$, una sucesión de $A_k$ queda completamente determinada por las $k$ posiciones (ordenadas) donde vale $1$ --- el resto son ceros --- así que $A_k$ se inyecta en $NN^k$.
]

#resolucion[
  *Cota inferior: $A$ es infinito.* Para cada $m in NN$, sea $(e^m_k)_(k in NN)$ la sucesión con $e^m_k = 1$ si $k=m$ y $e^m_k=0$ si no. La familia ${(e^m_k)_k : m in NN} subset.eq A$ es numerable (sucesiones distintas para $m$ distintos), así que $A$ es infinito.

  *Partición por cantidad de unos.* Escribimos $A = union.big_(k in NN_0) A_k$, con $A_k = {(a_n)_n in A : (a_n)_n "tiene exactamente" k "unos"}$.

  - $A_0 = {(0,0,0,dots)}$: un solo elemento.
  - $A_1 = {(e^m_k)_k : m in NN}$: numerable, biyectando con $m in NN$.
  - Para $k >= 2$: la función $A_k -> NN^k$ que manda $(a_n)_n$ a $(m_1, dots, m_k)$ con $m_1 < dots < m_k$ las posiciones donde vale $1$, es inyectiva --- dos sucesiones de $A_k$ con las mismas $k$ posiciones en $1$ coinciden en esas posiciones y en el resto (todo ceros), así que son la misma sucesión. Como $NN^k$ es numerable, $A_k$ es contable.

  *Conclusión.* $A$ es unión numerable de conjuntos contables, así que $A$ es contable; combinado con ser infinito, $A$ es numerable: $\#A = aleph_0$.
]

#ejemplo[Cardinal de $Omega = {B subset.eq ZZ : \#B != \#(ZZ without B)}$ (Parcial 2023)][guía-4][
  Sea $Omega subset.eq cal(P)(ZZ)$ definido como $Omega = {B subset.eq ZZ : \#B != \#(ZZ without B)}$. ¿Cuál es el cardinal de $Omega$?
]

#estrategia[$Omega$ es exactamente finitos $union$ cofinitos, y cada mitad es numerable][
  La clave es notar que la condición que define a $Omega$ es *simétrica* entre $B$ y su complemento, así que $Omega$ se parte en dos mitades del mismo tamaño: los subconjuntos finitos y los de complemento finito (cofinitos). Cada mitad se cuenta con la misma técnica del ejemplo anterior (partir por tamaño y encajar en $ZZ^k$).
]

#resolucion[
  *$Omega = Omega_F union Omega_("cof")$*, con $Omega_F = {B subset.eq ZZ : B "finito"}$ y $Omega_("cof") = {B subset.eq ZZ : ZZ without B "finito"}$ (unión disjunta, porque $ZZ$ es infinito: ningún subconjunto puede ser finito y cofinito a la vez).

  $supset.eq)$ Si $B$ es finito, $ZZ without B$ es infinito, así que $\#B != \#(ZZ without B)$ y $B in Omega$. Por simetría de la condición que define a $Omega$, si $B in Omega$ entonces $ZZ without B in Omega$ también; en particular, todo $B$ cofinito está en $Omega$.

  $subset.eq)$ Sea $B in Omega$. Si $B$ no fuera finito, sería infinito y, al ser $B subset.eq ZZ$ numerable, resultaría $\#B = aleph_0$. Si además $ZZ without B$ fuera infinito, también sería numerable, y entonces $\#B = \#(ZZ without B) = aleph_0$, contradiciendo $B in Omega$. Luego $ZZ without B$ debe ser finito, es decir $B in Omega_("cof")$.

  *$\#Omega_F = \#Omega_("cof")$*, vía la biyección $Omega_F -> Omega_("cof")$, $B |-> ZZ without B$ (con inversa la misma operación).

  *$\#Omega_F = aleph_0$.* Escribimos $Omega_F = union.big_(k in NN_0) Omega_(F,k)$ con $Omega_(F,k) = {B subset.eq ZZ : \#B = k}$. Cada $Omega_(F,k)$ es contable: la función que manda $B in Omega_(F,k)$ a la $k$-upla ordenada de sus elementos es inyectiva hacia $ZZ^k$, que es numerable (como en el Ejemplo guía-3). Como $Omega_F$ es infinito (contiene, por ejemplo, todos los singuletes ${n}$, $n in ZZ$) y es unión numerable de contables, $Omega_F$ es numerable.

  *Conclusión.* $\#Omega_("cof") = \#Omega_F = aleph_0$, y $Omega = Omega_F union Omega_("cof")$ es unión de dos numerables, así que $\#Omega = aleph_0$.
]

#sublema(titulo: "Pregunta abierta en el margen (sin resolver)")[
  La clase deja anotada, sin resolver, la pregunta complementaria: ¿cuál es el cardinal de $Omega' = {A subset.eq ZZ : \#A = \#(ZZ without A)}$? Como $Omega' = cal(P)(ZZ) without Omega$ y $Omega$ es numerable mientras que $cal(P)(ZZ) tilde.op RR$, la respuesta debería ser $\#Omega' = frak(c)$ (quitarle un numerable a un conjunto de cardinal $frak(c)$ no cambia su cardinal), pero esa propiedad de aritmética cardinal no está probada en el apunte, así que no se completa acá.
]
