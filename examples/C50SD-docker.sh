#! /bin/bash
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

echo "Revisamos si existe el directorio /etc/docker y su contenido."
sudo ls -lah /etc/docker

echo "Revisamos si está instalado el paquete docker."
pacman -Qqe | grep docker
# Deshabilitamos los dockers
echo "Vemos si están arrancados los servicios."
sudo systemctl status docker.service
sudo systemctl status docker.socket

echo "Añadimos el usuario deck al grupo dockers."
sudo cat /etc/group | grep docker
