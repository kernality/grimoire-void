#!/usr/bin/env bash
set -Eeuo pipefail
src="$HOME/.local/share/config_dotfiles/config/firefox"
for root in "${XDG_CONFIG_HOME:-$HOME/.config}/mozilla/firefox" "$HOME/.mozilla/firefox"; do
  ini="$root/profiles.ini"
  [[ -f "$ini" ]] || continue
  path="$(awk -F= '/^\[Profile/{p="";d=0}$1=="Path"{p=$2}$1=="Default"&&$2=="1"{d=1}d&&p!=""{print p;exit}' "$ini")"
  [[ -n "$path" ]] || path="$(awk -F= '$1=="Path"{print $2;exit}' "$ini")"
  [[ -n "$path" ]] || continue
  [[ "$path" = /* ]] || path="$root/$path"
  mkdir -p "$path"
  if [[ -e "$path/user.js" && ! -L "$path/user.js" ]]; then mv "$path/user.js" "$path/user.js.backup"; else rm -f "$path/user.js"; fi
  if [[ -e "$path/chrome" && ! -L "$path/chrome" ]]; then mv "$path/chrome" "$path/chrome.backup"; else rm -rf "$path/chrome"; fi
  ln -s "$src/user.js" "$path/user.js"
  [[ -d "$src/chrome" ]] && ln -s "$src/chrome" "$path/chrome"
  notify-send "Firefox" "Profile configuration linked"
  exit 0
done
notify-send "Firefox" "Launch Firefox once, then run this script again"
exit 1
