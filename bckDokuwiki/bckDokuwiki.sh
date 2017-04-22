#!/bin/bash

# Script para backup remoto de Dokuwiki
#
# TO DO
# - Que compruebe que las rutas existen

wikiDir=/var/www/dokuwiki
date=`date +"%y%m%d_%H%M%S"`
filename=dokuwiki_$date.tar.gz
# Ruta donde dejar el Backup
bckDir="/path/to"
login="user@host"
port="22"
remoteDir="/path/to/backup/"

# Monta el recurso remoto mediante sftp
sshfs -p $port $login:$remoteDir $bckDir

# Comprime directorio de Dokuwiki en la ruta del backup
tar -zcvf $bckDir/$filename $wikiDir

# Desmonta el directorio remoto
umount $bck

echo "Copia de seguridad, $filename, enviada a $bckDir"
