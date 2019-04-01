#! /bin/bash

# Compute hashes for all arguments to the script
declare -A words
for word; do
    words[$(printf '%s' "$word" | sha1sum - | cut -d' ' -f1)]=$word
done

# Extract the desired passwords from a stream of counts
while IFS=$' \t:\r' read -r hash count; do
    word=${words[${hash,,}]}
    if [[ $word ]]; then
        printf '%s\t%s\n' "$word" "$count"
        unset -v "words[${hash,,}]"
        (( ${#words[@]} )) || exit 0
    fi
done
