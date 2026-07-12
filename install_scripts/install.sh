#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'
trap 'printf "\n[ERROR] line %s: %s\n" "$LINENO" "$BASH_COMMAND" >&2' ERR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/scripts/mini_functions.sh"
(( EUID != 0 )) || die "Run as your regular user, not root."
command -v sudo >/dev/null || die "sudo is required"
sudo -v
info "Synchronising and updating Void"
sudo xbps-install -Suy
bash "$DIR/scripts/setup_hardware.sh"
bash "$DIR/scripts/setup_power.sh"
bash "$DIR/scripts/setup_audio.sh"
bash "$DIR/scripts/make_directories.sh"
bash "$DIR/scripts/install_with_xbps.sh"
bash "$DIR/scripts/copy_from_src_to_des.sh"
bash "$DIR/scripts/symlink_configs.sh"
bash "$DIR/scripts/setup_shell.sh"
bash "$DIR/scripts/setup_login.sh"
bash "$DIR/scripts/enable_services.sh"
success "Base setup completed without a hidden stage failure"
info "Flatpak: bash '$DIR/scripts/install_with_flatpak.sh'"
info "KVM: bash '$DIR/scripts/setup_virtualization.sh'"
