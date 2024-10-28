# When you hit enter, brings the prompt to the middle of the screen

function () {
  zmodload zsh/terminfo 
  mid_point=$((LINES/2))

  down_half=""
  up_half=""
  for i in {1..$mid_point}; do
    down_half="$down_half$terminfo[cud1]"
    up_half="$up_half$terminfo[cuu1]"
  done

  magic-enter () {
      if [[ -z $BUFFER ]]
      then
          print ${halfpage_down}${halfpage_up}$terminfo[cuu1]
          zle reset-prompt
      else
          zle accept-line
      fi
  }

  zle -N magic-enter
  bindkey "^M" magic-enter
}
