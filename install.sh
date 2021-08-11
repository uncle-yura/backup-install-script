#!/bin/bash
echo "Start packet installation"
apt update
apt install clonezilla gparted

lsblk

echo "Enter disk name for backup (Example: sda1):"
read DISK

archdir="/home/backup"

mkdir -p $archdir

cp backup.sh $archdir/backup.sh
cp backup.sh $archdir/restore.sh

sed -i "s/^\#*imgdisk=.*/imgdisk=\"$DISK\"/g" $archdir/backup.sh
sed -i "s/^\#*imgdisk=.*/imgdisk=\"$DISK\"/g" $archdir/restore.sh

