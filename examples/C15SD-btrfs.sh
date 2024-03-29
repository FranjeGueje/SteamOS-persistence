#!/bin/bash
# Muestra las diferencias entre los ficheros utilizados para el tratamiento de las microSD y de los que hicimos copia.
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com> en colaboración con https://github.com/Trevo525/btrfdeck
# ABOUT: Muestra las diferencias entre los ficheros utilizados para el tratamiento de las microSD y de los que hicimos copia.
# REQUISITOS: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit
##############################################################################################################################################################


# FROM https://github.com/Trevo525/btrfdeck . Todos los aplausos para Trevo525

# Si la variable que usa el programa no está creada, se crea con los valores por defecto
[ -z "$BACKUPS" ] && BACKUPS="/home/.SteamOS-persistence.d/backup"

echo "### Comprobamos las diferencias entre los ficheros actuales y los originales ###"
echo -ne "\n\n*** Diferencias de sdcard-mount.sh entre el que tiene SteamOS y nuestro Backup ***\n____________________________________________________________________________\n\n"
diff /usr/lib/hwsupport/sdcard-mount.sh "$BACKUPS"/sdcard-mount.sh

echo -ne "\n\n\n\n*** Diferencias de format-sdcard.sh entre el que tiene SteamOS y nuestro Backup ***\n______________________________________________________________________________\n\n\n"
diff /usr/lib/hwsupport/format-sdcard.sh "$BACKUPS"/format-sdcard.sh
