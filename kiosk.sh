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
# get resolutions xrandr | grep 'connected' | perl -ne 'if (/(\d+)x(\d+)\+(\d+)\+(\d+)/) { print "$3,$4 - ", $3 + $1 - 1, ",", $4 + $2 - 1, "\n" }'

monitors=$(xrandr| perl -ne 'if (/(\d+)x(\d+)\+(\d+)\+(\d+)/) { print "$3\n" }')

monitor=1
while IFS= read -r resolutionX
do
    /snap/bin/chromium --window-position="$resolutionX",0 \
                   --window-size=1920,1080 \
                   --new-window \
                   --start-maximized \
                   --kiosk \
                   --start-fullscreen \
                   --user-data-dir="/home/kiosk/${monitor}" \
                   --no-first-run "https://ads-monitors.os-system.com/?mac_adress=${MAC_ADDRESS}&monitor_number=${monitor}" &
    ((monitor=monitor+1))
done < <(printf '%s\n' "$monitors")