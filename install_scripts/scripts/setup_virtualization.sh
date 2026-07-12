#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"; source "$DIR/mini_functions.sh"
mapfile -t virt_packages < "$DIR/../package_lists/virt_pkg_list.txt"
for pkg in "${virt_packages[@]}"; do
 [[ -z "$pkg" || "$pkg" == \#* ]] && continue
 xbps-query "$pkg" &>/dev/null && { info "$pkg already installed"; continue; }
 sudo xbps-install -y "$pkg" || warning "Skipping $pkg"
done
for service in dbus libvirtd virtlogd virtlockd; do
 [[ -d "/etc/sv/$service" && ! -e "/var/service/$service" ]] && sudo ln -s "/etc/sv/$service" /var/service/
done
for grp in libvirt kvm; do getent group "$grp" >/dev/null 2>&1 && sudo usermod -aG "$grp" "$USER"; done
mkdir -p "$HOME/.config/libvirt"; echo 'uri_default = "qemu:///system"' > "$HOME/.config/libvirt/libvirt.conf"
if command -v virsh >/dev/null 2>&1; then
 sudo virsh net-autostart default 2>/dev/null || true
 sudo virsh net-start default 2>/dev/null || true
fi
success "Virtualization ready. Log out/in for groups, then launch virt-manager."
