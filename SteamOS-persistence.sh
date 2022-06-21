#! /bin/bash

##############################################################################################################################################################
#VERSION 0.1
#SCRIPT pensado para ganar persistencia en SteamOS. Este ejecutará todos los Scripts que comiencen con el caracter S o el caracter K.
#   Los que comiencen por S es para 'Salvar persistencia' hasta la próxima actualización por parte del fabricante.
#   Los que comiencen por K es para 'Deshacer esa persistencia'. Es decir, intentar deshacer cada uno de los scripts anteriores S. Esta parte es más opcional.
#Util añadirlo como Aplicación de Steam en el Gaming Mode. Así, tras una actualización de SteamOS, lo ejecutaremos para volver a dar persistencia.
#Util para todas las modificaciones que NO SOBREVIVEN a las actualizaciones.
#
# REQUISITOS - Es necesario que el usuario deck no tenga contraseña (passwd -d). No funcionará el automatismo con contraseña personalizada
##############################################################################################################################################################


# Variables iniciales
DIRECTORIO="/home/deck/.SteamOS-persistence.d"
BACKUPS="$DIRECTORIO/backup"
LOGS="$DIRECTORIO/log"

# Si los directorios auxiliares no existen, se crean
[ ! -d "$BACKUPS" ] && mkdir -p $BACKUPS
[ ! -d "$LOGS" ] && mkdir -p $LOGS

function showhelp()
{
    echo "Usage: $0 -S|-K [-d directory] [-n]"
    echo "Options:"
    echo -e "\t-h|--help\t\tEsta ayuda. This help."
    echo -e "\t-S|--savemode\t\tEjecutar en modo Salvado. It'll runing on Save Persistence Mode."
    echo -e "\t-K|--killmode\t\tEjecutar en modo Deshacer. It'll runing on Undo Persistence Mode."
    echo -e "\t-d|--directory\t\tSe indica donde se encuentran esos scripts. Por defecto $DIRECTORIO"
    echo -e "\t-n|--nosudo\t\tNo necesitamos tareas de sudo. Don't need sudo tasks."
    exit 0
}

# Mientras el número de argumentos NO SEA 0
while [ $# -ne 0 ]
do
    case "$1" in
    -h|--help)
        # No hacemos nada más, porque showhelp se saldrá del programa
        showhelp
        ;;
    -S|--savemode)
        [ ! -z "$MODE" ] && echo "No se puede definir -S y -K conjuntamente." && exit 2
	MODE=S
        ;;
    -K|--killmode)
	[ ! -z "$MODE" ] && echo "No se puede definir -K y -S conjuntamente." && exit 2
	MODE=K
        ;;
    -d|--directory)
	DIRECTORIO="$2"
	shift
	;;
    -n|--nosudocheck)
	SUDO_CHECK=N
	;;
    *)
        echo "Argumento no válido. Something is wrong..."
        showhelp
        ;;
    esac
    shift
done

# Comprobaciones de parámetros
if [ -z "$MODE" ]
then
    echo "Falta algún parámetro necesario. I need some parameters..."
    showhelp
    exit 1
fi

if [ -z "$SUDO_CHECK" ]
then
    # Añadimos contraseña al usuario
    echo -e -n "pass\npass" | passwd

    # Ejecutamos sudo para ver si podemos ser super user
    echo -e -n "pass" | sudo -S ls >/dev/null 2>/dev/null || exit 1
fi

# Para el directorio definido, ejecutamos todos los scripts
RESULT="$DIRECTORIO/$MODE*.sh"
for f in $RESULT; do
	if [ -f "$f" ]
	then
		# Si el fichero existe
		echo "Processing $f"
		NAME_F=$(basename "$f")
		source "$f" > "$LOGS/$NAME_F.log" 2> "$LOGS/$NAME_F.log.error"
	else
		# No existen ficheros
		echo "Advertencia: algunos problemas con $f"
	fi
done

# Volvemos a dejar la password del usuario como vacia
if [ -z "$SUDO_CHECK" ]
then
    # Borramos la contraseña del usuario deck para dejarla como al principio
     sudo passwd -d deck
fi

exit 0

