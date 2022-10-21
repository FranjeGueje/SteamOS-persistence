#! /bin/bash
# Chequea los locale dentro del fichero locale.gen (comentados y activos).
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com>
# ABOUT: Chequea los locale dentro del fichero locale.gen (comentados y activos).
# REQUISITOS: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit
##############################################################################################################################################################


# Buscamos los locale comentados
echo "### Buscamos los locale comentados ###"
grep "#es_ES.UTF-8 UTF-8" </etc/locale.gen && echo "Se encuentra locale es_ES comentado... :,( "

# Buscamos los locale activos
echo -e "\n### Buscamos los locale activos ###"
grep "es_ES.UTF-8 UTF-8" </etc/locale.gen | grep -v '#' && echo -ne "¡Se encuentra locale es_ES activo! :)\n\nPero recuerda que para que funcione también debe de estar instalado un paquete glibc.\n"

# Comprobamos que el idioma del sistema sea por defecto español
echo -e "El idioma del sistema es: $(cat /etc/locale.conf)"
