#! /bin/bash
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

# Devolvemos la copia de fstab a su sitio
sudo steamos-readonly disable
sudo cp -f "$BACKUPS/fstab.bak" /etc/fstab
sudo steamos-readonly enable

