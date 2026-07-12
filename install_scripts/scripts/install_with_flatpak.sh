#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; source "$DIR/mini_functions.sh"
mapfile -t flatpak_packages < "$DIR/../package_lists/flatpak_pkg_list.txt"

for pkg in flatpak xdg-desktop-portal xdg-desktop-portal-gtk; do
 xbps-query "$pkg" &>/dev/null || sudo xbps-install -y "$pkg"
done
flatpak remotes | grep -q flathub || flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
for app in "${flatpak_packages[@]}"; do
 [[ -z "$app" || "$app" == \#* ]] && continue
 flatpak list --app --columns=application | grep -qx "$app" \
 && info "$app already installed." \
 || { info "Installing $app ..."; flatpak install --user -y flathub "$app"; }
done
success "Flatpak apps installed."
