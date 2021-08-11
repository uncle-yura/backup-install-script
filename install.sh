#!/bin/bash
echo "Start packet installation"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

apt update
apt install clonezilla gparted

lsblk

echo "Enter disk name for backup (Example: sda1):"
read DISK

archdir="/home/backup"
desktopdir="/user/share/applications"

mkdir -p $archdir

cp backup.sh $archdir/backup.sh
cp restore.sh $archdir/restore.sh

sed -i "s/^\#*imgdisk=.*/imgdisk=\"$DISK\"/g" $archdir/backup.sh
sed -i "s/^\#*imgdisk=.*/imgdisk=\"$DISK\"/g" $archdir/restore.sh

cp run-backup.desktop $desktopdir/run-backup.desktop
cp run-restore.desktop $desktopdir/run-restore.desktop

