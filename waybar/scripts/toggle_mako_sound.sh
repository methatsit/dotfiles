#!/bin/bash

SCRIPT_PATH="$HOME/.config/waybar/scripts/toggle_mako_sound.sh"

case "$1" in
    on)
        makoctl mode -s shout
        notify-send -t 2000 "Mako" "Sound: ON"
        ;;
    off)
        makoctl mode -s default
        notify-send -t 2000 "Mako" "Sound: OFF"
        ;;
    toggle)
        CURRENT_MODES=$(makoctl mode)
        if echo "$CURRENT_MODES" | grep -q "shout"; then
            $SCRIPT_PATH off
        else
            $SCRIPT_PATH on
        fi
        ;;
    status)
        CURRENT_MODES=$(makoctl mode)
        if echo "$CURRENT_MODES" | grep -q "shout"; then
            echo '{"text": " 󰂚 ", "class": "sound-on"}'
        else
            echo '{"text": " 󰂛 ", "class": "sound-off"}'
        fi
        exit 0
        ;;
esac

pkill -RTMIN+8 waybar
