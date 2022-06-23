#! /bin/bash
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

# Devolvemos la copia de fstaba a su sitio
sudo cp -f "$BACKUPS/fstab.bak" /etc/fstab

