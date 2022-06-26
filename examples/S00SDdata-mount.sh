#! /bin/bash
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

UUID=ElValorDeLaParticionBTRFS
PARTICION="/dev/disk/by-uuid/$UUID"

function addToFstab()
{
    # Comprobamos si es la primera vez que ejectamos este script, o lo que es lo mismo, que nuestra unidad btrfs no tiene ningún fichero
    mkdir /tmp/deck-btrfs && sudo mount "$PARTICION" /tmp/deck-btrfs -t btrfs -o noatime,lazytime,compress-force=zstd:6,space_cache=v2,autodefrag
    # Si el punto de montaje tiene cero ficheros entonces copiamos el contenido de home deck al disco nuevo
    sudo find /tmp/deck-btrfs -type f | sudo wc -l && echo "La partición está vacía, se procede a la copia." && \
	    sudo cp -a /home/deck/. /tmp/deck-btrfs
    sudo umount /tmp/deck-btrfs
    
    # Hacemos copia del fichero a modificar
    cp /etc/fstab "$BACKUPS"/fstab.bak -f
    # Añadimos la línea al fstab
    sudo steamos-readonly disable
    echo -e "UUID=$UUID     /home/deck    btrfs   noatime,lazytime,compress-force=zstd:6,space_cache=v2,autodefrag 0 0" | sudo tee -a /etc/fstab
    sudo steamos-readonly enable
    # Recargar los demonios no haría falta, mejor sería reiniciar
    # sudo systemctl daemon-reload
    echo "Actualizado, se recomienada reiniciar."
}

# Vemos si el actual fstab tiene el punto de montaje btrfs, si no, llama a la funcion para ponerlo
grep /home/deck < /etc/fstab | grep btrfs || echo "Es necesario añadir al fstab la partición /home/deck" && addToFstab
