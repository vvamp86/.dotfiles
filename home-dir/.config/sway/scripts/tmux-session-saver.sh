#!/bin/bash
# ~/.config/sway/scripts/tmux-session-saver.sh

declare -A TERMINAL_SESSIONS

# Function to save and kill session
save_and_cleanup() {
    local PID="$1"
    local TMUX_SESSION="${TERMINAL_SESSIONS[$PID]}"

    if [ -n "$TMUX_SESSION" ] && tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
        echo "Saving session for PID $PID: $TMUX_SESSION"

        SESSION_DIR="$HOME/.tmux/saved_sessions"
        mkdir -p "$SESSION_DIR"

        # Save layout
        tmux list-windows -t "$TMUX_SESSION" -F '#{window_index} #{window_name} #{window_layout}' \
            > "$SESSION_DIR/${TMUX_SESSION}_layout.txt"

        # Kill the tmux session
        tmux kill-session -t "$TMUX_SESSION"

        # Remove from tracking
        unset TERMINAL_SESSIONS[$PID]
    fi
}

# Monitor terminal launches
swaymsg -t subscribe '["window"]' | while read event; do
    CHANGE=$(echo "$event" | jq -r '.change')
    APP_ID=$(echo "$event" | jq -r '.container.app_id')
    PID=$(echo "$event" | jq -r '.container.pid')

    if [[ "$APP_ID" =~ [Aa]lacritty|kitty|foot ]]; then  # Add your terminal
        case "$CHANGE" in
            "new")
                sleep 0.5
                # Try multiple methods to find tmux session
                TMUX_SESSION=""

                # Method 1: Check process arguments
                TMUX_SESSION=$(ps -o args= $PID 2>/dev/null | grep -o 'tmux new -A -s "[^"]*"' | cut -d'"' -f2)

                # Method 2: Check for TMUX_SESSION env var (if using wrapper)
                if [ -z "$TMUX_SESSION" ] && [ -f "/proc/$PID/environ" ]; then
                    TMUX_SESSION=$(cat "/proc/$PID/environ" 2>/dev/null | tr '\0' '\n' | grep '^TMUX_SESSION=' | cut -d'=' -f2-)
                fi

                # Method 3: Check tmux server for sessions owned by this PID
                if [ -z "$TMUX_SESSION" ]; then
                    TMUX_SESSION=$(tmux list-sessions -F '#{session_name} #{session_created}' 2>/dev/null | \
                        sort -k2 -n | tail -1 | awk '{print $1}')
                fi

                if [ -n "$TMUX_SESSION" ]; then
                    TERMINAL_SESSIONS[$PID]="$TMUX_SESSION"
                    echo "Tracked: PID $PID -> tmux session $TMUX_SESSION"
                fi
                ;;

            "close")
                # Terminal is closing (from kill or exit)
                save_and_cleanup "$PID"
                ;;

            "focus")
                # Optional: Update PID if terminal respawns
                ;;
        esac
    fi
done
