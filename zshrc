# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ~/.zshrc: executed by zsh(1) for non-login shells.
# see /usr/share/doc/zsh/examples/startup-files/rc for examples

autoload -Uz compinit
compinit

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History file configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

# History behavior options
setopt APPEND_HISTORY          # Append history to file when shell exits
setopt INC_APPEND_HISTORY      # Write to history file immediately upon command execution
setopt SHARE_HISTORY           # Share command history across concurrent zsh sessions
setopt HIST_IGNORE_DUPS        # Do not record duplicate consecutive commands
setopt HIST_IGNORE_SPACE       # Do not record commands starting with a space
setopt HIST_REDUCE_BLANKS      # Remove extra blank spaces from recorded commands

bindkey '^R' history-incremental-search-backward

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [[ -x /usr/bin/tput ]] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/zsh/zshrc).
# Source global definitions
if [ -f /etc/zshrc ]; then
    source /etc/zshrc
fi

# User specific environment
if [[ ! "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$HOME/Library/Python/3.9/bin:$PATH"
fi

export PATH

ZSH_RCD=~/.zshrc.d
# User specific aliases and functions
if [ -d $ZSH_RCD ]; then
  source "$ZSH_RCD/os.sh"
  source "$ZSH_RCD/fn.sh"
  source "$ZSH_RCD/k8s.sh"
  source "$ZSH_RCD/alias.sh"
  source "$ZSH_RCD/python-venv.sh"
  source "$ZSH_RCD/completions.sh"
  source "$ZSH_RCD/nerdstorm.sh"
  source "$ZSH_RCD/ai.sh"
else
  echo "Minimal shell loaded"
  echo "Symlink 'zshrc.d' on your dotfiles to your home directory to source additional zsh functionality."
  echo 
fi

# Display something useful in terminal label 
echo -ne "\033]0;`whoami`@`hostname`$@\007"

# Extra colors
export TERM="xterm-256color"

# set lvim as the default editor so that commit messages will open it.
export EDITOR=`which nvim`

# Linux mint cows bullshit
export ANSIBLE_NOCOWS=1
export AWS_PROFILE=saml
#source <(kubectl completion zsh)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"

# Added by Antigravity
export PATH="/Users/purinda/.antigravity/antigravity/bin:$PATH"

# Added by Antigravity IDE
export PATH="/Users/purinda/.antigravity-ide/antigravity-ide/bin:$PATH"

# Flutter
export PATH="/Users/purinda/flutter/bin:$PATH"
export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH"
source ~/.powerlevel10k/powerlevel10k.zsh-theme

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C
# <<< grok installer <<<

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/purinda/.lmstudio/bin"
# End of LM Studio CLI section
