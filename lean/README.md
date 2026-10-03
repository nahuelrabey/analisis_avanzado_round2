# Verificación en Lean de los parciales

Proyecto Lean 4 + Mathlib con una formalización de cada ejercicio de los parciales
transcriptos en `apuntes-typst/parciales/`:

| Examen | Transcripción y resolución | Archivo Lean |
|---|---|---|
| Primer parcial 1C 2025 (08/05/2025) | `apuntes-typst/parciales/2025_1c_parcial_1.typ` | `Parciales/Parcial1_1C2025.lean` |
| Primer recuperatorio 1C 2025 (08/07/2025) | `apuntes-typst/parciales/2025_1c_recuperatorio_1.typ` | `Parciales/Recu1_1C2025.lean` |

Cada resolución escrita en el `.typ` termina con una caja *Observación* que indica qué teorema
del archivo Lean la certifica y en qué difiere la formalización de la escritura a mano.

## Compilar

```sh
# una sola vez: instalar elan (gestor de toolchains de Lean)
curl -sSf https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh | sh -s -- -y

cd lean
lake exe cache get   # baja los .olean de Mathlib (varios GB); evita compilarla
lake build           # compila Parciales/*.lean; termina sin errores ni warnings
```

Para comprobar que ninguna demostración usa `sorry` ni axiomas no estándar:

```lean
import Parciales
#print axioms Parcial1_1C2025.ej1   -- [propext, Classical.choice, Quot.sound]
```

## Convenciones

- Las sucesiones del curso empiezan en `n = 1`; en Lean los índices empiezan en `0`
  (`a_n` del curso es `a (n-1)` en Lean). Ningún argumento depende de esto.
- `ℝⁿ` es `Fin n → ℝ`, que en Mathlib trae la métrica `d_∞`; `d_2` se transporta desde
  `EuclideanSpace ℝ (Fin n)`.
- El espacio `X` de sucesiones eventualmente nulas (parcial 1, ej. 4) se modela como
  subconjunto de `ℕ →ᵇ ℝ` (funciones acotadas, con la métrica del supremo).
