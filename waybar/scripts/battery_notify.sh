#!/bin/bash

last_bat_status=$(cat /sys/class/power_supply/BAT0/status)

fade_brightness() {
    target_pct=$1
    
    while true; do
        current_pct=$(brightnessctl -m | cut -d, -f4 | tr -d '%')

        if [ "$current_pct" -eq "$target_pct" ]; then
            break
        fi

        if [ "$current_pct" -gt "$target_pct" ]; then
            brightnessctl set 1%- > /dev/null 2>&1
        else
            brightnessctl set +1% > /dev/null 2>&1
        fi
        
        sleep 0.01
    done
}

while true; do
    bat_level=$(cat /sys/class/power_supply/BAT0/capacity)
    bat_status=$(cat /sys/class/power_supply/BAT0/status)

    if [ "$bat_status" == "Discharging" ] && [ "$bat_level" -le 15 ]; then
        if [ ! -f /tmp/battery_low_notified ]; then
            notify-send -u critical -i battery-level-10-symbolic "HEV WARNING" "Power level critical: ${bat_level}%"
            fade_brightness 15
            touch /tmp/battery_low_notified
        fi
    elif [ "$bat_level" -gt 15 ]; then
        rm -f /tmp/battery_low_notified
    fi

    if [ "$bat_status" == "Charging" ] && [ "$last_bat_status" == "Discharging" ]; then
        fade_brightness 50
    fi

    if [ "$bat_status" == "Charging" ] && [ "$bat_level" -ge 80 ]; then
        if [ ! -f /tmp/battery_high_notified ]; then
            notify-send -u normal -i battery-full-charged-symbolic "OPTIMAL CHARGE" "Battery at ${bat_level}%. Unplug to preserve health."
            touch /tmp/battery_high_notified
        fi
    elif [ "$bat_level" -lt 80 ]; then
        rm -f /tmp/battery_high_notified
    fi

    last_bat_status="$bat_status"
    sleep 10
done
