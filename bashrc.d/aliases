# Commented to support docker short hand aliases
alias s='sudo'
alias v='vim'
alias lsd='ll -d */'
alias h='history | grep $1'
alias q='exit'
alias shutdown='sudo shutdown -h now'
alias reboot='sudo reboot'

# Commented to support docker short hand aliases
alias g='git'
alias gs='git status'
alias ga='git add'
alias gci='git commit'
alias gc='git checkout'
alias gl='git lg'
alias gp='git push'
alias gd='git diff'
alias tree='tree -C'
alias sg='grep -HIrin --colour=always' 
alias dmenv='setup_dockermachine $1'
alias c=docker-compose
alias cup='docker-compose up -d'

alias la='ls -A'
alias l='ls -CF'

unset use_color safe_term match_lhs sh

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -mh'                     # show sizes in MB
alias more=less

# use htop instead of top if htop is installed
if type htop &>/dev/null; then
    alias top='htop'
fi

# OS specific aliases
if [ "$(uname)" == "Darwin" ]; then

    alias ll='ls -lhFG'
    alias all='ls -AlhiFG'

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then

    alias ll='ls -lhF --color'
    alias all='ls -AlhiF --color'

fi
