#! /bin/bash
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

grep "#es_ES.UTF-8 UTF-8" < /etc/locale.gen && echo "¡Se encuentra locale comentado!"

grep "es_ES.UTF-8 UTF-8" < /etc/locale.gen | grep -v '#' && echo "¡Se encuentra activo!"

