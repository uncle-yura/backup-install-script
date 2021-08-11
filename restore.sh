#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

imgdir="/home/partimag"
archdir="/home/backup"
imgdisk="sda1"

function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}

echo "Start restore script"

read -p "Are you sure? [y/n]" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    jumpto start
fi
jumpto exit

start:
mkdir -p $imgdir

cd $imgdir

filename="$(find $archdir -type f -iname '*_Backup.tar.gz')"

echo "Start uncompressing"
tar -xzf "$filename"

dirname="$(find $imgdir -type d -iname '*_img')"

echo "Start clonezilla"
/usr/sbin/ocs-sr -e1 auto -e2 -c -t -r -j2 -k -p true -f $imgdisk restoreparts $(basename -- "$dirname") $imgdisk

rm -r $imgdir/*

echo "Restore complete"

exit:

