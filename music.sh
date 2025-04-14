#! /bin/bash
# Creates a playable list from a filepath and then plays music
# If a playlist exists in the path already, will copy that list
#
# Note: playlists are used .m3u format, if you have a different format
#       then you must modify the scirpt to suit your purposes.
# To Do: Add shuffle

trap "rm playlist.m3u" EXIT
path="$1"
if [[ "$path" == "" ]] then
        path='.'
fi
file=$(ls "$path" | grep ".m3u")
num=$(echo "$file" | grep ".m3u" | wc -l)
if [[ "$num" == '1' ]] then
        echo ./$1$file > playlist.m3u
else
        find "$path" -name "*.mp3" > playlist.m3u
fi
mpv --input-ipc-server=/tmp/mpvsocket playlist.m3u
