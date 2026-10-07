# Lean: código compartido entre guías y parciales, y cómo organizar las librerías

**Fecha:** 7 de octubre de 2026
**Estado:** nota de decisión. Es un relevamiento de `lean/` (Parciales, Ejemplos, Guías 1, 2 y 3;
~9700 líneas, 60 archivos) hecho sobre el código tal como quedó después del PR #13. No se movió
nada todavía: la sección 4 dice qué se va a hacer y en qué orden.
**Motivo:** las tres guías se resolvieron con agentes que trabajaban en paralelo sobre archivos
"independientes entre sí" (cada `EjNN.lean` sólo importa su `Defs.lean`), y los parciales se
formalizaron antes, cada uno contra Mathlib directo. El resultado es que lo mismo está probado
varias veces con nombres distintos.

> **Cómo leer esto.** Las secciones 1 y 2 son el catálogo (qué está repetido y dónde, con
> archivo y línea). La 3 es la decisión de organización. La 5 responde las dos preguntas del
> pedido: si hay una "estructura" de demostración que se repite y si hay un patrón para
> resolver ejercicios, mirando sobre todo los parciales.

---

## 0. Resumen en diez líneas

- Hay **cuatro dialectos** para las mismas nociones: el del curso en `Guia1/Defs.lean`
  (`EsSup`, `Converge` ε-n₀), el del curso en `Guia2/Defs.lean` (`Numerable`, `CardC`), el
  "a mano" de la Guía 3 (`EsMetrica`, `bola`, `EsCauchy`, `Converge d`) y el de Mathlib que usan
  los seis parciales (`sSup`, `Tendsto`, `Cardinal.mk`, `MetricSpace`). Ningún parcial importa
  nada de `Guias/`.
- **Unas 1500 de las 9700 líneas son copias**: ~900 en la Guía 2 (Ej. 13/14/15 comparten 12
  declaraciones idénticas, Ej. 2/3/4 comparten 7, Ej. 6/7 comparten 3), ~400 en la Guía 3
  (`d1`/`d2`/`dinf` dos veces, la métrica discreta tres veces contando un recuperatorio,
  dos `fronteraCurso`, tres `distancias`, lemas de `Common.lean` reprobados en el Ej. 3), ~100
  en la Guía 1 (`le_two_pow`, `exists_strictMono_of_step`, cuatro `strictMono_*`, cuatro
  `diverge*`), ~100 en los parciales (`d1` de `C[0,1]` con `ext`/`ext_of_mem` dos veces,
  `sumSet` dos veces, `dtilde` = `dhat` de la Guía 3, `Rδ` = `Disc ℝ`).
- La causa es una sola regla: "los archivos de la práctica son independientes". Se reemplaza
  por una librería común `Comun` (nueva `lean_lib`) con un archivo por tema, de la que importan
  guías, parciales y ejemplos; los `EjNN.lean` pueden importar ejercicios anteriores.
- Sí hay estructuras de prueba que se repiten (sección 5.1: doce, con esqueleto) y sí hay un
  patrón claro en los parciales (sección 5.2): cuatro casilleros fijos --- cardinal de un
  conjunto (6/6), topología general con "V o F" (6/6), sup/ínf (5/6), métrica concreta con
  bolas/completitud/continuidad (5/6) --- cada uno con un guion de 3-5 pasos.

---

## 1. Definiciones compartidas (la misma noción, definida más de una vez)

| Noción del curso | Dónde está definida | Qué hacer |
|---|---|---|
| Métrica (Def. 4.1) | `Guias/Common.lean:14` (`structure EsMetrica`); los parciales prueban los 4 campos inline o como `d_nonneg/d_eq_zero_iff/d_comm/d_triangle` sueltos (`Recu1_1C2025.lean:192-215`, `Peine.lean:29-89`, `Parcial1_1C2024.lean:185`, `Recu1_2C2025.lean:159`) y arman una `instance : MetricSpace`. Nadie usa `EsMetrica` fuera de la Guía 3 porque no hay constructor `EsMetrica d → MetricSpace`. | Una `EsMetrica` + constructor `EsMetrica.toMetricSpace` (sobre un sinónimo de tipo) + lema `dist_eq` por `rfl`. |
| Bola abierta/cerrada | `Common.lean:25,28` (`bola d`, `bolaCerrada d`, sólo usadas por Guía 3 Ej. 1 y 12; `bolaCerrada` no la usa nadie); el resto usa `Metric.ball`. | `bola d` sólo para métricas sin instancia; puentes `bola d x r = Metric.ball x r` para las que sí la tienen. |
| `d₁`, `d₂`, `d_∞` en ℝⁿ | `Guia3/Ej01.lean:157,53,187` y, **textualmente iguales**, `Guia3/Ej12.lean:23,26,29`; `Recu1_1C2025.lean:175` define `d2` vía `EuclideanSpace` y `d2_eq` (:178) la iguala a la fórmula; `d_∞` del recuperatorio es el `dist` de Mathlib en `Fin n → ℝ`. | Una copia, con `dinf_eq_dist` y `d2_eq_dist_euclidean`. |
| Métrica discreta | `Guia3/Ej01.lean:306` (`δ` + `EsMetrica`), `Guia3/Ej04.lean:130-176` (`Disc X` + instancia), `Recu1_2C2025.lean:157-183` (`Rδ`, **misma prueba línea por línea** que `Disc`). | `Disc X`; `Rδ := Disc ℝ`; `δ` se deriva. |
| `C([0,1])` y sus distancias | `Guia3/Ej01.lean:234,237` (`C01`, `dC` = sup); `Parcial1_1C2024.lean:108-120` y `Parcial1_2C2024.lean:217-229` (`ext`, `continuous_ext`, `ext_of_mem`, `d1` integral; **idénticos**). | Un módulo `C01` con `dC` (+ `dC_eq_dist`), `d1`, `d1_le_dist`, `E`. |
| Distancia entre conjuntos | `Guia3/Ej11.lean:30,33` (`distancias`, `dhat`) y `Parcial1_2C2025.lean:145` (`dtilde`, mismo `sInf` con el conjunto inline); `dhat_le` (:48) = `dtilde_le` (:149). | `dhat`; `dtilde` desaparece. |
| Conjunto de distancias | tres `distancias` distintas con el mismo nombre: `Guia3/Ej07.lean:25` (diámetro), `Ej10.lean:24` (punto-conjunto), `Ej11.lean:30` (conjunto-conjunto). | Tres nombres (`distsDiam`, `distsPunto`, `distsPar`) en un módulo. |
| Frontera por bolas | `Guia3/Ej08.lean:41` (en ℝ) y `Ej09.lean:27` (en `E` general); `fronteraCurso_eq` (Ej08:69) = `frontera_eq_sdiff` (Ej09:56). | Una, general. |
| Interior/clausura/abierto/cerrado "del curso" | `Guia3/Ej03.lean:37-47` sólo en ℝ (`interiorCurso`, `clausuraCurso`, `AbiertoCurso`, `CerradoCurso`); `Ej12.lean:34` (`EsAbierto d`, por `bola`). Los puentes de Ej03 (`interior_eq_interiorCurso` :531, `closure_eq_clausuraCurso` :540) **reprueban** `Common.mem_interior_iff_ball` y `mem_closure_iff_ball`. | Generalizar a `[MetricSpace E]` y probar los puentes con `Common`. |
| Convergencia (Def. 7 / 4.42) | `Guia1/Defs.lean:167` (`Converge a l`, ℝ), `Guia2/Ej16.lean:121` (`Converge a`, en ℤ, con `∃ ℓ`), `Guia3/Ej14.lean:39` (`Converge d x l`, métrica cualquiera). Dos puentes `converge_iff_tendsto` paralelos (`Guia1/Defs.lean:186`, `Guia2/Ej16.lean:125`). | `Converge d x l` como la general; la de ℝ es `Converge (fun x y => \|x - y\|)`; la de Ej16 es `∃ ℓ, Converge (cast ∘ a) ℓ`. |
| Cauchy / completo (Def. 4.51, 4.55) | `Guia3/Ej14.lean:35,43` (`EsCauchy d`, `EsCompleto d`); todos los demás usan `CauchySeq`/`CompleteSpace` + `Metric.cauchySeq_iff`. | Mantener las dos (son dialectos) con puente. |
| "Acotado" | `Guia1/Defs.lean:48` (`Acotado : Set ℝ → Prop`, sup e inf) y `Guia3/Ej07.lean:22` (`Acotado : Set E → Prop`, Def. 4.8, diámetro); mismo nombre, nociones distintas, sin lema que las relacione en ℝ. | Renombrar la métrica `AcotadoMet` (o poner namespaces explícitos) y probar `Acotado A ↔ AcotadoMet A` en ℝ. |
| Supremo / ínfimo / máximo / mínimo | `Guia1/Defs.lean:51-60` (`EsSup`, `EsInf`, `EsMax`, `EsMin`); Guía 3 y parciales usan `sSup`/`sInf`/`IsGreatest`. Equivalencias: `equiv_sup`/`equiv_inf` (Defs:114/144) son `csSup_eq_of_forall_le_of_forall_lt_exists_gt` / `csInf_eq_of_forall_ge_of_forall_gt_exists_lt` (`Parcial1_2C2025.lean:38,56`, `Recu1_2C2025.lean:46`); `caract_sup_max` es `IsGreatest.csSup_eq` (`Recu1_2C2025.lean:34-40`). | Los puentes ya están (`esSup_iff_isLUB` es `Iff.rfl`): no hace falta unificar, sí que los parciales agreguen el corolario en dialecto del curso cuando el enunciado dice "hallar sup/máx". |
| `A + B` | `Parcial1_2C2024.lean:20` y `Recu1_1C2025.lean:79` (`sumSet`, **idénticos**); `sSup`/`sInf` del conjunto suma probados en espejo (`ej1` :23-43 y `ej2a` :82-102). | `sumSet`, `sSup_sumSet`, `sInf_sumSet` en la librería de supremos. |
| Cardinales (Def. 3.1, 3.6, 3.8) | `Guia2/Defs.lean:26-50` (`Coordinables`, `CardLe`, `Numerable`, `Contable`, `CardC`); los parciales usan `#A = ℵ₀` / `#A = 𝔠` (`Cardinal.mk_eq_aleph0`, `Cardinal.mk_real`). **No hay puente** entre `CardC A` y `#A = 𝔠`. | Puentes `coordinables_iff_mk_eq`, `cardLe_iff_mk_le`, `numerable_iff_mk_eq_aleph0`, `cardC_iff_mk_eq_continuum`. |
| `𝒫(X) ≃ (X → Bool)` | cinco veces: `Guia2/Ej08.lean:34` (`equivCaracteristica`), `Ej10.lean:223` (`partesEquivFun`), `Ej13.lean:26`, `Ej14.lean:24`, `Ej15.lean:26` (`setEquivBool`). | Una. |
| `ℕ × ℕ ↪ ℕ` | cuatro: `Ej01.lean:147` (`pairEmb`, `2^n 3^m`), `Ej06.lean:40-60` (misma función, otra prueba), `Ej12.lean:42-69` y `Ej16.lean:36-40` (`2^k (2m+1)`, que además es sobreyectiva sobre ℕ₊). | `par` + `par_injective` + `descomposicion` (da `ℕ × ℕ ≃ ℕ₊` sin CSB); `pairEmb` sólo si se quiere el texto del Ej. 1 (c). |
| `ℤ ≃ ℕ` | `Ej01.lean:46-54` (`natEquivInt`) y `Ej16.lean:66` (`codZ`, que es `intToNat`). | Una. |
| Polinomio ↦ (grado, coeficientes) | `Guia2/Ej15.lean:221-245` (`coefs`, en ℝ) y `Parcial1_1C2024.lean:20-30` (`codif`, en ℚ), con `heq_apply` = `sigma_eq_aux`. | Una, sobre `R[X]` con `[Semiring R]`. |
| Sucesiones eventualmente nulas | `Parcial1_1C2025.lean:168` (`X : Set (ℕ →ᵇ ℝ)`) con `continuous_eval_X`, `aN`, `aN_cauchySeq`. | A la librería: es el contraejemplo canónico de no completitud. |

---

## 2. Lemas compartidos (el mismo enunciado, probado más de una vez)

### 2.1 Copias exactas (mismo texto o casi)

| Enunciado | Copias |
|---|---|
| `sumNatEmb : ℕ ⊕ ℕ ↪ ℕ`, `unionEmb : ↥(A ∪ B) ↪ ↥A ⊕ ↥B`, `cardLe_nat_of_contable`, `union_contable` (= Ej. 2), `infinito_union_left`, `exists_C_coordinables`, `pegar`, `diff_coordinables` (= Ej. 3 (b)) | `Guia2/Ej02`, `Ej03`, `Ej04` (y `Ej06.embedding_nat_of_contable`, `Ej07.cardLe_union_sum`) |
| `setEquivBool`, `corte`, `corte_injective`, `corteEmb`, `setRatEquivSetNat`, `cardLe_real_set_nat`, `term`, `term_nonneg`, `term_le`, `summable_geom_succ`, `summable_term`, `tsum_tail_le`, `serie`, `serie_split`, `serie_lt`, `serie_injective`, `serieEmb`, `cardLe_set_nat_real` (18 declaraciones, ~140 líneas) | `Guia2/Ej13`, `Ej14`, `Ej15` (+ variante `Ej10.termino/suma`) |
| `intercalar`, `setProdEquiv`, `cardLe_real_prod_real`, `cardLe_real_real_prod`, `cardC_real_prod`, `cardC_pi`, `cardC_set_nat` (= Ej. 10 (b)) | `Guia2/Ej14`, `Ej15` |
| `exists_mem`, `idx`, `mem_idx` + inyección de la unión (`F_injective` / `G_injective`) | `Guia2/Ej06`, `Ej07` |
| `cardLe_nat_prod_real`; `add_injective` = `sumaEmb` | `Guia2/Ej07`, `Ej15` |
| `d1`, `d2`, `dinf`, `abs_le_dinf` | `Guia3/Ej01`, `Ej12` |
| `ej5a : (interior A)ᶜ = closure Aᶜ` = `compl_interior_eq`; `ej5b` = `compl_closure_eq` | `Guia3/Ej05`, `Ej09` |
| `frontera_eq_inter` = `frontera_eq_inter_closure_compl` (alias interno) | `Guia3/Ej09:45,95` |
| `subset_clausuraCurso` = `Common.subset_closure_ball`; `clausuraCurso_mono` = `closure_mono_ball` | `Guia3/Ej03:98,103` vs `Common.lean:73,79` |
| `Cc = range ((↑) : ℚ → ℝ)` = `Q`; `c_clausura`/`c_interior` ≈ `closure_Q`/`interior_Q` | `Guia3/Ej03:56`, `Ej05:76` |
| Instancia `MetricSpace` discreta, `Disc.dist_eq` = `Rδ.dist_eq` | `Guia3/Ej04:134-160`, `Recu1_2C2025:159-183` |
| `dhat`/`dhat_le` = `dtilde`/`dtilde_le`; `distancias_bddBelow` inline en `dtilde_le` | `Guia3/Ej11:33-48`, `Parcial1_2C2025:145-154` |
| `ext`, `continuous_ext`, `ext_of_mem`, `d1` (integral) | `Parcial1_1C2024:108-120`, `Parcial1_2C2024:217-229` |
| `sumSet` | `Parcial1_2C2024:20`, `Recu1_1C2025:79` |
| `exists_strictMono_of_step` (recursión `choose` + `Nat.rec` + `strictMono_nat_of_lt_succ`) | `Guia1/Ej14:49`, `Ej15:23` |
| `le_two_pow` (`n ≤ 2^n`; una en ℕ, otra en ℝ) | `Guia1/Ej04:56`, `Ej07:64` |
| `strictMono_two_mul`, `_three_mul`, `_two_mul_add_one`, `_three_mul_add_one` (un solo `strictMono_mul_add` las cubre) | `Guia1/Ej16:62-75` |
| `divergeMasInf_id`, `_two_mul`, `divergeMenosInf_neg_id`, `_neg_two_mul` (mismo cuerpo) | `Guia1/Ej09:86-116` |
| `range_a2` = `range_b2` | `Recu1_1C2025:108,117` |
| `ej1' : #A = #ℝ` | `Parcial1_1C2025:75`, `Recu1_1C2025:71` |
| `par_injective` = `Ej12.unicidad`; `codZ_injective` ⊂ `natEquivInt` | `Guia2/Ej16:40,68`, `Ej12:55`, `Ej01:54` |
| `coefs_injective` = `codif_injective`; `heq_apply` = `sigma_eq_aux` | `Guia2/Ej15:225-232`, `Parcial1_1C2024:24-30` |

### 2.2 El mismo hecho, probado en dialectos distintos

| Hecho | Versión curso | Versión Mathlib (parciales / Guía 3) |
|---|---|---|
| Arquímedes "`1/n < r`" | `Guia1.Defs.arquimedes2` (:103) | `Guia3/Ej03.exists_inv_lt` (:402); `exists_nat_gt (c/ε)` inline en `Parcial1_2C2024:163`, `Parcial1_2C2025:42,60`, `Recu1_2C2025:51`, `Guia3/Ej11:260` |
| "`∃ n₀, ∀ n ≥ n₀, M < n`" | `Guia1/Ej09.exists_nat_gt_of_ge` (:79) | inline en los cuatro parciales de arriba |
| `1/(n+1) ≤ 1/(N+1)` para `N ≤ n` | inline `Guia1/Ej13:75-78` | inline `Parcial1_1C2025:250`, `Parcial1_2C2024:115` |
| sup/ínf por cota + aproximación ε | `equiv_sup`/`equiv_inf` | `csSup_eq_of_forall_le_of_forall_lt_exists_gt` y dual |
| máximo = cota que pertenece | `caract_sup_max` | `IsGreatest` + `.csSup_eq` |
| "no hay mínimo" | `¬ ∃ m, EsMin B m` (`Guia1/Ej04:104`) | `0 ∉ A1` (`Recu1_2C2025:64`, `Parcial1_2C2025:72`) |
| `ínf {1/f(n)} = 0` por Arquímedes | `Guia1/Ej04.ej4b_inf` | `Parcial1_2C2025.ej1_sInf`, `Recu1_2C2025.ej1_sInf` |
| `x ∈ cl A ⇔` toda bola corta `A` | `Common.mem_closure_iff_ball` (con `Metric.ball`) | `Metric.mem_closure_iff` (con `dist`) en `Guia3/Ej07,10,11` y `Parcial1_2C2025` |
| `cl` monótona, `A ⊆ cl A` | `closure_mono_ball`, `subset_closure_ball` | `closure_mono`, `subset_closure` en `Guia3/Ej07,11` y tres parciales |
| cerrado ⇔ complemento abierto | `Guia3/Ej04.isClosed_iff_isOpen_compl_ball` | `isOpen_compl_iff` en `Ej09`, `Ej10` |
| `d_∞ ≤ d₂` | `Guia3/Ej12.dinf_le_d2` | `Recu1_1C2025.dist_le_d2` |
| transferencia de completitud por `c·d' ≤ d ≤ C·d'` | `Guia3/Ej14.completo_of_equiv` (atado a `dinf` y a `n`) | `Recu1_1C2025.lipschitz_toRd/ofRd/uniformEquivRd` (:280-316) |
| numerable = contable ∧ infinito; infinito por copia de ℕ | `numerable_iff_contable_infinito` + `infinito_iff_infinite.2 (Infinite.of_injective …)` | `haveI` + `Cardinal.mk_eq_aleph0`; `Infinite.of_injective` + `congrArg Subtype.val` (tres veces igual) |
| cardinal `𝔠` por CSB | `teorema_CSB` | `le_antisymm` + `Cardinal.mk_le_of_injective` + `two_power_aleph0` |
| "subconjunto infinito de un contable tiene ℵ₀" | `Guia2/Ej13.numerable_of_infinito` | `Parcial1_2C2024.mk_eq_aleph0_of_infinite_subset` |
| contable por codificación en Σ-tipo | `Guia2/Ej16.cardLe_sigma_nat` | `Parcial1_2C2025.A2_countable` (vía `Set.countable_iUnion`, lema que `Guia2/Defs` prohíbe) |
| Ej. 11 de la Práctica 2 (partes finitas de numerable) | `Guia2/Ej11.ej11_contable` | `Recu1_2C2025.C_countable` (vía `Set.countable_ofPred_finite_subset`, prohibido en Defs) |

### 2.3 Lemas genéricos que viven en un ejercicio y deberían ser de librería

- **ℝ:** `le_two_pow`, `one_div_two_pow_le` (`Guia1/Ej04`), `sqrt_two_irrational`, `irrational_rat_add/mul` (`Ej02`), `sqrt_add_le` (`Guia3/Ej02:51`), `cauchy_schwarz` (`Guia3/Ej01:60`), `eq_of_forall_abs_sub_lt` (`Guia2/Ej10:75`), `aislado`, `Icc_diff_Ioo_01` (`Guia3/Ej08`), `mem_ball_iff` (bola de ℝ como intervalo, `Guia3/Ej03:71`; reescrito a mano seis veces en Ej05/06/11), `exists_pto`, `exists_rat_pto` (`Ej03:162,174`).
- **Sucesiones:** `exists_strictMono_of_step`, `exists_bound_finite`, `exists_gt_of_not_acotadoSup` (`Guia1/Ej14`), `exists_subseq_far_of_not_converge` (`Ej15`), `converge_of_subseq` (`Ej16`), `decreciente_le` (`Ej12`; mismo esqueleto que `Guia3/Ej16.sub_of_le`), `converge_zero` → `converge_const`, `cotaInf_neg`, `cotaSup_smul` (`Ej06`), `ej5a_acotado`/`ej5a_sup`/… (`Ej05`, son monotonías de cotas con nombre de ejercicio), `abs_dist_sub_dist_le` (`Guia3/Ej13:182`), "Cauchy en `↥A` ⇒ Cauchy en `E`" (dentro de `Guia3/Ej15.ej15`).
- **Topología por bolas:** `isClosed_iff_isOpen_compl_ball`, `isOpen_inter_ball`, `ej4a`-`ej4e` (`Guia3/Ej04`), `closure_interior_subset`, `interior_subset_interior_closure` (`Ej05`), `isOpen_interior_bolas`, `isClosed_closure_bolas`, `frontera_*` (`Ej09`), `closure_subset_of_sep` (`Ej11:167`, con la constante `1/2` que debería ser parámetro), `isOpen_of_subset_interior` (cierre repetido dos veces en parciales).
- **Métricas:** `EsMetrica.max`, `EsMetrica.const_mul` (lo que `Recu1_1C2025.d_*` prueba a mano), `equivalentes_of_le`, `abiertos_iff` (`Guia3/Ej12`), `completo_of_equiv` generalizado, `d2_le_sqrt_mul_dist` (`Recu1_1C2025:248`, la cota fina que `Ej12.d2_le_n_dinf` no tiene), `dist_prod_eq` (`Parcial1_2C2025:200`).
- **Cardinales:** corolarios de una línea que faltan en `Guia2/Defs` y se rehacen en cada ejercicio: `contable_iff_cardLe_nat`, `infinito_of_cardLe`, `infinito_of_cardLe_nat`, `contable_subtype_nat`, `numerable_of_infinito_subset_nat`, `cardLe_rat_nat`, `finito_prod`, `finito_pow`, `cardLt_fin_one_iff`; más los puentes a `Cardinal` de la sección 1.

### 2.4 Lo que está en `Defs`/`Common` y nadie usa

`Guia1/Defs.lean`: los 12 puentes, `esSup_unique`, `esInf_unique`, `esSup_sSup`, `esInf_sInf`, `densidad_Q`, `equiv_sup2`, los cinco `algebra_limites_*`, `convergente_acotada`, `monotona_creciente_converge`, `le_of_strictMono` no los usa ningún ejercicio (son el catálogo de "resultados dados por verdaderos"; queda, pero separado en una sección propia). `Common.bolaCerrada` no la usa nadie. `Common.notMem_closure_iff_ball` sólo Ej06 (Ej05 y Ej09 la re-derivan). `set_option maxHeartbeats 200000` en `Peine.lean:13` es el valor por defecto.

---

## 3. Decisión: cómo organizar las librerías

### 3.1 Principios

1. **Una librería común, un archivo por tema, fuera de las guías.** Hoy `Guias/Guia1/Defs.lean`, `Guias/Guia2/Defs.lean` y `Guias/Common.lean` son tres "Defs" por práctica. Pasan a una `lean_lib` nueva, `Comun`, de la que importan `Guias`, `Parciales` y `Ejemplos`. La dependencia es siempre `Comun ← {Guias, Parciales, Ejemplos}`, nunca al revés.
2. **Se deroga la regla "archivos independientes".** Un `EjNN.lean` importa `Comun.*` y, si hace falta, un ejercicio anterior de la misma práctica (ya pasa en `Guia3/Ej08 → Ej03` y `Ej14 → Ej12`). Nunca uno posterior, nunca uno de otra práctica (lo que una práctica usa de otra, va a `Comun`).
3. **Cuando un lema de `Comun` _es_ un ejercicio**, la prueba vive en `Comun` con nombre descriptivo y docstring "es el Ej. N de la Práctica K; la demostración sigue el texto", y el `EjNN.lean` lo re-enuncia en una línea (`theorem ej2 … := Comun.union_contable …`). La regla de circularidad se mantiene al nivel de `Comun`: esos lemas no se prueban con el lema de Mathlib que es literalmente el resultado (sigue valiendo la lista de prohibidos de los `Defs`).
4. **Dos dialectos conviven, con puente obligatorio.** El del curso (`EsSup`, `Converge`, `Numerable`, `EsMetrica`) para las guías, el de Mathlib (`sSup`, `Tendsto`, `Cardinal.mk`, `MetricSpace`) para los parciales. Cada noción del curso trae en `Comun` su lema `_iff_` con Mathlib; en los parciales, cuando el enunciado pide "hallar sup / máx / cardinal", se agrega el corolario en dialecto del curso (`EsMax A1 (1/2)`, `CardC A`), que es lo que el enunciado dice. No se reescriben los parciales al dialecto del curso: los temas de los parciales (clausuras, completitud, continuidad) necesitan la API de Mathlib, que no tiene análogo en la Guía 1.
5. **`Converge` general.** La canónica es `Converge (d : X → X → ℝ) (x : ℕ → X) (l : X)` (Def. 4.42, hoy `Guia3/Ej14`); la de la Guía 1 es `Converge (fun x y => |x - y|)` y conserva su nombre vía `abbrev`; la de `Guia2/Ej16` es `∃ ℓ, Converge (cast ∘ a) ℓ`. `EsCauchy d`, `EsCompleto d` quedan junto a ella con puentes a `CauchySeq`/`CompleteSpace`.
6. **Nombres.** `Acotado` (métrico, Guía 3) pasa a `AcotadoMet`; las tres `distancias` a `distsDiam`/`distsPunto`/`distsPar`; `dA`/`dC` del Ej. 2 de la Guía 3 a `dA2`/`dC2` (colisión con Ej. 1); las `fronteraCurso` se funden; `dtilde` → `dhat`; `Rδ` → `Disc ℝ`.

### 3.2 Estructura de archivos

```
lean/
  Comun.lean                       umbrella: importa todo lo de abajo
  Comun/
    Reales.lean                    Arquímedes (arquimedes, arquimedes2 = exists_inv_lt), exists_n0_forall_lt,
                                   le_two_pow, one_div_two_pow_le, one_div_succ_antitone, sqrt_add_le,
                                   sqrt_two_irrational, irrational_rat_add/mul, eq_of_forall_abs_sub_lt,
                                   mem_ball_iff (bola de ℝ = intervalo), exists_pto, exists_rat_pto,
                                   Icc_diff_Ioo_01, aislado, cauchy_schwarz
    Supremos.lean                  CotaSup … EsMin + puentes + axioma_completitud, equiv_sup/inf,
                                   caract_sup_max/inf_min, esSup_unique, esSup_sSup, cotaInf_neg,
                                   cotaSup_smul, acotadoSup_mono, esSup_mono (…), sumSet, sSup_sumSet,
                                   sInf_sumSet            [hoy: Guia1/Defs + Ej05/06 + dos parciales]
    Sucesiones.lean                Converge d / EsCauchy d / EsCompleto d, Converge en ℝ, Diverge±∞,
                                   Acotada, Creciente, Decreciente + puentes + unicidad, álgebra de
                                   límites, convergente_acotada, monótonas, equiv_sup2, subsucesiones;
                                   exists_strictMono_of_step, strictMono_mul_add, converge_of_subseq,
                                   exists_subseq_far_of_not_converge, exists_bound_finite,
                                   exists_gt_of_not_acotadoSup, creciente_le/decreciente_le,
                                   converge_const, divergeMasInf_id/const_mul, abs_dist_sub_dist_le,
                                   cauchySeq_subtype          [hoy: Guia1/Defs + Ej09/12/14/15/16, Guia3/Ej13/14]
    Cardinales.lean                Guia2/Defs tal cual + corolarios (contable_iff_cardLe_nat,
                                   infinito_of_cardLe, …) + puentes a Cardinal.mk
    Cardinales/Numerables.lean     natEquivInt, sumNatEmb, unionEmb, union_contable (= P2 Ej. 2),
                                   par/par_injective/descomposicion, codTupla, codSigma,
                                   cardLe_sigma_nat, idx/mem_idx/cardLe_iUnion_prod, contable_iUnion
                                   (= P2 Ej. 6 a), pegar, exists_C_coordinables, codigo (Finset ℕ ↪ ℕ),
                                   partes_finitas_contable (= P2 Ej. 11)
    Cardinales/Continuo.lean       setEquivBool, partesCongr, corte/corteEmb/cardLe_real_set_nat,
                                   bloque serie (una copia) + suma_mem, cardC_set_nat (= P2 Ej. 10 b),
                                   intercalar, setProdEquiv, cardC_real_prod, cardC_pi,
                                   coordinables_real_sum_real, sumaEmb, cardLe_nat_prod_real,
                                   cardLe_*_union_real, cardLe_*_iUnion_real (= P2 Ej. 7),
                                   heq_apply, coefs/coefsEmb sobre R[X]
    Metricas.lean                  EsMetrica, EsMetrica.toMetricSpace (sobre sinónimo `Con d`),
                                   dist_eq rfl, EsMetrica.max, EsMetrica.const_mul, bola, puentes
                                   bola ↔ Metric.ball, EsAbierto, Equivalentes, abiertos_iff,
                                   equivalentes_of_le, completo_of_equiv (general),
                                   completeSpace_of_dist_le_of_le (Lipschitz, para parciales)
    Metricas/Rn.lean               d1, d2, dinf + axiomas (= P3 Ej. 1 b-d) + bolas + cadena
                                   dinf ≤ d2 ≤ d1 ≤ n·dinf, d2 ≤ √n·dinf, dinf_eq_dist,
                                   d2_eq_dist_euclidean, completitud (= P3 Ej. 14)
    Metricas/Discreta.lean         δ, Disc X + instancia + dist_eq, ball_one, closedBall_one,
                                   esMetrica_delta (= P3 Ej. 1 f), bola_delta_le/gt
    Metricas/C01.lean              C01, dC (sup) + lemas + dC_eq_dist (= P3 Ej. 1 e); ext,
                                   continuous_ext, ext_of_mem, d1 (integral), d1_le_dist, E,
                                   dist_prod_eq
    Metricas/EvNulas.lean          X (ℕ →ᵇ ℝ eventualmente nulas), continuous_eval_X, aN,
                                   aN_cauchySeq, no completo
    Topologia.lean                 lo de Common (mem_interior_iff_ball, …) + isClosed_iff_isOpen_compl,
                                   isOpen_inter, isClosed_singleton, isOpen_ball,
                                   closure_ball_subset_ball_of_lt, isClosed_closedBall,
                                   closure_ball_subset_closedBall (= P3 Ej. 4 a-e), compl_interior_eq,
                                   compl_closure_eq (= P3 Ej. 5), interior_inter, closure_union, …
                                   (= P3 Ej. 6), isOpen_interior, isClosed_closure, fronteraCurso +
                                   lemas (= P3 Ej. 9), closure_subset_of_sep (δ), isOpen_of_subset_interior
    Topologia/Curso.lean           interiorCurso, clausuraCurso, AbiertoCurso, CerradoCurso,
                                   acumulacion, derivadoCurso, puentes con Mathlib, mem_*Curso,
                                   not_abierto_of, not_cerrado_of (generalizadas a [MetricSpace E];
                                   las de intervalos quedan en ℝ)
    Topologia/DistConjuntos.lean   AcotadoMet, distsDiam, diam + lemas (= P3 Ej. 7), distsPunto,
                                   distA + lemas (= P3 Ej. 10), distsPar, dhat + lemas (= P3 Ej. 11 a-c)
  Guias/   Guia1/EjNN, Guia2/EjNN, Guia3/EjNN importan Comun.*; Guia1/Defs, Guia2/Defs y
           Common quedan como umbrellas de una línea (import) hasta que nadie los importe, y se borran.
  Parciales/, Ejemplos/   importan Comun.*; usan Disc, dhat, d1/C01, sumSet, EsMetrica.toMetricSpace.
```

`lakefile.toml` agrega `[[lean_lib]] name = "Comun"` y lo pone primero en `defaultTargets`.

### 3.3 Qué queda local (no va a `Comun`)

Todo lo que es dato del enunciado: conjuntos concretos (`Ca…Ch`, `A11/B11`, `B`, `C`, `S`, `𝒜`, `A1`, `A2`, `Omega`, `Primos`, `Conv`, `Per`, …), contraejemplos (`ej6b_ejemplo`, `a2/b2`, `(n, -n)`, `ej4f_bool`), métricas del enunciado de un parcial (`Recu1_1C2025.d`, `Parcial1_1C2024.d`, `Peine.d`; pasan a construirse con `EsMetrica.toMetricSpace` pero siguen en su archivo), las ~60 verificaciones de veredictos de `Guia3/Ej03` y `Ej08`, `Guia2/Ej05` entero, el bloque de desarrollos binarios de `Guia2/Ej10` (salvo `eq_of_forall_abs_sub_lt`), `Guia2/Ej17` (`L`/`R`, es análisis de funciones monótonas), `Guia1/Ej13.paso` y la recursión de `ej13`, `Ej02.ej2a` con `Nat.find` (es el ejercicio).

### 3.4 Orden de ejecución (un PR por paso, `lake build` verde y `#print axioms` estándar en cada uno)

| Paso | Qué | Líneas que se van | Riesgo |
|---|---|---|---|
| 0 | Crear `Comun` moviendo `Guia1/Defs`, `Guia2/Defs`, `Common` sin cambiar enunciados; umbrellas de compatibilidad. | 0 | nulo (sólo rutas) |
| 1 | Guía 2: `Numerables` y `Continuo`; Ej. 2/3/4, 6/7, 13/14/15 pasan a importar. Corolarios y puentes a `Cardinal`. | ~900 | bajo: son copias textuales |
| 2 | Guía 3: `Rn`, `Discreta`, `C01`, `Topologia`, `Curso`, `DistConjuntos`; Ej. 3 usa los puentes de `Common` en vez de reprobarlos. | ~400 | medio: renombres y generalización ℝ → `E` |
| 3 | Guía 1: lemas de `Sucesiones` y `Reales`; `Converge` general con `abbrev`. | ~100 | bajo |
| 4 | Parciales y Peine: `Disc ℝ`, `dhat`, `C01.d1`, `sumSet`, `EsMetrica.toMetricSpace`, puentes a `Cardinal`; corolarios en dialecto del curso. | ~100 | bajo; el ejercicio formalizado no cambia |

Cada paso termina actualizando `lean/README.md` (tabla de módulos de `Comun`) y los encabezados de los `EjNN.lean` que cambian.

---

## 4. Consecuencia para la forma de trabajar con agentes

El instructivo de las próximas guías (y de cualquier re-resolución) cambia en dos líneas: (a) "leé `Comun.lean` y usá lo que ya está; si necesitás un lema genérico nuevo, escribilo en el módulo de `Comun` que corresponda y decilo en el reporte"; (b) "podés importar ejercicios anteriores". El riesgo de que dos agentes editen el mismo archivo de `Comun` se maneja como ahora con los `Defs`: el lead escribe `Comun` antes de lanzar, y los agentes proponen agregados en el reporte en vez de editar.

---

## 5. Respuestas a las dos preguntas

### 5.1 ¿Existe una "estructura" de demostración que se repita en varios lugares?

Sí. Doce, y casi todas cruzan guías y parciales (la misma estructura aparece en el dialecto del curso y en el de Mathlib):

1. **ε-n₀ con n₀ de Arquímedes y la cuenta exacta** `|a_n − ℓ| = c/(n+1)`: P1 Ej. 7 y 13; `Parcial1_2C2024.ej3`; `Recu1_2C2025.ej4b` (negada); `Guia3/Ej11`. Esqueleto: `intro ε hε; obtain ⟨n₀, _⟩ := arquimedes (c/ε); refine ⟨n₀, fun n hn => ?_⟩; cuenta; div_lt_iff₀; linarith`.
2. **ε/2 + ε/2 con `n₀ = max n₁ n₂`** (o `δ = min`): P1 Ej. 9 (a-c), 16 (a); `Guia3/Ej13`, `Ej14` (`Finset.univ.sup`); `Parcial1_2C2025.ej5` y `Parcial1_2C2024.ej4` (continuidad).
3. **Por el absurdo con el ε "que falta"** (`ε = (ℓ₁ − ℓ₂)/2`, `ε = x − y`): P1 Ej. 1, 10; cierre `le_of_forall_pos_lt_add` en `Recu1_1C2025.ej2a`, `Guia3/Ej10`.
4. **Construcción recursiva de índices**: `choose` + `Nat.rec` + `strictMono_nat_of_lt_succ` (P1 Ej. 13, 14, 15; `Guia3/Ej16`; `Guia2/Ej17`).
5. **sup/ínf de un conjunto concreto en tres pasos**: no vacío, cota, aproximación ε con Arquímedes; máximo por pertenencia. En el curso: `caract_sup_max` / `equiv_sup` + `arquimedes2` (P1 Ej. 4, 12, 13); en Mathlib: `csSup_eq_of_forall_le_of_forall_lt_exists_gt` + `exists_nat_gt` (`Parcial1_2C2025.ej1`, `Recu1_2C2025.ej1`); en la Guía 3 con los wrappers `dist_le_diam`/`le_distA`/`dhat_le`.
6. **Métrica nueva**: 4 campos (`nonneg`, `eq_zero_iff`, `symm`, `triangle`), triangular por casos cuando hay un `if` (`by_cases hxz; ite_eq_left/right; split_ifs <;> linarith`) o por `max_le` cuando es un máximo; sinónimo de tipo + `instance : MetricSpace` + `dist_eq` por `rfl`; luego describir la bola con `ext` + aritmética. Guía 3 Ej. 1, 2, 4, 11; `Parcial1_1C2024`, `Recu1_1C2025`, `Recu1_2C2025`, `Peine`.
7. **Abierto**: `Metric.isOpen_iff` y la bola de radio `r − d(y, x)` con la triangular (`Guia3/Ej04/09/10/12`). **Cerrado**: por complemento abierto, por `cl S ⊆ S` + `Subset.antisymm _ subset_closure`, o por sucesiones (`IsClosed.mem_of_tendsto`). Las tres variantes en Guía 3 y en los seis parciales.
8. **"x ∈ clausura ⇔ toda bola corta"** con un punto a distancia ε/2 o ε/3 y la triangular (`Guia3/Ej04/05/06/07/10/11`, `Parcial1_2C2025.ej4b`). Versión ℝ: la bola es un intervalo y el punto es `1 ± r/2` (seis veces a mano).
9. **Puente curso ↔ Mathlib**: `def XCurso` por bolas + `theorem x_eq_XCurso` + veredictos `_mathlib` (`Guia3/Ej03`, `Ej08`), y los `_iff_` de `Guia1/Defs` y `Guia2/Defs`.
10. **Dos inyecciones + CSB**: `teorema_CSB ⟨f⟩ ⟨g⟩` en P2 Ej. 1 (d), 7, 10, 13, 14, 15; `le_antisymm (Cardinal.mk_le_of_injective …) (…)` en `Parcial1_2C2024.ej2`, `Recu1_1C2025.ej1`.
11. **Contable por codificación inyectiva en ℕ** (`2^a 3^b`, `2^k (2m+1)`, `Σ 2^k`, Σ-tipo con `Sigma.mk.inj_iff` + `eq_of_heq`) y **numerable = contable ∧ infinito**, con infinito por copia de ℕ (`Infinite.of_injective` + `congrArg Subtype.val`): P2 Ej. 1, 6, 11, 12, 15, 16; los cuatro parciales con `#A = ℵ₀`.
12. **Contraejemplo**: conjunto o sucesión concreta + lema de valores (`range_a2 = {1, 0}`, `(fun n => n + -n) = fun _ => 0` por `funext; ring`) + `norm_num`/`linarith` (P1 Ej. 4, 9 (d); Guía 3 Ej. 2, 4 (f), 6, 11; `Parcial1_1C2025.ej2b`, `Recu1_1C2025.ej2b`, `Recu1_2C2025.ej3b`).

Lo que **no** se repite y es específico de un lugar: el argumento diagonal (no aparece en ningún archivo: la no numerabilidad de ℝ se toma de Mathlib), los desarrollos binarios (P2 Ej. 10), las discontinuidades de una monótona (P2 Ej. 17), la "carpeta" para refutar continuidad en `d₁` (`Parcial1_2C2024.ej4_reciproca_falsa`), el punto fijo del anexo de P1.

### 5.2 ¿Existe un patrón claro para resolver los ejercicios? (parciales)

Sí, y es más rígido que en las guías. Los seis primeros parciales (1C 2024, 2C 2024, 1C 2025 y su recuperatorio, 2C 2025 y su recuperatorio) tienen **cuatro casilleros fijos**:

| Casillero | Frecuencia | Enunciados | Guía que lo entrena |
|---|---|---|---|
| **A. Cardinal de un conjunto concreto** | 6/6 | ℚ[x] y algebraicos; `{B ⊆ ℚ : #B = #(ℚ∖B)}`; sucesiones enteras con pasos 1/2; con `aₙ ∣ aₙ₊₁`; racionales con `a_{n+k} = a_kⁿ`; `f : ℚ → ℕ` casi constantes | P2 (Ej. 1, 6, 7, 11, 13, 15, 16) |
| **B. Supremo / ínfimo** | 5/6 | concreto (`{m/(m+n)}`, `{1/(n²−8n+18)}`) o propiedad "V o F" con contraejemplo (`ínf(A+B)`, `ínf A = ínf cl A` V / `= ínf A°` F, `sup(A+B)`, sup de sucesiones) | P1 (Ej. 4, 5, 6) |
| **C. Topología general en un espacio métrico, casi siempre "V o F"** | 6/6 | `f(cl A) = cl f(A)` con compacto; encajados ⇒ completo; `U` abierto ⇔ `U ∩ cl T ⊆ cl(U ∩ T)`; denso y abierto; separación con clausuras disjuntas; `A ∩ cl B ≠ ∅ ⇒ A ∩ B ≠ ∅`; continua ⇔ `f⁻¹(B°) ⊆ (f⁻¹B)°` | P3 (Ej. 4, 5, 6, 9, 10, 11, 15) |
| **D. Métrica concreta: bolas, completitud, continuidad** | 5/6 | `(ℝ, d)` con `d = \|x\|+\|y\|` completo; `max{4/3 d_∞, d₂}` + bola + completo; `√(\|x₁−x₂\|² + δ²)` + bola + convergencia; sucesiones eventualmente nulas no completo; `Ψ` uniformemente continua `d_∞ → d₁`; evaluación continua en `C[0,1] × [0,1]` | P3 (Ej. 1, 2, 12, 13, 14, 16) |

Guiones por casillero (los pasos que aparecen siempre):

- **A (cardinal).** (1) Cota superior: inclusión en un tipo de cardinal conocido o codificación inyectiva (`#A ≤ #(ℕ → ℤ)`, polinomio ↦ coeficientes, función ↦ gráfico finito). (2) Cota inferior: copia de ℕ (constantes) para ℵ₀; de `ℕ → Bool` o `𝒫(ℕ)` para 𝔠. (3) Cierre: `Cardinal.mk_eq_aleph0` (contable + infinito) o CSB. La tabla 2.2 muestra que los pasos (1) y (2) hoy se prueban con lemas de Mathlib que `Guia2/Defs` prohíbe en las guías (`mk_set`, `countable_iUnion`, `countable_ofPred_finite_subset`); con `Comun/Cardinales` se reemplazan por los ejercicios 10, 16 y 11 de la P2.
- **B (sup/ínf).** Concreto: no vacío → cota → aproximación ε con Arquímedes → máximo/mínimo por pertenencia o `x ∉ A`. "V o F": si es V, `le_antisymm` con `le_csSup`/`csSup_le` + `le_of_forall_pos_lt_add`; si es F, un conjunto de dos piezas (`{0} ∪ [1,2]`, `{0}` y `(0,1)`, `(1,0,0,…)` y `(−1,0,0,…)`) y `norm_num`.
- **C (topología general).** Un solo lema de Mathlib hace el trabajo (`IsOpen.inter_closure`, `closure_minimal`, `closure_mono`, `preimage_interior_subset_interior_preimage`, `Metric.closure_ball_subset_closedBall`) más el cierre `interior_eq_iff_isOpen.1 (subset_antisymm interior_subset h)`. En el papel, es siempre "tomar `x ∈ cl`, una bola, un punto en la intersección, triangular" (estructura 8).
- **D (métrica concreta).** `def d` → 4 axiomas (estructura 6) → sinónimo + instancia → `dist_eq` → bola explícita por `ext`; completitud por transferencia desde `d_∞` (`c·d_∞ ≤ d ≤ C·d_∞`, Lipschitz en los dos sentidos) o por dicotomía "eventualmente constante / tiende a 0"; no completitud con la sucesión de Cauchy `aN` (truncadas de `1/n`) y pasar a coordenadas; continuidad con ε-δ + `d₁ ≤ d_∞` (`d1_le_dist`) o con una cota Lipschitz (`d1 (Ψ f) (Ψ g) ≤ dist f g / 2`).

Dos observaciones que salen de cruzar guías y parciales:

- **La forma dominante del parcial es "V o F con contraejemplo"** (casilleros B y C), y es la que las guías menos practican: en P1 sólo el Ej. 9 (d), en P3 los Ej. 2, 6 (b)(d) y 11 (c)(d). Si hay que agregar ejercicios de entrenamiento, es ahí.
- **Cada casillero se apoya en tres o cuatro lemas de librería** que hoy no existen como tales: A en `cardC_set_nat`, `cardLe_sigma_nat`, `partes_finitas_contable` y los puentes a `Cardinal`; B en `sSup_sumSet`/`sInf_sumSet` y `equiv_sup`/`equiv_inf`; C en los lemas por bolas de `Topologia`; D en `EsMetrica.toMetricSpace`, `Disc`, `Rn`, `C01.d1`, `completeSpace_of_dist_le_of_le`, `EvNulas.aN`. Eso es exactamente la lista de `Comun` de la sección 3.2: la librería compartida no es sólo deduplicación, es el "kit" con el que se resuelve un parcial.

---

## 6. Fuentes de esta nota

Cuatro relevamientos exhaustivos (uno por bloque: parciales + Peine; Guía 3 + Common; Guía 2; Guía 1), cada uno con catálogo de definiciones y lemas con archivo:línea, más una pasada mecánica sobre los nombres de declaración repetidos (`grep` de `def|theorem|instance` en los 60 archivos). Los números de línea son los de `main` tras el PR #13.

---

## 7. Estado de ejecución (7 de octubre de 2026, mismo PR)

Los cinco pasos de la sección 3.4 están hechos, un commit por paso (`Lean, paso 0` … `paso 4`),
con `lake build` completo sin errores ni warnings y `#print axioms` estándar en los 786 teoremas
del proyecto después de cada uno. Enunciados y nombres de los `ejN…` sin cambios (salvo los
renombres anunciados: `dA2`/`dC2` en Guía 3 Ej. 2 y `AcotadoMet`).

| Carpeta | Antes (`main`) | Después | Nota |
|---|---|---|---|
| `Comun/` (15 módulos) | 615 (los tres `Defs`/`Common`) | 4026 | incluye puentes, generalizaciones, `EvNulas`, docstrings |
| `Guias/Guia1/` | 1664 | 1165 | |
| `Guias/Guia2/` | 3112 | 1499 | |
| `Guias/Guia3/` | 3037 | 1889 | |
| `Parciales/` | 1672 | 1613 | más 22 corolarios `_curso` nuevos |
| `Ejemplos/` | 111 | 112 | instancia vía `EsMetrica.toMetricSpace` |
| **Ejercicios + parciales + ejemplos** | **9129** | **6278** | **−2851** |
| Total `lean/` | 9744 | 10376 | la librería creció más de lo que se borró: es el "kit" de la sección 5.2 |

Desvíos respecto de la sección 3.2: `mem_ball_iff`, `exists_pto`, `exists_rat_pto`, `Icc_diff_Ioo_01`,
`aislado`, `sqrt_add_le` quedaron en `Comun/Topologia/Real.lean` (no en `Reales`); `cauchy_schwarz`
en `Metricas/Rn.lean`; `EsCauchy`/`ConvergeMet`/`EsCompleto` en `Metricas.lean` (no en
`Sucesiones`), con el puente `converge_iff_convergeMet`; los lemas de los ítems de P3 Ej. 4 y 6
llevan sufijo `_bolas` para no chocar con Mathlib; `dist_prod_eq` vive en `Comun.C01`;
`Recu1_1C2025.dist_le_d2`/`d2_le_sqrt_mul_dist` llevan un `cases n` porque `dinf` pide `[NeZero n]`
y las firmas del parcial no. Las cajas *Observación* de las tres guías resueltas citan los lemas de
`Comun`; los `.typ` de los parciales no cambian porque los nombres que citan se conservaron.
