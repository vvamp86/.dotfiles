#!/bin/sh
sh -c "rg -q '^swaylock$' /proc/*/comm || swaylock -f"
