#!/bin/zsh

# Dependency: Native datetime
zmodload zsh/datetime

# Config
local SOUND="/System/Library/Sounds/Glass.aiff"
local DEF_WORK=25
local DEF_REST=5

# Usage
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    printf "Usage: %s [WORK] [REST]\nDefaults: %s / %s\n" "${0##*/}" "$DEF_WORK" "$DEF_REST"
    exit 0
fi

# Logic
function count_down() {
    local label=$1 min=$2
    local end=$(( EPOCHSECONDS + min * 60 ))

    while (( EPOCHSECONDS < end )); do
        local rem=$(( end - EPOCHSECONDS ))
        if [[ -t 1 ]]; then
            printf "\r%-5s %02d:%02d " "$label" $((rem / 60)) $((rem % 60))
        fi
        sleep 1
    done
    [[ -t 1 ]] && printf "\r\033[K"
}

function notify() {
    [[ -f "$SOUND" ]] && afplay "$SOUND" &
    printf "\r%s >> " "$1"
    read -rs < /dev/tty
    printf "\r\033[K"
}

# Main
trap "printf '\r\033[K'; exit 0" INT

local t_work=${1:-$DEF_WORK}
local t_rest=${2:-$DEF_REST}

while true; do
    count_down "FOCUS" "$t_work"
    notify "FOCUS"
    count_down "REST"  "$t_rest"
    notify "REST"
done
