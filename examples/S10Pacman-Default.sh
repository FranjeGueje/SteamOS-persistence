#! /bin/bash
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
sudo pacman -S dialog --noconfirm

sudo steamos-readonly enable


