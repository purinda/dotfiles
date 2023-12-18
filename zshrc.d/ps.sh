function my_set_prompt() {
  PS1='\w'

  if gitstatus_query && [[ "$VCS_STATUS_RESULT" == ok-sync ]]; then
    if [[ -n "$VCS_STATUS_LOCAL_BRANCH" ]]; then
      PS1+=" ${VCS_STATUS_LOCAL_BRANCH//\\/\\\\}"  # escape backslash
    else
      PS1+=" @${VCS_STATUS_COMMIT//\\/\\\\}"       # escape backslash
    fi
    (( VCS_STATUS_HAS_STAGED"    )) && PS1+='+'
    (( VCS_STATUS_HAS_UNSTAGED"  )) && PS1+='!'
    (( VCS_STATUS_HAS_UNTRACKED" )) && PS1+='?'
  fi

  PS1+='\n\$ '

  shopt -u promptvars  # disable expansion of '$(...)' and the like
}

gitstatus_stop && gitstatus_start
PROMPT_COMMAND=my_set_prompt