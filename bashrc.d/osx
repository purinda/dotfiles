if [[ "$OSTYPE" == "darwin"* ]]; then
    # Brew
    eval $(/opt/homebrew/bin/brew shellenv)

    # OSX /usr/local/bin/
    export PATH="/usr/local/bin/:$PATH"
    export PATH="/usr/local/sbin:$PATH"

    # Brew paths
    export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
    export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
    export PATH="/opt/homebrew/anaconda3/bin:$PATH"

    # Rust
    export PATH="/Users/purinda/.cargo/bin:$PATH"

    # Conda
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
            . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
        else
            export PATH="/opt/homebrew/anaconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
fi
