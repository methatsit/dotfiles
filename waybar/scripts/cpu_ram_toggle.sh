#!/bin/bash

STATE_FILE="/tmp/waybar_cpu_ram_state"

# Default state
if [ ! -f "$STATE_FILE" ]; then
    echo "cpu" > "$STATE_FILE"
fi

STATE=$(cat "$STATE_FILE")

if [ "$1" = "toggle" ]; then
    if [ "$STATE" = "cpu" ]; then
        echo "ram" > "$STATE_FILE"
    else
        echo "cpu" > "$STATE_FILE"
    fi
    exit 0
fi

# Display logic
if [ "$STATE" = "cpu" ]; then
    USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
    printf " CPU: %.0f%%\n" "$USAGE"
else
    MEM=$(free -m | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')
    echo " RAM: ${MEM}%"
fi
