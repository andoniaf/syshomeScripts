#! /bin/bash

# ytmpt3 - Script para extraer el sonido en MP3 de la URL pasada. (De Youtube)

# TO DO: - Hacer que se descargue en Descargas

# Comprueba que se han pasado parametros
if [ -z $1 ]; then
    echo "No se ha introducido la URL || Uso del comando: ytmp3 <URL>"
    exit 1
fi
		
# Extrae el audio del video y los descarga en .mp3     
youtube-dl --print-traffic --extract-audio --audio-format mp3 $1

