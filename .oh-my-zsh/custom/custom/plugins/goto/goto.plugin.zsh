goto() {
	case $1 in
    ".config"|"config"|"cfg")
      cd ~/.config
      return
      ;;
    "site"|"johnk.dev")
    	cd ~/repos/john-h-k.github.io
    	return
    	;;
		"repos")
			cd ~/repos
			return
			;;
    "herodoctors.co.uk") # Special case for auto clockin
      cd ~/repos/herodoctors.co.uk
      ws clockin --quiet-if-nop # don't print if already clocked in
      return
      ;;
		"clr")
			cd ~/repos/runtime/artifacts/bin/coreclr/
			return
			;;
		"codejam")
			cd ~/Documents/codejam
			return
			;;
	esac
	
	if [[ -d ~/"repos/$1" ]]; then
		cd ~/repos/$1
	elif [[ -d ~/"$1" ]]; then
		cd ~/$1
	else
		echo "'${1}' is not a recognized location"
		return 1
	fi
}

_goto_autocomplete() {
	local file
	if [[ "repos" =~ $2 ]]; then
		COMPREPLY+=("repos")
	fi

	if [[ "clr" =~ $2 ]]; then
		COMPREPLY+=("clr")
	fi

	term="${COMP_WORDS[1]}"
	for file in ~/repos/$term* ~/$term*; do
		echo "$file"
		[[ -d $file ]] || continue

		COMPREPLY+=( $(basename "${file}") )
		COMPREPLY+=( $(basename "${file:l}") )
		COMPREPLY+=( $(basename "${file:u}") )
	done
}

complete -F _goto_autocomplete goto
