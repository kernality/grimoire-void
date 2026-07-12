#!/usr/bin/env bash
SETUP_LOGIN_SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SETUP_LOGIN_SCRIPT_PATH/mini_functions.sh"

xbps-query gnome-keyring &>/dev/null || sudo xbps-install -y gnome-keyring

info "Installing /usr/local/bin/start-sway"
sudo tee /usr/local/bin/start-sway >/dev/null <<'EOF'
#!/bin/sh
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM="wayland;xcb"
export _JAVA_AWT_WM_NONREPARENTING=1
export LIBVA_DRIVER_NAME=iHD
[ -z "$XDG_RUNTIME_DIR" ] && export XDG_RUNTIME_DIR="/tmp/$(id -u)-runtime" && mkdir -p "$XDG_RUNTIME_DIR" && chmod 700 "$XDG_RUNTIME_DIR"
exec dbus-run-session sway
EOF
sudo chmod +x /usr/local/bin/start-sway

info "Writing /etc/greetd/config.toml"
sudo mkdir -p /etc/greetd
sudo tee /etc/greetd/config.toml >/dev/null <<'EOF'
[terminal]
vt = 2

[default_session]
command = "tuigreet --remember --remember-session --asterisks --time --greeting 'grimoire // void' --cmd start-sway --theme 'border=yellow;text=white;prompt=yellow;time=yellow;action=white;button=yellow;container=black;input=white'"
user = "greeter"
EOF

if [[ -f /etc/pam.d/greetd ]]; then
 info "Hardening /etc/pam.d/greetd (elogind session + keyring) ..."
 grep -q pam_elogind /etc/pam.d/greetd || \
 echo 'session    optional  pam_elogind.so' | sudo tee -a /etc/pam.d/greetd >/dev/null
 if find /usr/lib* -name 'pam_gnome_keyring.so' &>/dev/null && ! grep -q pam_gnome_keyring /etc/pam.d/greetd; then
 sudo tee -a /etc/pam.d/greetd >/dev/null <<'EOF'
auth       optional  pam_gnome_keyring.so
session    optional  pam_gnome_keyring.so auto_start
EOF
 fi
else
 warning "/etc/pam.d/greetd not found; skipping PAM hardening."
fi

success "greetd + tuigreet configured (elogind session + keyring auto-unlock)."
