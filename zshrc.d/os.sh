# Homebrew is the package manager on Bluefin and macOS. Discover it even when
# the desktop session has not added it to PATH yet.
if command -v brew >/dev/null 2>&1; then
    eval "$(command brew shellenv)"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Keep user tools (including rootless Docker) ahead of system tools.
typeset -U path
path=("$HOME/.local/bin" "$HOME/bin" $path)

# Only add optional tool paths when installed, on either platform.
for tool_dir in \
    "$HOME/.cargo/bin" \
    "$HOME/Library/Python/3.9/bin" \
    "$HOME/.grok/bin" \
    "$HOME/flutter/bin" \
    "$HOME/.antigravity/antigravity/bin" \
    "$HOME/.antigravity-ide/antigravity-ide/bin" \
    "$HOME/.lmstudio/bin"; do
    [[ ! -d "$tool_dir" ]] || path+=("$tool_dir")
done
if [[ "$OSTYPE" == darwin* ]]; then
    for tool_dir in \
        "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/node@22/bin" \
        "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/mysql-client/bin" \
        "${HOMEBREW_PREFIX:-/opt/homebrew}/opt/sqlite/bin" \
        "${HOMEBREW_PREFIX:-/opt/homebrew}/share/google-cloud-sdk/bin"; do
        [[ ! -d "$tool_dir" ]] || path+=("$tool_dir")
    done
fi
export PATH
unset tool_dir

# Ubuntu calls the bat executable batcat.
if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
    bat() { command batcat "$@"; }
fi
