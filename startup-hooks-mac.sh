#!/bin/bash
#
# Place the path to the script in crontab as follows.
# @reboot /Users/purinda/Projects/dotfiles/startup-hooks-mac.sh
#
#

mount_nas() {
    mount -t smbfs //guest:@router/backupdrive /Volumes/NAS
}

# Mount NAS
if [ -d /Volumes/NAS ]
then
    mount_nas
elif [ ! -d /Volumes/NAS ]
then
    mkdir /Volumes/NAS
    mount_nas
fi

