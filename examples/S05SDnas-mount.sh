#! /bin/bash
# Añade al fstab las particiones de mi NAS.
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com>
# ABOUT: Añade al fstab las particiones de mi NAS.
# REQUISITOS: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit
##############################################################################################################################################################

echo -e "### Se comprueba si hay que añadir al archivo /etc/fstab ###"

LINEAS=$(grep -c "/mnt/nas" < /etc/fstab)
if [ "$LINEAS" = "0" ]; then
    echo -e "\n*** Se añade al archivo /etc/fstab ***"

    echo -e "\n192.168.3.2:/volume1/EmulationStation 	/mnt/nas/Emu		nfs	hard,noauto,user,async 0 0\n\
192.168.3.2:/volume1/SteamOS 	/mnt/nas/SteamOS		nfs	hard,noauto,user,async 0 0" | sudo tee -a /etc/fstab
else
    echo -e "\n*** No es necesario añadirlo al archivo /etc/fstab ***"
fi

# Creamos las dos carpetas por si no están ya creadas.
sudo mkdir -p /mnt/nas/SteamOS /mnt/nas/Emu 2>/dev/null

echo -ne "\n### Instalamos los paquetes nfs que no lleva SteamOS ###\n"

sudo steamos-readonly disable

echo "### Eliminamos si existen restos de otra instalacion. ###"
sudo mv /etc/request-key.d/id_resolver.conf /tmp/. 2>/dev/null
sudo mv /var/lib/nfs/state /tmp/. 2>/dev/null

echo "### Instalamos paquetes a través de pacman. ###"
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman -S nfs-utils --noconfirm

sudo steamos-readonly enable

