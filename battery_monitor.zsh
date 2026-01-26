#!/bin/zsh

# Config
UPPER=80
LOWER=40
LOCK_FILE="/tmp/batt_alert.lock"

# Fetch system status
raw_data=$(pmset -g batt)
[[ $raw_data =~ "([0-9]+)%" ]] && level=$match[1]
[[ $raw_data =~ "AC Power" ]] && is_charging=true || is_charging=false

# Signal handler
trigger_alert() {
    local msg=$1
    afplay /System/Library/Sounds/Glass.aiff
    osascript -e "display notification \"$msg\" with title \"System Manager\""
}

# State control
if [[ "$is_charging" == "true" && $level -ge $UPPER ]]; then
    if [[ ! -f "$LOCK_FILE" ]]; then
        trigger_alert "[pwr] status: battery > $UPPER%. terminate charging."
        touch "$LOCK_FILE"
    fi
elif [[ "$is_charging" == "false" && $level -le $LOWER ]]; then
    if [[ ! -f "$LOCK_FILE" ]]; then
        trigger_alert "[pwr] alert: battery < $LOWER%. connect source."
        touch "$LOCK_FILE"
    fi
else
    # Reset state
    rm -f "$LOCK_FILE"
fi

