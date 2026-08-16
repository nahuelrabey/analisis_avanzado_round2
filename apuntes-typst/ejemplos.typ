#import "@preview/frame-it:2.0.0": *
#import "utils.typ": *

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


// --- Archivo Acumulativo de Ejemplos ---

#ejemplo[Supremo de $B = (0, 1)$][
  Sea $B = (0, 1)$. Probar que $op("sup")(B) = 1$.
]

#estrategia[
  La estrategia es suponer que no es el supremo, por lo tanto hay un $t$ menor a él que es cota superior, y deberíamos ver una contradicción estudiando el punto medio entre $t$ y $1$.
]

#resolucion[
  Tenemos que $op("sup")(B) = 1$ ya que:

  - $s = 1$ es cota superior.
  - Supongamos que $t$ es una cota superior de $B$ y veamos que $t >= 1$. Supongamos que no, es decir, $t < 1$. Pero entonces puedo tomar $x = (t+1)/2$ (el punto medio entre $t$ y $1$) y nos sale que $t < x < 1$. Pero entonces tenemos que por un lado $x in B$ (porque es menor a 1) y por el otro es mayor a $t$ (que era una cota superior!). Esto es absurdo.
]

#ejemplo[Supremo de $C = {2 - 1/n : n in NN}$][
  Sea $C = {2 - 1/n : n in NN} = {2 - 1, 2 - 1/2, 2 - 1/3, ...}$. Probar que $op("sup")(C) = 2$.
]

#estrategia[
  Claramente $2$ es una cota superior de $C$. Mediante el Principio de Arquímedes se puede demostrar formalmente que $2 = op("sup")(C)$.
]

#ejemplo[Supremo de $D = {x in RR : 1/x^2 > 1/4}$][
  Sea $D = {x in RR : 1/x^2 > 1/4}$. Determinar el conjunto $D$ y hallar su supremo.
]

#resolucion[
  Resolviendo la inecuación:

  $ 1/x^2 > 1/4 <=> 4 > x^2 and x != 0 <=> 2 > |x| and x != 0 $

  Esto nos da el conjunto $D = (-2, 0) union (0, 2)$, cuyo supremo es $op("sup")(D) = 2$.
]

#ejemplo[Inexistencia de supremo en $QQ$ para $A = {r in QQ : r^2 < 2}$][
  Sea $A = {r in QQ : r^2 < 2}$. Demostrar que $A$ es acotado pero no tiene supremo en $QQ$.
]

#estrategia[
  Usar demostración por contradicción suponiendo que existe $s = op("sup")(A) in QQ$. Analizar las opciones $s^2 > 2$ y $s^2 < 2$ utilizando la densidad de $QQ$ en $RR$ para encontrar en ambos casos una contradicción.
]

#resolucion[
  Vemos que este conjunto es acotado (en $QQ$ y en $RR$). Sin embargo, $A$ no tiene supremo en $QQ$. Supongamos que sí tiene supremo, es decir, que existe $s = op("sup")(A)$ y $s in QQ$. Entonces tenemos que $s$ es cota superior de $A$ y si $t$ es otra cota superior, se debe cumplir que $t >= s$.

  Como $s in QQ subset.eq RR$ tenemos dos posibilidades: $s^2 > 2$ o $s^2 < 2$ (dado que $s^2 != 2$). Notar que acá estamos usando formalmente uno de los axiomas de orden: Tricotomía.

  - Si $s^2 > 2$, tenemos que $s > sqrt(2)$ (dado que $s > 0$). Por la Proposición 2, sabemos que existe un número racional $q$ tal que $s > q > sqrt(2)$. Elevando todo al cuadrado:
    $ q^2 > 2 > r^2 "para todo" r in A => q > r "para todo" r in A. $
    Esto último dice que $q$ es una cota superior de $A$. Pero $s > q$, que contradice que $s$ sea la menor cota superior en $QQ$.

  - Si $s^2 < 2$, tenemos que $s < sqrt(2)$. Al igual que antes, tiene que existir $q in QQ$ tal que $s < q < sqrt(2)$. Elevando al cuadrado:
    $ q^2 < 2 "y" q in QQ => q in A, $
    y por lo tanto se contradice que $s$ sea cota superior de $A$.

  Como llegamos a un absurdo con las dos únicas opciones, podemos concluir que no puede existir $s in QQ$.
]

#ejemplo[Máximo y Supremo de $A = [0, 1]$ y $B = [0, 1)$][
  Para $A = [0, 1]$, el $op("sup")(A) = 1$ y como $1 in A$, $op("máx")(A) = 1$. Sin embargo, para $B = [0, 1)$, el $op("sup")(B) = 1$ pero no tiene máximo porque $1 in.not B$.
]

#ejemplo[Ínfimo de $A = {1/n : n in NN}$][6][
  Sea $A = {1/n : n in NN}$. Veamos que $op("ínf")(A) = 0$:
]

#resolucion[
  #set enum(numbering: "1.")
  + Es fácil ver que $0$ es cota inferior.
  + Supongamos que $t$ es una cota inferior "mejor" que $0$, es decir, que $t > 0$. Por el Principio de Arquímedes (Proposición 1), sabemos que debe existir un $n in NN$ tal que $t > 1/n > 0$. Pero esto nos dice que $t$ no puede ser cota inferior, lo cual es absurdo. Concluimos que si $t$ es cota inferior debe ser $t <= 0$, que es lo que queríamos ver.
]

#ejemplo[Límite de $a_n = 1/n$][8][
  Sea $a_n = 1/n$. Veamos que $lim_(n -> oo) a_n = 0$. Acá "ver" quiere decir "probar por definición":

  Sea $epsilon > 0$. Queremos encontrar $n_0 in NN$ tal que $|1/n - 0| < epsilon$ para todo $n >= n_0$. Desmembrando un poco la condición $|1/n - 0| < epsilon$, vemos que
  $ |1/n - 0| < epsilon <=> 1/n < epsilon <=> 1/epsilon < n. $
]

#estrategia[
  La idea es la siguiente: el $epsilon$ viene dado y tenemos que ser capaces de exhibir un $n_0$ que cumpla lo que queremos. Por la condición de arriba, vemos que si $n_0$ es tal que $1/epsilon < n_0$, entonces
  $ n >= n_0 > 1/epsilon => 1/n <= 1/n_0 < epsilon. $

  Con lo cual, $n_0$ tiene que cumplir que $1/epsilon < n_0$ ya que esto garantiza que si tomamos $n >= n_0$, entonces $1/n < epsilon$.
]

#resolucion[
  Ahora, ¿qué es lo que permite afirmar que existe un $n_0$ tal que $1/epsilon < n_0$? La respuesta es el Principio de Arquímedes: para $x = 1/epsilon$ existe $n_0 in NN$ tal que $1/epsilon < n_0$.
]

#ejemplo[No convergencia de $a_n = (-1)^n$][9][
  La sucesión $a_n = (-1)^n$ *no converge*.
]

#estrategia[
  ¿Cómo probamos esto? Deberíamos ver que *para todo* candidato a límite $ell in RR$ *existe* un $epsilon > 0$ tal que *para toda* elección de $n_0$ *existe* un $n >= n_0$ con $|a_n - ell| >= epsilon$.
]

#resolucion[
  En el ejemplo que estábamos mirando: sea $ell in RR$. Entonces tenemos dos opciones: $ell >= 0$ o $ell < 0$.

  Supongamos que $ell >= 0$, y sea $epsilon = 1/2$. Dado $n_0 in NN$ cualquiera, tenemos que $n_0$ es par o es impar.
  - Si $n_0$ es par, podemos elegir $n = n_0 + 1$ (impar) y tenemos que:
    $ |(-1)^n - ell| = |(-1) - ell| = ell - (-1) = ell + 1 >= 1/2 $
    pues $ell >= 0$ y $n$ es impar.
  - Si $n_0$ es impar, podemos elegir $n = n_0$ (impar) y podemos hacer la misma cuenta.

  Finalmente, nos queda observar que si $ell < 0$ podemos hacer una cuenta muy parecida y llegamos a la misma conclusión.
]

#ejemplo[Ejemplo 2.20][
  Sea $A = {x / (x + 1) : x > 0}$. Veamos que $op("sup")(A) = 1$.
]

#resolucion[
  - *1 es cota superior:*
    $ x / (x + 1) <= 1 <=> x <= x + 1, $
    dado que $x > 0$ y por lo tanto 1 es cota superior.

  - *Veamos que existe una sucesión que converge a 1:* Consideremos $a_n = n / (n + 1) in A$ para todo $n in NN$ y sabemos que $lim_(n -> oo) a_n = 1$.

  Por la equivalencia del supremo nos sale que $1 = op("sup")(A)$. Podemos observar además que $1 in.not A$, por lo que $A$ no tiene máximo.
]

#ejemplo[Ejemplo 2.24][
  Sea $r in (0, 1)$ y sea $a_n = r^n$. Usemos la proposición anterior para probar que $r^n -> 0$.
]

#resolucion[
  Como $r < 1$, multiplicando por $r^n$ ambos términos (que es un número positivo), vemos que $r^(n+1) < r^n$ y por lo tanto $(a_n)_(n in NN)$ es una sucesión decreciente. Además es acotada, por lo que sabemos que existe el límite de esta sucesión (además sabemos que este límite debe coincidir con el ínfimo, y esa es otra manera de terminar este ejercicio pero no es lo que vamos a hacer nosotros). Llamemos $ell in RR$ al límite de $(a_n)_(n in NN)$ y consideremos la subsucesión $a_(2k) = r^(2k)$ la subsucesión de los términos pares. Por la proposición anterior, sabemos que $(a_(2k))_(k in NN)$ también converge a $ell$. Observemos que

  $ a_(2k) = r^(2k) = r^k · r^k -> ell · ell = ell^2, $

  por álgebra de límites. Pero entonces, por unicidad del límite, tenemos que $ell = ell^2$ y por lo tanto $ell = 0$ o $ell = 1$. Finalmente, observamos que $ell$ no puede ser 1, porque el primer término de la sucesión es $r$ y después la sucesión es decreciente: esto nos dice que $abs(a_n - 1) >= 1 - r$ para todo $n in NN$. Concluimos que $ell = 0$, como queríamos ver.
]




