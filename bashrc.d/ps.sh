ENV=${HOME}/.env

bash_prompt() {
  local NONE="\[\033[0m\]"    # unsets color to term's fg color

  # regular colors
  local K="\[\033[1;30m\]"    # black
  local R="\[\033[1;31m\]"    # red 
  local G="\[\033[1;32m\]"    # green
  local Y="\[\033[1;33m\]"    # yellow
  local B="\[\033[1;34m\]"    # blue
  local M="\[\033[1;35m\]"    # magenta
  local C="\[\033[1;36m\]"    # cyan
  local W="\[\033[1;37m\]"    # white
  local BIBlack="\[\033[1;90m\]"      # Black


  local UC=$C                 # user's color
  [ $UID -eq "0" ] && UC=$R   # root's color
 
  # Default tab color
  tab_blue
 
  if [ -f $ENV ]; 
  then
    if grep dev $ENV > /dev/null 
    then
      PS1="$BIBlack[\t] $UC\u$W@$G\h$C[$W\w$C]$G\$(__git_branch)$R\$(__git_dirty)$W+$NONE "

      # Change tab color
      tab_green
    elif grep prod $ENV > /dev/null
    then
      PS1="$BIBlack[\t] $UC\u$W@$R\h$C[$W\w$C]$G\$(__git_branch)$R\$(__git_dirty)$W+$NONE "

      # Change tab color
      tab_red
    fi
  else
     PS1="$BIBlack[\t] $UC\u$W@$B\h$C[$W\w$C]$G\$(__git_branch)$R\$(__git_dirty)$W+$NONE "
  fi
}

bash_prompt
unset bash_prompt
