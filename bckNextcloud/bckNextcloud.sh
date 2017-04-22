#!/bin/bash

# Script para backup remoto de los datos de NextCloud (solo los datos, no la aplicacion al completo)
#
# TO DO
# - Que compruebe que las rutas existen

# Ruta donde estan los datos de NextCloud
nextCloudDir="/path/to/nextcloudData"
# Ruta donde esta instalado Nexcloud (y el archivo 'occ')
nextCloudConf="/var/www/nextcloud"
# Usuario del servicio
userWeb="www-data"
date=`date +"%y%m%d_%H%M%S"`
filename=nextcloudData_$date.tar.gz
# Ruta donde dejar el Backup
bckDir="/path/to"
login="user@host"
port="22"
remoteDir="/path/to/backup/"

# Monta el recurso remoto mediante sftp
sshfs -p $port $login:$remoteDir $bckDir

# Activa el modo mantenimiento
sudo -u $userWeb php occ maintenance:mode --on

# Espera un minuto por si quedase algun accion pendiente sobre los ficheros
sleep 60

# Comprime directorio de NextCloud en la ruta del backup
tar -zcvf $bckDir/$filename $nextCloudDir

# Desactiva el modo mantenimiento
sudo -u $userWeb php occ maintenance:mode --off

# Desmonta el directorio remoto
umount $bck

echo "Copia de seguridad, $filename, enviada a $login:$bckDir"
