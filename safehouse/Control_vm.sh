#!/bin/bash
# This script automatically starts Safehouse Build Server and mounts
# exported directories into /Volumes/SBS/ folder.

VMS="SBS"

# Sanity checks
# Check whether we got parameters
if [ -z $1 ]
then
    echo "
Control_vm: Invalid or no option passed in.
usage: start suspend shutdown
"
    exit 1
fi

# Check if we have virtual box installed
command -v VBoxManage >/dev/null 2>&1
if [ "$?" -eq 1 ]
then
    echo "Error: VirtualBox is not installed or cannot be found"
    exit 1
fi

# Check whether SBS VM is available
VMEXIST=`VBoxManage list vms | awk '{print match($1,'/$VMS/')}' | awk '$1 > 0'`
if [ "$VMEXIST" == "0" ]
then
    echo "Error: Safehouse Build Server not found in the VM list"
    exit 1
fi

# Read switches
if [ $1 == "start" ]
then  
    echo "$VMS started."
    VBoxHeadless --startvm $VMS &
elif [ $1 == "suspend" ]
then
    # suspend commands
    VBoxManage controlvm $VMS savestate &
fi

