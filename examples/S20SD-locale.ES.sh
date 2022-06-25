#! /bin/bash
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

function changeLocal() {

	sudo steamos-readonly disable
	sudo sed -i 's/\#es_ES.UTF-8\ UTF-8/es_ES.UTF-8\ UTF-8/' /etc/locale.gen
	sudo pacman-key --init
	sudo pacman-key --populate archlinux
	sudo pacman -S glibc --noconfirm
	sudo locale-gen
	sudo steamos-readonly enable

}

echo Buscamos si está el locale es_ES-UTF8 activo
grep "#es_ES.UTF-8 UTF-8" </etc/locale.gen && echo "¡Se necesita cambiar el locale!" && changeLocal
