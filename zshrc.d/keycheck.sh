# keycheck — check whether an AI provider API key is accepted.
#
# Adding a provider is one line in the registry below. The fields are:
#
#   label | env-var | url | auth-header | auth-scheme | extra-headers | reject-codes
#
# `auth-scheme` is the word before the key in the auth header, and is empty for
# providers that send the key bare. `extra-headers` is a ";"-separated list of
# static headers the provider requires, and is empty when there are none.
# `reject-codes` lists the HTTP codes that provider returns for a bad key.
#
# Pick a URL that costs nothing and needs only the key, such as a model list.
#
# Keys never travel as arguments. An argument is written to ~/.zsh_history and
# is readable by any process running `ps` while the command is in flight.
#
# xAI answers 400 for a bad key where the others answer 401, so 400 is a reject
# code for that provider alone. The cost is that a genuinely malformed request
# to xAI reads as a rejected key, because xAI returns the same code for both.

typeset -gA _KEYCHECK_REGISTRY
_KEYCHECK_REGISTRY[openai]='OpenAI|OPENAI_API_KEY|https://api.openai.com/v1/models|Authorization|Bearer||401 403'
_KEYCHECK_REGISTRY[grok]='xAI (Grok)|XAI_API_KEY|https://api.x.ai/v1/models|Authorization|Bearer||400 401 403'
_KEYCHECK_REGISTRY[claude]='Anthropic (Claude)|ANTHROPIC_API_KEY|https://api.anthropic.com/v1/models|x-api-key||anthropic-version: 2023-06-01|401 403'

# Second names people reach for. Each maps to a key of the registry above.
typeset -gA _KEYCHECK_ALIASES
_KEYCHECK_ALIASES[anthropic]=claude
_KEYCHECK_ALIASES[xai]=grok

# Print the registry name for a word the user typed, or return 1 if there is none.
_keycheck_resolve() {
  local want="${1:l}"

  if [ -n "${_KEYCHECK_REGISTRY[$want]:-}" ]; then
    printf '%s\n' "$want"
    return 0
  fi

  if [ -n "${_KEYCHECK_ALIASES[$want]:-}" ]; then
    printf '%s\n' "${_KEYCHECK_ALIASES[$want]}"
    return 0
  fi

  return 1
}

# Check one provider.
#
# $1 registry name, $2 set to 1 to prompt when the variable is unset.
# Returns 0 accepted, 1 rejected, 2 could not run, 3 skipped.
_keycheck_one() {
  local provider="$1" allow_prompt="$2"
  local -a fields extra_args
  local label env url auth_header auth_scheme extras reject_codes key http header

  fields=("${(@s:|:)_KEYCHECK_REGISTRY[$provider]}")
  label="${fields[1]}"
  env="${fields[2]}"
  url="${fields[3]}"
  auth_header="${fields[4]}"
  auth_scheme="${fields[5]:-}"
  extras="${fields[6]:-}"
  reject_codes="${fields[7]:-401 403}"

  key="${(P)env:-}"

  if [ -z "$key" ] && [ "$allow_prompt" = 1 ]; then
    read -rs "key?$label API key: "
    printf '\n' >&2
  fi

  if [ -z "$key" ]; then
    if [ "$allow_prompt" = 1 ]; then
      printf 'keycheck %s: no key supplied. Set $%s, or type one at the prompt.\n' \
        "$provider" "$env" >&2
      return 2
    fi
    printf 'keycheck %s: skipped, $%s is not set.\n' "$provider" "$env"
    return 3
  fi

  # A quote or backslash would break out of the curl config line below, and no
  # provider key contains one. Rejecting them also catches a paste that picked
  # up surrounding quotes or trailing whitespace.
  case "$key" in
    *[!A-Za-z0-9_-]*)
      printf 'keycheck %s: key contains characters no API key uses. Refusing to send it.\n' \
        "$provider" >&2
      return 2
      ;;
  esac

  if [ -n "$auth_scheme" ]; then
    header="$auth_header: $auth_scheme $key"
  else
    header="$auth_header: $key"
  fi

  extra_args=()
  local h
  for h in ${(@s:;:)extras}; do
    [ -n "$h" ] && extra_args+=(--header "$h")
  done

  # Only the secret header goes through the config file on stdin. That keeps it
  # out of the process arguments, where the static headers are harmless.
  http="$(printf 'header = "%s"\n' "$header" \
    | command curl --config - \
        "${extra_args[@]}" \
        --silent --show-error --max-time 15 \
        --output /dev/null --write-out '%{http_code}' \
        "$url" 2>/dev/null)"

  case " $reject_codes " in
    *" $http "*)
      printf 'keycheck %s: rejected (HTTP %s). The key is invalid, revoked, or not permitted to read %s.\n' \
        "$provider" "$http" "$url" >&2
      return 1
      ;;
  esac

  case "$http" in
    200)
      printf 'keycheck %s: accepted (HTTP 200) — %s.\n' "$provider" "$label"
      return 0
      ;;
    429)
      printf 'keycheck %s: accepted but throttled (HTTP 429). The key is valid and either rate limited or out of quota.\n' \
        "$provider"
      return 0
      ;;
    000 | "")
      printf 'keycheck %s: no response from %s. Check network access, then retry.\n' \
        "$provider" "$url" >&2
      return 2
      ;;
    *)
      printf 'keycheck %s: unexpected response (HTTP %s).\n' "$provider" "$http" >&2
      return 2
      ;;
  esac
}

# Check every provider whose variable is set, and report the worst result.
_keycheck_all() {
  # Not named `status`: zsh reserves that as a read-only alias for $?.
  local name worst=0 result

  for name in ${(ko)_KEYCHECK_REGISTRY}; do
    _keycheck_one "$name" 0
    result=$?
    case $result in
      3) ;;
      *) [ $result -gt $worst ] && worst=$result ;;
    esac
  done

  return $worst
}

_keycheck_help() {
  local name a alias_list
  local -a fields

  printf 'keycheck — check whether an AI provider API key is accepted.\n\n'
  printf 'Usage:\n'
  printf '  keycheck <provider>   Check one provider.\n'
  printf '  keycheck all          Check every provider whose variable is set.\n'
  printf '  keycheck --help       Show this message.\n\n'
  printf 'Providers:\n'

  for name in ${(ko)_KEYCHECK_REGISTRY}; do
    fields=("${(@s:|:)_KEYCHECK_REGISTRY[$name]}")
    alias_list=""
    for a in ${(ko)_KEYCHECK_ALIASES}; do
      [ "${_KEYCHECK_ALIASES[$a]}" = "$name" ] && alias_list="$alias_list $a"
    done
    printf '  %-8s %-19s $%-18s%s\n' \
      "$name" "${fields[1]}" "${fields[2]}" "${alias_list:+alias:$alias_list}"
  done

  printf '\n'
  printf 'The key is read from the variable shown above. When that is unset, keycheck\n'
  printf 'prompts for it without echoing. A key is never taken as an argument, so it\n'
  printf 'stays out of ~/.zsh_history and out of the process arguments.\n\n'
  printf 'Exit codes: 0 accepted, 1 rejected, 2 the check could not run, 3 skipped.\n'
}

keycheck() {
  local arg="${1:-}" provider

  case "$arg" in
    "" | -h | --help | help)
      _keycheck_help
      return 0
      ;;
  esac

  if ! command -v curl >/dev/null 2>&1; then
    printf 'keycheck: curl is not installed. Install it, then retry.\n' >&2
    return 2
  fi

  if [ "$arg" = all ]; then
    _keycheck_all
    return $?
  fi

  if ! provider="$(_keycheck_resolve "$arg")"; then
    local -a names
    names=(${(ko)_KEYCHECK_REGISTRY})
    printf 'keycheck: unknown provider "%s". Supported: %s.\n' \
      "$arg" "${(j:, :)names}" >&2
    printf 'Run `keycheck --help` for usage.\n' >&2
    return 2
  fi

  _keycheck_one "$provider" 1
}

# Complete provider names, so a new registry entry is completable at once.
if (( $+functions[compdef] )); then
  _keycheck_complete() {
    compadd all ${(ko)_KEYCHECK_REGISTRY} ${(ko)_KEYCHECK_ALIASES}
  }
  compdef _keycheck_complete keycheck
fi
