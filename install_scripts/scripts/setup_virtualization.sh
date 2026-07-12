#!/usr/bin/env bash
set -Eeuo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/mini_functions.sh"
grep -Eq '(vmx|svm)' /proc/cpuinfo || error "Enable Intel VT-x in BIOS before configuring KVM"
mapfile -t packages < <(grep -Ev '^[[:space:]]*(#|$)' "$DIR/../package_lists/virt_pkg_list.txt")
sudo xbps-install -y "${packages[@]}"
for service in dbus libvirtd virtlogd virtlockd; do
  [[ -d "/etc/sv/$service" ]] || error "Missing service: $service"
  sudo ln -sfn "/etc/sv/$service" "/var/service/$service"
  sudo sv up "$service"
done
for group in libvirt kvm; do getent group "$group" >/dev/null && sudo usermod -aG "$group" "$USER"; done
mkdir -p "$HOME/.config/libvirt"
printf 'uri_default = "qemu:///system"\n' > "$HOME/.config/libvirt/libvirt.conf"
for _ in {1..20}; do sudo virsh -c qemu:///system list >/dev/null 2>&1 && break; sleep 1; done
sudo virsh -c qemu:///system list >/dev/null || { sudo sv status libvirtd virtlogd virtlockd; error "libvirt did not become ready"; }
sudo virsh -c qemu:///system net-autostart default
sudo virsh -c qemu:///system net-start default 2>/dev/null || true
success "Virtualization ready; log out/in for groups"
