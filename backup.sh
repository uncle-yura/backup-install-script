#!/bin/bash
mkdir -p /home/backup

cd /home/backup

rm ./*_Backup.tar.gz.2

for file in $(ls -r *_Backup.tar.gz*); do
    mv "$file" "${file%.[0-9]}.$((${file##*.}+1))"
done

/usr/sbin/ocs-sr -q2 -c -j2 -z1p -i 4096 -fsck-src-part -p true saveparts $(date +%Y%m%d)_img sda1

cd /home/partimag

tar -czf "/home/backup/$(date +%Y%m%d)_Backup.tar.gz" ./*

rm -r /home/partimag/*
