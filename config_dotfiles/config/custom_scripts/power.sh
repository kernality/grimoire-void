#!/usr/bin/env bash
set -u
choice="$(printf 'Log Out\nLock\nSuspend\nRestart\nPower Off\n' | wofi --dmenu --prompt power --width 260 --lines 5)"
lock=(swaylock -f -i "$HOME/.config/walls/lock.png")
case "$choice" in
  'Log Out') swaymsg exit ;;
  'Lock') "${lock[@]}" ;;
  'Suspend') "${lock[@]}" && loginctl suspend ;;
  'Restart') loginctl reboot ;;
  'Power Off') loginctl poweroff ;;
  *) exit 0 ;;
esac
