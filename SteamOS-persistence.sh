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
# REQUISITOS: Si se lanza en modo desatendido (-S, -C o -K), es necesario que el usuario deck no tenga contraseña (passwd -d).
# REQUISITOS: Si se tiene contraseña, se debe de lanzar sin el comando -S, -C o -K y se lanzará en modo asistente
#
# EXITs:
# 0 --> Salida correcta.
# 1 --> Necesitas revisar el comando. Se sale tras mostrar la ayuda.
# 2 --> Usas -S, -C o -K conjutamente.
# 3 --> El directorio de script no existe.
# 4 --> El usuario no tiene una contraseña en blanco y para el caso es necesario
# 88 -> No se encuntra la utilidad dialog y se necesita
##############################################################################################################################################################

# Variables iniciales
DIRECTORIO="/home/.SteamOS-persistence.d"

function showhelp() {
    echo -e "Uso desatendido/unattended:\n\t\t$0 -S|C|K [-d directorio] [-v]\n\nUso del asistente/With wizard:\n\t\t$0 [-d directorio]\n\
    \n[Opciones/Options]\n\
    \t-h|--help\t\tEsta ayuda. This help.\n\
    \t-S|--savemode\t\tEjecutar en modo Salvado.// It'll runing on Save Persistence Mode.\n\
    \t-C|--checkmode\t\tEjecutar en modo Chequeo.// It'll runing on Check Persistence Mode.\n\
    \t-K|--killmode\t\tEjecutar en modo Deshacer.// It'll runing on Undo Persistence Mode.\n\
    \t-d|--directory\t\tSe indica donde se encuentran esos scripts. Por defecto $DIRECTORIO // Where are the scripts?\n\
    \t-v|--verbose\t\tSi se quiere mostrar en el modo desatendido los logs resultantes. Se usará 'sleep' para esperar."
    exit 1
}

function showLogs() {
    echo -e "Mostrando los mensajes sin dialog"

    RESULT="$LOGS/$MODE*log*"
    for f in $RESULT; do
        clear && echo -e "    --> FICHERO $f\n\n" && cat "$f" && echo -e "\n\n\n    --> Espere 5 segundos para continuar..."
        sleep 5
    done
}

# Recopilamos argumentos
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
    -v | --verbose)
        VERBOSE=S
        ;;
    *)
        echo "Argumento no válido.// Something is wrong..."
        showhelp
        ;;
    esac
    shift
done

#
# Tras recoger todos los argumentos, comprobamos parámetros, y montamos parámetros finales
#

# Si el directorio no existe, se sale
[ ! -d "$DIRECTORIO" ] && echo "No existe el directorio $DIRECTORIO" && showhelp

# Variables para la ejecución de dialog
DIALOGPATH="$DIRECTORIO/util"
DIALOG="$DIALOGPATH/dialog"
DIALOGMODULE="$DIALOGPATH/dialog.sh"
# Variables donde guardar Backups y Logs
BACKUPS="$DIRECTORIO/backup"
LOGS="$DIRECTORIO/log"

# Si no tenemos paramétros para ejecutarse automáticamente en algún modo y existe la utilidad portable dialog, la usamos.
if [ -z "$MODE" ] && [ -f "$DIALOG" ]; then
    echo "Usamos dialog y ejecutamos el Wizard (asistente)"
    # shellcheck source=/dev/null
    source "$DIALOGMODULE"
    # Aquí no debería de llegar, ya toma el flujo de dialog
    exit 88
else
    # Si no tenemos dialog, y no hemos puesto ningún modo: nos falta un parámetro y salimos. Mostramos la ayuda antes
    [ -z "$MODE" ] && echo "Falta algún parámetro necesario.// I need some parameters..." && showhelp
fi

#
# Chequeamos que la contraseña sea nula, que no tenga password el usuario
#
if [ ! "$(passwd -S | cut -d ' ' -f2)" = "NP" ]; then
    echo -e "El usuario tiene una contraseña personalizada y se está lanzando de forma automática."
    echo -e "The user deck has not a blank password and you're running this script in automatic-mode."
    exit 4
fi

# Añadimos contraseña al usuario, si no podemos ser super user, salimos
echo "El usuario no tiene password. Añadimos contraseña al usuario, si no podemos ser super user, salimos"
echo -e -n "pass\npass" | passwd
echo -e -n "pass" | sudo -S ls >/dev/null 2>/dev/null || exit 4

# Si los directorios auxiliares no existen, se crean
[ ! -d "$BACKUPS" ] && mkdir -p "$BACKUPS"
[ ! -d "$LOGS" ] && mkdir -p "$LOGS"

#
# Ejecutamos para el directorio definido todos los scripts correspondientes (S, C, o K)
#
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

# Mostramos resultado si la opción -v está definida
[ -n "$VERBOSE" ] && showLogs

# Dejamos al usuario sin contraseña de nuevo, porque recuerdo, que este método es el desatendido y es requisito...
sudo passwd -d deck

exit 0
