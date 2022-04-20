#!/bin/bash
 
# Run this script in display 0 - the monitor
export DISPLAY=:0

MAC_ADDRESS=$(cat /sys/class/net/enp*s0/address | head -n 1 | sed 's/://g')
 
# Hide the mouse from the display
unclutter &
 
# If Chromium crashes (usually due to rebooting), clear the crash flag so we don't have the annoying warning bar
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' /home/kiosk/.config/chromium/Default/Preferences
sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' /home/kiosk/.config/chromium/Default/Preferences

# get count of monitor + resolution https://askubuntu.com/questions/639495/how-can-i-list-connected-monitors-with-xrandr

# Run Chromium and open tabs
/snap/bin/chromium --window-position=0,0 \
                   --window-size=1920,1080 \
                   --new-window \
                   --start-maximized \
                   --kiosk \
                   --start-fullscreen \
                   --no-first-run "https://ads-monitors.os-system.com/?mac_adress=${MAC_ADDRESS}" &