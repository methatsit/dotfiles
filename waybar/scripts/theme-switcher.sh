#!/bin/bash
# Theme Switcher Script for Hyprpaper
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CURRENT_WALLPAPER_FILE="$HOME/.cache/current_wallpaper"

# Collect wallpapers
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | sort)

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    exit 1
fi

# Helpers
get_current_index() {
    [[ -f "$CURRENT_WALLPAPER_FILE" ]] && cat "$CURRENT_WALLPAPER_FILE" || echo "0"
}

apply_theme() {
    local wallpaper_path="$1"
    local index="$2"
    
    echo "$index" >"$CURRENT_WALLPAPER_FILE"
    
    # --- HYPRPAPER LOGIC START ---
    # Check if hyprpaper is running, start if not
    if ! pgrep -x hyprpaper >/dev/null; then
        hyprpaper &
        sleep 1
    fi
    
    # Simply set the wallpaper - no preload/unload needed
    # Use full path, not ~
    hyprctl hyprpaper wallpaper ",$wallpaper_path"
    
    if [ $? -ne 0 ]; then
        notify-send "Wallpaper Error" "Failed to set wallpaper"
        return 1
    fi
    # --- HYPRPAPER LOGIC END ---
    
    update_hyprlock_wallpaper "$wallpaper_path"
}

update_hyprlock_wallpaper() {
    local wallpaper_path="$1"
    local hyprlock_config="$HOME/.config/hypr/hyprlock.conf"
    
    if [[ -f "$hyprlock_config" ]]; then
        [[ ! -f "${hyprlock_config}.backup" ]] && cp "$hyprlock_config" "${hyprlock_config}.backup"
        sed -i "/background {/,/}/{s|path = .*|path = $wallpaper_path|}" "$hyprlock_config"
    fi
}

restore_theme() {
    local index=$(get_current_index)
    if [ -z "${WALLPAPERS[$index]}" ]; then
        index=0
    fi
    apply_theme "${WALLPAPERS[$index]}" "$index"
}

# Main
case "${1:-next}" in
    "next")
        next_index=$((($(get_current_index) + 1) % ${#WALLPAPERS[@]}))
        apply_theme "${WALLPAPERS[$next_index]}" "$next_index"
        ;;
    "random")
        random_index=$((RANDOM % ${#WALLPAPERS[@]}))
        apply_theme "${WALLPAPERS[$random_index]}" "$random_index"
        ;;
    "restore")
        restore_theme
        ;;
    "list")
        selected=$(printf "%s\n" "${WALLPAPERS[@]}" | sed "s|$WALLPAPER_DIR/||" | wofi --dmenu --prompt "Choose Wallpaper" --insensitive)
        if [ -n "$selected" ]; then
            full_path="$WALLPAPER_DIR/$selected"
            for i in "${!WALLPAPERS[@]}"; do
                if [[ "${WALLPAPERS[$i]}" == "$full_path" ]]; then
                    apply_theme "${WALLPAPERS[$i]}" "$i"
                    break
                fi
            done
        fi
        ;;
esac
