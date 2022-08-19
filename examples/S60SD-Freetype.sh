#! /bin/bash
# Instala las fuentes de FreeType para 32bits que se queja WINE y algunos juegos no funcionan por esto.
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com>
# ABOUT: Instala las fuentes de FreeType para 32bits que se queja WINE y algunos juegos no funcionan por esto.
# REQUISITOS: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit
##############################################################################################################################################################

# Deshabilitamos el sólo lectura
sudo steamos-readonly disable

# Inicializamos pacman
sudo pacman-key --init
sudo pacman-key --populate archlinux

# Instalamos la fuente
sudo pacman -S lib32-freetype2 --noconfirm

# Volvemos a dejar todo como solo lectura
sudo steamos-readonly enable


