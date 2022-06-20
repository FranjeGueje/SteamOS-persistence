#! /bin/bash
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

function addToFstab()
{
    cp /etc/fstab "$BACKUPS"/fstab.bak -f
    sudo echo -e "/dev/nvme0n1p9     /home/deck/SD-Data    btrfs   noatime,lazytime,compress-force=zstd:6,space_cache=v2,autodefrag 0 2" >> /dev/null
    sudo systemctl daemon-reload
}

# Vemos si el actual fstab tiene el punto de montaje btrfs, si no, llama a la funcion para ponerlo
grep /home/deck/SD-Data < /etc/fstab || addToFstab

