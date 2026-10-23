# Práctica 4: teoría que falta en `apuntes.typ` y dónde encontrarla

Nota de apoyo para incorporar teoría al apunte. Sale de leer 16 apuntes universitarios de acceso abierto buscando ejemplos para la Práctica 4. Los ejemplos están en `apuntes-typst/ejemplos/p4_alternativos.typ`. Acá queda lo que esos ejemplos *usan* y el apunte todavía no tiene.

El capítulo 5 de `apuntes.typ` llega hoy hasta la Obs. 5.34 y tiene:

- **Continuidad:** imagen y preimagen (Def. 5.1), continuidad ε–δ y con bolas (Def. 5.4), la observación de que la continuidad depende de las métricas, continuidad por sucesiones (Teo. 5.7), por preimágenes de abiertos (Teo. 5.9) y de cerrados (Ej. 5.10), la Obs. 5.12 (continua no implica abierta ni cerrada) y la caracterización por clausuras (Teo. 5.13). La definición de función abierta y cerrada está sólo como comentario después de la Obs. 5.12.
- **Continuidad uniforme:** Def. 5.14, Obs. 5.15 (contra la continuidad), Obs. 5.16 (negación) y Prop. 5.18 (caracterización por pares de sucesiones). Que manda Cauchy en Cauchy es el Ejercicio 5.19, como desafío.
- **Densidad y extensión:** Def. 5.20 (denso: $\overline{E} = M$) y Teo. 5.22 (extensión de una uniformemente continua desde un denso a un completo); la unicidad es el Ejercicio 5.23.
- **Lipschitz:** Def. 5.24, la observación "derivada acotada implica Lipschitz" y la Obs. 5.28 (Lipschitz ⇒ uniformemente continua ⇒ continua, sin vueltas: $x^2$ y $\sqrt{x}$). Lipschitz ⇒ uniformemente continua es el Ejercicio 5.25 y $\sqrt{x}$ uniformemente continua es el 5.27.
- **Homeomorfismos e isometrías:** Def. 5.29, Def. 5.33 y Obs. 5.34 (una isometría es homeomorfismo con su imagen). Los ejercicios 5.31 y 5.32 (identidad entre $d_1$, $d_2$, $d_\infty$; composición de homeomorfismos) son desafíos.

Los ejemplos numerados del capítulo (5.17, 5.21, 5.26, 5.30, 5.35) están en `ejemplos/p4.typ`. Ahí también están los ejemplos de la clase del 07/10 (C9): suma y producto de continuas (C9-1.1), proyecciones de $\mathbb{R}^n$ (C9-1.2), polinomios (C9-1.6), conjuntos como preimágenes de polinomios (C9-2.1, C9-2.2) y los Ejercicios 8 y 7 (a) de la guía (C9-3.1 y C9-3.2). La columna de estado distingue lo que está en `apuntes.typ` de lo que sólo está como ejemplo de clase.

## 1. Lo que faltaba, por orden de urgencia para la Práctica 4

Las páginas son las del PDF (la del visor), no la impresa. Los códigos `O…` son los de la tabla de fuentes del final y de la pestaña de los ejemplos. La columna *Estado* compara con el capítulo 5 hasta la Obs. 5.34: quedan pendientes las filas 2 a 7, 11, 14, 15 y 16, y la 1 a medias.

| # | Resultado | La práctica lo usa en | Dónde está demostrado | Estado en `apuntes.typ` |
|---|---|---|---|---|
| 1 | **Definición de conjunto denso** ($\overline{D} = X$). El apunte sólo tiene la Prop. 2 "Densidad de ℚ"; no hay definición general. Conviene agregar las caracterizaciones: $D$ denso ⟺ corta a todo abierto no vacío ⟺ toda bola contiene un punto de $D$. | Ej. 7, 8 (y P3) | O3 Prop. 2.2.45 y Obs. 2.2.46 (págs. 83–84); O4 Lema 2.1 (pág. 31) y Ejercicio E5 a) (pág. 60) | **Parcial.** Def. 5.20 (denso) y Ejemplo 5.21 ($\mathbb{Q}$ y $\mathbb{R}\setminus\mathbb{Q}$). Faltan las caracterizaciones por abiertos y por bolas; C9-3.1 usa la de abiertos como estrategia. |
| 2 | **Composición de continuas** (en un punto y global), y **restricción** a un subconjunto. | Ej. 1, 5, 11 | O2 Prop. 3.9 (pág. 66, por sucesiones); O15 Lema 3.3 (págs. 7 y 60, ε–δ) y Teo. 3.9 (pág. 10, por preimágenes); O14 Apuntes_03 §3.4 | Pendiente. El Ejemplo 5.30 a) y el Ejercicio 5.32 la usan sin enunciarla. |
| 3 | **Álgebra de continuas a valores reales**: suma, producto, cociente con denominador no nulo, máximo y mínimo; polinomios y racionales continuas. | Ej. 1 (a), (b), 5, 11 (c) | O14 Apuntes_03 §3.7–3.8 (págs. 9–11, demostrado vía composición con suma, producto e inversión); O2 Ejercicio 3.14 y Nota 3.15 (pág. 67, sin demostración); O16 Ej. 8.22 (máximo, pág. 15) | Pendiente en `apuntes.typ`. Suma y producto (C9-1.1) y polinomios (C9-1.6) están probados como ejemplos de clase en `ejemplos/p4.typ`; faltan cociente, máximo y mínimo. El Ejemplo 5.30 a) usa "cociente de continuas". |
| 4 | **Continuidad coordenada a coordenada** en $X \times Y$ con $d_\infty$ (ya está como ejemplo C6-1 en `ejemplos/p4.typ`, pero no como proposición del apunte). | Ej. 1, 4, 5 | O2 Prop. 3.11 y Cor. 3.12–3.13 (págs. 66–67); O14 Apuntes_03 §3.6 | Pendiente en `apuntes.typ`. Está como ejemplo de clase: C6-1 ($X \times Y$) y C9-1.2 (proyecciones de $\mathbb{R}^n$ con $d_\infty$). |
| 5 | **Lema del pegado**: si $X = C_1 \cup C_2$ con $C_i$ cerrados y $f\vert_{C_i}$ continuas, $f$ es continua. Falla con infinitos cerrados y vale con abiertos. | Ej. 1 (b), 13 | O2 Prop. 3.16 (pág. 67); O16 Ej. 8.18, Cor. 8.19, Prop. 8.20 (págs. 14–15) | Pendiente. |
| 6 | **Distancia de un punto a un conjunto** $d(x, A)$ y entre conjuntos $d(A, B)$; $\lvert d(x, A) - d(y, A)\rvert \le d(x, y)$; $d(x, A) = 0 \iff x \in \overline{A}$. | Ej. 10, 11, 16 | O2 Def. 1.39–1.40 (pág. 28), Prop. 1.52 (pág. 30), Prop. 2.61 (pág. 57); O3 Prop. 2.3.9 y Obs. 2.3.10 (pág. 92) | Pendiente. |
| 7 | **Lema de Urysohn métrico** y separación de cerrados disjuntos por abiertos disjuntos. | Ej. 11 | O2 Teo. 3.19 y Cor. 3.20–3.22 (pág. 68); O3 Cor. 2.3.12 (pág. 93); O12 Cor. 2.2.5 (pág. 20, con el signo de $d_E - d_F$) | Pendiente. |
| 8 | **Función Lipschitz** y **uniformemente continua**; Lipschitz ⇒ uniformemente continua ⇒ continua; los recíprocos fallan ($\sqrt{x}$, $x^2$). | Ej. 12, 13, 15 | O2 Def. 3.33, 3.50 y Prop. 3.51 (págs. 70–73); O6 Def. 3.4.1, 3.4.7, Prop. 3.4.8 (págs. 138–141) | **Cubierta.** Def. 5.14, Obs. 5.15, Def. 5.24 y Obs. 5.28; Ejercicios 5.25 y 5.27; Ejemplos 5.17 y 5.26. |
| 9 | **Criterio por sucesiones** para negar continuidad uniforme: existen $x_n, y_n$ con $d(x_n, y_n) \to 0$ y $d'(f(x_n), f(y_n)) \ge \varepsilon$. | Ej. 13, 15, 16 | O3 Prop. 2.5.3 (págs. 117–118); O14 Apuntes_05 §5.3 (pág. 4); O4 Prop. 3.1.6 (págs. 45–46) | **Cubierta.** Obs. 5.16 y Prop. 5.18. |
| 10 | **Uniformemente continua manda Cauchy en Cauchy**; la continuidad sola no alcanza ($1/x$). | Ej. 14 | O6 Lema 3.4.5 (pág. 139); O2 Obs. 6.5 (pág. 101) | **Cubierta.** Ejercicio 5.19 (desafío). El contraejemplo $1/x$ no está en el apunte (O2-13). |
| 11 | **Métricas equivalentes** (topológica, uniforme y Lipschitz): si $d \le C d'$, la identidad es Lipschitz; métricas equivalentes tienen las mismas funciones continuas. Contesta los "¿cambia algo con $d_1$ o $d_\infty$?" | Ej. 1, 5, 9 (c) | O3 Prop. 2.5.6–2.5.8 (págs. 121–123); O2 Prop. 3.87 (pág. 77); O4 §1.3 (págs. 23–24) | Pendiente. La observación tras la Def. 5.4 cubre cambiar la métrica de llegada; falta la de salida (Ej. 9 (c)) y la versión uniforme. El Ejercicio 5.31 da la identidad entre $d_1$, $d_2$, $d_\infty$ como homeomorfismo. |
| 12 | **Funciones abiertas y cerradas, homeomorfismo, isometría**. (El usuario ya dejó la definición de abierta y cerrada como comentario en `apuntes.typ` y como definición en `ejemplos/p4.typ`.) | Ej. 6, 1 (c), (d) | O2 Def. 3.23–3.28, Obs. 3.31 y Ej. 3.32 (págs. 68–70); O2 §3.4 isometrías (págs. 76–77) | **Cubierta.** Def. 5.29, Def. 5.33, Obs. 5.34; Ejemplos 5.30 y 5.35. Abierta y cerrada siguen como comentario. |
| 13 | **Extensión**: una función uniformemente continua definida en un denso, a valores en un completo, se extiende de manera única a la clausura. | Ej. 7, 14 | O2 Teo. 6.28 (págs. 105–106); O6 Prop. 3.4.6 (págs. 140–141, versión en intervalos); O14 Uniforme §11.3 (págs. 3–4) | **Cubierta.** Def. 5.20, Teo. 5.22 y Ejercicio 5.23 (unicidad). |
| 14 | **Lineal continua ⟺ acotada ⟺ Lipschitz** (contesta el Ej. 9 (c) para funcionales lineales). | Ej. 9 (c) | O14 Apuntes_05 §5.6 (págs. 7–8) | Pendiente (no hace falta para la Práctica 4). |
| 15 | **Heine**: continua en un compacto ⇒ uniformemente continua. Es de la Práctica 5, pero explica los contraejemplos de los Ej. 13 y 15. | Ej. 13, 15 (contexto) | O6 Teo. 3.4.4 (pág. 139, en $[a, b]$ con Bolzano–Weierstrass); O14 Apuntes_05 §5.3 (pág. 4, por sucesiones); O2 Cor. 7.38 (pág. 118) | Pendiente (Práctica 5). |
| 16 | **El conjunto de puntos de continuidad es un $G_\delta$** (por eso no hay $f : \mathbb{R} \to \mathbb{R}$ continua exactamente en $\mathbb{Q}$). Curiosidad alrededor del Ej. 2; la función de Thomae es el ejemplo dual. | Ej. 2 (contexto) | O3 Prop. 2.3.16–2.3.17 (págs. 94–96); O6 Ej. 3.2.12 (págs. 126–127) | Pendiente (curiosidad). |

## 2. Observaciones sobre el estado actual del apunte

- La Obs. 5.12 tiene los ejemplos $e^x$ y $x^2$. Hay un tercero más limpio en O11-2: $\lvert x \rvert$ en $[-1, 1]$.
- El Teo. 5.13 se demuestra en el apunte por sucesiones en un sentido y por cerrados en el otro. O4-6 y O9-1 traen otras dos demostraciones, por sucesiones y por ε–δ.
- La observación "la continuidad depende de las métricas" del apunte cubre la identidad con la métrica discreta, y el Ejemplo 5.30 b) muestra que esa identidad no es un homeomorfismo. O14-8 agrega que la continuidad *uniforme* depende de la métrica aunque los abiertos sean los mismos: la identidad de $(\mathbb{R}, \lvert\cdot\rvert)$ en $(\mathbb{R}, \lvert e^x - e^y\rvert)$ es un homeomorfismo (Def. 5.29) que no es uniformemente continuo.
- Los ejemplos de clase C9-3.2 y C9-3.1 resuelven los Ejercicios 7 (a) y 8. En `p4_alternativos.typ`, O11-4 y O15-4 (Ej. 7) y O2-5 y O9-1 (Ej. 8) son otras demostraciones de lo mismo, y su comentario lo dice.
- Con las Defs. 5.14 a 5.24 en el apunte, algunos ítems de `p4_alternativos.typ` pasaron a ser una segunda lectura con la misma demostración: O6-1 (definiciones), O3-8 y O14-6 (Prop. 5.18), O2-6 y O14-10 (Teo. 5.22). Se dejaron porque traen casos extra (O2-6 incluye el caso isometría; O14-6, contraejemplos concretos), y su comentario lo indica en el nivel.

## 3. Fuentes

Todas se pueden descargar sin registrarse. Sólo dos declaran una licencia abierta: Lebl (O6) y MIT OpenCourseWare (O9). Guccione 2017 (O2) permite la copia sin fines de lucro y sin modificar el texto. El resto no declara licencia: son apuntes publicados por los docentes en sus páginas. Los ejemplos citan la fuente al pie y transcriben fragmentos traducidos; si el repositorio pasa a ser público, conviene tenerlo en cuenta.

| Tag | Fuente | Acceso | Ítems usados |
|---|---|---|---|
| O1 | J. A. y J. J. Guccione, *Espacios Métricos*, Cálculo Avanzado, FCEN-UBA, 2014 | sin licencia | 0 (la edición 2017 lo contiene) |
| O2 | J. A. y J. J. Guccione, *Espacios Métricos*, Cálculo Avanzado, FCEN-UBA, 2017 | copia sin lucro y sin modificar | 14 |
| O3 | A. Daniilidis, *Espacios Métricos*, MA3801, U. de Chile, 2016 | sin licencia | 6 |
| O4 | P. Gajardo, *Análisis I*, UTFSM, 2021 | copyright del autor | 6 |
| O5 | E. Maximenko, *Funciones uniformemente continuas*, ESFM-IPN, 2022 | sin licencia | 4 |
| O6 | J. Lebl, *Basic Analysis I*, v6.3, 2026 | CC BY-NC-SA 4.0 / CC BY-SA 4.0 | 11 |
| O7 | J. Tyson, *MATH 424 lecture notes: functions*, UIUC, 2026 | sin licencia | 5 |
| O8 | P. Dote, *18.S097*, Lecture 5, MIT, 2022 | sin licencia | 1 |
| O9 | MIT OCW 18.100C, Problem Set 6 Solutions, 2012 | CC BY-NC-SA 4.0 | 2 |
| O10 | P. Karageorgis, *MA2223 Metric spaces*, TCD | sin licencia | 3 |
| O11 | D. Herrera Carrasco, F. Macías Romero, L. A. Guerrero Méndez, *La magia de los espacios métricos*, BUAP, 2025 | derechos reservados BUAP | 6 |
| O12 | R. G. Wilson, *Notas de Análisis*, UAM-I, 2005 | sin licencia | 1 |
| O13 | F. Galaz Fontes, *Notas, Clase 21*, CIMAT, 2020 | sin licencia | 0 (duplicaba otros) |
| O14 | R. Payá, *Análisis Matemático I*, U. de Granada, 2014-15 y 2024-25 | sin licencia | 11 |
| O15 | T. W. Körner, *Metric and Topological Spaces*, Cambridge, 2021 | sin licencia | 4 |
| O16 | S. Chavan, *MTH304 Topology*, IIT Kanpur | sin licencia | 6 |
| O17 | N. Addington, *A Course in Metric Spaces and Point-Set Topology*, U. of Oregon, 2026 | sin licencia | 4 |

URLs: en la tabla del encabezado de `ejemplos/p4_alternativos.typ`.

Búsquedas que no dieron resultado: las soluciones del Problem Set 5 de MIT 18.100C no tratan continuidad; la Práctica 4 de la UNLP (2018) y los apuntes de A. Ramírez (UC Chile), U. de Murcia, Lebl (OSU, cap. 7 suelto) y R. Schwartz (Brown) no se pudieron descargar desde el entorno.

## 4. Ítems descartados por duplicados

Se extrajeron 130 ítems y se cargaron 84. Estos 46 quedaron afuera porque repiten, con la misma demostración, algo que sí se cargó (o son sólo un enunciado de algo resuelto en otro ítem):

- **O1-1 a O1-14**: edición 2014 del apunte de Guccione; la de 2017 (O2) trae el mismo material.
- **O3-3**: composición y álgebra: ya cubiertas por O15-1, O2-1 y O2-2.
- **O4-12**: composición, sólo enunciado: cubierta por O15-1 y O2-1.
- **O7-4**: composición por preimágenes: es la segunda demostración de O15-1.
- **O13-2**: composición por sucesiones: es O2-1.
- **O3-4**: Lipschitz y $\sqrt{|x|}$ sin resolución: cubierto por O6-1, O2-12 y O6-11.
- **O4-13**: definiciones de Lipschitz, sólo enunciado: cubiertas por O6-1.
- **O13-1**: constantes, identidad y $d(\cdot, p)$ Lipschitz: cubierto por O7-1.
- **O3-11**: Heine: se dejan O6-7 y O14-7.
- **O4-9**: Heine: se dejan O6-7 y O14-7.
- **O12-4**: Heine: se dejan O6-7 y O14-7.
- **O15-6**: Heine, sólo indicación: se dejan O6-7 y O14-7.
- **O11-6**: continuidad uniforme manda Cauchy en Cauchy: misma demostración que O6-8.
- **O5-5**: Cauchy en Cauchy, sólo indicación: resuelto en O6-8 y O4-7.
- **O10-4**: $1/x$ y $x_n = 1/n$: es O2-13.
- **O7-5**: extensión desde un denso, sólo enunciado: resuelta en O2-6 y O14-10.
- **O11-7**: extensión a la clausura con varias erratas: resuelta en O2-6 y O14-10.
- **O4-8**: criterio por pares de sucesiones: es O3-8.
- **O17-6**: $f = g$ en un denso, sólo indicación: resuelto en O11-4 y O15-4.
- **O3-5**: $d(\cdot, A)$ 1-Lipschitz y $\overline{A} = d(\cdot, A)^{-1}(0)$: misma demostración que O2-8.
- **O3-6**: Urysohn: misma construcción que O2-9.
- **O3-7**: todo cerrado es $G_\delta$: es la segunda parte de O4-4.
- **O4-1**: $d(x, A) = 0 \iff x \in \overline{A}$: está en O2-8.
- **O4-2**: $d(\cdot, C)$ 1-Lipschitz: está en O2-8.
- **O4-11**: la métrica es continua, sólo enunciado: resuelto en O2-7.
- **O6-5**: enunciados sobre $d(\cdot, p)$ y $d$ en $X \times X$: resueltos en O7-1 y O2-7.
- **O11-1**: $d(x, a)$ y $d(x, A)$ continuas: cubierto por O7-1 y O2-8.
- **O12-1**: $x \in \overline{A} \iff d(x, A) = 0$: está en O2-8.
- **O12-2**: $d_A$ 1-Lipschitz: está en O2-8.
- **O14-5**: $d(\cdot, z)$ no expansiva y $d$ Lipschitz con constante 2: es O2-7.
- **O15-5**: enunciado del Ej. 11 casi literal, sin resolución: resuelto en O2-8 y O2-9.
- **O16-7**: Urysohn con indicación: resuelto en O2-9.
- **O17-2**: $p \mapsto d(p, a)$ continua, sólo indicación: resuelto en O7-1.
