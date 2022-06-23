#! /bin/bash
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

# Vemos si el actual fstab tiene el punto de montaje btrfs, si no, llama a la funcion para ponerlo
cat /etc/fstab
