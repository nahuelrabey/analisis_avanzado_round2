# Propuesta: correcciones de la revisión crítica de `guia_3_resuelta_agente.typ`

¿Afecta a alguna SKILL? No: sólo toca `apuntes-typst/guias-agente/guia_3_resuelta_agente.typ`
(archivo escrito por el agente) y los `lean/Guias/Guia3/EjNN.lean`.

Hallazgos sobre las fuentes permitidas (apuntes.typ + enunciados de guías 1-2):

1. Ej. 1 (e): se usa el teorema de Weierstrass (valores extremos), que no está en `apuntes.typ`
   ni en las guías 1-2. Se deja declarado como presupuesto del enunciado (que escribe "máx").
2. Ej. 3, Lema 4 y (e): la parte entera se justificaba con "Arquímedes y buen orden de ℕ"; se
   reemplaza por la Práctica 1, Ej. 2 (a) (entero entre `x` e `y` cuando `y - x > 1`).
3. Ej. 5 (pregunta final): el irracional se construía "a mano" con `√2 ∉ ℚ`; se cita la Práctica 1,
   Ej. 2 (d), como en el Ej. 3.
4. Ej. 11 (c): se citaba el Teorema 1 (`x ≤ n`) para obtener `1/n < ε`; lo correcto es la
   Proposición 1 (`0 < 1/n < y`).
5. Cabecera: se explicita qué hechos de base (orden y aritmética de ℝ, ℤ, ℕ) se usan sin cita.

Más las correcciones que surjan de la auditoría de los archivos Lean. Esta propuesta se borra al
implementarse.
