venv-setup() {
    if [ -z "$1" ]; then
        echo "Usage: venv-setup <path> [python_version]"
        return 1
    fi

    # If no Python version is specified, default to python3
    python_version=${2:-python3}

    # Create the virtual environment with the specified Python version
    "$python_version" -m venv "$1"

    # Activate the virtual environment
    source "$1/bin/activate"
}

venv-activate() {
    if [ -z "$1" ]; then
        echo "Usage: venv-activate <path>"
        return 1
    fi

    if [ ! -d "$1/bin" ]; then
        echo "No valid virtual environment found at $1"
        return 1
    fi

    source "$1/bin/activate"
}

venv-deactivate() {
    if [ -z "$VIRTUAL_ENV" ]; then
        echo "No virtual environment is activated."
        return 1
    fi

    deactivate
}
