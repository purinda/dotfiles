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
# Container runtime & Compose detection (Docker takes precedence over Podman)
if type docker &>/dev/null; then
    alias dps='docker ps'
    alias dpsa='docker ps -a'
    alias di='docker images'
    alias dex='docker exec -it'

    if docker compose version &>/dev/null 2>&1; then
        alias c='docker compose'
        alias cup='docker compose up -d'
        if ! type docker-compose &>/dev/null; then
            alias docker-compose='docker compose'
        fi
    elif type docker-compose &>/dev/null; then
        alias c='docker-compose'
        alias cup='docker-compose up -d'
    fi
elif type podman &>/dev/null; then
    alias docker='podman'
    alias dps='podman ps'
    alias dpsa='podman ps -a'
    alias di='podman images'
    alias dex='podman exec -it'

    if type podman-compose &>/dev/null; then
        alias docker-compose='podman-compose'
        alias c='podman-compose'
        alias cup='podman-compose up -d'
    elif podman compose version &>/dev/null 2>&1; then
        alias docker-compose='podman compose'
        alias c='podman compose'
        alias cup='podman compose up -d'
    fi
else
    alias c='docker-compose'
    alias cup='docker-compose up -d'
fi

# Logs
alias cl='c logs -f $1'
clj() {
  c logs --no-log-prefix -f "$1" | grep '^{' | jq -r '.message'
}

alias la='eza -A'
alias ll='eza -l'
alias l='eza -lG'
alias ls='eza'
alias all='eza -AliG'

alias cat='bat --color=always --style=plain'
unset use_color safe_term match_lhs sh

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -mh'                     # show sizes in MB
alias more=less

# tmux
TMUX_CMD=$(which tmux)
alias t="$TMUX_CMD attach || $TMUX_CMD new"
alias ta="$TMUX_CMD attach"
alias tn="$TMUX_CMD new"

# Use htop instead of top if htop is installed
if type btop &>/dev/null; then
    alias top='btop'
fi

