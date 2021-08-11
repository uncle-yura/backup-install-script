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

echo "Start backup script"

read -p "Are you sure? [y/n]" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    jumpto start
fi
jumpto exit

start:
echo "Start clonezilla"
/usr/sbin/ocs-sr -q2 -c -j2 -z1p -i 4096 -fsck-src-part -p true saveparts $(date +%Y%m%d)_img $imgdisk && echo "Clone complite" || jumpto failed

mkdir -p $archdir

cd $archdir

rm ./*_Backup.tar.gz.2

for file in $(ls -r *_Backup.tar.gz*); do
    mv "$file" "${file%.[0-9]}.$((${file##*.}+1))"
done

cd $imgdir

echo "Start compressing"
tar -czf "$archdir/$(date +%Y%m%d)_Backup.tar.gz" ./*

rm -r $imgdir/*
echo "Backup complete"
jumpto exit

failed:
echo "Backup failed"

exit:
read -n 1 -s -r -p "Press any key to exit"

