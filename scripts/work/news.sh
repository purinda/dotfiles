#!/bin/bash

PROFILE="/Users/purinda/profile"

export_proxy() {

    # Enable cntlm for News Ltd proxy
    export http_proxy=http://localhost:3128
    export https_proxy=http://localhost:3128
    echo "Setting up NewsCorp proxy.."

}

up() {

    if [ ! -f $PROFILE ];
    then
        touch $PROFILE
    fi

    # setting to empty so below block would enable work mode.
    echo 'init' > $PROFILE
}

down() {

    if [ -f $PROFILE ];
    then
        touch $PROFILE
    fi

    echo 'auto' > $PROFILE
}

enforce_profile() {

    # run under work profile
    if [ -f $PROFILE ]; 
    then
        
        if grep auto $PROFILE > /dev/null
        then

            echo 'Auto profile'

        # if not work?
        elif grep init $PROFILE > /dev/null
        then

            # Set hostname
            # osascript -e "do shell script \"scutil --set HostName hera\" with administrator privileges" 

            echo "Enabling work profile..."
            echo 

            # reload cntlm config
            osascript -e "do shell script \"launchctl unload /Library/LaunchDaemons/homebrew.mxcl.cntlm.plist; launchctl load /Library/LaunchDaemons/homebrew.mxcl.cntlm.plist\" with administrator privileges" 
            echo "cntlm up..."

            # env vars for proxy
            export_proxy;

            # set enabled flag
            echo work > $PROFILE

        # work profile sitll need proxy env vars for current session
        elif grep work $PROFILE > /dev/null
        then

            echo "Work profile"
            
            # env vars for proxy
            export_proxy;
        fi
    fi

}

if [ "$1" = "up" ] ; then
    up;
    exit 0
elif [ "$1" = "down" ] ; then
    down;
    exit 0
elif [ "$1" = "reload" ] ; then
    down;
    up;
else
    enforce_profile;
fi
