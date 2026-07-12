#!/usr/bin/env bash
set -Eeuo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/mini_functions.sh"
vendor="$(cat /sys/class/drm/card*/device/vendor 2>/dev/null | head -n1 || true)"
[[ "$vendor" == "0x8086" ]] || error "Latitude baseline expects Intel GPU; detected ${vendor:-unknown}"
sudo xbps-install -Sy void-repo-nonfree
sudo xbps-install -Suy
sudo xbps-install -y mesa-dri mesa-vulkan-intel vulkan-loader \
  intel-video-accel libva-utils intel-ucode linux-firmware-intel thermald
series="linux$(uname -r | awk -F. '{print $1 "." $2}')"
if xbps-query -p pkgver "$series" >/dev/null 2>&1; then
  sudo xbps-reconfigure -f "$series"
else
  warning "intel-ucode installed; verify and regenerate the installed kernel initramfs manually"
fi
success "Latitude 5490 Intel profile installed; VA-API driver selection left automatic"
