#! /bin/bash
# Instala los paquetes a través de pacman que se quiera.
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com>
# ABOUT: Instala los paquetes a través de pacman que se quiera.
# REQUISITOS: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit
##############################################################################################################################################################

sudo steamos-readonly disable

echo "### Instalamos paquetes a través de pacman. ###"
sudo pacman-key --init
sudo pacman-key --populate archlinux
# Descomentar la línea de abajo y añadir los paquetes que quieras instalar automáticamente
#sudo pacman -S paquete1 paquete2 --noconfirm

sudo steamos-readonly enable


