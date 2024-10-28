# # UNCOMMENT TO PROFILE
# zmodload zsh/zprof


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

qwertyuiopasdfghjklzxcvbnm() {
	print "stop procrastinating you shithead"
}

# If you come from bash you might have to change your $PATH.
export JAVA_HOME=/Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home
export CORE_ROOT="~/repos/runtime/artifacts/bin/coreclr/OSX.arm64.Checked"
export CORE_LIBRARIES="/usr/local/share/dotnet/shared/Microsoft.NETCore.App/6.0.3"
export CORE_RUN="/Users/johnk/repos/runtime/artifacts/bin/coreclr/OSX.arm64.Checked/corerun"
export CORE_RUN_DEBUG="/Users/johnk/repos/runtime/artifacts/bin/coreclr/OSX.arm64.Debug/corerun"
export EDITOR=hx

# Dilemma: I like having backticks in my commit messages, but I also often like single quotes
# I generally use backticks around something to signify a code identifier, and single quotes to signify any other sort of identifier/word
# Setting RC_QUOTES option means double single quotes, when inside a single quote string, are replaced with one single quote
# Without RC_QUOTES: `echo 'foo''bar'` -> foobar
# With RC_QUOTES   : `echo 'foo''bar'` -> foo'bar
setopt rcquotes

# Environment managers
eval "$(opam env)" # opam (OCaml)
eval "$(pyenv init -)" # pyenv (Python)
eval "$(rbenv init - zsh)" # rbenv (Ruby)
eval "$(fnm env --use-on-cd)" # fnm (Node)

# Path to your oh-my-zsh installation.
export ZSH="/Users/johnk/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
 HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	zsh-vi-mode

	git
	macos
	docker
	docker-compose
	jsontools

	# Custom
	activity-tracker
	big-files
	chrome
	clean-branches
	git-delta
	goto
	ip
	magic-enter
	ngrok
	ntfy
	plugin
	subcommands
	touchid-auth
	ws
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

zstyle ':completion:*'  matcher-list 'm:{a-z}={A-Z}'
setopt extendedglob
unsetopt CASE_GLOB

fpath=($fpath "/Users/johnk/.zfunctions")

# Set typewritten ZSH as a prompt
#autoload -U promptinit; promptinit
#prompt typewritten

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

function nosleep() {
  sudo pmset -a disablesleep 1
  echo "sudo pmset -a disablesleep 0" | at now + 1 hour
}

function resleep() {
  sudo pmset -a disablesleep 0
}

_listening_file_editor() {
  target="$1"
	previous=$(shasum $target | cut -d ' ' -f 1)
	$EDITOR "$target"
	post=$(shasum $target | cut -d ' ' -f 1)

	if [[ $previous == $post ]]; then
		return 0
	fi	

	read "confirm?Apply updates from '$target' edit? [Y/n]: " 
	if [[ "yes" =~ "${confirm:l}" ]]; then
		omz reload
		echo "Updates to '$target' applied"
	fi
}

rmcr() {
	print "Removing \`/r\` characters from $@"
	gsed -i 's/\r$//' "$@"
}

zshrc() {
	_listening_file_editor ~/.zshrc
}

zshenv() {
	_listening_file_editor ~/.zshenv
}

sdk_path() {
	echo $(xcrun -sdk macosx --show-sdk-path)
}

link() {
	ld "$@" -lSystem -syslibroot $(xcrun -sdk macosx --show-sdk-path)
}

remove_ext() {
	echo "$(echo "$1" | rev | cut -f 2- -d '.' | rev)"
}

asm() {
	file="$1"
	obj_file="$1.o"
	out_file=$(remove_ext "$1")
	as "$file" -o "$obj_file" || return $?
	link "$obj_file" -o "$out_file" || return $?
	
	rm "$obj_file"

	echo "Assembled to '${out_file}'"

	return $?
}

gtfd() {
	cd "$(dirname "$1")"
}

corerun() {
	~/repos/runtime/artifacts/bin/coreclr/OSX.arm64.Checked/corerun "$@"
}

docker-ui() {
	/Applications/Docker.app/Contents/MacOS/Docker
	return 0
}

star-count() {
	repos=$(gh repo list --limit 2000 --json isFork,nameWithOwner --jq '.[] | select(.isFork|not) | .nameWithOwner')

	total=0
	for repo in "${(@f)repos}"; do
		stars=$(gh repo view $repo --json stargazerCount --jq ".stargazerCount")
		total=$((total + stars))
	done

	echo "Total stars: $total"
}

stocks() {
	/Applications/OpenBB\ Terminal/OpenBB\ Terminal ; exit;
}

invoke_llvm() {
	cmd="$1"
	shift 1
	/opt/homebrew/opt/llvm/bin/${cmd} "$@"
}

segfault() {
	out=$(mktemp)
	echo '#include <stdio.h>\nint main() { *((volatile int*)1) = 0; }' | clang -x c -o "$out" -
	"$out"
	rm "$out"
}

fuzz() {
	printf '%s\n' ./**/*$1*
}

imsg() {
	target="$1"
	shift
	osascript -e 'tell application "Messages" to send "'"$*"'" to buddy "'"$target"'"'
}

recents() {
	if [ -z "$1" ]; then
		ls -tU -1
	else
		ls -tU -1 --color=always | head "-$1"
	fi
}

fix-twitter() {
	sudo dscacheutil -flushcache  
	sudo killall mDNSResponder  
}

# I forget this all the time
alias loc=scc

export PATH="$PATH:/Users/johnk/.kit/bin"
export PATH="$PATH:/Users/johnk/go/bin"
export PATH="$PATH:/Users/johnk/go/bin"

# CONDA INITIALIZE DISABLED - Very slow!
# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/Users/johnk/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/Users/johnk/miniforge3/etc/profile.d/conda.sh" ]; then
#         . "/Users/johnk/miniforge3/etc/profile.d/conda.sh"
#     else
#         export PATH="/Users/johnk/miniforge3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<

# # conda deactivate

export PATH="/opt/homebrew/opt/curl/bin:$PATH"
#export PATH="$HOME/.rbenv/bin:$PATH"

source /Users/johnk/.docker/init-zsh.sh || true # Added by Docker Desktop

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Unsets existing 'll' alias to 'ls -l'
alias ll >> /dev/null && unalias ll

ll() {
  cd "$(llama "$@")"
}

expose-port() {
  sudo lsof -i :$1
}

zparseopts-help() {
  open 'https://man.archlinux.org/man/zshmodules.1.en#zparseopts'
}

alias chat=/Users/johnk/repos/chat

#export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
#export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
#export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
#export CXXFLAGS="-I/opt/homebrew/opt/llvm/include"

ad() {
  if [ $(($(df / | awk '{print $4}' | tail -1) * 512)) -lt $((16 * 1024 * 1024 * 1024)) ]; then
	print 'Warning: low free space'
  fi
}

tracker() {
  open 'https://github.com/john-h-k/tracker/issues'
}


newline() {
	for file in "$@"; do
		tail -c 1 "$file" | read || echo >> "$file"
	done
}

servedir() {
	port="${1:-8080}"
	python -m http.server -d . $port
}

lvim_km() {
  # open LazyVim keymaps
  open 'https://www.lazyvim.org/keymaps'
}

findal() {
	# search aliases
	alias | grep "$1"
}

disk() {
	df -h /
}

export PATH="/Users/johnk/.yarn/bin:$PATH"
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export PATH="/opt/homebrew/opt/llvm/bin/lldb-dap:$PATH"

# eval "$(starship init zsh)"

export NNN_COLORS="21530fa0"

BLK="04" CHR="27" DIR="27" EXE="a0" REG="00" HARDLINK="00" SYMLINK="06" MISSING="00" ORPHAN="01" FIFO="0F" SOCK="0F" OTHER="02"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"

alias fs='nnn -de'
alias c=code
alias z=zellij
alias n=nvim
alias lg=lazygit	

export LLVM_SYS_150_PREFIX=/opt/homebrew/opt/llvm@15

# If zprof was loaded, run it
command -v zprof && zprof

export PATH="$(rbenv root)/shims:$PATH"

# Enable proper search history even with zsh-vi-mode
zvm_after_init_commands+=("bindkey '^[[A' up-line-or-search" "bindkey '^[[B' down-line-or-search")

export PATH="$PATH:/Users/johnk/.local/bin"

[ -f "/Users/johnk/.ghcup/env" ] && source "/Users/johnk/.ghcup/env" # ghcup-env

# # Required for installation of various native dependencies to work
# export CC=$(xcrun --find clang)
# export CXX=$(xcrun --find clang++)
export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)

export HELIX_RUNTIME="/Users/johnk/.config/helix/runtime"
export LIBRARY_PATH="$LIBRARY_PATH:$(brew --prefix)/lib"

