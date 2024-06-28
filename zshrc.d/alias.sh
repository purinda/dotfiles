# Commented to support docker shorthand aliases
alias s='sudo'
alias v='vim'
alias lsd='ls -d -- */'
alias h='history | grep $1'
alias q='exit'
alias shutdown='sudo shutdown -h now'
alias reboot='sudo reboot'

# Commented to support docker shorthand aliases
alias g='git'
alias gs='git status'
alias gsh='git show --diff-merges=on'
alias ga='git add'
alias gci='git commit'
alias gc='git checkout'
alias gl='git lg'
alias gp='git push'
alias gd='git diff'
alias tree='eza --tree'
alias sg='grep -HIrin --color=always'
alias c='docker-compose'
alias cup='docker-compose up -d'

alias la='eza -A'
alias l='eza -l'
alias ll='eza -lG'
alias ls='eza'
alias all='eza -AliG'

alias cat='bat --color=always --style=plain'
unset use_color safe_term match_lhs sh

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -mh'                     # show sizes in MB
alias more=less

# tmux
alias t="/opt/homebrew/bin/tmux attach || /opt/homebrew/bin/tmux new"
alias ta="/opt/homebrew/bin/tmux attach"
alias tn="/opt/homebrew/bin/tmux new"

# Use htop instead of top if htop is installed
if type btop &>/dev/null; then
    alias top='btop'
fi

