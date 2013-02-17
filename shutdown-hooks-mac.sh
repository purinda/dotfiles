#!/bin/bash
#
# Place the path to the script in mac login/logout hooks as follows (Use LogoutHook for logouts)
# sudo defaults write com.apple.loginwindow LogoutHook /path/to/script
#

DOTDIR="/Users/purinda/Projects/dotfiles/"
# include helper 
source $DOTDIR/bash/helper.sh

#STATUS=$("$DOTDIR/safehouse/Control_vm.sh" "suspend" 2>&1 >/dev/null)

#log "${STATUS}" "${DOTDIR}/logs/shutdown.log"
#log "Logout script ended" "${DOTDIR}/logs/shutdown.log"

