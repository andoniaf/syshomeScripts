#! /bin/bash

# magneto - Script que extrae los enlaces magnets de una URL y los añade para su descarga en transmission
#
# Modo de uso: magneto <URL>

# Exporta credenciales de Transmission ($TR_AUTH) desde ".conf"
. .conf
export TR_AUTH=$TR_AUTH

## FUNCTIONS

# Funcion que añade enlace magnet para su descarga
addMagnet(){
    for magnetURL in $magnetsList
    do
        transmission-remote -ne -a "$magnetURL"
    done
}

# Funcion que filtra la URL y proporciona la lista de magnets
findMagnet(){
    toFilterURL=$1
    magnetsList=$(wget -O - $toFilterURL | grep magnet | cut -d "\"" -f 2 | grep 720p)
}


## Comienza la magia

# Comprueba que se han pasado parametros, si no, sale del programa mostrando el modo de uso
if [ -z $1 ]; then
    echo "No se ha introducido la URL || Uso del comando: magneto <URL>"
    exit 1
fi

findMagnet $1

addMagnet

echo "Se han añadido $(echo $magnetsList | wc -l) archivos para su descarga."
