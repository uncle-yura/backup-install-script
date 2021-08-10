#!/bin/bash
mkdir -p /home/partimage

cd /home/partimag

tar -xzf "/home/backup/*_Backup.tar.gz"

/usr/sbin/ocs-sr -e1 auto -e2 -c -t -r -j2 -k -p true -f sda1 restoreparts *_img sda1

rm -r /home/partimag/*

