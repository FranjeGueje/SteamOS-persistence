#! /bin/bash
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com>
# ABOUT: Instala el servicio docker, pero lo hace en otro directorio ($DIRDOCKER). También lo deja deshabilitado para que no ararnque automáticamente.
# NOTA: Revisad el fichero docker/daemon.json para la ubicación del directorio de dockers.
# REQUISITOS: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit
##############################################################################################################################################################


DIRDOCKER=/home/deck/docker

sudo steamos-readonly disable

echo "Creamos el directorio donde van a estar los dockers."
mkdir -p "$DIRDOCKER"
sudo mkdir -p /etc/docker
sudo cp "$DIRECTORIO"/docker/daemon.json /etc/docker/.

echo "Instalamos dockers."
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman -S docker --noconfirm
# Deshabilitamos los dockers
echo "Deshabilitamos el servicio de dockers para que no se arranque automáticamente."
sudo systemctl disable docker.service docker.socket

# Paramos el servicio
sudo systemctl stop docker.service
sudo systemctl stop docker.socket

# Cambiamos los permisos de la carpeta
echo "Cambiando permisos de la carpeta."
sudo chown 1000:1000 "$DIRDOCKER" -R

echo "Añadimos el usuario deck al grupo dockers."
sudo usermod -a -G docker deck

sudo steamos-readonly enable
