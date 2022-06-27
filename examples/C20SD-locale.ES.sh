#! /bin/bash
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com>
# ABOUT: Chequea los locale dentro del fichero locale.gen (comentados y activos).
# REQUISITOS: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit
##############################################################################################################################################################


# Buscamos los locale comentados
grep "#es_ES.UTF-8 UTF-8" </etc/locale.gen && echo "¡Se encuentra locale comentado!"

# Buscamos los locale activos
grep "es_ES.UTF-8 UTF-8" </etc/locale.gen | grep -v '#' && echo "¡Se encuentra activo!"
