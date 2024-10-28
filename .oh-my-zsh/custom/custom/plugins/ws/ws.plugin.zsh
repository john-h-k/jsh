ws-vp() {
    gh pr diff $1 --patch
}

ws-ap() {
    ws-vp | git apply -
}


ws-diff() {
    local prs branches missing WHITELIST
  
    prs=("${(@f)$(gh pr list --state "all" --author "@me" --json headRefName --limit 10000 --jq ".[].headRefName" | tr -d '"')}")
    branches=("${(@f)$(git branch --no-color --format "%(refname:short)")}")

    missing=("${(@)branches:|prs}")

    WHITELIST=(
        master
        2fa-backup
        2fa-git-test
        gib-sso
        gib-sso-good-fix
        merge-test
        monitor

        # other people opened PRs
        2fa
        patient-details/source-control
        patient-details/views
    )

    for branch in $missing
    do
        if (($WHITELIST[(Ie)$branch])); then
            print -P "$branch"
        else
            print -P "%F{red}$branch%f"
        fi
    done
}

ws-nr() {
    local prs lines

    print "Pull requests needing review: "
    prs=$(gh pr status \
        --json title,url,reviewDecision \
        --jq '[ .createdBy[] | select(.reviewDecision == "REVIEW_REQUIRED") | "\(.title) -- \(.url)" ] | join("\\n")')

    print $prs | awk '{print NR " -- " $0}'

    print -n "\nCopy to clipboard? (y/n/lines): "
    read -r "answer?"

    if [ "${answer:l}" = "y" ]; then
        print $prs | clipcopy
    elif [[ "$answer" =~ "[0-9]+" ]]; then
        lines=$(print "$answer" | xargs | grep -o .)
        print "$prs" |
            awk -v s="$lines" 'BEGIN{split(s, a, "\n"); for (i in a) b[a[i]]} NR in b' |
            clipcopy
    fi

    print ""
}

ws-diff() {
  # Default difftool github

  repo_url=$(gh repo view --json url --jq ".url")

  open "$repo_url/compare/$1"
}

ws-repo() {
    gh repo view
}

ws-status() {
    gh pr status -c
}

ws-bumps() {
    prs=$(gh pr list --author app/dependabot)
}

ws-pr() {
    local flag_copy flag_web

    zparseopts -D -F -E - \
        {c,-copy}=flag_copy \
        {w,-web}=flag_web ||
        return 1

    ((# > 0)) && shift 1 # remove the -- from the arguments if any provided

    if [[ -n $flag_copy && -n $flag_web ]]; then
        print "Cannot specify both --copy and --web!"
        return 1
    fi

    needs_new_pr="$(gh pr view --json closed --jq ".closed" || print "true")"

    if [[ $needs_new_pr == "true" ]]; then
        print "Creating new pull request..."

        git push
        
        if ! gh pr create --fill --assignee @me "$@"; then
            print "Failed to create pull request"
            return 1
        fi
    fi

    # If we're not interactive, don't ask
    [[ $- == *i* ]] || return 0

    if [[ -n $flag_copy ]]; then
        answer='y'
    elif [[ -n $flag_web ]]; then
        answer='w'
    else
        print -n "\nCopy to clipboard? (y[es]/n[o]/w[eb]): "
        read -r -k 1 "answer?"
        print ""
    fi

    case "${answer:l}" in
    y)
        gh pr view --json url --jq ".url" | clipcopy
        print "Copied to clipboard"
        ;;
    w)
        print "Opening in your browser..."
        open $(gh pr view --json url --jq ".url")
        ;;
    esac
}

readonly _ws_clockin_file=~/Desktop/ws_clockin.txt

_ws-is-clocked-in() {
    local today="$(date +'%Y-%m-%d')"
    touch "$_ws_clockin_file"
    grep "$today" "$_ws_clockin_file" >> /dev/null
}

ws-clockin() {
    local today now
    local flag_quiet_if_nop

    zparseopts -D -F - \
        -quiet-if-nop=flag_quiet_if_nop ||
        return 1

    today="$(date +'%Y-%m-%d')"

    if _ws-is-clocked-in; then
        [[ -n "$flag_quiet_if_nop" ]] && return 0

        clock_in_time="$(grep "$today" "$_ws_clockin_file" | cut -d ' ' -f2)"
        print "Already clocked in"
        print "Clock-in time was $clock_in_time"
    else
        now="$(date +'%Y-%m-%d %H:%M:%S')"
        print $now >> $_ws_clockin_file

        time="$(print $now | cut -d ' ' -f2)"
        print "Clocked in at $time"
    fi
}

ws() {
    if [ "${1:l}" != "clockin" ]; then
        _ws-is-clocked-in || print -P "%F{red}Note:%f Not clocked in. Call 'ws clockin' to clock in\n"
    fi

    invoke-subcommand "ws" "$@"
}
