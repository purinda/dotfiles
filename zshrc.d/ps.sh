BIBlack="%{$(tput setaf 8)%}"  # Black
UC="%{$(tput setaf 7)%}"        # User's color
HC="%{$(tput setaf 4)%}"        # Host's color
CC="%{$(tput setaf 6)%}"        # Current directory's color
GC="%{$(tput setaf 2)%}"        # Git branch's color
RC="%{$(tput sgr0)%}"           # Reset color

PS1="${BIBlack}[%*] $PROMPT "