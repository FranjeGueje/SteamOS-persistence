#! /bin/bash
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com>
# ABOUT: Añade al fstab la partición indicada en la variable UUID (recuerda editarla en este fichero).
# REQUISITOS: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit
##############################################################################################################################################################


# Si la variable que usa el programa no está creada, se crea con los valores por defecto
[ -z "$BACKUPS" ] && BACKUPS="/home/.SteamOS-persistence.d/backup"

UUID=ElValorDeLaParticionBTRFS
PARTICION="/dev/disk/by-uuid/$UUID"
TEMP=/tmp/deck-btrfs

function addToFstab()
{
    # Comprobamos si es la primera vez que ejectamos este script, o lo que es lo mismo, que nuestra unidad btrfs no tiene ningún fichero
    mkdir "$TEMP"
    sudo mount "$PARTICION" "$TEMP" -t btrfs -o noatime,lazytime,compress-force=zstd:6,space_cache=v2,autodefrag
    # Si el punto de montaje tiene cero ficheros entonces copiamos el contenido de home deck al disco nuevo
    [ -z "$(ls -A "$TEMP")" ] && echo -e "\n### La partición está vacía, se procede a la copia. ###" &&  sudo cp -a /home/deck/. "$TEMP"
    sudo umount "$TEMP"
    
    # Hacemos copia del fichero a modificar
    cp /etc/fstab "$BACKUPS"/fstab.bak -f
    # Añadimos la línea al fstab
    sudo steamos-readonly disable
    echo -e "UUID=$UUID     /home/deck    btrfs   noatime,lazytime,compress-force=zstd:6,space_cache=v2,autodefrag 0 0" | sudo tee -a /etc/fstab
    sudo steamos-readonly enable
    # Recargar los demonios no haría falta, mejor sería reiniciar
    # sudo systemctl daemon-reload
    echo -e "\n### Actualizado el fichero de montajes, se recomienada reiniciar. ###"
}

# Vemos si el actual fstab tiene el punto de montaje btrfs, si no, llama a la funcion para ponerlo
grep "/home/deck" < /etc/fstab | grep btrfs || echo "### Es necesario añadir al fstab la partición /home/deck ###" && addToFstab

