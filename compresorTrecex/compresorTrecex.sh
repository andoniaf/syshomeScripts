#!/bin/bash

# [ES] compresorTrecex - Script para comprimir archivos o directorios. (Para la práctica de scripts con zenity)

clear

menu() {
    echo "==============================="
    echo "  Compresor TreceX   "
    echo "==============================="
    echo "1) Comprimir uno o varios archivos."
    echo "2) Comprimir uno o varios directorios."
    echo "3) Descomprimir un archivo."
    echo "4) Salir."
    echo "--------------------------------"
    read -p "Seleccione una opción: " OPT
}

until [ $OPT -eq 4 ]; do
    case $OPT in
    1)
        read -p "A continuación seleccione los archivos a comprimir: " STOP
        ARCH=$(zenity --file-selection --multiple --separator=' ' --title="Selecciona archivos para comprimir")
        read -p "Seleccione la ruta y el nombre del archivo comprimido (sin la extension '.tar.gz'): " STOP
        NOM=$(zenity --file-selection --save --title="Seleccione el nombre y la ruta del archivo comprimido")
        echo "--------------------------------------------------------"
                tar -zvcf ${NOM}.tar.gz $ARCH 1> /dev/null 2>&1
                if [ $? = 0 ]; then
                        echo "Su archivo se ha comprimido correctamente."
                    else
                        zenity --error --text= "Ha ocurrido algun error, revise los parametros introducidos."
                        echo "____________________________________________________________"
                    fi
        menu
        ;;
    2)
        read -p "A continuación seleccione los directorios a comprimir: " STOP
        ARCH=$(zenity --file-selection --multiple --directory --title="Seleccione uno o varios archivos/directorios")
        read -p "Selecciona la ruta y el nombre del archivo comprimido: " STOP
    NOM=$(zenity --file-selection --save --title="Seleccione el nombre y la ruta del archivo comprimido")
        echo "--------------------------------------------------------"
                tar -zvcf ${NOM}.tar.gz $ARCH 1> /dev/null 2>&1
                if [ $? = 0 ]; then
                        echo "Su archivo se ha comprimido correctamente."
                    else
                        zenity --error --text= "Ha ocurrido algun error, revise los parametros introducidos."
                        echo "____________________________________________________________"
                    fi
        menu
        ;;
    3)
        read -p "Selecciona el archivo que quieres descomprimir: " STOP
        ARCH=$(zenity --file-selection --title="Selecciona archivo para descomprimir")
        read -p "Selecciona el directorio donde quieras descomprimirlo: " STOP
        RUT=$(zenity --file-selection --directory --title="Seleccione un directorio")
        echo "--------------------------------------------------------"
                tar -xzvf $ARCH -C $RUT 1> /dev/null 2>&1
                if [ $? = 0 ]; then
                        echo "Su archivo se ha descomprimido correctamente."
                    else
                        zenity --error --text= "Ha ocurrido algun error, revise los parametros introducidos."
                        echo "____________________________________________________________"
                    fi
        menu
            ;;
    4)
        break
        ;;
    *)
        clear
        menu
        ;;
    esac
done
