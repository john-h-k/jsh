plugin() {
    invoke-subcommand "plugin" "${@}"
}

plugin-enable() {
    local with_new_plugins=(${(@f)$(_plugin_get_enabled)})

    for plugin in "$@"; do
        if ! _plugin_exists "$plugin"; then
            print "Plugin '$plugin' does not exist!"
            continue
        fi

        if _plugin_enabled "$plugin"; then
            print "Plugin '$plugin' already enabled!"
            continue
        fi

        with_new_plugins+=($plugin)

        print "Plugin '$plugin' successfully enabled"
    done

    _plugin_write_plugins $with_new_plugins

    print 'Run `omz reload` to apply changes'
}

plugin-disable() {
    local without_plugins=(${(@f)$(_plugin_get_enabled)})

    for plugin in "$@"; do
        if ! _plugin_exists "$plugin"; then
            print "Plugin '$plugin' does not exist!"
            continue
        fi

        if ! _plugin_enabled "$plugin"; then
            print "Plugin '$plugin' already disabled!"
            continue
        fi

        local removable=($plugin)
        without_plugins=(${without_plugins:|removable})

        print "Plugin '$plugin' successfully disabled"
    done

    _plugin_write_plugins $without_plugins

    print 'Run `omz reload` to apply changes'
}

plugin-new() {
    if _plugin_exists $1; then
        print "Plugin already exists!"
        return -1
    fi

    mkdir "$ZSH_CUSTOM/plugins/$1"
    touch "$ZSH_CUSTOM/plugins/$1/$1.plugin.zsh"
    $EDITOR "$ZSH_CUSTOM/plugins/$1"
}

plugin-list() {
    local custom_plugins bold italic normal
    
    custom_plugins=$(ls $ZSH_CUSTOM/plugins | sort)
    custom_plugins=(${(f)custom_plugins})

    bold=$(tput bold)
    italic='\e[3m'
    normal=$(tput sgr0)

    for file in $custom_plugins
    do
        if _plugin_enabled $file; then
            print -P "%F{cyan}${bold}${file}${normal}%f"
        else
            print -P "%F{red}${italic}(disabled) ${file}${normal}%f"
        fi
    done
}

plugin-edit() {
    if ! _plugin_exists "$1"; then
        print "Plugin '$1' does not exist!"
        return -1
    fi

    $EDITOR "$ZSH_CUSTOM/plugins/$1"
}

_plugin_write_plugins() {
    cp ~/.zshrc ~/.zshrc.bak

    local sorted_plugins=(${(@f)$(
        printf '%s\n' "${@}" \
            | tr -d ' \t\r' \
            | sort -d
    )})

    local formatted_plugins="$(printf "%s\\\n\\\t" "${sorted_plugins[@]}")"

    cat ~/.zshrc \
        | tr '\n' '\0' \
        | gsed -E "s/# Custom[^ ][^)]+/# Custom\x0\t${formatted_plugins:0:-2}/" \
        | tr '\0' '\n' > ~/.zshrc
}

_plugin_exists() {
    [[ -d "$ZSH_CUSTOM/plugins/$1" ]]
}

_plugin_enabled() {
    plugin_array=(${=$(print $plugins)})
    (($plugin_array[(Ie)$1]))
}

_plugin_get_enabled() {
    ggrep -zoP 'plugins=\([^)]*# Custom([^)]+)\)' ~/.zshrc \
        | ggrep -zoP '(?<=# Custom)[^)]+' \
        | tr -d '\t\r ' \
        | xargs
}
