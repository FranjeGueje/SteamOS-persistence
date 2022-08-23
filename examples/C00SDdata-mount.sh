#! /bin/bash
# Chequea el estado de fstab para comprobar las particiones montadas al arrancar.
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com>
# ABOUT: Chequea el estado de fstab para comprobar las particiones montadas.
# REQUISITOS: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit
##############################################################################################################################################################


# Vemos si el actual fstab
cat /etc/fstab
