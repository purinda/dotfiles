if [[ "$OSTYPE" == "darwin"* ]]; then
    # Brew
    eval "$(command brew shellenv)"

    # OSX /usr/local/bin/
    export PATH="/usr/local/bin/:$PATH"
    export PATH="/usr/local/sbin:$PATH"

    # Brew paths
    export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
    export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
    export PATH="/opt/homebrew/anaconda3/bin:$PATH"

    # Rust
    export PATH="$HOME/.cargo/bin:$PATH"
fi
