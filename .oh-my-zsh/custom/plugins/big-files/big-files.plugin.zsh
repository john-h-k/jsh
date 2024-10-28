big-files() {
    local objects count i output size compressed_size sha location added deleted

    print "Running git verify-pack (may take a while)..."

    objects=$(git verify-pack -v .git/objects/pack/pack-*.idx | grep -v chain | sort -k3nr | head)
    objects=(${(f)objects})

    count="${#objects[@]}"
    i=0

    output="size,pack,SHA,location,added,deleted"
    for obj in $objects
    do
        i=$(($i + 1))
        print -n "Analysing packs ($i/$count)...\r"
        size=$(($(echo $obj | cut -f 5 -d ' ') / 1024))
        compressed_size=$(($(echo $obj | cut -f 6 -d ' ') / 1024))
        sha=$(echo $obj | cut -f 1 -d ' ')
        location=$(git rev-list --all --objects | grep $sha | cut -f 2 -d ' ')
        added=$(git log --diff-filter=A --pretty=format:"%h" -- $location | tr -d '\n')
        deleted=$(git log --diff-filter=D --pretty=format:"%h" -- $location | tr -d '\n')
        output="${output}\n${size},${compressed_size},${sha},${location},${added},${deleted}"
    done

    print "\nAll sizes are in kB. The pack column is the size of the object, compressed, inside the pack file."
    print $output | column -t -s ', '
}
