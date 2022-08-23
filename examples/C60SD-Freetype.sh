#! /bin/bash
# Chequea el estado de la instalación de Freetype.
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com>
# ABOUT: Chequea el estado de la instalación de Freetype.
# REQUISITOS: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit
##############################################################################################################################################################


echo -e "\n### Revisamos si existen paquetes Freetype instalados. ###"
pacman -Q | grep lib32-freetype2
