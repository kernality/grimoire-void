#!/usr/bin/env bash
set -Eeuo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/mini_functions.sh"
db="$DIR/../db/config_dotfiles.db.json"
backup="$HOME/.config.backup/$(date +%Y%m%d_%H-%M-%S)"
mkdir -p "$backup"
expand_home() {
  case "$1" in
    '\$HOME'/*) printf '%s/%s\n' "$HOME" "${1#\$HOME/}" ;;
    *) printf '%s\n' "$1" ;;
  esac
}
while IFS= read -r row; do
  name="$(jq -r '.name' <<<"$row")"
  src="$(expand_home "$(jq -r '.config_src' <<<"$row")")"
  dst="$(expand_home "$(jq -r '.config_des' <<<"$row")")"
  [[ -e "$src" || -L "$src" ]] || error "Missing source for $name: $src"
  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    target="$backup/$name"
    [[ ! -e "$target" ]] || target="$backup/${name}-$(date +%s%N)"
    mv -- "$dst" "$target"
  elif [[ -L "$dst" ]]; then
    rm -- "$dst"
  fi
  ln -sfn -- "$src" "$dst"
  success "Linked $name"
done < <(jq -c '.[]' "$db")
rmdir "$backup" 2>/dev/null || true
