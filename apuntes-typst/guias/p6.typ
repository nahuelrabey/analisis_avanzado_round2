#import "../utils.typ": *
#show: frame-style(styles.boxy)

#align(center)[
  #text(14pt, weight: "bold")[Análisis Avanzado - Segundo cuatrimestre de 2025] \
  #v(2pt)
  #text(12pt, weight: "medium")[Práctica 6]
]

#v(4pt)
#line(length: 100%, stroke: 0.7pt)
#v(8pt)

#set enum(numbering: "1.")

+ Pruebe que $\|dot\|_1$, $\|dot\|_2$ y $\|dot\|_infinity$ definen normas en $RR^n$, donde
  $ \|x\|_1 = sum_(i=1)^n |x_i|, quad \|x\|_2 = (sum_(i=1)^n x_i^2)^(1/2) quad "y" quad \|x\|_infinity = max_(1 <= i <= n) |x_i|. $

+ Sea $E$ un espacio normado. Pruebe que se verifican:
  #set enum(numbering: "(a)")
  + Si $x in E$ y $r > 0$, $overline(B(x, r)) = overline(B)(x, r)$ (es decir, la clausura de la bola abierta es la bola cerrada).
  + $op("diam")(B(x, r)) = 2r$.
  + Si $y, z in B(x, r)$ entonces para todo $t in [0, 1]$, $t y + (1 - t) z in B(x, r)$ (es decir, toda bola es _convexa_).

+ Sea $E$ un espacio normado. Sean $(x_n)_(n in NN) subset.eq E$ y $x_0 in E$ tales que $lim_(n -> oo) x_n = x_0$. Pruebe que si definimos $(y_n)_(n in NN) subset.eq E$ por
  $ y_n = (x_1 + x_2 + dots + x_n) / n, $
  entonces $lim_(n -> oo) y_n = x_0$.

+ Sea $E$ un espacio normado y $S subset.eq E$ un subespacio (vectorial). Pruebe que:
  #set enum(numbering: "(a)")
  + $overline(S)$ también es un subespacio.
  + Si $S != E$, entonces $S^compose = nothing$.
  + Si $op("dim")(S) < oo$, entonces $S$ es cerrado.
  + Si $S$ es un hiperplano, entonces $S$ es o bien denso o bien cerrado en $E$.

+ Sea $RR_n [t]$ el conjunto de los polinomios de grado menor o igual que $n$ con coeficientes en $RR$. Consideremos para $p in RR_n [t]$ las normas
  $ \|p\|_infinity = max_(0 <= t <= 1) |p(t)| quad "y" quad \|p\|_1 = integral_0^1 |p(t)| dif t. $
  #set enum(numbering: "(a)")
  + ¿Son $(RR_n [t], \|dot\|_infinity)$ y $(RR_n [t], \|dot\|_1)$ espacios de Banach? ¿Por qué?
  + Justifique por qué ambas normas resultan equivalentes en $RR_n [t]$ para todo $n in NN$.
  + Si $RR[t]$ denota el conjunto de todos los polinomios con coeficientes en $RR$, pruebe que ahí las normas $\|dot\|_infinity$ y $\|dot\|_1$ no son equivalentes. ¿Hay alguna contradicción con el ítem anterior, que afirma que las normas son equivalentes para polinomios de grado hasta $n$ para todo $n in NN$?

+ Definimos $ell^infinity$ como el espacio de todas las sucesiones acotadas de números reales:
  $ ell^infinity = \{a = (a_n)_(n in NN) subset.eq RR : sup_(n in NN) |a_n| < +oo\} $
  con la norma
  $ \|a\|_infinity = sup_(n in NN) |a_n|. $
  #set enum(numbering: "(a)")
  + Pruebe que la bola cerrada de centro $0$ y radio $1$ de $ell^infinity$ no es compacta.
  + Pruebe que no hay ningún conjunto numerable denso en $ell^infinity$.

+ Sea $E subset.eq ell^infinity$ el (sub)espacio normado definido como
  $ E = \{a in ell^infinity : "existe " n_0 in NN "tal que " a_n = 0 "para todo " n >= n_0\}, $
  dentro del cual consideramos el subespacio
  $ S = \{a in E : sum_(n >= 1) a_n = 0\}. $
  Pruebe que $S$ es denso en $E$.

+ Sean $(E, \|dot\|_E)$, $(F, \|dot\|_F)$ espacios normados. Sea $T : E -> F$ un operador lineal. Pruebe que son equivalentes:
  #set enum(numbering: "(a)")
  + $T$ es continuo en $0$.
  + Existe $x_0 in E$ tal que $T$ es continuo en $x_0$.
  + $T$ es continuo.
  + $T$ es uniformemente continuo.
  + $T$ es acotado.
  + Para todo $A subset.eq E$ acotado, $T(A)$ es acotado.

+ Sean $(E, \|dot\|_E)$, $(F, \|dot\|_F)$ espacios normados, y sea $T : E -> F$ lineal y continuo. Verifique las siguientes fórmulas:
  $ \|T\| = sup_(\|x\|_E <= 1) \|T x\|_F = sup_(\|x\|_E = 1) \|T x\|_F = sup_(x != 0) (\|T x\|_F) / (\|x\|_E). $

+ Consideremos en $C([0, 1])$ las normas
  $ \|f\|_infinity = max_(x in [0, 1]) |f(x)| quad "y" quad \|f\|_1 = integral_0^1 |f(x)| dif t. $
  Sean $cal(E), cal(I) : C([0, 1]) -> RR$ las funcionales lineales definidas por
  $ cal(E) f = f(0), quad cal(I) f = integral_0^1 f(x) dif x. $
  Decida, para cada una de las normas, si cada una de las funcionales es continua; en caso afirmativo, acote su norma.

+ Consideremos en $C([0, 1])$ la norma infinito. Fijada $k : [0, 1] times [0, 1] -> RR$ continua, sea $K : C([0, 1]) -> C([0, 1])$ dada por
  $ (K f)(x) = integral_0^1 k(x, y) f(y) dif y. $
  Pruebe que $K$ es lineal y continua. Acote su norma.

+ Sea $RR[t]$ el espacio de polinomios, con la norma $\|dot\|_infinity$ definida en el Ejercicio 5. Sea $delta : RR[t] -> RR[t]$ dado por $(delta p)(t) = p'(t)$, donde $p'$ denota el derivado de $p$. Probar que $delta$ es un operador lineal que no es continuo.

+ Sea $ell^2$ el espacio vectorial de todas las sucesiones de cuadrado sumable:
  $ ell^2 = \{a = (a_n)_(n in NN) subset.eq RR : sum_(n=1)^oo |a_n|^2 < +oo\}. $
  Para $a in ell^2$ definimos
  $ \|a\|_2 = (sum_(n=1)^oo |a_n|^2)^(1/2). $
  #set enum(numbering: "(a)")
  + ¿Es compacta la bola cerrada de centro $0$ y radio $1$ de $ell^2$?
  + Pruebe que $gamma : ell^2 -> RR$ dada por
    $ gamma(a) = sum_(n=1)^oo a_n / n $
    es una funcional lineal continua.

    _Sugerencia: use la desigualdad de Cauchy-Schwarz._
