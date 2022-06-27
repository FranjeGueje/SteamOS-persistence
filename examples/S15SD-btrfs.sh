#!/bin/bash
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com> en colaboración con https://github.com/Trevo525/btrfdeck
# ABOUT: Chequea el estado de fstab para comprobar las particiones montadas
# REQUISITOS: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit
##############################################################################################################################################################


# FROM https://github.com/Trevo525/btrfdeck . Todos los aplausos para Trevo525

echo "Backing up current files..."
cp /usr/lib/hwsupport/sdcard-mount.sh "$BACKUPS"/sdcard-mount.sh
cp /usr/lib/hwsupport/format-sdcard.sh "$BACKUPS"/format-sdcard.sh
echo "Temporarily disabling readonly filesystem..."
sudo steamos-readonly disable
echo "Removing current files..."
sudo rm /usr/lib/hwsupport/sdcard-mount.sh
sudo rm /usr/lib/hwsupport/format-sdcard.sh
echo "Copying modified files..."
sudo cp "$DIRECTORIO"/btrfdeck/modified/sdcard-mount.sh /usr/lib/hwsupport/sdcard-mount.sh
sudo cp "$DIRECTORIO"/btrfdeck/modified/format-sdcard.sh /usr/lib/hwsupport/format-sdcard.sh
echo "Editing new file permissions..."
sudo chmod 755 /usr/lib/hwsupport/sdcard-mount.sh /usr/lib/hwsupport/format-sdcard.sh
echo "Re-enabling readonly filesystem..."
sudo steamos-readonly enable
echo "Done!"
