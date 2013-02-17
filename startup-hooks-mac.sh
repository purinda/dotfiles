#!/bin/bash
#
# Place the path to the script in mac login/logout hooks as follows (Use LogoutHook for logouts)
# sudo defaults write com.apple.loginwindow LoginHook /path/to/script
#

DIR="/Volumes/backupdrive"
DOTDIR="/Users/purinda/Projects/dotfiles/"


# include helper 
source $DOTDIR/bash/helper.sh

mount_nas() {
    mount -t smbfs //guest:@router/backupdrive $DIR >/dev/null 2>&1
    if [ $? -eq 1 ]
    then
        log "NAS not mounted, error occured." "$DOTDIR/logs/boot.log"
    else
        log "NAS mounted" "$DOTDIR/logs/boot.log"
    fi
}

# if mount directory doesnt exist
if [ ! -d $DIR ]
then
    mkdir $DIR
fi

# Check if directory is empty ? if so (assuming not mounted already) mount it
if [ ! "$(ls -A $DIR)" ]
then
    mount_nas
fi

# Try to fire up the SBS VM
#VMSTATUS=$("$DOTDIR/safehouse/Control_vm.sh" "start" 2>&1 >/dev/null)
#log "VM Started: ${VMSTATUS}" "${DOTDIR}/logs/boot.log"
