#!/usr/bin/env bash

INSTALL_WITH_FLATPAK_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$INSTALL_WITH_FLATPAK_SCRIPT_DIR/mini_functions.sh"

# Read Flatpak package list
mapfile -t flatpak_packages < "$INSTALL_WITH_FLATPAK_SCRIPT_DIR/../package_lists/flatpak_pkg_list.txt"

install_flatpak_packages() {

    # Install Flatpak if needed
    if ! xbps-query -Rs "^flatpak$" >/dev/null 2>&1; then
        info "Installing Flatpak..."
        sudo xbps-install -Sy flatpak
    fi

    success "Flatpak is installed."

    # Add Flathub if missing
    if ! flatpak remote-list | grep -q "^flathub$"; then
        info "Adding Flathub repository..."
        sudo flatpak remote-add --if-not-exists \
            flathub https://flathub.org/repo/flathub.flatpakrepo
    fi

    # Install applications
    for package in "${flatpak_packages[@]}"; do
        if flatpak info "$package" >/dev/null 2>&1; then
            info "$package already installed."
        else
            info "Installing $package..."
            flatpak install -y flathub "$package"
        fi
    done
}

install_flatpak_packages
