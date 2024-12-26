# Load completions for ngrok
if command -v ngrok &>/dev/null; then
    eval "$(ngrok completion)"
fi
