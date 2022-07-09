#! /bin/bash
# Añade al fstab las particiones de mi NAS.
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com>
# ABOUT: Añade al fstab las particiones de mi NAS.
# REQUISITOS: Las variables del Script anterior se heredan. TAMBIÉN: NO podemos salir del script con ningún exit
##############################################################################################################################################################

echo -e "### Se comprueba si hay que añadir al archivo /etc/fstab ###"
grep "/mnt/nas" < /etc/fstab >/dev/null || echo -e "\n*** Se añade al archivo /etc/fstab ***" && \
	echo -e "\n192.168.3.2:/volume1/EmulationStation 	/mnt/nas/Emu		nfs	hard,noauto,user,async 0 0\n\
192.168.3.2:/volume1/SteamOS 	/mnt/nas/SteamOS		nfs	hard,noauto,user,async 0 0" | sudo tee -a /etc/fstab

