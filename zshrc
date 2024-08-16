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

# don't put duplicate lines or lines starting with space in the history.
# See zshoptions(1) for more options
HISTCONTROL=ignoredups

# append to the history file, don't overwrite it
setopt histappend

# for setting history length see HISTSIZE and HISTFILESIZE in zshparam(1)
HISTSIZE=10000
HISTFILESIZE=20000
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
  source "$ZSH_RCD/iterm2.sh"
  source "$ZSH_RCD/os.sh"
  source "$ZSH_RCD/fn.sh"
  source "$ZSH_RCD/k8s.sh"
  source "$ZSH_RCD/alias.sh"
  source "$ZSH_RCD/python-venv.sh"
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
export EDITOR=`which lvim`

# Linux mint cows bullshit
export ANSIBLE_NOCOWS=1
export AWS_PROFILE=saml
source <(kubectl completion zsh)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source ~/.powerlevel10k/powerlevel10k.zsh-theme
