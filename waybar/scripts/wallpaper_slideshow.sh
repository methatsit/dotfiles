#!/bin/bash

# Wait for the system to wake up
sleep 3

while true; do
    # Call the random function directly
    ~/.config/waybar/scripts/theme-switcher.sh random
    
    # Wait 30 minutes (1800 seconds)
    sleep 1800
done
