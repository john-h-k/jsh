dir-tracker() {
    find .  -type f -exec gstat -c '%y' '{}' \; | sort -r | head -n1
}

git-tracker() {
    local year month day tomorrow format all last end_time duration
    local flag_commit_count flag_excel_format

    zparseopts -D -F - \
        {c,-commits}=flag_commit_count \
        {e,-excel}=flag_excel_format ||
        return 1

    year=$(gdate +'%Y')
    month="${1:-$(gdate +%m)}"

    day=$(gdate -d "$year-$month-01 00:00:00" --iso-8601=seconds)
    day=$(gdate -d "$day + 6 hours" --iso-8601=seconds)

    print "Date, Earliest Commit, Latest Commit, Working Duration (Timestamp), Working Duration (Decimalised), 8h Days Worked"

    while [ $(gdate -d "$day" +%m) = "$month" ]; do
        tomorrow=$(gdate -d "$day + 1 day" --iso-8601=seconds)

        #git log -g --all --after $day --before $tomorrow --author 'John Kelly'  --oneline --pretty=$format;
        #git log -g --all --after $day --before $tomorrow --committer 'John Kelly'  --oneline --pretty=$format

        format="format:%ci/%ai:%H"
        all=$({
            git log --all --after $day --before $tomorrow --author 'John Kelly'  --oneline --pretty=$format;
            git log --all --after $day --before $tomorrow --committer 'John Kelly'  --oneline --pretty=$format;
        } | sort -ru)

        first=$(echo $all | tail -n1 | gcut -d'/' -f1)
        last=$(echo $all | head -n1 | gcut -d'/' -f1)

        if [[ -n "$first" ]]; then
            start_time=$(gdate -d $first +%T)
        else
            start_time="<Not found>"
        fi

        if [[ -n "$last" ]]; then
            end_time=$(gdate -d $last +%T)
        else
            end_time="<Not found>"
        fi

        if [[ -n "$first" && -n "$last" ]]; then
            duration=$(time-diff $first $last)
            seconds=$(print $duration | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')

            duration_decimal=$(printf "%.2f" $(($seconds / 3600.0 + 0.0049)))
            days_worked=$(printf "%.1f" $(($seconds / 3600.0 / 8.0 + 0.049)))
        else
            duration="<Not found>"
            duration_decimal=0
            days_worked=0
        fi

        # commit_count_col=""
        # if [ -n "$flag_commit_count" ]; then
        #     commit_count_col=", $(print $all | wc -l)"
        # fi

        print "$(gdate -d $day '+%a %b %d'), $start_time, $end_time, $duration, $duration_decimal, $days_worked"

        day=$tomorrow
    done
}

time-diff() {
    start_epoch=$(gdate -d $1 +%s)
    end_epoch=$(gdate -d $2 +%s)

    # sub 3600 to account for timezone
    diff_seconds=$((end_epoch - start_epoch - 3600))

    gdate -d @$diff_seconds +%T
}


activity-tracker() {
    
}
