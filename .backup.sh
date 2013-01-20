#!/bin/bash
#
# creates backups of essential files
#
DATA="/home/purinda/ /root /opt/"
CONFIG="/etc"
LIST="/tmp/backlist_$$.txt"
DST="/media/backupdrive/Backup/zeus/"
#
#mount /media/backupdrive
set $(date)

# backup on monday coz I fiddle with code during the weekends :)
if test "$1" = "Mon" ; then
        # weekly a full backup of all data and config. settings:
        #
        tar cfz "$DST/data/full_$6-$2-$3.tgz" $DATA
        rm -f $DST/data/data_diff*
        #
        tar cfz "$DST/config/full_$6-$2-$3.tgz" $CONFIG
        rm -f $DST/config/config_diff*
else
        # incremental backup:
        #
        find $DATA -depth -type f \( -ctime -1 -o -mtime -1 \) -print > $LIST
        tar cfzT "$DST/data/diff_$6-$2-$3.tgz" "$LIST"
        rm -f "$LIST"
        #
        find $CONFIG -depth -type f  \( -ctime -1 -o -mtime -1 \) -print > $LIST
        tar cfzT "$DST/config/diff_$6-$2-$3.tgz" "$LIST"
        rm -f "$LIST"
fi
#
# create sql dump of databases:
#mysqldump -u root --password=mypass --opt mydb > "/mnt/backup/database/mydb_$6-$2-$3.sql"
#gzip "/mnt/backup/database/mydb_$6-$2-$3.sql"
#
#umount /mnt/backup
