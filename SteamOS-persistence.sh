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
# 3 --> El directorio de script no existe.
##############################################################################################################################################################

# Variables iniciales
DIRECTORIO="/home/.SteamOS-persistence.d"

function showhelp() {
    echo "Uso/Usage: $0 -S|C|K [-d directorio] [-n]"
    echo "Opciones/Options:"
    echo -e "\t-h|--help\t\tEsta ayuda. This help."
    echo -e "\t-S|--savemode\t\tEjecutar en modo Salvado.// It'll runing on Save Persistence Mode."
    echo -e "\t-C|--checkmode\t\tEjecutar en modo Chequeo.// It'll runing on Check Persistence Mode."
    echo -e "\t-K|--killmode\t\tEjecutar en modo Deshacer.// It'll runing on Undo Persistence Mode."
    echo -e "\t-d|--directory\t\tSe indica donde se encuentran esos scripts. Por defecto $DIRECTORIO // Where are the scripts?"
    echo -e "\t-n|--nosudo\t\tNo necesitamos tareas de sudo.// Don't need sudo tasks."
    exit 1
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
    -n | --nosudocheck)
        SUDO_CHECK=N
        ;;
    *)
        echo "Argumento no válido.// Something is wrong..."
        showhelp
        ;;
    esac
    shift
done

# Si el directorio no existe, se sale
[ ! -d "$DIRECTORIO" ] && echo "No existe el directorio $DIRECTORIO" && showhelp && exit 3

# Variables donde guardar Backups y Logs
BACKUPS="$DIRECTORIO/backup"
LOGS="$DIRECTORIO/log"

# Si los directorios auxiliares no existen, se crean
[ ! -d "$BACKUPS" ] && mkdir -p "$BACKUPS"
[ ! -d "$LOGS" ] && mkdir -p "$LOGS"

# Comprobaciones de parámetros
if [ -z "$MODE" ]; then
    echo "Falta algún parámetro necesario.// I need some parameters..."
    showhelp
    exit 1
fi

if [ -z "$SUDO_CHECK" ]; then
    # Añadimos contraseña al usuario
    echo -e -n "pass\npass" | passwd

    # Ejecutamos sudo para ver si podemos ser super user
    echo -e -n "pass" | sudo -S ls >/dev/null 2>/dev/null || exit 1
fi

# Para el directorio definido, ejecutamos todos los scripts
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

# Volvemos a dejar la password del usuario como vacia
if [ -z "$SUDO_CHECK" ]; then
    # Borramos la contraseña del usuario deck para dejarla como al principio
    sudo passwd -d deck
fi

exit 0
