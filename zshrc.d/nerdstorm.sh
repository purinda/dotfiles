# Nerdstorm platform tooling — `cicd` runnable from anywhere.
#
# The engine lives in the platform-deployment-toolkit checkout; this puts its
# launcher on PATH. Checkout resolution mirrors the app repos' ./cicd shims so
# there is one convention everywhere:
#   1. $PLATFORM_REPO
#   2. ~/.config/nerdstorm/platform-repo   (a file containing the path)
#   3. the default checkout location
#
# Usage: inside any app checkout `cicd uat diff` just works (product resolved
# from the git remote); anywhere else pass `--product <name>` — it never
# guesses. `cicd` with no args opens the interactive menu.
_nerdstorm_platform_repo() {
  if [ -n "${PLATFORM_REPO:-}" ] && [ -d "${PLATFORM_REPO:-}" ]; then
    echo "$PLATFORM_REPO"
  elif [ -f "$HOME/.config/nerdstorm/platform-repo" ]; then
    head -1 "$HOME/.config/nerdstorm/platform-repo"
  else
    echo "$HOME/src/nerdstorm.org/platform-deployment-toolkit"
  fi
}

_nerdstorm_pdt="$(_nerdstorm_platform_repo)"
if [ -x "$_nerdstorm_pdt/cicd/bin/cicd" ]; then
  export PATH="$_nerdstorm_pdt/cicd/bin:$PATH"
fi
unset _nerdstorm_pdt
