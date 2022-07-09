#! /bin/bash
# RECORDATORIO: Las variables del Script anterior se heredan. TAMBIÉN:Este Script debe de salir con exit. Tiene un flujo alternativoal desatendido

##############################################################################################################################################################
# AUTOR: Paco Guerrero <fjgj1@hotmail.com>
# ABOUT: Este script importa lo necesario para que dialog funcione desde el script que lo invoca y todas sus funciones.
# REQUISITOS: Las variables del Script anterior se heredan. TAMBIÉN:Este Script debe de salir con exit. Tiene un flujo alternativoal desatendido
##############################################################################################################################################################

# Importamos las librerías necesarias
LD_LIBRARY_PATH="$DIALOGPATH"
export LD_LIBRARY_PATH

#
# Variables para definir y acortar los parámetros de 'dialog'
#
# Variable de ejecución para acortar las intrucciones de 'dialog'
D="$DIALOG --backtitle SteamOS-persistence --title "
# Variables que definen la longitud de la ventana de dialog
T=" 40 120 "

function salir() {
    # Para finalizar, si se le estableció la contraseña porque no tenía, se deja sin contraseña de nuevo
    [ -n "$CHANGEDPASS" ] && sudo passwd -d deck && echo Password cambiada de nuevo
}

#
# FUNCIONES SOBRE DIALOG - Mejor que empiecen por D (Dfuncion)
#

# Para preguntar por la contraseña:
function DpedirPass() {
    $D PASSWORD --msgbox "El usuario -deck- tiene una password personalida.\n\nPediremos la contrasena." 0 0
    while :; do
        secreto="$($D PASSWORD --stdout --passwordbox "Necesitamos tu contrasena para elevar los permisos.\n\nIntroduce la contrasena:" 0 0)"
        echo -e -n "$secreto" | sudo -S ls >/dev/null 2>/dev/null && break
        $D "PASSWORD INCORRECTA" --msgbox "Has introducido una password incorrecta." 0 0
    done
    secreto=0
}

# Para preguntar seleccionar menu principal:
function DmainMenu() {
    MODE=$($D "MENU PRINCIPAL" \
        --stdout \
        --menu "Selecciona la opcion a realizar" 10 50 0 \
        S "Modo Save  - Guarda persistencia" \
        C "Modo Check - Comprueba persistencia" \
        K "Modo Kill  - Deshace persistencia")

    if [ -z "$MODE" ]; then
        salir
        $D SALIENDO --msgbox "Has seleccionado Salir. ¡Que tengas un buen dia!"
        exit 8
    fi
}

# Para seleccionar scripts a utilizar
function Dselect() {
    # Si es en modo Check se selecciona todo
    if [ "$MODE" = "C" ]; then
        s=on
    else
        # Si es en otro modo, no se selecciona ningún elemento
        s=off
    fi

    RESULT="$DIRECTORIO/$MODE*.sh"
    i=1
    LISTA=()
    for f in $RESULT; do
        if [ -f "$f" ]; then
            DESC=$(sed -n 2p "$f")
            NAME=$(basename "$f")
            LISTA+=("$NAME" "$DESC" "$s")
            ((i++)) || true
        else
            $D "SIN SCRIPTs" --msgbox "No existen Scripts del tipo seleccionado" 10 50
            DmainMenu
            Dselect
        fi
    done

    RUN=$($D "SELECCION DE SCRIPTS" --stdout \
        --checklist "Selecciona los Scripts que quieres que se ejecuten" 0 0 0 "${LISTA[@]}")
    echo "Elegidos: ${RUN}"
    if [ ! "$RUN" ]; then
        $D "SIN SELECCION" --msgbox "Se cancelo o no se seleccionaron scripts." 0 0
        DmainMenu
        Dselect
    fi
}

#
# MAIN: Procedimiento principal
#

# Si tiene password, se la pedimos y si no le creamos una para ejecutarlo. En este último caso se deberá de volver a eliminar la pass
if [ ! "$(passwd -S | cut -d ' ' -f2)" = "NP" ]; then
    DpedirPass
else
    $D "PASSWORD VACIA" --msgbox "El usuario no tiene password. Creamos una password temporal al usuario, si no podemos ser super user, saldremos del programa" 20 50
    CHANGEDPASS=S
    echo -e -n "pass\npass" | passwd
    echo -e -n "pass" | sudo -S ls >/dev/null 2>/dev/null || exit 4
fi

# Mostramos el menu principal
DmainMenu
Dselect

# Ejecutamos los scripts seleccionados
for f in $RUN; do
    g="$DIRECTORIO/$f"
    # Si el fichero existe
    echo "Procesando... // Processing... $f"
    # shellcheck source=/dev/null
    source "$g" >"$LOGS/$f.log" 2>"$LOGS/$f.log.error"
    # Tras correr los scripts seleccionados, se muestran los resultados
    $D "SALIDA $f" --textbox "$LOGS/$f.log" $T
    $D "SALIDA (ERRORES) $f" --textbox "$LOGS/$f.log.error" $T
done

salir
exit 0
