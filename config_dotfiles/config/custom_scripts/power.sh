#!/usr/bin/env bash
lock="swaylock -f -i $HOME/.config/walls/wall.png"
if pgrep -x sway >/dev/null; then logout="swaymsg exit"; else logout="loginctl terminate-user $USER"; fi
chosen=$(printf "Log Out\nLock\nSuspend\nRestart\nPower OFF\n" | wofi --dmenu --prompt "power" --width 260 --lines 6)
case "$chosen" in
 "Log Out")   eval "$logout" ;;
 "Lock")      eval "$lock" ;;
 "Suspend")   eval "$lock"; loginctl suspend ;;
 "Restart")   loginctl reboot ;;
 "Power OFF") loginctl poweroff ;;
 *) exit 1 ;;
esac
