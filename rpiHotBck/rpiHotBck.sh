#!/bin/bash

# [ES] Raspberry Pi Hot Backup - Script para automatizar un backup "en caliente" del almacenamiento principal de la RPi
#
#  Modo de uso: Modificar las variables y ejecutar
#
#  Hecho sobre Raspbian, no probado sobre otros SO.

# Vars
BCKDIR=rpiBck
DIR=/route/to/path/$BCKDIR
DISKNAME=/dev/mmcblk0
DISKSIZE=SDSIZE=`blockdev --getsize64 $DISKNAME`;
FILENAME="rpiBck_$(date +%Y%m%d_%H%M%S)"
FILE=$FILENAME.img
SERVICES=( apache2 mysql cron )       	# Services to stop before backup
MAIL=correo@domin.io 			# You need some pkg to send mails.

echo "###########################################################"
echo "Starting backup process."
echo "Services will be unavailable while this process is running."
echo "###########################################################"

# Check if 'pv' is installed. If not, install it.
dpkg -s pv | grep Status

PVSTATUS=$?

if [ $PVSTATUS = 0 ]; then
    echo "## INFO: 'pv' is installed"
else
    echo "## WARN: 'pv is NOT installed, installing:"
    apt-get -y install pv
fi

# Check if Backup directory exists
if [ ! -d "$DIR" ]; then
    echo "## WARN: Backup dir $DIR NOT exist, creating it."
    mkdir $DIR
fi

# Sync disks
sync

# Stop services
echo "## INFO: Stopping services..."
for i in ${SERVICES[@]}
do
    service $i stop
done

# Start backup
echo "## INFO: Starting backup!!"
echo "Please wait..."
pv -tpreb /dev/mmcblk0 -s $DISKSIZE | dd of=$DIR/$FILENAME bs=1M conv=sync,noerror iflag=fullblock

# Backup ok?
BCKOK=$?

# Start services
echo "## INFO: Stating services..."
for i in ${SERVICES[@]}
do
    service $i start
done

#
if [ $BCKOK = 0 ]; then
    echo "## INFO: Backup completed OK"
    mv $FILENAME $FILE
    # Email notif
    echo "Backup completed. New file: $FILE" | mail -s "[SysNotif] Backup completed" $MAIL
    exit 0
else
    echo "## WARN: Backup failed!!!"
    rm -f $FILENAME
    # Email notif
    echo "Backup not completed. No new file... Check HDD space." | mail -s "[SysNotif] Backup failed!" $MAIL
    exit 1
fi
