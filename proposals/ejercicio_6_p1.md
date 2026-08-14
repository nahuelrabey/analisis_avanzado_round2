# Propuesta de Transcripción: Ejercicio 6 de la Práctica 1 (`p1.typ`)

Se ha preparado la estructura en Typst utilizando la librería `frame-it` (`#enunciado`, `#solucion`, `#duda`) para incorporar el Ejercicio 6 (a) y 6 (b) con la solución proveída por el usuario.

---

### Contenido a incorporar en `apuntes-typst/guias/p1.typ`

```typst
#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

#enunciado[Ejercicio 6 (a)][
  Dado un conjunto $A subset.eq RR$ acotado superiormente, pruebe que $-A = \{(-1)a : a in A\}$ está acotado inferiormente e $op("ínf")(-A) = -op("sup")(A)$.
]

#solucion[Propuesta 1][
  Como $A$ está acotado superiormente, $exists c in RR : a <= c, forall a in A$. Por lo tanto, $-c <= -a, forall -a in -A$ (pues $forall a in A$ se tiene $-a in -A$ y $forall -a in -A$ se tiene $a in A$). Es decir, $exists tilde(c) = -c in RR : tilde(c) <= -a, forall -a in -A$, con lo cual $-A$ está acotado inferiormente.

  _(Nota: Denotamos por $O(A)$ al conjunto de cotas superiores de $A$ y por $Omega(A)$ al conjunto de cotas inferiores de $A$)_.

  Más aún, para todo $c in RR$ tal que $a <= c, forall a in A$, existe $tilde(c) = -c$ que es cota inferior de $-A$. Y recíprocamente, para todo $tilde(c) in RR$ tal que $tilde(c) <= -a, forall -a in -A$, podemos encontrar $c = -tilde(c)$ tal que $a <= c, forall a in A$. Es decir, $-O(A) = Omega(-A)$: el conjunto de cotas superiores de $A$ reflejado es igual al conjunto de cotas inferiores de $-A$.

  Como $A$ está acotado superiormente, por el Axioma de Completitud existe $s = op("sup")(A)$. Luego, para todo $t in O(A)$ se cumple $s <= t$, por lo cual $-t <= -s$. Como $-O(A) = Omega(-A)$, se tiene que para todo $k in Omega(-A)$ vale $k <= -s$. Además, $-s$ es cota inferior de $-A$, por lo que es la mayor de todas las cotas inferiores. Concluimos que:
  $ -s = -op("sup")(A) = op("ínf")(-A) $
]

#duda[Consulta para docentes][
  ¿Es necesario demostrar rigurosamente la igualdad de conjuntos de cotas $-O(A) = Omega(-A)$ paso a paso o alcanza con argumentar la biyección mediante el cambio de signo $c |-> -c$?
]

#v(12pt)
#line(length: 100%, stroke: 0.5pt + luma(150))
#v(8pt)

#enunciado[Ejercicio 6 (b)][
  Sean $c > 0$ y $A subset.eq RR$ acotado superiormente. Pruebe que $c A$ está acotado superiormente y $op("sup")(c A) = c op("sup")(A)$.
]

#solucion[Propuesta 1][
  Como $A$ está acotado superiormente, $exists k in RR : a <= k, forall a in A$. Como $c > 0$, multiplicando por $c$ obtenemos $c a <= c k$, por lo que hemos encontrado $tilde(k) = c k$ tal que $c a <= tilde(k), forall c a in c A$. Por lo tanto, $c A$ está acotado superiormente.

  Más aún, para todo $k in RR$ tal que $a <= k, forall a in A$, podemos construir $tilde(k) = c k$ cota superior de $c A$. Recíprocamente, para todo $tilde(k) in RR$ tal que $c a <= tilde(k), forall c a in c A$, podemos definir $k = tilde(k)/c$ (dado que $c > 0$), resultando $a <= k, forall a in A$. Es decir, $c O(A) = O(c A)$.

  Dado que $A$ está acotado superiormente, por el Axioma de Completitud existe $s = op("sup")(A)$. Sabemos que $s <= t, forall t in O(A)$, de donde $c s <= c t$. Como $c O(A) = O(c A)$, se tiene que $c s <= tilde(t), forall tilde(t) in O(c A)$. Dado que $c s$ es cota superior de $c A$ y es menor o igual a cualquier otra cota superior de $c A$, es el supremo de $c A$:
  $ op("sup")(c A) = c s = c op("sup")(A) $
]
