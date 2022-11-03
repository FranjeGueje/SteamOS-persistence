#! /bin/bash
# Añade al fstab la partición indicada en la variable UUID (recuerda editarla en este fichero).
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com>
# ABOUT: Añade al fstab la partición indicada en la variable UUID (recuerda editarla en este fichero).
# REQUISITOS: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit
##############################################################################################################################################################


# Si la variable que usa el programa no está creada, se crea con los valores por defecto
[ -z "$BACKUPS" ] && BACKUPS="/home/.SteamOS-persistence.d/backup"

###########
#IMPORTANTE: a rellenar por el usuario manualmente para ingresar el UUID de la partición
###########
UUID=
PARTICION="/dev/disk/by-uuid/$UUID"
ToADD="UUID=$UUID     /home/deck    btrfs   noatime,lazytime,compress-force=zstd:6,space_cache=v2,autodefrag 0 0"

function addToFstab()
{
    # Comprobamos si es la primera vez que ejectamos este script, o lo que es lo mismo, que nuestra unidad btrfs no tiene ningún fichero
    mkdir /tmp/deck-btrfs && sudo mount "$PARTICION" /tmp/deck-btrfs -t btrfs -o noatime,lazytime,compress-force=zstd:6,space_cache=v2,autodefrag
    ans=$?

    if [ $ans ];then
        echo "** Se montó bien la partición **"

        # Si el punto de montaje tiene cero ficheros entonces copiamos el contenido de home deck al disco nuevo
        NUMFICHERO=$(sudo find /tmp/deck-btrfs -type f | sudo wc -l)
        if [ $NUMFICHERO -eq 0 ]; then
            echo -e "\n### La partición está vacía, se procede a la copia. ###"
            sudo cp -a /home/deck/. /tmp/deck-btrfs
        fi
        sudo umount /tmp/deck-btrfs

        # Hacemos copia del fichero a modificar
        cp /etc/fstab "$BACKUPS"/fstab.bak -f

        # Añadimos la línea al fstab
        sudo steamos-readonly disable
        echo -e "$ToADD" | sudo tee -a /etc/fstab
        sudo steamos-readonly enable
        # Recargar los demonios no haría falta, mejor sería reiniciar
        # sudo systemctl daemon-reload
        echo -e "\n### Actualizado el fichero de montajes, se recomienada reiniciar. ###"
    else
        echo "** No se pudo montar la partición **"
    fi
}

# Comienzo del script.

# Si no has rellanado el UUID se sale

if [ -z "$UUID" ];then
    echo "** ## ** No se ha modificado la variable con el UUID del disco. ** ## **"
    echo "** ## ** No se hacen cambios ** ## **"
else
    # Vemos si el actual fstab tiene el punto de montaje btrfs, si no, llama a la funcion para ponerlo
    LINEAS=$(grep "/home/deck" < /etc/fstab | grep -c btrfs)
    if [ "$LINEAS" = "0" ]; then
        echo "### Es necesario añadir al fstab la partición /home/deck ###"
        addToFstab
    else
        echo "### No es necesario, ya está añadido ###"
    fi
fi

