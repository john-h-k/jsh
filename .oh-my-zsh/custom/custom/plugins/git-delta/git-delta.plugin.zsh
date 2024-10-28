git-delta() {
  git rev-parse --is-inside-work-tree 1> /dev/null || return -1

  local flag_exclude flag_all
  local flag_from=($(git default-branch))

  zparseopts -D -F -K - \
    {e,-exclude}+:=flag_exclude \
    {f,-from}:=flag_from \
    {a,-all}=flag_all ||
    return 1

  from="$flag_from[-1]"
  print "Using '$from' as base..."

  local flag_names=(-e --exclude)

  local exclude_args='$.'

  if [ ${#flag_exclude[@]} != 0 ]; then
    printf -v exclude_args '(%s)|' "${(@)flag_exclude:|flag_names}"
    exclude_args=${exclude_args:0:-1}

    print "Excluding files matching: '$exclude_args'"
  fi


  local commits
  
  if [ ${#flag_all[@]} != 0 ]; then
    commits=$(git log "$from..HEAD" --oneline --pretty=format:%h)
  else
    commits=$(git log "$from..HEAD" -1 --oneline --pretty=format:%h)
  fi

  print "Processing $(echo $commits | wc -l) commits..."

  local add=0
  local del=0

  for commit in ${(@f)commits}; do
    local totals="$(git diff $commit~1 $commit --numstat | grep -vE "$exclude_args" | awk '{add+=$1; del+=$2} END {print add; print del}')"

    local add_text=$(echo $totals | head -n1)
    local del_text=$(echo $totals | tail -n1)

    add=$((add + add_text))
    del=$((del + del_text))
  done

  print "Added $add lines, deleted $del lines"
  print "Total changes: $(($add + $del)) lines"
}
