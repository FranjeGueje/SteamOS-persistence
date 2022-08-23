#! /bin/bash
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN:Este Script debe de salir con exit. Tiene un flujo alternativoal desatendido


##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com>
# ABOUT: Este script importa lo necesario para que dialog funcione desde el script que lo invoca y todas sus funciones.
#
# NOTA: Es necesario este script como parte de SteamOS-persistence si se requiereel modo asistente.
#
# REQUISITOS: este script debe de devolver un valor o salir con exit.
#
# EXITs:
# 0 --> Salida correcta.
# 8 --> Se sale a petición del usuario.
# 4 --> El usuario tiene una contraseña en blanco y se encontró un problema al cambiarla
##############################################################################################################################################################


function salir() {
    # Para finalizar, si se le estableció la contraseña porque no tenía, se deja sin contraseña de nuevo
    [ -n "$CHANGEDPASS" ] && sudo passwd -d deck && echo Password cambiada de nuevo
}

#
# FUNCIONES SOBRE El asistente
#

# Para preguntar por la contraseña:
function DpedirPass() {
    zenity --title SteamOS-persistence --info --text="El usuario tiene una password personalida.\n\nPediremos la password" --width=300
    while :; do
        secreto="$(zenity --password --title SteamOS-persistence --ok-label="Aceptar" --cancel-label="Seguir sin introducirla" --text="Necesitamos tu password para elevar los permisos.\n\nIntroduce la password" --width=300)"
        echo "$secreto" | sudo -v -S >/dev/null 2>/dev/null && break
        zenity --title SteamOS-persistence --info --text="Has introducido una password incorrecta." --width=300
    done
    secreto=0
}

# Para preguntar seleccionar menu principal:
function DmainMenu() {
    MODE=$(zenity --list --title=SteamOS-persistence \
        --text="Selecciona la opcion a realizar" --height=300 --width=600 \
        --ok-label="Aceptar" --cancel-label="Cancelar" \
        --radiolist --column="" --column="Modo" --column="Descripcion" \
        1 S "Save - Guarda persistencia" \
        2 C "Check - Comprueba persistencia" \
        3 K "Kill - Deshace persistencia")
}

# Para seleccionar scripts a utilizar
function Dselect() {
    # Creamos la selección de Scripts
    RESULT="$DIRECTORIO/$MODE*.sh"
    i=1
    LISTA=()
    for f in $RESULT; do
        if [ -f "$f" ]; then
            DESC=$(sed -n 2p "$f")
            NAME=$(basename "$f")
            LISTA+=("$i" "$NAME" "$DESC")
            ((i++)) || true
        else
            zenity --title=SteamOS-persistence --info --text="No existen Scripts del tipo seleccionado" --width=300
            RUN=
            return
        fi
    done

    RUN=$(zenity --list --title=SteamOS-persistence --height=600 --width=900 \
        --ok-label="Aceptar" --cancel-label="Cancelar" \
        --text="Selecciona los Scripts que quieres que se ejecuten" --checklist \
        --column="" --column="Nombre" --column="Descripcion" --separator=" "\
        "${LISTA[@]}")
    echo "Elegidos: ${RUN}"
}

# Para correr los scripts elegidos
function Drun() {

    if [ -z "$RUN" ]; then
        zenity --title=SteamOS-persistence --info --text="No se ha seleccionado scripts a ejecutar." --width=300
    else
        for f in $RUN; do
            g="$DIRECTORIO/$f"
            # Si el fichero existe
            echo "Procesando... // Processing... $f"
            # shellcheck source=/dev/null
            source "$g" >"$LOGS/$f.log" 2>"$LOGS/$f.log.error"
            # Tras correr los scripts seleccionados, se muestran los resultados
            zenity --title SteamOS-persistence --text-info --filename="$LOGS/$f.log" --height=600 --width=900
            zenity --title SteamOS-persistence --text-info --filename="$LOGS/$f.log.error" --height=600 --width=900
        done
    fi
}

#
# MAIN: Procedimiento principal
#

# Si tiene password, se la pedimos y si no le creamos una para ejecutarlo. En este último caso se deberá de volver a eliminar la pass
if [ ! "$(passwd -S | cut -d ' ' -f2)" = "NP" ]; then
    DpedirPass
else
    zenity --title=SteamOS-persistence --info --text="El usuario no tiene password. Creamos una password temporal al usuario. Si no podemos ser super user, saldremos del programa" --width=300
    CHANGEDPASS=S
    echo -e -n "pass\npass" | passwd
    echo -e -n "pass" | sudo -S ls >/dev/null 2>/dev/null || exit 4
fi

MODE="" ; RUN=""

# Buble principal
while :; do
    # Mostramos el menu principal
    DmainMenu

    # Tratamos ls opción elegida
    if [ -z "$MODE" ]; then
        zenity --title SteamOS-persistence --info --text="Has seleccionado Salir.\n\nQue tengas un buen dia!" --width=300
        break
    fi

    Dselect

    # Tratamos los scripts seleccionados
    Drun
done

salir
exit 0
