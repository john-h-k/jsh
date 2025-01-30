EK_KEY_DIR="/Users/johnk/repos/eval-pk"

_ek-sel() {
    local name="$1"
    local files
    local selected_file

    # Find all files matching the name with any date
    files=("$EK_KEY_DIR"/${name}*.txt)

    # Check if no files found
    if [ ${#files[@]} -eq 0 ]; then
        echo "No keys found with name: $name"
        return 1
    elif [ ${#files[@]} -eq 1 ]; then
        # Only one file found; return it
        echo "$files[1]"
    else
        # Multiple files found; prompt user to select one
        echo "Multiple keys found with name '$name':"
        local options=()
        for file in "${files[@]}"; do
            options+=("$(basename "$file")")
        done

        # Display options and get user selection
        PS3="Select the key to use: "
        select opt in "${options[@]}"; do
            if [[ -n "$opt" ]]; then
                selected_file="${EK_KEY_DIR}/$opt"
                echo "$selected_file"
                break
            else
                echo "Invalid selection. Please try again."
            fi
        done
    fi
}

ek-add() {
    local edit_mode=0
    local OPTIND opt
    local key_name
    local date_str
    local file
    local pub_key

    while getopts ":e" opt; do
        case ${opt} in
            e )
                edit_mode=1
                ;;
            \? )
                echo "Invalid Option: -$OPTARG" >&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND -1))

    if [ $# -lt 1 ]; then
        echo "Usage: add [-e] <key_name>"
        return 1
    fi

    key_name="$1"

    if [ "$edit_mode" -eq 0 ]; then
        # new key

        date_str=$(date +%Y-%m-%d)
        file="${EK_KEY_DIR}/${key_name}-${date_str}.txt"

        if [ -e "$file" ]; then
            echo "File $file already exists. Use -e to edit an existing key."
            return 1
        fi

        echo "Enter public key: "
        pub_key=""
        while IFS= read -r line; do
          [[ -z "$line" ]] && break
          pub_key+="${line}\n"
        done
        pub_key="${pub_key%\\n}"

        echo "$pub_key" > "$file"
    else
        # existing key file

        file=$(_ek-sel "$key_name")
        if [ $? -ne 0 ]; then
            return 1
        fi

        ssh-add -d "$file" 2>/dev/null
    fi

    chmod 600 "$file"
    ssh-add --apple-use-keychain "$file"

    echo "Key added: $(basename "$file")"
}

ek-ls() {
    local files=("$EK_KEY_DIR"/*)

    if [ "${#files[@]}" -eq 0 ]; then
        echo "No keys found in $EK_KEY_DIR."
        return 0
    fi

    local loaded_fps
    loaded_fps=$(ssh-add -l | awk '{print $2}')

    local fp
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            fp=$(ssh-keygen -lf "$file" | awk '{print $2}')

            if echo "$loaded_fps" | grep -qF "$fp"; then
                echo -e "\e[1m\e[1;32m$(basename "$file")\e[0m"
            else
                echo -e "\e[1m\e[1;31mNOT LOADED - $(basename "$file")\e[0m"
            fi
        fi
    done
}

ek-rm() {
    local key_name="$1"
    local file
    local fp

    if [ -z "$key_name" ]; then
        echo "Usage: rm <key_name>"
        return 1
    fi

    file=$(_ek-sel "$key_name")
    if [ $? -ne 0 ]; then
        return 1
    fi

    fp=$(ssh-keygen -lf "$file" 2>/dev/null | awk '{print $2}')

    ssh-add -d "$file" 2>/dev/null
    rm "$file"

    echo "Key '$file' has been removed."
}

ek() {
    invoke-subcommand "ek" "${@}"
}

