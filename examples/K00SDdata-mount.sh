#! /bin/bash
# Restauramos el archivo fstab antes de que se ejecutara el script.
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com>
# ABOUT: Restauramos el archivo fstab antes de que se ejecutara el script.
# REQUISITOS: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit
##############################################################################################################################################################


# Si la variable que usa el programa no está creada, se crea con los valores por defecto
[ -z "$BACKUPS" ] && BACKUPS="/home/.SteamOS-persistence.d/backup"

# Devolvemos la copia de fstab a su sitio
sudo steamos-readonly disable
sudo cp -f "$BACKUPS/fstab.bak" /etc/fstab
sudo steamos-readonly enable
