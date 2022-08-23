#!/bin/bash
# Instala sólo un script para montar btrfs en las tarjetas SD. NO FORMATEA EN BTRFS!
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com> en colaboración con https://github.com/Trevo525/btrfdeck
# ABOUT: Instala los scripts para usar btrfs en las tarjetas SD
# REQUISITOS: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit
##############################################################################################################################################################


# FROM https://github.com/Trevo525/btrfdeck . Todos los aplausos para Trevo525

# Si la variable que usa el programa no está creada, se crea con los valores por defecto
[ -z "$DIRECTORIO" ] && DIRECTORIO="/home/.SteamOS-persistence.d"
[ -z "$BACKUPS" ] && BACKUPS="$DIRECTORIO/backup"

echo "### Copiando los archivos actuales..."
cp /usr/lib/hwsupport/sdcard-mount.sh "$BACKUPS/sdcard-mount.sh-$(date +"%d-%m-%y-%r")" # Copia por histórico
cp /usr/lib/hwsupport/sdcard-mount.sh "$BACKUPS/sdcard-mount.sh"
echo "### Deshabilitamos sólo lectura..."
sudo steamos-readonly disable
echo "### Borramos los archivos actuales..."
sudo rm /usr/lib/hwsupport/sdcard-mount.sh
echo "### Copiamos los nuevos ficheros..."
sudo cp "$DIRECTORIO"/btrfdeck/modified/sdcard-mount.sh /usr/lib/hwsupport/sdcard-mount.sh
echo "### Asignamos permisos..."
sudo chmod 755 /usr/lib/hwsupport/sdcard-mount.sh
echo "### Habiltamos el sólo lectura de nuevo..."
sudo steamos-readonly enable
echo "Done!"

