#!/bin/bash
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com> en colaboración con https://github.com/Trevo525/btrfdeck
# ABOUT: Muestra las diferencias entre los ficheros utilizados y los del backup.
# REQUISITOS: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit
##############################################################################################################################################################


# FROM https://github.com/Trevo525/btrfdeck . Todos los aplausos para Trevo525

echo "### Comprobamos las diferencias entre los ficheros actuales y los originales ###"
echo "* Diff de sdcard-mount.sh *"
diff /usr/lib/hwsupport/sdcard-mount.sh "$BACKUPS"/sdcard-mount.sh

echo "* Diff de format-sdcard.sh "
diff /usr/lib/hwsupport/format-sdcard.sh "$BACKUPS"/format-sdcard.sh
