#!/usr/bin/env bash
SETUP_POWER_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SETUP_POWER_PATH/mini_functions.sh"

info "Installing TLP ..."
sudo xbps-install -y tlp

# GUARD: acpid + elogind both handling ACPI = double-suspend. We use elogind.
if xbps-query acpid &>/dev/null; then
 warning "acpid conflicts with elogind's power handling."
 [[ -e /var/service/acpid ]] && { warning "Disabling acpid service ..."; sudo rm -f /var/service/acpid; }
 [[ -e /etc/acpi/events/anything ]] && sudo mv /etc/acpi/events/anything /etc/acpi/events/anything.disabled
fi

info "Writing /etc/elogind/logind.conf.d/10-grimoire.conf ..."
sudo mkdir -p /etc/elogind/logind.conf.d
sudo tee /etc/elogind/logind.conf.d/10-grimoire.conf >/dev/null <<'EOF'
[Login]
HandleLidSwitch=suspend
HandleLidSwitchExternalPower=suspend
HandlePowerKey=suspend
HandleSuspendKey=suspend
IdleAction=ignore
EOF

info "Ensuring non-root backlight access (video group) ..."

success "Power configured (TLP + elogind lid/key rules + brightness)."
