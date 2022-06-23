#!/bin/bash
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

# FROM https://github.com/Trevo525/btrfdeck

echo "Temporarily disabling readonly filesystem..."
sudo steamos-readonly disable
echo "Removing current files..."
sudo rm /usr/lib/hwsupport/sdcard-mount.sh
sudo rm /usr/lib/hwsupport/format-sdcard.sh
echo "Return original files..."
sudo cp "$BACKUPS"/sdcard-mount.sh /usr/lib/hwsupport/sdcard-mount.sh
sudo cp "$BACKUPS"/format-sdcard.sh /usr/lib/hwsupport/format-sdcard.sh
echo "Editing new file permissions..."
sudo chmod 755 /usr/lib/hwsupport/sdcard-mount.sh /usr/lib/hwsupport/format-sdcard.sh
echo "Re-enabling readonly filesystem..."
sudo steamos-readonly enable
echo "Done!"

