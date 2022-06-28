#! /bin/bash

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com>
# ABOUT: script pensado para ganar persistencia en SteamOS. Este ejecutará todos los Scripts que comiencen con el caracter S, K, C
#   Los que comiencen por S es para 'Salvar persistencia' hasta la próxima actualización por parte del fabricante.
#   Los que comiencen por C es para 'Chequear persistencia', comprobar el estado de cada una de la persistencia. No sería necesaria, pero recomendado.
#   Los que comiencen por K es para 'Deshacer esa persistencia'. Es decir, deshace cada uno de los scripts anteriores S. Esta parte no es necesaria.
#
# NOTA: añadirlo como Aplicación de Steam en el Gaming Mode. Así, tras una actualización de SteamOS, lo ejecutaremos para volver a dar persistencia.
# NOTA: para todas las modificaciones que NO SOBREVIVEN a las actualizaciones.
#
# REQUISITOS: Es necesario que el usuario deck no tenga contraseña (passwd -d). No funcionará el tanto automatismo si se tiene una contraseña personalizada
#
# EXITs:
# 0 --> Salida correcta.
# 1 --> Necesitas revisar el comando. Se sale tras mostrar la ayuda.
# 2 --> Usas -S, -C o -K conjutamente.
# 3 --> El directorio de script no existe.
# 4 --> El usuario no tiene una contraseña en blanco.
##############################################################################################################################################################

# Variables iniciales
DIRECTORIO="/home/.SteamOS-persistence.d"

DIALOG=S
function showhelp() {
    echo "Uso/Usage: $0 -S|C|K [-d directorio]"
    echo "Opciones/Options:"
    echo -e "\t-h|--help\t\tEsta ayuda. This help."
    echo -e "\t-S|--savemode\t\tEjecutar en modo Salvado.// It'll runing on Save Persistence Mode."
    echo -e "\t-C|--checkmode\t\tEjecutar en modo Chequeo.// It'll runing on Check Persistence Mode."
    echo -e "\t-K|--killmode\t\tEjecutar en modo Deshacer.// It'll runing on Undo Persistence Mode."
    echo -e "\t-d|--directory\t\tSe indica donde se encuentran esos scripts. Por defecto $DIRECTORIO // Where are the scripts?"
    exit 1
}

function showLogs() {
    echo -e "Mostrando los mensajes con dialog"
    
    RESULT="$LOGS/$MODE*log*"
    for f in $RESULT; do
        NAME_F=$(basename "$f")
	dialog --title "$NAME_F" --textbox $f 0 0
    done 
}

# Mientras el número de argumentos NO SEA 0
while [ $# -ne 0 ]; do
    case "$1" in
    -h | --help)
        # No hacemos nada más, porque showhelp se saldrá del programa
        showhelp
        ;;
    -S | --savemode)
        [ -n "$MODE" ] && echo "No se puede definir -S -C o -K conjuntamente.// You can't define -S -C or -K together." && exit 2
        MODE=S
        ;;
    -C | --checkmode)
        [ -n "$MODE" ] && echo "No se puede definir -S -C o -K conjuntamente.// You can't define -S -C or -K together." && exit 2
        MODE=C
        ;;
    -K | --killmode)
        [ -n "$MODE" ] && echo "No se puede definir -S -C o -K conjuntamente.// You can't define -S -C or -K together." && exit 2
        MODE=K
        ;;
    -d | --directory)
        DIRECTORIO="$2"
        shift
        ;;
    *)
        echo "Argumento no válido.// Something is wrong..."
        showhelp
        ;;
    esac
    shift
done

# Comprobaciones de parámetros
[ -z "$MODE" ] && echo "Falta algún parámetro necesario.// I need some parameters..." && showhelp

# Si el directorio no existe, se sale
[ ! -d "$DIRECTORIO" ] && echo "No existe el directorio $DIRECTORIO" && showhelp

# Variables donde guardar Backups y Logs
BACKUPS="$DIRECTORIO/backup"
LOGS="$DIRECTORIO/log"

# Si los directorios auxiliares no existen, se crean
[ ! -d "$BACKUPS" ] && mkdir -p "$BACKUPS"
[ ! -d "$LOGS" ] && mkdir -p "$LOGS"

# Chequeamos que la contraseña sea nula, que no tenga password el usuario
if [ ! "$(passwd -S | cut -d ' ' -f2)" = "NP" ];then
    echo -e "El usuario tiene una contraseña personalizada. La contraseña debe de ser vacía para este script."
    echo -e "The user deck has not a blank password. This script require a blank password."
    exit 4
fi

# Añadimos contraseña al usuario, si no podemos ser super user, salimos
echo -e -n "pass\npass" | passwd
echo -e -n "pass" | sudo -S ls >/dev/null 2>/dev/null || exit 4

# Para el directorio definido, ejecutamos todos los scripts correspondientes (S, C, o K)
RESULT="$DIRECTORIO/$MODE*.sh"
for f in $RESULT; do
    if [ -f "$f" ]; then
        # Si el fichero existe
        echo "Procesando... // Processing... $f"
        NAME_F=$(basename "$f")
        # shellcheck source=/dev/null
        source "$f" >"$LOGS/$NAME_F.log" 2>"$LOGS/$NAME_F.log.error"
    else
        # No existen ficheros
        echo "Advertencia: algunos problemas con $f // Something is wrong with $f ..."
    fi
done

# Mostramos resultado
[ "$DIALOG" ] && showLogs

# Borramos la contraseña del usuario deck para dejarla como al principio, blanco
sudo passwd -d deck

exit 0
