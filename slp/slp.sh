#! /bin/bash

# [ES] Script for lazy people - Para abrir combinaciones de programas (u otras acciones) frecuentes.
#
#  Modo de uso: slp <nombreSesion/Accion>
#
#  Lista de combinaciones posibles:
#                                   - default (aka slp): Abre Telegram, Firefox, Thunderbird y una terminal
#                                   - lpic: Abre PDF con el temario, terminal y virtualBox
#                                   - torrent: Abre transmission y su GUI web en una pestaña nueva en FF
#                                   - yts: Abre un pestaña de FF con una búsqueda en YT de la $palabraClave,
#                                           si no se introduce ninguna abre la página principal.
#                                   - en2es: Abre una pestaña de Wordreference con X palabra a buscar
#


# Checking $1
if [ -z $1 ];then
    echo "You did not provide a parameter"
    echo "Try again... Bye!"
else
    # Selecting option
    case $1 in
        help)
            echo "Modo de uso: slp <nombreSesion/Accion>"
            echo
            echo "Lista de combinaciones posibles:"
            echo " - slp: Abre Telegram, Firefox y Thunderbird"
            echo " - lpic: Abre PDF con el temario, terminal y virtualBox"
            echo " - torrent: Abre transmission y su GUI web en una pestaña nueva en FF"
            echo " - yts: Abre un pestaña de FF con una búsqueda en YT de la $palabraClave,"
            echo "          si no se introduce ninguna abre la página principal."
            echo " - en2es: Abre una pestaña de Wordreference con X palabra a buscar"
        ;;
        slp)
            echo "Opening $1 session..."
            #Aqui lo que se tenga que abrir
            firefox > /dev/null 2>&1 &
            thunderbird > /dev/null 2>&1 &
            /home/andoniaf/Telegram/Telegram > /dev/null 2>&1 &
            sleep 5
            clear
        ;;
        lpic)
            echo "Opening $1 session..."
            #Aqui lo que se tenga que abrir
            evince /home/andoniaf/Dropbox/Libros/Libros\ Informatica/LPIC-1-4th_edition.pdf &
            konsole &
            /usr/bin/virtualbox &
            sleep 5
            clear
        ;;
        torrent)
            echo "Opening $1 session..."
            #Aqui lo que se tenga que abrir
            transmission-gtk -m &
            sleep 5
            firefox -new-tab http://venom:9091/transmission/web/ &
            sleep 5
            echo "Session $1 open."
        ;;
        yts)
            read -p "Introducir palabra clave o presionar Enter para página principal: " palabraClave
            firefox -new-tab https://www.youtube.com/results\?search_query\="$palabraClave" &
            clear
        ;;
        en2es)
            read -p "Introducir palabra a traducir o Enter para abrir Wordreference: " palabraClave
            firefox -new-tab http://www.wordreference.com/es/translation.asp?tranword="$palabraClave" &
            clear
            ;;
        *)
            echo "$1 is not a valid session..."
            echo "Try again... Bye!"
            exit
        ;;
    esac
fi
