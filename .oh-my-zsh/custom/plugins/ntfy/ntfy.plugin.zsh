ntfy() {
    local message=${1:-"Command finished"}
    curl -d "$message" ntfy.sh/johnharrykelly-command-done > /dev/null 2>&1
}
