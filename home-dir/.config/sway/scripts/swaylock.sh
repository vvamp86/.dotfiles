#!/bin/sh
sh -c "rg -q '^swaylock$' /proc/*/comm || killall swaylock || swaylock -f"
