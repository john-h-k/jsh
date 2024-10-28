clean-branches-old() {
    local branches="$(gh pr list --limit 2000 --state merged --json headRefName --jq ".[].headRefName")"
    for branch in "${(@f)branches}"; do
        git rev-parse --verify $branch >> /dev/null 2>&1 || { 
            print "Branch $branch not found locally; skipping..."; continue
        }

        print $branch
        git branch -D $branch
    done
}

clean-branches() {
    local branches="$(git for-each-ref --format='%(refname:short)' refs/heads/)"
    for branch in "${(@f)branches}"; do
        local state=$(gh pr view $branch --json state --jq '.state' || echo NO_PR)

        case $state in
            NO_PR)
                print "PR for branch $branch not found on GitHub; skipping..."
                ;;
            OPEN)
                print "PR for branch $branch open; skipping..."
                ;;
            CLOSED)
                print "PR for branch $branch closed; skipping..."
                ;;
            MERGED)
                print -P "%F{red}PR for branch $branch merged; deleting...%f"
                git branch -D $branch
                ;;
            *)
                print -P "%F{yellow}Unknown state $state for branch $branch; skipping...%f"
                ;;
        esac
    done
}
