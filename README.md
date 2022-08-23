# SteamOS-persistence
Script para automatizar la persistencia de los cambios frente a las actualizacinoes oficiales de SteamOS 3. Script to automate persistence in SteamOS 3.

**Todas estas utilidades han sido probadas, pero úsalas sin ningún tipo de garantía**.

## ¿Qué es esto?
SteamOS en cada reinicio utiliza y sobreescribe un nuevo grupo de particiones A o B para rootfs y otras particiones. A esto, hay que añadirle que el sistema de ficheros es de sólo lectura. Esto hace que los cambios que hayamos hecho en esos sistemas, ya sea crear nuevos ficheros, carpetas, aplicaciones, ..., se pierdan tras la actualización. Este script no pretente romper con esa filosofía, si no que intenta automatizar los cambios que queramos hacer tras la actualización.

Si además, añadimos este script al Game Mode como si de un "Juego no de Steam" se tratase, tras la actualización, sólo tendremos que pulsar un botón y podremos hacer nuestras modificaciones automáticamente.

## Instrucciones de uso
Recordamos del propósito del programa: ejecutar una serie de scripts independientes entre ellos (o no) para ganar persistencia hasta la próxima actualización de SteamOS.

Pues bien, el corazón del programaa se divide en dos elementos:
* "SteamOS-persistence.sh" - Script principal. Se debe de colocar donde se quiera (recomiendo colocarlo en /home)
* ".SteamOS-persistence.d" - carpeta donde se encuentran dentro los scripts a lanzar además de varias utilidades. Por defecto, se debería de colocar en /home también.

Importante: recuerda que para guardarlo en "/home" necesitarás hacerlo con el usuario mediante "sudo". Recomiendo dejar los permisos del fichero ejecutable y de la carpeta (y subcarpetas y archivos) como propietario al usuario deck una vez copiado.

En la carpeta principal, colocar todos los scripts a ejectuar. Los que comienzan por:
- S ... .sh - son los scripts usados para salvar la persistencia, son los que modifican el SO oficial de Valve.
- K ... .sh - son los scripts usados para deshacer las tareas realizadas por los que comienzan por S. Esto sería recomendable hacerlo por cada script S.
- C ... .sh - son los scripts que comprueban el estado de la persistencia, no deberían modificar nada. Esto sería recomendable hacerlo por cada script S.

Por lo tanto, el uso del programa sería dejar en la carpeta principal los scripts (ver ejemplos de uso) y lanzar el programa principal. Dependiendo de cómo se lance el programa puede ser desatendido o mediante asistente (ver parámetros de uso)

## Ejemplos de uso (ya probados por mi)
En la carpeta examples existen varios scripts de ejemplo. Son los que uso yo actualmente.
- Montar una partitión btrfs automáticamente a través de la modificación del archivo `/etc/fstab`.
- Instalar paquetes a través de pacman.
- Modificar scripts de SteamOS, como por ejemplo, el montaje de tarjetas SD en formato btrfs. Ver https://github.com/Trevo525/btrfdeck
- Instalar glibc y los UTF8 (locale).
- Instalar DOCKER en otra ubicación personalizada y desactivar los servicios hasta que sean necesarios.

## Parámetros de uso
#### Uso desatendido/unattended:
SteamOS-persistence.sh -S|C|K [-d directorio] [-v]

#### Uso del asistente/With wizard:
SteamOS-persistence.sh \[-d directorio\]

Opciones/Options:

* -h|--help       Esta ayuda. This help.
* -S|--savemode   Ejecutar en modo Salvado.// It'll runing on Save Persistence Mode.
* -C|--checkmode  Ejecutar en modo Chequeo.// It'll runing on Check Persistence Mode.
* -K|--killmode   Ejecutar en modo Deshacer.// It'll runing on Undo Persistence Mode.
* -d|--directory  Se indica donde se encuentran esos scripts. Por defecto es `/home/.SteamOS-persistence` // Where are the scripts?
* -v|--verbose    Si se quiere mostrar en el modo desatendido los logs resultantes.


## Imágenes de la herramienta
(Las imágenes no corresponden a un sistema Steam Deck si no a un portátil usado para pruebas)
Imágenes en modo asistente:
![Esta es una imagen](https://raw.githubusercontent.com/FranjeGueje/SteamOS-persistence/dev/doc/01-SteamOS-PasswordCheck.png)

![Esta es una imagen](https://raw.githubusercontent.com/FranjeGueje/SteamOS-persistence/dev/doc/02-SteamOS-Password.png)

![Esta es una imagen](https://raw.githubusercontent.com/FranjeGueje/SteamOS-persistence/dev/doc/03-SteamOS-Principal.png)

![Esta es una imagen](https://raw.githubusercontent.com/FranjeGueje/SteamOS-persistence/dev/doc/04-SteamOS-SelectScripts.png)

![Esta es una imagen](https://raw.githubusercontent.com/FranjeGueje/SteamOS-persistence/dev/doc/05-SteamOS-Result.png)
