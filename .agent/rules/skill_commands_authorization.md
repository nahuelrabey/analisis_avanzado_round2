# Autorización Directa para Comandos de Skills

La invocación explícita por parte del usuario de cualquier comando de skill (por ejemplo, `/guia`, `/desafio`, `/apunte`, `/ejemplo`, `/galerazo`) cuenta como **autorización explícita** para crear, modificar e implementar directamente el contenido en los archivos del repositorio requeridos por dicha skill (como `apuntes-typst/guias/p{N}.typ`, `apuntes-typst/desafios.typ`, `apuntes-typst/apuntes.typ`, `apuntes-typst/ejemplos.typ`, `apuntes-typst/galerazos.typ`), sin requerir confirmaciones adicionales ni pedir la palabra clave "implementá".

## Excepción: `/corregir`

`/corregir` es una skill de **chat puro** y no tiene archivo destino. Invocarla **no** autoriza a escribir ni modificar nada, y tampoco corresponde ofrecer hacerlo al cerrar la corrección. Para volcar el resultado a un `.typ`, el usuario invoca por su cuenta `/guia`, `/ejemplo` o `/galerazo`.
