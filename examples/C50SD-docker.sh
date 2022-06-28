#! /bin/bash
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com>
# ABOUT: Chequea el estado de la instalación docker.
# REQUISITOS: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit
##############################################################################################################################################################


# Revisamos directorio ...
echo -e "### Revisamos si existe el directorio /etc/docker y su contenido. ###"
ls -lah /etc/docker

echo -e "\n### Revisamos si existen paquetes docker instalados. ###"
pacman -Qqe | grep docker

# Deshabilitamos los dockers
echo -e "\n### Comporobando si están arrancados los servicios de dockers. ###"
systemctl status docker.service
systemctl status docker.socket

echo -e "\n### Comprobamos si el usuario deck pertenece al grupo dockers. ###"
cat /etc/group | grep docker
