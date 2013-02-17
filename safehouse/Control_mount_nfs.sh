#!/bin/bash
#
# Place the path to the script in mac login/logout hooks as follows (Use LogoutHook for logouts)
# sudo defaults write com.apple.loginwindow LoginHook /path/to/script
#

DOTDIR="/Users/purinda/Projects/dotfiles/"
MOUNTPT="/Volumes/SBS/Projects"
SBSIP="192.168.56.2"
NFSDIR="/home/purinda/Projects"
# include helper 
source $DOTDIR/bash/helper.sh

mount_nfs() {
    mount -t nfs ${SBSIP}:${NFSDIR} $MOUNTPT >/dev/null 2>&1
    if [ $? -eq 1 ]
    then
        log "SBS NFS not mounted, error occured." "$DOTDIR/logs/boot.log"
    else
        log "SBS NFS mounted" "$DOTDIR/logs/boot.log"
    fi
}

# if mount directory doesnt exist
if [ ! -d $MOUNTPT ]
then
    mkdir -p $MOUNTPT
fi

# Check if directory is empty ? if so (assuming not mounted already) mount it
if [ ! "$(ls -A $MOUNTPT)" ]
then
    mount_nfs
fi

# Try to fire up the SBS VM
#VMSTATUS=$("$DOTDIR/safehouse/Control_vm.sh" "start" 2>&1 >/dev/null)
#log "VM Started: ${VMSTATUS}" "${DOTDIR}/logs/boot.log"
