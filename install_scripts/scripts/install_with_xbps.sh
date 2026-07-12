#!/usr/bin/env bash
INSTALL_WITH_XBPS_SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$INSTALL_WITH_XBPS_SCRIPT_PATH/mini_functions.sh"

install_with_xbps() {
 for pkg in "$@"; do
 [[ -z "$pkg" || "$pkg" == \#* ]] && continue
 if xbps-query "$pkg" &>/dev/null; then
 info "$pkg already installed"
 else
 info "Installing $pkg ..."
 sudo xbps-install -y "$pkg"
 fi
 done
}

mapfile -t common_packages  < "$INSTALL_WITH_XBPS_SCRIPT_PATH/../package_lists/common_pkg_list.txt"
mapfile -t dev_packages     < "$INSTALL_WITH_XBPS_SCRIPT_PATH/../package_lists/dev_pkg_list.txt"
mapfile -t wayland_packages < "$INSTALL_WITH_XBPS_SCRIPT_PATH/../package_lists/wayland_pkg_list.txt"
mapfile -t gui_packages     < "$INSTALL_WITH_XBPS_SCRIPT_PATH/../package_lists/gui_pkg_list.txt"

run_function install_with_xbps "${common_packages[@]}"
run_function install_with_xbps "${dev_packages[@]}"
run_function install_with_xbps "${wayland_packages[@]}"
run_function install_with_xbps "${gui_packages[@]}"
