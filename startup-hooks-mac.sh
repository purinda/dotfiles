#!/bin/bash
#
# Place the path to the script in crontab as follows.
# @reboot /Users/purinda/Projects/dotfiles/startup-hooks-mac.sh
#
#

DIR=/Volumes/backupdrive

mount_nas() {
    mount -t smbfs //guest:@192.168.1.1/backupdrive $DIR
}

# Mount NAS
if [ ! -d $DIR ]
then
    mkdir $DIR
fi

# Check if directory is empty ? if so (assuming not mounted already) mount it
if [ ! "$(ls -A $DIR)" ]
then
    mount_nas
fi


echo `date "+[INFO] %d/%m/%Y %H:%M:%S"` NAS mounted >> /var/log/custom.log



################ Mount secto.me #######################

mount_sectome() {

}
