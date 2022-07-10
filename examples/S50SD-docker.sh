#! /bin/bash
# Instala el servicio docker, pero lo hace en otro directorio ($DIRDOCKER). También lo deja deshabilitado para que no ararnque automáticamente.
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com>
# ABOUT: Instala el servicio docker, pero lo hace en otro directorio ($DIRDOCKER). También lo deja deshabilitado para que no ararnque automáticamente.
# REQUISITOS: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit
##############################################################################################################################################################


# Si la variable que usa el programa no está creada, se crea con los valores por defecto
[ -z "$DIRECTORIO" ] && DIRECTORIO="/home/.SteamOS-persistence.d"

DIRDOCKER=/home/deck/docker

sudo steamos-readonly disable

echo "### Creamos el directorio donde van a estar los dockers. ###"
mkdir -p "$DIRDOCKER"
sudo mkdir -p /etc/docker
echo -en "{\n  \"data-root\": \"/home/deck/docker\"\n}\n" | sudo tee /etc/docker/daemon.json

echo -e "\n### Instalamos dockers. ###"
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman -S docker --noconfirm
# Deshabilitamos los dockers
echo -e "\n### Deshabilitamos el servicio de dockers para que no se arranque automáticamente. ###"
sudo systemctl disable docker.service docker.socket

# Paramos el servicio
sudo systemctl stop docker.service
sudo systemctl stop docker.socket

# Cambiamos los permisos de la carpeta
echo -e "\n### Cambiando permisos de la carpeta. ###"
sudo chown 1000:1000 "$DIRDOCKER" -R

echo -e "\n### Añadimos el usuario deck al grupo dockers. ###"
sudo usermod -a -G docker deck

sudo steamos-readonly enable

