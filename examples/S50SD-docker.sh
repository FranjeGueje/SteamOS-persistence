#! /bin/bash
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

sudo steamos-readonly disable

echo "Creamos el directorio donde van a estar los dockers."
mkdir -p /home/deck/docker
sudo mkdir -p /etc/docker
sudo cp docker/daemon.json /etc/docker/.

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
chown 1000:1000 /home/deck/docker

echo "Añadimos el usuario deck al grupo dockers."
sudo usermod -a -G docker deck

sudo steamos-readonly enable
