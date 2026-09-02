# AI and LLM shell helpers.
#
# Anything that talks to a model provider from the shell belongs here.
#
# Keep provider credentials out of argv and out of history. A key passed as an
# argument is written to ~/.zsh_history, and any process running `ps` can read
# it while the command is in flight. So no function here takes a key as a
# positional argument.

# Report whether an OpenAI API key is currently accepted by the API.
#
# The key comes from $OPENAI_API_KEY when that is set, and otherwise from a
# prompt that does not echo. It reaches curl through a config file on stdin
# rather than a -H flag, which keeps it out of the process arguments too.
#
# Usage: openai_key_check
# Exit:  0 accepted, 1 rejected, 2 the check could not run.
openai_key_check() {
  local key http

  if ! command -v curl >/dev/null 2>&1; then
    printf 'openai_key_check: curl is not installed. Install it, then retry.\n' >&2
    return 2
  fi

  if [ -n "${OPENAI_API_KEY:-}" ]; then
    key="$OPENAI_API_KEY"
  else
    read -rs "key?OpenAI API key: "
    printf '\n' >&2
  fi

  if [ -z "$key" ]; then
    printf 'openai_key_check: no key supplied. Set OPENAI_API_KEY, or type one at the prompt.\n' >&2
    return 2
  fi

  # A quote or backslash would break out of the curl config line below, and no
  # real OpenAI key contains one. Rejecting them also catches a paste that
  # picked up surrounding quotes or trailing whitespace.
  case "$key" in
    *[!A-Za-z0-9_-]*)
      printf 'openai_key_check: key contains characters no OpenAI key uses. Refusing to send it.\n' >&2
      return 2
      ;;
  esac

  http="$(printf 'header = "Authorization: Bearer %s"\n' "$key" \
    | command curl --config - \
        --silent --show-error --max-time 15 \
        --output /dev/null --write-out '%{http_code}' \
        https://api.openai.com/v1/models 2>/dev/null)"

  case "$http" in
    200)
      printf 'openai_key_check: accepted (HTTP 200).\n'
      return 0
      ;;
    429)
      printf 'openai_key_check: accepted but throttled (HTTP 429). The key is valid and either rate limited or out of quota.\n'
      return 0
      ;;
    401)
      printf 'openai_key_check: rejected (HTTP 401). The key is invalid or revoked.\n' >&2
      return 1
      ;;
    403)
      printf 'openai_key_check: rejected (HTTP 403). The key is known but not allowed to list models.\n' >&2
      return 1
      ;;
    000 | "")
      printf 'openai_key_check: no response from api.openai.com. Check network access, then retry.\n' >&2
      return 2
      ;;
    *)
      printf 'openai_key_check: unexpected response (HTTP %s).\n' "$http" >&2
      return 2
      ;;
  esac
}
