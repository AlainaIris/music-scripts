#! /bin/bash
# dwmblocks script for displaying what song is playing and whether it's playing or paused

file=$(echo '{ "command": ["get_property", "filename/no-ext"] }' | socat - /tmp/mpvsocket | jq -r ".data")
artist=$(echo '{ "command": ["get_property", "metadata"] }' | socat - /tmp/mpvsocket | jq -r ".data" | jq -r ".artist")
pause=$(echo '{ "command": ["get_property", "core-idle"] }' | socat - /tmp/mpvsocket | jq -r ".data")

if [[ $file != "" ]] then
        if [[ "$pause" == 'true' ]] then
                echo "▷$file"
        else
                echo "▶$file"
        fi
fi
