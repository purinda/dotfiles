venv-setup() {
    if [ -z "$1" ]; then
        echo "Usage: venv-setup <path>"
        return 1
    fi

    python3 -m venv "$1"
    source "$1/bin/activate"
}

venv-deactivate() {
    if [ -z "$VIRTUAL_ENV" ]; then
        echo "No virtual environment is activated."
        return 1
    fi

    deactivate
}