#! /bin/bash
# Creates a playable list from a filepath and then plays music
# If a playlist exists in the path already, will copy that list
#
# Note: playlists are used .m3u format, if you have a different format
#       then you must modify the scirpt to suit your purposes.

# Remove any vestigial files prior
rm playlist.m3u
rm shuffle.m3u

trap "rm playlist.m3u" EXIT

path="$1"

while [[ $# -gt 0 ]]; do
        case $1 in
                -e|--extension)
                        shift # past argument
                        shift # past value
                        ;;
                -s|--shuffle)
                        SHUFFLE="true"
                        shift # past argument
                        ;;
                -*|--*)
                        echo "Unknown option $1"
                        shift
#exit 1
                        ;;
                *)
                        POSITIONAL_ARGS+=("$1") # save positional arg
                        shift # past argument
                        ;;
        esac
done

echo "$path"
if [[ "$path" == "" || ! -e "$path" ]] then
        path='.'
fi

file=$(ls "$path" | grep ".m3u")

num=$(echo "$file" | grep ".m3u" | wc -l)

if [[ "$num" == '1' ]] then
        cat "$path/$file" | awk "{ printf \"$path\/\"; print }" > playlist.m3u
else
        find "$path" -name "*.mp3" > playlist.m3u
fi

filename="playlist.m3u"

if [[ "$SHUFFLE" == "true" ]] then
        cat playlist.m3u | shuf > shuffle.m3u
        filename="shuffle.m3u"
fi
echo "$filename"
mpv --input-ipc-server=/tmp/mpvsocket "$filename"
