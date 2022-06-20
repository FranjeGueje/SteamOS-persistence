# SteamOS-persistence
Script para automatizar la persistencia frente a las actualizacinoes de SteamOS 3. Script to automate persistence in SteamOS 3

**Todas estas utilidades no han sido probadas, úsalas sin ningún tipo de garantía**.

## ¿Qué es esto?
SteamOS en cada reinicio utiliza y sobreescribe un nuevo grupo de particiones A o B para rootfs y otras particiones. A esto hay que añadirle que el sistema de ficheros es de sólo lectura. Esto hace que los cambios que hayamos hecho en esos sistemas, ya sea crear nuevos ficheros, carpetas, paquetes, ..., se pierdan tras la actualización. Este script no pretente romper con esa filosofía si no que intenta automatizar los cambios que queramos hacer tras la actualización.

Si además, añadimos este script al Game Mode como si de un "Juego no de Steam" se tratase, tras la actualización, sólo tendremos que pulsar un botón y podremos hacer nuestras modificaciones automáticamente.

## Ejemplos de uso (no probados)
- Montar una partitión btrfs automáticamente a través de la modificación del archivo `/etc/fstab`
- Instalar paquetes a través de pacman.
- Modificar scripts de SteamOS, como por ejemplo, el montaje de tarjetas SD en formato btrfs. Ver https://github.com/Trevo525/btrfdeck

## Parámetros de uso
SteamOS-persistence.sh -S|-K [-d directory] [-n]

Options:
- -h|--help - Esta ayuda. This help.
- -S|--savemode - Ejecutar en modo Salvado. It'll runing on Save Persistence Mode.
- -K|--killmode - Ejecutar en modo Deshacer. It'll runing on Undo Persistence Mode.
- -d|--directory - Se indica donde se encuentran esos scripts. Por defecto "/home/deck/.SteamOS-persistence.d".
- -n|--nosudo - No necesitamos tareas de sudo. Don't need sudo tasks.
