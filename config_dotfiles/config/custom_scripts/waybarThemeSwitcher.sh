#!/usr/bin/env bash
set -Eeuo pipefail
root="$HOME/.local/share/config_dotfiles/config/waybar"
active="$root/style.css"
swaymsg mode default >/dev/null 2>&1 || true
labels=("Block 1" "Block 2" "Block 3" "Block 4" "Floating" "Underline")
selected="$(printf '%s\n' "${labels[@]}" | wofi --dmenu -i --prompt 'Waybar theme' --width 360 --lines 6)"
[[ -n "$selected" ]] || exit 0
case "$selected" in
  "Block 1") theme=waybar_block_1 ;;
  "Block 2") theme=waybar_block_2 ;;
  "Block 3") theme=waybar_block_3 ;;
  "Block 4") theme=waybar_block_4 ;;
  "Floating") theme=waybar_floating ;;
  "Underline") theme=waybar_underline ;;
  *) notify-send -u critical "Waybar" "Unknown theme"; exit 1 ;;
esac
target="$root/themes/$theme/style.css"
[[ -r "$target" ]] || { notify-send -u critical "Waybar" "Missing $target"; exit 1; }
tmp="$root/.style.css.new"
ln -sfn "themes/$theme/style.css" "$tmp"
mv -Tf "$tmp" "$active"
# A controlled restart fully refreshes every CSS property and avoids SIGUSR2 edge cases.
pkill -x waybar 2>/dev/null || true
for _ in {1..20}; do pgrep -x waybar >/dev/null || break; sleep 0.05; done
setsid -f waybar -c "$root/config.jsonc" -s "$active" >/dev/null 2>&1
notify-send "Waybar" "Theme: $selected"
