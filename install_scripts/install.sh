#!/usr/bin/env bash
INSTALL_SH_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$INSTALL_SH_SCRIPT_DIR/scripts/mini_functions.sh"

info "Synchronising xbps and updating the base system ..."
sudo xbps-install -Suy

source "$INSTALL_SH_SCRIPT_DIR/scripts/setup_hardware.sh"
source "$INSTALL_SH_SCRIPT_DIR/scripts/setup_power.sh"
source "$INSTALL_SH_SCRIPT_DIR/scripts/setup_audio.sh"
source "$INSTALL_SH_SCRIPT_DIR/scripts/make_directories.sh"
source "$INSTALL_SH_SCRIPT_DIR/scripts/install_with_xbps.sh"
source "$INSTALL_SH_SCRIPT_DIR/scripts/copy_from_src_to_des.sh"
source "$INSTALL_SH_SCRIPT_DIR/scripts/symlink_configs.sh"
source "$INSTALL_SH_SCRIPT_DIR/scripts/setup_shell.sh"
source "$INSTALL_SH_SCRIPT_DIR/scripts/setup_login.sh"
source "$INSTALL_SH_SCRIPT_DIR/scripts/enable_services.sh"

success "grimoire-void base setup done. Optional extras:"
info "  • Flatpak apps : bash $INSTALL_SH_SCRIPT_DIR/scripts/install_with_flatpak.sh"
info "  • KVM/libvirt  : bash $INSTALL_SH_SCRIPT_DIR/scripts/setup_virtualization.sh"
info "Reboot to land in tuigreet -> Sway (shell is now zsh)."
