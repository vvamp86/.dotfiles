#!/bin/bash
# Sway-native version using wpctl and makoctl

# See README.md for usage instructions
volume_step=1
keyboard_brightness_step=20
screen_brightness_step=1
max_volume=100
notification_timeout=3000

### Auto-detect keyboard and cache in /tmp/kbd_backlight_device:
device_cache="/tmp/kbd_backlight_device"

if [ -f "$device_cache" ]; then         # If there is cache, load it into device
    device=$(cat "$device_cache")
else                                    # If there is no cache, create one
    device=$(brightnessctl --list 2>/dev/null | grep -Po '\w+::kbd_backlight' | head -1)
    if [ -n "$device" ]; then
        echo "$device" > "$device_cache"
    fi
fi

# Uses wpctl for PipeWire/Wayland volume
function get_volume {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | \
        grep -oP '[0-9]+\.[0-9]+' | \
        head -1 | \
        awk '{printf "%.0f", $1 * 100}'
}

# Uses wpctl for PipeWire/Wayland mute
function get_mute {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | \
        grep -q "MUTED" && echo "yes" || echo "no"
}

# Uses makoctl to dismiss previous notifications before showing new ones
function dismiss_previous_notifications {
    # Dismiss volume notifications
    makoctl dismiss -g volume 2>/dev/null || true
    # Dismiss brightness notifications
    makoctl dismiss -g brightness 2>/dev/null || true
}

# Unified notification function for all types
function show_notification {
    local group="$1"
    local title="$2"
    local message="$3"
    local value="$4"

    dismiss_previous_notifications

    notify-send -t "$notification_timeout" \
        -h "string:x-canonical-private-synchronous:$group" \
        -h "int:value:$value" \
        "$title" \
        "$message"
}

# Get keyboard_brightness from brightnessctl
function get_keyboard_brightness {
    if [ -n "$device" ]; then
        keyboard_curr=$(brightnessctl -d "$device" get 2>/dev/null)
        keyboard_max=$(brightnessctl -d "$device" max 2>/dev/null)
        if [ -n "$keyboard_curr" ] && [ -n "$keyboard_max" ] && [ "$keyboard_max" -gt 0 ]; then
            echo $(( keyboard_curr * 100 / keyboard_max ))
        else
            echo 0
        fi
    fi
}

# Grabs screen brightness and formats it out of 100
function get_screen_brightness {
    screen_curr=$(brightnessctl -q get 2>/dev/null)
    screen_max=$(brightnessctl -q max 2>/dev/null)
    if [ -n "$screen_curr" ] && [ -n "$screen_max" ] && [ "$screen_max" -gt 0 ]; then
        echo $(( screen_curr * 100 / screen_max ))
    else
        echo 50  # Fallback value
    fi
}

# Returns a mute icon, a volume-low icon, or a volume-high icon, depending on the volume
function get_volume_icon {
    volume=$(get_volume)
    mute=$(get_mute)
    if [ "$volume" -eq 0 ] || [ "$mute" == "yes" ] ; then
        volume_icon="󰖁"  # Volume muted (Nerd Font)
    elif [ "$volume" -lt 33 ] ; then
        volume_icon="󰕿"  # Volume low (Nerd Font)
    elif [ "$volume" -lt 67 ] ; then
        volume_icon=""  # Volume medium (Nerd Font)
    else
        volume_icon="󰕾"  # Volume high (Nerd Font)
    fi
}

# Always returns the same icon - I couldn't get the brightness-low icon to work with fontawesome
function get_keyboard_brightness_icon {
    kb_brightness=$(get_keyboard_brightness)
    # Fallback to 0 if empty
    if [ -z "$kb_brightness" ]; then
        kb_brightness=0
    fi
    if [ "$kb_brightness" -eq 33 ] ; then
        keyboard_brightness_icon="󰃞"  # brightness off
    elif [ "$kb_brightness" -lt 67 ] ; then
        keyboard_brightness_icon="󰃝"  # brightness low
    else
        keyboard_brightness_icon="󰃠"  # brightness high
    fi
}

function get_screen_brightness_icon {
    sc_brightness=$(get_screen_brightness)
    if [ "$sc_brightness" -eq 33 ] ; then
        screen_brightness_icon="󰃞"  # brightness off
    elif [ "$sc_brightness" -lt 67 ] ; then
        screen_brightness_icon="󰃝"  # brightness low
    else
        screen_brightness_icon="󰃠"  # brightness high
    fi
}

# Main function - Takes user input, "volume_up", "volume_down", "keyboard_brightness_up", "keyboard_brightness_down", "brightness_up", or "brightness_down"
case $1 in
    volume_up)
    # Unmutes and increases volume, then displays the notification
    wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 2>/dev/null || true

    # Convert volume_step to decimal for wpctl (wpctl expects 0.0-1.0)
    volume_step_decimal=$(echo "scale=2; $volume_step / 100" | bc)
    max_volume_decimal=$(echo "scale=2; $max_volume / 100" | bc)

    # Get current volume as decimal
    current_decimal=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | \
        grep -oP '[0-9]+\.[0-9]+' | head -1)

    if [ -z "$current_decimal" ]; then
        current_decimal=0
    fi

    # Calculate new volume
    new_decimal=$(echo "$current_decimal + $volume_step_decimal" | bc)

    if (( $(echo "$new_decimal > $max_volume_decimal" | bc -l) )); then
        wpctl set-volume @DEFAULT_AUDIO_SINK@ "$max_volume_decimal" 2>/dev/null || true
    else
        # Use wpctl's increment syntax
        wpctl set-volume @DEFAULT_AUDIO_SINK@ "${volume_step}%+" 2>/dev/null || true
    fi

    volume=$(get_volume)
    get_volume_icon
    show_notification "volume" "Volume" "$volume_icon $volume%" "$volume"
    ;;

    volume_down)
    # Lowers volume and displays the notification
    wpctl set-volume @DEFAULT_AUDIO_SINK@ "${volume_step}%-" 2>/dev/null || true

    volume=$(get_volume)
    get_volume_icon
    show_notification "volume" "Volume" "$volume_icon $volume%" "$volume"
    ;;

    volume_mute)
    # Toggles mute and displays the notification
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle 2>/dev/null || true

    volume=$(get_volume)
    get_volume_icon
    show_notification "volume" "Volume" "$volume_icon $volume%" "$volume"
    ;;

    keyboard_brightness_up)
    if [ -n "$device" ]; then
        brightnessctl -d "$device" set "${keyboard_brightness_step}+" 2>/dev/null || true
    fi

    keyboard_brightness=$(get_keyboard_brightness)
    get_keyboard_brightness_icon
    show_notification "brightness" "Keyboard Brightness" "$keyboard_brightness_icon $keyboard_brightness%" "$keyboard_brightness"
    ;;

    keyboard_brightness_down)
    if [ -n "$device" ]; then
        brightnessctl -d "$device" set "${keyboard_brightness_step}-" 2>/dev/null || true
    fi

    keyboard_brightness=$(get_keyboard_brightness)
    get_keyboard_brightness_icon
    show_notification "brightness" "Keyboard Brightness" "$keyboard_brightness_icon $keyboard_brightness%" "$keyboard_brightness"
    ;;

    screen_brightness_up)
    # Increase screen brightness
    brightnessctl -q set "${screen_brightness_step}%+" 2>/dev/null || true
    screen_brightness=$(get_screen_brightness)
    get_screen_brightness_icon
    show_notification "brightness" "Screen Brightness" "$screen_brightness_icon $screen_brightness%" "$screen_brightness"
    ;;

    screen_brightness_down)
    # Decrease screen brightness
    brightnessctl -q set "${screen_brightness_step}%-" 2>/dev/null || true
    screen_brightness=$(get_screen_brightness)
    get_screen_brightness_icon
    show_notification "brightness" "Screen Brightness" "$screen_brightness_icon $screen_brightness%" "$screen_brightness"
    ;;

    *)
    echo "Usage: $0 {volume_up|volume_down|volume_mute|keyboard_brightness_up|keyboard_brightness_down|screen_brightness_up|screen_brightness_down}"
    exit 1
    ;;
esac
